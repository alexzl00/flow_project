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

    function getAnswerMaximumLength() {
        return answer.maximumLength
    }

    Count_letters {
        id: count_letters
        anchors.bottom: container2.bottom
        anchors.right: container2.right
        anchors.bottomMargin: 5
        anchors.rightMargin: 15

        maximum: answer.maximumLength
    }

    Flickable {
        id: answer_flickable
        width: parent.width * 0.9
        height: parent.height * 0.78
        contentWidth: answer.width
        contentHeight: answer.height
        clip: true
        anchors.centerIn: parent

        boundsBehavior: Flickable.StopAtBounds

        TextEdit {
            id: answer
            property string placeholderText: "Add an answer"
            wrapMode: TextEdit.Wrap
            width: answer_flickable.width

            font.pixelSize: Math.min(window.width / 50, window.height / 50)

            property int maximumPossibleLength: 999


            // length that can be saved in database
            property int maximumLength: 200

            Text {
                text: answer.placeholderText
                color: 'gray'
                font.pixelSize: 14
                font.bold: true
                visible: !answer.text
            }

            onTextChanged: {
                // cuts the text that exceeds maximumLength
                if (answer.text.length > answer.maximumLength) remove(answer.maximumPossibleLength, answer.text.length);

                count_letters.current = answer.text.length
            }
        }
    }
}