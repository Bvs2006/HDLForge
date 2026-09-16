import {
  supabaseFetchProblems,
  supabaseFetchProblemBySlug,
  supabaseFetchLeaderboard,
  supabaseFetchMyRank,
  supabaseFetchAllAchievements,
  supabaseFetchMyAchievements,
  supabaseFetchDiscussions,
  supabaseFetchProblemSubmissions,
} from "./supabase/queries";
import { createClient } from "./supabase/client";

async function getAuthHeader(): Promise<Record<string, string>> {
  try {
    const supabase = createClient();
    const { data: { session } } = await supabase.auth.getSession();
    if (session?.access_token) {
      return { Authorization: `Bearer ${session.access_token}` };
    }
  } catch {
    // Ignore error
  }
  return {};
}

import {
  Problem,
  ProblemListResponse,
  SubmissionResult,
  SubmissionRequest,
  WaveformData,
  LeaderboardResponse,
  UserRankResponse,
  UserAchievementsResponse,
  Achievement,
  AchievementInfo,
  AIChatRequest,
  AIChatResponse,
  AIConversationSummary,
  AIConversationDetail,
  AIFeedbackRequest,
} from "./types";

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000";

async function apiFetch<T>(path: string, options?: RequestInit): Promise<T> {
  const authHeader = await getAuthHeader();
  const url = `${API_BASE}${path}`;
  const res = await fetch(url, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...authHeader,
      ...options?.headers,
    },
  });

  if (!res.ok) {
    const body = await res.json().catch(() => ({}));
    const message =
      (body as { detail?: string }).detail ||
      `Request failed with status ${res.status}`;
    throw new ApiError(res.status, message);
  }

  return res.json();
}

export class ApiError extends Error {
  status: number;
  constructor(status: number, message: string) {
    super(message);
    this.name = "ApiError";
    this.status = status;
  }
}

interface ApiProblem {
  id: number;
  slug: string;
  title: string;
  description: string;
  difficulty: "EASY" | "MEDIUM" | "HARD";
  category: string;
  language: "VERILOG" | "SYSTEMVERILOG";
  input_description: string;
  output_description: string;
  constraints: string;
  starter_code: string;
  time_complexity: string;
  space_complexity: string;
  reference_solution: string;
  created_at: string;
  updated_at: string;
  public_test_cases: Array<{
    name: string;
    description: string;
    input: string;
    expected: string;
  }>;
  public_testbenches: Array<{
    name: string;
    testbench: string;
    language: string;
  }>;
}

interface ApiProblemListResponse {
  problems: ApiProblem[];
  total: number;
}

interface ApiTestResult {
  name: string;
  passed: boolean;
  expected: string;
  received: string;
  message: string;
}

interface ApiSubmissionResponse {
  status: string;
  message: string;
  compilation_message: string | null;
  tests: ApiTestResult[];
  score: number;
  tests_passed: number;
  tests_total: number;
  execution_time: number;
  submission_id: number;
  waveform_id: string | null;
  xp_earned: number;
  xp_total: number;
  level: number;
  progress_status: string | null;
  achievements_unlocked: ApiAchievementInfo[];
  submitted_by: string | null;
  submitted_by_display: string | null;
}

interface ApiAchievementInfo {
  slug: string;
  name: string;
  description: string;
  icon: string;
  xp_reward: number;
}

function mapDifficulty(d: "EASY" | "MEDIUM" | "HARD"): "easy" | "medium" | "hard" {
  return d.toLowerCase() as "easy" | "medium" | "hard";
}

function mapLanguage(
  l: "VERILOG" | "SYSTEMVERILOG"
): "verilog" | "systemverilog" {
  return l.toLowerCase() as "verilog" | "systemverilog";
}

function transformProblem(p: ApiProblem): Problem {
  return {
    id: String(p.id),
    slug: p.slug,
    title: p.title,
    difficulty: mapDifficulty(p.difficulty),
    category: p.category,
    language: mapLanguage(p.language),
    description: p.description,
    inputDescription: p.input_description,
    outputDescription: p.output_description,
    constraints: p.constraints ? p.constraints.split("\n").filter(Boolean) : [],
    examples: [],
    starterCode: p.starter_code,
    timeComplexity: p.time_complexity || undefined,
    spaceComplexity: p.space_complexity || undefined,
    referenceSolution: p.reference_solution || undefined,
    publicTestCases: p.public_test_cases || [],
    publicTestbenches: p.public_testbenches || [],
  };
}

