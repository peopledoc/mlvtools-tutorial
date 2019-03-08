#!/bin/bash

script_dir=$(dirname $0)

notebook_path=$script_dir/../extract_dataset.ipynb

ipynb_to_python -n $notebook_path -o $script_dir/extract_dataset.py
