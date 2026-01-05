# Silky Design - Z80 Retro Motherboard

This is a Z80-based 'retro-style' Single Board Computer (motherboard).

The motherboard includes enough to run stand-alone. That includes:

1. Z80 CPU
2. Reset circuit, divided into a POR board/system reset and a Z80/CPU only reset
3. Memory Management Unit (MMU) that provides bank selecting 8 of 32 8K banks (2M physical address)
4. 512K bytes RAM and 512K bytes Flash ROM
5. 2 Serial ports with one RS232 and one USB interface
6. Programmable BAUD rate generator
7. RP2040 module for SD card, USB KBD, and RTC interface
8. Fully buffered RC2014-80 Extended/Enhanced Bus
9. CPU and Peripheral clock control to allow 12MHz CPU with 6MHz SIO & CTC

The design started with much more on the board, but has been paired down to make the size and complexity of the board more reasonable. The 'features' that have been removed have been moved into projects of their own to be built-out as expansion boards.