export async function fetchProblems(params?: {
  difficulty?: string;
  category?: string;
  search?: string;
}): Promise<ProblemListResponse> {
  const supabaseRes = await supabaseFetchProblems(params);
  if (supabaseRes) return supabaseRes;
  const searchParams = new URLSearchParams();
  if (params?.difficulty && params.difficulty !== "all") {
    searchParams.set("difficulty", params.difficulty.toUpperCase());
  }
  if (params?.category && params.category !== "all") {
    searchParams.set("category", params.category);
  }
  if (params?.search) {
    searchParams.set("search", params.search);
  }

  const qs = searchParams.toString();
  const path = `/api/problems${qs ? `?${qs}` : ""}`;

  const data = await apiFetch<ApiProblemListResponse>(path);
  return {
    problems: data.problems.map(transformProblem),
    total: data.total,
  };
}

export async function fetchProblemBySlug(slug: string): Promise<Problem> {
  const supabaseProblem = await supabaseFetchProblemBySlug(slug);
  if (supabaseProblem) return supabaseProblem;
  const data = await apiFetch<ApiProblem>(`/api/problems/${slug}`);
  return transformProblem(data);
}

export async function runCode(
  request: SubmissionRequest
): Promise<SubmissionResult> {
  const apiRequest = {
    problem_slug: request.problemSlug,
    language: request.language.toUpperCase(),
    code: request.code,
    ...(request.testbenchCode ? { testbench_code: request.testbenchCode } : {}),
  };

  const data = await apiFetch<ApiSubmissionResponse>(
    "/api/submissions/run",
    {
      method: "POST",
      body: JSON.stringify(apiRequest),
    }
  );

  return transformSubmissionResponse(data);
}

export async function submitCode(
  request: SubmissionRequest
): Promise<SubmissionResult> {
  const apiRequest = {
    problem_slug: request.problemSlug,
    language: request.language.toUpperCase(),
    code: request.code,
    ...(request.testbenchCode ? { testbench_code: request.testbenchCode } : {}),
  };

  const data = await apiFetch<ApiSubmissionResponse>(
    "/api/submissions/submit",
    {
      method: "POST",
      body: JSON.stringify(apiRequest),
    }
  );

  return transformSubmissionResponse(data);
}

function transformSubmissionResponse(data: ApiSubmissionResponse): SubmissionResult {
  const status = data.status as SubmissionResult["status"];
  return {
    status,
    compilationMessage: data.compilation_message ?? undefined,
    tests: data.tests.map((t) => ({
      name: t.name,
      passed: t.passed,
      expected: t.expected || undefined,
      received: t.received || undefined,
      message: t.message || undefined,
    })),
    score: data.score,
    testsPassed: data.tests_passed,
    testsTotal: data.tests_total,
    executionTime: data.execution_time,
    waveformId: data.waveform_id ?? undefined,
    xpEarned: data.xp_earned,
    xpTotal: data.xp_total,
    level: data.level,
    progressStatus: data.progress_status,
    achievementsUnlocked: data.achievements_unlocked.map((a) => ({
      slug: a.slug,
      name: a.name,
      description: a.description,
      icon: a.icon,
      xpReward: a.xp_reward,
    })),
    submittedBy: data.submitted_by ?? undefined,
    submittedByDisplay: data.submitted_by_display ?? undefined,
  };
}

interface ApiWaveformSignalChange {
  time: number;
  value: string;
}

interface ApiWaveformSignal {
  name: string;
  width: number;
  changes: ApiWaveformSignalChange[];
}

interface ApiWaveformResponse {
  waveform_id: string;
  format: string;
  duration: number;
  timescale: string;
  file_size: number;
  signal_count: number;
  signals: ApiWaveformSignal[];
}

function transformWaveformData(data: ApiWaveformResponse): WaveformData {
  return {
    waveformId: data.waveform_id,
    format: data.format,
    duration: data.duration,
    timescale: data.timescale,
    fileSize: data.file_size,
    signalCount: data.signal_count,
    signals: data.signals.map((s) => ({
      name: s.name,
      width: s.width,
      changes: s.changes.map((c) => ({
        time: c.time,
        value: c.value,
      })),
    })),
  };
}

