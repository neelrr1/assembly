; "Hello, world" bootloader written in FASM
; run with `qemu boot.bin`

use16 ; CPU is running in 16 bit mode
org 0x7c00 ; bootloader gets loaded at this address

; clear screen and set custom colors
xor al, al
xor cx, cx
mov bh, 0x03 ; set background to black and foreground to cyan, via "BIOS color attributes"
mov dx, 0xffff ; just clear a bunch of the screen, this should be enough
mov ah, 0x06
int 0x10

; move cursor to the beginning
xor bh, bh
xor dx, dx
mov ah, 0x02
int 0x10

mov bx, msg ; put address of msg in bx

inlined = 0
if defined inlined & inlined > 0
    ; print all characters in message using FASM meta-programming
    i = 0
    while i < msg_len
        mov al, [bx + i]
        call print_char
        i = i + 1
    end while
else
    ; print all characters in message using a loop in assembly
    xor cx, cx
    start:
        mov al, [bx]
        call print_char
        inc bx
        inc cx

        cmp cx, msg_len
        jne start
end if

hang: jmp hang ; infinite loop to prevent falling through

; -------------------------------------------------------

print_char: ; use BIOS "video services" function to print char to screen 
    mov ah, 0x0e
    int 0x10

    ret

msg: db "Hello, World!"
msg_len = $ - msg

times 510-($ - $$) db 0 ; pad bootloader code to 512 bytes (2 reserved for magic number)
dw 0xaa55 ; magic bootloader number