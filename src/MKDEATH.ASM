**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: death blows										*
* 											     *
*  copyright (c) 1993 midway manufacturing							*
*											     *
**************************************************************************
	.file	'mkdeath.asm'
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
	.include	mkfatal.tbl
	.include	mksplit.tbl
	.include	mkmk3.tbl
	.include	imgtbl.glo
	.text

db1_table
	.long	do_split_in_2		;  0 - hat head
	.long	do_dragon		;  1 - kang
	.long	do_rip			;  2 - cage rip torso off
	.long	do_decap		;  3 - sword arms
	.long	do_kiss			;  4 - female ninja #1
	.long	do_psycho_stab		;  5 - female ninja #2
	.long	do_drain		;  6 - shang tsung
	.long	do_raiden_fry		;  7 - raiden frying the otherguy
	.long	do_shatter_punch	;  8 - 
	.long	do_tongue		;  9 - reptile toungue thing
	.long	do_scortch		; 10 - scorpion scortch
	.long	do_clap			; 11 - jax head clap

db2_table
	.long	do_hat_decap		;  0 - hat head
	.long	do_wheel_kick		;  1 - kang
	.long	do_head_pop1		;  2 - cage
	.long	do_impale		;  3 - sword arms
	.long	do_fan_decap		;  4 - female ninja #1
	.long	do_body_suck		;  5 - female ninja #2
	.long	do_st_dive		;  6 - shang tsung
	.long	do_raiden_punch		;  7 - raiden explosion punch
	.long	do_pitch		;  8 - 
	.long	do_inviso_kill		;  9 - 
	.long	do_spear_swipe		; 10	-
	.long	do_arm_rip		; 11	-

**************************************************************************

null_death_blow
	calla	stop_me

local_wait_forever
	jauc	wait_forever

**************************************************************************

do_kintaro_fatal
	movk	1,a0
	movk	3,a1
	callr	init_death_blow

	movi	>0d,a9
	calla	get_char_ani2
	movk	4,a14
	calla	find_part_a14
	calla	find_last_frame
	calla	do_next_a9_frame

	movi	>0004000a,a0
	movk	3,a1
	move	a8,a10
	jsrp	shake_him_up
	jsrp	white_flash

	tsound	>68
	create	pid_fx,baby_flash
	create	pid_fx,baby_poof
	move	a8,*a0(pa10),l

	sleep	>0b
	move	a8,a0
	calla	clear_inviso

;*************
	movk	ft_goro,a0
	move	a0,*a8(ochar),w
	clr	a9
	calla	get_char_ani
	move	*a9,a0,l
	move	*a0,a0,l
	move	*a0(icmap),a0,l
	calla	player_swpal
	move	*a8(oypos),a0,w
	subi	>0c,a0
	move	a0,*a8(oypos),w
	movk	7,a9
	calla	get_char_ani
	calla	do_next_a9_frame
	movi	ft_st,a0
	move	a0,*a8(ochar),w		; keep shang ochar
;*************

	sleep	10

	tsound	>ad			; roar !

	movk	3,a0
	jsrp	mframew
	sleep	10
	movk	3,a0
	jsrp	mframew
	sleep	10

;*************
	movk	ft_goro,a0
	move	a0,*a8(ochar),w
	movk	3,a9
	calla	get_char_ani
	movi	ft_st,a0
	move	a0,*a8(ochar),w		; keep shang ochar
;*************

	movk	3,a0
	jsrp	mframew

	movi	>00080008,a11
	calla	shake_a11

	movi	r_screwed_by_goro,a7
	calla	takeover_him

	sleep	>40
	movk	10,a0
	jsrp	mframew

	callr	death_blow_complete

;*************
	movk	ft_goro,a0
	move	a0,*a8(ochar),w
	movi	>0d,a9
	calla	get_char_ani
	movi	ft_st,a0
	move	a0,*a8(ochar),w		; keep shang ochar
;*************

	movk	3,a0
	jsrp	mframew
	jauc	wait_forever


r_screwed_by_goro
	calla	face_opponent

	tsound	>1b
	calla	disturbing_scream		; ahhh !!!

	move	a8,a10
	movi	>39,a9
	calla	get_char_ani
	movk	6,a14
	calla	find_part_a14			; legz
	calla	gmo_proc
	move	*a10(ochar),*a8(ochar),w
	move	*a10(oid),*a8(oid),w
	move	*a10(oflags2),*a8(oflags2),w

	callr	a8_to_bloody_pal
	push	a8
	move	a8,a0				; a0 = multipart object
	move	a10,a8				; a8 = him
	calla	match_ani_points
	pull	a8

	calla	insobja8
	movk	7,a0
	calla	create_blood_proc
	jreq	rgorod3
	move	a8,*a0(pa11),l
rgorod3	move	a10,a8

	move	*a13(p_ganiy),a0,w
	addi	>40,a0
	move	a0,*a13(p_ganiy),w		; adjust to ground

	movi	>41,a9
	calla	get_char_ani
	calla	change_to_bloody_pal
	calla	do_next_a9_frame
	subi	32,a9

	movi	>60000,a0
	movi	->80000,a1
	movi	>6000,a2
	movk	4,a3
	jsrp	flight

	calla	shake_n_sound
	jauc	wait_forever

**************************************************************************

do_inviso_kill
	movk	1,a0
	movk	2,a1
	callr	init_death_blow

	calla	am_i_joy
	jrc	dikil3
	move	*a8(oflags2),a4,w
	btst	b_inviso,a4			; already invisible
	jrne	dikil3

	jsrp	do_inviso

dikil3	movi	pid_inviso1,a0
	movi	pid_inviso2,a1
	calla	p1p2_pick
	calla	dallprc				; no need for interuptions !!!
	sleep	>30

	move	a8,a0
	calla	set_inviso

	movi	r_second_swipe,a7
	calla	takeover_him
	tsound	>56				; crunch sound	
	sleep	>40

	callr	death_blow_complete
	move	a8,a0
	calla	clear_inviso
	jauc	victory_animation

**************************************************************************

do_fan_decap
	movk	1,a0
	movk	2,a1
	callr	init_death_blow

	movk	3,a9
	calla	get_char_ani2
	calla	do_next_a9_frame
	sleep	>30

	movk	4,a0
	jsrp	mframew			; slice !!

	movi	rsnd_death_voice,a0
	calla	calla_for_him
	tsound	>44			; sword slice sound
	movi	decap_fall,a7
	calla	takeover_him_sr

	movk	4,a0
	jsrp	mframew
	sleep	>30

	callr	death_blow_complete
	jauc	victory_animation

**************************************************************************

do_spear_swipe
	movk	1,a0	 		; fade = yes
	movk	2,a1	 		; fatality #
	callr	init_death_blow

	movk	5,a9
	calla	get_char_ani2

	push	a9
	calla	do_next_a9_frame
	movk	6,a9
	calla	get_char_ani2
	move	a9,a11
	calla	get_proj_obj_m
	move	a10,a0
	calla	insobj			; get spear object
	pull	a9
	sleep	>10			; dramatic pause

	movk	3,a0
	jsrp	double_mframew		; swipe !!!

	push	a10
	movi	r_first_swipe,a7
	calla	takeover_him
	pull	a10

	sleep	>10

	movk	3,a0
	jsrp	double_mframew
	sleep	>10
*
* frame sans spear
*
	pushp	a9
	movk	5,a9
	calla	get_char_ani2
	movk	5,a14
	calla	find_part_a14		; frame 6
	calla	do_next_a9_frame

	move	a10,a0
	calla	set_inviso		; turn off spear
	sleep	3
	move	a10,a0
	calla	clear_inviso		; turn spear back on
	pullp	a9

	movk	3,a0
	jsrp	double_mframew

	push	a10
	movi	r_second_swipe,a7
	calla	takeover_him
	pull	a10

	sleep	>18

	callr	death_blow_complete
	movk	8,a0
	jsrp	double_mframew

	calla	delete_slave		; no more need for this spear
	jauc	victory_animation


r_first_swipe
	tsound	>44			; sword slice sound
	calla	rsnd_wasted_voice

	move	a8,a11
	movi	>10,a0
	calla	create_blood_proc

	movi	>37,a9
	calla	get_char_ani
	movi	4,a0
	jsrp	mframew				; stumble sans moving
	jauc	wait_forever

r_second_swipe
	calla	face_opponent
	tsound	>44				; sword slice sound
	tsound	>56				; crunch sound

	calla	rsnd_death_voice

	move	a8,a10
	movi	>39,a9
	calla	get_char_ani
	movk	6,a14
	calla	find_part_a14			; legz
	calla	gmo_proc
	move	*a10(ochar),*a8(ochar),w
	move	*a10(oid),*a8(oid),w
	move	*a10(oflags2),*a8(oflags2),w

	callr	a8_to_bloody_pal
	push	a8
	move	a8,a0				; a0 = multipart object
	move	a10,a8				; a8 = him
	calla	match_ani_points
	pull	a8

	calla	insobja8
	movk	7,a0
	calla	create_blood_proc
	jreq	swp3
	move	a8,*a0(pa11),l
swp3	move	a10,a8

	move	*a13(p_ganiy),a0,w
	addi	>40,a0
	move	a0,*a13(p_ganiy),w		; adjust to ground

	movi	>41,a9
	calla	get_char_ani
	calla	change_to_bloody_pal
	calla	do_next_a9_frame
	subi	32,a9

	movi	->30000,a0
	movi	->80000,a1
	movi	>6000,a2
	movk	4,a3
	jsrp	flight

	calla	shake_n_sound
	jauc	wait_forever

**************************************************************************

do_hat_decap
	movk	1,a0	 		; fade = yes
	movk	2,a1	 		; fatality #
	callr	init_death_blow

	movi	act_hat_killer,a0
	move	a0,*a13(p_stk),w	; flag: decap

	movi	>26,a9
	calla	do_first_a9_frame	; frame #1
	sleep	6	      		; windup time !

	clr	a0
	move	a0,@f_death,w		; must prove this fatality
	clr	a10
	jsrp	do_zap

	sleep	>40

	move	@f_death,a0,w
	jane	victory_animation	; success ---> victory animation
	jruc	fatality_cancell

**************************************************************************

