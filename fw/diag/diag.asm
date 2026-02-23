; ==============
;
; General Board Diagnostics
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;
		.stitle	"Diagnostics"
TEXT		.sect	W

		.input	"diag.inc"

;;**************
ramchk_nsp:
		ld	d,h 		; save the start page
		ld	e,c 		; save the page count
		; fill all
ramchk_0:	ld	b,0		; byte count (256)
ramchk_1:	ld	(hl),a
		inc	a
		inc	(hl)
		djnz	ramchk_1	; continue writing this page
		inc	a
		dec	c		; next page
		jr	nz,ramchk_0
ramchk_2:	; all ram written, read it back
		xor	a
		ld	l,a
		ld	h,d 		; get the start page
		ld	c,e 		; get the page count
ramchk_00:	ld	b,0 		; byte count
ramchk_01:	ld	e,(hl)		; read the byte
		cp	e 		; check it
		jr	nz,ramchk_err
		inc	a
		inc	hl
		djnz	ramchk_01	; next byte
		inc	a
		dec	c
		jr	nz,ramchk_00 	; next page
		; all ram compares, return Z
		;
ramchk_err:	; register values and NZ flag are what we need to return
		jp	(iy)


		.byte	"!diag!"
		.end
