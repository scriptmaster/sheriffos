#all: compile iso_x86 qemu
all: compile limine

CC=x86_64-elf-gcc
LD=x86_64-elf-ld
CCOPTIONS= -mcmodel=large -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -nostdlib -lgcc
CCOPTIONS2= -nostdlib -lgcc
CCOPTIONS3= -ffreestanding
LINKER_SCRIPT=link.ld

override COBJ   := kernel.o
override SYMBOLS := bootstrap.o

*.o: *.c
	$(CC) $(CCOPTIONS3) $(CCOPTIONS) -c $< -o $@
	file $@

*.o: *.S
	$(CC) $(CCOPTIONS3) $(CCOPTIONS) -c $< -o $@
	file $@

compile: $(COBJ) $(SYMBOLS)
	# $(CC) -ffreestanding $(CCOPTIONS) $(CCOPTIONS2) $(COBJ) $(SYMBOLS) -T $(LINKER_SCRIPT) -o kernel.elf
	$(LD) -m elf_x86_64 -T $(LINKER_SCRIPT) -o kernel.img $(COBJ) $(SYMBOLS)

iso_x86:
	cp -r kernel.img build/isofiles/boot/
	xorriso -outdev build/kernel.iso -blank as_needed -map build/isofiles / -boot_image grub bin_path=/boot/grub/stage1_5

# qemu:
# 	qemu-system-x86_64 -full-screen -cdrom build/kernel.iso

qemu:
	qemu-system-x86_64 -full-screen -cdrom build/kernel.iso

limine:
	cd limine_iso && ./makeiso.sh
