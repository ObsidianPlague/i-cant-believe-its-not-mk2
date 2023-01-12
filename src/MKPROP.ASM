**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: body propell moves									*
* 											     *
*  copyright (c) 1993 midway manufacturing							*
*											     *
**************************************************************************
	.file	'mkprop.asm'
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


do_body_propell
	cmpi	(propell_end-propell_table)/32,a0
	jrhi	local_reaction_exit			; out of range = abort
	sll	5,a0
	addi	propell_table,a0
	move	*a0,a0,l
	jump	a0


propell_table
	.long	do_scissor_kick		; 0 
	.long	do_fn2_teleport		; 1
	.long	do_fn2_kano		; 2
	.long	do_reptile_superk	; 3
	.long	do_decoy		; 4
	.long	do_slide		; 5
	.long	do_jc_shoruken		; 6	
	.long	do_bicycle		; 7
	.long	do_shadow_kick		; 8
	.long	do_super_kang		; 9
	.long	do_hh_teleport		; a
	.long	do_square_wave		; b
	.long	reaction_exit		; c
	.long	do_raiden_melt		; d
	.long	do_smoke_speed		; e
propell_end

**************************************************************************

do_smoke_speed
	calla	init_special
	movk	1,a0
	calla	init_anirate
	movk	1,a9
	calla	get_char_ani			; walk forwards ani
	movi	>a0000,a0
	calla	towards_x_vel			; zip over towards him
	movi	>50,a11
	jsrp	speedy_entry			; zipppppp.....
	calla	is_he_airborn
	jac	reaction_exit
	jauc	do_body_slam

**************************************************************************

do_scissor_kick
	movi	act_scissor,a1
	calla	init_special_act	; i can't block !!

	movi	act_scissor,a1
	move	a1,*a13(p_action),w

	movk	2,a9
	calla	get_char_ani2
	movk	3,a0
	jsrp	mframew

	movk	4,a11
scis3
	calla	is_he_a_boss
	jrc	scis4			; boss = cant be "clipped" hahahaha
     	movi	>19,a0
	calla	strike_check_a0		; hit ?
	jrc	scissor_hit

scis4	sleep	1
	dsj	a11,scis3

	movk	4,a0
	jsrp	mframew
	sleep	6

scis9	movi	>00040012,a9
	jsrp	animate_a9		; getup fast
	jruc	local_reaction_exit


scissor_hit
	move	b2,b2
	jrne	scissor_blocked

	move	a9,a6
	movi	>16,a9
	calla	get_his_char_ani
	move	a9,a11
	move	a6,a9

	movi	r_scissor,a7
	calla	takeover_him

;	move	*a10(oypos),a14,w
	calla	match_him_with_me_f	; line him up
;	move	a14,*a10(oypos),w

	calla	ground_him

	movi	->50,a0
	calla	adjust_him_x		; bacdafucup

	calla	double_next_a9
	sleep	5
	calla	double_next_a9
	sleep	5
	calla	double_next_a9
	sleep	5

	move	a11,a6
	calla	shake_n_sound
	move	a6,a11
	movi	28,a0
	calla	damage_to_him

	movk	3,a0
	jsrp	mframew_him
	movk	3,a0
	jsrp	mframew_him

	movi	post_scissor_hit,a7
	calla	takeover_him
	jruc	scis9


post_scissor_hit
	sleep	6
	jauc	getup_local_reaction_exit


scissor_blocked
	sleep	8
	movi	>19,a9
	calla	find_ani_part2		; duck kick hi ani
	movk	5,a0
	jsrp	mframew
	jauc	do_backup		; backup / retp


r_scissor
	movk	4,a7
	move	a7,@f_norepell,w	; no repell while in this mode
	sleep	2
	calla	get_his_action
	cmpi	act_scissor,a1
	jreq	r_scissor
	jruc	local_reaction_exit

;*************************************************************************

do_fn2_teleport
	movi	act_fntele,a1
	calla	init_special_act

	tsound	>88

	movi	>29,a9
	calla	get_char_ani		; borrow her victory animation
	addi	16*7,a9			; frame #2 is what we want
	calla	do_next_a9_frame	; pose: teleport down

	movi	>50000,a0
	move	a0,*a8(oyvel),l		; start headin' downwards

fntele3	sleep	1
	move	*a8(oypos),a0,w
	move	@worldtly+16,a1,w
	addi	scrbot->20,a1
	cmp	a1,a0			; time to teleport ?
	jrhi	fntele5			; yes

	move	*a8(oyvel),a0,l
	addi	>a000,a0
	move	a0,*a8(oyvel),l		; artificial gravity
	jruc	fntele3
	

fntele5
;**********************
;	movk	1,a0
;	move	a0,@f_novel,w
;	sleep	>30
;	clr	a0
;	move	a0,@f_novel,w
;**********************

	calla	match_me_with_him
	calla	flip_multi
	movi	->70,a0
	clr	a1
	calla	multi_adjust_xy		; line me up to hit him !!
	move	@worldtly+16,a1,w
	subi	>20,a1
	move	a1,*a8(oypos),w		; to the top

	movi	>30000,a0
	calla	towards_x_vel

