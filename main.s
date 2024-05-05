.section .bss
input_buffer: .space 256            # Allocate 256 bytes for input buffer

.section .data
    binary_str: .ascii "00000000\n"   # String to store binary representation, initialize with 8 zeros and a newline
.section .text
.global _start


# r9: input
# r13: single char of the input
# r10: current number
# r14: operation reg1
# r15: operation reg2
_start:
    mov $0, %ecx          # Counter for the loop
    mov $8, %edx          # Number of bits to process (assuming 8-bit integer)
    
bit_loop:
    shl $1, %eax          # Shift the integer value in %eax left by 1 bit
    jnc zero_bit          # Jump if carry flag is not set (bit shifted out was 0)
    movb $'1', binary_str(%ecx)  # Set the corresponding character in binary_str to '1'
    jmp continue_loop
    
zero_bit:
    movb $'0', binary_str(%ecx)  # Set the corresponding character in binary_str to '0'
    
continue_loop:
    inc %ecx              # Increment the loop counter
    dec %edx              # Decrement the bits counter
    jnz bit_loop          # Jump back to bit_loop if there are more bits to process
    
    # Print the binary representation
    mov $4, %eax          # syscall number for sys_write
    mov $1, %edi          # file descriptor 1 (stdout)
    mov $binary_str, %rsi # address of binary_str
    mov $9, %edx          # length of binary_str (including newline)
    syscall

    # Exit the program
    mov $60, %eax               # syscall number for sys_exit
    xor %edi, %edi              # exit code 0
    syscall
