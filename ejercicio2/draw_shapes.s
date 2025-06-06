.include "aliases.s"

// RECTANGULO  -------------------------------------------------------------------------------------
// Funcion para dibujar un rectangulo (cruz)
// Parametros:
// posX: coordenada X del centro
// posY: coordenada Y del centro
// ancho: extensión en X
// alto: extensión en Y
// color: Lorem ipsum
draw_rectangle:
    stp     x30, x12, [sp, -16]!        // Guarda x30 (link register) y x12 en la pila (salvar contexto)

    mov     x7, alto                    // x7 alto (numero de filas que tendra el rectangulo)
    mov     x8, ancho                   // x8 ancho original (no usado directamente luego)

.rectRow:                               // Comienza una nueva fila del rectangulo
    mov     x9, posY                    // x9 coordenada Y
    lsl     x9, x9, #9                  // x9 = Y * 512 (equivalente a Y << 9)
    mov     x12, posY                   // x12 Y
    lsl     x12, x12, #7                // x12 = Y * 128 (equivalente a Y << 7)
    add     x9, x9, x12                 // x9 = Y*512 + Y*128 = Y*640 offset en filas (stride = SCREEN_WIDTH)

    add     x9, x9, posX                // x9 += X offset horizontal
    lsl     x9, x9, #2                  // x9 *= 4 (porque cada pixel ocupa 4 bytes = 32 bits por pixel)
    add     x9, x9, framebuffer         // x9 = direccion absoluta dentro del framebuffer

    mov     x6, ancho                   // x6 ancho (cuantos pixeles escribir en esta fila)

.rectPix:                               // Bucle interno: recorre columnas en una fila
    stur    w5, [x9]                    // Guarda el color (w5) en la direccion apuntada por x9
    add     x9, x9, #4                  // Avanza 4 bytes (siguiente pixel)
    sub     x6, x6, #1                  // ancho restante -= 1
    cbnz    x6, .rectPix                // Si queda ancho por recorrer, continuar

    add     posY, posY, #1              // Y += 1 (siguiente fila)
    sub     x7, x7, #1                  // alto restante -= 1
    cbnz    x7, .rectRow                // Si quedan filas, repetir

    ldp     x30, x12, [sp], 16          // Restaura x30 y x12 desde la pila
    ret                                 // Vuelve al llamador

// ESTRELLAS -------------------------------------------------------------------------------------
// Funcion para dibujar una estrella (cruz)
// Parametros:
// posX: coordenada X del centro
// posY: coordenada Y del centro
star:
    // Salvar registros en el stack pile
        stp     x30, x12, [sp, -16]!        // Guarda x30 (link register) y x12 en la pila (salvar contexto)

    // Parte central
        mov     ancho, #5                   // Ancho
        mov     alto, #5                    // Alto
        set_color 0x3B, 0x8FAE              // Color del centro #3B8FAE
    bl      draw_rectangle

    // Parte superior e inferior
        sub     posY, posY, #10             // Subir del centro (5*2)
        set_color 0x14, 0x366D              // Color de alrededor #14366D
        bl      draw_rectangle

        add     posY, posY, #5              // Bajar del centro
        bl      draw_rectangle

        sub     posY, posY, #10             // Restaurar Y (5*2)

    // Parte derecha e izquierda
        add     posX, posX, #5              // Derecha del centro
        bl      draw_rectangle

        sub     posX, posX, #10             // Izquierda del centro (5*2)
        sub	    posY, posY, #5	    // Corrección en Y
        bl      draw_rectangle

    // Restaurar registros del stack pile
        ldp x30, x12, [sp], 16
        ret

    // Loop stuff
resetPosY:
	cmp 	posY, #480
	b.lt	skipResetPosY

	sub	posY, posY, #480
skipResetPosY:
	ret


