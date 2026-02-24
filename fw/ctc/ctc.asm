; ==============
;
; CTC Library - BAUD rate generation and periodic interrupt.
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;
			.list	1
			.input	"cmn/stddef.inc"
			.input	"cmn/board.inc"

			.list	2
			.input	"ctc.inc"

			.eject
TEXT			.sect	W

; ----------------------
; BAUD Rate divide counter values for 3,686,400Hz Osc
;
; SIO x16 Mode
; -----------
BC115200		.equ	2
BC76800			.equ	3
BC57600			.equ	4
BC38400			.equ	6
BC28800			.equ	8
BC19200			.equ	12
BC14400			.equ	16
BC9600			.equ	24
BC7200			.equ	32
BC4800			.equ	48
BC3600			.equ	64
BC2400			.equ	96
BC1800			.equ	128
BC1200			.equ	192
BC900			.equ	256
;
CTC_VECT_LD		.equ	11111000b	; Mask to load the vector (to CH0)
CTC_CONT_LD		.equ	00000001b	; Bit 0 ON to load control in register

_ctc_inittab:	; Values to be written to the CTC starting with REG0
		.byte	01000100b		; CTC0: No interrupt, Divider next
		.byte	BC9600
		.byte	01000100b		; CTC1: No interrupt, Divider next
		.byte	BC115200
		.byte	01000100b		; CTC2: No interrupt, Divider next
		.byte	0			;  divide by 256
		.byte	01000100b		; CTC3: No interrupt (for now), Divider next
		.byte	240			;  divide by 240 (256*240=61,440 gives 60Hz interrupt)
_ctc_it_len:	.equ	$-_ctc_inittab

ctc_minit:	; Initialize the CTC. Input clock is 3,686,400
			; E: Interrupt Vector Base
			;  CH0: SIO CHa BAUD. Target 9600 (/384 : (/24 /16))
			;  CH1: SIO CHb BAUD. Target 115200 (/32 : (/2 /16))
			;  CH2: Prescale for CH3 (256)
			;  CH3: Periodic interrupt. Target 60Hz (CH2 / 240)
			;  (interrupt not enabled in init)
		ld	c,CTCCH0
		ld	a,CTC_VECT_LD
		and	e
		out	(c),a
		;
		ld	hl,_ctc_inittab
		ld	b,4
_minit1:	; Init the 4 channels
		ld	a,(hl)
		out	(c),a
		inc	hl
		ld	a,(hl)
		out	(c),a
		inc	hl
		inc	c
		djnz	_minit1
		;
		ret


; Do nothing ISR to put in IVT for CH0-2
ctc_isr_nop:	reti

; ISR for periodic interrupt (60Hz)
ctc_isr_pi:	reti				; ZZZ - TODO


		.byte	"!ctc!"
		.end
