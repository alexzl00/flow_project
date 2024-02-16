import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../../my_components'
import MyModel_py 1.0

Rectangle{
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

    MainDrawer{
        id: drawer
    }

    ListView{
        id: sets_view
        anchors.centerIn: parent
        implicitWidth: learning_page.width * 0.3
        implicitHeight: learning_page.height * 0.5
        model: MyModel {}
        spacing: 10

        delegate: Item{
            implicitWidth: parent.width
            // it doesnt work parent.height, so learning_page.height (main rectangle's height) should be passed
            implicitHeight: Math.max(learning_page.height * 0.1, list_view_item_text.contentHeight)
            Rectangle{
                id: list_view_item
                radius: 20
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: 	'#FFF5EE'

                Text {
                    id: list_view_item_text
                    text: display
                    anchors.centerIn: parent
                    width: parent.width * 0.8
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    id: list_view_item_area
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        list_view_item.color = '#C0C0C0'
                    }
                    onExited: {
                        list_view_item.color = '#ffffff'
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

    ListView {
        id: view_of_cards
        visible: false
        model: MyModel {}
        anchors.centerIn: parent
        implicitWidth: learning_page.width * 0.3
        implicitHeight: learning_page.height * 0.5
        spacing: 10


        delegate: Item{
            implicitWidth: parent.width
            id: card_container
            property int index: DelegateModel.itemsIndex

            // it doesnt work parent.height, so learning_page.height (main rectangle's height) should be passed
            implicitHeight: Math.max(learning_page.height * 0.1, cards_view_item_text.contentHeight)

            Rectangle{
                id: cards_view_item
                radius: 20
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: 	'#FFF5EE'

                Text {
                    id: cards_view_item_text
                    width: parent.width * 0.8
                    text: display
                    anchors.centerIn: parent
                    wrapMode: Text.WordWrap
                }
                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        id: alter_card_button_container
                        implicitWidth: cards_view_item.height * 0.45
                        implicitHeight: cards_view_item.height * 0.45
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
                                alter_card_button_container.color = '#C0C0C0'
                            }
                            onExited: {
                                alter_card_button_container.color = '#ffffff'
                            }
                            onClicked: {
                                alter_card.visible = true
                                alter_card.chosen_card_index = card_container.index
                                alter_card.question_of_chosen_card = view_of_cards.model.question([learning_page.chosen_set, card_container.index])
                                alter_card.answer_of_chosen_card = view_of_cards.model.answer([learning_page.chosen_set, card_container.index])
                            }
                        }
                    }

                    Rectangle {
                        id: trash_button_container
                        implicitWidth: cards_view_item.height * 0.45
                        implicitHeight: cards_view_item.height * 0.45
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
                                trash_button_container.color = '#C0C0C0'
                            }
                            onExited: {
                                trash_button_container.color = '#ffffff'
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

    Rectangle {
        id: alter_card
        implicitWidth: parent.width * 0.5
        implicitHeight: parent.height * 0.6
        anchors.centerIn: parent
        color: 'red'

        visible: false

        z: 1

        // indicates which card should be changed
        property int chosen_card_index: -1

        property string question_of_chosen_card: ''
        property string answer_of_chosen_card: ''

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10

            Rectangle {
                id: container
                implicitWidth: alter_card.width * 0.8
                implicitHeight: alter_card.height * 0.4
                radius: 10
                TextEdit {
                    id: question

                    text: alter_card.question_of_chosen_card


                    anchors.fill: parent
                    padding: 3
                    font.pixelSize: 14
                    focus: true
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        var pos = question.positionAt(1, container.height + 1);
                        if(question.length >= pos)
                        {
                            question.remove(pos, question.length);
                        }
                    }
                }
            }
            Rectangle {
                id: container2
                implicitWidth: alter_card.width * 0.8
                implicitHeight: alter_card.height * 0.4
                radius: 10
                TextEdit {
                    id: answer

                    text: alter_card.answer_of_chosen_card

                    anchors.fill: parent
                    padding: 3
                    font.pixelSize: 14
                    focus: true
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        var pos = answer.positionAt(1, container2.height + 1);
                        if(answer.length >= pos)
                        {
                            answer.remove(pos, answer.length);
                        }
                    }
                }
            }

            Rectangle {
                id: submit_alter_card_button
                Layout.alignment: Qt.AlignBottom && Qt.AlignHCenter
                implicitHeight: parent.height * 0.10
                implicitWidth: parent.width * 0.30
                color: '#ffffff'
                radius: 5
                Text {
                    id: button_text
                    anchors.centerIn: submit_alter_card_button
                    text: 'Accept altering'
                    font.pixelSize: 16
                }
                MouseArea {
                    anchors.fill:  submit_alter_card_button
                    hoverEnabled: true

                    onEntered: {
                        submit_alter_card_button.color = '#C0C0C0'
                    }
                    onExited: {
                        submit_alter_card_button.color = '#ffffff'
                    }
                    onClicked: {
                        if (view_of_cards.model.alter_card([learning_page.chosen_set, alter_card.chosen_card_index, question.text, answer.text]) === true) {
                            view_of_cards.model.wordlist_of_set(learning_page.chosen_set)
                            alter_card.visible = false
                        }
                        answer.text = ''
                        question.text = ''
                    }
                }
            }
        }
    }

    MouseArea {
        id: outside_alter_card_rec
        anchors.fill: learning_page

        // is enabled when the alter_card rectangle is visible
        enabled: alter_card.visible

        onClicked: {
            var rect = alter_card.mapToItem(parent, 0, 0)
            var rectWidth = alter_card.width
            var rectHeight = alter_card.height

            if (mouse.x < rect.x || mouse.x > rect.x + rectWidth || mouse.y < rect.y || mouse.y > rect.y + rectHeight){
                alter_card.visible = false
            }
        }
    }

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.05

        Rectangle {
            id: learn_cards_button
            implicitWidth: learning_page.width * 0.1
            implicitHeight: learning_page.height * 0.07
            visible: view_of_cards.visible
            color: '#ffffff'
            radius: 10
            Text {
                anchors.centerIn: parent
                text: 'Learn cards'
                font.pixelSize: 16
            }

            MouseArea {
                id: learn_cards_button_area
                anchors.fill: learn_cards_button
                hoverEnabled: true

                onEntered: {
                    learn_cards_button.color = '#C0C0C0'

                }
                onExited: {
                    learn_cards_button.color = '#ffffff'
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
                    color: '#ffffff'
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
                            test_option_button.color = '#ffffff'
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