	.file	'diagprnt.asm'
	.title	"<<< printer primitives >>>"
	.width	132
	.option	b,d,l,t
	.mnolist

**************************************************************************
*									    			*
*	copyright (c) 1990 williams electronics games, inc.		 	*
*	all rights reserved.						 			*
*									    			*
**************************************************************************
	.include	"dispequ.asm"		;display processor equates
	.include	"sysequ.asm"			;system equates
	.include	"mainequ.asm"
	.include	"imgtbl.glo"
	.include	"stringh.asm"

	.include	"diagsequ.asm"
	.include	"diagmequ.asm"
	.include	"diagaudn.asm"
	.include	"dipequ.asm"

	.if	printer

	.ref	get_adj
	.ref	def_page, aud, aud1, set_page
	.ref	rc_byte, rc_bytei, rc_word, rc_wordi
	.ref	wc_byte, wc_bytei, wc_word, wc_wordi
	.ref	wipeout
	.ref	p_fork, adj_page
	.ref	checkdipfree, read_dip, forcedip
	.ref	g_cred
	.ref	get_cspt
	.ref	aud1, store_audit, get_aud
	.ref	rom_name
	.ref	printaudtable
	.ref	printcointable
	.ref	cat_a0, strcat
	.ref	get_plays
	.ref	cred_p
	.ref	gameunits

	.def	printp, fbalive, rawprint, doggyprint
	.def	pbufck,print_process
	.def	printauds
	.def	printerin,printerout,printdead
	.def	pgamestart, pgameend, pgamebuyin, pgamecont, pidied
	.def	pgamewarp
	.def	offtime, laststack,lasta0
	.def	plcoin,prcoin,pscoin, pbadguy
	.def	pgamelevel
	.def	print_dump,cat_dump

pbufsize	equ	2048		; buffer size -- must be power of 2
	.bss	offtime,32
	.bss	laststack,32		; last stack pointer
	.bss	lasta0,32		; last value of a0
	.bss	printerin,16		; input pointer
	.bss	printerout,16		; output pointer
	.bss	printerbuf,8*pbufsize	; printer buffer
	.bss	printdead,16		; printer status flag
	.bss	worknum,16
	.bss	workstr,32
	.bss	aregfile,16*32
	.bss	stackfile,10*32
	.bss	mystring,128*8
	.bss	stringerflag,16

**************************************************************************
*									    *
*	printer equates							 *
*									    *
**************************************************************************

printstrobe	equ	0efffh	; strobe line low
printunstrobe	equ	0ff00h	; unstrobe the line
printreset	equ	0df00h	; printer reset

**************************************************************************
*									    *
*	global variables						 *
*									    *
**************************************************************************
	.text
	.even

**************************************************************************
*												*
*   watch "cat" printer dump									*
*												*
**************************************************************************
cat_dump
	movi	msg_cat,a8
	jsrp	printp			; print intro line
;	<<<<< fall through >>>>>

**************************************************************************
*											     *
* 	dumpprint									     *
* 											     *
* 	print out a lot of useful information to the printer		     *
* 											     *
* 	entry										     *
* 		all the registers/top 10 stack words			     *
* 											     *
* 	exit										     *
* 		nothing									     *
*											     *
**************************************************************************
print_dump
	mmtm	sp,a0,a1,a2,a8
	move	a0,@aregfile,l			; a0
	movi	aregfile+20h,a0
	move	a1,*a0+,l
	move	a2,*a0+,l
	move	a3,*a0+,l
	move	a4,*a0+,l
	move	a5,*a0+,l
	move	a6,*a0+,l
	move	a7,*a0+,l
	move	a8,*a0+,l
	move	a9,*a0+,l
	move	a10,*a0+,l
	move	a11,*a0+,l
	move	a12,*a0+,l
	move	a13,*a0+,l
	move	a14,*a0+,l

	movi	dumpmess,a8
	jsrp	printp
	movi	dmtime,a8
	movi	audontime,a0
	calla	get_aud
	movk	1,a2
	calla	formatline

	movi	aregprint,a8
	jsrp	printp
	callr	newline

	move	b0,@aregfile,l			; b0
	movi	aregfile+20h,b0
	move	b1,*b0+,l
	move	b2,*b0+,l
	move	b3,*b0+,l
	move	b4,*b0+,l
	move	b5,*b0+,l
	move	b6,*b0+,l
	move	b7,*b0+,l
	move	b8,*b0+,l
	move	b9,*b0+,l
	move	b10,*b0+,l
	move	b11,*b0+,l
	move	b12,*b0+,l
	move	b13,*b0+,l
	move	b14,*b0+,l
	move	@aregfile,b0,l		; restore b0
	movi	bregprint,a8
	jsrp	printp
	callr	newline
	
	movi	11,a2
	move	sp,a1			; grab the stack
	addi	0a0h,a1
	movi	aregfile,a0
dsloop
	move	*a1+,*a0+,l
	dsjs	a2,dsloop
	movi	stackprint,a8
	jsrp	printp
	callr	newline

