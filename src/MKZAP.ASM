**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: projectile throwing moves								*
* 											     *
*  copyright (c) 1993 midway manufacturing							*
*											     *
**************************************************************************
	.file	'mkzap.asm'
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
	.text

**************************************************************************
*											     *
*  do_zap - All purpose ZAP routine. Call with:					     *
* 											     *
*  a0 = offset into table of routines							     *
* 											     *
*  Call with JSRP									     *
*											     *
**************************************************************************
do_zap
	sll	5,a0
	addi	projectile_jumps,a0
	move	*a0,a0,l
	jump	a0

projectile_jumps
	.long	do_throw_hat		; 0 - Hathead throw hat
	.long	do_lk_zapair		; 1 -
	.long	do_lk_zaplo		; 2 -
	.long	do_lk_zaphi		; 3 -
	.long	do_jc_zaphi		; 4 -
	.long	do_jc_zaplo		; 5 -
	.long	do_throw_fans		; 6 -
	.long	do_throw_sai		; 7 -
	.long	do_throw_bolt		; 8 -
	.long	do_st_zap1		; 9 - shang throw 1 skull
	.long	do_fn_spinfan		; a -
	.long	do_slow_proj		; b - Reptile slow projectile
	.long	do_throw_spear		; c - throw spear
	.long	do_throw_ice		; d - throw ice
 	.long	do_floor_ice		; e - throw ice on the floor
	.long	do_sa_zap		; f - sword arm spark zap
	.long	do_st_zap2		; 10 - shang throw 2 skulls
	.long	do_st_zap3		; 11 - shang throw 3 skulls
	.long	do_spit			; 12 - spit
	.long	do_kahn_spear		; 13 - shao kahns spear o death
	.long	do_jax_zap		; 14 - jax's.......whatever
	.long	do_goro_zap		; 15

;***********************************************************************

zap_air_init_special
	calla	air_init_special
	jruc	zinit3

zap_init_special_act
	calla	init_special_act
	jruc	zinit3

zap_init_special
	calla	init_special

zinit3	move	a10,a10			; flippped ??
	jreq	zinit4			; no
	calla	flip_multi
zinit4	rets


;***********************************************************************

do_goro_zap
	calla	init_special

	movi	>16,a9
	calla	get_char_ani
	movk	3,a0
	jsrp	mframew

	tsound	>d0			; poof sound

	push	a9
	movi	>17,a9
	calla	get_char_ani
	move	a9,a11
	callr	get_proj_obj_m		; get an object for my fireball

	move	a10,a5
	movi	>38,a0
	movi	>35,a1
	calla	adjust_xy_a5		; position at kintaro's mouth

	move	a10,a0
	calla	insobj			; fireball = on list
	movi	goro_fireball_proc,a7
	callr	spawn_proj_proc
	pull	a9

	move	a9,a11
	subi	32*2,a11		; a11 ---> frame 3
	move	a9,a10			; a10 ---> frame 4

	movk	3,a0
goroz2	move	a0,*a13(p_anicount),w
	move	a10,a9
	movi	TIGRPUK_P,a0
	calla	player_swpal		; thanks lazy ass vogel !!
	calla	do_next_a9_frame
	sleep	3

	move	a11,a9
	calla	player_normpal
	calla	do_next_a9_frame
	sleep	3

	move	*a13(p_anicount),a0,w
	dsj	a0,goroz2
	sleep	8
	retp


goro_fireball_proc
	movi	>a0000,a0
	callr	set_proj_vel

	movi	>17,a9
	calla	get_char_ani		; proj fly ani
	movk	2,a0
	calla	init_anirate

gfb3	sleep	1
	calla	next_anirate
	callr	proj_onscreen_test
	jrnc	delete_proj_and_die	; offscreen = delete
	movi	>06,a0
	callr	proj_strike_check
	jrnc	gfb3
*
* goro fireball hit
*
	movi	>d1,a0
	callr	hit_or_blocked_sound

	callr	proj_in_front

	calla	stop_a8
	move	*a8(oypos),a7,w
	push	a7
	calla	match_me_with_him
	pull	a7
	move	a7,*a8(oypos),w		; dont mess with y coordinate

	movi	->6a,a0
	movi	->20,a1
	calla	multi_adjust_xy

	movi	ft_kang,a0
	move	a0,*a8(ochar),w		; borrow from lk

	movi	>27,a9
	calla	get_char_ani
	move	*a9,a0,l
	move	*a0,a0,l
	move	*a0(icmap),a0,l		; grab new pal
	calla	swpal

	movi	>00040001,a9
	jsrp	animate2_a9
	jruc	delete_proj_and_die


TIGRPUK_P:
	.word   64 
	.word   00000h,0779ah,07777h,07714h,076f3h,076d4h,076b1h,07690h
	.word   0766fh,07650h,0762fh,06293h,0664dh,075c8h,0622bh,06dc9h
	.word   071a6h,061e9h,06d64h,074e7h,055ebh,06187h,07484h,06144h
	.word   05d23h,04da8h,07021h,05ce0h,05145h,06083h,04167h,04d03h
	.word   050c1h,06000h,044c3h,04c80h,03ca3h,04060h,030e4h,03c60h
	.word   03083h,03c00h,03060h,02c40h,02c00h,02060h,02000h,01000h
	.word   077bdh,06739h,05ad6h,04e73h,035adh,0294ah,01ce7h,014a5h
	.word   00c63h,00421h,07fe3h,07f20h,07ea0h,07e40h,07d80h,07100h

;***********************************************************************

do_jax_zap
	movi	act_jax_zap,a1
	callr	zap_init_special_act

	movi	>26,a9
	calla	do_first_a9_frame
	sleep	3

	tsound	>9d			; jax proj throw

	movk	4,a9
	calla	get_char_ani2
	move	a9,a11
	callr	get_proj_obj_m		; get an object for my spear
	move	a10,a0
	calla	insobj			; lightwave = on list

	movi	>26,a9
	calla	get_char_ani
	addi	32,a9
	movk	2,a0
	jsrp	double_mframew

	create	pid_proj1,jax_zap_proc
	move	a13,*a0(p_store1),l

	movk	2,a0
	jsrp	double_mframew
	calla	delete_slave

	movi	>18,a1
	jauc	do_proj_sitting_duck


jax_zap_proc
	move	*a13(p_store1),a0,l
	move	*a0(p_otherguy),*a13(p_otherguy),l
	move	*a0(p_otherproc),*a13(p_otherproc),l

	push	a13
	move	*a0(pa8),a8,l
	move	a0,a13			; pretend I am jax

	move	*a13(p_slave),a0,l
	push	a0
	movi	>27,a9
	calla	get_char_ani
	move	a9,a11
	callr	get_proj_obj_m	  	; get an object for my spear
	pull	a0
	move	a0,*a13(p_slave),l

	move	a10,a0
	calla	insobj		  	; proj on list
	pull	a13
	move	a10,a8			; a8 = proj

	movi	>80000,a0
	callr	set_proj_vel

	movi	>27,a9
	calla	get_char_ani		; proj fly ani
	movk	2,a0
	calla	init_anirate

jzap3	sleep	1
	calla	next_anirate
	callr	proj_onscreen_test
	jrnc	delete_proj_and_die	; offscreen = delete
	movi	>11,a0
	callr	proj_strike_check
	jrnc	jzap3
*
* jax zap hit
*
	callr	dead_projectile

	movi	>9e,a0
	callr	hit_or_blocked_sound

	calla	stop_a8
	movi	>10000,a0
	callr	set_proj_vel		; slow down during explosion
	movi	>27,a9
	calla	find_ani_part2
	movk	3,a0
	jsrp	mframew
	jruc	delete_proj_and_die

;***********************************************************************

do_kahn_spear
	callr	zap_init_special

	tsound	>d3			; spear appear sound
	movi	>0f,a9	
	calla	do_first_a9_frame
	sleep	8

	movk	6,a9
	calla	get_char_ani
	move	a9,a11
	callr	get_proj_obj_m		; get an object for my spear

	move	a10,a0
	calla	insobj

	tsound	>d4			; spear throw sound

	movi	>0f,a9	
	calla	get_char_ani
	movk	3,a0
	jsrp	double_mframew		; throw !!

	movi	kahn_spear_proc,a7
	callr	spawn_proj_proc
	sleep	>10
	retp


kahn_spear_proc
	movi	>a0000,a0
	callr	set_proj_vel

	movi	>06,a9
	calla	find_ani_part2
	movk	3,a0
	calla	init_anirate

