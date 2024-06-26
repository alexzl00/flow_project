import main
from main_logic import user_basic_info
from itertools import groupby

from PySide6.QtCore import QObject, Slot, Signal
from GUI_logic import setsModel


class InsertSet(QObject):
    def __init__(self):
        QObject.__init__(self)

    insert_set = Signal(str)

    @staticmethod
    def insert_word_into_set(set_id, user_id, question, answer):
        data, count = main.supabase.table('word_sets').insert(
            {'user_id': user_id, 'set_id': set_id, 'question': question,
             'answer': answer}).execute()
        return data, count

    @Slot(str)
    def insert_set_cards(self, set_card):
        set_card = set_card.split(',')
        set_name = set_card[0]
        question = set_card[1]
        answer = set_card[2]

        try:
            set_id = user_basic_info.UserData.user_sets[set_name][0]['set_id']

            data, count = self.insert_word_into_set(set_id, user_basic_info.UserData.user_id, question, answer)
            card_id = data[1][0]['card_id']

            # user_basic_info.UserData.user_sets[set_name]\
            #     .append({'set_id': set_id, 'question': question, 'answer': answer, 'card_id': card_id})

            user_basic_info.UserData.user_sets[set_name]\
                .insert(0, {'set_id': set_id, 'question': question, 'answer': answer, 'card_id': card_id})
            print(user_basic_info.UserData.user_sets[set_name])
        except KeyError:
            data, count = main.supabase.table('sets').insert(
                {'user_id': user_basic_info.UserData.user_id, 'set_name': set_name}).execute()
            set_id = data[1][0]['set_id']

            data, count = self.insert_word_into_set(set_id, user_basic_info.UserData.user_id, question, answer)
            card_id = data[1][0]['card_id']

            user_basic_info.UserData.user_sets = \
                {set_name: [{'set_id': set_id, 'question': question, 'answer': answer, 'card_id': card_id}],
                 **user_basic_info.UserData.user_sets}
            user_basic_info.UserData.user_sets_description = \
                {set_name: {'bookmarked': False, 'time_bookmarked': None, 'set_id': set_id},
                 **user_basic_info.UserData.user_sets_description}
            user_basic_info.UserData.user_sets_description = setsModel.sort_user_sets_description(
                user_basic_info.UserData.user_sets_description)

        self.insert_set.emit('true')


class LoadUserSets:
    def __init__(self, user_id):
        self.user_id = user_id

    @staticmethod
    def load_data():
        result = (main.supabase.table('word_sets').
                  select('set_id, question, answer, card_id, sets(set_name)').
                  eq('user_id', user_basic_info.UserData.user_id).execute()).data
        # sorting the sets in the order from the newest to the oldest
        sorted_result = sorted(result, key=lambda x: (x['set_id']), reverse=True)

        # grouping the result by the set name
        grouped = dict(((key, list({k: v for k, v in i.items() if not isinstance(v, dict)} for i in group)[::-1])
                        for key, group in groupby(sorted_result, key=lambda x: x['sets']['set_name'])))
        user_basic_info.UserData.user_sets = grouped

        sets_description_query = (main.supabase.table('sets').
                                  select('set_name, bookmarked, time_bookmarked, set_id').
                                  eq('user_id', user_basic_info.UserData.user_id).execute()).data
        sets_description = {i['set_name']: {k: v for k, v in i.items() if k != 'set_name'} for i in sets_description_query}
        user_basic_info.UserData.user_sets_description = setsModel.sort_user_sets_description(sets_description)

        print(user_basic_info.UserData.user_sets)

