# Laboratorio Assembler ARMv8

## Organizaci�n del Computador - A�o 2025

### Alumnos

1) `45694437` Mariano Gabriel Dubois Bruenner
2) `45692174` Valentin Issidoro
3) `45691761` Lisandro Marquez
4) `45934473` Mateo Marchisone

---

### Formato del Proyecto

**Archivos:**

1) Ejercicio 1:
    - *aliases.s:* Posee alias para sentencias recurrentes
    - *app.s:* Posee la imagen principal
    - *draw_shapes.s:* Posee las figuras b�sicas empleadas
2) Ejercicio 2:
    - *aliases.s:* Posee alias para sentencias recurrentes
    - *app.s:* Posee la imagen principal
    - *draw_shapes.s:* Posee las figuras b�sicas empleadas

---

### Descripci�n del Ejercicio 1

**Proceso de dibujado:**

1) Fondo con "transici�n" entre colores
2) Estrellas
3) Mango del Sable
4) OdC en el mango del sable
5) Haz de luz
6) Glow del haz
7) Brazo
8) Mano
9) "Detalles" de la mano

### Descripci�n del Ejercicio 2

**Proceso de dibujado:**

1) a
2) b
3) c
4) d
5) e

---

### Instrucciones ARMv8 empleadas

1) **stp x1, x2, [sp, n]!:** La instrucci�n stp es una sentencia de almacenamiento de dos de registros que realiza:
    - Decrementa el sp *(puntero de pila)* en 16 bytes ``([sp, -16]!)``
    - Almacena los registros x1 *(Link Register)* y x2 en las posiciones de memoria apuntadas por sp
    - El ! indica actualizaci�n ***pre-indexada***, es decir, primero decrementa sp y despu�s almacena los registros
2) **ldp x1, x2, [sp], n:** La instrucci�n ldp es una sentencia de carga de dos de registros que realiza:
    - Carga dos registros (x1 y x2) desde el *stack*
    - Incrementa el sp *(puntero de pila)* en 16 bytes ``([sp], 16)``
    - Utiliza direccionamiento post-indexado (primero carga, luego actualiza SP)

Aprendimos sobre estas sentencias **[aqu�](https://developer.arm.com/documentation/102374/0102/Loads-and-stores---load-pair-and-store-pair)**

#### �Por qu� usamos estas instrucciones?

Estas instrucciones las usamos debido a c�modidad para manipulaci�n de registros, ya que ambas instrucciones podr�an ser reemplazadas con sentencias puras de LEGv8, pero en lugar de 1 *(una)* l�nea de c�digo ser�an 3 *(tres)*.

#### "Equivalencias" en LEGv8

- ARMv8:

```javascript
stp x30, x12, [sp, -16]!

ldp x30, x12, [sp], 16
```

- LEGv8:

```javascript
sub sp, sp, #16
stur x30, [sp, #8]
stur x12, [sp, #0]

ldur x12, [sp, #0]
ldur x30, [sp, #8]
add sp, sp, #16
```
