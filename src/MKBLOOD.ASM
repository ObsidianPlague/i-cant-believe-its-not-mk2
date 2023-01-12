**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: BLOOD !										*
* 											     *
*  copyright (c) 1993 Midway Manufacturing							*
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
	.include	mkblood.tbl
	.text


create_blood_proc
	push	a2
	move	@f_no_blood,a2,w
	jrne	cbp9						; blood is turned off
	movi	(blood_procs_end-blood_procs)/32,a2
	cmp	a2,a0
	jrhs	cbp9
	sll	5,a0
	addi	blood_procs,a0
	move	*a0,a7,l
	movi	pid_blood,a1
	calla	getprc
cbp9	pull	a2
	move	a0,a0
	rets

blood_procs
	.long	swipe_blood		; 0
	.long	upcutted_blood		; 1
	.long	face_blood_2		; 2
	.long	fan_blood		; 3
	.long	speared_blood		; 4
	.long	bit_in_half_blood	; 5
	.long	clap_blood		; 6
	.long	torso_ripped_blood	; 7
	.long	stabbed_blood		; 8
	.long	split_blood		; 9
	.long	decaped_blood		; a
	.long	fn2_db_blood		; b
	.long	shred_blood		; c
	.long	fatality_drip		; d
	.long	arm_blood		; e
	.long	arm_blood2		; f
	.long	stretch_blood		; 10
	.long	spike_drips		; 11
	.long	face_punch_blood	; 12
	.long	hat_blood		; 13
	.long	roundhouse_blood	; 14
blood_procs_end


speared_blood
	movk	8,a10
spbld5	callr	spear_spawn_drip
	sleep	2
	dsj	a10,spbld5
	die

;	clr	a0	 		; x vel range
;	clr 	a1			; x vel minimum
;	clr	a2
;	clr	a3
;	movi	>00200001,a4		; coordinate adjust
;	movk	5,a5			; ani speed
;	movi	a_guts,a9
;	jruc	spatter_blood_fly


spatter_blood_fly
	mmtm	sp,a0,a1,a2,a3,a4,a5,a9
	callr	get_jt_blood
	mmfm	sp,a0,a1,a2,a3,a4,a5,a9

	calla	randu


	movi	>fff00000,a0
	callr	lineup_with_a11_offset
	calla	insobja8

	movi	>12000,a0
	calla	randu
	neg	a0
	move	a0,*a8(oyvel),l		; upwards

	movi	>20000,a0
	calla	randu
	addi	>30000,a0
	neg	a0
	calla	set_proj_vel

	movi	a_bigger,a9
	movk	6,a0
	jsrp	framew
	jruc	blood_death


spear_spawn_drip
	movi	>50000,a0		; x vel range
	movi	>40000,a1		; x vel minimum
	movi	>10000,a2		; y vel range
	movi	>0000,a3		; y vel minimum
	movi	>00200001,a4		; coordinate adjust
	movi	>00040002,a5		; ani speed / drip table ani offset
	jruc	spawn_drip

;**************************************************

arm_blood
	movi	>23,a10
arm5	callr	arm_spawn_drip
	sleep	2
	dsj	a10,arm5
	die

arm_spawn_drip
	movi	arm_flow_lineups,a0
	calla	get_char_long
	move	a0,a4

	movi	>50000,a0		; x vel range
	movi	>40000,a1		; x vel minimum
	movi	>10000,a2		; y vel range
	movi	>0000,a3		; y vel minimum
	movi	>00040002,a5		; ani speed / drip table ani offset

	move	a8,a11
	jruc	spawn_drip

;xxx
arm_flow_lineups
	.long	>004d0010	; 0
	.long	>002d0010	; 1
	.long	>0030001a	; 2
	.long	>00300010	; 3

	.long	>0023000c	; 4
	.long	>0023000c	; 5
	.long	>00330020	; 6
	.long	>0048000a	; 7

	.long	>004d0028	; 8
	.long	>004d0028	; 9
	.long	>004d0028	; a
	.long	>00400030	; b

	.long	>004d0010
	.long	>004d0010
	.long	>004d0010
	.long	>004d0010

arm_blood2
	tsound	>c4			; blood spooge sound

	create	pid_blood,left_gusher

	movi	right_gush_lineups,a0
	callr	gush_lineup
	calla	flip_single
	jruc	gush3

left_gusher
	move	a8,a11
	movi	left_gush_lineups,a0
	callr	gush_lineup

gush3	calla	insobja8
	movi	a_gusher,a9
	movk	4,a0
	jsrp	framew
	jruc	blood_death


gush_lineup
	calla	get_char_long
	push	a0
	move	a8,a11
	callr	get_tg_blood
	pull	a0
	jruc	lineup_with_a11_offset


right_gush_lineups
	.long	>0027fff0	; 0
	.long	>0027ffed	; 1
	.long	>0027fff0	; 2
	.long	>0027ffe8	; 3

	.long	>0027fff0	; 4
	.long	>0027fff0	; 5
	.long	>0027ffec	; 6
	.long	>0027ffe6	; 7

	.long	>0027fff0	; 8
	.long	>0027fff0	; 9
	.long	>0027fff0	; 10
	.long	>0020fff0	; 11


