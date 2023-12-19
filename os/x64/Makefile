all: kernasm kernc link qemu

kernasm:
	nasm -f elf64 bootkernel.asm -o kernasm.o

kernc:
	x86_64-elf-gcc -m64 -c kernel.c -o kernc.o

link: kernasm kernc
	file kernasm.o
	file kernc.o
	# x86_64-elf-ld -m elf_x86_64 -T linker.ld -o kernel-001 kernc.o
	x86_64-elf-ld -m elf_x86_64 -T linker.ld -o kernel-001 kernasm.o kernc.o
	file kernel-001

qemu:
	qemu-system-x86_64 -full-screen -kernel kernel-001