;**********************
;	movk	1,a0
;	move	a0,@f_novel,w
;	sleep	>30
;	clr	a0
;	move	a0,@f_novel,w
;**********************

	movi	>1e,a9			; flip punch ani
	movi	dont_touch,a0
	movi	>30000,a1
	movi	>6000,a2
	movk	3,a3
	movi	fn2_teleport_call,a6
	jsrp	flight_call

	movi	>00030005,a9
	jsrp	animate_a9		; land ani = duck ani
	sleep	8
	retp


fn2_teleport_call
	movi	>14,a0
	calla	strike_check_a0
	jrc	fn2_tele_hit
	rets

fn2_tele_hit
	pull	a0
	pull	a0
	calla	reset_proc_stack

	movi	act_fntele_sd,a0
	move	a0,*a13(p_action),w

	movi	>6000,a2
	move	b2,b2			; blocked ?
	jrne	fn2tele3
	movi	>a000,a2		; hit = greater gravity
fn2tele3	movi	>1e,a9
	calla	find_ani_part2
	calla	find_part2		; ani: post teleport kick

	movi	>20000,a0
	movi	->50000,a1
;	movi	>6000,a2
	movk	8,a3
	jsrp	flight			; bounce away from opponent
	jsrp	do_land_animation
	jruc	local_reaction_exit

;************************************************************************


do_fn2_kano
	movi	act_kano,a1
	calla	init_special_act
	tsound	>bd

	movk	5,a9
	calla	do_first_a9_frame
	sleep	3

	movk	7,a9
	calla	get_char_ani
	addi	32,a9			; skip unball frame

	clr	a0
	movi	>38,a1
	calla	multi_adjust_xy		; at ground level

	movk	2,a0
	calla	init_anirate
	movk	5,a11			; frames sans collision scanning
	movi	>18,a10			; how long I should fly
	movi	>a0000,a0
	calla	towards_x_vel

kano3	calla	next_anirate
	movi	>16,a0
	calla	strike_check_a0
	jrc	kano_hit
	sleep	1
	dsj	a11,kano3
	movk	1,a11			; from here on out, check collisions
	dsj	a10,kano3
	jruc	post_kano



kano_hit
	move	b2,b2			; blocked ?
	jrne	kano_blocked		; yup...

	movi	>10,a10			; travel this far after a hit
khit4	calla	next_anirate
	sleep	1
	dsj	a10,khit4

post_kano
	calla	stop_me
	calla	ground_player
	calla	face_opponent

	movi	l_kano,a0
	calla	update_tsl

	jauc	do_backup

kano_blocked
	movi	act_kano_sd,a0
	move	a0,*a13(p_action),w

	movk	7,a9
	calla	get_char_ani
	addi	32,a9			; rolled in a ball ani

	movi	->a0000,a0
	move	a0,*a8(oyvel),l
	movi	>6000,a2
	move	a2,*a8(ograv),l
	movk	2,a0
	calla	init_anirate
	movi	>a000,a0
	calla	away_x_vel

kblk4	sleep	1
	calla	next_anirate
	move	*a8(oypos),a0,w
	move	*a13(p_ganiy),a1,w
	cmp	a1,a0			; above ground level yet ?
	jrhi	kblk4			; no

	movi	dont_touch,a0
	move	a0,a1
	move	a0,a2
	movk	2,a3
	jsrp	flight
	jsrp	do_land_animation
	jruc	local_reaction_exit

;************************************************************************

do_reptile_superk
	calla	air_init_special

	tsound	>bd
	calla	rsnd_attack

	movi	act_reptile_fly,a1
	move	a1,*a13(p_action),w

	movi	>1e,a9
	movi	->80000,a0
	movi	>30000,a1
	movi	>4000,a2

	movk	2,a3
	movi	super_reptile_scan,a6
	jsrp	flight_call

	jsrp	do_land_animation
	jruc	local_reaction_exit	

super_reptile_scan
	move	*a9,a0,l		; leg extended ?
	jrne	srs4			; no
	movi	>12,a0			; stk table offset
	calla	get_char_stk
	calla	strike_check
	jrc	super_rep_hit
srs4	rets


super_rep_hit
	pull	a0
	pull	a0
	calla	reset_proc_stack
	calla	stop_me			; freeze in the air

	move	b2,b2
	jrne	super_rep_blocked
	sleep	6
	clr	a0
	clr	a1
	movi	>8000,a2
	movi	never_ani,a3
	jruc	decoy5

super_rep_blocked
	movi	act_hh_sd,a0
	move	a0,*a13(p_action),w
	movk	>08,a9
	calla	get_char_ani
	addi	32,a9			; rolled in a ball ani
	movi	>4000,a0
	movi	->70000,a1
	movi	>6000,a2
	movk	3,a3
	jsrp	flight
	jsrp	do_land_animation
	jruc	local_reaction_exit

;************************************************************************

do_decoy
	calla	air_init_special

	tsound	>86				; scorpion teleport sound

	movi	act_decoy,a1
	move	a1,*a13(p_action),w

	clr	a9
	calla	am_i_airborn
	jrnc	dec1
	movi	>1f,a9				; flip punch
