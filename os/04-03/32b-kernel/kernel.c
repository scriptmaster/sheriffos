#include <stddef.h>
#include <stdbool.h>
#include <stdint.h>

#include "multiboot.h"
#include "cpuid.h"

// The CGA graphics device is memory-mapped. We're not going to go into a ton 
// of detail here, but the basic idea is:

// | 4 bit background color | 4 bit foreground color | 8 bit ascii character |
// 24 rows of text, with 80 columns per row
volatile uint16_t* cga_memory = (volatile uint16_t*)0xb8000;
const uint32_t cga_column_count = 80;
const uint32_t cga_row_count = 24;
const uint16_t cga_white_on_black_color_code = (15 << 8);

bool machine_supports_64bit(void) {
    uint32_t cpuidResults[4];

    cpuid(CPUIDExtendedFunctionSupport, 0, cpuidResults);

    if (cpuidResults[CPUID_EAX] < CPUIDExtendedProcessorInfo) {
        return false;
    }

    cpuid(CPUIDExtendedProcessorInfo, 0, cpuidResults);

    return cpuidResults[CPUID_EDX] & (1 << 29);
}


void cga_clear_screen(void) {
    // would be nice to use memset here, but remember, there is no libc available
    for (uint32_t i = 0; i < cga_row_count * cga_column_count; ++i) {
        cga_memory[i] = 0;
    }
}

int cga_print_string(const char* string, uint32_t column, uint32_t row) {
    // this allows us to better control where on screen text will appear
    const uint32_t initial_index = column + cga_column_count * row;

    int strlen = 0;
    for (uint32_t i = initial_index; *string != '\0'; ++string, ++i, ++strlen) {
        cga_memory[i] = *string | cga_white_on_black_color_code;
    }

    return strlen;
}

void main__kernel(multiboot_info_t* multiboot_info) {
//#pragma unused(multiboot_info)
    cga_clear_screen();
    int row = 0;
    int strlen = 0;
    strlen = cga_print_string("Welcome to Sheriff OS", 0, row);

    row += 5;

    if (multiboot_info->flags & MULTIBOOT_INFO_CMDLINE) {
        strlen = cga_print_string("Cmdline: ", 0, row);
        cga_print_string((const char*)multiboot_info->cmdline, strlen, row);
    }

    row++;

    if (multiboot_info->flags & MULTIBOOT_INFO_MODS && multiboot_info->mods_count > 0) {
        const multiboot_module_t* module = (const multiboot_module_t*)multiboot_info->mods_addr;

        const char* text_module = "Module: ";
        strlen = cga_print_string(text_module, 0, row);
        cga_print_string((const char*)module->mod_start, strlen, row);
    }

    row++;

    strlen = cga_print_string("64-bit: ", 0, row);
    cga_print_string(machine_supports_64bit() ? "supported" : "unsupported", strlen, row);

}
