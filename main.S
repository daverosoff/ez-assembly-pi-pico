.syntax unified
.cpu cortex-m0plus
.thumb
.section .text
.global main
.thumb_func

@@@@@@@@@@@@@@@@@@@ Addresses @@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ The address range d000 0000 through dfff ffff is
@ reserved for SIO (single-cycle input output)
@ control. (Actually, only d000 0000 through
@ d0000 017c is currently used, but the rest is
@ reserved.) Within this range are special addresses
@ we can write to to set the GPIO pins. We are only
@ using the first 8 pins, so we only need the first
@ byte of each word.

@ The GPIO_OUT "register" is the word occupying
@ addresses d000 0010 through d000 0013
@ (4 bytes = 1 word). When we write to this word,
@ bits 0 through 29 set the values of GP0 through
@ GP29. (Bits 30 and 31 of the word are reserved.)
@ So, when we write to first byte, we are writing to
@ address 0xd000 0010 (and only that address).
@ The addresses GPIO_OUT_SET, GPIO_OUT_CLR, and
@ GPIO_OUT_XOR use bit masks. They set, clear, and
@ toggle the marked bits in each case. The sample
@ code writes a 1 to GPIO_OUT_XOR to toggle GP0 and
@ leave the rest of GP1-GP29 alone.

@ In assembly, it is idiomatic to refer to all these
@ addresses as "offsets" from the "base" address
@ SIO_BASE, which gets the value 0xd0000000. Then
@ when we want to write to GPIO_OUT, we use offset
@ notation. The base address goes in a register, say
@ r0, and then the address of GPIO_SET is obtained as
@ [r0, #0x10] in the instruction
@     str #1, [r0, #0x10]
@ which we might read as "store literal 1 into the
@ address pointed to by the value in r0 incremented
@ by literal hex 10".

.equ SIO_BASE,         0xd0000000
.equ GPIO_OUT,         0x10 @ offsets from SIO_BASE
.equ GPIO_OUT_SET,     0x14
.equ GPIO_OUT_CLR,     0x18
.equ GPIO_OUT_XOR,     0x1c

@ The words at offsets 0x20, 0x24, 0x28, and 0x2c
@ function similarly, except that they are used to
@ change GPIO pins to output mode. GPIO_OE sets all
@ the pin modes for GP0-GP29, and the rest operate
@ by bitmasks as described above.

.equ GPIO_OE,          0x20
.equ GPIO_OE_SET,      0x24
.equ GPIO_OE_CLR,      0x28
.equ GPIO_OE_XOR,      0x2c

@ The addresses from 0x40014000 through 0x40014
@ belong to IO_BANK0. Each of the 30 user GPIO
@ pins, GP0-GP29, has a STATUS word
@ and a CTRL word in this bank. They are important
@ because we need to write the value #5 = #0x101
@ into the lowest 4 bits of the CTRL word of each
@ pin we want to use as pure GPIO. These pins can
@ serve many other functions and the function of
@ each pin is encoded in the lowest 4 bits of its
@ CTRL word.

@ The STATUS and CTRL words are offset from the base
@ address IO_BANK0_BASE, 0x40014000, as follows:
@ GPIO0_STATUS ...................... 0x00
@ GPIO0_CTRL ........................ 0x04
@ GPIO1_STATUS ...................... 0x08
@ GPIO1_CTRL ........................ 0x0c
@ GPIO2_STATUS ...................... 0x10
@ GPIO2_CTRL ........................ 0x14
@ GPIO3_STATUS ...................... 0x18
@ GPIO3_CTRL ........................ 0x1c
@ ...
@ GPIO29_STATUS ..................... 0xd8
@ GPIO29_CTRL ....................... 0xdc

.equ IO_BANK0_BASE,    0x40014000

main:
    @ Initialize GP0 function
    ldr r0, io_bank0_base
    movs r1, #5
    str r1, [r0, #0x04] @ GP0

    @ Enable Output on GP0
    ldr r0, sio_base
    movs r1, #1
    str r1, [r0, #GPIO_OE_SET]

blink_loop:
    str r1, [r0, #GPIO_OUT_XOR]

    @ Delay
    ldr r2, =41666667 @ This shortcut is equivalent to storing a separate word
                      @ like we did for SIO_BASE and IO_BANK0_BASE
delay:
    subs r2, r2, #1
    bne delay

    b blink_loop
.align 2 @ after the program we can store some values that are too big
         @ to fit in our 8-bit register (and thus too big to be encoded)
         @ directly in instructions
         @ we need them to be aligned to addresses that end in 0, 4, 8, c
         @ that is the effect of .align 2 directive
sio_base:
    .word SIO_BASE
io_bank0_base:
    .word IO_BANK0_BASE
