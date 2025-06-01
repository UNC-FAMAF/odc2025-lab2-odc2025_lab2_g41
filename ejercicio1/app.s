	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.globl main
        .include "aliases.s"

        mov Xres, SCREEN_WIDTH
        mov Yres, SCREEN_HEIGH

draw_rectangle:
    stp     x30, x12, [sp, -16]!         // Guarda x30 (link register) y x12 en la pila (salvar contexto)

    mov     x7, x4                       // x7 ← alto (número de filas que tendrá el rectángulo)
    mov     x8, x3                       // x8 ← ancho original (no usado directamente luego)

.rectRow:                                // Comienza una nueva fila del rectángulo
    mov     x9, x2                       // x9 ← coordenada Y
    lsl     x9, x9, #9                   // x9 = Y * 512 (equivalente a Y << 9)
    mov     x12, x2                      // x12 ← Y
    lsl     x12, x12, #7                 // x12 = Y * 128 (equivalente a Y << 7)
    add     x9, x9, x12                  // x9 = Y*512 + Y*128 = Y*640 → offset en filas (stride = SCREEN_WIDTH)

    add     x9, x9, x1                   // x9 += X → offset horizontal
    lsl     x9, x9, #2                   // x9 *= 4 (porque cada píxel ocupa 4 bytes = 32 bits por píxel)
    add     x9, x9, x0                   // x9 = dirección absoluta dentro del framebuffer

    mov     x6, x3                       // x6 ← ancho (cuántos píxeles escribir en esta fila)

.rectPix:                                // Bucle interno: recorre columnas en una fila
    stur    w5, [x9]                     // Guarda el color (w5) en la dirección apuntada por x9
    add     x9, x9, #4                   // Avanza 4 bytes (siguiente píxel)
    sub     x6, x6, #1                   // ancho restante -= 1
    cbnz    x6, .rectPix                 // Si queda ancho por recorrer, continuar

    add     x2, x2, #1                   // Y += 1 (siguiente fila)
    sub     x7, x7, #1                   // alto restante -= 1
    cbnz    x7, .rectRow                 // Si quedan filas, repetir

    ldp     x30, x12, [sp], 16           // Restaura x30 y x12 desde la pila
    ret                                  // Vuelve al llamador




main:
        // x0 llega con la base del framebuffer
        mov     x20, x0                  // guarda FB base

// ---------- 1) PINTAR EL FONDO COMPLETO -------------------------
        movz    x10, 0x16, lsl 16
        movk    x10, 0x032F, lsl 0
        mov     x2,  SCREEN_HEIGH
bg_row: mov     x1,  SCREEN_WIDTH
bg_col: stur    w10, [x0]
        add     x0,  x0,  #4
        sub     x1,  x1,  #1
        cbnz    x1,  bg_col
        sub     x2,  x2,  #1
        cbnz    x2,  bg_row

// ---------- 2) DIBUJO DE FIGURAS --------------------------------
// -- MANGO DEL SABLE DE LUZ -----------------------------
        mov     x0,  x20                 // base FB
        mov     x1,  #50               // EJE X
        mov     x2,  #220               // EJE Y
        mov     x3,  #330                // ANCHO
        mov     x4,  #50                // ALTO
        movz    x5, 0x0c, lsl 16
        movk    x5, 0x3172, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle


//DETALLES MANGO
// EMISOR
        mov     x0,  x20                 // base FB
        mov     x1,  #375               // EJE X
        mov     x2,  #220               // EJE Y
        mov     x3,  #5                // ANCHO
        mov     x4,  #50                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #370               // EJE X
        mov     x2,  #223               // EJE Y
        mov     x3,  #5                // ANCHO
        mov     x4,  #45                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

