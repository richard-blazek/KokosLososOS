terminal._video_memory = 0xB8000
terminal._width = 80
terminal._height = 25
terminal._size = terminal._width * terminal._height * 2
terminal._scroll = terminal._width * 5 * 2
terminal._cursor dd 0

; Clear the screen
procedure terminal.clear
    mov ecx, 0
    .loop:
        mov dword [terminal._video_memory + ecx], 0x0A000A00 ; light green text on black background
        add ecx, 4
        cmp ecx, terminal._size
        jnz .loop

    mov dword [terminal._cursor], 0 ; reset cursor position
    ret


; Writes a character to the screen.
; Arguments: the character
procedure terminal.putc, eax
    cmp eax, 10     ; if encountered the Line Feed character
    je .newline
    
    .not_newline:
        mov ecx, dword [terminal._cursor]
        mov byte [terminal._video_memory + ecx], al
        add dword [terminal._cursor], 2 ; 2 bytes per character
        jmp .check_scroll
    
    .newline:
        mov ecx, dword [terminal._cursor]
        mov edx, 0
        mov eax, ecx
        mov ebx, 160
        div ebx ; EDX:EAX divided by EBX, remainder put in EDX
        sub ecx, edx
        add ecx, 160
        mov dword [terminal._cursor], ecx
    
    .check_scroll:
        cmp dword [terminal._cursor], terminal._size
        jl .finish

        sub dword [terminal._cursor], terminal._scroll
        mov ecx, 0
    .scroll_loop:
        mov ax, word [terminal._video_memory + terminal._scroll + ecx]
        mov word [terminal._video_memory + ecx], ax
        add ecx, 2
        cmp ecx, (terminal._size - terminal._scroll)
        jnz .scroll_loop

    .clear_loop:
        mov word [terminal._video_memory + ecx], 0x0A00
        add ecx, 2
        cmp ecx, terminal._size
        jnz .clear_loop

    .finish:
        ret


; Writes a string to the screen.
; Arguments: string, length
procedure terminal.puts, esi, ebx
    add ebx, esi
    mov eax, 0
    .loop:
        cmp esi, ebx
        je .loop_end
        mov al, byte [esi]
        call terminal.putc, eax
        inc esi
        jmp .loop
    .loop_end:
        ret
