.global draw_rectangle
draw_rectangle:
	stp     x30, x12, [sp, -16]!
	mov     x7,  x4                   // alto = h
	mov     x8,  x3                   // ancho original
rectRow: // dirección fila (x,y)
	mov     x9,  x2
	lsl     x9,  x9,  #9
	mov     x12, x2
	lsl     x12, x12, #7
	add     x9,  x9,  x12
	add     x9,  x9,  x1
	lsl     x9,  x9,  #2
	add     x9,  x9,  x0
	// recorre ancho
	mov     x6,  x3                    // ancho restante
rectPix:	stur    w5, [x9]
	add     x9,  x9,  #4
	sub     x6,  x6,  #1
	cbnz    x6,  rectPix
	// próxima fila
	add     x2,  x2,  #1
	sub     x7,  x7,  #1
	cbnz    x7,  rectRow
	ldp     x30, x12, [sp], 16
	ret
	