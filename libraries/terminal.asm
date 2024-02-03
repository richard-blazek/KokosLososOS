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
terminal.clear:
    push ecx

    ; Each character has a text byte and a colour byte, so we multiply by two
    mov ecx, (terminal.WIDTH * terminal.HEIGHT * 2)
    .loop:
        mov dword [terminal.VIDEO_MEMORY + ecx - 4], 0
        sub ecx, 4
        jnz .loop

    pop ecx
    ret


; Writes a string to a given position with a given formatting.
; Arguments:
;   - string
;   - string length
;   - position
;   - text colour
;   - background colour
terminal.print:
    pushad
    mov eax, [esp+52] ; background colour
    mov ebx, [esp+48] ; text colour
    shl eax, 4
    or eax, ebx       ; the colour code

    mov edi, [esp+44] ; position
    shl edi, 1        ; there are 2 bytes per character
    add edi, terminal.VIDEO_MEMORY ; the address in the video memory

    mov esi, [esp+36] ; string
    mov ecx, [esp+40] ; string length

    .loop:
        mov dl, byte [esi + ecx - 1]
        mov byte [edi + ecx * 2 - 2], dl
        mov byte [edi + ecx * 2 - 1], al
        dec ecx
        jnz .loop

    popad
    ret
