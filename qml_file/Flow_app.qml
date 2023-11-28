import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import 'pages'
import MyModel_py 1.0



ApplicationWindow{
    id: window
    width: 400
    height: 500
    //minimumWidth: 400
    //minimumHeight: 500
    //maximumWidth: 400
    //maximumHeight: 500
    visible: true
    title: "Flow"
    flags: Qt.Window | Qt.FramelessWindowHint

    property int windowStatus: 0
    property string maximize_restore_button_image_source: "images/maximize_button.png"
    property string minimize_button_image_source: "images/minimize_button.png"
    property string close_button_image_source: "images/close_button.png"

    QtObject{
        id: internal
        function maximize_restore(){
            if(window.windowStatus === 0){
                window.showMaximized()
                window.windowStatus = 1
                window.maximize_restore_button_image_source = "images/maximized_size_button.png"
            }
            else{
                window.showNormal()
                window.windowStatus = 0
                window.maximize_restore_button_image_source = "images/maximize_button.png"
            }
        }
    }

    MouseArea {
        id: resizeLeft
        width: 10
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor
        onPressed: window.startSystemResize(Qt.LeftEdge)
    }

    MouseArea {
        id: resizeRight
        width: 10
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor
        onPressed: window.startSystemResize(Qt.RightEdge)
    }

    MouseArea {
        id: resizeBottom
        height: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 0
        cursorShape: Qt.SizeVerCursor
        onPressed: window.startSystemResize(Qt.BottomEdge)
    }

    StackView{
        id: stack
        initialItem: log_page
        anchors.fill:parent
        replaceEnter: Transition {
            XAnimator {
                from: (control.mirrored ? -1 : 1) * -control.width
                to: 0
                duration: 1
                easing.type: Easing.OutCubic
            }
        }

        replaceExit: Transition {
            XAnimator {
                from: 0
                to: (control.mirrored ? -1 : 1) * control.width
                duration: 1
                easing.type: Easing.OutCubic
            }
        }
        Component {
            id: log_page
            Log_in_page{id: l_page}
        }

        Component {
            id: create_account_page
            Create_account_page{id: c_page}
        }

        Component {
            id: main_flow_page
            Main_flow_page {id: main_program_page}
        }

        Component {
            id: learning_page
            Learning_page {id: learning_page}
        }
        Component {
            id: add_set_page
            Add_set_page {id: add_set_page}
        }
    }
}