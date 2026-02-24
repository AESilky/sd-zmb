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
			.input	"sio.inc"

			.list	1
			.input	"../cmn/board.inc"

			.eject
BSS			.sect
_cha_r3			.block	BYTE
_cha_r5			.block	BYTE
_chb_r3			.block	BYTE
_chb_r5			.block	BYTE

TEXT			.sect	W

SIO_CMD_RST		.equ	00011000b	; Channel reset
;
SIO_R1_INT_EXT_BIT	.equ	1
SIO_R1_INT_EXT_MSK	.equ	00000001b
SIO_R1_INT_EXT_EN	.equ	00000001b	; External Status Interrupts
SIO_R1_INT_TX_BIT	.equ	2
SIO_R1_INT_TX_MSK	.equ	00000010b
SIO_R1_INT_TX_EN	.equ	00000010b	; Transmitter Interrupts
SIO_R1_INT_SEV_BIT	.equ	3
SIO_R1_INT_SEV_MSK	.equ	00000100b
SIO_R1_INT_SEV_EN	.equ	00000100b	; Status Effects Vector
SIO_R1_INT_RX_MSK	.equ	00011000b	; RX Interrupt Mode
SIO_R1_INT_RX_1ST	.equ	00001000b	;  RX Int on 1st char
SIO_R1_INT_RX_ALLPEV	.equ	00010000b	;  RX Int on all chars, parity effects vector
SIO_R1_INT_RX_ALL	.equ	00011000b	;  RX Int on all chars
;
; R2 is Interrupt Vector - CH-B ONLY
;
SIO_R3_RX_EN_BIT	.equ	1
SIO_R3_RX_EN_MSK	.equ	00000001b
SIO_R3_RX_EN		.equ	00000001b
SIO_R3_RX_5BITS		.equ	00000000b	; 5 Bits per character
SIO_R3_RX_6BITS		.equ	10000000b	; 6 Bits per character
SIO_R3_RX_7BITS		.equ	01000000b	; 7 Bits per character
SIO_R3_RX_8BITS		.equ	11000000b	; 8 Bits per character
;
SIO_R4_NOPARITY		.equ	00000000b	; No parity
SIO_R4_OPARITY		.equ	00000001b	; Odd parity
SIO_R4_EPARITY		.equ	00000011b	; Even parity
SIO_R4_SYNCSTOP		.equ	00000000b	; Synchronous (0 stop bits)
SIO_R4_10STOP		.equ	00000100b	; 1 stop bit
SIO_R4_15STOP		.equ	00001000b	; 1.5 stop bits
SIO_R4_20STOP		.equ	00001100b	; 2 stop bits
SIO_R4_08SYNC		.equ	00000000b	; 8-bit Pgrm Sync
SIO_R4_16SYNC		.equ	00010000b	; 16-bit Pgrm Sync
SIO_R4_SDLC		.equ	00100000b	; SDLC mode
SIO_R4_EXSYNC		.equ	00110000b	; External Sync
SIO_R4_01CLK		.equ	00000000b	; x1 Clock
SIO_R4_16CLK		.equ	01000000b	; x16 Clock
SIO_R4_32CLK		.equ	10000000b	; x32 Clock
SIO_R4_64CLK		.equ	11000000b	; x64 Clock
;
SIO_R5_TXCRC_EN_BIT	.equ	1
SIO_R5_TXCRC_EN_MSK	.equ	00000001b
SIO_R5_RTS_BIT		.equ	2
SIO_R5_RTS_MSK		.equ	00000010b
SIO_R5_TX_EN_BIT	.equ	4
SIO_R5_TX_EN_MSK	.equ	00001000b
SIO_R5_TX_EN		.equ	00000001b
SIO_R5_BRK_BIT		.equ	5		; Send BREAK
SIO_R5_BRK_MSK		.equ	00010000b
SIO_R5_DTR_BIT		.equ	8
SIO_R5_DTR_MSK		.equ	10000000b
SIO_R5_TX_5BITS		.equ	00000000b	; 5 Bits per character
SIO_R5_TX_6BITS		.equ	01000000b	; 6 Bits per character
SIO_R5_TX_7BITS		.equ	00100000b	; 7 Bits per character
SIO_R5_TX_8BITS		.equ	01100000b	; 8 Bits per character
;
SIO_IV_REG		.equ	2		; Interrupt Vector is only in CH-B
SIO_IV_MSK		.equ	11110000b

