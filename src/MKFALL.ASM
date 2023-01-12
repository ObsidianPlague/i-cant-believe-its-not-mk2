**************************************************************************
*											     *
*  video game project:	mortal kombat 2							*
* 											     *
*  game software:    	ed boon									*
* 											     *
*  module: falling down the pit effect							*
* 											     *
*  copyright (c) 1993 Midway Manufacturing							*
*											     *
**************************************************************************
	.file	'mkamode.asm'
	.title	" <<< falling down the pit >>> "

	.width	132
	.option	b,d,l
	.mnolist
*
* get the system stuff
*
	.include	dispequ.asm		; display processor equates
	.include	sysequ.asm		; sys.inc and gsp.inc
	.include	macros.hdr		; macros
	.include	mainequ.asm
	.include	imgtbl.glo
	.include	mkfall.tbl


falling_down_the_pit
	movk	1,a0
	move	a0,@f_auto_erase,w
	clr	a0
	move	a0,@dlists,l

	move	*a13(p_store4),a0,w
	clr	a1
	clr	a2			; player = 1
	calla	make_player_obj		; a8 = player 1 object
	move	a8,*a13(p_otherguy),l
	movk	5,a0
	move	a0,*a8(ozpos),w

	movi	p1_ram,a0
	move	*a13(p_store5),a1,w
	cmpi	oid_p1,a1
	jreq	fdtp4
	movi	p2_ram,a0
fdtp4	move	a0,*a8(oimg),l

;	movi	>40,a9
;	calla	do_first_a9_frame

	movi	ochar_fall_coor,a0
	calla	get_char_long
	move	a0,a4
	calla	set_xy_coordinates
	calla	insobja8

	movi	q3,a7			; starting coordinates
	movi	bsx,a5
	movi	bsy,a9
	movi	baklst1,a10
	callr	make_a_quadrant

	movi	q2,a7			; starting coordinates
	movi	bsx,a5
	movi	-bsy,a9
	movi	baklst2,a10
	callr	make_a_quadrant

	movi	q1,a7			; starting coordinates
	movi	-bsx,a5
	movi	-bsy,a9
	movi	baklst3,a10
	callr	make_a_quadrant

	movi	q4,a7			; starting coordinates
	movi	-bsx,a5
	movi	bsy,a9
	movi	baklst4,a10
	callr	make_a_quadrant
*
* start the fall
*
	clr	a0
	move	a0,@debug1,w  			; table offset
	movk	5,a0
	move	a0,@irqskye,w			; we've got blue skies !!!
	clr	a0
	move	a0,@ground_y,w
	movi	next_fall_frame,a0
	move	a0,@call_every_tick,l	; start !

	movi	dlists_falling,a0
	move	a0,@dlists,l

	move	*a13(p_otherguy),a8,l
	movi	ochar_pit_falls,a0
	calla	get_char_long
	move	a0,a9
	movk	3,a0
	calla	init_anirate
	
fall3	sleep	1
	calla	next_anirate
	move	@call_every_tick,a0,l	; fall done yet ?
	jrne	fall3

	movi	ochar_pit_falls,a0
	calla	get_char_long
	move	a0,a9
	calla	find_part2
	calla	do_next_a9_frame

	tsound	>cf				; impact at bottom of pit
	movi	>ccccccce,a1
	calla	ochar_sound			; wham !!

	movi	>00050005,a11
	calla	shake_a11

	movi	pitcrack,a5
	calla	gso_dmawnz
	movi	>0040008a,a4
	calla	set_xy_coordinates
	clr	a0
	move	a0,*a8(ozpos),w
	calla	insobja8			; crack !!

	movi	blood_spots,a7
fall5	move	*a7+,a1,l
	jreq	fall6

	movi	pitblood1a,a5
	calla	gso_dmawnz
	calla	ani_flag
	move	*a7+,a4,l
	calla	set_xy_coordinates
	movk	1,a0
	move	a0,*a8(ozpos),w
	calla	insobja8
	jruc	fall5