export async function fetchWaveform(waveformId: string): Promise<WaveformData> {
  const data = await apiFetch<ApiWaveformResponse>(
    `/api/waveforms/${waveformId}`
  );
  return transformWaveformData(data);
}

export async function fetchLeaderboard(params?: {
  page?: number;
  limit?: number;
  search?: string;
}): Promise<LeaderboardResponse> {
  const supabaseLeaderboard = await supabaseFetchLeaderboard(params);
  if (supabaseLeaderboard) return supabaseLeaderboard;
  const searchParams = new URLSearchParams();
  if (params?.page) searchParams.set("page", String(params.page));
  if (params?.limit) searchParams.set("limit", String(params.limit));
  if (params?.search) searchParams.set("search", params.search);

  const qs = searchParams.toString();
  const data = await apiFetch<{
    entries: Array<{
      rank: number;
      user_id: number;
      username: string;
      display_name: string | null;
      xp: number;
      level: number;
      solved_count: number;
      progress: number;
      streak: number;
      achievements: number;
    }>;
    total_users: number;
    page: number;
    limit: number;
    total_pages: number;
  }>(`/api/leaderboard${qs ? `?${qs}` : ""}`);

  return {
    entries: data.entries.map((e) => ({
      rank: e.rank,
      userId: e.user_id,
      username: e.username,
      displayName: e.display_name,
      xp: e.xp,
      level: e.level,
      solvedCount: e.solved_count,
      progress: e.progress,
      streak: e.streak,
      achievements: e.achievements,
    })),
    totalUsers: data.total_users,
    page: data.page,
    limit: data.limit,
    totalPages: data.total_pages,
  };
}

export async function fetchMyRank(): Promise<UserRankResponse> {
  const supabaseRank = await supabaseFetchMyRank();
  if (supabaseRank) return supabaseRank;
  const data = await apiFetch<{
    rank: number;
    xp: number;
    level: number;
    solved_count: number;
    progress: number;
    streak: number;
    achievements: number;
  }>("/api/leaderboard/me");

  return {
    rank: data.rank,
    xp: data.xp,
    level: data.level,
    solvedCount: data.solved_count,
    progress: data.progress,
    streak: data.streak,
    achievements: data.achievements,
  };
}

export async function fetchAllAchievements(): Promise<
  Achievement[]
> {
  const supabaseAch = await supabaseFetchAllAchievements();
  if (supabaseAch) return supabaseAch;
  const data = await apiFetch<{
    achievements: Array<{
      slug: string;
      name: string;
      description: string;
      icon: string;
      xp_reward: number;
      unlocked: boolean;
      unlocked_at: string | null;
      progress_current: number;
      progress_target: number;
    }>;
  }>("/api/achievements");

  return data.achievements.map((a) => ({
    slug: a.slug,
    name: a.name,
    description: a.description,
    icon: a.icon,
    xpReward: a.xp_reward,
    unlocked: a.unlocked,
    unlockedAt: a.unlocked_at,
    progressCurrent: a.progress_current,
    progressTarget: a.progress_target,
  }));
}

export async function fetchMyAchievements(): Promise<UserAchievementsResponse> {
  const supabaseMyAch = await supabaseFetchMyAchievements();
  if (supabaseMyAch) return supabaseMyAch;
  const data = await apiFetch<{
    achievements: Array<{
      slug: string;
      name: string;
      description: string;
      icon: string;
      xp_reward: number;
      unlocked: boolean;
      unlocked_at: string | null;
      progress_current: number;
      progress_target: number;
    }>;
    total_unlocked: number;
    total_available: number;
  }>("/api/achievements/me");

  return {
    achievements: data.achievements.map((a) => ({
      slug: a.slug,
      name: a.name,
      description: a.description,
      icon: a.icon,
      xpReward: a.xp_reward,
      unlocked: a.unlocked,
      unlockedAt: a.unlocked_at,
      progressCurrent: a.progress_current,
      progressTarget: a.progress_target,
    })),
    totalUnlocked: data.total_unlocked,
    totalAvailable: data.total_available,
  };
}