// ALETITA
        mov     x0,  x20                 // base FB
        mov     x1,  #362               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #1                // ANCHO
        mov     x4,  #20                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #360               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #2                // ANCHO
        mov     x4,  #25                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #358               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #2                // ANCHO
        mov     x4,  #28                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #356               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #2                // ANCHO
        mov     x4,  #30                // ALTO
        movz    x5, 0x0c, lsl 16
        movk    x5, 0x3172, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #354               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #2                // ANCHO
        mov     x4,  #30                // ALTO
        movz    x5, 0x0c, lsl 16
        movk    x5, 0x3172, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #352               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #2                // ANCHO
        mov     x4,  #30                // ALTO
        movz    x5, 0x0c, lsl 16
        movk    x5, 0x3172, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #350               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #2                // ANCHO
        mov     x4,  #28                // ALTO
        movz    x5, 0x0c, lsl 16
        movk    x5, 0x3172, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #348               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #2                // ANCHO
        mov     x4,  #26                // ALTO
        movz    x5, 0x0c, lsl 16
        movk    x5, 0x3172, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #347               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #1               // ANCHO
        mov     x4,  #23                // ALTO
        movz    x5, 0x0c, lsl 16
        movk    x5, 0x3172, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #346               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #1               // ANCHO
        mov     x4,  #18                // ALTO
        movz    x5, 0x0c, lsl 16
        movk    x5, 0x3172, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #340               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #6               // ANCHO
        mov     x4,  #16                // ALTO
        movz    x5, 0x0c, lsl 16
        movk    x5, 0x3172, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #339               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #1               // ANCHO
        mov     x4,  #14                // ALTO
        movz    x5, 0x0c, lsl 16
        movk    x5, 0x3172, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #338               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #1               // ANCHO
        mov     x4,  #12                // ALTO
        movz    x5, 0x0c, lsl 16
        movk    x5, 0x3172, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #337               // EJE X
        mov     x2,  #270               // EJE Y
        mov     x3,  #1               // ANCHO
        mov     x4,  #10                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

//GRIP


        mov     x0,  x20                 // base FB
        mov     x1,  #50              // EJE X
        mov     x2,  #260               // EJE Y
        mov     x3,  #60               // ANCHO
        mov     x4,  #5                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #50               // EJE X
        mov     x2,  #243               // EJE Y
        mov     x3,  #80               // ANCHO
        mov     x4,  #5                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #50               // EJE X
        mov     x2,  #225               // EJE Y
        mov     x3,  #80               // ANCHO
        mov     x4,  #5                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #130               // EJE X
        mov     x2,  #226               // EJE Y
        mov     x3,  #4               // ANCHO
        mov     x4,  #3                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #130               // EJE X
        mov     x2,  #244               // EJE Y
        mov     x3,  #4               // ANCHO
        mov     x4,  #3                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #47               // EJE X
        mov     x2,  #221               // EJE Y
        mov     x3,  #3               // ANCHO
        mov     x4,  #48                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


// ODC ENGRAVING
//O
        mov     x0,  x20                 // base FB
        mov     x1,  #300               // EJE X
        mov     x2,  #225               // EJE Y
        mov     x3,  #3               // ANCHO
        mov     x4,  #13                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #310               // EJE X
        mov     x2,  #225               // EJE Y
        mov     x3,  #3               // ANCHO
        mov     x4,  #13                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #303               // EJE X
        mov     x2,  #223               // EJE Y
        mov     x3,  #7               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #303               // EJE X
        mov     x2,  #238               // EJE Y
        mov     x3,  #7               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


//D
        mov     x0,  x20                 // base FB
        mov     x1,  #315               // EJE X
        mov     x2,  #223               // EJE Y
        mov     x3,  #3               // ANCHO
        mov     x4,  #17                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #325               // EJE X
        mov     x2,  #225               // EJE Y
        mov     x3,  #3               // ANCHO
        mov     x4,  #13                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #318               // EJE X
        mov     x2,  #223               // EJE Y
        mov     x3,  #7               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #318               // EJE X
        mov     x2,  #238               // EJE Y
        mov     x3,  #7               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

//C
        mov     x0,  x20                 // base FB
        mov     x1,  #330               // EJE X
        mov     x2,  #225               // EJE Y
        mov     x3,  #3               // ANCHO
        mov     x4,  #13                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #333               // EJE X
        mov     x2,  #223               // EJE Y
        mov     x3,  #8               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #333               // EJE X
        mov     x2,  #238               // EJE Y
        mov     x3,  #8               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

