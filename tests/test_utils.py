from more_modules.utils import count_csv_lines


class TestCsvCounter(object):

    def test_count_csv_lines(self, csv_file_):
        assert count_csv_lines(csv_file_) == 4