dec1	push	a9

	move	a8,a11
	clr	a9
	calla	get_char_ani			; a9 = frame with all the info
	calla	do_next_a9_frame
	subi	32,a9
	calla	gmo_proc
	move	a0,a10
	move	*a11(ochar),*a8(ochar),w	; mi ochar es su ochar

	pull	a9
	calla	do_first_a9_frame		; pose: stance frame #1
	calla	insobja8

	create	pid_decoy,decoy_proc		; process to animate decoy
	move	a8,*a0(pa8),l			; pass object to process
	move	a13,*a0(pa10),l			; pass scorpion proc 

	move	a8,a0
	move	a11,a8
	calla	match_ani_points		; lineup with scorpion

*
* now take off !!
*
	movi	act_decoy,a0
	move	a0,*a13(p_action),w	; define my action

	movi	pid_scroll,a0
	calla	exprc_er		; a0 = scroll proc
	move	a13,*a0(pa10),l		; pass me !!
	movi	decoy_scroll,a7
	calla	fastxfer
	movi	l_decoy,a0
	calla	update_tsl		; limit this shit

	calla	flip_multi		; face the other way
	movi	>1f,a9
	movi	>80000,a0
	movi	->30000,a1
	movi	>5000,a2
	movk	4,a3
	movi	crossover_scan,a6
	jsrp	flight_call

	jsrp	do_land_animation
	jruc	local_reaction_exit	


decoy_proc
	movk	6,a11
dec3	sleep	2
	callr	is_he_decoying
	jrne	pdec9			; no more decoy ---> exit
	dsj	a11,dec3
*
* flash 'em
*
	movk	4,a11
dec4	jsrp	decoy_alternate
	callr	is_he_decoying
	jrne	pdec9			; no more decoy ---> exit
	jsrp	decoy_alternate
	callr	is_he_decoying
	jrne	pdec9			; no more decoy ---> exit
	dsj	a11,dec4
pdec9	
	move	a8,a0
	calla	delobjp
	die



decoy_alternate
	move	*a8(oflags2),a4,w
	xori	m_inviso,a4
	move	a4,*a8(oflags2),w	; alternate it
	sleep	3
	retp

crossover_scan
	movi	>16,a0			; stk table offset
	calla	get_char_stk
	calla	strike_check
	jrc	decoy_hit

	movi	-scrrgt,a7
	move	*a8(oxpos),a3,w
	move	*a8(oflags),a4,w
	btst	b_fliph,a4
	jrne	cos4			; moving left

	move	@worldtlx+16,a1,w
	addi	scrrgt,a1		; a1 = right edge
	sub	a3,a1
	jrn	cross_warp
	cmpi	3,a1
	jrle	cross_warp		; close or passed edge = cross over

	cmpi	>35,a1
	jrhi	cos9
	movk	3,a7
	move	a7,@f_norepell,w	; close to edge ---> sans repell
	jruc	cos9

cos4	move	@worldtlx+16,a1,w
	sub	a1,a3
	jrn	cross_warp
	cmpi	3,a3
	jrle	cross_warp		; close or passed edge = cross over

	cmpi	>35,a3
	jrhi	cos9
	movk	3,a7
	move	a7,@f_norepell,w	; close to edge ---> sans repell

cos9	rets


cross_warp
	movk	1,a11			; flag: crossed over !
	clr	a1
	move	a7,a0
	jauc	multi_adjust_xy


decoy_hit
	pull	a0
	pull	a0
	calla	reset_proc_stack
	calla	stop_me			; freeze in the air

	move	b2,b2
	jrne	decoy_blocked

	movi	>1f,a9
	calla	get_char_ani
	calla	find_last_frame
	calla	do_next_a9_frame	; end up extended on hit

	sleep	6
	clr	a0
	clr	a1
	movi	>8000,a2
	movi	never_ani,a3
	jruc	decoy5

decoy_blocked
	movi	act_decoy_sd,a0
	move	a0,*a13(p_action),w
	movk	>08,a9
	calla	get_char_ani
	addi	32,a9			; rolled in a ball ani
	movi	>8000,a0
	movi	->70000,a1
	movi	>6000,a2
	movk	3,a3

decoy5	jsrp	flight
	jsrp	do_land_animation
	jruc	local_reaction_exit


decoy_adjust
	clr	a0
	calla	multi_adjust_xy
	sleep	3
	retp


decoy_scroll
	calla	stop_scrolling
	clr	a0
	move	a0,@scrolly,l
decsc4	sleep	1
	callr	is_he_decoying
	jreq	decsc4			; yes
	jauc	scroller		; no, normal scrolling

is_he_decoying
	move	*a10(p_action),a0,w
	cmpi	act_decoy,a0
	rets

;************************************************************************

do_slide
	movi	act_slide,a1
	calla	init_special_act

	movi	>80000,a0
	calla	towards_x_vel		; head towards opponent

	clr	a9
	calla	get_char_ani2
	movk	4,a0
	calla	init_anirate
	tsound	>5d			; slide sound
*
* first part of slide = no collision check
*
	movk	8,a10
slide2	sleep	1
	calla	next_anirate
	dsj	a10,slide2

	movi	>14,a10
