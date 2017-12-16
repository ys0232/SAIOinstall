
#!/bin/bash

BP="speedbackup.txt"
rm -rf $BP
touch $BP

for i in {1..10}
do 
hdparm -T /dev/mapper/vgbase-lvol0 >>$BP
done