ksp3	sleep	1
	calla	next_anirate
	callr	proj_onscreen_test
	jrnc	delete_proj_and_die	; offscreen = delete
	movi	>04,a0
	callr	proj_strike_check
	jrnc	ksp3
*
* kahn spear hit
*
	movi	>f1,a0
	callr	hit_or_blocked_sound

	calla	stop_a8
	movi	>10000,a0
	callr	set_proj_vel		; slow down during explosion
	movi	>06,a9
	calla	find_ani_part2
	calla	find_part2
	movk	3,a0
	jsrp	mframew
	jruc	delete_proj_and_die

;***********************************************************************

do_spit
	movi	act_spit,a1
	callr	zap_init_special_act

	movk	4,a9
	calla	get_char_ani2
	push	a9
	calla	find_part2
	calla	find_part2
	move	a9,a11
	callr	get_proj_obj_m		; get an object for my face
	move	a10,a0
	calla	insobj			; put on object list
	pull	a9
	tsound	>9c			; sound: hocking a loogy

	calla	double_next_a9
	movk	6,a0
	jsrp	face_sleep

	calla	double_next_a9
	movk	3,a0
	jsrp	face_sleep
	calla	double_next_a9
	movk	3,a0
	jsrp	face_sleep

	move	*a13(p_slave),a5,l	; my responsibility
	movi	pid_proj1,a1
	movi	spit_proc,a7

	callr	spawn_proj_proc
	move	*a13(p_otherguy),*a0(p_otherguy),l

	move	a8,*a0(pa10),l		; pass reptile obj
	move	a5,*a13(p_slave),l	; my responsibility
	movk	10,a0
	jsrp	face_sleep

	addi	32,a9
	addi	32,a11

	calla	double_next_a9
	movk	5,a0
	jsrp	face_sleep

	calla	double_next_a9
	movk	5,a0
	jsrp	face_sleep

	movk	8,a0
	jruc	face_sleep		; / retp

face_sleep
	move	a0,*a13(p_anicount),w
	move	a10,a0
	calla	match_ani_points		; lineup proj with thrower !
	move	*a8(oxvel),*a10(oxvel),l	; face = same vel as reptile
	sleep	1
	move	*a13(p_anicount),a0,w
	dsjs	a0,face_sleep
	retp



spit_proc
	tsound	>6f			; spit sound

	movk	3,a9
	calla	get_char_ani2
	calla	gmo_proc     		; a0 = process which holds data
	move	a0,*a8(oslink),l	; oslink = process
	movk	ft_reptile,a0
	move	a0,*a8(ochar),w

	push	a8
	move	a8,a0
	move	a10,a8
	calla	match_ani_points
	pull	a8
	calla	proj_in_front		; spit in front of others
	calla	insobja8

	movk	8,a11
spit2	jsrp	pre_spit_ani
	dsjs	a11,spit2

	movi	>a0000,a0
	callr	set_proj_vel

spit3	sleep	1
	callr	proj_onscreen_test
	jrnc	delete_proj_and_die	; offscreen = delete
	movi	>18,a0
	callr	tell_world_stk		; let the drone know about this !!!
	movi	>18,a0
	callr	proj_strike_check
	jrnc	spit3

spit_hit
	movi	>70,a0
	callr	hit_or_blocked_sound

	calla	stop_a8

	move	*a8(oypos),a9,w
	calla	match_me_with_him
	calla	flip_multi
	movi	->a0,a0
	movi	>00,a1
	calla	multi_adjust_xy
	move	a9,*a8(oypos),w		; original y

	movk	3,a9
	calla	get_char_ani2
	calla	find_part2
	movk	3,a0
	jsrp	mframew
	jruc	delete_proj_and_die

pre_spit_ani
	calla	do_next_a9_frame

	movi	>17,a0
	callr	tell_world_stk		; let the drone know about this !!!

	movi	>17,a0
	callr	proj_strike_check
	jrc	pre_spit_hit
	sleep	2
	retp

pre_spit_hit
	pullp	a0
	jruc	spit_hit

;***********************************************************************

do_sa_zap
	movi	act_spark,a1
	callr	zap_init_special_act

	tsound	>8a
	movi	>00030026,a9
	jsrp	animate_a9		; wind up

	mmtm	sp,a8,a9
	movi	>27,a9
	calla	get_char_ani
	move	a9,a11
	callr	get_proj_obj_m		; get an object for my spark projectile

	move	a10,a8
	clr	a0
	movi	->0c,a1
	calla	multi_adjust_xy		; lineup to my hands

	move	a10,a0
	calla	insobj			; put on object list
	mmfm	sp,a8,a9

	movk	4,a0
	jsrp	double_mframew		; speed up

	movi	pid_proj1,a1
	movi	spark_proc,a7
	callr	spawn_proj_proc
	move	a10,*a0(pa8),l		; pass spark object
	sleep	>1c
	calla	do_next_a9_frame
	sleep	4
	retp


spark_proc
	callr	proj_in_front
	movi	>27,a9
	calla	find_ani_part2

	calla	do_next_a9_frame
	movi	>16,a0
	callr	proj_strike_check
	jrc	spark_hit
	sleep	3

	calla	do_next_a9_frame
	movi	>16,a0
	callr	proj_strike_check
	jrc	spark_hit
	sleep	3

	movi	>a0000,a0
	callr	set_proj_vel
spark3	sleep	1
	callr	proj_onscreen_test
	jrnc	delete_proj_and_die	; offscreen = delete
	movi	>17,a0
	callr	proj_strike_check
	jrnc	spark3
*
* spark hit
*
spark_hit
	callr	dead_projectile

	movi	>8b,a0
	callr	hit_or_blocked_sound

	callr	proj_in_front
	calla	stop_a8

	calla	match_me_with_him
	calla	flip_multi
	movi	->80,a0
	movi	>00,a1
	calla	multi_adjust_xy

	movi	>27,a9
	calla	find_ani_part2
	calla	find_part2
	movk	3,a0
	jsrp	mframew			; zap hit ani
	jruc	delete_proj_and_die	; delete

;***********************************************************************

do_floor_ice
	movi	act_floor_ice,a1
	callr	zap_init_special_act
	movk	3,a9
	calla	get_char_ani2
	movk	3,a0
	jsrp	mframew			; zap at the floor

	tsound	>82

	movk	2,a9
	calla	get_char_ani2
	callr	get_proj_obj_m		; get an object for my hat projectile

	move	a10,a0
	calla	insobj			; put on object list

	movi	floor_ice_proc,a7
	callr	spawn_proj_proc
	move	a10,*a0(pa8),l		; pass ice object

	move	a0,a5			; a5 = proj proc
	movi	pid_floor_ice1,a0
	movi	pid_floor_ice2,a1
	calla	p1p2_pick
	move	a0,*a5(procid),w	; set correct pid

	movi	>20,a1
	jauc	do_proj_sitting_duck

floor_ice_proc
	clr	a0
	move	a0,*a13(p_action),w

	movi	back_z-1,a0
	move	a0,*a8(ozval),l		; floor ice is in back

	movk	2,a9
	calla	get_char_ani2
	movk	3,a0
	jsrp	mframew			; part 1
	calla	is_thrower_in_sd
	jrnc	delete_proj_and_die
	movk	3,a0
	jsrp	mframew			; part 2

	movi	floor_ice_time,a11
fip5	sleep	1
	move	*a13(p_otherguy),a0,l
	calla	is_he_a_boss
	jrc	fip6
	move	@winner_status,a0,w
	jrne	ice_melt
	movi	>15,a0
	callr	proj_strike_check
	jrc	floor_ice_hit		; gotcha !

fip6	dsj	a11,fip5
	jruc	ice_melt


floor_ice_hit
	push	a8
	move	@p1_obj,a8,l
	move	*a13(procid),a0,w
	cmpi	pid_floor_ice1,a0
	jreq	fih3
	move	@p2_obj,a8,l
fih3	movi	l_pud,a0
	calla	update_tsl		; update the timer for next time
	pull	a8

	calla	leftmost_mpart		; a2 = leftmost
	calla	rightmost_mpart		; a3 = rightmost
	move	*a13(p_otherproc),a0,l
	move	a2,*a0(pa10),l
	move	a3,*a0(pa11),l
*
* a11 = how much more time remained !!
*
fih6	sleep	3
	calla	get_his_action
	cmpi	act_slipping,a1
	jreq	fih6

ice_melt
	callr	dead_projectile

	movk	2,a9
	calla	get_char_ani2
	calla	find_part2
	calla	find_part2
	movk	3,a0
	jsrp	mframew
	jruc	delete_proj_and_die

