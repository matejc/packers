#!/usr/bin/env bash

qemu-kvm \
    -m 4G \
    -cpu host,hv_relaxed,hv_vapic,hv_time,hv_spinlocks=0x1fff \
    -smp 2 \
    -machine type=q35,accel=kvm,kernel_irqchip=on \
    -netdev user,id=vmnic,hostfwd=tcp::3389-:3389,smb=$PWD/shared/ \
    -device virtio-net-pci,netdev=vmnic \
    -drive file=windows_10-qemu/windows_10,if=virtio,cache=writeback,discard=ignore,format=qcow2,index=1 \
    -drive file=images/virtio-win.iso,media=cdrom,index=3 \
    -vga qxl -spice unix=on,addr=$PWD/spice.sock,disable-ticketing=on \
    -usb -device usb-tablet
