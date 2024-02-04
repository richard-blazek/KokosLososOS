; Calling convention: Arguments are passed on the stack in a right-to-left
; order and the caller is responsible for cleaning them up. Return value is
; stored in EAX. All general-purpose registers except EAX must be saved and
; preserved by the subroutine. A lot like cdecl.

macro macros._reverse_push [arg*] {
    reverse push arg
}

macro macros.call proc*, args& {
    size equ 0

    match any, args \{
        macros._reverse_push args
        irp arg, args \\{
            size equ (size + 4)
        \\}
    \}

    call proc
    if size > 0
        add esp, size
    end if
}
