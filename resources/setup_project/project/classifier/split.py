import random
from typing import List, Tuple


def split_dataset(fasttext_data_set: List[str], test_percent: float) -> Tuple[List[str], List[str]]:
    """
        Shuffle and split the input data set into a train and a test set
        according to the test_percent.
    :param fasttext_data_set: data set on fast text format
    :param test_percent:  percent of test data (ex: 0.10)
    :return: test fasttext data set, train fasttext data set
    """
    random.shuffle(fasttext_data_set)
    split_idx = round(test_percent * len(fasttext_data_set))
    return fasttext_data_set[0: split_idx], fasttext_data_set[split_idx:]
