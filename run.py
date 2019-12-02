from decouple import config
import datetime
import logging
import watchtower

DEBUG = config('DEBUG', default=True, cast=bool)
S3_INPUT = config('S3_INPUT', default=None)

logger = logging.getLogger('tutorial-batch-data-engineering')
cloudwatch_handler = watchtower.CloudWatchLogHandler(
    log_group='arthuralvim', stream_name='tutorial-batch-data-engineering')
cloudwatch_handler.setLevel(logging.INFO)
cloudwatch_handler.setFormatter(logging.Formatter('%(message)s'))
logger.addHandler(cloudwatch_handler)


if __name__ == '__main__':
    start_time = datetime.datetime.utcnow()
    print('EXECUTION BEGIN:', start_time)
    print('RUNNING!')
    print('EXECUTION DURATION:', datetime.datetime.utcnow() - start_time)
