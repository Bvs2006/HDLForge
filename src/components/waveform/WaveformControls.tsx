"use client";

import { WaveformDisplayMode } from "@/lib/types";
import { Search, ZoomIn, ZoomOut, Maximize2, RotateCcw } from "lucide-react";

interface WaveformControlsProps {
  zoom: number;
  displayMode: WaveformDisplayMode;
  onZoomIn: () => void;
  onZoomOut: () => void;
  onFitToScreen: () => void;
  onResetView: () => void;
  onDisplayModeChange: (mode: WaveformDisplayMode) => void;
  signalFilter: string;
  onFilterChange: (filter: string) => void;
}

export default function WaveformControls({
  zoom,
  displayMode,
  onZoomIn,
  onZoomOut,
  onFitToScreen,
  onResetView,
  onDisplayModeChange,
  signalFilter,
  onFilterChange,
}: WaveformControlsProps) {
  return (
    <div className="flex items-center gap-2 border-b border-border px-4 py-2">
      <div className="flex items-center gap-0.5">
        <button onClick={onZoomIn} className="rounded-lg p-1.5 text-text-muted hover:bg-surface hover:text-text-primary transition-colors" title="Zoom In">
          <ZoomIn className="h-3.5 w-3.5" />
        </button>
        <button onClick={onZoomOut} className="rounded-lg p-1.5 text-text-muted hover:bg-surface hover:text-text-primary transition-colors" title="Zoom Out">
          <ZoomOut className="h-3.5 w-3.5" />
        </button>
        <span className="ml-1 font-mono text-[10px] text-text-dim">{Math.round(zoom * 100)}%</span>
      </div>

      <div className="h-4 w-px bg-border" />

      <button onClick={onFitToScreen} className="rounded-lg px-2 py-1 text-[10px] text-text-muted hover:bg-surface hover:text-text-primary transition-colors" title="Fit to Screen">
        <Maximize2 className="h-3 w-3" />
      </button>
      <button onClick={onResetView} className="rounded-lg px-2 py-1 text-[10px] text-text-muted hover:bg-surface hover:text-text-primary transition-colors" title="Reset View">
        <RotateCcw className="h-3 w-3" />
      </button>

      <div className="h-4 w-px bg-border" />

      <div className="flex items-center gap-0.5">
        {(["binary", "hex", "decimal"] as WaveformDisplayMode[]).map((mode) => (
          <button
            key={mode}
            onClick={() => onDisplayModeChange(mode)}
            className={`rounded-lg px-2 py-1 text-[10px] font-medium transition-all ${
              displayMode === mode
                ? "bg-accent/10 text-accent"
                : "text-text-dim hover:bg-surface hover:text-text-muted"
            }`}
            title={`Display as ${mode}`}
          >
            {mode === "binary" ? "BIN" : mode === "hex" ? "HEX" : "DEC"}
          </button>
        ))}
      </div>

      <div className="h-4 w-px bg-border" />

      <div className="relative">
        <Search className="absolute left-2 top-1/2 h-3 w-3 -translate-y-1/2 text-text-dim" />
        <input
          type="text"
          value={signalFilter}
          onChange={(e) => onFilterChange(e.target.value)}
          placeholder="Search signals..."
          className="h-6 rounded-lg border border-border bg-surface pl-7 pr-2 text-[10px] text-text-muted placeholder-text-dim outline-none transition-all focus:border-accent/40"
        />
      </div>
    </div>
  );
}
