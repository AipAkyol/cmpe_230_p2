.section .bss
input_buffer: .space 256            # Allocate 256 bytes for input buffer

.section .data
    binary_str: .ascii "000000000000"   # String to store binary representation, initialize with 12 zeros and a newline
    r2_str: .ascii " 00000 000 00010 0010011\n"
    r1_str: .ascii " 00000 000 00001 0010011\n"
    add_str: .ascii "0000000 00010 00001 000 00001 0110011\n"
    sub_str: .ascii "0100000 00010 00001 000 00001 0110011\n"
    mul_str: .ascii "0000001 00010 00001 000 00001 0110011\n"
    and_str: .ascii "0000111 00010 00001 000 00001 0110011\n"
    or_str: .ascii "0000110 00010 00001 000 00001 0110011\n"
    xor_str: .ascii "0000100 00010 00001 000 00001 0110011\n"

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

        # constrcut the number and push it to the stack   
        push %r10
        mov $0, %r10

        add $1, %r9
        jmp loop_start             # Continue looping

        addition:
        cmp $'+', %r13                # Compare the character with +
        jnz subtraction

        pop %r15
        mov %r15, %r12
        call _print_binary_number
        # Print the rest
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $r2_str, %rsi 
        mov $25, %edx          # length of str
        syscall

        pop %r14
        mov %r14, %r12
        call _print_binary_number
        # Print the rest
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $r1_str, %rsi 
        mov $25, %edx          # length of str
        syscall

        add %r15, %r14       # operation
        push %r14           # push back the result

        # Print the operation
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $add_str, %rsi 
        mov $38, %edx          # length of str
        syscall

        mov $0, %r14
        mov $0, %r15


        jmp operation_skipper    # jump to operation skipper to skip whitespace after operation

        subtraction:
        cmp $'-', %r13                # Compare the character with -
        jnz multiplacation

        pop %r15
        mov %r15, %r12
        call _print_binary_number
        # Print the rest
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $r2_str, %rsi 
        mov $25, %edx          # length of str
        syscall

        pop %r14
        mov %r14, %r12
        call _print_binary_number
        # Print the rest
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $r1_str, %rsi 
        mov $25, %edx          # length of str
        syscall

        sub %r15, %r14     # operation
        push %r14          # psuh back the result
        
        # Print the operation
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $sub_str, %rsi 
        mov $38, %edx          # length of str
        syscall
        
        mov $0, %r14
        mov $0, %r15

        jmp operation_skipper     # jump to operation skipper to skip whitespace after operation

        multiplacation:
        cmp $'*', %r13                # Compare the character with -
        jnz and_operation

        pop %r15
        mov %r15, %r12
        call _print_binary_number
        # Print the rest
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $r2_str, %rsi 
        mov $25, %edx          # length of str
        syscall

        pop %r14
        mov %r14, %r12
        call _print_binary_number
        # Print the rest
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $r1_str, %rsi 
        mov $25, %edx          # length of str
        syscall

        mov %r15, %rax    
        mul %r14
        mov %rax, %r14     # operation
        push %r14          # psuh back the result

        # Print the operation
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $mul_str, %rsi 
        mov $38, %edx          # length of str
        syscall

        mov $0, %r14
        mov $0, %r15

        jmp operation_skipper     # jump to operation skipper to skip whitespace after operation


        and_operation:
        cmp $'&', %r13                # Compare the character with &
        jnz or_operation

        pop %r15
        mov %r15, %r12
        call _print_binary_number
        # Print the rest
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $r2_str, %rsi 
        mov $25, %edx          # length of str
        syscall

        pop %r14
        mov %r14, %r12
        call _print_binary_number
        # Print the rest
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $r1_str, %rsi 
        mov $25, %edx          # length of str
        syscall

        and %r15, %r14     # operation
        push %r14          # psuh back the result

        # Print the operation
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $and_str, %rsi 
        mov $38, %edx          # length of str
        syscall

        mov $0, %r14
        mov $0, %r15

        jmp operation_skipper     # jump to operation skipper to skip whitespace after operation

        or_operation:
        cmp $'|', %r13                # Compare the character with |
        jnz xor_operation

        pop %r15
        mov %r15, %r12
        call _print_binary_number
        # Print the rest
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $r2_str, %rsi 
        mov $25, %edx          # length of str
        syscall

        pop %r14
        mov %r14, %r12
        call _print_binary_number
        # Print the rest
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $r1_str, %rsi 
        mov $25, %edx          # length of str
        syscall

        or %r15, %r14     # operation
        push %r14          # psuh back the result

        # Print the operation
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $or_str, %rsi 
        mov $38, %edx          # length of str
        syscall        

        mov $0, %r14
        mov $0, %r15

        jmp operation_skipper     # jump to operation skipper to skip whitespace after operation

        xor_operation:
        cmp $'^', %r13                # Compare the character with ^
        jnz number_constructor

        pop %r15
        mov %r15, %r12
        call _print_binary_number
        # Print the rest
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $r2_str, %rsi 
        mov $25, %edx          # length of str
        syscall

        pop %r14
        mov %r14, %r12
        call _print_binary_number
        # Print the rest
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $r1_str, %rsi 
        mov $25, %edx          # length of str
        syscall

        xor %r15, %r14     # operation
        push %r14          # psuh back the result

        # Print the operation
        mov $1, %eax          # syscall number for sys_write
        mov $1, %edi          # file descriptor 1 (stdout)
        mov $xor_str, %rsi 
        mov $38, %edx          # length of str
        syscall        

        mov $0, %r14
        mov $0, %r15

        jmp operation_skipper     # jump to operation skipper to skip whitespace after operation


        operation_skipper:
        
        add $1, %r9
        
        movzbq (%r9), %r13  # Move one byte from memory at address stored in r9 to r13
        cmp $'\n', %r13                # Compare the character with newline ('\n')
        je loop_start                # If it's newline character, dont add one more index to jump

        add $1, %r9        # skip the whitespace
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


    # todo remove this
    pop %r14
#    movq $1, %rax
#    movq $1, %rdi
#    add $48, %r14
#    movq %r14, %rsi
#    movq $1, %rdx # +1 for asciz, if ascii no +1 needed
#    syscall

    # Exit the program
    mov $60, %eax               # syscall number for sys_exit
    xor %edi, %edi              # exit code 0
    syscall

_print_binary_number:
    mov $11, %ecx          # Counter for the loop
    mov $12, %edx          # Number of bits to process (assuming 8-bit integer)

    bit_loop:
        shr $1, %r12          # Shift the integer value in %eax left by 1 bit
        jnc zero_bit          # Jump if carry flag is not set (bit shifted out was 0)
        movb $'1', binary_str(%ecx)  # Set the corresponding character in binary_str to '1'
        jmp continue_loop

    zero_bit:
        movb $'0', binary_str(%ecx)  # Set the corresponding character in binary_str to '0'
    
    continue_loop:
        dec %ecx              # Increment the loop counter
        dec %edx              # Decrement the bits counter
        jnz bit_loop          # Jump back to bit_loop if there are more bits to process
    
    # Print the binary representation
    mov $1, %eax          # syscall number for sys_write
    mov $1, %edi          # file descriptor 1 (stdout)
    mov $binary_str, %rsi # address of binary_str
    mov $12, %edx          # length of binary_str 
    syscall
    ret
