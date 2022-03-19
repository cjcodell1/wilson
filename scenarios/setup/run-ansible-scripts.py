#!/usr/bin/python3
import argparse, json

# ----------------------------------------------------------

# Arg Parsing
parser = argparse.ArgumentParser(description="Specify the scenario JSON file")
parser.add_argument("-i", dest="scenario_json_file", help="The scenario JSON file to parse")
args = parser.parse_args()

# ----------------------------------------------------------

def main():
  # Open scenario JSON file and change dictionary of scripts to run into list
  vms_data = process_scenario_json_file()

  # For each VM, write an ansible script to a file to run the requested scripts
  for vm_name in list(vms_data.keys()):
    write_control_ansible(vms_data[vm_name])
  
# ----------------------------------------------------------

# Open scenario JSON file and change dictionary of scripts to run into list
def process_scenario_json_file():
  # Open Scenario JSON File
  with open(args.scenario_json_file, "r") as f:
    json_data = json.load(f)

  # Iterate through the VMs and get the requested scripts
  for vm_name in list(json_data.keys()):
    # Current VM data
    vm_data = json_data[vm_name]
    # List of scripts to run on the VM
    vm_scripts = []

    # Determine which scripts to run
    for script in list(vm_data["scripts"].keys()):
      if vm_data["scripts"][script]:
        vm_scripts.append(script)

    # Change the dictionary of scripts for this VM into list
    json_data[vm_name]["scripts"] = vm_scripts

  # Return the list of scripts per VM
  return json_data

# ----------------------------------------------------------

# For the given VM, write an ansible script to a file to run the requested scripts
def write_control_ansible(vm_data):
  print(vm_data)
  script_dir = hi

# ----------------------------------------------------------

# Run main
main()

# ----------------------------------------------------------

