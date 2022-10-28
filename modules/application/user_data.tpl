#!/bin/bash

sudo apt update -y

sudo apt-get install -y software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible git


git clone https://github.com/mrvincentoti/ha-laravel-aws-terraform.git /home/ec2-user/laravel

cd /home/ec2-user/laravel/ansible

ansible-playbook webserver.yml -vvvvv -e "db_address=${DB_HOSTNAME}" -e "db_name=${DB_NAME}" -e "db_username=${DB_USERNAME}" -e "db_password=${DB_PASSWORD}"