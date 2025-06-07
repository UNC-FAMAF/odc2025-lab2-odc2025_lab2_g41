// aliases.s
framebuffer .req x0
posX        .req x1
posY        .req x2
ancho       .req x3
alto        .req x4
color       .req x5
alfaX       .req x16
alfaY       .req x17
posInit     .req x20

.macro set_color val_high, val_low
    movz color, \val_high, lsl 16
    movk color, \val_low, lsl 0
.endm

.macro all_coords x, y, an, al 
    mov posX, \x
    mov posY, \y
    mov ancho, \an
    mov alto, \al
.endm

.macro resetFramebuffer
    mov framebuffer, posInit
.endm
