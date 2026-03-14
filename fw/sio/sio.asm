; ==============
;
; SIO Library - CH-A and CH-B Serial.
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
			.input	"sio.inc"

			.list	1
			.input	"../cmn/board.inc"

			.eject
BSS			.sect
; SIO Register backing (must be in order of init table)
;  CH-A
_cha_chfmt_bits:	.block	BYTE	; R4 Char format and Clk divider
_cha_int_ctrl:		.block	BYTE	; R1 Interrupt Control
_cha_rxen:		.block	BYTE	; R3 RX Enable and Bits/Char
_cha_txen:		.block	BYTE	; R5 TX Enable and Bits/Char
;  CH-B
_chb_chfmt_bits:	.block	BYTE	; R4 Char format and Clk divider
_chb_int_ctrl:		.block	BYTE	; R1 Interrupt Control
_chb_rxen:		.block	BYTE	; R3 RX Enable and Bits/Char
_chb_txen:		.block	BYTE	; R5 TX Enable and Bits/Char
;
; Interrupt handlers
hdlr_cha_esc:		.block	WORD
hdlr_cha_rxc:		.block	WORD
hdlr_cha_src:		.block	WORD
hdlr_cha_txe:		.block	WORD
hdlr_chb_esc:		.block	WORD
hdlr_chb_rxc:		.block	WORD
hdlr_chb_src:		.block	WORD
hdlr_chb_txe:		.block	WORD


TEXT			.sect	W

;
;
CHA_RX_INIT		.equ	R3_RX_EN|R3_RX_8BITS
CHA_TX_INIT		.equ	R5_TX_EN|R5_TX_8BITS
_sio_cha_tbl		.byte	R4_CHRFMT_CLK	; Reg4 Serial Format
			.byte	R4_16CLK|R4_10STOP|R4_NOPARITY
			.byte	R1_INTCTRL	; Reg1 Interrupt Mode
			.byte	R1_INT_NONE	;  no interrupts for basic init
			.byte	R3_RX_EN_CHRSZ	; Reg3 Receive
			.byte	CHA_RX_INIT
			.byte	R5_TX_EN_CHRSZ	; Reg5 Transmit (no HDSK bits)
			.byte	CHA_TX_INIT
_sio_cha_tbl_len	.equ	$-_sio_cha_tbl
;
CHB_RX_INIT		.equ	R3_RX_EN|R3_RX_8BITS
CHB_TX_INIT		.equ	R5_TX_EN|R5_TX_8BITS
_sio_chb_tbl		.byte	R4_CHRFMT_CLK	; Reg4 Serial Format
			.byte	R4_16CLK|R4_10STOP|R4_NOPARITY
			.byte	R1_INTCTRL	; Reg1 Interrupt Mode
			.byte	R1_INT_NONE	;  no interrupts for basic init
			.byte	R3_RX_EN_CHRSZ	; Reg3 Receive
			.byte	CHB_RX_INIT
			.byte	R5_TX_EN_CHRSZ	; Reg5 Transmit (no HDSK bits)
			.byte	CHB_TX_INIT
_sio_chb_tbl_len	.equ	$-_sio_chb_tbl


sio_minit:		; Initialize the SIO for basic operation. No interrupts to start.
			;  Interrupt Vector base is in E
			ld	a,CMD_RST	; Reset both channels for initialization
			out	(SIOACTRL),a
			out	(SIOBCTRL),a
			; Load the Interrupt Vector and read it back as a test
			ld	a,R2_INTVECT
			out	(SIOBCTRL),a
			ld	a,e
			and	IV_MSK
			ld	e,a		; save masked value for verification
			out	(SIOBCTRL),a
			; Read it back and compare
			ld	a,R2_INTVECT
			out	(SIOBCTRL),a
			in	a,(SIOBCTRL)
			cp	e
			ret	nz		; ERROR!
			;
			; The IV is loaded. Now we can init the rest of the SIO
			;
			;  Init CH-A
			;   output to the SIO and save in the backing
			ld	c,SIOACTRL
			ld	b,_sio_cha_tbl_len
			ld	hl,_sio_cha_tbl
			ld	de,_cha_chfmt_bits
_cha_init:		;
			bit	0,b
			jr	z,_cha_init2
			ld	a,(hl)
			ld	(de),a
			inc	de
_cha_init2:		outi
			jr	nz,_cha_init
			;  Init CH-B
			;   output to the SIO and save in the backing
			ld	c,SIOBCTRL
			ld	b,_sio_chb_tbl_len
			ld	hl,_sio_chb_tbl
			ld	de,_chb_chfmt_bits
_chb_init:		;
			bit	0,b
			jr	z,_chb_init2
			ld	a,(hl)
			ld	(de),a
			inc	de
