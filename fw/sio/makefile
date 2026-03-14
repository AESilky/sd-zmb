#
# Copyright 2025-26 AESilky
# SPDX-License-Identifier: MIT License
#
.PHONY:	all clean

# Define a variable with the current date/time
BUILD_DT 	:= $(shell date +"\"%Y%m%d-%H:%M\"")

ASM		:= uasz80
ALINK	:= ulink

BASEPATH	:= ../
CMNPATH		:= $(BASEPATH)cmn/

CMNFILES	:= $(CMNPATH)board.inc $(CMNPATH)stddef.inc
SIOCMN		:= sio_i.inc

ASMOPTS	:= -li$(BASEPATH) -i./ -d _BLD_DT=$(BUILD_DT)


%.obj:	%.asm
	$(ASM) $(ASMOPTS) $<

all:	sio.obj sio_ops.obj


sio.obj:	makefile sio.asm sio.inc $(SIOCMN) $(CMNFILES)

sio_ops.obj:	makefile sio_ops.asm sio_ops.inc $(SIOCMN) $(CMNFILES)

clean:
	rm *.obj
