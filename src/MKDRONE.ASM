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
*  ask_mr_diff - magical routine which asks mr diff if i can perform     *
*                a certain act.								     *
* 											     *
*  input: a0 --> table of 10 randper values which are used based on the  *
*                magical variable called diff					     *
* 											     *
*  returns: carry set   = yes								     *
*           carry clear = no								     *
*											     *
**************************************************************************
ask_mr_diff
	move	@diff,a1,w
	cmpi	9,a1
	jrle	amd3
    	movk	7,a1			; fucked up value ----> make it 7
amd3	sll	4,a1
	add	a0,a1
	move	*a1,a0,w		; grab yer "randper" entry
	jauc	randper

**************************************************************************
*											     *
*  get_proj_front - Returns the x position (a3) of a projectile given:   *
* 											     *
*  a10 = proj proc									     *
*											     *
**************************************************************************
get_proj_front
	move	*a10(p_joyport),a0,l	; a0 = stk table
	move	*a10(pa8),a5,l		; a5 = proj obj
	move	*a5(oxpos),a3,w
	move	*a0,a2,w		; a2 = x offset (stk table)
	move	*a5(oflags),a6,w
	btst	b_fliph,a6
	jreq	gpf4
	neg	a2
gpf4	add	a2,a3
	rets

**************************************************************************
*											     *
*  random_do - Do one of the actions (randomly) from this table of routi *
* 											     *
*  Input: a0 = table of "do's"								     *
*											     *
**************************************************************************
random_do
	move	a0,a1
	move	*a1+,a0,w		; a0 = # of entries
	calla	randu
	dec	a0
	sll	5,a0
	add	a0,a1
	move	*a1,a0,l

ochar_do
	movi	reaction_exit,a1
	move	a1,-*a12,l		; push ret addr
	jump	a0

ochar_do_or_rets
	calla	get_char_long
	jreq	odor9
	pull	a1			; no return
	jruc	ochar_do
odor9	rets

**************************************************************************
*											     *
*  diff_avoid_repeats - carry set = avoid repeated blows based in @diff  *
* 											     *
*  input: a0 = table of "repeat values" we want to avoid reaching		*
*											     *
**************************************************************************
diff_avoid_repeats
	callr	get_diff_word
	move	a0,a4	     			; a4 = # of repeats to avoid

	callr	drone_get_his_action		; a1 = his action !
	callr	count_q_repeats			; a3 = # of times action used
	jreq	davr2				; zero --> no repeats

	inc	a3				; include this hit thats coming up
	cmp	a4,a3				; is he abusing this move
	jrhs	davr3				; yes, avoid this blow
davr2	clrc					; no, say la vee !!
	rets

davr3	setc
	rets

*
* Input: A0 = table of 10 words
*
get_diff_word
	move	@diff,a14,w
	sll	4,a14
	add	a0,a14
	move	*a14,a0,w
	rets

**************************************************************************
*											     *
*  count_q_repeats - scan through the hit queue for repeats of the	     *
*                     action in a1							     *
* 											     *
*  returns: a3 = # of matches found in the queue				     *
*											     *
**************************************************************************
count_q_repeats
	calla	get_my_hitq		; a0 = my hit queue ram

	push	a2
	clr	a3			; start with zero matches
	callr	scan_1_entry
	callr	scan_1_entry
	callr	scan_1_entry
	callr	scan_1_entry
	callr	scan_1_entry
	callr	scan_1_entry		; scan all 6 entries in hit queue
	pull	a2

	move	a3,a3			; set zero flag if no matches found
	rets

scan_1_entry
	move	*a0+,a2,w	
	cmp	a1,a2			; match ?
	jrne	scan1			; no
	inc	a3			; yes, count it
scan1	rets

**************************************************************************
*											     *
*     FAQ										     *
*											     *
**************************************************************************

is_he_him
	move	*a13(p_otherguy),a1,l
	move	*a1(ochar),a1,w
	cmp	a0,a1
	jreq	ihhy
	clrc	
	rets
ihhy	setc
	rets

**************************************************************************

is_towards_me
	move	*a13(p_otherguy),a0,l
	move	*a0(oxvel),a0,l
	jreq	itmno
	jrp	itm5			; moving right
	calla	is_he_right
	jrc	itmyes
itmno	clrc
	rets
itm5	calla	is_he_right
	jrc	itmno			; moving right / he is right ---> no
itmyes	setc
	rets

;*************************************************************************

drone_1_proc
drone_2_proc
	movi	ft_final_boss,a0
	calla	am_i_him
	jrnc	dron3

	jsrp	kahn_taunt

dron3	jsrp	wait_for_start		; wait for the fight to start !
	callr	drone_setup

	movi	ochar_drone_start,a0
	jauc	ochar_jump

ochar_drone_start
	.long	generic_drone_start
	.long	generic_drone_start
	.long	generic_drone_start
	.long	generic_drone_start

	.long	generic_drone_start
	.long	generic_drone_start
	.long	shang_start
	.long	generic_drone_start

	.long	generic_drone_start
	.long	reptile_start
	.long	generic_drone_start
	.long	generic_drone_start

	.long	goro_start	     	; kintaro
	.long	kahn_start     			; kahn

	.long	smoke_start
	.long	drone_entry
	.long	drone_entry


shang_start
	movi	300,a0
	calla	randper
	jrc	drone_rmorph_jump
	jruc	generic_drone_start

reptile_start
	movi	200,a0
	calla	randper
	jrc	drone_inviso_jump
	jruc	generic_drone_start

generic_drone_start
	movi	rt_drone_start,a0
	jruc	random_do

rt_drone_start
	.word	4
	.long	drone_stalk
	.long	drone_flip_kick
	.long	drone_zap_jsrp
	.long	drone_special_start

drone_special_start
	movi	rt_special_start,a0
	jauc	ochar_jump

rt_special_start
	.long	drone_hh_tele_jump	; 0
	.long	drone_do_bicycle	; 1
	.long	drone_shadow		; 2
	.long	drone_zap_jump		; 3
	.long	drone_zap_jump		; 4
	.long	drone_do_fn_tele	; 5
	.long	drone_rmorph_jump	; 6
	.long	drone_melt_jump	  	; 7
	.long	drone_slide		; 8
	.long	drone_orb	 	; 9
	.long	drone_zap_jump		; 10
	.long	drone_quake_jump	; 11

	.long	drone_zap_jsrp
	.long	drone_zap_jsrp

	.long	drone_zap_jsrp
	.long	drone_zap_jsrp
	.long	drone_zap_jsrp


smoke_start
	move	a8,a11
	clr	a10
	create	pid_smoker,smoke_a_guy
	jruc	drone_entry

goro_start
drone_entry
	calla	reset_proc_stack	; make things kosher
	callr	drone_to_normal
	calla	check_winner_status
	callr	drone_beware
	calla	stance_setup		; set things up for "stance" ani
	calla	am_i_facing_him
	jrnc	drone_turnaround
	jruc	drone_stalk

;*************************************************************************

drone_stance_pause
	callr	drone_stance_setup
dum3	calla	next_anirate
	callr	drone_beware
	calla	check_winner_status
	calla	am_i_facing_him
	jrnc	dwait_turn			; keep facing him
	sleep	1
	dsj	a10,dum3
	retp

;*************************************************************************

drone_beware
	move	@winner_status,a0,w
	jrne	bew8				; we have a winner

;***********
;	jruc	bew8
;***********

	callr	drone_get_his_action
	jreq	bew8   				; no act ---> no react

	move	*a13(p_otheract),a0,w
	cmp	a0,a1				; same as before ??
	jreq	bew8				; yes, we had our chance before
	move	a1,*a13(p_otheract),w 	; no ---> new latest act !!

	move	a1,a2
	srl	8,a2
	jrne	bew5			; non-projectile move

	move	*a8(ochar),a3,w		; a3 = my ochar
	cmpi	ft_jade,a3
	jreq	bew8			; jade = ignore projectiles

bew5	sll	5,a2	 		; a2 = catagory offset
	addi	catagory_table,a2
	move	*a2,a2,l
	jreq	bew8			; no catagory ---> skip

	andi	>00ff,a1		; look only at catagory
	sll	5,a1
	add	a2,a1
	move	*a1,a1,l
	jreq	bew8	 		; no reaction ---> skip

	push	a1
	calla	player_normpal		; make sure i look like i should !
	move	*a8(ochar),a3,w		; a3 = my ochar
	pull	a1
	pull	a0			; a0 = return address

	move	a0,*a13(p_beware_return),l
	move	a10,*a13(p_beware_a10),l
	move	a11,*a13(p_beware_a11),l

	cmpi	ft_goro,a3
	jaeq	goro_counter_all	; goro ---> special routine !
	cmpi	ft_final_boss,a3
	jaeq	kahn_counter_all	; kahn ---> special routine

	jump	a1	 		; react to his action !

bew8	rets

;*********************************************************

return_to_beware
	move	*a13(p_beware_a10),a10,l
	move	*a13(p_beware_a11),a11,l
	move	*a13(p_beware_return),a0,l
	jump	a0

**************************************************************************
*											     *
*  stance_wait_yes - Wait in my stance animation for a "yes"			*
* 											     *
*  Where: A11 = routine to call every tick which returns carry set when  *
*               the event in question has happened.				     *
* 											     *
*         A10 = maximum ticks to wait							     *
*											     *
**************************************************************************
stance_wait_yes
	callr	drone_stance_setup

dsp8	calla	next_anirate
	callr	drone_beware		; keep one eye open !!
	push	a10
	call	a11
	pull	a10
	jrc	dsp9			; carry set = exit
	sleep	1
	dsj	a10,dsp8
	clrc				; carry clear = event did not happen
dsp9	retp


stance_wait_yes_nb
	callr	drone_stance_setup
swynb8	calla	next_anirate
	push	a10
	call	a11
	pull	a10
	jrc	swynb9			; carry set = exit
	sleep	1
	dsj	a10,swynb8
	clrc				; carry clear = event did not happen
swynb9	retp


stance_delay
	callr	drone_stance_setup
stdel3	calla	next_anirate
	sleep	1
	dsj	a10,stdel3
	retp

still_wait_yes
	sleep	1
	push	a10
	call	a11
	pull	a10
	jrc	swy9
	sleep	1
	dsj	a10,still_wait_yes
swy9	retp

**************************************************************************

walk_on_a_mission
	calla	towards_x_vel
	movk	1,a9			; walk forward ani
	calla	get_char_ani
	movk	4,a0
	calla	init_anirate

woam3	sleep	1
	dec	a11
	jreq	drone_reaction_exit	; max time passed = exit
	calla	am_i_facing_him
	jrnc	drone_turnaround	; facing wrong way = abort
	calla	next_anirate
	call	a10			; routine to call
	jruc	woam3

**************************************************************************

goro_walk_wait_yes
	calla	face_opponent
	callr	drone_walkf_setup
	jruc	wwy8

walk_wait_yes
	movi	act_walkf,a0
	move	a0,*a13(p_action),w	; action: walking forward

	movk	1,a9
	calla	get_char_ani

;	calla	get_walk_speeds
	movi	>30000,a0

	calla	towards_x_vel
	movk	4,a0
	calla	init_anirate

wwy8	calla	next_anirate
	callr	drone_beware
	push	a10
	call	a11		; ask the question
	pull	a10
	jrc	wwy9		; yes = exit
	sleep	1
	dsj	a10,wwy8
wwy9	retp

;************************************************************************

stance_wait_proj_proc
	movi	wait_4_proj_proc,a11
	movi	>30,a10			; max wait time
	jruc	stance_wait_yes		; wait for fan proc

wait_4_proj_proc	
	callr	get_his_proj_proc
	jreq	w4ppno
	setc
	rets
w4ppno	clrc
	rets

**************************************************************************
*											     *
*  wait_proj_pass - Wait for projectile to pass me up			     *
*											     *
**************************************************************************
wait_proj_pass
	sleep	1

	callr	get_his_proj_proc
	jreq	wpp9

	move	a0,a7
	move	*a7(p_joyport),a0,l	; a0 = stk table
	move	*a7(pa8),a5,l		; a5 = proj obj
	move	*a5(oxpos),a3,w
	move	*a0,a2,w		; a2 = x offset (stk table)
	move	*a0(16*2),a4,w		; a4 = x size
	move	*a5(oflags),a6,w
	btst	b_fliph,a6
	jreq	wpp5
	neg	a2
	neg	a4			; flipped = reverse offsets
wpp5	add	a2,a3
	sub	a4,a3			; a3 = tail end of proj scan
	move	*a8(oxpos),a2,w

	move	*a5(oflags),a6,w
	btst	b_fliph,a6
	jreq	wpp7
	swap	a3,a2
wpp7	cmp	a3,a2
	jrgt	wait_proj_pass

	movi	act_proj_passed,a1
	move	a1,*a7(p_action),w	; flag: this proj is pass my ahh

wpp9	retp

;************************************************************************

drone_stance_wait
	callr	drone_stance_setup

dwait3	calla	next_anirate

	calla	check_winner_status
	callr	drone_beware		; keep one eye open !!

	calla	am_i_facing_him
	jrnc	dwait_turn		; keep facing him
	sleep	1
	dsj	a10,dwait3
	retp

drone_stance_setup
	calla	drone_stop_me
	jruc	smooth_stance_setup


dwait_turn
	calla	reset_proc_stack
	jruc	drone_turnaround
 
;*********************************************************

drone_setup
	move	*a13(p_flags),a4,w
	andni	pm_joy,a4
	move	a4,*a13(p_flags),w	; flag: i am a drone
	rets

;*********************************************************

drone_finish_him
	move	@f_no_violence,a0,w
	jrne	non_violent_finish

	movi	aud_drone_fatal,a0		; a0 = audit to use
	movk	10,a2				; a2 = max number
	calla	audit_event_check
	jrc	drone_execute_fatality

uppercut_finish
	jsrp	uppercut_approach
	move	@curback,a1,w
	cmpi	6,a1 				; we on the pit ?
	jreq   	upcut0
	cmpi	1,a1 				; tomb ??
	jrne   	upcut
	jauc	do_up_the_spike

upcut0	move	@rand,a0,l
	jan	do_down_the_pit			; neg = down the pit
	jruc	upcut

non_violent_finish
	jsrp	uppercut_approach
upcut	jsrp	do_uppercut
	sleep	3
	calla	check_winner_status
	jauc	victory_animation


uppercut_approach
	calla	get_x_dist
	cmpi	>100,a3	    		; flip to save time ?
	jrlo	ucap3	    		; no
	jsrp	drone_ff_jsrp		; far away ---> flip
ucap3	movi	>48,a11
	jsrp	drone_approach
	jsrp	wait_for_dizzy
	move	a10,a10
	jrne	ucap9
	pullp	a0
	jauc	victory_animation
