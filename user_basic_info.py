from dataclasses import dataclass, field
from PySide6.QtCore import QObject, Slot, Signal


@dataclass()
class UserData:
    user_id: int
    user_sets: dict