fall6	movi	splat_spots,a7
fall4	move	*a7+,a1,l
	jreq	fall7
	movi	BLDSPLASH1,a5
	calla	gso_dmawnz
	move	a1,a4
	calla	set_xy_coordinates
	calla	insobja8
	jruc	fall4

fall7	calla	death_blow_complete
	sleep	>30

	movk	1,a0
	move	a0,@f_pit_fall,w		; flag: fallen down pit
	jauc	wait_forever


ochar_fall_coor
	.long	>003600c0
	.long	>004000c0
	.long	>004000c0
	.long	>004000c0

	.long	>003600c0
	.long	>004000c0
	.long	>002800c8
	.long	>003800c5

	.long	>004000c0
	.long	>004000c0
	.long	>004000c0
	.long	>004000c0



splat_spots
	.long	>00200090
	.long	>003000f0
	.long	>00400070
	.long	>00600080
	.long	>00900078
	.long	>00b00080

	.long	>002000e0
	.long	>004000f8
	.long	>006000e0
	.long	>009000f8
	.long	>00b00100

	.long	0

blood_spots
	.long	pitblood2a,>00380095
	.long	pitblood2b,>004700a5
	.long	pitblood2a,>00880095
	.long	pitblood2b,>009700a5
	.long	0


setup_clouds
	move	*a7+,a4,l
	jreq	suc9
	move	a4,a1
	movi	pitcloud,a5
	calla	gso_dmawnz_ns
	move	a1,a4
	calla	set_xy_coordinates
	calla	insobja8
	jruc	setup_clouds
suc9	rets

;************************************************************************

make_a_quadrant
	callr	make_a_row
	callr	make_a_row
	callr	make_a_row
	move	*a13(p_store7),a0,l	; save 1st obj of quad here
	clr	a1
	move	a1,*a0(oslink),l	; last row has no link
	rets


make_a_row
	move	@ofree,a0,l
	move	a0,*a13(p_store7),l	; save 1st obj of quad here
	move	a7,a11
	movk	4,a6			; a6 = column count

mar3	push	a5
	movi	PITFLOOR,a5
	calla	gso_dmawnz_ns
	clr	a5
	move	a5,*a8(oflags2),w	; flag: NOT end of row !!
	pull	a5

	move	a7,a4
	calla	set_xy_coordinates

	addxy	a5,a7			; moving along x axis
	move	a8,*a10(olink),l	; attach at the end of the list
	clr	a0
	move	a0,*a8(olink),l		; null the end of the list
	move	a8,a10			; a10 = end of list
	dsj	a6,mar3

	movk	1,a7
	move	a7,*a8(oflags2),w	; flag: end of row !!

	move	a11,a7			; restore origin
	addxy	a9,a7			; next row !!
	move	*a13(p_store7),a0,l	; 1st object of row
	move	@ofree,a1,l		; 1st object of next row
	move	a1,*a0(oslink),l	; linky
	rets

;************************************************************************

next_fall_frame
	move	@ground_y,a0,w
	move	a0,a1
	inc	a0
	move	a0,@ground_y,w

	sll	5,a1
	addi	fall_table,a1
;	addi	p1_state,a1
	move	*a1+,a0,w		; grab scale value to use
	jreq	fall_is_done
	move	*a1,a7,w		; a7 = size of box at this scale value
	move	a0,a2
	sll	16,a2
	or	a2,a0

	clr	a4			; a4 = previous object
	movi	q3,a5
	move	a7,a9
	move	a7,a11
	sll	16,a11
	movi	q3_origin,a10
	move	@baklst1,a1,l		; a1 = row #1
	callr	update_a_quad

	clr	a4			; a4 = previous object
	movi	q3,a5
	move	a7,a9
	move	a7,a11
	sll	16,a11
	neg	a11
	movi	q2_origin,a10
	move	@baklst2,a1,l		; a1 = row #1
	callr	update_a_quad

	clr	a4			; a4 = previous object
	movi	q3,a5
	move	a7,a9
	neg	a9
	movi	q1_origin,a10
	move	@baklst3,a1,l		; a1 = row #1
	callr	update_a_quad

	clr	a4			; a4 = previous object
	movi	q3,a5
	move	a7,a11
	sll	16,a11
	movi	q4_origin,a10
	move	@baklst4,a1,l		; a1 = row #1
	jruc	update_a_quad
	rets

