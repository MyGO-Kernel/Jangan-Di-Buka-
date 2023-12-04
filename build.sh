#!/bin/bash

function compile() 
{
rm -rf AnyKernel
source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
export ARCH=arm64
export KBUILD_BUILD_HOST=Axioo
export KBUILD_BUILD_USER="Soni Hikari"
git clone https://gitlab.com/tejas101k/clang-weebx  clang

[ -d "out" ] && rm -rf out || mkdir -p out

make O=out ARCH=arm64 lancelot_defconfig

PATH="${PWD}/clang/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      CC="clang" \
                      LLVM=1 \
                     ARCH=$ARCH \
                     CLANG_TRIPLE=aarch64-linux-gnu- \
                        CROSS_COMPILE="${PWD}/los-4.9-64/bin/aarch64-linux-android-" \
                        CROSS_COMPILE_ARM32="${PWD}/los-4.9-32/bin/arm-linux-androideabi-" \
            		LLVM=1 \
                        LD=ld.lld \
                        AR=llvm-ar \
                        NM=llvm-nm \
                        OBJCOPY=llvm-objcopy \
                        OBJDUMP=llvm-objdump \
                        STRIP=llvm-strip \
                        CONFIG_NO_ERROR_ON_MISMATCH=y 2>&1 | tee error.log 
}

function zipping()
{
git clone --depth=1 https://github.com/MyGO-Kernel/AnyKernel AnyKernel
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 Succubus-Kernel-Lancelot-MT6768.zip *
}

compile
zipping
