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

        Text {
            id: show_hide_answer_text
            leftPadding: 10
            rightPadding: 10
            bottomPadding: 10
            topPadding: 10
            anchors.right: parent.right
            anchors.top: parent.top
            text: 'Show answer'
            font.family: "Arial"
            font.pixelSize: 16
            z: 3
            MouseArea {
                id: show_hide_answer_text_area
                height: show_hide_answer_text.height
                width: show_hide_answer_text.width
                hoverEnabled: true

                onEntered: {
                    show_hide_answer_text.color = "blue"
                    show_hide_answer_text.font.underline = true
                }

                onExited: {
                    show_hide_answer_text.color = "black"
                    show_hide_answer_text.font.underline = false
                }
                onClicked: {
                    view_of_cards.answer_visible = false
                }

            }
        }





        SwipeView {
            id: view_of_cards
            interactive: true
            currentIndex: 0
            anchors.fill: parent
            property bool answer_visible: true

            Repeater{
                id: repeater
                model: CardForTest {}
                Loader {
                    active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: 'transparent'
                        Column {
                            spacing: 10
                            anchors.centerIn: parent
                            Text {
                                id: question
                                text: model.question
                            }
                            Text {
                                id: answer
                                text: model.answer
                                visible: view_of_cards.answer_visible
                            }
                        }
                    }
                }
            }

        }
    }

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

}