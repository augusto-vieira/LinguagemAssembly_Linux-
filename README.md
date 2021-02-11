## Assembly no Linux x86_64

Para um programa realizar qualquer operação/comunicação com o sistema operacional, é preciso chamar funções do SO, que são conhecidas como syscall. No ambiente Windows as chamadas do SO são realizadas pela “API Windows”.

**Return0 em Asm:**
```asm
section .text
global _start   ; label global, assim fica visível para o linker

_start:

; return 0
mov ebx, 0  ; valor do retorno da exit()
mov eax, 1  ; codigo da syscall exit(), valor 1.
int 0x80
```
**Ferramenta :**
O strace é uma ferramenta que monitora as chamadas de sistema system calls) e os sinais recebidos pela aplicação.

**Comandos:**
``` bash
sudo apt-get install strace
strace ./sai
```
``` bash
# Saída
execve("./sai", ["./sai"], 0x7ffebe1a7d30 /* 21 vars */) = 0
strace: [ Process PID=638 runs in 32 bit mode. ]
exit(0)                                 = ?
+++ exited with 0 +++

```

**Pegar o retorno de um programa pelo Bash:**
``` bash
echo $?
```

**Verifica as bibliotecas compartilhadas necessárias por cada programa ou biblioteca compartilhada especificada:**
``` bash
ldd return0_c 
```
``` bash
# Compilação em C
    linux-vdso.so.1 (0x00007ffc851d4000)
    libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f220ca8e000)
    /lib64/ld-linux-x86-64.so.2 (0x00007f220cc5c000)
```
``` bash
# Compilação em Asm
    not a dynamic executable # chama as funções diretamente
```

**Compilando:**
``` bash
nasm -f elf32 return0_Asm.asm # Gerando um arquivo objeto para 32 bits
ld -m elf_i386 -o bin_Asm  return0_Asm.o # Linkando o objeto
```
**Dump:**
``` bash
objdump -dM intel bin_Asm
```
``` bash
# Dump em Asm
bin_Asm:     file format elf32-i386

Disassembly of section .text:

08049000 <_start>:
 8049000:       bb 00 00 00 00          mov    ebx,0x0 # Argumento
 8049005:       b8 01 00 00 00          mov    eax,0x1 # Função
 804900a:       cd 80                   int    0x80

```
``` bash
# Dump em C
0000000000001125 <main>:
    1125:       55                      push   rbp
    1126:       48 89 e5                mov    rbp,rsp
    1129:       b8 00 00 00 00          mov    eax,0x0 # Argumento
    112e:       5d                      pop    rbp
    112f:       c3                      ret	# Não vemos a chamada da Syscall, a LibC que irá realizar a chamada
```

**Hello Word em Asm:**
```asm
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
```

### Referência:

- https://www.mentebinaria.com.br/

    💪 Apoio:
Nossa comunidade - https://menteb.in/apoie​ 💚

    Spod - https://spod.com.br/vpn/

- Treinamento de Engenharia Reversa

    http://www.mentebinaria.com.br/index...

- https://github.com/mentebinaria