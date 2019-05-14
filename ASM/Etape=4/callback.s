; ce programme est pour l'assembleur RealView (Keil)
	thumb
	
	include etat.inc
		
	extern StructSon
	extern Position
	
TIM3_CCR3	equ	0x4000043C	; adresse registre PWM

	area  moncode, code, readonly
	export callback
;
callback	proc
	ldr r0,=StructSon; on charge la valeur de la structure son
	ldr r1, =TIM3_CCR3
	ldr r2,[r0] ;la valeur du premier champ:position
	ldr r3,[r0, #E_TAI];la valeur du second champ : taille
	cmp r2,r3 ;on continue si position < taille
	bhs silence
	push {r4}
	push {r5}
		ldr r4, [r0,#E_SON]
		ldrsh r12 ,[r4, r2, LSL #1]
		add r12, #0x8000;
		ldr r5, [r0, #E_RES]
		mul r12,r5
		lsr r12,#16
		add r2,#1 ;on ajoute 1
		str r2,[r0] 
		str r12,[r1]
		pop {r5}
		pop{r4} ;
		b	fin
		
silence ldr r12, [r0, #E_RES]
		lsr r12, #1
		str r12,[r1]
		B fin
		
fin	bx	lr	; dernière instruction de la fonction
	endp
;
	end