ASM=nasm

src_dir=src
build_dir=build
img_dir=img

$(img_dir)/os.img: $(build_dir)/main.bin
	cp $(build_dir)/main.bin $(img_dir)/os.img
	truncate -s 1440k $(img_dir)/os.img

$(build_dir)/main.bin: $(src_dir)/main.asm
	$(ASM) $(src_dir)/main.asm -f bin -o $(build_dir)/main.bin