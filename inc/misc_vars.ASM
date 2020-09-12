PROT_MODE_MSG db 'EOS 0.0.0.3 BOOTLOADER LOADED IN PROTECTED MODE', 0

; gdt
; general descriptor table
gdt_start:

gdt_null:             ; null descriptor
	dd 0x0        ; define double word (4 bytes) of 0
	dd 0x0        ; define double word (4 bytes) of 0

gdt_code:             ; code segment descriptor
	              ; base 0x0 - limit 0xffff
	              ; 1st flags:  (present)1 (privilege)00 (descriptor type) 1 - 1001b
	              ; type flags: (code)1 (conforming)0 (readable)1 (accessed)0 - 1010b
	              ; 2nd flags:  (granularity)1 (32-bit default)1 (64-bit)0 (AVL)0 - 1100b
	dw 0xffff     ; limit
	dw 0x0        ; base
	db 0x0        ; base
	db 10011010b  ; 1st flags/type flags
	db 11001111b  ; 2nd flags
	db 0x0        ; base

gdt_data:             ; data segment descriptor
	dw 0xffff
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

gdt_end:              ; used for calculating gdt size


; gdt descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1 ; size of gdt minus 1
	dd gdt_start               ; gdt start address

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
