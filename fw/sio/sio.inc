; ==============
;
; SIO Library - CH-A and CH-B Serial.
;  (chip level routines)
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;

;;**************
;; @brief Get character from CHA without wait.
;; @ingroup sio
;;
;; Get a character if available.
;;
;; @entry
;; @used
;;	A
;; @return
;;	Z: Character not available
;;	A: Character (if available, also NZ status)
;;**************
		.global	sio_a_getc

;;**************
;; @brief Get character from CHA w/wait option.
;; @ingroup sio
;;
;; Get a character if available, with an option to wait if none ready.
;;
;; @entry
;;	B: Non-Zero to wait for a character before returning.
;; @used
;;	A
;; @return
;;	Z: Character not available
;;	A: Character (if available, also NZ status)
;;**************
		.global	sio_a_getcw

;;**************
;; @brief Put character to CHA without wait.
;; @ingroup sio
;;
;; Put a character if possible.
;;
;; @entry
;;	C: Character
;; @used
;;	A
;; @return
;;	Z: TX not ready
;;**************
		.global	sio_a_putc

;;**************
;; @brief Put character to CHA w/wait option.
;; @ingroup sio
;;
;; Put a character if possible, with an option to wait for ready.
;;
;; @entry
;;	C: Character
;;	B: Non-Zero to wait for a character before returning.
;; @used
;;	A
;; @return
;;	Z: TX not ready
;;**************
		.global	sio_a_putcw

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
;; @brief CHA TX Empty.
;; @ingroup sio
;;
;; @entry
;; @used
;;	A
;; @return
;;	Z if TX Empty
;;**************
		.global	sio_a_tx_mt

;;**************
;; @brief CHA Disable External Interrupts (DCD,CTS,SYNC).
;; @ingroup sio
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_a_ext_di

;;**************
;; @brief CHA Enable External Interrupts (DCD,CTS,SYNC).
;; @ingroup sio
;;
;; Interrupt on DCD, CTS, and SYNC input change.
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_a_ext_ei

;;**************
;; @brief CHA Disable RX Char Interrupts.
;; @ingroup sio
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_a_rxc_di

;;**************
;; @brief CHA Enable RX Char Interrupts.
;; @ingroup sio
;;
;; Interrupt on each received character.
;;
;; @entry
;;	Z: Parity is not a Special Receive Condition
;;	NZ: Parity is a SRC
;; @used
;;	A
;;**************
		.global	sio_a_rxc_ei

;;**************
;; @brief CHA Disable TX Char Interrupts.
;; @ingroup sio
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_a_txc_di

;;**************
;; @brief CHA Enable TX Char Interrupts.
;; @ingroup sio
;;
;; Interrupt on each received character.
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_a_txc_ei

;;**************
;; @brief Get character from CHB without wait.
;; @ingroup sio
;;
;; Get a single character.
;;
;; @entry
;; @used
;;	A
;; @return
;;	Z: Character not available
;;	A: Character (if available, also NZ status)
;;**************
		.global	sio_b_getc

;;**************
;; @brief Get character from CHB w/wait option.
;; @ingroup sio
;;
;; Get a single character, with an option to wait for a character.
;;
;; @entry
;;	B: Non-Zero to wait for a character before returning.
;; @used
;;	A
;; @return
;;	Z: Character not available
;;	A: Character (if available, also NZ status)
;;**************
		.global	sio_b_getcw

;;**************
;; @brief Put character to CHB without wait.
;; @ingroup sio
;;
;; Put a character if possible.
;;
;; @entry
;;	C: Character
;; @used
;;	A
;; @return
;;	Z: TX not ready
;;**************
		.global	sio_b_putc

;;**************
;; @brief Put character to CHB w/wait option.
;; @ingroup sio
;;
;; Put a character if possible, with an option to wait for ready.
;;
;; @entry
;;	C: Character
;;	B: Non-Zero to wait for a character before returning.
;; @used
;;	A
;; @return
;;	Z: TX not ready
;;**************
		.global	sio_b_putcw

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
;; @brief CHB TX Empty.
;; @ingroup sio
;;
;; @entry
;; @used
;;	A
;; @return
;;	Z if TX Empty
;;**************
		.global	sio_b_tx_mt

;;**************
;; @brief CHB Disable External Interrupts (DCD,CTS,SYNC).
;; @ingroup sio
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_b_ext_di

