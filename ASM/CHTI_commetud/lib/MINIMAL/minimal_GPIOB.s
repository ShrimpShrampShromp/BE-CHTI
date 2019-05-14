	thumb
	area	moncode, code, readonly

RCC_APB2ENR		equ	0x40021018	
RCC_APB2ENR_IOPBEN	equ	8
GPIOB			equ	0x40010C00	; GPIO B base address (page 51)
GPIOx_CRL		equ	0x00	; config lo register (ports 7:0)
GPIOx_CRH		equ	0x04	; config hi register (ports 15:8)
GPIOx_BSRR		equ	0x10	; Bit Set/Reset register (page 188)
GPIOx_ODR		equ	0x0C	; Output register

	export	GPIO_B_init
;
GPIO_B_init proc
	ldr	r3, =RCC_APB2ENR	; horloge pour GPIO B
	ldr	r0, [r3]
	orr	r0, #RCC_APB2ENR_IOPBEN
	str	r0, [r3]
	ldr	r3, =GPIOB
	mov	r0, #0x33333333		; push-pull output config
	str	r0, [r3, #GPIOx_CRL]	; bits PB7 ... PB0
	bx	lr
	endp
;
	export	GPIO_B_set
GPIO_B_set proc			; indice du bit (0 a 7) dans r0
	ldr	r3, =GPIOB
	movs	r1, #1
	movs	r0, r1, LSL r0
	str	r0, [r3, #GPIOx_BSRR]
	bx	lr
	endp
;
	export	GPIO_B_reset
GPIO_B_reset proc		; indice du bit (0 a 7) dans r0
	ldr	r3, =GPIOB
	movs	r1, #1
	adds	r0, #16	
	movs	r0, r1, LSL r0
	str	r0, [r3, #GPIOx_BSRR]
	bx	lr
	endp
	end