	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20

	// --------------- Start BG ---------------
	movz x10, 0x16, lsl 16
	movk x10, 0x032f, lsl 00

	mov x2, SCREEN_HEIGH         // Y Size
nextCol:
	mov x1, SCREEN_WIDTH        // X Size
nextRow:
	stur w10, [x0]  // Colorear el pixel N
	add x0, x0, 4	   // Siguiente pixel
	sub x1, x1, 1	   // Decrementar contador X
	cbnz x1, nextRow  // Si no terminó la fila, salto
	sub x2, x2, 1	   // Decrementar contador Y
	cbnz x2, nextCol  // Si no es la última fila, salto

	// --------------- Paint Rectangle ---------------
	mov x0, x20          // Reiniciar x0 a la base del framebuffer
    movz x10, 0x3b, lsl 16
    movk x10, 0x8fae, lsl 00

    mov x2, SCREEN_HEIGH // Y Size
    mov x3, SCREEN_WIDTH * 4 / 9 // Mitad del ancho (320)
rectY:
    mov x1, SCREEN_WIDTH / 9 // X Size (solo mitad derecha)
    mov x4, x0
    add x4, x4, x3, lsl 2    // x4 = x0 + 320 * 4 (offset mitad derecha)
rectX:
    stur w10, [x4]       // Pintar pixel en la mitad derecha
    add x4, x4, 4        // Siguiente pixel
    sub x1, x1, 1        // Decrementar contador X
    cbnz x1, rectX
    add x0, x0, SCREEN_WIDTH * 4 // Avanzar a la siguiente fila (640 * 4 bytes)
    mov x4, x0
    add x4, x4, x3, lsl 2       // Recalcular offset mitad derecha
    sub x2, x2, 1        // Decrementar contador Y
    cbnz x2, rectY

	// Ejemplo de uso de gpios
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10
	and w11, w10, 0b10

	// w11 será 1 si había un 1 en la posición 2 de w10, si no será 0
	// efectivamente, su valor representará si GPIO 2 está activo
	lsr w11, w11, 1

	// --------------- Infinite Loop ---------------


InfLoop:
	b InfLoop