do_pitch
	movk	1,a0	 		; fade = yes
	movk	2,a1	 		; fatality #
	callr	init_death_blow

	movk	4,a9
	calla	get_char_ani2
	calla	do_next_a9_frame
	sleep	8

	push	a9
	movi	a_snowball,a9
	move	a9,a11
	calla	get_proj_obj_m
	move	a10,a0
	calla	insobj
	pull	a9

	tsound	>82

	movk	4,a9
	calla	get_char_ani2
	movk	4,a0
	jsrp	double_mframew
	sleep	>10

	movk	3,a0
	jsrp	double_mframew
	movi	pitch_proc,a7
	calla	spawn_proj_proc
	sleep	>50
	callr	death_blow_complete
	sleep	>20
	jauc	victory_animation


pitch_proc
	tsound	>6a

	movi	>80000,a0
	calla	set_proj_vel

	movi	a_snowball,a9
	calla	find_part2
	calla	find_part2
	movk	3,a0
	calla	init_anirate
	movi	>60,a10

pitch3	sleep	1
	calla	next_anirate
	dsj	a10,pitch4
	jauc	delete_proj_and_die	; offscreen = delete
pitch4	move	*a13(p_otherguy),a0,l
	move	*a0(oxpos),a0,w
	move	*a8(oxpos),a1,w
	sub	a0,a1
	abs	a1
	cmpi	>60,a1
	jrhi	pitch3
*
* pitch hit
*
	calla	stop_a8
	push	a8
	move	a8,a0
	move	*a13(p_otherguy),a8,l
	calla	match_ani_points
	pull	a8

	movi	r_pitched,a7
	calla	takeover_him

	calla	flip_multi
	movi	->60,a0
	clr	a1
	calla	multi_adjust_xy
	movi	a_snowball,a9
	movk	4,a14
	calla	find_part_a14
	movk	2,a0
	jsrp	mframew				; thoooonk, ani
	jauc	delete_proj_and_die	; offscreen = delete

**************************************************************************

do_down_the_pit
	clr 	a0				; fade = NO !!
	movk	pit_fatality,a1			; fatality #
	callr	init_death_blow

	jsrp	do_duck
	sleep	>10

	move	*a13(p_otherproc),a0,l
	movi	act_pit_fall,a1
	move	a1,*a0(p_action),w		; tell him the deal
	jsrp	do_uppercut
	jauc	wait_forever


do_up_the_spike
	clr 	a0				; fade = NO !!
	movk	spike_fatality,a1  		; fatality #
	callr	init_death_blow

	jsrp	do_duck
	sleep	>10

	move	*a13(p_otherproc),a0,l
	movi	act_spike_rise,a1
	move	a1,*a0(p_action),w		; tell him the deal
	jsrp	do_uppercut

	callr	death_blow_complete
	movk	1,a0
	move	a0,@f_pit_fall,w		; flag: fallen down pit
	jauc	victory_animation

**************************************************************************

do_arm_rip
	movk	1,a0				; fade = yes
	movk	2,a1				; fatality #
	callr	init_death_blow
	callr	disable_repell
	sleep	>20

	callr	eliminate_edge_limits	; make sure things lineup !!

	movk	6,a9
	calla	get_char_ani2
	movk	4,a0
	jsrp	mframew

	movi	r_arms_ripped,a7
	calla	takeover_him

	sleep	>30				; pause with arms stretched out

	tsound	>56				; sound: arms getting ripped off
	movi	>000a000a,a11
	calla	shake_a11			; shake the world to be cool
	movi	r_arms_ripped2,a7
	calla	takeover_him

	push	a8
	movi	ochar_flyin_arms,a0
	calla	get_his_char_long
	move	a0,a11
	callr	get_arm_object

	clr	a0
	move	a0,*a8(ozpos),w			; arm #2 = behind
	move	a8,*a13(p_store2),l
	callr	get_arm_object

	move	a8,*a13(p_store1),l
	movk	1,a0
	move	a0,*a8(ozpos),w			; arm #1 = front
	move	a8,a10
	move	a10,a0
	pull	a8

	move	a8,a1
	move	*a13(p_store1),a0,l
	calla	lineup_1pwm
	calla	insobj

	move	a8,a1
	move	*a13(p_store2),a0,l
	calla	lineup_1pwm
	calla	insobj

	move	*a13(p_store2),a1,l
	move	*a1(oypos),a0,w
	subk	5,a0
	move	a0,*a1(oypos),w			; adjust arm #2 a bit
*
* animate with arms in hand !!
*
	jsrp	ani_with_arms
	jsrp	ani_with_arms
	jsrp	ani_with_arms
	jsrp	ani_with_arms

	push	a8
	move	*a13(p_store2),a8,l
	movk	5,a0
	movi	-5,a1
	calla	multi_adjust_xy
	pull	a8

	jsrp	ani_with_arms
	movk	3,a0
	jsrp	mframew
	callr	death_blow_complete
	jauc	wait_forever



get_arm_object
	move	*a11,a5,l
	calla	gso_dmawnz  		; arm #2
	movi	KT2BLUD_P,a7
	movi	ft_fn2,a0
	calla	is_he_him
	jreq	arm1
	clr	a7
arm1	move	a7,a0	    		; special case pal change ?
	jreq	arm3	    		; nope.
	calla	swpal	    		; yes, switcheroo
arm3	rets


ani_with_arms
	calla	do_next_a9_frame	; animate me (jax)
	mmtm	sp,a8,a9
	move	*a13(p_store1),a8,l
	callr	ani_1_arm
	move	*a13(p_store2),a8,l
	callr	ani_1_arm
	move	a9,a11
	mmfm	sp,a8,a9
	sleep	4
	retp

ani_1_arm
	move	a11,a9
	jauc	frame_a9    		; animate arm

;xxx
arm_ripped_adjust
	.word	->90,->08
	.word	->90,>06
	.word	->90,>00
	.word	->70,>00

	.word	->78,>0a
	.word	->78,>0a
	.word	->80,>0a
	.word	->80,>00

	.word	->90,>0a
	.word	->90,>0a
	.word	->90,>0a
	.word	->90,>04

	.word	->90,>00
	.word	->90,>00
	.word	->90,>00
	.word	->90,>00


r_arms_ripped
	movi	ochar_arm_ripped_ani,a0
	calla	get_char_long
	move	a0,a9
	calla	do_next_a9_frame
	calla	match_me_with_him
	calla	flip_multi
	calla	change_to_bloody_pal

	movi	arm_ripped_adjust,a0
	calla	get_char_long
	move	a0,a1
	zext	a0,w
	srl	16,a1
	calla	multi_adjust_xy
	jauc	wait_forever


r_arms_ripped2
	calla	do_next_a9_frame		; hold 1st frame for a bit
	calla	ground_player
	movk	>0e,a0
	calla	create_blood_proc

	movi	>00030004,a0
	movk	2,a1
	move	a8,a10
	jsrp	shake_him_up
	calla	disturbing_scream		; ahhh !!!
	movi	>00030004,a0
	movk	2,a1
	move	a8,a10
	jsrp	shake_him_up

	sleep	>30
	movk	6,a0
	jsrp	mframew

	movk	3,a10
armgush3	movk	>0f,a0
	calla	create_blood_proc
	sleep	>36
	dsj	a10,armgush3
	jauc	wait_forever


ochar_flyin_arms
	.long	a_hh_arm_fly
	.long	a_lk_arm_fly
	.long	a_jc_arm_fly
	.long	a_sa_arm_fly

	.long	a_fn_arm_fly
	.long	a_fn_arm_fly
	.long	a_st_arm_fly
	.long	a_rd_arm_fly

	.long	a_nj_arm_fly
	.long	a_nj_arm_fly
	.long	a_nj_arm_fly
	.long	a_jx_arm_fly

a_rd_arm_fly
a_hh_arm_fly
	.long	HHRIPARM1
	.long	HHRIPARM2
	.long	HHRIPARM3
	.long	HHRIPARM4
	.long	HHRIPARM5
	.long	0

a_lk_arm_fly
	.long	LKRIPARM1
	.long	LKRIPARM2
	.long	LKRIPARM3
	.long	LKRIPARM4
	.long	LKRIPARM5
	.long	0

a_jc_arm_fly
	.long	CAGERIPARM1
	.long	CAGERIPARM2
	.long	CAGERIPARM3
	.long	CAGERIPARM4
	.long	CAGERIPARM5
	.long	0

a_sa_arm_fly
	.long	UGRIPARM1
	.long	UGRIPARM2
	.long	UGRIPARM3
	.long	UGRIPARM4
	.long	UGRIPARM5
	.long	0

a_fn_arm_fly
	.long	NJGIRLARM1
	.long	NJGIRLARM2
	.long	NJGIRLARM3
	.long	NJGIRLARM4
	.long	NJGIRLARM5
	.long	0

a_st_arm_fly
	.long	TSRIPARM1
	.long	TSRIPARM2
	.long	TSRIPARM3
	.long	TSRIPARM4
	.long	TSRIPARM5
	.long	0


a_nj_arm_fly
	.long	NJRIPARM1
	.long	NJRIPARM2
	.long	NJRIPARM3
	.long	NJRIPARM4
	.long	NJRIPARM5
	.long	0

a_jx_arm_fly
	.long	JXRIPARM1
	.long	JXRIPARM2
	.long	JXRIPARM3
	.long	JXRIPARM4
	.long	JXRIPARM5
	.long	0

**************************************************************************

do_raiden_fry
	movk	1,a0			; fade = yes
	movk	2,a1			; fatality #
	callr	init_death_blow

	movk	3,a9
	calla	get_char_ani2
	movk	1,a0
	jsrp	mframew			; hold 1st frame for a sec...

	sleep	>20

	movi	wait_forever,a7
	calla	takeover_him
	calla	shocker_lineup

	move	*a13(p_otherguy),a11,l
	movi	raiden_smoke_squeeze,a10
	create	pid_smoker,smoke_a_guy

	movk	2,a0
	move	a0,*a13(p_store8),w
	tsound	>c7				; super zap sound
	movk	3,a11
	jsrp	shocker_shaker			; 3 times sans button requirement

	movk	7,a0
fry4	move	a0,*a13(p_anicount),w
	movk	1,a11
	jsrp	shocker_shaker

	move	*a13(p_store8),a0,w
	dsj	a0,fry5
	tsound	>c7				; super zap sound
	movk	2,a0
fry5	move	a0,*a13(p_store8),w

	calla	am_i_joy
	jrnc	fry6

	movi	l_lk,a0
	calla	get_tsl
	cmpi	10,a1				; still - a - bangin ???
	jrhi	fry_cancell
	movi	l_block,a0
	calla	get_tsl
	cmpi	10,a1				; still - a - bangin ???
	jrhi	fry_cancell

