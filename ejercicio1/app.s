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


    .equ SCREEN_WIDTH,  640       // ancho de pantalla en píxeles
    .equ SCREEN_HEIGHT, 480       // alto de pantalla (por si lo llegas a necesitar)
    .equ BPP,           32        // bits por píxel (4 bytes por píxel)


draw_line:
    // 1) Salvar link register
    stp     x30, xzr, [sp, #-16]!   // guardo x30 (LR)

    // 2) Calcular dx, dy
    sub     x6, x3, x1
    sub     x7, x4, x2

    // 3) abs_dx = |dx| → en x8
    mov     x8, x6              // copiar
    cmp     x8, #0
    cneg    x8, x8, MI          // si x8<0, x8 = -x8

    // 4) abs_dy = |dy| → en x9
    mov     x9, x7
    cmp     x9, #0
    cneg    x9, x9, MI          // si x9<0, x9 = -x9

    // 5) sx = sign(dx) → +1 ó -1
    mov     x10, #1             // por defecto +1
    mov     x13, #-1            // usar x13 como -1
    cmp     x6, #0
    csel    x10, x10, x13, GE   // si dx >= 0   sx := +1 ; si dx < 0  sx := -1

    // 6) sy = sign(dy) → +1 ó -1
    mov     x11, #1             // por defecto +1
    mov     x13, #-1            // x13 = -1
    cmp     x7, #0
    csel    x11, x11, x13, GE   // si dy >= 0   sy := +1 ; si dy < 0  sy := -1

    // 7) Decidir si es X‐dominante o Y‐dominante
    cmp     x8, x9
    b.lt    .loop_ydominant     // si |dx| < |dy|, ir a la versión Y‐dominante

    // ────────────────────────────────────────────────────────────────────────
    //  A) CASO “X‐dominante”: abs_dx ≥ abs_dy
    //    Para cada i = 0 .. abs_dx:
    //      x = x₁ + (i · sx)
    //      y = y₁ + ⎣(dy · i) / abs_dx⎦
    //
    mov     x12, #0             // i = 0
.xloop:
    // --- calcular x = x₁ + (i·sx) sin multiplicar
    mov     x13, x12            // x13 ← i
    cmp     x10, #0             // ¿sx < 0?
    cneg    x13, x13, MI        //   si sx <0, x13 = -i; si sx≥0 queda i
    add     x14, x1, x13        // x14 ← x₁ + (i·sx)

    // --- calcular y = y₁ + (dy * i) / abs_dx
    mul     x15, x7, x12        // x15 ← dy * i
    sdiv    x15, x15, x8        // x15 ← (dy * i) / abs_dx (división entera, floored)
    add     x15, x15, x2        // x15 ← y₁ + … = valor de y

    // --- dibujar pixel en (x14, x15)
    //     offset_bytes = (((y * SCREEN_WIDTH) + x) * 4)
    //     SCREEN_WIDTH = 640 = (1<<9) + (1<<7)
    mov     x16, x15            // x16 = y
    lsl     x16, x16, #9        // x16 = y*512
    mov     x17, x15            // x17 = y
    lsl     x17, x17, #7        // x17 = y*128
    add     x16, x16, x17       // x16 = y*640
    add     x16, x16, x14       // x16 = y*640 + x
    lsl     x16, x16, #2        // x16 = (y*640 + x) * 4 bytes
    add     x16, x16, x0        // x16 = dirección en el framebuffer
    stur    w5, [x16]           // escribo el color en w5

    // --- incrementar i y ver si ya terminé
    add     x12, x12, #1        // i++
    cmp     x12, x8             // comparar i con abs_dx
    ble     .xloop              // mientras i ≤ abs_dx, repetir

    b       .line_done          // si i > abs_dx, termino

    // ────────────────────────────────────────────────────────────────────────
.loop_ydominant:
    // B) CASO “Y‐dominante”: abs_dx < abs_dy
    //   Para cada i = 0 .. abs_dy:
    //     y = y₁ + (i·sy)
    //     x = x₁ + ⎣(dx · i) / abs_dy⎦
    //
    mov     x12, #0             // i = 0
.yloop:
    // --- calcular y = y₁ + (i·sy)
    mov     x13, x12            // x13 ← i
    cmp     x11, #0             // ¿sy < 0?
    cneg    x13, x13, MI        //   si sy <0, x13 = -i; si sy≥0 queda i
    add     x15, x2, x13        // x15 ← y₁ + (i·sy)

    // --- calcular x = x₁ + ⎣(dx * i) / abs_dy⎦
    mul     x14, x6, x12        // x14 ← dx * i
    sdiv    x14, x14, x9        // x14 ← (dx * i) / abs_dy
    add     x14, x14, x1        // x14 ← x₁ + … = valor de x

    // --- dibujar pixel en (x14, x15)
    mov     x16, x15            // y a x16
    lsl     x16, x16, #9        // x16 = y*512
    mov     x17, x15            // x17 = y
    lsl     x17, x17, #7        // x17 = y*128
    add     x16, x16, x17       // x16 = y*640
    add     x16, x16, x14       // x16 = y*640 + x
    lsl     x16, x16, #2        // x16 = (y*640 + x)*4
    add     x16, x16, x0        // x16 = dirección absoluta
    stur    w5, [x16]           // escribo el color

    // --- incrementar i y ver si ya terminé
    add     x12, x12, #1        // i++
    cmp     x12, x9             // comparar i con abs_dy
    ble     .yloop              // mientras i ≤ abs_dy, repetir

    // caigo aquí cuando i > abs_dy
.line_done:
    // Restaurar LR y retornar
    ldp     x30, xzr, [sp], #16
    ret


draw_triangle:
    // 1) Salvar LR (x30) en pila
    stp     x30, xzr, [sp, #-16]!       // guardo x30; xzr es dummy para alinear

    // 2) Guardar (p1_x, p1_y) en registros temporales (x8, x9)
    mov     x8, x1      // x8 ← p1_x
    mov     x9, x2      // x9 ← p1_y

    // ------- 3) Dibujar arista entre p1 (x1,y1) y p2 (x3,y4) -------
    //    Parámetros ya en:
    //      x0 = framebuffer, x1 = p1_x, x2 = p1_y, x3 = p2_x, x4 = p2_y
    //    Sólo hay que copiar color (en x7) → x5
    mov     x5, x7      // x5 ← color
    bl      draw_line

    // ------- 4) Dibujar arista entre p2 (x3,y2) y p3 (x5,y3) -------
    //    Ajustar registros para llamada:
    //      x1 ← p2_x (ya estaba en x3), x2 ← p2_y (ya en x4)
    //      x3 ← p3_x (viene en x5),   x4 ← p3_y (viene en x6)
    mov     x1, x3      // x1 = p2_x
    mov     x2, x4      // x2 = p2_y
    mov     x3, x5      // x3 = p3_x
    mov     x4, x6      // x4 = p3_y
    mov     x5, x7      // x5 ← color
    bl      draw_line

    // ------- 5) Dibujar arista entre p3 (x3,y3) y p1 (x8,x9) -------
    //    Ahora, p3 está en (x3,x4); p1 la recuperamos de (x8,x9).
    mov     x1, x3      // x1 = p3_x
    mov     x2, x4      // x2 = p3_y
    mov     x3, x8      // x3 = p1_x (guardado)
    mov     x4, x9      // x4 = p1_y (guardado)
    mov     x5, x7      // x5 ← color
    bl      draw_line

    // 6) Restaurar LR y retornar
    ldp     x30, xzr, [sp], #16
    ret

// ESTRELLAS -------------------------------------------------------------------------------------
// Funci�n para dibujar una estrella (cruz)
// Par�metros:
// x1: coordenada X del centro
// x2: coordenada Y del centro
star:
    stp     x30, x12, [sp, -16]!         // Guarda x30 (link register) y x12 en la pila (salvar contexto)
    // Parte central
    mov     x3, #5                       // Ancho
    mov     x4, #5                       // Alto
    movz    x5, 0x3B, lsl 16             // Color del centro #3b8fae
    movk    x5, 0x8FAE, lsl 0
    bl      draw_rectangle

    // Parte superior e inferior
    sub     x2, x2, #10                    // Subir del centro (5*2)
    movz    x5, 0x14, lsl 16		  // Color de alrededor #14366d
    movk    x5, 0x366D, lsl 0
    bl      draw_rectangle
    add     x2, x2, #5                    // Bajar del centro
    bl      draw_rectangle
    sub     x2, x2, #10                   // Restaurar Y (5*2)

    // Parte derecha e izquierda
    add     x1, x1, #5                    // Derecha del centro
    bl      draw_rectangle
    sub     x1, x1, #10                   // Izquierda del centro (5*2)
    sub	    x2, x2, #5		          // No se por que hace este offset
    bl      draw_rectangle

    ldp x30, x12, [sp], 16
    ret

// TRANSITION -------------------------------------------------------------------------------------
// Funci�n para dibujar la transici�n del background
// Par�metros:
// x0: base del framebuffer (debe estar cargado antes de llamar)
// x2: posici�n Y inicial (l�nea donde comienza la transici�n)
// x5: color a usar para la transici�n
// x6: hasta donde llegar en los line
draw_transition:
        stp     x30, x12, [sp, -32]!

        mov     x12, x6                      // x12 = largo del loop
        mov     x13, x1                      // Guardar donde inicializar X
        mov     x3, #6                       // Ancho en X
        mov     x14, x13                     // x14 "counter"
        mov     x15, x2                      // Desde donde el alto

firstLine:
        mov     x1, x14                      // Posici�n de X actual
        mov     x2, x15                      // L�nea Y
        mov     x4, #1                       // Alto
        bl      draw_rectangle               // Dibujar bloque

        add     x14, x14, #12                // Avanzar p�xeles: pintados + sin pintar
        cmp     x14, SCREEN_WIDTH
        b.lt    firstLine                    // Seguir si no se pas� del ancho

        subs    x12, x12, #1                 // Lineas restantes
        b.eq    endTransition                // Si ya no quedan lineas, salir

        mov     x3, #5
        mov     x14, x13
        sub     x15, x15, #1

secondLine:
        mov     x1, x14
        mov     x2, x15
        mov     x4, #2
        bl      draw_rectangle

        add     x14, x14, #10 
        cmp     x14, SCREEN_WIDTH
        b.lt    secondLine

        subs    x12, x12, #1                 // Lineas restantes
        b.eq    endTransition                // Si ya no quedan lineas, salir

        mov     x3, #4
        mov     x14, x13
        sub     x15, x15, #2

thirdLine:
        mov     x1, x14
        mov     x2, x15
        mov     x4, #2
        bl      draw_rectangle

        add     x14, x14, #8 
        cmp     x14, SCREEN_WIDTH
        b.lt    thirdLine

        subs    x12, x12, #1                 // Lineas restantes
        b.eq    endTransition                // Si ya no quedan lineas, salir

        mov     x3, #3
        mov     x14, x13
        sub     x15, x15, #2

fourthLine:
        mov     x1, x14
        mov     x2, x15 
        mov     x4, #2
        bl      draw_rectangle

        add     x14, x14, #6 
        cmp     x14, SCREEN_WIDTH
        b.lt    fourthLine

        subs    x12, x12, #1                 // Lineas restantes
        b.eq    endTransition                // Si ya no quedan lineas, salir

        mov     x3, #2
        mov     x14, x13
        sub     x15, x15, #2

fifthLine:
        mov     x1, x14
        mov     x2, x15 
        mov     x4, #3
        bl      draw_rectangle

        add     x14, x14, #4 
        cmp     x14, SCREEN_WIDTH
        b.lt    fifthLine

        subs    x12, x12, #1                 // Lineas restantes
        b.eq    endTransition                // Si ya no quedan lineas, salir

        mov     x3, #1
        mov     x14, x13
        sub     x15, x15, #3

sixthLine:
        mov     x1, x14
        mov     x2, x15
        mov     x4, #3
        bl      draw_rectangle

        add     x14, x14, #2 
        cmp     x14, SCREEN_WIDTH
        b.lt    sixthLine

endTransition:

        ldp     x30, x12, [sp], 32
        ret


// TRANSITION INVERSED --------------------------------------------------------------------------
// Funci�n para dibujar la transici�n del background
// Par�metros:
// x0: base del framebuffer (debe estar cargado antes de llamar)
// x2: posici�n Y inicial (l�nea donde comienza la transici�n)
// x5: color a usar para la transici�n
// x6: hasta donde llegar en los line
draw_transition_inverse:
        stp     x30, x12, [sp, -32]!

        mov     x12, x6                      // x12 = largo del loop
        mov     x13, x1                      // Guardar donde inicializar X
        mov     x3, #6                       // Ancho en X
        mov     x14, x1                      // x14 "counter"
        mov     x15, x2                      // Desde donde el alto

firstLineInv:
        mov     x1, x14                      // Posici�n de X actual
        mov     x2, x15                      // L�nea Y
        mov     x4, #3                       // Alto
        bl      draw_rectangle               // Dibujar bloque

        add     x14, x14, #12                // Avanzar p�xeles: pintados + sin pintar
        cmp     x14, SCREEN_WIDTH
        b.lt    firstLineInv                 // Seguir si no se pas� del ancho

        sub    x12, x12, #1                  // Lineas restantes
        cbz    x12, endTransitionInv         // Si ya no quedan lineas, salir

        mov     x3, #5
        mov     x14, x13
        add     x15, x15, #3

secondLineInv:
        mov     x1, x14
        mov     x2, x15
        mov     x4, #2
        bl      draw_rectangle

        add     x14, x14, #4
        cmp     x14, SCREEN_WIDTH
        b.lt    secondLineInv

        sub    x12, x12, #1                  // Lineas restantes
        cbz    x12, endTransitionInv         // Si ya no quedan lineas, salir

        mov     x3, #4
        mov     x14, x13
        add     x15, x15, #2

thirdLineInv:
        mov     x1, x14
        mov     x2, x15
        mov     x4, #2
        bl      draw_rectangle

        add     x14, x14, #8 
        cmp     x14, SCREEN_WIDTH
        b.lt    thirdLineInv

        sub    x12, x12, #1                  // Lineas restantes
        cbz    x12, endTransitionInv         // Si ya no quedan lineas, salir

        mov     x3, #3
        mov     x14, x13
        add     x15, x15, #2

fourthLineInv:
        mov     x1, x14
        mov     x2, x15 
        mov     x4, #2
        bl      draw_rectangle

        add     x14, x14, #6 
        cmp     x14, SCREEN_WIDTH
        b.lt    fourthLineInv

        sub    x12, x12, #1                  // Lineas restantes
        cbz    x12, endTransitionInv         // Si ya no quedan lineas, salir

        mov     x3, #2
        mov     x14, x13
        add     x15, x15, #2

fifthLineInv:
        mov     x1, x14
        mov     x2, x15 
        mov     x4, #1
        bl      draw_rectangle

        add     x14, x14, #4
        cmp     x14, SCREEN_WIDTH
        b.lt    fifthLineInv

        sub    x12, x12, #1                  // Lineas restantes
        cbz    x12, endTransitionInv         // Si ya no quedan lineas, salir

        mov     x3, #1
        mov     x14, x13
        add     x15, x15, #1

sixthLineInv:
        mov     x1, x14
        mov     x2, x15
        mov     x4, #3
        bl      draw_rectangle

        add     x14, x14, #2 
        cmp     x14, SCREEN_WIDTH
        b.lt    sixthLineInv

endTransitionInv:

        ldp     x30, x12, [sp], 32
        ret

main:
        // x0 llega con la base del framebuffer
        mov     x20, x0                  // guarda FB base

// ---------- 1) PINTAR EL FONDO COMPLETO -------------------------
        mov     x0,  x20                 // base FB
        mov     x1,  #0                  // EJE X
        mov     x2,  #0                  // EJE Y
        mov     x3,  SCREEN_WIDTH        // ANCHO
        mov     x4,  SCREEN_HEIGH / 4    // ALTO
        set_color x5, 0x16, 0x042F      //#16042F
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #0                  // EJE X
        mov     x2,  SCREEN_HEIGH / 4    // EJE Y
        mov     x3,  SCREEN_WIDTH        // ANCHO
        mov     x4,  SCREEN_HEIGH / 4    // ALTO
        set_color x5, 0x1A, 0x0633      //#1A0633
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #0                  // EJE X
        mov     x2,  SCREEN_HEIGH / 2    // EJE Y
        mov     x3,  SCREEN_WIDTH        // ANCHO
        mov     x4,  SCREEN_HEIGH / 4    // ALTO
        set_color x5, 0x1E, 0x0837      //#1E0837
        bl      draw_rectangle

        mov     x0,  x20                 // base FB
        mov     x1,  #0                  // EJE X
        mov     x2,  SCREEN_HEIGH *3 /4  // EJE Y
        mov     x3,  SCREEN_WIDTH        // ANCHO
        mov     x4,  SCREEN_HEIGH / 4    // ALTO
        set_color x5, 0x22, 0x0A3B      //#220A3B
        bl      draw_rectangle

        // TRANSICIONES ENTRE COLORES
        // 1ER TRANSICION
        mov     x0,  x20                  // base FB
        add     x1, xzr, xzr             // EJE X = 0
        mov     x2, SCREEN_HEIGH / 4
        set_color x5, 0x1A, 0x0633        //#1A0633
        mov     x6,  #6                   // Largo del loop
        bl      draw_transition           // Call function

        mov     x0,  x20                  // base FB
        add     x1, xzr, xzr             // EJE X = 0
        mov     x2, SCREEN_HEIGH / 4 + 5
        set_color x5, 0x1A, 0x0633        //#1A0633
        mov     x6,  #6                   // Largo del loop
        bl      draw_transition           // Call function

        // 2DA TRANSICION
        mov     x0,  x20                  // base FB
        add     x1, xzr, xzr             // EJE X = 0
        mov     x2, SCREEN_HEIGH / 2
        set_color x5, 0x1E, 0x0837        //#1E0837
        mov     x6,  #6                   // Largo del loop
        bl      draw_transition           // Call function

        mov     x0,  x20                  // base FB
        add     x1, xzr, xzr             // EJE X = 0
        mov     x2, SCREEN_HEIGH / 2 + 5
        set_color x5, 0x1E, 0x0837        //#1E0837
        mov     x6,  #6                   // Largo del loop
        bl      draw_transition           // Call function

        // 3RA TRANSICION
        mov     x0,  x20                  // base FB
        add     x1, xzr, xzr             // EJE X = 0
        mov     x2, SCREEN_HEIGH * 3 / 4
        set_color x5, 0x22, 0x0A3B        //#220A3B
        mov     x6,  #6                   // Largo del loop
        bl      draw_transition           // Call function
        
        mov     x0,  x20                  // base FB
        add     x1, xzr, xzr             // EJE X = 0
        mov     x2, SCREEN_HEIGH * 3 / 4 + 5
        set_color x5, 0x22, 0x0A3B        //#220A3B
        mov     x6,  #6                   // Largo del loop
        bl      draw_transition           // Call function

// ---------- 2) DETALLES DEL FONDO -------------------------------
        // CALLING FUNCTION STAR (X1, X2 -> X center, Y center)
	mov     x0, x20
	mov     x1, #20
	mov     x2, #100
	bl star

	mov     x0, x20
	mov     x1, #70
	mov     x2, #400
	bl star

	mov     x0, x20
	mov     x1, #100
	mov     x2, #150
	bl star

	mov     x0, x20
	mov     x1, #125
	mov     x2, #50
	bl star

	mov     x0, x20
	mov     x1, #175
	mov     x2, #440
	bl star

	mov     x0, x20
	mov     x1, #250
	mov     x2, #350
	bl star

	mov     x0, x20
	mov     x1, #300
	mov     x2, #125
	bl star

	mov     x0, x20
	mov     x1, #360
	mov     x2, #320
	bl star

	mov     x0, x20
	mov     x1, #370
	mov     x2, #180
	bl star

	mov     x0, x20
	mov     x1, #390
	mov     x2, #20
	bl star

	mov     x0, x20
	mov     x1, #400
	mov     x2, #415
	bl star

	mov     x0, x20
	mov     x1, #500
	mov     x2, #120
	bl star

	mov     x0, x20
	mov     x1, #500
	mov     x2, #375
	bl star

	mov     x0, x20
	mov     x1, #570
	mov     x2, #200
	bl star

	mov     x0, x20
	mov     x1, #590
	mov     x2, #345
	bl star

	mov     x0, x20
	mov     x1, #600
	mov     x2, #50
	bl star

	mov     x0, x20
	mov     x1, #610
	mov     x2, #460
	bl star

// ---------- 3) DIBUJO DE FIGURAS --------------------------------
// -- MANGO DEL SABLE DE LUZ -----------------------------
        mov     x0,  x20                 // base FB
        mov     x1,  #50                // EJE X
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

// GLOW DEL SABLE ----------------------------------------------------------------------------
        // Glow superior
        mov     x0,  x20                 // base FB
        mov     x1,  #376               // EJE X
        mov     x2,  #231               // EJE Y
        mov     x6,  #5                 // Largo del loop
        set_color    x5, 0x78, 0xc6fa
        bl      draw_transition

        mov     x0,  x20                 // base FB
        mov     x1,  #379               // EJE X
        mov     x2,  #228               // EJE Y
        mov     x6,  #3                 // Largo del loop
        set_color    x5, 0x78, 0xc6fa
        bl      draw_transition

        // Glow inferior
        mov     x0,  x20                 // base FB
        mov     x1,  #376               // EJE X
        mov     x2,  #255               // EJE Y
        mov     x6,  #5                 // Largo del loop
        set_color    x5, 0xad, 0xffff
        bl      draw_transition_inverse

        mov     x0,  x20                 // base FB
        mov     x1,  #376               // EJE X
        mov     x2,  #258               // EJE Y
        mov     x6,  #3                 // Largo del loop
        set_color    x5, 0xad, 0xffff
        bl      draw_transition_inverse

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
        mov     x24, #2            // ancho
        mov     x25, #4            // alto

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


// ---------- 4) GPIO DEMO + BUCLE INFINITO -----------------------
        //mov     x9,  GPIO_BASE
        //str     wzr, [x9, GPIO_GPFSEL0]  // GPIO 0-9 como entrada
        //ldr     w10, [x9, GPIO_GPLEV0]   // lee 32 bits
        //and     w11, w10, 0b10
        //lsr     w11, w11, 1

	// --------------- Infinite Loop ---------------


InfLoop:
        b       InfLoop
