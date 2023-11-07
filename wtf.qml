import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.0

Window {
    id: root

    width: 640
    height: 480
    visible: true
    title: "Hello Python World!"
    Text {
        id: u_t
        text: 'hooo'
    }
    Row {
        id: row_l
        anchors.centerIn: parent
        Button{
            id: click
            text: 'hello'
            onClicked: {
                u_t.text = 'hhhh'
                change.change_button_text(click.text)
            }
        }

        Connections {
            target: change

            function onChangeName(stringText){
                click.text = stringText
            }
        }
    }
}
