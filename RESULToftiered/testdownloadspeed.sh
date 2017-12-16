#!/bin/bash
#cdir=/media/swift/Elements/downloadtest

rm $HOME/speedTimedown.txt
touch $HOME/speedTimedown.txt
rm time.txt

for i in {1..20}

do
echo "times: "$i>>$HOME/speedTimedown.txt

{ time curl -k -X GET -H 'X-Auth-Token:AUTH_tk4a8c2b3d85834ae0b2c6377d31713acc' http://127.0.0.1:8080/v1/AUTH_test/testSpeedConElement/hadoop-2.7.1.tar.gz >$HOME/hadoop.tar.gz;} 2>>$HOME/speedTimedown.txt
done
 

