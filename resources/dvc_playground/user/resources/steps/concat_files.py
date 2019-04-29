#!/usr/bin/env python3
import glob
import logging
from argparse import ArgumentParser
from os.path import isdir

if __name__ == '__main__':
    parser = ArgumentParser(description='Concat files from a directory')
    parser.add_argument('-i', '--input-dir', required=True, help='Contains files to concat')
    parser.add_argument('-o', '--output-file', required=True, help='Result file')

    args = parser.parse_args()

    if not isdir(args.input_dir):
        logging.error(f'Not a directory: {args.input_dir}')
    else:
        with open(args.output_file, 'w') as fd_write:
            for file in sorted(glob.glob(f'{args.input_dir}/*.input')):
                with open(file, 'r') as fd_read:
                    fd_write.write(fd_read.read())