;***********************************************************************

do_throw_ice
	tsound	>6a

	movi	act_throw_ice,a1
	callr	zap_init_special_act

	movi	>26,a9
	calla	get_char_ani
	calla	do_next_a9_frame
	sleep	2
	calla	do_next_a9_frame
	sleep	2			; speed up ---> 1st 2 frame sleep "2"
	movk	3,a0
	jsrp	mframew			; remaining frames are the same "3"

	movk	1,a9
	calla	get_char_ani2
	callr	get_proj_obj_m		; get an object for my hat projectile

	move	a10,a5
	movi	>28,a0
	movi	>2d,a1
	calla	adjust_xy_a5		; adjust to scorpion's hands !!
	move	a10,a0
	calla	insobj			; put on object list

	movi	pid_proj1,a1
	movi	ice_proc,a7
	callr	spawn_proj_proc
	move	a0,a5			; a5 = proj proc

	movi	pid_ice1,a0
	movi	pid_ice2,a1
	calla	p1p2_pick
	move	a0,*a5(procid),w	; set correct pid

	movi	>20,a1
	jauc	do_proj_sitting_duck

ice_proc
	movk	1,a9
	calla	get_char_ani2		; ice ani
	calla	do_next_a9_frame
	sleep	2			; used to be "3"
	calla	do_next_a9_frame
	sleep	2			; used to be "3"

	callr	is_thrower_in_sd
	jrnc	delete_proj_and_die

	movk	3,a0
	jsrp	mframew

	movi	>13,a0
	callr	tell_world_stk

	calla	is_he_helpless
	jrc	ice1			; helpless = no freezing allowed
	movi	>13,a0
	callr	proj_strike_check
	jrc	icehit
ice1	calla	do_next_a9_frame
	sleep	3

	calla	is_he_helpless
	jrc	ice2			; helpless = no freezing allowed
	movi	>13,a0
	callr	proj_strike_check
	jrc	icehit
ice2	calla	do_next_a9_frame
	sleep	3

	movk	4,a0
	calla	init_anirate
	movi	>a0000,a0
	callr	set_proj_vel

ice4	sleep	1
	calla	next_anirate
	callr	proj_onscreen_test
	jrnc	delete_proj_and_die	; offscreen = delete
	calla	is_he_helpless
	jrc	ice4			; helpless = no freezing allowed

	movi	>14,a0
	callr	proj_strike_check
	jrnc	ice4
*
* ice hit
*
icehit 
	callr	dead_projectile

	movi	>c5,a0
	callr	hit_or_blocked_sound

	calla	stop_a8

	move	*a8(oypos),a14,w
	calla	match_me_with_him
	calla	flip_multi 		; flip him !
	movi	->90,a0
	clr	a1
	calla	multi_adjust_xy
	move	a14,*a8(oypos),w

	callr	proj_in_front

	movk	1,a9
	calla	get_char_ani2		; ice ani
	calla	find_part2
	calla	find_part2
	movk	4,a0
	jsrp	mframew
	jruc	delete_proj_and_die	; offscreen = delete


is_thrower_in_sd
	move	*a13(p_store2),a0,l
	move	*a0(p_action),a0,w
	cmpi	act_proj_sd,a0
	jreq	sdyes
	clrc
	rets
sdyes	setc
	rets

;***********************************************************************

do_throw_spear
	callr	zap_init_special
	movi	act_spear,a0
	move	a0,*a13(p_action),w	; action: throwing spear !!

	clr	a9
	calla	get_char_ani2
	movk	2,a0
	jsrp	mframew			; throw fast (we got 4 frames)
	sleep	1

	movi	l_spear,a0
	calla	update_tsl

	movk	1,a9
	calla	get_char_ani2
	callr	get_proj_obj_m		; get an object for my hat projectile

	move	*a10(oflags),a4,w
	ori	dmaclp,a4
	move	a4,*a10(oflags),w 	; set the "register clip bit"
	move	a10,a0
	callr	set_rope_clip

	move	a10,a5
	movi	->10,a0
	clr	a1
	calla	adjust_xy_a5		; adjust to scorpion's hands !!
	move	a10,a0
	calla	insobj			; put on object list

	movi	pid_proj1,a1
	movi	spear_proc,a7
	callr	spawn_proj_proc
	move	a13,*a0(p_store1),l	; pass scorpion proc
	move	a8,*a0(p_store2),l	; pass scorpion obj

	movi	act_proj_sd,a0		; dont change this to use
	move	a0,*a13(p_action),w	; "do_proj_sitting_duck" !!!!
	sleep	>30			; this long before i give up !

waiting_for_spear
	clr	a1
	move	a1,*a13(p_action),w	; i am not doing anything anymore
	retp

spear_proc
	tsound	>64			; spear throw sound
	movi	>a0000,a0
	callr	set_proj_vel
	movk	4,a0
	calla	init_anirate		; animation speed
	
spear3	sleep	1
	calla	next_anirate

	movi	>11,a0
	callr	tell_world_stk
	movi	>11,a0
	callr	proj_strike_check		; collision ?

	jrc	spear_hit		; yes
	callr	proj_onscreen_test
	jrnc	delete_proj_and_die	; offscreen = delete

;*************************
;	move	a8,a0
;	callr	set_rope_clip
;	move	*a8(oflags),a4,w
;	btst	b_fliph,a4
;	jrne	spear4
;	calla	rightmost_mpart		; a3 = rightmost
;	move	*a13(p_store2),a0,l
;	move	*a0(oxpos),a0,w	   	; a0 = scorpion's x pos
;	sub	a0,a3
;	abs	a3   			; a3 = amount showing
;	movi	304,a1			; full length of rope
;	sub	a3,a1			; a1 = amount to clip
;	move	a1,*a8(ofset),w
;	move	*a8(oxpos),a0,w
;	add	a1,a0
;	move	a0,*a8(oxpos),w
;spear4
;*************************

	jruc	spear3

spear_hit
	callr	dead_projectile

	calla	stop_a8
	move	*a13(p_store1),a0,l	; dude who threw me proc
	move	*a0(pwake),a1,l
	cmpi	waiting_for_spear,a1	; is he still waiting for me ?
	jrne	spear_cancelled		; no, act like i was blocked

	move	b2,b2			; blocked ??
	jrne	spear_blocked		; yes ---> skip the drag part

	movi	do_rope_pull,a7
	calla	fastxfer		; xfer scorpion ---> pull in otherguy
	move	a8,*a0(pa10),l		; pass a10 = spear proc
	move	a8,*a0(p_slave),l	; rope = your responsibility

	tsound	>65			; spear hit
	die

spear_cancelled
	move	*a13(p_otherproc),a0,l	; a0 = victim proc
	movi	r_null_speared,a7
	calla	fastxfer

spear_blocked
	tsound	>66			; spear blocked

	movi	>0e0e,a0
	move	a0,*a8(oconst),w	; constant color to flash with
	move	*a8(oflags),a9,w	; a9 = normal flags
	move	a9,a10
	andi	>fff0,a10
	ori	dmacnz,a10		; a10 = "white" flags

	movk	3,a11
spblk6	move	a10,a0
	jsrp	stuff_rope_flags
	move	a9,a0
	jsrp	stuff_rope_flags
	dsjs	a11,spblk6
	jruc	delete_proj_and_die	; offscreen = delete

stuff_rope_flags
	move	a0,*a8(oflags),w
	move	*a8(oimg),a2,l
	move	a0,*a2(mp_control),w	; 
	sleep	3
	retp

*
* a10 = rope obj
*
do_rope_pull
	movi	act_rope_pull,a1
	move	a1,*a13(p_action),w		; define my action

	push	a8
	movk	1,a9
	calla	get_char_ani2
	calla	find_part2			; a9 ---> tight rope frame
	move	a10,a8
	calla	do_next_a9_frame
	pull	a8

	clr	a9
	calla	get_char_ani2
	calla	find_part2
	calla	do_next_a9_frame

	movi	>0f,a0
	calla	is_he_a_boss
	jrnc	pull2
	movi	>10,a0
pull2	calla	pose_him_a0			; him --> 1st frame of knocked down
	move	*a13(p_otherguy),a11,l	; a11 = him

	movk	4,a0
	calla	create_blood_proc

	push	a10
	calla	stop_him
	calla	ground_him
	pull	a10