left_gush_lineups
	.long	>00270013	; 0
	.long	>0027000b	; 1
	.long	>00270013	; 2
	.long	>0026000a	; 3

	.long	>0027000d	; 4
	.long	>0027000d	; 5
	.long	>0027000c	; 6
	.long	>002f0013	; 7

	.long	>00270013	; 8
	.long	>00270013	; 9
	.long	>00270013	; 10
	.long	>00210016	; 11


stretch_blood
	tsound	>c4			; blood spooge sound
	callr	get_tg_blood

	movi	-2,a0
	move	a0,*a8(ozpos),w		; behind everyone

	movi	>00180005,a0
	callr	lineup_with_a11_offset
	calla	insobja8
	movk	1,a0
	movi	a_speared_blood,a9
	jsrp	framew

	movi	>28000,a0
	calla	set_proj_vel		; shoot out a bit
	movi	>4000,a0
	move	a0,*a8(oyvel),l

	calla	frame_a9
	movi	never_ani,a0
	movi	>6000,a10
	jsrp	blood_fall
	tsound	>c4			; blood spooge sound
	movi	-2,a0
	move	a0,*a8(ozpos),w		; behind everyone

	sleep	>20
	movk	5,a0
	jsrp	framew
	jruc	blood_death


a_speared_blood
	.long	longblud1
	.long	longblud2
	.long	longblud3
	.long	longblud4
	.long	longblud5
	.long	longblud6
	.long	longblud7
	.long	longblud8
	.long	longblud9
	.long	longblud10
	.long	longblud11
	.long	0

	.long	longblud12
	.long	longblud13
	.long	longblud14
	.long	longblud15
	.long	longblud16
	.long	0



bit_in_half_blood
	movi	>20000,a0		; x vel range
	movi	>10000,a1		; x vel minimum
	movi	>50000,a2		; y vel range
	movi	>30000,a3		; y vel minimum
	movi	>00300001,a4		; coordinate adjust
	movi	>00040000,a5		; ani speed / drip table ani offset
	movk	10,a10
	calla	spawn_drip_a10		; a10 x 2 drips

	create	pid_blood,in_half_right
	callr	get_tg_blood
	movi	>00280005,a0
	callr	lineup_with_a11_offset
	calla	flip_single
	jruc	half3

in_half_right
	callr	get_tg_blood
	movi	>00280000,a0
	callr	lineup_with_a11_offset

half3	calla	insobja8
	movi	a_decap_spray,a9
	movk	3,a0
	jsrp	framew
	jruc	blood_death

;****************************************************************************

;split_blood2
;	movk	4,a10
;	movi	>004c0000,a9
;	jruc	spbld3

split_blood
	movk	4,a10
	clr	a9
spbld3	addi	>000c0000,a9		; next splash down a bit
	create	pid_blood,one_split_splash
	sleep	4
	dsj	a10,spbld3

one_split_splash
	move	a8,a11
	movi	>20000,a0		; x vel range
	movi	>10000,a1		; x vel minimum
	movi	>50000,a2		; y vel range
	movi	>30000,a3		; y vel minimum
	move	a9,a4
	movi	>00040000,a5		; ani speed / drip table ani offset
	movk	4,a10
	calla	spawn_drip_a10		; do 6 drips for uppercut

	create	pid_blood,split_right
	callr	get_tg_blood

split_left_enter
	movi	>00180005,a0
	add	a9,a0
	callr	lineup_with_a11_offset
	calla	flip_single
	jruc	split_blood_enter

split_right
	callr	get_tg_blood
	movi	>00180000,a0
	add	a9,a0
	callr	lineup_with_a11_offset

split_blood_enter
	calla	insobja8
	movi	a_decap_spray,a9
	movk	3,a0
	jsrp	framew
	jruc	blood_death

;**************************************************************************

upcutted_blood
	move	a8,a11

	movi	>20000,a0		; x vel range
	movi	>10000,a1		; x vel minimum
	movi	>50000,a2		; y vel range
	movi	>30000,a3		; y vel minimum
	movi	>00010001,a4		; coordinate adjust
	movi	>00040000,a5		; ani speed / drip table ani offset
	movk	3,a10
	calla	spawn_drip_a10		; do 6 drips for uppercut

	create	pid_blood,upcut_right
	callr	get_tg_blood
	movi	>00180005,a0
	callr	lineup_with_a11_offset
	calla	flip_single
	jruc	upcb3

upcut_right
	callr	get_tg_blood
	movi	>00180000,a0
	callr	lineup_with_a11_offset

upcb3	calla	insobja8
	movi	a_decap_spray,a9
	movk	3,a0
	jsrp	framew
	jruc	blood_death

**************************************************************************

roundhouse_blood
	move	a8,a11

	movi	>20000,a0		; x vel range
	movi	>10000,a1		; x vel minimum
	movi	>50000,a2		; y vel range
	movi	>30000,a3		; y vel minimum
	movi	>0000fff0,a4		; coordinate adjust
	movi	>00040000,a5		; ani speed / drip table ani offset
	movk	3,a10
	calla	spawn_drip_a10		; do 6 drips for uppercut

	create	pid_blood,rhouse_right
	callr	get_tg_blood
	movi	>0018fff5,a0
	callr	lineup_with_a11_offset
	calla	flip_single
	jruc	rhb3

rhouse_right
	callr	get_tg_blood
	movi	>0018fff0,a0
	callr	lineup_with_a11_offset

