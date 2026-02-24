#
# Copyright 2025-26 AESilky
# SPDX-License-Identifier: MIT License
#

# Define a variable with the current date/time
BUILD_DT 	:= $(shell date +"\"%Y%m%d-%H:%M\"")

ASM		:= uasz80
ALINK	:= ulink

BASEPATH	:= ../
CMNPATH		:= $(BASEPATH)cmn/

CMNFILES	:= $(CMNPATH)board.inc $(CMNPATH)stddef.inc

ASMOPTS	:= -li$(BASEPATH) -i./ -d _BLD_DT=$(BUILD_DT)

%.obj:	%.asm
	$(ASM) $(ASMOPTS) $<


ctc.obj:	makefile ctc.asm ctc.inc $(CMNFILES)

.PHONY:	clean
clean:
	rm *.obj
