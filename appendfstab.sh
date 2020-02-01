#!/bin/bash
# appendfstab.sh

#set -x
Saferemove() {
	umount /temp_mnt 2>/dev/null
	rm -fr /temp_mnt
}
[[ `id -u` != 0 ]] && echo "Only root can modify /etc/fstab" && exit 1
echo -e "\nPartitions Table on `hostname` :\n"
lsblk
cp /etc/fstab /etc/fstab.save
cp /etc/fstab fstab.new
echo
#[[ -z $1 ]] && read -p "Partition Name (sdXn) : " part || part=$1
while true 
do
	read -p "Partition Name (sdXn) : " part
	expr "$part" : '^[sh]d[a-z][0-9][0-9]*$' >/dev/null 2>&1 && break
	[[ "$part" == "" ]] && echo "Abandon" && exit 10
	echo "$part not a partition ..."
done
grep -q $part /etc/fstab
[[ $? == 0 ]] && echo -e "$part is already in /etc/fstab\nAbandon" && exit 2
blkid |grep -q $part
if [[ $? != 0 ]]; then
	echo "$part not found"
	exit 3
fi  
uuid=`blkid |grep $part |awk '{print $2}' |sed 's/"//g'` 
# UUID peut apparaitre dans le champs 3 de la commande blkid
# par ex une partition "labelisée",  LABEL est dans le champs 2
# ou une clé usb peut donner d'autres infos dans le champs 2
echo $uuid |egrep -q "UUID|LABEL"
if [[ $? != 0 ]] ; then
	uuid=$(blkid | grep $part |awk '{print $3}' |sed 's/"//g')
	echo $uuid |egrep -q "UUID|LABEL"
	if [[ $? != 0 ]] ; then
		echo -e "UUID or LABEL not found ...\nAbandon"
		exit 4
fi ; fi
grep -q $uuid /etc/fstab && echo -e "# $part\n$uuid is already in /etc/fstab\nAbandon" && exit 5
mkdir /temp_mnt 2>/dev/null
# si la partition est visible via fdisk -l mais pas dans /etc/mtab,
# ça signifie qu'elle est ou déjà dans /etc/fstab (avec son LABEL par exple, ou en LVM), donc montée au démarrage,
# ou qu'elle est présente mais pas montée
# On verif si elle est montée
grep -q $part /etc/mtab
[[ $? != 0 ]] && mount /dev/$part /temp_mnt 2>/dev/null
# si ce n'est pas le cas, on la monte pour assigner une valeur à la variable FS
FS=$(grep $part /etc/mtab |awk '{print $3}')
# On ne pourra pas modifier le fstab avec une partition ("labelisée" ou en LVM) déjà présente dans le fichier 
[[ $FS == "" ]] && echo -e "\n# $part\n$uuid\nPartition with LABEL (CRYPTO_LUKS, LVM ...)\nAbandon" && {
	Saferemove
	exit 6
}
read -p "MountPoint : " dir
grep -q $dir /etc/fstab && {
	echo -e "$dir is already a MOUNTPOINT in /etc/fstab\nAbandon"
	Saferemove
	exit 7
}
[[ -e $dir ]] || { mkdir -p $dir && echo "$dir created" && sleep 2 ; }
echo "# $part" >> fstab.new
echo "$uuid $dir $FS defaults 1 2" >> fstab.new
echo
cat fstab.new
echo
read -p "File is correct (N/y) ? : " rep
case $rep in 
	y*|Y*) read -p "Overwrite /etc/fstab (N/y) ? : " rep2
	;;
	* ) echo Abandon
		exit
esac

case $rep2 in 
	y*|Y*)  cp /etc/fstab.new /etc/fstab
	;;
	*) echo Abandon
		exit
esac

Saferemove && rm -fr fstab.new

exit 0

# Écrit par cerulean  <ceruleanfirm@gmail.com>  0x71F86DC1B12845E9
# Août 2017
# Free For All

