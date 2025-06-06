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
        // framebuffer llega con la base del framebuffer
        mov     posInit, framebuffer                      // guarda FB base
        mov     alfaX, #0                                // coords iniciales de estrellas
        mov     alfaY, #0

reset:
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
        set_color color, 0x1C, 0x735            // #1C0735
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #0                      // EJE X
        mov     posY,  SCREEN_HEIGH / 2        // EJE Y
        mov     ancho,  SCREEN_WIDTH            // ANCHO
        mov     alto,  SCREEN_HEIGH / 4        // ALTO
        set_color color, 0x22, 0xA3B            // #220A3B
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #0                      // EJE X
        mov     posY,  SCREEN_HEIGH *3 /4      // EJE Y
        mov     ancho,  SCREEN_WIDTH            // ANCHO
        mov     alto,  SCREEN_HEIGH / 4        // ALTO
        set_color color, 0x28, 0xD41            // #280D41
        bl      draw_rectangle

        // TRANSICIONES ENTRE COLORES
        // 1ER TRANSICION
        mov     framebuffer,  posInit                     // base FB
        add     posX, xzr, xzr                 // EJE X = 0
        mov     posY, SCREEN_HEIGH / 4         // EJE Y
        mov     x3, SCREEN_WIDTH
        set_color color, 0x1C, 0x735            // #1C0735
        mov     x6,  #6                      // Largo del loop
        bl      draw_transition              // Call function

        mov     framebuffer,  posInit                     // base FB
        add     posX, xzr, xzr                 // EJE X = 0
        mov     posY, SCREEN_HEIGH / 4 + 5     // EJE Y
        mov     x3, SCREEN_WIDTH
        set_color color, 0x1C, 0x735            // #1C0735
        mov     x6,  #6                      // Largo del loop
        bl      draw_transition              // Call function

        // 2DA TRANSICION
        mov     framebuffer,  posInit                     // base FB
        add     posX, xzr, xzr                 // EJE X = 0
        mov     posY, SCREEN_HEIGH / 2         // EJE Y
        mov     x3, SCREEN_WIDTH
        set_color color, 0x22, 0xA3B            // #220A3B
        mov     x6,  #6                      // Largo del loop
        bl      draw_transition              // Call function

        mov     framebuffer,  posInit                     // base FB
        add     posX, xzr, xzr                 // EJE X = 0
        mov     posY, SCREEN_HEIGH / 2 + 5     // EJE Y
        mov     x3, SCREEN_WIDTH
        set_color color, 0x22, 0xA3B            // #220A3B
        mov     x6,  #6                      // Largo del loop
        bl      draw_transition              // Call function

        // 3RA TRANSICION
        mov     framebuffer,  posInit                     // base FB
        add     posX, xzr, xzr                 // EJE X = 0
        mov     posY, SCREEN_HEIGH * 3 / 4     // EJE Y
        mov     x3, SCREEN_WIDTH
        set_color color, 0x28, 0xD41            // #280D41
        mov     x6,  #6                      // Largo del loop
        bl      draw_transition              // Call function

        mov     framebuffer,  posInit                     // base FB
        add     posX, xzr, xzr                 // EJE X = 0
        mov     posY, SCREEN_HEIGH * 3 / 4 + 5 // EJE Y
        mov     x3, SCREEN_WIDTH
        set_color color, 0x28, 0xD41            // #280D41
        mov     x6,  #6                      // Largo del loop
        bl      draw_transition              // Call function


// --------------- 2) DETALLES DEL FONDO -------------------------------
        // CALLING FUNCTION STAR (X1, X2 -> X center, Y center)
		
	mov     framebuffer, posInit
	add     posX, alfaX, #20
	add     posY, alfaY, #100
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #70
	add     posY, alfaY, #400
	bl 		resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #100
	add     posY, alfaY, #150
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #125
	add     posY, alfaY, #50
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #175
	add     posY, alfaY, #440
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #250
	add     posY, alfaY, #350
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #300
	add     posY, alfaY, #125
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #360
	add     posY, alfaY, #320
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #370
	add     posY, alfaY, #180
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #390
	add     posY, alfaY, #20
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #400
	add     posY, alfaY, #415
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #500
	add     posY, alfaY, #120
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #500
	add     posY, alfaY, #375
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #570
	add     posY, alfaY, #200
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #590
	add     posY, alfaY, #345
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #600
	add     posY, alfaY, #50
	bl      resetPosY
	bl star

	mov     framebuffer, posInit
	add     posX, alfaX, #610
	add     posY, alfaY, #460
	bl      resetPosY
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


