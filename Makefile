ASM=nasm

src_dir=src
build_dir=build
img_dir=img

.PHONY: all clean img bootloader kernal always

# image

img: $(img_dir)/os.img

$(img_dir)/os.img: bootloader kernal
	dd if=/dev/zero of=$(img_dir)/os.img bs=512 count=2880
	mkfs.fat -F 12 -n "NBOS" $(img_dir)/os.img
	dd if=$(build_dir)/bootloader.bin of=$(img_dir)/os.img conv=notrunc
	mcopy -i $(img_dir)/os.img $(build_dir)/kernal.bin "::kernal.bin"

# bootloader

bootloader: $(build_dir)/bootloader.bin

$(build_dir)/bootloader.bin: always
	$(ASM) $(src_dir)/bootloader/bootloader.asm -f bin -o $(build_dir)/bootloader.bin

# kernal

kernal: $(build_dir)/kernal.bin

$(build_dir)/kernal.bin: always
	$(ASM) $(src_dir)/kernal/main.asm -f bin -o $(build_dir)/kernal.bin

always:
	@mkdir -p $(build_dir)
	@mkdir -p $(img_dir)

clean:
	rm -rf $(build_dir)/*
	rm -rf $(img_dir)/*