fry6	move	*a13(p_anicount),a0,w
	dsj	a0,fry4

	movi	r_shocker_pop,a7
	calla	takeover_him
*
* kill every form of smoke !!
*
	movi	oid_1_puff,a0
	calla	dallobj
	movi	pid_1_puff,a0
	calla	dallprc
	movi	pid_smoker,a0
	calla	dallprc			; stop smoker

	jsrp	raiden_post_shock
	callr	death_blow_complete
	jauc	victory_animation


raiden_post_shock
	movk	3,a9
	calla	get_char_ani2
	movk	4,a0
	jsrp	mframew			; hold 1st frame for a sec...
	sleep	>30
	retp


fry_cancell
	movi	rd_cacell_victum,a7
	calla	takeover_him
	clr	a1
	move	a1,@f_death,w	  	; cacell the party !!!
	movi	pid_smoker,a0
	calla	dallprc			; stop smoker

fatality_cancell
	clr	a1
	not	a1
	movi	pid_master,a0
	calla	existp
	jreq	fryc4

	move	*a0(pwake),a1,l
	cmpi	wait_fatality_finish,a1	; waiting for me ?
	jrne	fryc4
	movi	finish_him_exit,a7
	move	a7,*a0(pwake),l			; yes, no need to wait no moe

fryc4	jauc	victory_animation


rd_cacell_victum
	clr	a0
	clr	a1
	movi	>6000,a2			; a2 = gravity
	movk	5,a3				; a3 = ani speed
	jsrp	fall_on_my_back
	jauc	wait_forever


fried_big_time
	movi	act_shock_sd,a1
	move	a1,*a13(p_action),w	; so he cant shock me again
	clr	a0
	clr	a1
	movi	>6000,a2	   	; a2 = gravity
	movk	5,a3		   	; a3 = ani speed
	jauc	fall_on_my_back

raiden_smoke_squeeze
	move	a1,a14
	sub	a0,a14		; a14 = width	
	srl	2,a14 		; a14 = 1/4 width
	add	a14,a0
	sub	a14,a1
	subi	>20,a3
	rets

**************************************************************************

do_shatter_punch
	calla	am_i_joy
	jrc	shat3
*
* drone = freeze 'em first
*
	calla	get_x_dist
	cmpi	>80,a3
	jrhi	shat1

	calla	get_my_dfe
	cmpi	>90,a5
	jrlo	do_pitch
	cmpi	>90,a6
	jrlo	do_pitch

	movi	>90,a11
	jsrp	drone_retreat
shat1	jsrp	throw_arctic_blast
	movi	>48,a11
	jsrp	drone_approach

	movi	is_he_super_frozen,a11
	movi	>30,a10
	jsrp	stance_wait_yes
	callr	is_he_super_frozen
	janc	victory_animation

shat3	movk	1,a0			; fade = yes
	movk	2,a1			; fatality #
	callr	init_death_blow
	movi	>00040005,a9
	jsrp	animate_a9
	sleep	6

	move	*a13(p_otherproc),a0,l
	movi	act_pre_shatter,a1
	move	a1,*a0(p_action),w	; let him know he's gonna shatter
	jsrp	do_uppercut
	callr	death_blow_complete
	jauc	victory_animation

is_he_super_frozen
	move	*a13(p_otherproc),a0,l
	move	*a0(pwake),a0,l
	cmpi	super_frozen,a0
	jreq	ihsfy
	clrc
	rets
ihsfy	setc
	rets

**************************************************************************

do_super_freeze
	jsrp	throw_arctic_blast
	jauc	reaction_exit

throw_arctic_blast
	calla	init_special		; i can't block !!

	movi	pid_master,a0
	calla	existp
	jreq	supf4			; a0 = master proc

	move	*a0(pwake),a1,l
	cmpi	fatality_waiting,a1	; waiting for fatality ?
	jrne	supf4			; nope
	movi	>40*3,a2
	move	a2,*a0(pa11),l		; yes, wait a little longer

supf4	movi	>00030026,a9
	jsrp	animate_a9
	tsound	>d7			; arctic blast sound
	movk	6,a10
supf3	create	pid_proj1,super_ice_proc
	move	*a13(p_otherguy),*a0(p_otherguy),l
	move	*a13(p_otherproc),*a0(p_otherproc),l
	sleep	6
	dsj	a10,supf3
	retp



super_ice_proc
	movk	1,a9
	calla	get_char_ani2
	calla	get_proj_obj_m

	move	a10,a5
	movi	>28,a0
	movi	>2d,a1
	calla	adjust_xy_a5		; adjust to subzero's hands !!
	move	a10,a0
	calla	insobj			; put on object list
	move	a10,a8

	movk	3,a0
	jsrp	mframew			; intro part !!
	calla	do_next_a9_frame
	sleep	3
	calla	do_next_a9_frame
	sleep	3

	movk	1,a9
	calla	get_char_ani2		; ice ani
	calla	find_part2
	calla	find_part2

	movi	superice_lcheck,a11
	calla	is_he_right
	jrc	superi4
	movi	superice_rcheck,a11

superi4	movk	4,a0
	calla	init_anirate

superi7	sleep	1
	calla	next_anirate
	calla	proj_onscreen_test
	janc	delete_proj_and_die	; offscreen = delete
	call	a11
	jrnc	superi7

superice_hit
	calla	get_his_action
	cmpi	act_super_froze,a1
	jreq	super4

	movi	r_super_freeze,a7
	calla	takeover_him

super4	calla	stop_a8
	move	*a8(oypos),a14,w
	calla	match_me_with_him
	calla	flip_multi 		; flip ice !
	movi	->90,a0
	clr	a1
	calla	multi_adjust_xy
	move	a14,*a8(oypos),w

	movi	5,a0
	move	a0,*a8(ozpos),w		; proj in front

	movk	1,a9
	calla	get_char_ani2		; ice ani
	calla	find_part2
	calla	find_part2
	movk	4,a0
	jsrp	mframew
	jauc	delete_proj_and_die		; offscreen = delete



superice_rcheck
	calla	leftmost_mpart			; a2
	move	*a13(p_otherguy),a0,l
	move	*a0(oxpos),a0,w
	move	a2,a3
	swap	a0,a3
	jruc	schk3

superice_lcheck
	calla	rightmost_mpart			; a3
	move	*a13(p_otherguy),a0,l
	move	*a0(oxpos),a0,w
schk3	cmp	a0,a3
	jrlt	schk5
	setc
	rets
schk5	clrc
	rets

***************************************************************************

r_super_freeze
	movi	act_super_froze,a1
	move	a1,*a13(p_action),w

	calla	face_opponent
	movi	frozen_stunned,a0
	calla	get_char_word
	move	a0,a7
	movi	>28,a9
	calla	get_char_ani
	sll	5,a7
	add	a7,a9
	calla	do_next_a9_frame

	movk	7,a10
rsupf3	calla	player_froze_pal
	sleep	4
	calla	player_normpal
	sleep	4
	dsj	a10,rsupf3

	move	*a8(oflags2),a1,w
	andni	m_shadow,a1
	move	a1,*a8(oflags2),w		; turn off my shadow

	move	*a8(ochar),a9,w
	cmpi	ft_jax,a9
	jrls	rsupf5
	movi	ft_jax,a9			; in case of fire
rsupf5	sll	5,a9
	addi	super_frozen_poses,a9
	calla	do_next_a9_frame
	movi	FREEZE_P,a0
	calla	player_swpal

rsup9	sleep	40
super_frozen
	jruc	rsup9


frozen_stunned
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


super_frozen_poses
	.long	hh_superf
	.long	lk_superf
	.long	jc_superf
	.long	sa_superf
	.long	fn_superf
	.long	fn_superf
	.long	st_superf
	.long	rd_superf
	.long	nj_superf
	.long	nj_superf
	.long	nj_superf
	.long	jx_superf

hh_superf
	.long	TMFREEZ1B,TMFREEZ1C,TMFREEZ1A,0
lk_superf
	.long	LKFREEZ1B,LKFREEZ1C,LKFREEZ1A,0
jc_superf
	.long	JCFREEZ1B,JCFREEZ1C,JCFREEZ1A,0
sa_superf
	.long	UGFREEZ1B,UGFREEZ1C,UGFREEZ1A,0
fn_superf
	.long	KTFREEZ1B,KTFREEZ1C,KTFREEZ1A,0
st_superf
	.long	STFREEZ1B,STFREEZ1C,STFREEZ1A,0
rd_superf
	.long	RNFREEZ1B,RNFREEZ1C,RNFREEZ1A,0
nj_superf
	.long	NJFREEZ1B,NJFREEZ1C,NJFREEZ1A,0
jx_superf
	.long	JXFREEZ1B,JXFREEZ1C,JXFREEZ1A,0


r_shatter_punch
	tsound	>d8			; sz shatter sound
	calla	rsnd_death_voice

	movi	>00080008,a11
	calla	shake_a11

	create	pid_fx,super_freeze_bang

	movi	FREEZE_P,a0
	calla	player_swpal
	move	*a8(ochar),a9,w
	sll	5,a9
	addi	frozen_legs,a9
	calla	do_next_a9_frame
	jauc	wait_forever


frozen_legs
	.long	hh_frozen_legs
	.long	lk_frozen_legs
	.long	jc_frozen_legs
	.long	sa_frozen_legs
	.long	fn_frozen_legs
	.long	fn_frozen_legs
	.long	st_frozen_legs
	.long	rd_frozen_legs
	.long	nj_frozen_legs
	.long	nj_frozen_legs
	.long	nj_frozen_legs
	.long	jx_frozen_legs

hh_frozen_legs
	.long	JCFREEZ1B,JCFREEZ1C,0

lk_frozen_legs
	.long	LKFREEZ1B,LKFREEZ1C,0

jc_frozen_legs
	.long	JCFREEZ1B,JCFREEZ1C,0

sa_frozen_legs
	.long	UGFREEZ1B,UGFREEZ1C,0

fn_frozen_legs
	.long	KTFREEZ1B,KTFREEZ1C,0

st_frozen_legs
	.long	STFREEZ1B,STFREEZ1C,0

rd_frozen_legs
	.long	RNFREEZ1B,RNFREEZ1C,0

nj_frozen_legs
	.long	NJFREEZ1B,NJFREEZ1C,0

