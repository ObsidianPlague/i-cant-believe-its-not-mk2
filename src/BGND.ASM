**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: bgnd.asm  --- background code							*
* 											     *
*  copyright (c) 1993 williams electronics games, inc.			     *
*											     *
**************************************************************************
	.file	'main.asm'
	.width	132
	.option	b,d,l,t
	.mnolist
*
* get the system stuff
*
	.include	dispequ.asm
	.include	sysequ.asm
	.include	macros.hdr
	.include	mainequ.asm
	.include	imgtbl.glo
	.include	bgndtbl.glo
	.include	stringh.asm
	.include	mkfloors.tbl
	.include	mkbgani.tbl
	.text

center_x		.set	-2
null_irqskye	.set	444
pixels_600	.set	600

**************************************************************************
*											     *
*  do_a11_background - create a background update process			     *
* 											     *
*  input: a11 = offset into table of background modules			     *
*											     *
**************************************************************************
do_a11_background
	jruc	skippy

 	movk	6,a11
 	move	a11,@curback,w

skippy	sll	5,a11
	addi	table_o_mods,a11
	move	*a11,a11,l	 	; a11 = background
	move	a11,a0
	callr	init_bakmods
	create	pid_backg,background
	rets


table_o_mods
	.long	dedpool_mod	; 0
	.long	tomb_mod	; 1
	.long	battle_mod	; 2
	.long	tower_mod	; 3
	.long	forest_mod	; 4
	.long	armory_mod	; 5
	.long	bridge_mod	; 6
	.long	port_mod	; 7
	.long	arena_mod	; 8
	.long	mk1_mod		; 9
	.long	0		; a
	.long	team_mod	; b
	.long	vs_mod		; c
	.long	mountain_mod	; d

	.long	atrax1_mod	; e
	.long	atrax2_mod	; f
	.long	atrax3_mod	; 10
	.long	atrax4_mod	; 11

	.long	end_h_mod	; 12
	.long	end_v_mod	; 13
	.long	bio_mod		; 14
	.long	hstd_mod	; 15

**************************************************************************
*											     *
*  background - background update process						     *
* 											     *
*  input: a11 = multiplane bmod table							     *
*											     *
**************************************************************************
background
;	move	a11,a0
;	callr	init_bakmods

	movk	8,a10			; sleep time for updater
back1	callr	multi_plane
	move	a10,a0
	calla	prcslp			; sleep the requested time !
	jruc	back1


multi_plane
	movi	plane_info_table,a1

	movi	baklst1+32,a8		; start with furthest plane back !!

mulpl5	mmfm	a1,a0,a3,a4,a7		; load up the input registers

	subi	32,a8			; a8 ---> next background list
	cmpi	baklst8-32,a8		; all done ?
	jreq	mulpl6			; yes, exit

	move	*a0,a0,l
	cmpi	skip_bakmod,a0
	jreq	mulpl5			; skip this plane

	cmpi	dumbgnd,a0
	jreq	mulpl6			; dumbgnd ---> thats all !!
	callr	mp_bgnd_ud1  		; update another plane
	jruc	mulpl5

mulpl6	rets

*
* multi-plane background update call
*
mp_bgnd_ud1
	move	*a3,a3,l		; a3 = worldtl x
	move	*a4,a4,l		; a4 = worldtl y
	srl	16,a3			; position x in the x half
	srl	16,a4
	sll	16,a4			; position y in the y half
	or	a4,a3
	move	a3,a4
	jauc	bgnd_ud1		; background update routine


plane_info_table
	.long	bak1bits,worldtly,worldtlx,bak1mods
	.long	bak2bits,worldtly,worldtlx2,bak2mods
	.long	bak3bits,worldtly,worldtlx3,bak3mods
	.long	bak4bits,worldtly,worldtlx4,bak4mods
	.long	bak5bits,worldtly,worldtlx5,bak5mods
	.long	bak6bits,worldtly,worldtlx6,bak6mods
	.long	bak7bits,worldtly,worldtlx7,bak7mods
	.long	bak8bits,worldtly,worldtlx8,bak8mods
	.long	0

*************************************************************************

init_bakmods
	move	*a0+,a1,w
	cmpi	null_irqskye,a1
	jreq	ibak1	       		; null = dont touch !!

	move	a1,@irqskye,w		; 1st word = background color

ibak1	move	*a0+,a1,w
	move	a1,@ground_y
	move	*a0+,a1,w
	move	a1,@worldtly+16,w
	move	a1,@ceiling_y,w

	move	*a0+,a1,w

	sll	16,a1
	push	a0
	move	a1,a0
	calla	set_all_worldtlx	; 3rd word = initial worldtlx
	pull	a0
	
	move	*a0+,a1,w
	move	a1,@left_edge,w
	move	*a0+,a1,w
	move	a1,@right_edge,w	; scroll limits

	move	*a0+,a1,l
	push	a0
	call	a1			; call routine
	pull	a0

	move	*a0+,a1,l
	move	a1,@scrtab,l		; set scroll table
	move	*a0+,a1,l
	move	a1,@dlists,l		; display lists

	move	*a0+,a1,l		; starting bak?mod to fill
ibak3	move	*a0,a2,l

	cmpi	skip_bakmod,a2		; skip a plane ?
	jrne	ibak4			; yes ---> get the next plane
	move	a2,*a1+,l		; signal ---> skip plane
	addi	32,a0
	jruc	ibak3

ibak4	cmpi	>ffffffff,a2		; end of module list ?
	jreq	ibak5			; yup
	cmpi	center_x,a2		; center world coordinates ?
	jreq	ibak7
	move	a0,*a1+,l		; nope...stuff module pointer
	addi	64,a0			; a0 ---> next entry
	jruc	ibak3
ibak5	rets

*
* center all world coordinates
*
ibak7	addi	32,a0	 	; a0 ---> module to center around !
ibak8	move	*a0+,a1,l	; a1 = module
	jreq	ibak5	 	; zero ---> we done
	move	*a0+,a2,l	; a2 = world coordinates to set
	move	*a1,a1,w     	; a1 = module x size
	srl	1,a1		; 1/2 length of module
	subi	scrrgt/2,a1	; middle of screen
	sll	16,a1
	move	a1,*a2,l
	jruc	ibak8

**************************************************************************
*											     *
*  scroller - process to keep players on screen					     *
*											     *
**************************************************************************

far	.set	100
midzone	.set    150
mz_out	.set	(scrrgt-midzone)/2


scroller
	clr	a11			; a11 = flag: dont pit scroll !!
	sleep	4

scrstop	calla	stop_scrolling

scrloop	sleep	1

	move	@p2_obj,a8,l
	move	*a8(oxpos),a1,w		; a1 = player 2 ani x
	move	@p1_obj,a8,l
	move	*a8(oxpos),a0,w		; a0 = player 1 ani x

	cmp	a0,a1
	jrgt	scr4

	swap	a0,a1			; make sure a0 < a1
scr4 
	move	a1,a2
	sub	a0,a2			; a2 = distance between players
	move	a2,a3			; a3 = distance between players
	srl	1,a2
	add	a0,a2			; a2 = center point between 'em
	cmpi	far,a3
	jrhi	sc_far			; dudes are far apart
*
* dudes are close together
*
	move	@worldtlx+16,a3,w
	addi	scrrgt/2,a3   		; a3 = center o screen
	sub	a3,a2
	abs	a2
	cmpi	midzone/2,a2
	jrls	scr_stop		; center point in range
	cmp	a0,a3
	jrgt	scr_left
	jruc	scr_right
