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

.macro set_color reg, val_high, val_low
    movz \reg, \val_high, lsl 16
    movk \reg, \val_low, lsl 0
.endm
