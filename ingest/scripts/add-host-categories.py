#! /usr/bin/env python3
"""
From stdin, generates host names using info from the NCBI taxonomy output of the NDJSON record, with output to 'host'

Outputs the modified record to stdout.
"""

import argparse
import json
from sys import stdin, stdout

def parse_args():
    parser = argparse.ArgumentParser(
        description="Generate host names and output to 'host'.")
    parser.add_argument("--latin-field", default='host_latin_name',
        help="Field from the records to use as the host latin name.")
    parser.add_argument("--family-field", default='host_family',
        help="Field from the records to use as the host Family name.")
    parser.add_argument("--genus-field", default='host_genus',
        help="Field from the records to use as the host genus name.")
    parser.add_argument("--group-field", default='host_group',
        help="Field from the records to use as the host group.")
    return parser.parse_args()

def _set_host_name_transformed(record, args):
    latin_replacements = {
        "Canis lupus familiaris": "Domestic Dog",
        "Homo sapiens": "Human",
        "Bos taurus": "Cattle",
        "Didelphis albiventris": "Other Mammal",
        "Elephas maximus": "Other Mammal",
        "Dasypus novemcinctus": "Other Mammal"}
    family_replacements = {"Mephitidae": "Skunk"}
    group_replacements = {
        "odd-toed ungulates": "Other Ungulate",
        "even-toed ungulates & whales": "Other Ungulate",
        "carnivores": "Other Carnivore",
        "bats": "Bat",
        "birds": "Bird",
        "primates": "Other Mammal",
        "rodents": "Other Mammal",
        "mammals": "Other Mammal"
    }
    latin_field = record[args.latin_field]
    family_field = record[args.family_field]
    group_field = record[args.group_field]

    if record[args.family_field] == "Canidae" and record[args.genus_field] == "Vulpes":
        return "Fox (Vulpes sp.)"
    elif record[args.family_field] == "Procyonidae" and record[args.genus_field] == "Procyon":
        return "Raccoon"
    elif latin_field in latin_replacements:
        return latin_replacements[latin_field]
    elif family_field in family_replacements:
        return family_replacements[family_field]
    elif group_field in group_replacements:
        return group_replacements[group_field]
    else:
        return group_field

def main():
    args = parse_args()

    for index, record in enumerate(stdin):
        record = json.loads(record)
        record['host'] = _set_host_name_transformed(record, args)
        stdout.write(json.dumps(record) + "\n")

if __name__ == "__main__":
    main()
