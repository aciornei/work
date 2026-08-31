cd /usr/local/src/vm-doc-server-0.3.0

sudo systemctl stop vm-doc-collector
sudo systemctl stop vm-doc-server

sudo install -o root -g root -m 0755 \
  bin/vm-doc-server \
  /opt/vm-doc-server/bin/vm-doc-server

sudo install -o root -g root -m 0755 \
  bin/vm-doc-collector \
  /opt/vm-doc-server/bin/vm-doc-collector

sudo systemctl start vm-doc-server
sleep 3

sudo systemctl start vm-doc-collector
