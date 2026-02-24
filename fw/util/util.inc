; ==============
;
; Utility Library.
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;

;;**************
;; @brief `callind` Call indirect through HL.
;; @ingroup util
;;
;; This routine simply jumps to the address in HL. By calling this
;; it is equivalent to a `CALL (HL)` operation (which doesn't exist).
;;
;; @entry
;;	HL: Address of routine to call.
;; @used
;;	NONE
;; @return
;;	NONE
;;**************
		.global	callind

;;**************
;; @brief `callindx` Call indirect through IX.
;; @ingroup util
;;
;; This routine simply jumps to the address in IX. By calling this
;; it is equivalent to a `CALL (IX)` operation (which doesn't exist).
;;
;; @entry
;;	IX: Address of routine to call.
;; @used
;;	NONE
;; @return
;;	NONE
;;**************
		.global	callindx

;;**************
;; @brief `callindy` Call indirect through IY.
;; @ingroup util
;;
;; This routine simply jumps to the address in IY. By calling this
;; it is equivalent to a `CALL (IY)` operation (which doesn't exist).
;;
;; @entry
;;	IY: Address of routine to call.
;; @used
;;	NONE
;; @return
;;	NONE
;;**************
		.global	callindy

;;**************
;; @brief `jpentry` Set a Jump Table Entry.
;; @ingroup util
;;
;; Stores a JP opcode and the address at a location.
;;
;; @entry
;;	DE: Address of routine to store.
;;	HL: Destination (where to store)
;; @used
;;	A
;; @return
;;	NONE
;;**************
		.global	jpentry

;;**************
;; @brief `retentry` Set a Jump Table Entry to a RET instruction.
;; @ingroup util
;;
;; Stores a RET opcode at a location.
;;
;; @entry
;;	HL: Destination (where to store)
;; @used
;;	A
;; @return
;;	NONE
;;**************
		.global	retentry

