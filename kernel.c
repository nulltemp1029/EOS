void main() {
	// Declare a pointer to VGA text mode video memory byte
	// 0, position (x, y) = (0, 0) or top left corner
	char* video_memory = (char*) 0xb8000;
	//
	// Store the ascii character x at that location
	*video_memory = '?';
}

