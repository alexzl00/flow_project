import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: c_page
    anchors.fill: parent
    width: parent
    height: parent
    gradient: Gradient{
        GradientStop{position: 0.0; color: '#5cdb95'}
        GradientStop{position: 0.7; color: '#379683'}

    }

    Rectangle {
        id: titleBar
        parent: Overlay.overlay
        height: 35
        color: "#1e4258"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        MouseArea {
            id: dragArea
            anchors.fill: parent
            property int mouseXPosition: 1
            property int mouseYPosition: 1

            onPressed: {
                mouseXPosition = mouse.x
                mouseYPosition = mouse.y
            }
            onPositionChanged: {
                window.windowStatus = 0
                window.showNormal()
                window.x = window.x - (mouseXPosition - mouse.x)
                window.y = window.y - (mouseYPosition - mouse.y)
            }

        }

        Row {
            id: button_row
            anchors.right: parent.right
            spacing: 2
            Rectangle {
                id: minimize_button
                height: titleBar.height
                width: titleBar.height + 15
                color: 'transparent'
                Image {
                    id: minimize_button_image
                    width: parent.width
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    source: '../' + window.minimize_button_image_source

                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        minimize_button.color = '#265077'
                    }

                    onExited: {
                        minimize_button.color = 'transparent'
                    }
                    onClicked: {
                        window.showMinimized()
                    }
                }
            }

            Rectangle {
                id: close_button
                height: titleBar.height
                width: titleBar.height + 15
                color: 'transparent'
                Image {
                    id: close_button_image
                    width: parent.width
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    source: '../' + window.close_button_image_source

                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        close_button.color = '#c21807'
                    }

                    onExited: {
                        close_button.color = 'transparent'
                    }
                    onClicked: {
                        window.close()
                    }
                }
            }

        }
    }


    ColumnLayout{
        id: layout
        anchors.centerIn: parent
        spacing: 5
        Text {
            text: "Flow"
            Layout.alignment: Qt.AlignHCenter
            font {
                family: 'Dancing Script'
                pixelSize: 70
            }
        }

        Text {
            text: "Create your account, please"
            Layout.alignment: Qt.AlignHCenter
            font {
                family: 'Italic'
                pixelSize: 20
            }
        }


        TextField {
            id: new_login_field
            font.bold: false
            font.pointSize: 20
            placeholderText: 'Set your login'
            maximumLength: 15

            background: Rectangle{
                id: log_f
                radius: 10
                width: 250

            }
        }

        Text {
            id: login_warning
            text: ''
            font.bold: true
            font.pixelSize: 16
        }

        TextField {
            id: new_password_field
            font.bold: false
            font.pointSize: 20
            placeholderText: 'Set your password'
            maximumLength: 15
            echoMode: TextInput.Password

            background: Rectangle{
                id: new_log_p
                radius: 10
                width: 250

            }
        }

        Text {
            id: password_warning
            text: ''
            font.bold: true
            font.pixelSize: 16
        }

        Switch{
            id: control2
            checked: false
            text: 'See password'
            onClicked: control2.checked ? new_password_field.echoMode = TextInput.Normal : new_password_field.echoMode = TextInput.Password

            indicator: Rectangle {
                implicitWidth: 44
                implicitHeight: 20
                x: control2.leftPadding
                y: parent.height / 2 - height / 2

                radius: 10
                color: control2.checked ? '#ffffff' : '#ffffff'
                border.color: control2.checked ? '#c38d9e': '#cccccc'

                Rectangle{
                    x: control2.checked ? parent.width - width: 0
                    width: 24
                    height: 20
                    radius:10
                    color: control2.down ? '#cccccc' : '#ffffff', control2.checked ? '#116466' : 	'#C0C0C0'

                    border.color: control2.checked ? (control2.down ? '#c38d9e' : '#21be2b') : '#999999'
                }

            }

            contentItem: Text {
                text: control2.checked ? 'Hide password' : 'See password'
//                font: control.font
                font {
                    family: control2.font
                    bold: true
                }
                color: '#ffffff' /*'#0c0032'*/
                verticalAlignment: Text.AlignVCenter
                leftPadding: control2.indicator.width + control2.spacing

            }
        }

    Rectangle {
        id: submit_button
        Layout.alignment: Qt.AlignVCenter
        height: 30
        width: 60
        color: '#ffffff'
        radius: 5
        Text {
            id: button_text
            anchors.centerIn:  submit_button
            text: 'Submit'
            font.pixelSize: 16
        }
        MouseArea {
            anchors.fill:  submit_button
            hoverEnabled: true

            onEntered: {
                submit_button.color = '#C0C0C0'
            }
            onExited: {
                submit_button.color = '#ffffff'
            }
            onClicked: {
                check_login_password.check_login(new_login_field.text)
                check_login_password.check_password(new_password_field.text)
                if (login_warning.text === '' && password_warning.text === ''){
                    check_for_valid_login_password.check_if_login_not_taken(new_login_field.text)
                    if (login_warning.text === '' && password_warning.text === ''){
                        create_account.create_new_account([new_login_field.text, new_password_field.text])
                        stack.replace(log_page)
                    }
                }
            }
        }
    }

    Connections {
        target: create_account

        function onCreateNewAccount(stringText){
            button_text.text = stringText
        }
    }
    Connections {
        target: check_login_password

        function onCheck_data(stringText){
            if (stringText == 'false_login') {
                login_warning.text = "Allowed special characters: (-, _)"
            }
            if (stringText == 'false_password') {
                password_warning.text = "Allowed special characters: (-, _)"
            }
            if (stringText == "no_login_issue") {
                login_warning.text = ''
            }
            if (stringText == "no_password_issue") {
                password_warning.text = ''
            }
            if (stringText == 'Login field is required'){
                login_warning.text = stringText
            }
            if (stringText == 'Password field is required'){
                password_warning.text = stringText
            }
            if (stringText == 'Login field is required'){
                login_warning.text = stringText
            }
        }
    }
    Connections {
        target: check_for_valid_login_password

        function onResponse(stringText){
            if (stringText == 'login is taken'){
                login_warning.text = 'Login is already taken'
            }
            if (stringText == 'login not taken') {
                login_warning.text = ''
            }

        }
    }

    }
}