*
* dudes are far apart (just keep 'em on screen)
*
sc_far	move	@worldtlx+16,a3,w
	move	a3,a4
	addi	scrrgt-40,a4		; a4 = right edge
	addi	40,a3			; a3 = left edge

	cmp	a3,a0			; within left edge ?
	jrlt	scr_left		; no --> scroll left
	cmp	a4,a1			; within right edge ?
	jrle	scr_stop		; yes ---> stop
*
* scroll right
*
scr_right
	move	@right_edge,a3,w
	move	@worldtlx+16,a1,w
	cmp	a3,a1
	jrge	scr_stop		; too far right ----> no scroll

	movi	right_scrolls,a2
	movi	ss_28000,a3
	jruc	scr_choose
*
* scroll left
*
scr_left
	move	@left_edge,a2,w
	move	@worldtlx+16,a1,w
	cmp	a2,a1
	jrle	scr_stopl		; too far right ----> no scroll

	movi	left_scrolls,a2
	movi	ss_28000_neg,a3

scr_choose
	move	@p1_xvel,a4,l
	move	@p2_xvel,a5,l
	abs	a4
	abs	a5
	cmp	a5,a4
	jrhs	scrch4
	move	a5,a4			; a4 = fastest moving dude
scrch4	move	a4,a4
	jreq	scrr6

	move	a2,a5
scrr3	move	*a5+,a3,l		; grab a table speed
	jreq	scroll_error
	cmp	a4,a3			; how does table entry compare ?
	jrhs	scrr5			; faster or same ---> use it
	addi	32,a5			; a5 = next table entry !!
	jruc	scrr3

scrr5	move	*a5,a3,l		; grab a routine
scrr6	move	@scrtab,b0,l
	call	a3
	jruc	scrl6

scr_stopl
	move	a0,a0

scr_stop	calla	stop_scrolling

**************************************************************************
*											     *
*   y scrolling										     *
*											     *
**************************************************************************
scrl6	move	@ground_y,a3,w
	move	@ceiling_y,a5,w

	move	@p2_obj,a8,l
	move	*a8(oypos),a7,w		; a7 = player 2 ani y
	move	@p1_obj,a8,l
	move	*a8(oypos),a6,w		; a6 = player 2 ani y

	move	@worldtly+16,a0,w
	move	a0,a1
	addi	40,a1			; a1 = upper barrier
	cmp	a1,a6
	jrle	scrl7			; we need to scroll up
	cmp	a1,a7
	jrle	scrl7			; we need to scroll up

	cmp	a5,a0
	jreq	scrl9			; we are perfect ---> stop scrolling
	jrgt	scrl8			; we are too low ---> adjust back up

	movi	>18000,a0
   	jruc	scrla			; scroll down
*
* scroll up
*
scrl7	subi	>10,a5			; a5 = highest we are allowed to scroll
	cmp	a5,a0
	jrle	scrl9			; too high

	sub	a6,a1
	abs	a1			; a1 = how far we are from the limit
	cmpi	2,a1
	jrlo	scrl9			; too close ---> avoid jittering

	sub	a7,a1
	abs	a1			; a1 = how far we are from the limit
	cmpi	2,a1
	jrlo	scrl9			; too close ---> avoid jittering

	movi	->18000,a0
	jruc	scrla

scrl8	move	a5,@worldtly+16,w	; stuff exactly where we want to be
scrl9	clr	a0
scrla	move	a0,@scrolly,l		; stop scroll
	jruc	scrloop

scroll_error
	ermac	12

right_scrolls
	.long	>10000,ss_10000
	.long	>20000,ss_20000
	.long	>28000,ss_28000
	.long	>30000,ss_30000
	.long	>40000,ss_40000
	.long	>60000,ss_60000
	.long	>70000,ss_70000
	.long	>a0000,ss_a0000

	.long	>80000,ss_80000		; make be eliminated (ejbejbejb)
	.long	0

left_scrolls
	.long	>10000,ss_10000_neg
	.long	>20000,ss_20000_neg
	.long	>28000,ss_28000_neg
	.long	>30000,ss_30000_neg
	.long	>40000,ss_40000_neg
	.long	>60000,ss_60000_neg
	.long	>70000,ss_70000_neg
	.long	>a0000,ss_a0000_neg

	.long	>80000,ss_80000_neg	; make be eliminated (ejbejbejb)
	.long	0


ss_10000_neg
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_neg_values,b0
	jruc	ss_10

ss_10000
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_scroll_values,b0

ss_10	sra	1,a1
	sra	1,a2
	sra	1,a3
	sra	1,a4
	sra	1,a5
	sra	1,a6
	sra	1,a7
	sra	1,a8
	sra	1,a9
	jump	b0


ss_20000_neg
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	jruc	stuff_neg_values

ss_20000
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9	; grab the values from table
	jruc	stuff_scroll_values

ss_28000_neg
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9	; grab the values from table
	movi	stuff_neg_values,b0
	jruc	ss_28

ss_28000
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9	; grab the values from table
	movi	stuff_scroll_values,b0

ss_28	move	a1,a10
	sra	2,a10
	add	a10,a1		; subtract 1/4 table value
	move	a2,a10
	sra	2,a10
	add	a10,a2
	move	a3,a10
	sra	2,a10
	add	a10,a3
	move	a4,a10
	sra	2,a10
	add	a10,a4
	move	a5,a10
	sra	2,a10
	add	a10,a5
	move	a6,a10
	sra	2,a10
	add	a10,a6
	move	a7,a10
	sra	2,a10
	add	a10,a7
	move	a8,a10
	sra	2,a10
	add	a10,a8
	move	a9,a10
	sra	2,a10
	add	a10,a9
	jump	b0


ss_30000_neg
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_neg_values,b0
	jruc	ss_30

ss_30000
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_scroll_values,b0

ss_30	move	a1,a10
	sra	1,a10
	add	a10,a1		; 2 + 1 = 3
	move	a2,a10
	sra	1,a10
	add	a10,a2
	move	a3,a10
	sra	1,a10
	add	a10,a3
	move	a4,a10
	sra	1,a10
	add	a10,a4
	move	a5,a10
	sra	1,a10
	add	a10,a5
	move	a6,a10
	sra	1,a10
	add	a10,a6
	move	a7,a10
	sra	1,a10
	add	a10,a7
	move	a8,a10
	sra	1,a10
	add	a10,a8
	move	a9,a10
	sra	1,a10
	add	a10,a9
	jump	b0

;********************************** may be eliminated (for kano) ejbejbejb
ss_80000_neg
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_neg_values,b0
	jruc	ss_80

ss_80000
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_scroll_values,b0

ss_80	sll	2,a1
	sll	2,a2
	sll	2,a3
	sll	2,a4
	sll	2,a5
	sll	2,a6
	sll	2,a7
	sll	2,a8
	sll	2,a9
	jump	b0
;********************************** may be eliminated (for kano) ejbejbejb


ss_40000_neg
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_neg_values,b0
	jruc	ss_40

ss_40000
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_scroll_values,b0

ss_40	sll	1,a1
	sll	1,a2
	sll	1,a3
	sll	1,a4
	sll	1,a5
	sll	1,a6
	sll	1,a7
	sll	1,a8
	sll	1,a9
	jump	b0


ss_60000_neg
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_neg_values,b0
	jruc	ss_60

ss_60000
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_scroll_values,b0

ss_60	move	a1,a10
	sll	1,a10
	add	a10,a1		; 2 + 4 = 6
	move	a2,a10
	sll	1,a10
	add	a10,a2
	move	a3,a10
	sll	1,a10
	add	a10,a3
	move	a4,a10
	sll	1,a10
	add	a10,a4
	move	a5,a10
	sll	1,a10
	add	a10,a5
	move	a6,a10
	sll	1,a10
	add	a10,a6
	move	a7,a10
	sll	1,a10
	add	a10,a7
	move	a8,a10
	sll	1,a10
	add	a10,a8
	move	a9,a10
	sll	1,a10
	add	a10,a9
	jump	b0


ss_70000_neg
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_neg_values,b0
	jruc	ss_70

ss_70000
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_scroll_values,b0

ss_70	move	a1,a10
	move	a1,a11
	sll	1,a10
	sra	1,a11	
	add	a10,a1
	add	a11,a1		; 2 + 4 + 1 = 7
		
	move	a2,a10
	move	a2,a11
	sll	1,a10
	sra	1,a11	
	add	a10,a2
	add	a11,a2

	move	a3,a10
	move	a3,a11
	sll	1,a10
	sra	1,a11	
	add	a10,a3
	add	a11,a3

	move	a4,a10
	move	a4,a11
	sll	1,a10
	sra	1,a11	
	add	a10,a4
	add	a11,a4

	move	a5,a10
	move	a5,a11
	sll	1,a10
	sra	1,a11	
	add	a10,a5
	add	a11,a5

	move	a6,a10
	move	a6,a11
	sll	1,a10
	sra	1,a11	
	add	a10,a6
	add	a11,a6

	move	a7,a10
	move	a7,a11
	sll	1,a10
	sra	1,a11	
	add	a10,a7
	add	a11,a7

	move	a8,a10
	move	a8,a11
	sll	1,a10
	sra	1,a11	
	add	a10,a8
	add	a11,a8

	move	a9,a10
	move	a9,a11
	sll	1,a10
	sra	1,a11	
	add	a10,a9
	add	a11,a9

	jump	b0


ss_a0000_neg
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_neg_values,b0
	jruc	ss_a0

ss_a0000
	move	@scrtab,a0,l
	mmfm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movi	stuff_scroll_values,b0

ss_a0	move	a1,a10
	sll	2,a10
	add	a10,a1			; 2 + 8 = a

	move	a2,a10
	sll	2,a10
	add	a10,a2

	move	a3,a10
	sll	2,a10
	add	a10,a3

	move	a4,a10
	sll	2,a10
	add	a10,a4

	move	a5,a10
	sll	2,a10
	add	a10,a5

	move	a6,a10
	sll	2,a10
	add	a10,a6

	move	a7,a10
	sll	2,a10
	add	a10,a7

	move	a8,a10
	sll	2,a10
	add	a10,a8

	move	a9,a10
	sll	2,a10
	add	a10,a9
	jump	b0


stuff_neg_values
	neg	a1
	neg	a2
	neg	a3
	neg	a4
	neg	a5
	neg	a6
	neg	a7
	neg	a8
	neg	a9	; <<<<<<<<<<<< fall through >>>>>>>>>>>>

stuff_scroll_values
	movi	scrollx0+32,a0
	mmtm	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	rets

stop_scrolling
	clr	b0
	move	b0,@scrollx0,l
	move	b0,@scrollx,l
	move	b0,@scrollx2,l
	move	b0,@scrollx3,l
	move	b0,@scrollx4,l
	move	b0,@scrollx5,l
	move	b0,@scrollx6,l
	move	b0,@scrollx7,l
	move	b0,@scrollx8,l
	rets

**************************************************************************
*											     *
*                       background modules						     *
*                       background modules						     *
*                       background modules						     *
*											     *
**************************************************************************
initials1_mod
	.word	0		 		; autoerase color
	.word	>00	     			; ground y
	.word	>1d				; initial world y
	.word	>17				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.LONG	ENT1MODBMOD
	.word	->06,>00
	.long	>ffffffff


initials2_mod
	.word	0		 		; autoerase color
	.word	>00	     			; ground y
	.word	>1d				; initial world y
	.word	>03				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.LONG	ENTMOD2BMOD
	.word	->06,>00
	.long	>ffffffff


hstd_mod
	.word	0		 		; autoerase color
	.word	>00	     			; ground y
	.word	>2A				; initial world y
	.word	>1b				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.long	HISCRMOD1BMOD
	.word	->06,>00
	.long	>ffffffff


bio_mod
	.word	0		 		; autoerase color
	.word	>00	     			; ground y
	.word	>20				; initial world y
	.word	>13				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.long	STORYMODBMOD
	.word	->06,>00
	.long	>ffffffff


end_h_mod
	.word	0		 		; autoerase color
	.word	>00	     			; ground y
	.word	>22				; initial world y
	.word	>28				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.long	STORY1BMOD
	.word	->06,>00
	.long	>ffffffff


end_v_mod
	.word	0		 		; autoerase color
	.word	>00	     			; ground y
	.word	>29				; initial world y
	.word	>12				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.long	STORY2BMOD
	.word	->06,>00
	.long	>ffffffff



atrax1_mod
	.word	0		 		; autoerase color
	.word	>00	     			; ground y
	.word	>2e				; initial world y
	.word	>10				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.long	ATRXMOD1BMOD
	.word	->06,>00
	.long	>ffffffff


atrax2_mod
	.word	0		 		; autoerase color
	.word	>00	     			; ground y
	.word	>2e				; initial world y
	.word	>10				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.long	ATRXMOD2BMOD
	.word	->06,>00
	.long	>ffffffff


atrax3_mod
	.word	0		 		; autoerase color
	.word	>00	     			; ground y
	.word	>2e				; initial world y
	.word	>10				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.long	ATRXMOD3BMOD
	.word	->06,>00
	.long	>ffffffff


atrax4_mod
	.word	0		 		; autoerase color
	.word	>00	     			; ground y
	.word	>2e				; initial world y
	.word	>10				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.long	ATRXMOD4BMOD
	.word	->06,>00
	.long	>ffffffff


**************************************************************************
*											     *
*  MK 2 team photos									     *
*											     *
**************************************************************************
team_mod
	.word	0		 		; autoerase color
	.word	>00	     			; ground y
	.word	>2d				; initial world y
	.word	>18				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.long	TEAMMOD1BMOD
	.word	->06,>00
	.long	>ffffffff

**************************************************************************
*											     *
*  Vs screen module									     *
*											     *
**************************************************************************
vs_mod
	.word	0		 		; autoerase color
	.word	>00	     			; ground y
	.word	>00				; initial world y
	.word	>00				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.long	VSSCREENBMOD
	.word	->06,>00
	.long	>ffffffff

**************************************************************************
*											     *
*  One player ladder MOUNTAIN								     *
*											     *
**************************************************************************
mountain_mod
	.word	(32*32*0)+(32*0)+3 		; autoerase color

	.word	>00	     			; ground y
	.word	->30				; initial world y
	.word	>00				; initial worldx
	.word	->500 	  			; scroll left limit
	.word	>500	  			; scroll right limit

	.long	mountain_thunder
	.long	no_scroll			; scroll table
	.long	dlists_bogus
	.long	bak1mods

	.long	mount1BMOD
	.word	->60,>50
	.long	skip_bakmod			; skip baklst4 = distant fighters
	.long	mount2BMOD
	.word	>00,>00
	.long	>ffffffff


mountain_thunder
	create	pid_fx,thunder_spawner
	rets

thunder_spawner
	clr	a11
	movk	2,a10
	movk	6,a3
	jsrp	spawn_1_bang

	inc	a11
	movk	1,a10
	movk	6,a3
	jsrp	spawn_1_bang

	inc	a11
	movk	2,a10
	movk	6,a3
	jsrp	spawn_1_bang

	inc	a11
	movk	2,a10
	movk	5,a3
	jsrp	spawn_1_bang

	sleep	8
	inc	a11
 	clr	a10			; no sound
	movk	8,a3
	create	pid_fx,one_bang

	jruc	thunder_spawner


spawn_1_bang
	create	pid_fx,one_bang
	move	a3,*a0(p_anicount),w
	movi	28,a0
	calla	randu
	addi	38,a0
	calla	prcslp
	retp

one_bang
	sll	6,a11
	addi	lightning_table,a11
	movi	thunder1a,a5
	calla	gso_dmawnz_ns
	move	*a11+,a4,l
	calla	set_xy_coordinates
	move	a8,a0
	movi	baklst2,b4
	calla	insobj_v

	move	a10,a0
	jreq	nothud
	calla	triple_sound2		; distant thunder sound

nothud	move	*a11+,a9,l
	move	*a13(p_anicount),a0,w
	jsrp	framew	   		; thunder ani

	move	a8,a0
	calla	delpal
	movi	baklst2,a4
	calla	delobj_lista4
	die

lightning_table
	.word	>70,>50
	.long	a_thunder1

	.word	>c0,>40
	.long	a_thunder2

	.word	>120,>30
	.long	a_thunder3

	.word	>100,>3d
	.long	a_thunder1

	.word	>130,>38
	.long	a_thunder1

	.word	0


a_thunder1
	.long	thunder1e
	.long	thunder1d
	.long	thunder1c
	.long	thunder1b

	.long	thunder1a
	.long	thunder1b
	.long	thunder1a
	.long	thunder1b
	.long	thunder1a
	.long	thunder1b

	.long	thunder1c
	.long	thunder1d
	.long	thunder1e
	.long	0

a_thunder2
	.long	thunder2a
	.long	thunder2b
	.long	thunder2a
	.long	thunder2b

	.long	thunder2c
	.long	thunder2d
	.long	thunder2e
	.long	thunder2f
	.long	0

a_thunder3
	.long	thunder3f
	.long	thunder3e
	.long	thunder3d
	.long	thunder3c
	.long	thunder3b

	.long	thunder3a
	.long	thunder3b
	.long	thunder3a
	.long	thunder3b

	.long	thunder3c
	.long	thunder3d
	.long	thunder3e
	.long	thunder3f
	.long	0

**************************************************************************
*											     *
*  module: massive mk dragon symbol							     *
*											     *
**************************************************************************
huge_mod
	.word	(32*32*5)+(32*0)+0 	; autoerase color

	.word	>e8	     			; ground y
	.word	->0b				; initial world y
	.word	->38				; initial worldx
	.word	->50 	  			; scroll left limit
	.word	>fff	  			; scroll right limit

	.long	huge_calla
	.long	no_scroll			; scroll table
	.long	dlists_buyin
	.long	bak1mods

	.long	HUGE1BMOD
	.word	->02,>00
	.long	>ffffffff

huge_calla
	movi	trademark,a5
	calla	gso_dmawnz_ns
	movi	>00f00120,a4
	calla	set_xy_coordinates
	jauc	insobj2a8

**************************************************************************
*											     *
*  module: buyin screen										*
*											     *
**************************************************************************
buyin_mod
	.word	null_irqskye		 	; autoerase color

	.word	>e8	     			; ground y
	.word	0				; initial world y
	.word	0				; initial worldx
	.word	->50 	  			; scroll left limit
	.word	>fff	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_buyin

	.long	bak1mods

	.long	WINNER1BMOD
	.word	->02,>00
	.long	WINNER2BMOD
	.word	>bf,0

	.long	>ffffffff

dlists_buyin
	.long	baklst4,worldtlx+16
	.long	baklst3,worldtlx+16
	.long	baklst2,worldtlx+16
	.long	baklst1,worldtlx+16
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0

**************************************************************************
*											     *
*  module: player select screen									*
*											     *
**************************************************************************
psel_mod
	.word	0			 	; autoerase color

	.word	>e8	     			; ground y
	.word	0				; initial world y
	.word	0				; initial worldx
	.word	->50 	  			; scroll left limit
	.word	>fff	  			; scroll right limit

	.long	return
	.long	no_scroll			; scroll table
	.long	dlists_psel

	.long	bak1mods
	.long	PLAYRSELBMOD
	.word	-3,-7
	.long	>ffffffff

dlists_psel
	.long	baklst1,worldtlx+16
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0

**************************************************************************
*											     *
*  module: port										     *
*											     *
**************************************************************************
port_mod
	.word	0		 	; autoerase color

	.word	>f6	     		; ground y
	.word	>e6-wy_offset		; initial world y
	.word	(1236/2)-scrrgt/2	; initial worldx

	.word	>00 	  		; scroll left limit
	.word	>32c	  		; scroll right limit

	.long	port_calla
	.long	port_scroll		; scroll table
	.long	dlists_port

	.long	bak1mods
	.long	skip_bakmod		; skip baklst1

	.long	spiral1BMOD		; baklst2 = pillars
	.word	>00,->01
	.long	spiral2BMOD		; baklst3 = house
	.word	>00,>1a

	.long	skip_bakmod		; skip baklst4

	.long	spiral3BMOD		; baklst5 = little mountains
	.word	>00,>be
	.long	spiral4BMOD		; baklst6 = sky
	.word	>00,>00

	.long	center_x
	.long	spiral1BMOD,worldtlx2
	.long	spiral2BMOD,worldtlx3
	.long	spiral3BMOD,worldtlx5
	.long	spiral4BMOD,worldtlx6
	.long	0

port_scroll
	.long	0		; 8
	.long	0		; 7
	.long	0		; 6 - sky
	.long	>8000		; 5 - little mountains
	.long	0		; 4
	.long	>10000		; 3 - house
	.long	>18000		; 2 - pillars
	.long	>20000		; 1 - main floor
	.long	0		; 0

dlists_port
	.long	baklst7,worldtlx7+16
	.long	baklst6,worldtlx6+16
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16
	.long	baklst3,worldtlx3+16
	.long	baklst2,worldtlx2+16
	.long	-1,floor_code
	.long	-2				; shadows
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0

port_calla
	movi	>005801d8,a4
	movi	>005b01d8,a5
	movi	baklst4,a6
	callr	make_big_monk

	movi	>005802c8,a4
	movi	>005b02c8,a5
	movi	baklst4,a6
	callr	make_big_monk

	movi	timefloor1,a5
	movi	>009800a0,a4
	movk	1,a3
	callr	put_float

	movi	timemonk1,a5
	movi	>008300a0,a4
	movk	2,a3
	callr	put_float
	create	pid_bani,lil_monk_animator

	movi	timemonk1,a5
	movi	>008300e0,a4
	movk	2,a3
	callr	put_float
	create	pid_bani,lil_monk_animator

	create	pid_bani,warplite_animator

	movi	port_floor_info,a0
	jruc	setup_floor_info


port_floor_info
	.long	FL_PORT			; sag
	.long	moflr_p			; palette for floor
	.word	>d4			; skew y position
	.word	42			; height
	.long	scrollx2
	.long	port_skew_calla
 
port_skew_calla
	move	@skew_dx,a11,l		; dx per line
	sra	7,a9
	sub	a9,a11			; adjust with scroll
	move	a11,@skew_dx,l
	jauc	skew_rets

;*********************************************************************

warplite_animator
	movi	warplite1,a5
	calla	gso_dmawnz_ns
	movi	>008200c2,a4
	calla	set_xy_coordinates
	move	a8,a0
	movi	baklst7,b4
	calla	insobj_v

wla1	move	*a8(oxval),*a13(p_store1),l
	move	*a8(oyval),*a13(p_store2),l
	movi	>fff,a0
	move	a0,*a8(oxpos),w
	move	a0,*a8(oypos),w			; out of sight
	sleep	>70

	movi	>000200b4,a0			; [total # of entries, 1st entry]
	calla	random_triple			; random spark sound

	move	*a13(p_store1),*a8(oxval),l
	move	*a13(p_store2),*a8(oyval),l
	movk	2,a11
wla3	movi	a_warplite,a9
	movk	3,a0
	jsrp	framew
	dsj	a11,wla3
	jruc	wla1

a_warplite
	.long	warplite1
	.long	warplite2
	.long	warplite3
	.long	warplite4
	.long	warplite5
	.long	warplite6
	.long	0

;*********************************************************************

put_float
	mmtm	sp,a3,a4
	calla	gso_dmawnz
	mmfm	sp,a3,a4

	move	@worldtlx5+16,a5,w
	add	a5,a4

	move	a3,*a8(ozval),l
	calla	set_xy_coordinates
	move	a8,a0
	movi	baklst4,b4
	jauc	insobj_v


lil_monk_animator
	movi	a_timemonk,a9
	movk	6,a0
	jsrp	framew
	jruc	lil_monk_animator

a_timemonk
	.long	timemonk1
	.long	timemonk2
	.long	timemonk3
	.long	timemonk4
	.long	timemonk5
	.long	timemonk6
	.long	timemonk7
	.long	0

**************************************************************************
*											     *
*  module: arena										     *
*											     *
**************************************************************************
arena_mod
	.word	(32*32*13)+(32*8)+13		; autoerase color
	.word	240	     			; ground y
	.word	0				; initial world y
	.word	400				; initial x

	.word	>30 			; scroll left limit
	.word	>287 			; scroll right limit

	.long	arena_calla
	.long	arena_scroll			; scroll table
	.long	dlists_arena

	.long	bak1mods
	.long	skip_bakmod			; skip baklst1

	.long	arena2BMOD			; baklst2 - kano / throne
	.word	>60,>47 

	.long	arena3BMOD			; baklst3 - distant floor #1
	.word	>00,>b0

	.long	arena4BMOD			; baklst4 - distant floor #2
	.word	>00,>a8
	
	.long	skip_bakmod			; skip baklst5 = crowd

	.long	arena5BMOD			; baklst6 = wall
	.word	>00,>32 

	.long	arena6BMOD			; baklst7
	.word	>190,>16 

	.long	center_x
;	.long	arena2BMOD,worldtlx2		; kano / throne
	.long	arena3BMOD,worldtlx3		; distant floor #1
	.long	arena4BMOD,worldtlx4		; distant floor #2
	.long	arena5BMOD,worldtlx6		; back wall
;	.long	arena6BMOD,worldtlx7		; sky
	.long	0

arena_scroll
	.long	0		; 8
	.long	0		; 7 - sky
	.long	>8000		; 6 - wall
	.long	>8000		; 5 - crowd
	.long	>10000		; 4 -
	.long	>14000		; 3 -
	.long	>1a000		; 2 - kano / throne
	.long	>20000		; 1 - player's plane	
	.long	0		; 0

dlists_arena
	.long	baklst7,worldtlx7+16
	.long	baklst6,worldtlx6+16
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16
	.long	baklst3,worldtlx3+16
	.long	-1,floor_code
	.long	baklst2,worldtlx2+16
	.long	baklst1,worldtlx2+16
	.long	-2				; shadows
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0

arena_calla
	create	pid_bani,sitting_kahn
	create	pid_bani,kano_proc
	create	pid_bani,sonya_proc
	movi	arena_floor_info,a0
	callr	setup_floor_info
	create	pid_bani,crowd_ani
	rets

arena_floor_info
	.long	FL_ARENA		; sag
	.long	STADFLR_p		; palette for floor
	.word	>d4			; skew y position
	.word	42			; height
	.long	scrollx2
	.long	arena_skew_calla
 
arena_skew_calla
	move	@skew_dx,a11,l		; dx per line
	sra	7,a9
	sub	a9,a11			; adjust with scroll
	move	a11,@skew_dx,l
	jauc	skew_rets

crowd_ani
	movi	crowd_coordinates,a7

crani2	movi	crowd1,a5
	calla	gso_dmawnz
	move	*a7+,a0,w
	zext	a0,w			; keep y zero
	movi	>007c0000,a4
	or	a0,a4
	calla	set_xy_coordinates
	move	a8,a0
	movi	baklst5,b4
	calla	insobj_v
	move	*a7,a0,w
	jrne	crani2
	sleep	3

cani3	movi	crowd1,a9
	jsrp	crowd_ani_jsrp
	movi	crowd2,a9
	jsrp	crowd_ani_jsrp
	movi	crowd3,a9
	jsrp	crowd_ani_jsrp
	jruc	cani3

crowd_ani_jsrp
	move	@baklst5,a8,l
caj7	move	a9,a1
	calla	ani_flag
	move	*a8,a8,l
	jrne	caj7
	sleep	8
caj9	retp



crowd_start	.set	>127

crowd_coordinates
	.word	crowd_start->79
	.word	crowd_start
	.word	crowd_start+>79
	.word	crowd_start+(>79*2)
	.word	crowd_start+(>79*3)
	.word	crowd_start+(>79*4)
	.word	0

;**************************************************************************

sonya_proc
	movi	a_sonya_struggle,a9
	calla	gmo_proc

	move	@worldtlx+16,a4,w
	addi	>1e7,a4
	move	a4,*a8(oxpos),w
	move	@worldtly+16,a4,w
	addi	>49,a4
	move	a4,*a8(oypos),w

	move	a8,a0
	movi	baklst1,b4
	calla	insobj_v

son4	movi	a_sonya_struggle,a9
	movk	8,a0
	jsrp	mframew
	movk	20,a0
	calla	randu
	addi	>20,a0
	calla	prcslp
	jruc	son4

;**************************************************************************

kano_proc
	movi	a_kano_struggle,a9
	calla	gmo_proc

	move	@worldtlx+16,a4,w
	subi	>54,a4
	move	a4,*a8(oxpos),w
	move	@worldtly+16,a4,w
	addi	>4a,a4
	move	a4,*a8(oypos),w

	move	a8,a0
	movi	baklst1,b4
	calla	insobj_v

kano4	movi	a_kano_struggle,a9
	movk	8,a0
	jsrp	mframew
	movk	20,a0
	calla	randu
	addi	>20,a0
	calla	prcslp
	jruc	kano4


a_sonya_struggle
	.long	SONYA1
	.long	SONYA2
	.long	SONYA3
	.long	SONYA4
	.long	SONYA5
	.long	SONYA4
	.long	SONYA3
	.long	SONYA2
	.long	SONYA1
	.long	0

SONYA1	.long	sonyachain1a,sonyachain1b,sonyachain1c,sonyafeet,a0
SONYA2	.long	sonyachain2a,sonyachain2b,sonyachain2c,sonyafeet,a0
SONYA3	.long	sonyachain3a,sonyachain3b,sonyachain3c,sonyafeet,a0
SONYA4	.long	sonyachain4a,sonyachain4b,sonyachain4c,sonyafeet,a0
SONYA5	.long	sonyachain5a,sonyachain5b,sonyachain5c,sonyafeet,a0



a_kano_struggle
	.long	KANO1
	.long	KANO2
	.long	KANO3
	.long	KANO4
	.long	KANO3
	.long	KANO2
	.long	KANO1
	.long	0

KANO1	.long	kanochain1a,kanochain1b,kanochain1c,kanofeet1,kanofeet2,0
KANO2	.long	kanochain2a,kanochain2b,kanochain2c,kanofeet1,kanofeet2,0
KANO3	.long	kanochain3a,kanochain3b,kanochain3c,kanofeet1,kanofeet2,0
KANO4	.long	kanochain4a,kanochain4b,kanochain4c,kanofeet1,kanofeet2,0
KANO5	.long	kanochain5a,kanochain5b,kanochain5c,kanofeet1,kanofeet2,0

;**********************************************************************

sitting_kahn
	move	@p1_char,a0,w
	move	@p2_char,a1,w
	movi	ft_final_boss,a2
	calla	double_compare		; kahn fighting ?
	jreq	sitk9			; yes, no need for him in chair

	movi	bosssit1,a5
	calla	gso_dmawnz

	move	@worldtlx+16,a4,w
	addi	>94,a4
	move	a4,*a8(oxpos),w
	move	@worldtly+16,a4,w
	addi	>2b,a4
	move	a4,*a8(oypos),w

	move	a8,a0
	movi	baklst1,b4
	calla	insobj_v
sitk9	die

**************************************************************************
*											     *
*  module: pit #2										*
*											     *
**************************************************************************
bridge_mod
	.word	(32*2)+6		 	; autoerase color

	.word	205	     			; ground y
	.word	205-wy_offset			; initial world y
	.word	(1502/2)-(scrrgt/2)		; initial worldx

	.word	>00 	  			; scroll left limit
	.word	>453	  			; scroll right limit

	.long	calla_bridge
	.long	bridge_scroll			; scroll table
	.long	dlists_bridge

	.long	bak1mods

	.long	BRIDGE0BMOD			; baklst1 main bridge (front)
	.word	->20,>C9 
	.long	BRIDGE1BMOD			; baklst2 main bridge
	.word	>00,>9c
	.long	BRIDGE2BMOD			; baklst3 mist
	.word	>00,>a0

	.long	skip_bakmod			; skip baklst4 = distant fighters

	.long	BRIDGE3BMOD			; baklst5 distance mountain / bridge
	.word	>00,>00
	.long	BRIDGE4BMOD			; baklst6 thin mist behind distance bridge
	.word	>00,>88
	.long	BRIDGE6BMOD			; baklst7 thick clouds / moon
	.word	>00,>08
	.long	BRIDGE5BMOD			; baklst8 cloud outline
	.word	>00,>40

	.long	center_x
;	.long	BRIDGE0BMOD,worldtlx
	.long	BRIDGE1BMOD,worldtlx
	.long	BRIDGE2BMOD,worldtlx3
	.long	BRIDGE3BMOD,worldtlx5
	.long	BRIDGE4BMOD,worldtlx6
	.long	BRIDGE6BMOD,worldtlx7
	.long	BRIDGE5BMOD,worldtlx8
	.long	0

bridge_scroll
	.long	0		; 8
	.long	0		; 7
	.long	>2000		; 6 - 
	.long	>4000		; 5 - distant bridge
	.long	>4000		; 4 - distant fighters
	.long	>8000		; 3 - mist
	.long	>20000		; 2 - main bridge
	.long	>20000		; 1 - main bridge
	.long	0		; 0

calla_bridge
	create	pid_bani,little_fighters
	rets

dlists_bridge
	.long	baklst8,worldtlx8+16
	.long	baklst7,worldtlx7+16
	.long	baklst6,worldtlx6+16
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16
	.long	baklst3,worldtlx3+16
	.long	baklst2,worldtlx2+16
	.long	objlst,worldtlx+16
	.long	baklst1,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0


little_fighters
	movi	BKGUY1,a5
	movi	>005802d0,a4
	callr	make_lil
	move	a8,a10
	movi	a_darkman1,a11

	movi	TORCH1,a5
	movi	>004f02f0,a4
	callr	make_lil

	movi	a_darkman2,a9

lil4	calla	frame_a9

	mmtm	sp,a8,a9
	move	a10,a8
	move	a11,a9
	calla	frame_a9
	move	a9,a11
	mmfm	sp,a8,a9

	sleep	6
	jruc	lil4


a_darkman1
	.long	BKGUY1
	.long	BKGUY2
	.long	BKGUY3
	.long	BKGUY4
	.long	BKGUY5
	.long	BKGUY6
	.long	BKGUY7
	.long	ani_jump,a_darkman1

a_darkman2
	.long	TORCH1
	.long	TORCH2
	.long	TORCH3
	.long	TORCH4
	.long	TORCH5
	.long	TORCH6
	.long	TORCH7
	.long	ani_jump,a_darkman2

make_lil
	push	a4
	calla	gso_dmawnz
	pull	a4
	calla	set_xy_coordinates

	move	a8,a0
	movi	baklst4,b4
	calla	insobj_v
	rets

**************************************************************************
*											     *
*  module: tomb											*
*											     *
**************************************************************************
tomb_mod
	.word	0			 	; autoerase color

	.word	220	     			; ground y
	.word	220-wy_offset-8			; initial world y
	.word	(1965/2)-(scrrgt/2)+>30	; initial worldx

	.word	>1b0 	  			; scroll left limit
	.word	>4da	  			; scroll right limit

	.long	calla_tomb
	.long	tomb_scroll			; scroll table
	.long	dlists_tomb

	.long	bak1mods

	.long	skip_bakmod			; baklst1 = skipped

	.long	TMOD1BMOD			; baklst2 = WALL
	.word	>00,->28
	.long	TMOD2BMOD			; baklst3 = FENCE
	.word	>00,>6c

	.long	skip_bakmod			; baklst4 = bats (skip)

	.long	TMOD3BMOD			; baklst5 = SKY
	.word	>00,>30

	.long	center_x
	.long	TMOD1BMOD,worldtlx2	; wall
	.long	TMOD2BMOD,worldtlx3	; FENCE
	.long	TMOD3BMOD,worldtlx5	; SKY
	.long	0


no_scroll
tomb_scroll
	.long	0		; 8
	.long	0		; 7
	.long	0		; 6
	.long	0		; 5 -
	.long	>10000		; 4 -
	.long	>10000		; 3 - fence
	.long	>18000		; 2 - wall
	.long	>20000		; 1 - players
	.long	0		; 0


calla_tomb
	create	pid_bani,bats_proc
	create	pid_bani,small_bat_proc

	movi	tomb_floor_info,a0
	callr	setup_floor_info
	rets

tomb_floor_info
	.long	FL_TOMB			; sag
	.long	TOMBFLR_p		; palette for floor
	.word	>cb			; skew y position
	.word	59			; height
	.long	scrollx2
	.long	tomb_skew_calla

tomb_skew_calla
	move	@skew_dx,a11,l		; dx per line
	sra	7,a9
	sub	a9,a11			; adjust with scroll
	move	a11,@skew_dx,l
	jauc	skew_rets

dlists_tomb
	.long	baklst6,worldtlx6+16
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16
	.long	-1,floor_code
	.long	baklst3,worldtlx3+16
	.long	baklst2,worldtlx2+16
	.long	-2
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0

dlists_ceiling
	.long	baklst6,worldtlx6+16
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16
	.long	-1,floor_code
	.long	baklst3,worldtlx3+16
	.long	baklst2,worldtlx2+16
	.long	baklst1,worldtlx2+16
	.long	-2
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0



get_bat_obj
	mmtm	sp,a0,a4
	movi	MEDBAT1,a5
	calla	gso_dmawnz
	mmfm	sp,a0,a4
	move	a0,*a8(oxvel),l

	callr	set_bat_coordinates

	move	a8,a0
	movi	baklst4,b4
	jauc	insobj_v


small_bat_proc
	movi	>10000,a0
	movi	>0060ffc0,a4
	callr	get_bat_obj
	calla	flip_single

bat0	movi	>0060ffc0,a4
	callr	set_bat_coordinates
	movi	a_smallbat,a9
	movk	1,a0
	calla	init_anirate

bat1	sleep	6
	calla	next_anirate
	move	*a8(oxpos),a0,w
	move	@worldtlx4+16,a1,w
	addi	scrrgt,a1
	sub	a1,a0
	cmpi	>40,a0
	jrlt	bat1

	jsrp	bat_pause
	jruc	bat0

bats_proc
	movi	->20000,a0
	movi	>08000800,a4
	callr	get_bat_obj

bat2 	movi	>00500190,a4
	callr	set_bat_coordinates

	movi	a_medbat,a9
	movk	1,a0
	calla	init_anirate

bat3	sleep	6
	calla	next_anirate
	move	*a8(oxpos),a0,w
	move	@worldtlx4+16,a1,w
	sub 	a0,a1
	cmpi	>40,a1
	jrlt	bat3

	jsrp	bat_pause
	jruc	bat2

bat_pause
	move	*a8(oxvel),a11,l
	calla	stop_a8
	sleep	>60
	move	a11,*a8(oxvel),l
	retp


set_bat_coordinates
	move	@worldtlx4,a0,l
	move	@worldtly,a1,l
	srl	16,a0
	or	a0,a1
	add	a1,a4
	jauc	set_xy_coordinates


a_medbat
	.long	MEDBAT1
	.long	MEDBAT2
	.long	MEDBAT3
	.long	MEDBAT4
	.long	MEDBAT5
	.long	MEDBAT6
	.long	MEDBAT7
	.long	MEDBAT8
	.long	ani_jump,a_medbat

a_smallbat
	.long	SMBAT1
	.long	SMBAT2
	.long	SMBAT3
	.long	SMBAT4
	.long	SMBAT5
	.long	SMBAT6
	.long	SMBAT7
	.long	SMBAT8
	.long	ani_jump,a_smallbat

**************************************************************************
*											     *
*  module: statues										*
*											     *
**************************************************************************
dedpool_mod
	.word	(32*32*3)+(32*5)+1 	; autoerase color

	.word	>d8	     			; ground y
	.word	>d8-wy_offset			; initial world y

;*********************
;	.word	(1144/2)-(scrrgt/2)+>30	; initial worldx
	.word	0
;*********************

	.word	>2 	  			; scroll left limit
	.word	>2eb	  			; scroll right limit

	.long	calla_dedpool
	.long	dedpool_scroll			; scroll table
	.long	dlists_dedpool

	.long	bak1mods

	.long	DPUL5BMOD			; baklst1 = back wall
	.word	0,->58

	.long	skip_bakmod			; baklst2 = skip
;	.long	DPUL1BMOD
;	.word	-610,>00

;*************************
;	.long	skip_bakmod			; skip baklst3
;;	.long	DPUL2BMOD
;;	.word	-297,->40

	.long	DPUL2BMOD
	.word	0,->40				; baklst3 = close up chains
;*************************

	.long	DPUL3BMOD			; 4 - chains
;	.word	-24,->40
	.word	0,->40

	.long	DPUL4BMOD			; 5 - chains
;	.word	14,->40
	.word	0,->40

	.long	center_x
	.long	DPUL5BMOD,worldtlx		; back wall
	.long	DPUL3BMOD,worldtlx4		; back wall
	.long	DPUL4BMOD,worldtlx5		; back wall
	.long	DPUL2BMOD,worldtlx3		; close chains
	.long	0


dedpool_scroll
	.long	0		; 8
	.long	0		; 7
	.long	0		; 6
	.long	>24000		; 5
	.long	>28000		; 4
	.long	>30000		; 3
	.long	0		; 2
	.long	>20000		; 1
	.long	0		; 0

dlists_dedpool
	.long	baklst1,worldtlx+16		; wall is furthest thing back
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16

;	.long	baklst2,worldtlx2+16

	.long	-2				; shadows
	.long	objlst,worldtlx+16
	.long	baklst3,worldtlx3+16		; close up chains
	.long	objlst2,worldtlx+16
	.long	0

calla_dedpool
	create	pid_cycle,dedpool_cycle
	rets

dedpool_cycle
	sleep	4
	movi	NESS_P,a10
	movi	>010F0600,a11
	jauc	cycle_forward

**************************************************************************
*											     *
*  module: Batttle field										*
*											     *
**************************************************************************
battle_mod
	.word	(32*32*2)+(32*0)+2 		; autoerase color

	.word	>e5	     			; ground y
	.word	>e5-wy_offset-19		; initial world y
	.word	(1282/2)-(scrrgt/2)		; initial worldx

	.word	>00 	  			; scroll left limit
	.word	1282-scrrgt  			; scroll right limit

	.long	calla_battle
	.long	battle_scroll			; scroll table
	.long	dlists_battle

	.long	bak1mods

	.long	skip_bakmod			; skip baklst1

	.long	BAT1BMOD
	.word	0,>93
	.long	BAT2BMOD
	.word	(1282-784)/2,>04
	.long	BAT4BMOD
	.word	(1282-837)/2,>61
	.long	BAT5BMOD
	.word	(1282-300)/2+>b0,>40		; castle
	.long	BAT6BMOD
	.word	(1282-480)/2,>5a		; mountains
	.long	BAT7BMOD
	.word	((1282-433)/2),>1A		; sky

	.long	>ffffffff


battle_scroll
	.long	0		; 7
	.long	0		; 6
	.long	>2000		; 5
	.long	>3000		; 6
	.long	>8000		; 4
	.long	>10000		; 3
	.long	>1a000		; 2
	.long	>20000		; 1
	.long	0		; 0

dlists_battle
	.long	baklst8,worldtlx8+16
	.long	baklst7,worldtlx7+16
	.long	baklst6,worldtlx6+16
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16
	.long	baklst3,worldtlx3+16
	.long	-1,floor_code
	.long	baklst2,worldtlx2+16
	.long	baklst1,worldtlx+16
	.long	-2				; shadows
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0

calla_battle
	create	pid_cycle,battle_cycle
	movi	battle_floor_info,a0
	callr	setup_floor_info
	rets

battle_floor_info
	.long	FL_BATTL			; sag
	.long	GROUND_p			; palette for floor
	.word	>d2				; skew y position
	.word	45				; height
	.long	scrollx2
	.long	battle_skew_calla

battle_skew_calla
	move	@skew_dx,a11,l		; dx per line
	sra	7,a9
	sub	a9,a11			; adjust with scroll
	jauc	skew_rets

battle_cycle
	sleep	4
	movi	WATER,a10
	movi	>21080800,a11
	jauc	cycle_forward

**************************************************************************
*											     *
*  module: Tower											*
*											     *
**************************************************************************
tower_mod
	.word	(32*32*7)+(32*9)+12 		; autoerase color

	.word	>e5	     			; ground y
	.word	>e5-wy_offset-19		; initial world y

	.word	(1120/2)-(scrrgt/2)		; initial worldx
	.word	>2c 	  			; scroll left limit
	.word	>2cc	  			; scroll right limit
	.long	calla_tower
	.long	tower_scroll			; scroll table
	.long	dlists_tower

	.long	bak1mods
	.long	skip_bakmod			; skip baklst1
	.long	skip_bakmod			; skip baklst2
	.long	skip_bakmod			; skip baklst3

;	.long	PLANE3BMOD			; baklst3 = statues
;	.word	(1120-705)/2,>0e

	.long	PLANE4BMOD			; baklst4 = pillars / smallest statue
	.word	>16d,->1f

	.long	skip_bakmod			; skip baklst5 = monk

	.long	PLANE5BMOD			; baklst6 = wall
	.word	0,->21
	.long	>ffffffff


tower_scroll
	.long	>14000		; 8 - clouds
	.long	>14000		; 7 - clouds
	.long	>14000		; 6 - wall
	.long	>14000		; 5 - monk
	.long	>16000		; 4 - pillars / smallest statue #1
	.long	>18000		; 3 - statue #2
	.long	0		; 2 - 
	.long	>20000		; 1 -
	.long	0		; 0

window_right	.set	>290
window_left	.set	>1ca

calla_tower
	movi	tower_floor_info,a0
	callr	setup_floor_info
	create	pid_bani,cloud_proc

	movi	>00480218,a4
	movi	>004b0218,a5
	movi	baklst5,a6
	callr	make_big_monk

return	rets


tower_floor_info
	.long	FL_TOW			; sag
	.long	CASFLR1_p		; palette for floor
	.word	>b5			; skew y position
	.word	75			; height
	.long	scrollx6
	.long	tower_skew_calla

tower_skew_calla
	move	@skew_dx,a11,l		; dx per line
	sra	7,a9
	sub	a9,a11			; adjust with scroll
	move	a11,@skew_dx,l
	jauc	skew_rets


dlists_bogus
	.long	baklst8,worldtlx8+16
	.long	baklst7,worldtlx7+16
	.long	baklst6,worldtlx6+16
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16
	.long	baklst3,worldtlx3+16
	.long	baklst2,worldtlx2+16
	.long	baklst1,worldtlx+16
dlists_objlst
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0

dlists_tower
	.long	baklst8,worldtlx8+16		; clouds
	.long	baklst7,worldtlx7+16		; clouds
	.long	baklst6,worldtlx6+16
	.long	-1,floor_code
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16
	.long	baklst3,worldtlx3+16
	.long	baklst2,worldtlx2+16
	.long	-2				; shadows
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0

set_skew_flag
	movk	1,a0
	move	a0,@f_skew,w
	rets



make_big_monk
	create	pid_bani,monk_proc
	move	a4,*a0(p_store1),l
	move	a5,*a0(p_store2),l
	move	a6,*a0(p_store3),l
	rets

*
* p_store1 = piece #1 coordinates
* p_store2 = piece #2 coordinates
*
monk_proc
	move	*a13(p_store1),a4,l
	callr	monk_piece
	move	a8,a11

	move	*a13(p_store2),a4,l
	callr	monk_piece

	movi	monk_ani,a9
	movk	6,a0
	calla	init_anirate
	movi	>4000,a10

monkp4	sleep	1
	calla	next_anirate
	addi	>400,a10
	move	a10,*a8(oyvel),l
	move	a10,*a11(oyvel),l
	cmpi	>8000,a10
	jrlt	monkp4

monkp6	sleep	1
	calla	next_anirate
	subi	>400,a10
	move	a10,*a8(oyvel),l
	move	a10,*a11(oyvel),l
	cmpi	->8000,a10
	jrgt	monkp6
	jruc	monkp4


monk_ani
	.long	monk1
	.long	monk2
	.long	monk3
	.long	monk4
	.long	monk5
	.long	monk6
	.long	monk7
	.long	ani_jump,monk_ani

monk_piece
	push	a4
	movi	monktorso,a5
	calla	gso_dmawnz
	pull	a4

	calla	set_xy_coordinates
	move	a8,a0
	move	*a13(p_store3),a6,l
	move	a6,b4
	jauc	insobj_v



cloud_proc
	movi	>30000,a14				; cloud velocity
	movi	>002a0000+window_left->30,b2	; coordinates
	callr	get_a8_to_a11				; get a row o clouds
	move	a8,@baklst7,l

	mmtm	a12,a8,a9,a10,a11			; save list #7

	movi	>18000,a14				; cloud velocity
	movi	window_left,b2				; coordinates
	callr	get_a8_to_a11				; get a row o clouds
	move	a8,@baklst8,l

**************************************************************************
*											     *
*  cloud move loop									     *
*											     *
**************************************************************************

cld4	callr	clip_a_row		; clip baklst8

	move	a8,b0
	move	a9,b1
	move	a10,b2
	move	a11,b3

	mmfm	a12,a8,a9,a10,a11   	; get baklst7
	callr	clip_a_row		; clip baklst7
	mmtm	a12,a8,a9,a10,a11   	; update baklst7

	move	b0,a8
	move	b1,a9
	move	b2,a10
	move	b3,a11

	sleep	2

;	jauc	wait_forever

	jruc	cld4


clip_a_row
	move	*a11(oxpos),a0,w
	cmpi	window_right,a0		; beyond right edge ??
	jrls	cld5			; no, clip it
*
* wrap around rightmost cloud
*
	clr	a0
	move	a0,*a11(ofset),w	; no clipping

	move	*a11(oslink),a0,w
	dec	a0
	sll	5,a0
	addi	cloud_wrap,a0
	move	*a0,a1,w
	move	*a0(16),a2,w

	move	*a8(oxpos),a3,w

;***********
;	move	*a8(ofset),a0,w
;	sll	32-8,a0
;	srl	32-8,a0			; a0 = left clip
;	sub	a0,a1
;***********

	add	a1,a3
	move	a3,*a11(oxpos),w
	move	*a8(oypos),a3,w
	add	a2,a3
	move	a3,*a11(oypos),w

	move	a8,a14
	move	a11,a8
	move	a10,a11
	move	a9,a10	      		; cloud shuffle
	move	a14,a9 			; clouds are: a8 --> a9 --> a10 --> a11

cld5	move	a8,a14
	move	a9,a5			; a5 = cloud to the right of me
	callr	left_edge_clip
	move	a10,a5			; a5 = cloud to the right of me
	move	a9,a14
	callr	left_edge_clip		; clip 2 leftmost clouds
	clr	a0
	move	a0,*a10(ofset),w	; make sure no clip on a10 cloud
*
* clip rightmost cloud (a11)
*
	move	*a11(oxpos),a0,w	; a0 = left edge
	move	*a11(osizex),a1,w
	move	a1,a2
	add	a0,a1			; a1 = right edge
	subi	window_right,a1		; a1 = amount to clip off right
	jrn	cld9			; none

	sub	a1,a2			; a2 = # of pixels on screen
	cmpi	3,a2			; more than 3 ?
	jrhi	cld6			; yes ---> ok
    	subk	3,a1			; no ----> make sure at least 3
cld6	sll	8,a1			; put on the "right clip" side
	move	a1,*a11(ofset),w	; set "right clip"
cld9	rets


left_edge_clip
	move	*a14(oypos),a2,w
	andi	>0fff,a2    		; assume: back in our world
	move	*a5(oxpos),a0,w
	move	*a14(osizex),a1,w
	sub	a1,a0   	   	; a0 = my unclipped x
	add	a0,a1			; a1 = right edge

	subi	window_left-8,a1    	; a1 = # of pixels on screen
	jrn	cld7			; none ---> offscreen please
	cmpi	4,a1
	jrlo	cld7			; don't allow smaller than 4 pixels
*
* onscreen ---> check for clipping
*
	move	a2,*a14(oypos),w	; onscreen = normal y position
	cmpi	window_left-8,a0
	jrhs	cld8			; totally onscreen ----> no clip

	move	*a14(osizex),a2,w
	sub	a1,a2			; a2 = amount to clip off left
	move	a2,*a14(ofset),w	; set "left clip"
	add	a2,a0
	move	a0,*a14(oxpos),w

	movi	window_left-8,a1
	move	a1,*a14(oxpos),w	; adjust coordinates for clip change

 	rets

cld7	addi	>4000,a2		; set this piece offscreen
	move	a2,*a14(oypos),w
	rets

cld8	clr	a2
	move	a2,*a14(ofset),w
	move	a0,*a14(oxpos),w	; fully onscreen = set true x position
	rets


make_a_cloud
	push	a14
	movi	cloud1a,a5
	calla	gso_dmawnz
	move	*a8(oflags),a4,w
	ori	dmaclp,a4
	move	a4,*a8(oflags),w		; set the "register clip bit"

	move	b2,a4
	calla	set_xy_coordinates
	move	a11,*a8(oslink),w
	pull	a14
	move	a14,*a8(oxvel),l
	rets


get_a8_to_a11
	movk	4,a11
	callr	make_a_cloud
	move	a8,a10				; a10 = 1st object

	movk	3,a11
cld2	move	a8,a9

	callr	make_a_cloud
	move	a11,a1
	dec	a1
	sll	6,a1

	move	*a9(oxpos),*a8(oxpos),w
	move	*a9(oypos),*a8(oypos),w	; match up coords

	addi	cloud_row,a1
	move	a1,a2
	move	*a1,a1,l			; grab oimg
	calla	ani_flag

	move	*a8(oflags),a4,w
	ori	dmaclp,a4
	move	a4,*a8(oflags),w		; set the "register clip bit"

	addi	32,a2
	move	*a2,a3,w    			; dx
	move	*a2(16),a4,w			; dy

	move	*a9(oxpos),a5,w
	add	a3,a5
	move	a5,*a8(oxpos),w
	move	*a9(oypos),a5,w
	add	a4,a5
	move	a5,*a8(oypos),w	  	; connect !

	move	a8,*a9(olink),l	  	; link to previous

	dsj	a11,cld2

	move	a10,a8	    		;  a8 = 1st
	move	*a8,a9,l    		;  a9 = 2nd
	move	*a9,a10,l   		; a10 = 3rd
	move	*a10,a11,l  		; a11 = 4th
	clr	a0
	move	a0,*a11(olink),l  	; last one = zero link
	rets


cloud_wrap
	.word	->56,>00	; 0
	.word	->62,>2c	; 1
	.word	->62,>00	; 2
	.word	->56,->2c	; 3

cloud_row
	.long	cloud1d
	.word	>62,->2c

	.long	cloud1c
	.word	>62,>00

	.long	cloud1b
	.word	>56,>2d

	.long	cloud1a
	.word	0,0

**************************************************************************
*											     *
*  module: forest										*
*											     *
**************************************************************************
forest_mod
	.word	0				; autoerase color

	.word	>e3	     			; ground y
	.word	>e5-wy_offset-19		; initial world y
	.word	(1279/2)-(scrrgt/2)		; initial worldx

	.word	>00 	  			; scroll left limit
	.word	>363	  			; scroll right limit
	.long	calla_forest
	.long	forest_scroll			; scroll table
	.long	dlists_forest

	.long	bak1mods
	.long	skip_bakmod			; baklst1 = SKIP

	.long	wood1BMOD
	.word	>00,->36			; baklst2 = Biggest trees
	.long	wood2BMOD
	.word	(1279-1009)/2,->1a		; baklst3

	.long	skip_bakmod			; baklst4 = SKIP

	.long	wood4BMOD
	.word	(1279-1057)/2,>14		; baklst5
	.long	wood5BMOD
	.word	(1279-849)/2,>21		; baklst6
	.long	wood6BMOD
	.word	(1279-716)/2,>3a		; baklst7
	.long	wood7BMOD
	.word	(1279-522)/2,>52		; baklst8

	.long	>ffffffff


;	.long	wood1BMOD
;	.word	>00,->36			; baklst2 = Biggest trees
;	.long	wood2BMOD
;	.word	(1279-1009)/2,->1a		; baklst3
;	.long	wood4BMOD
;	.word	(1279-1057)/2,>14		; baklst4
;	.long	wood5BMOD
;	.word	(1279-849)/2,>21		; baklst5
;	.long	wood6BMOD
;	.word	(1279-716)/2,>3a		; baklst6
;	.long	wood7BMOD
;	.word	(1279-522)/2,>52		; baklst7
;	.long	>ffffffff


forest_scroll
	.long	0		; 8
	.long	>a000		; 7
	.long	>10000		; 6
	.long	>14000		; 5

	.long	>18000		; 4 - secrets
	.long	>18000		; 3

	.long	>20000		; 2
	.long	>20000		; 1
	.long	0		; 0


calla_forest
	create	pid_bani,secret_peek
	create	pid_bani,tree_animator
	movi	forest_floor_info,a0
	callr	setup_floor_info
	rets


secret_peek
	move	@gstate,a0,w
	cmpi	gs_amode,a0
	jaeq	sucide

	movi	100,a0
	calla	randper
	janc	sucide		; not often

	movi	>58,a10
	movi	>78,a11
	movi	->20000,a9
	movi	NJSMOKEHIDE,a5

	move	@rand,a0,l
	jrn	secp4

	movi	JADEHIDDEN,a5
	movi	>58,a10
	movi	>90,a11
	movi	>20000,a9

secp4	calla	gso_dmawnz

	move	@worldtly+16,a0,w	
	add	a10,a0
	move	a0,*a8(oypos),w		; on ground
	move	@worldtlx+16,a0,w
	add	a11,a0
	move	a0,*a8(oxpos),w

	move	a8,a0
	movi	baklst4,b4
	calla	insobj_v

	movk	3,a10
peekl	movi	>40*5,a0
	calla	randu
	addi	>40*5,a0
	calla	prcslp

	move	*a8(oxpos),a11,w
	move	a9,*a8(oxvel),l
	sleep	>0c
	calla	stop_a8
	sleep	>40
	neg	a9
	move	a9,*a8(oxvel),l
	neg	a9
	sleep	>0c
	calla	stop_a8
	move	a11,*a8(oxpos),w
	dsj	a10,peekl

	die



forest_floor_info
	.long	FL_FORST	; sag
	.long	humus_p
	.word	>d7			; skew y position
	.word	39			; height
	.long	scrollx
	.long	forest_skew_calla


forest_skew_calla
	move	@skew_dx,a11,l		; dx per line
	sra	8,a9
	sub	a9,a11			; adjust with scroll
	move	a11,@skew_dx,l
	jauc	skew_rets

dlists_forest
	.long	baklst8,worldtlx8+16		; clouds
	.long	baklst7,worldtlx7+16		; clouds
	.long	baklst6,worldtlx6+16		; 
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16
	.long	baklst3,worldtlx3+16
	.long	-1,floor_code
	.long	baklst2,worldtlx2+16
	.long	baklst1,worldtlx+16
	.long	-2				; shadows
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0

tree_animator
	movi	>00490148,a4
	callr	make_a_mad_tree
	move	a8,a11
	movi	>00490270,a4
	callr	make_a_mad_tree
	move	a8,a10
	movi	>00490391,a4
	callr	make_a_mad_tree			; trees are: a11 / a10 / a8

treea3	movi	>c0,a0
	calla	randu
	addi	>80,a0
	calla	prcslp

	tsound	>b6			; sound: tree roar
	movi	a_treeroar,a9
	movk	5,a0
	jsrp	triple_framew
	jruc	treea3

triple_framew
	pushp	a0		; save sleep time

trip2	calla	frame_a9	; 1
	jrc	trip5		; carry set = we just did last frame

	subi	32,a9
	push	a8
	move	a11,a8
	calla	frame_a9	; 2
	subi	32,a9
	move	a10,a8
	calla	frame_a9	; 2
	pull	a8
	move	*a12,a0,l	; sleep time
	calla	prcslp
	jruc	trip2

trip5	pullp	a0
	retp



make_a_mad_tree
	push	a4
	movi	TREEANI1,a5
	calla	gso_dmawnz
	pull	a4
	calla	set_xy_coordinates
	move	a8,a0
	movi	baklst1,b4
	jauc	insobj_v


a_treeroar
	.long	TREEANI1
	.long	TREEANI2
	.long	TREEANI3
	.long	TREEANI4
	.long	TREEANI5
	.long	TREEANI6
	.long	TREEANI7

	.long	TREEANI6
	.long	TREEANI7
	.long	TREEANI6
	.long	TREEANI7
	.long	TREEANI6
	.long	TREEANI7
	.long	TREEANI6
	.long	TREEANI7

	.long	TREEANI5
	.long	TREEANI4
	.long	TREEANI3
	.long	TREEANI2
	.long	TREEANI1
	.long	0

;*********************************************************************

armory_mod
	.word	0				; autoerase color
	.word	>f1	     			; ground y
	.word	>00				; initial world y

	.word	>200				; initial worldx
	.word	>50 	  			; scroll left limit
	.word	>39f		 		; scroll right limit

	.long	calla_armory
	.long	armory_scroll			; scroll table
	.long	dlists_armory

	.long	bak1mods

	.long	skip_bakmod			; baklst1 = skip baklst1

	.long	ARM1BMOD			; baklst2 = pillars / weapons rack
	.word	>00,->16

	.long	skip_bakmod			; baklst3 = LAVA ANIMATION

	.long	ARM2BMOD			; baklst4 = steel tub
	.word	>00,>33

	.long	ARM3BMOD			; baklst5 = back wall w/ mk symbol
	.word	>00,-20

	.long	center_x
	.long	ARM1BMOD,worldtlx2
	.long	ARM2BMOD,worldtlx3		; lineup lava with steel tub
	.long	ARM2BMOD,worldtlx4
	.long	ARM3BMOD,worldtlx5
	.long	0


dlists_armory
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16
	.long	baklst3,worldtlx3+16
	.long	-1,floor_code
	.long	baklst2,worldtlx2+16
	.long	-2				; shadows
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0

armory_scroll
	.long	>16000		; 8 - skewing floor follows this scroll 
	.long	0		; 7
	.long	0		; 6
	.long	>c000		; 5 - back wall
	.long	>15000		; 4 - steel tub
	.long	>15000		; 3 - lava animation
	.long	>1c000		; 2 - pillars
	.long	>20000		; 1 - players
	.long	0		; 0

calla_armory
	create	pid_cycle,armory_cycle
	create	pid_bani,lava_ani
	movi	armory_floor_info,a0

setup_floor_info
	move	*a0+,a1,l
	addi	>2000000+(400*6),a1	; centered
	move	a1,@skew_sag,l		; #1 = sag

	move	*a0+,a1,l
	push	a0
	move	a1,a0
	calla	getfpal
	move	a0,@skew_constpal,l	; #2 = set const:pal
	pull	a0

;	move	*a0+,a1,w
;	clr	a1
;	move	a1,@skew_dx,l		; #3 = skew dx

	clr	a1
	move	a1,@skew_oc,l		; #4 = off center = 0

	move	*a0+,a1,w
	move	a1,@skew_y,w		; #4 = y position of floor

	move	*a0+,a1,w
	move	a1,@skew_height,w 	; #5 = height of floor piece

	move	*a0+,a1,l
	move	a1,@skew_scroll,l	; #6 = scroll x to use

	move	*a0+,a1,l
	move	a1,@skew_calla,l	; #7 = scroll

	callr	set_skew_flag
	rets


armory_floor_info
	.long	FL_ARM			; sag
	.long	MARFLOR			; palette for floor
	.word	>c0			; skew y position
	.word	62			; height
	.long	scrollx8
	.long	armory_skew_calla

armory_skew_calla
	move	@skew_dx,a11,l		; dx per line
	sra	7,a9
	sub	a9,a11			; adjust with scroll
	move	a11,@skew_dx,l
	jauc	skew_rets


armory_cycle
	sleep	4
	movi	VAT,a10
	movi	>2d0b0600,a11
	jauc	cycle_forward

lava_ani
	movi	>00520066,a4
	callr	make_lava_piece
	calla	flip_single
	move	a8,a11

	movi	>005200e7,a4
	callr	make_lava_piece
	move	a8,a10

	movi	>00520368,a4
	callr	make_lava_piece
	calla	flip_single

lavaa2	movi	a_lava,a9
	movk	6,a0
	jsrp	triple_framew
	jruc	lavaa2


make_lava_piece
	push	a4
	movi	LAVA1,a5
	calla	gso_dmawnz
	pull	a4
	calla	set_xy_coordinates
	move	a8,a0
	movi	baklst3,b4
	jauc	insobj_v


a_lava
	.long	LAVA1
	.long	LAVA2
	.long	LAVA3
	.long	LAVA4
	.long	LAVA5
	.long	LAVA6
	.long	LAVA7
	.long	LAVA8
	.long	LAVA9
	.long	LAVA10
	.long	LAVA11
	.long	LAVA12
	.long	0

;***********************************************************************

mk1_mod
	.word	0	       		; background sky color
	.word	265			; ground y
	.word	>1a			; initial worldy
	.word	372			; initial worldx

	.word	>80 	  		; scroll left limit
	.word	>330	  		; scroll right limit
	.long	return
	.long	cave_scroll		; scroll table
	.long	dlists_cave

	.long	bak1mods
	.long	dun1BMOD		; 1
	.word	71,>105
	.long	dun2BMOD		; 2
	.word	71,>f5
	.long	dun3BMOD		; 3
	.word	71,>e7
	.long	dun4BMOD		; 4
	.word	>00,->5d
	.long	dun5BMOD		; 5
	.word	143,>ca
	.long	dun8BMOD		; 6
	.word	215,-5
	.long	dun9BMOD		; 7
	.word	295,>ba
	.long	dun10BMOD		; 8
	.word	385,>b6
	.long	>ffffffff

cave_scroll
	.long	>10000		; 8
	.long	>12000		; 7
	.long	>14000		; 6
	.long	>18000		; 5
	.long	>1c000		; 4
	.long	>1e000		; 3
	.long	>20000		; 2
	.long	>22000		; 1
	.long	0		; 0

dlists_cave
	.long	baklst8,worldtlx8+16
	.long	baklst7,worldtlx7+16
	.long	baklst6,worldtlx6+16
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16
	.long	baklst3,worldtlx3+16
	.long	baklst2,worldtlx2+16
	.long	baklst1,worldtlx+16
;	.long	-2				; shadows
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0

;*********************************************************************


moflr_p
	.word   64 
	.word   00000h,030e4h,02483h,02cc5h,028a4h,03927h,03506h,03d48h
	.word   03d27h,03505h,01c62h,02cc3h,03926h,02083h,03884h,02863h
	.word   04107h,03907h,04907h,03d08h,02943h,02ce3h,04168h,03d07h
	.word   03d47h,028a6h,02484h,03928h,030e6h,01c64h,03d29h,02cc8h
	.word   0458ah,049a9h,04daah,049aah,04568h,0416ah,0498ch,03925h
	.word   030e5h,04169h,04567h,01862h,051cah,04548h,030e3h,04547h
	.word   02062h,01841h,01441h,02cc4h,030c6h,034e8h,04148h,028e3h
	.word   01861h,04989h,020a1h,04549h,04149h,034e7h,028c2h,03104h

STADFLR_p:
	.word   64 
	.word   039ceh,049abh,0458ah,04589h,04168h,04dcbh,03d47h,051edh
	.word   04dcch,049ach,051eeh,0560eh,055edh,0416ah,05a2fh,049a9h
	.word   051ebh,04167h,03926h,03d48h,04587h,03505h,04dceh,04dc9h
	.word   03506h,03925h,03104h,0458ch,04e2fh,05e50h,045efh,05672h
	.word   066d5h,04a11h,045f0h,04a10h,04e30h,05673h,04e32h,041cfh
	.word   0356eh,04e33h,03daeh,05e94h,05252h,06af7h,05e92h,0318ch
	.word   04a31h,05694h,0314ah,0398ch,0356bh,02d29h,024e7h,0316bh
	.word   02908h,03dceh,039adh,0316ch,03d8eh,02929h,031c4h,03087h

MARFLOR:
	.word   64 
	.word   00000h,024a2h,02083h,02082h,024a4h,02ce4h,028c3h,028c4h
	.word   01841h,01420h,01862h,01441h,01c62h,028a3h,020a3h,024c4h
	.word   02ce5h,03105h,03526h,028c5h,00c00h,03506h,03925h,03106h
	.word   00400h,02cc4h,01000h,00000h,03107h,03527h,04144h,04902h
	.word   040e3h,01c84h,01c83h,020a5h,020a4h,028e5h,024c5h,01442h
	.word   01021h,01462h,01863h,028e6h,02d06h,03127h,024c6h,00801h
	.word   03548h,02ce6h,02d07h,00001h,01864h,02d08h,03d69h,00401h
	.word   0418ah,04df3h,01c85h,01443h,01022h,00802h,00002h,0560eh

CASFLR1_p:
	.word   64 
	.word   00000h,02d29h,0290ah,02d2ah,02909h,0314bh,0356bh,0396bh
	.word   03569h,03149h,0314ch,020c8h,024e7h,01ca7h,024e8h,01cc8h
	.word   024eah,020c7h,02d2ch,0356ch,0398ch,03dadh,03d8eh,03dabh
	.word   041ceh,049ceh,041ach,0418ch,01887h,01888h,01486h,00c45h
	.word   01065h,014a6h,0394ah,020cah,045eeh,049edh,03d8ch,02929h
	.word   01cc7h,03daah,00842h,03169h,00843h,02d07h,045eah,03d88h
	.word   045cbh,018c6h,02c04h,02c05h,03005h,03405h,03806h,03c26h
	.word   04028h,04049h,049a2h,04582h,03d23h,03d03h,034e3h,02404h

humus_p:
	.word   63 
	.word   00000h,00860h,00060h,008a0h,000c0h,00ca0h,02da5h,004a0h
	.word   02123h,00d00h,00cc0h,01500h,01941h,01482h,00c60h,018e3h
	.word   018e1h,010a0h,01081h,018c0h,018e2h,01121h,014e0h,00080h
	.word   01d42h,01100h,02164h,008e0h,00cc3h,01d62h,03da8h,02d06h
	.word   020e2h,01ce1h,01481h,03166h,02d05h,02d45h,018a4h,01cc3h
	.word   018a2h,02926h,02925h,020e4h,02504h,02d27h,03167h,02d46h
	.word   03566h,03168h,0398ah,02d25h,02503h,020e3h,03546h,03545h
	.word   01cc2h,020c4h,02924h,03146h,03987h,024e5h,02102h

GROUND_p:
	.word   64 
	.word   00000h,01503h,02146h,014c3h,01d04h,0350ch,028e8h,02147h
	.word   024e7h,01c87h,0396ch,0350bh,0354bh,020aah,01c88h,024c9h
	.word   020a8h,0312ch,0312bh,028eah,02d0ah,01468h,0352dh,024cch
	.word   03d8eh,041adh,045aeh,041aeh,0354ch,03d6ch,0396eh,04190h
	.word   0352bh,03129h,02d09h,028e9h,0396dh,03d6bh,01066h,01466h
	.word   049ceh,03d4ch,020e9h,024c7h,028e7h,03d4bh,01866h,01045h
	.word   00c44h,024c8h,028cah,02cech,0312ah,0394ch,020e7h,01065h
	.word   0418dh,018a5h,03d4dh,0394dh,02cebh,01887h,020c6h,02908h

TOMBFLR_p:
	.word   61 
	.word   035adh,034e6h,02483h,01820h,028a5h,02082h,01c41h,04147h
	.word   04988h,055cah,04da9h,04989h,04568h,03d27h,01821h,028c4h
	.word   030e4h,04146h,01c21h,02ca3h,0412ah,05e0bh,0664fh,01c40h
	.word   055c8h,05e2eh,02463h,04da8h,05a0eh,06e8fh,01c20h,02482h
	.word   01000h,0664bh,01400h,04566h,02cc5h,045abh,0418bh,045aah
	.word   049cbh,0416bh,0418ah,0498dh,0456ah,03949h,03106h,03506h
	.word   030e7h,0560eh,0456ch,03d6ah,051ech,06693h,03927h,04148h
	.word   03948h,05a4fh,03529h,05e70h,04da7h


coin_page_bgnd
;	movi	dlists_bogus,a0
;	move	a0,@dlists,l

	movk	2,a11
	calla	do_a11_background
	calla	amode_coinpage_mk2

;	movi	>33,a3
;	calla	send_code_a3

	movi	fl_coinpage,a11
	create	pid_fx,boonpal_stuff	; flash letters
	rets

fl_coinpage
	.word	bpal_flash1,4
	.word	>ffff
	.word	rgb_blue
	.word	end_stuff

forden_peek
	move	@curback,a0,w
	cmpi	9,a0
	jaeq	sucide

	move	@tick,a0,w
	move	a0,@toasty,w		; look at our stop watch now !!

	movi	pid_forden,a0
	move	a0,*a13(procid),w
	movi	forden,a5
	calla	gso_dmawnz_ns
	movi	>00b00170,a4
	calla	set_xy_coordinates
	movi	100,a0
	move	a0,*a8(ozpos),w
	calla	insobja8

	movi	->80000,a11
	move	a11,*a8(oxvel),l
	movk	6,a10
ford3	sleep	1
	dsj	a10,ford3

	calla	stop_a8
	tsound2	>2f

	sleep	>20
	neg	a11
	move	a11,*a8(oxvel),l

	movi	>10,a10
ford5	sleep	1
	dsj	a10,ford5

	move	a8,a0
	calla	delobjp
	die


bridge_list_fixed
	move	@worldtly+16,a6,w

blf5	move	*a0,a8,l
	jreq	olns9

	move	*a8(oxpos),a0,w
	sub	a5,a0
	move	a0,*a8(oxpos),w
	move	*a8(oypos),a0,w
	sub	a6,a0
	move	a0,*a8(oypos),w
	calla	set_noscroll		; sky don't scroll

	move	a8,a0
	jruc	blf5

olns9	rets

****************************************************************************

spike_the_ceiling
	push	a8
	calla	dont_show_scores
	movi	dlists_ceiling,a0
	move	a0,@dlists,l

	move	@worldtlx2+16,a14,w	; a14 = where we are
	subi	70,a14
	movi	>1eb-70-70,a1		; first roof tile spot
stc4	addi	70,a1
	cmp	a14,a1
	jrlo	stc4	

	movk	7,a9
stc5	callr	one_roof_tile
	addi	70,a1
	dsjs	a9,stc5

	pull	a8
	rets

one_roof_tile
	push	a1
	movi	spikeroof2,a5
	calla	gso_dmawnz
	move	@ceiling_y,a0,w
	subi	>5a,a0
	pull	a1

	move	a0,a6
	move	a1,a7

	move	a1,*a8(oxpos),w
	move	a0,*a8(oypos),w
	move	a8,a0
	movi	baklst1,b4
	calla	insobj_v

	movi	spikes,a5
	calla	gso_dmawnz
	move	a6,a0
	addi	>00,a0
	move	a0,*a8(oypos),w
	move	a7,a1
	move	a1,*a8(oxpos),w

	movi	50,a0
	move	a0,*a8(ozpos),w
	jauc	insobja8


ceiling_scroll
	calla	stop_scrolling
	clr	a0
	move	a0,@scrolly,l
*
* up we go !!!
*
cscr3	sleep	1
	movi	->30000,a0
	move	a0,@scrolly,l
	move	@worldtly+16,a1,w
	move	@ceiling_y,a0,w
	sub	a0,a1
	abs	a1
	cmpi	>40,a1
	jrlo	cscr3

	clr	a0
	move	a0,@scrolly,l
	jauc	wait_forever


****************************************************************************

pit_scroll
	calla	stop_scrolling
	clr	a0
	move	a0,@scrolly,l

	movi	baklst3,a0
	move	@worldtlx3+16,a5,w
	callr	bridge_list_fixed
	movi	baklst4,a0
	move	@worldtlx4+16,a5,w
	callr	bridge_list_fixed
	movi	baklst5,a0
	move	@worldtlx5+16,a5,w
	callr	bridge_list_fixed
	movi	baklst6,a0
	move	@worldtlx6+16,a5,w
	callr	bridge_list_fixed
	movi	baklst7,a0
	move	@worldtlx7+16,a5,w
	callr	bridge_list_fixed
	movi	baklst8,a0
	move	@worldtlx8+16,a5,w
	callr	bridge_list_fixed

	movi	skip_bakmod,a0
	move	a0,@bak3mods,l
	move	a0,@bak4mods,l
	move	a0,@bak5mods,l
	move	a0,@bak6mods,l
	move	a0,@bak7mods,l
	move	a0,@bak8mods,l		; dont update these lists !!

	clr	a1
	not	a1
	movi	pid_backg,a0
	calla	existp
	movk	1,a1
	move	a1,*a0(pa10),l		; background updater = every tick !!

	movi	>70,a10			; time before switching camera view

pits1	sleep	1
	dec	a10
	jreq	switch_camera_angle

	move	*a11(oxpos),a0,w
	move	@worldtlx+16,a1,w
	addi	scrrgt/2,a1

	movi	stop_scrolling,a5

	move	a0,a3
	sub	a1,a3
	abs	a3
	cmpi	6,a3
	jrlo	pits3			; just about centered ---> stop scroll

	cmp	a1,a0
	jrhi	pit_scroll_right
	jrlo	pit_scroll_left
pits3	call	a5

	move	*a11(oyvel),a6,l
	jrn	pits1			; heading up ---> dont scroll y

	move	*a11(oypos),a0,w
	move	@worldtly+16,a1,w
	sub	a1,a0
	cmpi	>60,a0
	jrlt	pits1

	move	a6,@scrolly,l		; follow him down da pit
	jruc	pits1


pit_scroll_right
	move	@right_edge,a3,w
	move	@worldtlx+16,a1,w
	cmp	a3,a1
	jrge	pit_stop_scroll		; too far right ----> no scroll

	move	@scrtab,b0,l
	movi	ss_20000,a5
	jruc	pits3


pit_scroll_left
	move	@left_edge,a2,w
	move	@worldtlx+16,a1,w
	cmp	a2,a1
	jrle	pit_stop_scroll		; too left right ----> no scroll

	move	@scrtab,b0,l
	movi	ss_20000_neg,a5
	jruc	pits3

pit_stop_scroll
	callr	stop_scrolling
	jruc	pits3


switch_camera_angle
	tsound	>d0			; poof sound

	move	*a11(ochar),*a13(p_store4),w
	move	*a11(oid),*a13(p_store5),w
	movi	>ffff,a0
	move	a0,@irqskye,w		; white

	clr	a1
	not	a1
	movi	pid_master,a0
	calla	existp			; a0 = master proc
	move	a0,a9
	movi	>8000,a1
	move	a1,*a9(procid),w	; temp "indestructable"
	calla	murder_myoinit_score	; kill all others
	movi	pid_master,a1
	move	a1,*a9(procid),w	; back to normal id

	calla	display_off
	sleep	5
 	calla	display_on
	jauc	falling_down_the_pit

*
* a8 = dude to follow
*
scroll_center
	clr	a0
	move	a0,@scrolly,l

	move	@ceiling_y,a0,w
	sll	16,a0
	move	a0,@worldtly,l

scrc3	callr	keep_centered_on_a8
	sleep	1
	jruc	scrc3

keep_centered_on_a8
	move	*a8(oxpos),a0,w
	move	@worldtlx+16,a1,w
	addi	scrrgt/2,a1

	movi	stop_scrolling,a5
	move	a0,a3
	sub	a1,a3
	abs	a3
	cmpi	6,a3
	jrlo	kcen3			; just about centered ---> stop scroll

	cmp	a1,a0
	jrhi	kcen_right
	jrlo	kcen_left
	jruc	kcen3

kcen_right
	move	@right_edge,a0,w
	move	@worldtlx+16,a1,w
	sub	a0,a1
	abs	a1
	cmpi	6,a1
	jrlo	kcen3			; too close to edge ---> stop scrolling

	move	@scrtab,b0,l
	movi	ss_20000,a5
	jruc	kcen3

kcen_left
	move	@left_edge,a0,w
	move	@worldtlx+16,a1,w
	sub	a0,a1
	abs	a1
	cmpi	6,a1
	jrlo	kcen3			; too close to edge ---> stop scrolling

	move	@scrtab,b0,l
	movi	ss_20000_neg,a5
kcen3	push	a8
	call	a5
	pull	a8
	rets

;**********************************************************************

r_fall_in_slime
	movi	pid_master,a0
	calla	existp
	jreq	fis3			; a0 = master proc
	move	*a0(pwake),a1,l
	cmpi	fatality_waiting,a1	; waiting for fatality ?
	jrne	fis3			; nope
	movi	>88,a2
	move	a2,*a0(pa11),l		; yes, wait a little longer

fis3	calla	center_around_me

	movk	1,a0
	calla	create_blood_proc
	movi	>001b001c,a1
	calla	randsnd			; either of these monster hit sounds

	calla	disturbing_scream	; ahhh !!!
	movi	>00060006,a11
	calla	shake_a11		; shake upon contact

	calla	get_my_dfe
	move	*a8(oflags),a4,w
	btst	b_fliph,a4
	jrne	fis4
     	move	a5,a6
fis4	cmpi	>130,a6
	jrhi	fis5			; normal fall

	move	*a13(p_ganiy),a0,w
	subi	>08,a0
	move	a0,*a13(p_ganiy),w	; adjust floor to the slime

	movi	->40000,a0		; a0 = initial x vel
	movi	>3a,a9
	movi	->c0000,a1		; a1 = initial y vel
	movi	>6000,a2		; a2 = gravity	
	movk	5,a3			; a3 = ani speed
	jsrp	flight
	jruc	fis6

fis5	move	*a13(p_ganiy),a0,w
	subi	>20,a0
	move	a0,*a13(p_ganiy),w	; adjust floor to the slime

	movi	>20000,a0		; a0 = initial x vel
	movi	->c0000,a1		; a1 = initial y vel
	movi	>6000,a2		; a2 = gravity	
	movk	5,a3			; a3 = ani speed
	movi	>0f,a9			; a9 = ani offset
	jsrp	flight

fis6	move	a8,a9
	movi	acidsplash1a,a5
	calla	gso_dmawnz
	move	a8,a0
	move	a9,a1
	calla	lineup_1pwm

	movk	20,a0
	move	a0,*a8(ozpos),w		; splash in front of dude
	movi	>b8,a0
	move	a0,*a8(oypos),w		; position splash at edge of world
	calla	insobja8
	create	pid_green_splash,green_splash_proc
	swap	a8,a9			; a8 = dude / a9 = splash

	move	*a8(oypos),a0,w
	addi	10,a0
	move	a0,*a8(oypos),w
	sleep	4

	move	a8,a0
	calla	set_inviso
	sleep	>50

	move	a8,a10
	movi	acidskel1,a5
	calla	gso_dmawnz
	move	*a10(oxpos),*a8(oxpos),w
	movi	>b0,a0
	move	a0,*a8(oypos),w
	calla	insobja8

	calla	get_my_dfe
	movi	>8000,a0
	cmp	a5,a6
	jrhs	falls4
      	neg	a0
falls4	move	a0,*a8(oxvel),l

	movi	-1,a0
	move	a0,@f_death,w			; count this as a fatality

	movi	a_slime_skel,a9
	movk	5,a0
	jsrp	framew

	tsound	>f6				; bubble sound
	addi	32,a9
	movk	5,a0
	jsrp	framew
	sleep	>20

	move	@switch,a0,l
	not	a0
	btst	1,a0
	jrne	falls6
	btst	9,a0
	jrne	falls6

falls3	movi	200,a0
	calla	randper
	jrnc	falls5
falls6	tsound	>f7				; oh maw
falls5	jauc	wait_forever


green_splash_proc
	tsound	>f5			; splash sound
	movi	a_green_splash,a9
	movk	4,a0
	jsrp	framew
	move	a8,a0
	calla	delobjp
	jauc	wait_forever

a_green_splash
	.long	acidsplash1a
	.long	acidsplash2a
	.long	acidsplash3
	.long	acidsplash4
	.long	acidsplash5
	.long	acidsplash6
	.long	acidsplash7
	.long	acidsplash8
	.long	0

a_slime_skel
	.long	acidskel1
	.long	acidskel2
	.long	acidskel3
	.long	acidskel4
	.long	acidskel5
	.long	0
	.long	acidskel6
	.long	acidskel7
	.long	acidskel8
	.long	acidskel9
	.long	acidskel10
	.long	acidskel11
	.long	0

;************************************************************************

	.end
