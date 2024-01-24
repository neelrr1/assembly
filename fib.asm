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

print_newline:
    mov rax, SYSCALL_WRITE
    mov rdi, STDOUT
    lea rsi, [newline]
    mov rdx, 1
    syscall

    ret

main:
    ; Read from stdin in a loop until we read a newline
    mov r8, 0 ; r8 will track how many loop iterations to do
    
    ; read(STDIN, &k, 1)
    mov rax, SYSCALL_READ
    mov rdi, STDIN
    lea rsi, [k]
    mov rdx, 1
    syscall

    ; r8 is loop counter, r9 is prev prev, r10 is prev
    mov r8b, [k]
    sub r8b, 48 ; convert ASCII digit to real digit
    
    mov r9b, 0
    mov r10b, 1

loup:
    mov byte[k], r10b
    add byte[k], 48
    
    mov r11b, r10b
    add r11b, r9b

    mov r9b, r10b
    mov r10b, r11b

    mov rax, SYSCALL_WRITE
    mov rdi, STDOUT
    lea rsi, [k]
    mov rdx, k_len
    syscall

    dec r8b
    cmp r8b, 0
    jnz loup

    call print_newline

    ; Exit with EXIT_CODE
    mov rax, SYSCALL_EXIT
    mov rdi, EXIT_CODE
    syscall

segment readable writeable
k: rb 1
db ' '
k_len = $ - k

newline: db 10