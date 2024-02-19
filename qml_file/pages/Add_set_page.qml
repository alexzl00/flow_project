import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../../my_components'

Rectangle{
    id: add_set_page
    anchors.fill: parent
    implicitWidth: parent
    implicitHeight: parent
    gradient: Gradient{
        GradientStop{position: 0.0; color: '#5cdb95'}
        GradientStop{position: 0.7; color: '#379683'}
    }

    MainDrawer{
        id: drawer
    }

    Title_bar{
        id: titleBar
    }

    Rectangle {
        id: content
        implicitHeight: parent.height - 35
        implicitWidth: parent.width

        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        color: "#00000000"
        ColumnLayout {
            spacing: window.height * 0.03
            anchors.centerIn: parent
            Text {
                id: name
                text: "Flow"
                Layout.alignment: Qt.AlignHCenter
                font {
                    family: 'Dancing Script'
                    pixelSize: 90
                }
            }
            ColumnLayout {
                TextField {
                    id: add_set_name
                    font.bold: false
                    font.pointSize: 20
                    placeholderText: 'Add a name of your set'
                    maximumLength: 25

                    background: Rectangle{
                        radius: 10
                        implicitWidth: window.width * 0.30
                        implicitHeight: window.height * 0.08

                    }
                }


                Add_question {
                    id: container
                }

                Add_answer {
                    id: container2
                }

            }
            Rectangle {
                id: submit_add_card_button
                Layout.alignment: Qt.AlignBottom && Qt.AlignHCenter
                implicitHeight: window.height * 0.05
                implicitWidth: window.width * 0.07
                color: '#ffffff'
                radius: 5
                Text {
                    id: button_text
                    anchors.centerIn: submit_add_card_button
                    text: 'Add card'
                    font.pixelSize: 16
                }
                MouseArea {
                    anchors.fill:  submit_add_card_button
                    hoverEnabled: true

                    onEntered: {
                        submit_add_card_button.color = '#C0C0C0'
                    }
                    onExited: {
                        submit_add_card_button.color = '#ffffff'
                    }
                    onClicked: {
                        var question = container.getQuestionText()
                        var answer = container2.getAnswerText()

                        set_op.insert_set_cards([add_set_name.text, question, answer])
                        container.clearQuestionText()
                        container2.clearAnswerText()
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

}