slide4	sleep	1
	calla	next_anirate

	movi	>12,a0
	calla	get_char_stk
	calla	strike_check
	jrc	slide_hit

	dsj	a10,slide4
	jruc	slide_blocked


slide_hit
	move	b2,b2
	jrne	slide_blocked

	clr	a9
	calla	get_char_ani2
	addi	32+32,a9
	calla	do_next_a9_frame	; assure we are on frame #3

	move	*a8(oxvel),a0,l
	sra	1,a0	       
	move	a0,*a8(oxvel),l		; 1/2 speed
	sleep	3
	calla	stop_me
	jsrp	wait_for_landing	; stall till he lands !!
	jruc	slide_is_over

slide_blocked
	calla	stop_me
	move	*a8(oflags2),a4,w
	andni	m_noflip,a4		; i can be flipped !
	ori	m_noblock,a4		; i can't block
	move	a4,*a8(oflags2),w

	movi	act_slide_sd,a0
	move	a0,*a13(p_action),w	; i am a sitting duck !
	sleep	>16			; sitting duck time !

slide_is_over
	clr	a9
	calla	get_char_ani2
	addi	32,a9
	calla	do_next_a9_frame	; frame 2
	sleep	4

	clr	a9
	calla	get_char_ani2
	calla	do_next_a9_frame	; frame 1
	sleep	4
 
	movi	l_slide,a0
	calla	update_tsl
	jruc	local_reaction_exit

;************************************************************************

do_jc_shoruken
	calla	init_special			; initialize for special move
	tsound	>6b

	movi	act_shoruken,a0
	move	a0,*a13(p_action),w		; define what i am doing

	movi	>00040001,a9
	jsrp	animate2_a9			; wind up

	movi	->c0000,a1			; initial y
	move	a1,*a8(oyvel),l
	movi	>b000,a2			; a2 = gravity	
	move	a2,*a8(ograv),l			; send him movin'

	movi	->a0000,a0
	calla	away_x_vel

	movi	>8000,a10
	move	a0,a0
	jrn	shor3
	neg	a10
shor3	clr	a0
	move	a0,*a13(p_store1),w		; flag: no contact !

;	dsound	>22
	create	pid_trail,trail_proc
	clr	a1
	move	a1,*a0(p_store3),l		; green shadow only
*
* accelerate upwards
*
shor4	sleep	1

	movk	3,a0
	move	a0,@f_norepell,w		; no repell during this

	move	*a13(p_store1),a0,w		; contact ?
	jrne	shor7				; yes, don't try again

	calla	get_his_action
	cmpi	act_duck,a1
	jreq	shor7				; leave ducking dudes alone

	movk	>12,a0
	calla	strike_check_a0			; contact ?
	jrnc	shor7				; no

	movk	1,a0
	move	a0,*a13(p_store1),w		; yes, flag: contact !

	move	b2,b2
	jrne	shor7				; blocked

	move	*a8(oxvel),a0,l
	move	*a8(oyvel),a1,l
	move	*a8(ograv),a2,l			; grab vital shit
	mmtm	a12,a0,a1,a2			; save vitals
	calla	stop_me
	movk	1,a0
	calla	away_x_vel	 		; trick trail proc !!

;************
	movk	8,a0
	move	a0,@f_norepell,w		; no repell during this
;************

	sleep	6
	mmfm	a12,a0,a1,a2			; pull vitals
	move	a1,*a8(oyvel),l
	move	a2,*a8(ograv),l
	neg	a0
	calla	away_x_vel			; retore vitals
	
shor7	move	*a8(ograv),a0,l
	subi	>2000,a0
	move	a0,*a8(ograv),l	    		; accelerate upwards

	move	*a8(oypos),a0,w
	subi	>10,a0
	jrp	shor4
*
* slow down at peak of arc
*
	movi	act_shoruken_sd,a0
	move	a0,*a13(p_action),w

	movi	>18000,a0
	move	a0,*a8(ograv),l
shor5	move	*a8(oyvel),a0,l
	jrnn	shor6
	move	*a8(oxvel),a0,l
	neg	a0
	sra	1,a0
	calla	away_x_vel

;************
	movk	3,a0
	move	a0,@f_norepell,w		; no repell during this
;************


	sleep	1
	jruc	shor5
*
* drop down to earth
*
shor6	calla	stop_me
	sleep	12

	movi	>00030001,a9
	calla	pose2_a9
	movi	>5000,a2		; a2 = gravity	
	jsrp	drop_straight_down

	jsrp	do_land_animation
	retp

;************************************************************************

do_bicycle
	calla	init_special

	movi	act_bike,a1
	calla	init_special_act	; initialize for special move

	tsound	>10			; bike kick yell !!

	movi	->90000,a0
	calla	away_x_vel
	move	a0,a11			; save x vel

	movi	>00010006,a9		; ani 2
	movi	->90000,a0
	movi	->38000,a1
	movi	>3000,a2
	movk	4,a3
	movi	bike_call,a6
	movk	6,a11			; ticks sans collision checks
	jsrp	flight_call
	retp

bike_call
	move	a11,a11
	jreq	bcall3
	dec	a11
	jruc	bcall9

