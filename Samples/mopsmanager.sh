#!/bin/bash

echo "Adding repo"
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
echo "Installing npm"
sudo apt-get update
sudo apt-get install -y nodejs

echo "Prepping to install m"
USER=`whoami`
sudo mkdir -p /usr/local/m/versions
sudo chown -R $USER /usr/local/m
sudo npm install -g m