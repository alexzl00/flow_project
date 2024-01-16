import dataclasses
import threading

from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Slot, QObject, Signal
from PySide6.QtGui import QColor, QPainter
from PySide6.QtQml import QmlElement
from PySide6.QtQuick import QQuickPaintedItem

import user_basic_info

import pyttsx3

QML_IMPORT_NAME = 'MyModel_py'
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0


@QmlElement
class MyModel(QAbstractListModel):

    def __init__(self):
        super().__init__()
        self._data = []

    def rowCount(self, parent=QModelIndex()) -> int:
        return len(self._data)

    def roleNames(self):
        roles = super().roleNames()
        return roles

    def data(self, index: QModelIndex, role=Qt.DisplayRole):
        if not self._data:
            return None

        elif role == Qt.DisplayRole:
            data = self._data[index.row()]
            return data

    @Slot(result=bool)
    def update(self, parent=QModelIndex()):
        new_data = user_basic_info.UserData.user_sets.keys()
        position = self.rowCount()

        if len(new_data) > 0:
            self.beginInsertRows(parent, position, position + len(new_data)-1)
            for i in new_data:
                self._data.insert(position, i)
            self.endInsertRows()
        return True

    @Slot(str, result=bool)
    def wordlist_of_set(self, set_name):
        parent = QModelIndex()
        new_data = user_basic_info.UserData.user_sets[set_name]
        position = self.rowCount()

        if len(new_data) > 0:
            self.beginInsertRows(parent, position, position + len(new_data)-1)
            for i in new_data:
                self._data.insert(position, f'question: {i[1]}\n answer: {i[2]}')
            self.endInsertRows()
        return True


@QmlElement
class CardForTest(QAbstractListModel):
    question = Qt.UserRole + 1
    answer = Qt.UserRole + 2

    def __init__(self):
        super().__init__()
        self._data = []

    def rowCount(self, parent=QModelIndex()) -> int:
        return len(self._data)

    def roleNames(self):
        roles = {self.question: b'question', self.answer: b'answer'}
        return roles

    def data(self, index: QModelIndex, role=Qt.DisplayRole):
        if not self._data:
            return None
        if role == self.question:
            return self._data[index.row()][0]
        if role == self.answer:
            return self._data[index.row()][1]

    @Slot(str, result=bool)
    def cards_for_test(self, set_name):
        parent = QModelIndex()
        new_data = user_basic_info.UserData.user_sets[set_name]
        position = self.rowCount()

        if len(new_data) > 0:
            self.beginInsertRows(parent, position, position + len(new_data)-1)
            for i in new_data:
                self._data.insert(position, (f'question: {i[1]}', f'answer: {i[2]}'))
            self.endInsertRows()
        return True

    @staticmethod
    def text_to_speech_separate_thread(text):
        engine = pyttsx3.init()

        engine.setProperty('rate', 140)
        engine.setProperty('volume', 0.7)

        engine.say(text)
        engine.runAndWait()

    @Slot(str)
    def text_to_speech(self, row):

        text = self._data[int(row)][1]

        t1 = threading.Thread(target=self.text_to_speech_separate_thread, args=[text])
        t1.start()


@QmlElement
class CustomPaintedItem(QQuickPaintedItem):
    def __init__(self):
        super().__init__()

        self.grey_proportion = 1
        self.red_proportion = 0
        self.orange_proportion = 0
        self.green_proportion = 0

    def paint(self, painter):
        total_width = self.width()
        total_height = self.height()

        total_proportion = self.grey_proportion + self.red_proportion + self.orange_proportion + self.green_proportion
        green_width = total_width * self.green_proportion / total_proportion
        orange_width = total_width * self.orange_proportion / total_proportion
        red_width = total_width * self.red_proportion / total_proportion
        grey_width = total_width * self.grey_proportion / total_proportion

        painter.fillRect(0, 0, green_width, total_height, QColor(Qt.green))
        painter.fillRect(green_width, 0, orange_width, total_height, '#FFA500')
        painter.fillRect(green_width + orange_width, 0, red_width, total_height, QColor(Qt.red))
        painter.fillRect(green_width + orange_width + red_width, 0, grey_width, total_height, '#808080')

    @Slot(str)
    def set_proportion(self, list_of_colors):

        list_of_colors = list_of_colors.split(',')
        self.green_proportion = int(list_of_colors[0])
        self.orange_proportion = int(list_of_colors[1])
        self.red_proportion = int(list_of_colors[2])
        self.grey_proportion = int(list_of_colors[3])

        self.update()

        # print(f"{self.green_proportion} and {type(self.green_proportion)} \n"
        #       f"{self.orange_proportion} and {type(self.orange_proportion)} \n"
        #       f"{self.red_proportion} and {type(self.red_proportion)} \n"
        #       f"{self.grey_proportion} and {type(self.grey_proportion)} \n")


@QmlElement
class LoadNewCard(QObject):

    @Slot(str, result=str)
    def load_new_card(self, index_of_set, index):
        return user_basic_info.UserData.user_sets[index_of_set][index]
