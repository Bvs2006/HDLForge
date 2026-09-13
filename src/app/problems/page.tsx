"use client";

import { useCallback, useEffect, useState } from "react";
import { fetchProblems } from "@/lib/api";
import { Problem } from "@/lib/types";
import ProblemCard from "@/components/ProblemCard";
import { Search, Code2, Filter } from "lucide-react";

export default function ProblemsPage() {
  const [problems, setProblems] = useState<Problem[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [difficulty, setDifficulty] = useState("all");
  const [category, setCategory] = useState("all");

  const loadProblems = useCallback(async () => {
    setLoading(true);
    try {
      const data = await fetchProblems({
        difficulty: difficulty !== "all" ? difficulty : undefined,
        category: category !== "all" ? category : undefined,
        search: search || undefined,
      });
      setProblems(data.problems);
    } catch {
      // Handle error
    } finally {
      setLoading(false);
    }
  }, [difficulty, category, search]);

  useEffect(() => {
    void loadProblems();
  }, [loadProblems]);

  return (
    <div className="mx-auto max-w-5xl px-4 py-10 sm:px-6 lg:px-8">
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-2">
          <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-accent/10">
            <Code2 className="h-5 w-5 text-accent" />
          </div>
          <h1 className="text-xl font-bold text-text-primary">Problems</h1>
        </div>
        <p className="text-sm text-text-muted">Solve RTL design problems and master hardware engineering.</p>
      </div>

      {/* Filters */}
      <div className="mb-6 flex flex-col gap-3 sm:flex-row sm:items-center">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 h-3.5 w-3.5 -translate-y-1/2 text-text-dim" />
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search problems..."
            className="h-9 w-full rounded-xl border border-border bg-panel pl-9 pr-3 text-xs text-text-primary placeholder-text-dim outline-none transition-all focus:border-accent/40 focus:shadow-[0_0_12px_rgba(0,217,165,0.1)]"
          />
        </div>
        <div className="flex items-center gap-2">
          <Filter className="h-3.5 w-3.5 text-text-dim" />
          <select
            value={difficulty}
            onChange={(e) => setDifficulty(e.target.value)}
            className="h-9 rounded-xl border border-border bg-panel px-3 text-xs text-text-secondary outline-none transition-all focus:border-accent/40"
          >
            <option value="all">All Difficulties</option>
            <option value="easy">Easy</option>
            <option value="medium">Medium</option>
            <option value="hard">Hard</option>
          </select>
          <select
            value={category}
            onChange={(e) => setCategory(e.target.value)}
            className="h-9 rounded-xl border border-border bg-panel px-3 text-xs text-text-secondary outline-none transition-all focus:border-accent/40"
          >
            <option value="all">All Categories</option>
            <option value="combinational">Combinational</option>
            <option value="sequential">Sequential</option>
            <option value="fsm">FSM</option>
            <option value="arithmetic">Arithmetic</option>
            <option value="memory">Memory</option>
            <option value="protocols">Protocols</option>
          </select>
        </div>
      </div>

      {/* Problem List */}
      {loading ? (
        <div className="space-y-3">
          {[1, 2, 3, 4, 5].map((i) => (
            <div key={i} className="h-28 animate-pulse rounded-xl bg-panel" />
          ))}
        </div>
      ) : problems.length === 0 ? (
        <div className="rounded-xl border border-border bg-panel p-12 text-center">
          <Code2 className="mx-auto mb-3 h-8 w-8 text-text-dim" />
          <p className="text-sm text-text-muted">No problems found.</p>
        </div>
      ) : (
        <div className="space-y-2">
          {problems.map((problem) => (
            <ProblemCard key={problem.slug} problem={problem} />
          ))}
        </div>
      )}
    </div>
  );
}
