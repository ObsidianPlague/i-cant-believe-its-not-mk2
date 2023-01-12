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
	.include	mainequ.asm
	.include	imgtbl.glo
	.text


do_body_slam
	calla	init_special   		; this is considered a special move
	callr	body_slam_init

	movi	body_slam_jumps,a0
	jauc	ochar_jump

body_slam_init
	move	*a13(p_otherguy),a0,l
	calla	clear_inviso		; in case he was invisible
	calla	delete_slave

	movi	>30,a0
	move	a0,@f_norepell,w 	; disable repell !!

	move	*a8(ochar),a9,w
	cmpi	ft_noob,a9
	jreq	bsi1
	cmpi	ft_smoke,a9
	jrne	bsi2
bsi1	movi	ft_scorpion,a9		; smoke = borrow from scorpion
	jruc	bsi3
bsi2	cmpi	ft_jade,a9
	jrne	bsi3
	movi	ft_fn1,a9

bsi3	addi	>2a,a9			; add "flipped by me" offset
	calla	get_his_char_ani
	move	a9,a11	    		; a11 = flipped by me ani
	move	*a13(p_otherguy),a10,l
	movi	>24,a9
	calla	get_char_ani		; a9 = me flipping someone

	movi	flipped_pause,a7
	calla	takeover_him_sr

	movi	act_bodyslam,a0
	move	a0,*a13(p_action),w		; define my action
	move	*a13(p_otherproc),a1,l
	move	a0,*a1(pa11),l			; pass my action for him to look 4
	rets

;************************************************************************

do_back_breaker
	calla	air_init_special	; this is considered a special move

	calla	stop_me
	calla	stop_him
	move	*a13(p_otherguy),a0,l
	calla	clear_inviso		; in case he was invisible

	movi	>38,a0
	move	a0,@f_norepell,w 	; disable repell !!
	movi	flipped_pause,a7
	calla	takeover_him_sr
	movi	act_backbreak,a0
	move	a0,*a13(p_action),w		; define my action
	move	*a13(p_otherproc),a1,l
	move	a0,*a1(pa11),l		; pass my action for him to look 4

	tsound	>89	       		; speech: gotcha !

;	movi	rsnd_react_voice,a0
;	calla	calla_for_him

	calla	me_in_front

	movk	5,a9
	calla	get_char_ani2
	calla	do_next_a9_frame	; pose: frame 1 of breaking a back
	movi	>00,a0
	movi	>20,a1
	calla	multi_adjust_xy
*
* pose him ---> back getting snapped
*
	callr	set_his_alt_pal

	movi	>3f,a0
	calla	pose_him_a0
	calla	match_him_with_me
	movi	back_break_adjusts,a0
	calla	get_his_char_long
	move	a0,a1
	sra	16,a1
	sll	16,a0
	sra	16,a0
	calla	adjust_him_xy		; line him up wid me !!!

	sleep	>06			; pause in the air to let em know !!

	clr	a0
	movi	>20000,a1
	movi	>a000,a2
	movi	never_ani,a3
	movi	bb_fall_call,a6
	jsrp	flight_call
	calla	stop_him

	movi	>3f,a9
	calla	get_his_char_ani
	move	a9,a11	    		; a11 = him broken back frame 1

	movk	5,a9
	calla	get_char_ani2
	addi	32,a9	      		; we already did this frame
	calla	do_next_a9_frame
	sleep	2

	tsound	>bb
	movi	rsnd_wasted_voice,a0

	calla	calla_for_him		; him = ahh !!
	addi	32,a11	      		; he already did this frame
	movk	2,a0
	jsrp	double_mframew		; all 2-gether now !!

	push	a11
	movi	>00050005,a11
	calla	shake_a11
	pull	a11
	sleep	>03
	movk	2,a0
	jsrp	double_mframew		; all 2-gether now !!

	movi	>20,a0
	calla	damage_to_him 		; inflict pain

	movi	post_broken_back,a7
	calla	takeover_him
	callr	set_his_alt_pal

	sleep	>18
	jauc	do_backup


set_his_alt_pal
	movi	ft_st,a0
	calla	is_he_him
	jrnc	shap3

	movi	change_to_bloody_pal,a0
	calla	calla_for_him	   	; st = thanks tobias (sarcasm) !!
	move	*a13(p_otherproc),a0,l
	move	*a0(p_flags),a4,w
	ori	pm_alt_pal,a4
	move	a4,*a0(p_flags),w	; flag: he is using aleternate palette
shap3	rets


