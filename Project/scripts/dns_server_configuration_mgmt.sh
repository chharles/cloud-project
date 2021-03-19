#!/bin/bash
# commands to set up DNS server on management node

# become root user
sudo su

# setting the host name for mgmt node
# the other host names are:
# storage.openstack.auburn.csse
# compute.openstack.auburn.csse
# controller.openstack.auburn.csse
hostnamectl set-hostname mgmt.openstack.auburn.csse
ssh -i kp0.pem root@10.0.1.6 "hostnamectl set-hostname storage.openstack.auburn.csse"
ssh -i kp0.pem root@10.0.1.4 "hostnamectl set-hostname compute.openstack.auburn.csse"
ssh -i kp0.pem root@10.0.1.5 "hostnamectl set-hostname controller.openstack.auburn.csse"

# verify you updated the hostname
hostnamectl

# update the repository index
apt update

# static ip addresses have already been set via OpenStack

# install DNS server package
apt install -y bind9 bind9utils bind9-doc dnsutils

# cd into the bind directory and show files
ls /etc/bind

# next you would create a zones file that holds all of your zones and their
# configurations
# this is in the "dns_server (bind9) folder" and is: "named.conf.local"
echo '//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";

zone "openstack.auburn.csse" IN {
        type master;
        file "/etc/bind/forward.openstack.auburn.csse";
        allow-update { none; };
};

zone "1.0.10.in-addr.arpa" IN {
        type master;
        file "/etc/bind/reverse.openstack.auburn.csse";
        allow-update { none; };
};' > /etc/bind/named.conf.local

# next is creating zone lookup files
# we need to create forward and reverse zones for being able to ping both domains
# and ip addresses
# these are in the "dns_server (bind9) folder" and are named:
# "reverse.openstack.auburn.csse" & "forward.openstack.auburn.csse"
echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     mgmt.openstack.auburn.csse. root.openstack.auburn.csse. (
                              3         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
;@      IN      NS      localhost.
;@      IN      A       127.0.0.1
;@      IN      AAAA    ::1

@       IN      NS      mgmt.openstack.auburn.csse.

mgmt.openstack.auburn.csse.     IN      A       10.0.1.3

controller.openstack.auburn.csse.       IN      A       10.0.1.5

compute.openstack.auburn.csse.  IN      A       10.0.1.4

storage.openstack.auburn.csse.  IN      A       10.0.1.6' > /etc/bind/forward.openstack.auburn.csse

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     mgmt.openstack.auburn.csse. root.openstack.auburn.csse. (
                              3         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
;@      IN      NS      localhost.
;@      IN      A       127.0.0.1
;@      IN      AAAA    ::1

@       IN      NS      mgmt.openstack.auburn.csse.

3       IN      PTR     mgmt.openstack.auburn.csse.

4       IN      PTR     compute.openstack.auburn.csse.

5       IN      PTR     controller.openstack.auburn.csse.

6       IN      PTR     storage.openstack.auburn.csse.' > /etc/bind/reverse.openstack.auburn.csse

# to check for named.conf file errors:
named-checkconf

# to check for any zone lookup file errors:
named-checkzone openstack.auburn.csse /etc/bind/forward.openstack.auburn.csse
named-checkzone 1.0.10.in-addr.arpa /etc/bind/reverse.openstack.auburn.csse

# every time you change something in the zone lookup files
# increment the serial # in the zone file and reload the file by:
rndc reload openstack.auburn.csse
rndc reload 1.0.10.in-addr.arpa

# then restart bind9, enable it for system startup, and check status by
systemctl restart bind9
systemctl enable bind9
systemctl status bind9

# set up DNS configuration in NIC file
# in netplan yaml file by adding search and addresses fields
# to nameservers field

# can confirm by using nslookup of full domains and pinging domains
