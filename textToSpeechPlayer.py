import threading

from gtts import gTTS
from io import BytesIO
import pygame
from PySide6.QtCore import Slot, QObject, Signal


class TextToSpeech(QObject):
    def __init__(self):
        super().__init__()
        self.stop = False
        self.play_thread = None

    play_response = Signal(str)

    @Slot(str)
    def play_text(self, text):
        if self.play_thread is None:
            tts = gTTS(text=text)

            fp = BytesIO()
            tts.write_to_fp(fp)

            fp.seek(0)

            self.play_thread = threading.Thread(target=self.start_play_text, args=(fp,))
            self.play_thread.start()

            self.play_response.emit('True')

        else:
            self.stop = True

    def start_play_text(self, fp):
        pygame.mixer.init()
        pygame.mixer.music.load(fp)
        pygame.mixer.music.play()

        # set the default value
        self.stop = False

        while pygame.mixer.music.get_busy() and not self.stop:
            pygame.time.Clock().tick(15)

        pygame.mixer.music.stop()
        self.play_thread = None

    @Slot(result=None)
    def stop_playing(self):
        self.stop = True
