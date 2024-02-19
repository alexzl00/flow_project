import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: container
    implicitWidth: window.width * 0.30
    implicitHeight: window.height * 0.17
    radius: 10

    function getQuestionText() {
        return question.text
    }

    function clearQuestionText() {
        question.text = ''
    }

    function setTextToQuestion(text){
        question.text = text
    }

    Flickable {
        id: question_flickable
        width: parent.width * 0.9
        height: parent.height * 0.8
        contentWidth: question.width
        contentHeight: question.height
        clip: true
        anchors.centerIn: parent

        TextEdit {
            id: question
            property string placeholderText: "Add an question"
            wrapMode: TextEdit.Wrap
            width: question_flickable.width

            Text {
                text: question.placeholderText
                color: 'gray'
                font.pixelSize: 14
                font.bold: true
                visible: !question.text
            }

            font.pixelSize: 14
        }
    }
}