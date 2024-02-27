import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../../my_components'
import MyModel_py 1.0
import QtQuick.Shapes



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

    property string volume_button_png: '../../images/volume_button.png'

    property string sad_face_button_png: '../../images/sad_button.png' // for bad_button
    property string neutral_face_button_png: '../../images/neutral_button.png' // for good_button
    property string happy_face_button_png: '../../images/happy_button.png' // for excellent_button
    property string return_button_png: '../../images/return_button.png' // for return_button


    Title_bar {
        id: titleBar
    }

    MainDrawer {
        id: drawer
    }


    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        Rectangle {
            id: custom_result_indicator_rec
            implicitHeight: test_page.height * 0.01
            implicitWidth: rec_for_view.width * 0.9
            Layout.alignment: Qt.AlignHCenter
            color: 'transparent'
            radius: 10
            clip: true

            property int number_of_cards: view_of_cards.count

            property list<int> list_of_green: []
            property list<int> list_of_orange: []
            property list<int> list_of_red: []

            RowLayout {
                anchors.centerIn: parent
                implicitWidth: parent.width
                implicitHeight: parent.height

                property int rec_radius: 10
                spacing: 0

                Result_indicator_shape {
                    id: advancedShapeGreen
                    implicitWidth: custom_result_indicator_rec.list_of_green.length / custom_result_indicator_rec.number_of_cards * custom_result_indicator_rec.width
                    implicitHeight: custom_result_indicator_rec.height

                    tlRadius: advancedShapeGreen.height / 2
                    trRadius: (advancedShapeOrange.width === 0 && advancedShapeRed.width === 0 && advancedShapeGrey.width === 0) ? advancedShapeGreen.height / 2 : 0
                    brRadius: (advancedShapeOrange.width === 0 && advancedShapeRed.width === 0 && advancedShapeGrey.width === 0) ? advancedShapeGreen.height / 2 : 0
                    blRadius: advancedShapeGreen.height / 2

                    fill_color: colorModel.get(0).green
                }

                Result_indicator_shape {
                    id: advancedShapeOrange
                    implicitWidth: custom_result_indicator_rec.list_of_orange.length / custom_result_indicator_rec.number_of_cards * custom_result_indicator_rec.width
                    implicitHeight: custom_result_indicator_rec.height

                    tlRadius: advancedShapeGreen.width === 0 ? advancedShapeOrange.height / 2 : 0
                    trRadius: (advancedShapeRed.width === 0 && advancedShapeGrey.width === 0) ? advancedShapeOrange.height / 2 : 0
                    brRadius: (advancedShapeRed.width === 0 && advancedShapeGrey.width === 0) ? advancedShapeOrange.height / 2 : 0
                    blRadius: advancedShapeGreen.width === 0 ? advancedShapeOrange.height / 2 : 0

                    fill_color: colorModel.get(1).orange
                }

                Result_indicator_shape {
                    id: advancedShapeRed
                    implicitWidth: custom_result_indicator_rec.list_of_red.length / custom_result_indicator_rec.number_of_cards * custom_result_indicator_rec.width
                    implicitHeight: custom_result_indicator_rec.height

                    tlRadius: (advancedShapeGreen.width === 0 && advancedShapeOrange.width === 0) ? advancedShapeRed.height / 2 : 0
                    trRadius: (advancedShapeGrey.width === 0) ? advancedShapeRed.height / 2 : 0
                    brRadius: (advancedShapeGrey.width === 0) ? advancedShapeRed.height / 2 : 0
                    blRadius: (advancedShapeGreen.width === 0 && advancedShapeOrange.width === 0) ? advancedShapeRed.height / 2 : 0

                    fill_color: colorModel.get(2).red
                }

                Result_indicator_shape {
                    id: advancedShapeGrey
                    implicitWidth: grey_length / custom_result_indicator_rec.number_of_cards * custom_result_indicator_rec.width
                    implicitHeight: custom_result_indicator_rec.height

                    property int grey_length: custom_result_indicator_rec.number_of_cards - custom_result_indicator_rec.list_of_green.length - custom_result_indicator_rec.list_of_orange.length - custom_result_indicator_rec.list_of_red.length

                    tlRadius: (advancedShapeGreen.width === 0 && advancedShapeOrange.width === 0 && advancedShapeRed.width === 0) ? advancedShapeGrey.height / 2 : 0

                    // it's default value for grey rectangle since it on the right, so when it appears, it should be always rounded
                    trRadius: advancedShapeGrey.height / 2
                    brRadius: advancedShapeGrey.height / 2

                    blRadius: (advancedShapeGreen.width === 0 && advancedShapeOrange.width === 0 && advancedShapeRed.width === 0) ? advancedShapeGrey.height / 2 : 0

                    fill_color: '#C0C0C0' // grey
                }

            }
        }

        Rectangle {
            id: rec_for_view
            implicitWidth: test_page.width * 0.3
            implicitHeight: test_page.height * 0.5

            color: 'transparent'
            radius: 10
            clip: true

            SwipeView {
                id: view_of_cards
                interactive: false
                currentIndex: 0
                anchors.fill: parent

                Repeater{
                    id: repeater
                    model: CardForTest {}
                    delegate: Loader {
                        active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                        Rectangle {
                            id: card_holder
                            width: rec_for_view.width
                            height: rec_for_view.height
                            radius: 20
                            z: 3
                            color: 'transparent'
                            clip: true

                            property int itemIndex: index

                            Flipable {
                                id: flipable
                                width: parent.width * 0.9
                                height: parent.height * 0.9
                                anchors.centerIn: parent

                                property bool flipped: false

                                front: Rectangle {
                                    id: question_holder
                                    width: parent.width
                                    height: parent.height
                                    color: '#fdf7e4'
                                    // radius: flipable.flipped ? 0 : 20
                                    radius: 20
                                    antialiasing: true
                                    z: 2

                                    Rectangle {
                                        id: play_sound_button
                                        implicitWidth: parent.height * 0.15
                                        implicitHeight: parent.height * 0.15
                                        color: 'transparent'
                                        radius: play_sound_button.width / 2
                                        z: 3

                                        Image {
                                            anchors.centerIn: parent
                                            width: parent.width * 0.6
                                            height: parent.height
                                            fillMode: Image.PreserveAspectFit
                                            mipmap: true
                                            source: test_page.volume_button_png
                                        }

                                        MouseArea {
                                            id: play_sound_button_area
                                            anchors.fill: play_sound_button
                                            hoverEnabled: true

                                            onEntered: {
                                                play_sound_button.color = '#e6dac7'

                                            }
                                            onExited: {
                                                play_sound_button.color = 'transparent'
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

                                        color: custom_result_indicator_rec.list_of_green.indexOf(card_holder.itemIndex) !== -1 ? colorModel.get(0).green :
                                               custom_result_indicator_rec.list_of_orange.indexOf(card_holder.itemIndex) !== -1 ? colorModel.get(1).orange :
                                               custom_result_indicator_rec.list_of_red.indexOf(card_holder.itemIndex) !== -1 ? colorModel.get(2).red :
                                               colorModel.get(3).grey


                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.bottomMargin: 10
                                    }

                                    Rectangle {
                                        width: parent.width
                                        height: 1
                                        color: '#36454F'

                                        anchors.top: question_flickable.top

                                        antialiasing: true
                                    }

                                    Rectangle {
                                        width: parent.width
                                        height: 1
                                        color: '#36454F'

                                        anchors.bottom: question_flickable.bottom

                                        antialiasing: true
                                    }

                                    Flickable {
                                        id: question_flickable
                                        width: question_holder.width * 0.8
                                        height: parent.height * 0.7

                                        contentWidth: question.width
                                        contentHeight: question.height

                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter

                                        anchors.leftMargin: 12

                                        clip: true


                                        boundsBehavior: Flickable.StopAtBounds

                                        Text {
                                            id: question

                                            text: model.question
                                            width: question_flickable.width
                                            wrapMode: Text.Wrap
                                            font.pixelSize: Math.min(window.width / 50, window.height / 50)
                                        }
                                    }

                                    Behavior on radius {
                                        PropertyAnimation {
                                            duration: 800; easing.type: Easing.InOutQuad
                                        }
                                    }
                                }


                                back: Rectangle {
                                    id: answer_holder
                                    color: '#fdf7e4'
                                    width: parent.width
                                    height: parent.height
                                    // radius: flipable.flipped ? 20 : 0
                                    radius: 20
                                    antialiasing: true
                                    z: 2

                                    Rectangle {
                                        width: parent.width
                                        height: 1
                                        color: '#36454F'

                                        anchors.top: answer_flickable.top

                                        antialiasing: true
                                    }

                                    Rectangle {
                                        width: parent.width
                                        height: 1
                                        color: '#36454F'

                                        anchors.bottom: answer_flickable.bottom

                                        antialiasing: true
                                    }

                                    Flickable {
                                        id: answer_flickable
                                        width: answer_holder.width * 0.8
                                        height: parent.height * 0.7

                                        contentWidth: answer.width
                                        contentHeight: answer.height

                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter

                                        anchors.leftMargin: 12

                                        clip: true


                                        boundsBehavior: Flickable.StopAtBounds

                                        Text {
                                            id: answer

                                            anchors.centerIn: parent

                                            text: model.answer
                                            width: answer_flickable.width
                                            wrapMode: Text.Wrap
                                            font.pixelSize: Math.min(window.width / 50, window.height / 50)
                                        }
                                    }

                                    Behavior on radius {
                                        PropertyAnimation {
                                            duration: 800; easing.type: Easing.InOutQuad
                                        }
                                    }
                                }


                                transform: Rotation {
                                    id: rotation
                                    origin.x: flipable.width/2
                                    origin.y: flipable.height/2

                                    // setting axis.y to 1 so it rotates on y axis
                                    axis.x: 0; axis.y: 1; axis.z: 0

                                    angle: flipable.flipped ? 180 : 0

                                    Behavior on angle {
                                        NumberAnimation {
                                            target: rotation; property: 'angle'; easing.type: Easing.OutExpo; duration: 800
                                        }
                                    }
                                }

                                MouseArea {
                                    id: flipable_mouse_area
                                    anchors.fill: parent
                                    onClicked: {
                                        flipable.flipped = !flipable.flipped
                                    }
                                }
                            }
                        }
                    }
                }

                ListModel {
                    id: colorModel
                    ListElement {green: '#1f930f'}
                    ListElement {orange: '#f76f0b'}
                    ListElement {red: '#ef1910'}
                    ListElement {grey: '#808080'}
                }

            }
        }
    }

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.15

        Rectangle {
            id: return_button
            implicitWidth: test_page.width * 0.08
            implicitHeight: test_page.height * 0.08
            color: '#cdeac2'
            radius: 10

            // '#b2c3b2' sage green

            Image {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height * 0.7
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: test_page.return_button_png
            }

            MouseArea {
                id: return_button_area
                anchors.fill: return_button
                hoverEnabled: true

                onEntered: {
                    return_button.color = '#bde8aa'

                }
                onExited: {
                    return_button.color = '#cdeac2'
                }

                onClicked: {
                    if (view_of_cards.currentIndex > 0) {
                    view_of_cards.currentIndex = view_of_cards.currentIndex - 1}
                    else {
                        view_of_cards.currentIndex = view_of_cards.count - 1
                    }
                }

            }
        }

        Rectangle {
            id: bad_button
            implicitWidth: test_page.width * 0.08
            implicitHeight: test_page.height * 0.08
            color: '#ef1910'
            radius: 10

            Image {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height * 0.7
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: test_page.sad_face_button_png
            }

            MouseArea {
                id: bad_button_area
                anchors.fill: bad_button
                hoverEnabled: true

                onEntered: {
                    bad_button.color = '#d50202'

                }
                onExited: {
                    bad_button.color = '#ef1910'
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
            color: '#f76f0b'
            radius: 10

            Image {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height * 0.7
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: test_page.neutral_face_button_png
            }

            MouseArea {
                id: good_button_button_area
                anchors.fill: good_button
                hoverEnabled: true

                onEntered: {
                    good_button.color = '#f95504'

                }
                onExited: {
                    good_button.color = '#f76f0b'
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
            color: '#1f930f'
            radius: 10

            Image {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height * 0.7
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: test_page.happy_face_button_png
            }

            MouseArea {
                id: excellent_button_area
                anchors.fill: excellent_button
                hoverEnabled: true

                onEntered: {
                    excellent_button.color = '#107b18'

                }
                onExited: {
                    excellent_button.color = '#1f930f'
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