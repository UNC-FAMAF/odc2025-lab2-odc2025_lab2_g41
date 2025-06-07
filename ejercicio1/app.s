	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.globl main
        .include "draw_shapes.s"

// -----------------------------------------------------------------------------------------------
main:
    // Framebuffer llega con la base del framebuffer
        mov     posInit, framebuffer    // Guardar FB base

// --------------- 1) PINTAR EL FONDO COMPLETO -------------------------
    // PINTAR EL FONDO (RECTANGULOS)
        resetFramebuffer
        all_coords #0, #0, SCREEN_WIDTH, SCREEN_HEIGH / 4                   // X, Y, ANCHO, ALTO
        set_color 0x16, 0x42F                                               // #16042F
        bl      draw_rectangle

        resetFramebuffer
        all_coords #0, SCREEN_HEIGH / 4, SCREEN_WIDTH, SCREEN_HEIGH / 4     // X, Y, ANCHO, ALTO
        set_color 0x1C, 0x735                                               // #1C0735
        bl      draw_rectangle

        resetFramebuffer
        all_coords #0, SCREEN_HEIGH / 2, SCREEN_WIDTH, SCREEN_HEIGH / 4     // X, Y, ANCHO, ALTO
        set_color 0x22, 0xA3B            // #220A3B
        bl      draw_rectangle

        resetFramebuffer
        all_coords #0, SCREEN_HEIGH * 3 / 4, SCREEN_WIDTH, SCREEN_HEIGH / 4 // X, Y, ANCHO, ALTO
        set_color 0x28, 0xD41                                               // #280D41
        bl      draw_rectangle

    // TRANSICIONES ENTRE COLORES
        // 1ER TRANSICION
        resetFramebuffer
        all_coords #0, SCREEN_HEIGH / 4, SCREEN_WIDTH, #0           // X, Y, ANCHO, ALTO
        set_color 0x1C, 0x735                                       // #1C0735
        mov     x6,  #6                                             // Largo del loop
        bl      draw_transition

        resetFramebuffer
        all_coords #0, SCREEN_HEIGH / 4 + 5, SCREEN_WIDTH, #0       // X, Y, ANCHO, ALTO
        set_color 0x1C, 0x735                                       // #1C0735
        mov     x6,  #6                                             // Largo del loop
        bl      draw_transition

        // 2DA TRANSICION
        resetFramebuffer
        all_coords #0, SCREEN_HEIGH / 2, SCREEN_WIDTH, #0           // X, Y, ANCHO, ALTO
        set_color 0x22, 0xA3B                                       // #220A3B
        mov     x6,  #6                                             // Largo del loop
        bl      draw_transition

        resetFramebuffer
        all_coords #0, SCREEN_HEIGH / 2 + 5, SCREEN_WIDTH, #0       // X, Y, ANCHO, ALTO
        set_color 0x22, 0xA3B                                       // #220A3B
        mov     x6,  #6                                             // Largo del loop
        bl      draw_transition

        // 3RA TRANSICION
        resetFramebuffer
        all_coords #0, SCREEN_HEIGH * 3 / 4, SCREEN_WIDTH, #0       // X, Y, ANCHO, ALTO
        set_color 0x28, 0xD41                                       // #280D41
        mov     x6,  #6                                             // Largo del loop
        bl      draw_transition

        resetFramebuffer
        all_coords #0, SCREEN_HEIGH * 3 / 4 + 5, SCREEN_WIDTH, #0   // X, Y, ANCHO, ALTO
        set_color 0x28, 0xD41                                       // #280D41
        mov     x6,  #6                                             // Largo del loop
        bl      draw_transition