*
* print football specific variables
*
	movi	ernum_print,a8
	jsrp	printp
	movi	gstate_print,a8
	jsrp	printp
	movi	offplay_print,a8
	jsrp	printp
	movi	defplay_print,a8
	jsrp	printp
	movi	ball_print,a8
	jsrp	printp
	movi	ballcar_print,a8
	jsrp	printp
	movi	offense_print,a8
	jsrp	printp
	movi	hiram_dump,a8
	jsrp	printp
	movi	higam_dump,a8
	jsrp	printp

	mmfm	sp,a0,a1,a2,a8
	rets

msg_cat
	.string "***** watch cat activated *******",0ah,0
	.even

dumpmess
	.string	"\b****************************************\b",0ah,00
	.word	1
	.word	0
	.even

dmtime	.string	"dump time ",0
	.even

aregprint
	.string	" -  a0  -  -  a1  -  -  a2  -  -  a3  - ",0ah
	.string	" %08lx  %08lx  %08lx  %08lx",0ah
	.string	" -  a4  -  -  a5  -  -  a6  -  -  a7  - ",0ah
	.string	" %08lx  %08lx  %08lx  %08lx",0ah
	.string	" -  a8  -  -  a9  -  -  a10 -  -  a11 - ",0ah
	.string	" %08lx  %08lx  %08lx  %08lx",0ah
	.string	" -  a12 -  -  a13 -  -  a14 - ",0ah
	.string	" %08lx  %08lx  %08lx ",0ah,0
	.long	aregfile+00h, aregfile+20h, aregfile+40h, aregfile+60h
	.long	aregfile+80h, aregfile+0a0h, aregfile+0c0h, aregfile+0e0h
	.long	aregfile+100h, aregfile+120h, aregfile+140h, aregfile+160h
	.long	aregfile+180h, aregfile+1a0h, aregfile+1c0h
	.byte	0
	.even

bregprint
	.string	" -  b0  -  -  b1  -  -  b2  -  -  b3  - ",0ah
	.string	" %08lx  %08lx  %08lx  %08lx",0ah
	.string	" -  b4  -  -  b5  -  -  b6  -  -  b7  - ",0ah
	.string	" %08lx  %08lx  %08lx  %08lx",0ah
	.string	" -  b8  -  -  b9  -  -  b10 -  -  b11 - ",0ah
	.string	" %08lx  %08lx  %08lx  %08lx",0ah
	.string	" -  b12 -  -  b13 -  -  b14 - ",0ah
	.string	" %08lx  %08lx  %08lx ",0ah,0
	.long	aregfile+00h, aregfile+20h, aregfile+40h, aregfile+60h
	.long	aregfile+80h, aregfile+0a0h, aregfile+0c0h, aregfile+0e0h
	.long	aregfile+100h, aregfile+120h, aregfile+140h, aregfile+160h
	.long	aregfile+180h, aregfile+1a0h, aregfile+1c0h
	.byte	0
	.even

stackprint
	.string	" -  s0  -  -  s1  -  -  s2  -  -  s3  - ",0ah
	.string	" %08lx  %08lx  %08lx  %08lx",0ah
	.string	" -  s4  -  -  s5  -  -  s6  -  -  s7  - ",0ah
	.string	" %08lx  %08lx  %08lx  %08lx",0ah
	.string	" -  s8  -  -  s9  - ",0ah
	.string	" %08lx  %08lx ",0ah,0
	.long	aregfile+00h, aregfile+20h, aregfile+40h, aregfile+60h
	.long	aregfile+80h, aregfile+0a0h, aregfile+0c0h, aregfile+0e0h
	.long	aregfile+100h, aregfile+120h
	.byte	0
	.even

ernum_print
	.string "boon trap number = %d",0ah,0
	.long	errnum

gstate_print
	.string "game state = %x",0ah,0
	.long	gstate

offplay_print
	.string "offplay = %x",0ah,0
	.long	offplay

defplay_print
	.string "defplay = %d",0ah,0
	.long	defplay

ball_print
	.string "ball object = %08lx",0ah,0
	.long	ball

ballcar_print
	.string "ball carrier object = %08lx",0ah,0
	.long	ballcar

offense_print
	.string "offense flag = %d",0ah,0
	.long	offense

hiram_dump
	.string "hiram dump:",0ah
	.string	" %08lx  %08lx  %08lx  %08lx",0ah	; 1
	.string	" %08lx  %08lx  %08lx  %08lx",0ah	; 2
	.string	" %08lx  %08lx  %08lx  %08lx",0ah	; 3
	.string	" %08lx  %08lx  %08lx  %08lx",0ah	; 4
	.string	" %08lx  %08lx  %08lx  %08lx",0ah	; 5
	.string	" %08lx  %08lx  %08lx  %08lx",0ah	; 6
	.byte	0
	.long	hiram+00h,hiram+20h,hiram+40h,hiram+60h		; 1
	.long	hiram+80h,hiram+>a0,hiram+>c0,hiram+>e0		; 2
	.long	hiram+100h,hiram+120h,hiram+140h,hiram+160h	; 3
	.long	hiram+180h,hiram+1a0h,hiram+1c0h,hiram+1e0h	; 4
	.long	hiram+200h,hiram+220h,hiram+240h,hiram+260h	; 5
	.long	hiram+280h,hiram+2a0h,hiram+2c0h,hiram+2e0h	; 6
	.byte	0
	.even

