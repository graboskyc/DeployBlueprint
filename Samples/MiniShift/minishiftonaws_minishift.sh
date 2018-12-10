#!/bin/bash

# download minishift
yes | sudo yum install wget
wget https://github.com/minishift/minishift/releases/download/v1.28.0/minishift-1.28.0-linux-amd64.tgz
tar xvzf minishift-1.28.0-linux-amd64.tgz 
rm minishift-1.28.0-linux-amd64.tgz 
sudo mv minishift-1.28.0-linux-amd64/ /opt/minishift

echo "=============================="
echo "ready to run"
echo "stage your ssh key then run:"
echo ""
echo "/opt/minishift/minishift start --vm-driver generic --remote-ipaddress <remote_IP_address> --remote-ssh-user <username> --remote-ssh-key <private_ssh_key>"
echo "/opt/minishift/minishift addon apply htpasswd-identity-provider --addon-env USER_PASSWORD=<NEW_PASSWORD>"
echo ""
echo "use your local IPs (not hostnames) and make sure your AWS SG is set correctly ports 80, 8443, 22, 2376, 53, 8053"