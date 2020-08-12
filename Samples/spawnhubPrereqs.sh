#!/bin/bash

apt update
apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt update
apt-cache policy docker-ce wget
apt install -y docker-ce

apt install -y python3
wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py

docker pull graboskyc/mongodb-wkshp-spawnhub:latest
docker pull graboskyc/mongodb-wkshp-jupyter:latest
docker run -t -i -d -p 8000:8000 --name testqamdbwkshpsh --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock graboskyc/mongodb-wkshp-spawnhub:latest
