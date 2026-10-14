.set MB_MAGIC, 0x1BADB002
.set MB_FLAGS, 0x00000007
.set MB_CHECK, -(MB_MAGIC + MB_FLAGS)
.section .multiboot,"a"
.align 4
.long MB_MAGIC
.long MB_FLAGS
.long MB_CHECK
.long 0,0,0,0,0
.long 0
.long 1024
.long 768
.long 32
.section .text
.global _start
_start:
    cli
    cld
    movl $stack_top, %esp
    pushl %ebx
    pushl %eax
    lgdt gdt_desc
    ljmp $0x08, $1f
1:
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    fninit
    call kmain
2:
    cli
    hlt
    jmp 2b

.global launch_application
launch_application:
    cli
    movl 4(%esp), %eax
    movl 8(%esp), %ebx
    movl 12(%esp), %edx
    movl $0x01F00000, %esp
    jmp *%edx

.section .rodata
.align 8
gdt:
.quad 0
.quad 0x00CF9A000000FFFF
.quad 0x00CF92000000FFFF
gdt_end:
gdt_desc:
.word gdt_end-gdt-1
.long gdt
.section .bss
.align 16
stack_bottom:
.skip 262144
stack_top:
