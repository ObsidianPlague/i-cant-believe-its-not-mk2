**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: animation tables / routines							*
* 											     *
*  copyright (c) 1993 midway manufacturing							*
*											     *
**************************************************************************
; look for lines which were commented out when converting to mk2
	.file	'joy.asm'
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
*  get_char_word - get a characters word entry from a table 		     *
* 											     *
*  input: a0 = table of entries (words)						     *
*											     *
**************************************************************************
get_char_word
	move	*a8(ochar),a1,w
	sll	4,a1
	add	a0,a1
	move	*a1,a0,w
	rets

**********************************************************************

joy_1_proc
joy_2_proc


joy_begin
	movi	bt_stance,b0
	callr	stuff_buttons
	move	*a13(p_flags),a4,w
	ori	pm_joy,a4
	move	a4,*a13(p_flags),w		; flag: i am a joystick dude
	sleep	1

joyb4	jsrp	wait_for_start			; stance till fight begins

joy_entry
	callr	enable_all_buttons
;	calla	back_to_normal
	calla	reset_proc_stack		; make things kosher

	calla	get_my_height			; a1 = my height
	cmpi	>60,a1
	jrhi	joye4				; I am standing

	callr	joystick_in_a0
	btst	bit_jdown,a0
	jrne	joy_duck_entry			; stick down = duck

joye4	clr	a0
	move	a0,*a13(p_downcount),w	; not down anymore
	calla	stance_setup

joy_stance_loop
	callr	am_i_facing_him
	jrc	joye5
	jsrp	turn_around 		; face the chump
	jruc	local_reaction_exit

joye5	callr	check_winner_status
	move	@f_start,a0,w		; still fighting ?
	jreq	joyb4		   	; no --> stance animation
	sleep	1

	callr	check_block_bit
	jrc	joy_block
	callr	joystick_in_a0
	btst	bit_jright,a0		; right ?
	jrne	joy_right
	btst	bit_jleft,a0 		; left ?
	jrne	joy_left

	btst	bit_jup,a0		; up ?
	jrne	joy_up
	btst	bit_jdown,a0 		; down ?
	jrne	joy_down

	calla	back_to_shang_check

	calla	next_anirate
	jruc	joy_stance_loop

**************************************************************************
*											     *
*  joy = up										     *
*											     *
**************************************************************************

joy_up
	calla	face_opponent

	callr	disable_all_buttons
	jsrp	look_for_angle
	movi	bt_jump,b0
	callr	stuff_buttons

	calla	distance_from_ground
	move	a0,a10	   		; a10 = animation point ground dist
	clr	a11
	jsrp	do_jump_up
	movk	6,a9
	calla	find_ani_part2		; a9 = "landing" ani
	movk	3,a0
 	jsrp	mframew
	jruc	local_reaction_exit	; return to normal

**************************************************************************
*											     *
*  do_jump_up - joy/drone jumpup routine					   	     *
* 											     *
*  input: a11 = routine to call everytick (zero for joydudes)		     *
*											     *
**************************************************************************
do_jump_up
	movi	>fafbfcfd,a1
	calla	ochar_sound		; voice: huh !!!!
 
	movi	act_jumpup,a0
	move	a0,*a13(p_action),w

	move	a11,a6
	clr	a0			; initial x vel
  	movi	up_vel,a1		; initial y vel
	movi	up_grav,a2		; grav
	movk	4,a3			; animation speed
	movk	6,a9			; animation offset
 	jsrp	flight_call
	tsound	>1e			; feet gently landing on the ground
	retp

joy_duck_entry
	movk	5,a9
	calla	get_char_ani
	addi	32*2,a9			; a9 = my duck frame
	calla	do_next_a9_frame
	jruc	joyd3


joy_down
	callr	disable_all_buttons
	jsrp	do_duck

joy_getup_entry
joyd3	movi	bt_duck,b0
	callr	stuff_buttons

joyd4	movi	act_duck,a0
	move	a0,*a13(p_action),w		; reset action !!

	sleep	1

	callr	am_i_facing_him			; facing him ?
	jrc    	joyd5				; yes
	jsrp	duck_turnaround			; no, turnaround
	jruc	joyd3

joyd5	
	callr	inc_downcount			; count duck time !
	callr	check_block_bit
	jrc	joy_duck_block
	callr	check_winner_status		; scan for "end of round" while ducking


	callr	joystick_in_a0
	btst	bit_jdown,a0
	jrne	joyd4	    			; stay down while stick = down

joy_back_up
	callr	disable_all_buttons
	calla	face_opponent
	jsrp	do_backup
	jruc	local_reaction_exit	; return to normal

inc_downcount
	move	*a13(p_downcount),a0,w
	inc	a0
	move	a0,*a13(p_downcount),w
	rets

do_backup
	movi	act_backup,a1
	move	a1,*a13(p_action),w	; define my action

	movk	5,a9			; a9 = animation to run backwards
	movk	2,a1			; a1 = sleep time
	jauc	backwards_ani


do_duck
	callr	stop_me
	calla	face_opponent
	movk	5,a9
	calla	get_char_ani
	movk	2,a0
	movi	act_duck,a1
	jauc	act_mframew


do_duck_block
	callr	stop_me
	calla	face_opponent
	movk	>0c,a9
	calla	get_char_ani
	movk	3,a0
	movi	act_blocklo,a1
	jauc	act_mframew   		; get into "duck block" pose



joy_duck_punch
	callr	disable_all_buttons
	jsrp	do_duck_punch

	callr	joystick_in_a0
	btst	bit_jdown,a0
	jrne	joyd3	    		; stay down while stick = down
	jruc	joy_back_up

**************************************************************************
*											     *
*  joy = uppercut									     *
*											     *
**************************************************************************
joy_uppercut
	callr	disable_all_buttons
	jsrp	do_uppercut

	jruc	local_reaction_exit	; return to normal


joy_duck_block
	callr	disable_all_buttons
jdblk2	jsrp	do_duck_block


joy_duck_block_loop
	sleep	1

	callr	am_i_facing_him			; facing him ?
	jrc    	jdblk5				; yes
	jsrp	duck_turnaround			; no, turnaround
	jruc	jdblk2

jdblk5	callr	joystick_in_a0
	btst	bit_jdown,a0		; still holding down joystick ?
	jreq	joy_back_up		; no ---> back up

	callr	inc_downcount
	callr	check_winner_status	; scan for "end of round" while ducking

	movi	act_blocklo,a0
	move	a0,*a13(p_action),w	; reset action !!
	callr	check_block_bit		; still holding block ?
	jrc	joy_duck_block_loop	; yes, loop
*
* joy un - duck block
*
	movk	>0c,a9
	calla	find_ani_part2
	movi	act_duck,a1
	movk	3,a0
	jsrp	act_mframew		; "duck un-block"
	jruc	joyd3


