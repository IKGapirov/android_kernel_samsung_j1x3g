#!/bin/bash
##
#  Copyright (C) 2015, Samsung Electronics, Co., Ltd.
#  Written by System S/W Group, S/W Platform R&D Team,
#  Mobile Communication Division.
#
#  Edited by IKGapirov
##

set -e -o pipefail

PLATFORM=sc9830
DEFCONFIG=lineage_j1x3g_defconfig
NAME=Unofficial_kernel
VERSION=v1.0

export ARCH=arm
export LOCALVERSION=-${VERSION}

KERNEL_PATH=$(pwd)
KERNEL_ZIP=${KERNEL_PATH}/kernel_zip
KERNEL_ZIP_NAME=${NAME}_${VERSION}
EXTERNAL_MODULE_PATH=${KERNEL_PATH}/external_module

JOBS=`grep processor /proc/cpuinfo | wc -l`

# Colors
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

function build() {
	clear;

	BUILD_START=$(date +"%s");
	echo -e "$cyan"
	echo "***********************************************";
	echo "              Compiling Unofficial Kernel          	     ";
	echo -e "***********************************************$nocol";
	echo -e "$red";
	echo -e "Initializing defconfig...$nocol";
	make ${DEFCONFIG};
	echo -e "$red";
	echo -e "Building kernel...$nocol";
	make -j${JOBS};
	find ${KERNEL_PATH}/drivers -name "*.ko" -exec mv -f {} ${KERNEL_ZIP}/system/lib/modules \;
	find ${KERNEL_PATH} -name "zImage" -exec mv -f {} ${KERNEL_ZIP}/tools \;

	BUILD_END=$(date +"%s");
	DIFF=$(($BUILD_END - $BUILD_START));
	echo -e "$yellow";
	echo -e "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol";
}

function make_zip() {
	echo -e "$red";
	echo -e "Making flashable zip...$nocol";

	cd ${KERNEL_PATH}/kernel_zip;
	zip -r ${KERNEL_ZIP_NAME}.zip ./;
	mv ${KERNEL_ZIP_NAME}.zip ${KERNEL_PATH};
}

function clean() {
	echo -e "$red";
	echo -e "Cleaning build environment...$nocol";
	make mrproper;
	rm ${KERNEL_ZIP_NAME}.zip;
	echo -e "$yellow";
	echo -4 "Done!$nocol";
}

function main() {
	if [ ${exportedtcpath} != "" ]; then
		echo -e "$red";
		echo -e "Using exported Toolchain path: $nocol ${exportedtcpath}";
		export CROSS_COMPILE=${exportedtcpath};
	else
		read -p "Please specify Toolchain path: " tcpath;
		if [ "${tcpath}" == "" ]; then
			echo -e "$red"
			export CROSS_COMPILE=/Path to your toolchain/arm-eabi-4.8/bin/arm-eabi-;
			echo -e "No toolchain path found. Using default local one:$nocol ${CROSS_COMPILE}";
		else
			export CROSS_COMPILE=${tcpath};
			echo -e "$red";
			echo -e "Specified toolchain path: $nocol ${CROSS_COMPILE}";
		fi;
	fi;

	echo -e "***************************************************************";
	echo "      Unofficial Kernel for Samsung Galaxy J1 (2016) SM-J120H";
	echo -e "***************************************************************";
	echo "Choices:";
	echo "1. Cleanup source";
	echo "2. Build kernel";
	echo "3. Build kernel then make flashable ZIP";
	echo "4. Make flashable ZIP package";
	echo "Leave empty to exit this script (it'll show invalid choice)";
	if [ ${exportedchoice} != "" ]; then
		choice=${exportedchoice};
	else
		read -n 1 -p "Select your choice: " -s choice;
	fi;
	case ${choice} in
		1) clean;;
		2) build;;
		3) build
		   make_zip;;
		4) make_zip;;
		*) echo
		   echo "Invalid choice entered. Exiting..."
		   sleep 2;
		   exit 1;;
	esac
}

main $@
