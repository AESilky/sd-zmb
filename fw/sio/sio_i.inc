; ==============
;
; SIO Internal Definitions.
;
; This file is intended to only be included by SIO modules. Using, and
; especially using, the SIO registers directly can interfere with the SIO
; modules operation.
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;

; WR0 Commands are bits 3..5
CMD_NOP		.equ	00000000b	; 0: NOP (used when setting other bits)
CMD_SEND_ABORT	.equ	00001000b	; 1: Send ABORT (SDLC)
CMD_CLR_ESI	.equ	00010000b	; 2: Clear External Status Int
CMD_RST		.equ	00011000b	; 3: Channel reset
CMD_INT_NRXC	.equ	00100000b	; 4: Interrupt on Next RX Char
CMD_RST_TXIP	.equ	00101000b	; 5: Reset TX Int Pending
CMD_RST_CHERR	.equ	00110000b	; 6: Reset Char Errors (Parity, Overrun)
CMD_RETI	.equ	00111000b	; 7: Return from Interrupt (CH-A only)
;
; RR0 contains channel status
;
RR0_RX_CHAR_BIT		.equ	1		; Character Available
RR0_RX_CHAR_MSK		.equ	00000001b
RR0_INT_PEND_BIT	.equ	2		; Interrupt Pending (CH-A ONLY)
RRO_INT_PEND_MSK	.equ	00000010b
RR0_TX_BUFMT_BIT	.equ	3		; TX Buffer Empty
RR0_TX_BUFMT_MSK	.equ	00000100b
RR0_DCD_BIT		.equ	4		; DCD Input
RR0_DCD_MSK		.equ	00001000b
RR0_SYNC_BIT		.equ	5		; SYNC/Hunt
RR0_SYNC_MSK		.equ	00010000b
RR0_CTS_BIT		.equ	6		; CTS Input
RR0_CTC_MSK		.equ	00100000b
RR0_TX_UNDR_BIT		.equ	7		; TX Underrun/EOM
RR0_TX_UNDR_MSK		.equ	01000000b
RR0_RX_BRK_BIT		.equ	8		; RX Break/Abort
RR0_RX_BRK_MSK		.equ	10000000b
;
; R0 is (primarily) for Register Index: D2..0
;    Additionally,
;	Command: D5..3
;	CRC and TX Underrun Reset: D7..6
;
;
; R1 is Interrupt Control
;
R1_INTCTRL		.equ	1
R1_INT_NONE		.equ	0
R1_INT_EXT_BIT		.equ	1
R1_INT_EXT_MSK		.equ	00000001b
R1_INT_EXT_EN		.equ	00000001b	; External Status Interrupts
R1_INT_TX_BIT		.equ	2
R1_INT_TX_MSK		.equ	00000010b
R1_INT_TX_EN		.equ	00000010b	; Transmitter Interrupts
R1_INT_SEV_BIT		.equ	3
R1_INT_SEV_MSK		.equ	00000100b
R1_INT_SEV_EN		.equ	00000100b	; Status Effects Vector
R1_INT_RX_MSK		.equ	00011000b	; RX Interrupt Mode
R1_INT_RX_1ST		.equ	00001000b	;  RX Int on 1st char
R1_INT_RX_ALLPEV	.equ	00010000b	;  RX Int on all chars, parity effects vector
R1_INT_RX_ALL		.equ	00011000b	;  RX Int on all chars
;
; R2 is Interrupt Vector - CH-B ONLY
;
R2_INTVECT		.equ	2		; Interrupt Vector
IV_MSK			.equ	11110000b	; Assure that the low nibble is 0
;
; R3 is Async RX Enable and Bits per Char
;
R3_RX_EN_CHRSZ		.equ	3
R3_RX_EN_BIT		.equ	1
R3_RX_EN_MSK		.equ	00000001b
R3_RX_EN		.equ	00000001b
R3_RX_5BITS		.equ	00000000b	; 5 Bits per character
R3_RX_6BITS		.equ	10000000b	; 6 Bits per character
R3_RX_7BITS		.equ	01000000b	; 7 Bits per character
R3_RX_8BITS		.equ	11000000b	; 8 Bits per character
;
; R4 is Char Format and Async Clock
;
R4_CHRFMT_CLK		.equ	4
R4_NOPARITY		.equ	00000000b	; No parity
R4_OPARITY		.equ	00000001b	; Odd parity
R4_EPARITY		.equ	00000011b	; Even parity
R4_SYNCSTOP		.equ	00000000b	; Synchronous (0 stop bits)
R4_10STOP		.equ	00000100b	; 1 stop bit
R4_15STOP		.equ	00001000b	; 1.5 stop bits
R4_20STOP		.equ	00001100b	; 2 stop bits
R4_08SYNC		.equ	00000000b	; 8-bit Pgrm Sync
R4_16SYNC		.equ	00010000b	; 16-bit Pgrm Sync
R4_SDLC			.equ	00100000b	; SDLC mode
R4_EXSYNC		.equ	00110000b	; External Sync
R4_01CLK		.equ	00000000b	; x1 Clock
R4_16CLK		.equ	01000000b	; x16 Clock
R4_32CLK		.equ	10000000b	; x32 Clock
R4_64CLK		.equ	11000000b	; x64 Clock
;
; R5 is Async TX Enable and Bits per Char
;
R5_TX_EN_CHRSZ		.equ	5
R5_TXCRC_EN_BIT		.equ	1
R5_TXCRC_EN_MSK		.equ	00000001b
R5_RTS_BIT		.equ	2
R5_RTS_MSK		.equ	00000010b
R5_TX_EN_BIT		.equ	4
R5_TX_EN_MSK		.equ	00001000b
R5_TX_EN		.equ	00000001b
R5_BRK_BIT		.equ	5		; Send BREAK
R5_BRK_MSK		.equ	00010000b
R5_DTR_BIT		.equ	8
R5_DTR_MSK		.equ	10000000b
R5_TX_5BITS		.equ	00000000b	; 5 Bits per character
R5_TX_6BITS		.equ	01000000b	; 6 Bits per character
R5_TX_7BITS		.equ	00100000b	; 7 Bits per character
R5_TX_8BITS		.equ	01100000b	; 8 Bits per character
