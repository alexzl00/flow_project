from dataclasses import dataclass
from PySide6.QtCore import QObject, Slot, Signal


@dataclass(frozen=True)
class UserData:
    user_id: int


