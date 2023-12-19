
# Make an initramfs with the sysroot.
( cd sysroot && tar cf ../initramfs.tar * )

# Prepare the iso and boot directories.
rm -rf iso_root
mkdir -pv iso_root/boot
# cp sysroot/boot/vinix.elf iso_root/boot/
cp ../kernel.img iso_root/boot/
cp initramfs.tar iso_root/boot/
cp limine.cfg iso_root/boot/
# cp background.bmp iso_root/boot/

# Install the limine binaries.
cp limine-6/limine-bios.sys iso_root/boot/
cp limine-6/limine-bios-cd.bin iso_root/boot/
cp limine-6/limine-uefi-cd.bin iso_root/boot/
mkdir -pv iso_root/EFI/BOOT
cp limine-6/BOOT*.EFI iso_root/EFI/BOOT/

# Create the disk image.
xorriso -as mkisofs -b boot/limine-bios-cd.bin -no-emul-boot -boot-load-size 4 \
    -boot-info-table --efi-boot boot/limine-uefi-cd.bin -efi-boot-part \
    --efi-boot-image --protective-msdos-label iso_root -o sheriffos.iso

# Install limine.
limine-6/limine bios-install sheriffos.iso

qemu-system-x86_64 -full-screen -cdrom sheriffos.iso
