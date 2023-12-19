all: prepare asm kernel.c link qemu

asm:
	mkdir -p build
	nasm -felf32 32b-kernel/multiboot_header.asm -o build/multiboot_header.o
	nasm -felf32 32b-kernel/multiboot_entry.asm -o build/multiboot_entry.o

kernel.c:
	clang -target i386-linux-gnu -ffreestanding -Wall -Wextra -c 32b-kernel/kernel.c -o build/kernel.o
	ls -lah build/kernel.o

link:
	i386-elf-ld -T 32b-kernel/kernel.ld -o build/kernel.elf build/multiboot_header.o build/multiboot_entry.o build/kernel.o
	ls -lah build/kernel.elf
	file build/kernel.elf

qemu:
	echo qemu

prepare:
	mkdir -p 32b-kernel
	cp ../04/32-bit-kernel/multiboot_header.asm 32b-kernel/
	cp ../04/32-bit-kernel/multiboot_entry.asm 32b-kernel/
	cp ../04/32-bit-kernel/kernel.c 32b-kernel/
	cp ../04/32-bit-kernel/multiboot.h 32b-kernel/
	cp ../04/32-bit-kernel/kernel.ld 32b-kernel/