export async function fetchLearningPaths() {
  const data = await apiFetch<{
    paths: Array<{
      id: number;
      slug: string;
      title: string;
      description: string;
      difficulty: string;
      estimated_hours: number;
      module_count: number;
    }>;
  }>("/api/learning/paths");

  return {
    paths: data.paths.map((p) => ({
      id: p.id,
      slug: p.slug,
      title: p.title,
      description: p.description,
      difficulty: p.difficulty,
      estimatedHours: p.estimated_hours,
      moduleCount: p.module_count,
    })),
  };
}

export async function fetchLearningPath(slug: string) {
  const data = await apiFetch<{
    id: number;
    slug: string;
    title: string;
    description: string;
    difficulty: string;
    estimated_hours: number;
    modules: Array<{
      id: number;
      slug: string;
      title: string;
      description: string;
      order_index: number;
      lessons: Array<{
        id: number;
        slug: string;
        title: string;
        description: string;
        difficulty: string;
        estimated_minutes: number;
        order_index: number;
        has_quiz: boolean;
      }>;
    }>;
  }>(`/api/learning/paths/${slug}`);

  return {
    id: data.id,
    slug: data.slug,
    title: data.title,
    description: data.description,
    difficulty: data.difficulty,
    estimatedHours: data.estimated_hours,
    modules: data.modules.map((m) => ({
      id: m.id,
      slug: m.slug,
      title: m.title,
      description: m.description,
      orderIndex: m.order_index,
      lessons: m.lessons.map((l) => ({
        id: l.id,
        slug: l.slug,
        title: l.title,
        description: l.description,
        difficulty: l.difficulty,
        estimatedMinutes: l.estimated_minutes,
        orderIndex: l.order_index,
        hasQuiz: l.has_quiz,
      })),
    })),
  };
}

export async function fetchLesson(slug: string) {
  const data = await apiFetch<{
    id: number;
    slug: string;
    title: string;
    description: string;
    content: string;
    difficulty: string;
    estimated_minutes: number;
    order_index: number;
    status: string;
    prerequisites_met: boolean;
    prerequisites: Array<{ slug: string; title: string }>;
    has_quiz: boolean;
    related_problems: Array<{ slug: string; title: string; difficulty: string; category: string }>;
    prev_lesson: { slug: string; title: string } | null;
    next_lesson: { slug: string; title: string } | null;
    module: { slug: string; title: string } | null;
    path: { slug: string; title: string } | null;
  }>(`/api/learning/lessons/${slug}`);

  return {
    id: data.id,
    slug: data.slug,
    title: data.title,
    description: data.description,
    content: data.content,
    difficulty: data.difficulty,
    estimatedMinutes: data.estimated_minutes,
    orderIndex: data.order_index,
    status: data.status,
    prerequisitesMet: data.prerequisites_met,
    prerequisites: data.prerequisites,
    hasQuiz: data.has_quiz,
    relatedProblems: data.related_problems,
    prevLesson: data.prev_lesson,
    nextLesson: data.next_lesson,
    module: data.module,
    path: data.path,
  };
}

export async function startLesson(slug: string) {
  return apiFetch<{ status: string }>(`/api/learning/lessons/${slug}/start`, {
    method: "POST",
    credentials: "include",
  });
}

export async function completeLesson(slug: string) {
  return apiFetch<{ xp_earned: number }>(`/api/learning/lessons/${slug}/complete`, {
    method: "POST",
    credentials: "include",
  });
}

export async function fetchQuiz(lessonSlug: string) {
  const data = await apiFetch<{
    id: number;
    title: string;
    questions: Array<{
      id: number;
      question: string;
      question_type: string;
      options: string;
      order_index: number;
    }>;
  }>(`/api/learning/quizzes/${lessonSlug}`);

  return {
    id: data.id,
    title: data.title,
    questions: data.questions.map((q) => ({
      id: q.id,
      question: q.question,
      questionType: q.question_type,
      options: q.options,
      orderIndex: q.order_index,
    })),
  };
}

export async function submitQuiz(quizId: number, answers: string[]) {
  return apiFetch<{
    score: number;
    passed: boolean;
    results: Array<{
      question: string;
      correct: boolean;
      correct_answer: string;
      explanation: string;
    }>;
    xp_earned: number;
  }>(`/api/learning/quizzes/${quizId}/attempt`, {
    method: "POST",
    credentials: "include",
    body: JSON.stringify({ answers }),
  });
}

