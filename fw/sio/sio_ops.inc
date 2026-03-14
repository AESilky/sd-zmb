; ==============
;
; SIO Operations Library - Functional Routines that use the SIO.
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;

;;**************
;; @brief Put a string to the SIO channel A without interrupts.
;; @ingroup sio
;;
;; Output a string without using interrupts. This checks the TX Buf Empty
;; status bit for each character sent.
;;
;; Note: This doesn't disable interrupts, it is intended to be used when
;;	the SIO doesn't have interrupts enabled.
;;
;; @entry
;;	HL: Location of string to display.
;;	B: String terminator (typically 0xFF or 0)
;; @used
;;	A, C, DE, HL
;; @return
;;	NONE
;;**************
		.global	sio_a_putsni

;;**************
;; @brief Put a string to the SIO channel B without interrupts.
;; @ingroup sio
;;
;; Output a string without using interrupts. This checks the TX Buf Empty
;; status bit for each character sent.
;;
;; Note: This doesn't disable interrupts, it is intended to be used when
;;	the SIO doesn't have interrupts enabled.
;;
;; @entry
;;	HL: Location of string to display.
;;	B: String terminator (typically 0xFF or 0)
;; @used
;;	A, C, DE, HL
;; @return
;;	NONE
;;**************
		.global	sio_b_putsni

;;**************
;; @brief Run channel A with interrupts.
;; @ingroup sio
;;
;; Enables all the interrupts on channel A with handlers that call into
;; registered routines. The handlers take care of any required status bits
;; in the SIO.
;;
;; @entry
;; @used
;;	A, HL
;; @return
;;	NONE
;;**************
		.global	sio_a_runwint

;;**************
;; @brief Run channel B with interrupts.
;; @ingroup sio
;;
;; Enables all the interrupts on channel B with handlers that call into
;; registered routines. The handlers take care of any required status bits
;; in the SIO.
;;
;; @entry
;; @used
;;	A, HL
;; @return
;;	NONE
;;**************
		.global	sio_b_runwint


;;**************
;; @brief Initialize the module.
;; @ingroup sio
;;
;; Initializes the SIO Operations module.
;;
;; @entry
;; @used
;;	ALL
;; @return
;;**************
		.global	sio_ops_minit

