; ==============
;
; Display Library - For ROWxCOL display.
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;
			.list	1
			.input	"../cmn/stddef.inc"

JMPTBL			.sect
disp_jptbl_		.equ	$		; RAM Jump Table for functions
disp_clr:		.block	JP_ENTRY	; Clear display and home
disp_info:		.block	JP_ENTRY	; Get display info
disp_pos:		.block	JP_ENTRY	; Set ROW:COL Position
dispc:			.block	JP_ENTRY	; Display Character
disps:			.block	JP_ENTRY	; Display String
disp_jptbl__		.equ	$
disp_jptbl_len_		.equ	(disp_jptbl__-disp_jptbl_)	; size of the jump table

TEXT			.sect	W

			.list	2
			.input	"disp.inc"

			.list	1
			.input	"../cmn/board.inc"
			.input	"../util/util.inc"

E240128F0_COLS		.equ	30		; Font-0 (8x8)
E240128F1_COLS		.equ	40		; Font-1 (6x8)
E240128_ROWS		.equ	16

DMC_CHAR_ADJ		.equ	32		; Subtract from ASCII for font glyph

DMC_STATUS01_MASK:	.equ	01000011b
DMC_STATUS01_OK		.equ	00000011b

; T6963/I6963 commands (see datasheet)
;
;  Registers
DMC_R_CURSOR_POS        .equ	021h    ; Data: X,Y (2)
DMC_R_OFFSET            .equ	022h    ; Data: data,0 (2)
DMC_R_ADDR              .equ	024h    ; Data: Low,High (2)

;  Control
DMC_C_TEXT_HOME         .equ	040h    ; Data: Low,High (2)
DMC_C_TEXT_AREA         .equ	041h    ; Data: Cols,0 (2)
DMC_C_GRFX_HOME         .equ	042h    ; Data: Low,High (2)
DMC_C_GRFX_AREA         .equ	043h    ; Data: Cols,0 (2)

;  Mode
DMC_MODE_ICGx           .equ	080h    ; Use the built-in character ROM (add a mode below) (0)
DMC_MODE_ECGx           .equ	088h    ; Use external character RAM (add a mode below) (0)
DMC_MODE_OR                 .equ	000h    ; see datasheet
DMC_MODE_XOR                .equ	001h    ; ...
DMC_MODE_AND                .equ	003h    ; ...
DMC_MODE_TEXTATTR           .equ	004h    ; ...

;  Display
DMC_DISP_MODEx          .equ	090h    ; Low nibble is mode bits: (0)
DMC_DISP_MODE_OFF           .equ	000h    ; B3-B0: Display OFF
DMC_DISP_MODE_CURon         .equ	002h    ; B1: Cursor ON (see Blink)
DMC_DISP_MODE_CBLNKon       .equ	001h    ; B0: Cursor Blink ON (use with Cursor ON)
DMC_DISP_MODE_TEXTon        .equ	004h    ; B2: Text Display ON
DMC_DISP_MODE_GRFXon        .equ	008h    ; B3: Graphic Display ON

;  Cursor
DMC_CURSOR_SIZEx        .equ	0A0h    ; Cursor size from 1-8 line (000-111) (0)

;  Data Read/Write Auto-Advance
DMC_DATA_AUTO_WR        .equ	0B0h    ; Enter 'AUTO' Write mode (0)
DMC_DATA_AUTO_RD        .equ	0B1h    ; Enter 'AUTO' Read mode (0)
DMC_DATA_AUTO_RST       .equ	0B2h    ; Exit 'AUTO' RD/WR mode (0)

;  Data Read/Write Byte
DMC_DWR_NEXT            .equ	0C0h    ; WR Data and advance data pointer (1)
DMC_DRD_NEXT            .equ	0C1h    ; RD Data and advance data pointer
;
DMC_DWR_PREV            .equ	0C2h    ; WR Data and decrease data pointer (1)
DMC_DRD_PREV            .equ	0C3h    ; RD Data and decrease data pointer
;
DMC_DWR_SAME            .equ	0C4h    ; WR Data and leave data pointer (1)
DMC_DRD_SAME            .equ	0C5h    ; RD Data and leave data pointer

;  Screen Data Manipulation
DMC_SCR_PEEK            .equ	0E0h    ; 'Peek' the set address (0) - Follow with STA6 check and data read
DMC_SCR_COPY            .equ	0E8h    ;
DMC_BIT_SR              .equ	0F0h    ; Low nibble is bit 0-7

