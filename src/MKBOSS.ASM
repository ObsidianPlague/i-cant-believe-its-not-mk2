**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: DRONE CODE										*
* 											     *
*  copyright (c) 1993 Midway Manufacturing							*
*											     *
**************************************************************************
	.file	'mkdrone.asm'
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
	.include	diagaudn.asm
	.text

**************************************************************************
*											     *
*                KINTARO  KINTARO  KINTARO  KINTARO				     *
*                KINTARO  KINTARO  KINTARO  KINTARO				     *
*                KINTARO  KINTARO  KINTARO  KINTARO				     *
*											     *
**************************************************************************
goro_stalk

;*********
;	movi	>5530,a10
;	jsrp	drone_stance_wait	; hang out
;*********

	callr	goro_stalk_zap

	movi	200,a0	
	calla	randper
	jrc	goro_psycho_stomp

	callr	goro_dummy_jump

	calla	face_opponent
goro0	calla	drone_walkf_setup

goro1	calla	am_i_facing_him
	janc	drone_turnaround
	sleep	1
	calla	next_anirate
	calla	drone_beware
	calla	drone_get_x_dist   	; a3 = distance tween us

;	cmpi	>70,a3
	cmpi	>60,a3

	jrhi	goro1
*
* Kintaro close attack !!
*
	calla	get_his_action
	cmpi	act_fk_sd,a1
	jrne	goro2
*
* other dude = landing from a flip kick/punch
*
	movi	act_flykick,a1
	calla	count_q_repeats	 		; a3 = # of hits so far
	cmpi	3,a3
	jrhs	goro_discourage_flipkp	; discourage abusers
	movi	act_flypunch,a1
	calla	count_q_repeats	 		; a3 = # of hits so far
	cmpi	3,a3
	jrhs	goro_discourage_flipkp	; discourage abusers
	jruc	goro_stance_wait		; be easy on others

goro2	calla	is_he_airborn
	jrc	goro3				; he is in the air

	movi	300,a0
	calla	randper
	jrc	goro_slam			; random body slam

goro3	move	*a8(p_otherguy),a0,l
	move	*a0(oyvel),a1,l
	jrn	goro_air_wait			; heading up

goro4	callr	goro_dummy_roar

	callr	drone_get_x_dist   		; a3 = distance tween us
	cmpi	>60,a3
	jrls	goro_uppercut

	movi	rt_goro_close,a0
	jauc	random_do

rt_goro_close
	.word	2
	.long	goro_punch
	.long	goro_kick

goro_air_wait
	movi	is_he_close_ground,a11
	movi	>30,a10			; max wait time
	jsrp	stance_wait_yes

	callr	goro_mean_check
	jrc	goro4

	movi	is_he_grounded,a11
	movi	>30,a10			; max wait time
	jsrp	stance_wait_yes
	jruc	goro0
;	jruc	goro4

**************************************************************************

goro_stalk_zap
	calla	get_x_dist
	cmpi	>80,a3			; far apart ?
	jrlo	gdr9			; no

	movi	diff_zap_chances,a0
	calla	get_diff_word		; a0 = chance of zap
	calla	randper
	jrnc	gdr9

	pull	a0
	jauc	drone_zap_jump

diff_zap_chances
	.word	50,50,50,100,150,175,200,250,275,280,300

**************************************************************************

goro_dummy_jump
	calla	get_x_dist
;	cmpi	>c0,a3			; far apart ?
	cmpi	>a0,a3			; far apart ?
	jrlo	gdr9			; no

	calla	am_i_way_ahead
	jrnc	gdj5

	move	@c_goro_dummy,a1,w
	cmpi	8,a1
	jrhi	gdj5			; enough already !!!

	movi	500,a0
	calla	randper
	jrc	gdj8

gdj5	movi	diff_dummy_counts,a0
	calla	get_diff_word		; a0 = count allowed
	move	@c_goro_dummy,a1,w
	cmp	a0,a1
	jrhi	gdr9

	movi	ask_goro_dummy,a0
	calla	ask_mr_diff
	jrnc	gdr9

gdj8	move	@c_goro_dummy,a1,w
	inc	a1
	move	a1,@c_goro_dummy,w	; bump da count

	pull	a0
	jsrp	goro_jump
	jruc	drone_reaction_exit

**************************************************************************

