

bootstrap.S

```
.section .text
.code32

multiboot_header:
    (only needed if you're using multiboot)

bootstrap:
    (32-bit to 64-bit code goes here)
    (jump to 64-bit code)
```



```
ENTRY(bootstrap)

SECTIONS
{
    . = KERNEL_LMA;

    .bootstrap :
    {
        <path of bootstrap object> (.text)
    }

    . += KERNEL_VMA;

    .text : AT(ADDR(.text) - KERNEL_VMA)
    {
        _code = .;
        *(EXCLUDE_FILE(*<path of bootstrap object>) .text)
        *(.rodata*)
        . = ALIGN(4096);
    }
}
```
