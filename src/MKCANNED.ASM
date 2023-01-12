**************************************************************************
*											     *
*  video game project:	mortal kombat 2							*
* 											     *
*  game software:    	ed boon								     *
* 											     *
*  module: canned animations									*
* 											     *
*  copyright (c) 1993 midway manufacturing							*
*											     *
**************************************************************************
	.file	'mkcanned.asm'
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
*  winner status = 3									     *
*											     *
**************************************************************************
finish_him
	move	*a13(p_flags),a4,w
	btst	pb_finish,a4			; am i finishing him ?
	jreq	fhim3				; no
	rets


fhim3	pull	a1				; no retreat / no return
	move	@p1_matchw,a0,w
	move	@p2_matchw,a1,w
	move	*a13(procid),a2,w
	cmpi	pid_p1,a2			; am i player 1 ??
	jreq	fhim4				; yes
	swap	a0,a1				; no ---> swap
fhim4	cmp	a1,a0				; more wins for me ?
	jrlo	dizzy_dude			; no ---> dizzy

	move	*a13(p_flags),a4,w
	ori	pm_finish,a4
	move	a4,*a13(p_flags),w		; flag: i am finishing him

fhim5	calla	am_i_joy
	janc	drone_finish_him		; drone ---> finish
	jauc	joy_entry			; joy ---> let him handle it

**************************************************************************
*											     *
*  winner status = 1									     *
*											     *
**************************************************************************
player_1_wins
	movk	pid_p1,a2
	jruc	plwins

**************************************************************************
*											     *
*  winner status = 2									     *
*											     *
**************************************************************************
player_2_wins
	movk	pid_p2,a2
plwins  	pull	a3
	move	*a13(procid),a0,w		; a0 = my id
	cmp	a0,a2				; am i the winner
	jreq	victory_animation		; yes ---> celebrate
*
* I lost
*
	calla	disable_all_buttons
	jruc	collapse_on_ground


victory_animation
	calla	stop_me
	calla	disable_all_buttons
	calla	am_i_shang
	jrc	st_victory
	movi	victory_jumps,a0
	calla	get_char_long
	jump	a0


victory_jumps
	.long	generic_victory	; 0
	.long	lk_victory	; 1
	.long	jc_victory	; 2
	.long	sa_victory	; 3
	.long	generic_victory	; 4
	.long	generic_victory	; 5
	.long	st_victory	; 6
	.long	raiden_victory	; 7
	.long	generic_victory	; 8
	.long	generic_victory	; 9
	.long	generic_victory	; a
	.long	generic_victory	; b

	.long	goro_victory	; c
	.long	kahn_victory	; d

	.long	smoke_victory	; e
	.long	generic_victory	; f
	.long	generic_victory	; 10


kahn_victory
	calla	get_x_dist
	cmpi	>d0,a3
	jrhi	klaf3			; far from me = just laugh

	movi	>68,a11
	jsrp	kahn_stalk_a11		; close = walk up to him

	calla	stop_me
	sleep	>18
	movk	5,a0
	calla	randu
	dec	a0
	sll	4,a0
	addi	kahn_victory_taunts,a0
	move	*a0,a0,w
	calla	triple_sound2

	movi	>19,a9
	calla	get_char_ani
	movk	2,a10
kvic2	movk	3,a0
	jsrp	mframew			; point
	movk	6,a0
	calla	randu
	addk	10,a0
	calla	prcslp
	dsj	a10,kvic2
	jruc	local_wait_forever

kahn_victory_taunts
	.word	>42
	.word	>4c
	.word	>4d
	.word	>4e
	.word	>4f


klaf3	movi	>0049004a,a1	
	calla	randsnd2		; random laugh !!
	movi	>0d,a9
	calla	get_char_ani
	movi	>0008000d,a0
	jsrp	animate_a0_frames
	jruc	local_wait_forever


goro_victory
	movi	>0006000d,a9
	jruc	vict4

sa_victory
	movi	>00060029,a9

vict4	jsrp	animate_a9
	movk	6,a0
	jsrp	mframew
	jruc	local_wait_forever

st_victory
	movi	ft_st,a0
	calla	am_i_him			; am I in shang form ???
	jreq	stv5				; yes

	jsrp	back_to_shang_form

stv5	movi	>29,a9
	calla	do_first_a9_frame
	jruc	local_wait_forever


lk_victory
	move	@gstate,a0,w
	cmpi	gs_psel,a0
	jreq	generic_victory
	tsound	>3a			; kang: Oooooo


smoke_victory
	calla	clear_shadow_bit

generic_victory
	movi	>00060029,a9
	jsrp	animate_a9
	jruc	local_wait_forever


raiden_victory
	movi	>00060029,a9
	jsrp	animate_a9

	move	@gstate,a0,w
	cmpi	gs_gameover,a0
	jreq	local_wait_forever
	cmpi	gs_psel,a0
	jreq	local_wait_forever
	cmpi	gs_post_psel,a0
	jreq	local_wait_forever

	create	pid_lightning,victory_lighting
