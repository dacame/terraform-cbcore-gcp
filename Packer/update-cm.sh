#!/bin/bash

# This script just installs CloduBees Jenkins Distribution in Linux Debian 
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q install wget dialog apt-utils default-jdk apt-transport-https ca-certificates

sudo DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver keyserver.ubuntu.com --recv 38E2F5F39FF90BDA
wget -q -O - https://downloads.cloudbees.com/cloudbees-core/traditional/client-master/rolling/debian/cloudbees.com.key | sudo apt-key add -

echo "deb https://downloads.cloudbees.com/cloudbees-core/traditional/client-master/rolling/debian binary/" | sudo tee -a /etc/apt/sources.list

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q install cloudbees-core-cm