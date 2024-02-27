import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../../my_components'

Rectangle {
    id: reset_password_page
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

    Return_to_log_page_button {
        id: return_button
    }

    property string email: ''

    ColumnLayout {
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

                enabled: true

                background: Rectangle{
                    radius: email_field_holder.radius
                    width: email_field_holder.width
                    color: enabled ? '#ffffff' : '#C0C0C0'
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
            id: confirm_token
            width: 260
            height: confirm_token_field.height
            radius: 10

            TextField {
                id: confirm_token_field
                font.bold: false
                font.pointSize: 20
                placeholderText: 'Enter sent code'
                width: parent.width
                enabled: false

                background: Rectangle{
                    radius: confirm_token.radius
                    width: confirm_token.width
                    color: enabled ? '#ffffff' : '#C0C0C0'

                }
            }
        }

        Text {
            id: token_field_warning
            text: ''
            font.bold: true
            font.pixelSize: 16
        }

        Rectangle {
            id: reset_password
            width: 260
            height: reset_password_field.height
            radius: 10

            TextField {
                id: reset_password_field
                font.bold: false
                font.pointSize: 20
                placeholderText: 'Enter new password'
                width: parent.width

                enabled: false

                background: Rectangle{
                    radius: reset_password.radius
                    width: reset_password.width
                    color: enabled ? '#ffffff' : '#C0C0C0'
                }
            }
        }
        Text {
            id: password_field_warning
            text: ''
            font.bold: true
            font.pixelSize: 16

        }

        Rectangle {
            id: submit_button
            Layout.alignment: Qt.AlignVCenter
            height: 30
            width: 100
            color: '#ffffff'
            radius: 5
            Text {
                id: button_text
                anchors.centerIn:  submit_button
                text: 'Send code'
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
                     if (reset_password_field.enabled === true){
                        check_email_password.check_password_forbidden(reset_password_field.text)
                        if (password_field_warning.text === ''){
                            reset_user_password.set_new_password([reset_password_page.email, reset_password_field.text])

                        }
                    }

                    if (confirm_token_field.enabled === true && reset_password_field.enabled === false) {
                        reset_user_password.verify_token([reset_password_page.email, confirm_token_field.text])
                        confirm_token_field.enabled = false
                        reset_password_field.enabled = true
                        button_text.text = 'Set password'
                    }

                    if (confirm_token_field.enabled === false && reset_password_field.enabled === false){
                        check_email_password.check_email_forbidden(email_field.text)
                        reset_password_page.email = email_field.text
                        if(email_field_warning.text === ''){
                            reset_user_password.send_otp_for_email(email_field.text)
                        }
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
            target: reset_user_password

            function onResponse(Boolean) {
                if (Boolean === true){
                    stack.replace(log_page)
                }

                // when the token is checked, if it has expired or is invalid, the page is changed for security
                if (Boolean === false){
                    stack.replace(log_page)
                }
            }

            function onError_response(stringText){
                if (stringText === 'Can be sent once in 60 sec'){
                    email_field_warning.text = stringText
                }
                if (stringText === 'Too Many Requests') {
                    token_field_warning.text = stringText
                }
                if (stringText === 'Wait, 60 seconds to try again, please') {
                    password_field_warning.text = stringText
                }
                if (stringText === 'invalid email') {
                    email_field_warning.text = stringText
                }
                if (stringText === 'Email rate limit exceeded') {
                    email_field_warning.text = stringText
                }
                if (stringText === 'Wait 60 seconds, please') {
                    email_field_warning.text = stringText
                }
                if (stringText === 'no error') {
                    email_field.enabled = false
                    confirm_token_field.enabled = true
                    button_text.text = 'Confirm'
                }
            }
        }
    }
}