higam_dump
	.string "higam dump:",0ah
	.string	" %08lx  %08lx  %08lx  %08lx",0ah  ; 1
	.string	" %08lx  %08lx  %08lx  %08lx",0ah  ; 2
	.string	" %08lx  %08lx  %08lx  %08lx",0ah  ; 3
	.string	" %08lx  %08lx  %08lx  %08lx",0ah  ; 4
	.string	" %08lx  %08lx  %08lx  %08lx",0ah  ; 5
	.string	" %08lx  %08lx  %08lx  %08lx",0ah  ; 6
	.string	" %08lx  %08lx  %08lx  %08lx",0ah  ; 7
	.string	" %08lx  %08lx  %08lx  %08lx",0ah  ; 8
	.string	" %08lx  %08lx  %08lx  %08lx",0ah  ; 9
	.string	" %08lx  %08lx  %08lx  %08lx",0ah  ; 10
	.string	" %08lx  %08lx  %08lx  %08lx",0ah  ; 11
	.string	" %08lx  %08lx  %08lx  %08lx",0ah  ; 12
	.byte	0

	.long	higam+00h,higam+20h,higam+40h,higam+60h		; 1
	.long	higam+80h,higam+>a0,higam+>c0,higam+>e0		; 2
	.long	higam+100h,higam+120h,higam+140h,higam+460h	; 3
	.long	higam+180h,higam+1a0h,higam+1c0h,higam+4e0h	; 4
	.long	higam+200h,higam+220h,higam+240h,higam+460h	; 5
	.long	higam+280h,higam+2a0h,higam+2c0h,higam+4e0h	; 6
	.long	higam+300h,higam+320h,higam+340h,higam+460h	; 7
	.long	higam+380h,higam+3a0h,higam+3c0h,higam+4e0h	; 8
	.long	higam+400h,higam+420h,higam+440h,higam+460h	; 9
	.long	higam+480h,higam+4a0h,higam+4c0h,higam+4e0h	; 10
	.long	higam+500h,higam+520h,higam+540h,higam+560h	; 11
	.long	higam+580h,higam+5a0h,higam+5c0h,higam+5e0h	; 12
	.byte	0
	.even

**************************************************************************
*									    *
*	pgamestart							 *
*									 *
*	print out a game start						 *
*									    *
**************************************************************************

pgamestart
	mmtm	sp,a0,a1,a2,a3,a4,a8
;	calla	gplaynum		; ( off of a2 )
	clr	a0
	sll	5,a0
	addi	mgstarttab,a0
	move	*a0,a8,l
	callr	setred
	movi	audontime,a0
	calla	get_aud
	movk	1,a2
	calla	formatline
	callr	setblack
	mmfm	sp,a0,a1,a2,a3,a4,a8
	rets

mgstarttab
	.long	mgstart1, mgstart2, mgstart3, mgstart4

mgstart1
	.string	"game start by rex",0
	.even
mgstart2
	.string	"game start by bloop",0
	.even
mgstart3
	.string	"game start by spike",0
	.even
mgstart4
	.string	"game start by gwen",0
	.even

;
;	a8 is the level ( 0 -> 3 ) to use
;

pgamelevel
	mmtm	sp,a0,a1,a2,a3,a4,a8
	sll	5,a8
	addi	mgleveltab,a8
	move	*a8,a8,l
	movi	audontime,a0
	calla	get_aud
	movk	1,a2
	calla	formatline
	mmfm	sp,a0,a1,a2,a3,a4,a8
	rets

mgleveltab
	.long	mglevel1, mglevel2, mglevel3, mglevel4

mglevel1
	.string	"instructional level",0
	.even
mglevel2
	.string	"easy level",0
	.even
mglevel3
	.string	"advanced level",0
	.even
mglevel4
	.string	"expert level",0
	.even


pgameend
	mmtm	sp,a0,a1,a2,a3,a4,a8
;	calla	gplaynum		; ( off of a2 )
	clr	a0
	sll	5,a0
	addi	mgendtab,a0
	move	*a0,a8,l
	callr	setred
	movi	audontime,a0
	calla	get_aud
	movk	1,a2
	calla	formatline
	callr	setblack
	movi	mgendcreds,a8
	move	@gameunits,a1,w		; units used
	clr	a2
	calla	formatline
	mmfm	sp,a0,a1,a2,a3,a4,a8
	rets
mgendtab
	.long	mgend1, mgend2, mgend3, mgend4

mgend1	.string	"game end by rex",0
	.even
mgend2	.string	"game end by bloop",0
	.even
mgend3	.string	"game end by spike",0
	.even
mgend4	.string	"game end by gwen",0
	.even
mgendcreds
	.string	"credits used",0
	.even

pgamebuyin
	mmtm	sp,a0,a1,a2,a3,a4,a8
;	calla	gplaynum		; ( off of a2 )
	clr	a0
	sll	5,a0
	addi	mgbuyintab,a0
	move	*a0,a8,l
	movi	audontime,a0
	calla	get_aud
	movk	1,a2
	calla	formatline
	mmfm	sp,a0,a1,a2,a3,a4,a8
	rets

mgbuyintab
	.long	mgbuyin1, mgbuyin2, mgbuyin3, mgbuyin4

mgbuyin1
	.string	"game buyin by rex",0
	.even
