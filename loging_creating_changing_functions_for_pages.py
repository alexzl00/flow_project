import set_operations
import mysql.connector
import user_basic_info
from PySide6.QtCore import QObject, Slot, Signal

QML_IMPORT_NAME = 'io.qt.textproperties'
QML_IMPORT_MAJOR_VERSION = 1


mydb = mysql.connector.connect(
    host='localhost',
    user='root',
    password='gfyu-Dfgs-MLon',
    database='qt_project'
)

mycursor = mydb.cursor()


class CheckForValidLoginPassword(QObject):
    def __init__(self):
        QObject.__init__(self)

    response = Signal(str)

    # checks for valid information while loging
    @Slot(str)
    def check_for_valid_info(self, t):
        t = t.split(',')
        login = t[0]
        password = t[1]
        query = 'SELECT id, user_login, user_password FROM user WHERE user_login = %s and user_password = %s'
        mycursor.execute(query, (login, password,))
        result = mycursor.fetchone()
        if result is not None:
            self.response.emit('found')
            user_basic_info.UserData.user_id = result[0]
            set_operations.LoadUserSets(user_basic_info.UserData.user_id).load_data()
        else:
            self.response.emit('not found')

    # checks if login is already taken while creating account
    @Slot(str)
    def check_if_login_not_taken(self, login):
        query = 'SELECT user_login FROM user WHERE user_login = %s'
        mycursor.execute(query, (login, ))
        result = mycursor.fetchone()
        if result is not None:
            self.response.emit('login is taken')
        else:
            self.response.emit('login not taken')


# creating new account in db
class CreateAccount(QObject):
    def __init__(self):
        QObject.__init__(self)

    createNewAccount = Signal(str)

    @Slot(str)
    def create_new_account(self, t):
        t = t.split(',')
        login = t[0]
        password = t[1]
        query = 'INSERT INTO user(user_login, user_password) VALUES (%s, %s)'
        mycursor.execute(query, (login, password))
        mydb.commit()
        self.createNewAccount.emit('tru')


# checks if the user password and login are built correctly
class CheckLoginPassword(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.special_characters = [
            '!', '@', '#', '$', '%', '^', '&', '*', '+', '=', '~', '`', '|', '\\', '/',
            ':', ';', '"', "'", '<', '>', ',', '?', '(', ')', '[', ']', '{', '}']

    check_data = Signal(str)

    @Slot(str)
    def check_login(self, login):
        login = list(login)
        answer = None

        # checks if login field is field
        if len(login) == 0:
            self.check_data.emit('Login field is required')
        else:
            # checks if the submitted login contains forbidden special characters
            for i in login:
                if i in self.special_characters:
                    answer = False

            if not answer:
                self.check_data.emit('false_login')

            if answer is None:
                self.check_data.emit('no_login_issue')

    @Slot(str)
    def check_password(self, password):
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