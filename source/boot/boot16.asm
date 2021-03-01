; Bootloader must be at 0x7c00 memory address
org 0x7c00
; Generate 16bit code
bits 16

; Go to start point
jmp start

; ==== MinervaOS start point ====
start :
    ; ==== Init ====
    ; Disable interruption
    cli
    ; Zero ax (Add register)
    xor ax, ax
    ; Zero ds (Data register)
    mov ds, ax
    ; Zero es (Extended segment)
    mov es, ax
    ; Zero ss (Stack segment)
    mov ss, ax
    ; Set sp (Stack Pointer) as start point
    mov sp, 0x7c00
    ; Enable interruption
    sti

    ; ==== Screen cleaning ====
    mov ax, 0x0003
    int 0x10

    ; ==== Set cursor position ====
    mov ax, 0x0200
    mov dx, 0x0000
    xor bh, bh
    int 10h

    ; ==== Print hello message ====
    mov ax, 0x1300
    mov bp, hello_message
    mov cx, 0x0013
    mov bl, 0x000D
    int 10h

    ; ==== Infinity loop ====
    jmp $

; ==== Hello str ====
hello_message db "Hello, bootloader!", 0

; Bootloader signature
times 510 - ($ - $$) db 0
db 0x55, 0xAA