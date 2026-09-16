"""initial migration

Revision ID: 001
Revises:
Create Date: 2026-09-11

"""
from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "001"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    difficulty_enum = sa.Enum("EASY", "MEDIUM", "HARD", name="difficulty")
    language_enum = sa.Enum("VERILOG", "SYSTEMVERILOG", name="language")
    # difficulty_enum.create(op.get_bind(), checkfirst=True)
    # language_enum.create(op.get_bind(), checkfirst=True)

    op.create_table(
        "problems",
        sa.Column("id", sa.Integer(), primary_key=True, index=True),
        sa.Column("slug", sa.String(length=100), unique=True, index=True),
        sa.Column("title", sa.String(length=200)),
        sa.Column("description", sa.Text()),
        sa.Column("difficulty", difficulty_enum),
        sa.Column("category", sa.String(length=100)),
        sa.Column("language", language_enum),
        sa.Column("input_description", sa.Text(), server_default=""),
        sa.Column("output_description", sa.Text(), server_default=""),
        sa.Column("constraints", sa.Text(), server_default=""),
        sa.Column("starter_code", sa.Text(), server_default=""),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
        ),
    )


def downgrade() -> None:
    op.drop_table("problems")
    sa.Enum(name="language").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="difficulty").drop(op.get_bind(), checkfirst=True)