goro_dummy_roar
	movi	diff_dummy_counts,a0
	calla	get_diff_word		; a0 = count allowed
	move	@c_goro_dummy,a1,w
	cmp	a0,a1
	jrhi	gdr9

	movi	ask_goro_dummy,a0
	calla	ask_mr_diff
	jrnc	gdr9

	inc	a1
	move	a1,@c_goro_dummy,w	; bump da count

	pull	a0
	jsrp	goro_roar		; roar like an idiot
	jruc	drone_reaction_exit

gdr9	rets

diff_dummy_counts
	.word	10,10,10,8,8,7,6,6,4,4

ask_goro_dummy
	.word	500,500,500,500,450,400,350,300,250,150,100

**************************************************************************
	
goro_mean_check
	movi	500,a0
	jauc	randper

**************************************************************************

goro_charge_slam
	movi	>30,a10
	movi	can_goro_slam,a11
	jsrp	goro_walk_wait_yes
	calla	can_goro_slam
	jrc	goro_slam
	jruc	drone_reaction_exit

**************************************************************************

goro_discourage_flipkp
	movi	700,a0
	calla	randper
	jrc	goro_slam
	jruc	goro_stance_wait



goro_slam
	calla	init_special

	movi	>30,a7
	move	a7,@f_norepell,w	; start the count down

	movi	flipped_pause,a7
	calla	takeover_him
	movi	act_bodyslam,a1
	move	a1,*a13(p_action),w
	move	a1,*a0(pa11),l

	tsound	>b1			; goro big roar

	movi	>00040006,a9
	jsrp	animate_a9		; grab

	calla	match_him_with_me_f

	move	a9,a6
	movi	>3e,a9
	calla	get_his_char_ani
	move	a9,a11
	move	a6,a9

	movi	>30,a0
	movk	4,a0
	jsrp	double_mframew		; all together now !!

	movi	slammed_by_goro,a7
	calla	xfer_otherguy
	movi	>0008000a,a11
	calla	shake_a11

	tsound	>b3			; crowd cheers for goro slam !!

	sleep	>10
	movk	5,a0
	jsrp	mframew			; get out of slam

	calla	flip_multi
	jruc	goro_sanity_pause

**************************************************************************

goro_jump
	movi	400,a0
	calla	randper
	jrnc	gjmp3

	clr	a11
	jsrp	goro_stupid_jump

gjmp3	movi	->80000,a11

goro_stupid_jump
	movi	>0003000a,a9
	jsrp	animate_a9
	tsound	>b1				; long goro roar

	move	a11,a0
	movi	->a0000,a1
	movi	>c000,a2
	movi	never_ani,a3
	jsrp	flight

	movi	>000a000f,a11
	calla	shake_a11			; boom !!
	callr	goro_psycho_land_frame

	tsound	>b2				; quake sound
	sleep	>10
	retp

**************************************************************************

goro_psycho_stomp
	calla	init_special

	movi	act_psycho_goro,a1
	move	a1,*a13(p_action),w
	move	*a13(p_otherguy),a0,l
	move	*a0(oxpos),a11,l	; save his x

	tsound	>87			; hh teleport sound
	tsound	>b1			; long goro roar
;	tsound	>b3			; crowd

	movi	>0003000a,a9
	jsrp	animate_a9

	movi	->a0000,a0
	move	a0,*a8(oyvel),l
	movi	->20000,a0
	move	a0,*a8(ograv),l

psy3	sleep	1
	calla	distance_off_ground
	cmpi	>110,a0
	jrlo	psy3

	calla	stop_me
	calla	do_next_a9_frame	; pose: pounce
	sleep	8

	move	a11,*a8(oxpos),w	; lineup to where he was
	clr	a11			; flag: we have not checked yet
	clr	a0
	movi	>40000,a1
	movi	>10000,a2
	movi	never_ani,a3
	movi	psycho_fall_call,a6
	jsrp	flight_call

	movi	>000a000f,a11
	calla	shake_a11		; boom !!
	callr	goro_psycho_land_frame

	movi	diff_psycho_chances,a0
	calla	ask_mr_diff
	jrnc	psy5

	jsrp	goro_roar
	jruc	drone_reaction_exit

psy5	sleep	>0a
	jruc	drone_reaction_exit


diff_pycho_roar
	.word	500,500,500,500,500,475,450,400,250,200,150



