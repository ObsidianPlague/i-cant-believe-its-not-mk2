	.file	'util.asm'
	.title	" <<< general purpose subroutines >>>"

**************************************************************************
*												*
*	copyright (c) 1988 williams electronics games, inc.			*
*	all rights reserved.									*
*												*
**************************************************************************

	.width	132
	.option	b,d,l
	.mnolist

*	get the system stuff

	.include	"dispequ.asm"	;display processor equates
	.include	"sysequ.asm" 	;sys.inc and gsp.inc
	.include	"macros.hdr"		;macros, yeah!
	.include	"mainequ.asm"
	.include	imgtbl.glo

	.even
	.text

**************************************************************************
*												*
* clrworld - clear all world coordinates and scroll velocities.		*
*												*
**************************************************************************
clrworld
	push	a0
	clr	a0
	move	a0,@scrollx,l		;x scroll value
	move	a0,@scrolly,l		;y scroll value
	move	a0,@worldtlx,l		;top left x screen coord (world)
	move	a0,@worldtly,l		;top left y screen coord (world)
;	move	a0,@worldtl,l

	movi	scrnst,a0
	move	a0,@scrntl,l
	move	a0,@scrntl2,l
;	move	a0,@shad_scrntl,l

	movi	scrnend,a0
	move	a0,@scrnlr,l
	move	a0,@scrnlr2,l
	pull	a0
	rets

**************************************************************************
*												*
* random - generate a random number					 			*
* returns:								 			*
* a0 = 32 bit random #							 			*
*												*
**************************************************************************
random:	push	a1
	move	@rand,a0,l
	sla	1,a0
	jrv	rnd2
	ori	2,a0
rnd2:	move	a0,@rand,l
	clr	a1
	addc	a1,a0	;get last bit back to make 32
	move	@hcount,a1
	rl	a1,a0	;random rotation
	move	a0,a0	;set status bits
	mmfm	sp,a1
	rets	

**************************************************************************
*												*
* randu - generate a uniformly distributed random # between 1 and [a0]	*
* a0 = range input							 			*
* returns:								 			*
* a0 = random #								 			*
*												*
**************************************************************************
randu:	push	a1
	move	a0,a1
	callr	random
	mpyu	a1,a0
	inc	a0
	mmfm	sp,a1
	rets		
*
*get signed random # in range +/- a0
*calling parameters: a0
*returns a0
*
srand:
	mmtm	sp,a1
	move	a0,a1
	sll	1,a0
	calla	randu
	sub	a1,a0
	mmfm	sp,a1
	rets

**************************************************************************
*											     *
*  randper - random % routine								     *
*  calling parameters:									     *
*  a0=probability of event (0-1000) p(a0=1000) = 1; p(a0=1) = 1/1000.    *
*  returns cs if probability is true, cc for false				     *
*  returns a0 = actual random # 0-999							     *
*											     *
**************************************************************************
randper:
	mmtm	sp,a1,a2
	move	a0,a2
	calla	random
	movi	1000,a1
	mpyu	a1,a0
	cmp	a2,a0
	mmfm	sp,a1,a2
	rets		

**************************************************************************
*												*
* fillarea - fill a given square area on the screen with a color	 	*
* a1 = [color,palette]							 			*
* a3 = dag of area [ypos,xpos]						 			*
* a4 = [y,x] size of area						 			*
*												*
**************************************************************************
fillarea
	mmtm	sp,a1,a2,a4,a5
	jruc	areacon

**************************************************************************
*												*
* blnkarea - blank a given square area on the screen					*
* a3 = dag of area [ypos,xpos]									*
* a4 = [y,x] size of area									*
*												*
**************************************************************************
blnkarea
	mmtm	sp,a1,a2,a4,a5
	clr	a1			;constant 0:palette 0
areacon
	move	a4,a2
	movi	2000000h,a4		;somewhere in image rom
	movi	dmacal|>600c,a5
	calla	qdman
	mmfm	sp,a1,a2,a4,a5
	rets
*
* yflp - set object y-flip, a8:object block ptr
*
yflp	mmtm	sp,a1,a4
	move	*a8(oflags),a4
	ori	m_fliph,a4
	jruc	stuflags
*
*noyflp - clear object y-flip, a8:object block ptr	
noyflp	mmtm	sp,a1,a4
	move	*a8(oflags),a4
	andni	m_fliph,a4