fall_is_done
	move	a0,@call_every_tick,l	; stop
	rets



update_a_quad
	move	a1,a6			; save 1st object here
uaq3	move	a0,*a1(oscale),l

	move	a4,a4			; previous obj ?
	jrne	nff4			; yes

	jump	a10			; no, get to starting point

nff4	move	*a4(oxpos),a14,w
	add	a9,a14
	move	a14,*a1(oxpos),w
	move	*a4(oypos),*a1(oypos),w	; tile next to the last piece

nff5 	move	a1,a4				; new previous object
	move	*a1,a1,l
	move	*a4(oflags2),a14,w		; last of this row ??
	jreq	uaq3

	move	*a6(oslink),a1,l	; return: a1 = next row
	jreq	nff9

	clr	a4			; no previous
	add	a11,a5			; next row
	jruc	update_a_quad

nff9	rets


q4_origin
	move	a5,a3
	subxy	a7,a3
	move	a3,*a1(oxpos),w

	move	a5,a14
	sra	16,a14
	move	a14,*a1(oypos),w
	jruc	nff5

q3_origin
	move	a5,a14
	sra	16,a14
	move	a14,*a1(oypos),w
	move	a5,*a1(oxpos),w		; 1st obj ---> set coordinates at origin
	jruc	nff5

q2_origin
	move	a5,*a1(oxpos),w		; q2 ---> x stays the same
	move	a7,a14			; a14 = y
	sll	16,a14
	move	a5,a3
	subxy	a14,a3
	sra	16,a3
	move	a3,*a1(oypos),w
	jruc	nff5

q1_origin
	move	a7,a14			; a14 = y
	sll	16,a14
	move	a5,a3
	subxy	a14,a3
	sra	16,a3
	move	a3,*a1(oypos),w

	move	a5,a3
	subxy	a7,a3
	move	a3,*a1(oxpos),w
	jruc	nff5



dlists_falling
	.long	baklst4,worldtlx+16
	.long	baklst3,worldtlx+16
	.long	baklst2,worldtlx+16
	.long	baklst1,worldtlx+16
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0


bsx	.set	>80
bsy	.set	bsx*>10000
q3	.set	>10000*(scrbot/2)+scrrgt/2
q2	.set	q3-bsy
q1	.set	q3-bsy-bsx
q4	.set	q3-bsx