ucap9	retp



drone_execute_fatality
	movi	aud_bb,a0
	movi	200,a2				; a2 = max number
	calla	audit_event_check
	jrnc	def2

	move	@rand,a0,l
	jan	do_babality
	jauc	do_friendship

def2	movi	ochar_fatality_distances,a0
	calla	get_char_long

	move	@rand,a5,l
	jrn	def3

	srl	16,a0
	jsrp	fatality_align
	jsrp	wait_for_dizzy
	move	a10,a10
	jreq	drone_sweep
	jauc	do_fatality_2

def3	zext	a0,w
	jsrp	fatality_align
	jsrp	wait_for_dizzy
	move	a10,a10
	jreq	drone_sweep
	jauc	do_fatality_1


wait_for_dizzy
	movi	is_he_dizzy,a11
	movi	>30,a10
	jsrp	stance_wait_yes
	retp

is_he_dizzy
	move	*a13(p_otherproc),a0,l
	move	*a0(pwake),a0,l
	cmpi	dizzy,a0
	jreq	ihdy
	clrc
	rets
ihdy    	setc
	rets


fatality_align
	move	a0,a11
	calla	get_x_dist		; a3 = x dist
	cmp	a3,a0
	jrlo	def5
	jauc	drone_retreat

def5	calla	get_x_dist
	cmpi	>100,a3	    		; flip to save time ?
	jrlo	def6	    		; no
	jsrp	drone_ff_jsrp
def6	jauc	drone_approach


ochar_fatality_distances
	.word	>70,>110	; kung lao
	.word	>4b,>d0		; liu kang
	.word	>4b,>4b		; cage
	.word	>48,>50		; baraka
	.word	>4a,>4a		; kitana
	.word	>4a,>4a		; mileena
	.word	>50,>70		; shang tsung
	.word	>4b,>4b		; raiden
	.word	>90,>b0		; subzero
	.word	>d0,>50		; reptile
	.word	>a0,>50		; scorpion
	.word	>50,>60		; jax

drone_bf_jsrp
	calla	face_opponent
	clr	a6
	movk	8,a9
	calla	get_char_ani
	movi	>40000,a0
	jruc	dff2

drone_ff_jsrp
	calla	face_opponent
	clr	a6
	movk	7,a9
	calla	get_char_ani
	movi	->40000,a0

dff2	calla	away_x_vel

	movi	dont_touch,a0
  	movi	->a0000,a1		; initial y vel (upwards)
	movi	angle_grav,a2
	movk	3,a3			; animation speed
 	jsrp	flight_call

	movk	6,a9
	calla	find_ani_part2

	tsound	>1e			; feet gently landing on the ground

	movk	3,a0
	calla	init_anirate
dff3	sleep	1
	callr	drone_beware
	calla	next_anirate
	move	*a9,a0,l
	jrne	dff3
	retp

;*********************************************************

drone_to_normal
	calla	back_to_normal
	clr	a0
	move	a0,*a13(p_otheract),w
	rets

drone_stop_me
	jauc	stop_me

drone_post_block
	clr	a1
	move	a1,*a13(p_action),w
	calla	get_block_ani_offset
	calla	find_ani_part2
	movk	4,a0
	jsrp	drone_beware_mframew		; ani: standing unblock
	jruc	drone_reaction_exit

drone_post_duckhit


drone_beware_mframew
	clr	a11
	move	a11,*a13(p_otheract),w	; dont ignore anything
	pullp	a11				; a11 = return address
	calla	init_anirate			; set things arriba !!
dbf3	sleep	1
	calla	next_anirate
	callr	drone_beware
	move	*a9,a1,l
	jrne	dbf3			; more frames to go ---> loopy
	jump	a11			; return

;**********************************************************************

drone_turnaround
	calla	reset_proc_stack
	callr	drone_stop_me

	movk	2,a9
	calla	am_i_a_boss
	jrc	dturn4			; boss turnaround animation different

dturn3	movi	>09,a9
	calla	am_i_short
	jrnc	dturn4
	movi	>0a,a9
dturn4	calla	get_char_ani

	movi	ta_speeds,a0
	calla	get_char_long		; get my speed to animate
	calla	init_anirate		; turn around speed

dturn7	sleep	1
	callr	drone_beware
	calla	next_anirate
	move	*a9,a0,l		; animation done ????
	jrne	dturn7			; no
	jruc	drone_reaction_exit

;**************************************************************************

drone_charge_slam
;	calla	get_walk_speeds		; a0 = forward walk speed
	movi	>30000,a0

	calla	towards_x_vel
	movk	1,a9			; walk forward ani
	calla	get_char_ani
	movk	4,a0
	calla	init_anirate

	movi	>30,a11
dcs7	sleep	1
	dec	a11
	jreq	drone_reaction_exit	; max time
	calla	next_anirate
	callr	drone_get_x_dist

	callr	can_drone_slam
	cmp	a0,a3			; within range ?
	jrhi	dcs7			; nope

	jruc	drone_body_slam

drone_body_slam

;********************
	calla	is_he_airborn
	jrc	drone_slam_abort

	move	@diff,a0,w
	jreq	drone_slam_abort	; diff=0 ---> no body slammin'

	calla	is_he_joy
	jrnc	dbslam3			; he is a drone ---> ok
	calla	is_he_short
	jrc	dbslam3			; he is ducking ---> ok to SLAM !!

	mmtm	sp,a13,a8
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l	; trick "joystick_in_a0" routine
	calla	is_stick_away
	mmfm	sp,a13,a8
	jrc	drone_slam_abort	; joy is not away ---> ok to flip

;********************


dbslam3	jsrp	do_body_slam		; close = slam the clown !!!
	calla	face_opponent

	calla	get_my_dfeos
	cmpi	>50,a5
	jrlo	dslam3
	cmpi	>50,a6
	jrlo	dslam3			; close to edge ---> dont backoff
*
* post body slam = backoff somewhat
*
	calla	get_x_dist
	addi	>20,a3
	move	a3,a11
	movi	>20,a0
	move	a0,*a13(p_store5),w

	calla	face_opponent
	callr	drone_walkb_setup
dslam2	calla	am_i_facing_him
	jrnc	drone_turnaround
	sleep	1

	move	*a13(p_store5),a0,w
	dec	a0
	jreq	drone_reaction_exit
	move	a0,*a13(p_store5),w

	calla	next_anirate
	callr	drone_beware
	callr	drone_get_x_dist  	; a3 = distance between us
	cmp	a11,a3
	jrlo	dslam2

dslam3	movi	is_he_done_reacting,a11
	movi	>40,a10
	jsrp	stance_wait_yes
	jruc	drone_reaction_exit

drone_slam_abort
	jruc	drone_rapid_lo

***************************************************************************

is_he_done_reacting
	move	@winner_status,a0,w
	jrne	isdr3			; we done ---> exit
	move	*a13(p_otherproc),a0,l
	move	*a0(p_flags),a0,w
	btst	pb_reacting,a0
	jreq	isdr3
	clrc
	rets
isdr3	setc
	rets

is_he_reacting
	move	*a13(p_otherproc),a0,l
	move	*a0(p_flags),a0,w
	btst	pb_reacting,a0
	jrne	ihr4
	clrc
	rets
ihr4	setc
	rets

***************************************************************************

*
* Carry set = ok
*
check_slam_freq
	movi	l_drone_slam,a0
	calla	get_tsl

	movi	drone_slam_frequency,a0
	callr	get_diff_word			; a0 = frequency allowed !
	cmp	a0,a1
	jrlo	check_slam_no
	setc
	rets

check_slam_no
	clrc
	rets

drone_slam_frequency
	.word	>00,>f0,>c0
	.word	>c0,>c0,>80
	.word	>80,>60,>40,>40

**************************************************************************
*											     *
*  can_drone_slam - Answers the question with:					     *
* 											     *
*  a0 = distance we must be within to slam (zero = no slam allowed)	     *
*											     *
**************************************************************************
can_drone_slam
	move	@diff,a0,w
	sll	4,a0
	addi	slam_distances,a0
	move	*a0,a0,w
	rets

slam_distances
	.word	>46,>46,>46,>46,>46,>48,>4a,>4d,>50,>50,>50

;************************************************************************

drone_backup
	movi	act_backup,a1
	move	a1,*a13(p_action),w	; define my action

	movk	5,a9			; a9 = animation to run backwards
	calla	find_ani_last_frame
	calla	do_next_a9_frame
	sleep	2
	subi	32*2,a9
	calla	do_next_a9_frame
	sleep	2
	subi	32*2,a9
	calla	do_next_a9_frame
	sleep	2
	retp

;************************************************************************

*
* a11 = distance we want
* 
drone_approach
	calla	face_opponent
	callr	drone_walkf_setup

speedy_entry
drap3	calla	am_i_facing_him
	jrnc	drone_turnaround
	sleep	1

	calla	next_anirate
	callr	drone_beware
	callr	drone_get_x_dist  		; a3 = distance tween us
	cmp	a11,a3
	jrhi	drap3
	calla	stop_me
	retp

drone_retreat
	calla	face_opponent
	callr	drone_walkb_setup

drrt3	calla	am_i_facing_him
	jrnc	drone_turnaround

	sleep	1
	calla	next_anirate
	callr	drone_beware
	callr	drone_get_x_dist  	; a3 = distance between us
	cmp	a11,a3
	jrlo	drrt3

	calla	stop_me
	retp

;************************************************************************

drone_stalk
	callr	boss_jump
	.long	goro_stalk		; 0 = goro
	.long	kahn_stalk		; 1 = shao kahn

;***********************
;	movi	>40*80,a10
;	jsrp	drone_stance_wait
;***********************

	calla	face_opponent
	callr	drone_walkf_setup

	movi	3,a0
	calla	randu
	dec	a0
dstk2	move	a0,*a13(p_dronevar1),w	; cmf offset

dstk3	calla	am_i_facing_him
	jrnc	drone_turnaround

	sleep	1

	calla	next_anirate
	callr	drone_beware
	callr	drone_get_x_dist  		; a3 = distance tween us
	move	*a13(p_dronevar1),a0,w	; distance we are looking for
	sll	4,a0
	addi	close_med_far,a0
	move	*a0,a0,w			; a0 = distance we are lookin for
	cmp	a0,a3
	jrhi	dstk3
*
* within range = time to act
*
	callr	stalk_airborn_check

	callr	drone_beware			; but 1st....what is he doing ??
	move	*a13(p_dronevar1),a0,w	; distance we are looking for
	cmpi	2,a0
	jrlo	dstk6
	movk	2,a0
dstk6	sll	5,a0
	addi	cmf_jumps,a0
	move	*a0,a0,l			; a0 = distance we are lookin for
	jump	a0

;*************************************************************************

d_close	.set	>50
d_med	.set	>70
d_far	.set	>c0

close_med_far
	.word	d_close,d_med,d_far

;*************************************************************************

cmf_jumps
	.long	cmf_close
	.long	cmf_med
	.long	cmf_far

;*************************************************************************

cmf_med
	calla	is_he_airborn		; is he in the air ?
	jrnc	cmed3

	clr	a0
	callr	does_stk_reach		; can I hit him from here ?
	jrnc	cmed2			; no, skip
	movi	300,a0
	calla	randper
	jrc	drone_hikick		; sometimes kick

cmed2	movi	>30,a10
  	movi	is_he_landed,a11
	jsrp	stance_wait_yes	    	; wait for him 2 land

cmed3	calla	is_he_short	    	; he ducking ?
	jrnc	cmed4		    	; no

	clr	a0
	jruc	dstk2			; yes, switch to "close mode"

cmed4	movi	rt_medium,a0
	jruc	random_do

rt_medium
	.word	3
	.long	charge_slam_check
	.long	drone_sweep
	.long	drone_lokick
	.long	drone_hikick

;*************************************************************************

cmf_close
	callr	drone_get_his_action
	cmpi	act_duck,a1
	jreq	close_he_is_ducking

	calla	is_he_short
	jrc	close_he_is_ducking

	move	@rand,a0,l
	jrn	drone_rapid_lo
	jruc	drone_rapid_hi

charge_slam_check
close_he_is_ducking
	callr	check_slam_freq
	jrnc	drone_rapid_lo
	jruc	drone_charge_slam


drone_rapid_lo
	movk	7,a0
	movk	2,a1
	movk	3,a2		; stk #2 = hi punch
	move	a2,a3
	clr	a4
	movi	>14,a9
	jruc	drone_rapid_start

drone_rapid_hi
	movk	7,a0
	movk	2,a1
	movk	2,a2		; stk #2 = hi punch
	move	a2,a3
	clr	a4
	movi	>13,a9

drone_rapid_start
	jsrp	drone_rfp
	jruc	drone_reaction_exit

;***************************************************************************

cmf_far
	calla	get_x_dist
	cmpi	>90,a3
	jrhi	far3

	clr	a0
	jruc	dstk2			; yes, switch to "close mode"

far3	movi	ft_smoke,a0
	calla	am_i_him
	jrnc	far4

	movi	>0e,a0
	jsrp	do_body_propell
	jauc	reaction_exit

*
* far attacks
*
far4	movi	ft_st,a0
	calla	am_i_him
	jrnc	far5

	movi	300,a0
	calla	randper
	jrc	drone_rmorph_jump

far5	movi	ft_reptile,a0
	calla	am_i_him
	jrnc	far6

	move	*a8(oflags2),a4,w
	btst	b_inviso,a4			; already invisible
	jrne	far6				; then skip

	movi	200,a0
	calla	randper
	jrc	drone_inviso_jump

far6	move	@diff,a0,w
	jrne	far7
	jruc	dstk2		; diff = o ---> dont zap or propell

far7	move	@rand,a0,l
	jrn	drone_zap_jump

	movi	ochar_propells,a0
	jauc	ochar_jump

ochar_propells
	.long	drone_zap_jump
	.long	drone_lk_super
	.long	drone_shadow
	.long	drone_zap_jump
	.long	fn1_zap_or_prop
	.long	drone_kano_jump
	.long	drone_zap_jump
	.long	do_raiden_dive
	.long	drone_slide
	.long	drone_slide
	.long	drone_zap_jump
	.long	jax_zap_or_quake

	.long	drone_zap_jump
	.long	drone_zap_jump

	.long	drone_zap_jump
	.long	drone_zap_jump
	.long	drone_zap_jump

jax_zap_or_quake
	movi	200,a0
	calla	randper
	jrc	drone_quake_jump
	jruc	drone_zap_jump

fn1_zap_or_prop
	movi	300,a0
	calla	randper
	jrc	drone_square_wave
	jruc	drone_zap_jump

;***************************************************************************

