clear
gcc -ffreestanding -c kernel.c kernel.o
ld -o kernel.bin -T linker.l kernel.o --oformat binary
nasm -f bin -o bootloader_s1.bin bootloader_s1.ASM
cat bootloader_s1.bin kernel.bin > os-image