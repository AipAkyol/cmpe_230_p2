.section .data
hello_msg:
    .ascii "Hello, World!\n"
    hello_msg_len = . - hello_msg

.section .text
.globl _start
_start:
    mov $1, %rax             # syscall number for sys_write
    mov $1, %rdi             # file descriptor 1 (stdout)
    lea hello_msg(%rip), %rsi   # address of the message
    mov hello_msg_len(%rip), %rdx # message length
    syscall

    mov $60, %rax            # syscall number for sys_exit
    xor %rdi, %rdi           # exit code 0
    syscall
    