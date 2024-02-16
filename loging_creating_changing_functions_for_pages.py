import set_operations
import mysql.connector
import user_basic_info
from PySide6.QtCore import QObject, Slot, Signal
import main
import threading
from postgrest import APIError

QML_IMPORT_NAME = 'io.qt.textproperties'
QML_IMPORT_MAJOR_VERSION = 1


mydb = mysql.connector.connect(
    host='localhost',
    user='root',
    password='gfyu-Dfgs-MLon',
    database='qt_project'
)

mycursor = mydb.cursor()


class CheckForValidEmailPassword(QObject):
    def __init__(self):
        QObject.__init__(self)

    response = Signal(str)

    # checks for valid information while loging
    @Slot(str)
    def check_for_valid_info(self, t):
        t = t.split(',')
        login = t[0]
        password = t[1]
        session = None

        try:
            session = main.supabase.auth.sign_in_with_password({"email": f"{login}", "password": f"{password}"})
        except APIError:
            self.response.emit('not found')

        user_basic_info.UserData.user_id = session.user.id
        set_operations.LoadUserSets(user_basic_info.UserData.user_id).load_data()
        self.response.emit('found')


# creating new account in db
class CreateAccount(QObject):
    def __init__(self):
        QObject.__init__(self)

    createNewAccount = Signal(str)

    @staticmethod
    def create_account(email, password):
        main.supabase.auth.sign_up({'email': email, 'password': password, 'send_magic_link': True})

    @Slot(str)
    def create_new_account(self, t):
        t = t.split(',')
        email = t[0]
        password = t[1]

        t1 = threading.Thread(target=self.create_account, args=[email, password])
        t1.start()

        self.createNewAccount.emit('tru')


# checks if the user password and login are built correctly
class CheckEmailPassword(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.special_characters = [
            '!', '#', '$', '%', '^', '&', '*', '+', '=', '~', '`', '|', '\\', '/',
            ':', ';', '"', "'", '<', '>', ',', '?', '(', ')', '[', ']', '{', '}']

    check_data = Signal(str)

    @Slot(str)
    def check_email_forbidden(self, email):
        email = list(email)
        answer = None

        # checks if login field is field
        if len(email) == 0:
            self.check_data.emit('Email field is required')
        else:
            # checks if the submitted login contains forbidden special characters
            for i in email:
                if i in self.special_characters:
                    answer = False

            if not answer:
                self.check_data.emit('false_email')

            if answer is None:
                self.check_data.emit('no_email_issue')

    @Slot(str)
    def check_password_forbidden(self, password):
        password = list(password)
        answer = None

        # checks if password field is field
        if len(password) == 0:
            self.check_data.emit('Password field is required')
        else:
            # checks if the submitted password contains forbidden special characters
            for i in password:
                if i in self.special_characters:
                    answer = False

            if not answer:
                self.check_data.emit('false_password')

            if answer is None:
                self.check_data.emit('no_password_issue')