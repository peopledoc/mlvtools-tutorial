#!/usr/bin/env python3
from os.path import dirname, join
from tempfile import mkdtemp

from sklearn.datasets.twenty_newsgroups import download_20newsgroups

cache_path = join(dirname(__file__), 'poc', 'data', '20news-bydate_py3.pkz')

tmp = mkdtemp()
# Temporary directory is removed by download_20newsgroups
buffer = download_20newsgroups(target_dir=tmp, cache_path=cache_path)
