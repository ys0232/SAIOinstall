#!/bin/bash
#cdir=/media/swift/Elements/downloadtest

rm $HOME/speedTimedown.txt
touch $HOME/speedTimedown.txt
rm time.txt

for i in {1..20}

do
echo "times: "$i>>$HOME/speedTimedown.txt

{ time curl -k -X GET -H 'X-Auth-Token: AUTH_tk939a36d889b14a888cf6fa1cc6ee0b17' http://127.0.0.1:8080/v1/AUTH_test/testSpeedConElement/hadoop-2.7.1.tar.gz >$HOME/hadoop.tar.gz;} 2>>$HOME/speedTimedown.txt
done

sed -ne '/^real|^sys|^user|^times/p'speedTimedown.txt >>time.txt 
 

