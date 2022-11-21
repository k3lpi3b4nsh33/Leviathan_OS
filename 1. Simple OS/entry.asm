; Author: l3vi3th4n 
; Date: @ 2022 Nov 16 10:28
; ASM FILE FOR LEVIATHAN_OS
MBT_HDR_FLAGS EQU 0x00010003
MBT_HDR_MAGIC EQU 0x1BADB002
MBT_HDR2_MAGIC EQU 0xE85250D6
global _start ; export _start symbol
extern main ;import main symbol function
[section .start.text] ; Define text section
[bits 32]
_start:
    jmp_entry
ALIGN 8
mbt_hdr:
    dd MBT_HDR_MAGIC
    dd MBT_HDR_FLAGS
    dd -(MBT_HDR_MAGIC+MBT_HDR_FLAGS)
    dd mbt_hdr
    dd _start
    dd 0
    dd 0
    dd _entry

; GRUB Head file


ALIGN 8
mbt2_hdr:
	DD	MBT_HDR2_MAGIC
	DD	0
	DD	mbt2_hdr_end - mbt2_hdr
	DD	-(MBT_HDR2_MAGIC + 0 + (mbt2_hdr_end - mbt2_hdr))
	DW	2, 0
	DD	24
	DD	mbt2_hdr
	DD	_start
	DD	0
	DD	0
	DW	3, 0
	DD	12
	DD	_entry
	DD      0
	DW	0, 0
	DD	8

mbt2_hdr_end:
; GRUB2 Head file
; Compatible with both GRUB and GRUB2
ALIGN 8

_entry:
    cli
    in al, 0x70
    or al, 0x80
    out 0x70,al
    ; Reload GDT
    lgdt [GDT_PTR]
    jmp dword 0x8 :_32bits_mode

_32bits_mode:
; Initalize the registers that will be used by C
	mov ax, 0x10
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	xor eax,eax
	xor ebx,ebx
	xor ecx,ecx
	xor edx,edx
	xor edi,edi
	xor esi,esi
	xor ebp,ebp
	xor esp,esp

; Initalize the stack
    mov esp, 0x9000
    call main
; CPU STOP COMMAND
halt_step:
    halt
    jmp halt_step
GDT_START:
    knull_dsc: dq 0
    kcode_dsc: dq 0x00cf9e000000ffff
    kdata_dsc: dq 0x00cf92000000ffff
    k16cd_dsc: dq 0x00009e000000ffff
    k16da_dsc: dq 0x000092000000ffff

GDT_END:

GDT_PTR:
GDTLEN dw GDT_END-GDT_START-1
GDTBASE dd GDT_START


