#!/usr/bin/env python3
import json
import logging
from argparse import ArgumentParser
from random import randint
from typing import List

noise_chars = ['!', '?', '§', 'X', 'r', 'd', 'D', '¨', '$', '£', '"', "€", '°', '}', '{', '[']


def add_noise(content_lines: List[str]):
    replaced_content = []
    max_line_lenght = len(max(content_lines, key=len))
    for line in content_lines:
        line = line.replace('\n', '')
        if len(line) < max_line_lenght:
            line = line + (max_line_lenght - len(line)) * ' '
        replaced_content.append(''.join([noise_chars[randint(0, len(noise_chars) - 1)] if char == ' ' else char
                                         for char in line]))
    return [f'{line}\n' for line in replaced_content]


def remove_noise(content_lines: List[str]):
    return [''.join(' ' if char in noise_chars else char for char in line) for line in content_lines]


def shift_rows(content_lines: List[str], shift: int):
    nb_lines = len(content_lines)
    return [content_lines[(i + shift) % nb_lines] for i in range(0, nb_lines)]


def unshift_rows(content_lines: List[str], shift: int):
    nb_lines = len(content_lines)
    return [content_lines[(i - shift) % nb_lines] for i in range(0, nb_lines)]


def shift_cols(content_lines: List[str], even_shift: int, odd_shift: int):
    shifted_content = []
    for idx, line in enumerate(content_lines):
        line = line.replace('\n', '')
        new_line = ''
        if idx % 2 == 0:
            for char_id in range(0, len(line)):
                new_line += line[(char_id + even_shift) % len(line)]
        else:
            for char_id in range(0, len(line)):
                new_line += line[(char_id + odd_shift) % len(line)]
        shifted_content.append(new_line)

    return [f'{line}\n' for line in shifted_content]


def unshift_cols(content_lines: List[str], even_shift: int, odd_shift: int):
    unshifted_content = []
    for idx, line in enumerate(content_lines):
        line = line.replace('\n', '')
        new_line = ''
        if idx % 2 == 0:
            for char_id in range(0, len(line)):
                new_line += line[(char_id - even_shift) % len(line)]
        else:
            for char_id in range(0, len(line)):
                new_line += line[(char_id - odd_shift) % len(line)]
        unshifted_content.append(new_line)

    return [f'{line}\n' for line in unshifted_content]


def encrypt(encrypted_file: str, output_file: str, row_shift: int, col_even_shift: int, col_odd_shift: int):
    with open(encrypted_file, 'r') as fd:
        content_lines = fd.readlines()

    noisy_content = add_noise(content_lines)
    row_shifted = shift_rows(noisy_content, shift=row_shift)
    col_shifted = shift_cols(row_shifted, even_shift=col_even_shift, odd_shift=col_odd_shift)

    with open(output_file, 'w') as fd:
        fd.writelines(col_shifted)


def decrypt(encrypted_file: str, output_file: str, row_shift: int, col_even_shift: int, col_odd_shift: int):
    with open(encrypted_file, 'r') as fd:
        content_lines = fd.readlines()

    col_unshifted = unshift_cols(content_lines, even_shift=col_even_shift, odd_shift=col_odd_shift)
    row_unshifted = unshift_rows(col_unshifted, shift=row_shift)
    decrypted_content = remove_noise(row_unshifted)

    with open(output_file, 'w') as fd:
        fd.writelines(decrypted_content)


if __name__ == '__main__':
    parser = ArgumentParser(description='Decrypt file!')
    parser.add_argument('-i', '--input-file', required=True)
    parser.add_argument('-o', '--output-file', required=True)
    parser.add_argument('-p', '--param-file', required=True)
    parser.add_argument('-e', '--encrypt', action='store_true')

    args = parser.parse_args()
try:
    with open(args.param_file, 'r') as fd:
        params = json.load(fd)

    row_shift = params['row_shift']
    col_even_shift = params['col_even_shift']
    col_odd_shift = params['col_odd_shift']

    if args.encrypt:
        encrypt(args.input_file, args.output_file, row_shift, col_even_shift, col_odd_shift)
    else:
        decrypt(args.input_file, args.output_file, row_shift, col_even_shift, col_odd_shift)
except KeyError as e:
    logging.error(f'Parameter error: {e}')
except json.JSONDecodeError as e:
    logging.error(f"Parameter file wrongly formated {e}")
except IOError as e:
    logging.error(f'IOError: {e}')