rhb3	calla	insobja8
	movi	a_decap_spray,a9
	movk	3,a0
	jsrp	framew
	jruc	blood_death


**************************************************************************
*											     *
*  face_blood_2 - Hit in the face HARD blood					     *
*											     *
**************************************************************************
face_blood_2
	move	a8,a11

	movk	4,a6
facb3	create	pid_blood,face_blood
	dsj	a6,facb3

	movi	>20000,a0		; x vel range
	movi	>30000,a1		; x vel minimum
	movi	>40000,a2		; y vel range
	movi	>30000,a3		; y vel minimum
	movi	>00010001,a4		; coordinate adjust
	movi	>00060001,a5		; ani speed / drip table ani offset
	callr	spawn_drip_neg
	callr	spawn_drip_neg
	callr	spawn_drip_neg
	callr	spawn_drip_neg
	die


face_blood
	callr	get_jt_blood

	movi	>fff00000,a0
	callr	lineup_with_a11_offset
	calla	insobja8

	movi	>12000,a0
	calla	randu
	neg	a0
	move	a0,*a8(oyvel),l		; upwards

	movi	>20000,a0
	calla	randu
	addi	>30000,a0
	neg	a0
	calla	set_proj_vel

	movi	a_bigger,a9
	movk	6,a0
	jsrp	framew
	jruc	blood_death

**************************************************************************
*											     *
*  spawn_drip - Spawn a drip of blood given				     	*
* 											     *
*  a0 = x vel range									     *
*  a1 = x vel minimum									     *
*  a2 = y vel range									     *
*  a3 = y vel minimum									     *
*  a4 = y:x coordinate adjust									*
*  a5 = animation to use										*
*											     *
**************************************************************************
spawn_drip_a10
	callr	spawn_drip
	callr	spawn_drip_neg
	dsj	a10,spawn_drip_a10
	rets

spawn_drip_neg
	mmtm	sp,a0,a1,a2,a3,a4,a5
	mmtm	sp,a0,a1
	movi	tobias_drip_neg,a7
	jruc	spawnd3

spawn_drip
	mmtm	sp,a0,a1,a2,a3,a4,a5
	mmtm	sp,a0,a1
	movi	tobias_drip,a7

spawnd3	movi	pid_blood,a1
	calla	getprc
	move	a0,a6			; a6 = blood proc
	mmfm	sp,a0,a1

	move	a0,*a6(p_store1),l
	move	a1,*a6(p_store2),l
	move	a2,*a6(p_store3),l
	move	a3,*a6(p_store4),l	; pass velocity info to proc
	move	a4,*a6(p_store5),l
	move	a5,*a6(p_store6),l

	mmfm	sp,a0,a1,a2,a3,a4,a5
	rets

tobias_drip_neg
	callr	tdrip_getobj
	neg	a0
	calla	set_proj_vel
	jruc	tdrip2

tobias_drip
	callr	tdrip_getobj
	calla	set_proj_vel
	calla	flip_single

tdrip2	calla	insobja8
	move	*a13(p_store6),a9,l
	move	a9,a0
	srl	16,a0
	zext	a9,w
	sll	5,a9
	addi	drip_ani_table,a9
	move	*a9,a9,l

	movi	>4000,a10
	jruc	drip_fall_2


tdrip_getobj
;	callr	get_jt_blood
	callr	get_tg_blood

	move	*a13(p_store5),a0,l
	callr	lineup_with_a11_offset

	move	*a13(p_store3),a0,l
	calla	randu
	move	*a13(p_store4),a1,l
	add	a1,a0
	neg	a0
	move	a0,*a8(oyvel),l		; head upwards

	move	*a13(p_store1),a0,l
	calla	randu
	move	*a13(p_store2),a1,l
	add	a1,a0
	rets


drip_ani_table
	.long	a_rotate_12
	.long	a_rotate_standard
	.long	a_rotate_9
	.long	a_rotate_7

a_rotate_12
	.long	bludglob1
	.long	bludglob2
	.long	bludglob3

a_rotate_standard
	.long	bludglob4
	.long	bludglob5

a_rotate_9
	.long	bludglob6
	.long	bludglob7
	.long	bludglob8

a_rotate_7
	.long	bludglob9
	.long	bludglob10
	.long	bludglob11
	.long	bludglob12
	.long	0

;	.long	ani_jump,a_drip_splat

**************************************************************************
*											     *
*  clap_blood - Do the blood for JAX clap fatatlity				     *
* 											     *
*  Input: a8 = Jax obj									     *
*											     *
**************************************************************************
clap_blood
	move	a8,a11
	movi	>00100050,a10
	create	pid_blood,guts_proc
	create	pid_blood,gutsf_proc

	create	pid_blood,chunks_proc
	movi	>00100050,a10
	movk	5,a9
clapb4	create	pid_blood,clap_drip_proc
	sleep	2
	dsjs	a9,clapb4

	sleep	7
	movi	>00100050,a10
	create	pid_blood,guts_proc
	create	pid_blood,gutsf_proc

	die

*
*  a8 = obj to lineup with
* a10 = y:x offset
*
gutsf_proc
	callr	get_jt_blood
	move	a10,a0
	callr	lineup_with_a11_offset
	callr	local_flip_single
	jruc	guts1

guts_proc
	callr	get_jt_blood
	move	a10,a0
	callr	lineup_with_a11_offset

