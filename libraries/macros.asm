; Calling convention: Arguments are passed on the stack in a right-to-left
; order and the caller is responsible for cleaning them up. Return value is
; stored in EAX. All general-purpose registers except EAX must be saved and
; preserved by the subroutine. A lot like cdecl.
macro call proc*, [arg] {
    common
        local size
        size = 0

    reverse
        match any, arg \{
            push arg
            size = size + 4
        \}

    common
        call proc
        if size > 0
            add esp, size
        end if
}

macro procedure proc*, [reg] {
    common
    proc:
        pushad
        local shift
        shift = 36

    forward
        match any, reg \{
            mov reg, [esp+shift]
            shift = shift + 4
        \}
}

macro ret {
    popad
    ret
}