mgbuyin2
	.string	"game buyin by bloop",0
	.even
mgbuyin3
	.string	"game buyin by spike",0
	.even
mgbuyin4
	.string	"game buyin by gwen",0
	.even

pidied
	mmtm	sp,a0,a1,a2,a3,a4,a8
;	calla	gplaynum		; ( off of a2 )
	clr	a0
	sll	5,a0
	addi	mgdeadtab,a0
	move	*a0,a8,l
	movi	audontime,a0
	calla	get_aud
	movk	1,a2
	calla	formatline
	mmfm	sp,a0,a1,a2,a3,a4,a8
	rets

mgdeadtab
	.long	mgdead1, mgdead2, mgdead3, mgdead4

mgdead1	.string "rex final death",0
	.even
mgdead2	.string "bloop final death",0
	.even
mgdead3	.string "spike final death",0
	.even
mgdead4	.string "gwen final death",0
	.even

setred
	push	a0
	movi	1bh,a0
	callr	paddchar
	movi	34h,a0
	callr	paddchar
	pull	a0
	rets

setblack
	push	a0
	movi	1bh,a0
	callr	paddchar
	movi	35h,a0
	callr	paddchar
	pull	a0
	rets

pgamecont
	mmtm	sp,a0,a1,a2,a3,a4,a8
;	calla	gplaynum		; ( off of a2 )
	clr	a0
	sll	5,a0
	addi	mgconttab,a0
	move	*a0,a8,l
	movi	audontime,a0
	calla	get_aud
	movk	1,a2
	calla	formatline
	mmfm	sp,a0,a1,a2,a3,a4,a8
	rets

mgconttab
	.long	mgcont1, mgcont2, mgcont3, mgcont4

mgcont1	.string	"game continue by rex",0
	.even
mgcont2	.string	"game continue by bloop",0
	.even
mgcont3	.string	"game continue by spike",0
	.even
mgcont4	.string	"game continue by gwen",0
	.even

pgamewarp
	mmtm	sp,a0,a1,a2,a3,a4,a8
	movi	mgwarp,a8
	calla	stringf
	movi	audontime,a0
	calla	get_aud
	movk	1,a2
	calla	formatline
	mmfm	sp,a0,a1,a2,a3,a4,a8
	rets

mgwarp	.string	"---> warp to wave ",0
	.even

dino_tab:
	.long	p1name,p2name,p3name,p4name,0
p1name:
	.string	"rex",0
	.even
p2name:
	.string	"bloop",0
	.even
p3name:
	.string	"spike",0
	.even
p4name:
	.string	"gwen",0
	.even

**************************************************************************
*									    *
*	pbadguy								 *
*									 *
*	plot the various messages as a guy clears credits and things	 *
*									 *
*	entry								 *
*		a0	which message to put up				 *
*									 *
*	exit								 *
*		nothing							 *
*									 *
*	call								 *
*		calla							 *
*									    *
**************************************************************************

pbadguy
	mmtm	sp,a0,a1,a2,a3,a4,a8
	sll	5,a0
	addi	pbcruncher,a0
	move	*a0,a8,l
	movi	audontime,a0
	calla	get_aud
	movk	1,a2
	callr	setred
	calla	formatline
	callr	setblack
	mmfm	sp,a0,a1,a2,a3,a4,a8
	rets

pbcruncher:
	.long	pbstr0,pbstr1,pbstr2,pbstr3,pbstr4,pbstr5,pbstr6,pbstr7
	.long	pbstr8,pbstr9,pbstr10
	


pbstr0	.string	"clear coin counts",0
	.even
pbstr1	.string	"set operator message",0
	.even
pbstr2	.string	"clear credits",0
	.even
pbstr3	.string	"bogus message",0
	.even
pbstr4	.string	"clear game audits",0
	.even
pbstr5	.string	"reset high scores",0
	.even
pbstr6	.string	"default adjustments",0
	.even
pbstr7	.string	"full factory restore",0
	.even
pbstr8	.string	"enter test mode",0
	.even
pbstr9	.string	"cmos reset, dude!",0
	.even
pbstr10	.string	"cmos totally out to lunch",0
	.even



**************************************************************************
*									    *
*	doggyprint							 *
*									 *
*	something hit the watch dog -- bark!				 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

doggyprint:
	push	a8
	movi	dogmess,a8
	callr	rawprint		; ain't got nothing to do
	pull	a8
	calla	read_dip
	andi	40h,a0
	jrnz	doggydone		;  don't print if ds1-7 on
	callr	doggydump
doggydone
	rets

dogmess
	.byte	0ah
	.byte	1bh, 34h
	.string	"watch dog reset detected"
	.byte	1bh, 35h
	.byte	0ah,0
	.word	1
	.word	0
	.even

doggydump
	.if	debug
	rets				; don't lockup on this thing
	.endif
	.if	yunit
	.else
	rets				; return on z units
	.endif
	mmtm	sp,a0,a1,a2,a8
	move	@lasta0,a0,l		; fake out the system
	move	a0,@aregfile,l			; a0
	movi	aregfile+20h,a0
	move	a1,*a0+,l
	move	a2,*a0+,l
	move	a3,*a0+,l
	move	a4,*a0+,l
	move	a5,*a0+,l
	move	a6,*a0+,l
	move	a7,*a0+,l
	move	a8,*a0+,l
	move	a9,*a0+,l
	move	a10,*a0+,l
	move	a11,*a0+,l
	move	a12,*a0+,l
	move	a13,*a0+,l
	move	a14,*a0+,l

	movi	dumpmess,a8
	callr	rawprintp
