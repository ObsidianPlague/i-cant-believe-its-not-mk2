**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: special moves										*
* 											     *
*  copyright (c) 1993 midway manufacturing							*
*											     *
**************************************************************************
	.file	'moves.asm'
	.width	132
	.option	b,d,l,t
	.mnolist
*
* get the system stuff
*
	.include	dispequ.asm
	.include	sysequ.asm
	.include	macros.hdr
	.include	stringh.asm
	.include	mainequ.asm
	.include	imgtbl.glo
	.include	mkbaby.tbl
	.text


bb_check
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	bbno			; only during "finish him" mode

	movi	l_hp,a0
	callr	bb_get_tsl
	jrne	bbno
	movi	l_lp,a0
	callr	bb_get_tsl
	jrne	bbno

	movi	ochar_baby_combos,a0
	calla	get_char_long
	move	a0,a11
	clr	a0
	clr	a1
	calla	combo_look_lr
	jrnc	bbno	  		; no

	pull	a0
	movi	do_babality,a7
	jauc	restricted_xfer

bbno	rets


ochar_baby_combos
	.long	scom_hh_baby
	.long	scom_lk_baby
	.long	scom_jc_baby
	.long	scom_sa_baby
	.long	scom_fn_baby
	.long	scom_fn_baby
	.long	scom_st_baby
	.long	scom_rd_baby
	.long	scom_nj_baby
	.long	scom_nj_baby
	.long	scom_nj_baby
	.long	scom_jx_baby

;*************************************************************************
;*************************************************************************
;*************************************************************************
;*************************************************************************
;*************************************************************************
;*************************************************************************

do_babality
	calla	init_special

	create	pid_fx,delayed_baby_start
	move	*a13(p_otherguy),*a0(p_otherguy),l
	move	*a13(p_otherproc),*a0(p_otherproc),l
	move	*a13(p_ganiy),*a0(p_ganiy),w
	jauc	victory_animation


delayed_baby_start
	sleep	>10

	movk	1,a0				; fade = yes
	movk	bb_fatality,a1			; fatality #
	calla	init_death_blow

	sleep	>30

	movi	baby_xfer,a7
	calla	takeover_him

	sleep	>90				; time to switch to baby
	movk	1,a0
	move	a0,@f_death2,w			; flag: babality
	calla	death_blow_complete
	die


baby_xfer
	calla	nosounds
	sleep	1

	tsound	>68
	create	pid_fx,baby_flash
	create	pid_fx,baby_poof
	move	a8,*a0(pa10),l

	sleep	>0c

	move	a8,a10

	movi	baby_images,a0
	calla	get_char_long
	move	a0,a5
	calla	gso_dmawnz

	move	*a10(oxpos),a0,w
	move	*a8(osizex),a1,w
	sra	1,a1
	sub	a1,a0
	move	a0,*a8(oxpos),w

	move	@ground_y,a0,w
	move	*a8(osizey),a1,w
	sub	a1,a0
	move	a0,*a8(oypos),w
	calla	insobja8

	tsound2	>38
	sleep	>40
	tsound2	>39
	sleep	>40
	jauc	wait_forever


baby_flash
	jsrp	white_flash
	die

pf_change
	mess_mac rd15font,2,200,>58,bpal_hot_green*>10000,strcnrmos_scr,0
	.byte	"BABALITY !!",0
	.even

baby_images
	.long	HHBABE
	.long	LKBABE
	.long	CAGEBABE
	.long	BKBABE
	.long	KTBABE
	.long	MLBABE
	.long	STBABE
	.long	RDBABE
	.long	SZBABE
	.long	RPBABE
	.long	SCBABE
	.long	JXBABE

SZBABE	.word   28,44,0,0
	.long   054c7254H
	.word   06080H
	.long	SUB_P

RPBABE	.word   28,44,0,0
	.long   054c7254H
	.word   06080H
	.long	REP_P

SCBABE	.word   28,44,0,0
	.long   054c7254H
	.word   06080H
	.long	SCORP_P

;**************************************************************************

baby_poof
	move	a8,*a13(p_store4),l
	move	a8,a11
	movi	a_scorpion_flame,a9
	calla	gmo_proc
	move	a0,*a8(oslink),l

	movi	front_z+1,a0
	move	a0,*a8(ozval),l		; in front of player characters

	calla	insobja8
	move	a8,a9
	move	a8,a0
	move	a11,a8
	calla	match_ani_points	; line flame with scorpion
	move	a9,a8

	movi	->70,a0
	movi	>20,a1
	calla	multi_adjust_xy		; thanks for doing this tony (sarcasm)

	movi	a_scorpion_flame,a9
	calla	find_part2
