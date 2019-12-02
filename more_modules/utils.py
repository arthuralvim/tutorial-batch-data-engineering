import csv


def count_csv_lines(file_path):
    with open(file_path, 'r') as csvfile:
        file_object = csv.reader(csvfile, delimiter=',')
        file_line_size = sum(1 for row in file_object)
    return file_line_size
