#!/usr/bin/env bash

set -Eu

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/../.."

# Check if vagrannt VM has been created
if ! VBoxManage list vms | grep -qw "ubuntu-24.04-vagrant"; then
    echo "VM ubuntu-24.04-vagrant not found, creating it ..."
    cd "${PROJECT_TOP_DIR}/test/vagrant/ubuntu-24.04"
    vagrant up # This will create VM and run provision script
    vagrant halt # We need to reboot VM to apply GUI settings
    echo "VM ubuntu-24.04-vagrant created"
    cd ../
else
    echo "VM ubuntu-24.04-vagrant found"
fi

# If user did not clean up the VM, we will do it for him
if VBoxManage list vms | grep -qw "ubuntu-24.04-vagrant-clone"; then
    echo "VM ubuntu-24.04-vagrant-clone found, deleting it ..."
    VBoxManage unregistervm "ubuntu-24.04-vagrant-clone" --delete
    echo "VM ubuntu-24.04-vagrant-clone deleted"
fi

# Create a environment
mkdir -p /home/${USER}/virtualbox/machines/

# We would like to keep the original VM as a baseline, so we will clone it
echo "Cloning VM ubuntu-24.04-vagrant to ubuntu-24.04-vagrant-clone ..."
VBoxManage clonevm "ubuntu-24.04-vagrant" --name "ubuntu-24.04-vagrant-clone" --register --mode all --basefolder /home/${USER}/virtualbox/machines/
echo "VM ubuntu-24.04-vagrant cloned to ubuntu-24.04-vagrant-clone"

# Start the cloned VM
echo "Starting VM ubuntu-24.04-vagrant-clone ..."
VBoxManage startvm "ubuntu-24.04-vagrant-clone" --type GUI
echo "VM ubuntu-24.04-vagrant-clone started"

# Wait for the VM to boot
echo "Waiting 180s for VM to boot ..."
sleep 180

# Before user logs in, Desktop is not created
sshpass -p "vagrant" ssh -p 3022 vagrant@127.0.0.1 "mkdir -p /home/vagrant/Desktop"

# Copy the project to the VM
echo "Copying project to VM ..."
sshpass -p "vagrant" scp -P 3022 -r "${PROJECT_TOP_DIR}/../Personal-Ubuntu-Settings" "vagrant@127.0.0.1:/home/vagrant/Desktop/"
echo "Project copied to VM"

echo "VM ubuntu-24.04-vagrant-clone is ready for testing"
