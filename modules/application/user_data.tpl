#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install epel -y
sudo yum install ansible -y
sudo yum install git -y