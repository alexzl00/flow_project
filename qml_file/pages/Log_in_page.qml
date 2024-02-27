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

    Title_bar {
        id: titleBar
        minimizeRestoreButtonVisible: false
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
        Rectangle {
            id: email_field_holder
            width: 260
            height: email_field.height
            radius: 10

            TextField {
                id: email_field
                font.bold: false
                font.pointSize: 20
                placeholderText: 'Enter your email'
                width: parent.width

                background: Rectangle{
                    radius: email_field_holder.radius
                    width: email_field_holder.width

                }
            }
        }

        Text {
            id: email_field_warning
            text: ''
            font.bold: true
            font.pixelSize: 16

        }
        Rectangle {
            id: password_field_holder
            width: 260
            height: password_field.height
            radius: 10

            TextField {
                id: password_field
                font.bold: false
                font.pointSize: 20
                placeholderText: 'Enter your password'
                echoMode: TextInput.Password
                width: parent.width

                background: Rectangle{
                    id: log_p
                    radius: password_field_holder.radius
                    width: password_field_holder.width

                }
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
                    stack.replace(reset_password_page)
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
                text: 'Log in'
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
                    check_email_password.check_email_forbidden(email_field.text)
                    check_email_password.check_password_forbidden(password_field.text)
                    if(email_field_warning.text === '' && password_field_warning.text === ''){
                        check_for_valid_email_password.check_for_valid_info([email_field.text, password_field.text])
                    }

                }
            }
        }
        Connections {
            target: check_email_password

            function onCheck_data(stringText){
                if (stringText == 'false_email') {
                    email_field_warning.text = "Allowed special characters: (-, _)"
                }
                if (stringText == 'false_password') {
                    password_field_warning.text = "Allowed special characters: (-, _)"
                }
                if (stringText == "no_email_issue") {
                    email_field_warning.text = ''
                }
                if (stringText == "no_password_issue") {
                    password_field_warning.text = ''
                }
                if (stringText == 'Email field is required'){
                    email_field_warning.text = stringText
                }
                if (stringText == 'Password field is required'){
                    password_field_warning.text = stringText
                }
            }

        }
        Connections {
            target: check_for_valid_email_password

            function onResponse(stringText){
                if(stringText == 'found'){
                    window.minimumWidth = 999
                    window.minimumHeight = 799
                    window.maximumWidth = Screen.desktopAvailableWidth
                    window.maximumHeight = Screen.desktopAvailableHeight

                    stack.replace(main_flow_page)
                    window.width = 1000
                    window.height = 800
                    window.x = (Screen.desktopAvailableWidth - window.width) / 2
                    window.y = (Screen.desktopAvailableHeight - window.height) / 2

                }

            }
        }
    }

}


