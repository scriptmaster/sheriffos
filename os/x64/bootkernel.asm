bits 64  ;nasm directive - 64 bit
    section .text
    ;multiboot spec
    align 4
    dd 0x1BADB002 ;magic
    dd 0x00 ;flags
    dd - (0x1BADB002 + 0x00) ;checksum

    extern main__x64 ; this is the function in C file

    global start ;entry point for bootloader

    start:
    cli ;clear interrupts-- to diable interrupts
    mov esp, stack_space ;set stack pointer
    call main__x64 ;calls the main kernel function from c file
    hlt ;halts the CPU

    section .bss
    resb 8192 ;8KB memory reserved for the stack
    stack_space:  
