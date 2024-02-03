; Converts a positive integer to a string.
; Arguments:
;   - number
;   - destination
; Returns: the length of the string
utils.itoa:
    push ebx            ; push registers
    push ecx
    push edx
    push edi
    mov edi, [esp+24]   ; destination
    mov eax, [esp+20]   ; number
    mov ebx, 10         ; divisor
    mov ecx, 0          ; length

    .itoaDivLoop:
        mov edx, 0             ; upper register for division
        div ebx                ; remainder in edx, quotient in eax
        add edx, '0'           ; convert remainder 0...9 to character '0'...'9'
        mov byte [edi+ecx], dl ; store character to memory
        add ecx, 1             ; increment counter
        cmp eax, 0             ; loop until eax becomes zero
        jnz .itoaDivLoop

    mov eax, ecx
    dec eax      ; eax is the last index
    mov esi, 0   ; ebx is the first index
    .itoaReverseLoop:
        cmp eax, esi
        jbe .itoaReverseLoopEnd

        mov dl, byte [edi+eax]
        mov bl, byte [edi+esi]
        mov byte [edi+eax], bl
        mov byte [edi+esi], dl

        inc esi
        dec eax
        jmp .itoaReverseLoop
    .itoaReverseLoopEnd:

    mov eax, ecx
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret
