
from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Slot, QObject
from PySide6.QtQml import QmlElement

import main
import user_basic_info

from datetime import datetime

QML_IMPORT_NAME = 'MyModel_py'
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0


def get_datetime(value):
    if value is None:
        return datetime.min
    return datetime.strptime(value, '%Y-%m-%dT%H:%M:%S.%f')


def sort_user_sets_description(dictionary):
    return dict(sorted(dictionary.items(),
                key=lambda x: (get_datetime(x[1]['time_bookmarked']), x[1]['set_id']), reverse=True))


@QmlElement
class MyModel(QAbstractListModel):
    bookmarked = Qt.UserRole + 1

    def __init__(self):
        super().__init__()
        self._data = []

    def rowCount(self, parent=QModelIndex()) -> int:
        return len(self._data)

    def roleNames(self):
        roles = {Qt.DisplayRole: b'display', self.bookmarked: b'bookmarked'}
        return roles

    def data(self, index: QModelIndex, role=Qt.DisplayRole):
        if not self._data:
            return None

        if role == self.bookmarked:
            return self._data[index.row()][1]

        elif role == Qt.DisplayRole:
            data = self._data[index.row()][0]
            return data

    @Slot(result=int)
    def data_length(self):
        return len(list(user_basic_info.UserData.user_sets.keys()))

    # for sets_view
    @Slot(int, int, result=bool)
    def update(self, start_index, end_index, parent=QModelIndex()):
        new_data = list(user_basic_info.UserData.user_sets_description.keys())[start_index: end_index]
        new_data.reverse()

        position = self.rowCount()

        self.beginRemoveRows(parent, 0, position - 1)
        for i in range(0, position - 1):
            self._data = []
        self.endRemoveRows()

        new_position = 0
        if len(new_data) > 0:
            self.beginInsertRows(parent, new_position, new_position + len(new_data)-1)
            for i in new_data:
                self._data.insert(new_position, (i, user_basic_info.UserData.user_sets_description[i]['bookmarked']))
            self.endInsertRows()
        return True

    # False means that we have to make from the set that was bookmarked, set that is not bookmarked
    @Slot(str, bool)
    def bookmark_set(self, set_name, bookmark):
        set_id = user_basic_info.UserData.user_sets_description[set_name]['set_id']
        current_time = datetime.now().isoformat()

        if bookmark is True:
            data, count = main.supabase.table('sets').\
                update({'bookmarked': bookmark, 'time_bookmarked': current_time}).\
                eq('set_id', set_id).\
                execute()
            user_basic_info.UserData.user_sets_description[set_name]['time_bookmarked'] = current_time
        else:
            data, count = main.supabase.table('sets').\
                update({'bookmarked': bookmark, 'time_bookmarked': None}).\
                eq('set_id', set_id).\
                execute()
            user_basic_info.UserData.user_sets_description[set_name]['time_bookmarked'] = None

        user_basic_info.UserData.user_sets_description[set_name]['bookmarked'] = bookmark
        user_basic_info.UserData.user_sets_description = sort_user_sets_description(user_basic_info.UserData.user_sets_description)

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
            del user_basic_info.UserData.user_sets_description[set_name]
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
    itemIndex = Qt.UserRole + 3

    def __init__(self):
        super().__init__()
        self._data = []

    def rowCount(self, parent=QModelIndex()) -> int:
        return len(self._data)

    def roleNames(self):
        roles = {self.question: b'question', self.answer: b'answer', self.itemIndex: b'index'}
        return roles

    def data(self, index: QModelIndex, role=Qt.DisplayRole):
        if not self._data:
            return None
        if role == self.question:
            return self._data[index.row()][0]
        if role == self.answer:
            return self._data[index.row()][1]
        if role == self.itemIndex:
            return self._data[index.row()][2]

    @Slot(str, result=int)
    def number_of_cards(self, set_name):
        return len(user_basic_info.UserData.user_sets[set_name])

    @Slot(str, result=bool)
    def cards_for_test(self, set_name):
        parent = QModelIndex()
        new_data = user_basic_info.UserData.user_sets[set_name][::-1]
        position = self.rowCount()

        length_of_new_data = len(new_data)

        if length_of_new_data > 0:
            self.beginInsertRows(parent, position, position + length_of_new_data-1)
            for index, card in enumerate(new_data):
                self._data.insert(position, (f'{card["question"]}', f'{card["answer"]}', f'{length_of_new_data - index - 1}'))
            self.endInsertRows()
        return True

    @Slot(int, result=list)
    def generate_list_of_grey(self, number_of_cards):
        print(number_of_cards)
        print([i for i in range(0, number_of_cards)])
        return [i for i in range(0, number_of_cards)]

    @Slot(str, list, result=bool)
    def cards_for_test_by_color(self, set_name, list_of_cards):
        position = self.rowCount()
        parent = QModelIndex()
        list_of_cards = sorted(list_of_cards, reverse=True)

        new_data = [card for index, card in enumerate(user_basic_info.UserData.user_sets[set_name]) if index in list_of_cards]
        # print(list(new_data))

        self.beginRemoveRows(parent, 0, position - 1)
        for i in range(0, position - 1):
            self._data = []
        self.endRemoveRows()

        position = 0

        if len(list_of_cards) > 0:
            self.beginInsertRows(parent, position, position + len(list_of_cards)-1)
            for index, card in enumerate(new_data[::-1]):
                self._data.insert(position, (f'{card["question"]}', f'{card["answer"]}', f'{list_of_cards[index]}'))
            self.endInsertRows()
        return True


@QmlElement
class LoadNewCard(QObject):

    @Slot(str, result=str)
    def load_new_card(self, index_of_set, index):
        return user_basic_info.UserData.user_sets[index_of_set][index]
