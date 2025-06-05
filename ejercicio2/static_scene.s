// static_scene.s -----------------------------------------------------------
    .equ SCREEN_WIDTH, 640
    .equ SCREEN_HEIGH, 480
    .include "aliases.s"
    .include "animation.s"

draw_static_scene:
// --------------- 1) PINTAR EL FONDO COMPLETO -------------------------
        // PINTAR EL FONDO (RECTANGULOS)
        reset_framebuffer
        all_coordinates #0, #0, SCREEN_WIDTH, SCREEN_HEIGH / 4                          // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x16, 0x42F                                                           // #16042F
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #0, SCREEN_HEIGH / 4, SCREEN_WIDTH, SCREEN_HEIGH / 4            // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x1C, 0x735                                                           // #1C0735
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #0, SCREEN_HEIGH / 2, SCREEN_WIDTH, SCREEN_HEIGH / 4            // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x22, 0xA3B                                                           // #220A3B
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #0, SCREEN_HEIGH * 3 / 4, SCREEN_WIDTH, SCREEN_HEIGH / 4        // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x28, 0xD41                                                           // #280D41
        bl      draw_rectangle

        // TRANSICIONES ENTRE COLORES
        // 1ER TRANSICION
        reset_framebuffer
        coordinates #0, SCREEN_HEIGH / 4                // EJE X, EJE Y
        mov     ancho, SCREEN_WIDTH                     // Ancho
        set_color 0x1C, 0x735                           // #1C0735
        mov     x6,  #6                                 // Largo del loop
        bl      draw_transition                         // Call function

        reset_framebuffer
        coordinates #0, SCREEN_HEIGH / 4 + 5            // EJE X, EJE Y
        mov     ancho, SCREEN_WIDTH                     // Ancho
        set_color 0x1C, 0x735                           // #1C0735
        mov     x6,  #6                                 // Largo del loop
        bl      draw_transition                         // Call function

        // 2DA TRANSICION
        reset_framebuffer
        coordinates #0, SCREEN_HEIGH / 2                // EJE X, EJE Y
        mov     ancho, SCREEN_WIDTH                     // Ancho
        set_color 0x22, 0xA3B                           // #220A3B
        mov     x6,  #6                                 // Largo del loop
        bl      draw_transition                         // Call function

        reset_framebuffer
        coordinates #0, SCREEN_HEIGH / 2 + 5            // EJE X, EJE Y
        mov     ancho, SCREEN_WIDTH                     // Ancho
        set_color 0x22, 0xA3B                           // #220A3B
        mov     x6,  #6                                 // Largo del loop
        bl      draw_transition                         // Call function

        // 3RA TRANSICION
        reset_framebuffer
        coordinates #0, SCREEN_HEIGH * 3 / 4            // EJE X, EJE Y
        mov     ancho, SCREEN_WIDTH                     // Ancho
        set_color 0x28, 0xD41                           // #280D41
        mov     x6,  #6                                 // Largo del loop
        bl      draw_transition                         // Call function
        
        reset_framebuffer
        coordinates #0, SCREEN_HEIGH * 3 / 4 + 5        // EJE X, EJE Y
        mov     ancho, SCREEN_WIDTH                     // Ancho
        set_color 0x28, 0xD41                           // #280D41
        mov     x6,  #6                                 // Largo del loop
        bl      draw_transition                         // Call function


// --------------- 2) DETALLES DEL FONDO -------------------------------
        // CALLING FUNCTION STAR (X1, X2 -> X center, Y center)
	reset_framebuffer
        coordinates #20, #100   // EJE X, EJE Y
	bl star

	reset_framebuffer
        coordinates #70, #400   // EJE X, EJE Y
	bl star

	reset_framebuffer
        coordinates #100, #150  // EJE X, EJE Y
	bl star

	reset_framebuffer
        coordinates #125, #50   // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #175, #440  // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #250, #350  // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #300, #125  // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #360, #320  // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #370, #180  // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #390, #20   // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #400, #415  // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #500, #120  // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #500, #375  // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #570, #200  // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #590, #345  // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #600, #50   // EJE X, EJE Y
	bl star

	reset_framebuffer
	coordinates #610, #460  // EJE X, EJE Y
	bl star


