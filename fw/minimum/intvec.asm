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
		.input		"../ctc/ctc.inc"
		.input		"../sio/sio.inc"

INTVEC		.sect		W		; No writes
		.align		8		; Must be at a page boundary
intvec:		.equ		$
		.block		IVCNT_CTC
		.block		IVCNT_SIO

		.byte		"!intvec!"
		.end
