.global drawLeftHand

drawLeftHand:
        mov     x22, #0          // X inicial
        mov     x23, #60        // Y inicial
        mov     x24, #20          // cuántos rectángulos

        .manoIzqLoop1:
            mov     x0,  x20         // frame-buffer
            mov     x1,  x22         // X
            mov     x2,  x23         // Y
            mov     x3,  #6          // ancho
            mov     x4,  #80         // alto
            movz    x5,  #0,     lsl 16
            movk    x5,  #0x4782, lsl 0
            bl      draw_rectangle   // draw_rectangle puede clobber x0-x17 sin problemas

            add     x22, x22, #6     // X += 6
            add     x23, x23, #1     // Y += 1
            subs    x24, x24, #1     // contador--
            b.ne    .manoIzqLoop1


            mov     x24, #20          // reiniciamos contador

            .manoIzqLoop2:
            mov     x0,  x20         // frame-buffer
            mov     x1,  x22         // X
            mov     x2,  x23         // Y
            mov     x3,  #6          // ancho
            mov     x4,  #80         // alto
            movz    x5,  #0,     lsl 16
            movk    x5,  #0x4782, lsl 0
            bl      draw_rectangle   // draw_rectangle puede clobber x0-x17 sin problemas

            add     x22, x22, #6     // X += 6
            add     x23, x23, #2     // Y += 2
            subs    x24, x24, #1     // contador--
            b.ne    .manoIzqLoop2

            mov     x24, #20          // reiniciamos contador


 .manoIzqLoop3:
            mov     x0,  x20         // frame-buffer
            mov     x1,  x22         // X
            mov     x2,  x23         // Y
            mov     x3,  #6          // ancho
            mov     x4,  #80         // alto
            movz    x5,  #0,     lsl 16
            movk    x5,  #0x4782, lsl 0
            bl      draw_rectangle   // draw_rectangle puede clobber x0-x17 sin problemas

            add     x22, x22, #6     // X += 6
            add     x23, x23, #3     // Y += 3
            subs    x24, x24, #1     // contador--
            b.ne    .manoIzqLoop3



            mov     x24, #20          // reiniciamos contador


 .manoIz1Loop4:
            mov     x0,  x20         // frame-buffer
            mov     x1,  x22         // X
            mov     x2,  x23         // Y
            mov     x3,  #6          // ancho
            mov     x4,  #80         // alto
            movz    x5,  #0,     lsl 16
            movk    x5,  #0x4782, lsl 0
            bl      draw_rectangle   // draw_rectangle puede clobber x0-x17 sin problemas

            add     x22, x22, #6     // X += 6
            add     x23, x23, #4     // Y += 4
            subs    x24, x24, #1     // contador--
            b.ne    .manoIz1Loop4
            ret