CHA_R3_INIT		.equ	SIO_R3_RX_EN|SIO_R3_RX_8BITS
CHA_R5_INIT		.equ	SIO_R5_TX_EN|SIO_R5_TX_8BITS
_sio_cha_tbl		.byte	004h		; Reg4 Serial Format
			.byte	SIO_R4_16CLK|SIO_R4_10STOP|SIO_R4_NOPARITY
			.byte	001h		; Reg1 Interrupt Mode
			.byte	000h		;  no interrupts for basic init
			.byte	003h		; Reg3 Receive
			.byte	CHA_R3_INIT
			.byte	005h		; Reg5 Transmit (no HDSK bits)
			.byte	CHA_R5_INIT
_sio_cha_tbl_len	.equ	$-_sio_cha_tbl
;
CHB_R3_INIT		.equ	SIO_R3_RX_EN|SIO_R3_RX_8BITS
CHB_R5_INIT		.equ	SIO_R5_TX_EN|SIO_R5_TX_8BITS
_sio_chb_tbl		.byte	004h		; Reg4 Serial Format
			.byte	SIO_R4_16CLK|SIO_R4_10STOP|SIO_R4_NOPARITY
			.byte	001h		; Reg1 Interrupt Mode
			.byte	000h		;  no interrupts for basic init
			.byte	003h		; Reg3 Receive
			.byte	CHB_R3_INIT
			.byte	005h		; Reg5 Transmit (no HDSK bits)
			.byte	CHB_R5_INIT
_sio_chb_tbl_len	.equ	$-_sio_chb_tbl


sio_minit:		; Initialize the SIO for basic operation. No interrupts to start.
			;  Interrupt Vector base is in E
			ld	a,SIO_CMD_RST	; Reset both channels for initialization
			out	(SIOACTRL),a
			out	(SIOBCTRL),a
			; Load the Interrupt Vector and read it back as a test
			ld	a,SIO_IV_REG
			out	(SIOBCTRL),a
			ld	a,e
			and	SIO_IV_MSK
			ld	e,a		; save masked value for verification
			out	(SIOBCTRL),a
			; Read it back and compare
			ld	a,SIO_IV_REG
			out	(SIOBCTRL),a
			in	a,(SIOBCTRL)
			cp	e
			ret	nz		; ERROR!
			;
			; The IV is loaded. Now we can init the rest of the SIO
			;
			ld	c,SIOACTRL
			ld	b,_sio_cha_tbl_len
			ld	hl,_sio_cha_tbl
			otir
			ld	a,CHA_R3_INIT
			ld	(_cha_r3),a
			ld	a,CHA_R5_INIT
			ld	(_cha_r5),a
			ld	c,SIOBCTRL
			ld	b,_sio_chb_tbl_len
			ld	hl,_sio_chb_tbl
			otir
			ld	a,CHB_R3_INIT
			ld	(_chb_r3),a
			ld	a,CHB_R5_INIT
			ld	(_chb_r5),a
			;
			ret

sio_a_isr_esc:	; SIO CHA External Status Change
			reti

sio_a_isr_rxc:	; SIO CHA Receive Character
			reti

sio_a_isr_src:	; SIO CHA Special Receive Condition
			reti

sio_a_isr_txe:	; SIO CHA TX Buffer Empty
			reti


sio_b_isr_esc:	; SIO CHB External Status Change
			reti

sio_b_isr_rxc:	; SIO CHB Receive Character
			reti

sio_b_isr_src:	; SIO CHB Special Receive Condition
			reti

sio_b_isr_txe:	; SIO CHB TX Buffer Empty
			reti


sio_a_rts_clr:		; Clear CH-A RTS
			ld	a,5
			out	(SIOACTRL),a		; ZZZ - Disable Ints needed between 'outs'?
			ld	a,(_cha_r5)
			res	SIO_R5_RTS_BIT,a
			ld	(_cha_r5),a
			out	(SIOACTRL),a
			ret

sio_a_rts_set:		; Set CH-A RTS
			ld	a,5
			out	(SIOACTRL),a		; ZZZ - Disable Ints needed between 'outs'?
			ld	a,(_cha_r5)
			set	SIO_R5_RTS_BIT,a
			ld	(_cha_r5),a
			out	(SIOACTRL),a
			ret

sio_b_rts_clr:		; Clear CH-B RTS
			ld	a,5
			out	(SIOBCTRL),a		; ZZZ - Disable Ints needed between 'outs'?
			ld	a,(_chb_r5)
			res	SIO_R5_RTS_BIT,a
			ld	(_chb_r5),a
			out	(SIOBCTRL),a
			ret

sio_b_rts_set:		; Set CH-B RTS
			ld	a,5
			out	(SIOBCTRL),a		; ZZZ - Disable Ints needed between 'outs'?
			ld	a,(_chb_r5)
			set	SIO_R5_RTS_BIT,a
			ld	(_chb_r5),a
			out	(SIOBCTRL),a
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

			.byte	"!sio!"
			.end
