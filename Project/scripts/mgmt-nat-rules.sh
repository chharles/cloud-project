#!/bin/bash

sudo apt update &&  sudo apt upgrade -y

sudo iptables-save > install-rules.v4
sudo iptables -F
iptables -I FORWARD -i ens4 -o ens3 -j ACCEPT
iptables -I FORWARD -i ens3 -o ens4 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -I POSTROUTING -o ens3 -j MASQUERADE
sudo iptables-save > nat-rules.v4

sudo apt install iptables-persistent
sudo systemctl enable netfilter-persistent.service