fall_table
	.word	004BDh, 0001Bh, 004BDh, 0001Bh, 004BDh, 0001Bh, 004BDh, 0001Bh
	.word	00492h, 0001Ch, 00469h, 0001Dh, 00444h, 0001Eh, 00444h, 0001Eh
	.word	00400h, 00020h, 003E0h, 00021h, 003C3h, 00022h, 003A8h, 00023h
	.word	00375h, 00025h, 00348h, 00027h, 0031Fh, 00029h, 0030Ch, 0002Ah
	.word	002E8h, 0002Ch, 002C8h, 0002Eh, 002AAh, 00030h, 0028Fh, 00032h
	.word	00276h, 00034h, 0025Eh, 00036h, 00249h, 00038h, 00234h, 0003Ah
	.word	00222h, 0003Ch, 00210h, 0003Eh, 00200h, 00040h, 001F0h, 00042h
	.word	001E1h, 00044h, 001D4h, 00046h, 001C7h, 00048h, 001BAh, 0004Ah
	.word	001AFh, 0004Ch, 001A4h, 0004Eh, 00199h, 00050h, 0018Fh, 00052h
	.word	00186h, 00054h, 0017Dh, 00056h, 00174h, 00058h, 0016Ch, 0005Ah
	.word	00164h, 0005Ch, 0015Ch, 0005Eh, 00155h, 00060h, 0014Eh, 00062h
	.word	00147h, 00064h, 00141h, 00066h, 0013Bh, 00068h, 00135h, 0006Ah
	.word	0012Fh, 0006Ch, 00129h, 0006Eh, 00124h, 00070h, 0011Fh, 00072h
	.word	0011Ah, 00074h, 00115h, 00076h, 00111h, 00078h, 0010Ch, 0007Ah
	.word	00108h, 0007Ch, 00104h, 0007Eh, 00000h, 00000h, 00000h, 00000h
	.word	00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h, 00000h

ochar_pit_falls
	.long	a_hh_fall
	.long	a_lk_fall
	.long	a_jc_fall
	.long	a_sa_fall

	.long	a_fn_fall
	.long	a_fn_fall
	.long	a_st_fall
	.long	a_rd_fall

	.long	a_nj_fall
	.long	a_nj_fall
	.long	a_nj_fall
	.long	a_jx_fall


a_hh_fall
	.long	TMPITFALL1
	.long	TMPITFALL2
	.long	TMPITFALL3
	.long	TMPITFALL4
	.long	TMPITFALL5
	.long	ani_jump,a_hh_fall
	.long	0
	.long	TMPITFALL6
	.long	0

TMPITFALL1
	.long	TMPITFALL1A,TMPITFALL1B,TMPITFALL1C,TMPITFALL1D
	.long	0
TMPITFALL2
	.long	TMPITFALL2A,TMPITFALL2B,TMPITFALL2C,TMPITFALL2D
	.long	TMPITFALL2E,0
TMPITFALL3
	.long	TMPITFALL3A,TMPITFALL3B,TMPITFALL3C,TMPITFALL3D
	.long	TMPITFALL3E,0
TMPITFALL4
	.long	TMPITFALL4A,TMPITFALL4B,TMPITFALL4C,TMPITFALL4D
	.long	TMPITFALL4E,TMPITFALL4F,0
TMPITFALL5
	.long	TMPITFALL5A,TMPITFALL5B,TMPITFALL5C,TMPITFALL5D
	.long	0
TMPITFALL6
	.long	TMPITFALL6A,TMPITFALL6B,TMPITFALL6C,TMPITFALL6D
	.long	0

;**********************************************************************

a_lk_fall
	.long	LKPITFALL1
	.long	LKPITFALL2
	.long	LKPITFALL3
	.long	LKPITFALL4
	.long	LKPITFALL5
	.long	ani_jump,a_lk_fall
	.long	0

	.long	LKPITFALL6
	.long	0


LKPITFALL1
	.long	LKPITFALL1A,LKPITFALL1B,LKPITFALL1C,LKPITFALL1D
	.long	LKPITFALL1E,0
LKPITFALL2
	.long	LKPITFALL2A,LKPITFALL2B,LKPITFALL2C,LKPITFALL2D
	.long	0
LKPITFALL3
	.long	LKPITFALL3A,LKPITFALL3B,LKPITFALL3C,0
LKPITFALL4
	.long	LKPITFALL4A,LKPITFALL4B,LKPITFALL4C,0
LKPITFALL5
	.long	LKPITFALL5A,LKPITFALL5B,LKPITFALL5C,0
LKPITFALL6
	.long	LKPITFALL6A,LKPITFALL6B,LKPITFALL6C,LKPITFALL6D
	.long	0

;*********************************************************************

