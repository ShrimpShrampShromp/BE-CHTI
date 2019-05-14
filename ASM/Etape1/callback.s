; ce programme est pour l'assembleur RealView (Keil)
	thumb

	extern etat
	
GPIOB_BSRR	equ	0x40010C10	; Bit Set/Reset register

	area  moncode, code, readonly
	export callback
;
callback	proc
	ldr r0,=etat; on change la valeur de etat
	ldr r2,[r0]
	cmp r2, #0x00000001
	beq misea0
; mise a 1 de PB1
misea1	ldr	r3, =GPIOB_BSRR
		mov	r1, #0x00000002
		str	r1, [r3]
		add r2,#1;
		str r2,[r0]
		b	fin
		
; mise a zero de PB1
misea0	ldr	r3, =GPIOB_BSRR
		mov	r1, #0x00020000
		str	r1, [r3]
		sub r2,#1;
		str r2,[r0]

fin	bx	lr	; dernière instruction de la fonction
	endp
;
	end