_chb_init2:		outi
			jr	nz,_chb_init
			;
			; Set the initial ISR handlers to the NOP handler
			ld	hl,_isr_nop_hdlr
			ld	(hdlr_cha_esc),hl
			ld	(hdlr_cha_rxc),hl
			ld	(hdlr_cha_src),hl
			ld	(hdlr_cha_txe),hl
			ld	(hdlr_chb_esc),hl
			ld	(hdlr_chb_rxc),hl
			ld	(hdlr_chb_src),hl
			ld	(hdlr_chb_txe),hl
			;
			ret


sio_a_getc:		; Get Char - No Wait (ret Z if none)
			in	a,(SIOACTRL)
			and	RR0_RX_CHAR_MSK
			ret	z
			; NZ indicates char was available
			in	a,(SIOADATA)
			ret

sio_a_getcw:		; Get Char - B non-zero to wait for character
			in	a,(SIOACTRL)
			and	RR0_RX_CHAR_MSK
			jr	nz,_a_getcw
			; No char, see if wait requested
			or	b
			jr	nz,sio_a_getcw
			ret	; Z indicates no char available
_a_getcw:		; NZ indicates char was available
			in	a,(SIOADATA)
			ret

sio_a_putc:		; Put Char if possible. Char in C. Z if TX not ready
			in	a,(SIOACTRL)
			and	RR0_TX_BUFMT_MSK
			ret	z
			; NZ indicates char was sent
			ld	a,c
			out	(SIOADATA),a
			ret

sio_a_putcw:		; Put Char if possible. Char in C. If not ready, wait if B NZ
			in	a,(SIOACTRL)
			and	RR0_TX_BUFMT_MSK
			jr	nz,_a_putcw
			or	b
			jr	nz,sio_a_putcw
			ret	; Z indicates not ready
_a_putcw:		; NZ indicates char was sent
			ld	a,c
			out	(SIOADATA),a
			ret

sio_a_rts_clr:		; Clear CH-A RTS
			ld	a,R5_TX_EN_CHRSZ
			out	(SIOACTRL),a		; ZZZ - Disable Ints needed between 'outs'?
			ld	a,(_cha_txen)
			res	R5_RTS_BIT,a
			ld	(_cha_txen),a
			out	(SIOACTRL),a
			ret

sio_a_rts_set:		; Set CH-A RTS
			ld	a,R5_TX_EN_CHRSZ
			out	(SIOACTRL),a		; ZZZ - Disable Ints needed between 'outs'?
			ld	a,(_cha_txen)
			set	R5_RTS_BIT,a
			ld	(_cha_txen),a
			out	(SIOACTRL),a
			ret

sio_a_tx_mt:		; Check CH-A TX Empty
			in	a,(SIOACTRL)
			and	RR0_TX_BUFMT_MSK
			xor	RR0_TX_BUFMT_MSK	; Turn status into Z for empty
			ret

sio_b_getc:		; Get Char - No Wait (ret Z if none)
			in	a,(SIOBCTRL)
			and	RR0_RX_CHAR_MSK
			ret	z
			; NZ indicates char was available
			in	a,(SIOBDATA)
			ret

sio_b_getcw:		; Get Char - B non-zero to wait for character
			in	a,(SIOBCTRL)
			and	RR0_RX_CHAR_MSK
			jr	nz,_b_getcw
			; No char, see if wait requested
			or	b
			jr	nz,sio_b_getcw
			ret	; Z indicates no char available
_b_getcw:		; NZ indicates char was available
			in	a,(SIOBDATA)
			ret

sio_b_putc:		; Put Char if possible. Char in C. Z if TX not ready
			in	a,(SIOBCTRL)
			and	RR0_TX_BUFMT_MSK
			ret	z
			; NZ indicates char was sent
			ld	a,c
			out	(SIOBDATA),a
			ret

sio_b_putcw:		; Put Char if possible. Char in C. If not ready, wait if B NZ
			in	a,(SIOBCTRL)
			and	RR0_TX_BUFMT_MSK
			jr	nz,_b_putcw
			or	b
			jr	nz,sio_b_putcw
			ret	; Z indicates not ready
_b_putcw:		; NZ indicates char was sent
			ld	a,c
			out	(SIOADATA),a
			ret

sio_b_rts_clr:		; Clear CH-B RTS
			ld	a,R5_TX_EN_CHRSZ
			out	(SIOBCTRL),a		; ZZZ - Disable Ints needed between 'outs'?
			ld	a,(_chb_txen)
			res	R5_RTS_BIT,a
			ld	(_chb_txen),a
			out	(SIOBCTRL),a
			ret

sio_b_rts_set:		; Set CH-B RTS
			ld	a,R5_TX_EN_CHRSZ
			out	(SIOBCTRL),a		; ZZZ - Disable Ints needed between 'outs'?
			ld	a,(_chb_txen)
			set	R5_RTS_BIT,a
			ld	(_chb_txen),a
			out	(SIOBCTRL),a
			ret

