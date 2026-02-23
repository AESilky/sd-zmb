#
# Copyright 2025-26 AESilky
# SPDX-License-Identifier: MIT License
#

ASM		:= uasz80
ALINK	:= ulink

CMNPATH		:= ../cmn/

ASMOPTS	:=	-l

%.obj:	%.asm
	$(ASM) $(ASMOPTS) $<


util.obj:	makefile util.asm util.inc

.PHONY:	clean
clean:
	rm *.obj