; *** Ultrachip UCI6963c ONLY (not available on Toshiba T6963C) ***
UCi_BLNK_RATE           .equ	050h    ; Data: 0=66ms 1=250ms 2=500ms 3=1.75s 4=1.0s 5=1.25s 6=1.5s 7=2.0s, 0
UCi_CURSOR_AA           .equ	060h    ; Data: 0=No auto adv 1=Auto adv, 0
UCi_CGROM_FONT          .equ	070h    ; Data: 2=Font1 3=Font2, 0
;  Screen Inverse
DMC_SCR_REV             .equ	0D0h    ; Data: 0=Normal 1=Reverse, 0

; Status Bits
DMC_STA0_CMDEXEC_OK     .equ	00000001b
DMC_STA1_DATARDWR_OK    .equ	00000010b
DMC_STA2_AUTORD_OK      .equ	00000100b
DMC_STA3_AUTOWR_OK      .equ	00001000b
DMC_STA5_CTRLOP_OK      .equ	00100000b
DMC_STA6_SCRCPY_ERR     .equ	01000000b
DMC_STA7_SCR_BLINK      .equ	10000000b

ERMC_VRES		.equ	128
ERMC_HRES		.equ	240
ERMC_ADDR_TEXT_BASE_H	.equ	000h
ERMC_ADDR_TEXT_BASE_L	.equ	000h
ERMC_ADDR_GRFX_BASE_H	.equ	008h
ERMC_ADDR_GRFX_BASE_L	.equ	000h

; Initialization table is the length of the table in bytes (4*entries), then:
;	COMMAND, NUMBER_OF_PARAMS+1, PARAM1, PARAM2
l6963_init:		.equ	$
			.byte	(l6963_ie-l6963_i0)/4
l6963_i0:		.equ	$
			.byte	DMC_C_TEXT_HOME, 3, 0, ERMC_ADDR_TEXT_BASE_H
			.byte	DMC_C_GRFX_HOME, 3, 0, ERMC_ADDR_GRFX_BASE_H
			.byte	DMC_C_GRFX_AREA, 3, ERMC_HRES, 0
			.byte	(DMC_CURSOR_SIZEx|007h), 1, 0, 0
			.byte	(DMC_MODE_ICGx|DMC_MODE_OR), 1, 0, 0
			.byte	UCi_CGROM_FONT, 3, 2, 0
			.byte	(DMC_DISP_MODEx|(DMC_DISP_MODE_GRFXon|DMC_DISP_MODE_TEXTon|DMC_DISP_MODE_CURon|DMC_DISP_MODE_CBLNKon)), 1, 0, 0
			.byte	DMC_R_OFFSET, 3, 4, 0
			.byte	DMC_R_CURSOR_POS, 3, 0, 0
			.byte	UCi_CURSOR_AA, 3, 1, 0
			.byte	UCi_BLNK_RATE, 3, 2, 0
l6963_ie:		.equ	$

zerow:			.word	0

BSS			.sect
_cols			.block	BYTE
_font:			.block	BYTE

TEXT			.sect	W
;; =============
;; Write a command with no parameters.
;;
;; L: Command
;;
;; USED: A
;;
_cmd_wr0:	call	_stat01_wait
		ld	a,l
		out	(DISPCTRL),a
		ret

;; =============
;; Write a command with 1 parameter.
;;
;; L: Command
;; E: Parameter 1 (low)
;;
;; USED: A, C
;;
_cmd_wr1:	ld	c,DISPDATA
		; Output parameter 1
		call	_stat01_wait
		out	(c),e
		; Output the command
		inc	c		; Point C to CTRL port
		call	_stat01_wait
		out	(c),l
		ret

;; =============
;; Write a command with 2 parameters.
;;
;; L: Command
;; E: Parameter 1 (low)
;; D: Parameter 2 (high)
;;
;; USED: A, C
;;
_cmd_wr2:	ld	c,DISPDATA
		; Output parameter 1
		call	_stat01_wait
		out	(c),e
		; Output parameter 2
		call	_stat01_wait
		out	(c),d
		; Output the command
		inc	c		; Point C to CTRL port
		call	_stat01_wait
		out	(c),l
		ret

