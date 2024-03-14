import QtQuick
import QtQuick.Controls
import QtCharts
import QtQuick.Layouts

Rectangle {
    id: assessment_button
    implicitWidth: test_page.width * 0.08
    implicitHeight: test_page.height * 0.08
    color: main_color
    radius: 10

    property string main_color: ''
    property string on_hover_color: ''
    property string image_source: ''

    Image {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height * 0.7
        fillMode: Image.PreserveAspectFit
        mipmap: true
        source: image_source
    }
}