joy_duck_kickh
	jsrp	do_duck_kickh
	movi	act_ret_kick,a0
	move	a0,*a13(p_action),w

	movk	8,a0			; no connect sleep
	jrnc	dkick5
	movk	16,a0			; connect sleep
dkick5	calla	prcslp
	movk	4,a0
	jsrp	retract_strike

	move	*a13(p_downcount),a0,w
	addi	>26,a0
	move	a0,*a13(p_downcount),w	; count kick time as "down time"
	jruc	post_joy_duck_kick


joy_duck_kickl
	jsrp	do_duck_kickl
	movi	act_ret_kick,a0
	move	a0,*a13(p_action),w

	movk	6,a14
	calla	is_he_joy
	jrc	dkick2
	movk	10,a14			; pause against drone
dkick2	move	a14,a0
	calla	prcslp

;****************
;	movk	4,a0			; no connect sleep
;	jrnc	dkick4
;	movk	6,a0			; connect sleep
;dkick4	calla	prcslp
;****************

	movk	2,a0
	jsrp	retract_strike

	move	*a13(p_downcount),a0,w
	addi	8,a0
	move	a0,*a13(p_downcount),w	; count kick time as "down time"

post_joy_duck_kick
	callr	joystick_in_a0
	btst	bit_jdown,a0
	jrne	joyd3	    		; stay down while stick = down
	jruc	joy_back_up

**************************************************************************
*											     *
*  joy = left										     *
*											     *
**************************************************************************
joy_left
	movi	m_jleft,a0
	move	a0,*a13(p_store4),w	; store joystick mask here

	move	*a8(oflags),a4,w
	andi	m_fliph,a4
	xori	m_fliph,a4		; flipped

	jruc	joyr2

**************************************************************************
*											     *
*  joy = right										     *
*											     *
**************************************************************************
joy_right
	move	*a8(oflags),a4,w
	andi	m_fliph,a4
	movi	m_jright,a0
	move	a0,*a13(p_store4),w	; store joystick mask here

joyr2	clr	a2
	move	a2,*a13(p_action),w	; no more stance

	movi	get_walk_info_f,a5
	movk	1,a9			; forward walk
	move	a4,a4
	jreq	joyr3
	movi	get_walk_info_b,a5

joyr3	call	a5			; get walk info
	move	a2,a9
	calla	init_anirate
	move	a1,a0
	calla	set_x_vel
	move	a9,*a13(p_store1),w	; store walk ani offset here
	calla	get_char_ani
	move	a9,*a13(p_anitab),l	; store walk animation
*
* walk loop
*
joyr6	sleep	1
	calla	check_winner_status
	callr	angle_scan		; look for joystick angle combos
	callr	walk_flip_check
	calla	next_anirate
	callr	mask_joystick
	jrne	joyr6			; still pressed ---> walk again
*
* joystick was released
*
	move	*a13(p_anitab),a0,l
	sub	a9,a0
	abs	a0
	srl	5,a0			; a0 = walk frame # i am on !
	cmpi	3,a0			; skip ?
	jrhs	joyr7			; no, stop abruptly
*
* skip animation
*
	move	a0,a1
	sll	5,a1			; 32 bits
	move	*a13(p_store1),a9,w
	inc	a9			; a9 = skip animation offset
	calla	get_char_ani
	add	a1,a9			; a9 = spot to finish off skip ani
	movi	>00060002,a0		; slower skip now !!
	jsrp	animate_a0_frames	; finish skip ani

joyr7	callr	stop_me
	jruc	local_reaction_exit	; return to normal

*
* joystick ---> check if i should turn around while i am walking
*
walk_flip_check
	callr	am_i_facing_him
	jrc	wfc5
	pull	a0
	jsrp	turn_around
	jruc	local_reaction_exit	; return to normal

wfc5	rets

**************************************************************************
*											     *
*  joy = up / right									     *
*											     *
**************************************************************************
joy_upright
	movk	7,a0			; forward flip
	movk	8,a1			; backwards flip
	movi	>40000,a11		; x vel
	jsrp	do_angle_jump
	jruc	local_reaction_exit	; return to normal

*
* input: a0 = ani #1
*	a1 = ani #2
*       a11 = x vel
*
do_angle_jump
	mmtm	sp,a0,a1
	movi	>fafbfcfd,a1
	calla	ochar_sound		; voice: huh !!!!
	mmfm	sp,a0,a1

	move	a0,a9
	move	*a8(oflags),a4,w
	btst	b_fliph,a4
	jreq	jur4
	move	a1,a9

jur4	callr	stop_me
	callr	disable_all_buttons

	movi	bt_angle_jump,b0
	callr	stuff_buttons		; now you can allow attacks

	movi	act_angle_jump,a0
	move	a0,*a13(p_action),w			; define my action
	move	*a8(oxpos),*a13(p_store8),w	; save starting x position

	calla	is_he_right
	jrnc	jur6
	neg	a11    	
jur6	move	a11,a0			; x vel

	movi	angle_jump_call,a6
  	movi	->a0000,a1		; initial y vel (upwards)
	movi	angle_grav,a2
	movk	3,a3			; animation speed
	movk	4,a11			; flip whoosh sound speed
 	jsrp	flight_call

	tsound	>1e			; feet gently landing on the ground
	movi	act_land,a1
	move	a1,*a13(p_action),w	; action: landing on the ground

	calla	face_opponent
	movi	>07,a9
	calla	get_char_ani

	calla	do_next_a9_frame
	sleep	3
	calla	back_to_shang_check
	retp


angle_jump_call
	callr	next_flip_whoosh

	move	*a8(oyvel),a0,l		; vertical direction ?
	jrn	ajc4			; upwards --> skip
	
	move	*a8(oypos),a2,w
	move	*a13(p_ganiy),a0,w	; a0 = grounded ani y
	sub	a2,a0
	abs	a0			; a0 = distance from ground
	cmpi	20,a0
	jrhi	ajc4			; hi off ground ---> skip

	callr	disable_all_buttons	; close to ground ---> no attacking
	clr	a6
	move	a6,*a13(p_store4),l	; no more need for this

ajc4	rets


next_flip_whoosh
	dsj	a11,nfw9
	movk	12,a11			; reset counter

	clr	a0
	movk	1,a1
	calla	p1p2_pick
	calla	triple_sound

nfw9	rets

**************************************************************************
*											     *
*  joy = up / left									     *
*											     *
**************************************************************************
joy_upleft
	movk	7,a1			; forward flip
	movk	8,a0			; backwards flip
	movi	->40000,a11		; x vel
	jsrp	do_angle_jump
	jruc	local_reaction_exit	; return to normal

**************************************************************************
*											     *
*  stop_him - stop other guy								     *
*											     *
**************************************************************************
stop_him
	push	a8
	move	*a13(p_otherguy),a10,l
	move	a10,a8
	callr	stop_me
	pull	a8
	rets


stop_me	calla	stop_a8
	clr	a0
	move	a0,*a8(ograv),l