//2

        mov     x0,  x20                 // base FB
        mov     x1,  #302               // EJE X
        mov     x2,  #262               // EJE Y
        mov     x3,  #6               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #302               // EJE X
        mov     x2,  #254               // EJE Y
        mov     x3,  #6               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #302               // EJE X
        mov     x2,  #246               // EJE Y
        mov     x3,  #6               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #308               // EJE X
        mov     x2,  #248               // EJE Y
        mov     x3,  #2               // ANCHO
        mov     x4,  #6                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #300               // EJE X
        mov     x2,  #256               // EJE Y
        mov     x3,  #2               // ANCHO
        mov     x4,  #6                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

//0
        mov     x0,  x20                 // base FB
        mov     x1,  #314               // EJE X
        mov     x2,  #246               // EJE Y
        mov     x3,  #6               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 00
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #314               // EJE X
        mov     x2,  #262               // EJE Y
        mov     x3,  #6               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #312               // EJE X
        mov     x2,  #248               // EJE Y
        mov     x3,  #2               // ANCHO
        mov     x4,  #14                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #320               // EJE X
        mov     x2,  #248               // EJE Y
        mov     x3,  #2               // ANCHO
        mov     x4,  #14                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

//2

        mov     x0,  x20                 // base FB
        mov     x1,  #326               // EJE X
        mov     x2,  #262               // EJE Y
        mov     x3,  #6               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #326               // EJE X
        mov     x2,  #254               // EJE Y
        mov     x3,  #6               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #326               // EJE X
        mov     x2,  #246               // EJE Y
        mov     x3,  #6               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #332               // EJE X
        mov     x2,  #248               // EJE Y
        mov     x3,  #2               // ANCHO
        mov     x4,  #6                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #324               // EJE X
        mov     x2,  #256               // EJE Y
        mov     x3,  #2               // ANCHO
        mov     x4,  #6                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

//5

        mov     x0,  x20                 // base FB
        mov     x1,  #338               // EJE X
        mov     x2,  #262               // EJE Y
        mov     x3,  #6               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #338               // EJE X
        mov     x2,  #254               // EJE Y
        mov     x3,  #6               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #338               // EJE X
        mov     x2,  #246               // EJE Y
        mov     x3,  #6               // ANCHO
        mov     x4,  #2                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #344               // EJE X
        mov     x2,  #256               // EJE Y
        mov     x3,  #2               // ANCHO
        mov     x4,  #6                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #336               // EJE X
        mov     x2,  #248               // EJE Y
        mov     x3,  #2               // ANCHO
        mov     x4,  #6                // ALTO
        movz    x5, 0x04, lsl 16
        movk    x5, 0x1839, lsl 0
        bl      draw_rectangle


// -- HAZ DEL SABLE DE LUZ -----------------------------
        mov     x0,  x20                 // base FB
        mov     x1,  #376               // EJE X
        mov     x2,  #232               // EJE Y
        mov     x3,  #264                // ANCHO
        mov     x4,  #25                // ALTO
        movz    x5, 0xAD, lsl 16
        movk    x5, 0xFFFF, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle

//DETALLES DEL HAZ

mov     x0,  x20                 // base FB
        mov     x1,  #376               // EJE X
        mov     x2,  #232               // EJE Y
        mov     x3,  #264                // ANCHO
        mov     x4,  #3                // ALTO
        movz    x5, 0x78, lsl 16
        movk    x5, 0xc6fa, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle


mov     x0,  x20                 // base FB
        mov     x1,  #376               // EJE X
        mov     x2,  #234               // EJE Y
        mov     x3,  #264                // ANCHO
        mov     x4,  #3                // ALTO
        movz    x5, 0x98, lsl 16
        movk    x5, 0xd3fa, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle


mov     x0,  x20                 // base FB
        mov     x1,  #376               // EJE X
        mov     x2,  #249               // EJE Y
        mov     x3,  #264                // ANCHO
        mov     x4,  #3                // ALTO
        movz    x5, 0xFF, lsl 16
        movk    x5, 0xFFFF, lsl 0       // x5 = 0000 0000 0083 15c7
        bl      draw_rectangle