;	movi	dmtime,a8
;	movi	audontime,a0
;	calla	get_aud
;	movk	1,a2
;	calla	formatline

	movi	aregprint,a8
	callr	rawprintp
;	callr	newline
	move	b0,@aregfile,l			; b0
	movi	aregfile+20h,b0
	move	b1,*b0+,l
	move	b2,*b0+,l
	move	b3,*b0+,l
	move	b4,*b0+,l
	move	b5,*b0+,l
	move	b6,*b0+,l
	move	b7,*b0+,l
	move	b8,*b0+,l
	move	b9,*b0+,l
	move	b10,*b0+,l
	move	b11,*b0+,l
	move	b12,*b0+,l
	move	b13,*b0+,l
	move	b14,*b0+,l
	move	@aregfile,b0,l		; restore b0
	movi	bregprint,a8
	callr	rawprintp
;	callr	newline

	movi	stackloc,a8
	callr	rawprintp
	
	movi	11,a2
	move	@laststack,a1		; grab what we saw as a stack
;	addi	0a0h,a1
	movi	aregfile,a0
rawdsloop
	move	*a1+,*a0+,l
	dsjs	a2,rawdsloop
	movi	stackprint,a8
	callr	rawprintp
;	callr	newline

	mmfm	sp,a0,a1,a2,a8
	
	rets

stackloc
	.string	"stack pointer = %08lx",0ah,00
	.long	laststack



**************************************************************************
*											     *
* 	fbalive										     *
* 											     *
* 	print out a welcome to newgame message					     *
* 											     *
* 	entry										     *
* 		nothing									     *
* 											     *
* 	exit										     *
* 		nothing									     *
*											     *
**************************************************************************
fbalive
	.if	printer
	create	pid_print,trogprint
	.endif
	rets

trogprint
	movi	trogstartup,a8
	jsrp	printp

;	movi	auduptime,a0
;	calla	get_aud
;	movk	1,a2
;	movi	puptime,a8
;	callr	formatline
;	move	@offtime,a1,l
;	movi	palivetime,a8
;	movk	1,a2
;	callr	formatline			; kick out last alive time
;	callr	printcreds
	die

trogstartup
	.string	"\bnewgame\b"
	.string	"\nversion: %s"
	.byte	0ah, 0
	.word	1
	.word	0
	.long	rom_name
	.even

printcreds
	movi	totcreds,a8
	clr	a2
	calla	cred_p			; credits on machine
	move	a0,a1
	callr	formatline
	callr	newline
	rets

totcreds
	.string	"total game credits",0
	.even

puptime
	.string	"total game uptime",0
	.even

palivetime
	.string	"time last on for",0
	.even


**************************************************************************
*									    *
*	plcoin								 *
*	prcoin								 *
*	pscoin								 *
*									 *
*	print out time stamps for the coins (left,right,service)	 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									 *
*	call								 *
*		jsrp							 *
*									    *
**************************************************************************

plcoin:
	movi	mlcoin,a8
	jruc	pcoin

prcoin:
	movi	mrcoin,a8
	jruc	pcoin

pscoin:
	movi	mscoin,a8

pcoin:
	movi	audontime,a0
	calla	get_aud
	movk	1,a2
	calla	formatline
	retp

mlcoin	.string	"left coin",0
	.even

mrcoin	.string	"right coin",0
	.even

mscoin	.string	"service credit",0
	.even



**************************************************************************
*									    *
*	printauds							 *
*									 *
*	print out the audit table					 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

printauds:
	.if	printer
	jsrp	printcoinage
	
	movi	paudheader,a8
	jsrp	printp

	movi	printaudtable,a11
paloop
	move	*a11+,a8,l		; get text string
	jrz	padone
	move	*a11+,a0,w		; which audit
	move	*a11+,a2,w		; which format
	calla	get_aud			; get the value ( in a1 )
	callr	formatline1
	jruc	paloop
padone
	sleep	5
	callr	pbufck
	jrnz	padone		; empty out the buffer first
	.endif
	retp

paudheader
	.string	"\n\n\bnewgame game audits :\b\n",0
	.word	1
	.word	0
	.even

pcr
	.byte	0ah,00h
	.even


**************************************************************************
*									    *
*	printcoinage							 *
*									 *
*	print out the coinage stuff					 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

printcoinage:
	
	movi	pcoinheader,a8
	jsrp	printp

	movi	printcointable,a11
pcloop
	move	*a11+,a8,l		; get text string
	jrz	pcdone
	move	*a11+,a0,w		; which audit
	move	*a11+,a2,w		; which format
	calla	get_aud			; get the value ( in a1 )
	callr	formatline1
	jruc	pcloop
pcdone
	sleep	5
	callr	pbufck
	jrnz	pcdone		; empty out the buffer first
	retp

pcoinheader
	.string	"\n\n\bnewgame coin bookkeeping :\b\n",0
	.word	1
	.word	0
	.even