stuflags
	move	*a8(oimg),a1,l		;get the current image pointer
	calla	ani			;setup the "new" image
unflpd	mmfm	sp,a1,a4
	rets

**************************************************************************
*												*
* syncfull - synchronize with the full screen interrupt			 	*
*												*
**************************************************************************
syncfull
	mmtm	sp,a0,a1
	movi	intsync1,a1
	clr	a0
	move	a0,*a1,w	;clear half screen sync
syncsd1	move	*a1,a0,w
	jreq	syncsd1		;end hasn't hit yet
	mmfm	sp,a0,a1
	rets

**************************************************************************
*												*
* dtime - used to dma an image									*
* a1 = [constant color,palette(stuffed in dtime)]					*
* a3 = dag [y,x]											*
* a5 = [offset,control]										*
* a14 = address of image header									*
*												*
**************************************************************************
dtime:
	mmtm	sp,a0,a1
	move	*a14(icmap),a0,l	;get the palette
	calla	findpal			;get the correct color map #
	jrnz	dtime1			;br = palette was found
	clr	a0			;default to fixed palette
dtime1
	movx	a0,a1
	calla	qdma			;queue this suckah
	mmfm	sp,a0,a1
	rets

**************************************************************************
*												*
* dmawait - wait on the dma busy bit to clear						*
*												*
**************************************************************************
dmawait	
	push	a0
dmawaitl
	move	@dmactrl,a0,w	;dma busy?
	jrn	dmawaitl	;br = yes
	pull	a0
	rets
**************************************************************************
*												*
* dmaqwait - wait for dma queues to empty, then wait for dma to finish	*
*	   the last one.									*
*												*
**************************************************************************
;dmaqwait
;	push	a0
;dmaqwt1
;	move	@topq0cnt,a0,w	
;	jrne	dmaqwt1
;	move	@topq1cnt,a0,w	
;	jrne	dmaqwt1
;	move	@botq0cnt,a0,w	
;	jrne	dmaqwt1
;	move	@botq1cnt,a0,w	
;	jrne	dmaqwt1
;	pull	a0
;dmaqwt2
;	move	b13,b13
;	jrz	dmawait
;	jruc	dmaqwt2

*
*scrclr - clear the screen with eugene
*only call with interrupts disabled and the dma shut down, otherwise
*	use clr_scrn
scrclr	clr	a0
*scrfil - fill screen with a0
scrfil:
	mmtm	sp,a1,a2
	clr	a1
	move	a1,@cmapsel,w			;select color map 0
	movi	screen,a1,l
	movi	(scrne-screen)/32,a2,l
scrlp	move	a0,*a1+,l
	dsjs	a2,scrlp
	mmfm	sp,a1,a2
	rets

**************************************************************************
*												*
* setpproc - setup ti's pixel processing register's (bfile), to match	*
*	   the zunit system.						 			*
* note:	   if you want to do any special tricks, don't use this. 	 	*
*												*
**************************************************************************
setpproc
	push	a0
	movi	offsetval,b4	;set up offset register
	movi	0,b8			;set background color
	movi	scrn_ptch,a0		;get screen pitch
	move	a0,b1
	move	a0,b3
	lmo	a0,a0			;convert in temporary register
	move	a0,@convsp		;move to convsp io register
	move	a0,@convdp		;move to convdp io register
	pull	a0
	rets


************  clear screen routine  *********************
clr_scrn
	clr	a0
	mmtm	sp,a1,a2,a3
	move	@displayon,a3,w
	clr	a1
	move	a1,@displayon,w
;	callr	dmaqwait			;wait on dma
	clr	a1
	move	a1,@cmapsel,w			;select color map 0
	movi	screen,a1,l
	movi	((scrne-2000h)-screen)/32,a2,l
clrlp	move	a0,*a1+,l
	dsjs	a2,clrlp
	move	a3,@displayon,w
	mmfm	sp,a1,a2,a3
	rets

**************************************************************************
*												*
* copyobj - copies the contents of one object block to the other.		*
* a0 = ptr to destination block									*
* a8 = ptr to source block									*
*												*
**************************************************************************
copyobj
	mmtm	sp,a0,a6,a8
	movi	obsiz,a6,w	;get the size of the block in words
	addi	64,a0
	addi	64,a8		;don't copy the links
	srl	4,a6		;divide by 16		
	subk	4,a6		;subtract to account for the 1st two links