stalk_airborn_check
	calla	is_he_airborn
	jrnc	sac9				; he is on ground ---> return

	pull	a14
	callr	drone_beware			; is this in our repetuiour ??

	calla	get_x_dist			; a3 = x distance
	cmpi	d_close,a3
	jrlo	stalk_airborn_close
	cmpi	d_med,a3
	jrlo	stalk_airborn_med
	jruc	stalk_airborn_far

sac9	rets


stalk_airborn_far
stalk_airborn_med
	callr	is_towards_me
	jrnc	drone_zap_jump

	movi	is_he_grounded,a11
	movi	>30,a10			; max wait time
	jsrp	stance_wait_yes
	jruc	drone_reaction_exit

stalk_airborn_close
	movi	rt_airborn_close,a0
	jruc	random_do

rt_airborn_close
	.word	3
	.long	drone_hikick
	.long	drone_roundhouse
	.long	drone_rapid_hi

;*********************************************************

drone_walkb_setup
	calla	get_walk_info_b
	jruc	dwset3

drone_walkf_setup
	calla	get_walk_info_f
dwset3	move	a2,a9
	calla	init_anirate
	move	a1,a0
	calla	set_x_vel
	jauc	get_char_ani

drone_get_his_action
	jauc	get_his_action

drone_reaction_exit
	jauc	reaction_exit

drone_get_x_dist
	jauc	get_x_dist

drone_get_my_strength
	jauc	get_my_strength

sweep_if_u_can
	movi	>04,a0
	callr	does_stk_reach		; close enough for sweep ?
	jrnc	siuc9
	pull	a0			; no return
	jruc	drone_sweep
siuc9	rets


hikick_if_u_can
	clr	a0
	callr	does_stk_reach		; close enough for sweep ?
	jrnc	siuc9
	pull	a0			; no return
	jruc	drone_hikick

lokick_if_u_can
	movi	>01,a0
	callr	does_stk_reach		; close enough for sweep ?
	jrnc	siuc9
	pull	a0			; no return
	jruc	drone_lokick

drone_lokick
	jsrp	do_lo_kick
	jruc	drone_reaction_exit

drone_hikick
	jsrp	do_hi_kick
	jruc	drone_reaction_exit

drone_roundhouse
	jsrp	do_roundhouse
	jruc	drone_reaction_exit

;*********************************************************

drone_duck_block
	calla	am_i_short		; am I already ducking ?
	jrc	ddb5			; yes
	movi	act_blockhi,a1		; action: block, in case I am hit
	jsrp	drone_duck_act
ddb5	jsrp	do_duck_block
	retp

drone_duck
	calla	reset_proc_stack
	jsrp	drone_duck_real
*
* wait for non-attack AND keep facing him
*	  	
	movi	>40*3,a10		; time limit
ddk3	sleep	1
	calla	am_i_facing_him
	jrc	ddk5			; facing him = cool

	movi	>0a,a9
	calla	get_char_ani		; duck turn ani
	movk	2,a0
	calla	init_anirate
ddk4	sleep	1
	calla	next_anirate
	callr	is_he_attacking
	jrnc	ddk7			; he is done ----> exit
	move	*a9,a0,l
	jrne	ddk4			; finish animation
	jruc	ddk3			; keep down

ddk5	dec	a10
	jreq	ddk7			; enough of this !!!
	callr	is_he_attacking
	jrc	ddk3	       		; still attacking = loop

ddk7	calla	face_opponent
	jsrp	drone_backup
	jruc	drone_reaction_exit


drone_duck_fast
	movi	act_duck,a1
	move	a1,*a13(p_action),w	; define my DIFFERENT action !!!
	callr	drone_stop_me
	calla	face_opponent
	movk	5,a9
	calla	get_char_ani
	movk	1,a0
	jauc	mframew

drone_duck_real
	movi	act_duck,a1

drone_duck_act
	move	a1,*a13(p_action),w	; define my DIFFERENT action !!!
	callr	drone_stop_me
	calla	face_opponent
	movk	5,a9
	calla	get_char_ani
	movk	2,a0
	jauc	mframew

drone_duck_upcut
	jsrp	drone_duck_fast
	jsrp	drone_wait_nonattack
	movi	>08,a0
	callr	does_stk_reach		; close enough for uppercut ?
	jrc	ddu5			; yes, do it

	callr	sweep_if_u_can
	jruc	drone_reaction_exit	; too far period

ddu5	jsrp	do_uppercut
	jruc	drone_reaction_exit


drone_post_duck_hit
	jsrp	drone_wait_nonattack
	jsrp	drone_backup
	jruc	drone_reaction_exit

;*********************************************************

drone_block
	jsrp	do_block_hi
	jsrp	drone_wait_nonattack
	jruc	drone_reaction_exit

drone_post_skull_hit
drone_block_proj
	jsrp	do_block_hi
	jsrp	wait_proj_spawn
	jsrp	wait_proj_pass		; take yer punishment
	jruc	drone_reaction_exit

;*********************************************************

drone_wait_nonattack
	sleep	1
	callr	is_he_attacking
	jrc	drone_wait_nonattack
	retp

drone_wait_non
	sleep	1
	dec	a10
	jreq	dwn9
	callr	is_he_attacking
	jrc	drone_wait_non
dwn9	retp

;*********************************************************

cage_zap_hi_jsrp
	clr	a10
	movk	4,a0			; 4 = cage zap hi
	jauc	do_zap

drone_reverse_zap_jump
	movk	1,a10
	movi	zap_offsets,a0
	calla	get_char_word		; my ochar zap offset
	jrn	drone_zap_no		; negative = no zap
	jsrp	do_zap
	jruc	drone_reaction_exit

*
* jump to this one
*
drone_zap_jump
	jsrp	drone_zap_jsrp
	jruc	drone_reaction_exit
*
* jsrp to this one if you want to return
*
drone_zap_jsrp
	clr	a10
	movi	zap_offsets,a0
	calla	get_char_word		; my ochar zap offset
	jrn	drone_zap_no		; negative = no zap
	jauc	do_zap

drone_zap_no
	sleep	1
	jruc	drone_reaction_exit

zap_offsets
	.word	0	; 0 - hh
	.word	3	; 1 - lk
	.word	5	; 2 - cage (low)
	.word	>0f	; 3 - sword arms (sans)

	.word	6	; 4 - fn1 (fans)
	.word	7	; 5 - fn2 (tsai)
	.word	9	; 6 - shang (skull)
	.word	8	; 7 - raiden

	.word	>0d	; 8 - subzero
	.word	>12	; 9 - reptile
	.word	>0c	; 10 - scorpion
	.word	>14	; 11 - jax

	.word	>15	; 12 - kintaro
	.word	>13	; 13 - kahn

	.word	>0c	; 14 - scorpion
	.word	>0c	; 15 - scorpion
	.word	6	;

**************************************************************************
*											     *
*  drone_rfp - drone rapid fire punches !!						     *
* 											     *
*  input: a0 = max times i am allowed to hit					     *
*         a1 = sleep time after a strike						     *
*         a2 = stk offset #1								     *
*         a3 = unused (so far)									*
*         a4 = routine to call after every swing !				     *
*         a9 = animation offset to use !						     *
* 											     *
*  call with jsrp									     *
*											     *
**************************************************************************
drone_rfp
	mmtm	a12,a2,a3,a4,a9		; dump all our shit info on proc stack

	move	a0,*a13(p_dcount),w	; max punches in a row
	move	a1,*a13(p_anirate),w
	calla	init_special

;drfp0
	move	*a12,a9,l		; grab ani offset
	calla	get_char_ani

drfp1	movk	3,a0
	jsrp	mframew

	move	*a12(32),a0,l
	jreq	drf5
	call	a0			; call routine if u must

drf5	move	*a12(32*3),a0,l		; a0 = stk #1
	calla	get_char_stk
	calla	strike_check		; strike: punch #1
	jrnc	drfp3			; miss

	move	*a13(p_dcount),a0,w
	dec	a0
	jreq	drfp3			; enough of this !
	move	a0,*a13(p_dcount),w	; count this hit

	move	*a13(p_anirate),a0,w
	calla	prcslp

	movk	3,a0
	jsrp	mframew

	move	*a12(32),a0,l
	jreq	drf6
	call	a0			; call routine if u must

drf6	move	*a12(32*3),a0,l		; a0 = stk #1
	calla	get_char_stk
	calla	strike_check	 	; med punch strike #2
	jrnc	drfp2			; miss

	move	*a13(p_dcount),a0,w
	dec	a0
	jreq	drfp2			; enough of this !
	move	a0,*a13(p_dcount),w	; count this hit

	move	*a13(p_anirate),a0,w
	calla	prcslp
	jruc	drfp1

*
* unpunch #2
*
drfp2	move	*a12,a9,l
	calla	find_ani_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	jruc	drfp4
*
* unpunch #1
*
drfp3 	move	*a12,a9,l		; grab ani offset
	calla	find_ani_part2
	calla	find_part2
	calla	find_part2

drfp4	movk	3,a0
	jsrp	mframew
	mmfm	a12,a2,a3,a4,a9		; pull everything off stack
	retp

;*********************************************************

drone_flip_kick
	callr	drone_stop_me
	calla	face_opponent	

;	psound	>10			; whooshes !!

	movk	7,a9			; ani = forward flip
	movi	->40000,a0
	movi	drone_ajump_call,a6
  	movi	->a0000,a1		; initial y vel (upwards)
	movi	angle_grav,a2
	movk	3,a3			; animation speed
 	jsrp	flight_call
	jruc	drone_land


drone_ajump_call
	calla	next_flip_whoosh
	callr	drone_get_x_dist
	cmpi	>80,a3	  		; close enough to attack ?
	jrhi	dajc4			; not yet !

	pull	a0
	pull	a0
	calla	reset_proc_stack
	jsrp	do_flip_kick
	jruc	drone_reaction_exit

dajc4	rets

;******************************************************************

;drone_flip_punch
;	callr	drone_stop_me
;	calla	face_opponent	
;	movk	7,a9			; ani = forward flip
;	movi	->40000,a0
;	movi	drone_fp_call,a6
;  	movi	->a0000,a1		; initial y vel (upwards)
;	movi	angle_grav,a2
;	movk	3,a3			; animation speed
; 	jsrp	flight_call
;	jruc	drone_land
;
;drone_fp_call
;	calla	next_flip_whoosh
;	callr	drone_get_x_dist
;	cmpi	>80,a3	  		; close enough to attack ?
;	jrhi	dfp4			; not yet !
;
;	pull	a0
;	pull	a0
;	calla	reset_proc_stack
;	jsrp	do_flip_punch
;	jruc	drone_reaction_exit
;
;dfp4	rets


;******************************************************************

drone_land
	movk	6,a9
	calla	find_ani_part2

	tsound	>1e			; feet gently landing on the ground

	movk	3,a0
	calla	init_anirate
dlnd3	sleep	1
	callr	drone_beware
	calla	next_anirate
	move	*a9,a0,l
	jrne	dlnd3
	jruc	drone_reaction_exit


drone_getup
	movi	act_getup,a0
	move	a0,*a13(p_action),w		; define my action !
	clr	a0
	move	a0,*a13(p_otheract),w	; dont let anything get by me !

	calla	if_boss_branch
	.long	boss_getup

	calla	raiden_getup_pal

	movi	>12,a9
	calla	get_char_ani
	move	a11,a0
	calla	get_char_word
dgu4	calla	init_anirate		; define animation speed

dgu5	sleep	1
	calla	drone_beware
	calla	next_anirate
	move	*a9,a0,l
	jrne	dgu5
	jruc	drone_reaction_exit

boss_getup
	movi	>0b,a9
	calla	get_char_ani
	movk	3,a0		
	jruc	dgu4

;******************************************************************


smooth_stance_setup
	move	a9,a5	   	; a5 = "before" animation
	calla	stance_setup

sss1	move	*a9,a4,l
	cmpi	ani_ochar_jump,a4	; jump command ?
	jrne	sss2
	addi	16*5,a9,l		; yes, skip the bs
	jruc	sss1


sss2	move	a9,a4
sss3	move	*a4+,a1,l
	cmpi	ani_jump,a1	; find the "ani_jump"
	jrne	sss3
	subi	32*2,a4		; a4 --> last stance frame
*
* a9 ---> top
* a4 ---> bottom     a5 ---> where we were before
* 
	cmp	a9,a5
	jrlo	sss6		; b4 = above the top ---> use new ani
	cmp	a4,a5
	jrhi	sss6		; b4 = below the bottom ---> new ani
	move	a5,a9		; already in stance ani ---> dont interupt
sss6	rets


get_his_reach_y
	move	*a13(p_otherproc),a0,l	; his proc
	move	*a0(p_stk),a0,w			; his strike offset
	calla	get_char_stk			; a0 = strike table
	move	*a13(p_otherguy),a1,l	; him

	move	*a0(16*1),a2,w			; y offset
	move	*a0(16*3),a3,w			; y size

	move	*a1(oypos),a0,w
	add	a2,a3
	add	a0,a3
	rets

;********************************************************************

*
* a2 = distance I would consider safe
*
return_if_reach
	push	a2
	callr	will_he_reach_me
	pull	a2
	jrc	riryes

	pull	a0			; no return
	cmp	a2,a3	 	  	; within our window ??
	jrhi	return_to_beware	; no, ignore

	movi	>30,a10
	movi	is_he_attacking,a11
	jruc	dont_walk_into_it

riryes	rets

;********************************************************************

will_he_reach_me
	mmtm	sp,a8,a13			; save my personal info
	move	*a13(p_otherguy),a8,l	; him
	move	*a13(p_otherproc),a13,l	; his proc
	move	*a13(p_stk),a0,w    		; his strike table
	callr	does_stk_reach			; close enough for sweep ?
	mmfm	sp,a8,a13
	rets

**************************************************************************
*											     *
*  does_stk_reach - Determines if I am in range to strike using stk	     *
*                   offset of A0								     *
* 											     *
*  Returns: carry set = yes								     *
* 	 a3 = pixels away from a hit							     *
*											     *
**************************************************************************
does_stk_reach
	calla	get_char_stk

	push	a8
	move	*a13(p_otherguy),a8,l
	calla	leftmost_mpart		; a2 = left point
	calla	rightmost_mpart		; a3 = right point
	pull	a8

	move	a3,a4
	sub	a2,a4
	abs	a4			; a4 = x size of other dude

	move	*a0(16*8),a6,w		; (stksize)
	btst	sb_squeeze,a6 		; squeeze flag ?
	jreq	dsr6			; no

	move	a4,a7
	srl	3,a7			; a7 = 1/8 wideness
	srl	2,a4			; a4 = 1/2 wideness
	add	a7,a4			; a4 = 4/8 + 1/8 = 5/8 wideness
	add	a4,a2			; a2 = dudes left collision x
	sub	a4,a3			; a3 = dudes right collision x

