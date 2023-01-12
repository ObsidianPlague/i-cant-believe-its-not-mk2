*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³																								³
*³ File		:	pal.h																		³
*³ Contents	:																				³
*³ Project	:	Space Hulk																³
*³ Programmer	:	Jamie Rivett														³
*³ Last mod	:	3/23/92																	³
*³																								³
*³ COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.						³
*³																								³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*Palette allocator equates

*Palette allocation ram
*For each color palette ID 32 Bits
*Not used: Palette count 16 bits
*IF PALCNT>0 PALETTE IS ALLOCATED, IF PALCNT=0 PALETTE IS FREE

NUM_PALETTES	.set	16		;max number of palettes
PALTAB_SIZE		.set	32		;size of palette allocation table

;NUMPAL	.SET	64	;# Palettes in pal table
;NMFPAL	.SET	32	;# foregnd pals
;NMBPAL	.SET	32	;# backgnd pals

*struct PAL
PALID	.SET	0	;UHL 32 BIT PALETTE I.D. (ADDRESS OF ACTUAL PALETTE)
*endstruct

PALRSIZ	.SET	32	;SIZE OF PALETTE ALLOCATION RAM

* pal transfer equates

PALQ_ENTRY_SIZE	.equ	32+16+16	;src 32, dest 16, # cols 16
PALQ_MAX_ENTRY		.equ	32		;max number of entries
PALQ_SIZE			.equ	PALQ_ENTRY_SIZE * PALQ_MAX_ENTRY

*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
* END

