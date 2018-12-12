#!/bin/bash

# https://docs.okd.io/latest/minishift/using/run-against-an-existing-machine.html
# https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce-1

yes | sudo sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
yes | sudo apt-get install docker-ce
sudo ufw disable

yes | sudo apt-get install net-tools firewalld
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-port 2376/tcp --add-port 8443/tcp --add-port 3128/tcp  --add-port 80/tcp
addr=`sudo docker network inspect -f "{{range .IPAM.Config }}{{ .Subnet }}{{end}}" bridge`
sudo firewall-cmd --permanent --new-zone minishift
sudo firewall-cmd --permanent --zone minishift --add-source ${addr}
sudo firewall-cmd --permanent --zone minishift --add-port 53/udp --add-port 8053/udp
sudo firewall-cmd --reload

sudo groupadd docker
sudo gpasswd -a ubuntu docker
sudo usermod -aG docker ubuntu
newgrp docker

echo "Make sure your SGs are set!!! ports 80, 8443, 22, 2376, 53, 8053"