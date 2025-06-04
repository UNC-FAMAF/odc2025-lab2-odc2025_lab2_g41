// static_scene.s -----------------------------------------------------------
    .equ SCREEN_WIDTH, 640
    .equ SCREEN_HEIGH, 480
    .include "aliases.s"

draw_static_scene:
// --------------- 1) PINTAR EL FONDO COMPLETO -------------------------
        // PINTAR EL FONDO (RECTANGULOS)
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #0                      // EJE X
        mov     posY,  #0                      // EJE Y
        mov     ancho,  SCREEN_WIDTH            // ANCHO
        mov     alto,  SCREEN_HEIGH / 4        // ALTO
        set_color color, 0x16, 0x42F            // #16042F
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #0                      // EJE X
        mov     posY,  SCREEN_HEIGH / 4        // EJE Y
        mov     ancho,  SCREEN_WIDTH            // ANCHO
        mov     alto,  SCREEN_HEIGH / 4        // ALTO
        set_color color, 0x1A, 0x633            // #1A0633
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #0                      // EJE X
        mov     posY,  SCREEN_HEIGH / 2        // EJE Y
        mov     ancho,  SCREEN_WIDTH            // ANCHO
        mov     alto,  SCREEN_HEIGH / 4        // ALTO
        set_color color, 0x1E, 0x837            // #1E0837
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #0                      // EJE X
        mov     posY,  SCREEN_HEIGH *3 /4      // EJE Y
        mov     ancho,  SCREEN_WIDTH            // ANCHO
        mov     alto,  SCREEN_HEIGH / 4        // ALTO
        set_color color, 0x22, 0xA3B            // #220A3B
        bl      draw_rectangle

        // TRANSICIONES ENTRE COLORES
        // 1ER TRANSICION
        mov     framebuffer,  posInit                     // base FB
        add     posX, xzr, xzr                 // EJE X = 0
        mov     posY, SCREEN_HEIGH / 4         // EJE Y
        mov     x3, SCREEN_WIDTH
        set_color color, 0x1A, 0x633            // #1A0633
        mov     x6,  #6                      // Largo del loop
        bl      draw_transition              // Call function

        mov     framebuffer,  posInit                     // base FB
        add     posX, xzr, xzr                 // EJE X = 0
        mov     posY, SCREEN_HEIGH / 4 + 5     // EJE Y
        mov     x3, SCREEN_WIDTH
        set_color color, 0x1A, 0x633            // #1A0633
        mov     x6,  #6                      // Largo del loop
        bl      draw_transition              // Call function

        // 2DA TRANSICION
        mov     framebuffer,  posInit                     // base FB
        add     posX, xzr, xzr                 // EJE X = 0
        mov     posY, SCREEN_HEIGH / 2         // EJE Y
        mov     x3, SCREEN_WIDTH
        set_color color, 0x1E, 0x837            // #1E0837
        mov     x6,  #6                      // Largo del loop
        bl      draw_transition              // Call function

        mov     framebuffer,  posInit                     // base FB
        add     posX, xzr, xzr                 // EJE X = 0
        mov     posY, SCREEN_HEIGH / 2 + 5     // EJE Y
        mov     x3, SCREEN_WIDTH
        set_color color, 0x1E, 0x837            // #1E0837
        mov     x6,  #6                      // Largo del loop
        bl      draw_transition              // Call function

        // 3RA TRANSICION
        mov     framebuffer,  posInit                     // base FB
        add     posX, xzr, xzr                 // EJE X = 0
        mov     posY, SCREEN_HEIGH * 3 / 4     // EJE Y
        mov     x3, SCREEN_WIDTH
        set_color color, 0x22, 0xA3B            // #220A3B
        mov     x6,  #6                      // Largo del loop
        bl      draw_transition              // Call function

        mov     framebuffer,  posInit                     // base FB
        add     posX, xzr, xzr                 // EJE X = 0
        mov     posY, SCREEN_HEIGH * 3 / 4 + 5 // EJE Y
        mov     x3, SCREEN_WIDTH
        set_color color, 0x22, 0xA3B            // #220A3B
        mov     x6,  #6                      // Largo del loop
        bl      draw_transition              // Call function


