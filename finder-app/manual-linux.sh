#!/bin/bash
# Script outline to install and build kernel.
# Author: Siddhant Jajoo.

set -e
set -u

OUTDIR=/tmp/aeld
KERNEL_REPO=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
KERNEL_VERSION=v5.1.10
BUSYBOX_VERSION=1_33_1
FINDER_APP_DIR=$(realpath $(dirname $0))
ARCH=arm64
CROSS_COMPILE=aarch64-none-linux-gnu-

if [ $# -lt 1 ]
then
	echo "Using default directory ${OUTDIR} for output"
else
	OUTDIR=$1
	echo "Using passed directory ${OUTDIR} for output"
fi

mkdir  -p ${OUTDIR}

cd "$OUTDIR"
if [ ! -d "${OUTDIR}/linux-stable" ]; then
    #Clone only if the repository does not exist.
	echo "CLONING GIT LINUX STABLE VERSION ${KERNEL_VERSION} IN ${OUTDIR}"
	git clone ${KERNEL_REPO} --depth 1 --single-branch --branch ${KERNEL_VERSION}
fi
if [ ! -e ${OUTDIR}/linux-stable/arch/${ARCH}/boot/Image ]; then
    cd linux-stable
    echo "Checking out version ${KERNEL_VERSION}"
    git checkout ${KERNEL_VERSION}

    # TODO: Add your kernel build steps here
	#applying the git patch
#	git apply ~/Downloads/dtc-multiple-definition.patch 
	#cleaning
	make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} mrproper
	#defconfig
	make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} defconfig
	#building the kernel
	make -j4 ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} all
fi

echo "Adding the Image in outdir"
cp ${OUTDIR}/linux-stable/arch/arm64/boot/Image ${OUTDIR}/
echo "Creating the staging directory for the root filesystem"
cd "$OUTDIR"
if [ -d "${OUTDIR}/rootfs" ]
then
	echo "Deleting rootfs directory at ${OUTDIR}/rootfs and starting over"
    sudo rm  -rf ${OUTDIR}/rootfs
fi
mkdir ${OUTDIR}/rootfs
cd ${OUTDIR}/rootfs
# TODO: Create necessary base directories
        mkdir -p bin etc home dev lib lib64 proc sys sbin tmp usr
        mkdir -p usr/bin usr/lib usr/sbin
        mkdir -p var/log
        #a=$(pwd)
        #cd  /home/rostom/embedded_linux/assignment-1-bawrostomc/finder-app/ 
        #cp finder.sh finder-test.sh writer  $a/home
        #cd $a
        #cp -r /home/rostom/embedded_linux/assignment-1-bawrostomc/conf .
        #cd ./home && ln -s ../conf conf
        cd ../

if [ ! -d "${OUTDIR}/busybox" ]
then
git clone git://busybox.net/busybox.git
    cd busybox
    git checkout ${BUSYBOX_VERSION}
    # TODO:  Configure busybox
#	make menuconfig
else
    cd busybox
fi

# TODO: Make and install busybox
	make distclean
	make defconfig 
	make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} 
	make CONFIG_PREFIX=../rootfs ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}  install 
cd ../rootfs
echo "Library dependencies"
${CROSS_COMPILE}readelf -a bin/busybox | grep "program interpreter"
${CROSS_COMPILE}readelf -a bin/busybox | grep "Shared library"
cd ../rootfs/
# TODO: Add library dependencies to rootfs
if [ ! -e "lib/ld-linux-aarch64.so.1" ]
then
	cp /tmp/libs/ld-linux-aarch64.so.1 lib/
fi
if [ ! -e "lib64/libc.o.6" ]
then
	cp /tmp/libs/libc.so.6 lib64/ 
fi
if [ ! -e "lib64/libm.o.6" ]
then
	cp /tmp/libs/libm.so.6 lib64/

fi
if [ ! -e "lib64/libresolv.o.6" ]
then
	cp /tmp/libs/libresolv.so.2 lib64/
fi
# TODO: Make device nodes

	sudo mknod -m 666 dev/null c 1 3
	sudo mknod -m 666 dev/console c 5 1

# TODO: Clean and build the writer utility

cd ~/embedded_linux/assignment-1-bawrostomc/finder-app
make clean
make CROSS_COMPILE=aarch64-none-linux-gnu-
# TODO: Copy the finder related scripts and executables to the /home directory
cp writer finder.sh finder-test.sh ${OUTDIR}/rootfs/home
cd ${OUTDIR}/rootfs
# on the target rootfs

# TODO: Chown the root directory
sudo chown root:root .
# TODO: Create initramfs.cpio.gz

find . | cpio -H newc -ov --owner root:root > ${OUTDIR}/initramfs.cpio
gzip -f ${OUTDIR}/initramfs.cpio

