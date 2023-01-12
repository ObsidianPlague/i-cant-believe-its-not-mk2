**************************************************************************
*											     *
*  video game project:	mortal kombat 2							*
* 											     *
*  game software:    	ed boon								     *
* 											     *
*  module: mkdie.asm - special case death sequences					*
* 											     *
*  copyright (c) 1993 midway manufacturing							*
*											     *
**************************************************************************
	.file	'mkdie.asm'
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
	.include	mkfat1.tbl
	.include	mkfat2.tbl
	.include	mkchunks.tbl
	.include	mksuck.tbl
	.include	mkarms.tbl
	.include	mkrocks.tbl
	.text

;************************************************************************

r_pitched
	tsound	>55			; scorpion spear sound
	calla	rsnd_death_voice

	movi	>00050006,a0
	movk	2,a1
	move	a8,a10
	jsrp	shake_him_up

	movi	>39,a9
	calla	get_char_ani
	movk	6,a14
	calla	find_part_a14
	calla	do_next_a9_frame
	calla	change_to_bloody_pal
	calla	face_opponent

	jsrp	white_flash
	tsound	>d8			; sz shatter sound

	move	a8,a11
	movi	exp_burst,a6
	movi	>4000,a10		; a10 = gravity
	movi	bone_land,a0
	callr	explode
	movi	>00080008,a11
	calla	shake_a11
	jauc	wait_forever


r_body_suck
	movi	>00040004,a0
	movk	3,a1
	move	a8,a10
	jsrp	shake_him_up

	calla	match_me_with_him
	calla	flip_multi

	movi	sucked_in_anis,a0
	calla	get_char_long
	move	a0,a9
	movk	4,a0
	jsrp	mframew

	move	a8,a0
	calla	set_inviso		; I is gone...

	jauc	wait_forever


spit_bones
	move	a8,a11	      		; a11 = mileena obj

	movk	10,a10
spit3	create	pid_bones,spit_bone1
	sleep	2
	create	pid_bones,spit_bone2
	sleep	3
	create	pid_bones,spit_bone3
	sleep	1
	dsj	a10,spit3

	die


bone_init
	mmtm	sp,a0,a1
	move	*a9,a5,l
	calla	gso_dmawnz
	move	a8,a0
	move	a11,a1
	calla	lineup_1pwm    		; line up with her
	calla	flip_single
	mmfm	sp,a0,a1
	calla	multi_adjust_xy		; lineup at her nasty mouth
	jauc	insobja8


spit_bone1
	movi	>2a,a0
	movi	>0f,a1
	movi	a_spit_bone1,a9
	callr	bone_init
	jruc	bbone3


spit_bone2
	movi	>2a,a0
	movi	>0f,a1
	movi	a_spit_bone2,a9
	callr	bone_init
	jruc	bbone3


spit_bone3
	movi	>2a,a0
	movi	>10,a1
	movi	a_spit_bone2,a9
	callr	bone_init

	movk	2,a0
	jsrp	framew	       		; revealing part !
	jruc	bbone3


bbone3	movk	2,a0
	jsrp	framew	       		; revealing part !
	movi	j_bone_spin,a9
	calla	frame_a9
	movi	>0f,a0
	movi	>16,a1
	calla	multi_adjust_xy		; adjust cuz of shithead vogel

	movi	>38000,a0
	calla	randu
	addi	>4000,a0
	calla	set_proj_vel

	movk	3,a0
	calla	randu
	inc	a0
	calla	init_anirate