// BRAZO
// LOOP1 -------------------------------------------------------------------------------------
        mov     x20, x0            // framebuffer base
        mov     x21, #10            // contador (10 rectángulos)
        mov     x22, #0          // X inicial
        mov     x23, #300          // Y fijo
        mov     x24, #6           // ancho
        mov     x25, #90           // alto

    rectLoop1:
        mov     x0, x20            // framebuffer
        mov     x1, x22            // X
        mov     x2, x23            // Y
        mov     x3, x24            // ancho
        mov     x4, x25            // alto
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        add     x22, x22, x24      // X += ancho → siguiente rectángulo a la derecha
        sub     x23, x23, #2
        subs    x21, x21, #1       // contador--
        cbnz    x21, rectLoop1

// LOOP2 -------------------------------------------------------------------------------------
        mov     x20, x0            // framebuffer base
        mov     x21, #10            // contador (10 rectángulos)
        mov     x22, #60          // X inicial
        mov     x23, #280          // Y fijo
        mov     x24, #6           // ancho
        mov     x25, #90           // alto

    rectLoop2:
        mov     x0, x20            // framebuffer
        mov     x1, x22            // X
        mov     x2, x23            // Y
        mov     x3, x24            // ancho
        mov     x4, x25            // alto
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        add     x22, x22, x24      // X += ancho → siguiente rectángulo a la derecha
        sub     x23, x23, #3
        subs    x21, x21, #1       // contador--
        cbnz    x21, rectLoop2


// LOOP3 -------------------------------------------------------------------------------------
        mov     x20, x0            // framebuffer base
        mov     x21, #10            // contador (10 rectángulos)
        mov     x22, #120          // X inicial
        mov     x23, #250          // Y fijo
        mov     x24, #6           // ancho
        mov     x25, #90           // alto

    rectLoop3:
        mov     x0, x20            // framebuffer
        mov     x1, x22            // X
        mov     x2, x23            // Y
        mov     x3, x24            // ancho
        mov     x4, x25            // alto
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        add     x22, x22, x24      // X += ancho → siguiente rectángulo a la derecha
        sub     x23, x23, #4
        subs    x21, x21, #1       // contador--
        cbnz    x21, rectLoop3





//HAND -------------------------------------------------------------
//DEDO GORDO
        mov     x0,  x20                 // base FB
        mov     x1,  #260               // EJE X
        mov     x2,  #190             // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #82                // ALTO
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #266               // EJE X
        mov     x2,  #190             // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #82                // ALTO
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #272               // EJE X
        mov     x2,  #190             // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #82                // ALTO
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #278               // EJE X
        mov     x2,  #190             // EJE Y
        mov     x3,  #3              // ANCHO
        mov     x4,  #82                // ALTO
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #281               // EJE X
        mov     x2,  #192             // EJE Y
        mov     x3,  #3              // ANCHO
        mov     x4,  #28                // ALTO
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #283               // EJE X
        mov     x2,  #194             // EJE Y
        mov     x3,  #3              // ANCHO
        mov     x4,  #28                // ALTO
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #286               // EJE X
        mov     x2,  #196             // EJE Y
        mov     x3,  #3              // ANCHO
        mov     x4,  #24                // ALTO
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #289               // EJE X
        mov     x2,  #198             // EJE Y
        mov     x3,  #3              // ANCHO
        mov     x4,  #22                // ALTO
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #292               // EJE X
        mov     x2,  #200             // EJE Y
        mov     x3,  #3              // ANCHO
        mov     x4,  #20                // ALTO
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #295               // EJE X
        mov     x2,  #204             // EJE Y
        mov     x3,  #2              // ANCHO
        mov     x4,  #16                // ALTO
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle



