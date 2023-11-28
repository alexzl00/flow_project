from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Slot
from PySide6.QtQml import QmlElement

import user_basic_info

QML_IMPORT_NAME = 'MyModel_py'
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0


@QmlElement
class MyModel(QAbstractListModel):
    RatioRole = Qt.UserRole + 1

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