; <<<<<<<< fall through >>>>>>>>

set_x_vel
	movi	p1_xvel,a1,l
	move	@p1_obj,a2,l
	cmp	a2,a8
	jreq	sxv4			; one of the players ---> zero p?_xvel

	movi	p2_xvel,a1,l
	move	@p2_obj,a2,l
	cmp	a2,a8
	jreq	sxv4			; one of the players ---> zero p?_xvel
	rets

sxv4	move	a0,*a1,l		; make the request !!
	rets

**************************************************************************
*											     *
*  look_for_angle - watches for joystick angle combos			     *
* 											     *
*  returns: carry set = combo was found						     *
*											     *
**************************************************************************
look_for_angle
	movk	3,a11
url4	callr	joystick_in_a0
	move	a0,a1

	andi	m_jup|m_jright,a0
	cmpi	m_jup|m_jright,a0
	jreq	url5
	andi	m_jup|m_jleft,a1
	cmpi	m_jup|m_jleft,a1
	jreq	url6

	sleep	1
	dsjs	a11,url4   		; give a change to go up/right
	retp

url5	pullp	a0			; no return
	jruc	joy_upright
url6	pullp	a0			; no return
	jruc	joy_upleft


angle_scan
	callr	joystick_in_a0
	move	a0,a1
	andi	m_jright|m_jup,a0
	cmpi	m_jright|m_jup,a0
	jreq	ascan4
	andi	m_jleft|m_jup,a1
	cmpi	m_jleft|m_jup,a1
	jreq	ascan5
	rets

ascan4	pull	a0
	jruc	joy_upright
ascan5	pull	a0
	jruc	joy_upleft

**************************************************************************
*											     *
*  mask_joystick - looks at the joystick bits, masks according to	     *
*                  p_store4.								     *
* 											     *
*  returns: zero set   = bit is clear							     *
*           zero clear = bit is set							     *
*											     *
**************************************************************************
mask_joystick
	callr	joystick_in_a0
	move	*a13(p_store4),a1,w	; a1 = joystick mask
	and	a1,a0
	rets

**************************************************************************
*											     *
*  joystick_in_a0 - returns current switch state in a0				*
*											     *
**************************************************************************
joystick_in_a0
	move	*a13(p_joyport),a0,l
	move	*a0,a0,l
	not	a0
	andi	>0f,a0			; look only at 4 joy bits
	rets

**************************************************************************
*											     *
*  check_block_bit - routine to check if a player's block bit iz set !!  *
* 											     *
*  input: a13 = process of dude in question					     *
* 											     *
*  returns: carry set ---> block bit is set !					     *
*											     *
**************************************************************************
check_block_bit
	move	@switch,a0,l
	not	a0			; a0 = switch states
	move	*a13(procid),a1,w
	cmpi	pid_p1,a1		; player 1 ?
	jreq	chbb4			; yes

;	cmpi	pid_p2,a1		; player 2 ?
;	jrne	cbb_error

;	btst	b_p2block,a0		; player 2 blocking ?
;	jreq	blkno
;	jruc	blkyes

	andi	m_p2blocks,a0
	jreq	blkno
	jruc	blkyes

chbb4	andi	m_p1blocks,a0
	jreq	blkno

;	btst	b_p1block,a0		; player 1 blocking ?
;	jreq	blkno

blkyes	setc
	rets

blkno	clrc
	rets


bt_null	.long	0,0,0,0,0

bt_angle_jump
	.long	joy_flip_punch 	; 0
	.long	joy_flip_punch 	; 1
	.long	0		; 2
	.long	joy_flip_kick	; 3
	.long	joy_flip_kick	; 4

bt_duck
	.long	joy_uppercut	; 0
	.long	joy_duck_punch	; 1
	.long	joy_duck_block	; 2
	.long	joy_duck_kickh	; 3
	.long	joy_duck_kickl	; 4

bt_stance
	.long	joy_hi_punch	; 0
	.long	joy_lo_punch	; 1
	.long	joy_block	; 2
	.long	joy_hi_kick	; 3
	.long	joy_med_kick	; 4

bt_jump	.long	jumpup_punch	; 0
	.long	jumpup_punch	; 1
	.long	0		; 2
	.long	jumpup_kick	; 3
	.long	jumpup_kick	; 4

**************************************************************************
*											     *
*  joy_block - joystick dude block sequence					     *
*											     *
**************************************************************************
joy_block
	callr	disable_all_buttons
	calla	face_opponent		; dont look stupid
	jsrp	do_block_hi

joy_block_loop
	sleep	1
	callr	joystick_in_a0
	btst	bit_jdown,a0
	jrne	joy_down

	callr	am_i_facing_him
	jrc	jblk5

	jsrp	turn_around		; face your rival
	jruc	local_reaction_exit	; return to normal

jblk5	callr	check_block_bit
	jrc	joy_block_loop

	jsrp	do_unblock_hi
	jruc	local_reaction_exit	; return to normal

**************************************************************************
*											     *
*  joy_hi_punch - joystick hi punch		  					     *
*											     *
**************************************************************************
psleep	.set	3

joy_hi_punch
	callr	disable_all_buttons

	callr	me_in_front
	callr	is_stick_away
	jrc	joy_power_punch		; stick away ---> power punch

no_power_yet
	callr	elbow_check
	callr	stop_me	
	movi	>13,a9
	calla	get_char_ani

jhp4	callr	get_last_button
	move	a0,*a13(p_store3),l	; save here

	movk	2,a0
	move	a0,*a13(p_stk),w

	calla	punch_sounds
	movk	psleep,a0
	movi	act_hipunch,a1
	jsrp	act_mframew

	move	@f_thatsall,a0,w
	jrne	joy_un_hi_punch1	; round is over ---> exit

	clr	a10			; flag: hi punch
	movk	2,a11			; a11 = strike check offset to use
	move	a11,a0

	callr	strike_check_a0		; strike: hipunch #1
	jrnc	jhp2

	clr	a11
	not	a11			; collision = dont check for more

jhp2	movk	5,a10
	jsrp	punch_sleep
	jrnc	joy_un_hi_punch1
	srl		16,a0
	cmpi	sw_lo_punch,a0
	jreq	joy_punch_htm1		; interupted by medium punch !!
 	cmpi	sw_hi_punch,a0
	jrne	joy_un_hi_punch1	; non-hi-punch ----> finish punch

jhp5	callr	get_last_button
	move	a0,*a13(p_store3),l	; save here

	calla	punch_sounds

	movk	2,a0
	move	a0,*a13(p_stk),w

	movk	psleep,a0
	movi	act_hipunch,a1
	jsrp	act_mframew

	move	@f_thatsall,a0,w
	jrne	joy_un_hi_punch2	; round is over ---> exit

	clr	a10
	movk	2,a11			; a11 = strike check offset to use
	move	a11,a0
	callr	strike_check_a0   		; med punch strike #2
	jrnc	jhp6			; collision = no

	clr	a11
	not	a11			; collision = dont check for more

