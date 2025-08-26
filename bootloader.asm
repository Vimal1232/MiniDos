[bits 16] ; Telling Nasm its Real Mode

[org 0x7c00] ; Loading Boot Sector 
global _start
mov [Boot] , dl; Disk Information in from Bios

_start:
  cli    ;Disabling Interrupts
  xor ax , ax  ; Making Ax Register 0
  mov es , ax  ; Making Es segment 0
  mov ds , ax  ; Making ds segment 0
  mov ss , ax  ; Making ss segment 0
  mov sp , 0x7bff  ; Making SP pointer at this Pointer Grows Downwards
  sti    ; Enabling Interrupts



; Actual Code 

  mov si , msg
  call Print_String

  mov si , msg_init
  call Print_String

  mov si , msg_loading
  call Print_String
  
  clc
  mov ax, 0x1000 ; Segmet To load kerne;
  mov es,ax 
  xor bx,bx ; offset 0x00
  mov ah , 0x02 ; Bios Read sectors
  mov al , 11; read 1 sector
  mov ch, 0x00; cylinder
  mov cl, 0x02;start from Sector 2
  mov dh,0x00; head
  mov dl,[Boot] ; Boot drive
  int 0x13
  jc disk_Err ; error if Carry flag Set

  mov si , msg_success
  call Print_String

  cli 
  lgdt [GDT_DESCRIPTOR] ; Loading Descripter Table 

  mov eax , cr0 
  or eax , 1 ; Protection Enable Bit
  mov cr0, eax

  jmp CODE_SELECTOR:ProtectedMode ; Jump to The Protected mode

; Making it Run infinitly
  jmp $

;Disk Error SubRoutine
disk_Err:
    mov si , err 
    call  Print_String

;Print_String Subroutine
Print_String:
    mov ah , 0x0E ; Bios Teletype Mode
    .print_next:
    lodsb 
    cmp al , 0 
    je .done
    int 0x10
    jmp .print_next
    .done:
    ret

ProtectedMode:
  [bits 32]
  mov ax , DATA_SELECTOR
  mov ds ,ax
  mov es , ax
  mov ss, ax
  mov esp , 0x9000

  jmp 0x10000 ; Jumping to Kernel

;Global Descripter Table
GDT_START:
    ;nulll Descriptor
     dq 0x0000000000000000

GDT_CODE:
    dw 0xffff ; Limit
    dw 0x0000 ; base
    db 0x00   ; base
    db 0x9A  ; accessByte
    db 0xCF ; Flags and Limit
    db 0x00 ; Base

GDT_DATA:
    dw 0xffff ; Limit
    dw 0x0000 ; base
    db 0x00   ; base
    db 0x92  ; accessByte
    db 0xCF ; Flags and Limit
    db 0x00 ; Base
GDT_END:


GDT_DESCRIPTOR:
    dw GDT_END - GDT_START -1 ; Size
    dd GDT_START   ; address


;Symbols or Constants
CODE_SELECTOR equ GDT_CODE - GDT_START;
DATA_SELECTOR equ GDT_DATA - GDT_START;


; Data To be Here
msg db "MiniDOS Bootloader v1.0",13,10,0
msg_init db "Initializing system...",13,10,0
msg_loading db "Loading kernel from disk...",13,10,0
msg_success db "Kernel loaded successfully!",13,10,0
err db "Error in Disk",13,10,0;Err 
Boot db 0 ; 


; Boot Signature
times 510-($-$$) db 0 ; 
dw 0x0AA55;



