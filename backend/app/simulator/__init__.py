from app.simulator.base import (
    HDLSimulator,
    SimulationResult,
    SimulationStatus,
    TestResult as SimTestResult,
)
from app.simulator.verilator import VerilatorSimulator
from app.simulator.icarus import IcarusSimulator
from app.simulator.result_parser import ResultParser

def get_simulator(name: str, workspace: object | None = None, limits: object | None = None) -> HDLSimulator:
    """Factory to return the appropriate HDL simulator.

    Args:
        name: Identifier of the simulator, e.g., "verilator" or "icarus".
        workspace: Execution workspace passed to the simulator.
        limits: Execution limits configuration.
    """
    name = name.lower()
    if name == "verilator":
        return VerilatorSimulator(workspace=workspace, limits=limits)
    if name == "icarus":
        return IcarusSimulator(workspace=workspace, limits=limits)
    raise ValueError(f"Unsupported simulator '{name}'. Available: verilator, icarus")

__all__ = [
    "HDLSimulator",
    "SimulationResult",
    "SimulationStatus",
    "SimTestResult",
    "VerilatorSimulator",
    "IcarusSimulator",
    "ResultParser",
    "get_simulator",
]
