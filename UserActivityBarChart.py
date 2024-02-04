import functools

from PySide6 import QtCharts
from PySide6.QtCore import Qt, QObject, Signal, Property, Slot
from PySide6.QtGui import QStandardItemModel, QStandardItem
import main
from datetime import datetime, timedelta
import user_basic_info


class ChartManager(QObject):
    seriesChanged = Signal()

    def __init__(self):
        super().__init__()
        self._series = QtCharts.QPercentBarSeries(self)
        self.populate_series()

    def get_series(self):
        return self._series

    series = Property(QtCharts.QAbstractBarSeries, get_series, notify=seriesChanged)

    def populate_series(self):

        categories = ['category1', 'category2']
        values = [20, 40]

        model = QStandardItemModel()
        for category, value in zip(categories, values):
            item = QStandardItem(category)
            item.setData(value, Qt.DisplayRole)
            model.appendRow(item)

        self._series.setLabelsVisible(True)
        self.seriesChanged.emit()


class Chart(QObject):
    def __init__(self):
        super().__init__()
        # dictionary with values and categories for BarSeries in Test_page.qml
        self._val_cat = {}

        self.current_date = datetime.now().strftime("%Y/%m/%d")
        self.last_week = datetime.strptime(self.current_date, "%Y/%m/%d") + timedelta(days=-6)

    # we need to use the functools.cache, in order to avoid sending two times query and render the data
    # when Property values and Property categories are called in qml
    @functools.cache
    def render_data(self):
        query = 'SELECT day_of_using, SUM(TIME_TO_SEC(time_of_using))' \
                ' FROM user_screen_time WHERE user_id = %s and day_of_using > %s GROUP BY 1'
        main.mycursor.execute(query, (user_basic_info.UserData.user_id, self.last_week))

        results = main.mycursor.fetchall()

        for day in range(0, 7):
            # the previous dates
            date = datetime.strftime(self.last_week + timedelta(days=day), "%Y/%m/%d")

            # setting all previous dates
            self._val_cat[date] = 0

        # setting screen time to previous dates
        for result in results:
            # screen time is in hours converted from seconds
            screen_time = int(result[1]) / 3600

            # the date of screen time
            date = datetime.strftime(result[0], "%Y/%m/%d")

            # saves the day of week with the screen time on that day in seconds
            self._val_cat[date] = screen_time

    @Property(list)
    def values(self):
        # fills the self._val_cat with data
        self.render_data()
        return list(self._val_cat.values())

    @Property(list)
    def categories(self):
        # fills the self._val_cat with data
        self.render_data()
        return list(self._val_cat.keys())

