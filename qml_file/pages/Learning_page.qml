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

    property string test_button_svg: "../../images/test_button.svg"
    property string trash_button_png: '../../images/delete_button_red.svg'
    property string alter_card_button_png: '../../images/edit_button_blue.svg'
    property string backward_button_svg: '../../images/backward_button_black.svg'
    property string forward_button_svg: '../../images/forward_button_black.svg'
    property string regular_bookmark_svg: '../../images/bookmark-regular.svg'
    property string solid_bookmark_svg: '../../images/bookmark-solid.svg'
    property int choose_test_rec_preferable_height: learning_page.height * 0.2

    property string chosen_set: ''

    FontLoader {
        id: montserrat
        source: '../../fonts/Montserrat-Medium.ttf'
    }

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
            family: montserrat.font.family
            pixelSize: 48
        }
    }


    Rectangle {
        id: list_view_holder
        implicitWidth: learning_page.width * 0.8
        implicitHeight: learning_page.height * 0.8

        x: (learning_page.width - drawer.drawerWidthIfNotDrawn - width) / 2 + drawer.drawerWidthIfNotDrawn
        anchors.verticalCenter: parent.verticalCenter

        //color: '#f9efc9'
        color: 'transparent'
        clip: true

        property string children_main_color: '#cdeac2'
        property string children_on_hover_color: '#bde8aa'



        ColumnLayout {
            anchors.centerIn: parent
            spacing: 30

            Text {
                id: sets_text
                text: "Your sets"
                Layout.alignment: Qt.AlignHCenter
                color: '#1B1212'
                visible: sets_view.visible
                font {
                    family: montserrat.font.family
                    pixelSize: Math.min(window.width / 20, window.height / 20)
                }
            }

            GridView {
                id: sets_view
                // anchors.left: parent.left
                implicitWidth: list_view_holder.width
                implicitHeight: grid_height

                Layout.alignment: Qt.AlignHCenter

                model: MyModel {}

                clip: true
                focus: true
                interactive: false

                currentIndex: 0

                property int currentPage: 1

                onCurrentPageChanged: {
                    model.update(amount_of_rows * amount_of_columns * (currentPage - 1), (amount_of_rows * amount_of_columns * currentPage))
                }

                property int totalPages: Math.ceil(model.data_length() / itemsPerPage)
                property int itemsPerPage: amount_of_rows * amount_of_columns

                property bool if_last_page: currentPage === totalPages ? true : false
                property int preferable_grid_height: list_view_holder.height * 0.8
                property int last_page_grid_height: Math.ceil(sets_view.count / amount_of_columns) * cellHeight

                cellWidth: sets_view.width / amount_of_columns
                cellHeight: preferable_grid_height / amount_of_rows

                //cellHeight: Math.max(learning_page.height * 0.1, list_view_item_text.contentHeight)

                property int grid_height: if_last_page ? last_page_grid_height : preferable_grid_height

                property int amount_of_rows: 4
                property int amount_of_columns: 3


                delegate: Item{
                    implicitWidth: sets_view.cellWidth * 0.9
                    // it doesnt work parent.height, so learning_page.height (main rectangle's height) should be passed
                    implicitHeight: sets_view.cellHeight * 0.9

                    property int item_index: index

                    property bool marked_as_main: model.bookmarked

                    Rectangle{
                        id: list_view_item
                        radius: 20
                        implicitWidth: parent.width
                        implicitHeight: parent.height
                        color: list_view_holder.children_main_color

                        x: (sets_view.cellWidth - parent.width) / 2

                        border.width: 2
                        border.color: 'black'

                        Text {
                            id: list_view_item_text
                            text: display

                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: parent.width * 0.1

                            width: parent.width * 0.7
                            wrapMode: Text.Wrap

                            font.pixelSize: Math.min(window.width / 40, window.height / 40)
                            font.family: montserrat.font.family
                        }
                        Rectangle {
                            id: bookmark_container
                            implicitHeight: parent.height * 0.4
                            implicitWidth: parent.height * 0.4
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            color: 'transparent'
                            z: 2


                            Image {
                                id: bookmark_button
                                anchors.centerIn: parent

                                width: bookmark_area.containsMouse ? parent.height * 0.8 : parent.height * 0.7
                                height: bookmark_area.containsMouse ? parent.height * 0.8 : parent.height * 0.7
                                fillMode: Image.PreserveAspectFit
                                mipmap: true
                                source: marked_as_main === false ? regular_bookmark_svg : solid_bookmark_svg

                            }
                            MouseArea {
                                id: bookmark_area
                                anchors.fill: bookmark_container
                                hoverEnabled: true
                                preventStealing: true
                                z: 2

                                onClicked: {
                                    if (marked_as_main === false) {
                                        marked_as_main = true
                                    } else {
                                        marked_as_main = false
                                    }
                                    sets_view.model.bookmark_set(list_view_item_text.text, marked_as_main)
                                    if (sets_view.currentPage != 1) {
                                        sets_view.currentPage = 1
                                    } else {
                                        sets_view.model.update(0, sets_view.itemsPerPage)
                                    }
                                }
                            }
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

            //space filler
            Item {
                visible: sets_view.if_last_page && (sets_view.preferable_grid_height != sets_view.height) ? true : false
                height: sets_view.preferable_grid_height - sets_view.height - parent.spacing
                width: 1
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10

            Text {
                id: cards_text
                text: `Chosen set: \n${learning_page.chosen_set}`
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
                color: sets_text.color
                visible: view_of_cards.visible
                font {
                    family: montserrat.font.family
                    pixelSize: sets_text.font.pixelSize
                }
            }

            ListView {
                id: view_of_cards
                visible: false
                model: MyModel {}
                implicitWidth: sets_view.width
                implicitHeight: sets_view.preferable_grid_height
                spacing: 10

                clip: true

                Layout.fillHeight: true
                Layout.fillWidth: true

                boundsBehavior: Flickable.StopAtBounds

                delegate: Item{
                    implicitWidth: view_of_cards.width
                    id: card_container
                    property int index: DelegateModel.itemsIndex

                    // it doesnt work parent.height, so learning_page.height (main rectangle's height) should be passed
                    implicitHeight: Math.min(learning_page.height * 0.15, 200)


                    Row {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        //anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: cards_view_item.border.width

                        Rectangle {
                            id: alter_card_button_container
                            implicitWidth: card_container.height - cards_view_item.height
                            implicitHeight: card_container.height - cards_view_item.height
                            radius: cards_view_item.height / 2
                            color: 'transparent'

                            anchors.rightMargin: 10

                            Image {
                                id: alter_card_button
                                anchors.centerIn: parent

                                width: alter_area.containsMouse ? parent.height * 0.9 : parent.width * 0.7
                                height: alter_area.containsMouse ? parent.height * 0.9 : parent.width * 0.7
                                fillMode: Image.PreserveAspectFit
                                mipmap: true
                                source: alter_card_button_png

                            }
                            MouseArea {
                                id: alter_area
                                anchors.fill: parent
                                hoverEnabled: true

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
                            implicitWidth: card_container.height - cards_view_item.height
                            implicitHeight: card_container.height - cards_view_item.height
                            radius: cards_view_item.height / 2
                            color: 'transparent'

                            anchors.rightMargin: 10

                            Image {
                                id: trash_button
                                anchors.centerIn: parent

                                width: delete_area.containsMouse ? parent.height * 0.9 : parent.width * 0.8
                                height: delete_area.containsMouse ? parent.height * 0.9 : parent.width * 0.8
                                fillMode: Image.PreserveAspectFit
                                mipmap: true
                                source: trash_button_png

                            }
                            MouseArea {
                                id: delete_area
                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: {

                                    if (view_of_cards.model.delete_card([learning_page.chosen_set, card_container.index]) === true){
                                        view_of_cards.model.wordlist_of_set(learning_page.chosen_set)
                                    }
                                    else {
                                        sets_view.totalPages = Math.ceil(sets_view.model.data_length() / sets_view.itemsPerPage)
                                        if (sets_view.totalPages < sets_view.currentPage) {
                                            sets_view.currentPage = sets_view.totalPages
                                        }
                                        sets_view.model.update(sets_view.itemsPerPage * (sets_view.currentPage - 1), (sets_view.itemsPerPage * sets_view.currentPage))
                                        view_of_cards.visible = false
                                        sets_view.visible = true
                                    }

                                }
                            }

                        }
                    }

                    Rectangle{
                        id: cards_view_item
                        radius: 20
                        implicitWidth: parent.width
                        implicitHeight: parent.height * 0.7
                        color: list_view_holder.children_main_color

                        anchors.bottom: parent.bottom

                        border.width: 2
                        border.color: '#36454F'

                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 2

                            color: parent.border.color
                        }

                        Text {
                            text: 'Question'
                            font.pixelSize: 16
                            font.family: montserrat.font.family
                            font.bold: true

                            anchors.top: parent.top
                            anchors.topMargin: 1

                            x: cards_view_item.width / 4 - contentWidth / 2
                        }

                        Text {
                            text: 'Answer'
                            font.pixelSize: 16
                            font.family: montserrat.font.family
                            font.bold: true

                            anchors.top: parent.top
                            anchors.topMargin: 1

                            x: cards_view_item.width / 4 * 3 - contentWidth / 2
                        }

                        Flickable {
                            id: question_flickable
                            width: parent.width / 2.5
                            height: parent.height * 0.49

                            contentWidth: question_text.width
                            contentHeight: question_text.height / 2 * 3

                            x: cards_view_item.width / 4 - width / 2
                            anchors.topMargin: cards_view_item.height / 3
                            anchors.top: parent.top

                            clip: true


                            boundsBehavior: Flickable.StopAtBounds

                            Text {
                                id: question_text
                                width: question_flickable.width

                                text: view_of_cards.model.question([learning_page.chosen_set, card_container.index])
                                wrapMode: Text.Wrap
                                font.pixelSize: Math.min(window.width / 50, window.height / 50)
                                font.family: montserrat.font.family
                            }
                        }

                        Flickable {
                            id: answer_flickable
                            width: parent.width / 2.5
                            height: parent.height * 0.49

                            contentWidth: answer_text.width
                            contentHeight: answer_text.height / 2 * 3

                            x: cards_view_item.width / 4 * 3 - width / 2
                            anchors.topMargin: cards_view_item.height / 3
                            anchors.top: parent.top

                            clip: true

                            boundsBehavior: Flickable.StopAtBounds

                            Text {
                                id: answer_text
                                width: answer_flickable.width

                                text: view_of_cards.model.answer([learning_page.chosen_set, card_container.index])
                                wrapMode: Text.Wrap
                                font.pixelSize: Math.min(window.width / 50, window.height / 50)
                                font.family: montserrat.font.family
                            }
                        }
                    }
                }
            }
        }
    }
    RowLayout {
        anchors.bottomMargin: 10
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: list_view_holder.horizontalCenter
        visible: sets_view.visible
        spacing: 20

        Rectangle {
            id: backward
            implicitWidth: learning_page.width * 0.07
            implicitHeight: learning_page.height * 0.07
            radius: 8
            color: main_color
            border.width: 2.5

            property string main_color: '#cdeac2'
            property string on_hover_color: '#bde8aa'

            Image {
                id: backward_image
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                width: parent.width * 0.8
                height: parent.height * 0.8
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: learning_page.backward_button_svg

            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    backward.color = backward.on_hover_color
                }
                onExited: {
                    backward.color = backward.main_color
                }
                onClicked: {
                    if (sets_view.currentPage > 1) {
                        sets_view.currentPage = sets_view.currentPage - 1
                    }
                }
            }

        }

        Text {
            text: `${sets_view.currentPage} / ${sets_view.totalPages}`
            color: 'black'
            font {
                family: montserrat.font.family
                pixelSize: backward.height / 2
            }
        }

        Rectangle {
            id: forward
            implicitWidth: backward.width
            implicitHeight: backward.height
            radius: backward.radius
            color: main_color
            border.width: backward.border.width

            property string main_color: backward.main_color
            property string on_hover_color: backward.on_hover_color

            Image {
                id: forward_image

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                //anchors.rightMargin: (parent.width - width) / 2

                width: parent.width * 0.8
                height: parent.height * 0.8
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: learning_page.forward_button_svg

            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    forward.color = forward.on_hover_color
                }
                onExited: {
                    forward.color = forward.main_color
                }
                onClicked: {
                    if (sets_view.currentPage < sets_view.totalPages) {
                        sets_view.currentPage = sets_view.currentPage + 1
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
        color: '#cdeac2'
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
                implicitWidth: container.width

                color: submit_alter_card_area.containsMouse ? on_hover_color : main_color
                radius: 5

                //border.width: 3
                //border.color: '#AFE1AF'

                property string main_color: '#36454F'
                property string on_hover_color: '#1f2f40'

                Text {
                    id: button_text
                    anchors.centerIn: submit_alter_card_button
                    text: 'Accept'
                    font.pixelSize: Math.min(window.width / 50, window.height / 50)
                    color: 'white'
                }

                MouseArea {
                    id: submit_alter_card_area
                    anchors.fill:  submit_alter_card_button
                    hoverEnabled: true

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
        anchors.horizontalCenter: list_view_holder.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.05

        Rectangle {
            id: learn_cards_button
            implicitWidth: learn_card_button_text.contentWidth + 20
            implicitHeight: learn_card_button_text.contentHeight + 20
            visible: view_of_cards.visible
            color: learn_cards_button_area.containsMouse ? choose_test_rec.on_hover_color : choose_test_rec.main_color
            radius: 10

            border.width: 2

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

        property string main_color: '#cdeac2'
        property string on_hover_color: '#bde8aa'

        // This rec is only used for layout to be horizontally placed at the center of a learning page
        // and not changing the length of choose_test_rec
        Rectangle {
            id: rec
            anchors.left: parent.left
            anchors.right: parent.right
            implicitHeight: parent.height
            color: 'transparent'

            RowLayout {
                anchors.centerIn: parent
                spacing: 2
                visible: choose_test_rec.height < learning_page.choose_test_rec_preferable_height / 2 - learning_page.choose_test_rec_preferable_height * 0.2 ? false : true
                Rectangle {
                    id: test_option_button
                    implicitWidth: choose_test_rec.width * 0.1
                    implicitHeight: learning_page.choose_test_rec_preferable_height * 0.4
                    color: test_option_button_area.containsMouse ? choose_test_rec.on_hover_color : choose_test_rec.main_color
                    radius: 10

                    border.width: 2
                    border.color: '#192846'

                    Image {
                        anchors.centerIn: parent
                        width: parent.height * 0.7
                        height: parent.height * 0.7
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        source: learning_page.test_button_svg
                    }
                    MouseArea {
                        id: test_option_button_area
                        anchors.fill: test_option_button
                        hoverEnabled: true

                        onEntered: {
                            // we need to set enabled to false, because outside_choose_test_rec intercepts the click
                            outside_choose_test_rec.enabled = false
                        }
                        onExited: {
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

    Component.onCompleted: sets_view.model.update(0, sets_view.itemsPerPage)
}