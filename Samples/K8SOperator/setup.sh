#!/bin/bash

function heading {
    echo "+=================================+"
    echo "| $1"
    echo "+=================================+"
    echo
}

heading "Prep minishift vm!"
echo "Go to https://github.com/minishift/minishift or https://www.okd.io/minishift/ and follow directions"
echo "Install is here: https://docs.okd.io/latest/minishift/getting-started/installing.html"
echo "Do: brew install docker-machine-driver-xhyve"
echo "Do: sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve"
echo "Do: sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve"
echo "Do: brew cask install minishift"
echo "Press enter to continue"
read
echo
echo "What is the org ID in Cloud Manager?"
echo "What is the API key for Cloud Manager?"
echo "Make sure you white list that API!"
echo "Once you know these, press enter"
read
echo "We will basically be following this tutorial: https://github.com/mongodb/mongodb-enterprise-kubernetes"
echo "From https://github.com/graboskyc/DeployBlueprint/tree/master/Samples/K8SOperator download all the yaml files there"
echo "PUT THEM IN THIS DIRECTORY SAME AS THIS SCRIPT IS RUNNING FROM!!!!"
echo "Press enter when ready to continue"
read
echo "Edit map.yaml and change the org id to yours from your cloud manager"
echo "Press enter when ready to continue"
read
echo "What is your cloud manager username?"
read cmun
echo "What is your cloud manager api key?"
read cmapi
echo
echo "OK now are you ready to do this? Press enter to go!"
heading "Starting minishift"
minishift start
echo
heading "Prepping OC Client"
wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-mac.zip -O ~/Downloads/oc.zip
unzip ~/Downloads/oc.zip -d ~/Downloads/oc
rm ~/Downloads/oc.zip
heading "Logging in as root"
~/Downloads/oc/oc login -u system:admin
heading "Create namespace"
~/Downloads/oc/oc create namespace mongodb
heading "Create crd"
~/Downloads/oc/oc apply -f ~/Desktop/crd.yaml
heading "Add operator"
~/Downloads/oc/oc apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/mongodb-enterprise.yaml
heading "Create config map"
~/Downloads/oc/oc apply -f ~/Desktop/map.yaml
heading "Add cred secret"
~/Downloads/oc/oc -n mongodb create secret generic cmcreds --from-literal="user=$cmun" --from-literal="publicApiKey=$cmapi"
heading "deploy it"
~/Downloads/oc/oc apply -f ~/Desktop/rs.yaml