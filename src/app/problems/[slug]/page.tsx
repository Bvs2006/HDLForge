"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { use } from "react";
import Link from "next/link";
import { fetchProblemBySlug, fetchWaveform, fetchProblemSubmissions, fetchDiscussions, createDiscussion, voteDiscussion } from "@/lib/api";
import { Problem, SubmissionResult, WaveformData, AchievementInfo, ProblemSubmission, Discussion } from "@/lib/types";
import { runCode, submitCode } from "@/lib/api";
import { useAuth } from "@/lib/auth";
import CodeEditor from "@/components/CodeEditor";
import Console from "@/components/Console";
import DifficultyBadge from "@/components/DifficultyBadge";
import CategoryBadge from "@/components/CategoryBadge";
import { WaveformViewer } from "@/components/waveform";
import {
  Play,
  Send,
  FileText,
  Lock,
  ChevronLeft,
  ChevronDown,
  ChevronRight,
  Zap,
  Trophy,
  ArrowLeft,
  BookOpen,
  Clock,
  MemoryStick,
  MessageSquare,
  ThumbsUp,
  CheckCircle2,
  XCircle,
  History,
  Code2,
  Eye,
  EyeOff,
} from "lucide-react";

type LeftTab = "description" | "submissions" | "solution" | "discussion";