psycho_fall_call
	movk	3,a0
	move	a0,@f_norepell,w 	; keep us 2-gether

	calla	distance_off_ground
	cmpi	>50,a0
	jrhi	pfc9

	move	a11,a11
	jrne	pfc9			; only check once !!!

	movk	1,a11
	calla	drone_get_x_dist
	cmpi	>60,a3			; did I get him ?	
	jrlo	goro_pycho_hit		; yes

pfc9	rets


goro_psycho_land_frame
	movi	>0a,a9
	jauc	do_first_a9_frame


goro_pycho_hit
	pull	a0
	pull	a0
	calla	reset_proc_stack
	calla	me_in_front

	movi	rsnd_death_voice,a0
	calla	calla_for_him

	movi	>0f,a9
	calla	get_his_char_ani
	calla	find_part2
	calla	find_part2
	calla	find_last_frame
	push	a8
	move	*a13(p_otherguy),a8,l
	calla	do_next_a9_frame		; pose him: laying down
	pull	a8			

	movi	flipped_pause,a7
	calla	takeover_him			; him = out o commision
	move	*a13(p_action),a1,w
	move	a1,*a0(pa11),l			; pass my action

	movi	dont_touch,a0
	move	a0,a1
	move	a0,a2
	movi	never_ani,a3
	movi	psycho_lineup,a6
	jsrp	flight_call

	tsound	>b2				; quake sound
	calla	ground_him
	movi	>000a000f,a11
	calla	shake_a11			; boom !!
	callr	goro_psycho_land_frame

;	movi	>48,a0
	movi	>38,a0
	calla	damage_to_him

	sleep	8
*
* pound - pound - pound
*
	movk	3,a0
gps5	move	a0,*a13(p_store1),w
	movi	>0004000a,a9
	jsrp	animate_a9

	movk	4,a0
	jsrp	mframew

	tsound	>b2				; quake sound
	movi	>00080005,a11
	calla	shake_a11			; boom !!
	calla	check_winner_status
	sleep	5

	move	*a13(p_store1),a0,w
	dsj	a0,gps5
*
* jump out of the way
*
	movi	>0004000a,a9
	jsrp	animate_a9
	calla	get_my_dfe			; a5 / a6

	movi	>60000,a0			; initial x vel
	cmp	a5,a6
	jrhi	gsp7				; final jump right
	neg	a0
gsp7	movi	->a0000,a1
	movi	>c000,a2			; grav
	movi	never_ani,a3
	movi	>0a,a9
	jsrp	flight

	clr	a0
	move	a0,*a13(p_action),w		; let him wakeup

	movi	>00080008,a11
	calla	shake_a11			; boom !!
	movi	>0a,a9
	calla	find_ani_part2
	addi	32*2,a9
	calla	do_next_a9_frame		; land pose
	sleep	12
	jsrp	goro_roar
	jruc	drone_reaction_exit


psycho_lineup
	calla	match_him_with_me_f
	clr	a0
	movi	->30,a1
	calla	adjust_him_xy
	movk	3,a0
	move	a0,@f_norepell,w
	rets

**************************************************************************

goro_uppercut
	calla	init_special

	tsound	>ae			; goro uhh sound

	movk	3,a0
	clr	a1
	movk	5,a9
	movk	3,a10
	movk	2,a11
	jsrp	striker			; uppercut !!!

	movi	>1d,a0			; full contact hit
	movi	>10,a1			; blocked hit
	movi	>08,a2			; miss
	jruc	goro_post_strike

**************************************************************************

goro_kick
	calla	init_special

	tsound	>ae			; goro uhh sound

	movk	3,a0
	clr	a1
	movk	4,a9
	movk	4,a10
	movk	1,a11
	jsrp	striker		; kick !!!

	movi	>12,a0		; full contact hit
	movi	>08,a1		; blocked hit
	movi	>08,a2		; miss
	jruc	goro_post_strike

**************************************************************************

goro_punch
	calla	init_special

	tsound	>ae			; goro uhh sound
	movk	3,a0
	clr	a1
	movk	3,a9
	movk	3,a10
	clr	a11
	jsrp	striker

	movi	>12,a0			; full contact hit
	movi	>08,a1			; blocked hit
	movi	>08,a2			; miss
	jruc	goro_post_strike

goro_post_strike
	jrc	goro_punch_hit
	move	a2,a0			; missed sleep
	jruc	goro_strike_missed

goro_punch_hit
	move	b2,b2
	jrne	goro_punch_blocked

	calla	prcslp
	movk	4,a0
	jsrp	mframew			; retract
	jruc	goro_sanity_pause