;;**************
;; @brief CHB Enable External Interrupts (DCD,CTS,SYNC).
;; @ingroup sio
;;
;; Interrupt on DCD, CTS, and SYNC input change.
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_b_ext_ei

;;**************
;; @brief CHB Disable RX Char Interrupts.
;; @ingroup sio
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_b_rxc_di

;;**************
;; @brief CHB Enable RX Char Interrupts.
;; @ingroup sio
;;
;; Interrupt on each received character.
;;
;; @entry
;;	Z: Parity is not a Special Receive Condition
;;	NZ: Parity is a SRC
;; @used
;;	A
;;**************
		.global	sio_b_rxc_ei

;;**************
;; @brief CHB Disable TX Char Interrupts.
;; @ingroup sio
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_b_txc_di

;;**************
;; @brief CHB Enable TX Char Interrupts.
;; @ingroup sio
;;
;; Interrupt on each received character.
;;
;; @entry
;; @used
;;	A
;;**************
		.global	sio_b_txc_ei

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
;;	RETI (default - depends on handler set)
;;
;;**************
		.global	sio_a_isr_esc

;;**************
;; @brief Clear the handler for - CHA RX External Status Change.
;; @ingroup sio
;;
;; Sets the handler to the default NOP handler.
;;
;; @entry
;;	NONE
;; @used
;;	HL
;; @return
;;	NONE
;;
;;**************
		.global sio_clr_hdlr_a_esc

;;**************
;; @brief Set the handler for - CHA RX External Status Change.
;; @ingroup sio
;;
;; See `sio_a_isr_esc` for what it is called for.
;;
;; The handler being registered will be called with HL pushed on the stack.
;; The routine must assure that HL is popped and an RETI is executed for return.
;;
;; @entry
;;	HL: Address of method to jump to.
;; @used
;;	NONE (saved)
;; @return
;;	NONE
;;
;;**************
		.global sio_set_hdlr_a_esc

;;**************
;; @brief Interrupt Service Routine - CHA RX Character Received.
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
;;	RETI (default - depends on handler set)
;;
;;**************
		.global	sio_a_isr_rxc

;;**************
;; @brief Clear the handler for - CHA RX Character Received.
;; @ingroup sio
;;
;; Sets the handler to the default NOP handler.
;;
;; @entry
;;	NONE
;; @used
;;	HL
;; @return
;;	NONE
;;
;;**************
		.global sio_clr_hdlr_a_rcx

;;**************
;; @brief Set the handler for - CHA RX Character Received.
;; @ingroup sio
;;
;; See `sio_a_isr_rxc` for what it is called for.
;;
;; The handler being registered will be called with HL pushed on the stack.
;; The routine must assure that HL is popped and an RETI is executed for return.
;;
;; @entry
;;	HL: Address of method to jump to.
;; @used
;;	NONE (saved)
;; @return
;;	NONE
;;
;;**************
		.global sio_set_hdlr_a_rcx

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
;;	RETI (default - depends on handler set)
;;
;;**************
		.global	sio_a_isr_src

;;**************
;; @brief Clear the handler for - CHA RX Special RX Condition.
;; @ingroup sio
;;
;; Sets the handler to the default NOP handler.
;;
;; @entry
;;	NONE
;; @used
;;	HL
;; @return
;;	NONE
;;
;;**************
		.global sio_clr_hdlr_a_src

;;**************
;; @brief Set the handler for - CHA RX Special RX Condition.
;; @ingroup sio
;;
;; See `sio_a_isr_src` for what it is called for.
;;
;; The handler being registered will be called with HL pushed on the stack.
;; The routine must assure that HL is popped and an RETI is executed for return.
;;
;; @entry
;;	HL: Address of method to jump to.
;; @used
;;	NONE (saved)
;; @return
;;	NONE
;;
;;**************
		.global sio_set_hdlr_a_src

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
;;	RETI (default - depends on handler set)
;;
;;**************
		.global	sio_a_isr_txe

;;**************
;; @brief Clear the handler for - CHA TX Buffer Empty.
;; @ingroup sio
;;
;; Sets the handler to the default NOP handler.
;;
;; @entry
;;	NONE
;; @used
;;	HL
;; @return
;;	NONE
;;
;;**************
		.global sio_clr_hdlr_a_txe

