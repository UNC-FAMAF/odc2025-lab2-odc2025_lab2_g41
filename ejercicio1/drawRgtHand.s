.global drawRightHand

drawRightHand:
        mov     x22, #0          // X inicial
        mov     x23, #300        // Y inicial
        mov     x24, #10          // cuántos rectángulos

        .manoDerLoop1:
            mov     x0,  x20         // frame-buffer
            mov     x1,  x22         // X
            mov     x2,  x23         // Y
            mov     x3,  #6          // ancho
            mov     x4,  #80         // alto
            movz    x5,  #0,     lsl 16
            movk    x5,  #0x4782, lsl 0
            bl      draw_rectangle   // draw_rectangle puede clobber x0-x17 sin problemas

            add     x22, x22, #6     // X += 6
            sub     x23, x23, #1     // Y -= 1
            subs    x24, x24, #1     // contador--
            b.ne    .manoDerLoop1


            mov     x24, #10          // reiniciamos contador

            .manoDerLoop2:
            mov     x0,  x20         // frame-buffer
            mov     x1,  x22         // X
            mov     x2,  x23         // Y
            mov     x3,  #6          // ancho
            mov     x4,  #80         // alto
            movz    x5,  #0,     lsl 16
            movk    x5,  #0x4782, lsl 0
            bl      draw_rectangle   // draw_rectangle puede clobber x0-x17 sin problemas

            add     x22, x22, #6     // X += 6
            sub     x23, x23, #2     // Y -= 2
            subs    x24, x24, #1     // contador--
            b.ne    .manoDerLoop2

            mov     x24, #10          // reiniciamos contador


 .manoDerLoop3:
            mov     x0,  x20         // frame-buffer
            mov     x1,  x22         // X
            mov     x2,  x23         // Y
            mov     x3,  #6          // ancho
            mov     x4,  #80         // alto
            movz    x5,  #0,     lsl 16
            movk    x5,  #0x4782, lsl 0
            bl      draw_rectangle   // draw_rectangle puede clobber x0-x17 sin problemas

            add     x22, x22, #6     // X += 6
            sub     x23, x23, #3     // Y -= 3
            subs    x24, x24, #1     // contador--
            b.ne    .manoDerLoop3



            mov     x24, #10          // reiniciamos contador


 .manoDerLoop4:
            mov     x0,  x20         // frame-buffer
            mov     x1,  x22         // X
            mov     x2,  x23         // Y
            mov     x3,  #6          // ancho
            mov     x4,  #80         // alto
            movz    x5,  #0,     lsl 16
            movk    x5,  #0x4782, lsl 0
            bl      draw_rectangle   // draw_rectangle puede clobber x0-x17 sin problemas

            add     x22, x22, #6     // X += 6
            sub     x23, x23, #4     // Y -= 4
            subs    x24, x24, #1     // contador--
            b.ne    .manoDerLoop4
            ret
