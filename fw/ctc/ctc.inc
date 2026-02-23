; ==============
;
; CTC Library - BAUD rate generation and periodic interrupt.
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;

;;**************
;; @brief Initialize the module.
;; @ingroup ctc
;;
;; @entry
;;	E: Interrupt Vector base NNNNNxx0
;; @used
;;	ALL
;; @return
;;	Z: Success
;;	NZ: Failure
;;		A: Failure code
;;**************
		.global	ctc_minit

IVCNT_CTC:	.equ	4

;