sio_b_tx_mt:		; Check CH-B TX Empty
			in	a,(SIOBCTRL)
			and	RR0_TX_BUFMT_MSK
			xor	RR0_TX_BUFMT_MSK	; Turn status into Z for empty
			ret

sio_rts_clr:		; E 0=A 1=B
			dec	e
			jr	z,sio_b_rts_clr
			jr	sio_a_rts_clr

sio_rts_ctrl:		; A 0=CLR 1=SET, E 0=A 1=B
			or	a
			jr	z,sio_rts_set
			jr	sio_rts_clr

sio_rts_set:		; E 0=A 1=B
			dec	e
			jr	z,sio_b_rts_set
			jr	sio_a_rts_set


;
; Interrupt Methods
;
sio_a_ext_di:		; Disable CH-A External Interrupts
			ld	a,R1_INTCTRL
			out	(SIOACTRL),a
			ld	a,(_cha_int_ctrl)
			res	R1_INT_EXT_BIT,a
			out	(SIOACTRL),a
			ld	(_cha_int_ctrl),a
			ret

sio_a_ext_ei:		; Enable CH-A External Interrupts
			ld	a,R1_INTCTRL
			out	(SIOACTRL),a
			ld	a,(_cha_int_ctrl)
			set	R1_INT_EXT_BIT,a
			out	(SIOACTRL),a
			ld	(_cha_int_ctrl),a
			ret

sio_a_rxc_di:		; Disable CH-A RX Interrupts
			ld	a,R1_INTCTRL
			out	(SIOACTRL),a
			ld	a,(_cha_int_ctrl)
			and	R1_INT_RX_MSK
			out	(SIOACTRL),a
			ld	(_cha_int_ctrl),a
			ret

sio_a_rxc_ei:		; Enable CH-A RX Interrupts
			ld	a,R1_INTCTRL
			out	(SIOACTRL),a
			ld	a,(_cha_int_ctrl)
			;  parity is SRC?
			jr	z,_a_rxc_ei1
			and	R1_INT_RX_MSK
			or	R1_INT_RX_ALLPEV
			jr	_a_rxc_ei2
_a_rxc_ei1:		and	R1_INT_RX_MSK
			or	R1_INT_RX_ALL
_a_rxc_ei2:		out	(SIOACTRL),a
			ld	(_cha_int_ctrl),a
			ret

sio_a_txc_di:		; Disable CH-A TX Interrupts
			ld	a,R1_INTCTRL
			out	(SIOACTRL),a
			ld	a,(_cha_int_ctrl)
			res	R1_INT_TX_BIT,a
			out	(SIOACTRL),a
			ld	(_cha_int_ctrl),a
			ret

sio_a_txc_ei:		; Enable CH-A TX Interrupts
			ld	a,R1_INTCTRL
			out	(SIOACTRL),a
			ld	a,(_cha_int_ctrl)
			set	R1_INT_TX_BIT,a
			out	(SIOACTRL),a
			ld	(_cha_int_ctrl),a
			ret


sio_b_ext_di:		; Disable CH-B External Interrupts
			ld	a,R1_INTCTRL
			out	(SIOBCTRL),a
			ld	a,(_chb_int_ctrl)
			res	R1_INT_EXT_BIT,a
			out	(SIOBCTRL),a
			ld	(_chb_int_ctrl),a
			ret

sio_b_ext_ei:		; Enable CH-B External Interrupts
			ld	a,R1_INTCTRL
			out	(SIOBCTRL),a
			ld	a,(_chb_int_ctrl)
			set	R1_INT_EXT_BIT,a
			out	(SIOBCTRL),a
			ld	(_chb_int_ctrl),a
			ret

sio_b_rxc_di:		; Disable CH-B RX Interrupts
			ld	a,R1_INTCTRL
			out	(SIOBCTRL),a
			ld	a,(_chb_int_ctrl)
			and	R1_INT_RX_MSK
			out	(SIOBCTRL),a
			ld	(_chb_int_ctrl),a
			ret

sio_b_rxc_ei:		; Enable CH-B RX Interrupts
			ld	a,R1_INTCTRL
			out	(SIOBCTRL),a
			ld	a,(_chb_int_ctrl)
			;  parity is SRC?
			jr	z,_b_rxc_ei1
			and	R1_INT_RX_MSK
			or	R1_INT_RX_ALLPEV
			jr	_b_rxc_ei2
_b_rxc_ei1:		and	R1_INT_RX_MSK
			or	R1_INT_RX_ALL
_b_rxc_ei2:		out	(SIOBCTRL),a
			ld	(_chb_int_ctrl),a
			ret

