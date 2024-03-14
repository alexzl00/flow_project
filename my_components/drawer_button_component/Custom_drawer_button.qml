import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: custom_button
    implicitWidth: drawer.width
    implicitHeight: drawer.height * 0.1
    border.color: '#3aafa9'
    border.width: 2
    color: main_color

    property string main_color: '#2b7a78'
    property string on_hover_color: '#00887a'
    property string image_source: ''

    Image {
        width: custom_button.width
        height: custom_button.height * 0.7
        fillMode: Image.PreserveAspectFit
        mipmap: true
        source: image_source
        anchors.centerIn: parent
    }
}