back_break_adjusts
	.word	>0a,->4b
	.word	>0a,->4b
	.word	>0a,->4b
	.word	>0a,->4b

	.word	>0a,->4b
	.word	>0a,->4b
	.word	>0a,->47
	.word	>0a,->4b

	.word	>0a,->32
	.word	>0a,->32
	.word	>0a,->32
	.word	>00,->42

	.word	>00,>00
	.word	>00,>00		; 2 bosses

	.word	>0a,->4b
	.word	>0a,->4b
	.word	>0a,->4b


bb_fall_call
	move	*a13(p_otherguy),a0,l
	move	*a8(oyvel),*a0(oyvel),l
	rets

;************************************************************************

do_air_body_slam
	calla	air_init_special	; this is considered a special move
	callr	body_slam_init

	movi	>003e003f,a0
	calla	p1p2_sound
	calla	match_him_with_me_f	; line him up
	movk	3,a0
	jsrp	double_mframew		; step #1 = grab

	movi	>4000,a0
	move	a0,*a8(ograv),l
	move	a0,*a10(ograv),l	; both of use: heading down

	movi	>00400041,a0
	calla	p1p2_sound
	movk	3,a0
	jsrp	double_mframew		; step #2 = throw !!
	movi	post_fb_xfers,a0
	calla	get_char_long		; get xfer for other dude
	move	a0,a7
	calla	xfer_otherguy		; and xfer him

	clr 	a0
	movi	>18000,a1
	movi	>8000,a2
	movi	never_ani,a3
	jsrp	flight

	movi	>00030012,a9
	jauc	animate_a9		; getup animation




body_slam_jumps
	.long	hathead_slam	; 0 - hathead
	.long	kang_slam	; 1 - liu kang
	.long	cage_slam	; 2 - cage
	.long	normal_slam  	; 3 - sword arm
	.long	normal_slam	; 4 - female ninja 1
	.long	normal_slam	; 5 - female ninja 2
	.long	normal_slam	; 6 - shang tsung
	.long	raiden_slam	; 7 - raiden
	.long	normal_slam	; 8
	.long	normal_slam	; 9
	.long	normal_slam	; 10
	.long	jax_slam	; 11
	.long	normal_slam	; 12
	.long	normal_slam	; 13
	.long	normal_slam	; 14 - smoke
	.long	normal_slam	; 15
	.long	normal_slam	; 16

jax_slam
	movi	pid_super_slam,a0
	movi	super_slam_proc,a7
	calla	create_and_kill
	move	a13,*a0(pa10),l		; pass my proc
	jruc	normal_slam

raiden_slam
	calla	do_next_a9_frame	; do frame 1 by myself
	sleep	5
	jruc	slam1

kang_slam
	tsound	>06			; kang throw speech
	jruc	slam1

cage_slam
normal_slam
	calla	rsnd_grab_voice

slam1	calla	match_him_with_me_f	; line him up
	movi	throw_ani_speeds,a0
	calla	get_char_word

;******************
;	movi	>300,a0
;	move	a0,@f_norepell,w 	; slow motion patch
;	movk	30,a0
;******************

	jsrp	double_mframew		; step #1 = grab
	sleep	3

	movi	ft_kang,a0
	calla	am_i_him
	jrc	slam2			; kang = dont make next speech call
	calla	rsnd_throw_voice
slam2	movi	throw_ani_speeds,a0
	calla	get_char_word

;***
;	movk	30,a0			; slow motion patch
;***
	jsrp	double_mframew		; step #2 = throw !!

	movk	ft_jax,a0
	calla	am_i_him
	jrc	jax_super_slam		; jax = chance for superslam

	movi	post_fb_xfers,a0
	calla	get_char_long		; get xfer for other dude
	move	a0,a7
	calla	xfer_otherguy		; and xfer him
	sleep	8
	movk	4,a0
	jauc	mframew			; step #3 = back 2 normal


jax_super_slam
	callr	super_wham
	clr	a1
	not	a1
	movi	pid_super_slam,a0
	calla	existp			; super slam still alive ?
	jreq	sans_super		; no, normal slam

*
* flip again !
*
	move	a9,*a13(p_store1),l
	move	a11,*a13(p_store2),l	; save these spots

	movk	3,a0
super3	move	a0,*a13(p_anicount),w
	move	*a13(p_store1),a9,l
	move	*a13(p_store2),a11,l		; save these spots
	movk	4,a0

	movk	4,a0
	jsrp	double_mframew

	calla	super_wham
	sleep	>08

	clr	a1
	not	a1
	movi	pid_super_slam,a0
	calla	existp				; super slam still alive ?
	jreq	sans_super			; no, normal slam

	move	*a13(p_anicount),a0,w
	dsj	a0,super3
