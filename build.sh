#Credits @xiaoleGun
#	 https://github.com/xiaoleGun/KernelSU_Action
echo "Preparing Package..."
sudo apt-get install git ccache automake flex lzop bison gperf build-essential zip curl zlib1g-dev g++-multilib libxml2-utils bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make optipng maven libssl-dev pwgen libswitch-perl policycoreutils minicom libxml-sax-base-perl libxml-simple-perl bc libc6-dev-i386 lib32ncurses5-dev libx11-dev lib32z-dev libgl1-mesa-dev xsltproc unzip device-tree-compiler python2 python3
cd ..
echo "Setting ENV..."
export WorkFolder=$(pwd)
export ARCH=arm64
export PATH=$WorkFolder/clang-aosp/bin:$PATH
export KBUILD_BUILD_HOST=BUILD-Action
export KBUILD_BUILD_USER=$(echo ZaeXT | tr A-Z a-z)
echo "Preparing Clang-aosp..."
#mkdir clang-aosp
#wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main/clang-r450784e.tar.gz
#tar -C clang-aosp/ -zxvf clang-r450784e.tar.gz
#echo "Preparing Gcc-64"
#mkdir gcc-64
#wget -O gcc-aarch64.tar.gz https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/refs/tags/android-12.1.0_r27.tar.gz
#tar -C gcc-64/ -zxvf gcc-aarch64.tar.gz
#echo "Preparing Gcc-32"
#mkdir gcc-32
#wget -O gcc-arm.tar.gz https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/+archive/refs/tags/android-12.1.0_r27.tar.gz
#tar -C gcc-32/ -zxvf gcc-arm.tar.gz
echo "Entering source folder."
cd kernel_realme_sm6150
echo "Configuring Build..."
make -j$(nproc --all) CC=clang O=out ARCH=arm64 CLANG_TRIPLE=aarch64-linux-gnu- LD=ld.lld LLVM=1 LLVM_IAS=1 CROSS_COMPILE=$WorkFolder/gcc-64/bin/aarch64-linux-android- CROSS_COMPILE_ARM32=$WorkFolder/gcc-32/bin/arm-linux-androideabi- X2_defconfig
echo "Cleaning Envir..."
make mrproper
echp "Building..."
make -j$(nproc --all) CC=clang O=out ARCH=arm64 CLANG_TRIPLE=aarch64-linux-gnu- LD=ld.lld LLVM=1 LLVM_IAS=1 CROSS_COMPILE=$WorkFolder/gcc-64/bin/aarch64-linux-android- CROSS_COMPILE_ARM32=$WorkFolder/gcc-32/bin/arm-linux-androideabi-
cd $WorkFolder
echo "Preparing AnyKernel3..."
git clone https://github.com/osm0sis/AnyKernel3
echo "Generating anykernel.sh..."
sed -i 's/do.devicecheck=1/do.devicecheck=0/g' AnyKernel3/anykernel.sh
sed -i 's!block=/dev/block/platform/omap/omap_hsmmc.0/by-name/boot;!block=auto;!g' AnyKernel3/anykernel.sh
sed -i 's/is_slot_device=0;/is_slot_device=auto;/g' AnyKernel3/anykernel.sh
echo "Copying Kernel&DTBO..."
cp $WorkFolder/kernel_realme_sm6150/out/arch/arm64/boot/Image.gz-dtb AnyKernel3/
cp $WorkFolder/kernel_realme_sm6150/out/arch/arm64/boot/dtbo.img Anykernel3/
rm -rf AnyKernel3/.git* AnyKernel3/README.md
echo "Done!"
echo "Cleaning...	clang-aosp"
rm -rf clang-aosp/
echo "Cleaning...	gcc-64"
rm -rf gcc-64/
echo "Cleaning...	gcc-32"
rm -rf gcc-32/
echo "Finished!"
echo "Opening"
echo "$WorkFolder/AnyKernel3"
open AnyKernel3/
