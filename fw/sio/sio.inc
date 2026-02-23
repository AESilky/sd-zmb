; ==============
;
; SIO Library - CH-A and CH-B Serial.
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;

;;**************
;; @brief RTS CHA CLEAR.
;; @ingroup sio
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_a_rts_clr

;;**************
;; @brief RTS CHA SET.
;; @ingroup sio
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_a_rts_set

;;**************
;; @brief RTS CHB CLEAR.
;; @ingroup sio
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_b_rts_clr

;;**************
;; @brief RTS CHB SET.
;; @ingroup sio
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_b_rts_set

;;**************
;; @brief RTS CLEAR.
;; @ingroup sio
;;
;; @entry
;;	E: 0 CH-A, 1 CH-B
;; @used
;;	A, E
;;**************
		.global	sio_rts_clr

;;**************
;; @brief RTS Control (SET/CLR).
;; @ingroup sio
;;
;; @entry
;;	E: 0 CH-A, 1 CH-B
;;	A: 0 CLEAR, 1 SET
;; @used
;;	A, E
;;**************
		.global	sio_rts_ctrl

;;**************
;; @brief RTS SET.
;; @ingroup sio
;;
;; @entry
;;	E: 0 CH-A, 1 CH-B
;; @used
;;	A, E
;;**************
		.global	sio_rts_set

;;**************
;; @brief Initialize the module.
;; @ingroup sio
;;
;; @entry
;;	E: Interrupt Vector base NNNNxxx0
;; @used
;;	ALL
;; @return
;;	Z: Success
;;	NZ: Failure
;;**************
		.global	sio_minit

IVCNT_SIO:	.equ	8

;