jx_frozen_legs
	.long	JXFREEZ1B,JXFREEZ1C,0

**************************************************************************

do_st_dive
	movk	8,a0
	calla	randper
	jrc	do_kintaro_fatal   	; every blue moon !!

	movk	1,a0			; fade = yes
	movk	2,a1			; fatality #
	callr	init_death_blow

	callr	disable_repell

	movi	>0d,a9
	calla	get_char_ani2
	movk	4,a0
	jsrp	mframew			; wind back !!

	calla	match_me_with_him
	calla	flip_multi
	movi	burst_distance_offset,a0
	calla	get_his_char_long
	move	a0,a1
	zext	a0,w
	sra	16,a1
	neg	a0
	calla	multi_adjust_xy		; lineup so I fly into his mouth/face

	movi	pre_burst_poses,a0
	jsrp	dizzy_wait

	tsound	>c9			; suck sound

	movi	>0d,a9
	calla	get_char_ani2
	calla	find_part2
	movk	3,a0
	jsrp	mframew			; start squeeze
	movi	r_burst_shake1,a7
	calla	takeover_him
	movk	3,a0
	jsrp	mframew			; finish squeeze
*
* him = 1st frame of inflate
*
	move	a8,a0
	calla	set_inviso
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l
	calla	inflate_pose
	calla	rsnd_wasted_voice	; speech for him/her: ahh !!!
	mmfm	sp,a8,a13
	sleep	8
*
* shake him up alot !!
*
	tsound	>a3			; rumble sound

	movi	>00030006,a0
	movk	3,a1
	move	*a13(p_otherguy),a10,l
	jsrp	shake_him_up
	movi	>00050008,a0
	movk	3,a1
	jsrp	shake_him_up
	movi	>00070008,a0		; shake till I am xfered elsewhere
	movk	3,a1
	jsrp	shake_him_up
*
* xfer him ---> explode
*
	movi	r_burst_pop,a7
	calla	takeover_him
	sleep	4			; wait for screen 2 go white

	clr	a0
	move	a0,*a8(ozpos),w		; me = behind chunks
	move	a8,a0
	calla	clear_inviso
	calla	match_me_with_him
	calla	ground_player
	movi	>0d,a9
	calla	get_char_ani2
	calla	find_part2
	calla	find_part2
	calla	find_part2		; bursting out part
	calla	do_next_a9_frame
	sleep	5			; hold 1st frame for a bit

	movk	3,a0
	jsrp	mframew
	callr	death_blow_complete
	jauc	wait_forever

pre_burst_poses
	.word	>20
	.word	>c0
	.word	>40
	.word	>20

	.word	>20
	.word	>20
	.word	>20
	.word	>40

	.word	>e0
	.word	>e0
	.word	>e0
	.word	>c0

burst_distance_offset
	.word	>5f,>10
	.word	>5d,>10
	.word	>50,>13
	.word	>5f,>10

	.word	>58,>0d
	.word	>58,>0d
	.word	>5c,>10
	.word	>6a,>0e

	.word	>64,>07
	.word	>64,>07
	.word	>64,>07
	.word	>7d,>10

r_burst_shake1
	calla	center_around_me

	movi	>00030006,a0
	movk	3,a1
	move	a8,a10
	jsrp	shake_him_up
	jauc	wait_forever

**************************************************************************

do_raiden_punch
	movk	1,a0			; fade = yes
	movk	2,a1			; fatality #
	callr	init_death_blow

	jsrp	do_duck
	sleep	>30			; pause a bit

	movi	>0002001c,a9
	jsrp	animate_a9
	movi	r_raiden_superp,a7
	calla	takeover_him

	movi	>0008000c,a11
	calla	shake_a11
	sleep	>30
	movk	4,a0
	jsrp	mframew
	sleep	>30

	callr	death_blow_complete
	jauc	victory_animation

**************************************************************************

do_head_pop1
	clr	a0
	move	a0,*a13(p_store3),w

	movk	1,a0			; fade = yes
	movk	2,a1			; fatality #
	callr	init_death_blow

	movk	1,a5
pop3	move	a5,*a13(p_store1),w

	jsrp	do_duck
	sleep	>30			; pause a bit

	move	*a13(p_store3),a0,w
	jrne	pop1

	calla	am_i_joy
	jrc	pop4

	movi	30,a0
	calla	randper
	jrnc	pop1
	jruc	pop5

pop4	calla	is_stick_down
	jrnc	pop1

	movk	1,a0
	move	a0,*a13(p_store3),w	; go through this routine only once
	move	a13,*a13(p_store4),l
	movi	p1b2,a0
	movi	p1b1|p1b4,a1
	movi	p2b2,a2
	movi	p2b1|p2b4,a3
	calla	button_bit_check
	jrnc	pop1

pop5	movk	3,a5
	move	a5,*a13(p_store1),w
	movk	1,a0
	move	a0,*a13(p_store3),w	; go through this routine only once

pop1	movi	>0002001c,a9
	jsrp	animate_a9
	movi	cage_poped_fall,a7
	calla	takeover_him

	tsound	>55
	movi	>0008000c,a11
	calla	shake_a11
	sleep	>10

	move	*a13(p_otherproc),a10,l
	move	*a10(pwake),a11,l		; remember where he was !!
	movi	wait_forever,a7
	calla	takeover_him
	move	*a13(p_store1),a5,w
	dsj	a5,pop3
	move	a11,a7
	calla	takeover_him			; restore where he was

	sleep	>20
	movk	2,a0
	jsrp	mframew

	callr	death_blow_complete
	jauc	victory_animation


;r_head_pop
;	movi	>3c,a9
;	calla	get_char_ani
;	calla	do_next_a9_frame
;	calla	change_to_bloody_pal
;	create	pid_head,decapped_head
;	move	a8,*a0(pa10),l
;	jauc	wait_forever

**************************************************************************

do_wheel_kick
	movk	1,a0			; fade = yes
	movk	2,a1			; fatality #
	callr	init_death_blow
	clr	a0
	move	a0,@f_death,w
	sleep	4

	tsound	>2f			; yell

	movk	4,a9
	calla	get_char_ani2

	movi	->80000,a0
	movk	4,a3
	movi	->60000,a1		; initial y vel
	movi	>a000,a2		; a2 = gravity
	jsrp	flight

	calla	get_x_dist
	cmpi	>48,a3
	jrhi	kang_death_miss

	movk	1,a0
	move	a0,@f_death,w

	movi	r_lk_wheel,a7
	calla	takeover_him		; him: getting hit

	tsound	>30			; hit 1 yell
	movk	1,a0	
	move	a0,@f_death,w	 	; flag: death blow success !!
	sleep	4
	movk	4,a9
	calla	get_char_ani2
	calla	find_part2

	movk	4,a0
	jsrp	mframew
	movi	r_lk_wheel,a7
	calla	takeover_him		; him: getting hit
	tsound	>31			; hit 1 yell

	movk	3,a0
	jsrp	mframew
*
* killer uppercut
*
	movk	5,a9
	calla	get_char_ani
	movk	3,a0
	jsrp	mframew			; duck for the killer uppercut
	sleep	8

	calla	me_in_front
	movk	2,a0
	movi	act_uppercut,a1
	movk	>1c,a9
	movk	1,a10
	movi	>16,a11
	move	a11,*a13(p_stk),w
	jsrp	striker

	tsound	>3b			; upcut scream

	callr	death_blow_complete
	sleep	>20
	movk	4,a0
	jsrp	mframew
	jauc	reaction_exit


kang_death_miss
	calla	stop_me
	calla	ground_player
	movk	4,a9
	calla	get_char_ani2
	calla	find_part2
	movk	4,a0
	jsrp	mframew
	jauc	victory_animation

;************************************************************************

r_lk_wheel
	tsound	>1b		; smack !

	calla	face_opponent
	movi	>11,a9
	calla	get_char_ani
	movk	4,a0
	jsrp	mframew		; hit in chest !

	movi	>00060028,a9
	jsrp	animate_a9
	jauc	wait_forever

**************************************************************************
*											     *
*  Hathead splitting the guy in 2							     *
*											     *
**************************************************************************
do_split_in_2
	movk	1,a0
	movk	1,a1
	callr	init_death_blow
	sleep	>20

	movi	a_split_in_2,a9
	movi	>20,a0
	jsrp	mframew			; pause on 1st frame
	tsound	>d6			; split dude in 2 sound
*
* get object for "swipe" part
*
	push	a9
	movi	a_split_swipe,a9
	move	a9,a11
	calla	get_proj_obj_m		; get an object for my face
	move	a10,*a13(p_slave),l	; my responsibility
	move	a10,a0
	calla	match_ani_points	; lineup proj with thrower !
	move	a10,a0
	calla	insobj			; put on object list
	pull	a9

	tsound	>97			; hat slice sound
	movk	4,a0
	jsrp	double_mframew		; slice !!

	mmtm	sp,a10,a11
	movi	r_split_in_2,a7
	calla	takeover_him
	mmfm	sp,a10,a11

	movk	4,a0
	jsrp	double_mframew		; slice part 2 !!

	mmtm	a12,a8,a9
	move	a10,a8
	move	a11,a9
	movk	4,a0
	jsrp	mframew			; finish off the "aura" animation
	mmfm	a12,a8,a9
	calla	delete_slave		; get rid of aura !!

	sleep	>30
	movk	3,a0
	jsrp	mframew			; ta da

	sleep	>20
	callr	death_blow_complete
	jauc	wait_forever

**************************************************************************
*											     *
*  Scorpion scortch the other dude							     *
*											     *
**************************************************************************
do_scortch
	movk	1,a0
	movk	1,a1
	callr	init_death_blow

	tsound	>91			; mask off sound
	movk	3,a9
	calla	get_char_ani2
	movk	5,a0
	jsrp	mframew			; 2 frames sans mask
*
* create an object for my skull head
*
	push	a9
	movk	4,a9
	calla	get_char_ani2
	move	a9,a11
	calla	get_proj_obj_m		; get an object for my face
	move	a10,*a13(p_slave),l	; my responsibility
	move	a10,a0
	calla	match_ani_points	; lineup proj with thrower !
	move	a10,a0
	calla	insobj			; put on object list
	pull	a9

	movk	5,a0
	jsrp	double_mframew		; off goes the mask
	sleep	>10

	movk	5,a0
	jsrp	double_mframew		; lean over
	tsound	>92			; flame spit
	jsrp	scorpion_flame

	sleep	>70

	movk	3,a9
	calla	get_char_ani2
	movk	6,a14
	calla	find_part_a14		; back up facing screen
	movk	5,a0
	jsrp	double_mframew		; backup

	move	*a13(p_store6),a0,w
	jrne	do_toasty

	movi	100,a0
	calla	randper
	jrnc	no_toasty

