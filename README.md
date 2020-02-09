# Unofficial Kernel tree for Samsung Galaxy SM-J120H/DS Galaxy J1 (2016) [modified for Lineage]
![Spreadtrum SC9830](http://proshivkis.ru/cpu/spreadtrum-sc9830.jpg "Samsung Galaxy J1 Duos")
###################################################################################################
HOW TO BUILD Unofficial Kernel for SM-J120H/DS [modified for Lineage]                                     

1. How to Build
	- get Toolchain
	download and install arm-eabi-4.8 or other toolchain for ARM EABI.              
	Extract kernel source and move into the top directory.
	Change path in build.sh or Makefile file to your toolchain.
	
	$ make lineage_j1x3g_defconfig                                                    
	$ make -jx


2. Output files
	- Kernel : Kernel/arch/arm/boot/zImage
	- module : Kernel/drivers/*/*.ko

3. How to Clean	
    	$ make clean
                                                                                   
###################################################################################################
