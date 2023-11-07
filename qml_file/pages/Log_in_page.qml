import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../../my_components'


Rectangle {
    id: l_page
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
                    source: '../../' + window.minimize_button_image_source

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
                    source: '../../' + window.close_button_image_source

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
            id: main_layout
            anchors.centerIn: parent
            spacing: 5
            Text {
                id: name
                text: "Flow"
                Layout.alignment: Qt.AlignHCenter
                font {
                    family: 'Dancing Script'
                    pixelSize: 70
                }
            }

            TextField {
                id: login_field
                font.bold: false
                font.pointSize: 20
                placeholderText: 'Enter your login'
                maximumLength: 15

                background: Rectangle{
                    id: log_f
                    radius: 10
                    width: 250

                }
            }

            Text {
                id: login_field_warning
                text: ''
                font.bold: true
                font.pixelSize: 16

            }

            TextField {
                id: password_field
                font.bold: false
                font.pointSize: 20
                placeholderText: 'Enter your password'
                maximumLength: 15
                echoMode: TextInput.Password

                background: Rectangle{
                    id: log_p
                    radius: 10
                    width: 250

                }
            }

            Text {
                id: password_field_warning
                text: ''
                font.bold: true
                font.pixelSize: 16
            }

            Switch{
                id: control
                checked: false
                text: 'See password'
                onClicked: control.checked ? password_field.echoMode = TextInput.Normal : password_field.echoMode = TextInput.Password

                indicator: Rectangle {
                    implicitWidth: 44
                    implicitHeight: 20
                    x: control.leftPadding
                    y: parent.height / 2 - height / 2

                    radius: 10
                    color: control.checked ? '#ffffff' : '#ffffff'
                    border.color: control.checked ? '#c38d9e': '#cccccc'

                    Rectangle{
                        x: control.checked ? parent.width - width: 0
                        width: 24
                        height: 20
                        radius:10
                        color: control.down ? '#cccccc' : '#ffffff', control.checked ? '#116466' : 	'#C0C0C0'

                        border.color: control.checked ? (control.down ? '#c38d9e' : '#21be2b') : '#999999'
                    }

                }

                contentItem: Text {
                    text: control.checked ? 'Hide password' : 'See password'
    //                font: control.font
                    font {
                        family: control.font
                        bold: true
                    }
                    color: '#ffffff' /*'#0c0032'*/
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: control.indicator.width + control.spacing

                }
            }
            Text {
                id: create_account
                text: 'Create account?'
                color: 'black'
                font.underline: false

                MouseArea{
                    width: create_account.width + 10
                    height: create_account.height
                    hoverEnabled: true
                    onEntered: {
                        create_account.font.underline = true
                        create_account.color = 'blue'
                    }
                    onExited: {
                        create_account.font.underline = false
                        create_account.color = 'black'
                    }
                    onClicked: {
                        stack.replace(create_account_page)
                    }

                }
            }
            Text {
                id: forgot_password
                text: 'Forgot password?'
                color: 'black'
                font.underline: false

                MouseArea{
                    width: forgot_password.width + 10
                    height: forgot_password.height
                    hoverEnabled: true
                    onEntered: {
                        forgot_password.font.underline = true
                        forgot_password.color = 'blue'

                    }
                    onExited: {
                        forgot_password.font.underline = false
                        forgot_password.color = 'black'
                    }

                    onClicked: {
                        forgot_password.text = 'pussy'
                    }

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
                        check_login_password.check_login(login_field.text)
                        check_login_password.check_password(password_field.text)
                        if(login_field_warning.text === '' && password_field_warning.text === ''){
                            check_for_valid_login_password.check_for_valid_info([login_field.text, password_field.text])
                        }

                    }
                }
            }
        Connections {
            target: check_login_password

            function onCheck_data(stringText){
                if (stringText == 'false_login') {
                    login_field_warning.text = "Allowed special characters: (-, _)"
                }
                if (stringText == 'false_password') {
                    password_field_warning.text = "Allowed special characters: (-, _)"
                }
                if (stringText == "no_login_issue") {
                    login_field_warning.text = ''
                }
                if (stringText == "no_password_issue") {
                    password_field_warning.text = ''
                }
                if (stringText == 'Login field is required'){
                    login_field_warning.text = stringText
                }
                if (stringText == 'Password field is required'){
                    password_field_warning.text = stringText
                }
                if (stringText == 'Login field is required'){
                    login_field_warning.text = stringText
                }

            }

        }
        Connections {
            target: check_for_valid_login_password

            function onResponse(stringText){
                if(stringText == 'found'){
                    stack.replace(main_flow_page)
                    window.width = 1000
                    window.height = 800
                    window.x = (Screen.desktopAvailableWidth - window.width) / 2
                    window.y = (Screen.desktopAvailableHeight - window.height) / 2


                    window.minimumHeight.valueOf()
                    window.minimumWidth.valueOf()
                }

            }
        }
    }

}


