# Attack Playbook
## Table of Contents
1. Linux Attacks - Current
2. Linux Attacks - Current Interactions
3. Linux Attacks - Future Considerations
4. Windows Attacks - Current
5. Windows Attacks - Future Considerations

## Linux Attacks - Current

### Alias - `cat` command
#### Description
Added a malicious alias for the `cat` command in the `~/.bashrc` file for the user "alice". This overrides the existing `cat` command with the alias, which will open a reverse shell whenever the "alice" user calls the `cat` command.
#### Detection
Inspect the `~/.bashrc` file for every user to find unusual lines of code.
#### Mediation
Remove the malicious alias from the `~/.bashrc` file for the user "alice".

### Backdoored Binary - 'ls' command
#### Description
Moved the real `ls` to /tmp/, replaced it with a backdoored version that won't display anything if "authorized_keys" would be in the output
#### Detection
Run debsums (currently not backdoored).
#### Mediation
hello

### Backdoored Binary - 'which' command
#### Description
Moved the real `which` to /tmp/, replaced it with a backdoored version that will display '/usr/bin/ps' if 'which ps' is called
#### Detection
Run debsums (currently not backdoored).
#### Mediation
hello

### Create Unauthorized User
#### Description
hello
#### Detection
hello
#### Mediation
hello

### Cron Job For SSH Key
#### Description
hello
#### Detection
hello
#### Mediation
hello
#### Notes
* Will need to be edited with desired SSH keys

### Hidden SSH Key
#### Description
hello
#### Detection
hello
#### Mediation
hello
#### Notes
* Will need to be edited with desired SSH keys

### Obvious SSH Key
#### Description
hello
#### Detection
hello
#### Mediation
hello
#### Notes
* Will need to be edited with desired SSH keys

### Path Injection - 'ps' command
#### Description
Added a malicious file `/etc/ps` that won't display any lines that include the port '6666'. Changed `$PATH` to  `export PATH=/etc:$PATH`
#### Detection
hello
#### Mediation
Use which
#### Notes
* This will be harder to detect if paired with the backdoored which
* Will need to be edited with attacker IP

## Linux Attacks - Current Interactions


## Linux Attacks - Future Considerations


## Windows Attacks - Current
Please note that these have not been tested in the Azure environment, and while they are included in this repository, they should be used with caution.
### Mimikatz
#### Description
hello
#### Detection
hello
#### Mediation
hello
#### Notes
* hello

### Run Keys
#### Description
hello
#### Detection
hello
#### Mediation
hello
#### Notes
* hello

## Windows Attacks - Future Considerations
hello
