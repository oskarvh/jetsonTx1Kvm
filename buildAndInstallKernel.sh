#!/bin/bash
# Get, build and install the Jetson TX1 kernel
# Based on https://forums.developer.nvidia.com/t/tx1-building-l4t-kernel-on-device-failed-to-start-nvpmodel-service/192873/2
# and some pointers by JetsonHacks

mkdir -p "${HOME}/build/kernel"
mkdir -p "${HOME}/build/modules"
mkdir -p "${HOME}/build/firmware"
mkdir -p "${HOME}/Downloads/helper_scripts"

export TOP="/usr/src/kernel/kernel-4.9"
export HELPER_SCRIPTS="${HOME}/Downloads/helper_scripts"
export TEGRA_KERNEL_OUT="${HOME}/build/kernel"
export TEGRA_MODULES_OUT="${HOME}/build/modules"
export TEGRA_FIRMWARE_OUT="${HOME}/build/firmware"
export TEGRA_TAR="${HOME}/Downloads/nvidia_4.9_kernel_source"
export TEGRA_BUILD="${HOME}/build"

# Assuming this is the 4.9 kernel, lets get the kernel sources by calling 
# JetsonHacks script "getKernelSources.sh" found here: https://github.com/jetsonhacks/jetson-linux-build
# Script was fetched Sept 2021. 

# This gets the kernel sources and unpacks them in /usr/src. 
# this can be done manually but hey, these are nice helper scripts and do 
# the same thing as the manual process so.. 
cd "$HELPER_SCRIPTS"
FOLDER="jetson-linux-build"
if [ ! -d "$FOLDER" ] ; then
	git clone https://github.com/jetsonhacks/jetson-linux-build
fi
cd "$FOLDER"
if [ ! -d "$TOP" ] ; then
	source getKernelSources.sh
fi
# The script above also fetches the config from /proc/config.gz. 

# Now pick up where linuxdev on the forum pointed:
# Compile commands start in $TOP, thus:
cd $TOP

# Do not forget to provide a starting configuration. Probably copy of "/proc/config.gz",
# to $TEGRA_KERNEL_OUT, but also perhaps via:
make O=$TEGRA_KERNEL_OUT nconfig

# If building the kernel Image:
make -j 4 O=$TEGRA_KERNEL_OUT Image

# If you did not build Image, but are building modules:
make -j 4 O=$TEGRA_KERNEL_OUT modules_prepare

# To build modules:
make -j 4 O=$TEGRA_KERNEL_OUT modules

# To build device tree content:
make -j 4 O=$TEGRA_KERNEL_OUT dtbs

# To put modules in "$TEGRA_MODULES_OUT":
make -j 4 O=$TEGRA_KERNEL_OUT INSTALL_MOD_PATH=$TEGRA_MODULES_OUT modules_install

# To put firmware and device trees in "$TEGRA_FIRMWARE_OUT":
make -j 4 O=$TEGRA_KERNEL_OUT INSTALL_FW_PATH=$TEGRA_FIRMWARE_OUT firmware_install

# Copy the modules to /lib/modules:
sudo cp -r "$TEGRA_MODULES_OUT/*" "/lib/modules/."

# Copy image
sudo cp -r "$TEGRA_KERNEL_OUT/arch/arm64/boot/Image" "/boot/."

# NOTE: you will have to manually copy images and modules if you mounted SSD as rootfs
echo "NOTE: you will have to manually copy images and modules if you mounted SSD as rootfs"
echo ""
echo "All done!"
