#!/usr/bin/env python

from optparse import OptionParser
import sys

from app.utils.logger import logger
from app.signal import motion_signal, door_signal
from app.http.data_pusher import DataPusher
from app.http.http_thread import HttpThread


def main():
    logger.info("Starting application")
    server, house, username, password = get_options()
    data_pusher = DataPusher(server, house, username, password)
    logger.info('Server: %s\n'
                'House: %s\n'
                'Username: %s' % (server, house, username))

    httpThread = HttpThread(data_pusher)
    httpThread.start()

    while True:
        signal = get_signal()
        logger.debug('Signal received: %s' % signal)
        data = gather_data(signal)
        if data is not None:
            print("test")
            data_pusher.push_data(data)
            data_pusher.send()


def get_options():
    # TODO read a default config from file
    parser = OptionParser()
    parser.add_option('-s', '--server', dest='server', default='localhost',
                      help='URL of the server')
    parser.add_option('-H', '--house', dest='house',
                      help='ID of the house')
    parser.add_option('-u', '--user', dest='username', default='',
                      help='Username')
    parser.add_option('-p', '--password', dest='password', default='',
                      help='Password')
    (options, args) = parser.parse_args()
    if options.house is None:
        logger.error('Unknown House')
        raise ValueError

    return options.server, options.house, options.username, options.password


def get_signal():
    return sys.stdin.readline()


def gather_data(signal):
    signal_types = [motion_signal, door_signal]

    data = None

    for checker in signal_types:
        data = checker.matches(signal)
        if data is not None:
            break

    return data


if __name__ == '__main__':
    main()