jhp6	movk	5,a10
	jsrp	punch_sleep
	jrnc	joy_un_hi_punch2
	srl	16,a0
	cmpi	sw_lo_punch,a0
	jreq	joy_punch_htm2		; interupted by medium punch !!
 	cmpi	sw_hi_punch,a0
	jrne	joy_un_hi_punch2	; non-hi-punch ----> finish punch
	jruc	jhp4


joy_un_hi_punch2
	movi	>13,a9
	calla	find_ani_part2		; a9 ---> part 2
	calla	find_part2		; a9 ---> part 3
	jruc	unhip1

joy_un_hi_punch1
	movi	>13,a9
	calla	find_ani_part2		; a9 ---> part 2
unhip1	
	calla	find_part2		; a9 ---> part 3
	calla	find_part2		; a9 ---> un-hipunch
    movk	psleep-1,a0
	jsrp	mframew
	jruc	local_reaction_exit	; return to normal


joy_punch_htm1
	movi	>13,a9
	calla	find_ani_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	jruc	jmp5

joy_punch_htm2
	movi	>13,a9
	calla	find_ani_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	jruc	jmp4

joy_power_punch
	movi	ochar_power_punches,a0
	calla	get_char_long
	jreq	no_power_yet
	movi	reaction_exit,a1	
	pushp	a1			; return address
	jump	a0

ochar_power_punches
	.long	0
	.long	0
	.long	0
	.long	do_swipe
	.long	do_fan_swipe
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0

**************************************************************************
*											     *
*  joy_lo_punch - joystick medium punch						     *
*											     *
**************************************************************************
joy_lo_punch
	callr	stop_me
	callr	disable_all_buttons

	movi	>40,a7
	callr	toss_check
	jrc	joy_toss

	callr	me_in_front

	movi	>14,a9
	calla	get_char_ani

jmp4	callr	get_last_button
	move	a0,*a13(p_store3),l	; save here

	movk	3,a0
	move	a0,*a13(p_stk),w

	calla	punch_sounds
	movk	psleep,a0
	movi	act_lopunch,a1
	jsrp	act_mframew

	move	@f_thatsall,a0,w
	jrne	joy_un_lo_punch1	; round is over ---> exit

	movk	1,a10		 	; flag: med punch
	movk	3,a11			; a11 = strike check offset to use
	move	a11,a0
	callr	strike_check_a0	 	; med punch strike #1
	jrnc	jmp2

	clr	a11
	not	a11			; dont check for more collisions

jmp2	movk	5,a10
	jsrp	punch_sleep
	jrnc	joy_un_lo_punch1
	srl	16,a0
	cmpi	sw_hi_punch,a0
	jreq	joy_punch_mth1		; interupted by hi punch !!
 	cmpi	sw_lo_punch,a0
	jrne	joy_un_lo_punch1	; non-med-punch ----> finish punch


jmp5	callr	get_last_button
	move	a0,*a13(p_store3),l		; save here

	movk	3,a0
	move	a0,*a13(p_stk),w

	calla	punch_sounds
	movk	psleep,a0
	movi	act_lopunch,a1
	jsrp	act_mframew

	move	@f_thatsall,a0,w
	jrne	joy_un_lo_punch2	; round is over ---> exit
	movk	1,a10	   		; flag: med punch
	movk	3,a11			; a11 = strike check offset to use
	move	a11,a0
	callr	strike_check_a0		; med punch strike #2
	jrnc	jmp6
	
	clr	a11
	not	a11			; dont check for more collisions

jmp6	movk	5,a10
	jsrp	punch_sleep
	jrnc	joy_un_lo_punch2
	srl	16,a0
	cmpi	sw_hi_punch,a0
	jreq	joy_punch_mth2		; interupted by hi punch !!
 	cmpi	sw_lo_punch,a0
	jrne	joy_un_lo_punch2	; non-med-punch ----> finish punch
	jruc	jmp4


joy_un_lo_punch2
	movi	>14,a9
	calla	find_ani_part2		; a9 ---> part 2
	calla	find_part2		; a9 ---> part 3
	jruc	unhip1

joy_un_lo_punch1
	movi	>14,a9
	calla	find_ani_part2		; a9 ---> part 2
	jruc	unhip1


joy_punch_mth1
	movi	>14,a9
	calla	find_ani_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	jruc	jhp5

joy_punch_mth2
	movi	>14,a9
	calla	find_ani_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	jruc	jhp4

**************************************************************************
*											     *
*  jumpup_punch - punch while jumping straight up				     *
*											     *
**************************************************************************
jumpup_punch
	callr	disable_all_buttons
	jsrp	do_jumpup_punch
	jruc	local_reaction_exit	; return to normal

**************************************************************************
*											     *
*  jumpup_kick - kick while jumping straight up					     *
*											     *
**************************************************************************
jumpup_kick
	callr	disable_all_buttons
	jsrp	do_jumpup_kick
	jruc	local_reaction_exit	; return to normal

**************************************************************************
*											     *
*  elbow_check - sees if dudes are real close together and if so then    *
*                it jumps to the elbow routine.					     *
*											     *
**************************************************************************
elbow_check
	calla	is_he_airborn
	jrc	local_rets

	calla	get_his_action
	cmpi	act_jax_dizzy,a1
	jreq	local_rets		; no re-dizzy allowed !

	callr	get_x_dist		; a3 = x distance between guys
	cmpi	>40,a3
	jrhi	local_rets

joy_elbow
	pull	a0
	jsrp	do_elbow
	jruc	local_reaction_exit	; return to normal

**************************************************************************
*											     *
*  toss_check - sees if dudes are close enough to for me to toss the     *
*               other guy. carry set = yes							*
* 											     *
*  input: a7 = x distance to qualify "close enough" to toss !!	     	*
*											     *
**************************************************************************
toss_check

;***************
;	move	a7,a7
;	jrn	toss_no
;	cmpi	>60,a7
;	jrhi	toss_no
;***************

	move	@f_sans_throws,a0,w
	jrne	toss_no			; throws disabled !!

	move	*a13(p_otherguy),a0,l

	move	*a0(ochar),a3,w
	cmpi	ft_goro,a3
	jreq	toss_no			; goro cant be flipped
	cmpi	ft_final_boss,a3
	jreq	toss_no			; shao kahn can't be flipped

	move	*a0(oflags2),a0,w
	btst	b_noflip,a0		; is he allowed to be flipped ??
	jrne	toss_no
	callr	is_he_airborn
	jrc	toss_no			; cant toss if he's airborn
	callr	get_x_dist		; a3 = x distance between guys
	cmp	a7,a3
	jrhi	toss_no			; too far apart !!
	callr	am_i_facing_him
	jrnc	toss_no			; he's on the wrong side o me !!
