import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import 'drawer_button_component'

Rectangle {
    id: drawer
    anchors.bottom: parent.bottom
    width: window.width * 0.1
    height: window.height - 35
    color: '#5cdb95'

    // properties
    property bool is_drawn: drawer.width === drawerWidthIfDrawn ? true : false

    property int drawerWidthIfDrawn: window.width * 0.15
    property int drawerWidthIfNotDrawn: window.width * 0.1

    function runDrawerAnimation(){
        animation_menu.running = true;
    }

    // button sources
    property string menu_button: '../images/menu_button.svg'
    property string home_button: '../images/home_button.svg'
    property string exercise_button: '../images/exercise_button.svg'
    property string add_set_button: '../images/add_set_button.svg'

    property int drawer_animation_duration: 1000

    // for the learning page, to catch if the learning button is clicked when this page is already loaded
    signal ifLearningPageSignal()


    ColumnLayout{
        id: drawer_layout
        spacing: -menu.border.width
        Layout.alignment: Qt.AlignLeft && Qt.AlignTop

        PropertyAnimation {
            id: animation_menu
            target: drawer
            property: 'width'
            to: if(drawer.width == drawerWidthIfNotDrawn) return drawerWidthIfDrawn; else return drawerWidthIfNotDrawn
            duration: drawer.drawer_animation_duration
            easing.type: Easing.InOutQuint
        }

        Custom_drawer_button {
            id: menu

            image_source: '../' + drawer.menu_button

            MouseArea {
                id: menu_area
                anchors.fill: menu
                hoverEnabled: true

                onEntered: {
                    menu.color = menu.on_hover_color
                }
                onExited: {
                    menu.color = menu.main_color
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
        Custom_drawer_button {
            id: home_button

            image_source: '../' + drawer.home_button

            MouseArea {
                id: home_button_area
                anchors.fill: home_button
                hoverEnabled: drawer.is_drawn
                enabled: drawer.is_drawn
                onEntered: {
                    home_button.color = home_button.on_hover_color
                }
                onExited: {
                    home_button.color = home_button.main_color
                }
                onClicked: {
                    stack.replace(main_flow_page)
                }
            }
        }
        Custom_drawer_button {
            id: exercise_button

            image_source: '../' + drawer.exercise_button

            MouseArea {
                id: exercise_button_area
                anchors.fill: exercise_button
                hoverEnabled: drawer.is_drawn
                enabled: drawer.is_drawn
                onEntered: {
                    exercise_button.color = exercise_button.on_hover_color
                }
                onExited: {
                    exercise_button.color = exercise_button.main_color
                }
                onClicked: {
                    stack.replace(learning_page)
                    ifLearningPageSignal()
                }
            }
        }
        Custom_drawer_button {
            id: add_set_button

            image_source: '../' + drawer.add_set_button

            MouseArea {
                id: add_set_button_area
                anchors.fill: add_set_button
                hoverEnabled: drawer.is_drawn
                enabled: drawer.is_drawn
                onEntered: {
                    add_set_button.color = add_set_button.on_hover_color
                }
                onExited: {
                    add_set_button.color = add_set_button.main_color
                }
                onClicked: {
                    stack.replace(add_set_page)
                }

            }
        }
    }
}

