org 0x7C00 
bits 16 ; to allow for backward compatibility with older hardware

%define ENDL 0x0D, 0x0A ; define a constant for the newline characters (carriage return and line feed)

start:
    jmp main ; jump to the main function

; prints a string to the screen

puts:
    push si ; save the SI register
    push ax ; save the AX register

.loop:
    lodsb ; load the next byte from the string into AL
    or al, al ; check if the byte is null (end of string)
    jz .done ; if it is, we're done

    mov ah, 0x0E ; BIOS teletype output function
    mov bh, 0x00 ; page number (0)
    int 0x10 ; call the BIOS video interrupt to print the character in AL
    jmp .loop ; otherwise, print the character and continue

.done:
    pop ax ; restore the AX register
    pop si ; restore the SI register
    ret ; return from the function

main:

    mov ax, 0x0000 ; set up the segment registers
    mov ds, ax
    mov es, ax

    mov ss, ax ; set up the stack segment
    mov sp, 0x7C00
    ;print the message
    mov si, msg_hello ; load the address of the message into SI
    call puts ; call the puts function to print the message

    hlt ; halt the CPU

.halt:
    jmp .halt ; infinite loop to keep the CPU halted

msg_hello: db 'Hello, World!', ENDL, 0 ; the string to print

times 510-($-$$) db 0 ; fill the rest of the sector with zeros
dw 0xAA55 ; boot signature