*
* we are close enough !!
*
	calla	get_his_action
	cmpi	act_land,a1		; landing ?
	jreq	toss_no			; yes ---> cant toss him !!

	callr	is_he_joy
	jrc	toss_ok			; he is joy = ok to throw
	callr	toss_drone_check
*
* no throwing when near a wall
*
toss_ok
	callr	am_i_joy		; am I a joystick dude
	jrnc	tchk4			; no
	move	*a8(ochar),a0,w
	cmpi	ft_hathead,a0
	jreq	tchk4			; kung lao = ok to throw
	calla	get_my_dfe
	calla	is_he_right
	jrc	tchk2
	move	a6,a5			; a5 = edge that is behind me
tchk2	cmpi	close_to_edge+8,a5
	jrlo	toss_no			; close to edge ---> no throwing

tchk4	mmtm	sp,a13,a8
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l	; trick "joystick_in_a0" routine
	callr	is_stick_away
	mmfm	sp,a13,a8
	jrnc	toss_yes      		; joy is not away ---> ok to flip

toss_no
	clrc
	rets

toss_yes	setc
	rets


drone_reverse_toss
joy_toss
	jsrp	do_body_slam
	jauc	reaction_exit


local_rets
	rets

local_reaction_exit
	jauc	reaction_exit



toss_drone_check
	move	@winner_status,a0,w
	cmpi	3,a0
	jreq	tdck9			; finish him = ok to throw

	move	@diff,a0,w
	sll	5,a0
	addi	rt_drone_reverse,a0
	move	*a0,a0,w
	calla	randper
	jrnc	tdck9

	callr	get_his_action
	cmpi	act_frozen,a1
	jreq	tdck9			; froze dude ---> no counter throw

	pull	a7
	pull	a7
	movi	drone_reverse_toss,a7
	callr	react_xfer_him
	sleep	4			; let him slam me
	jauc	reaction_exit		; too l8

tdck9	rets

rt_drone_reverse
	.word	0,100,200,300,400,500,700,700,800,900

**************************************************************************
*											     *
*  knee_check - checks to see if dudes are close enough for a knee!!     *
*											     *
**************************************************************************
knee_check
	callr	get_x_dist		; a3 = x distance between guys
	cmpi	>40,a3
	jrhi	local_rets 		; too far away
	calla	is_he_airborn		; is he airborn ?
	jrc	local_rets		; yes, dont knee

joy_knee
	pull	a0
	jsrp	do_knee
	jruc	local_reaction_exit	; return to normal

**************************************************************************
*											     *
*  get_x_dist - get ani x distance between 2 dudes				     *
* 											     *
*  returns: a3 = distance between 'em							     *
*											     *
**************************************************************************
get_x_dist
	move	*a8(oxpos),a4,w
	move	*a13(p_otherguy),a10,l
	move	*a10(oxpos),a3,w
	jruc	gdist4

get_y_dist
	move	*a8(oypos),a4,w
	move	*a13(p_otherguy),a10,l
	move	*a10(oypos),a3,w
gdist4	sub	a4,a3
	abs	a3		; a3 = distance
	rets

**************************************************************************
*											     *
*  punch_sleep - sleep used after a punch has been made (and hit)	     *
* 											     *
*  input: a10 = total sleep time (assuming no buttons pressed)		     *
*         a11 = strike_check offset							     *
*  *a13(p_store3) = button/time that started it all					*
* 											     *
*  returns: carry set = interupted by additional button press		     *
* 											     *
*            a0 = last button/time pressed							*
*											     *
**************************************************************************
punch_sleep
	sleep	1
	move	a11,a0
	jrn	psl2			; neg = dont check for collision
	callr	strike_check_a0		; additional strike checks

psl2	callr	get_last_button
	move	*a13(p_store3),a1,l	; a1 = old state
	cmp	a0,a1			; same ?
	jrne	psl7			; no, leave right now
	dsjs	a10,punch_sleep		; count yer sleeps
	clrc
	jruc	psl9

psl7	callr	am_i_facing_him		; allow repeats only if im facing him

psl9	retp

**************************************************************************
*											     *
*  get_last_button - returns last button/time in a0			     	*
*											     *
**************************************************************************
get_last_button
	calla	get_bcq_next_pointer
	jauc	previous_q_entry

**************************************************************************
*											     *
*  joy_hi_kick - joystick high kick							     *
*											     *
**************************************************************************
joy_hi_kick
	callr	disable_all_buttons
	callr	is_stick_away
	jrc	joy_roundhouse		; stick away ---> roundhouse

	callr	knee_check
	jsrp	do_hi_kick
	jruc	local_reaction_exit	; return to normal

joy_roundhouse
	jsrp	do_roundhouse
	jruc	local_reaction_exit	; return to normal

**************************************************************************
*											     *
*  joy_med_kick - joystick high kick							     *
*											     *
**************************************************************************
joy_med_kick
	callr	disable_all_buttons
	callr	knee_check

	callr	is_stick_away
	jrc	joy_sweep_kick

	jsrp	do_lo_kick
	jruc	local_reaction_exit

joy_sweep_kick
	jsrp	do_sweep_kick
	jruc	local_reaction_exit


**************************************************************************
*											     *
*  joy_flykick - joystick dude kicking while flying at an angle	     *
*											     *
**************************************************************************
joy_flip_kick
	callr	disable_all_buttons
	jsrp	do_flip_kick
	jruc	local_reaction_exit

joy_flip_punch
	callr	disable_all_buttons
	jsrp	do_flip_punch
	jruc	local_reaction_exit

**************************************************************************
*											     *
*  strike_check - look for collisions on "strike" routines		     *
* 											     *
*    input: a0 = stk table      								     *
* 											     *
*  returns: b2 = blocked flag								     *
*											     *
**************************************************************************
strike_check_a0
	calla	get_char_stk  	; a0 = strike table

strike_check
	mmtm	sp,a0,a10,a11

	clr	b2		; a block must be proven !!

;	move	@p1_bar,a1,w
;	jreq	no_collision
;	move	@p2_bar,a1,w
;	jreq	no_collision	; round is over ---> no more collision checks

	move	*a0+,a1,w	; a1 = x offset
	move	*a0+,a2,w   	; a2 = y offset
	move	*a0+,a3,w	; a3 = strike box x size
	move	*a0+,a4,w	; a4 = strike box y size
	move	*a0+,a11,w	; a11 = [strike routine, block routine]
	move	*a0+,a7,w	; a7 = [hit damage,blocked damage]

	move	*a0+,a5,l
	move	a5,b0		; b0 = score value of hit

	move	*a0+,a5,w	; a5 = flags
	pushp	a5

	neg	a1
	move	*a8(oflags),a5,w
	btst	b_fliph,a5
	jrne	stck5
	neg	a1
	sub	a3,a1		; not flipped --> subtract x size for xpos

