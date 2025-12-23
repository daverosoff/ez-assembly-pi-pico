.syntax unified
.cpu cortex-m0plus
.thumb
.section .text
.global main
.thumb_func

.equ SIO_BASE,        0xd0000000
.equ GPIO_OUT_SET,    0x14
.equ GPIO_OUT_CLR,    0x18

main:
    @ Initialize GP0 function
    ldr r0, =IO_BANK0_GP0_CTRL
    movs r1, #5
    str r1, [r0, #0x04] @ GP0
    str r1, [r0, #0x0c] @ GP1
    str r1, [r0, #0x14] @ GP2
    str r1, [r0, #0x1c] @ GP3
    str r1, [r0, #0x24] @ GP4
    str r1, [r0, #0x2c] @ GP5
    str r1, [r0, #0x34] @ GP6
    str r1, [r0, #0x3c] @ GP7
    ldr r0, =SIO_BASE
    movs r1, #5
    str r1, [r0, #GPIO_OUT_SET]

loop:
    b loop
