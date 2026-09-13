"""add waveforms table

Revision ID: 004
Revises: 003
Create Date: 2026-09-12

"""
from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "004"
down_revision: Union[str, None] = "003"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "waveforms",
        sa.Column("id", sa.Integer(), primary_key=True, index=True),
        sa.Column("submission_id", sa.Integer(), sa.ForeignKey("submissions.id"), index=True),
        sa.Column("waveform_id", sa.String(64), unique=True, index=True),
        sa.Column("format", sa.String(10), server_default="vcd"),
        sa.Column("file_size", sa.Integer(), server_default="0"),
        sa.Column("duration", sa.Integer(), server_default="0"),
        sa.Column("timescale", sa.String(20), server_default="1ns"),
        sa.Column("signal_count", sa.Integer(), server_default="0"),
        sa.Column("file_path", sa.Text(), server_default=""),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=True),
    )


def downgrade() -> None:
    op.drop_table("waveforms")
