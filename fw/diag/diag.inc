; ==============
;
; General Board Diagnostics
;
; Copyright 2025-26 AESilky
; SPDX-License-Identifier: MIT License
;
; ==============
;

;;**************
;; @brief Perform a basic RAM read/write check on a block of memory without using Stack.
;; @ingroup diag
;;
;; Assures that the block of memory can be written and read and that memory within the
;; block is unique (when a location is written it is not read back at another address).
;;
;; The routine does not use the stack, as memory might not be working.
;;
;; The block must start at a page boundary and the size is in pages (256 bytes).
;;
;; @entry
;;	IY: Return address
;;	HL: Start address (must be on a page boundary)
;;	 C: Number of pages to check (0 will check 256 pages)
;; @used
;;	NONE
;; @return
;;	Z: Success
;;	NZ: Failure
;;		HL: Address in error
;;		 A: Expected
;;		 E: Actual
;;**************
	.global	ramchk_nsp

;
