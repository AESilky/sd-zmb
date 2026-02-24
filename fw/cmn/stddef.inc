; ==============
;
; Standard Definitions.
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;
BYTE		.equ	1		; Length of byte
WORD		.equ	2		; Length of word

EOS		.equ	0FFh		; End of String
NULL		.equ	0		;

JP_OP		.equ	0C3h		; Z80 JP Opcode
JP_ENTRY	.equ	3		; Number of bytes for a JP Entry

RET_OP		.equ	0C9h		; Z80 RET Opcode
