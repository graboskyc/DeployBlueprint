#!/bin/bash

# download minishift
yes | sudo yum install wget
wget https://github.com/minishift/minishift/releases/download/v1.28.0/minishift-1.28.0-linux-amd64.tgz
tar xvzf minishift-1.28.0-linux-amd64.tgz 
rm minishift-1.28.0-linux-amd64.tgz 
sudo mv minishift-1.28.0-linux-amd64/ /opt/minishift

# virt requiements
yes | sudo yum install libvirt qemu-kvm
sudo curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-centos7 -o /usr/local/bin/docker-machine-driver-kvm
sudo chmod +x /usr/local/bin/docker-machine-driver-kvm
systemctl is-active libvirtd
sudo systemctl start libvirtd
systemctl is-active libvirtd
sudo virsh net-list --all

echo "=============================="
echo "ready to run /opt/minishift/minishift start"