sudo apt-get update
sudo apt-get install curl gcc memcached rsync sqlite3 xfsprogs \
                     git-core libffi-dev python-setuptools \
                     liberasurecode-dev libssl-dev
sudo apt-get install python-coverage python-dev python-nose \
                     python-xattr python-eventlet \
                     python-greenlet python-pastedeploy \
                     python-netifaces python-pip python-dnspython \
                     python-mock

if ! [ -e /srv ]
then
    sudo mkdir /srv
fi
sudo mkfs.xfs -i size=1024 /srv/swift-disk


sudo mkdir /mnt/sdb1
sudo mount /mnt/sdb1
sudo mkdir /mnt/sdb1/1 /mnt/sdb1/2 /mnt/sdb1/3 /mnt/sdb1/4
sudo chown ${USER}:${USER} /mnt/sdb1/*
for x in {1..4}; do sudo ln -s /mnt/sdb1/$x /srv/$x; done
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

cd $HOME; git clone https://github.com/openstack/python-swiftclient.git
cd $HOME/python-swiftclient; sudo python setup.py develop; cd -
git clone https://github.com/openstack/swift.git
cd $HOME/swift; sudo pip install --no-binary cryptography -r requirements.txt; sudo python setup.py develop; cd -

sudo pip install -U xattr
cd $HOME/swift; sudo pip install -r test-requirements.txt

sudo cp $HOME/swift/doc/saio/rsyncd.conf /etc/
sudo sed -i "s/<your-user-name>/${USER}/" /etc/rsyncd.conf

sudo systemctl enable rsync
sudo systemctl start rsync

rsync rsync://pub@localhost/

sudo systemctl enable memcached.service
sudo systemctl start memcached.service

sudo rm -rf /etc/swift
cd $HOME/swift/doc; sudo cp -r saio/swift /etc/swift; cd -
sudo chown -R ${USER}:${USER} /etc/swift

find /etc/swift/ -name \*.conf | xargs sudo sed -i "s/<your-user-name>/${USER}/"

mkdir -p $HOME/bin
cd $HOME/swift/doc; cp saio/bin/* $HOME/bin; cd -
chmod +x $HOME/bin/*

echo "export SAIO_BLOCK_DEVICE=/srv/swift-disk" >> $HOME/.bashrc
sed -i "/find \/var\/log\/swift/d" $HOME/bin/resetswift

cp $HOME/swift/test/sample.conf /etc/swift/test.conf
echo "export SWIFT_TEST_CONFIG_FILE=/etc/swift/test.conf" >> $HOME/.bashrc

echo "export PATH=${PATH}:$HOME/bin" >> $HOME/.bashrc
. $HOME/.bashrc

















