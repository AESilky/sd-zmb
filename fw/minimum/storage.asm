; ==============
;
; ZMB (Z80 Main Board) Minimum Boot-Up Data Storage
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;
		.stitle	"Storage"

		.list	1
		.input	"../cmn/stddef.inc"
		.list	2
		.input	"storage.inc"
		.eject

BSS		.sect

bdctrl:		.block	BYTE
bdfunc:		.block	BYTE	; See BF_*** in board.inc for bit definitions



