import dataclasses
import threading

from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Slot, QObject, Signal
from PySide6.QtGui import QColor, QPainter
from PySide6.QtQml import QmlElement
from PySide6.QtQuick import QQuickPaintedItem

import main
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

    # for sets_view
    @Slot(result=bool)
    def update(self, parent=QModelIndex()):
        new_data = list(user_basic_info.UserData.user_sets.keys())[::-1]
        position = self.rowCount()

        self.beginRemoveRows(parent, 0, position)
        self.endRemoveRows()

        new_position = 0
        if len(new_data) > 0:
            self.beginInsertRows(parent, new_position, new_position + len(new_data)-1)
            for i in new_data:
                self._data.insert(new_position, i)
            self.endInsertRows()
        return True

    # for view_of_cards
    @Slot(str, result=bool)
    def wordlist_of_set(self, set_name: str) -> bool:
        parent = QModelIndex()
        new_data = user_basic_info.UserData.user_sets[set_name][::-1]
        position = self.rowCount()

        self.beginRemoveRows(parent, 0, position)
        self.endRemoveRows()

        new_position = 0
        if len(new_data) > 0:
            self.beginInsertRows(parent, new_position, new_position + len(new_data)-1)
            for i in new_data:
                self._data.insert(new_position, f'question: {i["question"]}\n answer: {i["answer"]}')
            self.endInsertRows()

        return True

    @Slot(list, result=bool)
    def delete_card(self, t: list) -> bool:
        set_name: str = t[0]
        card_index: int = int(t[1])
        card_id = user_basic_info.UserData.user_sets[set_name][card_index]['card_id']
        del user_basic_info.UserData.user_sets[set_name][card_index]

        main.supabase.table('word_sets').delete().eq('card_id', card_id).execute()

        if len(user_basic_info.UserData.user_sets[set_name]) == 0:
            del user_basic_info.UserData.user_sets[set_name]
            main.supabase.table('sets').delete().eq('set_name', set_name).execute()

            # means that this set does not have cards anymore,
            # so we can catch it in qml and redirect to the ListView with sets
            return False

        # means that this set has cards,
        # and we just update the rows excluding the one deleted
        return True

    @Slot(list, result=bool)
    def alter_card(self, t: list) -> bool:
        set_name: str = t[0]
        card_index: int = int(t[1])
        new_question = t[2]
        new_answer = t[3]
        print(f's {set_name}, c{card_index}, nq {new_question}, na {new_answer}')

        card_id = user_basic_info.UserData.user_sets[set_name][card_index]['card_id']

        user_basic_info.UserData.user_sets[set_name][card_index]['question'] = new_question
        user_basic_info.UserData.user_sets[set_name][card_index]['answer'] = new_answer

        main.supabase.table('word_sets').update({'question': new_question, 'answer': new_answer}).eq('card_id', card_id).execute()
        return True

    @Slot(list, result=str)
    def answer(self, t: list):
        set_name: str = t[0]
        card_index: int = int(t[1])

        return user_basic_info.UserData.user_sets[set_name][card_index]['answer']

    @Slot(list, result=str)
    def question(self, t: list):
        set_name: str = t[0]
        card_index: int = int(t[1])

        return user_basic_info.UserData.user_sets[set_name][card_index]['question']


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
                self._data.insert(position, (f'question: {i["question"]}', f'answer: {i["answer"]}'))
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


@QmlElement
class LoadNewCard(QObject):

    @Slot(str, result=str)
    def load_new_card(self, index_of_set, index):
        return user_basic_info.UserData.user_sets[index_of_set][index]
