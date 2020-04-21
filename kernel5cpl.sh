#!/bin/bash
# kernel5cpl.sh
# for debian_based and redhat_based

[[ $UID == 0 ]] || {
    echo 'run me as root'
    exit 10
}
ps -ef |grep -E 'kernel.*cpl.sh' |grep -vE "grep|$$" && {
	echo -e "script may be already running...\nQuitting"
	exit 12
}
[[ $1 ]] && rel=$1 || read -p "Release (example 5.5 or 5.6.4) : " rel
cd
ls |grep linux-$rel.tar.gz || {
	wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$rel.tar.gz
	[[ $? != 0 ]] && {
	echo "linux-$rel.tar.gz not found in https://cdn.kernel.org/pub/linux/kernel/v5.x/"
	echo "Quitting"
	exit 11
	}
}
rm -f sha256sums.asc
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/sha256sums.asc
ls |grep sha256sums.asc
echo
grep `sha256sum linux-$rel.tar.gz |awk '{print $1}'` sha256sums.asc || {
    echo -e "\nshasum does not match\nQuitting"
    exit 12
}
echo
sleep 2

grep -iq debian /etc/*lease && {
	export DEBIAN_FRONTEND=noninteractive
	apt -o Acquire::ForceIPv4=true update
	apt -o Acquire::ForceIPv4=true install \
		bc \
		pciutils \
		rsync \
		htop \
		curl \
		wget \
		tmux \
		screen \
		git \
		ntpdate \
		dnsutils \
		net-tools \
		binutils \
		build-essential \
		libncurses-dev \
		libncurses5-dev \
		flex \
		bison \
		libssl-dev \
		libelf-dev -y --assume-yes
}
grep -iq CentOS /etc/*lease && yum install centos-release-scl epel-release -y
grep -iq redhat /etc/*lease && {
	yum groupinstall "Development Tools" -y
	yum install bc htop ncurses-devel bison flex elfutils-libelf-devel openssl-devel -y
}
echo
df -h
krnl=/usr/src/kernel5 
echo -e "\ncheck free space on /lib/modules/ or /usr/lib/modules ..." 
echo -e "kernel will be build in $krnl\n"
read -p "20G available is required. Continue ? (N/y) : " av
case $av in 
  y*|Y* ) true ;;
  * ) echo "Quitting" && exit ;;
esac

[[ -d $krnl ]] || mkdir $krnl
cd $krnl
tar xvzf ~/linux-$rel.tar.gz 
cd linux-$rel/

cp /boot/config-`uname -r` .config
#cp /tmp/kernelconfig .config
make menuconfig
echo
grep -e CONFIG_SYSTEM_TRUSTED_KEY -e CONFIG_MODULE_SIG_KEY $krnl/linux-$rel/.config
echo
sleep 4
[[ `nproc` == 1 ]] && make 
[[ `nproc` -gt 1 ]] && make -j$((`nproc` - 1))
make modules_install

sf=`df -m /boot |awk '{print $4}' |sed 1d`
[[ $sf -le 500 ]] && {
    echo -e "\n$sf M available for initrd.img\n"
    df -h /boot
    echo
    read -p "Continue ? (N/y) : " rep
    case $rep in 
      y*|Y* ) true ;;
      * ) echo "Quitting" && exit ;;
    esac
}

make install
grub-mkconfig -o /boot/grub/grub.cfg || {
	grub2-mkconfig -o /boot/grub2/grub.cfg
	grubby --set-default /boot/vmlinuz-$rel
}
