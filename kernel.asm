bits 32  ;nasm directive - 32 bit
        section .text
         ;multiboot spec
         align 4
         dd 0x1BADB002 ;magic
         dd 0x00 ;flags
         dd - (0x1BADB002 + 0x00) ;checksum
         
        global start ;to set symbols from source code as global 
        extern main__main ;main__main is the function in C file

        start:
        cli ;clear interrupts-- to diable interrupts
        mov esp, stack_space ;set stack pointer
        call main__main ;calls the main kernel function from c file
        hlt ;halts the CPU

        section .bss
        resb 8192 ;8KB memory reserved for the stack
        stack_space:  
