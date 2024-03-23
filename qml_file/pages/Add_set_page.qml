import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../../my_components'
import MyModel_py 1.0

Rectangle{
    id: add_set_page
    anchors.fill: parent
    implicitWidth: parent
    implicitHeight: parent
    gradient: Gradient{
        GradientStop{position: 0.0; color: '#5cdb95'}
        GradientStop{position: 0.7; color: '#379683'}
    }

    property string arrow_down_icon: '../../images/arrow_down_bold.png'
    property string arrow_up_icon: '../../images/arrow_up_bold.png'

    MainDrawer{
        id: drawer
    }

    Title_bar{
        id: titleBar
    }

    FontLoader {
        id: montserrat
        source: '../../fonts/Montserrat-Medium.ttf'
    }

    PropertyAnimation {
        id: view_of_sets_container_animation
        target: view_of_sets_container
        property: 'height'
        to: if(view_of_sets_container.height === 0) return view_of_sets_container.preferable_height ; else return 0
        duration: 1000
        easing.type: Easing.InOutQuint
    }

    // check if add_set_page height changed, so we can set view_of_sets_container.width to 0,
    // otherwise it causes positioning troubles
    onHeightChanged: {
        view_of_sets_container.height = 0
    }

    Rectangle {
        id: view_of_sets_container
        implicitWidth: add_set_name.width
        implicitHeight: 0

        property int preferable_height: add_set_page.height * 0.28
        property string main_color: '#cdeac2'
        property string on_hover_color: '#bde8aa'

        color: main_color

        radius: 10

        onWidthChanged: {
            view_of_sets_container.height = 0
        }


        z: 1

        ListView {
            id: view_of_sets
            implicitWidth: parent.width
            implicitHeight: parent.height < delegateHeight ? 0 : parent.height - parent.radius * 2

            property int delegateHeight: (view_of_sets_container.preferable_height - view_of_sets_container.radius * 2 ) / 4

            y: parent.radius

            visible: true
            model: MyModel {}
            spacing: 0

            clip: true

            boundsBehavior: Flickable.StopAtBounds

            delegate: Item {
                implicitWidth: view_of_sets.width
                implicitHeight: view_of_sets.delegateHeight

                Rectangle {
                    implicitWidth: parent.width
                    implicitHeight: parent.height

                    color: view_of_sets_container.main_color

                    Text {
                        id: set_name_text
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 10

                        font.pixelSize: Math.min(window.width / 45, window.height / 45)
                        font.family: montserrat.font.family

                        text: display

                        width: parent.width * 0.9
                        wrapMode: Text.Wrap
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            parent.color = view_of_sets_container.on_hover_color
                        }

                        onExited: {
                            parent.color = view_of_sets_container.main_color
                        }

                        onClicked: {
                            add_set_name.text = set_name_text.text
                            view_of_sets_container_animation.running = true
                        }
                    }
                }
            }
        }

    }

    ColumnLayout {
        spacing: window.height * 0.03
        x: (add_set_page.width - drawer.drawerWidthIfNotDrawn - new_card.width) / 2 + drawer.drawerWidthIfNotDrawn
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: name
            text: "Flow"
            Layout.alignment: Qt.AlignHCenter
            font {
                family: 'Dancing Script'
                pixelSize: Math.min(window.width / 8.8, window.height / 8.8)
            }
        }



        ColumnLayout {
            spacing: 40

            TextField {
                id: add_set_name
                font.bold: false
                font.pointSize: Math.min(window.width / 50, window.height / 50)
                font.family: montserrat.font.family
                color: '#fdf7e4'
                placeholderText: 'Add name of your set'
                placeholderTextColor: color
                maximumLength: 25


                verticalAlignment: TextInput.AlignVCenter

                background: Rectangle {
                    radius: 10
                    implicitWidth: window.width * 0.6
                    implicitHeight: window.height * 0.07
                    //color: '#fdf7e4'
                    color: 'transparent'
                    border.width: 3
                    border.color: '#36454F'
                }

                Count_letters {
                    id: count_letters
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 5
                    anchors.rightMargin: 15

                    maximum: add_set_name.maximumLength
                    main_color: add_set_name.color
                }

                onTextChanged: {
                    count_letters.current = add_set_name.text.length

                    if (text.length === 0) {
                        //submit_add_card_button.visible = true
                    } else {
                        //submit_add_card_button.visible = false
                    }
                }

                onActiveFocusChanged: {
                    //submit_add_card_button.visible = activeFocus === true ? true : false
                }

                Rectangle {
                    id: created_sets_view
                    implicitWidth: add_set_name.height * 0.6
                    implicitHeight: add_set_name.height * 0.6
                    radius: created_sets_view.height / 2
                    color: 'transparent'

                    anchors.right: parent.right
                    //anchors.verticalCenter: parent.verticalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.rightMargin: 10

                    Image {
                        id: created_sets_view_image
                        anchors.centerIn: parent

                        width: parent.width * 0.7
                        height: parent.height * 0.7
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        source: view_of_sets_container.height != 0 ? add_set_page.arrow_up_icon : add_set_page.arrow_down_icon

                    }
                    MouseArea {
                        id: created_sets_view_area
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            created_sets_view_image.height = created_sets_view.height * 0.8
                            created_sets_view_image.width = created_sets_view.height * 0.8
                        }
                        onExited: {
                            created_sets_view_image.height = created_sets_view.height * 0.7
                            created_sets_view_image.width = created_sets_view.height * 0.7
                        }
                        onClicked: {
                            view_of_sets_container_animation.running = true

                            if (view_of_sets_container.height === 0) {
                                view_of_sets.model.update(0, view_of_sets.model.data_length())
                            }

                            var gl_position = add_set_name.mapToItem(add_set_page, add_set_name)
                            view_of_sets_container.x = gl_position.x
                            view_of_sets_container.y = gl_position.y + add_set_name.height
                        }
                    }
                }

            }

            Rectangle{
                id: new_card
                radius: 20
                implicitWidth: add_set_name.width
                implicitHeight: add_set_page.height * 0.17
                color: main_color

                property string main_color: '#cdeac2'
                property string on_hover_color: '#bde8aa'

                border.width: 2
                border.color: '#36454F'

                // create the maximum length of new question and answer
                property int maximumLength: 250


                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 2

                    color: parent.border.color
                }

                Text {
                    text: 'Add question'
                    font.pixelSize: 16
                    font.family: montserrat.font.family
                    font.bold: true

                    anchors.top: parent.top
                    anchors.topMargin: 10

                    x: new_card.width / 4 - contentWidth / 2
                }

                Text {
                    text: 'Add answer'
                    font.pixelSize: 16
                    font.family: montserrat.font.family
                    font.bold: true

                    anchors.top: parent.top
                    anchors.topMargin: 10

                    x: new_card.width / 4 * 3 - contentWidth / 2
                }

                Flickable {
                    id: question_flickable
                    implicitWidth: parent.width / 2.5
                    implicitHeight: parent.height * 0.6
                    contentWidth: new_question.width
                    contentHeight: new_question.height
                    clip: true

                    anchors.topMargin: new_card.height / 4
                    anchors.top: parent.top

                    x: new_card.width / 4 - width / 2

                    boundsBehavior: Flickable.StopAtBounds

                    TextEdit {
                        id: new_question
                        property string placeholderText: "Add new question"
                        wrapMode: TextEdit.Wrap

                        width: question_flickable.width

                        font.pixelSize: 16
                        font.family: montserrat.font.family
                        font.bold: true

                        Text {
                            text: new_question.placeholderText
                            color: 'gray'
                            font.pixelSize: 14
                            font.family: montserrat.font.family
                            font.bold: true
                            visible: !new_question.text
                        }

                        onTextChanged: {
                            count_letters_new_question.current = new_question.text.length
                        }

                        onContentHeightChanged: {
                            if (contentHeight > question_flickable.height) {
                                question_flickable.contentY =  contentHeight - question_flickable.height
                            }
                        }

                    }
                }

                Flickable {
                    id: answer_flickable
                    implicitWidth: parent.width / 2.5
                    implicitHeight: parent.height * 0.6
                    contentWidth: new_answer.width
                    contentHeight: new_answer.height
                    clip: true

                    anchors.topMargin: new_card.height / 4
                    anchors.top: parent.top

                    x: new_card.width / 4 * 3 - width / 2

                    boundsBehavior: Flickable.StopAtBounds

                    TextEdit {
                        id: new_answer
                        property string placeholderText: "Add new answer"
                        wrapMode: TextEdit.Wrap

                        width: answer_flickable.width

                        font.pixelSize: 16
                        font.family: montserrat.font.family
                        font.bold: true

                        Text {
                            text: new_answer.placeholderText
                            color: 'gray'
                            font.pixelSize: 14
                            font.family: montserrat.font.family
                            font.bold: true
                            visible: !new_answer.text
                        }

                        onTextChanged: {
                            count_letters_new_answer.current = new_answer.text.length
                        }

                        onContentHeightChanged: {
                            if (contentHeight > answer_flickable.height) {
                                answer_flickable.contentY = contentHeight - answer_flickable.height
                            }
                        }

                    }
                }

                Count_letters {
                    id: count_letters_new_question
                    anchors.bottom: new_card.bottom
                    anchors.bottomMargin: 5

                    x: new_card.width / 2 - width - 15

                    maximum: new_card.maximumLength
                }

                Count_letters {
                    id: count_letters_new_answer
                    anchors.bottom: new_card.bottom
                    anchors.bottomMargin: 5

                    x: new_card.width - width - 15

                    maximum: new_card.maximumLength
                }

            }

            //Add_question {
                //id: container
            //}

            //Add_answer {
                //id: container2
            //}

        }

        Item {
            height: 10
        }

        Rectangle {
            id: submit_add_card_button
            Layout.alignment: Qt.AlignBottom && Qt.AlignHCenter
            implicitHeight: button_text.contentHeight + 30
            implicitWidth: add_set_name.width
            color: main_color
            radius: 5

            border.width: 3
            border.color: '#AFE1AF'

            property string main_color: '#36454F'
            property string on_hover_color: '#1f2f40'

            Text {
                id: button_text
                anchors.centerIn: submit_add_card_button
                text: 'Add card'
                color: '#F5F5DC'
                font.pixelSize: Math.min(window.width / 50, window.height / 50)
                font.family: montserrat.font.family
            }
            MouseArea {
                anchors.fill:  submit_add_card_button
                hoverEnabled: true

                onEntered: {
                    submit_add_card_button.color = submit_add_card_button.on_hover_color
                }
                onExited: {
                    submit_add_card_button.color = submit_add_card_button.main_color
                }
                onClicked: {

                    if (add_set_name.text.length > 0
                    && new_question.text.length > 0
                    && new_answer.text.length > 0
                    && new_question.length <= new_card.maximumLength
                    && new_answer.length <= new_card.maximumLength) {
                        set_op.insert_set_cards([add_set_name.text, new_question.text, new_answer.text])
                        new_question.text = ''
                        new_answer.text = ''
                    }
                }
            }
        }
    }
    Connections {
        target: set_op

        function onInsert_set(stringText){
            if (stringText = 'true'){
                animation_pup_up.running = true
                animation_timer.running = true
            }
        }
    }
    Timer {
        id: animation_timer
        interval: 3000
        running: false
        repeat: false

        onTriggered: {
            animation_pup_up.running = true

        }
    }
    PropertyAnimation {
        id: animation_pup_up
        target: pop_up
        property: 'height'
        to: if(pop_up.height == 0) return parent.height * 0.2; else return 0
        duration: 1000
        easing.type: Easing.InOutQuint
    }

    Rectangle {
        id: pop_up
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.right: parent.right
        color: '#ffffff'
        implicitWidth: parent.width * 0.15
        implicitHeight: 0
        property int fontPixelSize: 0
        Image {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: pop_up.width * 0.4
            height: pop_up.height * 0.4
            fillMode: Image.PreserveAspectFit
            mipmap: true
            source: 'images/acceptance_sign_2.png'
        }
        Text {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            id: pop_up_text
            text: 'The word is added \n       Succesfully!'
            font.pixelSize: 15
        }

    }

}