// --------------- 2) DETALLES DEL FONDO -------------------------------
    // Counting Stars by OneRepublic
        resetFramebuffer
        mov     posX, #20
        mov     posY, #100
        bl      star

        resetFramebuffer
        mov     posX, #70
        mov     posY, #400
        bl      star

        resetFramebuffer
        mov     posX, #100
        mov     posY, #150
        bl      star

        resetFramebuffer
        mov     posX, #125
        mov     posY, #50
        bl      star

        resetFramebuffer
        mov     posX, #175
        mov     posY, #440
        bl      star

        resetFramebuffer
        mov     posX, #250
        mov     posY, #350
        bl      star

        resetFramebuffer
        mov     posX, #300
        mov     posY, #125
        bl      star

        resetFramebuffer
        mov     posX, #360
        mov     posY, #320
        bl      star

        resetFramebuffer
        mov     posX, #370
        mov     posY, #180
        bl      star

        resetFramebuffer
        mov     posX, #390
        mov     posY, #20
        bl      star

        resetFramebuffer
        mov     posX, #400
        mov     posY, #415
        bl      star

        resetFramebuffer
        mov     posX, #500
        mov     posY, #120
        bl      star

        resetFramebuffer
        mov     posX, #500
        mov     posY, #375
        bl      star

        resetFramebuffer
        mov     posX, #570
        mov     posY, #200
        bl      star

        resetFramebuffer
        mov     posX, #590
        mov     posY, #345
        bl      star

        resetFramebuffer
        mov     posX, #600
        mov     posY, #50
        bl      star

        resetFramebuffer
        mov     posX, #610
        mov     posY, #460
        bl      star


// --------------- 3) MANGO DEL SABLE --------------------------------
    // BASE DEL MANGO
        resetFramebuffer
        all_coords #50, #220, #330, #50 // X, Y, ANCHO, ALTO
        set_color 0xc, 0x3172           // #0C3172
        bl      draw_rectangle

    // EMISOR
        resetFramebuffer
        all_coords #375, #220, #5, #50  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #370, #223, #5, #45  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

    // ALETITA
        resetFramebuffer
        all_coords #362, #270, #1, #20  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #360, #270, #2, #25  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #358, #270, #2, #28  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #356, #270, #2, #30  // X, Y, ANCHO, ALTO
        set_color 0xc, 0x3172           // #0C3172
        bl      draw_rectangle

        resetFramebuffer
        all_coords #354, #270, #2, #30  // X, Y, ANCHO, ALTO
        set_color 0xc, 0x3172           // #0C3172
        bl      draw_rectangle

        resetFramebuffer
        all_coords #352, #270, #2, #30  // X, Y, ANCHO, ALTO
        set_color 0xc, 0x3172           // #0C3172
        bl      draw_rectangle

        resetFramebuffer
        all_coords #350, #270, #2, #28  // X, Y, ANCHO, ALTO
        set_color 0xc, 0x3172           // #0C3172
        bl      draw_rectangle

        resetFramebuffer
        all_coords #348, #270, #2, #26  // X, Y, ANCHO, ALTO
        set_color 0xc, 0x3172           // #0C3172
        bl      draw_rectangle

        resetFramebuffer
        all_coords #347, #270, #1, #23  // X, Y, ANCHO, ALTO
        set_color 0xc, 0x3172           // #0C3172
        bl      draw_rectangle

        resetFramebuffer
        all_coords #346, #270, #1, #18  // X, Y, ANCHO, ALTO
        set_color 0xc, 0x3172           // #0C3172
        bl      draw_rectangle

        resetFramebuffer
        all_coords #340, #270, #6, #16  // X, Y, ANCHO, ALTO
        set_color 0xc, 0x3172           // #0C3172
        bl      draw_rectangle

        resetFramebuffer
        all_coords #339, #270, #1, #14  // X, Y, ANCHO, ALTO
        set_color 0xc, 0x3172           // #0C3172
        bl      draw_rectangle

        resetFramebuffer
        all_coords #338, #270, #1, #12  // X, Y, ANCHO, ALTO
        set_color 0xc, 0x3172           // #0C3172
        bl      draw_rectangle

        resetFramebuffer
        all_coords #337, #270, #1, #10  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

    // GRIP
        resetFramebuffer
        all_coords #50, #260, #60, #5   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #50, #243, #80, #5   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #50, #225, #80, #5   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #130, #226, #4, #3   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #130, #244, #4, #3   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #47, #221, #3, #48   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle


// --------------- 4) ODC ENGRAVING ----------------------------------
    // O
        resetFramebuffer
        all_coords #300, #225, #3, #13  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #310, #225, #3, #13  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #303, #223, #7, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #303, #238, #7, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

    // D
        resetFramebuffer
        all_coords #315, #223, #3, #17  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #325, #225, #3, #13  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #318, #223, #7, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #318, #238, #7, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

    // C
        resetFramebuffer
        all_coords #330, #225, #3, #13  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #333, #223, #8, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #333, #238, #8, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

    // 2
        resetFramebuffer
        all_coords #302, #262, #6, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #302, #254, #6, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #302, #246, #6, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #308, #248, #2, #6   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #300, #256, #2, #6   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

    // 0
        resetFramebuffer
        all_coords #314, #246, #6, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #314, #262, #6, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #312, #248, #2, #14  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #320, #248, #2, #14  // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

    // 2
        resetFramebuffer
        all_coords #326, #262, #6, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #326, #254, #6, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #326, #246, #6, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #332, #248, #2, #6   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #324, #256, #2, #6   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

    // 5
        resetFramebuffer
        all_coords #338, #262, #6, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #338, #254, #6, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #338, #246, #6, #2   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #344, #256, #2, #6   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle

        resetFramebuffer
        all_coords #336, #248, #2, #6   // X, Y, ANCHO, ALTO
        set_color 0x4, 0x1839           // #041839
        bl      draw_rectangle


// --------------- 5) HAZ DEL SABLE DE LUZ -----------------------------
         // BASE DEL HAZ
                        resetFramebuffer
                        mov     posX,  #376     // EJE X
                        mov     posY,  #232     // EJE Y
                        mov     ancho,  #264    // ANCHO
                        mov     alto,  #25      // ALTO
                        set_color 0xAD, 0xFFFF  // #ADFFFF
                        bl      draw_rectangle

        // DETALLES DEL HAZ
                // Detalle 1
                        resetFramebuffer
                        mov     posX,  #376             // EJE X
                        mov     posY,  #232             // EJE Y
                        mov     ancho,  #264            // ANCHO
                        mov     alto,  #3               // ALTO
                        set_color 0x78, 0xC6FA   // #78C6FA
                        bl      draw_rectangle

                        resetFramebuffer
                        mov     posX,  #376     // EJE X
                        mov     posY,  #234     // EJE Y
                        mov     ancho,  #264    // ANCHO
                        mov     alto,  #3       // ALTO
                        set_color 0x98, 0xD3FA  // #98D3FA
                        bl      draw_rectangle

                        resetFramebuffer
                        mov     posX,  #376     // EJE X
                        mov     posY,  #249     // EJE Y
                        mov     ancho,  #264    // ANCHO
                        mov     alto,  #3       // ALTO
                        set_color 0xFF, 0xFFFF  // #FFFFFF
                        bl      draw_rectangle
        

// --------------- 6) GLOW DEL SABLE ------------------------------------
        // Glow superior
                // Superior 1
                        resetFramebuffer
                        mov     posX,  #376             // EJE X
                        mov     posY,  #231             // EJE Y
                        mov     x6,  #5                 // Largo del loop
                        mov     x3, SCREEN_WIDTH        // ANCHO
                        set_color 0x78, 0xC6FA          // #78C6FA
                        bl      draw_transition

                // Superior 2
                        resetFramebuffer
                        mov     posX,  #385             // EJE X
                        mov     posY,  #224             // EJE Y
                        mov     x6,  #5                 // Largo del loop
                        mov     x3, SCREEN_WIDTH        // ANCHO
                        set_color 0x78, 0xC6FA          // #78C6FA
                        bl      draw_transition_inverse

        // Glow inferior
                        resetFramebuffer
                        mov     posX,  #376             // EJE X
                        mov     posY,  #255             // EJE Y
                        mov     x6,  #5                 // Largo del loop
                        mov     x3, SCREEN_WIDTH        // ANCHO
                        set_color 0xAD, 0xFFFF          // #ADFFFF
                        bl      draw_transition_inverse

                        resetFramebuffer
                        mov     posX,  #379             // EJE X
                        mov     posY,  #264             // EJE Y
                        mov     x6,  #5                 // Largo del loop
                        mov     x3, SCREEN_WIDTH        // ANCHO
                        set_color 0xAD, 0xFFFF          // #ADFFFF
                        bl      draw_transition


