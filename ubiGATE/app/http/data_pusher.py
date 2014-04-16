import httplib2
from threading import Lock

from app.utils.logger import logger

try:
    from simplejson import dumps
except ImportError:
    from json import dumps


class DataPusher(object):

    """Docstring for DataPusher. """

    def __init__(self, host, house, login, password):
        """@todo: to be defined1. """
        self.lock = Lock()
        self.data_list = {'data': []}
        self.host = host
        self.house = house
        self.login = login
        self.password = password

    def push_data(self, data):
        self.data_list['data'].append(data)

    def flush(self):
        self.data_list['data'] = []

    def send(self):
        if not self.data_list['data']:
            return

        self.lock.acquire()

        uri = '%s/ubismart/house/%s/data' % (self.host, self.house)
        logger.info('Preparing to post message %s to uri "%s"'
                    % (self.data_list, uri))
        # h = httplib2.Http(ca_certs='/home/root/idh.lirmm.fr.pem')
        http = httplib2.Http('.cache', disable_ssl_certificate_validation=True)
        http.add_credentials(self.login, self.password)
        try:
            resp, content = http.request(
                uri=uri,
                method="POST",
                headers={'Content-type': 'application/json',
                         'cache-control': 'no-cache'},
                body=dumps(self.data_list))
        except Exception:
            logger.error('Server Not Found')
        else:
            if resp.status == 401:
                # TODO
                logger.error('Connection refused: 401 -'
                             'incorrect username/password')
            elif resp.status != 202:
                logger.error('Connection refused: %s' % resp.status)
            else:
                logger.info('Successfully posted data %s' % self.data_list)
                self.flush()

        self.lock.release()
