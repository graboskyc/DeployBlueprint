#!/bin/bash

sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt-cache policy docker-ce wget
sudo apt install -y docker-ce

sudo apt install -y python3
wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py

sudo docker pull graboskyc/mongodb-wkshp-spawnhub:latest
sudo docker pull graboskyc/mongodb-wkshp-jupyter:latest
sudo docker run -t -i -d -p 8000:8000 --name testqamdbwkshpsh --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock graboskyc/mongodb-wkshp-spawnhub:latest
