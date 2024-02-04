from PySide6.QtCore import Slot, QObject
from datetime import datetime, timedelta
import main
from PySide6.QtQml import QmlElement
from dataclasses import dataclass

import user_basic_info


@dataclass()
class StartOfSession:
    start_of_session = str


QML_IMPORT_NAME = 'TrackUserScreenTime'
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0


@QmlElement
class TrackUserScreenTime(QObject):
    def __init__(self):
        super().__init__()

    # saves the durance of the user session to database
    @Slot()
    def end_session(self):
        start_time = datetime.strptime(str(StartOfSession.start_of_session), "%Y/%m/%d %H:%M")
        current_time = datetime.now().strftime("%Y/%m/%d %H:%M")

        time_spent = datetime.strptime(current_time, "%Y/%m/%d %H:%M") - start_time

        one_minute = timedelta(minutes=1)

        day_of_using = start_time.strftime("%Y/%m/%d")
        print(time_spent)

        if time_spent > one_minute:
            query = 'INSERT INTO user_screen_time(user_id, day_of_using, time_of_using) VALUES (%s, %s, %s)'
            main.mycursor.execute(query, (user_basic_info.UserData.user_id,
                                          datetime.strptime(day_of_using, "%Y/%m/%d"), time_spent))
            main.mydb.commit()

