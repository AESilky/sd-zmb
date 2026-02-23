#
# Copyright 2025-26 AESilky
# SPDX-License-Identifier: MIT License
#

ASM		:= uasz80
ALINK	:= ulink

CMNPATH		:= ../cmn/

CMNFILES	:= $(CMNPATH)board.inc $(CMNPATH)stddef.inc

ASMOPTS	:=	-l

%.obj:	%.asm
	$(ASM) $(ASMOPTS) $<


sio.obj:	makefile sio.asm sio.inc $(CMNFILES)

.PHONY:	clean
clean:
	rm *.obj
