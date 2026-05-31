org 0x7C00 
bits 16 ; to allow for backward compatibility with older hardware

%define ENDL 0x0D, 0x0A ; define a constant for the newline characters (carriage return and line feed)

; fat12 headers
jmp short start ; jump to the start of the code
nop ; padding to ensure the correct offset for the FAT12 headers

bdb_oem:                    db 'MSWIN4.1'           ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0E0h
bdb_total_sectors:          dw 2880                 ; 2880 * 512 = 1.44MB
bdb_media_descriptor_type:  db 0F0h                 ; F0 = 3.5" floppy disk
bdb_sectors_per_fat:        dw 9                    ; 9 sectors/fat
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           db 0                    ; 0x00 floppy, 0x80 hdd, useless
                            db 0                    ; reserved
ebr_signature:              db 29h
ebr_volume_id:              db 12h, 34h, 56h, 78h   ; serial number, value doesn't matter
ebr_volume_label:           db 'NANOBYTE OS'        ; 11 bytes, padded with spaces
ebr_system_id:              db 'FAT12   '           ; 8 bytes


; start of the code

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