*
* flash myself some !!!
*
rvic4	sleep	2

	move	@f_fade,a0,w
	jrne	rvic5
	create	pid_fade,rvic_fade

rvic5	tsound	>f0			; raiden victory sound

  	movk	6,a11
rvic6	calla	player_froze_pal
	sleep	4
	calla	player_normpal
	sleep	4
	dsj	a11,rvic6
	jruc	local_wait_forever

rvic_fade
	movi	pid_cycle,a0
	calla	dallprc			; stop color cyclers
	calla	raiden_dimmer
	sleep	>2d
	calla	raiden_undimmer
	die

;************************************************************************

victory_lighting
	move	a8,a11			; a11 = raiden obj

	movk	5,a9
	calla	get_char_ani2
	calla	gmo_proc
	move	a8,a10
	move	a8,a0
	move	a11,a8
	calla	match_ani_points	; lineup with raiden
	move	a10,a0
	calla	insobj

	calla	gmo_proc
	move	a8,a0
	move	a8,a14
	move	a11,a8
	calla	match_ani_points	; lineup with raiden

	move	a14,a8
	calla	flip_multi
	movi	-8,a0
	clr	a1
	calla	multi_adjust_xy		; lineup with raiden's arm
	calla	insobja8

	tsound2	>04
	move	a9,a11
	movk	4,a0
	jsrp	double_mframew

	move	a8,a0
	calla	delobjp
	move	a10,a0
	calla	delobjp

	die

;************************************************************************

jc_victory
	calla	stop_me
	movi	>00060029,a9
	jsrp	animate_a9
	sleep	>0c

	movk	8,a0
	jsrp	mframew
	sleep	>14

	movk	8,a0
	jsrp	mframew
	sleep	>1a

	movk	5,a0
	jsrp	mframew
	jruc	local_wait_forever

local_wait_forever
	jauc	wait_forever


back_to_shang_form
	movi	act_morph,a1
	calla	init_special_act

	move	a8,a0
	calla	clear_inviso

	tsound	>5c	   		; morph sound

	movi	st_anitab2,a0
	calla	get_char_long		; get proper animation table
	move	a0,a9
	addi	32*3,a0
	move	*a0,a0,l
	move	*a0,a0,l
	move	*a0(icmap),a0,l
	calla	player_swpal		; change to morph pal


	move	*a8(ochar),a0,w
	cmpi	ft_sa,a0		; vogel stupidity ?
	jrne	back8			; nope...

	addi	32*4,a9			; a9 ---> frame 3 of morph
	jruc	back7

back8	addi	32*5,a9			; a9 ---> frame 3 of morph
	jsrp	back_shang_ani
back7	jsrp	back_shang_ani
	jsrp	back_shang_ani		; 3 morph frames
*
* switch to shang pal
*
	movk	ft_st,a0
	move	a0,*a8(ochar),w		; define my original ochar
	calla	player_normpal	 	; new normal palette
	clr	a9
	calla	do_first_a9_frame			; pose: stance1		
	calla	ground_ochar				; new ground position
	move	*a8(oypos),*a13(p_ganiy),w    	; new grounded y pos
	sleep	4
	retp
;	jauc	reaction_exit

back_shang_ani
	calla	do_next_a9_frame
	subi	32*2,a9			; move backwards
back9	sleep	4
	retp

**************************************************************************
*											     *
*                      REACTION TO DEATH BLOWS					     *
*                      REACTION TO DEATH BLOWS					     *
*                      REACTION TO DEATH BLOWS					     *
*											     *
**************************************************************************

r_stabbed_by_fn2
	movk	>0b,a0
	calla	create_blood_proc

	calla	face_opponent

	movi	>37,a9
	calla	get_char_ani
	movk	4,a0
	calla	init_anirate
	movk	6,a11

	movi	>8585b8b7,a1		; a1 = left / right / kang / female
	calla	ochar_sound 		; disturbing scream

sbfn2	sleep	1
	calla	next_anirate

	dsj	a11,sbfn3
	movk	6,a11
	tsound	>18	   		; stab sound / borrow block sound
sbfn3	clr	a3
	calla	distance_from_ground
	cmpi	>a0,a0
	jrhi	sbfn4
	movi	->10000,a3
sbfn4	move	a3,*a8(oyvel),l
	move	@f_death,a0,w
	jrnn	sbfn2

	jauc	post_fanned

**************************************************************************
*											     *
*  Decapitated dude falling to knees !						     *
*											     *
**************************************************************************
r_hat_decap
	calla	death_blow_complete	; enough
	tsound	>44			; sword slice sound

cage_poped_fall
	calla	rsnd_death_voice

decap_fall
	calla	face_opponent

	move	a8,a11
	movi	>0a,a0
	calla	create_blood_proc

	create	pid_head,decapped_head
	move	a8,*a0(pa10),l

tongued_fall
	move	a8,a11
	movi	>0a,a0
	calla	create_blood_proc

	calla	change_to_bloody_pal

	movi	>3c,a9
	calla	get_char_ani
	calla	do_next_a9_frame

	sleep	>30			; stand there for a sec

	movk	6,a0
	jsrp	mframew			; fall to yo knees
	movi	>00050005,a11
	calla	shake_a11
	calla	me_in_front

	movk	10,a0
	jsrp	mframew			; wobble

	movk	6,a0
	jsrp	mframew
	movi	>00050005,a11
	calla	shake_a11
	jruc	local_wait_forever

