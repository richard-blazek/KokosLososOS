format ELF
org 0x100000        ; Not sure if this line is necessary.

; Constant declarations
MULTIBOOT_ALIGN       = 1 shl 0
MULTIBOOT_MEMINFO     = 1 shl 1
MULTIBOOT_AOUT_KLUDGE = 1 shl 16
MULTIBOOT_FLAGS       = MULTIBOOT_ALIGN or MULTIBOOT_MEMINFO or MULTIBOOT_AOUT_KLUDGE
MULTIBOOT_MAGIC       = 0x1BADB002
MULTIBOOT_CHECKSUM    = -(MULTIBOOT_MAGIC + MULTIBOOT_FLAGS)

load_addr:

; Multiboot header
header_addr:
    dd MULTIBOOT_MAGIC
    dd MULTIBOOT_FLAGS
    dd MULTIBOOT_CHECKSUM
    dd header_addr        ; the beginning of the Multiboot header
    dd load_addr          ; the beginning of the text segment
    dd load_end_addr      ; the end of the data segment
    dd bss_end_addr       ; the end of the bss segment
    dd entry_addr         ; the address whither the bootloader jumps to start the OS

include 'libraries/macros.asm'
include 'libraries/terminal.asm'

; Code
entry_addr:
    ; Initializing the stack
    mov esp, stackbottom
    mov ebp, esp

    macros.call terminal.clear

    macros.call terminal.print, msg, msglen, 0, terminal.LIGHT_GREEN, terminal.BLACK
    macros.call terminal.print, msg, msglen, 85, terminal.LIGHT_GREEN, terminal.BLACK
    macros.call terminal.print, msg, msglen, 170, terminal.LIGHT_GREEN, terminal.BLACK
    macros.call terminal.print, msg, msglen, 255, terminal.LIGHT_GREEN, terminal.BLACK

    hlt ; halt

; Data section
msg db 'Hello world!'
msglen = $ - msg

load_end_addr:

; BSS section

; Memory reserved for the stack
rb 16384
; Since the stack grows downwards, the label is at the end
stackbottom:

bss_end_addr:
