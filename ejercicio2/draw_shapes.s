.include "aliases.s"

    .globl  draw_rectangle
    .globl  draw_line
    .globl  draw_triangle
    .globl  star
    .globl  draw_transition
    .globl  draw_transition_inverse

draw_rectangle:
    stp     x30, x12, [sp, -16]!         // Guarda x30 (link register) y x12 en la pila (salvar contexto)

    mov     x7, alto                       // x7 ← alto (número de filas que tendrá el rectángulo)
    mov     x8, ancho                       // x8 ← ancho original (no usado directamente luego)

.rectRow:                                // Comienza una nueva fila del rectángulo
    mov     x9, posY                       // x9 ← coordenada Y
    lsl     x9, x9, #9                   // x9 = Y * 512 (equivalente a Y << 9)
    mov     x12, posY                      // x12 ← Y
    lsl     x12, x12, #7                 // x12 = Y * 128 (equivalente a Y << 7)
    add     x9, x9, x12                  // x9 = Y*512 + Y*128 = Y*640 → offset en filas (stride = SCREEN_WIDTH)

    add     x9, x9, posX                   // x9 += X → offset horizontal
    lsl     x9, x9, #2                   // x9 *= 4 (porque cada píxel ocupa 4 bytes = 32 bits por píxel)
    add     x9, x9, framebuffer                   // x9 = dirección absoluta dentro del framebuffer

    mov     x6, ancho                       // x6 ← ancho (cuántos píxeles escribir en esta fila)

.rectPix:                                // Bucle interno: recorre columnas en una fila
    stur    w5, [x9]                     // Guarda el color (w5) en la dirección apuntada por x9
    add     x9, x9, #4                   // Avanza 4 bytes (siguiente píxel)
    sub     x6, x6, #1                   // ancho restante -= 1
    cbnz    x6, .rectPix                 // Si queda ancho por recorrer, continuar

    add     posY, posY, #1                   // Y += 1 (siguiente fila)
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
    sub     x6, ancho, posX
    sub     x7, alto, posY

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
    add     x14, posX, x13        // x14 ← x₁ + (i·sx)

    // --- calcular y = y₁ + (dy * i) / abs_dx
    mul     x15, x7, x12        // x15 ← dy * i
    sdiv    x15, x15, x8        // x15 ← (dy * i) / abs_dx (división entera, floored)
    add     x15, x15, posY        // x15 ← y₁ + … = valor de y

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
    add     x16, x16, framebuffer        // x16 = dirección en el framebuffer
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
    add     x15, posY, x13        // x15 ← y₁ + (i·sy)

    // --- calcular x = x₁ + ⎣(dx * i) / abs_dy⎦
    mul     x14, x6, x12        // x14 ← dx * i
    sdiv    x14, x14, x9        // x14 ← (dx * i) / abs_dy
    add     x14, x14, posX        // x14 ← x₁ + … = valor de x

    // --- dibujar pixel en (x14, x15)
    mov     x16, x15            // y a x16
    lsl     x16, x16, #9        // x16 = y*512
    mov     x17, x15            // x17 = y
    lsl     x17, x17, #7        // x17 = y*128
    add     x16, x16, x17       // x16 = y*640
    add     x16, x16, x14       // x16 = y*640 + x
    lsl     x16, x16, #2        // x16 = (y*640 + x)*4
    add     x16, x16, framebuffer        // x16 = dirección absoluta
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
    mov     x8, posX      // x8 ← p1_x
    mov     x9, posY      // x9 ← p1_y

    // ------- 3) Dibujar arista entre p1 (posX,y1) y p2 (ancho,y4) -------
    //    Parámetros ya en:
    //      framebuffer = framebuffer, posX = p1_x, posY = p1_y, ancho = p2_x, alto = p2_y
    //    Sólo hay que copiar color (en x7) → color
    mov     color, x7      // color ← color
    bl      draw_line

    // ------- 4) Dibujar arista entre p2 (ancho,y2) y p3 (color,y3) -------
    //    Ajustar registros para llamada:
    //      posX ← p2_x (ya estaba en ancho), posY ← p2_y (ya en alto)
    //      ancho ← p3_x (viene en color),   alto ← p3_y (viene en x6)
    mov     posX, ancho      // posX = p2_x
    mov     posY, alto      // posY = p2_y
    mov     ancho, color      // ancho = p3_x
    mov     alto, x6      // alto = p3_y
    mov     color, x7      // color ← color
    bl      draw_line

    // ------- 5) Dibujar arista entre p3 (ancho,y3) y p1 (x8,x9) -------
    //    Ahora, p3 está en (ancho,alto); p1 la recuperamos de (x8,x9).
    mov     posX, ancho      // posX = p3_x
    mov     posY, alto      // posY = p3_y
    mov     ancho, x8      // ancho = p1_x (guardado)
    mov     alto, x9      // alto = p1_y (guardado)
    mov     color, x7      // color ← color
    bl      draw_line

    // 6) Restaurar LR y retornar
    ldp     x30, xzr, [sp], #16
    ret

