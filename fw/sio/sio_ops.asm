; ==============
;
; SIO Operations Library - Functional Routines that use the SIO.
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;
			.list	1
			.input	"../cmn/stddef.inc"

			.list	2
			.input	"sio_i.inc"
			.input	"sio_ops.inc"

			.list	1
			.input	"sio.inc"
			.input	"../cmn/board.inc"

			.eject
RX_BUF_LEN		.equ	8
BBS			.sect
_arx_buf:		.block	RX_BUF_LEN	; Buffer to put received chars in
_arx_h:			.block	BYTE
_arx_t:			.block	BYTE
_brx_buf:		.block	RX_BUF_LEN	; Buffer to put received chars in
_brx_h:			.block	BYTE
_brx_t:			.block	BYTE

TEXT			.sect	W

sio_ops_minit:		; Initialize the SIO for basic operation. No interrupts to start.
			xor	a		; zero the head/tail offsets for the rx buffs
			ld	(_arx_h),a
			ld	(_arx_t),a
			ld	(_brx_h),a
			ld	(_brx_t),a
			ret


_hndlr_ret:		; Return from our level-1 interrupt handlers.
			; This method is JUMP'ed to, not CALL'ed
			;
			;  The root handlers pushed HL in order to perform
			;  a programmable jump. The RETI is required to clear
			;  the interrupt in the Z-Peripheral chips.
			pop	hl
			ret

_hndlr_reti:		; Return from our level-0 interrupt handlers.
			; This method is JUMP'ed to, not CALL'ed
			;
			;  The root handlers pushed HL in order to perform
			;  a programmable jump. The RETI is required to clear
			;  the interrupt in the Z-Peripheral chips.
			pop	hl
			ei
			reti

_hndlr_0to1:		; Transition from interrupt level 0 (directly from source and
			; interrupts disabled) to level 1 (still handling interrupt,
			; but chip allowed to return and interrupts re-enabled).
			;
			; This method is CALL'ed, such that it returns to continue
			; servicing the original interrupt.
			ei
			reti


_hndl_a_esc:		; Handle CH-A RX External Status Change
			;  entered with HL pushed on stack
			; ZZZ: implement
			jp	_hndlr_ret

_hndl_a_rxc:		; Handle CH-A RX Char Available
			;  entered with HL pushed on stack
			push	af
			push	bc		; we'll use BC in reading the character
			ld	b,RX_BUF_LEN	; max number of chars we will read
			ld	hl,_arx_buf
_hndl_a_rxc1:		in	a,(SIOACTRL)
			and	RR0_RX_CHAR_MSK
			jr	z,_hndl_a_rxc2
			in	a,(SIOADATA)
			ld	(hl),a
			inc	hl
			dec	b
			jr	z,_hndl_a_rxc2	; this is as many chars as we can take
_hndl_a_rxc2:
			ld	a,RX_BUF_LEN
			sub	b		; get the number of chars received
			ld	(_arx_cnt),a
			ld	b,a
			ld	hl,_arx_buf
			jp	_hndlr_ret

_hndl_a_src:		; Handle CH-A Special Receive Condition
			;  entered with HL pushed on stack
			jp	_hndlr_ret

_hndl_a_txe:		; Handle CH-A TX Empty
			;  entered with HL pushed on stack
			jp	_hndlr_ret

_hndl_b_esc:		; Handle CH-A RX External Status Change
			;  entered with HL pushed on stack
			; ZZZ: implement
			jp	_hndlr_ret

_hndl_b_rxc:		; Handle CH-A RX Char Available
			;  entered with HL pushed on stack
			jp	_hndlr_ret

_hndl_b_src:		; Handle CH-A Special Receive Condition
			;  entered with HL pushed on stack
			jp	_hndlr_ret

_hndl_b_txe:		; Handle CH-A TX Empty
			;  entered with HL pushed on stack
			jp	_hndlr_ret


sio_a_putsni:		; Put a string. HL: String  B: Term char
			in	a,(SIOACTRL)
			and	RR0_TX_BUFMT_MSK
			jr	z,sio_a_putsni		; Loop until TX ready
			ld	a,(hl)
			cp	b			; End of string?
			ret	z
			out	(SIOADATA),a
			inc	hl
			jr	sio_a_putsni

sio_b_putsni:		; Put a string. HL: String  B: Term char
			in	a,(SIOBCTRL)
			and	RR0_TX_BUFMT_MSK
			jr	z,sio_b_putsni		; Loop until TX ready
			ld	a,(hl)
			cp	b			; End of string?
			ret	z
			out	(SIOBDATA),a
			inc	hl
			jr	sio_b_putsni

sio_a_runwint:		; Initialize CH-A to run with interrupts
			;  first, set the handlers
			ld	hl,_hndl_a_esc
			call	sio_set_hdlr_a_esc
			ld	hl,_hndl_a_rxc
			call	sio_set_hdlr_a_rcx
			ld	hl,_hndl_a_src
			call	sio_set_hdlr_a_src
			ld	hl,_hndl_a_txe
			call	sio_set_hdlr_a_txe
			;  now, enable the channel
			call	sio_a_ext_ei
			or	1		; NZ: Parity is SRC
			call	sio_a_rxc_ei
			call	sio_a_txc_ei
			ret			; could use JP above

sio_b_runwint:		; Initialize CH-A to run with interrupts
			;  first, set the handlers
			ld	hl,_hndl_b_esc
			call	sio_set_hdlr_b_esc
			ld	hl,_hndl_b_rxc
			call	sio_set_hdlr_b_rcx
			ld	hl,_hndl_b_src
			call	sio_set_hdlr_b_src
			ld	hl,_hndl_b_txe
			call	sio_set_hdlr_b_txe
			;  now, enable the channel
			call	sio_b_ext_ei
			or	1		; NZ: Parity is SRC
			call	sio_b_rxc_ei
			call	sio_b_txc_ei
			ret			; could use JP above