decapped_head
	move	@ground_y,a0,w
	addk	9,a0
	move	a0,*a13(p_ganiy),w	; set ground level
	move	a8,a11

	movi	>3d,a9
	calla	get_char_ani		; head roll ani
	move	a9,b0
	move	*a9,a5,l
	calla	gso_dmawnz

	move	*a10(ochar),*a8(ochar),w	; same ochar
	calla	change_to_bloody_pal

	move	a8,a0
	move	a11,a1
	calla	lineup_1pwm		; lineup with dude

	clr	a0
	movi	>10,a1
	calla	multi_adjust_xy		; start position = at his neck
	movi	front_z+1,a0
	move	a0,*a8(ozval),l
	calla	insobja8

	movi	>20000,a0
	calla	randu
	addi	>18000,a0
	neg	a0
	calla	screen_half_a0
	move	a0,a11
	move	a11,*a8(oxvel),l

	move	b0,a9			; head roll ani

	movk	4,a0			; ani speed
	clr	a6			; routine every tick
	movi	>8000,a10		; grav
	movi	->60000,a1		; initial y
	jsrp	gravity_ani

	tsound	>1f			; hit ground !!
*
* head bounce
*
	sra	1,a11			; half x
	move	a11,*a8(oxvel),l
	movk	6,a0
	movi	->60000,a1
	clr	a6
	movi	>6000,a10
	jsrp	gravity_ani
	tsound	>1f			; hit ground !!

	move	a11,*a8(oxvel),l
	movk	6,a0
	movi	->40000,a1
	clr	a6
	movi	>6000,a10
	jsrp	gravity_ani
	tsound	>1f			; hit ground !!

	jauc	wait_forever

**************************************************************************
*											     *
*  dizzy_dude - guy who's got his shit kicked					     *
*											     *
**************************************************************************
dizzy_dude
	calla	disable_all_buttons
	calla	face_opponent

	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	dd4

	move	*a13(p_flags),a4,w
	ori	pm_sitduck,a4
	move	a4,*a13(p_flags),w 	; match over ---> i'm a sitting duk
	calla	set_no_block	    	; i can't block !!

dd4	calla	am_i_short    		; am i short ?
	jrnc	dd5			; no, skip

	calla	raiden_getup_pal
	movi	>00040012,a9
	jsrp	animate_a9
	calla	player_normpal

dd5	movi	act_stunned,a1
	move	a1,*a13(p_action),w	; define me action

	movi	3,a0	
	calla	init_anirate
	movi	>28,a9
	calla	get_char_ani

dd7	sleep	2
dizzy	calla	next_anirate
	move	@gstate,a0,w
	cmpi	gs_amode,a0
	jreq	dd7			; amode = in mtv mode = stay dizzy

	move	@winner_status,a0,w
	cmpi	3,a0			; stay dizzy only during "finish him"
	jreq	dd7
	move	@f_death,a0,w		; death blow started ?
	jrne	dd7			; yes, dont fall over

	movk	>0f,a9			; a9 = ani offset
	calla	get_char_ani

	movk	4,a0
	jsrp	mframew
	calla	shake_n_sound
	movk	4,a0
	jsrp	mframew

	jruc	local_wait_forever  	; stunned ani = loops forever

**************************************************************************
*											     *
*  corpse_fall_down - drone who is the first of a pair to get wasted	*
*                     comes here to die.						     *
*											     *
**************************************************************************
corpse_fall_down
	jauc	wait_forever


collapse_on_ground
	calla	am_i_a_boss
	jrc	boss_collapse

	movk	>0004000f,a9
	jsrp	animate_a9		; fall to ground
	movk	4,a0
	jsrp	mframew			; land on back
	movi	>00040004,a11
	calla	shake_a11		; shake upon hitting the ground
	movk	4,a0
	jsrp	mframew			; shake on ground

	calla	clear_shadow_bit
	jruc	local_wait_forever


boss_collapse
	movi	>00040009,a9
	jsrp	animate_a9		; fall to ground

	calla	shake_n_sound
	movk	4,a0
	jsrp	mframew			; land on back

	calla	clear_shadow_bit
	jruc	local_wait_forever

*******************************************************************

kahn_death
	move	a8,a11
	clr	a10
	create	pid_fx,smoke_a_guy		; start smokin !!
	movi	>11,a9
	calla	get_char_ani
	movi	>0004000a,a0
	jsrp	animate_a0_frames

	movi	>0d,a9
	calla	get_char_ani
	addi	32*3,a9
	calla	do_next_a9_frame

	movi	>0004000a,a0
	movk	2,a1
	move	a8,a10
	jsrp	shake_him_up
	movi	>00070f20,a0
	movk	2,a1
	move	a8,a10
	jsrp	shake_him_up
	jauc	wait_forever


*******************************************************************

	.end