// OTROS DEDOS
        mov     x0,  x20                 // base FB
        mov     x1,  #162              // EJE X
        mov     x2,  #216              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #90                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #168              // EJE X
        mov     x2,  #210              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #98                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #174              // EJE X
        mov     x2,  #206              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #102                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #180              // EJE X
        mov     x2,  #202              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #106                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #186              // EJE X
        mov     x2,  #198              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #110                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #192               // EJE X
        mov     x2,  #192             // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #114                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #198               // EJE X
        mov     x2,  #188              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #118                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #204               // EJE X
        mov     x2,  #184              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #122                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #210               // EJE X
        mov     x2,  #182              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #124                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #216               // EJE X
        mov     x2,  #180              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #124                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #222               // EJE X
        mov     x2,  #180              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #124                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #228               // EJE X
        mov     x2,  #180             // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #124                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #234               // EJE X
        mov     x2,  #180              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #122                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #240               // EJE X
        mov     x2,  #182              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #120                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #246               // EJE X
        mov     x2,  #184              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #118                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #252               // EJE X
        mov     x2,  #186              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #114                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #258               // EJE X
        mov     x2,  #188              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #110                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #264               // EJE X
        mov     x2,  #192              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #104                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #264               // EJE X
        mov     x2,  #194              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #102                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #270               // EJE X
        mov     x2,  #194              // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #100                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #276               // EJE X
        mov     x2,  #200             // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #90                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle


        mov     x0,  x20                 // base FB
        mov     x1,  #282               // EJE X
        mov     x2,  #204             // EJE Y
        mov     x3,  #6              // ANCHO
        mov     x4,  #82                // ALTO
        movz    x5,  #0,     lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle


// DETALLES DE MANOS

// NUDILLO1 -------------------------------------------------------------------------------------
        mov     x20, x0            // framebuffer base
        mov     x21, #14            // contador (10 rectángulos)
        mov     x22, #286          // X inicial
        mov     x23, #240          // Y fijo
        mov     x24, #2           // ancho
        mov     x25, #4           // alto

    nudillo1:
        mov     x0, x20            // framebuffer
        mov     x1, x22            // X
        mov     x2, x23            // Y
        mov     x3, x24            // ancho
        mov     x4, x25            // alto
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle

        sub     x22, x22, x24      // X += ancho → siguiente rectángulo a la derecha
        sub     x23, x23, #2
        subs    x21, x21, #1       // contador--
        cbnz    x21, nudillo1


// NUDILLO2 -------------------------------------------------------------------------------------
        mov     x20, x0            // framebuffer base
        mov     x21, #12            // contador (10 rectángulos)
        mov     x22, #286          // X inicial
        mov     x23, #270          // Y fijo
        mov     x24, #2           // ancho
        mov     x25, #4           // alto

    nudillo2:
        mov     x0, x20            // framebuffer
        mov     x1, x22            // X
        mov     x2, x23            // Y
        mov     x3, x24            // ancho
        mov     x4, x25            // alto
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle

        sub     x22, x22, x24      // X += ancho → siguiente rectángulo a la derecha
        sub     x23, x23, #2
        subs    x21, x21, #1       // contador--
        cbnz    x21, nudillo2


// NUDILLO3 -------------------------------------------------------------------------------------
        mov     x20, x0            // framebuffer base
        mov     x21, #8            // contador (10 rectángulos)
        mov     x22, #274          // X inicial
        mov     x23, #290          // Y fijo
        mov     x24, #2           // ancho
        mov     x25, #4           // alto

    nudillo3:
        mov     x0, x20            // framebuffer
        mov     x1, x22            // X
        mov     x2, x23            // Y
        mov     x3, x24            // ancho
        mov     x4, x25            // alto
        movz    x5,  #0x01,     lsl 16
        movk    x5,  #0x2e54, lsl 0
        bl      draw_rectangle

        sub     x22, x22, x24      // X += ancho → siguiente rectángulo a la derecha
        sub     x23, x23, #2
        subs    x21, x21, #1       // contador--
        cbnz    x21, nudillo3


// ---------- 3) GPIO DEMO + BUCLE INFINITO -----------------------
        mov     x9,  GPIO_BASE
        str     wzr, [x9, GPIO_GPFSEL0]  // GPIO 0-9 como entrada
        ldr     w10, [x9, GPIO_GPLEV0]   // lee 32 bits
        and     w11, w10, 0b10
        lsr     w11, w11, 1

	// --------------- Infinite Loop ---------------


InfLoop:
        b       InfLoop
