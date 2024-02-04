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


    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Rectangle {
            id: custom_result_indicator_rec
            implicitHeight: test_page.height * 0.01
            implicitWidth: test_page.width * 0.3

            property int number_of_cards: view_of_cards.count

            property list<int> list_of_green: []
            property list<int> list_of_orange: []
            property list<int> list_of_red: []

            CustomPaintedItem {
                id: custom_result_indicator
                anchors.fill: parent
            }

        }

        Rectangle {
            id: rec_for_view
            implicitWidth: test_page.width * 0.3
            implicitHeight: test_page.height * 0.5

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
                        if(view_of_cards.answer_visible === false) {
                            view_of_cards.answer_visible = true
                            show_hide_answer_text.text = "Hide answer"
                        }
                        else {
                            view_of_cards.answer_visible = false
                            show_hide_answer_text.text = 'Show answer'
                        }
                    }

                }
            }

            Rectangle {
                id: play_sound_button
                implicitWidth: test_page.width * 0.08
                implicitHeight: test_page.height * 0.08
                color: 'salmon'
                radius: 10
                z: 3

                Text {
                    id: play_sound_button_text
                    anchors.centerIn: play_sound_button
                    text: 'play sound'
                }

                MouseArea {
                    id: play_sound_button_area
                    anchors.fill: play_sound_button
                    hoverEnabled: true

                    onEntered: {
                        play_sound_button.color = '#C0C0C0'

                    }
                    onExited: {
                        play_sound_button.color = 'salmon'
                    }

                    onClicked: {
                        repeater.model.text_to_speech(view_of_cards.currentIndex)
                    }
                }
            }

            // indicates what was your previous answer an that question
            Rectangle {
                id: result_indicator_color
                implicitHeight: parent.height * 0.1
                implicitWidth: result_indicator_color.height
                radius: result_indicator_color.height / 2

                color: custom_result_indicator_rec.list_of_green.indexOf(view_of_cards.currentIndex) !== -1 ? colorModel.get(0).green :
                       custom_result_indicator_rec.list_of_orange.indexOf(view_of_cards.currentIndex) !== -1 ? colorModel.get(1).orange :
                       custom_result_indicator_rec.list_of_red.indexOf(view_of_cards.currentIndex) !== -1 ? colorModel.get(2).red :
                       colorModel.get(3).grey


                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 10
            }


            SwipeView {
                id: view_of_cards
                interactive: true
                currentIndex: 0
                anchors.fill: parent
                property bool answer_visible: false

                onCurrentIndexChanged: {
                    view_of_cards.answer_visible = false
                    custom_result_indicator.set_proportion([custom_result_indicator_rec.list_of_green.length, custom_result_indicator_rec.list_of_orange.length, custom_result_indicator_rec.list_of_red.length, custom_result_indicator_rec.number_of_cards - custom_result_indicator_rec.list_of_green.length - custom_result_indicator_rec.list_of_orange.length - custom_result_indicator_rec.list_of_red.length])
                }

                Repeater{
                    id: repeater
                    model: CardForTest {}
                    Loader {
                        active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                        Rectangle {
                            id: text_container
                            width: parent.width
                            height: parent.height

                            color: 'transparent'

                            z: 2

                            Column {
                                spacing: 10
                                anchors.centerIn: parent
                                Text {
                                    id: question
                                    text: model.question
                                    width: text_container.width * 0.8
                                    wrapMode: Text.WordWrap
                                }
                                Text {
                                    id: answer
                                    text: model.answer
                                    width: text_container.width * 0.8
                                    wrapMode: Text.WordWrap
                                    visible: view_of_cards.answer_visible
                                }
                            }
                        }
                    }
                }

                ListModel {
                    id: colorModel
                    ListElement {green: '#008000'}
                    ListElement {orange: '#FFA500'}
                    ListElement {red: '#FF0000'}
                    ListElement {grey: '#808080'}
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

                    var index_of_red = custom_result_indicator_rec.list_of_red.indexOf(view_of_cards.currentIndex)
                    if (index_of_red === -1) {
                        custom_result_indicator_rec.list_of_red.push(view_of_cards.currentIndex)

                        var index_of_green = custom_result_indicator_rec.list_of_green.indexOf(view_of_cards.currentIndex)
                        if (index_of_green !== -1) {
                            custom_result_indicator_rec.list_of_green.splice(index_of_green, 1)
                        }

                        var index_of_orange = custom_result_indicator_rec.list_of_orange.indexOf(view_of_cards.currentIndex)
                        if (index_of_orange !== -1) {
                            custom_result_indicator_rec.list_of_orange.splice(index_of_orange, 1)
                        }
                    }

                    if (view_of_cards.count > view_of_cards.currentIndex + 1) {
                        view_of_cards.currentIndex = view_of_cards.currentIndex + 1
                    }

                    else {
                        view_of_cards.currentIndex = 0
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

                    var index_of_orange = custom_result_indicator_rec.list_of_orange.indexOf(view_of_cards.currentIndex)
                    if (index_of_orange === -1) {
                        custom_result_indicator_rec.list_of_orange.push(view_of_cards.currentIndex)

                        var index_of_green = custom_result_indicator_rec.list_of_green.indexOf(view_of_cards.currentIndex)
                        if (index_of_green !== -1) {
                            custom_result_indicator_rec.list_of_green.splice(index_of_green, 1)
                        }

                        var index_of_red = custom_result_indicator_rec.list_of_red.indexOf(view_of_cards.currentIndex)
                        if (index_of_red !== -1) {
                            custom_result_indicator_rec.list_of_red.splice(index_of_red, 1)
                        }
                    }

                    if (view_of_cards.count > view_of_cards.currentIndex + 1) {
                        view_of_cards.currentIndex = view_of_cards.currentIndex + 1
                    }
                    else {
                        view_of_cards.currentIndex = 0
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

                    var index_of_green = custom_result_indicator_rec.list_of_green.indexOf(view_of_cards.currentIndex)
                    if (index_of_green === -1) {
                        custom_result_indicator_rec.list_of_green.push(view_of_cards.currentIndex)

                        var index_of_orange = custom_result_indicator_rec.list_of_orange.indexOf(view_of_cards.currentIndex)
                        if (index_of_orange !== -1) {
                            custom_result_indicator_rec.list_of_orange.splice(index_of_orange, 1)
                        }

                        var index_of_red = custom_result_indicator_rec.list_of_red.indexOf(view_of_cards.currentIndex)
                        if (index_of_red !== -1) {
                            custom_result_indicator_rec.list_of_red.splice(index_of_red, 1)
                        }
                    }

                    if (view_of_cards.count > view_of_cards.currentIndex + 1) {
                        view_of_cards.currentIndex = view_of_cards.currentIndex + 1
                    }
                    else {
                        view_of_cards.currentIndex = 0
                    }
                }

            }
        }

    }
    Component.onCompleted: {
        repeater.model.cards_for_test(window.chosen_set_of_cards)
    }

}