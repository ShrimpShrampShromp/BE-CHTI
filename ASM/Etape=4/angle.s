	thumb
		
	extern TabCos
	extern TabSin
	
	area  moncode, code, readonly
	export sommeangle
;
sommeangle	proc
	ldr r1,=TabCos; on charge la valeur de tabcos, l'argument est dans r0?
	ldr r2, =TabSin; tabsin
	push {r4}
	push {r5}
	ldrsh r4, [r1, r0, LSL #1] ;on met le arg-ième cos dans r4
	ldrsh r5, [r2, r0, LSL #1] ;on met le arg-ieme sin dans r5
	mov r12, #0x0000
	mla r12, r4, r4, r12 ;on ajoute cos*cos
	mla r12, r5, r5, r12; on ajoute sin*sin
	mov r0, r12
	pop {r5}
	pop {r4}
fin	bx	lr	; dernière instruction de la fonction
	endp
;
	end