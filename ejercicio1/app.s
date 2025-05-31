	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.globl main

draw_rectangle:
	stp     x30, x12, [sp, -16]!
	mov     x7,  x4                   // alto = h
	mov     x8,  x3                   // ancho original
.rectRow: // dirección fila (x,y)
	mov     x9,  x2
	lsl     x9,  x9,  #9
	mov     x12, x2
	lsl     x12, x12, #7
	add     x9,  x9,  x12
	add     x9,  x9,  x1
	lsl     x9,  x9,  #2
	add     x9,  x9,  x0
	// recorre ancho
	mov     x6,  x3                    // ancho restante
.rectPix:	stur    w5, [x9]
	add     x9,  x9,  #4
	sub     x6,  x6,  #1
	cbnz    x6,  .rectPix
	// próxima fila
	add     x2,  x2,  #1
	sub     x7,  x7,  #1
	cbnz    x7,  .rectRow
	ldp     x30, x12, [sp], 16
	ret



main:
        // x0 llega con la base del framebuffer
        mov     x20, x0                  // guarda FB base

// ---------- 1) PINTAR EL FONDO COMPLETO -------------------------
        movz    x10, 0xC7, lsl 16
        movk    x10, 0x1585, lsl 0
        mov     x2,  SCREEN_HEIGH
bg_row: mov     x1,  SCREEN_WIDTH
bg_col: stur    w10, [x0]
        add     x0,  x0,  #4
        sub     x1,  x1,  #1
        cbnz    x1,  bg_col
        sub     x2,  x2,  #1
        cbnz    x2,  bg_row

// ---------- 2) DIBUJO DE FIGURAS --------------------------------
// -- Rectángulo rojo (80,60) 180×120 -----------------------------
        mov     x0,  x20                 // base FB
        mov     x1,  #120
        mov     x2,  #240
        mov     x3,  #180
        mov     x4,  #120
        movz    x5, 0x83, lsl 16
        movk    x5, 0x15c7, lsl 0
        bl      draw_rectangle


// ---------- 3) GPIO DEMO + BUCLE INFINITO -----------------------
        mov     x9,  GPIO_BASE
        str     wzr, [x9, GPIO_GPFSEL0]  // GPIO 0-9 como entrada
        ldr     w10, [x9, GPIO_GPLEV0]   // lee 32 bits
        and     w11, w10, 0b10
        lsr     w11, w11, 1

	// --------------- Infinite Loop ---------------


InfLoop:
        b       InfLoop
