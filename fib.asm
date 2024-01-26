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

; subroutine to print the number stored in rax to stdout
print_number:
    ; count how many digits are in the input and write remainders to buf
    xor rbx, rbx ; store loop iterations in rbx

r:
    ; divide by 10
    mov rcx, 10
    xor rdx, rdx
    div rcx

    add rdx, 48 ; convert remainder to ascii
    lea rsi, [buf + buf_len - 1]
    sub rsi, rbx
    mov byte [rsi], dl ; store character in buffer
    inc rbx ; increment loop counter
    cmp rax, 0 ; if # is not 0, repeat
    jne r

    ; print the answer
    mov rax, SYSCALL_WRITE
    mov rdi, STDOUT
    lea rsi, [buf + buf_len]
    sub rsi, rbx
    mov rdx, rbx
    syscall

    ret

print_newline:
    mov rax, SYSCALL_WRITE
    mov rdi, STDOUT
    lea rsi, [newline]
    mov rdx, 1
    syscall

    ret

main:
    ; Read from stdin in a loop until we read a newline
    xor r8, r8 ; r8 will track the input
    mov r10, 10
    
get_input:
    ; read(STDIN, &k, 1)
    mov rax, SYSCALL_READ
    mov rdi, STDIN
    lea rsi, [k]
    mov rdx, 1
    syscall

    ; break if we read a newline
    cmp byte [k], 10
    je init

    ; r8 is the input number so far, r9 is the new digit we are trying to insert
    movzx r9, byte [k]
    sub r9, 48 ; convert ASCII digit to real digit
    
    ; multiply r8 by 10
    mov r10, r8
    shl r8, 3
    add r8, r10
    add r8, r10

    ; insert the newly read digit
    add r8, r9
    jmp get_input
init:
    mov r9, 0
    mov r10, 1

fib:
    ; calculate next number in sequence
    mov r11, r10
    add r11, r9
    ; set previous numbers
    mov r9, r10
    mov r10, r11

    ; print number stored in r10
    mov rax, r10
    call print_number
    call print_newline

    dec r8
    cmp r8, 0
    jnz fib

exit:
    ; Exit with EXIT_CODE
    mov rax, SYSCALL_EXIT
    mov rdi, EXIT_CODE
    syscall

segment readable writeable
k: rb 1
k_len = $ - k
buf: rb 20 ; longest 64 bit number is 20 digits
buf_len = $ - buf

newline: db 10