guts1	calla	insobja8
	movi	a_guts,a9
	movk	4,a0
	jsrp	framew
	jruc	blood_death

get_blood_lineup_a11
	move	a8,a11
	callr	get_jt_blood		; a8 = blood obj
	move	a11,a1
	move	a8,a0
	jauc	lineup_1pwm		; start with same coordinates as dude

a_guts	.long	GUTS1
	.long	GUTS2
	.long	GUTS3
	.long	GUTS4
	.long	GUTS5
	.long	GUTS6
	.long	GUTS7
	.long	0

clap_drip_proc
	callr	get_jt_blood
	move	a10,a0
	callr	lineup_with_a11_offset

	movi	>40000,a0
	calla	randu
	addi	>20000,a0
	neg	a0
	calla	set_proj_vel
	calla	insobja8

	clr	a11
	jruc	drip_fall

chunks_proc
	movk	8,a5
chk4	create	pid_blood,chunk_grav
	dsjs	a5,chk4

	movk	8,a8
chk5	movi	>40000,a0
	calla	randu
	addi	>30000,a0
	move	a0,a10			; a10 = x vel
	movi	>40000,a0
	calla	randu
	addi	>30000,a0
	move	a0,a9			; a9 = y vel
	create	pid_blood,chunk_pow1
	create	pid_blood,chunk_pow2
	create	pid_blood,chunk_pow3
	create	pid_blood,chunk_pow4
	dsj	a8,chk5

	die


chunk_pow2
	neg	a9
	jruc	chunk_pow3

chunk_pow1
	neg	a9

chunk_pow4
	neg	a10

chunk_pow3
	callr	get_clap_chunk

	move	a10,*a8(oxvel),l
	move	a9,*a8(oyvel),l

	movk	3,a0
	calla	randu
	inc	a0
	calla	init_anirate
	movi	a_bparts,a9

pflt5	sleep	1
	calla	next_anirate
	calla	scrtst
	jreq	pflt5
	jruc	blood_death

;********************************************************************

chunk_grav
	callr	get_clap_chunk

	movi	>40000,a0
	calla	randu
	addi	>30000,a0
	neg	a0
	move	a0,*a8(oyvel),l
	movi	>40000,a0
	calla	srand
	move	a0,*a8(oxvel),l
	move	a0,*a8(oslink),l	; remember x vel

	movk	4,a0
	calla	randu
	addk	2,a0			; random ani speed
	movi	a_bparts,a9
	movi	>4000,a10
	jsrp	blood_fall
	callr	random_splish_sound
*
* chunk bounce
*
	movi	->30000,a0
	jsrp	chunk_bounce
	movi	->20000,a0
	jsrp	chunk_bounce
	die

chunk_bounce
	move	a0,*a8(oyvel),l
	move	*a8(oslink),a0,l
	sra	1,a0
	move	a0,*a8(oxvel),l		; 1/2 x vel

;	movk	4,a0
;	calla	randu
;	addk	2,a0			; random ani speed
	movk	3,a0

	movi	>4000,a10
	jsrp	blood_fall
	retp

;********************************************************************

get_clap_chunk
	movi	BPARTS1,a5
	calla	gso_dmawnz
	movi	>00080058,a0
	callr	lineup_with_a11_offset
	jauc	insobja8
	
;********************************************************************

a_bparts
	.long	BPARTS1
	.long	BPARTS2
	.long	BPARTS3
	.long	BPARTS4
	.long	BPARTS5
	.long	BPARTS6

j_chunk
	.long	BPARTS7
	.long	BPARTS8
	.long	BPARTS9
	.long	BPARTS10
	.long	BPARTS11
	.long	BPARTS12
	.long	BPARTS13
	.long	BPARTS14
	.long	BPARTS15
	.long	BPARTS16
	.long	BPARTS17
	.long	BPARTS18
	.long	ani_jump,j_chunk

;*************************************************************************

fn2_db_blood
	create	pid_blood,one_fn2_drop
	sleep	1
	create	pid_blood,one_fn2_drop
	sleep	1
	create	pid_blood,one_fn2_drop
	sleep	1
	move	@f_death,a0,w
	jrnn	fn2_db_blood

	die


one_fn2_drop
	move	a8,a11
	callr	get_jt_blood

	movi	>30,a0
	calla	randu
	addi	>40,a0
	move	a0,a1
	clr	a0
	callr	a11_blood_lineup

	movi	>20000,a0
	calla	randu
	addi	>30000,a0
	neg	a0
	move	a0,*a8(oyvel),l

	movi	>20000,a0
	calla	randu
	addi	>20000,a0
	calla	set_proj_vel

	calla	insobja8
	movk	1,a11
	jruc	drip_fall


;************************************************************************

fan_blood
	movk	17,a10
fanb3	create	pid_blood,one_fan_drop
	sleep	1
	create	pid_blood,one_fan_drop
	sleep	1
	create	pid_blood,one_fan_drop
	sleep	1
	dsj	a10,fanb3
	die


one_fan_drop
	move	a8,a11

	callr	get_jt_blood
	movi	>20,a0
	movi	>30,a1
	callr	a11_blood_lineup

	movi	>20000,a0
	calla	randu
	addi	>30000,a0
	neg	a0
	move	a0,*a8(oyvel),l

	movi	>20000,a0
	calla	randu
	addi	>20000,a0
	neg	a0
	calla	set_proj_vel
	calla	insobja8
	movk	1,a11
	jruc	drip_fall