dsr6	move	*a0,a5,w		; a5 = x reach

	move	a2,a6			; a6 = left
	move	a3,a7			; a7 = right

	move	*a8(oxpos),a1,w		; a1 = my x
	calla	is_he_right		; is he on the right ?
	jrnc	dsr9			; no
*
* facing right
*
	move	a6,a3			; a3 = edge in question
	add	a5,a1
	cmp	a1,a6			; a1 is in question
	jrlt	dsr_yes
	jruc	dsr_no
*
* facing left
*
dsr9	move	a7,a3			; a3 = edge in question
	sub	a5,a1
	cmp	a1,a7			; a1 is in question
	jrgt	dsr_yes

dsr_no	sub	a1,a3
	abs	a3			; a3 = # of pixels we were off
	clrc
	rets

dsr_yes	setc
	rets

**************************************************************************
*											     *
*  get_his_proj_proc - Return with his projectile process	in A0	     *
* 											     *
*  Zero bit = no proc found								     *
*											     *
**************************************************************************
get_his_proj_proc
	movi	pid_proj2,a0
	movi	pid_proj1,a1
	calla	p1p2_pick
	move	a0,a1			; a1 = id we are looking for

	movi	active,a0		; a0 ---> active proc list
ghpp4	move	*a0(plink),a0,l
	jreq	ghpp9			; no more ---> exit
	move	*a0(procid),a2,w	; a2 = pid
	andi	>ff00,a2		; mask off individual stuff
	cmp	a1,a2			; projectile ?
	jrne	ghpp4			; no, keep looking through list
	move	a0,a0			; clear zero bit
ghpp9	rets

*
* wait for a projectile process to be spawned
*
wait_proj_spawn
	movi	>20,a10			; max wait time
wps3	sleep	1
	dec	a10
	jreq	wps9
	movi	pid_proj2,a0
	movi	pid_proj1,a1
	calla	p1p2_pick
	movi	>f00,a1
	calla	existp			; proj proc out there ?
	jrne	wait_proj_found		; yes
*
* no projectile found...
*
	calla	get_his_action
	cmpi	act_proj_sd,a1
	jreq	wps9		; and he is sittin duck ---> exit

	move	a1,a1
	jreq	wps9
	cmpi	>ff,a1
	jrhi	wps9		; and he is not zapping ---> exit
	jruc	wps3		; he is zapping ---> wait

wait_proj_found

;;	move	*a13(p_action),a1,w
;	move	*a0(p_action),a1,w
;	cmpi	act_proj_dead,a1  	; dead projectile ?
;	jrne	wps3			; no, still dangerous !!

wps9	retp


drone_sweep
	jsrp	do_sweep_kick

	callr	is_he_done_reacting
	jrc	drone_reaction_exit

	movi	is_he_done_reacting,a11
	movi	>40,a10
	jsrp	stance_wait_yes

	movk	10,a10
	jsrp	drone_stance_pause
	jruc	drone_reaction_exit

**************************************************************************
*											     *
*  Action Catagory Table									     *
* 											     *
*  100 = attacks										     *
*  200 = blocks										     *
*  300 = non-attacks									     *
*  400 = specific actions								     *
*  500 = unrelated actions								     *
*  600 = sitting duck actions								     *
*											     *
**************************************************************************
catagory_table
	.long	counter_proj_table	; 0
	.long	counter_attack_table	; 1
	.long	counter_propell		; 2
	.long	counter_non_attack	; 3
	.long	counter_specific	; 4
	.long	0			; 5
	.long	counter_sitting_duck	; 6
	.long	0			; 7


counter_propell
	.long	c_flykick	; 200 - flying (flip) kick
	.long	c_flypunch	; 201 - flying (flip) punch
	.long	c_hh_teleport	; 202 - kung lao teleport move
	.long	c_super_kang	; 203 - 
	.long	c_bike    	; 204 -
	.long	c_shadk		; 205 -
	.long	c_shoruken	; 206 -
	.long	0		; 207 - square
	.long	c_fntele	; 208 -
	.long	c_dive		; 209 -
	.long	c_decoy		; 20a -
	.long	c_scissor	; 20b - scissor leg grab
	.long	c_slide		; 20c -
	.long	c_reptile_fly	; 20d -
	.long	c_kano		; 20e -

counter_non_attack
	.long	0		; 0
	.long	0		; 1
	.long	0		; 2
	.long	0		; 3
	.long	0		; 4
	.long	0		; 5
	.long	0		; 6
	.long	0		; 7
	.long	c_angle_jump	; 8
	.long	c_melt		; 9
	.long	0		; a		   	
	.long	0		; b
	.long	0		; c
	.long	0		; d


counter_specific
	.long	0		; 400
	.long	c_frozen	; 401
	.long	0		; 402
	.long	0		; 403
	.long	c_morph		; 404
	.long	0		; 405
	.long	0		; 406
	.long	0		; 407
	.long	0		; 408
	.long	0		; 409
	.long	0		; 40a


counter_proj_table
	.long	0
	.long	c_throw_hat	; 01 - throw hat
	.long	c_lkzap_lo	; 02 -
	.long	c_lkzap_hi	; 03 -
	.long	c_lkzap_air	; 04 -
	.long	c_jcsnot_lo	; 05 -
	.long	c_jcsnot_hi	; 06 -
	.long	c_spark		; 07 -
	.long	c_throw_fans 	; 08 -
	.long	c_air_fans	; 09 -
	.long	c_throw_tsai	; 0a -
	.long	c_air_tsai	; 0b -
	.long	c_throw_skull1	; 0c	-
	.long	c_throw_skull2	; 0d	-
	.long	c_throw_skull3	; 0e	-
	.long	c_throw_bolt	; 0f	-
	.long	c_throw_ice	; 10 -
	.long	c_spear		; 11 -
	.long	c_spit		; 12	-
	.long	c_slow_orb	; 13	-
	.long	c_jax_zap	; 14


counter_attack_table
	.long	0		; 100 -
	.long	c_hipunch	; 101 - hi punch
	.long	c_lopunch	; 102 - lo punch
	.long	c_hikick	; 103 - hi kick
	.long	c_lokick	; 104 - lo kick
	.long	c_roundhouse	; 105 - roundhouse kick
	.long	c_sweep		; 106 - sweep kick
	.long	c_uppercut	; 107 - uppercut
	.long	c_hhspin	; 108 - hathead spin
	.long	0		; 109 -
	.long	c_splits	; 10a -
	.long	0		; 10b -
	.long	0		; 10c -
	.long	0		; 10d -
	.long	c_jumpupk	; 10e - jump up kick
	.long	c_knee		; 10f - knee

	.long	0		; 110 -
	.long	0		; 111 -
	.long	0		; 112 -
	.long	c_duck_kickh	; 113 -
	.long	c_elbow		; 114 - elbow
	.long	0		; 115 -
	.long	0		; 116 -
	.long	0		; 117 -
	.long	c_jumpupp	; 118 - jump up punch
	.long	c_duckpunch	; 119 -
	.long	c_duck_kickl	; 11a -
	.long	0		; 11b -
	.long	0		; 11c -
	.long	c_shred		; 11d -
	.long	c_swipe		; 11e -
	.long	0		; 11f -

	.long	c_fan_swipe	; 120 - 
	.long	c_spin		; 121 -
	.long	c_noogy		; 122 -
	.long	0		; 123 -
	.long	0		; 124 -
	.long	0		; 125 -
	.long	0		; 126 -
	.long	0		; 127 -
	.long	0		; 128 -
	.long	0		; 129 -
	.long	0		; 12a -
	.long	0		; 12b -
	.long	c_sonic		; 12c -
	.long	0		; 12d -
	.long	0		; 12e -
	.long	0		; 12f -
	.long	0		; 130
	.long	0		; 131
	.long	0		; 132
	.long	0		; 133
	.long	c_floor_ice	; 134
	.long	0		; 135
	.long	0		; 136
	.long	c_quake		; 137
	.long	0		; 138
	.long	0		; 139

counter_sitting_duck
	.long	0		; 600 -
	.long	c_knee_sd	; 601 - post knee sitting duck
	.long	c_dive_sd	; 602 -
	.long	0		; 603 -
	.long	c_proj_sd	; 604 - projectile sitting duck
	.long	c_speared_sd	; 605 -
	.long	0		; 606 -
	.long	c_decoy_sd	; 607 -
	.long	0		; 608 -
	.long	0		; 609 -
	.long	c_slide_sd	; 60a -
	.long	c_elbow_sd	; 60b - post elbow sitting duck
	.long	c_ret_kick  	; 60c -
	.long	0		; 60d -
	.long	c_slipping	; 60e -
	.long	c_spin_sd	; 60f -
	.long	0		; 610 -
	.long	c_shoruken_sd	; 611 -
	.long	c_fntele_sd	; 612 -
	.long	0		; 613 -
	.long	c_wave_sd	; 614
	.long	0		; 615 -
	.long	0		; 616 -
	.long	c_superk_sd	; 617 -
	.long	c_skull_sd	; 618 -
	.long	c_kano_sd	; 619
	.long	c_hh_sd		; 61a -
	.long	c_orb_sd	; 61b

;*************************************************************************

c_kano_sd
	movi	>46,a11
	jsrp	drone_approach
	movi	q_he_heading_down,a11
	movi	>30,a10
	jsrp	stance_wait_yes

	move	@diff,a0,w
	cmpi	5,a0
	jrlo	drone_hikick
	jsrp	do_uppercut
	jruc	drone_reaction_exit

;*************************************************************************

c_slipping
	movi	>48,a11
	jsrp	drone_approach
	jsrp	do_duck
	jsrp	do_uppercut
	jruc	drone_reaction_exit

;*************************************************************************

c_superk_sd
	movi	act_superkang,a1
	movk	1,a7
	callr	react_jump_table
	.long	nail_superk_sd
	.long	nail_superk_sd

nail_superk_sd
	movi	ochar_superk_sd,a0
	calla	get_char_long
	jump	a0

ochar_superk_sd
	.long	drone_uppercut_jump
	.long	drone_uppercut_jump
	.long	drone_shoruken
	.long	drone_shred
	.long	drone_uppercut_jump
	.long	drone_uppercut_jump
	.long	drone_uppercut_jump
	.long	drone_uppercut_jump
	.long	drone_pee
	.long	drone_uppercut_jump
	.long	drone_zap_jump
	.long	drone_noogy

	.long	drone_uppercut_jump
	.long	drone_uppercut_jump

	.long	drone_uppercut_jump
	.long	drone_uppercut_jump
	.long	drone_uppercut_jump

;*************************************************************************

c_wave_sd
	jruc	drone_square_jump
;	jruc	drone_zap_jump

;*************************************************************************

diff_flipk_limits
	.word	3,3,2
	.word	2,2,2
	.word	2,2,2,1

rpt_angle_counter
	.word	200,250,350,400,550,600,650,750,800,800

c_angle_jump
	move	@diff,a0,w
	cmpi	1,a0
	jrls	return_to_beware	; easy ----> leave him alone for now

;***********
	movi	act_flykick,a1
	calla	get_my_hitq		; a0 = my hit queue ram
	callr	scan_1_entry
	cmp	a1,a2			; last hit a flip kick ???
	jreq	cang1			; yes, react to this !!
;***********

	movi	act_flykick,a1
	callr	count_q_repeats	 	; a3 = # of flip kicked

	movi	diff_flipk_limits,a0
	callr	get_diff_word	   	; a0 = frequency allowed !
	cmp	a0,a3
	jrhs	cang1			; enough is enough !!!

	movi	rpt_angle_counter,a0
	calla	ask_mr_diff		; standard randper
	jrnc	return_to_beware
*
* counter angle jump
*
cang1	callr	is_towards_me
	jrc	angle_towards_me

	move	*a13(p_otherguy),a0,l
	move	*a0(oxvel),a0,l
	jreq	counter_zero_angle
*
* he is flipping away from me !!
*
	movi	ft_raiden,a0
	callr	is_he_him
	jrc	zap_backflipper
	movi	ft_kang,a0
	callr	is_he_him
	jrc	zap_backflipper
	movi	ft_fn1,a0
	callr	is_he_him
	jrc	zap_backflipper
	movi	ft_fn2,a0
	callr	is_he_him
	jrc	zap_backflipper

	move	*a13(p_otherguy),a0,l
	move	*a0(oyvel),a0,l
	jrn	cang3				; heading up ---> ok to follow
	calla	get_his_dog
	cmpi	>40,a0
	jrlo	zap_backflipper			; too close to ground ---> dont 

cang3 	move	*a13(p_otherguy),a0,l
	move	*a0(ochar),a0,w
	cmpi	ft_hathead,a0			; he = kung lao ??
	jrne	cang4
	move	@diff,a0,w
	cmpi	4,a0
	jrhi	return_to_beware		; hard = dont make things ez for hh

cang4	movi	>40,a0
	calla	randu
	addi	>88,a0
	move	a0,*a13(p_store6),w		; distance we are longing for

	movi	>30,a10
	movi	flip_chase_check,a11
	jsrp	stance_wait_yes
	jruc	drone_frontflip_jump

flip_chase_check
	calla	is_he_airborn
	jrnc	fcc9	   			; on ground = abort
	calla	get_x_dist
	move	*a13(p_store6),a0,w		; distance we are longing for
	cmp	a0,a3
	jrhi	fcc9
	clrc
	rets
fcc9	setc
	rets

;**************************************************************************

zap_backflipper
	move	@diff,a0,w
	jreq	return_to_beware		; easy ---> dont zap

	movi	backflipper_x_dist,a0
	calla	get_char_word
	move	a0,*a13(p_store1),w		; height I want to look for

	movi	>40,a10
	movi	backflip_wait,a11
	jsrp	stance_wait_yes
	jruc	drone_zap_jump

backflip_wait
	move	*a13(p_store1),a1,w		; height I want to look for
	jruc	is_he_further


backflipper_x_dist
	.word	>50
	.word	>50
	.word	>50
	.word	>50
	.word	>50
	.word	>50
	.word	>50
	.word	>50
	.word	>50
	.word	>50
	.word	>50
	.word	>50

	.word	>50
	.word	>50

	.word	>50
	.word	>50
	.word	>50

;***************************************************************************

counter_zero_angle
	calla	get_x_dist
	cmpi	>b0,a3
	jrhi	return_to_beware	; too far away to give a shit about
	
	calla	get_x_dist
	cmpi	>75,a3
	jrlo	gca_close

	cmpi	>a0,a3
	jrlo	gca_med

	movi	>a0,a11
	jsrp	drone_approach
	jruc	asshole_wait

