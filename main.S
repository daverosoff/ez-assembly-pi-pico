.syntax unified
.cpu cortex-m0plus
.thumb
.section .text
.global main

.equ SIO_BASE,        0xd0000000
.equ GPIO_OUT_SET,    0x14
.equ GPIO_OUT_CLR,    0x18

main:
    @ Initialize the GPIO (Standard SDK boilerplate)
    bl stdio_init_all

    @ Task: Turn on LED 0 and LED 2 (Binary 00000101 = 0x05)
    ldr r0, =SIO_BASE
    movs r1, #5
    str r1, [r0, #GPIO_OUT_SET]

loop:
    b loop