bcall3	movi	>15,a0
	calla	strike_check_a0
	jrnc	bcall9

	pull	a0			; pull return
	pull	a0			; pull a10
	pullp	a0
	calla	stop_me

	move	b2,b2			; blocked bike kick ?
	jrne	bike_sitting_duck

	move	*a13(p_otherguy),a0,l
	calla	clear_inviso

	movi	biked_suspend,a7
	calla	takeover_him

	calla	is_he_facing_me		; he facing me ?
	jrc	bike0
	push	a8
	move	*a13(p_otherguy),a8,l
	calla	flip_multi	    	; no,flip him !
	pull	a8

bike0	calla	is_he_airborn
	jrnc	bike1			; hit on ground
*
* hit in air
*
	calla	get_x_dist
	cmpi	>30,a3			; too close ?
	jrhi	bike3			; no

	move	*a10(oypos),a7,w
	calla	match_him_with_me_f
	move	a7,*a10(oypos),w
	jruc	bike2

bike1	calla	match_him_with_me_f
	calla	ground_him
bike2	movi	->38,a0
	calla	adjust_him_x		; line him up at my feet !!

bike3	push	a8
	move	*a13(p_otherguy),a8,l

	movi	>37,a9
	calla	if_not_boss_branch
	.long	bike8
	movi	>11,a9
bike8	pull	a8

	calla	get_his_char_ani	; him = hit by bike kick
	move	a9,a11

	movi	->50000,a0
	calla	away_x_vel
	movi	>50000,a0
 	calla	away_x_vel_him		; move at same speed
	sleep	1			; let velocities take place
*
* punching bag animation loop
*
	move	*a13(p_otherguy),a10,l
	movk	6,a9
	calla	get_char_ani2		; me = bike kick ani
	movk	3,a0
	calla	init_anirate

	movk	8,a0
	move	a0,*a13(p_store2),w

	movi	48,a0
bike4	move	a0,*a13(p_store1),w
	calla	next_anirate

	move	*a13(p_store2),a0,w
	dec	a0
	jrne	bike7
	calla	rsnd_smack
	movk	8,a0
bike7	move	a0,*a13(p_store2),w

	move	*a13(p_anicount),a0,w
	cmpi	3,a0	     		; did we just animate ?
	jrne	bike6	     		; no

   	push	a11
	movi	>00030003,a11
	calla	shake_a11    		; skake a bit
	pull	a11
	push	a9
	move	a11,a9
	calla	do_his_next_a9_frame	; animate him
	move	a9,a11
	pull	a9

bike6 	move	*a13(p_otherguy),a0,l
	move	*a0(oxvel),a0,l		; he still moving ?
	jrne	bike5			; yes
	calla	get_x_dist		; a3 = x distance
	cmpi	>30,a3
	jrhi	bike5
	calla	stop_me

bike5	sleep	1
	move	*a13(p_store1),a0,w
	dsj	a0,bike4
*
* done = fall to ground
*
	movi	r_bike_kicked_done,a7
	calla	takeover_him
	clr	a0
	clr	a1
	movi	>4000,a2
	movk	4,a3
	jsrp	flight
	jruc	local_reaction_exit

bcall9	rets


bike_sitting_duck
	movi	>00010006,a9		; ani 2
	movi	>10000,a0
	movi	->50000,a1
	movi	>4000,a2
	movk	4,a3
	jsrp	flight
	jsrp	do_land_animation
	jruc	local_reaction_exit


biked_suspend
	movi	act_bike,a0
	move	a0,*a13(p_hitby),w
	jauc	suspend_wait

;************************************************************************


do_shadow_kick
	calla	init_special	 	; initialize for special move

	movi	act_shadk,a0
	move	a0,*a13(p_action),w	; define what i am doing

	movi	>04,a9	
	calla	get_char_ani2	   	; a9 = ani table

	movi	>43,a5			; normal shadow kick sound
	movi	->60000,a0
	calla	away_x_vel
	create	pid_trail,trail_proc
	move	a0,a6
	clr	a7			; no red shadow !!
	movi	10,a0
	calla	randper
	jrnc	skick3
	movi	>c7,a5			; red shadow kick sound
	movk	1,a7
skick3	move	a7,*a6(p_store3),l	; flag: red shadow please
	move	a5,a0
	calla	triple_sound

	movk	2,a0
	calla	init_anirate

	movk	20,a11
skick4	calla	next_anirate

	cmpi	13,a11
	jrhi	skick5				; 1st 5 frame ---> no collisions
	movi	>11,a0
	calla	strike_check_a0
	jrc	shadow_kick_hit

skick5	sleep	1
	dsj	a11,skick4

	clr	a0
	move	a0,*a13(p_action),w		; un-define what i am doing
	calla	stop_me

	movi	act_shadow_sd,a0
	move	a0,*a13(p_action),w		; action: shadow kick sitting duck
	sleep	12
	jruc	skick8

shadow_kick_hit
	movi	>04,a9	
	calla	get_char_ani2			; a9 = ani table
	calla	find_last_frame
	calla	stop_me

	movi	act_shadow_sd,a0
	move	a0,*a13(p_action),w	; action: shadow kick sitting duck
	calla	do_next_a9_frame

	sleep	20

