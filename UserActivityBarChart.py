import functools
from PySide6.QtCore import QObject, Property
import main
from itertools import groupby
from datetime import datetime, timedelta
import user_basic_info


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
        data = main.supabase.table('user_screen_time').select(f'day_of_using, time_of_using').\
            eq('user_id', user_basic_info.UserData.user_id).gt('day_of_using', self.last_week).execute().data

        grouped_data = ([key, sum(time['time_of_using'] for time in list(grouped))]
                        for key, grouped in groupby(data, key=lambda x: x['day_of_using']))

        for day in range(0, 7):
            # the previous dates
            date = datetime.strftime(self.last_week + timedelta(days=day), "%Y-%m-%d")

            # setting all previous dates
            self._val_cat[date] = 0

        # setting screen time to previous dates
        for i in grouped_data:
            # screen time is in hours converted from seconds
            # i[1] these are seconds in type int
            screen_time = round(i[1] / 3600, 2)

            # saves the day of week with the screen time on that day in seconds
            # i[0] is day of using type str
            self._val_cat[i[0]] = screen_time

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

