import json
import logging
from typing import Tuple


def get_json(json_file_path: str) -> dict:
    """
        Load json content from a given path
    """
    try:
        with open(json_file_path, 'r') as fd:
            return json.load(fd)
    except json.JSONDecodeError:
        logging.exception(f'Invalid JSON format for pipeline input: {json_file_path}')
    except IOError:
        logging.exception(f'Can not open pipeline input: {json_file_path}')


def extract_data_from_inputs(json_input_file: str) -> Tuple[int, str]:
    """
        Read input file then extract pipeline data as list of tuples
    """
    json_content = get_json(json_input_file)

    extracted_data = [(review['ratingOverall'], review['segments']) for review in json_content]

    return extracted_data