copyobjl
	move	*a8+,*a0+,w	;move a word
	dsjs	a6,copyobjl
	mmfm	sp,a0,a6,a8

;	push	a6		;kludge to zero misplaced links
;	clr	a6
;	move	a6,*a0(oshad),l
;	pull	a6

	rets

**************************************************************************
*											     *
*  stop_a8 - zero velocities of object in a8					     *
*											     *
**************************************************************************
stop_a8
	mmtm	sp,a0,a1
	clr	a1			; no velocity
	move	a1,*a8(oxvel),l 	; in the "x" direction (and design)
	move	a1,*a8(oyvel),l 	; stop movement
	mmfm	sp,a0,a1
	rets


raiden_dimmer
	movi	death_fade_excludes,a0
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
	movi	raiden_fade_tab,a11
	jruc	fader

raiden_undimmer
	movi	death_fade_excludes,a0
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
	movi	raiden_unfade_tab,a11
	jruc	fader


**************************************************************************
*											     *
* 	fadeblak									     *
* 											     *
* 	fade a list of palettes to black, within one tick		     *
* 											     *
* 	input: a0 ptr to null terminated list **not** to fade		     *
*											     *
**************************************************************************
fadeblak
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
	clr	a14
	movi	fadeblak_tab,a11
	jruc	fader

**************************************************************************
*											     *
* 	fadeall										     *
* 											     *
* 	fade everything using a given fade entry				     *
* 											     *
* 	entry										     *
* 		a0	list of palettes						     *
* 		a11	fade mult table						     *
* 											     *
* 	exit										     *
* 		nothing									     *
* 											     *
* 	call										     *
* 		call									     *
*											     *
**************************************************************************
fadeall:
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
	jruc	fader


*slow version of fadein
*a0 = ptr to table of palettes not to fade
fadeins
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
	clr	a14
	movi	fadeins_tab,a11
	jruc	fader


*slow version of fadeout
*a0 = ptr to table of palettes not to fade
;fadeouts:
;	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
;	clr	a14
;	movi	fadeouts,a11
;	jruc	fader

**************************************************************************
*											     *
* 	fadein										     *
* 											     *
* 	fade a list of palettes from black to their current colors	     *
* 											     *
* 	entry										     *
* 		a0	ptr to null terminated list **not** to fade     *
* 											     *
* 	exit										     *
* 		nothing									     *
*										     	*
**************************************************************************
fadein
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
	movi	fadein_tab,a11
	jruc	fader

**************************************************************************
*											     *
* 	fadeout										     *
* 											     *
* 	fade a list of palettes down to black					     *
* 											     *
* 	entry										     *
* 		a0	ptr to null terminated list **not** to fade     *
* 											     *
* 	exit										     *
* 		nothing									     *
*											     *
**************************************************************************
join_in_fade1
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
	movi	join_in_tab1,a11
	jruc	fader

join_in_fade2
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
	movi	join_in_tab2,a11
	jruc	fader

fade_all_fast
	movi	all_palettes,a0
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
	movi	fast_fade_tab,a11
	jruc	fader

fadein_all_fast
	movi	all_palettes,a0
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
	movi	fast_fadein_tab,a11
	jruc	fader

;death_fadeout_1
;	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
;	movi	death_fadeout_tab1,a11
;	jruc	fader
;
;death_fadeout_2
;	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
;	movi	death_fadeout_tab2,a11
;	jruc	fader


fadeout:
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a11
	movi	fadeout_tab,a11

fader:
	move	a0,a6		

;* walk eugenes palette table, start proc to fade each palette *
	clr	a9		;palette slot
	dec	a9
	movi	palram-palrsiz,a2	;base of eugenes palette table
pallp:
	addi	palrsiz,a2
	inc	a9
	cmpi	numpal,a9
	jrge	pallpx

	move	*a2(palcnt),a1,w	;is palette allocated?
	jrz	pallp
	move	*a2(palid),a8,l		;ptr to palette
;*** skip fading pals in list pointed to by a6
	move	a6,a7
	jrz	skfpalx
skpallp:
	move	*a7+,a1,l
	jrz	skfpalx

	cmp	a1,a8
	jreq	pallp
	jruc	skpallp
skfpalx:
	create	pid_fade,fadeproc
	jruc	pallp
pallpx:

	mmfm	sp,a0,a1,a2,a6,a7,a8,a9,a11
	rets

