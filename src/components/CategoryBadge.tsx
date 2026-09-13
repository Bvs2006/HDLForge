import { CATEGORY_LABELS, Category } from "@/lib/types";

interface CategoryBadgeProps {
  category: string;
  size?: "sm" | "md";
}

export default function CategoryBadge({
  category,
  size = "sm",
}: CategoryBadgeProps) {
  const sizeClasses =
    size === "sm" ? "px-2 py-0.5 text-[10px]" : "px-2.5 py-1 text-xs";

  return (
    <span
      className={`inline-flex items-center rounded-lg border border-border bg-surface text-text-secondary ${sizeClasses}`}
    >
      {CATEGORY_LABELS[category as Category] ?? category}
    </span>
  );
}
