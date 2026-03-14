; ==============
;
; ZMB (Z80 Main Board) Minimum Boot-Up
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;
; This performs a basic RAM test (without relying on stack).
; If that succeeds it continues on to try to initialize more of the board.
; If the memory test fails it will continue writing and reading the location
; that was first detected as failing.
;
; This boot does not try to use the memory paging other than to write and
; read the page registers. So, the memory is fixed as 32K ROM and 32K RAM.
;

;	IDENTIFIERS DEFINED IN THIS MODULE
;
	.global	id	; ROM Identifier
	.global	ver	; ROM Version


;	ROUTINES DEFINED IN THIS MODULE
;

;;**************
;;
;; PURPOSE: Perform power-up or push-button reset board initialization.
;;
;;**************
	.global	reset

