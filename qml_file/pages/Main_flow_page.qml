import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../../my_components'

Rectangle{
    id: main_flow_page
    anchors.fill: parent
    implicitWidth: parent
    implicitHeight: parent
    gradient: Gradient{
        GradientStop{position: 0.0; color: '#5cdb95'}
        GradientStop{position: 0.7; color: '#379683'}
    }

    Title_bar{
        id: titleBar
    }

    ColumnLayout {
        anchors.centerIn: parent

        TextField {
            id: new_login_field
            font.bold: false
            font.pointSize: 20
            placeholderText: 'Set your login'
            maximumLength: 15

            background: Rectangle{
                id: log_f
                radius: 10
                implicitWidth: window.width * 0.2
            }
        }
    }
    // from MainDrawer.qml
    MainDrawer {
        id: drawer
    }

}