Dacă afișează, de exemplu, vm-doc-server, aflăm grupul:

SVC_GROUP=$(id -gn "$SVC_USER")
echo "Grup serviciu: $SVC_GROUP"

Apoi corectăm accesul:

chown root:"$SVC_GROUP" /etc/vm-doc-server
chmod 750 /etc/vm-doc-server

chown root:"$SVC_GROUP" \
  /etc/vm-doc-server/secrets.enc \
  /etc/vm-doc-server/master.key

chmod 640 \
  /etc/vm-doc-server/secrets.enc \
  /etc/vm-doc-server/master.key

Verifică:

ls -ld /etc/vm-doc-server
ls -l \
  /etc/vm-doc-server/secrets.enc \
  /etc/vm-doc-server/master.key

Ar trebui să fie aproximativ:

drwxr-x--- root vm-doc-server /etc/vm-doc-server
-rw-r----- root vm-doc-server secrets.enc
-rw-r----- root vm-doc-server master.key

Testează explicit că utilizatorul serviciului poate citi:

sudo -u "$SVC_USER" test -r /etc/vm-doc-server/secrets.enc \
  && echo "secrets.enc poate fi citit: OK" \
  || echo "secrets.enc NU poate fi citit"
sudo -u "$SVC_USER" test -r /etc/vm-doc-server/master.key \
  && echo "master.key poate fi citit: OK" \
  || echo "master.key NU poate fi citit"

Apoi:

systemctl restart vm-doc-server
systemctl status vm-doc-server --no-pager
journalctl -u vm-doc-server -n 50 --no-pager

Nu folosi chmod 644, 666 sau 777 pentru fișierele cu secrete.
