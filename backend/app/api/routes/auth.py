from fastapi import APIRouter, Cookie, Depends, HTTPException, Response
from sqlalchemy.orm import Session

from app.db.database import get_db
from app.db.models import User
from app.schemas.auth import AuthResponse, LoginRequest, RegisterRequest, UserResponse
from app.services import auth_service

router = APIRouter(prefix="/auth", tags=["auth"])


def get_current_user(
    token: str | None = Cookie(None, alias="access_token"),
    db: Session = Depends(get_db),
) -> User | None:
    if not token:
        return None
    user_id = auth_service.decode_access_token(token)
    if not user_id:
        return None
    return auth_service.get_user_by_id(db, user_id)


def require_user(
    token: str | None = Cookie(None, alias="access_token"),
    db: Session = Depends(get_db),
) -> User:
    if not token:
        raise HTTPException(status_code=401, detail="Not authenticated")
    user_id = auth_service.decode_access_token(token)
    if not user_id:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    user = auth_service.get_user_by_id(db, user_id)
    if not user:
        raise HTTPException(status_code=401, detail="User not found")
    return user


def _user_response(user: User) -> UserResponse:
    return UserResponse(
        id=user.id,
        email=user.email,
        username=user.username,
        display_name=user.display_name,
        avatar_url=user.avatar_url,
        created_at=user.created_at,
        last_login_at=user.last_login_at,
    )


@router.post("/register", response_model=AuthResponse)
def register(request: RegisterRequest, response: Response, db: Session = Depends(get_db)):
    if auth_service.get_user_by_email(db, request.email):
        raise HTTPException(status_code=409, detail="Email already registered")
    if auth_service.get_user_by_username(db, request.username):
        raise HTTPException(status_code=409, detail="Username already taken")

    user = auth_service.create_user(
        db,
        email=request.email,
        username=request.username,
        password=request.password,
        display_name=request.display_name,
    )
    token = auth_service.create_access_token(user.id)
    response.set_cookie(
        key="access_token",
        value=token,
        httponly=True,
        samesite="lax",
        max_age=72 * 3600,
    )
    return AuthResponse(user=_user_response(user), token=token)


@router.post("/login", response_model=AuthResponse)
def login(request: LoginRequest, response: Response, db: Session = Depends(get_db)):
    user = auth_service.authenticate_user(db, request.email, request.password)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid email or password")

    token = auth_service.create_access_token(user.id)
    response.set_cookie(
        key="access_token",
        value=token,
        httponly=True,
        samesite="lax",
        max_age=72 * 3600,
    )
    return AuthResponse(user=_user_response(user), token=token)


@router.post("/logout")
def logout(response: Response):
    response.delete_cookie(key="access_token", httponly=True, samesite="lax")
    return {"detail": "Logged out"}


@router.get("/me", response_model=UserResponse)
def get_me(user: User = Depends(require_user)):
    return _user_response(user)
