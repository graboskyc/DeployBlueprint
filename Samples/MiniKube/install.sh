#!/bin/bash

function heading {
    echo "+=================================+"
    echo "| $1"
    echo "+=================================+"
    echo
}

heading "Downloading kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

heading "Installing docker"
sudo apt-get update 
sudo apt-get install docker.io -y

sudo groupadd docker
sudo gpasswd -a centos docker
sudo newgrp docker

heading "Installing minikube"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

minikube version
sudo minikube start --vm-driver=none

heading "Importing mongodb"
sudo kubectl create namespace mongodb
sudo kubectl apply -f https://raw.githubusercontent.com/graboskyc/DeployBlueprint/master/Samples/K8SOperator/crd.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/mongodb-enterprise.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/graboskyc/DeployBlueprint/master/Samples/K8SOperator/map.yaml
sudo kubectl -n mongodb create secret generic cmcreds --from-literal="user=chris.grabosky" --from-literal="publicApiKey=8f2f29e1-a248-494c-b4c0-33b0249448ab"
sudo kubectl apply -f https://raw.githubusercontent.com/graboskyc/DeployBlueprint/master/Samples/K8SOperator/rs.yaml
#sudo kubectl logs -f deployment/mongodb-enterprise-operator -n mongodb 

heading "Done"
echo "When done, we need to expose out the dashboard"
echo "Run 'sudo kubectl -n kube-system edit service kubernetes-dashboard' and change type from ClusterIP to NodePort"
echo "Then run ' sudo kubectl -n kube-system get service kubernetes-dashboard' to find the port it is exposed on"
echo "And then make sure that is exposed in the AWS SG"