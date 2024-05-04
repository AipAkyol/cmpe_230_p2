.section .bss
input_buffer: .space 256            # Allocate 256 bytes for input buffer

.section .data

.newline.str:
    .ascii "\n"

.section .text
.global _start

_start:
    # Read input from standard input
    mov $0, %eax                    # syscall number for sys_read
    mov $0, %edi                    # file descriptor 0 (stdin)
    lea input_buffer(%rip), %rsi    # pointer to the input buffer
    mov $256, %edx                  # maximum number of bytes to read
    syscall                         # perform the syscall

    mov %rsi, %r9

    call print_func
    jmp exit_program  


print_func:
    # Assumes edx has size and rsi has address (popped from stack)
    mov $1, %eax                    # syscall number for sys_write
    mov $1, %edi                    # file descriptor 1 (stdout)
    loop_start:
        mov %r9, %rsi # Load the next character into %rsi
        mov (%rsi), %r13
        cmp $'\n', %r13                # Compare the character with newline ('\n')
        je loop_end                # If it's null character, end the loop
        mov $1, %eax               # syscall number for sys_write
        mov $1, %rdi               # file descriptor 1 (stdout)
        mov $1, %rdx               # Write one character
        syscall                    # Print the character
        leaq .newline.str, %rsi            # Load newline character into %rdx
        mov $1, %eax               # syscall number for sys_write
        mov $1, %edi               # file descriptor 1 (stdout)
        mov $1, %edx               # Write one character
        syscall                    # Print the newline character
        add $1, %r9
        jmp loop_start             # Continue looping
    loop_end:
    ret

exit_program:
    # Exit the program
    mov $60, %eax               # syscall number for sys_exit
    xor %edi, %edi              # exit code 0
    syscall
