// app.s --------------------------------------------------------------------
    .equ SCREEN_WIDTH,  640
    .equ SCREEN_HEIGH,  480
    .equ BITS_PER_PIXEL, 32

    .globl  main
    .text
    .include "aliases.s"
    .include "static_scene.s"

main:
    // x0 llega con la base del framebuffer
    mov     framebuffer, x0
    mov     posInit,   framebuffer

    // Dibujar escena estatica
    reset_framebuffer
    bl      draw_static_scene

    // timer
    reset_framebuffer
    bl      bladeeeeeee

    //---------------------------------------------------------------------
    // Bucle principal de animación (≈ 60 FPS)
main_loop:
    //bl      move_all_stars
    //bl      extend_blade
    //bl      tiny_delay
    //b       main_loop
