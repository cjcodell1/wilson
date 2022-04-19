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
Moved the true `ls` binary from `/bin/ls` to `/tmp/systemd-resolver`, and replaced it with a backdoored version. The backdoored version calls the true version at `/tmp/systemd-resolver`, but won't display anything if "authorized_keys" would be in the output. By doing this, it conceals the contents of a directory that contains the authorized keys file, which will conceal SSH keys. By moving the true `ls` binary to its new location in `/tmp/`, it is hiding in plain sight.
#### Detection
Run the `debsums` command, which is currently not backdoored, or inspect the `/tmp/` directory.
#### Mediation
Use only the true `ls` binary back at `/tmp/systemd-resolver`, or re-install the `ls` command.

### Backdoored Binary - 'which' command
#### Description
Moved the true `which` binary from `/usr/bin/which` to `/tmp/dnsmasq-tmp-log-199sjduse8kxp200oz8s`, and replaced it with a backdoored version. The backdoored version calls `/tmp/dnsmasq-tmp-log-199sjduse8kxp200oz8s`, but will display "/bin/ps" if `which ps` is called. By doing this, it tricks the user into thinking that the `ps` command in use is at the correct location of `bin/ps`. By moving the true `ls` binary to its new location in `/tmp/`, it is hiding in plain sight.
#### Detection
Run the `debsums` command, which is currently not backdoored, or inspect the `/tmp/` directory.
#### Mediation
Use only the true `which` binary back at `/tmp/dnsmasq-tmp-log-199sjduse8kxp200oz8s`, or re-install the `which` command.

### Create Unauthorized User
#### Description
An unauthorized user `carter` is created.
#### Detection
List users to detect the new unauthorized user.
#### Mediation
Remove the unauthorized user with the `userdel` command.

### Cron Job For SSH Key
#### Description
A cron job is set to run every five minutes that adds a SSH key to the home directory of the user "bob".
#### Detection
Inspect the cron jobs of all users to find any malicious scripts.
#### Mediation
Remove the malicious cron job.
#### Notes
* Will need to be edited with training manager-controlled SSH keys.

### Hidden SSH Key
#### Description
A SSH key for the user "bob" is added in a non-standard place, making it more difficult to find.
#### Detection
Inspect the SSH config files to determine which file is used to store SSH keys.
#### Mediation
Remove errant SSH keys and revert the SSH config file to only direct towards SSH keys in a desired location.
#### Notes
* Will need to be edited with training manager-controlled SSH keys.

### Obvious SSH Key
#### Description
A SSH key for the user "charlie" is added to their "authorized_keys" file, which is the obvious place for SSH keys.
#### Detection
List the `~/.ssh` directory for every user to determine if any SSH keys exist.
#### Mediation
Remove errant SSH keys.
#### Notes
* Will need to be edited with training manager-controlled SSH keys.

### Path Injection - `ps` command
#### Description
Added a new malicious file at `/etc/ps`, which calls the true `ps` binary at `/bin/ps`, except the malicious `ps` won't display any output that include port "6666". The `$PATH` for each user is changed to `export PATH=/etc:$PATH`. By doing this, the `ps` binary at `/etc/ps` is higher in the user's PATH, and therefore will be called before the true `ps` binary.
#### Detection
Inspect all users' PATHs for any discrepancies.
#### Mediation
Revert all users' PATHs to the original value.
#### Notes
* Will need to be edited with the attacker's IP.

## Linux Attacks - Current Interactions
### Backdoored Binary - `ls` command + SSH Key Scripts
The `ls` command is backdoored and does not display the contents of a directory if the "authorized_keys" file is in the directory. Due to this, it interacts very well with any script that creates or updates SSH keys, such as the Cron Job For SSH Key, Hidden SSH Key, and Obvious SSH Key scripts.

### Backdoored Binary - 'which' command + Path Injection - `ps` command
The `which` command is backdoored and displays "/bin/ps" when `which ps` is called. When the script for path injection for the `ps` command is in use, the path injection can be concealed by also using the backdoored `which` command script. When these files interact, the user may think that the current `ps` binary in use is the binary at the true location, at `/bin/ps`--however, the path injection script has instead moved the file.

## Linux Attacks - Future Considerations
* Backdoor `debsums` to not display any alerts for other backdoored binaries.

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
