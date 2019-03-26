#!/bin/bash

script_dir=$(dirname $0)

notebook_path=$script_dir/extract_dataset.ipynb

jupyter nbconvert --to python $notebook_path --output-dir $script_dir
