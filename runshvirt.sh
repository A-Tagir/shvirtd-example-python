!#/bin/bash
PASS=$1
git clone https://github.com/A-Tagir/shvirtd-example-python /opt/virtd/
cd /opt/virtd/
export DB_PASSWORD=$PASS && /usr/bin/docker compose up -d
