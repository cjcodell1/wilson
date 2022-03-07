#!/usr/bin/python3
import argparse, json

# ----------------------------------------------------------
# Arg Parsing
# ----------------------------------------------------------
parser = argparse.ArgumentParser(description="Specify the scenario JSON file")
parser.add_argument("-i", dest="scenario_json_file", help="The scenario JSON file to parse")
args = parser.parse_args()
# ----------------------------------------------------------

# Open Scenario JSON File
with open(args.scenario_json_file, "r") as f:
  json_data = json.load(f)

# Iterate through the VMs and determine which scripts to run
for vm_name in list(json_data.keys()):
  # Current VM data
  vm_data = json_data[vm_name]
  # List of scripts to run on the VM
  vm_scripts = []

  # Determine which scripts to run
  for script in list(vm_data["scripts"].keys()):
    if vm_data["scripts"][script]:
      vm_scripts.append(script)

  print(vm_scripts)




