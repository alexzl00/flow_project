import mysql.connector
import user_basic_info

QML_IMPORT_NAME = 'io.qt.textproperties'
QML_IMPORT_MAJOR_VERSION = 1


mydb = mysql.connector.connect(
    host='localhost',
    user='root',
    password='gfyu-Dfgs-MLon',
    database='qt_project'
)

mycursor = mydb.cursor()

from PySide6.QtCore import QObject, Slot, Signal

class InsertSet(QObject):
    def __init__(self):
        QObject.__init__(self)

    insert_set = Signal(str)

    @Slot(str)
    def insert_set_cards(self, set_card):
        set_card = set_card.split(',')
        set_name = set_card[0]
        question = set_card[1]
        answer = set_card[2]
        query = 'INSERT INTO word_sets(user_id, set_name, question, answer) VALUES(%s, %s, %s, %s)'
        mycursor.execute(query, (user_basic_info.UserData.user_id, set_name, question, answer))
        mydb.commit()
        self.insert_set.emit('true')