export default function ProblemPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = use(params);
  const { user } = useAuth();
  const [problem, setProblem] = useState<Problem | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [code, setCode] = useState("");
  const [testbenchCode, setTestbenchCode] = useState("");
  const [result, setResult] = useState<SubmissionResult | null>(null);
  const [isRunning, setIsRunning] = useState(false);
  const [activeTab, setActiveTab] = useState<LeftTab>("description");

  const [waveformData, setWaveformData] = useState<WaveformData | null>(null);
  const [waveformLoading, setWaveformLoading] = useState(false);
  const [waveformError, setWaveformError] = useState<string | null>(null);
  const [showWaveform, setShowWaveform] = useState(false);
  const waveformLoadedRef = useRef<string | null>(null);

  const [xpNotification, setXpNotification] = useState<{
    xpEarned: number;
    xpTotal: number;
    level: number;
    achievements: AchievementInfo[];
  } | null>(null);
  const notificationTimeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const [submissions, setSubmissions] = useState<ProblemSubmission[]>([]);
  const [submissionsLoading, setSubmissionsLoading] = useState(false);
  const [expandedSubmission, setExpandedSubmission] = useState<number | null>(null);

  const [discussions, setDiscussions] = useState<Discussion[]>([]);
  const [discussionsLoading, setDiscussionsLoading] = useState(false);
  const [newDiscussion, setNewDiscussion] = useState("");
  const [postingDiscussion, setPostingDiscussion] = useState(false);
  const [showSolution, setShowSolution] = useState(false);
  const [expandedTestCase, setExpandedTestCase] = useState<number | null>(null);

  useEffect(() => {
    let cancelled = false;
    async function load() {
      setLoading(true);
      setError(null);
      try {
        const p = await fetchProblemBySlug(slug);
        if (!cancelled) {
          setProblem(p);
          setCode(p.starterCode);
          setTestbenchCode(p.publicTestbenches?.[0]?.testbench || "");
        }
      } catch {
        if (!cancelled) {
          setError("Unable to load problem. Please try again.");
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    }
    load();
    return () => { cancelled = true; };
  }, [slug]);

  const loadWaveform = useCallback(async (waveformId: string) => {
    setWaveformLoading(true);
    setWaveformError(null);
    try {
      const data = await fetchWaveform(waveformId);
      setWaveformData(data);
      setShowWaveform(true);
    } catch (err) {
      setWaveformError(err instanceof Error ? err.message : "Failed to load waveform");
    } finally {
      setWaveformLoading(false);
    }
  }, []);

  useEffect(() => {
    if (
      result?.waveformId &&
      !waveformLoading &&
      !waveformData &&
      waveformLoadedRef.current !== result.waveformId
    ) {
      waveformLoadedRef.current = result.waveformId;
      setWaveformLoading(true);
      setWaveformError(null);
      fetchWaveform(result.waveformId)
        .then((data) => { setWaveformData(data); setShowWaveform(true); })
        .catch((err) => { setWaveformError(err instanceof Error ? err.message : "Failed to load waveform"); })
        .finally(() => { setWaveformLoading(false); });
    }
  }, [result, waveformLoading, waveformData]);

  const loadSubmissions = useCallback(async () => {
    if (!problem) return;
    setSubmissionsLoading(true);
    try {
      const data = await fetchProblemSubmissions(problem.slug);
      setSubmissions(data);
    } catch {
      // Handle error
    } finally {
      setSubmissionsLoading(false);
    }
  }, [problem]);

  const loadDiscussions = useCallback(async () => {
    if (!problem) return;
    setDiscussionsLoading(true);
    try {
      const data = await fetchDiscussions(problem.slug);
      setDiscussions(data);
    } catch {
      // Handle error
    } finally {
      setDiscussionsLoading(false);
    }
  }, [problem]);

  useEffect(() => {
    if (activeTab === "submissions") void loadSubmissions();
    if (activeTab === "discussion") void loadDiscussions();
  }, [activeTab, loadSubmissions, loadDiscussions]);

  const handleRun = async () => {
    if (!problem) return;
    setIsRunning(true);
    setResult(null);
    setWaveformData(null);
    setShowWaveform(false);
    setWaveformError(null);
    setXpNotification(null);
    if (notificationTimeoutRef.current) clearTimeout(notificationTimeoutRef.current);
    try {
      const res = await runCode({ problemSlug: problem.slug, language: problem.language, code, testbenchCode });
      setResult(res);
    } catch {
      setResult({
        status: "error", compilationMessage: "Unable to connect to the HDLForge server.",
        tests: [], score: 0, testsPassed: 0, testsTotal: 0, executionTime: 0,
        xpEarned: 0, xpTotal: 0, level: 1, progressStatus: null, achievementsUnlocked: [],
      });
    } finally {
      setIsRunning(false);
    }
  };

  const handleSubmit = async () => {
    if (!problem) return;
    setIsRunning(true);
    setResult(null);
    setWaveformData(null);
    setShowWaveform(false);
    setWaveformError(null);
    setXpNotification(null);
    if (notificationTimeoutRef.current) clearTimeout(notificationTimeoutRef.current);
    try {
      const res = await submitCode({ problemSlug: problem.slug, language: problem.language, code, testbenchCode });
      setResult(res);
      if (res.xpEarned > 0 || res.achievementsUnlocked.length > 0) {
        setXpNotification({
          xpEarned: res.xpEarned, xpTotal: res.xpTotal, level: res.level,
          achievements: res.achievementsUnlocked,
        });
        notificationTimeoutRef.current = setTimeout(() => setXpNotification(null), 5000);
      }
    } catch {
      setResult({
        status: "error", compilationMessage: "Unable to connect to the HDLForge server.",
        tests: [], score: 0, testsPassed: 0, testsTotal: 0, executionTime: 0,
        xpEarned: 0, xpTotal: 0, level: 1, progressStatus: null, achievementsUnlocked: [],
      });
    } finally {
      setIsRunning(false);
    }
  };

  const handlePostDiscussion = async () => {
    if (!problem || !newDiscussion.trim()) return;
    setPostingDiscussion(true);
    try {
      await createDiscussion(problem.slug, newDiscussion.trim());
      setNewDiscussion("");
      await loadDiscussions();
    } catch {
      // Handle error
    } finally {
      setPostingDiscussion(false);
    }
  };

  const handleVote = async (discussionId: number, vote: number) => {
    try {
      await voteDiscussion(discussionId, vote);
      await loadDiscussions();
    } catch {
      // Handle error
    }
  };

  const isSolved = result?.status === "PASSED" || result?.progressStatus === "SOLVED";

  if (loading) {
    return (
      <div className="flex h-[calc(100vh-3rem)] flex-col items-center justify-center gap-3">
        <div className="h-5 w-5 animate-spin rounded-full border-2 border-accent border-t-transparent" />
        <p className="text-xs text-text-muted">Loading problem...</p>
      </div>
    );
  }

  if (error || !problem) {
    return (
      <div className="flex h-[calc(100vh-3rem)] flex-col items-center justify-center gap-4">
        <h1 className="text-lg font-bold text-text-primary">{error || "Problem not found"}</h1>
        <p className="text-xs text-text-muted">The problem you&apos;re looking for doesn&apos;t exist.</p>
        <Link
          href="/problems"
          className="inline-flex h-8 items-center gap-2 rounded-xl bg-accent px-4 text-xs font-semibold text-[#070707] transition-all hover:bg-accent-hover hover:shadow-[0_0_16px_rgba(0,217,165,0.3)]"
        >
          <ArrowLeft className="h-3.5 w-3.5" />
          Return to Problems
        </Link>
      </div>
    );
  }

  const leftTabs: { key: LeftTab; label: string; icon: typeof FileText }[] = [
    { key: "description", label: "Description", icon: FileText },
        { key: "submissions", label: "Submissions", icon: History },
    { key: "solution", label: "Solution", icon: BookOpen },
    { key: "discussion", label: "Discussion", icon: MessageSquare },
  ];

  return (
    <div className="flex h-[calc(100vh-3rem)] flex-col bg-background/50 relative overflow-hidden">
      {/* Top Tab Bar - Glassmorphism */}
      <div className="glass-panel sticky top-0 z-10 flex items-center justify-between px-4 py-2 border-b border-border/50">
        <div className="flex items-center gap-3">
          <h1 className="text-sm font-bold text-text-primary">{problem.title}</h1>
          {problem.locked && <Lock className="h-3.5 w-3.5 text-text-dim" />}
          <DifficultyBadge difficulty={problem.difficulty} size="sm" />
        </div>
        
        <div className="flex gap-1 overflow-x-auto">
          {leftTabs.map(({ key, label, icon: Icon }) => (
            <button
              key={key}
              onClick={() => setActiveTab(activeTab === key ? "" as any : key)}
              className={`flex items-center gap-1.5 whitespace-nowrap px-3 py-1.5 rounded-lg text-[10px] font-medium transition-all ${
                activeTab === key
                  ? "bg-accent/10 text-accent border border-accent/20 shadow-[0_0_10px_rgba(0,217,165,0.1)]"
                  : "text-text-muted hover:text-text-primary hover:bg-surface/50 glass-button"
              }`}
            >
              <Icon className="h-3 w-3" />
              {label}
            </button>
          ))}
        </div>
        
        <Link href="/problems" className="text-[10px] text-text-muted hover:text-text-secondary glass-button px-2 py-1 rounded">
          All Problems
        </Link>
      </div>

      <div className="flex flex-1 overflow-hidden relative">
        {/* Sliding Side Panel for Tab Content */}
        {activeTab && (
          <div className="glass-panel w-[400px] flex-shrink-0 flex-col border-r border-border/50 z-10 absolute inset-y-0 left-0 shadow-2xl transition-transform duration-300 transform translate-x-0 flex overflow-hidden">
             <div className="flex items-center justify-between p-3 border-b border-border/30">
                <span className="text-xs font-bold text-text-primary">{leftTabs.find(t => t.key === activeTab)?.label}</span>
                <button onClick={() => setActiveTab("" as any)} className="text-text-muted hover:text-text-primary p-1 rounded hover:bg-surface/50">
                   <ChevronLeft className="h-4 w-4" />
                </button>
             </div>
             <div className="flex-1 overflow-y-auto p-5">
{/* Description Tab */}
            {activeTab === "description" && (
              <div className="space-y-5">
                <div>
                  <div className="mb-3 flex items-center gap-2">
                    <h1 className="text-base font-bold text-text-primary">{problem.title}</h1>
                    {problem.locked && <Lock className="h-3.5 w-3.5 text-text-dim" />}
                  </div>
                  <div className="flex gap-1.5 flex-wrap">
                    <DifficultyBadge difficulty={problem.difficulty} size="md" />
                    <CategoryBadge category={problem.category} size="md" />
                  </div>
                </div>

                <div>
                  <p className="text-sm leading-relaxed text-text-secondary">{problem.description}</p>
                </div>

                {/* Complexity */}
                {(problem.timeComplexity || problem.spaceComplexity) && (
                  <div className="flex gap-3">
                    {problem.timeComplexity && (
                      <div className="rounded-lg bg-surface px-3 py-2">
                        <span className="text-[10px] text-text-dim">Time: </span>
                        <span className="font-mono text-xs text-accent">{problem.timeComplexity}</span>
                      </div>
                    )}
                    {problem.spaceComplexity && (
                      <div className="rounded-lg bg-surface px-3 py-2">
                        <span className="text-[10px] text-text-dim">Space: </span>
                        <span className="font-mono text-xs text-accent">{problem.spaceComplexity}</span>
                      </div>
                    )}
                  </div>
                )}

                <div>
                  <h3 className="mb-2 text-[10px] font-bold uppercase tracking-widest text-text-dim">Input</h3>
                  <p className="rounded-lg bg-surface p-3 font-mono text-xs text-text-secondary">{problem.inputDescription}</p>
                </div>

                <div>
                  <h3 className="mb-2 text-[10px] font-bold uppercase tracking-widest text-text-dim">Output</h3>
                  <p className="rounded-lg bg-surface p-3 font-mono text-xs text-text-secondary">{problem.outputDescription}</p>
                </div>

                {problem.constraints.length > 0 && (
                  <div>
                    <h3 className="mb-2 text-[10px] font-bold uppercase tracking-widest text-text-dim">Constraints</h3>
                    <ul className="space-y-1">
                      {problem.constraints.map((c, i) => (
                        <li key={i} className="flex items-start gap-2 text-xs text-text-secondary">
                          <span className="mt-1 h-1 w-1 shrink-0 rounded-full bg-accent/40" />
                          {c}
                        </li>
                      ))}
                    </ul>
                  </div>
                )}

                {problem.examples.length > 0 && (
                  <div>
                    <h3 className="mb-2 text-[10px] font-bold uppercase tracking-widest text-text-dim">Examples</h3>
                    <div className="space-y-2">
                      {problem.examples.map((ex, i) => (
                        <div key={i} className="rounded-xl border border-border bg-surface p-3">
                          <div className="mb-2 text-[10px] font-bold text-text-muted">{ex.title}</div>
                          <div className="space-y-1 font-mono text-[11px]">
                            <div>
                              <span className="text-text-dim">Input: </span>
                              <span className="text-text-secondary">{ex.input}</span>
                            </div>
                            <div>
                              <span className="text-text-dim">Output: </span>
                              <span className="text-accent">{ex.output}</span>
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* Submissions Tab */}
            {activeTab === "submissions" && (
              <div className="space-y-3">
                <h3 className="text-xs font-bold text-text-primary">Your Submissions</h3>
                {submissionsLoading ? (
                  <div className="space-y-2">
                    {Array.from({ length: 3 }).map((_, i) => (
                      <div key={i} className="h-12 animate-pulse rounded-xl bg-surface" />
                    ))}
                  </div>
                ) : submissions.length > 0 ? (
                  submissions.map((sub) => (
                    <div key={sub.id} className="rounded-xl border border-border bg-surface overflow-hidden">
                      <button
                        onClick={() => setExpandedSubmission(expandedSubmission === sub.id ? null : sub.id)}
                        className="flex w-full items-center justify-between px-4 py-3 text-left"
                      >
                        <div className="flex items-center gap-3">
                          {sub.status === "PASSED" ? (
                            <CheckCircle2 className="h-4 w-4 text-accent" />
                          ) : (
                            <XCircle className="h-4 w-4 text-error" />
                          )}
                          <div>
                            <div className="flex items-center gap-2">
                              <span className={`text-xs font-semibold ${
                                sub.status === "PASSED" ? "text-accent" : "text-error"
                              }`}>
                                {sub.score}%
                              </span>
                              <span className="text-[10px] text-text-dim">
                                {sub.testsPassed}/{sub.testsTotal} tests
                              </span>
                            </div>
                            <span className="text-[10px] text-text-dim">
                              {new Date(sub.createdAt).toLocaleString()}
                            </span>
                          </div>
                        </div>
                        <div className="flex items-center gap-2">
                          <span className="text-[10px] text-text-dim">{(sub.executionTime * 1000).toFixed(0)}ms</span>
                          {expandedSubmission === sub.id ? (
                            <ChevronDown className="h-3.5 w-3.5 text-text-dim" />
                          ) : (
                            <ChevronRight className="h-3.5 w-3.5 text-text-dim" />
                          )}
                        </div>
                      </button>
                      {expandedSubmission === sub.id && (
                        <div className="border-t border-border px-4 py-3">
                          <pre className="overflow-x-auto rounded-lg bg-editor p-3 font-mono text-[11px] leading-relaxed text-text-secondary max-h-48 overflow-y-auto">
                            {sub.code}
                          </pre>
                        </div>
                      )}
                    </div>
                  ))
                ) : (
                  <p className="text-xs text-text-dim">No submissions yet.</p>
                )}
              </div>
            )}

            {/* Solution Tab */}
            {activeTab === "solution" && (
              <div className="space-y-4">
                {isSolved || showSolution ? (
                  <div>
                    <div className="flex items-center gap-2 mb-3">
                      <CheckCircle2 className="h-4 w-4 text-accent" />
                      <h3 className="text-xs font-bold text-text-primary">Reference Solution</h3>
                    </div>
                    {problem.referenceSolution ? (
                      <pre className="overflow-x-auto rounded-xl border border-border bg-surface p-4 font-mono text-[11px] leading-relaxed text-text-secondary">
                        {problem.referenceSolution}
                      </pre>
                    ) : (
                      <p className="text-xs text-text-dim">No reference solution available.</p>
                    )}
                  </div>
                ) : (
                  <div className="flex flex-col items-center justify-center py-16 text-center">
                    <Lock className="mb-3 h-8 w-8 text-text-dim" />
                    <p className="text-xs text-text-muted">Solution available after solving.</p>
                    <button
                      onClick={() => setShowSolution(true)}
                      className="mt-3 text-[10px] text-accent hover:underline"
                    >
                      Show anyway
                    </button>
                  </div>
                )}
              </div>
            )}

            {/* Discussion Tab */}
            {activeTab === "discussion" && (
              <div className="space-y-4">
                {user && (
                  <div className="rounded-xl border border-border bg-surface p-3">
                    <textarea
                      value={newDiscussion}
                      onChange={(e) => setNewDiscussion(e.target.value)}
                      placeholder="Share your approach or ask a question..."
                      className="w-full bg-transparent text-xs text-text-primary placeholder-text-dim outline-none resize-none"
                      rows={3}
                    />
                    <div className="flex justify-end mt-2">
                      <button
                        onClick={handlePostDiscussion}
                        disabled={postingDiscussion || !newDiscussion.trim()}
                        className="inline-flex h-7 items-center gap-1.5 rounded-lg bg-accent px-3 text-[10px] font-semibold text-[#070707] transition-all hover:bg-accent-hover disabled:opacity-40"
                      >
                        <Send className="h-3 w-3" />
                        Post
                      </button>
                    </div>
                  </div>
                )}

                {discussionsLoading ? (
                  <div className="space-y-2">
                    {Array.from({ length: 3 }).map((_, i) => (
                      <div key={i} className="h-20 animate-pulse rounded-xl bg-surface" />
                    ))}
                  </div>
                ) : discussions.length > 0 ? (
                  discussions.map((d) => (
                    <div key={d.id} className="rounded-xl border border-border bg-surface p-4">
                      <div className="flex items-start gap-3">
                        <div className="flex flex-col items-center gap-1">
                          <button
                            onClick={() => handleVote(d.id, 1)}
                            className="text-text-dim hover:text-accent transition-colors"
                          >
                            <ThumbsUp className="h-3.5 w-3.5" />
                          </button>
                          <span className="text-[10px] font-semibold text-text-secondary">{d.upvotes}</span>
                        </div>
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2 mb-1">
                            <span className="text-[10px] font-semibold text-text-primary">@{d.username}</span>
                            {d.isSolution && (
                              <span className="rounded-md bg-accent/10 px-1.5 py-0.5 text-[9px] font-semibold text-accent">SOLUTION</span>
                            )}
                            <span className="text-[10px] text-text-dim">{new Date(d.createdAt).toLocaleDateString()}</span>
                          </div>
                          <p className="text-xs text-text-secondary whitespace-pre-wrap">{d.content}</p>
                          {d.replies.length > 0 && (
                            <div className="mt-3 space-y-2 border-l-2 border-border pl-3">
                              {d.replies.map((r) => (
                                <div key={r.id}>
                                  <div className="flex items-center gap-2 mb-1">
                                    <span className="text-[10px] font-semibold text-text-primary">@{r.username}</span>
                                    <span className="text-[10px] text-text-dim">{new Date(r.createdAt).toLocaleDateString()}</span>
                                  </div>
                                  <p className="text-[11px] text-text-secondary whitespace-pre-wrap">{r.content}</p>
                                </div>
                              ))}
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  ))
                ) : (
                  <p className="text-xs text-text-dim text-center py-8">No discussions yet. Be the first to share!</p>
                )}
              </div>
            )}

             </div>
          </div>
        )}

        {/* Right Panel - Side-by-Side Editors */}
        <div className={`flex flex-1 overflow-hidden transition-all duration-300 ${activeTab ? 'ml-[400px]' : 'ml-0'}`}>
          <div className="flex flex-1 flex-col overflow-hidden border-r border-border/50">
            <div className="flex items-center justify-between px-3 py-1.5 border-b border-border/30 bg-surface/30">
               <span className="text-[10px] font-semibold text-text-secondary uppercase tracking-wider">Design (Code)</span>
               <span className="text-[9px] text-text-dim">{problem.language}</span>
            </div>
            <CodeEditor value={code} onChange={setCode} />
          </div>
          <div className="flex flex-1 flex-col overflow-hidden">
            <div className="flex items-center justify-between px-3 py-1.5 border-b border-border/30 bg-surface/30">
               <span className="text-[10px] font-semibold text-text-secondary uppercase tracking-wider">Testbench</span>
               <span className="text-[9px] text-text-dim">SystemVerilog</span>
            </div>
            <CodeEditor value={testbenchCode} onChange={setTestbenchCode} />
          </div>
        </div>
      </div>

{/* Bottom Bar - Actions & Console */}
      <div className="glass-panel flex items-center gap-3 border-t border-border/50 px-4 py-2.5 z-10 perspective-container">
        <button
          onClick={handleRun}
          disabled={isRunning || problem.locked}
          className="btn-3d inline-flex h-8 items-center gap-2 rounded-xl bg-accent px-4 text-xs font-semibold text-[#070707] transition-all hover:bg-accent-hover hover:shadow-[0_0_16px_rgba(0,217,165,0.3)] disabled:cursor-not-allowed disabled:opacity-40"
        >
          <Play className="h-3.5 w-3.5" />
          Run
        </button>
        <button
          onClick={handleSubmit}
          disabled={isRunning || problem.locked}
          className="btn-3d inline-flex h-8 items-center gap-2 rounded-xl border border-border bg-surface px-4 text-xs font-medium text-text-secondary transition-all hover:border-accent/30 hover:bg-accent/5 hover:text-text-primary disabled:cursor-not-allowed disabled:opacity-40"
        >
          <Send className="h-3.5 w-3.5" />
          Submit
        </button>

        {/* Waveform toggle */}
        {result?.waveformId && result.status !== "error" && !showWaveform && (
          <button
            onClick={() => result.waveformId && loadWaveform(result.waveformId)}
            disabled={waveformLoading}
            className="inline-flex h-8 items-center gap-2 rounded-xl border border-border bg-surface px-4 text-xs font-medium text-text-secondary transition-all hover:border-accent/30 hover:bg-accent/5 hover:text-text-primary disabled:opacity-50"
          >
            {waveformLoading ? (
              <div className="h-3 w-3 animate-spin rounded-full border-2 border-accent border-t-transparent" />
            ) : (
              <Zap className="h-3.5 w-3.5" />
            )}
            Waveform
          </button>
        )}

        {/* Score display */}
        {result && result.status !== "error" && (
          <div className="ml-auto flex items-center gap-4">
            {result.executionTime > 0 && (
              <div className="flex items-center gap-1.5 text-[10px] text-text-dim">
                <Clock className="h-3 w-3" />
                <span>{(result.executionTime * 1000).toFixed(0)}ms</span>
              </div>
            )}
            <div className={`text-xs font-bold ${
              result.testsPassed === result.testsTotal ? "text-accent" : "text-text-secondary"
            }`}>
              {result.testsPassed}/{result.testsTotal}
            </div>
          </div>
        )}
      </div>

      {/* Results Panel */}
      <div className="max-h-64 overflow-y-auto border-t border-border bg-panel p-4">
        {xpNotification && (
          <div className="mb-3 rounded-xl border border-accent/20 bg-accent/5 p-3">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-accent/10">
                  <Trophy className="h-4 w-4 text-accent" />
                </div>
                <div>
                  <p className="text-sm font-bold text-accent">+{xpNotification.xpEarned} XP Earned!</p>
                  <p className="text-[11px] text-text-muted">
                    Level {xpNotification.level} · {xpNotification.xpTotal.toLocaleString()} XP total
                  </p>
                </div>
              </div>
              {xpNotification.achievements.length > 0 && (
                <div className="flex items-center gap-2">
                  {xpNotification.achievements.map((ach) => (
                    <div key={ach.slug} className="flex items-center gap-1.5 rounded-lg bg-accent/10 px-2 py-1">
                      <span className="text-sm">{ach.icon}</span>
                      <span className="text-[10px] font-semibold text-accent">{ach.name}</span>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        )}
        <Console result={result} isRunning={isRunning} />
        {waveformError && (
          <div className="mt-2 text-xs text-warning">Waveform: {waveformError}</div>
        )}
      </div>

      {/* Waveform Viewer */}
      {showWaveform && waveformData && (
        <div className="border-t border-border bg-panel p-4">
          <WaveformViewer
            data={waveformData}
            onClose={() => { setShowWaveform(false); setWaveformData(null); }}
          />
        </div>
      )}

    </div>
  );
}
