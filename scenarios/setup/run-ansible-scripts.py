#!/usr/bin/python3
import argparse, json

# ----------------------------------------------------------
# Arg Parsing
# ----------------------------------------------------------
parser = argparse.ArgumentParser(description='Specify the scenario JSON file')
parser.add_argument('-i', dest='scenario_json_file', help='The scenario JSON file to parse')
args = parser.parse_args()
# ----------------------------------------------------------

# Open Scenario JSON File
with open(args.scenario_json_file, 'r') as f:
  json_data = json.load(f)

print(json_data['linux1'])