**************************************************************************
*											     *
* 	formatline									     *
* 											     *
* 	format a line for printing ( left on right, value on right )    *
* 											     *
* 	entry										     *
* 		a1	value								     *
* 		a2	format								     *
* 		a8	left string							     *
* 											     *
* 	exit										     *
* 		nothing									     *
*											     *
**************************************************************************
formatline1:
	mmtm	sp,a0,a5
	jsrp	printp
	jruc	formatlinego

formatline:
	mmtm	sp,a0,a5
	jsrp	nsprintp
formatlinego
	callr	slen			; length of what we plotted
	move	a0,a5
	move	a2,a2			; simple number
	jrnz	flck2
flnum
	push	a0
	move	a1,a0
	movi	mystring,a7
	calla	cat_a0
	movi	mystring,a8
	pull	a0
	jruc	flend
flck2
	cmpi	1,a2			; check for time
	jrnz	flck3
	move	a1,a3
	callr	formattime
	jruc	flend
flck3	
	cmpi	2,a2			; check for total plays
	jrnz	flck4
	calla	get_plays
	move	a2,a1
	jruc	flnum
flck4
	cmpi	3,a2			; check for time/credit
	jrnz	flck5
	mmtm	sp,a0,a1,a2
	clr	a3
*************
;	movi	audnumtc,a0
;	calla	get_aud		; get the divisor
	clr	a1
*************
	move	a1,a2
	jrz	dtcgo		; no /0's here, bud

******************
;	movi	audavgtc,a0
;	calla	get_aud		; get total time
	clr	a1
******************

	clr	a0
	divu	a2,a0		; a0 contains the real number
	move	a0,a3		; number to display
dtcgo
	mmfm	sp,a0,a1,a2
	callr	formattime
	jruc	flend
flck5
	cmpi	4,a2
	jrnz	flck6
	mmtm	sp,a0,a1,a2
	clr	a3
*************
;	movi	audnumtl,a0
;	calla	get_aud		; get the divisor
	clr	a1
*************
	move	a1,a2
	jrz	dtlgo		; no /0's here, bud
;	movi	audavgtl,a0
;	calla	get_aud		; get total time
	clr	a0
	divu	a2,a0		; a0 contains the real number
	move	a0,a3		; number to display
dtlgo
	mmfm	sp,a0,a1,a2
	callr	formattime
	jruc	flend

flck6
	cmpi	5,a2
	jrnz	flck7
	mmtm	sp,a0,a1,a2
	clr	a3
;	movi	audnumtg,a0
;	calla	get_aud		; get the divisor
	move	a1,a2
	jrz	dawgo		; no /0's here, bud
;	movi	audwavecnt,a0
;	calla	get_aud		; get total time
	clr	a0
	divu	a2,a0		; a0 contains the real number
	move	a0,a3		; number to display
dawgo
	mmfm	sp,a0,a1,a2
	move	a3,a1
	jruc	flnum
flck7
	cmpi	6,a2
	jrnz	flck8
	mmtm	sp,a0,a1,a2
	clr	a3
;	movi	audnumtg,a0
;	calla	get_aud		; get the divisor
	move	a1,a2
	jrz	dacgo		; no /0's here, bud

;	movi	audavggc,a0
;	calla	get_aud		; get total credits spent
	clr	a0
	divu	a2,a0		; a0 contains the real number
	move	a0,a3		; number to display
dacgo
	mmfm	sp,a0,a1,a2
	move	a3,a1
	jruc	flnum
flck8
	jruc	flnoplot		; anything else
flend
	callr	slen			; figure out length of string
	add	a5,a0			; total length
	movi	40,a1			; 40 chars/line
	sub	a0,a1
	callr	pspaces			; plot this many spaces
	jsrp	pstringer		; plot out the number
flnoplot
	movi	pcr,a8
	jsrp	nsprintp
	mmfm	sp,a0,a5
	rets

newline
	push	a8
	movi	pcr,a8
	jsrp	nsprintp
	pull	a8
	rets
	
**************************************************************************
*									    *
*	formattime							 *
*									 *
*	entry								 *
*		a3	time to plot					 *
*									 *
*	exit								 *
*		a8	string pointer					 *
*									    *
**************************************************************************

formattime:
	mmtm	sp,a0,a1,a2,a7,a9,a10,a11
	clr	a9			; no seconds
	clr	a10			; no minutes
	clr	a11			; no hours
	movi	mystring,a7		; string to build in
	move	a3,a1			; base value
	jrz	pnotime

	clr	a0			; dividend in <a0><a1>
	movi	60,a2			; 60 secs/minute
	divu	a2,a0			; a0 = minutes, a1 = seconds
	move	a1,a9			; set seconds
	move	a0,a1			; minutes/hours
	jrz	pnotime
	clr	a0
	divu	a2,a0			; a0 = hours, a1 = minutes
	move	a1,a10
	move	a0,a11

pnotime
	move	a11,a0
	jrz	pnohours
	calla	cat_a0			; hours
	movi	me_colon,a8
	calla	strcat
pnohours
	move	a10,a0
	cmpi	10,a0
	jrhs	p1
	clr	a0
	calla	cat_a0			; insert extra zero
	move	a10,a0