do_toasty
	create	pid_fx,fx_toasty

no_toasty
	sleep	>20
	callr	death_blow_complete
	jauc	wait_forever

**************************************************************************
*											     *
*  Kang morph to Dragon									     *
*											     *
**************************************************************************
do_dragon
	movk	1,a1
	movk	1,a0
	callr	init_death_blow
	sleep	>30			; dramatic pause !!

	calla	dont_show_scores
	tsound	>94			; morph sound
;	tsound	>8e			; roar

	movk	3,a9
	calla	get_char_ani2
	movk	5,a0
	jsrp	mframew
	sleep	>30

	movk	2,a0
	jsrp	mframew					; ani: chomp !!!

	movk	5,a0
	calla	create_blood_proc
	jreq	drag4
	move	*a13(p_otherguy),*a0(pa11),l	; pass otherguy to blood proc

drag4	movi	>00060008,a11
	calla	shake_a11
	tsound	>8f
	movi	rsnd_wasted_voice,a0
	calla	calla_for_him 			; ahh !!!!!!!!!!!!!!!!

	movi	wait_forever,a7
	calla	takeover_him

	move	*a10(oypos),a14,w
	calla	match_him_with_me_f
	move	a14,*a10(oypos),w		; keep his ground

	movi	->58,a0
	calla	adjust_him_x

	push	a9
	movi	>39,a9
	calla	get_his_char_ani
	movk	6,a14
	calla	find_part_a14
	calla	do_his_next_a9_frame
	calla	him_to_bloody_pal
	pull	a9

	sleep	>30
	movk	5,a0
	jsrp	mframew
	sleep	>20
	callr	death_blow_complete

	tsound	>95				; morph sound

	movk	5,a0
	jsrp	mframew				; back to kang

	calla	player_normpal
	jauc	victory_animation

**************************************************************************
*											     *
*  Jax head clap death blow								     *
*											     *
**************************************************************************
do_clap
	movk	1,a0
	movk	1,a1
	callr	init_death_blow

	movk	2,a9
	calla	get_char_ani2		; ani: clap
	calla	do_next_a9_frame
	sleep	>30			; dramatic pause !!

	movk	2,a0
	jsrp	mframew			; wham !!!

;****************
	tsound2	1			; boom sound
;	movi	>3e9,a3
;	calla	send_code_a3
;****************

	movi	>00060006,a11
	calla	shake_a11
	movk	6,a0
	calla	create_blood_proc

	calla	him_to_bloody_pal
	movi	>3c,a0
	calla	pose_him_a0		; him = decap frame
	calla	match_him_with_me_f
	movi	clapped_lineups,a0
	calla	adjust_him_tbl

	movi	clapped,a7
	calla	takeover_him
	sleep	>80
	movk	6,a0
	jsrp	mframew			; back to normal

	callr	death_blow_complete
	jauc	victory_animation


clapped
	calla	rsnd_death_voice
	sleep	>40
	calla	me_in_back
	movi	>0006003c,a9
	jsrp	animate_a9

	calla	shake_n_sound
	movk	7,a0
	jsrp	mframew			; wobble

	movk	5,a0
	jsrp	mframew			; plop
	calla	shake_n_sound
	jruc	local_wait_forever

clapped_lineups
	.word	->50,>00
	.word	->60,>00
	.word	->60,>00
	.word	->60,>00

	.word	->60,>00
	.word	->60,>00
	.word	->60,>00
	.word	->60,>00

	.word	->60,>00
	.word	->60,>00
	.word	->60,>00
	.word	->60,>00

	.word	->60,>00
	.word	->60,>00
	.word	->60,>00
	.word	->60,>00

**************************************************************************
*											     *
*  Reptile tongue death blow								     *
*											     *
**************************************************************************
do_tongue
	movk	1,a0
	movk	1,a1
	callr	init_death_blow
	movk	5,a9
	calla	get_char_ani2
	calla	do_next_a9_frame
	sleep	>10			; dramatic pause

	callr	eliminate_edge_limits
	movk	5,a0
	jsrp	mframew
	
	push	a9
	movk	6,a9
	calla	get_char_ani2
	calla	find_part2
	calla	find_part2
	move	a9,a11
	calla	get_proj_obj_m		; get an object for my face
	move	a10,*a13(p_slave),l	; my responsibility
	move	a10,a0
	calla	match_ani_points	; lineup proj with thrower !
	move	a10,a0
	calla	insobj			; put on object list
	pull	a9

	movk	5,a0
	jsrp	double_mframew		; finish animation with face obj
	sleep	20

	movk	5,a0
	jsrp	double_mframew		; lean over

	mmtm	a12,a8,a9,a10,a11	; save reptile/face objects/ animations

;	move	a8,*a13(p_store1),l	; save me (reptile)
;	move	a10,*a13(p_store2),l	; save face

*
* make the tongue come out !!
*
	move	a8,a11
	movk	6,a9
	calla	get_char_ani2
	calla	gmo_proc
	move	a0,*a8(oslink),l	; link proc to obj

	move	a8,a10			; a10 = tongue obj
	move	a11,a8			; a8 = reptile obj

	move	a10,a0
	calla	match_ani_points

	movi	front_z+1,a0
	move	a0,*a10(ozval),l
	move	*a8(ochar),*a10(ochar),w

	move	a10,a0
	calla	insobj

	swap	a8,a10

	tsound	>98			; sound: tongue whip

	movk	1,a0
	jsrp	mframew			; shoot out !

	tsound	>55			; sound: tongue stick
;	tsound	>99			; sound: tongue stick
*
* a10 = reptile
*  a8 = tongue
*
	pushp	a8
	move	a8,a11			; a11 = tongue obj
	move	a10,a8			; a8 = reptile obj

	calla	match_him_with_me_f

	move	*a13(p_otherguy),a7,l
	move	*a7(ochar),a7,w
	sll	6,a7
	addi	head_lineups,a7
	move	*a7+,a0,w
	move	*a7+,a1,w
	calla	adjust_him_xy

	move	*a7+,a9,w
	calla	get_his_char_ani
	move	*a7+,a7,w
	add	a7,a9
	calla	do_his_next_a9_frame
	movi	wait_forever,a7
	calla	takeover_him

	sleep	>10
	movi	rsnd_react_voice,a0		; ahh !!
	calla	calla_for_him
	sleep	>10

	movi	rsnd_wasted_voice,a0
	calla	calla_for_him			; ahh !!!!!!!!!!!!!!!!
	tsound	>9a				; sound: rip head off

	movi	tongued_fall,a7
	calla	takeover_him

	move	a11,a8			; a8 = tongue obj
	movk	6,a9
	calla	get_char_ani2
	calla	find_part2

	movi	>3d,a9
	calla	get_his_char_ani
	move	*a9,a5,l
	calla	gso_dmawnz
	move	*a13(p_otherguy),a0,l
	move	*a0(ochar),*a8(ochar),w	; head has same ochar as him
	callr	a8_to_bloody_pal
	movi	front_z+2,a0
	move	a0,*a8(ozval),l
*
* put head at the end of the tongue
*
	move	a8,a10			; a10 = head
	move	a8,a0			; head obj
	move	a11,a8			; a8 = tongue obj
	calla	match_ani_points

	move	a10,a8
	movi	>d0,a0
	movi	>10,a1
	calla	multi_adjust_xy		; to the end of the tongue

	move	a10,a8
	calla	insobja8
	move	a8,a10
	pullp	a8

	movk	6,a9
	calla	get_char_ani2
	calla	find_part2

tproc4	sleep	2
	calla	do_next_a9_frame
	jreq	tproc9

	move	*a8(oflags),a4,w
	btst	b_fliph,a4
	jreq	tproc6
	calla	leftmost_mpart		; a2 = leftmost point
	move	*a10(osizex),a0,w
	srl	1,a0
	add	a0,a2
	move	a2,*a10(oxpos),w	; center the head
	jruc	tproc4

tproc6	calla	rightmost_mpart		; a3 = rightmost point
	move	*a10(osizex),a0,w
	srl	1,a0
	sub	a0,a3
	move	a3,*a10(oxpos),w	; center the head
	jruc	tproc4


tproc9	move	a8,a2
	calla	kmo_proc		; rid of tongue

	clr	a0	
	not	a0
	move	a0,*a10(ozval),l
	move	a10,*a13(p_store1),l	; save head

	mmfm	a12,a8,a9,a10,a11	; get reptile/face objects/ animations
	move	*a13(p_store1),a0,l
	calla	match_ani_points

	move	*a13(p_store1),a5,l
	movi	>20,a0
	movi	>15,a1
	calla	adjust_xy_a5		; put head right in reptiles mouth
*
* chomp !!
*

	movk	2,a0
	jsrp	double_mframew		; CHOMP !!!
	move	*a13(p_store1),a0,l
	calla	delobjp			; rid of head
	tsound	>9b	    		; sound: bite
	sleep	>20
*
* yummy !
*
	callr	death_blow_complete

	tsound	>84			; speech: yum

	movk	3,a0
tproca	move	a0,*a13(p_anicount),w
	mmtm	a12,a9,a11
	movk	8,a0
	jsrp	double_mframew		; yum
	mmfm	a12,a9,a11
	move	*a13(p_anicount),a0,w
	dec	a0
	jrne	tproca

	jauc	wait_forever


offset_a8_off_a10
	move	*a10(oxpos),a2,w
	add	a0,a2
	move	a2,*a8(oxpos),w
	move	*a10(oypos),a2,w
	add	a1,a2
	move	a2,*a8(oypos),w
	rets


head_lineups
	.word	->bd,->08,>10,>20
	.word	->c5,>00,>10,>20
	.word	->b7,->08,>10,>20
	.word	->b3,->05,>10,>20

	.word	->c1,->05,>10,>00
	.word	->c1,->05,>10,>00
	.word	->b3,->04,>10,>20
	.word	->c0,->05,>10,>20

	.word	->bb,>00,>10,>20
	.word	->bb,>00,>10,>20
	.word	->bb,>00,>10,>20
	.word	->b8,->05,>10,>20

	.word	->b8,->05,>10,>20
	.word	->b8,->05,>10,>20
	.word	->b8,->05,>10,>20
	.word	->b8,->05,>10,>20

