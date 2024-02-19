import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: container2
    implicitWidth: window.width * 0.30
    implicitHeight: window.height * 0.17
    radius: 10

    function getAnswerText() {
        return answer.text
    }

    function clearAnswerText() {
        answer.text = ''
    }

    function setTextToAnswer(text){
        answer.text = text
    }

    Flickable {
        id: answer_flickable
        width: parent.width * 0.9
        height: parent.height * 0.8
        contentWidth: answer.width
        contentHeight: answer.height
        clip: true
        anchors.centerIn: parent

        TextEdit {
            id: answer
            property string placeholderText: "Add an answer"
            wrapMode: TextEdit.Wrap
            width: answer_flickable.width

            Text {
                text: answer.placeholderText
                color: 'gray'
                font.pixelSize: 14
                font.bold: true
                visible: !answer.text
            }

            font.pixelSize: 14
        }
    }
}