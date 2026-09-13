from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.db.database import get_db
from app.schemas.waveform import WaveformMetadata, WaveformResponse, WaveformSignal, WaveformSignalChange
from app.services.waveform_service import waveform_storage

router = APIRouter(prefix="/waveforms", tags=["waveforms"])


@router.get("/{waveform_id}", response_model=WaveformResponse)
def get_waveform(waveform_id: str, db: Session = Depends(get_db)):
    waveform = waveform_storage.get_waveform_metadata(db, waveform_id)
    if not waveform:
        raise HTTPException(status_code=404, detail=f"Waveform '{waveform_id}' not found")

    waveform_data = waveform_storage.get_waveform_data(db, waveform_id)
    if not waveform_data:
        raise HTTPException(status_code=404, detail="Waveform data not available or expired")

    signals = [
        WaveformSignal(
            name=s.name,
            width=s.width,
            changes=[WaveformSignalChange(time=c.time, value=c.value) for c in s.changes],
        )
        for s in waveform_data.signals
    ]

    return WaveformResponse(
        waveform_id=waveform_id,
        format=waveform.format,
        duration=waveform_data.duration,
        timescale=waveform_data.timescale,
        file_size=waveform.file_size,
        signal_count=len(waveform_data.signals),
        signals=signals,
    )


@router.get("/{waveform_id}/metadata", response_model=WaveformMetadata)
def get_waveform_metadata(waveform_id: str, db: Session = Depends(get_db)):
    waveform = waveform_storage.get_waveform_metadata(db, waveform_id)
    if not waveform:
        raise HTTPException(status_code=404, detail=f"Waveform '{waveform_id}' not found")

    return WaveformMetadata(
        waveform_id=waveform.waveform_id,
        format=waveform.format,
        duration=waveform.duration,
        timescale=waveform.timescale,
        file_size=waveform.file_size,
        signal_count=waveform.signal_count,
        submission_id=waveform.submission_id,
        created_at=str(waveform.created_at),
    )
