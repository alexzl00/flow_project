import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../../my_components'
import MyModel_py 1.0

Rectangle {
    id: learning_page
    anchors.fill: parent
    implicitWidth: parent
    implicitHeight: parent

    property string test_button_png: "../../images/test_button.png"
    property string trash_button_png: '../../images/trash_button.png'
    property string alter_card_button_png: '../../images/alter_card_button.png'
    property int choose_test_rec_preferable_height: learning_page.height * 0.2

    property string chosen_set: ''

    gradient: Gradient{
        GradientStop{position: 0.0; color: '#5cdb95'}
        GradientStop{position: 0.7; color: '#379683'}
    }

    Title_bar{
        id: titleBar
    }

    MainDrawer {
        id: drawer

        onIfLearningPageSignal: {
            sets_view.visible = true
            view_of_cards.visible = false
            drawer.runDrawerAnimation()
        }
    }

    Text {
        anchors.centerIn: parent
        visible: sets_view.count > 0 ? false : true
        text: "Currently you have no sets."
        Layout.alignment: Qt.AlignHCenter
        font {
            family: 'Arial'
            pixelSize: 48
        }
    }


    Rectangle {
        id: list_view_holder
        implicitWidth: learning_page.width * 0.55
        implicitHeight: learning_page.height * 0.8
        anchors.centerIn: parent
        //color: '#f9efc9'
        color: 'transparent'
        clip: true

        property string children_main_color: '#cdeac2'
        property string children_on_hover_color: '#bde8aa'


        //border.width: 3
        //border.color: '#36454F'
        //radius: 20

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10

            Text {
                id: sets_text
                text: "Your sets"
                Layout.alignment: Qt.AlignHCenter
                color: '#1B1212'
                visible: sets_view.visible
                font {
                    family: 'Arial'
                    pixelSize: Math.min(window.width / 20, window.height / 20)
                }
            }

            ListView {
                id: sets_view
                // anchors.left: parent.left
                implicitWidth: list_view_holder.width * 0.85
                implicitHeight: list_view_holder.height * 0.8
                model: MyModel {}
                spacing: 10
                clip: true


                Layout.fillHeight: true
                Layout.fillWidth: true

                boundsBehavior: Flickable.StopAtBounds


                ScrollBar.vertical: ScrollBar {
                    parent: sets_view.parent
                    anchors.top: sets_view.top
                    anchors.right: sets_view.right
                    anchors.bottom: sets_view.bottom

                    hoverEnabled: false

                    policy: sets_view.visible ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff

                    orientation: Qt.Vertical
                    interactive: false
                    pressed: false

                    minimumSize: 0.1
                    contentItem: Rectangle {
                        implicitWidth: 8
                        radius: width / 2
                        color: '#00A36C'
                    }
                    background: Rectangle {
                        implicitWidth: 8
                        color: list_view_holder.children_on_hover_color
                    }
                }

                delegate: Item{
                    implicitWidth: parent.width * 0.92
                    // it doesnt work parent.height, so learning_page.height (main rectangle's height) should be passed
                    implicitHeight: Math.max(learning_page.height * 0.1, list_view_item_text.contentHeight)
                    Rectangle{
                        id: list_view_item
                        radius: 20
                        implicitWidth: parent.width
                        implicitHeight: parent.height
                        color: list_view_holder.children_main_color

                        border.width: 2
                        border.color: '#36454F'

                        Text {
                            id: list_view_item_text
                            text: display
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                            wrapMode: Text.Wrap
                            font.pixelSize: Math.min(window.width / 40, window.height / 40)
                            //color: '#F5F5DC'
                        }

                        MouseArea {
                            id: list_view_item_area
                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: {
                                list_view_item.color = list_view_holder.children_on_hover_color
                            }
                            onExited: {
                                list_view_item.color = list_view_holder.children_main_color
                            }
                            onClicked: {
                                // we set this property to use it other window.StackView components
                                // where we need to load the data from chosen set
                                window.chosen_set_of_cards = list_view_item_text.text

                                sets_view.visible = false
                                view_of_cards.visible = true

                                // loading the ListView (view_of_cards) set based on chosen set
                                view_of_cards.model.wordlist_of_set(list_view_item_text.text)
                                learning_page.chosen_set = list_view_item_text.text
                            }
                        }
                    }

                }
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10

            Text {
                id: cards_text
                text: learning_page.chosen_set
                Layout.alignment: Qt.AlignHCenter
                color: sets_text.color
                visible: view_of_cards.visible
                font {
                    family: sets_text.font.family
                    pixelSize: sets_text.font.pixelSize
                }
            }

            ListView {
                id: view_of_cards
                visible: false
                model: MyModel {}
                implicitWidth: sets_view.width
                implicitHeight: sets_view.height
                spacing: 10

                clip: true

                Layout.fillHeight: true
                Layout.fillWidth: true

                boundsBehavior: Flickable.StopAtBounds


                ScrollBar.vertical: ScrollBar {
                    parent: view_of_cards.parent
                    anchors.top: view_of_cards.top
                    anchors.right: view_of_cards.right
                    anchors.bottom: view_of_cards.bottom

                    hoverEnabled: false

                    policy: sets_view.visible ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff

                    orientation: Qt.Vertical
                    interactive: false
                    pressed: false

                    minimumSize: 0.1
                    contentItem: Rectangle {
                        implicitWidth: 8
                        radius: width / 2
                        color: '#00A36C'
                    }
                    background: Rectangle {
                        implicitWidth: 8
                        color: list_view_holder.children_on_hover_color
                    }
                }

                delegate: Item{
                    implicitWidth: parent.width * 0.92
                    id: card_container
                    property int index: DelegateModel.itemsIndex

                    // it doesnt work parent.height, so learning_page.height (main rectangle's height) should be passed
                    implicitHeight: Math.min(learning_page.height * 0.1, 200)

                    Rectangle{
                        id: cards_view_item
                        radius: 20
                        implicitWidth: parent.width
                        implicitHeight: parent.height
                        color: list_view_holder.children_main_color

                        border.width: 2
                        border.color: '#36454F'

                        Flickable {
                            id: card_flickable
                            width: parent.width * 0.6
                            height: parent.height * 0.78

                            contentWidth: cards_view_item_text.width
                            contentHeight: cards_view_item_text.height

                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter

                            anchors.leftMargin: 12

                            clip: true


                            boundsBehavior: Flickable.StopAtBounds

                            Text {
                                id: cards_view_item_text
                                width: card_flickable.width

                                text: display
                                wrapMode: Text.Wrap
                                font.pixelSize: Math.min(window.width / 50, window.height / 50)
                            }
                        }

                        Row {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: cards_view_item.border.width

                            Rectangle {
                                id: alter_card_button_container
                                implicitWidth: cards_view_item.height * 0.65
                                implicitHeight: cards_view_item.height * 0.65
                                radius: cards_view_item.height / 2
                                color: 'transparent'

                                anchors.rightMargin: 10

                                Image {
                                    id: alter_card_button
                                    anchors.centerIn: parent

                                    width: parent.width * 0.7
                                    height: parent.height * 0.7
                                    fillMode: Image.PreserveAspectFit
                                    mipmap: true
                                    source: alter_card_button_png

                                }
                                MouseArea {
                                    id: alter_area
                                    anchors.fill: parent
                                    hoverEnabled: true

                                    onEntered: {
                                        alter_card_button_container.color = list_view_holder.children_on_hover_color
                                    }
                                    onExited: {
                                        alter_card_button_container.color = list_view_holder.children_main_color
                                    }
                                    onClicked: {
                                        alter_card.visible = true
                                        view_of_cards.visible = false
                                        alter_card.chosen_card_index = card_container.index
                                        container.setTextToQuestion(view_of_cards.model.question([learning_page.chosen_set, card_container.index]))
                                        container2.setTextToAnswer(view_of_cards.model.answer([learning_page.chosen_set, card_container.index]))
                                    }
                                }
                            }

                            Rectangle {
                                id: trash_button_container
                                implicitWidth: cards_view_item.height * 0.65
                                implicitHeight: cards_view_item.height * 0.65
                                radius: cards_view_item.height / 2
                                color: 'transparent'

                                anchors.rightMargin: 10

                                Image {
                                    id: trash_button
                                    anchors.centerIn: parent

                                    width: parent.width * 0.8
                                    height: parent.height * 0.8
                                    fillMode: Image.PreserveAspectFit
                                    mipmap: true
                                    source: trash_button_png

                                }
                                MouseArea {
                                    id: delete_area
                                    anchors.fill: parent
                                    hoverEnabled: true

                                    onEntered: {
                                        trash_button_container.color = list_view_holder.children_on_hover_color
                                    }
                                    onExited: {
                                        trash_button_container.color = 'transparent'
                                    }
                                    onClicked: {

                                        if (view_of_cards.model.delete_card([learning_page.chosen_set, card_container.index]) === true){
                                            view_of_cards.model.wordlist_of_set(learning_page.chosen_set)
                                        }
                                        else {
                                            sets_view.model.update()
                                            view_of_cards.visible = false
                                            sets_view.visible = true
                                        }

                                    }
                                }

                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: alter_card
        implicitWidth: parent.width * 0.5
        implicitHeight: view_of_cards.height
        anchors.centerIn: parent
        // color: 'transparent'
        color: '#f9efc9'
        border.color: '#36454F'
        border.width: 2
        radius: 20

        visible: false

        z: 1

        // indicates which card should be changed
        property int chosen_card_index: -1

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: 'Alter your card'
                font.pixelSize: Math.min(window.width / 20, window.height / 20)
            }

            Add_question {
                id: container
                border.color: '#36454F'
                border.width: 2
            }

            Add_answer {
                id: container2
                border.color: '#36454F'
                border.width: 2
            }

            Rectangle {
                id: submit_alter_card_button
                Layout.alignment: Qt.AlignBottom && Qt.AlignHCenter
                implicitHeight: button_text.contentHeight + 20
                implicitWidth: button_text.contentWidth + 20
                color: '#fdf7e4'
                radius: 5

                border.color: '#36454F'
                border.width: 2

                Text {
                    id: button_text
                    anchors.centerIn: submit_alter_card_button
                    text: 'Accept'
                    font.pixelSize: Math.min(window.width / 50, window.height / 50)
                }
                MouseArea {
                    anchors.fill:  submit_alter_card_button
                    hoverEnabled: true

                    onEntered: {
                        submit_alter_card_button.color = '#C0C0C0'
                    }
                    onExited: {
                        submit_alter_card_button.color = '#fdf7e4'
                    }
                    onClicked: {

                        var question = container.getQuestionText()
                        var answer = container2.getAnswerText()

                        if (question.length > 0
                        && answer.length > 0
                        && question.length <= container.getQuestionMaximumLength()
                        && answer.length <= container2.getAnswerMaximumLength()) {
                            if (view_of_cards.model.alter_card([learning_page.chosen_set, alter_card.chosen_card_index, question, answer]) === true) {
                                view_of_cards.model.wordlist_of_set(learning_page.chosen_set)
                                alter_card.visible = false
                                view_of_cards.visible = true
                            }
                            container.clearQuestionText()
                            container2.clearAnswerText()
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        id: outside_alter_card_rec
        anchors.fill: learning_page

        // this is necessary for window.startSystemResize, it still will resize, but will not show the resize cursor (Qt.SizeHorCursor)
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 10

        // is enabled when the alter_card rectangle is visible
        enabled: alter_card.visible

        onClicked: {
            var rect = alter_card.mapToItem(parent, 0, 0)
            var rectWidth = alter_card.width
            var rectHeight = alter_card.height

            if (mouse.x < rect.x || mouse.x > rect.x + rectWidth || mouse.y < rect.y || mouse.y > rect.y + rectHeight){
                alter_card.visible = false
                view_of_cards.visible = true
            }
        }
    }

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.05

        Rectangle {
            id: learn_cards_button
            implicitWidth: learn_card_button_text.contentWidth + 20
            implicitHeight: learn_card_button_text.contentHeight + 20
            visible: view_of_cards.visible
            color: '#fdf7e4'
            radius: 10
            Text {
                id: learn_card_button_text
                anchors.centerIn: parent
                text: 'Learn cards'
                font.pixelSize: Math.min(window.width / 50, window.height / 50)
            }

            MouseArea {
                id: learn_cards_button_area
                anchors.fill: learn_cards_button
                hoverEnabled: true

                onEntered: {
                    learn_cards_button.color = '#C0C0C0'

                }
                onExited: {
                    learn_cards_button.color = '#fdf7e4'
                }

                onClicked: {
                    choose_test_rec_animation.running = true
                    outside_choose_test_rec.enabled = true
                }
            }
        }
    }

    PropertyAnimation{
        id: choose_test_rec_animation
        target: choose_test_rec
        property: 'height'
        to: if (choose_test_rec.height > 0) return 0; else return choose_test_rec_preferable_height
        duration: if (choose_test_rec.height > 0) return 300; else return 1000
        easing.type: Easing.OutExpo
    }

    Rectangle {
        id: choose_test_rec
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        implicitWidth: parent.width - drawer.width
        implicitHeight: 0
        color: '#00887a'

        // This rec is only used for layout to be horizontally placed at the center of a learning page
        // and not changing the length of choose_test_rec
        Rectangle {
            id: rec
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: drawer.width
            implicitHeight: parent.height
            color: 'transparent'

            RowLayout {
                anchors.centerIn: parent
                spacing: 2
                Rectangle {
                    id: test_option_button
                    implicitWidth: choose_test_rec.width * 0.1
                    implicitHeight: choose_test_rec.height * 0.4
                    color: '#fdf7e4'
                    radius: 10
                    Image {
                        anchors.centerIn: parent
                        width: parent.width * 0.6
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        source: learning_page.test_button_png
                    }
                    MouseArea {
                        id: test_option_button_area
                        anchors.fill: test_option_button
                        hoverEnabled: true

                        onEntered: {
                            test_option_button.color = '#C0C0C0'
                            // we need to set enabled to false, because outside_choose_test_rec intercepts the click
                            outside_choose_test_rec.enabled = false
                        }
                        onExited: {
                            test_option_button.color = '#fdf7e4'
                            outside_choose_test_rec.enabled = true
                        }
                        onClicked: {
                            stack.replace(test_page)
                        }
                    }
                }
            }
        }
    }
    // This MouseArea is for choose_test_rec to be closed when mouse is clicked outside of this rec
    MouseArea {
        id: outside_choose_test_rec
        anchors.fill: learning_page

        // this is necessary for window.startSystemResize, it still will resize, but will not show the resize cursor (Qt.SizeHorCursor)
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 10

        enabled: false
        onClicked: {
            var rect = choose_test_rec.mapToItem(parent, 0, 0)
            var rectWidth = choose_test_rec.width
            var rectHeight = choose_test_rec.height

            if ((mouse.x < rect.x || mouse.x > rect.x + rectWidth || mouse.y < rect.y || mouse.y > rect.y + rectHeight)
            && choose_test_rec_preferable_height === choose_test_rec.height){
                choose_test_rec_animation.running = true
                outside_choose_test_rec.enabled = false
            }
        }
    }

    Component.onCompleted: sets_view.model.update()
}