// ESTRELLAS -------------------------------------------------------------------------------------
// Funci�n para dibujar una estrella (cruz)
// Par�metros:
// posX: coordenada X del centro
// posY: coordenada Y del centro
star:
    stp     x30, x12, [sp, -16]!         // Guarda x30 (link register) y x12 en la pila (salvar contexto)
    // Parte central
    mov     ancho, #5                       // Ancho
    mov     alto, #5                       // Alto
    set_color color, 0x3B, 0x8FAE           // Color del centro #3B8FAE
    bl      draw_rectangle

    // Parte superior e inferior
    sub     posY, posY, #10                   // Subir del centro (5*2)
    set_color color, 0x14, 0x366D            // Color de alrededor #14366D
    bl      draw_rectangle
    add     posY, posY, #5                    // Bajar del centro
    bl      draw_rectangle
    sub     posY, posY, #10                   // Restaurar Y (5*2)

    // Parte derecha e izquierda
    add     posX, posX, #5                    // Derecha del centro
    bl      draw_rectangle
    sub     posX, posX, #10                   // Izquierda del centro (5*2)
    sub	    posY, posY, #5		          // No se por que hace este offset
    bl      draw_rectangle

    ldp x30, x12, [sp], 16
    ret

// TRANSITION -------------------------------------------------------------------------------------
// Funci�n para dibujar la transici�n del background
// Par�metros:
// framebuffer: base del framebuffer (debe estar cargado antes de llamar)
// posY: posici�n Y inicial (l�nea donde comienza la transici�n)
// color: color a usar para la transici�n
// x6: hasta donde llegar en los line
draw_transition:
        stp     x30, x12, [sp, -32]!

        mov     x10, x3                        // ancho total de la funcion
        mov     x12, x6                      // x12 = largo del loop
        mov     x13, posX                      // Guardar donde inicializar X
        mov     ancho, #6                       // Ancho en X
        mov     x14, x13                     // x14 "counter"
        mov     x15, posY                      // Desde donde el alto

firstLine:
        mov     posX, x14                      // Posici�n de X actual
        mov     posY, x15                      // L�nea Y
        mov     alto, #1                       // Alto
        bl      draw_rectangle               // Dibujar bloque

        add     x14, x14, #12                // Avanzar p�xeles: pintados + sin pintar

        add     x11, x14, ancho
        cmp     x11, x10
        b.ge    nextLine                    // Si se pas� del ancho, salir

        cmp     x14, x10
        b.lt    firstLine                    // Seguir si no se pas� del ancho

nextLine:

        subs    x12, x12, #1                 // Lineas restantes
        b.eq    endTransition                // Si ya no quedan lineas, salir

        mov     ancho, #5
        mov     x14, x13
        sub     x15, x15, #1

secondLine:
        mov     posX, x14
        mov     posY, x15
        mov     alto, #2
        bl      draw_rectangle

        add     x14, x14, #10

        add     x11, x14, ancho
        cmp     x11, x10
        b.ge    nextLine1                    // Si se pas� del ancho, salir

        cmp     x14, x10
        b.lt    secondLine

nextLine1:

        subs    x12, x12, #1                 // Lineas restantes
        b.eq    endTransition                // Si ya no quedan lineas, salir

        mov     ancho, #4
        mov     x14, x13
        sub     x15, x15, #2

thirdLine:
        mov     posX, x14
        mov     posY, x15
        mov     alto, #2
        bl      draw_rectangle

        add     x14, x14, #8

        add     x11, x14, ancho
        cmp     x11, x10
        b.ge    nextLine2                    // Si se pas� del ancho, salir

        cmp     x14, x10
        b.lt    thirdLine

nextLine2:

        subs    x12, x12, #1                 // Lineas restantes
        b.eq    endTransition                // Si ya no quedan lineas, salir

        mov     ancho, #3
        mov     x14, x13
        sub     x15, x15, #2

fourthLine:
        mov     posX, x14
        mov     posY, x15
        mov     alto, #2
        bl      draw_rectangle

        add     x14, x14, #6

        add     x11, x14, ancho
        cmp     x11, x10
        b.ge    nextLine3                    // Si se pas� del ancho, salir

        cmp     x14, x10
        b.lt    fourthLine

nextLine3:

        subs    x12, x12, #1                 // Lineas restantes
        b.eq    endTransition                // Si ya no quedan lineas, salir

        mov     ancho, #2
        mov     x14, x13
        sub     x15, x15, #2

fifthLine:
        mov     posX, x14
        mov     posY, x15
        mov     alto, #3
        bl      draw_rectangle

        add     x14, x14, #4

        add     x11, x14, ancho
        cmp     x11, x10
        b.ge    nextLine4                    // Si se pas� del ancho, salir

        cmp     x14, x10
        b.lt    fifthLine

