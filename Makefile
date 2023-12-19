all: build qemu

v: kernasm kernv elfv qemu

build: kernasm kernc elf

kernasm:
	nasm -f elf32 kernel.asm -o kernasm.o

kernc:
	#gcc -m32 -c kernel.c -o kernc.o
	i386-elf-gcc -m32 -c kernel.c -o kernc.o

elf:
	#ld -m elf_i386 -T linker.ld -o kernel kernasm.o kernc.o
	i386-elf-ld -m elf_i386 -T linker.ld -o kernel-001 kernasm.o kernc.o

qemu:
	qemu-system-i386 -kernel kernel-001

kernv:
	v -o vkernel.c -cc clang -cflags "-ffreestanding" kernel.v
	i386-elf-gcc -m32 -c vkernel.c -o kernv.o
	# refer how vinix.elf was built how the clib was included

elfv:
	i386-elf-ld -m elf_i386 -T linker.ld -o kernel-001 kernasm.o kernv.o

check:
	x86_64-elf-gcc --version
	i386-elf-gcc --version
	qemu-system-i386 --version
	qemu-system-x86_64 --version

brew-install:
	brew install x86_64-elf-gcc
	brew tap nativeos/i386-elf-toolchain
	brew install nativeos/i386-elf-toolchain/i386-elf-binutils
	brew install nativeos/i386-elf-toolchain/i386-elf-gcc

brew-install-x86_64-elf-tools:
	brew install x86_64-elf-gcc

brew-uninstall-i386-elf-tools:
	brew uninstall nativeos/i386-elf-toolchain/i386-elf-binutils
	brew uninstall nativeos/i386-elf-toolchain/i386-elf-gcc

# menuentry 'kernel 001' { set root='sda,5' multiboot /boot/kernel-001 ro }
# https://computers-art.medium.com/writing-a-basic-kernel-6479a495b713#:~:text=By%20setting%20the%20start%20to,halts%20the%20CPU%20once%20done.