gca_med	movi	>a0,a11
	jsrp	drone_retreat
	jruc	asshole_wait

gca_close
	jruc	drone_quick_jupk

asshole_wait
	movi	q_he_heading_down,a11
	movi	>30,a10
	jsrp	stance_wait_yes
	jruc	drone_zap_jump

;***************************************************************************

drone_quick_jupk
	movi	scan_quick_jumpup_k,a11
	jsrp	drone_jumpup
	jruc	drone_reaction_exit

scan_quick_jumpup_k
	calla	distance_off_ground
	cmpi	>08,a0
	jrhi	drone_jupk_exit
	rets

drone_jupk_exit
	pull	a0
	pull	a0

	calla	reset_proc_stack
	jsrp	do_jumpup_kick
	jruc	drone_reaction_exit

;***************************************************************************

angle_towards_me
	calla	face_opponent

* insert: dont trap him code here

	calla	get_x_dist
;	cmpi	>a0,a3		   	; this old distance didn't work well
	cmpi	>80,a3		   	; time to kick him out of the air ?
	jrlo	drone_quick_jupk
*
* airzap if u can !!
*
	movi	angle_towards_reactions,a0
	jauc	ochar_jump

angle_towards_reactions
	.long	simple_angle
	.long	backflip_airthrow 	; kang
	.long	drone_cage_zaphi
	.long	drone_shred
	.long	airthrow_or_wave 	; fn1
	.long	backflip_airthrow 	; fn2
	.long	simple_angle
	.long	simple_angle
	.long	simple_angle
	.long	simple_angle
	.long	simple_angle
	.long	simple_angle

	.long	simple_angle
	.long	simple_angle

	.long	simple_angle
	.long	simple_angle
	.long	simple_angle

simple_angle
	callr	where_will_he_land		; a0 = his landing x
	move	*a8(oxpos),a1,w			; a1 = my current x
	sub	a0,a1
	abs	a1
	cmpi	>27,a1				; a1 = how far from me he'll land
	jrlo	flip_towards_land_close

	cmpi	>50,a1
	jrlo	kick_him_out_of_air

	movi	>30,a10
	movi	q_he_heading_down,a11
	jsrp	stance_wait_yes

	movi	ft_subzero,a0	
	calla	am_i_him
	jrc	drone_pee			; subzero = pee
	jruc	drone_zap_jump

;****************************************************************************

airthrow_or_wave
	calla	get_x_dist
	cmpi	>f0,a3
	jrhi	backflip_airthrow
	jruc	drone_wave

backflip_airthrow
	callr	drone_stop_me
	calla	face_opponent	
	movk	8,a9			; ani = back flip
	movi	>40000,a0
	movi	bfat_call,a6
  	movi	->a0000,a1		; initial y vel (upwards)
	movi	angle_grav,a2
	movk	3,a3			; animation speed
	movk	10,a11			; a11 = throw timer
 	jsrp	flight_call
	jruc	drone_land


bfat_call
	calla	next_flip_whoosh
	dsj	a11,bfat3

	pull	a0
	pull	a0
	calla	reset_proc_stack

	clr	a10			; forward zap
	movk	1,a0			; kang airzap
	move	*a8(ochar),a1,w
	cmpi	ft_kang,a1
	jaeq	lk_zapair

	movk	7,a0
	move	*a8(ochar),a1,w
	cmpi	ft_fn2,a1
	jreq	bfzap

	movk	6,a0
	move	*a8(ochar),a1,w
	cmpi	ft_fn1,a1
	jreq	bfzap

bfat3	rets

bfzap	jsrp	do_zap
	jauc	drone_reaction_exit

;****************************************************************************

flip_towards_land_close
	movi	close_out_of_air,a0
	jauc	ochar_jump

close_out_of_air
	.long	quick_flip_attack
	.long	drone_lk_super
	.long	drone_cage_zaphi
	.long	drone_shred
	.long	drone_wave
	.long	drone_fn2_tele
	.long	quick_flip_attack
	.long	quick_flip_attack
	.long	quick_flip_attack
	.long	quick_flip_attack
	.long	quick_flip_attack
	.long	quick_flip_attack

	.long	quick_flip_attack
	.long	quick_flip_attack

	.long	quick_flip_attack
	.long	quick_flip_attack
	.long	quick_flip_attack

;*************************************************************************

quick_flip_attack
	movi	10,a10
	movi	is_he_attacking,a11
	jsrp	stance_wait_yes
	calla	is_he_attacking
	jrnc	qfa3

	jsrp	do_duck				; a duck a down
	movi	>28,a10
	movi	q_ready_for_upcut,a11
	jsrp	still_wait_yes
	jsrp	do_uppercut
	jruc	drone_reaction_exit

qfa3	movi	scan_quick_flipp,a6
	jsrp	drone_frontflip_call
	jruc	drone_reaction_exit


q_ready_for_upcut
	calla	is_he_airborn
	jrnc	rfucy
	callr	a2_closest_point
	cmpi	>30,a2
	jrlo	rfucy
	clrc
	rets
rfucy	setc
	rets


q_he_heading_down
	move	*a13(p_otherguy),a0,l
	move	*a0(oyvel),a0,l
	jrp	hhdy
	clrc
	rets
hhdy	setc
	rets


scan_quick_flipp
	move	*a8(ochar),a0,w
	cmpi	ft_jax,a0
	jrne	sqf5

	calla	is_he_attacking
	jrc	sqf5			; he's attacking ---> no backbreak

	calla	get_x_dist
	cmpi	>60,a3	  		; close enough ?
	jrhi	sqf3			; no
	calla	get_y_dist
	cmpi	>60,a3	  		; close enough ?
	jrlo	drone_backbreaker
sqf3	rets

sqf5	calla	get_x_dist
	cmpi	>90,a3
	jrlo	do_flipp
	rets

do_flipp
	pull	a0
	pull	a0
	calla	reset_proc_stack
	jsrp	do_flip_kick
	jruc	drone_reaction_exit

drone_backbreaker
	pull	a0
	pull	a0
	calla	reset_proc_stack
	jsrp	do_back_breaker
	jruc	drone_reaction_exit

;**********************************************************************

kick_him_out_of_air
	movi	med_out_of_air,a0
	jauc	ochar_jump

hk_ooa
	movi	>40,a0
	move	a0,*a13(p_store8),w		; distance to wait for!
	movi	>30,a10
	movi	air_rhouse_check,a11
	jsrp	stance_wait_yes_nb
	calla	is_he_airborn
	jrnc	drone_reaction_exit		; on ground ---> skip
	jruc	drone_hikick

;*******************************************************************

rh_ooa	movi	rh_air_distances,a0
	calla	get_char_word
	move	a0,*a13(p_store8),w		; distance to wait for!
	movi	>30,a10
	movi	air_rhouse_check,a11
	jsrp	stance_wait_yes_nb

	calla	is_he_airborn
	jrnc	drone_reaction_exit		; on ground ---> skip
	jruc	drone_roundhouse


rh_air_distances
	.word	>40
	.word	>40
	.word	>40
	.word	>40
	.word	>40
	.word	>40
	.word	>40
	.word	>40
	.word	>40
	.word	>40
	.word	>40
	.word	>40

	.word	>40
	.word	>40

	.word	>40
	.word	>40
	.word	>40

;*******************************************************************

med_out_of_air
	.long	hk_ooa
	.long	drone_lk_super
	.long	drone_cage_zaphi
	.long	drone_shred
	.long	drone_wave
	.long	drone_fn2_tele
	.long	hk_ooa
	.long	rh_ooa
	.long	rh_ooa
	.long	rh_ooa
	.long	rh_ooa
	.long	rh_ooa

	.long	rh_ooa
	.long	rh_ooa

	.long	rh_ooa
	.long	rh_ooa
	.long	hk_ooa

drone_cage_zaphi
	movk	10,a10
	jsrp	stance_delay
	jsrp	cage_zap_hi_jsrp
	jruc	drone_reaction_exit

drone_uppercut_jump
	jsrp	do_uppercut
	jruc	drone_reaction_exit

drone_noogy
	jsrp	do_noogy
	jruc	drone_reaction_exit

drone_pee
	clr	a10
	movi	>0e,a0
	jsrp	do_zap
	jruc	drone_reaction_exit

drone_shoruken
	movk	6,a0
	jsrp	do_body_propell
	jruc	drone_reaction_exit

drone_shadow
	movk	8,a0
	jsrp	do_body_propell
	jruc	drone_reaction_exit

drone_lk_super
	movk	9,a0
	jsrp	do_body_propell
	jruc	drone_reaction_exit

drone_shred
	jsrp	do_shred
	jruc	drone_reaction_exit

drone_wave
	clr	a10
	movk	>0a,a0
	jsrp	do_zap
	jruc	drone_reaction_exit

drone_fn2_tele
	movk	1,a0
	jsrp	do_body_propell
	jruc	drone_reaction_exit



air_rhouse_check
	calla	is_he_airborn
	jrnc	fkrhy

	callr	a2_closest_point
	move	*a13(p_store8),a0,w	; a0 = distance we are looking for
	cmp	a0,a2
	jrlo	fkrhy
	clrc
	rets
fkrhy	setc
	rets

a2_closest_point
	movi	leftmost_mpart,a7
	calla	is_he_right
	jrc	arhc3
	movi	rightmost_mpart_a2,a7
arhc3	push	a8
	move	*a13(p_otherguy),a8,l
	call	a7			; a2 = his closest point to me !!
	pull	a8

	move	*a8(oxpos),a0,w
	sub	a0,a2
	abs	a2			; a2 = his x distance from me
	rets


rightmost_mpart_a2
	calla	rightmost_mpart
	move	a3,a2
	rets

where_will_he_land
	movi	>a0,a2				; assume moving right
	move	*a13(p_otherproc),a0,l
	move	*a0(p_store8),a0,w		; a0 = where he started
	move	*a13(p_otherguy),a1,l
	move	*a1(oxvel),a1,l
	jrp	wwhl3
	neg	a2				; other direction
wwhl3	add	a2,a0				; add in flip x coordinate change
	rets


**************************************************************************
*											     *
*                         COUNTERS MOVES						     *
*                         COUNTERS MOVES						     *
*                         COUNTERS MOVES						     *
*											     *
**************************************************************************
c_reptile_fly
	movi	act_reptile_fly,a1
	movk	3,a7
	callr	react_jump_table
	.long	drone_block
	.long	drone_block

;*************************************************************************

c_kano
	movi	act_kano,a1
	movk	3,a7
	callr	react_jump_table
	.long	drone_block
	.long	ct_kano

ct_kano
	callr	drone_get_x_dist
	cmpi	>80,a3
	jrlo	ckano3
*
* walk into slide
*
	movi	is_kano_close,a11
	jsrp	walk_wait_yes

ckano3	callr	drone_get_my_strength
	cmpi	6,a0
	jrlo	drone_frontflip		; me weak ---> avoid all contact
	jruc	drone_block

is_kano_close
	movi	act_kano,a3
	callr	is_he_doing_this
	jrnc	ikcl9	  		; not sliding anymoe ---> exit
	callr	drone_get_x_dist
	cmpi	>80,a3			; close ?
	jrlo	ikcl9
	clrc
	rets
ikcl9   	setc
	rets

;************************************************************************

c_frozen
	movi	>48,a11
	jsrp	drone_approach
	calla	is_he_airborn
	jrc	drone_hikick
	jsrp	do_uppercut
	jruc	drone_reaction_exit

;************************************************************************

c_speared_sd
	movi	>48,a11
	jsrp	drone_approach
	jsrp	do_uppercut
	jruc	drone_reaction_exit

;************************************************************************

c_hhspin
	jruc	drone_zap_jump

;************************************************************************

c_duck_kickl
	movi	>40,a2			; distance to ignore this
	callr	return_if_reach		; is he will reach me then return

	movi	act_duck_kickl,a1
	movk	3,a7
	callr	react_jump_table
	.long	av_duck_kickl
	.long	ct_duck_kickl

av_duck_kickl
	jruc	drone_block

ct_duck_kickl
	callr	drone_get_x_dist
	calla	can_drone_slam		; a0 = slam distance
	jreq	drone_block		; no slamming ---> block

	move	a0,a1
	sub	a3,a1
	jrp	drone_charge_slam	; we are already within range

	abs	a1			; a1 = how far from slamming distance
	cmpi	10,a1
	jrlo	drone_charge_slam	; close ---> slam
	jruc	drone_block		; not allowed to slam yet

;************************************************************************

c_ret_kick
	calla	is_he_short
	jrc	cretk4
	callr	rtb_nail_sd		; nail this sitting duck
cretk4	callr	sweep_if_u_can
	jruc	return_to_beware

;************************************************************************

c_duck_kickh
	movi	>40,a2			; distance to ignore this
	callr	return_if_reach		; is he will reach me then return

	movi	act_duck_kickh,a1
	movk	3,a7
	callr	react_jump_table
	.long	av_duck_kickl
	.long	ct_duck_kickl

;************************************************************************

c_lkzap_air
	movi	act_lkzap_air,a1
	movk	3,a7
	callr	react_jump_table
	.long	av_lkzap_air
	.long	av_lkzap_air

av_lkzap_air
	jsrp	stance_wait_proj_proc

	move	a0,a10
	movi	ft_fn1,a0
	calla	am_i_him
	jreq	duck_under_proj		; kat = dont raise arm and get hit

	move	*a10(pa8),a5,l		; a5 = proj obj
	move	*a5(oypos),a3,w
	move	@ground_y,a0,w
	sub	a3,a0
	cmpi	>a0,a0
	jrhi	zap_airborn_dude
	jruc	duck_under_proj

;************************************************************************

c_duckpunch
	movi	>40,a2			; distance to ignore this
	callr	return_if_reach		; is he will reach me then return

	movi	act_duckpunch,a1
	movk	3,a7
	callr	react_jump_table
	.long	av_duck_kickl
	.long	ct_duck_kickl

;************************************************************************


*
* Input: a10 = max time to wait
*        a11 = question which we exit with
*
dont_walk_into_it
	calla	reset_proc_stack
	callr	drone_stop_me

	movi	>30,a10
	movi	is_he_done_attacking,a11
	jsrp	stance_wait_yes			; wait for him 2 finish

	movi	ft_final_boss,a0
	calla	am_i_him
	jac	kahn_post_dont_walk
	jruc	drone_reaction_exit

is_he_done_attacking
	callr	is_he_attacking
	jrc	ihdan
	setc
	rets
ihdan	clrc
	rets


is_he_attacking
	callr	drone_get_his_action
	srl	8,a1
	sll	8,a1
	cmpi	act_attacks,a1
	jreq	ihay
	cmpi	act_body_propell,a1
	jreq	ihay

	clrc
	rets