p1
	calla	cat_a0			; minutes
	movi	me_colon,a8
	calla	strcat
	move	a9,a0
	cmpi	10,a0
	jrhs	p2
	clr	a0
	calla	cat_a0			; insert extra zero
	move	a9,a0
p2
	calla	cat_a0			; seconds
	mmfm	sp,a0,a1,a2,a7,a9,a10,a11
	movi	mystring,a8
	rets

me_colon:
	.string	":",0
	.even

**************************************************************************
*									    *
*	pspaces								 *
*									 *
*	print out some spaces						 *
*									 *
*	entry								 *
*		a1	number of spaces				 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

pspaces:
	cmpi	0,a1
	jrls	pdone
	movi	20h,a0
	callr	paddchar
	dec	a1
	jruc	pspaces
pdone
	rets

slen
	mmtm	sp,a1,a8
	clr	a0
sloop
	movb	*a8,a1
	jrz	sdone
	addk	8,a8	
	inc	a0
	jruc	sloop
sdone
	mmfm	sp,a1,a8
	rets
	


**************************************************************************
*									    *
*	printp								 *
*									 *
*	stringf a string and print it out				 *
*									 *
*	entry								 *
*		a8	string to print					 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************
	
printp:	
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a9,a10,a11
	calla	read_dip		; check if printer enabled
	andi	80h,a0
	jrnz	printpret
	calla	stringf
	pushp	a8
	jsrp	pstringer
	pullp	a8
printpret
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a9,a10,a11
	retp

nsprintp:	
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	calla	read_dip		; check if printer enabled
	andi	80h,a0
	jrnz	nsprintpret
	jsrp	pstringer
nsprintpret
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	retp

rawprintp:	
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	calla	read_dip		; check if printer enabled
	andi	80h,a0
	jrnz	rawprintpret
	calla	stringf
	callr	rawprint
rawprintpret
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets
	
	
**************************************************************************
*									    *
*	pstringer							 *
*									 *
*	output a text string to the little baby printer			 *
*									 *
*	entry								 *
*		a8	what to print					 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

pstringer:
	mmtm	sp,a0,a1,a7,a8,a11
	callr	print_p
	jrnz	stringr2
	clr	a0
	move	a0,@printerin,w		; nothing going in or out
	move	a0,@printerout,w
	create	pid_print,print_process		; get a background printer

stringr2
	movb	*a8,a7		;get a character
	sll	24,a7
	srl	24,a7		;make sure we're positive
	jreq	stringrx	;br = string be gone brotha
	addk	8,a8		;next byte

	cmpi	' ',a7
	jrhs	strnchar	;br = it's kosh baby 

;
;	check for control characters 
;

strncont
	cmpi	new_sleep,a7	; sleep?
	jrne	strcc1
	move	*a8+,a0,w	; eat it
	jruc	stringr2
strcc1
	cmpi	new_pcolor,a7	; color
	jrne	strcc2
	move	*a8+,a1,w	; grab the new color
	jrz	scc1blk
	movi	1bh,a0
	callr	paddchar	; esc
	movi	34h,a0
	callr	paddchar
	jruc	stringr2
scc1blk
	movi	1bh,a0
	callr	paddchar
	movi	35h,a0
	callr	paddchar
	jruc	stringr2
strcc2
	cmpi	new_control,a7	; dma control flags
	jrne	strcc3
	move	*a8+,a0,w	; eat it
	jruc	stringr2	
strcc3
	cmpi	new_font,a7	; font
	jrne	strcc4
	move	*a8+,a0,l	; snag it
	jrz	scc3res
	movi	1bh,a0
	callr	paddchar
	movi	0eh,a0
	callr	paddchar
	jruc	stringr2
scc3res
	movi	1bh,a0
	callr	paddchar
	movi	14h,a0
	callr	paddchar
	jruc	stringr2
strcc4
	cmpi	new_xy,a7	; new xy location
	jrne	strcc5
	move	*a8+,a0,l	; eat it
	jruc	stringr2
strcc5
	cmpi	new_spacing,a7	; new spacing
	jrne	strcc6
	move	*a8+,a0,l	; eat it
	jruc	stringr2
strcc6
	cmpi	ascii_cr,a7	; cr
	jrnz	strcc7
	movi	0ah,a7		; set to something useful
	jruc	strnchar
strcc7
	cmpi	add_dydx,a7	; dxdy change
	jrne	strcc8
	move	*a8+,a0,l	; eat it
	jruc	stringr2
strcc8
;	jruc	stringr2	; take a pill, pass control codes to printer
;
;	output a character here
;
strnchar
	move	a7,a0
	callr	paddchar
;	move	@printerin,a0,w
;	move	a0,a1
;	sll	3,a0
;	addi	printerbuf,a0
;	movb	a7,*a0
;	inc	a1
;	andi	pbufsize-1,a1		; wrap it
;	move	a1,@printerin,w
	jruc	stringr2

stringrx
	mmfm	sp,a0,a1,a7,a8,a11
	retp

**************************************************************************
*									    *
*	paddchar							 *
*									 *
*	add a character in a0 to the printer buffer			 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