*
*  jax getting out of body slam animation
*
sans_super
	movi	post_fb_xfers,a0
	calla	get_char_long		; get xfer for other dude
	move	a0,a7
	calla	xfer_otherguy		; and xfer him

	sleep	10
	movi	>24,a9
	calla	find_ani_part2
	calla	find_part2
	calla	find_part2
	movk	6,a0
	jauc	mframew			; 1 frame / return



super_wham
	mmtm	sp,a10,a11
	movi	rsnd_wasted_voice,a0
	calla	calla_for_him			; scream for him
	calla	shake_n_sound
	movi	>0a,a0
	calla	damage_to_him			; inflict pain
	mmfm	sp,a10,a11
	rets


super_slam_proc
	sleep	12			; 1st time = give em a little more time
ssp4	sleep	8
	move	*a10(p_action),a0,w
	cmpi	act_bodyslam,a0		; still slammin ?
	jane	sucide	       		; no, die
	movi	l_hp,a0
	calla	get_tsl
	cmpi	10,a1			; still a tappin ??
	jrlo	ssp4			; yes stay alive
	die


throw_ani_speeds
	.word	4	; hathead
	.word	4	; kang
	.word	4	; cage
	.word	3	; sword arms
	.word	3	; female ninjas
	.word	3	; female ninjas
	.word	4	; shang tsung
	.word	5	; raiden
	.word	4	;
	.word	4	;
	.word	4	; ninjas
	.word	4	; jax

	.word	4	;
	.word	4	;

	.word	3
	.word	3
	.word	3

hathead_slam
	movi	>60,a0
	move	a0,@f_norepell,w		; disable repell !!

	move	*a13(p_otherguy),a2,l
	calla	noflip_a2

	movi	flipped_pause,a7
	calla	takeover_him
	movi	act_bodyslam,a1
	move	a1,*a13(p_action),w
	move	a1,*a0(pa11),l
*
* check if we are too close to the edge of the world
*
	calla	get_his_dfe		; a5 = left   a6 = right
	move	a6,a7			; assume we will check the right edge
	calla	is_he_right
	jrc	flip3
     	move	a5,a7			; check the left edge
flip3	cmpi	>100,a7
	jrhi	flip_throw     		; close to edge = no flip throw
*
* too close ---> do "non-flip" version
*
	movi	>0002003e,a0		; [total # of entries, 1st entry]
	calla	random_triple		; random raiden yell

	movi	>24,a9			; flip / throw animation
	calla	find_ani_last_frame	; skip the flip part

	push	a8
	move	*a13(p_otherguy),a8,l
	calla	flip_multi 		; flip him horizontally
	movi	ochar_nonflip_adjx,a0
	calla	get_char_word
	calla	adjust_him_x
	pull	a8

	movk	3,a0
	calla	psound_for_him

	calla	flip_multi
	calla	do_next_a9_frame	; pose: about to throw frame
	addi	32,a9			; a9 ---> throw ani
	movk	10,a10		 	; flip version sleep time
	jruc	flip4

ochar_nonflip_adjx
	.word	0	; hathead
	.word	->08	; kang
	.word	0	; cage
	.word	->10	; sword arms
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
	.word	0

*
* grab / shake
*
flip_throw
	tsound	>bf	 			; hh flip voice

	movi	>24,a9
	calla	do_first_a9_frame		; me = grab frame!
	calla	match_him_with_me_f
	movi	>2a,a0
	calla	pose_him_a0			; pose: flipped by hh

	movk	3,a0
	calla	psound_for_him

	movi	>00030001,a0			; a0 = # of pix , # of shakes
	movk	2,a1				; a1 = sleep time
	move	*a13(p_otherguy),a10,l	; a10 = dude to shake !!
	jsrp	shake_him_up
*
* flip over him
*
	movk	4,a0
	jsrp	mframew	    	  		; flip over
	movk	4,a10				; flip version sleep time

flip4
	push	a9
	movi	>2a,a9
	calla	get_his_char_ani
	calla	find_part2
	calla	do_his_next_a9_frame	; him = about to get thrown pose
	pull	a9

	move	a10,a0
	calla	prcslp 	      		; pause before the toss

	push	a9
	movi	>2a,a9
	calla	get_his_char_ani
	calla	find_part2
	calla	find_part2
	calla	do_his_next_a9_frame	; him = about to get thrown pose
	pull	a9

	movi	tossed_by_hathead,a7
	calla	xfer_otherguy
	movk	4,a0
	jsrp	mframew			; the actual toss animation
	sleep	30			; hold that throw pose

	movk	3,a0
	jsrp	mframew			; getup back to stance
	retp

;************************************************************************

	.end