export async function fetchLearningProgress() {
  const data = await apiFetch<{
    paths: Array<{
      id: number;
      slug: string;
      title: string;
      description: string;
      difficulty: string;
      estimated_hours: number;
      modules: Array<{
        id: number;
        slug: string;
        title: string;
        description: string;
        order_index: number;
        lessons: Array<{
          id: number;
          slug: string;
          title: string;
          description: string;
          difficulty: string;
          estimated_minutes: number;
          order_index: number;
          status: string;
          prerequisites_met: boolean;
        }>;
        completed_lessons: number;
        total_lessons: number;
      }>;
      completed_lessons: number;
      total_lessons: number;
      progress_percent: number;
    }>;
    total_lessons: number;
    completed_lessons: number;
    progress_percent: number;
  }>("/api/learning/progress", { credentials: "include" });

  return {
    paths: data.paths.map((p) => ({
      id: p.id,
      slug: p.slug,
      title: p.title,
      description: p.description,
      difficulty: p.difficulty,
      estimatedHours: p.estimated_hours,
      modules: p.modules.map((m) => ({
        id: m.id,
        slug: m.slug,
        title: m.title,
        description: m.description,
        orderIndex: m.order_index,
        lessons: m.lessons.map((l) => ({
          id: l.id,
          slug: l.slug,
          title: l.title,
          description: l.description,
          difficulty: l.difficulty,
          estimatedMinutes: l.estimated_minutes,
          orderIndex: l.order_index,
          status: l.status,
          prerequisitesMet: l.prerequisites_met,
        })),
        completedLessons: m.completed_lessons,
        totalLessons: m.total_lessons,
      })),
      completedLessons: p.completed_lessons,
      totalLessons: p.total_lessons,
      progressPercent: p.progress_percent,
    })),
    totalLessons: data.total_lessons,
    completedLessons: data.completed_lessons,
    progressPercent: data.progress_percent,
  };
}

export async function fetchConceptMastery() {
  const data = await apiFetch<{
    concepts: Array<{
      slug: string;
      name: string;
      category: string;
      mastery_score: number;
      level: string;
      solved_count: number;
      failed_count: number;
    }>;
  }>("/api/learning/concepts/mastery", { credentials: "include" });

  return {
    concepts: data.concepts.map((c) => ({
      slug: c.slug,
      name: c.name,
      category: c.category,
      masteryScore: c.mastery_score,
      level: c.level,
      solvedCount: c.solved_count,
      failedCount: c.failed_count,
    })),
  };
}

export async function fetchLearningRecommendations() {
  const data = await apiFetch<{
    next_lesson: {
      slug: string;
      title: string;
      module_slug: string;
      module_title: string;
      path_slug: string;
      path_title: string;
    } | null;
    practice_problem: {
      slug: string;
      title: string;
      difficulty: string;
    } | null;
    weak_concept: {
      slug: string;
      name: string;
      mastery_score: number;
    } | null;
    reason: string;
  }>("/api/learning/recommendations", { credentials: "include" });

  return {
    nextLesson: data.next_lesson ? {
      slug: data.next_lesson.slug,
      title: data.next_lesson.title,
      moduleSlug: data.next_lesson.module_slug,
      moduleTitle: data.next_lesson.module_title,
      pathSlug: data.next_lesson.path_slug,
      pathTitle: data.next_lesson.path_title,
    } : null,
    practiceProblem: data.practice_problem ? {
      slug: data.practice_problem.slug,
      title: data.practice_problem.title,
      difficulty: data.practice_problem.difficulty,
    } : null,
    weakConcept: data.weak_concept ? {
      slug: data.weak_concept.slug,
      name: data.weak_concept.name,
      masteryScore: data.weak_concept.mastery_score,
    } : null,
    reason: data.reason,
  };
}

export async function sendAIChat(request: AIChatRequest): Promise<AIChatResponse> {
  const apiRequest = {
    task: request.task,
    problem_slug: request.problemSlug,
    submission_id: request.submissionId,
    code: request.code,
    compiler_error: request.compilerError,
    waveform_id: request.waveformId,
    lesson_slug: request.lessonSlug,
    user_question: request.userQuestion,
    hint_level: request.hintLevel || 1,
    concept_tags: request.conceptTags || [],
  };

  const data = await apiFetch<{
    response: string;
    model: string;
    tokens_used: number;
    conversation_id: number | null;
  }>("/api/ai/chat", {
    method: "POST",
    credentials: "include",
    body: JSON.stringify(apiRequest),
  });

  return {
    response: data.response,
    model: data.model,
    tokensUsed: data.tokens_used,
    conversationId: data.conversation_id,
  };
}

