#!/usr/bin/env bash

TOP_DIR=`pwd`

build_qemu()
{
    echo "build qemu-riscv64"
    pushd $TOP_DIR/qemu
    ./configure --target-list=riscv64-softmmu
    make -j `nproc`
    popd
}

start_qemu()
{
    echo "Starting rv64 qemu..."
    cp /usr/share/AAVMF/AAVMF_CODE.fd flash1.img
    ./qemu/build/qemu-system-riscv64  -nographic\
     -drive file=$TOP_DIR/uefi_qemu_flash1.img,if=pflash,format=raw,unit=1 -machine virt -m 2G -smp 2 -numa node,mem=1G -numa node,mem=1G \
     -drive file=fat:rw:$TOP_DIR/edk2-test/uefi-sct/Build/UefiSct/RELEASE_GCC5/SctPackageRISCV64/RISCV64/,id=hd0 -device virtio-blk-device,drive=hd0
}

build_qemu
start_qemu