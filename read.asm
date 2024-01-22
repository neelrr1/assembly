format ELF64 executable 3

entry main
segment executable readable

SYSCALL_EXIT = 60
EXIT_CODE = 0

SYSCALL_READ = 0
SYSCALL_WRITE = 1

STDIN = 0
STDOUT = 1

ENDL = 10

main:
    ; Read from stdin in a loop until we read a newline
    mov r8, 0 ; r8 will track how many characters we read!
loup:
    ; read(STDIN, &buf, 1)
    mov rax, SYSCALL_READ
    mov rdi, STDIN
    lea rsi, [r8 + buf]
    mov rdx, 1
    syscall

    mov r9, [r8 + buf]
    
    inc r8
    cmp r9, 10
    jne loup

    ; Call write syscall to print the message to the terminal
    mov rax, SYSCALL_WRITE
    mov rdi, STDOUT
    lea rsi, [prefix]

    ; # of characters to print is the length of the input + the length of the prefix
    mov rdx, r8
    add rdx, prefix_len
    syscall

    ; Exit with EXIT_CODE
    mov rax, SYSCALL_EXIT
    mov rdi, EXIT_CODE
    syscall

segment readable writeable
prefix: db 'You wrote: '
prefix_len = $ - prefix
buf_size = 256
buf: rb buf_size