;; =============
;; Write a command with 0, 1, or 2 parameters.
;;
;; L: Command
;; H: Number of parameters + 1
;; E: Parameter 1 (low)
;; D: Parameter 2 (high)
;;
;; USED: C, DE, HL
;;
_cmd_wrA:	ld	c,DISPDATA
		dec	h
		jr	z,_cmd_wrA0
		; Output parameter 1
		call	_stat01_wait
		out	(c),e
		dec	h
		jr	z,_cmd_wrA0
		; Output parameter 2
		call	_stat01_wait
		out	(c),d
_cmd_wrA0:	; Output the command
		inc	c		; Point C to CTRL port
		call	_stat01_wait
		out	(c),l
		ret

;; =============
;; Check 01 status.
;;
;; USED: A
;; RETURN: Z on Ready
;;
_stat01:	; Check ready
		in	a,(DISPCTRL)
		and	DMC_STATUS01_MASK
		cp	DMC_STATUS01_OK
		ret

;; =============
;; Wait for 01 status to be ready.
;;
;; USED: A
;; RETURN: On Ready
;;
_stat01_wait:	; Wait for ready
		call	_stat01
		jr	nz,_stat01_wait
		ret


;; **************************************************************************
;; Public Method Bodies (entry copied to jump table on successful init)
;; **************************************************************************

disp_clr_:	; No params
		ret


disp_info_:	; Return DE with Rows,Cols
		ld	d,E240128_ROWS
		ld	e,E240128F0_COLS
		ld	a,(_font)
		or	a
		ret	z
		ld	e,E240128F1_COLS
		ret


disp_pos_:	; BC holds Row,Col
		;  pos = (row * cols) + col
		ld	a,(_cols)
		ld	e,a
		xor	a
		ld	h,a
		ld	l,a
		ld	d,a
_dpos1:		or	b
		jr	z,_dpos2
		add	hl,de
		dec	b
		jr	_dpos1
_dpos2:		add	hl,bc
		ld	e,l
		ld	d,h
		ld	l,DMC_R_ADDR
		jr	_cmd_wr2


dispc_:		; A holds Character
		sub	DMC_CHAR_ADJ
		ld	e,a
		ld	l,DMC_DWR_NEXT
		jp	_cmd_wr1


disps_:		; HL holds pointer to string
		ld	a,(hl)
		cp	EOS
		ret	z
		ld	d,l
		call	dispc_
		ld	l,d
		inc	hl
		jr	disps_




disp_minit:	; A is selected font
		ld	(_font),a
		or	a
		ld	a,E240128F0_COLS
		jr	z,_minit00
		ld	a,E240128F1_COLS
_minit00:	ld	(_cols),a
		; See if the display responds
		;  we try 256 times in case the display takes some time to wake up
		ld	b,0
_minit0:	call	_stat01
		jr	z,_minit1
		djnz	_minit0
		;  the check has failed 256 times. Store RET in the Jump Table entries.
		ld	b,disp_jptbl_len_
		ld	a,RET_OP
		ld	hl,disp_jptbl_
_minit0f:
		ld	(hl),a
		djnz	_minit0f
		or	a			; Set NZ for return status
		ret
_minit1:	; The display responded. Initialize it.
		ld	a,(l6963_init)		; Number of entries
		ld	b,a
		ld	ix,l6963_init+1		; First entry
_minit2:	ld	l,(ix+0)
		ld	h,(ix+1)
		ld	e,(ix+2)
		ld	d,(ix+3)
		call	_cmd_wrA
		ld	de,4
		add	ix,de
		djnz	_minit2
		; The display is initialized except for the font dependant settings
		xor	a
		ld	d,a
		ld	l,DMC_C_TEXT_AREA
		ld	a,(_font)
		or	a
		jr	nz,_minit2b
		ld	e,E240128F0_COLS
		call	_cmd_wr2
		jr	_minit3
_minit2b:	ld	e,E240128F1_COLS
		call	_cmd_wr2
_minit3:	; Store Jump Table entries
		ld	de,disp_clr_
		ld	hl,disp_clr
		call	jpentry
		ld	de,disp_info_
		ld	hl,disp_info
		call	jpentry
		ld	de,disp_pos_
		ld	hl,disp_pos
		call	jpentry
		ld	de,dispc_
		ld	hl,dispc
		call	jpentry
		ld	de,disps_
		ld	hl,disps
		call	jpentry
		xor	a			; Z status
		ret


		.byte	"!disp!"
		.end
