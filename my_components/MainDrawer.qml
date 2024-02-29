import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: drawer
    anchors.bottom: parent.bottom
    width: window.width * 0.1
    height: window.height - 35
    color: '#5cdb95'

    // properties
    property bool is_drawn: drawer.width === drawerWidthIfDrawn ? true : false

    property int drawerWidthIfDrawn: window.width * 0.2
    property int drawerWidthIfNotDrawn: window.width * 0.1

    function runDrawerAnimation(){
        animation_menu.running = true;
    }

    // button sources
    property string menu_button: '../images/menu_button.png'
    property string home_button: '../images/home_button.png'
    property string exercise_button: '../images/exercise_button.png'
    property string add_set_button: '../images/add_set_button.png'

    property int drawer_animation_duration: 1000

    // for the learning page, to catch if the learning button is clicked when this page is already loaded
    signal ifLearningPageSignal()


    ColumnLayout{
        id: drawer_layout
        spacing: 0
        Layout.alignment: Qt.AlignLeft && Qt.AlignTop

        PropertyAnimation {
            id: animation_menu
            target: drawer
            property: 'width'
            to: if(drawer.width == drawerWidthIfNotDrawn) return drawerWidthIfDrawn; else return drawerWidthIfNotDrawn
            duration: drawer.drawer_animation_duration
            easing.type: Easing.InOutQuint
        }

        Rectangle {
            id: menu
            implicitWidth: drawer.width
            implicitHeight: drawer.height * 0.1
            border.color: '#3aafa9'
            border.width: 2
            color: '#2b7a78'

            Image {
                width: menu.width
                height: menu.height
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: drawer.menu_button
            }

            MouseArea {
                id: menu_area
                anchors.fill: menu
                hoverEnabled: true

                onEntered: {
                    menu.color = '#00887a'

                }
                onExited: {
                    menu.color = '#2b7a78'
                }

                onClicked: {
                    animation_menu.running = true
                    menu_area.enabled = false
                    drawer_animation_timer.running = true
                }
            }
        }
        Timer {
            id: drawer_animation_timer
            interval: drawer.drawer_animation_duration
            running: false
            repeat: false

            onTriggered: {
                menu_area.enabled = true
            }
        }
        Rectangle {
            id: home_button
            implicitWidth: drawer.width
            implicitHeight: drawer.height * 0.1
            border.color: '#3aafa9'
            border.width: 2
            color: '#2b7a78'

            Image {
                width: home_button.width
                height: home_button.height
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: drawer.home_button
            }

            MouseArea {
                id: home_button_area
                anchors.fill: home_button
                hoverEnabled: drawer.is_drawn
                enabled: drawer.is_drawn
                onEntered: {
                    home_button.color = '#00887a'
                }
                onExited: {
                    home_button.color = '#2b7a78'
                }
                onClicked: {
                    stack.replace(main_flow_page)
                }
            }
        }
        Rectangle {
            id: exercise_button
            implicitWidth: drawer.width
            implicitHeight: drawer.height * 0.1
            border.color: '#3aafa9'
            border.width: 2
            color: '#2b7a78'

            Image {
                width: exercise_button.width
                height: exercise_button.height
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: drawer.exercise_button
            }

            MouseArea {
                id: exercise_button_area
                anchors.fill: exercise_button
                hoverEnabled: drawer.is_drawn
                enabled: drawer.is_drawn
                onEntered: {
                    exercise_button.color = '#00887a'
                }
                onExited: {
                    exercise_button.color = '#2b7a78'
                }
                onClicked: {
                    stack.replace(learning_page)
                    ifLearningPageSignal()
                }
            }
        }
        Rectangle {
            id: add_set_button
            implicitWidth: drawer.width
            implicitHeight: drawer.height * 0.1
            border.color: '#3aafa9'
            border.width: 2
            color: '#2b7a78'

            Image {
                width: parent.width * 0.8
                height: parent.height * 0.8
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: drawer.add_set_button
            }

            MouseArea {
                id: add_set_button_area
                anchors.fill: add_set_button
                hoverEnabled: drawer.is_drawn
                enabled: drawer.is_drawn
                onEntered: {
                    add_set_button.color = '#00887a'
                }
                onExited: {
                    add_set_button.color = '#2b7a78'
                }
                onClicked: {
                    stack.replace(add_set_page)
                }

            }
        }
    }
}

