from pydantic import BaseModel, Field


class WaveformSignalChange(BaseModel):
    time: int
    value: str


class WaveformSignal(BaseModel):
    name: str
    width: int = 1
    changes: list[WaveformSignalChange] = []


class WaveformResponse(BaseModel):
    waveform_id: str
    format: str = "vcd"
    duration: int = 0
    timescale: str = "1ns"
    file_size: int = 0
    signal_count: int = 0
    signals: list[WaveformSignal] = []


class WaveformMetadata(BaseModel):
    waveform_id: str
    format: str = "vcd"
    duration: int = 0
    timescale: str = "1ns"
    file_size: int = 0
    signal_count: int = 0
    submission_id: int = 0
    created_at: str = ""