a_jc_fall
	.long	JCPITFALL1
	.long	JCPITFALL2
	.long	JCPITFALL3
	.long	JCPITFALL4
	.long	JCPITFALL5
	.long	ani_jump,a_jc_fall
	.long	0

	.long	JCPITFALL6
	.long	0

JCPITFALL1
	.long	JCPITFALL1A,JCPITFALL1B,JCPITFALL1C,JCPITFALL1D
	.long	0
JCPITFALL2
	.long	JCPITFALL2A,JCPITFALL2B,JCPITFALL2C,JCPITFALL2D
	.long	JCPITFALL2E,0
JCPITFALL3
	.long	JCPITFALL3A,JCPITFALL3B,JCPITFALL3C,JCPITFALL3D
	.long	0
JCPITFALL4
	.long	JCPITFALL4A,JCPITFALL4B,JCPITFALL4C,0
JCPITFALL5
	.long	JCPITFALL5A,JCPITFALL5B,JCPITFALL5C,JCPITFALL5D
	.long	0
JCPITFALL6
	.long	JCPITFALL6A,JCPITFALL6B,JCPITFALL6C,JCPITFALL6D
	.long	0

;****************************************************************************

a_sa_fall
	.long	UGPITFALL1
	.long	UGPITFALL2
	.long	UGPITFALL3
	.long	UGPITFALL4
	.long	UGPITFALL5
	.long	ani_jump,a_sa_fall
	.long	0

	.long	UGPITFALL6
	.long	0


UGPITFALL1
	.long	UGPITFALL1A,UGPITFALL1B,UGPITFALL1C,UGPITFALL1D
	.long	0
UGPITFALL2
	.long	UGPITFALL2A,UGPITFALL2B,UGPITFALL2C,0
UGPITFALL3
	.long	UGPITFALL3A,UGPITFALL3B,UGPITFALL3C,UGPITFALL3D
	.long	0
UGPITFALL4
	.long	UGPITFALL4A,UGPITFALL4B,UGPITFALL4C,UGPITFALL4D
	.long	0
UGPITFALL5
	.long	UGPITFALL5A,UGPITFALL5B,UGPITFALL5C,UGPITFALL5D
	.long	0
UGPITFALL6
	.long	UGPITFALL6A,UGPITFALL6B,UGPITFALL6C,UGPITFALL6D
	.long	0

;****************************************************************************

a_fn_fall
	.long	KTPITFALL1
	.long	KTPITFALL2
	.long	KTPITFALL3
	.long	KTPITFALL4
	.long	KTPITFALL5
	.long	ani_jump,a_fn_fall
	.long	0

	.long	KTPITFALL6
	.long	0

KTPITFALL1
	.long	KTPITFALL1A,KTPITFALL1B,KTPITFALL1C,0
KTPITFALL2
	.long	KTPITFALL2A,KTPITFALL2B,KTPITFALL2C,0
KTPITFALL3
	.long	KTPITFALL3A,KTPITFALL3B,KTPITFALL3C,0
KTPITFALL4
	.long	KTPITFALL4A,KTPITFALL4B,KTPITFALL4C,0
KTPITFALL5
	.long	KTPITFALL5A,KTPITFALL5B,KTPITFALL5C,0
KTPITFALL6
	.long	KTPITFALL6A,KTPITFALL6B,KTPITFALL6C,KTPITFALL6D
	.long	0

;****************************************************************************

a_st_fall
	.long	STPITFALL1
	.long	STPITFALL2
	.long	STPITFALL3
	.long	STPITFALL4
	.long	STPITFALL5
	.long	ani_jump,a_st_fall
	.long	0
	.long	STPITFALL6
	.long	0

STPITFALL1
	.long	STPITFALL1A,STPITFALL1B,STPITFALL1C,0
STPITFALL2
	.long	STPITFALL2A,STPITFALL2B,STPITFALL2C,0
STPITFALL3
	.long	STPITFALL3A,STPITFALL3B,STPITFALL3C,STPITFALL3D
	.long	0