oneb1	sleep	1
	move	*a8(oyvel),a0,l
	addi	>6000,a0
	move	a0,*a8(oyvel),l		; bone gravity

	calla	next_anirate
	move	*a8(oypos),a0,w
	move	@ground_y,a1,w
	cmp	a1,a0
	jrlo	oneb1

	movi	>000400a7,a0		; [total # of entries, 1st entry]
	calla	random_triple		; bones land sound


	movi	->60000,a0
	jsrp	bone_bounce
	movi	->30000,a0
	jsrp	bone_bounce

	movk	3,a0
	calla	randu
	dec	a0
	sll	5,a0
	addi	a_bone_lay,a0
	move	a0,a9
	calla	frame_a9    		; last frame = laying down
	calla	stop_a8
	die

bone_bounce
	move	a0,*a8(oyvel),l
	move	*a8(oxvel),a0,l
	sra	1,a0
	move	a0,*a8(oxvel),l
	movk	3,a0
	movi	>6000,a10
	jauc	blood_fall


a_spit_bone1
	.long	BONE1_SPIT1
	.long	BONE1_SPIT2
	.long	BONE1_SPIT3
	.long	BONE1_SPIT4
	.long	BONE1_SPIT5
	.long	0

a_spit_bone2
	.long	BONE2_SPIT1
	.long	BONE2_SPIT2
	.long	BONE2_SPIT3
	.long	BONE2_SPIT4
	.long	BONE2_SPIT5
	.long	0


j_bone_spin
	.long	BONE3_SPIN1
	.long	BONE3_SPIN2
	.long	BONE3_SPIN3
	.long	BONE3_SPIN4
	.long	BONE3_SPIN5
	.long	BONE3_SPIN6
	.long	BONE3_SPIN7
	.long	BONE3_SPIN8
	.long	ani_jump,j_bone_spin

a_bone_lay
	.long	BONE3_SPIN1
	.long	BONE3_SPIN2
	.long	BONE3_SPIN5
	.long	BONE3_SPIN5


;*********************************************************************

sucked_in_anis
	.long	a_hh_sucked_in
	.long	a_lk_sucked_in
	.long	a_jc_sucked_in
	.long	a_sa_sucked_in
	.long	a_fn_sucked_in
	.long	a_fn_sucked_in
	.long	a_st_sucked_in
	.long	a_rd_sucked_in
	.long	a_nj_sucked_in
	.long	a_nj_sucked_in
	.long	a_nj_sucked_in
	.long	a_jx_sucked_in


a_jx_sucked_in
	.long	SUCK_JAX1
	.long	SUCK_JAX2
	.long	SUCK_JAX3
	.long	SUCK_JAX4
	.long	SUCK_JAX5
	.long	SUCK_JAX6
	.long	0

SUCK_JAX1
	.long	SUCK_JAX1A,SUCK_JAX1B,0
SUCK_JAX2
	.long	SUCK_JAX2A,SUCK_JAX2B,0
SUCK_JAX3
	.long	SUCK_JAX3A,0
SUCK_JAX4
	.long	SUCK_JAX4A,0
SUCK_JAX5
	.long	SUCK_JAX5A,0
SUCK_JAX6
	.long	SUCK_JAX6A,0

;*********************************************************************

a_st_sucked_in
	.long	SUCK_TSUNG1
	.long	SUCK_TSUNG2
	.long	SUCK_TSUNG3
	.long	SUCK_TSUNG4
	.long	SUCK_TSUNG5
	.long	SUCK_TSUNG6
	.long	SUCK_TSUNG7
	.long	0

SUCK_TSUNG1
	.long	SUCK_TSUNG1A,SUCK_TSUNG1B,0
SUCK_TSUNG2
	.long	SUCK_TSUNG2A,SUCK_TSUNG2B,0
SUCK_TSUNG3
	.long	SUCK_TSUNG3A,SUCK_TSUNG3B,0
SUCK_TSUNG4
	.long	SUCK_TSUNG4A,0
SUCK_TSUNG5
	.long	SUCK_TSUNG5A,0
SUCK_TSUNG6
	.long	SUCK_TSUNG6A,0
SUCK_TSUNG7
	.long	SUCK_TSUNG7A,0

;*********************************************************************

a_rd_sucked_in
	.long	SUCK_RAIDEN1
	.long	SUCK_RAIDEN2
	.long	SUCK_RAIDEN3
	.long	SUCK_RAIDEN4
	.long	SUCK_RAIDEN5
	.long	SUCK_RAIDEN6
	.long	SUCK_RAIDEN7
	.long	SUCK_RAIDEN8
	.long	0

SUCK_RAIDEN1
	.long	SUCK_RAIDEN1A,SUCK_RAIDEN1B,0
SUCK_RAIDEN2
	.long	SUCK_RAIDEN2A,SUCK_RAIDEN2B,0
SUCK_RAIDEN3
	.long	SUCK_RAIDEN3A,SUCK_RAIDEN3B,0
SUCK_RAIDEN4
	.long	SUCK_RAIDEN4A,0
SUCK_RAIDEN5
	.long	SUCK_RAIDEN5A,0
SUCK_RAIDEN6
	.long	SUCK_RAIDEN6A,0
SUCK_RAIDEN7
	.long	SUCK_RAIDEN7A,0
SUCK_RAIDEN8
	.long	SUCK_RAIDEN8A,0

;*********************************************************************

a_nj_sucked_in
	.long	SUCK_NINJA1
	.long	SUCK_NINJA2
	.long	SUCK_NINJA3
	.long	SUCK_NINJA4
	.long	SUCK_NINJA5
	.long	SUCK_NINJA6
	.long	SUCK_NINJA7
	.long	SUCK_NINJA8
	.long	0

SUCK_NINJA1
	.long	SUCK_NINJA1A,SUCK_NINJA1B,0
SUCK_NINJA2
	.long	SUCK_NINJA2A,SUCK_NINJA2B,0
SUCK_NINJA3
	.long	SUCK_NINJA3A,SUCK_NINJA3B,0
SUCK_NINJA4
	.long	SUCK_NINJA4A,SUCK_NINJA4B,0
SUCK_NINJA5
	.long	SUCK_NINJA5A,0
SUCK_NINJA6
	.long	SUCK_NINJA6A,0
SUCK_NINJA7
	.long	SUCK_NINJA7A,0
SUCK_NINJA8
	.long	SUCK_NINJA8A,0

;*********************************************************************

a_sa_sucked_in
	.long	SUCK_BARAKA1
	.long	SUCK_BARAKA2
	.long	SUCK_BARAKA3
	.long	SUCK_BARAKA4
	.long	SUCK_BARAKA5
	.long	SUCK_BARAKA6
	.long	SUCK_BARAKA7
	.long	0

SUCK_BARAKA1
	.long	SUCK_BARAKA1A,SUCK_BARAKA1B,0
SUCK_BARAKA2
	.long	SUCK_BARAKA2A,SUCK_BARAKA2B,0
SUCK_BARAKA3
	.long	SUCK_BARAKA3A,0
SUCK_BARAKA4
	.long	SUCK_BARAKA4A,0
SUCK_BARAKA5
	.long	SUCK_BARAKA5A,0
SUCK_BARAKA6
	.long	SUCK_BARAKA6A,0
SUCK_BARAKA7
	.long	SUCK_BARAKA7A,0

;*********************************************************************

a_fn_sucked_in
	.long	SUCK_KATANA1
	.long	SUCK_KATANA2
	.long	SUCK_KATANA3
	.long	SUCK_KATANA4
	.long	SUCK_KATANA5
	.long	SUCK_KATANA6
	.long	SUCK_KATANA7
	.long	SUCK_KATANA8
	.long	0

SUCK_KATANA1
	.long	SUCK_KATANA1A,SUCK_KATANA1B,0
SUCK_KATANA2
	.long	SUCK_KATANA2A,SUCK_KATANA2B,0
SUCK_KATANA3
	.long	SUCK_KATANA3A,SUCK_KATANA3B,0
SUCK_KATANA4
	.long	SUCK_KATANA4A,0
SUCK_KATANA5
	.long	SUCK_KATANA5A,0
SUCK_KATANA6
	.long	SUCK_KATANA6A,0
SUCK_KATANA7
	.long	SUCK_KATANA7A,0
SUCK_KATANA8
	.long	SUCK_KATANA8A,0

;*********************************************************************

a_jc_sucked_in
	.long	SUCK_CAGE1
	.long	SUCK_CAGE2
	.long	SUCK_CAGE3
	.long	SUCK_CAGE4
	.long	SUCK_CAGE5
	.long	SUCK_CAGE6
	.long	SUCK_CAGE7
	.long	0

SUCK_CAGE1
	.long	SUCK_CAGE1A,SUCK_CAGE1B,0
SUCK_CAGE2
	.long	SUCK_CAGE2A,SUCK_CAGE2B,0
SUCK_CAGE3
	.long	SUCK_CAGE3A,SUCK_CAGE3B,0
SUCK_CAGE4
	.long	SUCK_CAGE4A,0
SUCK_CAGE5
	.long	SUCK_CAGE5A,0
SUCK_CAGE6
	.long	SUCK_CAGE6A,0
SUCK_CAGE7
	.long	SUCK_CAGE7A,0

;*********************************************************************

a_hh_sucked_in
	.long	SUCK_LUNGLAO1
	.long	SUCK_LUNGLAO2
	.long	SUCK_LUNGLAO3
	.long	SUCK_LUNGLAO4
	.long	SUCK_LUNGLAO5
	.long	SUCK_LUNGLAO6
	.long	SUCK_LUNGLAO7
	.long	0

SUCK_LUNGLAO1
	.long	SUCK_LUNGLAO1A,SUCK_LUNGLAO1B,0
SUCK_LUNGLAO2
	.long	SUCK_LUNGLAO2A,SUCK_LUNGLAO2B,0
SUCK_LUNGLAO3
	.long	SUCK_LUNGLAO3A,SUCK_LUNGLAO3B,0
SUCK_LUNGLAO4
	.long	SUCK_LUNGLAO4A,0
SUCK_LUNGLAO5
	.long	SUCK_LUNGLAO5A,0
SUCK_LUNGLAO6
	.long	SUCK_LUNGLAO6A,0
SUCK_LUNGLAO7
	.long	SUCK_LUNGLAO7A,0

;*********************************************************************

a_lk_sucked_in
	.long	SUCK_LIUKANG1
	.long	SUCK_LIUKANG2
	.long	SUCK_LIUKANG3
	.long	SUCK_LIUKANG4
	.long	SUCK_LIUKANG5
	.long	SUCK_LIUKANG6
	.long	SUCK_LIUKANG7
	.long	0

SUCK_LIUKANG1
	.long	SUCK_LIUKANG1A,SUCK_LIUKANG1B,0
SUCK_LIUKANG2
	.long	SUCK_LIUKANG2A,SUCK_LIUKANG2B,0
SUCK_LIUKANG3
	.long	SUCK_LIUKANG3A,SUCK_LIUKANG3B,0
SUCK_LIUKANG4
	.long	SUCK_LIUKANG4A,0
SUCK_LIUKANG5
	.long	SUCK_LIUKANG5A,0
SUCK_LIUKANG6
	.long	SUCK_LIUKANG6A,0
SUCK_LIUKANG7
	.long	SUCK_LIUKANG7A,0

;************************************************************************

r_raiden_superp
	movk	1,a0
	move	a0,*a13(p_downcount),w
	tsound	>a4			; BOOM !!!
	jruc	superp_entry

r_shocker_pop
	clr	a0
	move	a0,*a13(p_downcount),w
	tsound	>a4			; BOOM !!!
	jruc	shocker_pop_entry

r_burst_pop
	clr	a0
	move	a0,*a13(p_downcount),w
	tsound	>a4			; BOOM !!!

	callr	inflate_pose
	calla	find_part2

	callr	get_pop_pal
	calla	swpal
	calla	do_next_a9_frame
	sleep	3

superp_entry
shocker_pop_entry
	jsrp	white_flash
	move	a8,a0
	calla	set_inviso

	create	pid_fx,kiss_explode
	move	a8,*a0(pa11),l		; pass my object to kiss explode

	move	a8,a11
	movi	exp_burst,a6
	movi	>4000,a10		; a10 = gravity
	movi	bone_land,a0
	callr	explode
	movi	>00080008,a11
	calla	shake_a11

	move	*a13(p_downcount),a0,w	; head ?
	jreq	spop3				; sans

	sleep	>a0

	move	a8,a11			; a11 = old me
	movi	>3d,a9
	calla	get_char_ani
	move	*a9,a5,l
	calla	gso_dmawnz

;******************
	move	*a11(ochar),*a8(ochar),w
	calla	change_to_bloody_pal
;******************

	movi	20,a0
	move	a0,*a8(ozpos),w		; in front of other shit
	move	*a11(oxpos),*a8(oxpos),w
	move	@worldtly+16,a0,w
	subi	>40,a0
	move	a0,*a8(oypos),w
	calla	insobja8

	movk	5,a0
	calla	init_anirate
	movi	>8000,a1
	movi	>60000,a0
	jsrp	head_grav

	movi	>6000,a1
	movi	->60000,a0
	jsrp	head_grav

	movi	>4000,a1
	movi	->40000,a0
	jsrp	head_grav

	movi	>4000,a1
	movi	->20000,a0
	jsrp	head_grav

spop3	jauc	wait_forever



head_grav
	move	a1,*a8(oxvel),l
	move	a0,*a8(oyvel),l
hgrav3	sleep	1
	calla	next_anirate
	move	*a8(oyvel),a0,l	
	addi	>6000,a0
	move	a0,*a8(oyvel),l		; gravity
	move	@ground_y,a1,w
	subi	>14,a1
	move	*a8(oypos),a0,w
	cmp	a1,a0
	jrlt	hgrav3

	tsound	>18			; thudd
	calla	stop_a8
	move	a1,*a8(oypos),w
	retp


exp_burst
	.word	>01,>40,>20		; coordinate adjust
	.word	8			; count
	.word	2			; ani speed min
	.word	0			; ani table offset
	.word	>3000
	.word	0
	.word	>7000
	.word	>4000

	.word	>01,>40,>20		; coordinate adjust / radius
	.word	3			; count
	.word	2			; ani speed min
	.word	1			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>3000

	.word	>01,>40,>28		; coordinate adjust / radius
	.word	8			; count
	.word	2			; ani speed min
	.word	2			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>3000

	.word	>01,>40,>28		; coordinate adjust / radius
	.word	4			; count
	.word	2			; ani speed min
	.word	3			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>3000

	.word	>01,>40,>28		; coordinate adjust / radius
	.word	2			; count
	.word	3			; ani speed min
	.word	4			; ani table offset
	.word	>1000
	.word	0
	.word	>7000
	.word	>7000

	.long	0

;************************************************************************

r_kissed
	calla	center_around_me

	callr	inflate_pose

	calla	rsnd_wasted_voice	; ahh !!!
	sleep	>20
	tsound	>a3			; rumble
	tsound	>a5			; dude suufering while inflating
;	tsound	>46			; dude suufering while inflating

	movk	8,a0
	jsrp	mframew			; inflate

	move	a8,a10
	movi	>00030006,a0
	movk	3,a1
	jsrp	shake_him_up		; shake ME up !!
	movi	>00050006,a0
	movk	3,a1
	jsrp	shake_him_up		; shake ME up !!
	movi	>00070006,a0
	movk	3,a1
	jsrp	shake_him_up		; shake ME up !!

	tsound	>a4			; BOOM !!!

	callr	get_pop_pal
;	move	*a9,a0,l
;	move	*a0,a0,l
;	move	*a0(icmap),a0,l
	calla	player_swpal		; use new "inflated" palette

	calla	do_next_a9_frame
	sleep	3
	jsrp	white_flash

	move	a8,a0
	calla	set_inviso

	create	pid_fx,kiss_explode
	move	a8,*a0(pa11),l		; pass my object to kiss explode

	move	a8,a11
	movi	exp_kiss,a6
	movi	>4000,a10		; a10 = gravity
	movi	bone_land,a0
	callr	explode

	movi	>00080008,a11
	calla	shake_a11

;	movk	3,a9
;kiss7	movk	1,a0
;	calla	create_blood_proc
;	move	*a8(oypos),a0,w
;	addi	>20,a0
;	move	a0,*a8(oypos),w
;	sleep	2
;	dsj	a9,kiss7

	jauc	wait_forever


inflate_pose
	movi	inflate_animations,a0
	calla	get_char_long
	move	a0,a9
	movi	inflate_palettes,a0
	calla	get_char_long

	movi	ft_st,a1
	move	*a8(ochar),a2,w
	cmp	a1,a2			; am i shang tsung ??
	jrne	infp3			; nope
	move	*a8(oflags2),a1,w
	btst	b_ugly_pal,a1		; alternate palette ?
	jreq	infp3			; no
	movi	FATSTB_P,a0
infp3
	calla	player_swpal   	; use new "inflated" palette
	calla	do_next_a9_frame
	rets

inflate_palettes
	.long	FATHATB_P	; 0 - kung lao
	.long	FATHOR_P	; 1 -
	.long	FATJONB_P	; 2 - cage
	.long	FATUGR_P	; 3 - baraka
	.long	FATKATB_P	; 4 - kitana
	.long	FATKATP_P	; 5 -
	.long	FATSHAN_P	; 6 - shang tsung
	.long	FATRADB_P	; 7 - raiden
	.long	FATSUB_P	; 8
	.long	FATREP_P	; 9
	.long	FATSCOR_P	; 10
	.long	FATJAXR_P	; 11


get_pop_pal
	movi	pop_palettes,a0
	calla	get_char_long
	rets

pop_palettes
	.long	POPHATB_P
	.long	POPLIUR_P
	.long	POPJONB_P
	.long	POPUGR_P
	.long	POPKATB_P
	.long	FATKATP_P
	.long	POPSHNB_P
	.long	POPRADB_P
	.long	POPSUB_P
	.long	POPREP_P
	.long	POPSCOR_P
	.long	POPJAXR_P


bone_land
	move	*a13(p_store2),a0,l
	cmpi	a_bone,a0
	jrne	bland3
	movi	>000400a7,a0	; [total # of entries, 1st entry]
	calla	random_triple
	
bland3	movi	->40000,a0
	move	a0,*a8(oyvel),l
	callr	half_x_vel
	jsrp	exp_flight

	movi	->20000,a0
	move	a0,*a8(oyvel),l
	callr	half_x_vel
	jsrp	exp_flight
	movi	>000400a7,a0	; [total # of entries, 1st entry]
	calla	random_triple

	calla	stop_a8
	die
	


inflate_animations
	.long	a_hh_fat	; 0 = kung lao
	.long	a_lk_fat	; 1 = liu kang
	.long	a_jc_fat
	.long	a_sa_fat

	.long	a_fn1_fat
	.long	a_fn2_fat
	.long	a_st_fat
	.long	a_rd_fat

	.long	a_sz_fat
	.long	a_rp_fat
	.long	a_sc_fat
	.long	a_jax_fat	; 11 = jax

	.long	a_jax_fat
	.long	a_jax_fat
	.long	a_jax_fat
	.long	a_jax_fat

;**************************************************************************

kahn_explode
	tsound	>a4			; sound: BOOM !!!!!
	push	a11
	movk	8,a11
	calla	do_a11_background	; put the arena back up !!
	pull	a11
*
* reposition kahn in center of screen
*
	move	@worldtlx+16,a0,w
	addi	scrrgt/2,a0
	move	a0,*a8(oxpos),w
	movi	>50,a0
	move	a0,*a8(oypos),w		; ground kahn
	calla	do_next_a9_frame
	sleep	3

	create	pid_fx,final_flasher
	movi	pid_backg,a0
	calla	dallprc
	movi	pid_bani,a0
	calla	dallprc

	move	a8,a0
	calla	set_inviso
	move	a8,a11			; a11 = input for explode
	callr	kahn_bang

	movi	exp_kahn,a6
	movi	>4000,a10		; a10 = gravity
	movi	bone_land,a0
	callr	explode

	sleep	4
	create	pid_fx,delete_offscreen
	sleep	>10

	tsound	>a4			; sound: BOOM !!!!!
	jsrp	white_flash
	callr	kahn_bang

	movi	>00080008,a11
	calla	shake_a11
	sleep	>60
	retp


exp_kahn
	.word	>01,>20,>20		; coordinate adjust
	.word	8			; count
	.word	2			; ani speed min
	.word	5			; ani table offset
	.word	>3000
	.word	0
	.word	>7000
	.word	>6000

	.word	>01,>20,>20		; coordinate adjust / radius
	.word	3			; count
	.word	2			; ani speed min
	.word	5			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>6000

	.word	>01,>20,>28		; coordinate adjust / radius
	.word	8			; count
	.word	2			; ani speed min
	.word	6			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>6000

	.word	>01,>20,>28		; coordinate adjust / radius
	.word	4			; count
	.word	2			; ani speed min
	.word	6			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>6000

	.word	>01,>20,>28		; coordinate adjust / radius
	.word	2			; count
	.word	3			; ani speed min
	.word	5			; ani table offset
	.word	>1000
	.word	0
	.word	>7000
	.word	>7000

	.long	0



final_flasher
	move	@irqskye,a9,w
	movi	>ffff,a0
	move	a0,@irqskye,w		; white
	movk	3,a10

ffl3	move	@baklst1,a1,l
	move	@baklst2,a2,l
	move	@baklst3,a3,l
	move	@baklst4,a4,l
	move	@baklst5,a5,l
	move	@baklst6,a6,l
	move	@baklst7,a7,l
	mmtm	a12,a1,a2,a3,a4,a5,a6,a7
	clr	a0
	move	a0,@baklst1,l
	move	a0,@baklst2,l
	move	a0,@baklst3,l
	move	a0,@baklst4,l
	move	a0,@baklst5,l
	move	a0,@baklst6,l
	move	a0,@baklst7,l
	move	a0,@f_skew,w		; dont draw the floor
	sleep	5

	move	a9,@irqskye,w		; white
	mmfm	a12,a1,a2,a3,a4,a5,a6,a7
	move	a1,@baklst1,l
	move	a2,@baklst2,l
	move	a3,@baklst3,l
	move	a4,@baklst4,l
	move	a5,@baklst5,l
	move	a6,@baklst6,l
	move	a7,@baklst7,l
	movk	1,a0
	move	a0,@f_skew,w		; dont draw the floor
	sleep	5
	dsj	a10,ffl3
	die

;**********************************************************************

super_freeze_bang
	jsrp	white_flash

	move	a8,a11
	move	*a11(oxpos),a3,w
	subk	>03,a3
	move	a3,a2
	move	*a11(oypos),a3,w
	addi	>48,a3

	movi	MEDROCK1,a5
	movi	ice_explode_table,a9
	callr	spawn_off_bang

	movi	exp_ice,a6
	movi	>4000,a10		; a10 = gravity
	movi	bone_land,a0
	callr	explode

	movi	>0008000e,a11
	calla	shake_a11

	sleep	4
	create	pid_fx,delete_offscreen
	die


exp_ice
	.word	>01,>40,>20		; coordinate adjust
	.word	8			; count
	.word	2			; ani speed min
	.word	7			; ani table offset
	.word	>3000
	.word	0
	.word	>7000
	.word	>4000

	.word	>01,>40,>20		; coordinate adjust / radius
	.word	3			; count
	.word	2			; ani speed min
	.word	8			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>3000

	.word	>01,>40,>28		; coordinate adjust / radius
	.word	8			; count
	.word	2			; ani speed min
	.word	9			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>3000

	.word	>01,>40,>28		; coordinate adjust / radius
	.word	4			; count
	.word	2			; ani speed min
	.word	10			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>3000

	.word	>01,>40,>28		; coordinate adjust / radius
	.word	2			; count
	.word	3			; ani speed min
	.word	4			; ani table offset
	.word	>1000
	.word	0
	.word	>7000
	.word	>7000

; xtras

	.word	>01,>40,>20		; coordinate adjust
	.word	8			; count
	.word	2			; ani speed min
	.word	2			; ani table offset
	.word	>3000
	.word	0
	.word	>7000
	.word	>4000

	.word	>01,>40,>20		; coordinate adjust / radius
	.word	3			; count
	.word	2			; ani speed min
	.word	3			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>3000

	.word	>01,>40,>28		; coordinate adjust / radius
	.word	8			; count
	.word	2			; ani speed min
	.word	9			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>3000

	.long	0


ice_explode_table
	.long	MEDROCK1
	.word	48,0
	.long	MEDROCK3
	.word	46,-12
	.long	MEDROCK5
	.word	40,-25

	.long	MEDROCK2
	.word	29,-38
	.long	MEDROCK4
	.word	16,-45
	.long	MEDROCK6
	.word	0,-48
	.long	0



a_ice_piece1
	.long	MEDROCK1
	.long	MEDROCK2
	.long	MEDROCK3
	.long	MEDROCK4
	.long	MEDROCK5
	.long	MEDROCK6
	.long	MEDROCK7
	.long	MEDROCK8
	.long	ani_jump,a_ice_piece1

a_ice_piece2
	.long	LILROCK1
	.long	LILROCK2
	.long	LILROCK3
	.long	LILROCK4
	.long	LILROCK5
	.long	LILROCK6
	.long	ani_jump,a_ice_piece2

a_ice_piece3
	.long	BIGANVILPC1
	.long	BIGANVILPC2
	.long	BIGANVILPC3
	.long	BIGANVILPC4
	.long	BIGANVILPC5
	.long	BIGANVILPC6
	.long	BIGANVILPC7
	.long	BIGANVILPC8
	.long	BIGANVILPC9
	.long	BIGANVILPC10
	.long	BIGANVILPC11
	.long	BIGANVILPC12
	.long	BIGANVILPC13
	.long	ani_jump,a_ice_piece3

a_ice_piece4
	.long	LILANVILPC1
	.long	LILANVILPC2
	.long	LILANVILPC3
	.long	LILANVILPC4
	.long	LILANVILPC5
	.long	LILANVILPC6
	.long	LILANVILPC7
	.long	LILANVILPC9
	.long	LILANVILPC10
	.long	LILANVILPC11
	.long	LILANVILPC12
	.long	LILANVILPC13
	.long	ani_jump,a_ice_piece4

;**********************************************************************

kahn_bang
	move	a11,a8
	move	*a11(oxpos),a3,w
	subk	>03,a3
	move	a3,a2
	move	*a11(oypos),a3,w
	addi	>48,a3

	movi	>17,a9
	calla	get_char_ani		; a9 ---> explode table
	movi	KAHNBIG1,a5		; a5 = source image
	jruc	spawn_off_bang

**************************************************************************
*											     *
*  kiss_explode - Explosion of body parts for the KISS OF DEATH BLOW     *
*											     *
**************************************************************************
kiss_explode
	move	*a11(oxpos),a3,w
	subk	>03,a3
	move	a3,a2
	move	*a11(oypos),a3,w
	addi	>48,a3

	movi	CHUNK1A,a5
	movi	balloon_table,a9
	callr	spawn_off_bang
	sleep	4

delete_offscreen
	move	@objlst,a10,l
	sleep	1

kexp4	move	*a10,a11,l   		; a11 = next
	move	@worldtlx+16,a3,w
	move	a3,a4
	addi	scrrgt,a4
	move	@worldtly+16,a5,w
	move	a5,a6
	addi	scrbot,a6

	move	*a10(oxpos),a1,w
	cmp	a3,a1
	jrlt	kexp9
	cmp	a4,a1
	jrgt	kexp9

	move	*a10(oypos),a1,w
	cmp	a5,a1
	jrlt	kexp9
	cmp	a6,a1
	jrlt	kexpa

kexp9	move	*a10(oid),a0,w
	cmpi	oid_bones,a0		; leave bones alone
	jreq	kexpa

	move	a10,a0
	calla	delobjp

kexpa	move	a11,a10
	jrne	kexp4
	jruc	delete_offscreen



spawn_off_bang
	move	a5,*a13(p_store5),l

sob3	move	*a9+,a1,l
	jreq	sob4
	move	*a9+,a6,w
	jreq	sob4
	move	*a9+,a7,w
	callr	non_scale_piece
	jruc	sob3
sob4	rets


non_scale_piece
	callr	getnon
	sra	1,a6
	sra	1,a7
	callr	getnon		; upper right

	sll	1,a6
	sll	1,a7
	neg	a6
	callr	getnon
	sra	1,a6
	sra	1,a7
	callr	getnon		; upper left

	sll	1,a6
	sll	1,a7
	neg	a7
	callr	getnon
	sra	1,a6
	sra	1,a7
	callr	getnon		; lower left

	sll	1,a6
	sll	1,a7
	neg	a6
	callr	getnon
	sra	1,a6
	sra	1,a7
	callr	getnon		; lower right

	rets


getnon
	move	*a13(p_store5),a5,l	; get source image
	calla	gso_dmawnz
	calla	ani_flag		; shape me !!

	movk	1,a0
	move	a0,*a8(ozpos),w

	move	a6,a0
	sll	16,a0
	sra	2,a0
	move	a0,*a8(oxvel),l
	move	a7,a0
	sll	16,a0
	sra	2,a0
	move	a0,*a8(oyvel),l

	mmtm	sp,a6,a7
	move	*a8(osizex),a0,w
	sra	1,a0
	add	a2,a6
	sub	a0,a6
	move	a6,*a8(oxpos),w
	move	*a8(osizey),a0,w
	sra	1,a0
	add	a3,a7
	sub	a0,a7
	move	a7,*a8(oypos),w
	mmfm	sp,a6,a7

	calla	insobja8

	rets


xspace	.set	10

balloon_table
	.long	CHUNK5A
	.word	48,0
	.long	CHUNK5B
	.word	46,-12
	.long	CHUNK5C
	.word	40,-25

	.long	CHUNK5A
	.word	29,-38
	.long	CHUNK5B
	.word	16,-45
	.long	CHUNK5C
	.word	0,-48

	.long	0

	.long	CHUNK5B
	.word	48-(4*xspace),-47
	.long	0

	.long	CHUNK5B		; image
	.word	>03,->20
	.long	CHUNK5C		; image
	.word	>05,->10

	.long	CHUNK5A		; image
	.word	>08,->30
	.long	CHUNK5B		; image
	.word	>09,->20
	.long	CHUNK5C		; image
	.word	>0a,->10

	.long	CHUNK5A		; image
	.word	>18,->10
	.long	CHUNK5B		; image
	.word	>18,->20
	.long	CHUNK5C		; image
	.word	>18,->10
	.long	0

*************************************************************************

CHUNK1	.long	CHUNK1A,CHUNK1B,CHUNK1C,0
CHUNK2	.long	CHUNK2A,CHUNK2B,CHUNK2C,0
CHUNK3	.long	CHUNK3A,CHUNK3B,CHUNK3C,0
CHUNK4	.long	CHUNK4A,CHUNK4B,CHUNK4C,0
CHUNK5	.long	CHUNK5A,CHUNK5B,CHUNK5C,0
CHUNK6	.long	CHUNK6A,CHUNK6B,CHUNK6C,0
CHUNK7	.long	CHUNK7A,CHUNK7B,CHUNK7C,0
CHUNK8	.long	CHUNK8A,CHUNK8B,CHUNK8C,0
CHUNK9	.long	CHUNK9A,CHUNK9B,CHUNK9C,0
CHUNK10	.long	CHUNK10A,CHUNK10B,CHUNK10C,0
CHUNK11	.long	CHUNK11A,CHUNK11B,CHUNK11C,0

a_jax_fat
	.long	FATJAX1
	.long	FATJAX2
	.long	FATJAX3
	.long	FATJAX4
	.long	FATJAX6
	.long	0
	.long	POPJAX
	.long	0

POPJAX	.long	JAXBUST1A,JAXBUST1B,0
FATJAX1	.long	FATJAX1A,FATJAX1B,FATJAX1C,FATJAX1D,0
FATJAX2	.long	FATJAX2A,FATJAX2B,FATJAX2C,0
FATJAX3	.long	FATJAX3A,FATJAX3B,FATJAX3C,0
FATJAX4	.long	FATJAX4A,FATJAX4B,FATJAX4C,0
FATJAX6	.long	FATJAX6A,FATJAX6B,FATJAX6C,0

;**********************************************************************

a_hh_fat
	.long	FATHAT1
	.long	FATHAT2
	.long	FATHAT3
	.long	FATHAT4
	.long	FATHAT5
	.long	0
	.long	POPHAT1
	.long	0

FATHAT1	.long	FATHAT1A,FATHAT1B,0
FATHAT2	.long	FATHAT2A,FATHAT2B,0
FATHAT3	.long	FATHAT3A,FATHAT3B,0
FATHAT4	.long	FATHAT4A,FATHAT4B,0
FATHAT5	.long	FATHAT5A,FATHAT5B,0
POPHAT1	.long	POPHAT1A,POPHAT1B,POPHAT1C,0

;**********************************************************************

a_lk_fat
	.long	FATLIU1
	.long	FATLIU2
	.long	FATLIU3
	.long	FATLIU4
	.long	FATLIU5
	.long	0
	.long	POPLIU1
	.long	0

FATLIU1	.long	FATLIU1A,FATLIU1B,0
FATLIU2	.long	FATLIU2A,FATLIU2B,0
FATLIU3	.long	FATLIU3A,FATLIU3B,0
FATLIU4	.long	FATLIU4A,FATLIU4B,0
FATLIU5	.long	FATLIU5A,FATLIU5B,0
POPLIU1	.long	POPLIU1A,POPLIU1B,0

;**********************************************************************

a_jc_fat
	.long	FATJON1
	.long	FATJON2
	.long	FATJON3
	.long	FATJON4
	.long	FATJON5
	.long	0
	.long	POPJON1
	.long	0

FATJON1	.long	FATJON1A,FATJON1B,0
FATJON2	.long	FATJON2A,FATJON2B,0
FATJON3	.long	FATJON3A,FATJON3B,0
FATJON4	.long	FATJON4A,FATJON4B,0
FATJON5	.long	FATJON5A,FATJON5B,0
POPJON1	.long	POPJON1A,POPJON1B,0

;**********************************************************************

a_sa_fat
	.long	FATUG1
	.long	FATUG2
	.long	FATUG3
	.long	FATUG4
	.long	FATUG5
	.long	0
	.long	POPUG1
	.long	0

FATUG1	.long	FATUG1A,FATUG1B,0
FATUG2	.long	FATUG2A,FATUG2B,0
FATUG3	.long	FATUG3A,FATUG3B,FATUG3C,FATUG3D,0
FATUG4	.long	FATUG4A,FATUG4B,FATUG4C,FATUG4D,0
FATUG5	.long	FATUG5A,FATUG5B,FATUG5C,0
POPUG1	.long	POPUG1A,POPUG1B,POPUG1C,0

;**********************************************************************

a_fn1_fat
a_fn2_fat
	.long	FATKAT1
	.long	FATKAT2
	.long	FATKAT3
	.long	FATKAT4
	.long	FATKAT5
	.long	0
	.long	POPKAT1
	.long	0

FATKAT1	.long	FATKAT1A,FATKAT1B,0
FATKAT2	.long	FATKAT2A,FATKAT2B,0
FATKAT3	.long	FATKAT3A,FATKAT3B,0
FATKAT4	.long	FATKAT4A,FATKAT4B,0
FATKAT5	.long	FATKAT5A,FATKAT5B,0
POPKAT1	.long	POPKAT1A,POPKAT1B,0

;**********************************************************************

a_st_fat
	.long	FATSHANG1
	.long	FATSHANG2
	.long	FATSHANG3
	.long	FATSHANG4
	.long	FATSHANG5
	.long	0
	.long	POPSHANG1
	.long	0

FATSHANG1
	.long	FATSHANG1A,FATSHANG1B,FATSHANG1C,FATSHANG1D,0
FATSHANG2
	.long	FATSHANG2A,FATSHANG2B,FATSHANG2C,FATSHANG2D,0
FATSHANG3
	.long	FATSHANG3A,FATSHANG3B,0
FATSHANG4
	.long	FATSHANG4A,FATSHANG4B,0
FATSHANG5
	.long	FATSHANG5A,FATSHANG5B,FATSHANG5C,0
POPSHANG1
	.long	POPSHANG1A,POPSHANG1B,POPSHANG1C,POPSHANG1D,0

;**********************************************************************

a_sc_fat
a_sz_fat
a_rp_fat
;	.long	FATNINJA1

	.long	FATNINJA2
	.long	FATNINJA3
	.long	FATNINJA4

;	.long	FATNINJA5
	.long	0
	.long	NINJABUST1
	.long	0

FATNINJA1
	.long	FATNINJA1A,FATNINJA1B,0
FATNINJA2
	.long	FATNINJA2A,FATNINJA2B,0
FATNINJA3
	.long	FATNINJA3A,FATNINJA3B,0
FATNINJA4
	.long	FATNINJA4A,FATNINJA4B,0
FATNINJA5
	.long	FATNINJA5A,FATNINJA5B,0
NINJABUST1
	.long	NINJABUST1A,NINJABUST1B,NINJABUST1C,NINJABUST1D,0

**************************************************************************

a_rd_fat
	.long	FATRAD1
	.long	FATRAD2
	.long	FATRAD3
	.long	FATRAD4
	.long	FATRAD5
	.long	0
	.long	RAIDENBUST1
	.long	0

FATRAD1	.long	FATRAD1A,FATRAD1B,0
FATRAD2	.long	FATRAD2A,FATRAD2B,0
FATRAD3	.long	FATRAD3A,FATRAD3B,0
FATRAD4	.long	FATRAD4A,FATRAD4B,FATRAD4C,FATRAD4D,0
FATRAD5	.long	FATRAD5A,FATRAD5B,FATRAD5C,FATRAD5D,0

RAIDENBUST1
	.long	RAIDENBUST1A,RAIDENBUST1B,RAIDENBUST1C,RAIDENBUST1D,0

;*****************************************************************

explode
	move	a0,*a13(p_store1),l
	push	a8
exp3	move	*a6+,a4,l			; y:x coordinate offset
	jreq	exp5
	move	*a6+,a8,w			; a8 = radius
	move	*a6+,a14,w			; a14 = count

	push	a4
	move	*a6+,a3,w			; more ?
	move	*a6+,a5,w
	sll	5,a5
	addi	explosion_animations,a5
	move	*a5,a5,l
	move	a5,b0

	move	*a6+,a5,w
	sll	4,a5
	move	*a6+,a7,w
	sll	4,a7
	move	*a6+,a9,w
	sll	4,a9
	move	*a6+,a2,w
	sll	4,a2
	pull	a4

exp6	push	a7
	create	pid_bones,explode_piece
	move	b0,a7
	move	a7,*a0(p_store2),l		; animation table
	pull	a7

	move	*a13(p_store1),*a0(p_joyport),l
	move	a3,*a0(p_store1),w		; grab animation speed
	move	a5,*a0(p_store4),l	 	; x range
	move	a7,*a0(p_store3),l		; x minimum
	move	a9,*a0(p_store5),l		; y range
	move	a2,*a0(p_store6),l		; y minimum
	move	a10,*a0(pa10),l			; grav
*
* starting coordinates
*
	mmtm	sp,a5,a14
	move	a0,a14				; a3 = proc

	move	a4,a1
	zext	a1,w				; a1 = x offset
	move	*a11(oxpos),a5,w
	add	a1,a5				; x coordinate offset
	move	a8,a0
	calla	srand
	add	a0,a5
	move	a5,*a14(p_store7),w

	move	a4,a1
	srl	16,a1
	move	*a11(oypos),a5,w
	add	a1,a5				; y coordinate offset
	move	a8,a0
	calla	srand
	add	a0,a5
	move	a5,*a14(p_store8),w
	mmfm	sp,a5,a14

	dsj	a14,exp6
	jruc	exp3

exp5	pull	a8
	rets


explode_piece
	move	*a13(p_store1),a1,w
	movk	2,a0
	calla	randu
	add	a1,a0
	calla	init_anirate

	move	*a13(p_store2),a9,l
	move	*a9,a5,l
	calla	gso_dmawnz
	movi	oid_bones,a0
	move	a0,*a8(oid),w

	movk	1,a0
	move	a0,*a8(ozpos),w

	move	*a13(p_store4),a0,l
	calla	randu
	move	*a13(p_store3),a1,l
	add	a1,a0
	move	@rand,a1,l
	jrn	expc4
	neg	a0
expc4	move	a0,*a8(oxvel),l

	move	*a13(p_store5),a0,l
	calla	randu
	move	*a13(p_store6),a1,l
	add	a1,a0
	neg	a0
	move	a0,*a8(oyvel),l

	move	*a13(p_store7),*a8(oxpos),w
	move	*a13(p_store8),*a8(oypos),w

	calla	insobja8
*
* flight loop
*
	jsrp	exp_flight
	move	*a13(p_joyport),a0,l
	jump	a0


half_x_vel
	move	*a8(oxvel),a0,l
	sra	1,a0
	move	a0,*a8(oxvel),l
	rets

exp_flight
	move	*a8(oyvel),a0,l
	add	a10,a0
	move	a0,*a8(oyvel),l
	calla	next_anirate
	sleep	1
	move	*a8(oyvel),a0,l
	jrn	exp_flight		; heading up = loop
	move	*a8(oypos),a0,w
	move	@ground_y,a1,w
	subi	>14,a1			; higher on screen
	cmp	a1,a0
	jrlt	exp_flight
	retp


exp_kiss
	.word	>01,>28,>10		; coordinate adjust
	.word	8			; count
	.word	2			; ani speed min
	.word	0			; ani table offset
	.word	>3000
	.word	0
	.word	>7000
	.word	>4000

	.word	>01,>28,>10		; coordinate adjust / radius
	.word	3			; count
	.word	2			; ani speed min
	.word	1			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>3000

	.word	>01,>28,>18		; coordinate adjust / radius
	.word	8			; count
	.word	2			; ani speed min
	.word	2			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>3000

	.word	>01,>28,>18		; coordinate adjust / radius
	.word	4			; count
	.word	2			; ani speed min
	.word	3			; ani table offset
	.word	>2000
	.word	0
	.word	>5000
	.word	>3000

	.word	>01,>28,>18		; coordinate adjust / radius
	.word	2			; count
	.word	3			; ani speed min
	.word	4			; ani table offset
	.word	>1000
	.word	0
	.word	>7000
	.word	>7000

	.long	0


explosion_animations
	.long	a_bone		; 0
	.long	a_hip		; 1
	.long	a_limb		; 2
	.long	a_intestin	; 3
	.long	a_hand		; 4

	.long	a_bigstone	; 5
	.long	a_lilstone	; 6

	.long	a_ice_piece1	; 7
	.long	a_ice_piece2	; 8
	.long	a_ice_piece3	; 9
	.long	a_ice_piece4	; 10


a_bone	.long	ROTATE2A
	.long	ROTATE2B
	.long	ROTATE2C
	.long	ROTATE2D
	.long	ROTATE2E
	.long	ROTATE2F
	.long	ROTATE2G
	.long	ROTATE2H
	.long	ani_jump,a_bone

a_hip	.long	ROTATE3A
	.long	ROTATE3B
	.long	ROTATE3C
	.long	ROTATE3D
	.long	ROTATE3E
	.long	ROTATE3F
	.long	ROTATE3G
	.long	ROTATE3H
	.long	ani_jump,a_hip

a_limb	.long	ROTATE4A
	.long	ROTATE4B
	.long	ROTATE4C
	.long	ROTATE4D
	.long	ROTATE4E
	.long	ROTATE4F
	.long	ROTATE4G
	.long	ROTATE4H
	.long	ani_jump,a_limb

a_intestin
	.long	ROTATE8A
	.long	ROTATE8B
	.long	ROTATE8C
	.long	ROTATE8D
	.long	ROTATE8E
	.long	ROTATE8F
	.long	ROTATE8G
	.long	ROTATE8H
	.long	ani_jump,a_intestin

a_hand
	.long	ROTATE9A
	.long	ROTATE9B
	.long	ROTATE9C
	.long	ROTATE9D
	.long	ROTATE9E
	.long	ROTATE9F
	.long	ROTATE9G
	.long	ROTATE9H
	.long	ani_jump,a_hand

;*****************************************************************

FATSCOR_P:
   .word   64 
   .word   00000h,07f99h,07b16h,07671h,06a0dh,05587h,04d44h,04522h
   .word   03cc0h,03480h,07fb4h,07fafh,07f50h,07f4ch,07f30h,07f2dh
   .word   07f27h,07f0ah,07eebh,07ee9h,07ee5h,07ecch,072eah,07ec8h
   .word   07aa8h,07ea3h,07688h,06e89h,07a63h,07666h,07263h,06e46h
   .word   07220h,06627h,06626h,06203h,05e06h,05de3h,05dc0h,051c6h
   .word   051a3h,05180h,05cc0h,04d40h,03d42h,03102h,028e1h,024a1h
   .word   01c40h,00c00h,07ffeh,07ff9h,07ff3h,035ceh,0296bh,0254ah
   .word   01d08h,018c5h,014c6h,014a3h,00c84h,00863h,00841h,00442h

FATREP_P:
   .word   64 
   .word   00000h,07f99h,07b16h,07671h,06a0dh,05587h,04d44h,04522h
   .word   03cc0h,03480h,04f6eh,02f60h,02f00h,02f00h,02ee0h,02ee0h
   .word   02ee0h,02ec0h,02ea0h,02ea0h,02ea0h,02e80h,022a0h,02e80h
   .word   02a60h,02e60h,02640h,01e40h,02a20h,02620h,02220h,01e00h
   .word   021e0h,015e0h,015e0h,011c0h,00dc0h,00da0h,00d80h,00180h
   .word   00160h,00140h,00c80h,00100h,00100h,000c0h,000a0h,00060h
   .word   00000h,00000h,05fb6h,057b5h,04f8eh,035ceh,0296bh,0254ah
   .word   01d08h,018c5h,014c6h,014a3h,00c84h,00863h,00841h,00442h

FATKATP_P:
   .word   61 
   .word   00000h,07fffh,06b5ah,056b5h,03defh,018c6h,07ed2h,076b1h
   .word   06e70h,06a4fh,0662eh,0660dh,05debh,059ech,055aah,05189h
   .word   003e0h,04d68h,04147h,03948h,03927h,02d06h,028e5h,024a2h
   .word   020a4h,01062h,00c21h,07fbch,07f9ah,07f36h,07b78h,066f5h
   .word   07e7fh,07e5fh,07e1fh,079feh,07a3eh,0799eh,0761dh,0757dh
   .word   0699ah,0697ah,06559h,06539h,05916h,054b5h,04070h,03c4fh
   .word   038aeh,034adh,0304ch,02c4bh,02449h,02048h,02028h,01c47h
   .word   01c27h,01024h,00401h,04a9eh,0292ah

POPSUB_P:
   .word   64 
   .word   00000h,039ceh,018c6h,01084h,00c63h,07e0ah,07da9h,075a6h
   .word   07483h,068e7h,068a4h,0656eh,06083h,058e7h,05483h,04cc5h
   .word   04463h,04000h,034a4h,03000h,02c63h,043bdh,02f9dh,0239dh
   .word   02f7dh,0235dh,01eddh,01a9dh,0331dh,01b1dh,0125dh,00f3dh
   .word   00afdh,01afdh,0165dh,0231dh,0029ch,0121bh,005fbh,04719h
   .word   01679h,005b8h,01217h,01a76h,005f3h,001f0h,0018fh,07f99h
   .word   07b16h,07671h,06a0dh,05587h,04d44h,04522h,03cc0h,03480h
   .word   07ffeh,05291h,014a3h,00401h,0296bh,0254ah,02129h,00442h

POPREP_P:
   .word   64 
   .word   00000h,039ceh,018c6h,01084h,00c63h,07e0ah,07da9h,075a6h
   .word   07483h,068e7h,068a4h,0656eh,06083h,058e7h,05483h,04cc5h
   .word   04463h,04000h,034a4h,03000h,02c63h,03380h,03360h,03360h
   .word   03340h,03320h,032a0h,03260h,032e0h,032e0h,03220h,03300h
   .word   032c0h,032c0h,03220h,02ee0h,02e60h,029e0h,029c0h,022e0h
   .word   02240h,01d80h,019e0h,01640h,009c0h,001c0h,00160h,07f99h
   .word   07b16h,07671h,06a0dh,05587h,04d44h,04522h,03cc0h,03480h
   .word   07ffeh,05291h,014a3h,00401h,0296bh,0254ah,02129h,00442h

FATSTB_P:
   .word   64 
   .word   00000h,07fffh,06739h,05ad6h,04631h,035adh,0294ah,02108h
   .word   018c6h,01084h,00842h,07fd5h,07fbah,07fb8h,07f95h,07f78h
   .word   07f77h,07f55h,07f35h,07f13h,07ef4h,07ef2h,07ed1h,07eb0h
   .word   07e8fh,07e8dh,07e6ch,07a2ah,076b2h,0724fh,071c6h,06e2dh
   .word   0662dh,065c9h,059aah,05967h,05546h,045cah,04503h,03440h
   .word   02901h,020c0h,018a1h,01061h,00400h,02effh,02edfh,02ef6h
   .word   02edch,02eb8h,02eb6h,02a72h,02676h,02252h,01a12h,015fch
   .word   015f6h,011b2h,00977h,00172h,00112h,03d81h,039a6h,03140h

;************************************************************************

ochar_arm_ripped_ani
	.long	a_hh_arms_ripped
	.long	a_lk_arms_ripped
	.long	a_jc_arms_ripped
	.long	a_sa_arms_ripped

	.long	a_fn_arms_ripped
	.long	a_fn_arms_ripped
	.long	a_st_arms_ripped
	.long	a_rd_arms_ripped

	.long	a_nj_arms_ripped
	.long	a_nj_arms_ripped
	.long	a_nj_arms_ripped
	.long	a_jx_arms_ripped

	.long	a_hh_arms_ripped
	.long	a_hh_arms_ripped
	.long	a_hh_arms_ripped
	.long	a_hh_arms_ripped

;**************************************************************************

a_hh_arms_ripped
	.long	TMARMRIP1
	.long	TMARMRIP2
	.long	TMARMRIP3
	.long	TMARMRIP4
	.long	TMARMRIP5
	.long	0

TMARMRIP1
	.long	TMARMRIP1A,TMARMRIP1B,TMARMRIP1C,0
TMARMRIP2
	.long	TMARMRIP2A,TMARMRIP2B,TMARMRIP2C,TMARMRIP2D,0
TMARMRIP3
	.long	TMARMRIP3A,TMARMRIP3B,TMARMRIP3C,0
TMARMRIP4
	.long	TMARMRIP4A,TMARMRIP4B,0
TMARMRIP5
	.long	TMARMRIP5A,TMARMRIP5B,0

;**************************************************************************

a_lk_arms_ripped
	.long	LKARMRIP1
	.long	LKARMRIP2
	.long	LKARMRIP3
	.long	LKARMRIP4
	.long	LKARMRIP5
	.long	0

LKARMRIP1
	.long	LKARMRIP1A,LKARMRIP1B,LKARMRIP1C,0
LKARMRIP2
	.long	LKARMRIP2A,LKARMRIP2B,0
LKARMRIP3
	.long	LKARMRIP3A,LKARMRIP3B,0
LKARMRIP4
	.long	LKARMRIP4A,LKARMRIP4B,0
LKARMRIP5
	.long	LKARMRIP5A,LKARMRIP5B,0

;**************************************************************************

a_jc_arms_ripped
	.long	JCARMRIP1
	.long	JCARMRIP2
	.long	JCARMRIP3
	.long	JCARMRIP4
	.long	JCARMRIP5
	.long	0

JCARMRIP1
	.long	JCARMRIP1A,JCARMRIP1B,JCARMRIP1C,0
JCARMRIP2
	.long	JCARMRIP2A,JCARMRIP2B,JCARMRIP2C,0
JCARMRIP3
	.long	JCARMRIP3A,JCARMRIP3B,JCARMRIP3C,0
JCARMRIP4
	.long	JCARMRIP4A,JCARMRIP4B,0
JCARMRIP5
	.long	JCARMRIP5A,JCARMRIP5B,0

;**************************************************************************

a_sa_arms_ripped
	.long	UGARMRIP1
	.long	UGARMRIP2
	.long	UGARMRIP3
	.long	UGARMRIP4
	.long	UGARMRIP5
	.long	0

UGARMRIP1
	.long	UGARMRIP1A,UGARMRIP1B,0
UGARMRIP2
	.long	UGARMRIP2A,0
UGARMRIP3
	.long	UGARMRIP3A,0
UGARMRIP4
	.long	UGARMRIP4A,0
UGARMRIP5
	.long	UGARMRIP5A,UGARMRIP5B,0

;**************************************************************************

a_fn_arms_ripped
	.long	KTARMRIP1
	.long	KTARMRIP2
	.long	KTARMRIP3
	.long	KTARMRIP4
	.long	KTARMRIP5
	.long	0

KTARMRIP1
	.long	KTARMRIP1A,KTARMRIP1B,KTARMRIP1C,0
KTARMRIP2
	.long	KTARMRIP2A,0
KTARMRIP3
	.long	KTARMRIP3A,0
KTARMRIP4
	.long	KTARMRIP4A,KTARMRIP4B,0
KTARMRIP5
	.long	KTARMRIP5A,KTARMRIP5B,0

;**************************************************************************

a_st_arms_ripped
	.long	STARMRIP1
	.long	STARMRIP2
	.long	STARMRIP3
	.long	STARMRIP4
	.long	STARMRIP5
	.long	0

STARMRIP1
	.long	STARMRIP1A,STARMRIP1B,STARMRIP1C,0
STARMRIP2
	.long	STARMRIP2A,STARMRIP2B,0
STARMRIP3
	.long	STARMRIP3A,STARMRIP3B,0
STARMRIP4
	.long	STARMRIP4A,STARMRIP4B,0
STARMRIP5
	.long	STARMRIP5A,STARMRIP5B,0

;**************************************************************************

a_rd_arms_ripped
	.long	RDARMLESS1
	.long	RDARMLESS2
	.long	RDARMLESS3
	.long	RDARMLESS4
	.long	RDARMLESS5
	.long	RDARMLESS6
	.long	RDARMLESS7
	.long	0

RDARMLESS1
	.long	RDARMLESS1A,RDARMLESS1B,RDARMLESS1C,0
RDARMLESS2
	.long	RDARMLESS2A,RDARMLESS2B,0
RDARMLESS3
	.long	RDARMLESS3A,RDARMLESS3B,0
RDARMLESS4
	.long	RDARMLESS4A,RDARMLESS4B,0
RDARMLESS5
	.long	RDARMLESS5A,RDARMLESS5B,0
RDARMLESS6
	.long	RDARMLESS6A,RDARMLESS6B,0
RDARMLESS7
	.long	RDARMLESS7A,RDARMLESS7B,0

;**************************************************************************

a_nj_arms_ripped
	.long	NJARMRIP1
	.long	NJARMRIP2
	.long	NJARMRIP3
	.long	NJARMRIP4
	.long	NJARMRIP5
	.long	0

NJARMRIP1
	.long	NJARMRIP1A,NJARMRIP1B,NJARMRIP1C,0
NJARMRIP2
	.long	NJARMRIP2A,NJARMRIP2B,0
NJARMRIP3
	.long	NJARMRIP3A,NJARMRIP3B,0
NJARMRIP4
	.long	NJARMRIP4A,NJARMRIP4B,0
NJARMRIP5
	.long	NJARMRIP5A,NJARMRIP5B,0

;**************************************************************************

a_jx_arms_ripped
	.long	JXARMLESS1
	.long	JXARMLESS2
	.long	JXARMLESS3
	.long	JXARMLESS4
	.long	JXARMLESS5
	.long	JXARMLESS6
	.long	JXARMLESS7
	.long	0

JXARMLESS1
	.long	JXARMLESS1A,JXARMLESS1B,JXARMLESS1C,0
JXARMLESS2
	.long	JXARMLESS2A,JXARMLESS2B,0
JXARMLESS3
	.long	JXARMLESS3A,JXARMLESS3B,0
JXARMLESS4
	.long	JXARMLESS4A,JXARMLESS4B,0
JXARMLESS5
	.long	JXARMLESS5A,JXARMLESS5B,0
JXARMLESS6
	.long	JXARMLESS6A,JXARMLESS6B,0
JXARMLESS7
	.long	JXARMLESS7A,JXARMLESS7B,0

;**************************************************************************

a_snowball
	.long	SBALL1
	.long	SBALL2
	.long	SBALL3
	.long	SBALL4
	.long	SBALL5
	.long	SBALL6
	.long	0

	.long	SBALL7
	.long	SBALL8
	.long	SBALL9
	.long	SBALL10
	.long	0

jsnow	.long	SBALL10
	.long	SBALL11
	.long	ani_jump,jsnow
	.long	0

	.long	SBALL12
	.long	SBALL13
	.long	SBALL14
	.long	SBALL15
	.long	SBALL16
	.long	SBALL17
	.long	0

SBALL1	.long	SNOWBALL1,0
SBALL2	.long	SNOWBALL2,0
SBALL3	.long	SNOWBALL3,0
SBALL4	.long	SNOWBALL4,0
SBALL5	.long	SNOWBALL5,0
SBALL6	.long	SNOWBALL6,0
SBALL7	.long	SNOWBALL7,0
SBALL8	.long	SNOWBALL8,0
SBALL9	.long	SNOWBALL9,0
SBALL10	.long	SNOWBALL10,0
SBALL11	.long	SNOWBALL11,0
SBALL12	.long	SNOWBALL12,0
SBALL13	.long	SNOWBALL13,0
SBALL14	.long	SNOWBALL14,0
SBALL15	.long	SNOWBALL15,0
SBALL16	.long	SNOWBALL16,0
SBALL17	.long	SNOWBALL17,0

;**************************************************************************

	.end
