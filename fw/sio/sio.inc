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

;;= Interrupt Vector Count - SIO has 8
IVCNT_SIO:	.equ	8


;;**************
;; @brief Interrupt Service Routine - CHA RX External Status Change.
;; @ingroup sio
;;
;; Handles:
;;     	    COMA-CTS    - Serial handshake.
;;          DCD         - RC80-Bus Int1 (ExIRQ1-)
;;          SYNC        - Console on COMB (CNSLSELB-)
;;          TX Underrun - (not applicable for async)
;;          Break Sig   - Serial Break detected
;;
;; @entry
;;	NONE
;; @used
;;	NONE (saved)
;; @return
;;	RETI
;;
;;**************
		.global	sio_a_isr_esc

;;**************
;; @brief Interrupt Service Routine - CHA RX Character.
;; @ingroup sio
;;
;; Handles:
;;     	    Character Available.
;;
;; @entry
;;	NONE
;; @used
;;	NONE (saved)
;; @return
;;	RETI
;;
;;**************
		.global	sio_a_isr_rxc

;;**************
;; @brief Interrupt Service Routine - CHA Special RX Condition.
;; @ingroup sio
;;
;; Handles:
;;     	    End of Frame (SDLC).
;;     	    Framing Error.
;;     	    Parity Error.
;;     	    RX Overrun.
;;
;; @entry
;;	NONE
;; @used
;;	NONE (saved)
;; @return
;;	RETI
;;
;;**************
		.global	sio_a_isr_src

;;**************
;; @brief Interrupt Service Routine - CHA TX Buffer Empty.
;; @ingroup sio
;;
;; Handles:
;;     	    The transmitter buffer becoming empty (must have had a character).
;;
;; @entry
;;	NONE
;; @used
;;	NONE (saved)
;; @return
;;	RETI
;;
;;**************
		.global	sio_a_isr_txe

;;**************
;; @brief Interrupt Service Routine - CHA RX External Status Change.
;; @ingroup sio
;;
;; Handles:
;;     	    CHB-CTS     - RB2040 Module Interrupt Request (MODIRQ-).
;;          DCD         - RC80-Bus Int2 (ExIRQ2-)
;;          TX Underrun - (not applicable for async)
;;          Break Sig   - Serial Break detected
;;
;; @entry
;;	NONE
;; @used
;;	NONE (saved)
;; @return
;;	RETI
;;
;;**************
		.global	sio_b_isr_esc

;;**************
;; @brief Interrupt Service Routine - CHB RX Character.
;; @ingroup sio
;;
;; Handles:
;;     	    Character Available.
;;
;; @entry
;;	NONE
;; @used
;;	NONE (saved)
;; @return
;;	RETI
;;
;;**************
		.global	sio_b_isr_rxc

;;**************
;; @brief Interrupt Service Routine - CHB Special RX Condition.
;; @ingroup sio
;;
;; Handles:
;;     	    End of Frame (SDLC).
;;     	    Framing Error.
;;     	    Parity Error.
;;     	    RX Overrun.
;;
;; @entry
;;	NONE
;; @used
;;	NONE (saved)
;; @return
;;	RETI
;;
;;**************
		.global	sio_b_isr_src

;;**************
;; @brief Interrupt Service Routine - CHB TX Buffer Empty.
;; @ingroup sio
;;
;; Handles:
;;     	    The transmitter buffer becoming empty (must have had a character).
;;
;; @entry
;;	NONE
;; @used
;;	NONE (saved)
;; @return
;;	RETI
;;
;;**************
		.global	sio_b_isr_txe