**************************************************************************

face_punch_blood
	move	a8,a11

	move	@rand,a0,l
	jrn	face3

	movi	>00000,a0		; x vel range
	movi	>30000,a1		; x vel minimum
	movi	>20000,a2		; y vel range
	movi	>20000,a3		; y vel minimum
	movi	>0010fff0,a4		; coordinate adjust
	movi	>00040002,a5		; ani speed / drip table ani offset
	callr	spawn_drip_neg

face3	callr	get_tg_blood

	move	a8,a0
	move	a11,a1
	calla	lineup_1pwm
	calla	flip_single

	move	*a11(ochar),a0,w
	sll	5,a0
	addi	face_blood_adjustments,a0
	move	*a0,a0,l
	move	a0,a1
	zext	a0,w
	srl	16,a1
	calla	multi_adjust_xy

	movi	->8000,a0
	move	a0,*a8(oyvel),l

	movi	>10000,a0
	calla	set_proj_vel

	calla	insobja8

	movi	a_face_blood,a9
	movk	3,a0
	jsrp	framew
	jruc	blood_death



face_blood_adjustments
	.long	>00100008
	.long	>00100008
	.long	>0015000c
	.long	>00100008

	.long	>00100008
	.long	>00100008
	.long	>00100008
	.long	>00100008

	.long	>00100008
	.long	>00100008
	.long	>00100008
	.long	>00100008

	.long	>00100008
	.long	>00100008
	.long	>00100008
	.long	>00100008

a_face_blood
	.long	SPLAT1
	.long	SPLAT2
	.long	SPLAT3
	.long	SPLAT4
	.long	SPLAT5
	.long	SPLAT6
	.long	SPLAT7
	.long	0

**************************************************************************

spike_drip_spots
	.word	>10
	.word	>18
	.word	->28
	.word	>30
	.word	->18
	.word	>38
	.word	>08

	.word	->10
	.word	->30
	.word	>28
	.word	>08
	.word	0
	

spike_drips
	sleep	>40

	movi	spike_drip_spots,a10
spdr2	move	*a10+,a6,w
	jreq	spdr4
	create	pid_blood,one_spike_drop
	move	a6,*a0(pa10),l
	sleep	10
	jruc	spdr2
spdr4	die


one_spike_drop
      	movi	STAB1,a5
	calla	gso_dmawnz

	move	*a11(oypos),a0,w
	addi	>88,a0
	move	a0,*a8(oypos),w
	move	*a11(oxpos),a2,w
	add	a10,a2
	move	a2,*a8(oxpos),w

	calla	insobja8		; put on list #1

	movi	a_fatality_drip,a9
	movi	a_rotate_7,a9
	movk	4,a0
	jsrp	framew

	move	@ground_y,a1,w
	movk	7,a0
	calla	randu
	add	a0,a1
	move	a1,*a13(p_ganiy),w

	movi	never_ani,a0
	movi	>30000,a1
	clr	a6
	movi	>3000,a10
	jsrp	gravity_ani		; fall to ground

	callr	random_splish_sound

	movi	-1,a0
	move	a0,*a8(ozval),l

	movi	a_drip,a9
	calla	find_part2
	movk	6,a0
	jsrp	framew
	die				; leave puddle out there !

**************************************************************************
*											     *
*  fatality_drip - Do the drip,drip FATALITY reveal effect		     *
*											     *
**************************************************************************
fatality_drip
	tsound2	>29	   		; fatality drip sound

	create	pid_blood,fatal_reveal
	sleep	30

	move	@f_pit_fall,a0,w
	jrne	fdrip9

	movi	drip_table,a9
fdrip3	move	*a9+,a11,w
	jreq	fdrip9
	addi	>00660000,a11
	create	pid_blood,fatal_drip
	move	*a9+,a0,w
	calla	prcslp
	jruc	fdrip3

fdrip9	die


drip_table
	.word	>b9,8
	.word	>ab,12
	.word	>ce,8
	.word	>7e,12
;	.word	>8c,8
	.word	>9c,12
	.word	>ab,8
	.word	>b9,8
	.word	>d5,8
	.word	0,0
	

fatal_reveal
	movi	FATALITY2,a5
	calla	gso_dmawnz_ns

	movi	oid_blood,a0
	move	a0,*a8(oid),w		; fatality oid = blood

	clr	a0
	move	a0,*a8(ozpos),w
	movi	>005000ad,a4
	calla	set_xy_coordinates

	calla	insobj2a8		; put on list #1
	movi	a_fatality,a9
	movk	6,a0
	jsrp	framew
	die


fatal_drip
	movi	FATALDRIP1,a5
	calla	gso_dmawnz_ns

	move	a11,a4
	calla	set_xy_coordinates
	calla	insobj2a8		; put on list #1
;	calla	insobja8		; put on list #1

	movi	a_fatality_drip,a9
	movk	4,a0
	jsrp	framew

	move	@ground_y,a1,w
	movk	7,a0
	calla	randu
	add	a0,a1
	move	a1,*a13(p_ganiy),w

	movi	never_ani,a0
	movi	>30000,a1
	clr	a6
	movi	>3000,a10
	jsrp	gravity_ani		; fall to ground

	callr	random_splish_sound

	movi	-1,a0
	move	a0,*a8(ozval),l

	movi	a_drip,a9
	calla	find_part2
	movk	6,a0
	jsrp	framew
	die				; leave puddle out there !

