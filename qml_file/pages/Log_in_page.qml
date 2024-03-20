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

    FontLoader {
        id: montserrat
        source: '../../fonts/Montserrat-Medium.ttf'
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
            height: email_field.height + 10
            radius: 10

            TextField {
                id: email_field
                font.bold: false
                font.pointSize: 14
                font.family: montserrat.font.family
                placeholderText: 'Enter your email'
                width: parent.width

                anchors.verticalCenter: parent.verticalCenter

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
            font.family: montserrat.font.family
            color: '#d50202'
        }
        Rectangle {
            id: password_field_holder
            width: email_field_holder.width
            height: email_field_holder.height
            radius: 10

            TextField {
                id: password_field
                font.bold: false
                font.pointSize: 14
                font.family: montserrat.font.family
                placeholderText: 'Enter your password'
                echoMode: TextInput.Password
                width: parent.width

                anchors.verticalCenter: parent.verticalCenter

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
            font.family: montserrat.font.family
            color: '#d50202'
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
                font {
                    family: montserrat.font.family
                    bold: true
                }
                color: '#ffffff' /*'#0c0032'*/
                verticalAlignment: Text.AlignVCenter
                leftPadding: control.indicator.width + control.spacing

            }
        }

        RowLayout {
            spacing: 20

            Text {
                id: create_account
                text: 'Create account?'
                color: 'black'
                font.underline: false
                font.family: montserrat.font.family

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
                font.family: montserrat.font.family

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
        }

        Item {
            height: 8
        }

        Rectangle {
            id: submit_button
            Layout.alignment: Qt.AlignVCenter
            height: 36
            width: email_field_holder.width
            color: '#28282B'
            radius: 8

            border.width: 2
            border.color: '#AFE1AF'

            Text {
                id: button_text
                anchors.centerIn:  submit_button
                text: 'Log in'
                font.pixelSize: 18
                font.family: montserrat.font.family
                color: '#F5F5DC'
            }
            MouseArea {
                anchors.fill:  submit_button
                hoverEnabled: true

                onEntered: {
                    submit_button.color = '#1B1212'
                }
                onExited: {
                    submit_button.color = '#28282B'
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


