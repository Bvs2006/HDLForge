import logging
import subprocess
from pathlib import Path

from app.execution.limits import ExecutionLimits
from app.simulator.base import HDLSimulator, SimulationResult, SimulationStatus
from app.simulator.result_parser import ResultParser

logger = logging.getLogger(__name__)

class IcarusSimulator(HDLSimulator):
    """Icarus Verilog based simulator.

    Compilation uses `iverilog` to produce a binary executable, and simulation runs
    the binary with `vvp`. Supports optional VCD generation via `$dumpfile` in the
    testbench (handled by the runner's VCD injection)."""

    def __init__(self, workspace: object | None = None, limits: ExecutionLimits | None = None) -> None:
        self.limits = limits or ExecutionLimits.from_env()
        self.parser = ResultParser()
        self.workspace = workspace

    def compile(self, submission_path: Path, testbench_path: Path, trace_enabled: bool = False) -> SimulationResult:
        # Icarus does not have a separate trace flag like Verilator; ignore trace_enabled.
        output_path = submission_path.parent / "simulation.out"
        cmd = [
            "iverilog",
            "-g2012",
            "-o",
            str(output_path),
            str(testbench_path),
            str(submission_path),
        ]
        try:
            proc = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=self.limits.timeout_seconds,
                cwd=str(submission_path.parent),
            )
        except FileNotFoundError:
            return SimulationResult(
                status=SimulationStatus.SYSTEM_ERROR,
                message="Icarus Verilog (iverilog) is not installed or not found in PATH.",
                compilation_output="",
            )
        except subprocess.TimeoutExpired:
            return SimulationResult(
                status=SimulationStatus.TIME_LIMIT_EXCEEDED,
                message="Compilation timed out.",
                compilation_output="",
            )

        if proc.returncode != 0:
            sanitized = self._sanitize_output(proc.stdout + "\n" + proc.stderr)
            return SimulationResult(
                status=SimulationStatus.COMPILATION_ERROR,
                message="Compilation failed.",
                compilation_output=sanitized,
            )
        return SimulationResult(
            status=SimulationStatus.COMPILATION_OK,
            compilation_output="Compilation successful.",
        )

    def simulate(self, binary_path: Path) -> SimulationResult:
        if not binary_path.exists():
            return SimulationResult(
                status=SimulationStatus.SYSTEM_ERROR,
                message="Compiled binary not found.",
            )
        try:
            proc = subprocess.run(
                ["vvp", str(binary_path)],
                capture_output=True,
                text=True,
                timeout=self.limits.timeout_seconds,
                cwd=str(binary_path.parent),
            )
        except subprocess.TimeoutExpired:
            return SimulationResult(
                status=SimulationStatus.TIME_LIMIT_EXCEEDED,
                message="Simulation timed out.",
            )
        if proc.returncode != 0 and not proc.stdout.strip():
            sanitized = self._sanitize_output(proc.stderr)
            return SimulationResult(
                status=SimulationStatus.RUNTIME_ERROR,
                message="Simulation runtime error.",
                simulation_output=sanitized,
            )
        return self.parser.parse(proc.stdout, proc.stderr)

    def _sanitize_output(self, output: str) -> str:
        lines = output.split("\n")
        sanitized = []
        for line in lines:
            if "/tmp/" in line or "hdlforge" in line.lower():
                continue
            sanitized.append(line)
        return "\n".join(sanitized).strip()