paddchar:
	mmtm	sp,a1,a2
	move	@printerin,a1,w
	move	a1,a2
	sll	3,a1
	addi	printerbuf,a1
	movb	a0,*a1
	inc	a2
	andi	pbufsize-1,a2		; wrap it
	move	a2,@printerin,w
	move	@printerout,a1,w
	cmp	a1,a2
	jrnz	pacool
	nop
pacool
	mmfm	sp,a1,a2
	rets


**************************************************************************
*									    *
*	print_process							 *
*									 *
*	just a process to manage the printer queue and try and keep	 *
*	the game from locking up too much when it runs out of paper	 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

print_timeout	equ	0ffh		; loop time for busy
print_burst	equ	50		; max chars without sleep

print_process:
	calla	read_dip		; check if printer enabled
	andi	80h,a0
	jrz	printgo1
	die
pp1
	clr	a0
	move	a0,@printdead,w		; flag printer as up

printloop	
	sleep	3			; everybody else gets a chance
	calla	read_dip		; check if printer enabled
	andi	80h,a0
	jrz	printgo1
	clr	a0
	move	a0,@printerin,w
	move	a0,@printerout,w
	die
printgo1
	move	@switch,a0,w
	andi	0c000h,a0	
	cmpi	4000h,a0
	jrz	ppgoprint
	clr	a0
	move	a0,@printerin,w
	move	a0,@printerout,w
	movk	1,a0
	move	a0,@printdead,w
	sleep	100
	jruc	printloop
ppgoprint
	clr	a4
	move	@printdead,a0,w
	jrz	ppburst			; br = printer healthy
	move	@switch,a0,w
	andi	80h,a0			; check if still busy
	jrnz	printloop		; br = boring
ppburst
	move	@printerin,a0,w
	move	@printerout,a1,w	
	cmp	a0,a1
	jrz	printloop		; br = nothing to output
	move	a1,a3
	sll	3,a1
	addi	printerbuf,a1
	movb	*a1,a0			; get the byte to print

	ori	0ff00h,a0		; unset the strobe
	move	a0,@sound,w
	andi	printstrobe,a0		; set the strobe
	move	a0,@sound,w
	ori	0ff00h,a0
	move	a0,@sound,w
	movi	print_timeout,a2
pploop
	move	@switch,a1,w
	andi	80h,a1
	jrz	ppok
	dsjs	a2,pploop		; loop waiting for busy to go away
;
;	ok, something went wrong with the printer -- never came back alive
;
	movk	1,a0
	move	a0,@printdead,w		; flag it history
	inc	a3			; output pointer
	andi	pbufsize-1,a3		; wrap it
	move	a3,@printerout,w
	sleep	5			; give it some serious time
	jruc	printloop		; try again
;
;	its a happening printer
;
ppok
	clr	a0
	move	a0,@printdead,w		; flag printer as up
	inc	a3			; output pointer
	andi	pbufsize-1,a3		; wrap it
	move	a3,@printerout,w
	inc	a4			; characters out this time
	cmpi	print_burst,a4
	jrlo	ppburst			; br = still in burst mode
	jruc	printloop


**************************************************************************
*									    *
*	rawprint							 *
*									 *
*	print out a string of characters -- this waits for it to	 *
*	finish or die, btw						 *
*									 *
*	entry								 *
*		a8	list of chars to print out			 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

rawtimeout	equ	0fffffffh	; raw printer timeout - gross, huh?

rawprint:
	mmtm	sp,a0,a1,a2,a3
rawloop
	calla	read_dip		; check if printer enabled
	andi	80h,a0
	jrnz	rawdone
	
	move	@switch,a0,w
	andi	0c000h,a0	
	cmpi	4000h,a0
	jrnz	rawdone			; error/outofpaper
	movb	*a8,a0			; get the byte to print
	move	a0,a0
	jrz	rawdone
	addk	8,a8
	ori	0ff00h,a0		; unset the strobe
	move	a0,@sound,w
	andi	printstrobe,a0		; set the strobe
	move	a0,@sound,w
	ori	0ff00h,a0
	move	a0,@sound,w
	movi	rawtimeout,a2
	clr	a3
rpwait
	move	@switch,a1,w
	andi	80h,a1
	jrz	rawloop
	inc	a3
	dsjs	a2,rpwait		; loop waiting for busy to go away
rawdone
	mmfm	sp,a0,a1,a2,a3
	rets

pemptywait:
	sleep	5
	callr	pbufck
	jrnz	pemptywait		; empty out the buffer first
	retp


**************************************************************************
*									    *
*	pbufck								 *
*									 *
*	checks to see whether there is anything in the printer buffer	 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		.z.	empty						 *
*									    *
**************************************************************************
	
pbufck:
	mmtm	sp,a0,a1
	calla	read_dip
	andi	80h,a0
	jrz	pbu1
	clr	a0
	move	a0,a0
	jruc	pburet
pbu1
	move	@printerin,a0,w
	move	@printerout,a1,w
	cmp	a0,a1
pburet
	mmfm	sp,a0,a1
	rets

**************************************************************************
*									    *
*	print_p								 *
*									 *
*	check for the existence of the printer background handler	 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		.eq.	no						 *
*		.ne.	yes						 *
*									    *
**************************************************************************

print_p	movi	pid_print,a0		; printer pid ( duh )
	movi	0ffffh,a1
	calla	existp
	rets

	.endif