**************************************************************************
*											     *
*  fade_irqskye - process to fade down the irqskye value along with	     *
*                 other fades.								     *
* 											     *
*  input: a11 - fade multiply table							     *
*											     *
**************************************************************************
;fade_irqskye
;	move	@irqskye,a0,w		; save original value in a10
;	move	a0,*a13(pdata),w
;
;fadesk6	move	*a11+,a2,w
;	jrn	fadesk9
;
;	push	a11
;	movi	>7c00,a4	;a4 - pre mult mask for 5 bits of red
;	movi	>03e0,a6	;a6 - pre mult mask for 5 bits of green
;	movi	>001f,a8	;a8 - pre mult mask for 5 bits of blue
;	move	a4,a9
;	move	a6,a10
;	move	a8,a11
;	sll	7,a9		; a9 - post mult max for 5 bits of red
;	sll	7,a10		;a10 - post mult max for 5 bits of green
;	sll	7,a11		;a11 - post mult max for 5 bits of blue
;
;	move	*a13(pdata),a3,w  ; r
;	move	*a13(pdata),a5,w  ; g
;	move	*a13(pdata),a7,w  ; b
;
;	and	a4,a3
;	and	a6,a5
;	and	a8,a7
;	mpyu	a2,a3
;	mpyu	a2,a5
;	mpyu	a2,a7
;	cmp	a9,a3
;	jrle	redok2
;	move	a9,a3
;redok2
;	cmp	a10,a5
;	jrle	greenok2
;	move	a10,a5
;greenok2
;	cmp	a11,a7
;	jrle	blueok2
;	move	a11,a7
;blueok2
;	and	a9,a3
;	and	a10,a5
;	or	a5,a3
;	or	a7,a3
;	srl	7,a3
;	move	a3,@irqskye,w
;	pull	a11
;
;	sloop	1,fadesk6
;
;fadesk9	sleep	1
;	die

**************************************************************************
*											     *
* 	fadeproc									     *
* 											     *
* 	process to actually fade a palette					     *
* 											     *
* 	entry										     *
* 		a8	ptr to palette to be faded				     *
* 		a9	palette slot of palette				     *
* 		a11	fade multiplier table					     *
* 											     *
* 	exit										     *
* 		nothing									     *
*											     *
**************************************************************************
fadeproc:

;*************************************** Goskie curse strikes again !!
	cmpi	boss_p,a8
	jaeq	sucide
;*************************************** Goskie curse strikes again !!

	sll	24,a9		;b8-15 dest pal | b0-7 start color	
	srl	16,a9

	.if	yunit
	move	a9,a2
	srl	12,a2
	sll	14,a2
	sll	20,a9
	srl	20,a9
	add	a2,a9
	.endif

fadeplp:
	;**** set up faded pal in process data space ****
	move	*a11+,a2,w	;a2 - color multiplier

****************
	jrn	fadeprcx
;	cmpi	-1,a2
;	jreq	fadeprcx	; allow negative entries (ejb)
****************

	move	a13,a0
	addi	pdata,a0	;a0 - dest ram for pal
	move	a8,a1		;a1 - src for pal
	callr	fadepal

	;**** get faded palette xferred to palram ****
	move	a9,a1		;b8-15 dest pal | b0-7 start color
	move	a13,a0
	addi	pdata,a0	;src for xfer
	move	*a0+,a2,w	;get # colors in palette
	calla	palset		;setup palette transfer

	sleep	1
	jruc	fadeplp

fadeprcx:
	sleep	1		;give last xfer a chance to go
	die

**************************************************************************
*											     *
* 	fadepal										     *
* 											     *
* 	apply the color multiplier and do one iteration on the palette  *
* 											     *
* 	entry										     *
* 		a0	destination ram for palette				     *
* 		a1	source for palette					     *
* 		a2	color multiplier						     *
* 											     *
* 	exit										     *
* 		nothing									     *
* 											     *
* 	note:	each color in palette will be multiplied by a2 then     *
* 		divided by 128								     *
*											     *
**************************************************************************
fadepal:
	mmtm	sp,a8,a9,a10,a11

	move	*a1+,a14,w
	move	a14,*a0+,w
	sll	23,a14		;top bits of field are flags
	srl	23,a14		;	only 9 bits needed for # colors

	movi	>7c00,a4	;a4 - pre mult mask for 5 bits of red
	movi	>03e0,a6	;a6 - pre mult mask for 5 bits of green
	movi	>001f,a8	;a8 - pre mult mask for 5 bits of blue
	move	a4,a9
	move	a6,a10
	move	a8,a11
	sll	7,a9		; a9 - post mult max for 5 bits of red
	sll	7,a10		;a10 - post mult max for 5 bits of green
	sll	7,a11		;a11 - post mult max for 5 bits of blue