stck5	mmtm	sp,a1,a2,a3
	move	*a8(oypos),a5,w	; a5 = my ani y
	move	*a8(oxpos),a6,w	; a6 = my ani x
	mmfm	sp,a1,a2,a3
	add	a6,a1	     	; a1 = x position of collision box
	add	a5,a2	     	; a2 = y position

	move	@f_colbox,a14,w		; collision box object ?
	jreq	skip_object    		; no

	;display collision boxes 
	mmtm	sp,a0,a1,a4,a8
	clr	a1
	not	a1
	movi	oid_cbox,a0
	calla	kilobj2	   	; kill all other collision box objects
	movi	cbox_init,a14
	movi	dmacal,a4
	calla	initobj
	move	a8,a10		    	; a10 = collision box object
	mmfm	sp,a0,a1,a4,a8

	move	a1,*a10(oxpos),w
	move	a2,*a10(oypos),w
	move	a3,*a10(osizex),w
	move	a4,*a10(osizey),w	; define size and shape
	movi	bpal_hot_green,a0
	move	a0,*a10(oconst),w
	move	a10,a0
	calla	insobj2			; put on list #2 (in front of dudes)

skip_object
	add	a1,a3
	add	a2,a4
	sll	16,a2
	movy	a2,a1			; a1 = "strike" top left [y,x]
	sll	16,a4
	movy	a4,a3			; a3 = "strike" bottom right [y,x]

	mmtm	sp,a1,a3

	move	*a13(p_otherguy),a10,l
	mmtm	sp,a7,a8
	move	a10,a8
	calla	highest_mpart		; a0 = high point
	calla	lowest_mpart		; a1 = low point
	calla	leftmost_mpart		; a2 = left point
	calla	rightmost_mpart		; a3 = right point
	mmfm	sp,a7,a8

	move	a3,a4
	sub	a2,a4
	abs	a4			; a4 = x size of other dude

	pullp	a6
	btst	sb_squeeze,a6 		; squeeze flag ?
	jreq	stck6			; no
	callr	sq_punch		; yea

stck6	callr	victim_box	 

	sll	16,a0
	movy	a0,a2			; a2 = top left [y,x]
	sll	16,a1
	movy	a1,a3			; a3 = bottom right [y,x]
	mmfm	sp,a4,a5
*
* a2 = victim top left [y,x]
* a3 = victim bottom right [y,x]
* a4 = strike top left [y,x]
* a5 = strike bottom right [y,x]
*
	cmpxy	a5,a2			; compare: top left / bottom right
	jryge	no_collision
	jrxge	no_collision
	cmpxy	a4,a3			; compare: bottom right / top left
	jrxle	no_collision
	jryle	no_collision
*
* collision = yes
*
	calla	disable_his_buttons			; dont let him break out !

	move	*a13(p_otherproc),a0,l
	move	*a13(p_action),*a0(p_hitby),w	; update: last hit by !

	move	a6,a5			; a5 = strike flags
	clr		a6			; reduce bar #1
	move	*a13(p_otherguy),a0,l
	move	@p1_obj,a1,l
	cmp		a0,a1
	jreq	stck7
	movk	1,a6			; reduce bar #2

stck7	
	callr	is_he_blocking
	jrc	strike_blocked		; blocked !

block_is_useless
	move	a7,a10
	sll	16,a10
	srl	24,a10			; a10 = use "hit damage" half
	callr	bar_reducer
	sll	16,a11
	srl	24,a11			; a11 = "hit" routine offset
	sll	5,a11

	move	*a8(ochar),a0,w
	sll	5,a0
	addi	reaction_tables,a0
	move	*a0,a0,l
	add	a0,a11
	move	*a11,a7,l

	callr	react_xfer_him

yes_collision
	setc
	jruc	sc_exit

no_collision
	clrc

sc_exit	mmfm	sp,a0,a10,a11
	rets

*
* Input: a7 = address to xfer him to !
*
react_xfer_him
	movi	pid_switch1,a0
	move	*a13(p_otherproc),a1,l
	move	*a1(procid),a1,w
	cmpi	pid_p1,a1
	jreq	rx4
	movi	pid_switch2,a0
rx4	calla	dallprc			; kill his switch procs
	calla	xfer_otherguy		; and xfer him away

	move	*a0(p_flags),a4,w
	ori		pm_reacting,a4
	move	a4,*a0(p_flags),w	; otherguy = flag: reactiing !!
	rets
*
* a5 = middle y of strike box
* a7 = [hit,blocked] damage
*
strike_blocked
	move	a7,a10			; a10 = damage
	sll	32-8,a10	
	srl	32-8,a10		; use "blocked damage" half

	push	a8
	move	*a13(p_otherguy),a8,l	; a little trickery here !!
	move	*a8(ochar),a3,w			; a3 = his ochar
	calla	get_my_strength			; a0 = other dudes strength
	pull	a8
	sub	a10,a0				; subtract block damage
	jrn	block_is_useless		; block or no ---> he's screwed!
	jreq	block_is_useless		; block or no ---> he's screwed!

	movk	1,b2				; flag: strike was blocked !!
	sll		24,a11
	srl		24-5,a11			; a11 = "blocked" offset
	addi	block_xfers,a11
	move	*a11,a7,l			; a7 = block address to xfer

	move	*a13(p_otherproc),a0,l
	calla	fastxfer
*
* block damage
*
	clr	b0				; no points for blocks
	callr	bar_reducer
	jruc	yes_collision



victim_box
	rets

	mmtm	sp,a0,a1,a2,a3,a4,a8
	movi	cbox_init,a14
	movi	dmacal,a4
	calla	initobj
	move	a8,a10		     ; a10 = collision box object
	mmfm	sp,a0,a1,a2,a3,a4,a8

	mmtm	sp,a0,a1,a2,a3
	move	a0,*a10(oypos),w
	sub	a0,a1
	abs	a1
	move	a1,*a10(osizey),w

	move	a2,*a10(oxpos),w
	sub	a2,a3
	abs	a3
	move	a3,*a10(osizex),w

	movi	bpal_red,a0
	move	a0,*a10(oconst),w
	move	a10,a0
	calla	insobj2			; put on list #2 (in front of dudes)
	mmfm	sp,a0,a1,a2,a3
	rets


**************************************************************************
*											     *
*  bar_reducer - add to players drop ram while is subtracted from his	*
*	        power										*
* 											     *
*  input:  a6 = 0/1 for player 1 or 2							     *
*         a10 = amount to subtract from p?_bar					     *
* 											     *
*          b0 = score value								     *
* 											     *
*  returns: carry set = round is over							     *
*											     *
**************************************************************************
bar_reducer
	move	@p1_bar,a0,w
	jreq	bred5
	move	@p2_bar,a0,w
	jreq	bred5			; zero already ---> mute point !