nextLine4:

        subs    x12, x12, #1                 // Lineas restantes
        b.eq    endTransition                // Si ya no quedan lineas, salir

        mov     ancho, #1
        mov     x14, x13
        sub     x15, x15, #3

sixthLine:
        mov     posX, x14
        mov     posY, x15
        mov     alto, #3
        bl      draw_rectangle

        add     x14, x14, #2

        add     x11, x14, ancho
        cmp     x11, x10
        b.ge    endTransition                    // Si se pas� del ancho, salir

        cmp     x14, x10
        b.lt    sixthLine

endTransition:

        ldp     x30, x12, [sp], 32
        ret


// TRANSITION INVERSED --------------------------------------------------------------------------
// Funci�n para dibujar la transici�n del background
// Par�metros:
// framebuffer: base del framebuffer (debe estar cargado antes de llamar)
// posY: posici�n Y inicial (l�nea donde comienza la transici�n)
// color: color a usar para la transici�n
// x6: hasta donde llegar en los line
draw_transition_inverse:
        stp     x30, x12, [sp, -32]!

        mov     x10, x3                        // ancho total de la funcion
        mov     x12, x6                      // x12 = largo del loop
        mov     x13, posX                      // Guardar donde inicializar X
        mov     ancho, #6                       // Ancho en X
        mov     x14, posX                      // x14 "counter"
        mov     x15, posY                      // Desde donde el alto

firstLineInv:
        mov     posX, x14                      // Posici�n de X actual
        mov     posY, x15                      // L�nea Y
        mov     alto, #3                       // Alto
        bl      draw_rectangle               // Dibujar bloque

        add     x14, x14, #12                // Avanzar p�xeles: pintados + sin pintar

        add     x11, x14, ancho
        cmp     x11, x10
        b.ge    nextLine01                    // Si se pas� del ancho, salir

        cmp     x14, x10
        b.lt    firstLineInv                 // Seguir si no se pas� del ancho

nextLine01:

        sub    x12, x12, #1                  // Lineas restantes
        cbz    x12, endTransitionInv         // Si ya no quedan lineas, salir

        mov     ancho, #5
        mov     x14, x13
        add     x15, x15, #3

secondLineInv:
        mov     posX, x14
        mov     posY, x15
        mov     alto, #2
        bl      draw_rectangle

        add     x14, x14, #10

        add     x11, x14, ancho
        cmp     x11, x10
        b.ge    nextLine02                    // Si se pas� del ancho, salir

        cmp     x14, x10
        b.lt    secondLineInv

nextLine02:

        sub    x12, x12, #1                  // Lineas restantes
        cbz    x12, endTransitionInv         // Si ya no quedan lineas, salir

        mov     ancho, #4
        mov     x14, x13
        add     x15, x15, #2

thirdLineInv:
        mov     posX, x14
        mov     posY, x15
        mov     alto, #2
        bl      draw_rectangle

        add     x14, x14, #8

        add     x11, x14, ancho
        cmp     x11, x10
        b.ge    nextLine03                    // Si se pas� del ancho, salir

        cmp     x14, x10
        b.lt    thirdLineInv

nextLine03:

        sub    x12, x12, #1                  // Lineas restantes
        cbz    x12, endTransitionInv         // Si ya no quedan lineas, salir

        mov     ancho, #3
        mov     x14, x13
        add     x15, x15, #2

fourthLineInv:
        mov     posX, x14
        mov     posY, x15
        mov     alto, #2
        bl      draw_rectangle

        add     x14, x14, #6

        add     x11, x14, ancho
        cmp     x11, x10
        b.ge    nextLine04                    // Si se pas� del ancho, salir

        cmp     x14, x10
        b.lt    fourthLineInv

nextLine04:

        sub    x12, x12, #1                  // Lineas restantes
        cbz    x12, endTransitionInv         // Si ya no quedan lineas, salir

        mov     ancho, #2
        mov     x14, x13
        add     x15, x15, #2

fifthLineInv:
        mov     posX, x14
        mov     posY, x15
        mov     alto, #1
        bl      draw_rectangle

        add     x14, x14, #4

        add     x11, x14, ancho
        cmp     x11, x10
        b.ge    nextLine05                    // Si se pas� del ancho, salir

        cmp     x14, x10
        b.lt    fifthLineInv

nextLine05:

        sub    x12, x12, #1                  // Lineas restantes
        cbz    x12, endTransitionInv         // Si ya no quedan lineas, salir

        mov     ancho, #1
        mov     x14, x13
        add     x15, x15, #1

sixthLineInv:
        mov     posX, x14
        mov     posY, x15
        mov     alto, #3
        bl      draw_rectangle

        add     x14, x14, #2

        add     x11, x14, ancho
        cmp     x11, x10
        b.ge    endTransitionInv                    // Si se pas� del ancho, salir

        cmp     x14, x10
        b.lt    sixthLineInv

endTransitionInv:

        ldp     x30, x12, [sp], 32
        ret
