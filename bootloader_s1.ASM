[ORG 0x7C00]
[BITS 16]

mov ah, 00
mov al, 02
int 10h

cli                   ; disable interrupts

lgdt [gdt_descriptor] ; load gdt from gdt_descriptor

; enable protected mode
mov eax, cr0
or eax, 0x1
mov cr0, eax

; flush pipeline
jmp CODE_SEG:init_pm

[BITS 32]

init_pm:                           ; in protected mode
	mov ax, DATA_SEG           ; get rid of old segments
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000           ; update stack
	mov esp, ebp               
	
	call BEGIN_PM

BEGIN_PM:
	mov ebx, PROT_MODE_MSG     ; protected mode msg for print
	call print_string_pm       ; print msg
	jmp $


%include "inc/real_mode_funcs.ASM"
%include "inc/prot_mode_funcs.ASM"
%include "inc/misc_vars.ASM"



times 510-($-$$) db 0
dw 0xaa55