// --------------- 2) DETALLES DEL FONDO -------------------------------
        // CALLING FUNCTION STAR (X1, X2 -> X center, Y center)
	mov     framebuffer, posInit
	mov     posX, #20
	mov     posY, #100
	bl star

	mov     framebuffer, posInit
	mov     posX, #70
	mov     posY, #400
	bl star

	mov     framebuffer, posInit
	mov     posX, #100
	mov     posY, #150
	bl star

	mov     framebuffer, posInit
	mov     posX, #125
	mov     posY, #50
	bl star

	mov     framebuffer, posInit
	mov     posX, #175
	mov     posY, #440
	bl star

	mov     framebuffer, posInit
	mov     posX, #250
	mov     posY, #350
	bl star

	mov     framebuffer, posInit
	mov     posX, #300
	mov     posY, #125
	bl star

	mov     framebuffer, posInit
	mov     posX, #360
	mov     posY, #320
	bl star

	mov     framebuffer, posInit
	mov     posX, #370
	mov     posY, #180
	bl star

	mov     framebuffer, posInit
	mov     posX, #390
	mov     posY, #20
	bl star

	mov     framebuffer, posInit
	mov     posX, #400
	mov     posY, #415
	bl star

	mov     framebuffer, posInit
	mov     posX, #500
	mov     posY, #120
	bl star

	mov     framebuffer, posInit
	mov     posX, #500
	mov     posY, #375
	bl star

	mov     framebuffer, posInit
	mov     posX, #570
	mov     posY, #200
	bl star

	mov     framebuffer, posInit
	mov     posX, #590
	mov     posY, #345
	bl star

	mov     framebuffer, posInit
	mov     posX, #600
	mov     posY, #50
	bl star

	mov     framebuffer, posInit
	mov     posX, #610
	mov     posY, #460
	bl star


// --------------- 3) DIBUJO DE FIGURAS --------------------------------
        // MANGO DEL SABLE DE LUZ
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #50                     // EJE X
        mov     posY,  #220                    // EJE Y
        mov     ancho,  #330                    // ANCHO
        mov     alto,  #50                     // ALTO
        set_color color, 0xc, 0x3172            // #0C3172
        bl      draw_rectangle

        // DETALLES MANGO
        // EMISOR
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #375                    // EJE X
        mov     posY,  #220                    // EJE Y
        mov     ancho,  #5                      // ANCHO
        mov     alto,  #50                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #370                    // EJE X
        mov     posY,  #223                    // EJE Y
        mov     ancho,  #5                      // ANCHO
        mov     alto,  #45                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        // ALETITA
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #362                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #1                      // ANCHO
        mov     alto,  #20                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #360                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #25                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #358                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #28                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #356                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #30                     // ALTO
        set_color color, 0xc, 0x3172            // #0C3172
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #354                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #30                     // ALTO
        set_color color, 0xc, 0x3172            // #0C3172
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #352                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #30                     // ALTO
        set_color color, 0xc, 0x3172            // #0C3172
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #350                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #28                     // ALTO
        set_color color, 0xc, 0x3172            // #0C3172
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #348                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #26                     // ALTO
        set_color color, 0xc, 0x3172            // #0C3172
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #347                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #1                      // ANCHO
        mov     alto,  #23                     // ALTO
        set_color color, 0xc, 0x3172            // #0C3172
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #346                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #1                      // ANCHO
        mov     alto,  #18                     // ALTO
        set_color color, 0xc, 0x3172            // #0C3172
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #340                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #16                     // ALTO
        set_color color, 0xc, 0x3172            // #0C3172
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #339                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #1                      // ANCHO
        mov     alto,  #14                     // ALTO
        set_color color, 0xc, 0x3172            // #0C3172
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #338                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #1                      // ANCHO
        mov     alto,  #12                     // ALTO
        set_color color, 0xc, 0x3172            // #0C3172
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #337                    // EJE X
        mov     posY,  #270                    // EJE Y
        mov     ancho,  #1                      // ANCHO
        mov     alto,  #10                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        // GRIP
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #50                     // EJE X
        mov     posY,  #260                    // EJE Y
        mov     ancho,  #60                     // ANCHO
        mov     alto,  #5                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #50                     // EJE X
        mov     posY,  #243                    // EJE Y
        mov     ancho,  #80                     // ANCHO
        mov     alto,  #5                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #50                     // EJE X
        mov     posY,  #225                    // EJE Y
        mov     ancho,  #80                     // ANCHO
        mov     alto,  #5                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #130                    // EJE X
        mov     posY,  #226                    // EJE Y
        mov     ancho,  #4                      // ANCHO
        mov     alto,  #3                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #130                    // EJE X
        mov     posY,  #244                    // EJE Y
        mov     ancho,  #4                      // ANCHO
        mov     alto,  #3                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #47                     // EJE X
        mov     posY,  #221                    // EJE Y
        mov     ancho,  #3                      // ANCHO
        mov     alto,  #48                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle


