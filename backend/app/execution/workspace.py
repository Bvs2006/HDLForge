import shutil
import tempfile
import uuid
from pathlib import Path


class ExecutionWorkspace:
    """Manages a temporary isolated workspace for HDL execution."""

    BASE_DIR = Path(tempfile.gettempdir()) / "hdlforge"

    def __init__(self) -> None:
        self.job_id = uuid.uuid4().hex[:16]
        self.workspace_path = self.BASE_DIR / self.job_id
        self._created = False

    def create(self) -> Path:
        self.workspace_path.mkdir(parents=True, exist_ok=True)
        self._created = True
        return self.workspace_path

    def write_submission(self, code: str) -> Path:
        path = self.workspace_path / "submission.sv"
        path.write_text(code, encoding="utf-8")
        return path

    def write_testbench(self, code: str) -> Path:
        path = self.workspace_path / "testbench.sv"
        path.write_text(code, encoding="utf-8")
        return path

    def write_file(self, filename: str, content: str) -> Path:
        path = self.workspace_path / filename
        path.write_text(content, encoding="utf-8")
        return path

    def read_output(self, filename: str) -> str:
        path = self.workspace_path / filename
        if path.exists():
            return path.read_text(encoding="utf-8", errors="replace")
        return ""

    def read_binary(self, filename: str) -> bytes:
        path = self.workspace_path / filename
        if path.exists():
            return path.read_bytes()
        return b""

    def get_waveform_path(self) -> Path:
        return self.workspace_path / "simulation.vcd"

    def waveform_exists(self) -> bool:
        return self.get_waveform_path().exists()

    def get_waveform_size(self) -> int:
        path = self.get_waveform_path()
        if path.exists():
            return path.stat().st_size
        return 0

    def cleanup(self) -> None:
        if self._created and self.workspace_path.exists():
            shutil.rmtree(self.workspace_path, ignore_errors=True)

    def __enter__(self) -> "ExecutionWorkspace":
        self.create()
        return self

    def __exit__(self, exc_type: object, exc_val: object, exc_tb: object) -> None:
        self.cleanup()
