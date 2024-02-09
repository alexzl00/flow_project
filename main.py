import mysql.connector
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, QmlElement, qmlRegisterType
import sys
import os

from PySide6.QtWidgets import QApplication
from postgrest import APIError

import loging_creating_changing_functions_for_pages
import set_operations
import UserActivityBarChart
import tracking_user_activity
from datetime import datetime


from supabase import create_client, Client
from dotenv import load_dotenv
load_dotenv()

# it is not shown to be used, but it is needed indeed, otherwise program exits -1
import setsModel

QML_IMPORT_NAME = 'io.qt.textproperties'
QML_IMPORT_MAJOR_VERSION = 1

mydb = mysql.connector.connect(
    host='localhost',
    user='root',
    password='gfyu-Dfgs-MLon',
    database='qt_project'
)

mycursor = mydb.cursor()

url: str = os.environ.get("SUPABASE_URL")
key: str = os.environ.get("SUPABASE_KEY")
supabase: Client = create_client(url, key)


if __name__ == "__main__":

    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    start_of_session = datetime.now().strftime("%Y/%m/%d %H:%M")
    tracking_user_activity.StartOfSession.start_of_session = start_of_session

    check = loging_creating_changing_functions_for_pages.CheckForValidEmailPassword()
    engine.rootContext().setContextProperty("check_for_valid_email_password", check)

    create = loging_creating_changing_functions_for_pages.CreateAccount()
    engine.rootContext().setContextProperty('create_account', create)

    login_password = loging_creating_changing_functions_for_pages.CheckEmailPassword()
    engine.rootContext().setContextProperty('check_email_password', login_password)

    bar_chart = UserActivityBarChart.Chart()
    engine.rootContext().setContextProperty('chart', bar_chart)

    set_op = set_operations.InsertSet()
    engine.rootContext().setContextProperty('set_op', set_op)

    engine.load(os.path.join(os.path.dirname(__file__), "qml_file/Flow_app.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
