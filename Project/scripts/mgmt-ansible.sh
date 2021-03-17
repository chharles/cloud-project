#!/bin/bash

sudo su
apt install python3-dev libffi-dev -y


#virtual environment setup
python3 -m pip install --user virtualenv
python3 -m venv ansible-env

#use virtual environment
source ./env/bin/activate

