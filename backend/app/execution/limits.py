import os
from dataclasses import dataclass


@dataclass(frozen=True)
class ExecutionLimits:
    timeout_seconds: int = 5
    memory_mb: int = 256
    cpu_seconds: int = 5
    max_source_size: int = 50000
    max_output_size: int = 100000
    process_limit: int = 64
    max_waveform_size: int = 5242880

    @classmethod
    def from_env(cls) -> "ExecutionLimits":
        return cls(
            timeout_seconds=int(os.getenv("HDL_EXECUTION_TIMEOUT", "5")),
            memory_mb=int(os.getenv("HDL_MEMORY_LIMIT", "256")),
            cpu_seconds=int(os.getenv("HDL_CPU_LIMIT", "5")),
            max_source_size=int(os.getenv("HDL_MAX_SOURCE_SIZE", "50000")),
            max_output_size=int(os.getenv("HDL_MAX_OUTPUT_SIZE", "100000")),
            process_limit=int(os.getenv("HDL_PROCESS_LIMIT", "64")),
            max_waveform_size=int(os.getenv("HDL_MAX_WAVEFORM_SIZE", "5242880")),
        )
