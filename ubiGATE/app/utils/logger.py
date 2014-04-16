import sys
import logging

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

# create a logging format
formatter = logging.Formatter(('%(asctime)s - %(name)s - '
                               '%(levelname)s - %(message)s'))

# create a file handler
file_handler = logging.FileHandler('data.log')
file_handler.setFormatter(formatter)

# create a stdout handler
stdout_handler = logging.StreamHandler(sys.stdout)
stdout_handler.setFormatter(formatter)

# add the handlers to the logger
logger.addHandler(file_handler)
logger.addHandler(stdout_handler)
