https://wiki.osdev.org/Creating_a_64-bit_kernel

#### Compiling

Compile each source file like any piece of C code, just remember to use the cross-compiler and the proper options. Linking will be done later...

`brew install x86_64-elf-gcc`

```
x86_64-elf-gcc -ffreestanding -mcmodel=large -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -c foo.c -o foo.o
```

The kernel will be linked as an x86_64 executable, to run at a virtual higher-half address. We use a linker script:


See: link.ld

Feel free to edit this linker script to suit your needs. Set ENTRY(...) to your entry function, and KERNEL_VMA to your base virtual address.

### Linking

You can link the kernel like this:

```
x86_64-elf-gcc -ffreestanding $other_options -T link.ld $object_files -o $kernel_executable -nostdlib -lgcc
```
