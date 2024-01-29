# OS
Using x86 Intel Assembly.

## Calling convention
Arguments are passed on the stack in a right-to-left order and the caller
is responsible for cleaning them up. Return value is stored in EAX. All
general-purpose registers except EAX must be saved and preserved by the subroutine.
A lot like cdecl.
