import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: return_button
    implicitWidth: parent.width * 0.2
    implicitHeight: parent.width * 0.2

    radius: height / 2

    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: titleBar.height + 10
    anchors.rightMargin: 10

    color: 'transparent'

    property string return_button_png: '../images/return_button.png'

    Image {
        id: return_image
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.width * 0.6
        fillMode: Image.PreserveAspectFit
        mipmap: true
        source: return_button_png
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            return_button.color = '#fdf7e4'
        }

        onExited: {
            return_button.color = 'transparent'
        }

        onClicked: {
            stack.replace(log_page)
        }
    }
}