"""empty message

Revision ID: 6c82b464c026
Revises: ecc4f4ddb3a1
Create Date: 2026-01-27 16:18:02.113515

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '6c82b464c026'
down_revision: Union[str, Sequence[str], None] = 'ecc4f4ddb3a1'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass
