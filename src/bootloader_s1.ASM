[ORG 0x7C00]
[BITS 16]

; enable VGA text mode
mov ah, 00
mov al, 02
int 10h

KERNEL_OFFSET equ 0x1000;

;mov [BOOT_DRIVE], dl

mov bx, KERNEL_OFFSET
mov dh, 1
mov dl, 0x0

mov ah, 0x02
mov al, 0x01
mov ch, 0x00
mov dh, 0x00
mov cl, 0x02
int 0x13

mov bp, 0x9000
mov sp, BEGIN_PM
;mov sp, bp
cli                   ; disable interrupts

lgdt [gdt_descriptor] ; load gdt from gdt_descriptor
mov eax, cr0
or eax, 0x1
mov cr0, eax
jmp CODE_SEG:init_pm

[BITS 32]
init_pm:                           ; in protected mode
	mov ax, DATA_SEG           ; get rid of old segments
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp, 0x9000           ; stack
	mov esp, ebp             
	
	jmp BEGIN_PM

BEGIN_PM:
	mov ebx, PROT_MODE_MSG     ; protected mode msg for print
	call print_string_pm       ; print msg

	jmp KERNEL_OFFSET         ; go to kernel
	jmp $


PROT_MODE_MSG db 'EOS 0.0.0.4 BOOTLOADER LOADED IN PROTECTED MODE', 0

; gdt
gdt_start:

gdt_null:  
	dd 0x0
	dd 0x0 
gdt_code:
	dw 0xffff
	dw 0x0 
	db 0x0 
	db 10011010b 
	db 11001111b 
	db 0x0
gdt_data:
	dw 0xffff
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
gdt_end: 

gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY
print_string_pm_loop:
	mov al, [ebx]
	mov ah, WHITE_ON_BLACK
	
	cmp al, 0
	je print_string_pm_done
	
	mov [edx], ax
	
	add ebx, 1
	add edx, 2
	
	jmp print_string_pm_loop
print_string_pm_done:
	popa
	ret

times 510-($-$$) db 0
dw 0xaa55