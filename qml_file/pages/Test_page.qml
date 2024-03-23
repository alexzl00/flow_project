import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../../my_components'
import '../../my_components/components_for_test_page'
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

    property string sad_face_button_png: '../../images/cross_button_white.svg' // for bad_button
    property string neutral_face_button_png: '../../images/circle_button_white.svg' // for good_button
    property string happy_face_button_png: '../../images/check_mark_white.svg' // for excellent_button
    property string return_button_png: '../../images/return_button.png' // for return_button


    Title_bar {
        id: titleBar
    }

    MainDrawer {
        id: drawer
    }

    FontLoader {
        id: montserrat
        source: '../../fonts/Montserrat-Medium.ttf'
    }

    Rectangle {
        id: show_percentage_of_indicator
        visible: false

        implicitWidth: custom_result_indicator_rec.width * 0.2
        implicitHeight: custom_result_indicator_rec.height * 5

        radius: 10
        color: '#cdeac2'
        border.width: 1.5


        Text {
            id: show_percentage_of_indicator_text
            anchors.centerIn: parent
            text: ''
            font.family: test_page.montserrat
            font.pixelSize: Math.min(window.width / 50, window.height / 50)
        }
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
            //clip: true

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


                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            var global_position = advancedShapeGreen.mapToItem(test_page, advancedShapeGreen)
                            show_percentage_of_indicator.x = global_position.x + advancedShapeGreen.width / 2  - show_percentage_of_indicator.width / 2
                            show_percentage_of_indicator.y = global_position.y - show_percentage_of_indicator.height - 5
                            show_percentage_of_indicator.visible = true
                            show_percentage_of_indicator_text.text = `${Math.ceil(custom_result_indicator_rec.list_of_green.length / custom_result_indicator_rec.number_of_cards * 100)}%`
                        }

                        onExited: {
                            show_percentage_of_indicator.visible = false
                        }
                    }
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

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            var global_position = advancedShapeOrange.mapToItem(test_page, advancedShapeOrange)
                            show_percentage_of_indicator.x = global_position.x + advancedShapeOrange.width / 2  - show_percentage_of_indicator.width / 2 - advancedShapeGreen.width
                            show_percentage_of_indicator.y = global_position.y - show_percentage_of_indicator.height - 5
                            show_percentage_of_indicator.visible = true
                            show_percentage_of_indicator_text.text = `${Math.ceil(custom_result_indicator_rec.list_of_orange.length / custom_result_indicator_rec.number_of_cards * 100)}%`
                        }

                        onExited: {
                            show_percentage_of_indicator.visible = false
                        }
                    }
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

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            var global_position = advancedShapeRed.mapToItem(test_page, advancedShapeRed)
                            show_percentage_of_indicator.x = global_position.x + advancedShapeRed.width / 2  - show_percentage_of_indicator.width / 2 - advancedShapeGreen.width - advancedShapeOrange.width
                            show_percentage_of_indicator.y = global_position.y - show_percentage_of_indicator.height - 5
                            show_percentage_of_indicator.visible = true
                            show_percentage_of_indicator_text.text = `${Math.ceil(custom_result_indicator_rec.list_of_red.length / custom_result_indicator_rec.number_of_cards * 100)}%`
                        }

                        onExited: {
                            show_percentage_of_indicator.visible = false
                        }
                    }
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

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            var global_position = mapToItem(test_page, advancedShapeGrey)
                            show_percentage_of_indicator.x = global_position.x + advancedShapeGrey.width / 2  - show_percentage_of_indicator.width / 2 - advancedShapeGreen.width - advancedShapeOrange.width - advancedShapeRed.width
                            show_percentage_of_indicator.y = global_position.y - show_percentage_of_indicator.height - 5
                            show_percentage_of_indicator.visible = true
                            show_percentage_of_indicator_text.text = `${Math.ceil(advancedShapeGrey.grey_length / custom_result_indicator_rec.number_of_cards * 100)}%`
                        }

                        onExited: {
                            show_percentage_of_indicator.visible = false
                        }
                    }
                }

            }
        }

        Rectangle {
            id: rec_for_view
            implicitWidth: test_page.width * 0.38
            implicitHeight: test_page.height * 0.6

            color: 'transparent'
            radius: 10
            clip: true

            SwipeView {
                id: view_of_cards
                interactive: false
                currentIndex: 0
                anchors.fill: parent

                property bool flipableFlipped: false

                property int flip_duration: 800

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

                            property string answer: model.answer

                            Flipable {
                                id: flipable
                                width: parent.width * 0.9
                                height: parent.height * 0.9
                                anchors.centerIn: parent

                                property bool flipped: view_of_cards.flipableFlipped

                                front: Rectangle {
                                    id: question_holder
                                    width: parent.width
                                    height: parent.height
                                    color: '#fdf7e4'
                                    radius: 20
                                    antialiasing: true
                                    z: 2

                                    border.width: 2
                                    border.color: 'black'

                                    Rectangle {
                                        id: play_sound_button
                                        implicitWidth: parent.height * 0.13
                                        implicitHeight: parent.height * 0.13
                                        color: 'transparent'
                                        radius: play_sound_button.width / 2
                                        z: 3

                                        anchors.top: parent.top
                                        anchors.left: parent.left
                                        anchors.leftMargin: 4
                                        anchors.topMargin: 4

                                        Image {
                                            anchors.centerIn: parent
                                            width: parent.width * 0.65
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
                                                text_to_speech.play_text(answer.text)
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
                                        height: 2
                                        color: 'black'

                                        anchors.top: question_flickable.top
                                        anchors.bottomMargin: height

                                        antialiasing: true
                                    }

                                    Rectangle {
                                        width: parent.width
                                        height: 2
                                        color: 'black'

                                        anchors.bottom: question_flickable.bottom
                                        anchors.topMargin: height

                                        antialiasing: true
                                    }

                                    Flickable {
                                        id: question_flickable
                                        implicitWidth: Math.min(question_holder.width * 0.8, question.text.length * question.font.pixelSize / 2 + 30)
                                        implicitHeight: parent.height * 0.7

                                        contentWidth: width
                                        contentHeight: Math.max(question.height, height)

                                        anchors.centerIn: parent

                                        clip: true


                                        boundsBehavior: Flickable.StopAtBounds

                                        Rectangle {
                                            id: question_text_holder
                                            implicitWidth: question_flickable.width
                                            implicitHeight: question.contentHeight
                                            anchors.centerIn: parent
                                            color: 'transparent'

                                            Text {
                                                id: question

                                                anchors.centerIn: question_text_holder

                                                text: model.question
                                                width: question_flickable.width
                                                wrapMode: Text.Wrap

                                                font.pixelSize: Math.min(window.width / 40, window.height / 40)
                                                font.family: montserrat.font.family
                                            }
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

                                    border.width: 2
                                    border.color: 'black'

                                    Rectangle {
                                        width: parent.width
                                        height: 2
                                        color: 'black'

                                        anchors.top: answer_flickable.top
                                        anchors.bottomMargin: height

                                        antialiasing: true
                                    }

                                    Rectangle {
                                        width: parent.width
                                        height: 2
                                        color: 'black'

                                        anchors.bottom: answer_flickable.bottom
                                        anchors.topMargin: height

                                        antialiasing: true
                                    }

                                    Flickable {
                                        id: answer_flickable
                                        implicitWidth: Math.min(answer_holder.width * 0.8, answer.text.length * answer.font.pixelSize / 2 + 30)
                                        implicitHeight: parent.height * 0.7

                                        contentWidth: width
                                        contentHeight: Math.max(answer.height, height)

                                        anchors.centerIn: parent

                                        clip: true


                                        boundsBehavior: Flickable.StopAtBounds

                                        Rectangle {
                                            id: answer_text_holder
                                            width: answer_flickable.width
                                            height: answer.contentHeight
                                            anchors.centerIn: parent
                                            color: 'transparent'

                                            Text {
                                                id: answer

                                                anchors.centerIn: answer_text_holder

                                                text: model.answer
                                                width: answer_flickable.width
                                                wrapMode: Text.Wrap

                                                font.pixelSize: Math.min(window.width / 40, window.height / 40)
                                                font.family: montserrat.font.family
                                            }
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
                                            target: rotation; property: 'angle'; easing.type: Easing.OutExpo; duration: view_of_cards.flip_duration
                                        }
                                    }
                                }

                                MouseArea {
                                    id: flipable_mouse_area
                                    anchors.fill: parent
                                    onClicked: {
                                        view_of_cards.flipableFlipped  = !view_of_cards.flipableFlipped
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
        anchors.bottomMargin: parent.height * 0.12
        spacing: 20

        Card_assessment_button {
            id: return_button
            implicitWidth: test_page.width * 0.08
            implicitHeight: test_page.height * 0.08
            color: '#cdeac2'
            radius: 10

            // '#b2c3b2' sage green

            main_color: '#cdeac2'
            on_hover_color: '#bde8aa'
            image_source: test_page.return_button_png

            Timer {
                id: flip_timer1
                interval: view_of_cards.flip_duration
                repeat: false
                running: false


                onTriggered: {
                    if (view_of_cards.currentIndex > 0) {
                    view_of_cards.currentIndex = view_of_cards.currentIndex - 1}
                    else {
                        view_of_cards.currentIndex = view_of_cards.count - 1
                    }
                }
            }

            MouseArea {
                id: return_button_area
                anchors.fill: return_button
                hoverEnabled: true

                onEntered: {
                    return_button.color = return_button.on_hover_color

                }
                onExited: {
                    return_button.color = return_button.main_color
                }

                onClicked: {
                    if (view_of_cards.flipableFlipped) {
                        flip_timer1.interval = view_of_cards.flip_duration
                    } else {
                        flip_timer1.interval = 0
                    }

                    view_of_cards.flipableFlipped = false

                    flip_timer1.start()
                }
            }
        }

        Card_assessment_button {
            id: bad_button

            main_color: '#ef1910'
            on_hover_color: '#d50202'
            image_source: test_page.sad_face_button_png
            border_color: '#FA5F55'

            Timer {
                id: flip_timer2
                interval: view_of_cards.flip_duration
                repeat: false
                running: false

                onTriggered: {
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

            MouseArea {
                id: bad_button_area
                anchors.fill: bad_button
                hoverEnabled: true

                onEntered: {
                    bad_button.color = bad_button.on_hover_color

                }
                onExited: {
                    bad_button.color = bad_button.main_color
                }

                onClicked: {
                    if (view_of_cards.flipableFlipped) {
                        flip_timer2.interval = view_of_cards.flip_duration
                    } else {
                        flip_timer2.interval = 0
                    }

                    view_of_cards.flipableFlipped = false

                    flip_timer2.start()
                }

            }
        }

        Card_assessment_button {
            id: good_button

            main_color: '#f76f0b'
            on_hover_color: '#f95504'
            image_source: test_page.neutral_face_button_png
            border_color: '#FFAA33'

            Timer {
                id: flip_timer3
                interval: view_of_cards.flip_duration
                repeat: false
                running: false

                onTriggered: {
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

            MouseArea {
                id: good_button_button_area
                anchors.fill: good_button
                hoverEnabled: true

                onEntered: {
                    good_button.color = good_button.on_hover_color

                }
                onExited: {
                    good_button.color = good_button.main_color
                }

                onClicked: {
                    if (view_of_cards.flipableFlipped) {
                        flip_timer3.interval = view_of_cards.flip_duration
                    } else {
                        flip_timer3.interval = 0
                    }

                    view_of_cards.flipableFlipped = false

                    flip_timer3.start()
                }

            }
        }

        Card_assessment_button {
            id: excellent_button

            on_hover_color: '#107b18'
            main_color: '#1f930f'
            image_source: test_page.happy_face_button_png
            border_color: '#50C878'


            Timer {
                id: flip_timer4
                interval: view_of_cards.flip_duration
                repeat: false
                running: false

                onTriggered: {
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

            MouseArea {
                id: excellent_button_area
                anchors.fill: excellent_button
                hoverEnabled: true

                onEntered: {
                    excellent_button.color = excellent_button.on_hover_color

                }
                onExited: {
                    excellent_button.color = excellent_button.main_color
                }

                onClicked: {
                    if (view_of_cards.flipableFlipped) {
                        flip_timer4.interval = view_of_cards.flip_duration
                    } else {
                        flip_timer4.interval = 0
                    }

                    view_of_cards.flipableFlipped = false

                    flip_timer4.start()
                }

            }
        }

    }
    Component.onCompleted: {
        repeater.model.cards_for_test(window.chosen_set_of_cards)
    }

    Connections {
        target: text_to_speech

        function onPlay_response(response) {
            if (response === 'True') {
                console.log('true')
            }
        }
    }
}