;	move	*a10(oflags),a4,w
;	ori	dmaclp,a4
;	move	a4,*a10(oflags),w		; set the "register clip bit"

	callr	lineup_rope_with_him

	movi	back_z-1,a0
	move	a0,*a11(ozval),l
	movi	back_z,a0
	move	a0,*a10(ozval),l
	callr	proj_in_front
	
	move	*a13(p_otherproc),a0,l
	movi	act_speared_sd,a1
	move	a1,*a0(p_action),w		; define his new action

	movk	6,a9
pull4	movi	-2,a1
	jsrp	double_shaker
	movk	2,a1
	jsrp	double_shaker			; shake it up !!
	dsj	a9,pull4

	clr	a9
	calla	get_char_ani2
	calla	find_part2
	calla	do_next_a9_frame
	sleep	4				; do frame before starting him in

	movi	tugged_in_by_spear,a7
	calla	xfer_otherguy

	movi	>0002007d,a0			; [total # of entries, 1st entry]
	calla	random_triple			; get over here / come here

	movk	4,a0
	calla	init_anirate			; animation speed

	callr	lineup_rope_with_him
	calla	next_anirate
	sleep	1
	callr	lineup_rope_with_him
	calla	next_anirate
pull5	sleep	1
	callr	lineup_rope_with_him
	calla	next_anirate
	move	*a11(oxvel),a0,l		; he still moving ?
	jrne	pull5				; yes, loop

	calla	delete_slave
	jauc	reaction_exit


lineup_rope_with_him
	push	a8
	move	*a8(oypos),a7,w
	push	a7
	move	a10,a8			; me = rope (trick the routine)
	calla	match_me_with_him
	pull	a7
	move	a7,*a8(oypos),w		; dont mess with y pos
	calla	flip_multi

	movi	spear_adjustments,a0
	calla	get_his_char_word
	neg	a0
	clr	a1
	calla	multi_adjust_xy

	pull	a8
	
	move	a10,a0
	callr	set_rope_clip
*
* clip rope
*
	push	a10
	calla	get_x_dist	    	; a3 = x distance
	pull	a10

	movi	304,a0
	sub	a3,a0
	abs	a0			; clip value
	move	a0,*a10(ofset),w

	move	*a10(oflags),a4,w
	btst	b_fliph,a4
	jreq	lrwh8
	neg	a0			; reverse adjustments for flip
lrwh8	move	*a10(oxpos),a1,w
	add	a0,a1
	move	a1,*a10(oxpos),w
	rets


double_shaker
	push	a8
	move	a10,a8
	clr	a0			; no x movement
	calla	multi_adjust_xy		; shake him
	move	a11,a8
	calla	multi_adjust_xy		; shake rope
	pull	a8
	sleep	2
	retp


set_rope_clip
	move	*a0(oimg),a2,l		; a2 = spear multipart ram
	move	*a2(mp_control),a4,w
	ori	dmaclp,a4
	move	a4,*a2(mp_control),w	; set the "udlr clip" bit in spear
	rets


spear_adjustments
	.word	>70
	.word	>77
	.word	>74
	.word	>75

	.word	>75
	.word	>75
	.word	>75
	.word	>7c

	.word	>7c
	.word	>7c
	.word   >80
	.word	>7c

	.word	>88	; kintaro
	.word	>88	; shao kahn

	.word	>7c
	.word	>7c
	.word	>7c


tugged_in_by_spear
	calla	set_no_block		; I cant block
	movi	>80000,a0
	calla	towards_x_vel		; whoa, shit !!!

papa4	sleep	1
	calla	get_x_dist
	cmpi	>40,a3
	jrhi	papa4

	movi	act_speared_sd,a0
	move	a0,*a13(p_action),w

	calla	stop_me
	movi	>00120028,a9		; stunned ani
	calla	goro_pick_ani
	calla	get_char_ani

	movk	8,a0
	calla	init_anirate

	movi	8*8,a11
papa6	sleep	1
	calla	next_anirate
	calla	is_he_airborn		; cheapo ----> get out of this !!
	jac	reaction_exit
	dsjs	a11,papa6
	jauc	reaction_exit

;***********************************************************************

do_slow_proj
	movi	act_slow_orb,a1
	callr	zap_init_special_act	; this is considered a special move

	movk	1,a9
	calla	get_char_ani2
	movk	2,a0
	jsrp	mframew			; wind up !!

	push	a9
	movk	1,a9
	calla	get_char_ani2
	calla	find_part2
	calla	find_part2
	callr	get_proj_obj_m		; get an object for my hat projectile

	move	a10,a0
	calla	insobj			; put on object list
	move	a9,a11
	pull	a9

	movk	3,a0			; faster
;	movk	4,a0
	jsrp	double_mframew		; speed up

	movi	slow_proj_proc,a7
	callr	spawn_proj_proc

	move	a0,a5			; a5 = proj proc
	movi	pid_orb1,a0
	movi	pid_orb2,a1
	calla	p1p2_pick
	move	a0,*a5(procid),w	; set correct pid

	movi	act_orb_sd,a0
	move	a0,*a13(p_action),w

	sleep	>10
	movk	1,a9
	calla	get_char_ani2
	calla	do_next_a9_frame
	sleep	4
	retp


slow_proj_proc
	callr	proj_in_front

	movi	>30000,a0
	callr	set_proj_vel
	move	*a13(p_otherguy),a10,l

	movk	1,a9
	calla	get_char_ani2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	movk	3,a0
	calla	init_anirate

	movk	1,a11			; orb sound timer
spp5	sleep	1
	dsj	a11,spp6
	movk	20,a11			; orb sound timer
	tsound	>67
spp6	calla	next_anirate
	callr	proj_onscreen_test
	jrnc	delete_proj_and_die	; offscreen = delete

	move	@winner_status,a0,w
	jrne	delete_proj_and_die	; roundover = delete

	move	*a8(oxpos),a1,w
	move	*a10(oxpos),a2,w
	sub	a2,a1
	abs	a1			; a1 = x distance
	cmpi	>30,a1			; close ?
	jrlo	slow_bang		; yes, explode
	jruc	spp5

slow_bang
	calla	stop_a8
	calla	orb_hit_sound

	movk	2,a9
	calla	get_char_ani2
	movk	2,a0
	calla	init_anirate

	movk	6,a11
spp7	calla	next_anirate

	calla	is_he_a_boss
	jrc	spp8			; boss = no effect !!!
	movi	>10,a0
	callr	proj_strike_check
	jrc	bang_hit

spp8	sleep	1
	dsjs	a11,spp7

bang_hit
	movk	2,a0
	jsrp	mframew
	jruc	delete_proj_and_die

**************************************************************************
*											     *
*  Hathead Zap: Throw hat !								     *
*											     *
**************************************************************************
do_throw_hat
	movi	act_throw_hat,a1
	callr	zap_init_special_act	; this is considered a special move

	movi	>26,a9
	calla	do_first_a9_frame	; frame #1
	sleep	6	      		; windup time !

	tsound	>52			; throw hat sound

	push	a9
	movi	>27,a9
	calla	get_char_ani
	callr	get_proj_obj_m		; get an object for my hat projectile
	move	a10,a0
	calla	insobj			; put on object list
	move	a9,a11
	calla	do_next_a11_for_a10	; frame #1 for hat !!!
	pull	a9
	calla	do_next_a9_frame	; frame #2 for me
	sleep	5

	calla	do_next_a11_for_a10	; frame #2 for hat !!!
	calla	do_next_a9_frame	; frame #3 for me
	sleep	3
	
	clr	a3
	calla	am_i_joy
	jrnc	that3
	movk	1,a3
that3	movi	hat_proc,a7
	callr	spawn_proj_proc
	move	a3,*a0(p_store3),w	; flag: joy dude flag of thrower
*
* make a new hat reappear
*
	movi	act_proj_sd,a0
	move	a0,*a13(p_action),w	; I am a sitting duck

	push	a8
	clr	a9
	calla	get_char_ani2
	move	a9,a11
	move	a9,a5			; a5 = hat reappear frame #1
	move	*a5,a5,l
	calla	get_single_obj
	calla	set_dmawnz
	move	a8,a0			; single object
	pull	a8

	move	a8,a1			; multipart object
	calla	lineup_1pwm		; lineup 1 part object with multipart
	calla	insobj			; put new hat on list
	move	a0,a10			; a10 = new hat obj
	movi	front_z+1,a0
	move	a0,*a10(ozval),l	; hat in front of hathead
	move	a10,*a13(p_slave),l

	movk	1,a9
that5	dsjs	a9,that6
	movk	3,a9
	calla	frame_a10a11
that6	sleep	1
	move	a8,a1
	move	a10,a0
	calla	lineup_1pwm		; keep hat aligned with kung lao
	move	*a11,a0,l
	jrne	that5

	movk	10,a9
that8	move	a8,a1
	move	a10,a0
	calla	lineup_1pwm		; keep hat aligned with kung lao
	sleep	1
	dsj	a9,that8

	calla	delete_slave
	retp


hat_proc
	movi	>c0000,a0
	callr	set_proj_vel
	movi	>27,a9
	calla	get_char_ani
	addi	32*4,a9			; a9 = frame #3 of hat fly !!
	clr	a0
	move	a0,*a13(p_store1),w	; flag: no collision yet

	movi	>10,a0
	callr	tell_world_stk

	movk	4,a0
	calla	init_anirate
hatp3	calla	next_anirate

*
* joystick direction control
*
	move	*a13(p_store3),a1,w
	jrne	hatp2			; joy = let stick control hat

	move	@f_death,a0,w
	jreq	hatp6			; not fatality mode

	movi	->1a000,a5
	move	@ground_y,a1,w
	move	*a8(oypos),a0,w
	sub	a0,a1
	abs	a1
	cmpi	>70,a1
	jrlo	hatp11
	clr	a5			; high enough to cut
hatp11	move	a5,*a8(oyvel),l		; set hat y vel

hatp2	push	a13
	move	*a13(p_store2),a13,l
	calla	joystick_in_a0
	pull	a13

	clr	a1			; assume no up/down change
	btst	bit_jdown,a0
	jreq	hatp4
	movi	>a000,a1
hatp4	btst	bit_jup,a0
	jreq	hatp5
	movi	->a000,a1
hatp5	move	*a8(oyvel),a0,l
	add	a1,a0
	move	a0,*a8(oyvel),l		; change y vel

hatp6	movi	>10,a0
	callr	proj_strike_check		; no, check for collision
	jrc	hatp8

	sleep	1
	callr	proj_onscreen_test
	jrc  	hatp3
	jruc	delete_proj_and_die	; offscreen = die

*
* hat hit !
*
hatp8
	callr	dead_projectile
	movi	front_z,a0
	move	a0,*a8(ozpos),w		; put hat in front of chump

	move	b2,b2
	jreq	hatpa

hat_blocked
	tsound	>54			; hat blocked sound

	calla	match_me_with_him

	movi	>27,a9
	calla	find_ani_part2		; ani: hat blocked !!
	movk	5,a0
	calla	init_anirate
	movi	>50000,a1

	move	@rand,a0,l
	jrn	hatp9
	jruc	hatp9
     	neg	a1

hatp9 	move	a1,*a8(oyvel),l		; up or down (random)

	movi	>00,a0
	movi	>30,a1
	calla	multi_adjust_xy		; lineup

	move	*a8(oxvel),a0,l
	neg	a0
	move	a0,*a8(oxvel),l
	jruc	hatpc
	
hatpa	tsound	>53			; hat hit sound

hatpc	calla	next_anirate
	sleep	1
	callr	proj_onscreen_test	; onscreen ?
	jrc  	hatpc			; yes ---> keep flyin'
	jruc	delete_proj_and_die

**************************************************************************
*											     *
*  Liu Kang: Zap !										*
*											     *
**************************************************************************
do_lk_zapair
	callr	zap_air_init_special	; this is considered a special move
	tsound	>61

	movi	act_lkzap_air,a1
	move	a1,*a13(p_action),w

	tsound	>05			; kang throw speech
	movi	>00040002,a9
	jsrp	animate2_a9

	movk	28,a0
	movi	->20,a1
	movk	8,a2			; recover time for lo zap
	movi	>c0000,a3		; a3 = speed of projectile
	movk	3,a4			; a4 = blob grow speed
	jruc	lkzap_entry


do_lk_zaplo
	movi	act_lkzap_lo,a1
	calla	zap_init_special_act	; this is considered a special move
	tsound	>61

	tsound	>05			; kang throw speech
	movi	>00040000,a9
	jsrp	animate2_a9

	movk	20,a0
	movi	40,a1
	movi	>30,a2			; recover time for lo zap
	movi	>a0000,a3		; a3 = speed of projectile
	movk	5,a4			; a4 = blob grow speed
	jruc	lkzap_entry

do_lk_zaphi
	movi	act_lkzap_hi,a1
	callr	zap_init_special_act	; this is considered a special move

	tsound	>61
	tsound	>05			; kang throw speech
	movi	>00040026,a9
	jsrp	animate_a9

	clr	a0
	clr	a1
	movi	>20,a2			; recover time for hi zap
	movi	>c0000,a3		; a3 = speed of projectile
	movk	4,a4			; a4 = blob grow speed

lkzap_entry
	move	a2,*a13(p_store1),w	; save recover time
	move	a3,*a13(p_store2),l	; save speed of projectile
	move	a4,*a13(p_store3),w	; blob grow speed
	mmtm	sp,a0,a1
	movi	>27,a9
	calla	get_char_ani
	callr	get_proj_obj_m		; get an object
	mmfm	sp,a0,a1

	move	a10,a5
	calla	adjust_xy_a5
	move	a10,a0
	calla	insobj			; put on object list

	movi	pid_proj1,a1
	movi	lk_fireball_proc,a7
	callr	spawn_proj_proc

	move	*a13(p_store2),*a0(p_store2),l	; pass speed of projectile
	move	*a13(p_store3),*a0(p_store3),w	; blob grow speed
	move	*a13(p_store1),a0,w		    	; recover time

	movi	act_proj_sd,a1
	move	a1,*a13(p_action),w			; action: sitting duck

	push	a0
	calla	am_i_airborn
	pull	a0
	jrnc	lkzap3
	clr	a1
	move	a1,*a13(p_action),w			; me airborn ---> no sd

lkzap3	calla	prcslp
	retp


lk_fireball_proc
;	dsound	>1f

	movi	>27,a9
	calla	do_first_a9_frame
*
* growing blob
*
	movk	>10,a11			; 1st stk offset
lkfb3	move	*a13(p_store3),a10,w	; blob grow speed !!
lkfb5
	move	a11,a0
	callr	tell_world_stk		; keep telling the world
	move	a11,a0
	callr	proj_strike_check		; check for collision
	jrc	fireball_hit		; bingo
	sleep	1
	dsj	a10,lkfb5
	inc	a11			; next "stk" table
	calla	do_next_a9_frame
	jrne	lkfb3			; ani done = exit

	movi	>27,a9
	calla	find_ani_part2

	move	*a13(p_store2),a0,l	; a0 = speed of projectile
	callr	set_proj_vel
	movk	4,a0
	calla	init_anirate		; ani speed

lkfb6	calla	next_anirate
	movk	>13,a0
	callr	tell_world_stk		; keep telling the world
	movk	>13,a0
	callr	proj_strike_check		; collision check
	jrc	fireball_hit		; bingo
	sleep	1
	callr	proj_onscreen_test
	jrnc	lkfb7
	jruc	lkfb6

fireball_hit
	callr	dead_projectile

	movi	>62,a0
	callr	hit_or_blocked_sound

	callr	proj_in_front

	calla	stop_a8
	move	*a8(oypos),a7,w
	push	a7
	calla	match_me_with_him
	pull	a7
	move	a7,*a8(oypos),w		; dont mess with y coordinate

	movi	->5a,a0
	clr	a1
	calla	multi_adjust_xy

	movi	>00040001,a9
	jsrp	animate2_a9
lkfb7	jruc	delete_proj_and_die

**************************************************************************
*											     *
*  Cage Zap										     *
*											     *
**************************************************************************
do_jc_zaphi
	movi	act_jcsnot_hi,a1
	callr	zap_init_special_act	; this is considered a special move
	movi	->a0000,a0		; initial y vel
	movi	>a0000,a1		; x vel
	movi	>8000,a2
	jruc	jczap4

do_jc_zaplo
	movi	act_jcsnot_lo,a1
	callr	zap_init_special_act	; this is considered a special move

	movi	->60000,a0		; initial y vel
	movi	>c0000,a1		; x vel
	movi	>6000,a2


jczap4	mmtm	a12,a0,a1,a2		; push velocity data

	movk	3,a9
	calla	get_char_ani2
	callr	get_proj_obj_m		; get an object
	move	a10,a0
	calla	insobj			; put on object list
	move	a9,a11

	move	*a8(ozpos),a0,w
	inc	a0
	move	a0,*a10(ozpos),w

	tsound	>4c			; throw snot sound

	movi	>26,a9
	calla	get_char_ani		; cage zap ani
	calla	double_next_a9
	sleep	8			; hold 1st frame

	movk	4,a0
	jsrp	double_mframew
	calla	do_next_a9_frame

	movi	pid_proj1,a1
	movi	jc_snot_proc,a7
	callr	spawn_proj_proc

	mmfm	a12,a2,a3,a4		; grab velocity data
	move	a2,*a0(pa10),l
	move	a3,*a0(pa11),l		; pass it
	move	a4,*a0(pa9),l		; pass it

	movi	>20,a1
	jsrp	do_proj_sitting_duck

	calla	do_next_a9_frame	; get out of throw ani
	sleep	3
	retp

jc_snot_proc
	mmtm	sp,a9,a10,a11
	movk	3,a9
	calla	get_char_ani2
	calla	find_part2
	calla	do_next_a9_frame	; biggest blob

	movi	>10,a0
	movi	>40,a1
	calla	multi_adjust_xy		; adjust to last spot
*
* make trailing blob objects
*
	movk	3,a9
	calla	get_char_ani2
	move	a9,a10
	calla	find_part2
	calla	find_part2		; a9 ---> 2nd largest

	move	*a10,a10,l
	move	*a10,a5,l		; a5 = image table to use

	callr	get_snot_trail_oid
	move	a0,a11			; a11 = trail object oid

	move	a8,a10			; a10 = master blob piece
	move	*a8(oslink),*a13(p_store1),l

	movk	6,a6
snot2	move	a8,a7
	calla	gso_dmawnz
	move	*a9+,a1,l
	calla	ani_flag		; shape to next smaller version

	move	a11,*a8(oid),w

	move	*a8(oimg),a2,l
	move	*a10(oxpos),a3,w
	move	*a2(ianioffx),a4,l
	sub	a4,a3
	move	a3,*a8(oxpos),w		; centered starting x point
	move	*a10(oypos),a3,w
	move	*a2(ianioffy),a4,l
	sub	a4,a3
	move	a3,*a8(oypos),w		; centered starting y point

	move	*a7(ozpos),a0,w
	dec	a0
	move	a0,*a8(ozpos),w		; behind previous

	calla	insobja8
	move	a8,*a7(oslink),l		; link to previous blob piece
	dsj	a6,snot2

	clr	a0
	move	a0,*a8(oslink),l		; last piece = zero link
	move	a10,a8

	mmfm	sp,a0,a1,a2

	move	a0,a11
	move	a1,*a8(oyvel),l		; upwards arc
	move	a2,a0
	callr	set_proj_vel

snot3	movi	>10,a0
	callr	tell_world_stk		; keep telling the world
	movi	>10,a0
	callr	proj_strike_check
	jrc	snot_hit

	move	*a10(oyvel),a0,l
	add	a11,a0
	move	a0,*a10(oyvel),l
	sleep	1
	callr	update_blob_snake
	callr	proj_onscreen_test
	jrc	snot3

	callr	get_snot_trail_oid
	calla	dallobj			; delete snot trail objects
	jruc	delete_master_snot

snot_hit
	callr	dead_projectile

	movi	>4d,a0			; snot hit
	callr	hit_or_blocked_sound

	callr	get_snot_trail_oid
	calla	dallobj			; delete snot trail objects

	move	a10,a8
	movk	3,a9
	calla	get_char_ani2
	calla 	find_part2
	calla 	find_part2
	calla 	find_part2

	calla	stop_a8
	movk	3,a0
	jsrp	mframew

delete_master_snot
	move	*a13(p_store1),*a8(oslink),l
	jruc	delete_proj_and_die

update_blob_snake
	move	a10,a0
	move	*a0(oslink),a1,l			; a1 = 2nd blob piece

	move	*a0(oxvel),a2,l
	move	*a0(oyvel),a3,l

ubs7	move	*a1(oxvel),a4,l
	move	*a1(oyvel),a5,l			; save old
	move	a2,*a1(oxvel),l
	move	a3,*a1(oyvel),l			; transfer

	move	a4,a2
	move	a5,a3				; new xfer #'s

	move	a1,a0
	move	*a0(oslink),a1,l
	jrne	ubs7
	rets

get_snot_trail_oid
	movi	oid_snot_trail1,a0
	move	*a13(p_otherguy),a1,l
	move	*a1(oid),a1,w
	cmpi	pid_p1,a1
	jrne	gsto2
	movi	oid_snot_trail2,a0
gsto2	rets

;*************************************************************************

do_throw_fans
	movi	l_throw_fan,a0
	calla	update_tsl

	calla	am_i_airborn
	jrc	do_throw_fans_air

	movi	act_throw_fans,a1
	callr	zap_init_special_act	; this is considered a special move
	movi	>26,a9
	calla	do_first_a9_frame
	sleep	8			; windup

	movk	4,a0
	jsrp	mframew			; wing !!

	tsound	>49			; throw fans sound

	movi	>10,a0			; x adjust
	movi	>10,a1			; y adjust
	callr	get_fan_obj

	movk	5,a0
	jsrp	mframew

	movi	>18,a1
	jauc	do_proj_sitting_duck


do_throw_fans_air
	movi	act_air_fans,a1
	move	a1,*a13(p_action),w
	callr	zap_air_init_special	; this is considered a special move
	clr	a9
	calla	get_char_ani2

	tsound	>49			; throw fans sound
	movk	4,a0
	jsrp	mframew			; windup !

	movi	>10,a0			; x adjust
	movi	>10,a1			; y adjust
	callr	get_fan_obj

	movk	4,a0
	jsrp	mframew

air_throw_drop
	movk	6,a9
	calla	find_ani_last_frame
	clr	a0	 		; a0 = initial x vel
	clr	a1	  		; a1 = initial y vel
	movi	>8000,a2		; a2 = gravity	
	movk	6,a3			; a3 = ani speed
	jsrp	flight
	jauc	do_land_animation	; retp


get_fan_obj
	mmtm	sp,a0,a1,a9
	movi	>27,a9
	calla	get_char_ani
	callr	get_proj_obj_m		; get an object for fan

	move	a10,a5
	mmfm	sp,a0,a1,a9
	calla	adjust_xy_a5

	move	a10,a0
	calla	insobj			; put on object list

	movi	pid_proj1,a1
	movi	fan_proc,a7
	jruc	spawn_proj_proc		; spawn off hat proc




fan_proc
	movi	>80000,a0
	callr	set_proj_vel
	movi	>27,a9
	calla	get_char_ani

	movk	1,a0
	calla	init_anirate
 
fanp4	calla	next_anirate
	sleep	1

	movi	>10,a0
	callr	tell_world_stk
	movi	>10,a0
	callr	proj_strike_check		; no, check for collision
	jrc	fan_hit
	callr	proj_onscreen_test
	jrc	fanp4
	jruc	delete_proj_and_die

fan_hit
	callr	dead_projectile

	move	b2,b2			; blocked ?
	jrne	fan_blocked

	tsound	>4a			; hit by fans sound

	calla	me_in_front
	calla	stop_a8

	movk	3,a0
	calla	create_blood_proc

	movi	>27,a9
	calla	find_ani_part2		; fast ani when hitting someone

;	movi	>28,a10
	movi	>14,a10
fhit4	sleep	1

	move	*a13(p_otherguy),a7,l
	move	*a7(oxpos),*a8(oxpos),w
	clr	a1
	movi	->40,a0
	calla	multi_adjust_xy

	clr	a6
	move	*a8(oypos),a0,w
	cmpi	>67,a0			; fan at ground level ?
	jrhs	fhit5			; yes, dont move in y anymoe
	move	*a7(oyvel),a6,l		; no, match y vel of victum
fhit5	move	a6,*a8(oyvel),l		; set fan y vel

	calla	next_anirate
	dsj	a10,fhit4

	movi	post_fanned,a7
	calla	xfer_otherguy

fan_blocked
	tsound	>4b			; fans blocked sound

	movi	->60000,a0
	callr	set_proj_vel
	movi	->60000,a0
	move	a0,*a8(oyvel),l		; bounce away !!

fanb5	sleep	1
	calla	next_anirate
	callr	proj_onscreen_test
	jrc	fanb5
	jruc	delete_proj_and_die

**************************************************************************
*											     *
*  Throw Sais										     *
*											     *
**************************************************************************
do_throw_sai
	tsound	>4f			; throw tsai sound

	calla	am_i_airborn
	jrc	do_throw_sai_air

	movi	act_throw_tsai,a1
	callr	zap_init_special_act	; this is considered a special move

	movk	5,a9
	calla	get_char_ani2
	calla	do_next_a9_frame
	sleep	6			; pause for a sec
	movk	3,a0
	jsrp	mframew			; wing !!

	push	a9
	movk	6,a9
	calla	get_char_ani2
	callr	get_proj_obj_m		; get an object for sai
	pull	a9
	move	a10,a0
	calla	insobj			; put on object list

	movi	pid_proj1,a1
	movi	sai_proc,a7
	callr	spawn_proj_proc		; spawn off hat proc

	movk	4,a0
	jsrp	mframew			; shwing !
	movi	>20,a1
	jauc	do_proj_sitting_duck

do_proj_sitting_duck
	movi	act_proj_sd,a0
	move	a0,*a13(p_action),w	; I am a sitting duck
	move	a1,a0
	calla	prcslp
        	retp


do_throw_sai_air
	callr	zap_air_init_special	; this is considered a special move

	movk	7,a9
	calla	get_char_ani2
	calla	do_next_a9_frame
	sleep	6
	movk	3,a0
	movi	act_air_tsai,a1
	jsrp	act_mframew

	movk	6,a9
	calla	get_char_ani2
	callr	get_proj_obj_m		; get an object for sai

	movi	-5,a0
	movi	-7,a1
	move	a10,a5
	calla	adjust_xy_a5		; adjust up to her hands

	move	a10,a0
	calla	insobj			; put on object list

	movi	pid_proj1,a1
	movi	sai_proc,a7
	callr	spawn_proj_proc		; spawn off hat proc

	sleep	8

	jruc	air_throw_drop


sai_proc
	movi	>b0000,a0
	callr	set_proj_vel
	movk	6,a9
	calla	get_char_ani2

	movk	3,a0
	calla	init_anirate

saip4	calla	next_anirate
	sleep	1
	movi	>11,a0
	callr	proj_strike_check		; no, check for collision
	jrc	sai_hit
	callr	proj_onscreen_test
	jrc	saip4
	jruc	delete_proj_and_die

sai_hit
	callr	dead_projectile

	calla	stop_a8

	movi	>51,a0			; tsai blocked sound !!!
	move	b2,b2			; blocked ?
	jrne	saih4			; yes

	movi	>10000,a0
	callr	set_proj_vel		; slow down during explosion
	movi	>50,a0			; tsai hit sound

saih4	calla	triple_sound

	calla	me_in_front
	movk	6,a9
	calla	get_char_ani2
	calla	find_part2		; hit ani
	movk	3,a0
	jsrp	mframew
	jruc	delete_proj_and_die


do_throw_bolt
	callr	zap_init_special 	; this is considered a special move

	movi	act_throw_bolt,a1
	move	a1,*a13(p_action),w
	
	movi	>27,a9
	calla	get_char_ani
	callr	get_proj_obj_m		; get an object
	move	a10,a0
	calla	insobj			; put on object list
	move	a9,a11

	move	*a8(ozpos),a0,w
	inc	a0
	move	a0,*a10(ozpos),w

	tsound	>57			; lightning zap

	movi	>26,a9
	calla	get_char_ani		; zap ani
	movk	3,a0
	jsrp	double_mframew		; here's the wind up !!

	movi	pid_proj1,a1
	movi	lightning_proc,a7
	callr	spawn_proj_proc
	move	a10,*a0(pa8),l

	sleep	36
	retp


lightning_proc
	movi	>27,a9
	calla	find_ani_part2
	movk	2,a0
	jsrp	mframew			; grow !

	jsrp	light_pre_check
	jrc	lightning_hit
	jsrp	light_pre_check
	jrc	lightning_hit

	movi	>a0000,a0
	calla	set_proj_vel		; fly !!
	movk	3,a0
	calla	init_anirate

*
* lightning flight
*
light3	sleep	1
	movi	>11,a0
	callr	proj_strike_check
	jrc	lightning_hit

	calla	next_anirate
	callr	proj_onscreen_test
	jrc	light3
	jruc	delete_proj_and_die


lightning_hit
	callr	dead_projectile

	movi	>58,a0
	callr	hit_or_blocked_sound

	calla	stop_a8
	movi	>27,a9
	calla	find_ani_part2
	calla	find_part2
	calla	find_part2			; lightning hit ani !!

	move	*a13(p_otherguy),a10,l

	calla	match_me_with_him
	calla	flip_multi

	movi	->90,a0
	movi	>00,a1
	calla	multi_adjust_xy

	movk	4,a0
	calla	init_anirate

lhit4	sleep	1
	calla	next_anirate
	jreq	delete_proj_and_die
	move	*a10(oxvel),*a8(oxvel),l
	move	*a10(oyvel),*a8(oyvel),l
	jruc	lhit4

light_pre_check
	calla	do_next_a9_frame
	sleep	1
	movi	>10,a0
	callr	proj_strike_check
	jrc	lpc9
	sleep	1
	movi	>10,a0
	callr	proj_strike_check
lpc9	retp

**************************************************************************
*											     *
*  Shang Tsung Zap !									     *
*											     *
**************************************************************************
do_st_zap3
	movi	act_throw_skull3,a1
	jsrp	shang_zap_setup
	callr	spawn_a_skull
	sleep	>10
	callr	spawn_a_skull
	sleep	>10
	callr	spawn_a_skull
	movi	>30,a11
	jruc	skull_fire_sd

do_st_zap2
	movi	act_throw_skull2,a1
	jsrp	shang_zap_setup
	callr	spawn_a_skull
	sleep	>10
	callr	spawn_a_skull
	movi	>20,a11
	jruc	skull_fire_sd

do_st_zap1
	movi	act_throw_skull1,a1
	jsrp	shang_zap_setup
	callr	spawn_a_skull
	movi	>20,a11

skull_fire_sd
	movi	act_skull_sd,a1
	move	a1,*a13(p_action),w
	move	a11,a0
	calla	prcslp
	retp



spawn_a_skull
	movi	>27,a9
	calla	get_char_ani
	callr	get_proj_obj_m		; get an object
	move	a10,a0
	calla	insobj			; put on object list
	movi	pid_proj1,a1
	movi	st_skull_proc,a7
	jruc	spawn_proj_proc

shang_zap_setup
	move	a1,*a13(p_action),w	; define me action

	callr	zap_init_special		; this is considered a special move
	movi	>00030026,a9
	jauc	animate_a9

st_skull_proc
	callr	proj_in_front

	movi	>00020027,a9
	jsrp	animate_a9		; harmless part

	tsound	>76

	movk	>10,a10
	jsrp	skull_pre_zap
	movk	>10,a10
	jsrp	skull_pre_zap
	movk	>11,a10
	jsrp	skull_pre_zap

	movi	>a0000,a0
	callr	set_proj_vel
	movk	3,a0
	calla	init_anirate		; animation speed

skull3	calla	next_anirate
	movk	>11,a0
	callr	proj_strike_check		; collision check
	jrc	skull_hit		; bingo
	sleep	1
	callr	proj_onscreen_test
	jrc	skull3
	jruc	delete_proj_and_die


pre_skull_hit
	pullp	a0			; no return

skull_hit
	callr	dead_projectile

	movi	>77,a0
	callr	hit_or_blocked_sound

	movi	ft_kang,a0
	move	a0,*a8(ochar),w		; borrow ochar from kang

	movi	>27,a9
	calla	get_char_ani
	move	*a9,a0,l
	move	*a0,a0,l
	move	*a0(icmap),a0,l
	calla	swpal			; switch to fireball pal

	move	*a8(oxvel),a0,l
	sra	2,a0
	move	a0,*a8(oxvel),l		; slow down while exploding

	move	a0,a0
	jrne	skhit4
	movi	>20000,a0
	callr	set_proj_vel		; if close ---> start moving anyways

skhit4	move	*a8(oypos),a0,w
	calla	match_me_with_him
	move	a0,*a8(oypos),w		; dont mess with y coordinate

	movi	->5a,a0
	movi	->08,a1
	calla	multi_adjust_xy		; adjust to where skull was

	movi	>00040001,a9
	jsrp	animate2_a9
	jruc	delete_proj_and_die


skull_pre_zap
	calla	do_next_a9_frame
	movk	2,a11
spz3	move	a10,a0
	callr	proj_strike_check		; collision check
	jrc	pre_skull_hit
	sleep	1
	dsj	a11,spz3
	retp

**************************************************************************
*											     *
*  Female Ninja Fan Spin (not really a projectile)				     *
*											     *
**************************************************************************
do_fn_spinfan
	movi	act_sonic,a1
	callr	zap_init_special_act
	movk	1,a9
	calla	get_char_ani2		; lean back ani
	movk	3,a0
	jsrp	mframew

	movi	>27,a9
	calla	get_char_ani
	move	*a9,a5,l
	calla	find_part2
	calla	find_part2		; a9 ----> open / spin
	move	a9,a11
	callr	get_proj_obj_m		; get an object for fan
	move	a10,a0
	calla	insobj
	tsound	>5e			; sonic fanspin sound
*
* spin loop
*
	movk	14,a9			; wave dispatch
	create	pid_sonic,wave_proc	; catch the wave, coke

	movi	>60,a0
spin4	move	a0,*a13(p_anicount),w
	sleep	1
	movi	>12,a0
	callr	proj_strike_check		; no, check for collision
	jrc	wave_hit
	calla	do_next_a11_for_a10
	dsj	a9,spin5		; time for another wave ?
	movk	14,a9			; yes, reset counter
	create	pid_sonic,wave_proc	; catch the wave, coke
spin5	move	*a13(p_anicount),a0,w
	dec	a0
	jrne	spin4
	jruc	spin_exit

wave_hit
	jsrp	post_hit_pause
	jsrp	post_hit_pause
	jsrp	post_hit_pause

	movi	>27,a9
	calla	get_char_ani
	move	*a9,a5,l
	calla	find_part2
	calla	find_part2
	calla	find_part2 		; a9 ----> close fan
	move	a9,a11
*
* close the fan
*
spin_exit
	jsrp	fan_close_ani
	jsrp	fan_close_ani
	jsrp	fan_close_ani		; close the fan
	calla	delete_slave		; I dont need this anymoe !!
	sleep	8

	movk	1,a9
	calla	get_char_ani2		; lean back ani
	move	a9,a10
*
* stand back up
*
	move	a10,a9
	addi	32,a9
	calla	do_next_a9_frame
	sleep	3
	move	a10,a9
	calla	do_next_a9_frame
	sleep	3
	retp


post_hit_pause
	movi	14,a9
php3	sleep	1
	calla	do_next_a11_for_a10	; hold it a bit more after a hit
	dsj	a9,php3
	create	pid_sonic,wave_proc	; catch the wave, coke
	retp

fan_close_ani
	calla	do_next_a11_for_a10
	sleep	3
	retp


wave_proc
	move	a8,a11			; a11 = female ninja obj
	movk	2,a9
	calla	get_char_ani2
	move	*a9,a5,l
	calla	gso_dmawnz
	callr	proj_in_front

	move	a8,a0
	move	a11,a1
	calla	lineup_1pwm		; lineup with female ninja
	calla	insobja8

	movk	6,a0
	jsrp	framew
	move	a8,a0
	calla	delobjp
	die

**************************************************************************
*											     *
*   Handy projectile routines								     *
*											     *
**************************************************************************


**************************************************************************
*											     *
*  spawn_proj_proc - spawn off a proc to handle a projectile		     *
* 											     *
*   a7 = address										     *
*  a10 = proj object									     *
*											     *
*  p_otherguy										     *
*  p_otherproc										     *
*											     *
**************************************************************************
spawn_proj_proc
	movi	p1p2_proj_pids,a0
	calla	get_char_long
	move	*a8(oid),a1,w
	cmpi	oid_p1,a1
	jreq	spp3
	srl	16,a0
spp3	move	a0,a1
	zext	a1,w		; a1 = proc id

	calla	getprc

	push	a2
	clr	a2
	move	a2,*a0(p_action),w				; no action for this !!
	pull	a2

	move	a10,*a0(pa8),l
	move	a8,*a0(p_store1),l			    	 ; pass thrower !
	move	a13,*a0(p_store2),l			    	 ; pass thrower proc

	move	*a13(p_otherguy),*a0(p_otherguy),l
	move	*a13(p_otherproc),*a0(p_otherproc),l ; pass info to proc
	push	a0
	calla	clear_slave_ram
	pull	a0
	rets

p1p2_proj_pids
	.word	pid_hat1,pid_hat2
	.word	pid_proj1,pid_proj2
	.word	pid_proj1,pid_proj2
	.word	pid_proj1,pid_proj2

	.word	pid_proj1,pid_proj2
	.word	pid_proj1,pid_proj2
	.word	pid_proj1,pid_proj2
	.word	pid_proj1,pid_proj2

	.word	pid_proj1,pid_proj2
	.word	pid_orb1,pid_orb2
	.word	pid_proj1,pid_proj2
	.word	pid_proj1,pid_proj2

	.word	pid_proj1,pid_proj2
	.word	pid_proj1,pid_proj2
	.word	pid_proj1,pid_proj2
	.word	pid_proj1,pid_proj2

**************************************************************************
*											     *
*  proj_onscreen_test - Answers "Is a projectile (a8) onscreen ?	     *
* 											     *
*  Returns:   Carry set = yes								     *
*           Carry clear = no								     *
*											     *
**************************************************************************
proj_onscreen_test
	move	*a8(oflags2),a4,w
	btst	b_multipart,a4
	jrne	pot4
*
* single part object
*
	move	*a8(oxvel),a0,l
	jrnn	pot41
	move	*a8(oxpos),a3,w
	move	*a8(osizex),a2,w
	add	a2,a3
	jruc	pot3

pot41	move	*a8(oxpos),a2,w
	jruc	pot6
*
* multipart object
*
pot4	move	*a8(oxvel),a0,l
	jrnn	pot5
	calla	rightmost_mpart		; a3 = right point
pot3	move	@worldtlx+16,a5,w	; a5 = left world x
	cmp	a3,a5
	jrle	pot_yes
pot_no	clrc
	rets

pot5	calla	leftmost_mpart		; a2 = left point
pot6	move	@worldtlx+16,a5,w
	addi	scrrgt,a5		; a5 = right world x
	cmp	a2,a5
	jrlt	pot_no
pot_yes	setc
	rets

**************************************************************************
*											     *
*  get_proj_obj - Get a projectile object for a player.			     *
* 											     *
*  Input: a8 = player who wants one   Returns: a10 = proj obj		     *
*         a9 = frame #1										*
*											     *
**************************************************************************
get_proj_obj_m
	push	a8
	calla	gmo_proc			; a0 = process which holds data
	move	a8,a10				; a10 = object
	move	a0,*a8(oslink),l		; oslink = process
	pull	a8

	move	*a8(ochar),*a10(ochar),w	; same ochar as thrower
	move	a10,*a13(p_slave),l		; projectiles are slave objects

	movi	front_z+1,a0
	move	a0,*a10(ozval),l

	movi	ochar_proj_oids,a0
	calla	get_char_long

	move	*a8(oid),a1,w
	cmpi	oid_p1,a1
	jreq	gpo8				; player 1 projectile oid
	srl	16,a0				; player 2 projectile oid
gpo8	move	a0,*a10(oid),w			; give oid to projectile object

	move	a10,a0
	calla	match_ani_points		; lineup proj with thrower !
	rets

ochar_proj_oids
	.word	oid_hat1,oid_hat2			; hathead
	.word	oid_fireball,oid_fireball		; kang
	.word	oid_snot,oid_snot			; cage
	.word	0,0					; raptor
	.word	oid_fans1,oid_fans2			; fans a spinnin'
	.word	oid_sai1,oid_sai2

	.word	0,0
	.word	0,0
	.word	0,0
	.word	oid_slow_proj,oid_slow_proj	; reptile
	.word	0,0
	.word	0,0

*
*          a8 = projectile object
* *a8(oslink) = process holding projectile data
*
delete_proj_and_die
	move	*a8(oslink),a0,l
	calla	kill			; kill "data storage" process

	move	a8,a0
	calla	delobjp
	die

set_proj_vel
	move	*a8(oflags),a4,w
	btst	b_fliph,a4
	jreq	spv6
      	neg	a0
spv6	move	a0,*a8(oxvel),l		; send it flyin'
	rets

proj_in_front
	movi	front_z+1,a0
	move	a0,*a8(ozval),l		; in front of players
	rets

hit_or_blocked_sound
	move	b2,b2		; blocked ?
	jreq	hob5		; no
	inc	a0		; yes, use blocked sound
hob5	jauc	triple_sound


tell_world_stk
	calla	get_char_stk
	move	a0,*a13(p_joyport),l	; save stk table here !!
	rets

dead_projectile
	movi	act_proj_dead,a0
	move	a0,*a13(p_action),w
	rets


proj_strike_check
	push	a14
	move	*a13(p_otherguy),a14,l
	move	*a14(ochar),a14,w
	cmpi	ft_jade,a14
	pull	a14
	jreq	projsc9
	jauc	strike_check_a0
projsc9	clrc				; no collision
	rets

;************************************************************************

	.end
