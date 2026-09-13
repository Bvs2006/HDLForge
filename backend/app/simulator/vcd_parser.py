"""VCD (Value Change Dump) parser for waveform visualization."""

import re
from dataclasses import dataclass, field


@dataclass
class SignalChange:
    time: int
    value: str


@dataclass
class Signal:
    id: str
    name: str
    width: int
    changes: list[SignalChange] = field(default_factory=list)


@dataclass
class WaveformData:
    timescale: str = "1ns"
    timescale_multiplier: int = 1
    timescale_unit: str = "ns"
    duration: int = 0
    signals: list[Signal] = field(default_factory=list)


class VCDParseError(Exception):
    pass


class VCDParser:
    """Parses VCD files into a normalized waveform model for browser rendering."""

    SCOPE_marker = "$scope"
    VAR_marker = "$var"
    ENDDEF_marker = "$enddefinitions"
    TIMESTAMP_marker = "#"
    DUMPALL = "$dumpall"
    DUMPPORTS = "$dumpports"
    DUMPSVARS = "$dumpsvars"
    END = "$end"
    TIMESCALE = "$timescale"

    def parse(self, vcd_content: str, max_signals: int = 100, max_changes: int = 5000) -> WaveformData:
        if not vcd_content or not vcd_content.strip():
            raise VCDParseError("Empty VCD content")

        waveform = WaveformData()
        current_scope: list[str] = []
        signal_map: dict[str, Signal] = {}
        current_time = 0
        total_changes = 0
        has_signal_defs = False

        lines = vcd_content.split("\n")
        i = 0

        while i < len(lines):
            line = lines[i].strip()

            if not line or line.startswith("//") or line.startswith("$comment"):
                i += 1
                continue

            if line.startswith(self.TIMESCALE):
                waveform.timescale = self._parse_timescale(line)
                waveform.timescale_multiplier, waveform.timescale_unit = self._parse_timescale_components(waveform.timescale)
                i += 1
                continue

            if line.startswith(self.SCOPE_marker):
                scope_name = self._extract_scope_name(line)
                if scope_name:
                    current_scope.append(scope_name)
                i += 1
                continue

            if line.startswith("$upscope"):
                if current_scope:
                    current_scope.pop()
                i += 1
                continue

            if line.startswith(self.VAR_marker):
                has_signal_defs = True
                if len(signal_map) < max_signals:
                    signal = self._parse_var(line, current_scope)
                    if signal:
                        signal_map[signal.id] = signal
                        waveform.signals.append(signal)
                i += 1
                continue

            if line.startswith(self.ENDDEF_marker):
                i += 1
                continue

            if line.startswith(self.TIMESTAMP_marker):
                try:
                    current_time = int(line[1:].strip())
                except ValueError:
                    pass
                i += 1
                continue

            if line.startswith(self.DUMPALL) or line.startswith(self.DUMPSVARS) or line.startswith(self.DUMPPORTS):
                i += 1
                continue

            if line == self.END:
                i += 1
                continue

            if line and line[0] in "01xzXZbB":
                if total_changes < max_changes * len(signal_map) if signal_map else max_changes:
                    signal_id, value = self._parse_value_change(line)
                    if signal_id and signal_id in signal_map:
                        signal_map[signal_id].changes.append(
                            SignalChange(time=current_time, value=value)
                        )
                        total_changes += 1
                        if current_time > waveform.duration:
                            waveform.duration = current_time

            i += 1

        return waveform

    def _parse_timescale(self, line: str) -> str:
        match = re.search(r"\$timescale\s+(\d+)\s*(\w+)\s*\$end", line)
        if match:
            return f"{match.group(1)}{match.group(2)}"

        parts = line.replace("$timescale", "").replace("$end", "").strip().split()
        if len(parts) == 2:
            return f"{parts[0]}{parts[1]}"
        elif len(parts) == 1:
            return parts[0]
        return "1ns"

    def _parse_timescale_components(self, timescale: str) -> tuple[int, str]:
        match = re.match(r"(\d+)(\w+)", timescale)
        if match:
            return int(match.group(1)), match.group(2)
        return 1, "ns"

    def _extract_scope_name(self, line: str) -> str:
        match = re.search(r"\$scope\s+\w+\s+(\S+)\s+\$end", line)
        if match:
            return match.group(1)
        parts = line.replace("$scope", "").replace("$end", "").strip().split()
        if len(parts) >= 2:
            return parts[1]
        return ""

    def _parse_var(self, line: str, scope: list[str]) -> Signal | None:
        match = re.search(
            r"\$var\s+\w+\s+(\d+)\s+(\S+)\s+(\S+)",
            line,
        )
        if not match:
            return None

        width_str, var_id, var_name = match.groups()
        width = int(width_str) if width_str.isdigit() else 1

        full_name = ".".join(scope + [var_name]) if scope else var_name

        return Signal(
            id=var_id,
            name=full_name,
            width=width,
        )

    def _parse_value_change(self, line: str) -> tuple[str, str]:
        if not line:
            return "", ""

        if line.startswith("b"):
            signal_id = line[1:].strip()
            if signal_id and len(signal_id) >= 1:
                value_part = ""
                id_part = ""
                for ch in signal_id:
                    if ch in "01xzXZ":
                        value_part += ch
                    else:
                        id_part += ch
                if value_part and id_part:
                    return id_part, value_part

        if line[0] in "01xzXZ":
            if len(line) >= 2:
                signal_id = line[1:].strip()
                return signal_id, line[0]

        return "", ""


def parse_vcd_file(
    vcd_path: str,
    max_signals: int = 100,
    max_changes: int = 5000,
) -> WaveformData:
    try:
        with open(vcd_path, "r", encoding="utf-8", errors="replace") as f:
            content = f.read()
    except FileNotFoundError:
        raise VCDParseError(f"VCD file not found: {vcd_path}")
    except Exception as e:
        raise VCDParseError(f"Error reading VCD file: {e}")

    parser = VCDParser()
    return parser.parse(content, max_signals=max_signals, max_changes=max_changes)
