
This  repository  is used to record the process of install openstack swift all in one(saio).
=======
`It's according to OpenStack Docs:SAIO(https://docs.openstack.org/swift/latest/development_saio.html#)
and cschwede/django-swiftbrowser(https://github.com/cschwede/django-swiftbrowser).`

It uses Ubuntu 16.04 LTS, and uses a loopback device for storage,
did not set up rsyslog for individual logging.

copy these commands from OpenStack Docs:SAIO
(https://docs.openstack.org/swift/latest/development_saio.html#)
and then write them into swiftInstall.sh,
you can install saio just run "bash swiftInstall.sh"

but before run "bash swiftInstall.sh", you should edit some system configured file
at administrator (root) privileges.

The process of install SAIO:

### 1. Add the following lines to /etc/rc.local (before the exit 0): ###

`mkdir -p /var/cache/swift /var/cache/swift2 /var/cache/swift3 /var/cache/swift4`<br>
`chown <your-user-name>:<your-group-name> /var/cache/swift*`<br>
`mkdir -p /var/run/swift`<br>
`chown <your-user-name>:<your-group-name> /var/run/swiftInstall`<br>

remember change "<your-user-name>" to your current user name of your computer

### 2. Edit /etc/fstab and add: ###

`/srv/swift-disk /mnt/sdb1 xfs loop,noatime,nodiratime,nobarrier,logbufs=8 0 0`<br>
`/home/swift/xfs_file /tmp xfs rw,noatime,nodiratime,attr2,inode64,noquota 0 0`<br>

### 3. edit the following line in /etc/default/rsync: ###
`RSYNC_ENABLE=true`<br>

### 4. run swiftInstall.sh ###
`bash swiftInstall.sh`<br>

### 5. Construct the initial rings using the provided script:  ###
`remakerings`<br>

### 6. Start the “main” Swift daemon processes (proxy, account, container, and object): ###
`cd $HOME/bin`<br>
`sudo ./startmain`<br>
if it has some errors,just do it again.

Other commands like get an X-Storage-Url and X-Auth-Token,or Adding Storage Policies
 to an Existing SAIO.you can follow OpenStack Docs:SAIO
(https://docs.openstack.org/swift/latest/development_saio.html#)

finally it is the swiftbrowser install according to cschwede/django-swiftbrowser
(https://github.com/cschwede/django-swiftbrowser).

following its readme in the repository,you also need to prepare its envoiroment

### 1. Install django ###

`sudo apt-get install python-django`<br>

### 2. Install swiftbrowser: ###

`pip install django-swiftbrowser`<br>


### 3. Please make sure that "tempurl" and "formpost" middlewares are activated in your proxy server. Extract from /etc/swift/proxy-server.conf: ###
`vim /etc/swift/proxy-server.conf`<br>
`[pipeline:main] `<br>
`pipeline = catch_errors gatekeeper healthcheck proxy-logging cache tempurl formpost tempauth proxy-logging proxy-server
`<br>
`pipeline = catch_errors gatekeeper healthcheck proxy-logging cache listing_formats
 bulk tempurl ratelimit crossdomain formpost container_sync tempauth staticweb copy container-quotas account-quotas slo dlo versioned_writes proxy-logging proxy-server
`<br>

`[filter:tempurl] `<br>
`use = egg:swift#tempurl`<br>

`[filter:formpost] `<br>
`use = egg:swift#formpost`<br>

### 4. Run development server: ###

`django-admin runserver --settings=swiftbrowser.settings`<br>

### 5. Open "http://127.0.0.1:8000/" in your browser and use 'account:username' to login (or tenant/project:username if using Keystone).###