// TRANSITION -------------------------------------------------------------------------------------
// Funcion para dibujar la transicion del background
// Parametros:
// framebuffer: base del framebuffer (debe estar cargado antes de llamar)
// posY: posicion Y inicial (linea donde comienza la transicion)
// color: color a usar para la transicion
// x6: hasta donde llegar en los line
draw_transition:
    // Salvar registros en el stack pile
                stp     x30, x12, [sp, -32]!

                mov     x10, x3                 // ancho total de la funcion
                mov     x12, x6                 // x12 = largo del loop
                mov     x13, posX               // Guardar donde inicializar X

        // Here starts in every floor
                mov     ancho, #6               // Ancho en X
                mov     x14, x13                // x14 "counter"
                mov     x15, posY               // Desde donde el alto

        firstLine:
                mov     posX, x14               // Posicion de X actual
                mov     posY, x15               // Linea Y
                mov     alto, #1                // Alto
                bl      draw_rectangle

                add     x14, x14, #12           // Avanzar pixeles: pintados + sin pintar

                add     x11, x14, ancho
                cmp     x11, x10
                b.ge    nextLine                // Si se pasa del ancho el siguiente pixel, salir

                cmp     x14, x10
                b.lt    firstLine               // Seguir si no se pasa del ancho el algoritmo

        nextLine:

                subs    x12, x12, #1            // Lineas restantes
                b.eq    endTransition           // Si ya no quedan lineas, salir

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
                b.ge    nextLine1

                cmp     x14, x10
                b.lt    secondLine

        nextLine1:

                subs    x12, x12, #1
                b.eq    endTransition

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
                b.ge    nextLine2

                cmp     x14, x10
                b.lt    thirdLine

        nextLine2:

                subs    x12, x12, #1
                b.eq    endTransition

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
                b.ge    nextLine3

                cmp     x14, x10
                b.lt    fourthLine

        nextLine3:

                subs    x12, x12, #1
                b.eq    endTransition

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
                b.ge    nextLine4

                cmp     x14, x10
                b.lt    fifthLine

        nextLine4:

                subs    x12, x12, #1
                b.eq    endTransition

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
                b.ge    endTransition

                cmp     x14, x10
                b.lt    sixthLine

        endTransition:

    // Restaurar registros del stack pile
                ldp     x30, x12, [sp], 32
                ret


// TRANSITION INVERSED --------------------------------------------------------------------------
// Funcion para dibujar la transicion del background
// Parametros:
// framebuffer: base del framebuffer (debe estar cargado antes de llamar)
// posY: posicion Y inicial (linea donde comienza la transicion)
// color: color a usar para la transicion
// x6: hasta donde llegar en los line
draw_transition_inverse:
// Salvar registros en el stack pile
                stp     x30, x12, [sp, -32]!

                mov     x10, x3                         // ancho total de la funcion
                mov     x12, x6                         // x12 = largo del loop
                mov     x13, posX                       // Guardar donde inicializar X
        // Here starts in every floor
                mov     ancho, #6                       // Ancho en X
                mov     x14, posX                       // x14 "counter"
                mov     x15, posY                       // Desde donde el alto

        firstLineInv:
                mov     posX, x14                       // Posicion de X actual
                mov     posY, x15                       // Linea Y
                mov     alto, #3                        // Alto
                bl      draw_rectangle

                add     x14, x14, #12                   // Avanzar pixeles: pintados + sin pintar

                add     x11, x14, ancho
                cmp     x11, x10
                b.ge    nextLine01                      // Si se pasa del ancho, salir

                cmp     x14, x10
                b.lt    firstLineInv                    // Seguir si no se pasa del ancho

        nextLine01:

                sub    x12, x12, #1                     // Lineas restantes
                cbz    x12, endTransitionInv            // Si ya no quedan lineas, salir

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
                b.ge    nextLine02

                cmp     x14, x10
                b.lt    secondLineInv

        nextLine02:

                sub    x12, x12, #1
                cbz    x12, endTransitionInv

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
                b.ge    nextLine03

                cmp     x14, x10
                b.lt    thirdLineInv

        nextLine03:

                sub    x12, x12, #1
                cbz    x12, endTransitionInv

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
                b.ge    nextLine04

                cmp     x14, x10
                b.lt    fourthLineInv

        nextLine04:

                sub    x12, x12, #1
                cbz    x12, endTransitionInv

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
                b.ge    nextLine05

                cmp     x14, x10
                b.lt    fifthLineInv

        nextLine05:

                sub    x12, x12, #1
                cbz    x12, endTransitionInv

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
                b.ge    endTransitionInv

                cmp     x14, x10
                b.lt    sixthLineInv

        endTransitionInv:

        // Restaurar registros del stack pile
                ldp     x30, x12, [sp], 32
                ret
