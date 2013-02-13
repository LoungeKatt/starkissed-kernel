#!/bin/bash

# Copyright (C) 2011 Twisted Playground

# This script is designed by Twisted Playground for use on MacOSX 10.7 but can be modified for other distributions of Mac and Linux

PROPER=`echo $2 | sed 's/\([a-z]\)\([a-zA-Z0-9]*\)/\u\1\2/g'`

if cat /etc/issue | grep Ubuntu; then
    HANDLE=twistedumbrella
    KERNELSPEC=~/android/Tuna_JB_pre1
    ANDROIDREPO=~/Dropbox/TwistedServer/Playground
    MKBOOTIMG=$KERNELSPEC/buildImg
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
    ANDROIDREPO=/Users/TwistedZero/Public/Dropbox/TwistedServer/Playground
    MKBOOTIMG=$KERNELSPEC/buildImg
    TOOLCHAIN_PREFIX=/Volumes/android/android-toolchain-eabi/bin/arm-eabi-
    PUNCHCARD=`date "+%m-%d-%Y_%H.%M"`
fi

KERNELREPO=$ANDROIDREPO/kernels
GOOSERVER=loungekatt@upload.goo.im:public_html

zipfile=$HANDLE"_StarKissed-JB42X.zip"

CPU_JOB_NUM=8

cd $KERNELSPEC

cp -R config/$2_config .config

make clean -j$CPU_JOB_NUM 

make -j$CPU_JOB_NUM ARCH=arm CROSS_COMPILE=$TOOLCHAIN_PREFIX

if [ -e arch/arm/boot/zImage ]; then

cp -R .config arch/arm/configs/starkissed_defconfig

if [ `find . -name "*.ko" | grep -c ko` > 0 ]; then

find . -name "*.ko" | xargs ${TOOLCHAIN_PREFIX}strip --strip-unneeded

if [ ! -e $KERNELSPEC/francoAIR/system ]; then
mkdir $KERNELSPEC/francoAIR/system
fi
if [ ! -e $KERNELSPEC/francoAIR/system/lib ]; then
mkdir $KERNELSPEC/francoAIR/system/lib
fi
if [ ! -e $KERNELSPEC/francoAIR/system/lib/modules ]; then
mkdir $KERNELSPEC/francoAIR/system/lib/modules
else
rm -r $KERNELSPEC/francoAIR/system/lib/modules
mkdir $KERNELSPEC/francoAIR/system/lib/modules
fi

for j in $(find . -name "*.ko"); do
cp -R "${j}" $KERNELSPEC/francoAIR/system/lib/modules
done

else

if [ -e $KERNELSPEC/francoAIR/system/lib ]; then
rm -r $KERNELSPEC/francoAIR/system/lib
fi

fi
cp -R arch/arm/boot/zImage $MKBOOTIMG

cd $MKBOOTIMG
./img.sh

echo "building kernel package"
cp -R boot.img ../francoAIR
cd ../francoAIR
rm *.zip
zip -r $zipfile *
cp -R $KERNELSPEC/francoAIR/$zipfile $KERNELREPO/$zipfile

export KENRELZIP="StarKissed-JB42X_$PUNCHCARD.zip"
if [ -e $KERNELREPO/TwistedZero_StarKissed-JB42X.zip ]; then
cp -R $KERNELREPO/TwistedZero_StarKissed-JB42X.zip $KERNELREPO/gooserver/$KENRELZIP
scp -P 2222 $KERNELREPO/gooserver/$KENRELZIP  $GOOSERVER/starkissed
rm -r $KERNELREPO/gooserver/*
fi

# cd $KERNELSPEC
# git commit -a -m "Compile success: Update build configuration defaults"

fi
