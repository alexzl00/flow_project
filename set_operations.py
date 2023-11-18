import mysql.connector
import user_basic_info
from itertools import groupby

import PySide6

QML_IMPORT_NAME = 'qml_set_operations'
QML_IMPORT_MAJOR_VERSION = 1


mydb = mysql.connector.connect(
    host='localhost',
    user='root',
    password='gfyu-Dfgs-MLon',
    database='qt_project'
)

mycursor = mydb.cursor()

from PySide6.QtCore import QObject, Slot, Signal, QAbstractListModel, QModelIndex, Qt


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


class LoadUserSets:
    def __init__(self, user_id):
        self.user_id = user_id

    def load_data(self):
        query = 'select set_name, question, answer from word_sets where user_id = %s'
        mycursor.execute(query, (self.user_id,))
        result = mycursor.fetchall()
        grouped = groupby(result, key=lambda x: x[0])
        # for key, value in grouped:
        #     print(key, list(value))
        user_basic_info.UserData.user_sets = grouped

# class SetUserSetsModel(QObject):
#     def __init__(self):
#         super().__init__()
#
#     @property
#     def user_sets_model(self):
#         data = ['item 1', 'item 2']
#         return MyModel(data)

from dataclasses import fields