sio_b_txc_di:		; Disable CH-B TX Interrupts
			ld	a,R1_INTCTRL
			out	(SIOBCTRL),a
			ld	a,(_chb_int_ctrl)
			res	R1_INT_TX_BIT,a
			out	(SIOBCTRL),a
			ld	(_chb_int_ctrl),a
			ret

sio_b_txc_ei:		; Enable CH-B TX Interrupts
			ld	a,R1_INTCTRL
			out	(SIOBCTRL),a
			ld	a,(_chb_int_ctrl)
			set	R1_INT_TX_BIT,a
			out	(SIOBCTRL),a
			ld	(_chb_int_ctrl),a
			ret


_isr_nop_hdlr:	; NOP Handler for an interrupt
			pop	hl			; HL pushed by vector routine
			reti


sio_a_isr_esc:	; SIO CHA External Status Change
			push	hl
			ld	hl,(hdlr_cha_esc)
			jp	(hl)			; Execute the handler

sio_clr_hdlr_a_esc:	; Clear handler for CHA RX External Status Change
			ld	hl,_isr_nop_hdlr
			ld	(hdlr_cha_esc),hl
			ret

sio_set_hdlr_a_esc:	; Set handler for CHA RX External Status Change
			ld	(hdlr_cha_esc),hl
			ret

sio_a_isr_rxc:	; SIO CHA Receive Character
			push	hl
			ld	hl,(hdlr_cha_rxc)
			jp	(hl)			; Execute the handler

sio_clr_hdlr_a_rcx:	; Clear handler for CHA Receive Character
			ld	hl,_isr_nop_hdlr
			ld	(hdlr_cha_rxc),hl
			ret

sio_set_hdlr_a_rcx:	; Set handler for CHA Receive Character
			ld	(hdlr_cha_rxc),hl
			ret

sio_a_isr_src:	; SIO CHA Special Receive Condition
			push	hl
			ld	hl,(hdlr_cha_src)
			jp	(hl)			; Execute the handler

sio_clr_hdlr_a_src:	; Clear handler for CHA Special Receive Condition
			ld	hl,_isr_nop_hdlr
			ld	(hdlr_cha_src),hl
			ret

sio_set_hdlr_a_src:	; Set handler for CHA Special Receive Condition
			ld	(hdlr_cha_src),hl
			ret

sio_a_isr_txe:	; SIO CHA TX Buffer Empty
			push	hl
			ld	hl,(hdlr_cha_txe)
			jp	(hl)			; Execute the handler

sio_clr_hdlr_a_txe:	; Clear handler for CHA TX Buffer Empty
			ld	hl,_isr_nop_hdlr
			ld	(hdlr_cha_txe),hl
			ret

sio_set_hdlr_a_txe:	; Set handler for CHA TX Buffer Empty
			ld	(hdlr_cha_txe),hl
			ret

sio_b_isr_esc:	; SIO CHB External Status Change
			push	hl
			ld	hl,(hdlr_chb_esc)
			jp	(hl)			; Execute the handler

sio_clr_hdlr_b_esc:	; Clear handler for CHB RX External Status Change
			ld	hl,_isr_nop_hdlr
			ld	(hdlr_chb_esc),hl
			ret

sio_set_hdlr_b_esc:	; Set handler for CHB RX External Status Change
			ld	(hdlr_chb_esc),hl
			ret

sio_b_isr_rxc:	; SIO CHB Receive Character
			push	hl
			ld	hl,(hdlr_chb_rxc)
			jp	(hl)			; Execute the handler

sio_clr_hdlr_b_rcx:	; Clear handler for CHB Receive Character
			ld	hl,_isr_nop_hdlr
			ld	(hdlr_chb_rxc),hl
			ret

sio_set_hdlr_b_rcx:	; Set handler for CHB Receive Character
			ld	(hdlr_chb_rxc),hl
			ret

sio_b_isr_src:	; SIO CHB Special Receive Condition
			push	hl
			ld	hl,(hdlr_chb_src)
			jp	(hl)			; Execute the handler

sio_clr_hdlr_b_src:	; Clear handler for CHB Special Receive Condition
			ld	hl,_isr_nop_hdlr
			ld	(hdlr_chb_src),hl
			ret

sio_set_hdlr_b_src:	; Set handler for CHB Special Receive Condition
			ld	(hdlr_chb_src),hl
			ret

sio_b_isr_txe:	; SIO CHB TX Buffer Empty
			push	hl
			ld	hl,(hdlr_chb_txe)
			jp	(hl)			; Execute the handler

sio_clr_hdlr_b_txe:	; Clear handler for CHB TX Buffer Empty
			ld	hl,_isr_nop_hdlr
			ld	(hdlr_chb_txe),hl
			ret

sio_set_hdlr_b_txe:	; Set handler for CHB TX Buffer Empty
			ld	(hdlr_chb_txe),hl
			ret


			.byte	"!SIO!"
			.end
