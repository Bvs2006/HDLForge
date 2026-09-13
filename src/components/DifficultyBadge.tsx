import { Difficulty } from "@/lib/types";

interface DifficultyBadgeProps {
  difficulty: Difficulty;
  size?: "sm" | "md";
}

const DIFFICULTY_STYLES: Record<Difficulty, string> = {
  easy: "text-success bg-success/10 border-success/20",
  medium: "text-warning bg-warning/10 border-warning/20",
  hard: "text-error bg-error/10 border-error/20",
};

export default function DifficultyBadge({
  difficulty,
  size = "sm",
}: DifficultyBadgeProps) {
  const sizeClasses =
    size === "sm" ? "px-2 py-0.5 text-[10px]" : "px-2.5 py-1 text-xs";

  return (
    <span
      className={`inline-flex items-center rounded-lg border font-semibold capitalize ${DIFFICULTY_STYLES[difficulty]} ${sizeClasses}`}
    >
      {difficulty}
    </span>
  );
}
