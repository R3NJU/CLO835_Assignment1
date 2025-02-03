#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
newgrp docker
sudo chmod 666 /var/run/docker.sock
sudo docker network create -d bridge --subnet 10.0.0.0/24 --gateway 10.0.0.1 my-nw