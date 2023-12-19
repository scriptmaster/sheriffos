/* Copyright 2003-2033 M Sheriff <msheriffusa@gmail.com> All rights reserved. */
OUTPUT_FORMAT(elf64-x86-64)
/* OUTPUT_ARCH(i386:x86-64) */

ENTRY(main__x64)

/* Program headers for bootloader permissions */
/* MMU permissions */
PHDRS
{
    null    PT_NULL    FLAGS(0) ;
    text    PT_LOAD    FLAGS((1 << 0) | (1 << 2)) ;
    rodata  PT_LOAD    FLAGS(1 << 2) ;
    data    PT_LOAD    FLAGS((1 << 1) | (1 << 2)) ;
}

SECTIONS
{
    /* Place Kernel in the higher half, in physical memory. 2MB above 0  */
    . = 0xffffffff80000000;

    .text : {
        *(.text .text.*)
    } : text

    . += CONSTANT(MAXPAGESIZE);

    /* Then let's place all the other traditional executable sections afterwards. */
    .rodata : {
        *(.rodata .rodata.*)
    } : rodata

    .symbol_table : {
        *(.symbol_table)
    } : rodata

    . += CONSTANT(MAXPAGESIZE);

    .data : {
        *(.data .data.*)
    } : data

    .bss : {
        *(COMMON)
        *(.bss .bss.*)
    } : data

    KERNEL_END_SYMBOL = .;
}
