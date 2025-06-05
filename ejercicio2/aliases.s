framebuffer .req x0
posX        .req x1
posY        .req x2
ancho       .req x3
alto        .req x4
color       .req x5
posInit     .req x20

// Guardar la macro para que se defina una sola vez
    .ifndef  __SET_COLOR_MACRO_DEFINED
    .set     __SET_COLOR_MACRO_DEFINED, 1
    .macro   set_color val_high, val_low
        movz color, \val_high, lsl 16
        movk color, \val_low,  lsl  0
    .endm
    .endif          // __SET_COLOR_MACRO_DEFINED

    .ifndef  __COORDINATES_MACRO_DEFINED
    .set     __COORDINATES_MACRO_DEFINED, 1
    .macro   coordinates x, y
        mov     posX, \x
        mov     posY, \y
    .endm
    .endif          // __COORDINATES_MACRO_DEFINED

    .ifndef  __ALL_COORDINATES_MACRO_DEFINED
    .set     __ALL_COORDINATES_MACRO_DEFINED, 1
    .macro   all_coordinates a, b, c, d
        mov     posX, \a
        mov     posY, \b
        mov     ancho, \c
        mov     alto,  \d
    .endm
    .endif          // __ALL_COORDINATES_MACRO_DEFINED

    .ifndef  __FRAMEBUFFER_MACRO_DEFINED
    .set     __FRAMEBUFFER_MACRO_DEFINED, 1
    .macro   reset_framebuffer
        mov     framebuffer, posInit
    .endm
    .endif          // __FRAMEBUFFER_MACRO_DEFINED
