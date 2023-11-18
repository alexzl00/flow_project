from PySide6 import QtQml
from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Slot
from PySide6.QtQml import QmlElement, qmlRegisterType

import user_basic_info

QML_IMPORT_NAME = 'MyModel_py'
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0


@QmlElement
class MyModel(QAbstractListModel):

    RatioRole = Qt.UserRole + 1

    def __init__(self):
        super().__init__()
        # self._data = [key for key, value in getattr(user_basic_info.UserData.user_sets)]
        self._data = ['item 1', 'item 2']
        # self._data = []

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
    def append(self, parent=QModelIndex()):
        new_data = []
        position = self.rowCount()
        for key, value in user_basic_info.UserData.user_sets:
            if key not in self._data:
                new_data.append(key)
        if len(new_data) > 0:
            self.beginInsertRows(parent, position, position + len(new_data)-1)
            for i in new_data:
                self._data.insert(position, i)
            self.endInsertRows()
        return True

    # @Slot(result=bool)
    # def append(self):
    #     return self.insertRow(self.rowCount())
    #
    # def insertRow(self, row: int, parent=QModelIndex()):
    #     return self.insertRows(row, 0)
    #
    # def insertRows(self, row: int, count, index=QModelIndex()):
    #     self.beginInsertRows(index, row, row + count)
    #     for i in range(count+1):
    #         self._data.insert(row, 'new')
    #     self.endInsertRows()
    #     return True
