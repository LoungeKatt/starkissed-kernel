#!/bin/bash

# Copyright (C) 2011 Twisted Playground

# This script is designed by Twisted Playground for use on MacOSX 10.7 but can be modified for other distributions of Mac and Linux

PROPER=`echo $2 | sed 's/\([a-z]\)\([a-zA-Z0-9]*\)/\u\1\2/g'`

if cat /etc/issue | grep Ubuntu; then
    HANDLE=twistedumbrella
    KERNELSPEC=~/android/Tuna_JB_pre1
    UBOOTSPEC=~/android/uboot-tuna
    ANDROIDREPO=~/Dropbox/TwistedServer/Playground
    TOOLCHAIN_PREFIX=~/android/android-toolchain-eabi/bin/arm-eabi-

    cd $KERNELSPEC/mkboot

    gcc -o mkbootfs mkbootfs.c

    gcc -c rsa.c
    gcc -c sha.c
    gcc -c mkbootimg.c
    gcc rsa.o sha.o mkbootimg.o -o mkbootimg
    rm *.o

    cp -R mkbootfs $MKBOOTIMG/linux
    cp -R mkbootimg $MKBOOTIMG/linux

else
    HANDLE=TwistedZero
    KERNELSPEC=/Volumes/android/Tuna_JB_pre1
    UBOOTSPEC=/Volumes/android/uboot-tuna
    ANDROIDREPO=/Users/TwistedZero/Public/Dropbox/TwistedServer/Playground
    TOOLCHAIN_PREFIX=/Volumes/android/android-toolchain-eabi/bin/arm-eabi-
    PUNCHCARD=`date "+%m-%d-%Y_%H.%M"`
fi

echo -n "Dual Boot Image: "
read dualboot

if [ $dualboot == "y" ]; then
    zipfile=$HANDLE"_StarKissed-JB42X-Dual.zip"
    KENRELZIP="StarKissed-JB42X_$PUNCHCARD-Dual.zip"
    KERNELDIR="dualBoot"
    cp -R config/ubuntu_config .config

elif [ $1 == "0" ]; then

    zipfile=$HANDLE"_StarKissed-JB401-Base.zip"
    KENRELZIP="StarKissed-JB401_$PUNCHCARD-Base.zip"
    KERNELDIR="legacySKU"
    cp -R config/legacy_config .config

else
    zipfile=$HANDLE"_StarKissed-JB42X-Base.zip"
    KENRELZIP="StarKissed-JB42X_$PUNCHCARD-Base.zip"
    KERNELDIR="francoAIR"
    cp -R config/$2_config .config
fi

MKBOOTIMG=$KERNELSPEC/buildImg
KERNELREPO=$ANDROIDREPO/kernels
GOOSERVER=loungekatt@upload.goo.im:public_html

CPU_JOB_NUM=8

cd $KERNELSPEC

make clean -j$CPU_JOB_NUM 

make -j$CPU_JOB_NUM ARCH=arm CROSS_COMPILE=$TOOLCHAIN_PREFIX

if [ -e arch/arm/boot/zImage ]; then

if [ $dualboot == "y" ]; then
    cp -R .config arch/arm/configs/dualkissed_defconfig
elif [ $1 == "0" ]; then
    cp -R .config arch/arm/configs/starkissed_legacyfig
else
    cp -R .config arch/arm/configs/starkissed_defconfig
fi

if [ `find . -name "*.ko" | grep -c ko` > 0 ]; then

find . -name "*.ko" | xargs ${TOOLCHAIN_PREFIX}strip --strip-unneeded

if [ $dualboot == "u" ]; then

if [ ! -e $UBOOTSPEC/dualBoot/system ]; then
mkdir $UBOOTSPEC/dualBoot/system
fi
if [ ! -e $UBOOTSPEC/dualBoot/system/lib ]; then
mkdir $UBOOTSPEC/dualBoot/system/lib
fi
if [ ! -e $UBOOTSPEC/dualBoot/system/lib/modules ]; then
mkdir $UBOOTSPEC/dualBoot/system/lib/modules
else
rm -r $UBOOTSPEC/dualBoot/system/lib/modules
mkdir $UBOOTSPEC/dualBoot/system/lib/modules
fi

else

if [ ! -e $KERNELSPEC/$KERNELDIR/system ]; then
mkdir $KERNELSPEC/$KERNELDIR/system
fi
if [ ! -e $KERNELSPEC/$KERNELDIR/system/lib ]; then
mkdir $KERNELSPEC/$KERNELDIR/system/lib
fi
if [ ! -e $KERNELSPEC/$KERNELDIR/system/lib/modules ]; then
mkdir $KERNELSPEC/$KERNELDIR/system/lib/modules
else
rm -r $KERNELSPEC/$KERNELDIR/system/lib/modules
mkdir $KERNELSPEC/$KERNELDIR/system/lib/modules
fi

fi

for j in $(find . -name "*.ko"); do
if [ $dualboot == "u" ]; then
cp -R "${j}" $UBOOTSPEC/dualBoot/system/lib/modules
else
cp -R "${j}" $KERNELSPEC/$KERNELDIR/system/lib/modules
fi
done

else

if [ $dualboot == "u" ]; then

if [ -e $UBOOTSPEC/dualBoot/system/lib ]; then
rm -r $UBOOTSPEC/dualBoot/system/lib
fi

else

if [ -e $KERNELSPEC/$KERNELDIR/system/lib ]; then
rm -r $KERNELSPEC/$KERNELDIR/system/lib
fi

fi

fi

if [ $dualboot == "u" ]; then

cp -R arch/arm/boot/zImage $UBOOTSPEC/buildImg/kernels/default/zImage

cd $UBOOTSPEC
./buildKernel.sh

else

cp -R arch/arm/boot/zImage $MKBOOTIMG

cd $MKBOOTIMG
./img.sh $dualboot $1

echo "building kernel package"
cp -R boot.img ../$KERNELDIR
cd ../$KERNELDIR
rm *.zip
zip -r $zipfile *
cp -R $KERNELSPEC/$KERNELDIR/$zipfile $KERNELREPO/$zipfile

if [ -e $KERNELREPO/$zipfile ]; then
cp -R $KERNELREPO/$zipfile $KERNELREPO/gooserver/$KENRELZIP
scp -P 2222 $KERNELREPO/gooserver/$KENRELZIP  $GOOSERVER/starkissed
rm -r $KERNELREPO/gooserver/*
fi

fi

fi
