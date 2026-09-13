from fastapi import APIRouter, Cookie, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.db.database import get_db
from app.db.models import Discussion, DiscussionVote, Problem, Submission, SubmissionTestResult, User
from app.schemas.submission import SubmissionRequest, SubmissionResponse, TestResult
from app.services import submission_service
from app.services.auth_service import decode_access_token, get_user_by_id

router = APIRouter(prefix="/submissions", tags=["submissions"])


def get_optional_user(
    access_token: str | None = Cookie(None, alias="access_token"),
    db: Session = Depends(get_db),
) -> User | None:
    if not access_token:
        return None
    user_id = decode_access_token(access_token)
    if not user_id:
        return None
    return get_user_by_id(db, user_id)


@router.post("/run", response_model=SubmissionResponse)
def run_submission(
    request: SubmissionRequest,
    db: Session = Depends(get_db),
    user: User | None = Depends(get_optional_user),
) -> SubmissionResponse:
    return submission_service.run_submission(db, request, user_id=user.id if user else None)


@router.post("/submit", response_model=SubmissionResponse)
def submit_solution(
    request: SubmissionRequest,
    db: Session = Depends(get_db),
    user: User | None = Depends(get_optional_user),
) -> SubmissionResponse:
    return submission_service.submit_solution(db, request, user_id=user.id if user else None)


@router.get("/{submission_id}", response_model=SubmissionResponse)
def get_submission(submission_id: int, db: Session = Depends(get_db)):
    submission = db.query(Submission).filter(Submission.id == submission_id).first()
    if not submission:
        raise HTTPException(status_code=404, detail=f"Submission '{submission_id}' not found")

    test_results = (
        db.query(SubmissionTestResult)
        .filter(SubmissionTestResult.submission_id == submission_id)
        .all()
    )

    tests = [
        TestResult(
            name=tr.test_name,
            passed=tr.status == "PASSED",
            expected=tr.expected,
            received=tr.actual,
            message=tr.message,
        )
        for tr in test_results
    ]

    return SubmissionResponse(
        status=submission.status.value,
        message=f"{submission.tests_passed}/{submission.tests_total} tests passed.",
        compilation_message=submission.compilation_message or None,
        tests=tests,
        score=int(submission.score),
        tests_passed=submission.tests_passed,
        tests_total=submission.tests_total,
        execution_time=submission.execution_time,
        submission_id=submission.id,
    )


@router.get("/problem/{problem_slug}")
def get_problem_submissions(
    problem_slug: str,
    db: Session = Depends(get_db),
    user: User | None = Depends(get_optional_user),
):
    problem = db.query(Problem).filter(Problem.slug == problem_slug).first()
    if not problem:
        raise HTTPException(status_code=404, detail=f"Problem '{problem_slug}' not found")

    if not user:
        return {"submissions": []}

    submissions = (
        db.query(Submission)
        .filter(Submission.problem_id == problem.id, Submission.user_id == user.id)
        .order_by(Submission.created_at.desc())
        .limit(50)
        .all()
    )

    result = []
    for sub in submissions:
        result.append({
            "id": sub.id,
            "score": sub.score,
            "status": sub.status.value,
            "tests_passed": sub.tests_passed,
            "tests_total": sub.tests_total,
            "execution_time": sub.execution_time,
            "language": sub.language.value.lower(),
            "code": sub.code,
            "created_at": sub.created_at.isoformat() if sub.created_at else "",
        })

    return {"submissions": result}


class DiscussionCreate(BaseModel):
    content: str
    parent_id: int | None = None


class DiscussionVoteRequest(BaseModel):
    vote: int = 1


@router.get("/discussions/{problem_slug}")
def get_discussions(problem_slug: str, db: Session = Depends(get_db)):
    problem = db.query(Problem).filter(Problem.slug == problem_slug).first()
    if not problem:
        raise HTTPException(status_code=404, detail=f"Problem '{problem_slug}' not found")

    discussions = (
        db.query(Discussion)
        .filter(Discussion.problem_id == problem.id, Discussion.parent_id.is_(None))
        .order_by(Discussion.upvotes.desc(), Discussion.created_at.desc())
        .all()
    )

    result = []
    for d in discussions:
        user = db.query(User).filter(User.id == d.user_id).first()
        replies = (
            db.query(Discussion)
            .filter(Discussion.parent_id == d.id)
            .order_by(Discussion.created_at.asc())
            .all()
        )
        reply_list = []
        for r in replies:
            r_user = db.query(User).filter(User.id == r.user_id).first()
            reply_list.append({
                "id": r.id,
                "content": r.content,
                "username": r_user.username if r_user else "deleted",
                "display_name": r_user.display_name if r_user else None,
                "upvotes": r.upvotes,
                "is_solution": r.is_solution,
                "created_at": r.created_at.isoformat() if r.created_at else "",
            })
        result.append({
            "id": d.id,
            "content": d.content,
            "username": user.username if user else "deleted",
            "display_name": user.display_name if user else None,
            "upvotes": d.upvotes,
            "is_solution": d.is_solution,
            "reply_count": len(replies),
            "replies": reply_list,
            "created_at": d.created_at.isoformat() if d.created_at else "",
        })

    return {"discussions": result}


@router.post("/discussions/{problem_slug}")
def create_discussion(
    problem_slug: str,
    request: DiscussionCreate,
    db: Session = Depends(get_db),
    user: User | None = Depends(get_optional_user),
):
    if not user:
        raise HTTPException(status_code=401, detail="Authentication required")

    problem = db.query(Problem).filter(Problem.slug == problem_slug).first()
    if not problem:
        raise HTTPException(status_code=404, detail=f"Problem '{problem_slug}' not found")

    discussion = Discussion(
        problem_id=problem.id,
        user_id=user.id,
        parent_id=request.parent_id,
        content=request.content,
    )
    db.add(discussion)
    db.commit()
    db.refresh(discussion)

    return {"id": discussion.id, "content": discussion.content}


@router.post("/discussions/{discussion_id}/vote")
def vote_discussion(
    discussion_id: int,
    request: DiscussionVoteRequest,
    db: Session = Depends(get_db),
    user: User | None = Depends(get_optional_user),
):
    if not user:
        raise HTTPException(status_code=401, detail="Authentication required")

    discussion = db.query(Discussion).filter(Discussion.id == discussion_id).first()
    if not discussion:
        raise HTTPException(status_code=404, detail="Discussion not found")

    existing_vote = (
        db.query(DiscussionVote)
        .filter(DiscussionVote.discussion_id == discussion_id, DiscussionVote.user_id == user.id)
        .first()
    )

    if existing_vote:
        discussion.upvotes -= existing_vote.vote
        existing_vote.vote = request.vote
        discussion.upvotes += request.vote
    else:
        vote = DiscussionVote(
            discussion_id=discussion_id,
            user_id=user.id,
            vote=request.vote,
        )
        db.add(vote)
        discussion.upvotes += request.vote

    db.commit()
    return {"upvotes": discussion.upvotes}
