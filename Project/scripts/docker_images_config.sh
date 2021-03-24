#!/bin/bash

# This performs the step of pulling images from docker, tagging them correctly
# in our private registry, and pushing them to our private registry.
# The private registry is in management.

# You can perform this script in management

source virtual/bin/activate

echo "kolla/ubuntu-binary-kolla-toolbox
kolla/ubuntu-binary-fluentd
kolla/ubuntu-binary-cron
kolla/ubuntu-binary-collectd
kolla/ubuntu-binary-elasticsearch
kolla/ubuntu-binary-keepalived
kolla/ubuntu-binary-haproxy
kolla/ubuntu-binary-kibana
kolla/ubuntu-binary-memcached
kolla/ubuntu-binary-mariadb
kolla/ubuntu-binary-rabbitmq
kolla/ubuntu-binary-keystone
kolla/ubuntu-binary-cinder-backup
kolla/ubuntu-binary-cinder-volume
kolla/ubuntu-binary-nova-ssh
kolla/ubuntu-binary-nova-compute
kolla/ubuntu-binary-nova-libvirt
kolla/ubuntu-binary-glance-api
kolla/ubuntu-binary-glance-registry
kolla/ubuntu-binary-cinder-scheduler
kolla/ubuntu-binary-cinder-api
kolla/ubuntu-binary-openvswitch-db-server
kolla/ubuntu-binary-neutron-openvswitch-agent
kolla/ubuntu-binary-openvswitch-vswitchd
kolla/ubuntu-binary-nova-conductor
kolla/ubuntu-binary-nova-api
kolla/ubuntu-binary-nova-scheduler
kolla/ubuntu-binary-nova-novncproxy
kolla/ubuntu-binary-placement-api
kolla/ubuntu-binary-ceilometer-compute
kolla/ubuntu-binary-neutron-metadata-agent
kolla/ubuntu-binary-neutron-dhcp-agent
kolla/ubuntu-binary-neutron-l3-agent
kolla/ubuntu-binary-neutron-server
kolla/ubuntu-binary-heat-api
kolla/ubuntu-binary-heat-engine
kolla/ubuntu-binary-heat-api-cfn
kolla/ubuntu-binary-horizon
kolla/ubuntu-binary-mongodb
kolla/ubuntu-binary-ceilometer-central
kolla/ubuntu-binary-ceilometer-notification
kolla/ubuntu-binary-neutron-linuxbridge-agent
kolla/ubuntu-binary-gnocchi-metricd
kolla/ubuntu-binary-gnocchi-api
kolla/ubuntu-binary-gnocchi-statsd
kolla/ubuntu-binary-etcd
kolla/ubuntu-binary-chrony
kolla/ubuntu-binary-keystone-ssh
kolla/ubuntu-binary-keystone-fernet
kolla/ubuntu-binary-placement-api
kolla/ubuntu-binary-mariadb-clustercheck" > docker_image_names

echo '#!/bin/bash

if [ -z "$1" ]; then
        echo "Please provide a file"
else
        F=$1
        while IFS= read -r line; do
                docker pull $line:ussuri
                docker tag $line:ussuri 10.0.1.3:4000/$line:ussuri
                docker push 10.0.1.3:4000/$line:ussuri
        done < $F
fi' > docker_images_init.sh

sudo chmod +x docker_images_init.sh
./docker_images_init.sh ./docker_image_names
