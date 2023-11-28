
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, QmlElement, qmlRegisterType
import sys
import os
import loging_creating_changing_functions_for_pages
import set_operations

QML_IMPORT_NAME = 'io.qt.textproperties'
QML_IMPORT_MAJOR_VERSION = 1


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    check = loging_creating_changing_functions_for_pages.CheckForValidLoginPassword()
    engine.rootContext().setContextProperty("check_for_valid_login_password", check)

    create = loging_creating_changing_functions_for_pages.CreateAccount()
    engine.rootContext().setContextProperty('create_account', create)

    login_password = loging_creating_changing_functions_for_pages.CheckLoginPassword()
    engine.rootContext().setContextProperty('check_login_password', login_password)

    set_op = set_operations.InsertSet()
    engine.rootContext().setContextProperty('set_op', set_op)

    # # user sets to choose
    # my_model = set_operations.MyModel()
    # engine.rootContext().setContextProperty("myModel", my_model)

    # my_model = set_operations.SetUserSetsModel()
    # engine.rootContext().setContextProperty('myModel', my_model)

    engine.load(os.path.join(os.path.dirname(__file__), "qml_file/Flow_app.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())