STPITFALL4
	.long	STPITFALL4A,STPITFALL4B,STPITFALL4C,0
STPITFALL5
	.long	STPITFALL5A,STPITFALL5B,0
STPITFALL6
	.long	STPITFALL6A,STPITFALL6B,STPITFALL6C,STPITFALL6D
	.long	0

;****************************************************************************

a_rd_fall
	.long	RNPITFALL1
	.long	RNPITFALL2
	.long	RNPITFALL3
	.long	RNPITFALL4
	.long	RNPITFALL5
	.long	ani_jump,a_rd_fall
	.long	0
	.long	RNPITFALL6
	.long	0

RNPITFALL1
	.long	RNPITFALL1A,RNPITFALL1B,RNPITFALL1C,0
RNPITFALL2
	.long	RNPITFALL2A,RNPITFALL2B,RNPITFALL2C,RNPITFALL2D
	.long	0
RNPITFALL3
	.long	RNPITFALL3A,RNPITFALL3B,RNPITFALL3C,0
RNPITFALL4
	.long	RNPITFALL4A,RNPITFALL4B,RNPITFALL4C,RNPITFALL4D
	.long	RNPITFALL4E,0
RNPITFALL5
	.long	RNPITFALL5A,RNPITFALL5B,RNPITFALL5C,RNPITFALL5D
	.long	0
RNPITFALL6
	.long	RNPITFALL6A,RNPITFALL6B,RNPITFALL6C,RNPITFALL6D
	.long	0

;****************************************************************************

a_nj_fall
	.long	NJFALLPIT1
	.long	NJFALLPIT2
	.long	NJFALLPIT3
	.long	NJFALLPIT4
	.long	NJFALLPIT5
	.long	ani_jump,a_nj_fall
	.long	0
	.long	NJFALLPIT6
	.long	0

NJFALLPIT1
	.long	NJFALLPIT1A,NJFALLPIT1B,NJFALLPIT1C,0
NJFALLPIT2
	.long	NJFALLPIT2A,NJFALLPIT2B,NJFALLPIT2C,0
NJFALLPIT3
	.long	NJFALLPIT3A,NJFALLPIT3B,NJFALLPIT3C,0
NJFALLPIT4
	.long	NJFALLPIT4A,NJFALLPIT4B,NJFALLPIT4C,0
NJFALLPIT5
	.long	NJFALLPIT5A,NJFALLPIT5B,NJFALLPIT5C,NJFALLPIT5D
	.long	0
NJFALLPIT6
	.long	NJFALLPIT6A,NJFALLPIT6B,NJFALLPIT6C,NJFALLPIT6D
	.long	0

;****************************************************************************

a_jx_fall
	.long	JXPITFALL1
	.long	JXPITFALL2
	.long	JXPITFALL3
	.long	JXPITFALL4
	.long	JXPITFALL5
	.long	ani_jump,a_jx_fall
	.long	0
	.long	JXPITFALL6
	.long	0

JXPITFALL1
	.long	JXPITFALL1A,JXPITFALL1B,JXPITFALL1C,JXPITFALL1D
	.long	0
JXPITFALL2
	.long	JXPITFALL2A,JXPITFALL2B,JXPITFALL2C,JXPITFALL2D
	.long	0
JXPITFALL3
	.long	JXPITFALL3A,JXPITFALL3B,JXPITFALL3C,0
JXPITFALL4
	.long	JXPITFALL4A,JXPITFALL4B,JXPITFALL4C,JXPITFALL4D
	.long	0
JXPITFALL5
	.long	JXPITFALL5A,JXPITFALL5B,JXPITFALL5C,JXPITFALL5D
	.long	0
JXPITFALL6
	.long	JXPITFALL6A,JXPITFALL6B,JXPITFALL6C,JXPITFALL6D
	.long	0

;****************************************************************************

	.end
