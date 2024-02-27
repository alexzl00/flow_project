import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: count_letters

    width: 20
    height: 10

    property int maximum: 10
    property int current: 0

    Text {
        anchors.centerIn: parent
        text: current + '/' + maximum
        color: current > maximum ? '#ef1910' : '#808080'
    }
}