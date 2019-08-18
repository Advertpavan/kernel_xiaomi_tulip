#!/bin/bash

# This Script needs one change from the users and have some instructions how to use it, so please do read first 10 Lines of the Script.

# Clone this script in your ROM Repo using following commands.
# cd rom_repo
# curl https://raw.githubusercontent.com/LegacyServer/Scripts/master/script_build.sh > script_build.sh

# Some User's Details. Please fill it with your own details.

# Replace "legacy" with your own SSH Username in lowercase
username=sourav

# Assign values to parameters used in Script from Jenkins Job parameters
use_ccache="$1"
make_clean="$2"
lunch_command="$3"
device_codename="$4"
target_command="$5"
build_type="$6"

# Colors makes things beautiful
export TERM=xterm

    red=$(tput setaf 1)             #  red
    grn=$(tput setaf 2)             #  green
    blu=$(tput setaf 4)             #  blue
    cya=$(tput setaf 6)             #  cyan
    txtrst=$(tput sgr0)             #  Reset

# CCACHE UMMM!!! Cooks my builds fast

if [ "$use_ccache" = "yes" ];
then
echo -e ${blu}"CCACHE is enabled for this build"${txtrst}
export USE_CCACHE=1
export CCACHE_DIR=/home/ccache/$username
prebuilts/misc/linux-x86/ccache/ccache -M 50G
fi

if [ "$use_ccache" = "clean" ];
then
export CCACHE_DIR=/home/ccache/$username
ccache -C
export USE_CCACHE=1
prebuilts/misc/linux-x86/ccache/ccache -M 50G
wait
echo -e ${grn}"CCACHE Cleared"${txtrst};
fi

# Its Clean Time
if [ "$make_clean" = "yes" ];
then
make clean && make clobber
wait
echo -e ${cya}"OUT dir from your repo deleted"${txtrst};
fi

export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="SouravGope"
export KBUILD_BUILD_HOST="theglitchhserver"
export CROSS_COMPILE="/home/sourav/aarch64-linux-android-4.9/bin/aarch64-linux-android-"
export CROSS_COMPILE_ARM32="/home/sourav/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-"
make tulip-perf_defconfig
make  -j8
