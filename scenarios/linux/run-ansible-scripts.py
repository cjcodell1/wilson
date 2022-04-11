#!/usr/bin/python3
import argparse, json, os

# ----------------------------------------------------------

# Arg Parsing
parser = argparse.ArgumentParser(description="Specify the scenario JSON file")
parser.add_argument("-i", dest="scenario_json_file", help="The scenario JSON file to parse")
parser.add_argument("-p", dest="controller_pwd", help="The password for the controller user")
args = parser.parse_args()

# ----------------------------------------------------------

def main():
  # Open scenario JSON file and change dictionary of scripts to run into list
  vms_data = process_scenario_json_file()

  # For each VM, write an ansible script to a file to run the requested scripts
  for vm_name in list(vms_data.keys()):
    write_control_ansible(vm_name, vms_data[vm_name])

  # Write a script to execute all the ansible playbooks
  write_execute_ansible(vms_data.keys())

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
# vm_name: String, name of given VM data
# vm_data: dict, data for given VM 
def write_control_ansible(vm_name, vm_data):
  # Make ansible script to execute all the playbooks
  with open("ansible_scripts_" + vm_name + ".yml", "w") as f:
    f.write("---\n")
    for script in vm_data["scripts"]:
      f.write("- name: \"run ansible playbook for " + script + "\"\n")
      f.write("  import_playbook: " + script + "\n")

  # Make inventory for given VM
  with open("inventory_" + vm_name + ".ini", "w") as f:
    f.write(vm_data["ip_address"])

# ----------------------------------------------------------

# Write a script to execute all the ansible playbooks
# vm_names: list, Strings of all the VMs
def write_execute_ansible(vm_names):
  # Write the script
  with open("execute_ansible_playbooks.sh", "w") as f:
    f.write("#!/bin/sh\n")
    # For each VM, add an entry for executing the ansible playbook
    for vm_name in vm_names:
      f.write("ansible-playbook -i inventory_" + vm_name + ".ini ansible_scripts_" + vm_name + ".yml --extra-vars \"ansible_user=controller ansible_ssh_pass='" + args.controller_pwd + "' ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_sudo_pass='" + args.controller_pwd + "'\"\n")
  os.system("chmod +x execute_ansible_playbooks.sh")

# ----------------------------------------------------------

# Run main
main()

# ----------------------------------------------------------

