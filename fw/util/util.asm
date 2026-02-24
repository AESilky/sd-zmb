; ==============
;
; Utility Library.
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;

TEXT		.sect	W
		.list	1
		.input	"../cmn/stddef.inc"
		.list	2
		.input	"util.inc"

callind:	jp	(hl)

callindx:	jp	(ix)

callindy:	jp	(iy)

jpentry:	ld	a,JP_OP
		ld	(hl),a
		inc	hl
		ld	(hl),e
		inc	hl
		ld	(hl),d
		ret

retentry:	ld	a,RET_OP
		ld	(hl),a
		ret

		.byte	"!util!"
		.end
