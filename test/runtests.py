#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#

import os
import json
import jsonschema
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--src", default="src", help="Directory with data files (default: src/)")
    parser.add_argument("-v", "--verbose", action='store_true', help="Increase verbosity")
    args = parser.parse_args()

    data_dir = args.src

    with open('schema.json') as schema_file:
        json_schema = json.load(schema_file)

    for file in [file for file in sorted(os.listdir(data_dir)) if file.endswith('.json')]:
        if args.verbose:
            print("[!] %s" % file)

        with open(os.path.join(data_dir, file)) as json_file:
            try:
                json_data = json.load(json_file)
            except ValueError as e:
                raise jsonschema.ValidationError("%s in %s" % (e, file)) from e

            for primarie in json_data:
                try:
                    jsonschema.validate(primarie, json_schema)
                except jsonschema.exceptions.ValidationError as e:
                    raise jsonschema.ValidationError("File: %s" % file) from e