ihay	setc
	rets

is_he_landed
	calla	is_he_airborn
	jrc	ihlno
	setc
	rets
ihlno	clrc
	rets

************************************************************************

c_scissor
	calla	get_x_dist
	cmpi	>b0,a3
	jrhi	return_to_beware
	jruc	drone_block

************************************************************************

c_noogy
	movi	>40,a2			; distance to ignore this
	callr	return_if_reach		; is he will reach me then return

noog3	movi	act_noogy,a1
	movk	3,a7
	callr	react_jump_table
	.long	av_noogy
	.long	ct_noogy

ct_noogy
	callr	drone_get_x_dist
	cmpi	>50,a3
	jrlo	drone_duck_upcut
	callr	sweep_if_u_can

av_noogy
	jruc	drone_duck

;************************************************************************

c_quake
	movi	act_quake,a1
	movk	3,a7
	callr	react_jump_table
	.long	drone_jumpup_nocall
	.long	ct_quake

ct_quake
	callr	hikick_if_u_can
	jruc	drone_jumpup_nocall

;************************************************************************

c_hh_sd
	callr	rtb_nail_sd			; nail this sitting duck

	movi	>44,a11
	jsrp	drone_approach

	movi	is_hh_sd_nailable,a11
	movi	>20,a10
	jsrp	stance_wait_yes			; wait to get in range
	jruc	drone_uppercut_jump
;	jruc	drone_flip_kick

is_hh_sd_nailable
	move	*a13(p_otherguy),a0,l
	move	*a0(oyvel),a0,l
	jrn	ihhhn				; heading up = nope

	calla	get_his_dog
;	cmpi	>50,a0
	cmpi	>48,a0
	jrlo	ihhhy

ihhhn	clrc
	rets

ihhhy	setc
	rets

;************************************************************************

c_decoy_sd
	callr	rtb_nail_sd			; nail this sitting duck
	movi	is_decoy_sd_kickable,a11
	movi	>20,a10
	jsrp	stance_wait_yes			; wait to get in range
	jruc	drone_hikick

is_decoy_sd_kickable
	move	*a13(p_otherguy),a0,l
	move	*a0(oyvel),a0,l
	jrn	idkn				; heading up = nope

	calla	get_his_dog
	cmpi	>50,a0
	jrlo	idky

idkn	clrc
	rets

idky	setc
	rets

;************************************************************************

c_decoy
	movi	act_decoy,a1
	movk	3,a7
	callr	react_jump_table
	.long	ct_decoy
	.long	ct_decoy

ct_decoy
	sleep	1			; let his velocity be set
	calla	get_his_dfeos		; a5=left   a6=right
	move	*a13(p_otherguy),a0,l
	move	*a0(oxvel),a4,l		; vel
	jrn	cdec4			; heading left
     	move	a6,a5			; a5 = edge to check for
cdec4	cmpi	>d0,a5
	jrhi	cdec7
*
* scorpion will cross
*
	calla	get_my_dfeos
	move	*a13(p_otherguy),a0,l
	move	*a0(oxvel),a4,l		; vel
	jrp	cdec5			; heading left
     	move	a6,a5			; a5 = edge to check for
cdec5	cmpi	>b0,a5
	jrhi	drone_reverse_zap_jump
	jruc	drone_block
*
* scorpion won't cross
*
cdec7	jruc	drone_zap_jump

;************************************************************************

c_orb_sd
	movi	act_slow_orb,a1
	callr	count_q_repeats	 	; a3 = # of skull hits so far ?
	cmpi	2,a3
	jrhs	corbsd3

	movi	act_slow_orb,a1
	movk	3,a7
	callr	react_jump_table
	.long	corbsd3
	.long	corbsd3

corbsd3	callr	is_orb_close
	jrnc	flip_over_orb

	jsrp	do_block_hi
	sleep	20
	jruc	drone_reaction_exit

;************************************************************************

c_slow_orb
	movi	act_slow_orb,a1
	callr	count_q_repeats	 	; a3 = # of skull hits so far ?
	cmpi	1,a3
	jrhi	ct_orb

	movi	act_slow_orb,a1
	movk	3,a7
	callr	react_jump_table
	.long	ct_orb
	.long	ct_orb

ct_orb	callr	sweep_if_u_can
	callr	drone_get_x_dist
	cmpi	>a0,a3
	jrhi	cso_7
	jruc	return_to_beware

cso_7	jsrp	drone_zap_jsrp


flip_over_orb
	movi	pid_orb2,a0
	movi	pid_orb1,a1
	calla	p1p2_pick
	clr	a1
	not	a1
	calla	existp			; his orb spawned ??
	jreq	drone_reaction_exit	; no

	movi	is_orb_close,a11
	jsrp	walk_wait_yes
	move	a10,a10
	jreq	drone_reaction_exit
	jruc	drone_flip_kick


is_orb_close
	callr	get_his_proj_proc
	move	a0,a10
	jreq	iocyes			; no proc = abort

	move	*a10(pa8),a0,l
	move	*a0(oxpos),a3,w
	move	*a8(oxpos),a0,w
	sub	a0,a3
	abs	a3
	cmpi	>80,a3
	jrlo	iocyes
	clrc
	rets
iocyes	setc
	rets

**************************************************************************
*											     *
*            PROJECTILE AVOIDENCE							     *
*            PROJECTILE AVOIDENCE							     *
*            PROJECTILE AVOIDENCE							     *
*											     *
**************************************************************************
c_throw_skull1
	movi	act_throw_skull1,a1
	movk	3,a7
	jruc	zapp3

c_spear
	movi	act_spear,a1
	jruc	zapp3

c_throw_ice
	movi	act_throw_ice,a1
	jruc	zapp3

c_throw_fans
	movi	act_throw_fans,a1
	jruc	zapp3

c_throw_tsai
	movi	act_throw_tsai,a1
	jruc	zapp3

c_jcsnot_lo
	movi	act_jcsnot_lo,a1	; only 1 catagory of Snot !!
	jruc	zapp3

c_spit	movi	act_spit,a1
	jruc	zapp3

c_spark	movi	act_spark,a1
	jruc	zapp3

c_jax_zap
	movi	act_jax_zap,a1
zapp3	movk	3,a7
	callr	react_jump_table

	.long	duck_under_proj
	.long	pro_avoid_projectile

c_jcsnot_hi
	movi	act_jcsnot_lo,a1	; only 1 catagory of Snot !!
	movk	3,a7
	callr	react_jump_table
	.long	duck_under_proj
	.long	duck_under_proj

c_air_tsai
	movi	act_throw_tsai,a1
	movk	3,a7
	callr	react_jump_table
	.long	ct_air_chick
	.long	ct_air_chick

c_air_fans
	movi	act_throw_fans,a1
	movk	3,a7
	callr	react_jump_table
	.long	ct_air_chick
	.long	ct_air_chick

c_throw_hat
	movi	act_throw_hat,a1
	movk	3,a7
	callr	react_jump_table
	.long	duck_under_hat
	.long	ct_hat

ct_hat	callr	standard_proj		; flip over projectile if u can

duck_under_hat
	calla	reset_proc_stack
	jsrp	drone_duck_real

	movi	act_blocklo,a0
	move	a0,*a13(p_action),w	; in case hat hits me
	jsrp	wait_proj_spawn
	jsrp	wait_proj_pass		; wait for projectile to pass
	jsrp	drone_backup
	jruc	drone_reaction_exit

c_throw_skull2
	movi	act_throw_skull1,a1
	jruc	csk3

c_throw_skull3
	movi	act_throw_skull1,a1
csk3	callr	count_q_repeats	 	; a3 = # of skull hits so far ?
	cmpi	3,a3
	jrhs	ct_skull		; 3 ---> enuf iz enuf

	movk	3,a7
	callr	react_jump_table
	.long	ct_skull
	.long	ct_skull

ct_skull
	calla	reset_proc_stack
	callr	sweep_if_u_can

;*********************
	movi	ochar_avoid_pro,a0
	calla	get_char_long		; whats my special retaliation
	cmpi	drone_flip_kick,a0	; standard bs ?
	jrne	avoid_proj_pro		; no, fuck em up !!

	callr	drone_get_x_dist 	; a3 = x distance
	cmpi	>b6,a3
	jrlo	ctsk2			; too close
	cmpi	>e0,a3
	jrlo	avoid_proj_pro		; within range ---> flip kick em
ctsk2
;*********************

	movi	skull_escape,a0
	calla	get_char_long		; do I have a way out of this ??
	jreq	ctsk3			; no, just duck

	movi	reaction_exit,a1
	pushp	a1			; setup for retp
	jump	a0

ctsk3	jsrp	stance_wait_proj_proc
ctsk4	jsrp	make_sure_i_am_ducked

tskul4	sleep	1
	callr	get_his_proj_proc	; wait for skull procs to die
	jrne	tskul4
	jsrp	drone_backup
	jruc	drone_reaction_exit

make_sure_i_am_ducked
	calla	am_i_short
	jrc	msiad8
	jsrp	do_duck			; duck if not ducked !!
msiad8	movk	5,a9
	calla	get_char_ani
	calla	find_last_frame
	calla	do_next_a9_frame	; last frame of duck animation
	retp

;**********************************************************************

c_skull_sd
	calla	reset_proc_stack
	callr	get_his_proj_proc
	jrne	ctsk4
*
	callr	sweep_if_u_can		; no skulls
	jruc	return_to_beware

;**********************************************************************

skull_escape
	.long	drone_hh_tele_jsrp	;  0 - kung lao
	.long	skull_lk_zaplo		;  1 - kang
	.long	0			;  2 - cage
	.long	0			;  3 - baraka
	.long	drone_square_wave	;  4 - kitana  (square wave)
	.long	drone_kano		;  5 - mileena (kano ball)
	.long	0			;  6 - shang 
	.long	drone_melt_jsrp		;  7 - raiden
	.long	drone_slide		;  8 - slide
	.long	drone_slide		;  8 - slide
	.long	skull_teleport		; 10
	.long	skull_quake		; 11

	.long	0
	.long	0

	.long	0
	.long	0
	.long	0


skull_lk_zaplo
	clr	a10
	movk	2,a0
	jsrp	do_zap

skull_stay_down
	movk	5,a9
	calla	get_char_ani
	calla	find_last_frame
	calla	do_next_a9_frame
	jruc	tskul4

skull_teleport
	callr	sc_tele_if_u_can
	calla	get_x_dist
	cmpi	>a0,a3
	jrlo	drone_zap_jump		; close enough = spear
	jruc	tskul4


sc_tele_if_u_can
	move	*a8(ochar),a0,w
	cmpi	ft_scorpion,a0
	jrne	stiuc9			; not scorpion

	calla	get_my_dfeos		; a5 / a6
	calla	is_he_right
	jrc	stiuc4
	move	a6,a5			; a5 = edge that is behind me
stiuc4	cmpi	>80,a5
	jrhi	stiuc9			; too far from edge of screen

	calla	get_my_dfe
	calla	is_he_right
	jrc	stiuc6
	move	a6,a5			; a5 = edge that is behind me
stiuc6	cmpi	>80,a5
	jrlo	stiuc9

	pull	a0
	movk	4,a0
	jsrp	do_body_propell
	jruc	drone_reaction_exit

stiuc9	rets


skull_quake
	jsrp	drone_quake_jsrp
	jruc	skull_stay_down

;************************************************************************

pro_avoid_projectile
	callr	standard_proj
	jruc	duck_under_proj		; too close

standard_proj
	callr	drone_get_x_dist 	; a3 = x distance
	cmpi	>b6,a3
	jrlo	close_proj		; too close

	pull	a0			; no return
	movi	rpt_pro_proj,a0
	callr	ask_mr_diff		; avoid it like a pro ?
	jrc	avoid_proj_pro		; yes
	jruc	drone_flip_kick		; no, just flip over the shit

close_proj
	rets

rpt_pro_proj
	.word	280,425,500,550,600,650,700,700,800,800

avoid_proj_pro
	movi	reaction_exit,a0
	pushp	a0			; setup for retp
	movi	ochar_avoid_pro,a0
	jauc	ochar_jump

ochar_avoid_pro
	.long	drone_hh_tele_jsrp	;  0 - kung lao
	.long	drone_lk_zaplo		;  1 - kang
	.long	drone_flip_kick		;  2 - cage
	.long	drone_flip_kick		;  3 - baraka
	.long	drone_square_wave	;  4 - kitana  (square wave)
	.long	drone_kano		;  5 - mileena (kano ball)
	.long	drone_flip_kick		;  6 - shang 
	.long	drone_melt_jsrp		;  7 - raiden
	.long	drone_slide		;  8 - slide
	.long	drone_slide		;  9 - slide
	.long	drone_flip_kick		; 10
	.long	drone_flip_kick		; 11

	.long	drone_flip_kick		; 11
	.long	drone_flip_kick		; 11

	.long	drone_flip_kick		; 11
	.long	drone_flip_kick		; 11
	.long	drone_flip_kick		; 11

;************************************************************************

c_floor_ice
	movi	act_floor_ice,a1
	callr	count_q_repeats	 	; a3 = # of hits so far
	move	a3,a3
	jrne	ct_floor_ice		; once is enuf !!

	movk	3,a7
	callr	react_jump_table
	.long	ct_floor_ice
	.long	ct_floor_ice

ct_floor_ice
         callr	sweep_if_u_can
	calla	get_x_dist
	cmpi	>d0,a3
	jrlo	ctfi4			; close to me ---> get outta the way

	jsrp	drone_zap_jsrp
	movi	>20,a10
	movi	is_puddle_spawned,a11
	jsrp	stance_wait_yes		; wait for ice proc
	jruc	drone_wait_puddle
	
ctfi4 	cmpi	>80,a3
	jrlo	drone_charge_slam
	jsrp	drone_backflip_jsrp

drone_wait_puddle
	movi	>80,a10
	movi	is_puddle_gone,a11
	jsrp	stance_wait_yes
	jruc	drone_reaction_exit

is_puddle_gone
	movi	pid_floor_ice2,a0
	move	*a8(oid),a1,w
	cmpi	1,a1
	jreq	ipt5
	movi	pid_floor_ice1,a0
ipt5	clr	a1
	not	a1
	calla	existp
	jreq	ipg_yes
	move	*a0(p_action),a0,w
	cmpi	act_proj_dead,a0
	jreq	ipg_yes
	clrc
	rets

ipg_yes	setc
	rets

is_puddle_spawned
	calla	get_his_floor_ice
	jreq	ips_no
	setc
	rets
ips_no	clrc
	rets
	
;************************************************************************

c_slide
	movi	act_slide,a1
	movk	3,a7
	callr	react_jump_table
	.long	drone_block
	.long	ct_slide