goro_sanity_pause
	movi	250,a0
	calla	randper
	jrnc	goro_stance_wait

	jsrp	goro_roar
	jruc	drone_reaction_exit

goro_stance_wait
	tsound	>ab			; sound: purr
	movi	>30,a10
	jsrp	drone_stance_wait	; hang out
	jruc	drone_reaction_exit

goro_punch_blocked
	move	a1,a0

goro_strike_missed
	calla	prcslp
	movk	4,a0
	jsrp	mframew			; retract
	jruc	drone_reaction_exit

goro_roar
	calla	init_special

	tsound	>ad			; sound: roar !!
	movi	>00030007,a9
	jsrp	animate_a9		; ROAR !!!!
	sleep	>0a
	movk	3,a0
	jauc	mframew			; unroar animation

*************************************************************************

goro_block
	calla	init_special
	movi	act_blockhi,a1
	move	a1,*a13(p_action),w
	movk	8,a9
	calla	get_char_ani
	movk	3,a0
	jsrp	mframew

	jsrp	boss_wait_nonattack

	move	a10,a10
	jreq	stop_abusive_attackers
	jruc	drone_reaction_exit

stop_abusive_attackers
	calla	can_goro_slam
	jrc	goro_slam
	movi	200,a0
	calla	randper
	jac	drone_zap_jump
	jruc	drone_reaction_exit

*************************************************************************

kahn_block_proj
goro_block_proj
	calla	init_special
	movi	act_blockhi,a1
	move	a1,*a13(p_action),w

	movk	8,a9
	calla	get_char_ani
	movk	3,a0
	jsrp	mframew

	jsrp	wait_proj_spawn
	jsrp	wait_proj_pass		; wait for projectile to pass
	jruc	drone_reaction_exit

*************************************************************************

goro_counter_all
	callr	drone_get_his_action		; a1
	move	a1,a1
	jreq	boss_return_to_beware
	srl	8,a1				; just use the catagory part
	sll	5,a1
	addi	goro_catagory_jumps,a1
	move	*a1,a1,l
	jreq	boss_return_to_beware
	jump	a1


goro_catagory_jumps
	.long	goro_counter_projectile
	.long	goro_counter_stationary
	.long	goro_counter_propell
	.long	0
	.long	0
	.long	0
	.long	goro_counter_sd			; sitting duck
	.long	0
	.long	0

;*************************************************************************

goro_counter_stationary
	calla	get_his_action		; a1 = his action
	movk	3,a7
	calla	react_jump_table
	.long	goro_avoid_stationary
	.long	goro_avoid_stationary

goro_avoid_stationary
	calla	get_his_action			; a1 = his action
	cmpi	act_shred,a1
	jreq	goro_avoid_shred
	cmpi	act_sonic,a1
	jreq	goro_avoid_sonic		; sonic waves ??

	calla	will_he_reach_me
	jrc	goro_block

	cmpi	>40,a3
	jrhi	boss_return_to_beware		; far off = ignore

	movi	>40,a10
	movi	is_he_done_attacking,a11
	jsrp	stance_wait_yes
;	jsrp	boss_wait_nonattack

	callr	can_goro_slam
	jrc	goro_slam
	jauc	drone_zap_jump


goro_avoid_shred
	calla	will_he_reach_me
	jrc	goro_block
	jruc	goro_charge_slam

goro_avoid_sonic
	movi	act_sonic,a1
	calla	count_q_repeats		; a3 = # of hits so far
	cmpi	3,a3
	jrhs	gavson3

	movi	250,a0
	calla	randper
	jrnc	boss_return_to_beware

gavson3	calla	get_x_dist
	cmpi	>a0,a3
	jahi	drone_zap_jump		; far away from me = fire at him
	movi	>80,a10
	movi	is_he_done_attacking,a11
	jsrp	stance_wait_yes
	calla	is_he_done_attacking
	jrnc	drone_reaction_exit
	jauc	drone_zap_jump

;*************************************************************************

goro_counter_sd
	calla	get_his_proj_proc	; projectile in the air ???
	jrne	goro_block_proj		; no
	jruc	boss_return_to_beware

;*************************************************************************

goro_counter_propell
	calla	get_his_action		; a1 = his action
	cmpi	act_flykick,a1
	jreq	goro_counter_flipkp
	cmpi	act_flypunch,a1
	jreq	goro_counter_flipkp

	calla	get_his_action		; a1 = his action
	movk	3,a7
	calla	react_jump_table
	.long	goro_block
	.long	gcprop3

