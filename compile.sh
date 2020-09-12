clear
gcc -m32 -fno-pie -ffreestanding -c kernel.c kernel.o
nasm kernel_entry.ASM -f elf -o kernel_entry.o
ld -m elf_i386 -o kernel.bin -T linker.l kernel_entry.o kernel.o --oformat binary
nasm -f bin -o bootloader_s1.bin bootloader_s1.ASM
cat bootloader_s1.bin kernel.bin > os-image