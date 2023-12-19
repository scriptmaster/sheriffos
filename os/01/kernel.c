
volatile uint16_t* cga_memory = (volatile uint16_t*)0xb8000;

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

void kernel_main(void)
{
    cga_clear_screen();
    int row = 0;
    int strlen = 0;
    strlen = cga_print_string("Welcome to Sheriff OS", 0, row);
}
