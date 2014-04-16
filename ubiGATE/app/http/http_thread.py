import threading
import time

from app.utils.logger import logger


class HttpThread(threading.Thread):

    """Docstring for DataPoster. """

    def __init__(self, data_pusher):
        """@todo: to be defined1. """
        threading.Thread.__init__(self)
        self.daemon = True
        self.data_pusher = data_pusher

    def run(self):
        while True:
            time.sleep(10)
            logger.info("Periodic checking of the data queue")
            self.data_pusher.send()