// --------------- 3) DIBUJO DE FIGURAS --------------------------------
        // MANGO DEL SABLE DE LUZ
        reset_framebuffer
        all_coordinates #50, #220, #330, #50    // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xc, 0x3172                   // #0C3172
        bl      draw_rectangle

        // DETALLES MANGO
        // EMISOR
        reset_framebuffer
        all_coordinates #375, #220, #5, #50     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #370, #223, #5, #45     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        // ALETITA
        reset_framebuffer
        all_coordinates #362, #270, #1, #20     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #360, #270, #2, #25     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #358, #270, #2, #28     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #356, #270, #2, #30     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xc, 0x3172                   // #0C3172
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #354, #270, #2, #30     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xc, 0x3172                   // #0C3172
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #352, #270, #2, #30     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xc, 0x3172                   // #0C3172
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #350, #270, #2, #28     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xc, 0x3172                   // #0C3172
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #348, #270, #2, #26     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xc, 0x3172                   // #0C3172
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #347, #270, #1, #23     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xc, 0x3172                   // #0C3172
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #346, #270, #1, #18     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xc, 0x3172                   // #0C3172
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #340, #270, #6, #16     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xc, 0x3172                   // #0C3172
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #339, #270, #1, #14     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xc, 0x3172                   // #0C3172
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #338, #270, #1, #12     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xc, 0x3172                   // #0C3172
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #337, #270, #1, #10     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        // GRIP
        reset_framebuffer
        all_coordinates #50, #260, #60, #5      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #50, #243, #80, #5      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #50, #225, #80, #5      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #130, #226, #4, #3      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #130, #244, #4, #3      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #47, #221, #3, #48      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle


// --------------- 4) ODC ENGRAVING ----------------------------------
        // O
        reset_framebuffer
        all_coordinates #300, #225, #3, #13     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #310, #225, #3, #13     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #303, #223, #7, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #303, #238, #7, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        // D
        reset_framebuffer
        all_coordinates #315, #223, #3, #17     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #325, #228, #3, #13     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #318, #223, #7, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #318, #238, #7, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        // C
        reset_framebuffer
        all_coordinates #330, #225, #3, #13     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #333, #223, #8, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #333, #238, #8, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        // 2
        reset_framebuffer
        all_coordinates #302, #262, #6, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #302, #254, #6, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #302, #246, #6, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #308, #248, #2, #6      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #300, #256, #2, #6      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        // 0
        reset_framebuffer
        all_coordinates #314, #246, #6, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #314, #262, #6, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #312, #248, #2, #14     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #320, #248, #2, #14     // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        // 2
        reset_framebuffer
        all_coordinates #326, #262, #6, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #326, #246, #6, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #326, #246, #6, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #332, #248, #2, #6      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #324, #256, #2, #6      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        // 5
        reset_framebuffer
        all_coordinates #338, #262, #6, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #338, #254, #6, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #338, #246, #6, #2      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #344, #256, #2, #6      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #336, #248, #2, #6      // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x4, 0x1839                   // #041839
        bl      draw_rectangle

        ret

// Blade
bladeeeeeee:
    // --------------- 5) HAZ DEL SABLE DE LUZ -----------------------------
        // BASE DEL HAZ
        reset_framebuffer
        all_coordinates #376, #232, #264, #25   // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xAD, 0xFFFF                  // #ADFFFF
        bl      draw_rectangle

        // DETALLES DEL HAZ
        reset_framebuffer
        all_coordinates #376, #232, #264, #3    // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x78, 0xC6FA                  // #78C6FA
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #376, #234, #264, #3    // EJE X, EJE Y, ANCHO, ALTO
        set_color 0x98, 0xD3FA                  // #98D3FA
        bl      draw_rectangle

        reset_framebuffer
        all_coordinates #376, #249, #264, #3    // EJE X, EJE Y, ANCHO, ALTO
        set_color 0xFF, 0xFFFF                  // #FFFFFF
        bl      draw_rectangle
        

    // --------------- 6) GLOW DEL SABLE ------------------------------------
        // Glow superior
        reset_framebuffer
        coordinates #376, #231                  // EJE X, EJE Y
        mov     x6,  #5                         // Largo del loop
        mov     ancho, SCREEN_WIDTH             // Ancho
        set_color 0x78, 0xC6FA                  // #78C6FA
        bl      draw_transition

        reset_framebuffer
        coordinates #385, #224                  // EJE X, EJE Y
        mov     x6,  #5                         // Largo del loop
        mov     ancho, SCREEN_WIDTH             // Ancho
        set_color 0x78, 0xC6FA                  // #78C6FA
        bl      draw_transition_inverse

        // Glow inferior
        reset_framebuffer
        coordinates #376, #255                  // EJE X, EJE Y
        mov     x6,  #5                         // Largo del loop
        mov     ancho, SCREEN_WIDTH             // Ancho
        set_color 0xAD, 0xFFFF                  // #ADFFFF
        bl      draw_transition_inverse

        reset_framebuffer
        coordinates #379, #264                  // EJE X, EJE Y
        mov     x6,  #5                         // Largo del loop
        mov     ancho, SCREEN_WIDTH             // Ancho
        set_color 0xAD, 0xFFFF                  // #ADFFFF
        bl      draw_transition

        ret
