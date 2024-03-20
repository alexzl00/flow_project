import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: container
    implicitWidth: window.width * 0.30
    implicitHeight: window.height * 0.17
    radius: 10

    color: '#fdf7e4'

    border.width: 3
    border.color: '#36454F'


    function getQuestionText() {
        return question.text
    }

    function clearQuestionText() {
        question.text = ''
    }

    function setTextToQuestion(text){
        question.text = text
    }

    function getQuestionMaximumLength() {
        return question.maximumLength
    }

    Count_letters {
        id: count_letters
        anchors.bottom: container.bottom
        anchors.right: container.right
        anchors.bottomMargin: 5
        anchors.rightMargin: 15

        maximum: question.maximumLength
    }

    Flickable {
        id: question_flickable
        width: parent.width * 0.9
        height: parent.height * 0.78
        contentWidth: question.width
        contentHeight: question.height
        clip: true
        anchors.centerIn: parent

        boundsBehavior: Flickable.StopAtBounds

        FontLoader {
            id: montserrat
            source: '../fonts/Montserrat-Medium.ttf'
        }

        TextEdit {
            id: question
            property string placeholderText: "Add an question"
            wrapMode: TextEdit.Wrap
            width: question_flickable.width

            font.pixelSize: Math.min(window.width / 50, window.height / 50)

            property int maximumPossibleLength: 999

            font.family: montserrat.font.family

            // length that can be saved in database
            property int maximumLength: 200

            Text {
                text: question.placeholderText
                color: 'gray'
                font.pixelSize: 14
                font.family: montserrat.font.family
                font.bold: true
                visible: !question.text
            }

            onTextChanged: {
                // cuts the text that exceeds maximumLength
                if (question.text.length > question.maximumLength) remove(question.maximumPossibleLength, question.text.length);

                count_letters.current = question.text.length
            }
        }
    }
}