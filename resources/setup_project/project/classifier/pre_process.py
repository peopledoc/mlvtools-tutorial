from typing import Tuple, List

from nltk import wordpunct_tokenize


def tokenize_and_clean_text(text: str) -> str:
    return ' '.join([token.lower() for token in wordpunct_tokenize(text)
                     if token.isalpha() and token.lower()])


def clean_formatting(text: List[str]) -> str:
    return tokenize_and_clean_text(' '.join(text))


def preprocess_data(extracted_data: List[Tuple[str, str]]) -> List[str]:
    """
        Transform data to get compliant with fasttext expected
        format:  __label__[label] [text]
    """
    return [f'__label__{data[0]} {clean_formatting(data[1])}' for data in extracted_data]