// --------------- 5) HAZ DEL SABLE DE LUZ -----------------------------



// --------------- 6) GLOW DEL SABLE ------------------------------------



// --------------- 7) BRAZO ---------------------------------------------
        // LOOP1
        mov     posInit, framebuffer                      // framebuffer base
        mov     x21, #10                     // contador (10 rectángulos)
        mov     x22, #0                      // X inicial
        mov     x23, #300                    // Y fijo
        mov     x24, #6                      // ancho
        mov     x25, #90                     // alto

    rectLoop1:
        mov     framebuffer, posInit                      // framebuffer
        mov     posX, x22                      // X
        mov     posY, x23                      // Y
        mov     ancho, x24                      // ancho
        mov     alto, x25                      // alto
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        add     x22, x22, x24                // X += ancho → siguiente rectángulo a la derecha
        sub     x23, x23, #2
        subs    x21, x21, #1                 // contador--
        cbnz    x21, rectLoop1

        // LOOP2
        mov     posInit, framebuffer                      // framebuffer base
        mov     x21, #10                     // contador (10 rectángulos)
        mov     x22, #60                     // X inicial
        mov     x23, #280                    // Y fijo
        mov     x24, #6                      // ancho
        mov     x25, #90                     // alto

    rectLoop2:
        mov     framebuffer, posInit                      // framebuffer
        mov     posX, x22                      // X
        mov     posY, x23                      // Y
        mov     ancho, x24                      // ancho
        mov     alto, x25                      // alto
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        add     x22, x22, x24                // X += ancho → siguiente rectángulo a la derecha
        sub     x23, x23, #3
        subs    x21, x21, #1                 // contador--
        cbnz    x21, rectLoop2

        // LOOP3
        mov     posInit, framebuffer                      // framebuffer base
        mov     x21, #10                     // contador (10 rectángulos)
        mov     x22, #120                    // X inicial
        mov     x23, #250                    // Y fijo
        mov     x24, #6                      // ancho
        mov     x25, #90                     // alto

    rectLoop3:
        mov     framebuffer, posInit                      // framebuffer
        mov     posX, x22                      // X
        mov     posY, x23                      // Y
        mov     ancho, x24                      // ancho
        mov     alto, x25                      // alto
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        add     x22, x22, x24                // X += ancho → siguiente rectángulo a la derecha
        sub     x23, x23, #4
        subs    x21, x21, #1                 // contador--
        cbnz    x21, rectLoop3


