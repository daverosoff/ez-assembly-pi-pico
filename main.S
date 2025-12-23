.syntax unified
.cpu cortex-m0plus
.thumb
.section .text
.global main
.thumb_func

@ Addresses
.equ SIO_BASE,         0xd0000000
.equ GPIO_OUT,         0x10 @ offsets from SIO_BASE
.equ GPIO_OUT_SET,     0x14
.equ GPIO_OUT_CLR,     0x18
.equ GPIO_OUT_XOR,     0x1c
.equ GPIO_OE,          0x20
.equ GPIO_OE_SET,      0x24
.equ GPIO_OE_CLR,      0x28
.equ GPIO_OE_XOR,      0x2c
.equ IO_BANK0_BASE, 0x40014000

main:
    @ Initialize GP0 function
    ldr r0, =IO_BANK0_BASE
    movs r1, #5
    str r1, [r0, #0x04] @ GP0

    @ Enable Output on GP0
    ldr r0, =SIO_BASE
    movs r1, #1
    str r1, [r0, #GPIO_OE_SET]

blink_loop:
    str r1, [r0, #GPIO_OUT_XOR]

    @ Delay
    ldr r2, =5000000
delay:
    subs r2, r2, #1
    bne delay

    b blink_loop
