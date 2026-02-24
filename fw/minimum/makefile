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

CMNFILES	:= $(BASEPATH)version.inc $(CMNPATH)board.inc $(CMNPATH)stddef.inc

INCS		:= \
	$(BASEPATH)ctc/ctc.inc \
	$(BASEPATH)diag/diag.inc \
	$(BASEPATH)disp/disp.inc \
	$(BASEPATH)sio/sio.inc \
	$(BASEPATH)util/util.inc

LOBJS	:= \
	boot.obj \
	intvec.obj \
	storage.obj

ROMIMG	:= rom.bin

ASMOPTS	:= -li$(BASEPATH) -i./ -d _BLD_DT=$(BUILD_DT)

%.obj:	%.asm
	$(ASM) $(ASMOPTS) $<

.PHONY:	all
all:	$(LOBJS)

boot.obj:		makefile boot.asm boot.inc storage.inc $(CMNFILES) $(INCS)

intvec.obj:		makefile intvec.asm intvec.inc $(CMNFILES)

storage.obj:	makefile storage.asm storage.inc $(CMNFILES)

.PHONY: LIBS
LIBS:
	cd $(BASEPATH);make

rom.bin:	makefile $(LOBJS) LIBS minimum.lnk
	ulink -f=minimum.lnk

.PHONY: ROM
ROM: $(ROMIMG)

.PHONY:	clean
clean:
	rm -f *.obj
	rm -f $(ROMIMG)
