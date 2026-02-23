#
# Copyright 2025-26 AESilky
# SPDX-License-Identifier: MIT License
#

# Define a variable with the current date/time
BUILD_DT 	:= $(shell date +"\"%Y%m%d-%H:%M\"")
$(info BUILD_DT is: $(BUILD_DT))

ASM		:= uasz80
ALINK	:= ulink

BASEPATH	:= ../
CMNPATH		:= $(BASEPATH)cmn/
DIAGPATH	:= $(BASEPATH)diag/

CMNFILES	:= $(BASEPATH)version.inc $(CMNPATH)board.inc $(CMNPATH)stddef.inc

OBJS		:= \
	$(BASEPATH)ctc/ctc.obj \
	$(BASEPATH)diag/diag.obj \
	$(BASEPATH)disp/disp.obj \
	$(BASEPATH)sio/sio.obj \
	$(BASEPATH)util/util.obj

LOBJS	:= \
	boot.obj \
	intvec.obj \
	storage.obj

ROMIMG	:= rom.bin

ASMOPTS	:= -li$(BASEPATH) -d _BLD_DT=$(BUILD_DT)

%.obj:	%.asm
	$(ASM) $(ASMOPTS) $<

.PHONY:	all
all:	$(LOBJS)

boot.obj:		makefile boot.asm boot.inc storage.inc $(CMNFILES) $(DIAGPATH)diag.inc

intvec.obj:		makefile intvec.asm intvec.inc

storage.obj:	makefile storage.asm storage.inc $(CMNFILES)

rom.bin:	makefile $(LOBJS) $(OBJS) minimum.lnk
	ulink -f=minimum.lnk

.PHONY: ROM
ROM: $(ROMIMG)

.PHONY:	clean
clean:
	rm -f *.obj
	rm -f $(ROMIMG)