// --------------- 7) BRAZO ---------------------------------------------
    // LOOP1
        mov     x21, #10        // contador (10 rectangulos)
        mov     x22, #0         // X inicial
        mov     x23, #300       // Y inicial
        mov     x24, #6         // ancho fijo
        mov     x25, #90        // alto fijo

    rectLoop1:
        resetFramebuffer
        mov     posX, x22       // X actual
        mov     posY, x23       // Y actual
        mov     ancho, x24      // ancho fijo
        mov     alto, x25       // alto fijo
        set_color 0x0, 0x4782   // #004782
        bl      draw_rectangle

        add     x22, x22, x24   // X += ancho al siguiente rectangulo a la derecha
        sub     x23, x23, #2    // Y decremento
        subs    x21, x21, #1    // contador--
        cbnz    x21, rectLoop1

    // LOOP2
        mov     x21, #10        // contador (10 rectangulos)
        mov     x22, #60        // X inicial
        mov     x23, #280       // Y inicial
        mov     x24, #6         // ancho fijo
        mov     x25, #90        // alto fijo

    rectLoop2:
        resetFramebuffer
        mov     posX, x22       // X actual
        mov     posY, x23       // Y actual
        mov     ancho, x24      // ancho fijo
        mov     alto, x25       // alto fijo
        set_color 0x0, 0x4782   // #004782
        bl      draw_rectangle

        add     x22, x22, x24   // X += ancho al siguiente rectangulo a la derecha
        sub     x23, x23, #3    // Y decremento
        subs    x21, x21, #1    // contador--
        cbnz    x21, rectLoop2

    // LOOP3
        mov     x21, #10        // contador (10 rectangulos)
        mov     x22, #120       // X inicial
        mov     x23, #250       // Y inicial
        mov     x24, #6         // ancho fijo
        mov     x25, #90        // alto fijo

    rectLoop3:
        resetFramebuffer
        mov     posX, x22       // X actual
        mov     posY, x23       // Y actual
        mov     ancho, x24      // ancho fijo
        mov     alto, x25       // alto fijo
        set_color 0x0, 0x4782   // #004782
        bl      draw_rectangle

        add     x22, x22, x24   // X += ancho al siguiente rectangulo a la derecha
        sub     x23, x23, #4    // Y decremento
        subs    x21, x21, #1    // contador--
        cbnz    x21, rectLoop3


// --------------- 8) HAND ---------------------------------------------
    // DEDO GORDO
        resetFramebuffer
        all_coords #260, #190, #6, #82  // X, Y, ANCHO, ALTO
        set_color 0x1, 0x2E54           // #012E54
        bl      draw_rectangle

        resetFramebuffer
        all_coords #266, #190, #6, #82  // X, Y, ANCHO, ALTO
        set_color 0x1, 0x2E54           // #012E54
        bl      draw_rectangle

        resetFramebuffer
        all_coords #272, #190, #6, #82  // X, Y, ANCHO, ALTO
        set_color 0x1, 0x2E54           // #012E54
        bl      draw_rectangle

        resetFramebuffer
        all_coords #278, #190, #3, #82  // X, Y, ANCHO, ALTO
        set_color 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        resetFramebuffer
        all_coords #281, #192, #3, #28  // X, Y, ANCHO, ALTO
        set_color 0x1, 0x2E54           // #012E54
        bl      draw_rectangle

        resetFramebuffer
        all_coords #283, #194, #3, #28  // X, Y, ANCHO, ALTO
        set_color 0x1, 0x2E54           // #012E54
        bl      draw_rectangle

        resetFramebuffer
        all_coords #286, #196, #3, #24  // X, Y, ANCHO, ALTO
        set_color 0x1, 0x2E54           // #012E54
        bl      draw_rectangle

        resetFramebuffer
        all_coords #289, #198, #3, #22  // X, Y, ANCHO, ALTO
        set_color 0x1, 0x2E54           // #012E54
        bl      draw_rectangle

        resetFramebuffer
        all_coords #292, #200, #3, #20  // X, Y, ANCHO, ALTO
        set_color 0x1, 0x2E54           // #012E54
        bl      draw_rectangle

        resetFramebuffer
        all_coords #295, #204, #2, #16  // X, Y, ANCHO, ALTO
        set_color 0x1, 0x2E54           // #012E54
        bl      draw_rectangle

    // OTROS DEDOS
        resetFramebuffer
        all_coords #162, #216, #6, #90  // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #168, #210, #6, #98  // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #174, #206, #6, #102 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #180, #202, #6, #106 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #186, #198, #6, #110 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #192, #192, #6, #114 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #198, #188, #6, #118 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #204, #184, #6, #122 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #210, #182, #6, #124 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #216, #180, #6, #124 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #222, #180, #6, #124 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782            // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #228, #180, #6, #124 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #234, #180, #6, #122 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #240, #182, #6, #120 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #246, #184, #6, #118 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #252, #186, #6, #114 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #258, #188, #6, #110 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #264, #192, #6, #104 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #264, #194, #6, #102 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #270, #194, #6, #100 // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782            // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #276, #200, #6, #90  // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle

        resetFramebuffer
        all_coords #282, #204, #6, #82  // X, Y, ANCHO, ALTO
        set_color 0x0, 0x4782           // #004782
        bl      draw_rectangle