ct_slide
	callr	drone_get_x_dist
	cmpi	>80,a3
	jrlo	csld3
*
* walk into slide
*
	movi	is_slider_close,a11
	jsrp	walk_wait_yes

csld3	callr	drone_get_my_strength
	cmpi	6,a0
	jrlo	drone_frontflip		; me weak ---> avoid all contact
	jruc	drone_block

is_slider_close
	movi	act_slide,a3
	callr	is_he_doing_this
	jrnc	iscl9	  		; not sliding anymoe ---> exit
	callr	drone_get_x_dist
	cmpi	>80,a3			; close ?
	jrlo	iscl9
	clrc
	rets
iscl9   	setc
	rets

;************************************************************************

c_slide_sd
	callr	rtb_nail_sd		; nail this sitting duck
	callr	sweep_if_u_can
	jruc	return_to_beware

;************************************************************************

c_dive_sd
	callr	rtb_nail_sd			; nail this sitting duck

	movi	divesd_x_dist,a0
	calla	get_char_word
	move	a0,*a13(p_store1),w		; height I want to look for

	movi	>40,a10
	movi	divesd_wait,a11
	jsrp	stance_wait_yes
	jruc	drone_zap_jump

divesd_wait
	move	*a13(p_store1),a1,w		; height I want to look for
	jruc	is_he_further


divesd_x_dist
	.word	>70
	.word	>70
	.word	>80
	.word	>80
	.word	>10
	.word	>90
	.word	>50
	.word	>80
	.word	>80
	.word	>00
	.word	>a0
	.word	>80

	.word	>90
	.word	>90

	.word	>90
	.word	>90
	.word	>10

;************************************************************************

c_dive
	movi	act_dive,a1
	movk	3,a7
	callr	react_jump_table
	.long	drone_block
	.long	ct_dive

ct_dive
	callr	get_his_reach_y
	calla	highest_mpart			; a0 = highest mpart
	cmp	a0,a3
	jrlo	return_to_beware
	jruc	drone_block

;************************************************************************

c_melt
	callr	rtb_nail_sd		; nail this sitting duck
	callr	sweep_if_u_can
	jruc	return_to_beware

; dont keep jumping into this routine (ejbpatch)

;************************************************************************

c_morph
	callr	rtb_nail_sd		; nail this sitting duck
	callr	sweep_if_u_can
	jruc	drone_zap_jump

;************************************************************************

c_fntele
	movi	act_fntele,a1
	movk	3,a7
	callr	react_jump_table
	.long	drone_block
	.long	drone_block

;************************************************************************

c_fntele_sd
	callr	rtb_nail_sd		; nail this sitting duck

	movi	fntele_heights,a0
	calla	get_char_word
	move	a0,*a13(p_store1),w	; height I want to look for

	movi	>40,a10
	movi	fntele_wait,a11
	jsrp	stance_wait_yes
	jruc	drone_zap_jump

fntele_wait
	move	*a13(p_store1),a1,w	; height I want to look for
	jruc	his_dog_wait_lo

fntele_heights
	.word	>60
	.word	>70
	.word	>70
	.word	>78
	.word	>70
	.word	>70
	.word	>80
	.word	>70
	.word	>80
	.word	>68
	.word	>60
	.word	>70

	.word	>50
	.word	>50

	.word	>60
	.word	>60
	.word	>70

;************************************************************************

c_throw_bolt
	movi	act_throw_bolt,a1
	movk	3,a7
	callr	react_jump_table
	.long	duck_under_proj
	.long	pro_avoid_projectile

;************************************************************************

c_sonic
	callr	rtb_nail_sd		; nail this sitting duck
	callr	sweep_if_u_can
	jruc	drone_zap_jump

;************************************************************************

ct_air_chick
	jsrp	stance_wait_proj_proc
	move	a0,a10
	movi	ft_fn1,a0
	calla	am_i_him
	jreq	duck_under_proj		; kat = dont raise arm and get hit

	move	*a10(pa8),a5,l		; a5 = proj obj
	move	*a5(oypos),a3,w
	move	@ground_y,a0,w
	sub	a3,a0
	cmpi	>a0,a0
	jrhi	zap_airborn_dude
	jruc	duck_under_proj

;************************************************************************

c_spin
	movi	act_sa_spin,a1
	movk	3,a7
	callr	react_jump_table
	.long	av_spin
	.long	ct_spin

ct_spin
	callr	drone_get_x_dist
	cmpi	>80,a3
	jrhi	drone_zap_jump   	; far away from me ---> zap
	callr	sweep_if_u_can
*
* duck and wait
*
av_spin	calla	reset_proc_stack
	jsrp	drone_duck_real
	
	movi	>40*3,a10
cspin4	sleep	1
	callr	sweep_if_u_can
	dsj	a10,cspin4
	jruc	drone_reaction_exit

;************************************************************************

c_spin_sd
	callr	rtb_nail_sd		; nail this sitting duck
	jruc	drone_zap_jump

;************************************************************************

c_fan_swipe
	movi	act_fan_swipe,a1
	movk	3,a7
	callr	react_jump_table
	.long	drone_duck
	.long	ct_swipe

c_swipe
	movi	act_swipe,a1
	movk	3,a7
	callr	react_jump_table
	.long	drone_duck
	.long	ct_swipe

ct_swipe
	callr	drone_get_x_dist
	cmpi	scrrgt/2,a3
	jrhi	return_to_beware

	callr	sweep_if_u_can

	callr	drone_get_x_dist
	cmpi	>80,a3
	jrhi	drone_zap_jump		; far away from me ---> zap

	callr	will_he_reach_me
	jrnc	return_to_beware
	jruc	drone_duck_upcut

;************************************************************************

c_shred
	movi	act_shred,a1
	movk	3,a7
	callr	react_jump_table
	.long	drone_block
	.long	ct_shred

ct_shred
	callr	drone_get_x_dist
	callr	can_drone_slam
	cmp	a0,a3			; within range ?
	jrls	drone_body_slam		; too close = slam em

	cmpi	>60,a3
	jrhi	drone_zap_jump		; far away = zap him
	jruc	drone_block

;************************************************************************

c_splits
	movi	act_splits,a1	; only 1 catagory of Snot !!
	movk	3,a7
	callr	react_jump_table
	.long	drone_block
	.long	ct_splits

ct_splits
	callr	drone_get_x_dist
	cmpi	>50,a3
	jrlo	drone_charge_slam

	callr	sweep_if_u_can
	jruc	return_to_beware

;************************************************************************

c_shoruken
	movi	act_shoruken,a1		; only 1 catagory of Snot !!
	movk	3,a7
	callr	react_jump_table
	.long	av_shoruken
	.long	av_shoruken

av_shoruken
	movi	act_blocklo,a0
	move	a0,*a13(p_action),w	; in case Im hit
	jsrp	drone_duck_act
	jsrp	drone_wait_nonattack
	jruc	drone_reaction_exit

c_shoruken_sd
	callr	rtb_nail_sd		; nail this sitting duck

	callr	drone_get_x_dist
	cmpi	>a0,a3
	jrhi	drone_zap_jump	; far away ---> try throwing something

zap_airborn_dude
	callr	drone_get_x_dist
	cmpi	scrrgt/2,a3
	jrhi	drone_zap_jump		; far away ---> zap now !!

	movi	>40,a10
	movi	shoruken_wait,a11
	jsrp	stance_wait_yes
	jruc	drone_zap_jump

shoruken_wait
	movi	>50,a1
	jruc	his_dog_wait_lo


is_he_falling
	move	*a13(p_otherguy),a0,l
	move	*a0(oyvel),a0,l
	jrn	answer_no			; heading upwards = wait
	setc
	rets

his_dog_wait_hi
	calla	get_his_dog 		; a0 = his distance off ground
	cmp	a1,a0			; too high ?
	jrlo	answer_no		
	setc
	rets

his_dog_wait_lo
	calla	get_his_dog 		; a0 = his distance off ground
	cmp	a1,a0			; too high ?
	jrhi	answer_no		
	setc
	rets

answer_no
	clrc
	rets

is_he_further
	calla	get_x_dist
	cmp	a1,a3
	jrlo	answer_no
	setc
	rets

*
* a3 = action we are looking for
*
is_he_doing_this
	callr	drone_get_his_action
	cmp	a1,a3
	jreq	ihdty
	clrc
	rets
ihdty	setc
	rets

;************************************************************************

c_shadk
	movi	act_shadk,a1
	movk	3,a7
	callr	react_jump_table
	.long	drone_duck_upcut
	.long	drone_duck_upcut

;************************************************************************

c_bike
	movi	act_bike,a1
	movk	3,a7
	callr	react_jump_table
	.long	drone_duck
	.long	drone_duck

;************************************************************************

c_lkzap_hi
	movi	act_lkzap_hi,a1
stzap3	movk	3,a7

	callr	react_jump_table
	.long	duck_under_proj
	.long	clkzap3

clkzap3	callr	standard_proj		; flip over projectile if u can

duck_under_proj
	calla	reset_proc_stack
	jsrp	drone_duck_real
	jsrp	wait_proj_spawn

under_proj_2
	jsrp	wait_proj_pass		; wait for projectile to pass
	jsrp	drone_backup
	jruc	drone_reaction_exit


c_lkzap_lo
	movi	act_lkzap_hi,a1		; this SHOULD be hi !!!
	movk	3,a7
	callr	react_jump_table
	.long	ct_lkzap_lo
	.long	ct_lkzap_lo

ct_lkzap_lo
	callr	drone_get_x_dist
	cmpi	>62,a3 			; close enough to throw ?
	jrls	drone_charge_slam	; no

	callr	drone_get_x_dist    	; a3 = x distance
	cmpi	>b6,a3
	jrlo	lkzap_close		; too close
	jruc	drone_flip_kick

lkzap_close
	movi	rt_lkzap_lo,a0
	jruc	random_do

rt_lkzap_lo
	.word	3
	.long	drone_jumpup_nocall
	.long	drone_jumpup_nocall
	.long	drone_jumpup_nocall

;************************************************************************

c_super_kang
	movi	act_superkang,a1
	movk	3,a7
	callr	react_jump_table
	.long	ct_superkang
	.long	ct_superkang

ct_superkang
	move	@diff,a0,w
	cmpi	3,a0
	jrlo	drone_duck		; easy ---> duck

	calla	get_my_strength		; a0 = my power
	cmpi	15,a0
	jrhi	block_superkang

	callr	drone_get_x_dist
	movi	superkang_zap_dist,a0
	calla	get_char_word
	cmp	a0,a3
	jrhi	csk_long
	jruc	drone_duck

block_superkang
	jsrp	do_block_hi
	jsrp	drone_wait_non
	jruc	drone_reaction_exit

csk_long
	jauc	drone_zap_jump

superkang_zap_dist
	.word	>c8
	.word	>ba
	.word	>d0
	.word	>d0
	.word	>d0
	.word	>d0
	.word	>d0
	.word	>d0
	.word	>d0
	.word	>d0
	.word	>d0
	.word	>d0

	.word	>d0
	.word	>d0

	.word	>d0
	.word	>d0
	.word	>d0

;************************************************************************

c_hh_teleport
	move	*a13(p_otherguy),a0,l
	move	*a0(ograv),a0,l
	jrn	chht5			; already crossed over
*
* already crossed
*
	jsrp	drone_face_turn		; turn around if u have 2
	callr	drone_get_x_dist
	cmpi	>80,a3
	jrhi	chht5
*
* close to me !!
*
	movi	hikick_if_u_can,a10
	movi	>30,a11
	jsrp	walk_on_a_mission
	jruc	drone_zap_jump
*
* heading towards the sky
*
chht5	movi	wait_4_hh_cross,a11
	movi	>40,a10			; max wait time
	jsrp	stance_wait_yes
	jrnc	drone_reaction_exit

	calla	reset_proc_stack
	jsrp	drone_face_turn		; turn around if u have 2
	movi	rt_hh_tele,a0
	jruc	random_do

rt_hh_tele
	.word	3
	.long	do_hi_kick
	.long	do_sweep_kick
	.long	drone_zap_jsrp

wait_4_hh_cross
	move	*a13(p_otherguy),a10,l
	move	*a10(ograv),a0,l
	jrp	w4c9
	clrc
	rets
w4c9	setc
	rets

;************************************************************************

c_lopunch
	movi	>40,a2			 	; distance to ignore this
	callr	punch_return_if_reach 	; is he will reach me then return
	movi	act_lopunch,a1
	jruc	cpun3

c_hipunch
	movi	>40,a2			 	; distance to ignore this
	callr	punch_return_if_reach 	; is he will reach me then return
	movi	act_hipunch,a1
cpun3	movk	1,a7

	callr	react_jump_table
	.long	drone_duck
	.long	drone_sweep

punch_return_if_reach
	push	a2
	callr	will_he_reach_me
	pull	a2
	jrc	riryes

	pull	a0				; no return
	cmp	a2,a3
	jrhi	return_to_beware		; far off = ignore
*
* don't walk into punch
*
	calla	reset_proc_stack
	callr	drone_stop_me
	callr	drone_stance_setup

	movi	>20,a10
dwp3	calla	next_anirate
	push	a10
	callr	is_he_punching
	pull	a10
	jrnc	prir9				; carry set = exit
	sleep	1
	dsj	a10,dwp3
	callr	sweep_if_u_can

prir9	jruc	drone_reaction_exit


is_he_punching
	callr	drone_get_his_action
	cmpi	act_hipunch,a1
	jreq	ihpy
	cmpi	act_lopunch,a1
	jreq	ihpy
	clrc
	rets
ihpy	setc
	rets

;************************************************************************
c_uppercut
	movi	act_uppercut,a14
	movi	>4a,a2			; distance to ignore this
	callr	return_if_reach		; is he will reach me then return

    	movk	3,a7
	move	a14,a1			; a1 = act
	callr	react_jump_table
	.long	drone_duck_upcut
	.long	drone_duck_upcut

;*************************************************************************

c_roundhouse
	movi	act_rhouse,a14
	movi	>40,a2			; distance to ignore this
	callr	return_if_reach		; is he will reach me then return
	jruc	ckik3

c_lokick
	movi	act_medkick,a14
	movi	>40,a2			; distance to ignore this
	callr	return_if_reach		; is he will reach me then return
	jruc	ckik3

c_hikick
	movi	>40,a2			; distance to ignore this
	callr	return_if_reach		; is he will reach me then return
	movi	act_hikick,a14

ckik3	movk	1,a7
	move	a14,a1			; a1 = act
	callr	react_jump_table
	.long	drone_duck
	.long	ct_kick

ct_kick	movi	rt_attack_kick,a0
	jruc	random_do

