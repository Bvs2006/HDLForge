"""Waveform storage service - manages VCD files with safe storage and retrieval."""

import logging
import os
import shutil
import tempfile
import uuid
from datetime import datetime, timedelta, timezone
from pathlib import Path

from sqlalchemy.orm import Session

from app.core.config import settings
from app.db.models import Waveform
from app.execution.workspace import ExecutionWorkspace
from app.simulator.vcd_parser import VCDParseError, VCDParser, WaveformData

logger = logging.getLogger(__name__)

WAVEFORM_STORAGE_DIR = Path(tempfile.gettempdir()) / "hdlforge" / "waveforms"


class WaveformStorage:
    """Manages waveform file storage and retrieval."""

    def __init__(self) -> None:
        WAVEFORM_STORAGE_DIR.mkdir(parents=True, exist_ok=True)

    def save_waveform(
        self,
        db: Session,
        submission_id: int,
        workspace: ExecutionWorkspace,
    ) -> Waveform | None:
        vcd_path = workspace.get_waveform_path()
        if not vcd_path.exists():
            return None

        file_size = vcd_path.stat().st_size
        if file_size > settings.HDL_MAX_WAVEFORM_SIZE:
            logger.warning(
                "Waveform too large: %d bytes (limit: %d)",
                file_size,
                settings.HDL_MAX_WAVEFORM_SIZE,
            )
            return None

        if file_size == 0:
            return None

        waveform_id = f"wf_{uuid.uuid4().hex[:12]}"
        dest_dir = WAVEFORM_STORAGE_DIR / waveform_id
        dest_dir.mkdir(parents=True, exist_ok=True)
        dest_path = dest_dir / "simulation.vcd"

        try:
            shutil.copy2(str(vcd_path), str(dest_path))
        except Exception as e:
            logger.error("Failed to copy waveform: %s", e)
            return None

        try:
            parser = VCDParser()
            waveform_data = parser.parse(
                dest_path.read_text(encoding="utf-8", errors="replace"),
                max_signals=100,
                max_changes=5000,
            )
        except VCDParseError:
            waveform_data = WaveformData()

        expires_at = datetime.now(timezone.utc) + timedelta(
            hours=settings.HDL_WAVEFORM_RETENTION_HOURS
        )

        waveform = Waveform(
            submission_id=submission_id,
            waveform_id=waveform_id,
            format="vcd",
            file_size=file_size,
            duration=waveform_data.duration,
            timescale=waveform_data.timescale,
            signal_count=len(waveform_data.signals),
            file_path=str(dest_path),
            expires_at=expires_at.isoformat(),
        )
        db.add(waveform)
        db.flush()

        logger.info(
            "Saved waveform %s for submission %d (%d bytes, %d signals)",
            waveform_id,
            submission_id,
            file_size,
            len(waveform_data.signals),
        )

        return waveform

    def get_waveform_data(
        self,
        db: Session,
        waveform_id: str,
    ) -> WaveformData | None:
        waveform = (
            db.query(Waveform)
            .filter(Waveform.waveform_id == waveform_id)
            .first()
        )
        if not waveform:
            return None

        if waveform.expires_at:
            try:
                expires = datetime.fromisoformat(str(waveform.expires_at))
                if expires.tzinfo is None:
                    expires = expires.replace(tzinfo=timezone.utc)
                if datetime.now(timezone.utc) > expires:
                    self.delete_waveform(db, waveform_id)
                    return None
            except (ValueError, TypeError):
                pass

        file_path = Path(waveform.file_path)
        if not file_path.exists():
            return None

        try:
            content = file_path.read_text(encoding="utf-8", errors="replace")
            parser = VCDParser()
            return parser.parse(content, max_signals=100, max_changes=5000)
        except Exception as e:
            logger.error("Error parsing waveform %s: %s", waveform_id, e)
            return None

    def get_waveform_metadata(
        self,
        db: Session,
        waveform_id: str,
    ) -> Waveform | None:
        return (
            db.query(Waveform)
            .filter(Waveform.waveform_id == waveform_id)
            .first()
        )

    def get_waveform_by_submission(
        self,
        db: Session,
        submission_id: int,
    ) -> Waveform | None:
        return (
            db.query(Waveform)
            .filter(Waveform.submission_id == submission_id)
            .first()
        )

    def update_submission_id(
        self,
        db: Session,
        waveform_id: str,
        submission_id: int,
    ) -> bool:
        waveform = (
            db.query(Waveform)
            .filter(Waveform.waveform_id == waveform_id)
            .first()
        )
        if not waveform:
            return False

        waveform.submission_id = submission_id
        db.flush()
        return True

    def delete_waveform(
        self,
        db: Session,
        waveform_id: str,
    ) -> bool:
        waveform = (
            db.query(Waveform)
            .filter(Waveform.waveform_id == waveform_id)
            .first()
        )
        if not waveform:
            return False

        file_path = Path(waveform.file_path)
        if file_path.exists():
            try:
                shutil.rmtree(file_path.parent, ignore_errors=True)
            except Exception as e:
                logger.error("Error deleting waveform file: %s", e)

        db.delete(waveform)
        db.flush()
        return True

    def cleanup_expired(self, db: Session) -> int:
        now = datetime.now(timezone.utc)
        expired = (
            db.query(Waveform)
            .filter(Waveform.expires_at.isnot(None))
            .all()
        )

        count = 0
        for waveform in expired:
            try:
                expires = datetime.fromisoformat(str(waveform.expires_at))
                if expires.tzinfo is None:
                    expires = expires.replace(tzinfo=timezone.utc)
                if now > expires:
                    self.delete_waveform(db, waveform.waveform_id)
                    count += 1
            except (ValueError, TypeError):
                continue

        if count > 0:
            db.commit()
            logger.info("Cleaned up %d expired waveforms", count)

        return count


waveform_storage = WaveformStorage()
