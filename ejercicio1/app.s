	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.globl main

main:
        // x0 llega con la base del framebuffer
        mov     x20, x0                  // guarda FB base

// ---------- 1) PINTAR EL FONDO COMPLETO -------------------------
        movz    x10, 0x16, lsl 16
        movk    x10, 0x032f, lsl 0
        mov     x2,  SCREEN_HEIGH
bg_row: mov     x1,  SCREEN_WIDTH
bg_col: stur    w10, [x0]
        add     x0,  x0,  #4
        sub     x1,  x1,  #1
        cbnz    x1,  bg_col
        sub     x2,  x2,  #1
        cbnz    x2,  bg_row

        bl drawLightsaber

        bl drawRightHand

        bl drawLeftHand


// ---------- 3) GPIO DEMO + BUCLE INFINITO -----------------------
        mov     x9,  GPIO_BASE
        str     wzr, [x9, GPIO_GPFSEL0]  // GPIO 0-9 como entrada
        ldr     w10, [x9, GPIO_GPLEV0]   // lee 32 bits
        and     w11, w10, 0b10
        lsr     w11, w11, 1

	// --------------- Infinite Loop ---------------


InfLoop:
        b       InfLoop