// --------------- 4) ODC ENGRAVING ----------------------------------
        // O
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #300                    // EJE X
        mov     posY,  #225                    // EJE Y
        mov     ancho,  #3                      // ANCHO
        mov     alto,  #13                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #310                    // EJE X
        mov     posY,  #225                    // EJE Y
        mov     ancho,  #3                      // ANCHO
        mov     alto,  #13                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #303                    // EJE X
        mov     posY,  #223                    // EJE Y
        mov     ancho,  #7                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #303                    // EJE X
        mov     posY,  #238                    // EJE Y
        mov     ancho,  #7                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        // D
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #315                    // EJE X
        mov     posY,  #223                    // EJE Y
        mov     ancho,  #3                      // ANCHO
        mov     alto,  #17                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #325                    // EJE X
        mov     posY,  #225                    // EJE Y
        mov     ancho,  #3                      // ANCHO
        mov     alto,  #13                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #318                    // EJE X
        mov     posY,  #223                    // EJE Y
        mov     ancho,  #7                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #318                    // EJE X
        mov     posY,  #238                    // EJE Y
        mov     ancho,  #7                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        // C
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #330                    // EJE X
        mov     posY,  #225                    // EJE Y
        mov     ancho,  #3                      // ANCHO
        mov     alto,  #13                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #333                    // EJE X
        mov     posY,  #223                    // EJE Y
        mov     ancho,  #8                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #333                    // EJE X
        mov     posY,  #238                    // EJE Y
        mov     ancho,  #8                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        // 2
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #302                    // EJE X
        mov     posY,  #262                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #302                    // EJE X
        mov     posY,  #254                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #302                    // EJE X
        mov     posY,  #246                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #308                    // EJE X
        mov     posY,  #248                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #6                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #300                    // EJE X
        mov     posY,  #256                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #6                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        // 0
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #314                    // EJE X
        mov     posY,  #246                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #314                    // EJE X
        mov     posY,  #262                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #312                    // EJE X
        mov     posY,  #248                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #14                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #320                    // EJE X
        mov     posY,  #248                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #14                     // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        // 2
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #326                    // EJE X
        mov     posY,  #262                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #326                    // EJE X
        mov     posY,  #254                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #326                    // EJE X
        mov     posY,  #246                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #332                    // EJE X
        mov     posY,  #248                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #6                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #324                    // EJE X
        mov     posY,  #256                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #6                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        // 5
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #338                    // EJE X
        mov     posY,  #262                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #338                    // EJE X
        mov     posY,  #254                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #338                    // EJE X
        mov     posY,  #246                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #2                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #344                    // EJE X
        mov     posY,  #256                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #6                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #336                    // EJE X
        mov     posY,  #248                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #6                      // ALTO
        set_color color, 0x4, 0x1839            // #041839
        bl      draw_rectangle


        ret
