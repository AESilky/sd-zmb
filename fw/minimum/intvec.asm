; ==============
;
; ZMB (Z80 Main Board) Minimum Boot-Up Interrupt Vector Table (IM2)
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============

		.stitle		"Interrupt Vector Table"

		.input		"intvec.inc"
		.list		1	; Don't list these includes
		.input		"cmn/stddef.inc"
		.input		"ctc/ctc.inc"
		.input		"sio/sio.inc"

INTVEC		.sect		W		; No writes
		.align		8		; Must be at a page boundary
intvec:		.equ		$
ivt_sio:	; SIO low-nibble must be 0
		.word		sio_b_isr_txe	; SIO CHB TX Buffer Empty
		.word		sio_b_isr_esc	; SIO CHB External Status Change
		.word		sio_b_isr_rxc	; SIO CHB Receive Character
		.word		sio_b_isr_src	; SIO CHB Special Receive Condition
		.word		sio_a_isr_txe	; SIO CHA TX Buffer Empty
		.word		sio_a_isr_esc	; SIO CHA External Status Change
		.word		sio_a_isr_rxc	; SIO CHA Receive Character
		.word		sio_a_isr_src	; SIO CHA Special Receive Condition
ivt_ctc:	.word		ctc_isr_nop	; CTC CH0
		.word		ctc_isr_nop	; CTC CH1
		.word		ctc_isr_nop	; CTC CH2
		.word		ctc_isr_pi	; CTC CH3
		;
_intvece:	.equ		$
		.if	(_intvece-intvec)-((IVCNT_SIO+IVCNT_CTC)*WORD)	; Check the size
			.error	"INTVEC Size!"
		.endif

		.byte		"!intvec!"
		.end