gcprop3	movi	>30,a10
	movi	can_goro_slam,a11
	jsrp	stance_wait_yes	 	; wait for him 2 finish
	callr	can_goro_slam
	jrc	goro_slam
	jruc	drone_reaction_exit

can_goro_slam
	calla	get_x_dist
	cmpi	>78,a3
	jrhi	cishn

;*****************
;	calla	is_he_airborn
;	jrc	cishn
;*****************

	setc
	rets
cishn	clrc
	rets

;************************************************************************

goro_counter_flipkp
	calla	get_his_action		; a1 = his action
	movk	1,a7
	calla	react_jump_table
	.long	goro_av_flipkp
	.long	goro_av_flipkp

goro_av_flipkp
	callr	is_flipkp_close
	jrc	goro_block		; close to me = block the shit !!

	calla	is_towards_me
	jrnc	boss_return_to_beware	; far away + heading away = ignore

	movi	>30,a10
	movi	is_flipkp_close,a11
	jsrp	stance_wait_yes	 	; wait for him 2 get close
	jruc	goro_block

is_flipkp_close
	calla	is_he_airborn
	jrnc	ifkcy			; on ground = abort out

	calla	get_x_dist
	cmpi	>80,a3
	jrhi	ifkcn

ifkcy	setc
	rets
ifkcn	clrc
	rets

;*************************************************************************

goro_counter_projectile
	calla	get_his_action		; a1 = his action
	cmpi	act_throw_skull2,a1
	jreq	goro_counter_skulls
	cmpi	act_throw_skull3,a1
	jreq	goro_counter_skulls

	movk	1,a7
	calla	react_jump_table
	.long	drone_zap_jump
	.long	goro_av_proj

goro_av_proj
	callr	drone_get_x_dist
	cmpi	>80,a3
	jrlo	goro_slam		; he is close ---> grab him
	cmpi	>a0,a3
	jrlo	goro_punch

	move	*a13(p_otherguy),a0,l
	move	*a0(ochar),a1,w
	cmpi	ft_scorpion,a1
	jaeq	drone_zap_jump

	movi	diff_psycho_chances,a0
	calla	get_diff_word
	calla	randper
	jrc	goro_psycho_stomp	; counter this with a stomp
	jruc	goro_block_proj


diff_psycho_chances
	.word	100,100,100,100,100,250,350,375,400,500


goro_counter_skulls
	movi	act_throw_skull1,a1
	calla	count_q_repeats		; a3 = count
	cmpi	2,a3
	jahs	drone_zap_jump		; sorry shang, but this gets annoying
	jruc	boss_return_to_beware

**************************************************************************
*											     *
*                           SHAO KAHN							     *
*                           SHAO KAHN							     *
*                           SHAO KAHN							     *
*                           SHAO KAHN							     *
*											     *
**************************************************************************
kahn_taunt
	move	@c_sk_taunt,a0,w
	inc	a0
	cmpi	5,a0
	jrls	riwk3
	clr	a0
riwk3	move	a0,@c_sk_taunt,w		; update counter

	sll	4,a0
	addi	kahn_intro_taunts,a0
	move	*a0,a0,w
	calla	triple_sound2

	movi	>18,a9
	calla	get_char_ani

	movk	2,a10
riwk5	movk	3,a0
	jsrp	mframew			; point

	movk	6,a0
	calla	randu
	addk	10,a0
	calla	prcslp

	dsj	a10,riwk5

	movi	>18,a9
	calla	find_ani_part2
	calla	find_part2
	movk	3,a0
	jsrp	mframew			; unpoint
	retp

kahn_intro_taunts
	.word	>43
	.word	>44
	.word	>45
	.word	>46
	.word	>47
	.word	>48

kahn_start
	movi	rt_kahn_start,a0
	jauc	random_do

rt_kahn_start
	.word	3
	.long	kahn_stalk
	.long	kahn_charge
	.long	kahn_zap


kahn_attack_voice
	movi	>00500051,a1
	jauc	randsnd2

**************************************************************************

kahn_stalk

;*********
;	movi	>5530,a10
;	jsrp	drone_stance_wait	; hang out
;*********

	callr	kahn_dummy_talk

	movi	>68,a11
	jsrp	kahn_stalk_a11

	calla	am_i_way_ahead		; am i wasting him ?
	jrnc	kahn2			; no, fight !!

	move	@winner_status,a0,w
	cmpi	3,a0
	jreq	kahn2

	movi	800,a0
	calla	randper
	jrc	kahn_free_hit

