.data
    value: .word 0

.text
.global main
main:
    mov $value, %edi        # Load the address of value into edi
    call read_int           # Call the function to read an integer
    movl (%edi), %eax       # Load the value from memory into eax

    # Limit value to 12 bits
    andl $0xFFF, %eax

    # Print binary representation
    movl $12, %ecx          # Set loop counter to 12
loop_start:
    movl $1, %edx           # Prepare mask
    shll $11, %edx          # Shift mask to the leftmost bit
    andl %edx, %eax         # Apply mask
    testl %eax, %eax        # Test if the bit is set
    jnz bit_set             # Jump if bit is set
    movl $'0', %ebx         # Move '0' to ebx
    jmp print_char          # Jump to print character

bit_set:
    movl $'1', %ebx         # Move '1' to ebx

print_char:
    movl $1, %eax           # syscall number for sys_write
    movl $1, %edi           # file descriptor 1 (stdout)
    movq %rbx, %rsi         # character to print
    movq $1, %rdx           # number of bytes to print (1 byte)
    syscall

    shll $1, %eax           # Shift right mask for next bit
    loop loop_start         # Repeat for remaining bits

    movl $10, %ebx          # Move newline character to ebx
    movl $1, %eax           # syscall number for sys_write
    movl $1, %edi           # file descriptor 1 (stdout)
    movl %ebx, %esi         # character to print
    movl $1, %edx           # number of bytes to print (1 byte)
    syscall

    movl $60, %eax          # syscall number for sys_exit
    xorl %edi, %edi         # return code 0
    syscall

read_int:
    # Prepare arguments for syscall sys_read
    movq $0, %rax           # syscall number for sys_read
    movq $0, %rdi           # file descriptor 0 (stdin)
    movq %edi, %rsi         # buffer to read into
    movq $4, %rdx           # number of bytes to read (4 bytes)
    syscall
    ret