export async function sendAIFeedback(request: AIFeedbackRequest) {
  return apiFetch<{ status: string }>("/api/ai/feedback", {
    method: "POST",
    credentials: "include",
    body: JSON.stringify({
      message_id: request.messageId,
      rating: request.rating,
      comment: request.comment || "",
      task_type: request.taskType || "",
    }),
  });
}

export async function fetchAIConversations() {
  const data = await apiFetch<{
    conversations: Array<{
      id: number;
      task_type: string;
      problem_id: number | null;
      lesson_id: number | null;
      created_at: string;
    }>;
  }>("/api/ai/conversations", { credentials: "include" });

  return {
    conversations: data.conversations.map((c) => ({
      id: c.id,
      taskType: c.task_type,
      problemId: c.problem_id,
      lessonId: c.lesson_id,
      createdAt: c.created_at,
    })),
  };
}

export async function fetchAIConversation(conversationId: number) {
  const data = await apiFetch<{
    id: number;
    task_type: string;
    messages: Array<{
      id: number;
      role: string;
      content: string;
      created_at: string;
    }>;
  }>(`/api/ai/conversations/${conversationId}`, { credentials: "include" });

  return {
    id: data.id,
    taskType: data.task_type,
    messages: data.messages.map((m) => ({
      id: m.id,
      role: m.role,
      content: m.content,
      createdAt: m.created_at,
    })),
  };
}

export async function fetchProblemSubmissions(slug: string): Promise<
  import("./types").ProblemSubmission[]
> {
  const supabaseSubs = await supabaseFetchProblemSubmissions(slug);
  if (supabaseSubs) return supabaseSubs;
  const data = await apiFetch<{
    submissions: Array<{
      id: number;
      score: number;
      status: string;
      tests_passed: number;
      tests_total: number;
      execution_time: number;
      language: string;
      code: string;
      created_at: string;
    }>;
  }>(`/api/submissions/problem/${slug}`, { credentials: "include" });

  return data.submissions.map((s) => ({
    id: s.id,
    score: s.score,
    status: s.status,
    testsPassed: s.tests_passed,
    testsTotal: s.tests_total,
    executionTime: s.execution_time,
    language: s.language,
    code: s.code,
    createdAt: s.created_at,
  }));
}

export async function fetchDiscussions(slug: string): Promise<
  import("./types").Discussion[]
> {
  const supabaseDisc = await supabaseFetchDiscussions(slug);
  if (supabaseDisc) return supabaseDisc;
  const data = await apiFetch<{
    discussions: Array<{
      id: number;
      content: string;
      username: string;
      display_name: string | null;
      upvotes: number;
      is_solution: boolean;
      reply_count: number;
      replies: Array<{
        id: number;
        content: string;
        username: string;
        display_name: string | null;
        upvotes: number;
        is_solution: boolean;
        created_at: string;
      }>;
      created_at: string;
    }>;
  }>(`/api/submissions/discussions/${slug}`);

  return data.discussions.map((d) => ({
    id: d.id,
    content: d.content,
    username: d.username,
    displayName: d.display_name,
    upvotes: d.upvotes,
    isSolution: d.is_solution,
    replyCount: d.reply_count,
    replies: d.replies.map((r) => ({
      id: r.id,
      content: r.content,
      username: r.username,
      displayName: r.display_name,
      upvotes: r.upvotes,
      isSolution: r.is_solution,
      createdAt: r.created_at,
    })),
    createdAt: d.created_at,
  }));
}

export async function createDiscussion(
  slug: string,
  content: string,
  parentId?: number
): Promise<{ id: number; content: string }> {
  return apiFetch(`/api/submissions/discussions/${slug}`, {
    method: "POST",
    credentials: "include",
    body: JSON.stringify({ content, parent_id: parentId || null }),
  });
}

export async function voteDiscussion(
  discussionId: number,
  vote: number
): Promise<{ upvotes: number }> {
  return apiFetch(`/api/submissions/discussions/${discussionId}/vote`, {
    method: "POST",
    credentials: "include",
    body: JSON.stringify({ vote }),
  });
}
