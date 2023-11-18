import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../../my_components'
import MyModel_py 1.0

Rectangle{
    id: learning_page
    anchors.fill: parent
    implicitWidth: parent
    implicitHeight: parent

    gradient: Gradient{
        GradientStop{position: 0.0; color: '#5cdb95'}
        GradientStop{position: 0.7; color: '#379683'}
    }

    Title_bar{
        id: titleBar
    }

    MainDrawer{
        id: drawer
    }

    ListView{
        id: sets_view
        anchors.centerIn: parent
        implicitWidth: parent.width * 0.3
        implicitHeight: parent.height * 0.5
        model: MyModel {}
        spacing: 10

        delegate: Item{
            implicitWidth: parent.width
            implicitHeight: 50
            Rectangle{
                radius: 20
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: 	'#FFF5EE'

                Text {
                    text: display
                    anchors.centerIn: parent
                }
            }

        }
    }

    Component.onCompleted: sets_view.model.append()
}