// --------------- 8) HAND ---------------------------------------------
        // DEDO GORDO
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #260                    // EJE X
        mov     posY,  #190                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #82                     // ALTO
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #266                    // EJE X
        mov     posY,  #190                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #82                     // ALTO
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #272                    // EJE X
        mov     posY,  #190                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #82                     // ALTO
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #278                    // EJE X
        mov     posY,  #190                    // EJE Y
        mov     ancho,  #3                      // ANCHO
        mov     alto,  #82                     // ALTO
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #281                    // EJE X
        mov     posY,  #192                    // EJE Y
        mov     ancho,  #3                      // ANCHO
        mov     alto,  #28                     // ALTO
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #283                    // EJE X
        mov     posY,  #194                    // EJE Y
        mov     ancho,  #3                      // ANCHO
        mov     alto,  #28                     // ALTO
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #286                    // EJE X
        mov     posY,  #196                    // EJE Y
        mov     ancho,  #3                      // ANCHO
        mov     alto,  #24                     // ALTO
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #289                    // EJE X
        mov     posY,  #198                    // EJE Y
        mov     ancho,  #3                      // ANCHO
        mov     alto,  #22                     // ALTO
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #292                    // EJE X
        mov     posY,  #200                    // EJE Y
        mov     ancho,  #3                      // ANCHO
        mov     alto,  #20                     // ALTO
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #295                    // EJE X
        mov     posY,  #204                    // EJE Y
        mov     ancho,  #2                      // ANCHO
        mov     alto,  #16                     // ALTO
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        // OTROS DEDOS
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #162                    // EJE X
        mov     posY,  #216                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #90                     // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #168                    // EJE X
        mov     posY,  #210                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #98                     // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #174                    // EJE X
        mov     posY,  #206                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #102                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #180                    // EJE X
        mov     posY,  #202                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #106                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #186                    // EJE X
        mov     posY,  #198                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #110                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #192                    // EJE X
        mov     posY,  #192                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #114                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #198                    // EJE X
        mov     posY,  #188                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #118                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #204                    // EJE X
        mov     posY,  #184                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #122                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #210                    // EJE X
        mov     posY,  #182                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #124                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #216                    // EJE X
        mov     posY,  #180                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #124                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #222                    // EJE X
        mov     posY,  #180                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #124                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #228                    // EJE X
        mov     posY,  #180                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #124                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #234                    // EJE X
        mov     posY,  #180                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #122                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #240                    // EJE X
        mov     posY,  #182                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #120                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #246                    // EJE X
        mov     posY,  #184                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #118                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #252                    // EJE X
        mov     posY,  #186                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #114                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #258                    // EJE X
        mov     posY,  #188                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #110                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #264                    // EJE X
        mov     posY,  #192                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #104                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #264                    // EJE X
        mov     posY,  #194                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #102                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #270                    // EJE X
        mov     posY,  #194                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #100                    // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #276                    // EJE X
        mov     posY,  #200                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #90                     // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #282                    // EJE X
        mov     posY,  #204                    // EJE Y
        mov     ancho,  #6                      // ANCHO
        mov     alto,  #82                     // ALTO
        set_color color, 0x0, 0x4782            // #004782
        bl      draw_rectangle


// --------------- 9) DETALLES DE MANOS --------------------------------
        // 1ER NUDILLO
        mov     posInit, framebuffer                      // framebuffer base
        mov     x21, #14                     // contador (10 rectángulos)
        mov     x22, #286                    // X inicial
        mov     x23, #240                    // Y fijo
        mov     x24, #2                      // ancho
        mov     x25, #4                      // alto

    nudillo1:
        mov     framebuffer, posInit                      // framebuffer
        mov     posX, x22                      // X
        mov     posY, x23                      // Y
        mov     ancho, x24                      // ancho
        mov     alto, x25                      // alto
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        sub     x22, x22, x24                // X += ancho → siguiente rectángulo a la derecha
        sub     x23, x23, #2
        subs    x21, x21, #1                 // contador--
        cbnz    x21, nudillo1

        // 2DO NUDILLO
        mov     posInit, framebuffer                      // framebuffer base
        mov     x21, #12                     // contador (10 rectángulos)
        mov     x22, #286                    // X inicial
        mov     x23, #270                    // Y fijo
        mov     x24, #2                      // ancho
        mov     x25, #4                      // alto

    nudillo2:
        mov     framebuffer, posInit                      // framebuffer
        mov     posX, x22                      // X
        mov     posY, x23                      // Y
        mov     ancho, x24                      // ancho
        mov     alto, x25                      // alto
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        sub     x22, x22, x24                // X += ancho → siguiente rectángulo a la derecha
        sub     x23, x23, #2
        subs    x21, x21, #1                 // contador--
        cbnz    x21, nudillo2

        // 3ER NUDILLO
        mov     posInit, framebuffer                      // framebuffer base
        mov     x21, #8                      // contador (10 rectángulos)
        mov     x22, #274                    // X inicial
        mov     x23, #290                    // Y fijo
        mov     x24, #2                      // ancho
        mov     x25, #4                      // alto

    nudillo3:
        mov     framebuffer, posInit                      // framebuffer
        mov     posX, x22                      // X
        mov     posY, x23                      // Y
        mov     ancho, x24                      // ancho
        mov     alto, x25                      // alto
        set_color color, 0x1, 0x2E54            // #012E54
        bl      draw_rectangle

        sub     x22, x22, x24                // X += ancho → siguiente rectángulo a la derecha
        sub     x23, x23, #2
        subs    x21, x21, #1                 // contador--
        cbnz    x21, nudillo3

        // Counter
        mov     x24, #1                      // ancho
        mov     x25, #377