kahn2	calla	is_he_short
	jrnc	kahn3

	movi	800,a0
	calla	randper
	jrc	kahn_charge		; ducking = charge


kahn3	calla	is_he_airborn	
	jrnc	kahn4			; not airborn

	movi	>20,a10
	movi	is_he_grounded,a11
	jsrp	stance_wait_yes

kahn4	movi	rt_kahn_attack,a0
	jauc	random_do

rt_kahn_attack
	.word	4
	.long	kahn_uppercut
	.long	kahn_punch
	.long	kahn_kick
	.long	kahn_charge

;************************************************************************

kahn_dummy_talk
	move	@tick,a0,w
	cmpi	>90,a0
	jrlo	gdr9

	movi	diff_kahn_dummy_counts,a0
	calla	get_diff_word		; a0 = count allowed
	move	@c_kahn_dummy,a1,w
	cmp	a0,a1
	jrhi	gdr9

	movi	ask_kahn_dummy,a0
	calla	ask_mr_diff
	jrnc	gdr9

	move	@c_kahn_dummy,a1,w
	inc	a1
	move	a1,@c_kahn_dummy,w	; bump da count
	pull	a0
*
* kahn talk shit
*
	movk	6,a0
	calla	randu
	dec	a0
	sll	4,a0
	addi	kahn_shit_taunts,a0
	move	*a0,a0,w
	calla	triple_sound2

	movi	>18,a9
	calla	get_char_ani

	movk	3,a0
	jsrp	mframew			; point
	sleep	10

	movk	3,a0
	jsrp	mframew			; point
	sleep	10

	movi	>18,a9
	calla	find_ani_part2
	calla	find_part2
	movk	3,a0
	jsrp	mframew			; unpoint
	jruc	drone_reaction_exit

ask_kahn_dummy
	.word	500,300,300,300,300,230,175,125,100,100,75

diff_kahn_dummy_counts
	.word	10,10,10,6,5,4,4,3,3,2

kahn_shit_taunts
	.word	>43
	.word	>44
	.word	>45
	.word	>46
	.word	>47
	.word	>48

;************************************************************************

kahn_backup_a11
	calla	face_opponent
	calla	drone_walkb_setup
	movk	>0a,a9
	calla	get_char_ani		; kahn walk backwards ani

kback3	calla	am_i_facing_him
	janc	drone_turnaround
	sleep	1
	calla	next_anirate
	calla	drone_beware

	move	*a8(oxvel),a0,l
	jreq	kback9			; I stopped moving ---> exit

	callr	drone_get_x_dist   	; a3 = distance tween us
	cmp	a11,a3
	jrlo	kback3
kback9	retp


kahn_stalk_a11
	calla	face_opponent
	calla	drone_walkf_setup

kstk4	calla	am_i_facing_him
	janc	drone_turnaround
	sleep	1
	calla	next_anirate
	calla	drone_beware
	callr	drone_get_x_dist   	; a3 = distance tween us
	cmp	a11,a3
	jrhi	kstk4
	retp

;************************************************************************

kahn_free_hit
	movi	>40*3,a10
	calla	drone_stance_setup

kfree3	calla	next_anirate

	move	@winner_status,a0,w
	cmpi	3,a0
	jreq	kahn_start

	calla	check_winner_status
	calla	am_i_facing_him
	janc	dwait_turn		; keep facing him
	sleep	1
	dsj	a10,kfree3
	jruc	kahn_start

;************************************************************************

kahn_uppercut
	movi	>50,a11
	jsrp	kahn_stalk_a11

	calla	init_special
	movk	2,a0
	clr	a1
	movk	5,a9
	movk	3,a10
	movk	3,a11
	jsrp	striker			; punch !!!

	movk	12,a0			; full contact hit
	movk	6,a1			; blocked hit
	movk	6,a2			; miss
	jruc	kahn_post_strike

;************************************************************************

kahn_zap
	movi	>13,a0
	clr	a10
	jsrp	do_zap
	jruc	drone_reaction_exit

;************************************************************************

kahn_punch
	movi	>50,a11
	jsrp	kahn_stalk_a11

	callr	kahn_attack_voice

	calla	init_special
	movk	2,a0
	clr	a1
	movk	3,a9
	movk	3,a10
	clr	a11
	jsrp	striker			; punch !!!

	movk	12,a0			; full contact hit
	movk	6,a1			; blocked hit
	movk	6,a2			; miss
	jruc	kahn_post_strike

