; ==============
;
; Display Library - For ROWxCOL display.
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;

EMCFONT0:	.equ	0	; 8x8 Font
EMCFONT1:	.equ	1	; 6x8 Font

;;**************
;; @brief `disp_clr` Clear the display and home the cursor.
;; @ingroup disp
;;
;; @entry
;;	NONE
;; @used
;;	C
;; @return
;;	NONE
;;**************
		.global	disp_clr

;;**************
;; @brief `disp_info` Get display information.
;; @ingroup disp
;;
;; @entry
;;	NONE
;; @used
;;	C
;; @return
;;	D: Rows
;;	E: Cols
;;**************
		.global	disp_info

;;**************
;; @brief `disp_pos` Set the cursor position (in text mode).
;; @ingroup disp
;;
;; @entry
;;	B: Row (0 based)
;;	C: Col (0 based)
;; @used
;;	A, BC, DE, HL
;; @return
;;	NONE
;;**************
		.global	disp_pos

;;**************
;; @brief Display a character at the current location and advance cursor.
;; @ingroup disp
;;
;; @entry
;;	A: Character to display
;; @used
;;	A, C, E, L
;; @return
;;	NONE
;;**************
		.global	dispc

;;**************
;; @brief Display a character string at the current location and advance cursor.
;; @ingroup disp
;;
;; @entry
;;	HL: Location of string to display.
;; @used
;;	A, C, DE, HL
;; @return
;;	NONE
;;**************
		.global	disps

;;**************
;; @brief Initialize the module.
;; @ingroup disp
;;
;; @entry
;;	A: Font to initialize for. 0=8x8 1=6x8
;; @used
;;	ALL
;; @return
;;	Z: Success
;;	NZ: Failure
;;		A: Failure code
;;**************
		.global	disp_minit

;
