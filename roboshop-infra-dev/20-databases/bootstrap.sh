#! /bin/bash

sudo dnf install ansible -y
ansible-pull -U https://github.com/Dustboy743/ansible_roboshop_roles.git -e component=$1 main.yml