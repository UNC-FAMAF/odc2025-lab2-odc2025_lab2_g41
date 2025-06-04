// app.s --------------------------------------------------------------------
    .equ SCREEN_WIDTH,  640
    .equ SCREEN_HEIGH,  480
    .equ BITS_PER_PIXEL, 32

    .globl  main
    .text
    .include "aliases.s"
    .include "animation.s"
    .include "static_scene.s"

main:
    // x0 llega con la base del framebuffer
    mov     framebuffer, x0
    mov     posInit,   framebuffer

    //---------------------------------------------------------------------
    bl      draw_static_scene      // ** función dentro de static_scene.s

     // longitud inicial del haz = 0
    mov     w0, #0
    adrp    x7, blade_len          // x7 ← página que contiene blade_len
    add     x7, x7, :lo12:blade_len
    str     w0, [x7]               // guardar 32 bits

    //---------------------------------------------------------------------
    // Bucle principal de animación (≈ 60 FPS)
main_loop:
    bl      move_all_stars
    bl      extend_blade
    bl      tiny_delay
    b       main_loop