;************************************************************************

kahn_kick
	calla	init_special

	callr	kahn_attack_voice

	movk	2,a0
	clr	a1
	movk	4,a9
	movk	4,a10
	movk	1,a11
	jsrp	striker			; kick !!!

	movk	16,a0			; full contact hit
	movk	6,a1			; blocked hit
	movk	6,a2			; miss
	jruc	kahn_post_strike

;************************************************************************

kahn_charge
	calla	init_special

	callr	kahn_attack_voice

	movk	>14,a9
	calla	get_char_ani		; charge animation
	movk	3,a0
	calla	init_anirate

	create	pid_trail,trail_proc
	tsound	>43			; shadow kick sound

	movi	>80000,a0
	calla	towards_x_vel
	movi	>10,a11
	movk	6,a10			; # of frames without collision check

kchg6	sleep	1
	calla	next_anirate
	dsj	a10,kchg3		; not time to check for collision yet
	movk	1,a10
	movk	2,a0
	calla	strike_check_a0
	jrnc	kchg3

	calla	stop_me
	movk	>14,a9
	calla	get_char_ani		; charge animation
	calla	find_last_frame
	calla	do_next_a9_frame	; pose on last frame of charge
	sleep	>20
	jruc	kchg8

kchg3	dsj	a11,kchg6
*
* decellerate
*
	calla	am_i_facing_him
	jrnc	kchg7			; not facing him ---> stop now
	movk	8,a11
kchg5	move	*a8(oxvel),a0,l
	abs	a0
	move	a0,a1
	sra	2,a1
	sub	a1,a0

	move	a0,a2
	sra	3,a2
	sub	a2,a0

	calla	towards_x_vel
	sleep	1
	dsj	a11,kchg5

kchg7	calla	stop_me
	sleep	8

kchg8	movk	>14,a9
	calla	find_ani_part2
	movk	3,a0
	jsrp	mframew
	jruc	drone_reaction_exit

;************************************************************************

kahn_post_dont_walk
	move	a10,a10
	jrne	drone_reaction_exit	; no timeout ---> no need to freak !!

kahn_prevent_repeat_punch
	move	@rand,a0,l
	jrn	kpdw3

	movi	>90,a11
	jsrp	kahn_backup_a11
	jruc	kahn_zap

kpdw3	move	@rand,a0,l
	jrn	kahn_charge
	jruc	kahn_kick

;************************************************************************

kahn_post_strike
	jrc	kahn_punch_hit
	move	a2,a0			; missed sleep
	jruc	kahn_strike_missed

kahn_punch_hit
	move	b2,b2
	jrne	kahn_punch_blocked

	calla	prcslp
	movk	4,a0
	jsrp	mframew			; retract
	jruc	kahn_sanity_pause

kahn_sanity_pause
	movi	>30,a10
	jsrp	drone_stance_wait	; hang out
	jruc	drone_reaction_exit

kahn_punch_blocked
	move	a1,a0

kahn_strike_missed
	calla	prcslp
	movk	4,a0
	jsrp	mframew			; retract
	jruc	drone_reaction_exit

;************************************************************************

kahn_counter_all
	callr	drone_get_his_action		; a1
	move	a1,a1
	jreq	boss_return_to_beware
	srl	8,a1				; just use the catagory part
	sll	5,a1
	addi	kahn_catagory_jumps,a1
	move	*a1,a1,l
	jreq	boss_return_to_beware
	jump	a1

kahn_catagory_jumps
	.long	kahn_counter_projectile
	.long	kahn_counter_stationary
	.long	kahn_counter_propell
	.long	kahn_counter_nonattack
	.long	0
	.long	0
	.long	kahn_counter_sd			; sitting duck
	.long	0
	.long	0

kahn_counter_sd
	calla	get_his_proj_proc		; projectile in the air ???
	jrne	kahn_block_proj			; no
	jruc	boss_return_to_beware

kahn_counter_projectile
	calla	get_his_action		; a1 = his action
	cmpi	act_throw_skull2,a1
	jreq	kahn_counter_skulls
	cmpi	act_throw_skull3,a1
	jreq	kahn_counter_skulls

	callr	kahn_3_fork
	.long	boss_return_to_beware	; 0 = chump mode
	.long	kahn_block_proj		; 1 = block
	.long	kahn_screw_proj

