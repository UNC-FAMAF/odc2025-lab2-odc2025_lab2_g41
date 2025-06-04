    .equ SCREEN_WIDTH,  640
    .equ SCREEN_HEIGH,  480
    .equ BITS_PER_PIXEL, 32
    .include "aliases.s"

    // ────────────────  CONSTANTES  ───────────────────────────────────────
    .equ STAR_W,            5
    .equ STAR_H,            5
    .equ STAR_ERASE_W,     15
    .equ STAR_ERASE_H,     15
    .equ STAR_OFF_X,        5
    .equ STAR_OFF_Y,       10
    .equ STAR_DX,           1

    .equ BLADE_MAX,       264
    .equ BLADE_STEP,        4

    // ────────────────  DATOS  ────────────────────────────────────────────
    .data
stripe_table:
    .word 0x0016042F, 0x001A0633, 0x001E0837, 0x00220A3B

stars:              // x ,  y , color de fondo
    .word  20,100, 0x0016042F
    .word  70,400, 0x00220A3B
    .word 100,150, 0x001A0633
    .word 125, 50, 0x0016042F
    .word 175,440, 0x00220A3B
    .word 250,350, 0x001E0837
    .word 300,125, 0x001A0633
    .word 360,320, 0x001E0837
    .word 370,180, 0x001A0633
    .word 390, 20, 0x0016042F
    .word 400,415, 0x00220A3B
    .word 500,120, 0x001A0633
    .word 500,375, 0x00220A3B
    .word 570,200, 0x001A0633
    .word 590,345, 0x001E0837
    .word 600, 50, 0x0016042F
    .word 610,460, 0x00220A3B

    .equ NESTARS, (.-stars)/(3*4)    // 17 estructuras de 12 bytes

    .bss
blade_len:  .skip 4                  // longitud actual del haz

    // ────────────────  CÓDIGO  ───────────────────────────────────────────
    .text
//--------------------------------------------------------------------------
//  x0 = &Star  (x, y, bg_color)
//  destruye x1-x6, x9-x12, x30
move_one_star:
    stp     x30, x21, [sp, #-16]!   // x21 guardará el puntero Star

    mov     x21, x0                // save  &Star
    mov     framebuffer, posInit   // ← 1) poner FB real en x0

    ldr     w6, [x21]              // x, y, bg_color ahora desde x21
    ldr     w9, [x21, #4]
    ldr     w10,[x21, #8]

    //–– Borrar estrella en posición vieja ––
    sub     posX,  x6,  #STAR_OFF_X       // posX = x - 5
    sub     posY,  x9,  #STAR_OFF_Y       // posY = y -10
    mov     ancho, #STAR_ERASE_W
    mov     alto,  #STAR_ERASE_H
    mov     color, x10
    bl      draw_rectangle

    //–– Actualizar X con wrap-around ––
    add     w6,  w6,  #STAR_DX
    cmp     w6,  #(SCREEN_WIDTH-STAR_W)
    csel    w6,  wzr, w6, GT              // si pasa, vuelve a 0
    str     w6,  [x21]                     // guardar nueva X

    //–– Dibujar estrella en nueva posición ––
    mov     posX, x6
    mov     posY, x9
    bl      star                          // tu rutina existente

    ldp     x30, x21, [sp], #16
    ret
//--------------------------------------------------------------------------
//  Recorre todas las estructuras Star
move_all_stars:
    adrp    x0, stars
    add     x0, x0, :lo12:stars           // x0 → primer Star
    mov     x1, #NESTARS
1:
    bl      move_one_star
    add     x0, x0, #12                   // sizeof(Star)
    subs    x1, x1, #1
    b.ne    1b
    ret
//--------------------------------------------------------------------------
//  Extiende el haz de luz BLADE_STEP px por cuadro
extend_blade:
    mov     framebuffer, posInit   // ← 2) asegurar FB en x0

    adrp    x7, blade_len
    add     x7, x7, :lo12:blade_len
    ldr     w6, [x7]                  // len actual
    cmp     w6, #BLADE_MAX
    b.ge    2f                            // ya está completo

    // Dibujar “punta” nueva
    mov     posX,  #376
    add     posX, posX, x6
    mov     posY,  #232
    mov     ancho, #BLADE_STEP
    mov     alto,  #25
    set_color color, 0xAD, 0xFFFF         // #ADFFFF
    bl      draw_rectangle

    // Actualizar longitud
    add     w6,  w6,  #BLADE_STEP
    str     w6,  [x7]
2:  ret
//--------------------------------------------------------------------------
//  Retardo “tonto” ≃ 60 FPS en QEMU (ajustar 0x8000 si hace falta)
tiny_delay:
    mov     x9, #0x2
1:  subs    x9, x9, #1
    b.ne    1b
    ret