skick8	movi	>04,a9	
	calla	get_char_ani2
	calla	find_part2
	movk	3,a0
	jsrp	mframew			; un kick
	retp

;************************************************************************

do_super_kang
	calla	init_special

	tsound	>83			; whoosh
	movi	>000f0011,a1
	calla	randsnd			; super kick yell

	movi	act_superkang,a0
	move	a0,*a13(p_action),w	; signal: this is what i am doing
	calla	init_special

	movi	>a0000,a0
	calla	towards_x_vel		; head towards opponent

	calla	get_x_dist		; a3 = x distance tween dudes
	subk	10,a3			; nudge factor
	jrp	supfly3
       	movk	1,a3			; no negative shit to fuck us over !!
supfly3	sll	16,a3
	movk	10,a1
	divs	a1,a3			; a3 = distance/speed = time
	srl	16,a3
	jrp	supfly1
	movk	1,a3			; no negative shit to fuck us over !!
supfly1	move	a3,a11

	movi	>200000,a1		; a1 = distance we want to travel up !
	divs	a3,a1			; a1 = height/time = y speed

	cmpi	>40000,a1
	jrls	supfly9
	movi	>40000,a1		; dont spaz out !!
supfly9	neg	a1
	move	a1,*a8(oyvel),l

	movi	>1e,a9			; animation table offset
	calla	get_char_ani
	movk	1,a0
	calla	init_anirate
*
* fly
*
	movk	8,a10
supfly5	sleep	1
	dec	a10
	jrne	supfly6
	movk	1,a10			; from now on ---> do collision check

	movi	>14,a0
	calla	strike_check_a0		; collision ?
	jrc	supfly7
supfly6	calla	next_anirate		; haya !!
	dsjs	a11,supfly5
*
* collision = no
*
	movi	>a000,a2
	move	a2,*a8(ograv),l
	clr	a6
	move	a6,*a13(p_store4),l	; routine to call 
	jsrp	flight_loop

	movi	>1e,a9
	calla	find_ani_part2
    	movk	3,a0
	jsrp	mframew	    		; landing animation / return
	jruc	super_exit
*
* collision = yes
*
supfly7	movi	act_postattack,a0
	move	a0,*a13(p_action),w	; flag: i am done with my attack
	move	b2,b2			; blocked ?
	jrne	supfly8			; yeah

	jsrp	super_kick_land
	jruc	super_exit
*
* superkick blocked
*
supfly8	jsrp	super_kick_land
	clr	a9
	calla	get_char_ani
	calla	do_next_a9_frame
	calla	set_no_block	; be victim to attacks !!
	sleep	10		; for this long

super_exit
	jruc	local_reaction_exit


super_kick_land
	movi	act_superk_sd,a1
	move	a1,*a13(p_action),w	; tell da drones

	calla	stop_me
	sleep	20

	clr	a1
	move	a1,*a8(oyvel),l		; send 'em skywards
	movi	>a000,a2
	move	a2,*a8(ograv),l
	clr	a6
	move	a6,*a13(p_store4),l	; routine to call 
	jsrp	flight_loop

	movi	>1e,a9
	calla	find_ani_part2
    	movk	3,a0
	jsrp	mframew	    	; landing animation / return
	retp

;************************************************************************

do_hh_teleport
	calla	init_special

	movi	act_hh_teleport,a1
	calla	init_special_act		; i can't block !!

	tsound	>87				; hathead teleport sound

	movk	6,a9
	calla	do_first_a9_frame		; flying frame

	movi	->80000,a0
	move	a0,*a8(oyvel),l
	movi	->10000,a0
	move	a0,*a8(ograv),l			; negative gravity

hht4	sleep	1
	move	*a8(oypos),a0,w
	cmpi	->95,a0
	jrgt	hht4				; zip off the top of the screen

	callr	teleport_next_to
	calla	face_opponent

	movi	>90,a0
	move	a0,*a8(oypos),w

	movi	>8000,a0
	move	a0,*a8(ograv),l
	movi	->a0000,a0
	move	a0,*a8(oyvel),l

hht6	sleep	1
	move	*a8(oypos),a0,w
	move	*a13(p_ganiy),a1,w
	cmp	a1,a0
	jrhi	hht6

	calla	am_i_joy
	jrnc	hht8
	movi	bt_jump,b0
	calla	stuff_buttons		; joy = let him punch / kick

hht8	clr	a0
	move	*a8(oyvel),a1,l
	move	*a8(ograv),a2,l
	movi	never_ani,a3
	jsrp	flight
	retp

;************************************************************************

do_square_wave
	calla	init_special

	movi	act_square,a1
	move	a1,*a13(p_action),w
	tsound	>87			; borrow hathead sound for now

	movi	>06,a9
	calla	get_char_ani		; straight up ani
	calla	do_next_a9_frame
	movi	->c0000,a0
	move	a0,*a8(oyvel),l		; head straight up !!

lfly5	sleep	1
	move	*a8(oypos),a2,w
	move	@ground_y,a0,w
	sub	a0,a2
	abs	a2
	cmpi	>e0,a2
	jrlo	lfly5
