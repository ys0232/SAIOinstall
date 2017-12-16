#!/bin/bash
cdir=/media/swift/Elements/testdata

rm $HOME/speedTime1.txt
touche $HOME/speedTime1.txt
cd $cdir
curl -v -X PUT -H 'X-Auth-Token:  AUTH_tk939a36d889b14a888cf6fa1cc6ee0b17' \
    http://127.0.0.1:8080/v1/AUTH_test/testSpeedConElement


for file in $( ls *);
do 
echo $file
{ time curl -X PUT -v -T $file -H 'X-Auth-Token: AUTH_tk939a36d889b14a888cf6fa1cc6ee0b17' http://127.0.0.1:8080/v1/AUTH_test/testSpeedConElement/$file;} 2>>$HOME/speedTime1.txt
done
cd 