a_fatality
	.long	FATALITY2
	.long	FATALITY4
	.long	FATALITY6
	.long	FATALITY8
	.long	FATALITY10
	.long	FATALITY12
	.long	FATALITY14

j_floop	.long	FATALOOP1
	.long	FATALOOP3
	.long	FATALOOP5
	.long	FATALOOP7
	.long	FATALOOP9
	.long	FATALOOP11
	.long	FATALOOP13
	.long	ani_jump,j_floop


a_fatality_drip
	.long	FATALDRIP1
	.long	FATALDRIP3
	.long	FATALDRIP4
	.long	FATALDRIP5
	.long	FATALDRIP6
	.long	0
	.long	FATALDRIP7
	.long	DRIPMAIN
	.long	0

;************************************************************************

torso_ripped_blood
	create	pid_blood,torso_splash_l
	create	pid_blood,torso_splash_r
	clr	a0				; x adjust
	movi	>28,a1
	callr	get_splash
	movi	front_z+1,a0
	move	a0,*a8(ozval),l

	jruc	blob_entry


decaped_blood
	create	pid_blood,decap_splash_l
	create	pid_blood,decap_splash_r
*
* blob
*
	clr	a0			; x adjust
	movk	10,a1
	callr	get_splash

blob_entry

;	movi	front_z+1,a0
;	move	a0,*a8(ozval),l

	movi	a_decap_blob,a9
	movk	4,a0
	jsrp	framew

	move	@ground_y,a0,w
	inc	a0
	move	a0,*a13(p_ganiy),w
	movi	never_ani,a0
	movi	>30000,a1
	clr	a6
	movi	>6000,a10
	jsrp	gravity_ani		; fall to ground

	calla	stop_a8
	move	*a13(p_ganiy),a0,w
	move	a0,*a8(oypos),w
	clr	a0
	movi	->1a,a1
	calla	multi_adjust_xy

	tsound	>c4			; blood spooge sound

	movi	a_decap_blob,a9
	calla	find_part2
	movk	4,a0
	jsrp	framew
	die


decap_splash_l
	movk	1,a0			; x adjust
	movk	10,a1
	callr	get_splash
	callr	local_flip_single
	jruc	decs3

decap_splash_r
	movi	-1,a0			; x adjust
	movk	10,a1
	callr	get_splash
	movi	front_z+1,a0
	move	a0,*a8(ozval),l
	jruc	decs3

torso_splash_l
	movk	1,a0			; x adjust
	movi	>28,a1
	callr	get_splash
	callr	local_flip_single
	movi	front_z+1,a0
	move	a0,*a8(ozval),l
	jruc	decs3

torso_splash_r
	movi	-1,a0			; x adjust
	movi	>28,a1
	callr	get_splash
	jruc	decs3

decs3	movk	4,a0
	jsrp	framew
	jruc	blood_death

**************************************************************************
*											     *
*  get_splash - get a blood object for the splash animation		     *
* 											     *
*  Input: a0 = x adjust									     *
*         a1 = y adjust									     *
*        a11 = object to lineup with							     *
*											     *
**************************************************************************
get_splash
	mmtm	sp,a0,a1
	movi	SPURT1,a5
	calla	gso_dmawnz
	mmfm	sp,a0,a1
	callr	a11_blood_lineup
	calla	insobja8
 	movi	a_decap_spray,a9
	rets

***************************************************************************

stabbed_blood
	jsrp	stabbed_spirt
	sleep	>20
	jsrp	stabbed_spirt
	die

stabbed_spirt
	movi	>14,a10
stabb2	create	pid_blood,stabbed_stream
	sleep	2
	move	@rand,a0,l
	jrn	stabb3
	sleep	1
stabb3	dsj	a10,stabb2
	retp


stabbed_stream
	calla	get_jt_blood
	clr	a0
	movi	>38,a1
	callr	a11_blood_lineup

	movi	>30000,a0
	calla	randu
	addi	>30000,a0
	neg	a0
	move	a0,*a8(oyvel),l

	movi	>20000,a0
	calla	randu
	addi	>20000,a0
	neg	a0
	calla	set_proj_vel

	calla	insobja8

	movi	a_drip,a9
	movk	6,a0
	movi	>6000,a10
	movk	20,a11
	jruc	drip_fall_1


;*********************************************************************

hat_blood
	movk	7,a11
hatb0	create	pid_blood,hatb1
	create	pid_blood,hatb_drip
	sleep	1
	dsjs	a11,hatb0
	die


hatb1	move	a8,a11
	callr	get_jt_blood
	clr	a0
	movi	>20,a1
	callr	a11_blood_lineup

	movi	>10000,a0
	calla	srand
	move	a0,*a8(oyvel),l

	movi	>20000,a0
	calla	randu
	addi	>10000,a0
	calla	set_proj_vel

	calla	flip_single
	calla	insobja8

	movi	a_bigger,a9
	movk	6,a0
	jsrp	framew
	jruc	blood_death


