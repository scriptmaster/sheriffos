all: img qemu iso
iso: kerneliso qemuiso

clean:
	rm -rf *.img

img:
	dd if=../04/bootloader/grub-0.97-binaries/stage1 of=grub.img bs=512 count=1
	dd if=../04/bootloader/grub-0.97-binaries/stage2 of=grub.img bs=512 seek=1

qemu:
	qemu-system-x86_64 -m 128 -full-screen -hda grub.img # works
	#qemu-system-x86_64 -m 128 -full-screen -drive file=grub.img,format=raw # works
	#qemu-system-x86_64 -m 128 -vga std -full-screen -drive file=grub.img,format=raw # works
	# type halt or alt+tab to return to system

kerneliso:
	mkdir -p "build/isofiles/boot/grub/"
	cp "../04/bootloader/grub-0.97-binaries/iso9660_stage1_5" "build/isofiles/boot/grub/stage1_5"
	cp "../04/bootloader/grub-0.97-binaries/stage2" "build/isofiles/boot/grub/stage2"
	xorriso -outdev build/kernel.iso -blank as_needed -map build/isofiles / -boot_image grub bin_path=/boot/grub/stage1_5

qemuiso:
	ls -lah build/kernel.iso
	sleep 1
	qemu-system-x86_64 -full-screen -cdrom build/kernel.iso
	# qemu-system-x86_64 -full-screen -boot d -cdrom build/kernel.iso
