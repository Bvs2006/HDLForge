from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path


class SimulationStatus(Enum):
    COMPILATION_OK = "COMPILATION_OK"
    COMPILATION_ERROR = "COMPILATION_ERROR"
    PASSED = "PASSED"
    FAILED = "FAILED"
    RUNTIME_ERROR = "RUNTIME_ERROR"
    TIME_LIMIT_EXCEEDED = "TIME_LIMIT_EXCEEDED"
    MEMORY_LIMIT_EXCEEDED = "MEMORY_LIMIT_EXCEEDED"
    OUTPUT_LIMIT_EXCEEDED = "OUTPUT_LIMIT_EXCEEDED"
    SYSTEM_ERROR = "SYSTEM_ERROR"


@dataclass
class TestResult:
    name: str
    passed: bool
    expected: str = ""
    received: str = ""
    message: str = ""


@dataclass
class SimulationResult:
    status: SimulationStatus
    score: int = 0
    message: str = ""
    compilation_output: str = ""
    simulation_output: str = ""
    tests: list[TestResult] = field(default_factory=list)


class HDLSimulator(ABC):
    """Abstract base class for HDL simulators."""

    @abstractmethod
    def compile(
        self,
        submission_path: Path,
        testbench_path: Path,
    ) -> SimulationResult:
        """Compile the submission and testbench. Returns COMPILATION_OK or COMPILATION_ERROR."""
        ...

    @abstractmethod
    def simulate(self, binary_path: Path) -> SimulationResult:
        """Run the compiled simulation. Returns PASSED/FAILED/error status."""
        ...
