from datetime import datetime
import pytz
import re

from ubigate import logger


def matches(signal, timezone):
    """@todo: Docstring for matches.

    :signal: @todo
    :returns: @todo

    """
    # sample matching input: 01/01 00:14:31 Rx RF HouseUnit: A1 Func: On
    logger.debug('Checking motion for signal "%s"' % signal)

    pattern = (r'^(?P<month>\d{2})/(?P<day>\d{2})\s'
               '(?P<hour>\d{2}):(?P<minute>\d{2}):(?P<second>\d{2})\s'
               'Rx\sRF\sHouseUnit:\s(?P<sensor>\w\d+)\s'
               'Func:\s(?P<value>On|Off)$\n*')
    regexp = re.compile(pattern)

    match = regexp.match(signal)

    if match:
        logger.info('Motion detected:')
        tz = pytz.timezone(str(timezone))

        try:
            date = tz.localize(datetime(datetime.now().year,
                                        int(match.group('month')),
                                        int(match.group('day')),
                                        int(match.group('hour')),
                                        int(match.group('minute')),
                                        int(match.group('second'))))
        except ValueError:
            logger.warn('Invalid date: %s-%s-%s %s:%s:%s, event skipped'
                        % (datetime.datetime.now().year, match.group('month'),
                           match.group('day'), match.group('hour'),
                           match.group('minute'), match.group('second')))
            return None
        logger.info('value: "%s", sensor: "%s", date: "%s"' %
                    (match.group('value'),
                     match.group('sensor'), date.isoformat()))

        sensor = match.group('sensor')

        data = {'sensor': sensor,
                'value': match.group('value'),
                'date': date.isoformat()}
        return sensor, data
    return None
