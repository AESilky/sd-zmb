; ==============
;
; ZMB (Z80 Main Board) Minimum Boot-Up
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;
; This performs a basic RAM check (without relying on stack).
; If that succeeds it continues on to try to initialize more of the board.
; If the memory check fails it will continue writing and reading the location
; that was first detected as failing.
;
; This boot does not try to use the memory paging other than to write and
; read the page registers as a check.
; So, the memory is fixed as 32K ROM and 32K RAM.
;
		.title	"ZMB (Z80 Main Board) Minimum Boot-Up"
		.stitle	"Reset Boot"
BOOT		.sect	W
;		.org	0

		.input	"cmn/board.inc"
		.input	"cmn/stddef.inc"
		.input	"boot.inc"
		.input	"intvec.inc"

		.list	1		; Don't list these included files
		.input	"ctc/ctc.inc"
		.input	"diag/diag.inc"
		.input	"disp/disp.inc"
		.input	"sio/sio.inc"
		.input	"storage.inc"

		.eject
; --------------
;
; ROUTINE: reset
;
; PURPOSE: Configure the board after power-up or pushbutton reset.
;
; ENTRY: _
; EXIT:  _
;
; --------------
;
reset:
		jp	reset0		; Jump over some ID 'stuff'
		.byte	"ZMB MIN BOOT"	; and Restart Vectors
		.input	"version.inc"	; include the build date/version

		.org	reset+038h
		jp	onrst38
		.org	reset+066h
		jp	onnmi

		.org	reset+0100h
reset0:
		; Do a ram check as our first step (this does not use the stack)
		ld	iy,rst_ramret	; Where to return to
		ld	h,RAMPGSTART	; ram start
		ld	b,RAMPGS	; pages to test
		jp	ramchk_nsp	; check it
rst_ramret:	jr	z,init1		; If no error, start initialization
		;
		; Continually write and read the location in error
		;
rst_ramerr:	ld	(hl),a
		ld	d,(hl)		; leave the initial incorrect value in E
		jr	rst_ramerr
		;
init1:
		; Ram has checked out, so we can use it
		; fill it with 0's
		ld	hl,RAMBASE
		ld	c,RAMPGS
		xor	a
		ld	(bdctrl),a
		ld	b,a
init2:		ld	(hl),a
		djnz	init2
		dec	c
		jr	nz,init2
		ld	sp,0
		ld	hl,0
		push	hl		; 0 at top of stack
		ld	a,001h		; All RED LEDs were on, turn LEDR0 off
		ld	(bdctrl),a
		out	(BRDCTRL),a
		; Initialize the CTC to be used for the SIO BAUD clocks
		ld	de,intvec
		call	ctc_minit
		jr	nz,init3
		ld	a,(bdctrl)	; Turn LEDR1 off if CTC init succeeded
		set	2,a
		ld	(bdctrl),a
		out	(BRDCTRL),a
init3:		ld	(bdctrl),a
		; Initialize the SIO
		ld	de,intvec+IVCNT_CTC
		call	sio_minit
		ld	a,EMCFONT1	; If SIO init fails, the display will be FONT1
		jr	nz,init4
		ld	a,(bdctrl)	; Turn LEDR2 off if SIO init succeeded
		set	3,a
		ld	(bdctrl),a
		out	(BRDCTRL),a
		;  The SIO RTSb drives the Font select and will be HIGH at reset (FONT1).
		DispFont0_EN		; Enable Display Font-0 (macro)
		ld	a,EMCFONT0
init4:		; Initialize the Display.
		call	disp_minit
		ld	a,BF_DISPLAY
		jr	z,init4b
		xor	a
init4b:		ld	(bdfunc),a 	; Mark if the display is present or not
		ld	hl,hello_world
		call	disps
		;

onrst38:
		jp	onrst38

onnmi:
		jp	onnmi

hello_world:	.byte	"Hello World, ZMB is up!",EOS

		.byte	"!boot!"

; Set up the TEXT section
TEXT		.sect	W	; No writes
		.align	4	; Put it at an easy to locate boundary

; Set up the Jump Table section
JMPTBL		.sect		; Will be written to
		.align  1	; Put it at an even boundary

		.end