InfLoop:
    // 1) Dibujar el sable en la posición actual x22
        // Haz del sable
        mov     framebuffer, posInit
        mov     posX,           #376
        mov     posY,           #232
        mov     ancho,          x24
        mov     alto,           #25
        set_color color, 0xAD, 0xFFFF      // Color “visible” del sable #ADFFFF
        bl      draw_rectangle

        mov     framebuffer,  posInit
        mov     posX,           #376                    // EJE X
        mov     posY,           #232                    // EJE Y
        mov     ancho,          x24                    // ANCHO
        mov     alto,           #3                      // ALTO
        set_color color, 0x78, 0xC6FA           // #78C6FA
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,       #376                    // EJE X
        mov     posY,       #234                    // EJE Y
        mov     ancho,      x24                    // ANCHO
        mov     alto,       #3                      // ALTO
        set_color color, 0x98, 0xD3FA           // #98D3FA
        bl      draw_rectangle

        mov     framebuffer,  posInit                     // base FB
        mov     posX,       #376                    // EJE X
        mov     posY,       #249                    // EJE Y
        mov     ancho,      x24                    // ANCHO
        mov     alto,       #3                      // ALTO
        set_color color, 0xFF, 0xFFFF           // #FFFFFF
        bl      draw_rectangle

        // Glow del haz
        // Glow superior
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #376                    // EJE X
        mov     posY,  #231                    // EJE Y
        mov     x6,  #5                      // Largo del loop
        mov     x3, x25
        set_color    color, 0x78, 0xC6FA        // #78C6FA
        bl      draw_transition

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #385                    // EJE X
        mov     posY,  #224                    // EJE Y
        mov     x6,  #5                      // Largo del loop
        mov     x3, x25
        set_color    color, 0x78, 0xC6FA        // #78C6FA
        bl      draw_transition_inverse

        // Glow inferior
        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #376                    // EJE X
        mov     posY,  #255                    // EJE Y
        mov     x6,  #5                      // Largo del loop
        mov     x3, x25
        set_color    color, 0xAD, 0xFFFF        // #ADFFFF
        bl      draw_transition_inverse

        mov     framebuffer,  posInit                     // base FB
        mov     posX,  #379                    // EJE X
        mov     posY,  #264                    // EJE Y
        mov     x6,  #5                      // Largo del loop
        mov     x3, x25
        set_color    color, 0xAD, 0xFFFF        // #ADFFFF
        bl      draw_transition


    // 2) Avanzar X en 1
    add     x24, x24, #1
    add     x25, x25, #1

    // 3) Si x24 == 264, borrar TODO el haz y reiniciar a 376
    cmp     x24, #264
    b.ne    SkipErase
	
    // Aquí: x22 acaba de llegar a 640 → tenemos que borrar todo el trazo
    mov     framebuffer, posInit
    mov     posX,       #376                      // Desde donde empezó el sable
    mov     posY,       #232                      // Mismo Y fijo del sable
    mov     ancho,      #264                   // 640 – 376 = 264 píxeles
    mov     alto,       #25                    // Misma altura del sable
    set_color color, 0x22, 0xA3B            // #220A3B
    bl      draw_rectangle

    mov     framebuffer, posInit
	
	add     alfaX, alfaX, #10                // muevo estrellas
    add     alfaY, alfaY, #10
	
	cmp		alfaY, #480						 // 
	b.gt	resetAlfaY
	
	bl reset

resetAlfaY:
	sub 	alfaY, alfaY, #480
	bl reset
	
	// Reiniciar x22 a 376 para que vuelva a aparecer en esa posición
    mov     x24, #1

SkipErase:
    // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


    // 4) Retardo para ralentizar la animación
    mov     x29, #0xFFFFF
DelayLoop:
    subs    x29, x29, #1
    b.ne    DelayLoop

    // 5) Volver a InfLoop
    b       InfLoop