**************************************************************************
*											     *
*  Cage torso rip									     *
*											     *
**************************************************************************
do_rip
	movk	1,a0
	movk	1,a1
	callr	init_death_blow

	callr	disable_repell

	movi	wait_forever,a7
	calla	takeover_him

	movi	>00040005,a9
	jsrp	animate2_a9		; grab
	calla	match_him_with_me_f

	pushp	a9

	push	a9
	movi	>39,a9
	calla	get_his_char_ani
	move	a9,a11			; a11 = his ani
	pull	a9

	movk	5,a0
	jsrp	mframew_him

	move	a11,a9
	calla	find_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2		; legz
	move	a9,*a13(p_store1),l
	pullp	a9

	tsound	>24			; grab sound

	move	*a13(p_otherguy),a10,l
	movi	>00030004,a0
	movk	3,a1
	jsrp	shake_him_up
	movk	6,a0
	jsrp	mframew	   		; wind up
*
* put legz where he was
*
	mmtm	sp,a8,a9,a10,a11

	move	*a13(p_store1),a9,l
	calla	gmo_proc
	move	*a10(ochar),*a8(ochar),w
	move	*a10(oid),*a8(oid),w
	move	*a10(oflags2),*a8(oflags2),w

	callr	a8_to_bloody_pal
	push	a8
	move	a8,a0				; a0 = multipart object
	move	*a13(p_otherguy),a8,l	; a8 = him
	calla	match_ani_points
	pull	a8

	calla	insobja8

	movk	7,a0
	calla	create_blood_proc
	jreq	rip3
	move	a8,*a0(pa11),l

rip3	mmfm	sp,a8,a9,a10,a11

	tsound	>56				; crunch sound
	movi	rsnd_death_voice,a0
	calla	calla_for_him

	movk	4,a0
	jsrp	double_mframew			; rrrrrrrip !!
	sleep	>20

	calla	me_in_back
	movk	4,a0
	jsrp	double_mframew			; pull back a bit
	sleep	>10

	movk	4,a0
	jsrp	double_mframew			; throw
	movi	torso_bounce,a7
	calla	takeover_him
	move	a11,*a0(pa9),l			; pass animation

	sleep	>30
	callr	death_blow_complete
	jauc	victory_animation


him_to_bloody_pal
	push	a8
	move	*a13(p_otherguy),a8,l
	callr	a8_to_bloody_pal
	move	a8,a10			; return with a10 = otherguy
	pull	a8
	rets

a8_to_bloody_pal
	push	a13
	move	*a13(p_otherproc),a13,l
	calla	change_to_bloody_pal
	pull	a13
	rets

**************************************************************************
*											     *
*  Shang Tsung Fatality #1 - Drain life from otherguy				*
*											     *
**************************************************************************
do_drain
	movk	1,a0
	movk	1,a1
	callr	init_death_blow

	calla	me_in_front
	sleep	>10

	callr	eliminate_edge_limits
	movi	wait_forever,a7
	calla	takeover_him

	movi	>0005000c,a9
	jsrp	animate2_a9		; reach out
	calla	match_him_with_me_f

	callr	disable_repell
	move	*a13(p_otherguy),a10,l

	pushp	a9
	movi	>38,a9
	calla	get_his_char_ani
	move	a9,a11
	movk	1,a0
	jsrp	mframew_him
	pullp	a9

	movi	>00040004,a0
	movk	3,a1
	jsrp	shake_him_up

	clr 	a0
	move	a0,*a8(ozpos),w		; now I am in back of "victum"
	movk	2,a0
	move	a0,*a10(ozpos),w

	movk	6,a0
	jsrp	double_mframew

	move	a8,a11			; pass a11 = me (shang)
	create	pid_fx,green_soul

	sleep	20

	movi	drain_table,a0
	calla	get_his_char_long
	move	a0,a11
	move	*a0,a0,l
	move	*a0,a0,l
	move	*a0(icmap),a0,l		; new "drained" palette

	move	*a8(oid),a1,w
	cmpi	oid_p1,a1		; am I player 1 ?
	jrne	drain3
	movi	alternate_suck_pals,a0
	calla	get_his_char_long	; right side player suck pals
drain3	callr	swpal_him

	movk	6,a0
	jsrp	mframew_him
	sleep	10
	movk	8,a0
	jsrp	mframew_him
*
* final frame = nasty
*
	movi	a_final_drain,a9
	move	*a9,a0,l
	move	*a0,a0,l
	move	*a0(icmap),a0,l
	callr	swpal_him
	calla	do_his_next_a9_frame

	sleep	>30

	callr	death_blow_complete
	jauc	wait_forever


swpal_him
	push	a8
	move	*a13(p_otherguy),a8,l
	calla	swpal
	pull	a8
	rets
**************************************************************************
*											     *
*  Sword Arms Fatality #1 - cut head off						     *
*											     *
**************************************************************************
do_decap
	movk	1,a0
	movk	1,a1
	callr	init_death_blow
	movk	1,a9
	calla	get_char_ani2
	calla	do_next_a9_frame
	sleep	>30

	movk	5,a0
	jsrp	mframew			; slice !!

	movi	rsnd_death_voice,a0
	calla	calla_for_him
	tsound	>44			; sword slice sound

	movi	decap_fall,a7
	calla	takeover_him_sr

	sleep	>10

	movi	>00060029,a9
	jsrp	animate_a9
	sleep	>10

	movk	6,a0
	jsrp	mframew

	callr	death_blow_complete
	jauc	wait_forever

**************************************************************************
*											     *
*  Sword Arms Fatality #2 - Impale								*
*											     *
**************************************************************************
do_impale
	movk	1,a0
	movk	1,a1
	callr	init_death_blow
*
* eliminate edge restrictions
*
	callr	eliminate_edge_limits

	movk	2,a9
	calla	get_char_ani2
	movk	6,a0
	jsrp	mframew			; out come the blades
	sleep	>10

	movk	4,a0
	jsrp	mframew			; stab !!

	tsound	>44			; sword stab sound

	movi	rsnd_death_voice,a0
	calla	calla_for_him
*
* make him react to getting stabbed
*
	calla	me_in_back		; put him in front of me

	mmtm	sp,a8,a9
	movi	wait_forever,a7
	calla	takeover_him_sr
	movi	>3b,a9
	calla	get_his_char_ani	; him = stabbed (impaled) ani
	move	a9,a11
	calla	find_part2
	move	a9,*a13(p_store1),l	; save suffering animation pointer
	callr	him_to_bloody_pal
	mmfm	sp,a8,a9

	calla	match_him_with_me_f
	movk	6,a0
	jsrp	double_mframew		; stabbo !!
	move	*a13(p_otherguy),a11,l

	movk	8,a0
	calla	create_blood_proc

	movk	2,a0
	jsrp	suffer_ani
	movk	4,a0
	jsrp	suffer_ani
	movk	6,a0
	jsrp	suffer_ani

	movi	rsnd_react_voice,a0
	calla	calla_for_him
	movk	8,a0
	jsrp	suffer_ani
	sleep	>30

	movi	rsnd_react_voice,a0
	calla	calla_for_him
	movk	8,a0
	jsrp	suffer_ani
	sleep	8

	callr	disable_repell

	mmtm	sp,a8,a13
	movi	>10000,a0
	move	a0,*a10(oyvel),l  	; slowly slide downwards
	move	a10,a8
	move	*a13(p_otherproc),a13,l
	movi	->10000,a0
	calla	away_x_vel
	mmfm	sp,a8,a13
	
	sleep	14
	calla	stop_him

	calla	stop_him
	callr	death_blow_complete
	jauc	wait_forever

suffer_ani
	move	*a13(p_store1),a11,l
	jauc	mframew_him			; suffering animation


eliminate_edge_limits
	movi	>5000,a0
	move	a0,@right_edge,w
	neg	a0
	move	a0,@left_edge,w
	calla	stop_scrolling
	clr	a0
	move	a0,@scrolly,l
	movi	pid_scroll,a0
	jauc	dallprc

**************************************************************************
*											     *
*  Female Ninja #1 Fatality #1 - Kiss								*
*											     *
**************************************************************************
do_kiss
	movk	1,a0
	movk	2,a1
	callr	init_death_blow

	movk	4,a9
	calla	get_char_ani2
	movk	8,a0
	jsrp	mframew			; take off mask
	calla	me_in_back

	movi	kissed_offset,a0
	jsrp	dizzy_wait
	jsrp	kiss_reach_out

	tsound	>60			; kiss sound

	movk	8,a0
	jsrp	mframew			; lift the leg
	sleep	>10
	movk	3,a0
	jsrp	mframew
	movi	r_kissed,a7
	calla	takeover_him
	sleep	>60

	callr	death_blow_complete
	jauc	wait_forever



kiss_reach_out
	movk	4,a9
	calla	get_char_ani2
	calla	find_part2		; a9 = reach out and grab
	movk	6,a0
	jsrp	mframew			; reach out and grab him
	sleep	10
*
* tug him towards me
*
	movi	kissed_coor_adj,a0
	calla	get_his_char_word
	move	a0,a11

	callr	disable_repell

	calla	do_next_a9_frame	; tug
	sleep	6

	jsrp	tug_in
;	jsrp	tug_in
;	retp

tug_in	move	*a13(p_otherguy),a2,l
	move	*a2(oypos),a3,w
	mmtm	sp,a2,a3
	calla	match_him_with_me_f
	mmfm	sp,a2,a3

	move	a3,*a2(oypos),w
	move	a11,a0
	calla	adjust_him_x
	calla	do_next_a9_frame	; tug
	sleep	6
	retp



dizzy_wait
	push	a0
	movi	>28,a9
	calla	get_his_char_ani
	pull	a0

	calla	get_his_char_word
	add	a0,a9 
	move	a9,a10			; a10 = where he should stop stunned ani
	
	move	@tick,a9,w		; a9 = tick state when we started 
	movi	>40/4,a11		; max wait time !

kiss3	sleep	4
	move	*a13(p_otherproc),a0,l
	move	*a0(pa9),a0,l		; a0 = his current frame
	dec	a11
	jreq	kiss5
	cmp	a0,a10			; match ?
	jrne	kiss3			; sans