kahn_screw_proj
	calla	get_x_dist
	cmpi	>b0,a3
	jrlo	kahn_charge		; close to me ---> CHARGE !!!!
	cmpi	>e0,a3
	jrhi	kahn_zap		; real far ---> zap
	jruc	kahn_block_proj


kahn_counter_skulls
	movi	act_throw_skull1,a1
	calla	count_q_repeats		; a3 = count
	cmpi	2,a3
	jrhs	kahn_zap		; sorry shang, but this gets annoying
	jruc	boss_return_to_beware

*************************************************************************

kahn_counter_propell
	calla	get_his_action		; a1 = his action
	cmpi	act_flykick,a1
	jreq	kahn_counter_flipkp
	cmpi	act_flypunch,a1
	jreq	kahn_counter_flipkp

	calla	get_his_action		; a1 = his action
	movk	1,a7
	calla	react_jump_table
	.long	kahn_block
	.long	kahn_block

kahn_counter_flipkp
	calla	get_his_action		; a1 = his action
	movk	2,a7
	calla	react_jump_table
	.long	kahn_av_flipkp
	.long	kahn_av_flipkp

kahn_av_flipkp
	callr	is_flipkp_close
	jrc	kahn_block		; close to me = block the shit !!

	calla	is_towards_me
	jrnc	boss_return_to_beware	; far away + heading away = ignore

	movi	>30,a10
	movi	is_flipkp_close,a11
	jsrp	stance_wait_yes	 	; wait for him 2 get close
	jruc	kahn_block

*************************************************************************

kahn_counter_nonattack
	calla	get_his_action		; a1 = his action
	cmpi	act_angle_jump,a1
	jrne	return_to_beware
*
* kahn counter angle jump
*
	move	*a13(p_otherguy),a0,l
	move	*a0(oxvel),a0,l
	jrne	return_to_beware 	; not in corner = ignore

	calla	get_x_dist
	cmpi	>b0,a3
	jrhi	return_to_beware 	; far away = ignore

	move	@rand,a0,l
	jrn	kahn_charge

	cmpi	>80,a3
	jrlo	kahn_charge

	movi	>20,a11
	jsrp	kahn_backup_a11
	jruc	kahn_zap

*************************************************************************

kahn_counter_stationary
	calla	get_his_action		; a1 = his action

	cmpi	act_hipunch,a1
	jreq	kahn_counter_punch
	cmpi	act_lopunch,a1
	jreq	kahn_counter_punch

	movk	1,a7
	calla	react_jump_table
	.long	kahn_avoid_stationary
	.long	kahn_avoid_stationary

kahn_avoid_stationary
	calla	will_he_reach_me
	jrc	kahn_block
	cmpi	>40,a3
	jrhi	boss_return_to_beware	; far off = ignore

	movi	>30,a10
	movi	is_he_attacking,a11
	jauc	dont_walk_into_it

kahn_counter_punch
kahn_block
	callr	init_move
	movi	act_blockhi,a1
	move	a1,*a13(p_action),w
	movk	8,a9
	calla	get_char_ani
	movk	3,a0
	jsrp	mframew
	jsrp	boss_wait_nonattack

	move	a10,a10
	jrne	drone_reaction_exit
	jruc	kahn_prevent_repeat_punch

init_move
	calla	stop_me
	calla	ground_player
	jauc	face_opponent

**************************************************************************

kahn_3_fork
	callr	kahn_react_ask		; what do i do now ?
	cmpi	3,a0
	jrlo	kfork2
      	movk	2,a0			; error ---> assume "bad ass mode"
kfork2	pull	a1			; a1 ---> 1st table entry
	sll	5,a0
	add	a1,a0
	move	*a0,a0,l
	jump	a0

kahn_react_ask
	movi	kahn_react_table,a7
	jauc	how_do_i_react

kahn_react_table
	.word	100,300,500,550,600,650,675,700,750,850

;***************************************************************************

drone_get_his_action
	jauc	get_his_action

drone_reaction_exit
	jauc	reaction_exit

drone_get_x_dist
	jauc	get_x_dist

boss_wait_nonattack
	movi	>20,a10
bwnon4	sleep	1
	push	a10
	calla	is_he_done_attacking
	pull	a10
	jrc	bwn_yes
	dsjs	a10,bwnon4
bwn_yes	retp


boss_return_to_beware
	jauc	return_to_beware

;*************************************************************************

	.end
