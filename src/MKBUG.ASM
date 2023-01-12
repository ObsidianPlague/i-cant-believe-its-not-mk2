**************************************************************************
*											     *
*  video game project:	  mortal kombat							*
* 											     *
*  programmer:		  edward j. boon						     *
* 											     *
*  module: mkdebug.asm --  debugging / toddview related routines	     *
* 											     *
*  copyright (c) 1993 williams electronics games, inc.			     *
*											     *
**************************************************************************
	.file	'mkbug.asm'
	.title	" <<< debugging related code >>> "

	.width	132
	.option	b,d,l
	.mnolist
*
* get the system stuff
*
	.include	"macros.hdr"		;macros
	.include	"dispequ.asm"	;display processor equates
	.include	"sysequ.asm" 	;sys.inc and gsp.inc
	.include	"mainequ.asm"
	.include	diagsequ.asm
	.include	diagaudn.asm
	.include	imgtbl.glo
	.include	mkcopy.tbl
	.include	stringh.asm

	.GLOBAL	TVPATCH,TVPATCHX
	.globl	curview,gangel
*
* routines defined in this module
*
	.DEF	TVBP,TVBPX,errort
	.def	illegal_opcode

	.if	printer
	.ref	print_dump,print_process
	.endif

	.bss	ram_intenb,16,w
	.bss	ram_intpend,16,w

	.even
	.text


***********************************************************************
*
* System Errors:
*
*  1 = 1 player state has 2 players active (THIS IS NOT GOOD)
*  2 = winner_status bad (JOY)
*  3 = exobj_er (MKUTIL)
*  4 = exprc_er (MKUTIL)
*  5 = object_setup could not get an object (mkutil)
*  6 = initobj ran out of objects
*  7 = initobj ran out of pals
*  8 = swpal ran out of pals
*  9 = rgbstuff could not find a pal
* 10 = rgbstuff could not find a pal
* 11 = color cycler could not find a pal
* 12 = scroll error
*
***********************************************************************

**************************************************************************
*												*
*  freeze											*
*												*
*  freezes the screen										*
*												*
**************************************************************************
freeze
	clr	a0
	move	a0,@f_auto_erase,w
	dint

frz2	move	@switch,a0,l
	not	a0
	btst	20,a0			; switch still in ?
	jrne	frz2			; yes
	eint
	movk	1,a0
	move	a0,@f_auto_erase,w
	die


system_lockup
	move	a0,@pf_ram,l
	pull	a0
	move	a0,b14
         movi    aud_syslock,a0
         calla   aud1
	move	@pf_ram,a0,l
         .if debug
	dint
	jruc	$			; in my office ---> hold it right there !!
         .endif
	jauc	recovery		; in the real world ---> recover

**************************************************************************

	.if debug

**************************************************************************
*											     *
*  test_obj - put a test object on object list #2 given:			     *
* 											     *
*  Input: a5 = img table									     *
*         a4 = y:x coordinates								     *
*											     *
**************************************************************************
test_obj
	push	a4
	calla	gso_dmawnz_ns
	pull	a4
	calla	set_xy_coordinates
	jauc	insobj2a8

	.endif

**************************************************************************
*												*
*  illegal_opcode										*
*												*
*  illegal opcode jumps here.									*
*												*
**************************************************************************
illegal_opcode
	movi	aud_illop,a0
	calla	aud1			; audit this

**************************************************************************
*												*
*  recovery											*
*												*
*  this code tries to salvage the game when either a error trap or a	*
*  bad opcode occurs. follow the comments, they always know !! 		*
*												*
**************************************************************************
recovery
	jauc	$

**************************************************************************
*												*
*  error trap section										*
*												*
*  this code is specifically for debugging purposes. calling consists of *
*  using the macro error_trap p1 where "p1" is the code which will be	*
*  printed on screen after everything is frozen on the screen. 		*
*												*
**************************************************************************
errort
	movi	aud_traps,a0
	calla	aud1
	jauc	$


**************************************************************************
*												*
*  toddview breakpoint routines									*
*												*
*  everytime a breakpoint is hit in toddview "tvbp" is called and before *
*  execution starts again "tvbpx" is called.						*
*												*
**************************************************************************
TVBP
	mmtm	sp,a0,a1

;**************** b4
	move	@intenb,a0,w	; disable rom protect interrupt (ext2)
;	andni	x2e|x1e|die,a0
	andni	x2e|die,a0
	move	a0,@intenb,w
;**************** b4

	push	a3
	clr	a3
	move	a3,@scrolly,l
	move	a3,@scrollx0,l
	move	a3,@scrollx,l
	move	a3,@scrollx2,l
	move	a3,@scrollx3,l
	move	a3,@scrollx4,l
	move	a3,@scrollx5,l
	move	a3,@scrollx6,l
	move	a3,@scrollx7,l
	move	a3,@scrollx8,l		; stop annoying scroll smear

;	calla	send_code_a3		; stop music
	pull	a3

;	move	@intenb,a0,w
;	move	a0,@ram_intenb,w
;	andni	x2e,a0	    		; rom protect
;	ori	die,a0			; disable display interupt
;	move	a0,@intenb,w

;	move	@intpend,a0,w
;	move	a0,@ram_intpend,w
;	andni	x2e,a0	    		; rom protect
;	andni	x1e,a0			; disable dma interupt
;	andni	die,a0			; disable display interupt
;	move	a0,@intpend,w

	mmfm	sp,a0,a1
	rets


TVBPX	
;********************** b4
	push	a0
	move	a0,@1e00000h,w	; clear write-to-rom interrupt

	move	@intenb,a0,w
;	ori	x2e,a0	    	; enable rom protect interrupt (ext2)
	ori	die,a0
	move	a0,@intenb,w

	move	@intpend,a0,w
	andni	x2e|die,a0
	move	a0,@intpend,w
;********************** b4

;	move	@ram_intenb,a0,w
;	move	a0,@intenb,w
;	move	@ram_intpend,a0,w
;	move	a0,@intpend,w
;	move	@ram_intenb,a0,w
;	ori	x2e,a0
;	move	a0,@intenb,w
;	move	@intpend,a0,w
;	andni	x1e,a0			; disable dma interupt
;	move	a0,@intpend,w
;	calla	test_it

	pull	a0
	rets

**************************************************************************
*											     *
*   tv patch area									     *
*											     *
**************************************************************************
TVPATCH:
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
TVPATCHX:
