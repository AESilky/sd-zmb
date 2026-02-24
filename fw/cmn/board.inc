; ==============
;
; ZMB (Z80 Main Board) Board Level Definitions
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;
; Non-paged ROM and RAM start and page count
;
ROMBASE		.equ	00000h
ROMPGSTART	.equ	000h
ROMPGS		.equ	080h
RAMBASE		.equ	08000h
RAMPGSTART	.equ	080h
RAMPGS		.equ	080h
;
; I/O Device Addresses
;
BRDCTRL		.equ	0A8h		; Board control bits and LEDs

SIOBASE		.equ	080h		; SIO uses 4 addresses
SIOACTRL	.equ	SIOBASE+0001b	;  CH-A Control
SIOADATA	.equ	SIOBASE+0000b	;  CH-A Data
SIOBCTRL	.equ	SIOBASE+0011b	;  CH-B Control
SIOBDATA	.equ	SIOBASE+0010b	;  CH-B Data

CTCBASE		.equ	088h		; CTC uses 4 addresses
CTCCH0		.equ	CTCBASE+0	;  CH-0
CTCCH1		.equ	CTCBASE+1	;  CH-1
CTCCH2		.equ	CTCBASE+2	;  CH-2
CTCCH3		.equ	CTCBASE+3	;  CH-3

RPMODBASE	.equ	090h		; RP2040 Module for SDCard, KBD, RTC
RPMCTRL		.equ	RPMODBASE+0	;   Module Control
RPMOP		.equ	RPMODBASE+1	;   (selected) Operation port

DISPBASE	.equ	098h		; Display Panel (one of two possible)
DISPCTRL	.equ	DISPBASE+0001b	;  Control
DISPDATA	.equ	DISPBASE+0000b	;  Data
					;  Backlight control is a bit on BRDCTRL

MPAGEREG	.equ	0B0h		; Memory Page Register (low-byte)
					;  Accessing uses 16-bit I/O address
					;  8 locations select memory pages
					;  8 locations are scratch registers
MPAGINGEN	.equ	0B8h		; Write: 1=Enable 0=Disable

;
; Board Control Bits - At Reset this register is ALL 0 (so the RED LEDs are ON)
;
RC8PAGE		.equ	00010000b	; Bit that goes to the RC8 Bus PAGE (pin 60)
RC8PAGEb	.equ	5		;  bit 5
DISPBKLT	.equ	00100000b	; Display Backlight Control: 0=ON 1=OFF
DISPBKLTb	.equ	6		;  bit 6
CLKFAST		.equ	01000000b	; Force Clock Fast - doesn't slow for I/O Ops
CLKFASTb	.equ	7		;  bit 7
NMIEN		.equ	10000000b	; Enable NMI: 0=Disabled 1=Enabled
NMIENb		.equ	8		;  bit 8
; Board LEDs - At Reset the 3 RED LEDs are ON and the GREEN LED is off
LEDR0		.equ	00000001b	; RED LED 0: 0=ON 1=OFF
LEDR0b		.equ	1		;  bit 1
LEDR1		.equ	00000010b	; RED LED 1: 0=ON 1=OFF
LEDR1b		.equ	2		;  bit 2
LEDR2		.equ	00000100b	; RED LED 2: 0=ON 1=OFF
LEDR2b		.equ	3		;  bit 3
LEDGRN		.equ	00001000b	; GREEN LED: 0=OFF 1=ON
LEDGRNb		.equ	4		;  bit 4
;
; Core Board Functionality bits
;
BF_DISPLAY	.equ	00000001b	; Display is functional
BF_DISPLAYb	.equ	1		;  bit 1
BF_COMA		.equ	00000010b	; COM-A (on SIO CHA) is functional
BF_COMAb	.equ	2		;  bit 2
BF_COMB		.equ	00000100b	; COM-B (on SIO CHB) is functional
BF_COMBb	.equ	3		;  bit 3
BF_CTCPI	.equ	00001000b	; CTC Periodic Interrupt is functional
BF_CTCPIb	.equ	4		;  bit 4
BF_RPM		.equ	00010000b	; RP2040 Module is available (other flags are used for functions)
BF_RPMb		.equ	5		;  bit 5

;
DispFont0_EN:	.macro
		call	sio_b_rts_set	; SIO CH-B RTS SET Selects Font0
		.endm
DispFont1_EN:	.macro
		call	sio_b_rts_clr	; SIO CH-B RTS CLR Selects Font1
		.endm
