#!/bin/bash
# Wordpress Permissions Checker writen by Ercan TOPALAK

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
FOLDER="/home/virtualservers/"


rootpermissions () {
for i in `find $FOLDER -maxdepth 4  ! -name "cache" ! -iname "cache.old" ! -iname "uploads" -type d `; do
        chown -R root: $i
done
echo "rootpermissions done"
}

nobodypermissions () {
for i in `find $FOLDER -maxdepth 4  -name "cache" -type d `; do
        chown -R nobody: $i
done
for i in `find $FOLDER -maxdepth 4  -name "uploads" -type d`; do
        chown -R nobody: $i
done
echo "noboypermissions done"
}

commonpermissions () {
find $FOLDER -type d -exec chmod 755 {} \;
echo "Directories done!"

find $FOLDER -type f -exec chmod 644 {} \;
echo "Folders done!"
}

rootcheck () {
ROOTPERM=`find $FOLDER -maxdepth 4 ! -iname "cache.old" ! -iname "uploads" -type d -print -printf %u\  | grep -v root`

echo $ROOTPERM
if [[ ! -z $ROOTPERM ]]; then
echo "Some files not owner root!"
fi
}

repairperms () {
find $FOLDER -maxdepth 4 ! -iname "cache.old" ! -iname "uploads" -type d -print -printf %u\  | grep -v root > /tmp/files.txt

for i in $(cat /tmp/files.txt | awk '{print $2}'); do
chown root: $i
done

}

#rootpermissions
#nobodypermissions
#commonpermissions
rootcheck

#repairperms