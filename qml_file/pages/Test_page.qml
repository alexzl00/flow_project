import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../../my_components'
import MyModel_py 1.0


Rectangle {
    id: test_page
    anchors.fill: parent
    implicitWidth: parent
    implicitHeight: parent
    gradient: Gradient{
        GradientStop{position: 0.0; color: '#5cdb95'}
        GradientStop{position: 0.7; color: '#379683'}
    }

    property string current_index_of_set: ""

    Title_bar {
        id: titleBar
    }

    MainDrawer {
        id: drawer
    }

    Rectangle {
        id: rec_for_view
        implicitWidth: test_page.width * 0.3
        implicitHeight: test_page.height * 0.5
        anchors.centerIn: parent
        color: '#ffffff'
        radius: 10
        clip: true

        SwipeView {
            id: view_of_cards
            interactive: true
            currentIndex: 0
            anchors.fill: parent

            Repeater{
                id: repeater
                model: MyModel {}
                Loader {
                    active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: 'transparent'
                        Text {
                            anchors.centerIn: parent
                            text: display
                        }
                    }
                }
            }

        }
    }
/*
    SwipeView {
        id: view_of_cards
        anchors.centerIn: parent
        interactive: true
        currentIndex: 0
        implicitWidth: test_page.width * 0.3
        implicitHeight: test_page.height * 0.5

        Repeater{
            id: repeater
            model: MyModel {}
            delegate: Item {
                height: view_of_cards.height
                width: view_of_cards.width

                Rectangle {
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    color: '#ffffff'
                    radius: 10
                    Text {
                        anchors.centerIn: parent
                        text: display
                    }
                }
            }
        }
    }
*/

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.05

        Rectangle {
            id: return_button
            implicitWidth: test_page.width * 0.08
            implicitHeight: test_page.height * 0.08
            color: '#ffffff'
            radius: 10

            Text {
                anchors.centerIn: return_button
                text: 'Return'
            }

            MouseArea {
                id: return_button_area
                anchors.fill: return_button
                hoverEnabled: true

                onEntered: {
                    return_button.color = '#C0C0C0'

                }
                onExited: {
                    return_button.color = '#ffffff'
                }

                onClicked: {
                    if (view_of_cards.currentIndex > 0) {
                    view_of_cards.currentIndex = view_of_cards.currentIndex - 1}
                }

            }
        }

        Rectangle {
            id: bad_button
            implicitWidth: test_page.width * 0.08
            implicitHeight: test_page.height * 0.08
            color: '#ffffff'
            radius: 10

            Text {
                anchors.centerIn: bad_button
                text: 'Bad'
            }

            MouseArea {
                id: bad_button_area
                anchors.fill: bad_button
                hoverEnabled: true

                onEntered: {
                    bad_button.color = '#C0C0C0'

                }
                onExited: {
                    bad_button.color = '#ffffff'
                }

                onClicked: {
                    if (view_of_cards.count > view_of_cards.currentIndex + 1) {
                        view_of_cards.currentIndex = view_of_cards.currentIndex + 1
                    }
                }

            }
        }

        Rectangle {
            id: good_button
            implicitWidth: test_page.width * 0.08
            implicitHeight: test_page.height * 0.08
            color: '#ffffff'
            radius: 10

            Text {
                anchors.centerIn: good_button
                text: 'Good'
            }

            MouseArea {
                id: good_button_button_area
                anchors.fill: good_button
                hoverEnabled: true

                onEntered: {
                    good_button.color = '#C0C0C0'

                }
                onExited: {
                    good_button.color = '#ffffff'
                }

                onClicked: {
                    if (view_of_cards.count > view_of_cards.currentIndex + 1) {
                        view_of_cards.currentIndex = view_of_cards.currentIndex + 1
                    }
                }

            }
        }

        Rectangle {
            id: excellent_button
            implicitWidth: test_page.width * 0.08
            implicitHeight: test_page.height * 0.08
            color: '#ffffff'
            radius: 10

            Text {
                anchors.centerIn: excellent_button
                text: 'Excellent'
            }

            MouseArea {
                id: excellent_button_area
                anchors.fill: excellent_button
                hoverEnabled: true

                onEntered: {
                    excellent_button.color = '#C0C0C0'

                }
                onExited: {
                    excellent_button.color = '#ffffff'
                }

                onClicked: {
                    if (view_of_cards.count > view_of_cards.currentIndex + 1) {
                        view_of_cards.currentIndex = view_of_cards.currentIndex + 1
                    }
                }

            }
        }

    }
    Component.onCompleted: {repeater.model.wordlist_of_set(window.chosen_set_of_cards) }
}