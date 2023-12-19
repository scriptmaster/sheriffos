all: link qemuiso
asm: prepare
	mkdir -p build
	nasm -felf32 32b-kernel/multiboot_header.asm -o build/multiboot_header.o
	nasm -felf32 32b-kernel/multiboot_entry.asm -o build/multiboot_entry.o
	# add cpuid asm files
	nasm -felf32 32b-kernel/cpuid_supported.asm -o build/cpuid_supported.o
	nasm -felf32 32b-kernel/cpuid.asm -o build/cpuid.o

kernel.c: prepare
	clang -target i386-linux-gnu -ffreestanding -Wall -Wextra -c 32b-kernel/kernel.c -o build/kernel.o
	# clang -target i386-linux-gnu -ffreestanding -Wall -Wextra -c vkernel.c -o build/kernel.o
	ls -lah build/kernel.o

v:
	# v -o vkernel.o -cflags -static vkernel.v
	v -cc "clang" -cflags "-target i386-linux-gnu -ffreestanding -Wall -Wextra -s " vkernel.v

link: asm kernel.c
	i386-elf-ld -T 32b-kernel/kernel.ld -o build/kernel.elf \
		build/multiboot_header.o build/multiboot_entry.o \
		build/cpuid_supported.o build/cpuid.o \
		build/kernel.o
	ls -lah build/kernel.elf
	file build/kernel.elf

qemu: link
	qemu-system-i386 -full-screen -kernel build/kernel.elf

prepare:
	mkdir -p 32b-kernel
	cp ../04/32-bit-kernel/multiboot_header.asm 32b-kernel/
	# modified to contain main__kernel # cp ../04/32-bit-kernel/multiboot_entry.asm 32b-kernel/
	# modified: custom # cp ../04/32-bit-kernel/kernel.c 32b-kernel/ # we will write our own kernel.c
	cp ../04/32-bit-kernel/multiboot.h 32b-kernel/
	cp ../04/32-bit-kernel/kernel.ld 32b-kernel/
	cp ../04/32-bit-kernel/i386/cpuid_supported.asm 32b-kernel/
	cp ../04/32-bit-kernel/i386/cpuid.asm 32b-kernel/
	cp ../04/32-bit-kernel/i386/cpuid.h 32b-kernel/

# from 04-01
#------------

kerneliso:
	mkdir -p "build/isofiles/boot/grub/"
	cp "../04/bootloader/grub-0.97-binaries/iso9660_stage1_5" "build/isofiles/boot/grub/stage1_5"
	cp "../04/bootloader/grub-0.97-binaries/stage2" "build/isofiles/boot/grub/stage2"
# NEW on 04-03:
	cp build/kernel.elf build/isofiles/boot/kernel.bin
	# cp ../04/bootloader/menu.lst build/isofiles/boot/grub/
	# cp ../04/bootloader/data_file build/isofiles/boot/

	xorriso -outdev build/kernel.iso -blank as_needed -map build/isofiles / -boot_image grub bin_path=/boot/grub/stage1_5

qemuiso: kerneliso
	ls -lah build/kernel.iso
	qemu-system-x86_64 -full-screen -cdrom build/kernel.iso
