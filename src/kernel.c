#include <stdio.h>
#include <unistd.h>
#include <sys/io.h>
#include <stdint.h>

// note that graphics is in vga mode 2 (80x25)
// starts on second line
int cursor_pos = 0;
int VGA_LENGTH = 80;
int VGA_HEIGHT = 40;

// gets length of string by counting until the end char
// could be optimized probably
int len(char* msg) {
	for(int i = 0; 0==0; ++i) {
		if(msg[i] == '\0') return i;
	}
}

// prep vga for high byte (14) and send high byte
// then prep vga for low byte (15) and send low byte
void update_cursor(uint16_t pos) {
	outb(14, 0x3d4);
	outb(pos >> 8, 0x3d5);
	outb(15, 0x3d4);
	outb(pos, 0x3d5);
}

// prints string by placing it into video text memory
// + cursor position offset, includes exception for \n
void print_string(char *msg, char color) {
	char* video_memory = (char*) 0xb8000;
	video_memory += cursor_pos*2;
	
	for(int i = 0; i < len(msg); ++i) {
		if(msg[i] == '\n') {
			cursor_pos += (VGA_LENGTH - cursor_pos%VGA_HEIGHT);
		} else {
			*video_memory++ = msg[i];
			*video_memory++ = color;
			cursor_pos++;
		}
	}
	update_cursor(cursor_pos);
}

void main() {
	// having the "outb" instruction cause global vars to
	// reset for some reason, so I need to reinitializer 
	// them here
	VGA_LENGTH = 80;
	VGA_HEIGHT = 40;
	cursor_pos = 80;

	print_string("32-bit protected mode c-kernel entered.\n", 0x0a);

	while (true) {
		
	}
}