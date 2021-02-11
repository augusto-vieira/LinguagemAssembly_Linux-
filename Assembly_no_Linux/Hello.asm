; ssize_t write(int fd, const void *buf, size_t count);

section .data ; seção .rodata do ELF, onde ficam os dados somente-leitura
msg: db "www.mentebinaria.com.br", 0xa ; string que será impressa, seguida de um \n
tam: equ $-msg  ; "$" significa "aqui" -> posição atual menos posição do texto. len terá o tamanho da string.

section .text ; seção .text do ELF, onde fica o código
global _start ; faz o label "_start" visível ao linker (ld)faz o label "_start" visível ao linker (ld)

_start:

mov edx, tam  ; arg3 da syscall write(), quantidade de bytes para imprimir (tamanho)
mov ecx, msg  ; arg2, pointeiro para o endereço da string
mov ebx, 1    ; arg1, em qual file descriptor (fd) escrever. 1 é stdout
mov eax, 4    ; 4 é o código da syscall write()
int 0x80      ; interrupção 0x80 do kernel (executa a syscall apontada em eax)

; void _exit(int status);
mov ebx, 0; valor do retorno da exit()  ; arg1 da syscall exit(). 0 significa execução com sucesso
mov eax, 1  ; 1 é o código da syscall exit()
int 0x80    ; executa a syscall apontada em eax, que vai sair do programa
