from PySide6.QtCore import QObject
from PySide6.QtCore import Slot, Signal
import threading

from gotrue.errors import AuthApiError
import main


class ResetPassword(QObject):
    def __init__(self):
        super().__init__()

    response = Signal(bool)

    error_response = Signal(str)

    def send(self, email):
        try:
            main.supabase.auth.sign_in_with_otp({'email': email})
            self.error_response.emit('no error')
        except AuthApiError as e:
            error_message = e.message
            print(error_message)
            if 'Email rate limit exceeded' in error_message:
                self.error_response.emit('Email rate limit exceeded')
            if 'Unable to validate email address: invalid format' in error_message:
                self.error_response.emit('Invalid email format')
            if 'For security purposes, you can only request this once every 60 seconds' in error_message:
                self.error_response.emit('Wait 60 seconds, please')

    @Slot(str)
    def send_otp_for_email(self, email):
        t1 = threading.Thread(target=self.send, args=[email])
        t1.start()

    @Slot(str)
    def verify_token(self, t):
        t = t.split(',')
        email = t[0]
        token = t[1]
        print(email)
        try:
            main.supabase.auth.verify_otp({'email': email, 'token': token, 'type': 'magiclink'})
        except AuthApiError as e:
            # is the most common error
            # Token has expired or is invalid
            self.response.emit(False)

    @Slot(str)
    def set_new_password(self, t):
        t = t.split(',')
        email = t[0]
        new_password = t[1]
        try:
            main.supabase.auth.update_user({'email': email, 'password': new_password})
            self.response.emit(True)
        except AuthApiError as e:
            error_message = e.message
            if 'Email rate limit exceeded' in error_message:
                self.error_response.emit('Wait, 60 seconds to try again, please')
