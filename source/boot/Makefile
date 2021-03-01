
all :
	nasm -f bin boot16.asm -o bootloader.bin

qemu_start : all
	qemu-system-x86_64 bootloader.bin -monitor stdio
