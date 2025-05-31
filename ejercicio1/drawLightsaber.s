.global drawLightsaber

drawLightsaber:
// -- Haz de luz (RAW) -----------------------------
        mov     x0,  x20                 // base FB
        mov     x1,  #427                // coord X
        mov     x2,  #230                // coord Y
        mov     x3,  #213                // ancho
        mov     x4,  #20                // alto
        movz    x5, 0xb3, lsl 16
        movk    x5, 0xFFFF, lsl 0
        bl      draw_rectangle

// -- Mango del sable (RAW) -----------------------------
        mov     x0,  x20                 // base FB
        mov     x1,  #150                // coord X
        mov     x2,  #220                // coord Y
        mov     x3,  #277                // ancho
        mov     x4,  #40                // alto
        movz    x5, 0x12, lsl 16
        movk    x5, 0x2d69, lsl 0
        bl      draw_rectangle
        