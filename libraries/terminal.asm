terminal.VIDEO_MEMORY = 0xB8000

terminal.BLACK = 0
terminal.BLUE = 1
terminal.GREEN = 2
terminal.CYAN = 3
terminal.RED = 4
terminal.MAGENTA = 5
terminal.BROWN = 6
terminal.LIGHT_GREY = 7
terminal.DARK_GREY = 8
terminal.LIGHT_BLUE = 9
terminal.LIGHT_GREEN = 10
terminal.LIGHT_CYAN = 11
terminal.LIGHT_RED = 12
terminal.LIGHT_MAGENTA = 13
terminal.LIGHT_BROWN = 14
terminal.WHITE = 15

terminal.WIDTH = 80
terminal.HEIGHT = 25

; Clear the screen
; Arguments: background colour, text colour
procedure terminal.clear, eax, ebx
    ; only using the AX part of EAX;
    ; lower byte for the text (zero), upper for the colour code
    shl eax, 4  ; shifting the background colour
    or eax, ebx ; obtaining the colour code
    shl eax, 8  ; shifting it to the upper byte

    mov ecx, 0
    .loop:
        mov word [terminal.VIDEO_MEMORY + ecx], ax
        add ecx, 2
        cmp ecx, (terminal.WIDTH * terminal.HEIGHT * 2)
        jnz .loop
    ret


; Sets the new colour for the terminal
; Arguments: background colour, text colour, position, length
procedure terminal.paint, eax, ebx, edi, ecx
    shl eax, 4                      ; shifting the background colour
    or eax, ebx                     ; obtaining the colour code
    shl edi, 1                      ; there are 2 bytes per character
    add edi, terminal.VIDEO_MEMORY  ; the address in the video memory

    .loop:
        mov byte [edi + ecx * 2 - 1], al
        dec ecx
        jnz .loop
    ret


; Writes a string to a given position.
; Arguments: string, length, position
procedure terminal.print, esi, ecx, edi
    shl edi, 1                      ; there are 2 bytes per character
    add edi, terminal.VIDEO_MEMORY  ; the address in the video memory

    .loop:
        mov dl, byte [esi + ecx - 1]
        mov byte [edi + ecx * 2 - 2], dl
        dec ecx
        jnz .loop
    ret
