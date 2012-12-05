#!/bin/bash

# Copyright (C) 2011 Twisted Playground

# This script is designed by Twisted Playground for use on MacOSX 10.7 but can be modified for other distributions of Mac and Linux

PROPER=`echo $2 | sed 's/\([a-z]\)\([a-zA-Z0-9]*\)/\u\1\2/g'`

if cat /etc/issue | grep Ubuntu; then
    HANDLE=twistedumbrella
    KERNELSPEC=~/android/Tuna_JB_pre1
    KERNELREPO=~/android
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
    KERNELREPO=/Users/TwistedZero/Public/Dropbox/TwistedServer/Playground/kernels
    MKBOOTIMG=$KERNELSPEC/buildImg
    TOOLCHAIN_PREFIX=/Volumes/android/android-toolchain-eabi/bin/arm-eabi-
fi

zipfile=$HANDLE"_francoAIR-JB42X.zip"

CPU_JOB_NUM=16

cd $KERNELSPEC

cp -R config/$2_config .config

make clean -j$CPU_JOB_NUM 

make -j$CPU_JOB_NUM ARCH=arm CROSS_COMPILE=$TOOLCHAIN_PREFIX

if [ -e arch/arm/boot/zImage ]; then

cp .config arch/arm/configs/francoair_defconfig

cp -R arch/arm/boot/zImage $MKBOOTIMG

cd $MKBOOTIMG
./img.sh

echo "making zip file"
cp -R boot.img ../francoAIR
cd ../francoAIR
rm *.zip
zip -r $zipfile *
cp -R $KERNELSPEC/francoAIR/$zipfile $KERNELREPO/$zipfile

fi