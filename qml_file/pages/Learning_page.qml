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
                id: list_view_item
                radius: 20
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: 	'#FFF5EE'

                Text {
                    id: list_view_item_text
                    text: display
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: list_view_item_area
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        list_view_item.color = '#C0C0C0'
                    }
                    onExited: {
                        list_view_item.color = '#ffffff'
                    }
                    onClicked: {
                        sets_view.visible = false
                        view_of_cards.visible = true
                        view_of_cards.model.wordlist_of_set(list_view_item_text.text)
                    }
                }
            }

        }
    }

    ListView{
        id: view_of_cards
        visible: false
        model: MyModel {}
        anchors.centerIn: parent
        implicitWidth: parent.width * 0.3
        implicitHeight: parent.height * 0.5
        spacing: 10

        delegate: Item{
            implicitWidth: parent.width
            implicitHeight: Math.max(50, cards_view_item_text.contentHeight)
            Rectangle{
                id: cards_view_item
                radius: 20
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: 	'#FFF5EE'

                Text {
                    id: cards_view_item_text
                    text: display
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: cards_view_item_area
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        cards_view_item.color = '#C0C0C0'
                    }
                    onExited: {
                        cards_view_item.color = '#ffffff'
                    }
                }
            }
        }
    }

    Component.onCompleted: sets_view.model.update()
}