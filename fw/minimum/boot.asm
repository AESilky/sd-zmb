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
		.input	"sio/sio_ops.inc"
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
id:		.byte	"ZMB MIN BOOT"	; and Restart Vectors
ver:		.equ	$
		.input	"version.inc"	; include the build date/version

		.org	reset+038h
		jp	onrst38
		.org	reset+066h
		jp	onnmi

		.org	reset+0100h
reset0:		di			; On Reset INTS will be disabled, but in case
					; we get back here.
		; Do a ram check as our first step (this does not use the stack)
		ld	iy,rst_ramret	; Where to return to (can't use `call`)
		ld	h,RAMPGSTART	; ram start (page)
		ld	c,RAMPGS	; pages to test
		jp	ramchk_ns	; check it
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
init2:		ld	(hl),a		; do a page
		inc	hl
		djnz	init2
		dec	c		; next page
		jr	nz,init2
		ld	sp,0		; set the stack pointer
		ld	hl,0
		push	hl		; 0 at top of stack
		ld	a,LEDR0		; All RED LEDs were on, turn LEDR0 off
		ld	(bdctrl),a
		out	(BRDCTRL),a
		; Initialize the CTC to be used for the SIO BAUD clocks
		;  E must have the IntVec low-byte
		ld	de,ivt_ctc
		call	ctc_minit
		; Initialize the SIO
		;  E must have the IntVec low-byte
		ld	de,ivt_sio
		call	sio_minit
		jr	nz,init3
		ld	a,(bdctrl)	; Turn LEDR1 off if SIO init succeeded
		set	LEDR1b,a
		ld	(bdctrl),a
		out	(BRDCTRL),a
		ld	a,BF_CTCPI|BF_COMA|BF_COMB ; 1st update to bdfunc, so simple write is ok
		ld	(bdfunc),a
init3:		; Initialize the Display.
		ld	a,EMCFONT1	; use FONT1 (HW selected through SIO)
		call	disp_minit
		jr	nz,init4b	; Display didn't check out =>
		ld	a,(bdfunc)	; Mark the Display as available
		or	BF_DISPLAY
		ld	(bdfunc),a
		ld	hl,hello_world
		ld	b,EOS
		call	disps
init4b:		;
		; Initialize the Interrupt Vector
		; but we won't use interrupts until we've sent out the Hello message.
		;
		ld	de,intvec
		ld	a,d
		ld	i,a
		; Say "Hello" on the serial ports
		ld	hl,hello_world
		ld	b,EOS
		call	sio_a_putsni
		ld	hl,hello_world
		call	sio_b_putsni
init5:		;
		; Do a 'check' of the paging registers and memory paging.
		; We say 'check', because it's not a thorough 'test', but it should
		; indicate that paging is working or not.
		;
		; LEDR3 will be turned off if both registers and paging succeed.
		ld	iy,init6	; the diagnostic doesn't use stack
		jp	pgrgchk_ns
init6:		jp	nz,_i5_err	; Error with the paging/scratch registers
		ld	iy,init7	; no stack used
		jp	pgingchk_ns
init7:		jp	nz,_i6_err	; Error with memory paging
		;
		; We've said Hello on the display and both serial channels,
		; and the Scratch and Paging Registers checked out, as did the
		; basic check of the paging!
		; Let's turn off the 3rd Red LED and turn on the Green LED!
		;
		ld	a,(bdctrl)
		set	LEDR2b,a
		set	LEDGRNb,a
		ld	(bdctrl),a
		out	(BRDCTRL),a
		;
init_ints:	;
	; ZZZ - Temp, just read the serial and output without INTERRUPTS.
rd_wr_loop:	;
		ld	d,0		; even/odd for CH-A/CH-B
_rwl_ia:	call	sio_a_getc	; Try to get a char from A
		jr	nz,_rwl_out	;  got one...
		inc	d		; indicate CH-B
_rwl_ib:	call	sio_b_getc	; Try to get a char from B
		jr	nz,_rwl_out	;  got one...
		inc	d		; indicate CH-A
		jr	_rwl_ia		; do again->
_rwl_out:	;
		; character in a, output to CH-A, CH-B, and Display
		ld	c,a
		ld	b,1		; Put char (wait for ready)
		call	sio_a_putcw
		call	sio_b_putcw
		ld	a,c
		call	dispc
		inc	d		; next channel
		bit	0,d
		jr	z,_rwl_ia	; D0 get from CH-A
		jr	_rwl_ib		; get from CH-B

_i5_err:	; There was a paging/scratch register error
		ld	hl,psrg_err
		ld	b,EOS
		call	disps
		jr	rd_wr_loop
_i6_err:	; There was a paging/scratch register error
		ld	hl,pgmem_err
		ld	b,EOS
		call	disps
		jr	rd_wr_loop


onrst38:
		jp	onrst38


onnmi:
		jp	onnmi

hello_world:	.byte	"Hello World, ZMB is up!",EOS
;
psrg_err:	.byte	" !Page/Scratch Reg Err!",EOS
pgmem_err:	.byte	" !Paging Memory Err!",EOS
		.byte	"!boot!"

; Set up the TEXT section
TEXT		.sect	W	; No writes
		.align	4	; Put it at an easy to locate boundary

; Set up the Jump Table section
JMPTBL		.sect		; Will be written to
		.align  1	; Put it at an even boundary

		.end


