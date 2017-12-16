#!/bin/bash

for i in {1..20}
do 
hdparm -T /dev/mapper/vgtiered-data >>time.txt
done


