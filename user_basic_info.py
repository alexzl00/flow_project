from dataclasses import dataclass


@dataclass()
class UserData:
    user_id: int
    user_sets: dict
    user_sets_description: dict


