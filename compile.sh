clear
gcc -m32 -fno-pie -ffreestanding -c src/kernel.c -o bin/kernel.o
nasm src/kernel_entry.ASM -f elf -o bin/kernel_entry.o
ld -m elf_i386 -o bin/kernel.bin -T src/linker.l bin/kernel_entry.o bin/kernel.o --oformat binary
nasm -f bin -o bin/bootloader_s1.bin src/bootloader_s1.ASM
cat bin/bootloader_s1.bin bin/kernel.bin > os-image