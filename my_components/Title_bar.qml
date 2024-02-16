import QtQuick
import QtQuick.Controls
import QtQuick.Layouts



Rectangle {
    id: titleBar
    parent: Overlay.overlay
    height: 35
    color: "#1e4258"
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.rightMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0

    // we need this for log page and create account page,
    // because we dont need maximize_restore_button to be shown on these pages

    property bool minimizeRestoreButtonVisible: true

    MouseArea {
        id: dragArea
        anchors.fill: parent
        property int mouseXPosition: 1
        property int mouseYPosition: 1

        onPressed: {
            mouseXPosition = mouse.x
            mouseYPosition = mouse.y
        }
        onPositionChanged: {

            window.showNormal()

            if (window.windowStatus === 1) {
                window.maximize_restore_button_image_source = "images/maximize_button.png"}
            window.windowStatus = 0

            window.x = window.x - (mouseXPosition - mouse.x)
            window.y = window.y - (mouseYPosition - mouse.y)
        }

    }

    Row {
        id: button_row
        anchors.right: parent.right
        spacing: 2

        Rectangle {
            id: minimize_button
            height: titleBar.height
            width: titleBar.height + 15
            color: 'transparent'
            Image {
                id: minimize_button_image
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: '../' + window.minimize_button_image_source

            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    minimize_button.color = '#265077'
                }

                onExited: {
                    minimize_button.color = 'transparent'
                }
                onClicked: {
                    window.maximize_restore_button_image_source = "images/maximize_button.png"
                    window.windowStatus = 0
                    window.showMinimized()
                }
            }
        }
        Rectangle {
            id: maximize_restore_button
            height: titleBar.height
            width: titleBar.height + 15
            color: 'transparent'


            visible: minimizeRestoreButtonVisible

            Image {
                id: maximize_restore_button_image
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: '../' + window.maximize_restore_button_image_source

            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    maximize_restore_button.color = '#265077'
                }

                onExited: {
                    maximize_restore_button.color = 'transparent'
                }
                onClicked: {
                    drawer.is_drawn = false
                    internal.maximize_restore()
                }
            }
        }
        Rectangle {
            id: close_button
            height: titleBar.height
            width: titleBar.height + 15
            color: 'transparent'
            Image {
                id: close_button_image
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: '../' + window.close_button_image_source

            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    close_button.color = '#c21807'
                }

                onExited: {
                    close_button.color = 'transparent'
                }
                onClicked: {
                    window.close()
                }
            }
        }

    }
}