;	move	@f_th atsall,a0,w
;	jrne	bred5			; thats all ---> dont beat a dead horse

	move	@p1_obj,a1,l
	move	@p1_char,a2,w
	cmpi	0,a6			; damage to player 1 ?
	jreq	bred3	    		; yes
	move	@p2_obj,a1,l		; no, player 2 !!
	move	@p2_char,a2,w
bred3	callr	ochar_xlate_damage

	move	a6,a7
 	sll	5,a6
	addi	pbar_table,a6
	move	*a6+,a6,l		; a6 ---> player bar value

	move	*a6,a1,w		; a1 = current bar value
	sub	a10,a1			; take off damage
	jrnn	bred4			; non-neg ----> stuff back into bar !
	clr	a1			; nothing smaller than zero allowed
bred4	move	a1,*a6,w		; stuff back into bar value
	jrp	not_dead_yet
bred5	setc				; carry set ---> round iz over
	rets

;**************************************************************************

ochar_xlate_damage
	sll	5,a2
	addi	ochar_damage_table,a2
	move	*a2,a2,l		; do something to damage ?
	jrne	oxd3
    	rets
oxd3	jump	a2


ochar_damage_table
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	xlate_goro
	.long	xlate_kahn

	.long	xlate_secret
	.long	xlate_secret
	.long	xlate_secret

xlate_goro
	srl	1,a10			; goro = half damage
	rets

xlate_secret
xlate_kahn
	move	a10,a2
	srl	1,a10			; 1/2
	srl	2,a2			; 1/4
	add	a2,a10
	rets

;**************************************************************************

not_dead_yet
	cmpi	6,a1			; dude in danger ?
	jrhi	bred6			; no

	inc	a7			; a7 = 1 or 2 (player 1 or 2)
	move	@f_warnsound,a1,w
	and	a7,a1			; look at bit for this player
	jrne	bred6			; sound call already made
	
	or	a7,a1
	move	a1,@f_warnsound,w	; set flag for this player
	move	a7,a5

	create	pid_danger1,danger_danger
	move	a5,*a0(pa11),l		; pass "who is in danger"

bred6	clrc
	rets


pbar_table
	.long	p1_bar
	.long	p2_bar

**************************************************************************
*											     *
*  sq_punch - squeeze routine for van dan punch					     *
*											     *
**************************************************************************
sq_punch
	push	a7
	move	a4,a7
	srl	3,a7			; a7 = 1/8 wideness
	srl	2,a4			; a4 = 1/2 wideness
	add	a7,a4			; a4 = 4/8 + 1/8 = 5/8 wideness

	add	a4,a2			; a2 = dudes left collision x
	sub	a4,a3			; a3 = dudes right collision x
	pull	a7
	rets

cbox_init
	.long	null_image,boonpal
	.word	oid_cbox,0,0,0

**************************************************************************
*											     *
*  check_winner_status - players call this routine between every move    *
*                        to check the status of the game			     *
* 											     *
*  where the variable means:								     *
* 											     *
*  0 - no outcome yet									     *
*  1 - player 1 wins									     *
*  2 - player 2 wins									     *
*  3 - finish him off mode								     *
*											     *
**************************************************************************
check_winner_status
	move	@winner_status,a0,w
	jreq	cws9				; nothing new ---> return
	cmpi	3,a0
	jrhi	winner_error
	dec	a0
	sll	5,a0
	addi	status_jumps,a0
	move	*a0,a0,l
	jump	a0				; jump to offset of table

cws9   
;	move	*a13(p_flags),a0,w
;	btst	pb_corpse,a0			; am i history ?
;	jane	i_am_a_corpse			; yes
	rets


status_jumps
	.long	player_1_wins			; winner_status = 1
	.long	player_2_wins			; winner_status = 2
	.long	finish_him			; winner_status = 3

winner_error
	ermac	2				; we are screwed bigtime !!

**************************************************************************
*											     *
*  disable_his_buttons - disable other players buttons			     *
*											     *
**************************************************************************
disable_his_buttons
	push	a8
	push	b0
	move	*a13(p_otherguy),a8,l	; trick "disable_all_buttons"
	callr	disable_all_buttons
	pull	b0
	pull	a8
	rets

**************************************************************************
*											     *
*  disable_all_buttons - disable my buttons					     *
*											     *
**************************************************************************
disable_all_buttons
	movi	bt_null,b0
	jruc	stuff_buttons	

enable_all_buttons
	movi	bt_stance,b0
;	<<<<<<<<<<<< fall through >>>>>>>>>>>>

**************************************************************************
*											     *
*  stuff_buttons - stuff a new button vector into p?_button		     *
* 											     *
*  input: b0 = new vector								     *
*         a8 = player object making the request					     *
*											     *
**************************************************************************
stuff_buttons
	push	a0
	move	@p1_obj,a0,l		; a0 = player 1 object
	movi	p1_button,b1
	cmp	a0,a8			; my object match player 1 ?
	jreq	stbut3			; yes, i am player 1
	movi	p2_button,b1		; no, i am player 2
stbut3	move	b0,*b1,l
	pull	a0
	rets

**************************************************************************
*											     *
*  stuff_bjump - stuff an address into a players button jump ram	     *
* 											     *
*  input: a10 = player 1 button jump ram						     *
*         a11 = player 2 button jump ram						     *
*         a9 = address	  								     *
*											     *
**************************************************************************
stuff_bjump
	move	@p1_obj,a3,l
	cmp	a3,a8
	jreq	sbj4
    	move	a11,a10
sbj4	move	a9,*a10,l		; stuff address in !!
	rets

**************************************************************************
*											     *
*  me_in_front - puts my object in front of the other guys		     *
* 											     *
*  input: a8 = my object									     *
*											     *
**************************************************************************
me_in_front	
	move	*a13(p_otherguy),a1,l	; grab the other chump
	movi	back_z,a0
	move	a0,*a1(ozval),l
	movi	front_z,a0
	move	a0,*a8(ozval),l
	rets

**************************************************************************
*											     *
*  me_in_back - puts my object in front of the other guys		     	*
* 											     *
*  input: a8 = my object									     *
*											     *
**************************************************************************
me_in_back
	move	*a13(p_otherguy),a1,l	; grab the other chump
	movi	front_z,a0
	move	a0,*a1(ozval),l
	movi	back_z,a0
	move	a0,*a8(ozval),l
	rets

**************************************************************************
*											     *
*  noflip_a2 - set the noflip bit in the a2 object				     *
*											     *
**************************************************************************
noflip_a2
	move	*a2(oflags2),a4,w
	ori	m_noflip,a4
	move	a4,*a2(oflags2),w		; set his bit !
	rets

**************************************************************************
*											     *
*  damage_to_me - dudes call this routine to give awards to the other    *
*                 player.								     *
* 											     *
*  input: b0 = score value (coded)							     *
*         a8 = me 										*
*        a10 = damage value								     *
*											     *
**************************************************************************
damage_to_me
	clr	a6
	movk	1,a1
	move	@p1_obj,a7,l
	cmp	a7,a8
	jreq	gett5
     	movk	1,a6
	clr	a1