;;**************
;; @brief Set the handler for - CHA TX Buffer Empty.
;; @ingroup sio
;;
;; See `sio_a_isr_txe` for what it is called for.
;;
;; The handler being registered will be called with HL pushed on the stack.
;; The routine must assure that HL is popped and an RETI is executed for return.
;;
;; @entry
;;	HL: Address of method to jump to.
;; @used
;;	NONE (saved)
;; @return
;;	NONE
;;
;;**************
		.global sio_set_hdlr_a_txe

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
;;	RETI (default - depends on handler set)
;;
;;**************
		.global	sio_b_isr_esc

;;**************
;; @brief Clear the handler for - CHA RX External Status Change.
;; @ingroup sio
;;
;; Sets the handler to the default NOP handler.
;;
;; @entry
;;	NONE
;; @used
;;	HL
;; @return
;;	NONE
;;
;;**************
		.global sio_clr_hdlr_b_esc

;;**************
;; @brief Set the handler for - CHA RX External Status Change.
;; @ingroup sio
;;
;; See `sio_b_isr_esc` for what it is called for.
;;
;; The handler being registered will be called with HL pushed on the stack.
;; The routine must assure that HL is popped and an RETI is executed for return.
;;
;; @entry
;;	HL: Address of method to jump to.
;; @used
;;	NONE (saved)
;; @return
;;	NONE
;;
;;**************
		.global sio_set_hdlr_b_esc

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
;;	RETI (default - depends on handler set)
;;
;;**************
		.global	sio_b_isr_rxc

;;**************
;; @brief Clear the handler for - CHB RX Character Received.
;; @ingroup sio
;;
;; Sets the handler to the default NOP handler.
;;
;; @entry
;;	NONE
;; @used
;;	HL
;; @return
;;	NONE
;;
;;**************
		.global sio_clr_hdlr_b_rcx

;;**************
;; @brief Set the handler for - CHB RX Character Received.
;; @ingroup sio
;;
;; See `sio_b_isr_rxc` for what it is called for.
;;
;; The handler being registered will be called with HL pushed on the stack.
;; The routine must assure that HL is popped and an RETI is executed for return.
;;
;; @entry
;;	HL: Address of method to jump to.
;; @used
;;	NONE (saved)
;; @return
;;	NONE
;;
;;**************
		.global sio_set_hdlr_b_rcx

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
;;	RETI (default - depends on handler set)
;;
;;**************
		.global	sio_b_isr_src

;;**************
;; @brief Clear the handler for - CHB RX Special RX Condition.
;; @ingroup sio
;;
;; Sets the handler to the default NOP handler.
;;
;; @entry
;;	NONE
;; @used
;;	HL
;; @return
;;	NONE
;;
;;**************
		.global sio_clr_hdlr_b_src

;;**************
;; @brief Set the handler for - CHB RX Special RX Condition.
;; @ingroup sio
;;
;; See `sio_b_isr_src` for what it is called for.
;;
;; The handler being registered will be called with HL pushed on the stack.
;; The routine must assure that HL is popped and an RETI is executed for return.
;;
;; @entry
;;	HL: Address of method to jump to.
;; @used
;;	NONE (saved)
;; @return
;;	NONE
;;
;;**************
		.global sio_set_hdlr_b_src

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
;;	RETI (default - depends on handler set)
;;
;;**************
		.global	sio_b_isr_txe

;;**************
;; @brief Clear the handler for - CHB TX Buffer Empty.
;; @ingroup sio
;;
;; Sets the handler to the default NOP handler.
;;
;; @entry
;;	NONE
;; @used
;;	HL
;; @return
;;	NONE
;;
;;**************
		.global sio_clr_hdlr_b_txe

;;**************
;; @brief Clear the handler for - CHB TX Buffer Empty.
;; @ingroup sio
;;
;; See `sio_b_isr_txe` for what it is called for.
;;
;; The handler being registered will be called with HL pushed on the stack.
;; The routine must assure that HL is popped and an RETI is executed for return.
;;
;; @entry
;;	HL: Address of method to jump to.
;; @used
;;	NONE (saved)
;; @return
;;	NONE
;;
;;**************
		.global sio_set_hdlr_b_txe


;;**************
;; @brief Initialize the module.
;; @ingroup sio
;;
;; Initializes the SIO and the module. This initializes the SIO without
;; any interrupts enabled, though it is set up to modify the vector for
;; the various interrupt sources.
;;
;; Separate routines must be called to enable interrupts for the various
;; parts of the SIO.
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

