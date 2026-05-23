#!/bin/bash

dnf install ansible -y
cd /tmp
git clone https://github.com/rajalingarao/4.12.expense-ansible-roles-expense-terraform-dev.git
cd 4.12.expense-ansible-roles-expense-terraform-dev
ansible-playbook main.yaml -e component=backend -e login_password=ExpenseApp1
ansible-playbook main.yaml -e component=frontend