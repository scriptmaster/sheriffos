// clang -target i386-linux-gnu -ffreestanding -Wall -Wextra -c 32b-kernel/kernel.c -o build/kernel.o

const cga_buffer = &u16(0xb8000)

fn main() {
	println('hi')
}

fn kernel() {
	println('hi')
}