hatb_drip
	move	a8,a11
	callr	get_jt_blood
	clr	a0
	movi	>50,a1
	callr	a11_blood_lineup

	movi	>60000,a0
	calla	randu
	addi	>20000,a0
	calla	set_proj_vel

	movi	>40000,a0
	calla	randu
	addi	>30000,a0
	neg	a0
	move	a0,*a8(oyvel),l

	calla	flip_single
	calla	insobja8
	
	movk	8,a0	 	; a0 = ani speed
	movi	a_drip,a9	; a9 = ani
	movi	>6000,a10	; a10 = grav
	jruc	blood_fall_splat_12_die

;*********************************************************************

swipe_blood
	movk	7,a11
swp0	create	pid_blood,swipeb1
	create	pid_blood,swipeb_drip
	sleep	1
	dsjs	a11,swp0

	die

swipeb1
	move	a8,a11
	callr	get_jt_blood
	clr	a0
	movi	>10,a1
	callr	a11_blood_lineup

	movi	>10000,a0
	calla	srand
	move	a0,*a8(oyvel),l

	movi	>20000,a0
	calla	randu
	addi	>10000,a0
	calla	set_proj_vel

	calla	insobja8

	movi	a_bigger,a9
	movk	6,a0
	jsrp	framew
	jruc	blood_death


swipeb_drip
	move	a8,a11
	callr	get_jt_blood
	clr	a0
	movi	>40,a1
	callr	a11_blood_lineup

	movi	>60000,a0
	calla	randu
	addi	>20000,a0
	calla	set_proj_vel

	movi	>40000,a0
	calla	randu
	addi	>30000,a0
	neg	a0
	move	a0,*a8(oyvel),l

	calla	insobja8
	
	movk	8,a0	 	; a0 = ani speed
	movi	a_drip,a9	; a9 = ani
	movi	>6000,a10	; a10 = grav

blood_fall_splat_12_die
	jsrp	blood_fall
	movi	a_drip,a9	; a9 = ab
	calla	find_part2

	callr	random_splish_sound

	movk	6,a0
	jsrp	framew
	jruc	blood_12_death

*************************************************************************

shred_blood
	move	a8,a11

shbld3	movk	6,a6
shbld4	create	pid_blood,shred_drip
	dsjs	a6,shbld4
	sleep	5
	move	*a10(p_action),a0,w
	cmpi	act_shred,a0
	jreq	shbld3
	die

shred_drip
	callr	get_jt_blood

	move	*a11(oypos),a1,w
	movi	>30,a0
	calla	randu
	addi	>30,a0
	add	a0,a1
	move	a1,*a8(oypos),w

	movi	>30,a1
	move	*a11(oflags),a4,w
	btst	b_fliph,a4
	jreq	shdr4
     	neg	a1			; flipped = other x direction
shdr4	move	*a11(oxpos),a0,w
	add	a1,a0
	move	a0,*a8(oxpos),w
*
* set velocities
*
	movi	>40000,a0
	calla	randu
	addi	>4000,a0
	move	a0,a6
	movi	300,a0
	calla	randper	 	; this game is just one big randper call
	jrnc	shdr5
	neg	a6
shdr5 

	move	a6,*a8(oxvel),l

;	movi	front_z+1,a0
;	move	a0,*a8(ozval),l


;	calla	insobj2a8
	calla	insobja8

	movi	>40000,a0
	calla	randu
	addi	>30000,a0
	neg	a0
	move	a0,*a8(oyvel),l

	movk	6,a0	 	; a0 = ani speed
	movi	a_drip,a9	; a9 = ab
	movi	a_goober,a9
	movi	>6000,a10	; a10 = grav
	jsrp	blood_fall

;	dsound	>29

	movi	back_z-1,a0
	move	a0,*a8(ozval),l

	movi	a_goober,a9
	calla	find_part2		; splat ani
	movk	6,a0
	jsrp	framew			; splat ani
	jruc	blood_12_death

**************************************************************************
*											     *
*  get_jt_blood										     *
* 											     *
*  Input: a11 = dude who blood is coming from					     *
*											     *
**************************************************************************
get_tg_blood
      	movi	STAB1,a5
	jruc	gbld3

get_jt_blood
	movi	BIGBLD1,a5
gbld3	calla	gso_dmawnz

	movi	front_z+1,a0
	move	a0,*a8(ozval),l

	move	*a11(oflags),a4,w
	move	*a8(oflags),a5,w
	andi	m_fliph,a4		; look only at flip of dude
	andni	m_fliph,a5		; clear flip bit of blood
	or	a4,a5
	move	a5,*a8(oflags),w	; match flip bit of dude
	rets


;*********************************************************************

a_drip
	.long	DRIP1
	.long	DRIP2
	.long	DRIP3
	.long	DRIP4
	.long	0
*
* splat on ground ani !
*
a_drip_splat
	.long	DRIP5
	.long	DRIP6
	.long	DRIP7
	.long	0


a_goober
	.long	GOOBER1
	.long	GOOBER2
	.long	GOOBER3
	.long	GOOBER4
	.long	GOOBER5
	.long	GOOBER6
	.long	GOOBER7
	.long	GOOBER8
	.long	GOOBER9
	.long	GOOBER10
	.long	0

	.long	GOOBER11
	.long	GOOBER12
	.long	GOOBER13
	.long	GOOBER14
	.long	0


