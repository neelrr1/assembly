format ELF64 executable 3

entry main
segment executable readable

SYSCALL_EXIT = 60
EXIT_CODE = 0

SYSCALL_WRITE = 1
STDOUT = 1

ENDL = 10

main:
    ; Call write syscall to print the message to the terminal
    mov rax, SYSCALL_WRITE
    mov rdi, STDOUT
    lea rsi, [message]
    mov rdx, message_len
    syscall

    ; Exit with EXIT_CODE
    mov rax, SYSCALL_EXIT
    mov rdi, EXIT_CODE
    syscall

segment readable writeable
message: db 'Hello, World!', ENDL
message_len = $ - message