#!/bin/bash

echo "making the image"
make 
echo "running qemu"
qemu-system-i386 -fda img/os.img