kiss5	movi	wait_forever,a7
	calla	takeover_him

	move	@tick,a0,w
	sub	a9,a0			; a0 = ticks since we started waiting
	subi	>20,a0
	jreq	kiss6
	jrp	kiss6			; long enough
	abs	a0
	calla	prcslp			; wait minimum time !

kiss6	retp



kissed_coor_adj
	.word	->4c
	.word	->49
	.word	->41
	.word	->3a

	.word	->4c
	.word	->4c
	.word	->45
	.word	->4c

	.word	->47
	.word	->47
	.word	->47
	.word	->48


kissed_offset
	.word	32*5
	.word	32*2
	.word	32*6
	.word	32*6

	.word	32*5
	.word	32*5

	.word	>c0
	.word	>60
	.word	>a0

	.word	32*5
	.word	32*5

	.word	32*5

**************************************************************************
*											     *
*  Female Ninja #2 Fatality #1 - Psycho Stabbing					*
*											     *
**************************************************************************
do_psycho_stab
	movk	1,a0
	movk	2,a1
	callr	init_death_blow

	clr	a9
	calla	get_char_ani2
	calla	do_next_a9_frame		; stand for a sec (show sai's)
	sleep	>30

	movi	r_stabbed_by_fn2,a7
	calla	takeover_him_sr

	movi	>00030020,a0
	jsrp	animate_a0_frames		; stab, stab, stab !!

	callr	death_blow_complete

	clr	a9
	calla	get_char_ani2
	calla	do_next_a9_frame		; stand for a sec (show sai's)
	sleep	>30
	jauc	reaction_exit

**************************************************************************
*											     *
*  init_death_blow - all death blow moves start by calling this routine  *
*                    which starts the fader and sets the death blow flag *
* 											     *
*  input: a0 = fader flag 0 = no								     *
*                         1 = yes							     *
* 											     *
*         a1 = death blow #								     *
*											     *
**************************************************************************
init_death_blow
	cmpi	bb_fatality,a1
	jreq	initdb3
	cmpi	fs_fatality,a1
	jreq	initdb3

	move	@f_no_violence,a4,w
	jrne	init_abort

initdb3	push	a8
	move	a1,@f_death,w	  	; flag: death blow !!!

	push	a0
	calla	init_special		; i can't block !!
	create	pid_fx,make_db_tone

	pull	a0
	move	a0,a0
	jreq	initdb5
	create	pid_fade,death_blow_fader
	pull	a8
	rets


init_abort
	pull	a4			; no return
	jauc	wait_forever

*
* make the evil death blow tone
*
make_db_tone
	calla	nosounds
	sleep	2
	movi	>34,a3
	calla	send_code_a3   		; fade sound
	die


death_blow_complete
	move	@f_death,a1,w
	movi	-1,a0
	move	a0,@f_death,w

	cmpi	fs_fatality,a1
	jreq	dbc9
	movi	>35,a3
	cmpi	bb_fatality,a1
	jrne	dbc5

	movi	>3f,a3
dbc5	calla	send_code_a3		; death blow over tune !!
dbc9	rets

death_blow_fader
	movi	pid_cycle,a0
	calla	dallprc			; kill any color cycle procs

	movk	1,a0
	move	a0,@f_fade,w		; flag: we r faded !!
	push	a9
	movi	>800,a9
	create	pid_fade,skydown
	pull	a9
	movi	death_fade_excludes,a0
	calla	fadeout
	sleep	10

	movi	pid_fade,a0
	calla	dallprc
	clr	a0
	move	a0,@f_shadows,w
	die

**************************************************************************
*											     *
*                          ANIMATION TABLES					     *
*                          ANIMATION TABLES					     *
*                          ANIMATION TABLES					     *
*                          ANIMATION TABLES					     *
*											     *
**************************************************************************
a_split_in_2
	.long	TMDETHBLOW1
	.long	0

	.long	TMDETHBLOW2
	.long	TMDETHBLOW3
	.long	TMDETHBLOW4
	.long	0

	.long	TMDETHBLOW5
	.long	TMDETHBLOW6
	.long	0

	.long	TMDETHBLOW7
	.long	0

TMDETHBLOW1
	.long	TMDETHBLOW1A,TMDETHBLOW1B,TMDETHBLOW1C,0
TMDETHBLOW2
	.long	TMDETHBLOW2A,TMDETHBLOW2B,TMDETHBLOW2C,TMDETHBLOW2D,0
TMDETHBLOW3
	.long	TMDETHBLOW3A,TMDETHBLOW3B,TMDETHBLOW3C,0
TMDETHBLOW4
	.long	TMDETHBLOW4A,TMDETHBLOW4B,TMDETHBLOW4C,0
TMDETHBLOW5
	.long	TMDETHBLOW5A,TMDETHBLOW5B,TMDETHBLOW5C,0
TMDETHBLOW6
	.long	TMDETHBLOW6A,TMDETHBLOW6B,TMDETHBLOW6C,TMDETHBLOW6D,0
TMDETHBLOW7
	.long	TMDETHBLOW7A,TMDETHBLOW7B,TMDETHBLOW7C,TMDETHBLOW7D,TMDETHBLOW7E,0

;***************************************************************************

a_split_swipe
	.long	TMHATSWIPE1
	.long	TMHATSWIPE2
	.long	TMHATSWIPE3
	.long	0

	.long	TMHATSWIPE4
	.long	TMHATSWIPE5
	.long	0

	.long	TMHATSWIPE6
	.long	TMHATSWIPE7
	.long	TMHATSWIPE8
	.long	0

TMHATSWIPE1
	.long	TMHATSWIPE1A,0
TMHATSWIPE2
	.long	TMHATSWIPE2A,TMHATSWIPE2B,0
TMHATSWIPE3
	.long	TMHATSWIPE3A,0
TMHATSWIPE4
	.long	TMHATSWIPE4A,TMHATSWIPE4B,0
TMHATSWIPE5
	.long	TMHATSWIPE5A,TMHATSWIPE5B,0
TMHATSWIPE6
	.long	TMHATSWIPE6A,TMHATSWIPE6B,0
TMHATSWIPE7
	.long	TMHATSWIPE7A,TMHATSWIPE7B,0
TMHATSWIPE8
	.long	TMHATSWIPE8A,TMHATSWIPE8B,0

**************************************************************************
*											     *
*  Dudes getting split in half								     *
*											     *
**************************************************************************
r_split_in_2
	movk	9,a0
	calla	create_blood_proc

	calla	change_to_bloody_pal
	movi	split_in_2_tab,a0	
	calla	get_char_long
	move	a0,a9
	calla	do_next_a9_frame

	calla	disturbing_scream
	sleep	>40

	movk	5,a0
	jsrp	mframew			; still together animation
	calla	shake_n_sound
	sleep	>10

	mmtm	sp,a8,a9
	clr	a9
	calla	get_char_ani
	move	a9,a11

split2	move	*a9,a0,l
	cmpi	ani_ochar_jump,a0	; ani jump ?
	jrne	split5			; nope.
	move	*a8(ochar),a1,w
	addi	32,a9
	move	*a9+,a0,w
	cmp	a0,a1			; my jump ?
	jreq	split3
	addi	32,a9
	jruc	split2

split3	move	*a9,a9,l
split5	calla	get_proj_obj_m		; get an object for my other half
	move	a10,*a13(p_slave),l	; my responsibility
	move	a10,a0
	calla	match_ani_points
	move	*a8(ochar),*a10(ochar),w
	move	*a8(oid),*a10(oid),w
	move	*a8(oflags2),*a10(oflags2),w	; so we use same bloody pal
	move	a10,a8
	calla	change_to_bloody_pal
	calla	flip_multi
	move	a10,a0
	calla	insobj			; put on object list
	mmfm	sp,a8,a9
	move	a9,a11

;	create	pid_blood,split_blood2

	tsound	>96			; peel sound
	movk	6,a0
	jsrp	double_mframew 		; peel

	calla	shake_n_sound
	jauc	wait_forever


split_in_2_tab
	.long	a_hh_split
	.long	a_lk_split
	.long	a_jc_split
	.long	a_sa_split
	.long	a_fn_split
	.long	a_fn_split
	.long	a_st_split
	.long	a_rd_split
	.long	a_nj_split
	.long	a_nj_split
	.long	a_nj_split
	.long	a_jx_split
	.long	0
	.long	0
	.long	a_nj_split
	.long	a_fn_split
	.long	a_nj_split

a_hh_split
	.long	TMSPLIT1
	.long	TMSPLIT2
	.long	TMSPLIT3
	.long	0

	.long	TMSPLIT4
	.long	TMSPLIT5
	.long	TMSPLIT6
	.long	TMSPLIT7
	.long	TMSPLIT8
	.long	TMSPLIT9
	.long	TMSPLIT10
	.long	0

TMSPLIT1
	.long	TMSPLIT1A,TMSPLIT1B,TMSPLIT1C,TMSPLIT1D,0
TMSPLIT2
	.long	TMSPLIT2A,TMSPLIT2B,TMSPLIT2C,TMSPLIT2D,0
TMSPLIT3
	.long	TMSPLIT3A,TMSPLIT3B,TMSPLIT3C,TMSPLIT3D,0
TMSPLIT4
	.long	TMSPLIT4A,TMSPLIT4B,0
TMSPLIT5
	.long	TMSPLIT5A,TMSPLIT5B,0
TMSPLIT6
	.long	TMSPLIT6A,0
TMSPLIT7
	.long	TMSPLIT7A,0
TMSPLIT8
	.long	TMSPLIT8A,0
TMSPLIT9
	.long	TMSPLIT9A,TMSPLIT9B,TMSPLIT9C,0
TMSPLIT10
	.long	TMSPLIT10A,TMSPLIT10B,TMSPLIT10C,0


a_lk_split
	.long	LKSPLIT1
	.long	LKSPLIT2
	.long	LKSPLIT3
	.long	0

	.long	LKSPLIT4
	.long	LKSPLIT5
	.long	LKSPLIT6
	.long	LKSPLIT7
	.long	LKSPLIT8
	.long	LKSPLIT9
	.long	LKSPLIT10
	.long	0

LKSPLIT1
	.long	LKSPLIT1A,LKSPLIT1B,LKSPLIT1C,LKSPLIT1D,0
LKSPLIT2
	.long	LKSPLIT2A,LKSPLIT2B,LKSPLIT2C,0
LKSPLIT3
	.long	LKSPLIT3A,LKSPLIT3B,0
LKSPLIT4
	.long	LKSPLIT4A,LKSPLIT4B,0
LKSPLIT5
	.long	LKSPLIT5A,LKSPLIT5B,0
LKSPLIT6
	.long	LKSPLIT6A,LKSPLIT6B,0
LKSPLIT7
	.long	LKSPLIT7A,LKSPLIT7B,0
LKSPLIT8
	.long	LKSPLIT8A,LKSPLIT8B,0
LKSPLIT9
	.long	LKSPLIT9A,LKSPLIT9B,LKSPLIT9C,0
LKSPLIT10
	.long	LKSPLIT10A,LKSPLIT10B,LKSPLIT10C,0


a_jc_split
	.long	JCSPLIT1
	.long	JCSPLIT2
	.long	JCSPLIT3
	.long	0

	.long	JCSPLIT4
	.long	JCSPLIT5
	.long	JCSPLIT6
	.long	JCSPLIT7
	.long	JCSPLIT8
	.long	JCSPLIT9
	.long	JCSPLIT10
	.long	0

JCSPLIT1
	.long	JCSPLIT1A,JCSPLIT1B,0
JCSPLIT2
	.long	JCSPLIT2A,JCSPLIT2B,0
JCSPLIT3
	.long	JCSPLIT3A,JCSPLIT3B,JCSPLIT3C,0
JCSPLIT4
	.long	JCSPLIT4A,0
JCSPLIT5
	.long	JCSPLIT5A,0
JCSPLIT6
	.long	JCSPLIT6A,0
JCSPLIT7
	.long	JCSPLIT7A,0
JCSPLIT8
	.long	JCSPLIT8A,JCSPLIT8B,JCSPLIT8C,0
JCSPLIT9
	.long	JCSPLIT9A,JCSPLIT9B,JCSPLIT9C,0
JCSPLIT10
	.long	JCSPLIT10A,JCSPLIT10B,JCSPLIT10C,0



a_sa_split
	.long	UGSPLIT1
	.long	UGSPLIT2
	.long	UGSPLIT3
	.long	0

	.long	UGSPLIT4
	.long	UGSPLIT5
	.long	UGSPLIT6
	.long	UGSPLIT7
	.long	UGSPLIT8
	.long	UGSPLIT9
	.long	UGSPLIT10
	.long	0

UGSPLIT1
	.long	UGSPLIT1A,UGSPLIT1B,UGSPLIT1C,0
UGSPLIT2
	.long	UGSPLIT2A,UGSPLIT2B,UGSPLIT2C,UGSPLIT2D,0
UGSPLIT3
	.long	UGSPLIT3A,UGSPLIT3B,UGSPLIT3C,UGSPLIT3D,0
UGSPLIT4
	.long	UGSPLIT4A,UGSPLIT4B,0
UGSPLIT5
	.long	UGSPLIT5A,UGSPLIT5B,0
UGSPLIT6
	.long	UGSPLIT6A,UGSPLIT6B,0
UGSPLIT7
	.long	UGSPLIT7A,UGSPLIT7B,0
UGSPLIT8
	.long	UGSPLIT8A,UGSPLIT8B,UGSPLIT8C,0
UGSPLIT9
	.long	UGSPLIT9A,UGSPLIT9B,0
UGSPLIT10
	.long	UGSPLIT10A,UGSPLIT10B,0



a_fn_split
	.long	KTSPLIT1
	.long	KTSPLIT2
	.long	KTSPLIT3
	.long	0

	.long	KTSPLIT4
	.long	KTSPLIT5
	.long	KTSPLIT6
	.long	KTSPLIT7
	.long	KTSPLIT8
	.long	KTSPLIT9
	.long	KTSPLIT10
	.long	0

KTSPLIT1
	.long	KTSPLIT1A,KTSPLIT1B,0
KTSPLIT2
	.long	KTSPLIT2A,KTSPLIT2B,0
KTSPLIT3
	.long	KTSPLIT3A,KTSPLIT3B,0
KTSPLIT4
	.long	KTSPLIT4A,KTSPLIT4B,0
KTSPLIT5
	.long	KTSPLIT5A,KTSPLIT5B,0
KTSPLIT6
	.long	KTSPLIT6A,KTSPLIT6B,0
KTSPLIT7
	.long	KTSPLIT7A,KTSPLIT7B,KTSPLIT7C,0
KTSPLIT8
	.long	KTSPLIT8A,KTSPLIT8B,KTSPLIT8C,0
KTSPLIT9
	.long	KTSPLIT9A,KTSPLIT9B,KTSPLIT9C,0
KTSPLIT10
	.long	KTSPLIT10A,KTSPLIT10B,KTSPLIT10C,0

a_st_split
	.long	STSPLIT1
	.long	STSPLIT2
	.long	STSPLIT3
	.long	0

	.long	STSPLIT4
	.long	STSPLIT5
	.long	STSPLIT6
	.long	STSPLIT7
	.long	STSPLIT8
	.long	STSPLIT9
	.long	STSPLIT10
	.long	0

STSPLIT1
	.long	STSPLIT1A,0
STSPLIT2
	.long	STSPLIT2A,0
STSPLIT3
	.long	STSPLIT3A,0
STSPLIT4
	.long	STSPLIT4A,0
STSPLIT5
	.long	STSPLIT5A,0
STSPLIT6
	.long	STSPLIT6A,0
STSPLIT7
	.long	STSPLIT7A,STSPLIT7B,0
STSPLIT8
	.long	STSPLIT8A,STSPLIT8B,STSPLIT8C,0
STSPLIT9
	.long	STSPLIT9A,STSPLIT9B,STSPLIT9C,0
STSPLIT10
	.long	STSPLIT10A,STSPLIT10B,STSPLIT10C,0


a_rd_split
	.long	RDSPLIT1
	.long	RDSPLIT2
	.long	RDSPLIT3
	.long	0

	.long	RDSPLIT4
	.long	RDSPLIT5
	.long	RDSPLIT6
	.long	RDSPLIT7
	.long	RDSPLIT8
	.long	RDSPLIT9
	.long	RDSPLIT10
	.long	0

RDSPLIT1
	.long	RDSPLIT1A,RDSPLIT1B,RDSPLIT1C,0
RDSPLIT2
	.long	RDSPLIT2A,RDSPLIT2B,RDSPLIT2C,RDSPLIT2D,0
RDSPLIT3
	.long	RDSPLIT3A,RDSPLIT3B,RDSPLIT3C,RDSPLIT3D,0
RDSPLIT4
	.long	RDSPLIT4A,RDSPLIT4B,RDSPLIT4C,RDSPLIT4D,0
RDSPLIT5
	.long	RDSPLIT5A,0
RDSPLIT6
	.long	RDSPLIT6A,0
RDSPLIT7
	.long	RDSPLIT7A,0
RDSPLIT8
	.long	RDSPLIT8A,0
RDSPLIT9
	.long	RDSPLIT9A,0
RDSPLIT10
	.long	RDSPLIT10A,0


a_nj_split
	.long	NJSPLIT1
	.long	NJSPLIT2
	.long	NJSPLIT3
	.long	0

	.long	NJSPLIT4
	.long	NJSPLIT5
	.long	NJSPLIT6
	.long	NJSPLIT7
	.long	NJSPLIT8
	.long	NJSPLIT9
	.long	NJSPLIT10
	.long	0

NJSPLIT1
	.long	NJSPLIT1A,NJSPLIT1B,0
NJSPLIT2
	.long	NJSPLIT2A,NJSPLIT2B,0
NJSPLIT3
	.long	NJSPLIT3A,NJSPLIT3B,0
NJSPLIT4
	.long	NJSPLIT4A,0
NJSPLIT5
	.long	NJSPLIT5A,0
NJSPLIT6
	.long	NJSPLIT6A,0
NJSPLIT7
	.long	NJSPLIT7A,0
NJSPLIT8
	.long	NJSPLIT8A,NJSPLIT8B,0
NJSPLIT9
	.long	NJSPLIT9A,NJSPLIT9B,0
NJSPLIT10
	.long	NJSPLIT10A,NJSPLIT10B,0

;***********************************************************************

a_jx_split
	.long	JXSPLIT1
	.long	JXSPLIT2
	.long	JXSPLIT3
	.long	0

	.long	JXSPLIT4
	.long	JXSPLIT5
	.long	JXSPLIT6
	.long	JXSPLIT7
	.long	JXSPLIT8
	.long	JXSPLIT9
	.long	JXSPLIT10
	.long	0

JXSPLIT1
	.long	JXSPLIT1A,JXSPLIT1B,0
JXSPLIT2
	.long	JXSPLIT2A,JXSPLIT2B,0
JXSPLIT3
	.long	JXSPLIT3A,JXSPLIT3B,JXSPLIT3C,0
JXSPLIT4
	.long	JXSPLIT4A,JXSPLIT4B,0
JXSPLIT5
	.long	JXSPLIT5A,JXSPLIT5B,0
JXSPLIT6
	.long	JXSPLIT6A,0
JXSPLIT7
	.long	JXSPLIT7A,JXSPLIT7B,0
JXSPLIT8
	.long	JXSPLIT8A,JXSPLIT8B,0
JXSPLIT9
	.long	JXSPLIT9A,0
JXSPLIT10
	.long	JXSPLIT10A,JXSPLIT10B,0

;***********************************************************************

do_body_suck
	movk	1,a0			; fade = yes
	movk	2,a1			; fatality #
	callr	init_death_blow

	movk	4,a9
	calla	get_char_ani2
	movk	8,a0
	jsrp	mframew			; take off mask
	calla	me_in_back

	callr	disable_repell

	movi	kissed_offset,a0
	jsrp	dizzy_wait
	jsrp	kiss_reach_out

	tsound	>60			; kiss sound
	tsound	>c9			; suck sound

	movk	5,a0
	jsrp	mframew			; lift the leg
	movi	r_body_suck,a7
	calla	takeover_him

	sleep	>30

	movk	3,a0
	jsrp	mframew			; leg down / back off

	movk	8,a9
	calla	get_char_ani2
	movk	4,a0
	jsrp	mframew			; lean over 'n spit

	tsound	>c3			; long spit sound

	create	pid_bones,spit_bones

	sleep	>40
	callr	death_blow_complete

	movk	6,a0
	jsrp	mframew
	jauc	victory_animation

;*********************************************************************

disable_repell
	movi	>40*40,a0
	move	a0,@f_norepell,w 	; disable repell !!
	rets

;*********************************************************************

	.end
