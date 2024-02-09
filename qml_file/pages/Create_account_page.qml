import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import '../../my_components'

Rectangle {
    id: c_page
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

        Rectangle {
            id: email_field_holder
            height: new_email_field.height
            width: 250
            radius: 10
            z: 1

            TextField {
                id: new_email_field
                font.bold: false
                font.pointSize: 20
                width: parent.width
                placeholderText: 'Set your email'

                background: Rectangle{
                    radius: email_field_holder.radius
                    width: email_field_holder.width

                }

            }
        }

        Text {
            id: email_warning
            text: ''
            font.bold: true
            font.pixelSize: 16
        }

        Rectangle {
            id: password_field_holder
            width: 250
            height: new_password_field.height
            radius: 10

            TextField {
                id: new_password_field
                font.bold: false
                font.pointSize: 20
                placeholderText: 'Set your password'
                echoMode: TextInput.Password
                width: parent.width

                background: Rectangle{
                    radius: password_field_holder.radius
                    width: password_field_holder.width

                }
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
                check_email_password.check_email_forbidden(new_email_field.text)
                check_email_password.check_password_forbidden(new_password_field.text)
                if (email_warning.text === '' && password_warning.text === ''){
                    create_account.create_new_account([new_email_field.text, new_password_field.text])
                    stack.replace(log_page)
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
        target: check_email_password

        function onCheck_data(stringText){
            if (stringText == 'false_email') {
                email_warning.text = "Allowed special characters: (-, _)"
            }
            if (stringText == 'false_password') {
                password_warning.text = "Allowed special characters: (-, _)"
            }
            if (stringText == "no_email_issue") {
                email_warning.text = ''
            }
            if (stringText == "no_password_issue") {
                password_warning.text = ''
            }
            if (stringText == 'Email field is required'){
                email_warning.text = stringText
            }
            if (stringText == 'Password field is required'){
                password_warning.text = stringText
            }
        }

    }

    }
}