import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: count_letters

    width: 25
    height: 13

    color: 'transparent'

    property int maximum: 10
    property int current: 0

    property string color_on_exceeded: '#ef1910'
    property string main_color: '#808080'

    Text {
        anchors.centerIn: parent
        text: current + ' / ' + maximum
        color: current > maximum ? color_on_exceeded : main_color
    }
}