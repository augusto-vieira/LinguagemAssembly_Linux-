section .text
global _start  ; label global, assim fica visível para o linker

_start:

; return 0
mov ebx, 0; valor do retorno da exit()
mov eax, 1 ; codigo da syscall exit(), valor 1.
int 0x80
