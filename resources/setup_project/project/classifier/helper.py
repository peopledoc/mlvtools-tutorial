import json
from os import makedirs
from os.path import dirname
from typing import List


def write_json(json_file: str, data: dict):
    """
        Create parent directories if not exist.
        Write the json file.
    """
    makedirs(dirname(json_file), exist_ok=True)
    with open(json_file, 'w') as fd:
        json.dump(data, fd)


def write_lines_file(file_path: str, data_list: List[str]):
    """
        Create parent directories if not exist.
        Write the file line by line.
    """
    makedirs(dirname(file_path), exist_ok=True)
    with open(file_path, 'w') as fd:
        fd.writelines(['{}{}'.format(line, '' if line.endswith('\n') else '\n') for line in data_list])