*	
* now horizontal punch
*
	tsound	>0d			; attack voice

	clr	a0
	move	a0,*a8(oyvel),l

	movk	5,a9
	calla	get_char_ani2
	movk	3,a0
	calla	init_anirate

	movi	>a0000,a0
	calla	towards_x_vel		; head towards opponent

	calla	face_opponent

	movi	>1a,a11
lfly4	sleep	1
	calla	next_anirate
	movi	>15,a0
	calla	get_char_stk
	calla	strike_check		; look for collision
	jrc	square_hit		; pow
	dsjs	a11,lfly4

	movi	>06,a9
	calla	get_char_ani
	calla	do_next_a9_frame

	calla	stop_me
	calla	face_opponent

	clr	a0
	movi	>20000,a1		; initial y vel
	movi	>10000,a2		; grav
	movi	never_ani,a3 		; ani speed
	movi	dont_touch,a9
	jsrp	flight
	jruc	local_reaction_exit


square_hit
	callr	clear_special_flag

	calla	stop_me
	movi	>1f,a9
	calla	get_char_ani
	calla	find_last_frame
	calla	do_next_a9_frame	; pause on "strike" frame
	sleep	>0e

	movi	>20000,a0
	calla	away_x_vel		; head towards opponent

	movi	>06,a9
	calla	get_char_ani		; straight up ani
	calla	do_next_a9_frame

	clr	a0
	movi	>8000,a1
	movk	4,a3
	movi	>8000,a2
	jsrp	flight			; fall 2 earth

	jsrp	do_land_animation
	jruc	local_reaction_exit


clear_special_flag
	move	*a13(p_flags),a4,w
	andni	pm_special,a4
	move	a4,*a13(p_flags),w	; flag: i am not doing a special move
	rets

;************************************************************************

