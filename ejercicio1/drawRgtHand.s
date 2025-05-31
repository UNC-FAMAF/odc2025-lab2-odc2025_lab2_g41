//  drawRightHand – dibuja la mano derecha (40 rectángulos en 4 escalones)
// drawRightHand, versión corregida
.global drawRightHand
drawRightHand:
        // ---------- prólogo (48 B, alineado) ----------
        stp     x29, x30, [sp, -48]!
        mov     x29, sp
        stp     x22, x23, [sp, 16]   //  x22-x23
        str     x24,       [sp, 32]  //  x24   (dentro del frame)

        //------------------------------------------------------------------
        //  Inicialización
        //------------------------------------------------------------------
        mov     x22, #0          // X
        mov     x23, #300        // Y
        mov     x24, #10         // contador

//=========================== ESCALÓN 1 ===========================
.manoDerLoop1:
        mov     x0,  x20
        mov     x1,  x22
        mov     x2,  x23
        mov     x3,  #6
        mov     x4,  #80
        movz    x5,  #0, lsl 16
        movk    x5,  #0x4782
        bl      draw_rectangle

        add     x22, x22, #6     // X += 6
        sub     x23, x23, #1     // Y -= 1
        subs    x24, x24, #1
        b.ne    .manoDerLoop1

//=========================== ESCALÓN 2 ===========================
        mov     x24, #10
.manoDerLoop2:
        mov     x0,  x20
        mov     x1,  x22
        mov     x2,  x23
        mov     x3,  #6
        mov     x4,  #80
        movz    x5,  #0x0, lsl 16
        movk    x5,  #0x4782, lsl 0
        bl      draw_rectangle

        add     x22, x22, #6
        sub     x23, x23, #2
        subs    x24, x24, #1
        b.ne    .manoDerLoop2

//=========================== ESCALÓN 3 ===========================
        mov     x24, #10
.manoDerLoop3:
        mov     x0,  x20
        mov     x1,  x22
        mov     x2,  x23
        mov     x3,  #6
        mov     x4,  #80
        movz    x5,  #0, lsl 16
        movk    x5,  #0x4782
        bl      draw_rectangle

        add     x22, x22, #6
        sub     x23, x23, #3
        subs    x24, x24, #1
        b.ne    .manoDerLoop3

//=========================== ESCALÓN 4 ===========================
        mov     x24, #10
.manoDerLoop4:
        mov     x0,  x20
        mov     x1,  x22
        mov     x2,  x23
        mov     x3,  #6
        mov     x4,  #80
        movz    x5,  #0, lsl 16
        movk    x5,  #0x4782
        bl      draw_rectangle

        add     x22, x22, #6
        sub     x23, x23, #4
        subs    x24, x24, #1
        b.ne    .manoDerLoop4

        // ---------- epílogo ----------
        ldr     x24,       [sp, 32]
        ldp     x22, x23, [sp, 16]
        ldp     x29, x30, [sp], 48
        ret