rt_attack_kick
	.word	3
	.long	do_sweep_kick
	.long	drone_duck
	.long	drone_duck_upcut

;***************************************************************************

c_sweep
	movi	>40,a2			; distance to ignore this
	callr	return_if_reach		; is he will reach me then return

	movk	1,a7
	movi	act_sweep,a1
	callr	react_jump_table
	.long	av_sweep
	.long	ct_sweep

ct_sweep
	callr	can_drone_slam
	jreq	av_sweep
	callr	drone_get_x_dist
	cmpi	>70,a3
	jrlo	drone_charge_slam

av_sweep
	calla	get_my_dfe
	cmp	a5,a6
	jrlo	close_to_right
	cmpi	>60,a5
	jrhi	drone_backflip
	jruc	drone_frontflip_jump
	jruc	block_sweep

close_to_right
	cmpi	>60,a6
	jrhi	sweep_backflip
	jruc	drone_frontflip_jump

block_sweep
	jsrp	drone_duck_block
	jruc	drone_reaction_exit

sweep_backflip
	jsrp	drone_backflip
	jruc	drone_reaction_exit

drone_frontflip_jump
	jsrp	drone_frontflip
	jruc	drone_reaction_exit

;**************************************************************************

*
* input: a11 = routine to call every tick
*
drone_jumpup_nocall
	clr	a11

drone_jumpup
	jsrp	do_jump_up
	jruc	drone_land
	

;**************************************************************************

drone_face_turn
	calla	am_i_facing_him
	jrc	dft9			; I am facing him ---> return
	jauc	turn_around
dft9	retp

;**************************************************************************

drone_backflip_jsrp
	clr	a6
	push	a6
	calla	face_opponent
	pull	a6
	movk	8,a9
	calla	get_char_ani
	movi	>40000,a0
	calla	away_x_vel

	movi	dont_touch,a0
  	movi	->a0000,a1		; initial y vel (upwards)
	movi	angle_grav,a2
	movk	3,a3			; animation speed
 	jsrp	flight_call

	movi	act_land,a1
	move	a1,*a13(p_action),w	; action: landing on the ground
	calla	am_i_facing_him
	jrc	dbfj4
    	calla	flip_multi		; always end up facing enemy !

*
* land animation !!
*
dbfj4	movk	6,a9
	calla	find_ani_part2
	tsound	>1e			; feet gently landing on the ground

	movk	3,a0
	calla	init_anirate
dbfj6	sleep	1
	callr	drone_beware
	calla	next_anirate
	move	*a9,a0,l
	jrne	dbfj6
	retp

;**************************************************************************


drone_frontflip
	clr	a6

drone_frontflip_call
	push	a6
	calla	face_opponent
	pull	a6
	movk	7,a9
	calla	get_char_ani
	movi	->40000,a0
	jruc	dflp2


drone_backflip
	clr	a6

	push	a6
	calla	face_opponent
	pull	a6

	movk	8,a9
	calla	get_char_ani
	movi	>40000,a0
dflp2	calla	away_x_vel

	movi	dont_touch,a0
  	movi	->a0000,a1		; initial y vel (upwards)
	movi	angle_grav,a2
	movk	3,a3			; animation speed
 	jsrp	flight_call

	movi	act_land,a1
	move	a1,*a13(p_action),w	; action: landing on the ground
	calla	am_i_facing_him
	jrc	dbf4
    	calla	flip_multi		; always end up facing enemy !
dbf4	jruc	drone_land

;***************************************************************************

c_flypunch
	movk	1,a7
	movi	act_flypunch,a1
	callr	react_jump_table
	.long	av_flyattack
	.long	av_flyattack

c_flykick
	movk	1,a7
	movi	act_flykick,a1
	callr	react_jump_table
	.long	av_flyattack
	.long	av_flyattack

av_flyattack
	callr	is_towards_me
	jrc	flykick_towards_me
*
* away from me !!
*
	callr	will_he_reach_me
	jrnc	return_to_beware
	jruc	drone_block

flykick_towards_me
	callr	will_he_reach_me	; towards me and close ?
	jrc	flyk3			; yes

	calla	get_x_dist
	cmpi	>a0,a3
	jrlo	drone_block
*
* escape ?
*
	movi	500,a0
	calla	randper
	jrc	flyk2

	calla	get_my_dfe
	cmpi	>80,a5
	jrlo	flyk2
	cmpi	>80,a6
	jrlo	flyk2			; close to edge ---> dont backflip
	jruc	drone_backflip

flyk2	movi	>30,a10
	movi	is_flyk_close,a11
	jsrp	stance_wait_yes
	calla	get_x_dist
	cmpi	>a0,a3
	jrhi	drone_reaction_exit	; far away from me ---> exit
	calla	is_he_airborn
	jrnc	drone_reaction_exit
	jruc	drone_quick_jupk


flyk3	movi	ft_fn2,a0
	calla	am_i_him
	jrc	drone_kano_jump

	movi	ft_raiden,a0
	calla	am_i_him
	jrnc	drone_block

	jsrp	drone_melt_jsrp
	jruc	drone_reaction_exit


is_flyk_close
	callr	is_he_body_propell
	jrnc	ifkc9
	calla	get_x_dist

;********
;	cmpi	>a0,a3
	cmpi	>80,a3
;********

	jrlo	ifkc9			; close
	clrc
	rets

ifkc9	setc
	rets

;***************************************************************************

is_he_body_propell
	callr	drone_get_his_action
	srl	8,a1
	sll	8,a1
	cmpi	act_body_propell,a1	; attacking still ?
	jreq	ihbpy			; yes, wait
	clrc
	rets
ihbpy   	setc
	rets

;***************************************************************************

c_jumpupp
	movk	1,a7
	movi	act_juppunch,a1
	callr	react_jump_table
	.long	av_jumpup_attack
	.long	av_jumpup_attack

c_jumpupk
	movk	1,a7
	movi	act_jupkick,a1
	callr	react_jump_table
	.long	av_jumpup_attack
	.long	av_jumpup_attack

av_jumpup_attack
	callr	will_he_reach_me
	jrnc	jupk_far

	callr	drone_get_x_dist		; a3 = x distance
	cmpi	>60,a3
	jrlo	block_jumpup_kp

	jsrp	do_sweep_kick
	jruc	drone_reaction_exit

jupk_far
	callr	drone_get_x_dist		; a3 = x distance
	cmpi	>a0,a3
	jrlo	drone_zap_jump
	jruc	return_to_beware

block_jumpup_kp
	jsrp	drone_duck_block	; too close to sweep
	jruc	drone_reaction_exit

;***************************************************************************

c_elbow
c_knee
	callr	rtb_nail_sd		; nail this sitting duck
	jruc	drone_block

c_elbow_sd
c_knee_sd
	callr	rtb_nail_sd		; nail this sitting duck
	callr	can_drone_slam
	jreq	csdke3
	callr	drone_get_x_dist
	cmp	a0,a3 			; close enough to throw ?
	jrls	drone_body_slam		; no
csdke3	jsrp	do_lo_kick
	jruc	drone_reaction_exit

**********************************************************************

c_proj_sd
	movi	pid_proj2,a0
	movi	pid_proj1,a1
	calla	p1p2_pick
	movi	>f00,a1
	calla	existp			; proj proc out there ?
	jrne	cpsd5			; yea...

	callr	rtb_nail_sd		; nail this sitting duck
	callr	sweep_if_u_can
	jruc	return_to_beware

cpsd5	move	*a0(p_action),a1,w
	cmpi	act_proj_passed,a1
	jreq	return_to_beware	; its already passed me ---> ignore
	cmpi	act_proj_dead,a1
	jreq	return_to_beware	; dead = ignore

	movi	act_blockhi,a1		; action: block, in case I am hit
	jsrp	drone_duck_act
	jruc	under_proj_2

**********************************************************************

drone_orb
	movi	>0b,a0
	clr	a10
	jsrp	do_zap
	jruc	drone_reaction_exit

drone_decoy
	movk	4,a0
	jauc	do_body_propell

drone_inviso_jump
	jsrp	do_inviso
	jruc	drone_reaction_exit

drone_kano_jump
	jsrp	drone_kano
	jruc	drone_reaction_exit

drone_square_jump
	jsrp	drone_square_wave
	jruc	drone_reaction_exit

drone_square_wave
	movi	>0b,a0
	jauc	do_body_propell

drone_lk_zaplo
	clr	a10
	movk	2,a0
	jauc	do_zap


drone_hh_tele_jump
	jsrp	drone_hh_tele_jsrp
	jruc	drone_reaction_exit

drone_hh_tele_jsrp
	clr	a0
	jruc	local_drone_do_a0

drone_do_bicycle
	movk	1,a0
	jruc	local_drone_do_a0

drone_do_fn_tele
	movk	3,a0
	jruc	local_drone_do_a0

drone_rmorph_jump
	jsrp	drone_rmorph_jsrp
	jruc	drone_reaction_exit

drone_rmorph_jsrp
	movk	4,a0
	jruc	local_drone_do_a0


drone_melt_jump
	jsrp	drone_melt_jsrp
	jruc	drone_reaction_exit

drone_melt_jsrp
	movk	5,a0
	jruc	local_drone_do_a0

drone_slide
	movk	6,a0
	jruc	local_drone_do_a0

;*********************************************

drone_quake_jump
	jsrp	drone_quake_jsrp
	jsrp	do_backup
	jruc	drone_reaction_exit

drone_quake_jsrp
	movk	8,a0
	jruc	local_drone_do_a0

;*********************************************

drone_kano
	movk	9,a0
	jruc	local_drone_do_a0

local_drone_do_a0
	jauc	drone_do_a0

**********************************************************************

boss_jump
	pull	a2			; a2 = 1st address
	move	*a8(ochar),a0,w
	cmpi	ft_goro,a0		; goro ?
	jreq	boss9			; yes

	cmpi	ft_final_boss,a0
	jreq	bossx

	addi	32*2,a2			; a2 = beyond end of table
	jump	a2			; just fall through

boss9	move	*a2,a2,l		; grab address for goro
	jump	a2

bossx	addi	32,a2
	jruc	boss9

**********************************************************************

; suggestions:
; jax ---> hh tele ---> grab and pound


**************************************************************************
*											     *
*  how_do_i_react - Answers the question given: a7 = table of randpers   *
* 											     *
*  Input: a1 = action to avoid repeats						     *
*         a7 = 0-3 (magnitude of hit)							     *
* 											     *
*  Returns: a0 = 0 ---> let him hit me						     *
*                1 ---> block / avoid his attack				     *
*                2 ---> counter his attack with one of my own		     *
*											     *
**************************************************************************
react_jump_table
	pull	a2		 	; a2 = return address

	cmpi	3,a7
	jrls	hdr3
	movk	3,a7
hdr3 	move	a7,a5

	callr	count_q_repeats	 	; a3 = # of hits so far
	sll	5,a5
	addi	drone_repeats,a5
	move	*a5,a5,l
	move	@diff,a0,w
	sll	4,a0
	add	a5,a0	
	move	*a0,a0,w		; a0 = # of hits ALLOWED
	cmp	a0,a3			; how many ?
	jrhs	hdr6			; too many ---> counter this move

	sll	5,a7
	addi	drone_randpers,a7
	move	*a7,a7,l
	move	@diff,a0,w
	sll	4,a0
	add	a7,a0
	move	*a0,a0,w		; grab a percentage
	calla	randper			; react ?
	jrc	hdr5			; yes
	jruc	return_to_beware	; no reaction ----> ignore
*
* react to him
*
hdr5	move	@diff,a0,w
	sll	4,a0
	addi	rpt_counter,a0
	move	*a0,a0,w
	calla	randper
	jrnc	hdr7
hdr6	addi	32,a2			; 2nd entry = counter
hdr7	move	*a2,a2,l		; grab 1st entry = avoid
	jump	a2

rpt_counter
	.word	300,350,550,600,700,750,800,800,800,900

****************************************************************************

drone_randpers
	.long	drone_rpt_0
	.long	drone_rpt_1
	.long	drone_rpt_2
	.long	drone_rpt_3

drone_rpt_0
	.word	100,150,250,350,400,500,550,600,650,700

drone_rpt_1
	.word	150,175,300,400,550,600,650,700,750,750

drone_rpt_2
	.word	150,175,350,500,650,700,750,750,775,800

drone_rpt_3
	.word	150,225,400,550,700,750,800,800,850,900


drone_repeats
	.long	repeat_0	; easy
	.long	repeat_1
	.long	repeat_2
	.long	repeat_3

*
* these are the values which we will ALLOW !!
*
repeat_0	.word	5,4,4,4,3,3,3,3,2,2
repeat_1	.word	4,4,4,3,3,3,3,2,2,2
repeat_2	.word	4,4,4,3,3,2,2,2,2,2
repeat_3	.word	4,4,3,3,3,2,2,2,1,1

****************************************************************************

rtb_nail_sd
	pull	a14			; a14 = return address
	movi	rpt_nail_sd,a0
	callr	ask_mr_diff
	jrnc	return_to_beware	; no react ---> return to beware
	jump	a14

rpt_nail_sd
	.word	100,250,300,400,500,600,600,700,700,700

****************************************************************************

how_do_i_react
	move	@diff,a0,w
	sll	4,a0
	add	a7,a0
	move	*a0,a0,w		; grab ranper from table
	calla	randper
	jrc	hdir5			; dont let him just nail me
	clr	a0			; I am a sucka
	rets

hdir5	movi	500,a0
	calla	randper
	jrc	hdir7
	movk	1,a0
	rets
hdir7	movk	2,a0
	rets


am_i_way_ahead
	calla	get_his_matchw		; a0 = his match wins
	move	a0,a0
	jrne	aiwa_no			; he has a win ---> no charity for him

	calla	get_my_matchw
	move	a0,a0
	jreq	aiwa_no			; I have not won yet ---> no charity

	calla	get_my_strength		; a0 = my strength
	cmpi	full_strength/3,a0
	jrlo	aiwa_no			; I am too weak ---> no charity

	calla	get_his_strength
	cmpi	>30,a0
	jrhi	aiwa_no			; he is too strong ---> no charity

	setc
	rets

aiwa_no	clrc
	rets


is_he_close_ground
	movi	>28,a5
	jruc	ihg3


is_he_grounded
	movk	3,a5
ihg3	calla	get_his_dog		; a0 = his distance off ground
	cmp	a5,a0
	jrlo	ilsy
	clrc
	rets
ilsy	setc
	rets

is_he_done_sd
	callr	drone_get_his_action
	srl	8,a1
	sll	8,a1
	cmpi	>600,a1
	jrne	ihdsdy
	clrc
	rets
ihdsdy	setc
	rets


	.end
