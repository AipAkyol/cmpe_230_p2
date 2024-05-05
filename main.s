.section .bss
input_buffer: .space 256            # Allocate 256 bytes for input buffer

.section .data

.newline.str:
    .ascii "\n"

.whitespace.str:
    .ascii " "

.section .text
.global _start


# r9: input
# r13: single char of the input
# r10: current number
# r14: operation reg1
# r15: operation reg2
_start:
    # Read input from standard input
    mov $0, %eax                    # syscall number for sys_read
    mov $0, %edi                    # file descriptor 0 (stdin)
    lea input_buffer(%rip), %rsi    # pointer to the input buffer
    mov $256, %edx                  # maximum number of bytes to read
    syscall                         # perform the syscall

    mov %rsi, %r9
    mov $0, %r10

    loop_start:
        movzbq (%r9), %r13  # Move one byte from memory at address stored in r9 to r13
        
        cmp $'\n', %r13                # Compare the character with newline ('\n')
        je loop_end                # If it's null character, end the loop
        
        cmp $' ', %r13                # Compare the character with whitespace
        jnz addition
           
        # implement stack and computations here
        # TODO: opertaiondan sonra 2 ekle ki stacke operation atmasın
        # TODO: stacke pushladıktan sonra r10 u sıfıra esitle
        push %r10
        mov $0, %r10

        add $1, %r9
        jmp loop_start             # Continue looping

        addition:
        cmp $'+', %r13                # Compare the character with whitespace
        jnz number_constructor

        pop %r15
        pop %r14

        add %r15, %r14
        push %r14

        mov $0, %r14
        mov $0, %r15

        # todo: implement prints

        add $2, %r9
        jmp loop_start             # Continue looping

        number_constructor:
        mov $10, %rax    # for decimal significancy
        mul %r10
        mov %rax, %r10 # multiplacation result
        sub $48, %r13   # ascii to number
        add %r13, %r10 # append the new decimal to the rest

        
        add $1, %r9
        jmp loop_start             # Continue looping
    loop_end:

    # Exit the program
    mov $60, %eax               # syscall number for sys_exit
    xor %edi, %edi              # exit code 0
    syscall
