#!/bin/bash

ssh -i kp0.pem root@10.0.1.4 "mv /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak"
echo '# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    version: 2
    ethernets:
        ens3:
            match:
                macaddress: fa:16:3e:b7:9f:2b
            mtu: 1400
            set-name: ens3
        ens4:
            addresses:
            - 10.0.2.4/24
            match:
                macaddress: fa:16:3e:fc:02:ad
            mtu: 1400
            set-name: ens4
        ens5:
            addresses:
            - 10.0.3.4/24
            match:
                macaddress: fa:16:3e:4e:0f:d5
            mtu: 1400
            set-name: ens5
    bridges:
        br0:
            interfaces: [ens3]
            mtu: 1400
            addresses: [10.0.1.4/24]
            gateway4: 10.0.1.3
            nameservers:
                    search: [openstack.auburn.csse, auburn.csse, csse]
                    addresses: [10.0.1.3]
            parameters:
                    stp: false
                    forward-delay: 0
            dhcp4: true
            dhcp6: false' > compute-netplan.yaml
scp -i kp0.pem ./compute-netplan.yaml root@10.0.1.4:/etc/netplan/50-cloud-init.yaml
ssh -i kp0.pem root@10.0.1.4 "netplan apply"

ssh -i kp0.pem root@10.0.1.5 "mv /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak"
echo '# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    version: 2
    ethernets:
        ens3:
            match:
                macaddress: fa:16:3e:9a:c2:8f
            mtu: 1400
            set-name: ens3
        ens4:
            addresses:
            - 10.0.2.5/24
            match:
                macaddress: fa:16:3e:6e:29:b6
            mtu: 1400
            set-name: ens4
        ens5:
            addresses:
            - 10.0.3.5/24
            match:
                macaddress: fa:16:3e:e0:05:2a
            mtu: 1400
            set-name: ens5
    bridges:
        br0:
            interfaces: [ens3]
            addresses: [10.0.1.5/24]
            gateway4: 10.0.1.3
            nameservers:
                    search: [csse, auburn.csse, openstack.auburn.csse]
                    addresses: [10.0.1.3]
            parameters:
                stp: false
                forward-delay: 0' > controller-netplan.yaml
scp -i kp0.pem ./controller-netplan.yaml root@10.0.1.5:/etc/netplan/50-cloud-init.yaml
ssh -i kp0.pem root@10.0.1.5 "netplan apply"


ssh -i kp0.pem root@10.0.1.6 "mv /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak"
echo '# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    version: 2
    ethernets:
        ens3:
            match:
                macaddress: fa:16:3e:aa:92:ff
            mtu: 1400
            set-name: ens3
        ens4:
            addresses:
            - 10.0.2.6/24
            match:
                macaddress: fa:16:3e:67:aa:90
            mtu: 1400
            set-name: ens4
        ens5:
            addresses:
            - 10.0.3.6/24
            match:
                macaddress: fa:16:3e:c3:ec:da
            mtu: 1400
            set-name: ens5
    bridges:
        br0:
            interfaces: [ens3]
            addresses: [10.0.1.6/24]
            gateway4: 10.0.1.3
            nameservers:
                search: [csse, auburn.csse, openstack.auburn.csse]
                addresses: [10.0.1.3]
            parameters:
                stp: false
                forward-delay: 0
            mtu: 1400
            dhcp4: false
            dhcp6: false' > storage-netplan.yaml
scp -i kp0.pem ./storage-netplan.yaml root@10.0.1.6:/etc/netplan/50-cloud-init.yaml
ssh -i kp0.pem root@10.0.1.6 "netplan apply"
#MGMT
#create backup of the mgmt netplant file
mv /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak

#create mgmt netplan file
echo '# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    version: 2
    ethernets:
        ens3:
            addresses:
            - 10.0.0.3/24
            match:
                macaddress: fa:16:3e:3a:2e:d7
            gateway4: 10.0.0.1
            mtu: 1400
            set-name: ens3
        ens4:
            match:
                macaddress: fa:16:3e:a3:9e:7d
            addresses:
            - 10.0.1.3/24
            mtu: 1400
            set-name: ens4
            nameservers:
                    search: [csse, auburn.csse, openstack.auburn.csse]
                    addresses: [10.0.1.3]
        ens5:
            addresses:
            - 10.0.2.3/24
            match:
                macaddress: fa:16:3e:8c:75:cf
            mtu: 1400
            set-name: ens5' > /etc/netplan/50-cloud-init.yaml
netplan apply




    