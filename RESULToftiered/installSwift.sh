
mount /dev/mapper/vgtiered-data /mnt/tiered_xmu

sudo mkdir /mnt/tiered_xmu/1 /mnt/tiered_xmu/2 /mnt/tiered_xmu/3 /mnt/tiered_xmu/4
sudo chown ${USER}:${USER} /mnt/tiered_xmu/*
for x in {1..4}; do sudo ln -s /mnt/tiered_xmu/$x /srv/$x; done
sudo mkdir -p /srv/1/node/sdb1 /srv/1/node/sdb5 \
              /srv/2/node/sdb2 /srv/2/node/sdb6 \
              /srv/3/node/sdb3 /srv/3/node/sdb7 \
              /srv/4/node/sdb4 /srv/4/node/sdb8 \
              /var/run/swift
sudo chown -R ${USER}:${USER} /var/run/swift
# **Make sure to include the trailing slash after /srv/$x/**
for x in {1..4}; do sudo chown -R ${USER}:${USER} /srv/$x/; done

cd ~
truncate -s 1GB xfs_file  # create 1GB fil for XFS in your home directory
mkfs.xfs xfs_file
sudo mount -o loop,noatime,nodiratime xfs_file /tmp
sudo chmod -R 1777 /tmp

sudo systemctl enable rsync
sudo systemctl start rsync

rsync rsync://pub@localhost/

sudo systemctl enable memcached.service
sudo systemctl start memcached.service

. $HOME/.bashrc

