// --------------- 9) DETALLES DE MANOS --------------------------------

    // 1ER NUDILLO
            mov     x21, #14        // contador (10 rectangulos)
            mov     x22, #286       // X inicial
            mov     x23, #240       // Y inicial
            mov     x24, #2         // ancho fijo
            mov     x25, #4         // alto fijo

        nudillo1:
            resetFramebuffer
            mov     posX, x22       // X actual
            mov     posY, x23       // Y actual
            mov     ancho, x24      // ancho fijo
            mov     alto, x25       // alto fijo
            set_color 0x1, 0x2E54   // #012E54
            bl      draw_rectangle

            sub     x22, x22, x24   // X += ancho al siguiente rectangulo a la derecha
            sub     x23, x23, #2    // Y decremento
            subs    x21, x21, #1    // contador--
            cbnz    x21, nudillo1

    // 2DO NUDILLO
            mov     x21, #12        // contador (10 rectangulos)
            mov     x22, #286       // X inicial
            mov     x23, #270       // Y inicial
            mov     x24, #2         // ancho fijo
            mov     x25, #4         // alto fijo

        nudillo2:
            resetFramebuffer
            mov     posX, x22       // X actual
            mov     posY, x23       // Y actual
            mov     ancho, x24      // ancho fijo
            mov     alto, x25       // alto fijo
            set_color 0x1, 0x2E54   // #012E54
            bl      draw_rectangle

            sub     x22, x22, x24   // X += ancho al siguiente rectangulo a la derecha
            sub     x23, x23, #2    // Y decremento
            subs    x21, x21, #1    // contador--
            cbnz    x21, nudillo2

    // 3ER NUDILLO
            mov     x21, #8         // contador (10 rectangulos)
            mov     x22, #274       // X inicial
            mov     x23, #290       // Y inicial
            mov     x24, #2         // ancho fijo
            mov     x25, #4         // alto fijo

        nudillo3:
            resetFramebuffer
            mov     posX, x22       // X actual
            mov     posY, x23       // Y actual
            mov     ancho, x24      // ancho fijo
            mov     alto, x25       // alto fijo
            set_color 0x1, 0x2E54   // #012E54
            bl      draw_rectangle

            sub     x22, x22, x24   // X += ancho al siguiente rectangulo a la derecha
            sub     x23, x23, #2    // Y decremento
            subs    x21, x21, #1    // contador--
            cbnz    x21, nudillo3


    // Reset or Init counters for infinite loop
            mov     x24, #1         // Ancho del sable a generar
            mov     x25, #377       // Hasta donde en x glow del sable

InfLoop:
        b       InfLoop                      // mantiene el programa corriendo :P (no borrar)