fadelp:
	move	*a1+,a3,w	;a3 - red
	move	a3,a5		;a5 - green
	move	a3,a7		;a7 - blue
	and	a4,a3
	and	a6,a5
	and	a8,a7
	mpyu	a2,a3
	mpyu	a2,a5
	mpyu	a2,a7
	cmp	a9,a3
	jrle	redok
	move	a9,a3
redok:
	cmp	a10,a5
	jrle	greenok
	move	a10,a5
greenok:
	cmp	a11,a7
	jrle	blueok
	move	a11,a7
blueok:
	and	a9,a3
	and	a10,a5
;	and	a11,a7	;unnecessary cause bottom bits will get >> 7

	or	a5,a3
	or	a7,a3
	srl	7,a3
	move	a3,*a0+,w
	dsjs	a14,fadelp
	
	mmfm	sp,a8,a9,a10,a11
	rets


;death_fadeout_tab1
;	.word	120,112,104,96,88,80	;,72,64,56,48,40,32,24,16,8,0,>ffff
;
;death_fadeout_tab2
;	.word	72,64,56,48,40,32,24,16,8,0,>ffff

fadein_tab
	.word	0,0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,>ffff
fadeout_tab
	.word	120,112,104,96,88,80,72,64,56,48,40,32,24,16,8,0,>ffff
fadeins_tab
	.word	0,0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76
	.word	80,84,88,92,96,100,104,108,112,116,120,124,128,>ffff
fadeblak_tab
	.word	0,>ffff

fast_fade_tab
	.word	120,104,88,72,56,40,24,8,0,>ffff

fast_fadein_tab
	.word	0,8,24,40,56,72,88,104,128,-1

raiden_fade_tab
	.word	48,-1

raiden_unfade_tab
	.word	128,-1


join_in_tab1
	.word	56,-1

join_in_tab2
	.word	48,40,32,24,16,8,0,-1

**************************************************************************
*											     *
* skydown - fade down the sky color and die					     *
* a9 = fader speed									     *
*											     *
**************************************************************************
skydown
	movi	10000h,a8
	move	@irqskye,a10,w		; a10 = starting color o sky

skydown1

;	move	@irqskye,a0,w
	move	a10,a0			; start out with the original

	move	a8,a1
	calla	xcolor
	move	a0,@irqskye,w
	sleep	1
	sub	a9,a8
	jrgt	skydown1
	clr	a1
	jruc	skydie

**************************************************************************
*											     *
*  skyup - fade up the sky color and die						     *
* 											     *
*   a9 = fader speed									     *
*  a10 = final color we wanna end up with						     *
*											     *
**************************************************************************
skyup
	clr	a8
skyup1

;	move	@skycolor,a0,w
	move	a10,a0

	move	a8,a1
	calla	xcolor
	move	a0,@irqskye,w
	sleep	1
	add	a9,a8
	cmpi	10000h,a8
	jrle	skyup1

	movi	10000h,a1
skydie
	move	@irqskye,a0,w
	calla	xcolor
	die

**************************************************************************
*											     *
* xcolor - color value multiplier							     *
* a0 = color value									     *
* a1 = x factor (msw:integer lsw:fraction)						     *
* returns										     *
* a0 = x color value									     *
*											     *
**************************************************************************
xcolor
	mmtm	sp,a3,a4
	clr	a4
	move	a0,a3
	sll	27,a3
	srl	27,a3		;now i got 'da blues
	mpyu	a1,a3
	sll	11,a3
	srl	27,a3
	or	a3,a4
	move	a0,a3
	sll	22,a3
	srl	27,a3		;greens
	mpyu	a1,a3
	sll	11,a3		;strip garbage
	srl	27,a3
	sll	5,a3
	or	a3,a4
	move	a0,a3
	sll	17,a3
	srl	27,a3		;now reds
	mpyu	a1,a3
	sll	11,a3
	srl	27,a3
	sll	10,a3
	or	a3,a4
	move	a4,a0
	mmfm	sp,a3,a4
	rets

*******************************************************************

	.end
