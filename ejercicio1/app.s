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
        movz    x10, 0x16, lsl 16  // x10 = 0x (00 00 00 00) [00 16 00 00]  [] es w10
        movk    x10, 0x032f, lsl 0 // x10 = 0x (00 .. 00 ) [00 16 03 2F]
        mov     x2,  SCREEN_HEIGH  // x2 = 480 
bg_row: mov     x1,  SCREEN_WIDTH  // x1 = 640
bg_col: stur    w10, [x0]          // w10 = 32 bits menos significativos de x10 y usa stur para settear el valor del pointer. En C: x0* = w10;
        add     x0,  x0,  #4       // avanza 4 bytes el puntero/ 4 bytes en direcciones de mem, o al siguiente pixel. En C: x0 += 4 Bytes;
        sub     x1,  x1,  #1       // resta 1 al ancho
        cbnz    x1,  bg_col        // (x1 != 0) --> volve al inicio del loop horizontal  
        sub     x2,  x2,  #1       // resta 1 al alto
        cbnz    x2,  bg_row        // vuelve a settear el ancho a su valor inicial y repite el loop

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