gett5	jruc	bar_reducer

**************************************************************************
*											     *
*  striker - general purpose attack routine.					     *
* 											     *
*  input: a0 = speed	      	returns: carry set = hit		     	*
*  	 a1 = act                        carry clear = miss		     *
*  	 a9 = ani offset       								     *
*  	 a10 = # of frames to look for collision					*
*  	 a11 = stk offset								     *
*											     *
**************************************************************************
upcut_striker
	mmtm	sp,a0,a1
	calla	init_special		; setup stuff
	jruc	attk5

behind_striker
	mmtm	sp,a0,a1
	calla	init_special		; setup stuff
	calla	me_in_back
	jruc	attk3

striker_2
	mmtm	sp,a0,a1
	calla	init_special		; setup stuff
	calla	get_char_ani2		; a9 = animation table
	jruc	attk2

striker
	mmtm	sp,a0,a1
	calla	init_special		; setup stuff
attk3	calla	get_char_ani		; a9 = animation table

attk5

;****************
	.if ejbbug
	clr	a1
	not	a1
	movi	oid_cbox,a0
	calla	kilobj2	   		; kill all other collision box objects
	.endif
;****************

attk2	mmfm	sp,a0,a1
	jsrp	act_mframew    		; attack animation

attk4	move	a11,a0
	callr	strike_check_a0		; look for strike
	jrc	attack_hit		; hit ---> yes
	sleep	1
	dsj	a10,attk4
	clrc				; carry clear ---> sans hit
	jruc	attk9

attack_hit
	setc
attk9	retp

**************************************************************************
*											     *
*      questions questions questions questions questions questions	     *
*      questions questions questions questions questions questions	     *
*      questions questions questions questions questions questions	     *
*											     *
**************************************************************************

**************************************************************************
*											     *
*  is_stick_away - answers the question: "is my joystick moving away fro *
*                  the other dude?"							     *
* 											     *
*  returns: carry set = yes								     *
*											     *
**************************************************************************
is_stick_away
	movi	m_jleft,a7
	calla	is_he_right
	jrc		isa5
	movi	m_jright,a7
isa5	
	callr	joystick_in_a0		; a0 = joy bits
	and		a7,a0
	jreq	isa7
	setc
	rets
isa7	
	clrc
	rets

is_stick_down
	callr	joystick_in_a0
	btst	bit_jdown,a0		; is joystick down ?
	jrne	isdyes	
	clrc
	rets
isdyes	setc
	rets

**************************************************************************
*											     *
*  is_he_blocking - answers the question: is the other dude trying to    *
*                   block this punch ?						     *
* 											     *
*           carry set = yes        carry clear = no				     *
* 											     *
*  b1 = duck flag									     *
*											     *
**************************************************************************
is_he_blocking
	clr	b1			; assume "sans blocking"

	callr	is_he_joy		; other dude a joy ?
	jrc	ihb1			; yes
*
* other dude is a drone
*
	move	*a0(p_action),a1,w
	cmpi	act_blockhi,a1		; he blocking ?
	jreq	ihby			; yes
	cmpi	act_blocklo,a1		; duck blocking ?
	jreq	ihby_duck		; yes
	jruc	ihbn
*
* other dude = joystick controlled
*
ihb1	callr	is_he_airborn
	jrc	ihbn			; can't block while airborn

	move	*a13(p_otherguy),a0,l
	move	*a0(oflags2),a0,w
	btst	b_noblock,a0		; is he in a "no block" situation
	jrne	ihbn			; yes = button or no button yer screwed

	push	a13
	move	*a13(p_otherproc),a13,l
	callr	check_block_bit
	pull	a13
	jrc	ihb2			; button pressed ---> blocked

ihbn	clrc
	rets

*
* block = yes
*
ihb2	move	*a13(p_otherproc),a10,l
	move	*a10(p_joyport),a0,l
	move	*a0,a0,l
	not	a0
	btst	bit_jdown,a0
	jreq	ihb3
ihby_duck
	movk	1,b1			; he's ducking ---> flag it !!
ihby	setc
	rets
*
* standing up block
*
ihb3	btst	1,a5			; does this require "duck" block ?
	jrne	ihbn			; yes ---> no block
	setc
	rets

**************************************************************************
*											     *
*  is_he_airborn - answers the question with a carry				     *
*											     *
**************************************************************************
is_he_airborn
	move	*a13(p_otherguy),a0,l
	move	*a13(p_otherproc),a1,l
	move	*a1(p_ganiy),a1,w	; a1 = grounded ani y

aborn4	move	*a0(oyvel),a3,l
	jrne	iha_yes			; moving y ---> yes

	move	*a0(oypos),a2,w		; a2 = current y
	cmp	a2,a1
	jrne	iha_yes			; not grounded = airborn
	clrc
	rets

iha_yes	setc
	rets

**************************************************************************
*											     *
*  am_i_airborn - answers the question with a carry				     *
*											     *
**************************************************************************
am_i_airborn
	move	a8,a0
	move	*a13(p_ganiy),a1,w	; a1 = grounded ani y
	jruc	aborn4

**************************************************************************
*											     *
*  is_he_joy - answers the question with a carry				     *
* 											     *
*  returns: a0 = other dudes proc							     *
*											     *
**************************************************************************
is_he_joy
	move	*a13(p_otherproc),a0,l
	move	*a0(p_flags),a4,w
	btst	pb_joy,a4			; joy dude ?
	jrne	ihjy				; yes
	clrc					; nope
	rets
ihjy	setc
	rets

**************************************************************************
*											     *
*  am_i_joy - answers the question with a carry					     *
*											     *
**************************************************************************
am_i_joy
	move	*a13(p_flags),a4,w
	btst	pb_joy,a4			; joy dude ?
	jrne	ihjy				; yes
	clrc					; nope
	rets

**************************************************************************
*											     *
*  am_i_facing_him - answers the question with a carry			     *
* 											     *
*  carry set ---> yes									     *
*											     *
**************************************************************************
am_i_facing_him
	clr	a6				; assume: no flip needed
	calla	is_he_right			; to the right of me ?
	jrc	aif4
	movi	m_fliph,a6
aif4	move	*a8(oflags),a4,w
	andi	m_fliph,a4			; a4 = flip state
	cmp	a4,a6				; are we correct ?
	jreq	aify
	clrc
	rets
aify	setc
	rets

is_he_facing_me
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l
	callr	am_i_facing_him
	mmfm	sp,a8,a13
	rets

**************************************************************************
*											     *
*  am_i_him - answers the question: am i the person in a0 with a carry   *
*											     *
**************************************************************************
am_i_him
	move	*a8(ochar),a1,w
	cmp	a0,a1
	jreq	aihy
	clrc
	rets

aihy	setc
	rets

**************************************************************************
	.end

