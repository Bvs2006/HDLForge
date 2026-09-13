"use client";

import { useState, useRef, useCallback } from "react";
import { WaveformData, WaveformSignal as WaveformSignalType, WaveformDisplayMode } from "@/lib/types";
import WaveformTimeline from "./WaveformTimeline";
import WaveformSignalRow from "./WaveformSignal";
import WaveformControls from "./WaveformControls";
import { BarChart3, ChevronDown, ChevronUp, X } from "lucide-react";

interface WaveformViewerProps {
  data: WaveformData;
  onClose?: () => void;
}

export default function WaveformViewer({ data, onClose }: WaveformViewerProps) {
  const [zoom, setZoom] = useState(1);
  const [cursorTime, setCursorTime] = useState<number | null>(null);
  const [displayMode, setDisplayMode] = useState<WaveformDisplayMode>("hex");
  const [signalFilter, setSignalFilter] = useState("");
  const [isCollapsed, setIsCollapsed] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);
  const scrollRef = useRef<HTMLDivElement>(null);

  const filteredSignals = data.signals.filter((s) =>
    s.name.toLowerCase().includes(signalFilter.toLowerCase())
  );

  const maxTime = data.duration || 100;
  const timeScale = data.timescale || "1ns";

  const handleZoomIn = useCallback(() => { setZoom((z) => Math.min(z * 1.5, 10)); }, []);
  const handleZoomOut = useCallback(() => { setZoom((z) => Math.max(z / 1.5, 0.1)); }, []);
  const handleFitToScreen = useCallback(() => { setZoom(1); if (scrollRef.current) scrollRef.current.scrollLeft = 0; }, []);
  const handleResetView = useCallback(() => { setZoom(1); setCursorTime(null); if (scrollRef.current) scrollRef.current.scrollLeft = 0; }, []);
  const handleSignalClick = useCallback((time: number) => { setCursorTime(time); }, []);

  const getSignalValuesAtCursor = useCallback(
    (signal: WaveformSignalType): string => {
      if (cursorTime === null) return "";
      let lastValue = "x";
      for (const change of signal.changes) {
        if (change.time <= cursorTime) lastValue = change.value;
        else break;
      }
      if (signal.width === 1) return lastValue;
      if (displayMode === "hex") return binaryToHex(lastValue);
      else if (displayMode === "decimal") return binaryToDecimal(lastValue);
      return lastValue;
    },
    [cursorTime, displayMode]
  );

  if (isCollapsed) {
    return (
      <div className="rounded-xl border border-border bg-panel">
        <button onClick={() => setIsCollapsed(false)} className="flex w-full items-center justify-between px-4 py-2.5">
          <span className="text-xs font-medium text-text-secondary">Waveform Viewer</span>
          <ChevronUp className="h-3.5 w-3.5 text-text-dim" />
        </button>
      </div>
    );
  }

  return (
    <div className="flex flex-col rounded-xl border border-border bg-panel overflow-hidden" ref={containerRef}>
      <div className="flex items-center justify-between border-b border-border px-4 py-2.5">
        <div className="flex items-center gap-2">
          <BarChart3 className="h-3.5 w-3.5 text-accent" />
          <span className="text-xs font-medium text-text-secondary">Waveform Viewer</span>
          <span className="text-[10px] text-text-dim">
            {data.signalCount} signals · {timeScale} · {formatDuration(maxTime, timeScale)}
          </span>
        </div>
        <div className="flex items-center gap-1">
          <button onClick={() => setIsCollapsed(true)} className="rounded-lg p-1.5 text-text-muted hover:bg-surface hover:text-text-primary transition-colors" title="Collapse">
            <ChevronDown className="h-3.5 w-3.5" />
          </button>
          {onClose && (
            <button onClick={onClose} className="rounded-lg p-1.5 text-text-muted hover:bg-surface hover:text-text-primary transition-colors" title="Close">
              <X className="h-3.5 w-3.5" />
            </button>
          )}
        </div>
      </div>

      <WaveformControls
        zoom={zoom}
        displayMode={displayMode}
        onZoomIn={handleZoomIn}
        onZoomOut={handleZoomOut}
        onFitToScreen={handleFitToScreen}
        onResetView={handleResetView}
        onDisplayModeChange={setDisplayMode}
        signalFilter={signalFilter}
        onFilterChange={setSignalFilter}
      />

      {cursorTime !== null && (
        <div className="border-b border-border bg-surface/50 px-4 py-1.5">
          <span className="text-[10px] text-text-muted">
            Cursor: <span className="font-mono text-accent">{cursorTime} {timeScale}</span>
          </span>
        </div>
      )}

      <div className="overflow-x-auto overflow-y-auto" style={{ maxHeight: "400px" }} ref={scrollRef}>
        <div style={{ width: `${Math.max(100, zoom * 100)}%`, minWidth: "100%" }}>
          <WaveformTimeline
            duration={maxTime}
            timescale={timeScale}
            zoom={zoom}
            cursorTime={cursorTime}
            onCursorChange={setCursorTime}
          />

          <div className="divide-y divide-border/50">
            {filteredSignals.map((signal) => (
              <WaveformSignalRow
                key={signal.name}
                signal={signal}
                duration={maxTime}
                timescale={timeScale}
                zoom={zoom}
                cursorTime={cursorTime}
                displayMode={displayMode}
                onSignalClick={handleSignalClick}
                cursorValue={getSignalValuesAtCursor(signal)}
              />
            ))}
          </div>

          {filteredSignals.length === 0 && (
            <div className="py-8 text-center text-xs text-text-dim">
              {data.signals.length === 0 ? "No signals in waveform" : "No signals match filter"}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

function binaryToHex(binary: string): string {
  const cleaned = binary.replace(/[^01xzXZ]/g, "");
  if (cleaned.length === 0) return binary;
  if (cleaned.includes("x") || cleaned.includes("z") || cleaned.includes("X") || cleaned.includes("Z")) return cleaned;
  const padded = cleaned.padStart(Math.ceil(cleaned.length / 4) * 4, "0");
  let hex = "";
  for (let i = 0; i < padded.length; i += 4) {
    const nibble = padded.substring(i, i + 4);
    hex += parseInt(nibble, 2).toString(16).toUpperCase();
  }
  return hex;
}

function binaryToDecimal(binary: string): string {
  const cleaned = binary.replace(/[^01]/g, "");
  if (cleaned.length === 0 || cleaned.length !== binary.length) return binary;
  return parseInt(cleaned, 2).toString();
}

function formatDuration(time: number, timescale: string): string {
  if (time === 0) return "0";
  return `${time} ${timescale}`;
}