*
* right side flame image
*
	move	a9,a14
	move	a8,a11			; a11 = left half
	movi	a_scorpion_flame,a9
	calla	gmo_proc
	move	a0,*a8(oslink),l

	movi	front_z+1,a0
	move	a0,*a8(ozval),l		; in front of player characters
	calla	insobja8
	move	a8,a9
	move	a8,a0
	move	a11,a8
	calla	match_ani_points	; line flame with left half
	move	a9,a8
	calla	flip_multi

	movi	->f4,a0
	clr	a1
	calla	multi_adjust_xy		; thanks for doing this tony (sarcasm)
	move	a14,a9
*
* animate left and right halves together
*
	movk	2,a10
	jsrp	double_flame_ani	; get to the skeleton xfer frame
	move	*a13(p_store4),a0,l

	move	*a0(ochar),a1,w
	cmpi	ft_smoke,a1
	jreq	bpoof3
	cmpi	ft_jade,a1
	jreq	bpoof3			; secret = no inviso

	calla	set_inviso

bpoof3	movk	5,a10
	jsrp	double_flame_ani	; get to the skeleton xfer frame

	move	*a8(oslink),a0,l
	calla	kill
	move	a8,a0
	calla	delobjp

	move	*a11(oslink),a0,l
	calla	kill
	move	a11,a0
	calla	delobjp			; rid of flame images
	die


bb_get_tsl
	move	*a8(oid),a1,w
	cmpi	pid_p1,a1	; player 1 ??
	jreq	tsl4
    	addk	16,a0		; no, point to player 2's tick ram
tsl4	move	*a0,a0,w	; when was the last time we did this ?
	rets

;********************************************************************

scom_hh_baby
	.word	>38	   	; time to do entire switch combo
	.word	sw_right
	.word	sw_right
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0

	.word	sw_left
	.word	sw_left
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0


scom_lk_baby
	.word	>38	   	; time to do entire switch combo
	.word	sw_left
	.word	sw_right
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0

	.word	sw_right
	.word	sw_left
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0

scom_jc_baby
	.word	>38	   	; time to do entire switch combo
	.word	sw_left
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0

	.word	sw_right
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0


scom_sa_baby
	.word	>38	   	; time to do entire switch combo
	.word	sw_right
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0

	.word	sw_left
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0


scom_fn_baby
	.word	>38	   	; time to do entire switch combo
	.word	sw_down
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0
	.word	0

	.word	sw_down
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0
	.word	0


scom_st_baby
	.word	>38	   	; time to do entire switch combo
	.word	sw_down
	.word	sw_right
	.word	sw_left
	.word	0
	.word	0
	.word	0

	.word	sw_down
	.word	sw_left
	.word	sw_right
	.word	0
	.word	0
	.word	0


scom_rd_baby
	.word	>38	   	; time to do entire switch combo
	.word	sw_up
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0
	.word	0

	.word	sw_up
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0
	.word	0

scom_nj_baby
	.word	>38	   	; time to do entire switch combo
	.word	sw_left
	.word	sw_left
	.word	sw_down
	.word	0
	.word	0
	.word	0

	.word	sw_right
	.word	sw_right
	.word	sw_down
	.word	0
	.word	0
	.word	0


scom_jx_baby
	.word	>38	   	; time to do entire switch combo
	.word	sw_up
	.word	sw_down
	.word	sw_up
	.word	sw_down
	.word	0
	.word	0

	.word	sw_up
	.word	sw_down
	.word	sw_up
	.word	sw_down
	.word	0
	.word	0

;************************************************************************

disco_ball_proc
	movi	discopole,a5
	calla	gso_dmawnz_ns
	movi	->60,a0
	move	a0,*a8(oypos),w
	calla	center_obj_x
	move	a8,a9
	calla	insobja8

	movi	discoball1,a5
	calla	gso_dmawnz_ns
	movi	>ffe000ac,a4
	calla	set_xy_coordinates
	calla	insobja8

	movi	>60000,a0
	move	a0,*a8(oyvel),l
	move	a0,*a9(oyvel),l
	sleep	15
	clr	a0
	move	a0,*a8(oyvel),l
	move	a0,*a9(oyvel),l		; slide ball down

disco3	movk	5,a0
	movi	a_disco_ball,a9
	jsrp	framew
	jruc	disco3

a_disco_ball
	.long	discoball1
	.long	discoball2
	.long	discoball3
	.long	discoball4
	.long	discoball5
	.long	discoball6
	.long	0

;***************************************************************************

	.end
