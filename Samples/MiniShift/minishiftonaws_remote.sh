#!/bin/bash

# https://docs.okd.io/latest/minishift/using/run-against-an-existing-machine.html

sudo yum install -y net-tools firewalld wget
cd ~/
wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.74-1.el7.noarch.rpm
# wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.12.1.ce-1.el7.centos.x86_64.rpm
sudo yum install -y ./*.rpm
sudo yum install -y docker
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
sudo gpasswd -a centos docker
sudo newgrp docker
sudo ln /usr/bin/dockerd /usr/bin/dockerd-current

echo "Make sure your SGs are set!!! ports 80, 8443, 22, 2376, 53, 8053"