do_raiden_dive
	calla	air_init_special
	calla	set_noflip

	movi	act_dive,a1
	move	a1,*a13(p_action),w

	movi	>00030079,a0		; [total # of entries, 1st entry]
	calla	random_triple		; random raiden yell

	movi	>a0000,a0
	calla	towards_x_vel     	; fire !!!
	move	a0,a10			; a10 = vel im gonna go
	move	a1,a11			; a11 = my p?_vel
	calla	stop_me			; but dont just yet

	clr	a9
	calla	get_char_ani2

	movk	3,a0
	jsrp	mframew			; wind up
	move	a10,*a11,l		; now start my velocity !!
	movk	3,a0
	jsrp	mframew			; wind up

	movi	>1a,a11
dive3	sleep	1
	movi	>14,a0
	move	a0,*a13(p_stk),w
	calla	get_char_stk
	calla	strike_check

	jrc	dive_hit
	dsjs	a11,dive3

	calla	stop_me
	calla	am_i_airborn
	jrnc	local_reaction_exit		; on ground ---> normal exit
*
* fall to the ground
*
	calla	face_opponent
	movk	6,a9
	calla	get_char_ani
	addi	32,a9
	calla	do_next_a9_frame	; pose: land
	clr	a0			; initial x vel
  	movi	>10000,a1		; initial y vel
	movi	>8000,a2		; grav
	movi	never_ani,a3		; animation speed
 	jsrp	flight
	jruc	local_reaction_exit


dive_hit

;****************
	move	*a13(p_otherguy),a0,l
	calla	clear_inviso		; in case he was invisible
;****************

	move	b2,b2			; blocked ??
	jrne	dive_blocked		; yes ---> skip the drag part

	tsound	>5f			; dive/drag sound

	push	a10			; save my velocity
	calla	takeover_him

	push	a8
	move	*a13(p_otherguy),a8,l
	movi	>0009000f,a9
	calla	boss_pick_ani		; pose him: knocked down ani
	pull	a8

	calla	get_his_char_ani
	movi	ochar_dived_poses,a0
	calla	get_his_char_word		; a0 = his offset
	sll	5,a0
	add	a0,a9
	calla	do_his_next_a9_frame		; him --> dived into pose

	calla	match_him_with_me_f
	movi	ochar_dived_adjust,a0
	calla	get_his_char_long
	move	a0,a1
	srl	16,a1				; a1 = adjust y
	zext	a0,w				; a0 = adjust x
	calla	adjust_him_xy			; line him up with my hands !!

	move	*a13(p_otherguy),a10,l
	movi	p1_xvel,a0
	movi	p2_xvel,a1
	move	@p1_obj,a2,l
	cmp	a2,a8
	jreq	dhit4
	swap	a0,a1		 	; a0 = my vel !!

dhit4	pull	a6			; grab my initial velocity
	move	a6,*a0,l
	move	a6,*a1,l	 	; both travel together
	move	*a13(p_otherguy),a0,l
	move	a6,*a0(oxvel),l		; set also by hand !
	move	a6,*a8(oxvel),l		; set also by hand !

	movi	>20,a11

dhit6	movk	2,a0
	move	a0,@f_norepell,w	; no repell while I am doing this !!
	sleep	1

raiden_dragging
	move	@p1_xvel,a0,l
	jreq	dhit7
	move	@p2_xvel,a0,l
	jreq	dhit7
	move	*a8(oxvel),a0,l
	jreq	dhit7
	move	*a10(oxvel),a0,l
	jreq	dhit7
	dsjs	a11,dhit6

dhit7	movi	>00060006,a11
	calla	shake_a11    		; skake a bit

	tsound	>f4 			; hit sound, finally !!
	movi	r_post_dived,a7
	calla	xfer_otherguy

dive_blocked
	movi	act_dive_sd,a0	
	move	a0,*a13(p_action),w	; flag: i am a sitting duck !!

	movk	>07,a9
	calla	get_char_ani
	addi	32,a9			; a9 = cannon ball ani

	movi	>40000,a0
	movi	->80000,a1
	movi	>6000,a2
	movk	3,a3
	jsrp	flight
	jruc	local_reaction_exit


ochar_dived_adjust
	.word	->40,>00	; hathead
	.word	->4a,>08	; kang
	.word	->48,>00	; cage
	.word	->48,>00	; sword arms

	.word	->48,>00	; knockout
	.word	->48,>00	; bombshell
	.word	->48,>00	; shang tsung
	.word	->48,>00	; raiden

	.word	->48,>00	; sub-zero
	.word	->48,>00	; reptile
	.word	->48,>00	; scorpion
	.word	->50,>00   	; jax
	.word	->60,>00  	; kintaro
	.word	->48,->14      	; shao kahn

	.word	->48,>00	;
	.word	->48,>00	;
	.word	->48,>00	;

ochar_dived_poses
	.word	>01	; hathead = frame 2
	.word	>01	; kang = frame 2
	.word	>00	; cage = frame 1
	.word	>00	; sword arms = frame 1
	.word	>01	; knockout = frame 1
	.word	>01	; bombshell = frame 1
	.word	>01	; shang tsung = frame 2
	.word	>00	; raiden = frame 1
	.word	>00
	.word	>00
	.word	>00
	.word	>00

	.word	>00
	.word	>00

	.word	>00
	.word	>00
	.word	>01

;********************************************************************

do_raiden_melt
	calla	init_special			; i can't block !!

	movi	act_melt,a0
	move	a0,*a13(p_action),w		; action: melt !

	movi	l_warp,a0
	calla	update_tsl			; update "last time" ram
	tsound	>5b				; transport sound
	move	a8,a11
*
* create a decoy to melt
*
	movi	>12,a9
	calla	get_char_ani			; a9 = frame with all the info
	calla	gmo_proc
	push	a0				; save dummy proc
	movi	ft_raiden,a0
	move	a0,*a8(ochar),w			; decoy ochar = raiden
	movk	1,a9
	calla	pose2_a9			; pose decoy ---> 1st melt frame
	calla	insobja8
	create	pid_melt,melt_decoy		; process to animate decoy
	pull	a1				; a1 = dummy proc
	move	a1,*a0(pa11),l			; pass in a11 to decoy animator

	move	a8,a0				; adjust decoy
	move	a11,a8				; match with raiden
	calla	match_ani_points		; lineup with dude we are following
*
* put me next to other guy
*
	callr	teleport_next_to
	calla	ground_player			; keep same grounded "ani y"
	calla	face_opponent

	calla	raiden_getup_pal		; switch to morph pal
	movi	>17,a9
	calla	get_char_ani
	movk	2,a0
	jsrp	mframew				; morph up fast !!
	calla	player_normpal

	clr	a9
	calla	get_char_ani			; stance ani
	calla	do_next_a9_frame		; pose quickly !
		 	
	calla	back_to_normal			; allow special moves
	sleep	8
	retp


teleport_next_to
	movi	>54,a9				; positive = in front
	move	*a13(p_otherguy),a0,l
	move	*a0(oxpos),a3,w			; a3 = his x
	move	@right_edge,a1,w
	addi	scrrgt,a1			; a1 = right side of universe
	sub	a3,a1
	abs	a1
	cmpi	>80,a1
	jrls	tnt4				; he's too close to right edge
	move	@left_edge,a1,w
	sub	a3,a1
	abs	a1
	cmpi	>80,a1
	jrls	tnt4				; he's too close to left edge
	neg	a9				; melt up behind the other player !!
tnt4	calla	match_me_with_him
	clr	a1
	move	a9,a0
	jauc	multi_adjust_xy			; shift next to opponent



melt_decoy
	movi	>00020001,a9			; sleep time / offset
	jsrp	animate2_a9
	move	a8,a0
	calla	delobjp

kill_a11_and_me
	move	a11,a0
	move	*a0(pwake),a1,l
	cmpi	multi_dummy_wake,a1		; still a dummy ?
	jrne	meltd3				; no
	calla	kill				; yes, kill it
meltd3	die


**************************************************************************
*											     *
*  drop_straight_down - Drop straight down to the ground			     *
* 											     *
*  Input: a2 = gravity									     *
*											     *
**************************************************************************
drop_straight_down
	clr	a0	 		; a0 = initial x vel
	clr	a1	  		; a1 = initial y vel
	movi	never_ani,a3 		; a3 = ani speed
	jauc	flight

;************************************************************************
;************************************************************************

local_reaction_exit
	jauc	reaction_exit

	.end

