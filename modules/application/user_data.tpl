#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install epel -y
sudo yum install ansible -y
sudo yum install git -y


git clone https://github.com/mrvincentoti/ha-laravel-aws-terraform.git /home/ec2-user/laravel

cd /home/ec2-user/laravel/ansible

ansible-playbook webserver.yml -vvvvv -e "db_address=${DB_HOSTNAME}" -e "db_name=${DB_NAME}" -e "db_username=${DB_USERNAME}" -e "db_password=${DB_PASSWORD}"