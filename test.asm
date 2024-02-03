format ELF executable
entry  _start

segment readable executable

; converts positive integer to string
; subroutine itoa (number: dword, destination: dword) -> (length : dword)
itoa:
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


_start:
    mov edi,msg
    add edi,14
    push edi
    push 123456789
    call itoa
    add esp, 8

    mov edx,len     ; third argument: message length
    mov ecx,msg     ; second argument: pointer to message to write
    mov ebx,1       ; first argument: file handle (stdout)
    mov eax,4       ; system call number (sys_write)
    int 0x80        ; call kernel

  	mov ebx,0       ; first syscall argument: exit code
    mov eax,1       ; system call number (sys_exit)
    int 0x80        ; call kernel

segment readable writable
    msg: db "Hello, world!            ",10
    len = $ - msg
