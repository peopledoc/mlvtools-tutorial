#!/usr/bin/env python3
# Generated from ./../extract_dataset.ipynb
import argparse


def mlvtools_extract_dataset(subset: str, data_in: str, output_path: str):
    """
    :param str subset: Subset of data to load {'train', 'test'}
    :param str data_in: File directory path
    :param str output_path: Output file path

    """

    # # Extract train and test data set from 20newsgroups

    import pandas as pd
    from sklearn.datasets import fetch_20newsgroups

    nws_train = fetch_20newsgroups(subset=subset, data_home=data_in)

    df_train = pd.DataFrame(nws_train.data, columns=['data'])
    df_train['target'] = nws_train.target
    df_train['targetnames'] = df_train['target'].apply(lambda n: nws_train.target_names[n])

    df_train.to_csv(output_path, index=None)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Command for script mlvtools_extract_dataset')

    parser.add_argument('--subset', type=str, required=True, help="Subset of data to load {'train', 'test'}")

    parser.add_argument('--data-in', type=str, required=True, help="File directory path")

    parser.add_argument('--output-path', type=str, required=True, help="Output file path")

    args = parser.parse_args()

    mlvtools_extract_dataset(args.subset, args.data_in, args.output_path)
