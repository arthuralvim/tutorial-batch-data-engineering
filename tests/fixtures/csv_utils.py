import pytest
import csv


@pytest.fixture(scope='session')
def csv_file_(tmpdir_factory):
    fn = tmpdir_factory.mktemp('data').join('test.csv')
    headers = ['n']
    with open(fn, 'w') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=headers)
        writer.writeheader()
        writer.writerow({'n': 1})
        writer.writerow({'n': 2})
        writer.writerow({'n': 3})
    return str(fn)