a_bigger
	.long	BIGGERBLUD1
	.long	BIGGERBLUD1

	.long	BIGGERBLUD2
	.long	BIGGERBLUD2

	.long	BIGGERBLUD3
	.long	BIGGERBLUD4
	.long	BIGGERBLUD5
	.long	BIGGERBLUD6
	.long	0


a_decap_spray
	.long	SPRAY1
	.long	SPRAY2
	.long	SPRAY3
	.long	SPRAY4
	.long	SPRAY5
	.long	SPRAY6
	.long	SPRAY7
	.long	SPRAY8
	.long	SPRAY9
	.long	SPRAY10
	.long	SPRAY11
	.long	SPRAY12
	.long	SPRAY13
	.long	0

a_decap_blob
	.long	SPURT1
	.long	SPURT2
	.long	SPURT3
	.long	SPURT4
	.long	SPURT5
	.long	SPURT6
	.long	SPURT7
	.long	SPURT8
	.long	SPURT9
	.long	SPURT10
	.long	SPURT11
	.long	SPURT12
	.long	SPURT13
	.long	SPURT14
	.long	SPURT15
	.long	SPURTMAIN
	.long	0

	.long	SPLASH1
	.long	SPLASH2
	.long	SPLASH3
	.long	SPLASH4
	.long	SPLASH5
	.long	SPLASH6
	.long	SPLASH7
	.long	0


**************************************************************************
*											     *
*   BLOODY ROUTINES  BLOODY ROUTINES  BLOODY ROUTINES  BLOODY ROUTINES   *
*   BLOODY ROUTINES  BLOODY ROUTINES  BLOODY ROUTINES  BLOODY ROUTINES   *
*   BLOODY ROUTINES  BLOODY ROUTINES  BLOODY ROUTINES  BLOODY ROUTINES   *
*											     *
**************************************************************************

random_splish_sound
	movi	>00030073,a0	; [total # of entries, 1st entry]
	jauc	random_triple


**************************************************************************
*											     *
*  blood_fall										     *
* 											     *
*  Input: a0 = ani speed									     *
*         a9 = ani									     *
*        a10 = gravity									     *
*											     *
**************************************************************************
blood_fall
	calla	init_anirate
bldf3	move	*a8(oyvel),a0,l
	add	a10,a0
	move	a0,*a8(oyvel),l
	calla	next_anirate
	sleep	1

	move	*a8(oyvel),a0,l
	jrn	bldf3			; heading up = loop

	move	*a8(oypos),a0,w
	move	@ground_y,a1,w
	subi	>14,a1			; higher on screen
	cmp	a1,a0
	jrlt	bldf3

	calla	stop_a8
;	move	a1,*a8(oypos),w		; set on ground
	retp

*
* a11 = disappear flag: 1 = disappear  0 = stay on ground
*
drip_fall
	movk	6,a0	 	; a0 = ani speed
	movi	a_drip,a9	; a9 = ab
	movi	>6000,a10	; a10 = grav
*
* drip_fall_2 - supply your own input regs
*
drip_fall_2
	jsrp	blood_fall

	callr	random_splish_sound
	movi	back_z-1,a0
	move	a0,*a8(ozval),l

	movi	a_drip,a9	; a9 = ab
	calla	find_part2
	movk	6,a0
	jsrp	framew

	move	a11,a11
	jreq	local_sucide
	jruc	blood_12_death

blood_12_death
	sleep	12

blood_death
	move	a8,a0
	calla	delobjp

local_sucide
	die

**************************************************************************
*											     *
*   a0 = ani speed									     *
*   a9 = ani										     *
*  a10 = grav										     *
*  a11 = sleep time before deleting blood object				     *
*											     *
**************************************************************************
drip_fall_1
	jsrp	blood_fall
	movi	a_drip,a9	; a9 = ab
	calla	find_part2
	movk	6,a0
	jsrp	framew

	move	a11,a0
	calla	prcslp
	jruc	blood_death


*
* Lineup blood with a11 then adjust by:
*    a0 = x adjust
*    a1 = y adjust
*
a11_blood_lineup
	move	*a11(oxpos),*a8(oxpos),w
	move	*a11(oypos),*a8(oypos),w
	jauc	multi_adjust_xy

*
*  a0 = y:x adjust
* a11 = dude to lineup with
*
lineup_with_a11_offset
	move	a0,a7
	move	a11,a1
	move	a8,a0
	calla	lineup_1pwm		; start with same coordinates as dude
	move	a7,a0

adjust_blood_a0
	move	a0,a1
	sext	a0,w 			; a0 = x adjust
	sra	16,a1			; a1 = y adjust
	jauc	multi_adjust_xy


adjust_blood_by_a10
	move	a10,a0
	move	a10,a1
	sext	a0,w
	sra	16,a1
	move	*a8(oxpos),a2,w
	add	a0,a2
	move	a2,*a8(oxpos),w
	move	*a8(oypos),a2,w
	add	a1,a2
	move	a2,*a8(oypos),w
	rets

local_flip_single
	jauc	flip_single



a_gusher
	.long	GUSHER1
	.long	GUSHER2
	.long	GUSHER3
	.long	GUSHER4
	.long	GUSHER5
	.long	GUSHER6
	.long	GUSHER7
	.long	GUSHER8
	.long	GUSHER9
	.long	0


;*************************************************************************

	.end
