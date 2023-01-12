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

; shang to hh  = away - down - away - hi kick
; shang to lk  = away - towards - towards - block
; shang to jc  = left - left - down - lo punch
; shang to sa  = down - down - lo kick
; shang to fn1 = block - block - block (fast)
; shang to fn2 =	hold hi punch for 1 second and let go
; shang to rd  = down - away - towards - lo kick
; shang to sz  = towards - down - towards - hi punch
; shang to rp  = up - down - hi punch
; shang to sc  = up - up
; shang to jx  = down - towards - away - hi kick

p1_up	.set	>01
p1_down	.set	>02
p1_left	.set	>03
p1_right	.set	>04	

p2_up	.set	>100
p2_down	.set	>200
p2_left	.set	>300
p2_right	.set	>400	


reaction_exit
	calla	am_i_airborn		; am i in the air ?
	jrnc	rex3			; no

	clr	a0
	clr	a1
	movi	>6000,a2		; a2 = gravity
	movk	5,a3			; a3 = ani speed
	jauc	fall_on_my_back

rex3	calla	stop_me
	calla	back_to_normal	  	; back 2 reality
	calla	reset_proc_stack  	; make things kosher
	calla	back_to_shang_check
	calla	check_sk_death

	move	*a13(p_flags),a4,w
	btst	pb_joy,a4		; joystick dude ?
	jane	joy_entry		; yes ---> return to joystick
	jauc	drone_entry		; no ---> drone yer ass off


button_table_xfer
	move	@p1_button,a1,l
	move	@p1_proc,a3,l
	move	a2,a2
	jreq	btx3
	move	@p2_button,a1,l
	move	@p2_proc,a3,l
btx3	move	a0,a4
	sll	5,a4
	add	a1,a4
	move	*a4,a7,l		; button jump table entry ??
	jreq	btx9			; nope.

	push	a0
	move	a3,a0
	calla	fastxfer		; button table xfer him
	pull	a0

btx9	rets

**************************************************************************
*											     *
*  update_tsl_a1										     *
* 											     *
*    input: a1 = points to two 16 bit locations (p1-p2)			     *
*           a8 = dude who wants 2 know						     *
*											     *
**************************************************************************
update_tsl_a1
	move	*a8(oid),a14,w
	cmpi	pid_p1,a14	; player 1 ??
	jreq	usl1
    	addk	16,a1		; no, point to player 2's tick ram
usl1	move	@tick,a14,w
	move	a14,*a1,w	; update this player's ram
	rets

**************************************************************************
*											     *
*   the following info is supplied:							     *
* 											     *
*  a0 = switch offset (0-8)								     *
*  a2 = player offset (0-1)								     *
*  a8 = my object									     *
* 											     *
*  p_store4    = my proc									     *
*  p_otherguy  = other guy's object							     *
*  p_otherproc = other guy's proc							     *
*											     *
**************************************************************************
switch_close_jumps
	.long	bj_hi_punch
	.long	bj_lo_punch
	.long	bj_block
	.long	bj_hi_kick
	.long	bj_lo_kick
	.long	jj_up
	.long	jj_down
	.long	jj_left
	.long	jj_right

bj_hi_punch
	movi	l_hp,a1
	callr	update_tsl_a1

	callr	button_table_xfer
	movi	char_hi_punch,a1
	jruc	charjmp

bj_lo_punch
	movi	l_lp,a1
	callr	update_tsl_a1

	callr	button_table_xfer
	movi	char_lo_punch,a1
	jruc	charjmp

bj_block
	movi	l_block,a1
	callr	update_tsl_a1

	callr	button_table_xfer
	movi	char_block,a1
	jruc	charjmp

bj_hi_kick
	movi	l_hk,a1
	callr	update_tsl_a1

	callr	button_table_xfer
	movi	char_hi_kick,a1
	jruc	charjmp

bj_lo_kick
	movi	l_lk,a1
	callr	update_tsl_a1

	callr	button_table_xfer
	movi	char_lo_kick,a1
	jruc	charjmp

jj_up
	movi	char_joyup,a1
	jruc	charjmp

jj_down
	movi	char_joydown,a1
	jruc	charjmp

jj_left
	movi	char_joyleft,a1
	jruc	charjmp

jj_right
	movi	char_joyright,a1

charjmp	move	*a8(ochar),a0,w
	sll	5,a0
	add	a1,a0
	move	*a0,a0,l
	jump	a0

char_joyup
	.long	hh_up			; 0
	.long	sucide			; 1
	.long	jc_up			; 2
	.long	sucide			; 3
	.long	sucide			; 4
	.long	sucide			; 5
	.long	st_up			; 6
	.long	rd_up			; 7 - Raiden
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;


char_joydown
	.long	sucide			;
	.long	lk_down			; 1 - liu kang
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;
	.long	st_down			;
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;


char_joyleft
char_joyright
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;
	.long	rd_left_right		;
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;


st_down
	move	@curback,a4,w
	cmpi	6,a4
	jrne	death
	move	@winner_status,a4,w
	cmpi	3,a4
	jrne	death	       		; only during "finish him" mode

	movi	f1b0|f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_st_dtp,a11
	jruc	check_dtp


st_up
	movi	f1b0|f1b1|f1b3|f1b4,a0
	movi	f2b0|f2b1|f2b3|f2b4,a1
	movi	scom_st_2_sc,a11
	callr	combo_look_lr
	jrnc	death			; no

	callr	button_mask
	jrne	death

	movi	do_st_2_sc,a7
	jruc	restricted_xfer


hh_up
	movi	f1b0|f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_hh_teleport,a11
	callr	combo_look_lr		; melt joystick combo ?
	jrnc	death			; no

	movi	do_hh_teleport,a7
	jruc	restricted_xfer



rd_up
	movi	f1b2,a0
	movi	f2b2,a1
	movi	scom_rd_melt,a11
	callr	combo_look_lr		; melt joystick combo ?
	jrnc	death			; no

	movi	l_warp,a0
	calla	get_tsl			; last raiden melt
	cmpi	>40,a1			; too soon since last time ?
	jrlo	death			; yes, abort, abort

	movi	do_raiden_melt,a7
	jruc	restricted_xfer



rd_left_right
	movi	f1b2,a0
	movi	f2b2,a1
	movi	scom_rd_dive,a11
	callr	combo_look_lr
	jrnc	death

	movi	do_raiden_dive,a7
	jruc	airborn_xfer


char_hi_punch
	.long	hh_hi_punch		; 0 - hathead
	.long	lk_hi_punch		; 1 - liu kang
	.long	jc_hi_punch		; 2 - cage
	.long	sa_hi_punch	   	; 3 - raptor
	.long	fn1_hi_punch		; 4 - knockout
	.long	sucide			; 5 - bombshell
	.long	st_hi_punch		; 6 - shang tsung
	.long	rd_hi_punch		; 7 - raiden
	.long	sz_hi_punch		; 8 - subzero
	.long	rp_hi_punch		; 9 - reptile
	.long	sc_hi_punch		; 10
	.long	jx_hi_punch	  	; 11

char_lo_punch
	.long	hh_lo_punch		; 0 - hathead
	.long	lk_lo_punch		; 1 - liu kang
	.long	jc_lo_punch		; 2 - cage
	.long	sa_lo_punch		; 3 - sword arms
	.long	fn1_lo_punch		; 4 - female ninja
	.long	fn2_lo_punch		; 5 - female ninja
	.long	st_lo_punch		; 6 - shang tsung
	.long	rd_lo_punch		; 7 - raiden
	.long	sz_lo_punch		; 8 - subzero
	.long	rp_lo_punch		; 9 - reptile
	.long	sc_lo_punch		; a - scorpion
	.long	jx_lo_punch		; b - jax

char_block
	.long	sucide			; 0
	.long	sucide			; 1
	.long	jc_block		; 2 - cage
	.long	sa_block		; 3
	.long	sucide			; 4
	.long	sucide			; 5
	.long	st_block		; 6 - shang tsung
	.long	sucide			; 7
	.long	sz_block		; 8 - subzero
	.long	rp_block		; 9 -
	.long	sc_block		; 10 - scorpion
	.long	jx_block		; 11 - jax

char_hi_kick
	.long	hh_hi_kick		; 0 = hathead
	.long	lk_hi_kick		; 1 - liu kang
	.long	jc_hi_kick		;
	.long	sa_hi_kick		;
	.long	fn1_hi_kick		; 4 - 
	.long	fn2_hi_kick		; 5 - 
	.long	st_hi_kick		; 6 - shang
	.long	rd_hi_kick		; 7
	.long	sz_hi_kick		; 8
	.long	rp_hi_kick		; 9 - reptile
	.long	sc_hi_kick		;10 - scorpion
	.long	jx_hi_kick		;

char_lo_kick
	.long	hh_lo_kick		; 0
	.long	lk_lo_kick		; 1
	.long	jc_lo_kick		; 2 - cage
	.long	sucide			; 3
	.long	fn1_lo_kick		; 4 - 
	.long	fn2_lo_kick		; 5
	.long	st_lo_kick		; 6 - shang
	.long	sucide			; 7
	.long	sz_lo_kick		; 8 - subzero
	.long	rp_lo_kick		; 9 - reptile
	.long	sc_lo_kick		; 10 - scorpion
	.long	jx_lo_kick		; 11 - jax

**************************************************************************
*											     *
*  Switch opennings									     *
*											     *
**************************************************************************
switch_open_jumps
	.long	bo_hi_punch
	.long	bo_lo_punch
	.long	sucide
	.long	bo_hi_kick
	.long	bo_lo_kick
	.long	sucide
	.long	sucide
	.long	sucide
	.long	sucide

bo_hi_punch
	movi	char_hip_open,a1
	jruc	charjmp

char_hip_open
	.long	sucide			; 0 - hathead
	.long	sucide			; 1
	.long	sucide			; 2
	.long	sucide			; 3
	.long	sucide			; 4
	.long	fn2_hp_open		; 5 - female ninja #2
	.long	st_hp_open		; 6 - shang hi punch open
	.long	rd_hp_open		; 7 - Raiden hi punch open
	.long	sucide			;
	.long	sucide			;
	.long	sc_hp_open		; 10
	.long	sucide			;

;******************************************************************

bo_hi_kick
	movi	char_hik_open,a1
	jruc	charjmp

char_hik_open
	.long	sucide			; 0 - hathead
	.long	sucide			; 1
	.long	sucide			; 2
	.long	sucide			; 3
	.long	sucide			; 4
	.long	fn2_hk_open		; 5
	.long	st_hk_open		; 6
	.long	sucide			; 8 
	.long	sucide			; 8 
	.long	sucide			; 9
	.long	sucide			; a
	.long	sucide			; b

;******************************************************************

rd_hi_kick
	calla	bb_check
	calla	get_x_dist
	cmpi	>a0,a3
	jrlo	death
	calla	fs_check
	jruc	death


rd_lk_open
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	l_lk,a0
	calla	get_tsl			; a1 = amount of time passed since
	cmpi	>80,a1			; within time frame ?
	jrlo	death			; no ---> ignore

	movi	>40,a1
	movi	do_fatality_1,a7
	jruc	fatality_xfer_close



rd_hp_open
	movi	l_hp,a0
	calla	get_tsl			; a1 = amount of time passed since
*
* raiden fatality #2
*
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	rdhpo2			; only during "finish him" mode
	cmpi	>40*6,a1   		; super long ?? (6 seconds)
	jrlo	rdhpo2			; no ---> ignore
	movi	>52,a1
	movi	do_fatality_2,a7
	jruc	fatality_xfer_close

rdhpo2	movi	l_hp,a0
	calla	get_tsl			; a1 = amount of time passed since
	cmpi	>50,a1			; within time frame ?
	jrlo	death			; no ---> ignore

	calla	is_he_joy
	jrnc	death			; no zap on drones

	calla	get_his_action
	cmpi	act_shock_sd,a1
	jreq	death			; sorry jeff !!

	movi	do_raiden_shocker,a7
	jruc	restricted_xfer

;*********************************************************************

st_hk_open
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	l_hk,a0
	calla	get_tsl			; a1 = amount of time passed since
	cmpi	>30,a1			; within time frame ?
	jrlo	death			; no ---> ignore

	calla	is_he_facing_me
	jrne	death

	calla	get_x_dist
	cmpi	>50,a3
	jrlo	death

	movi	>78,a1
	movi	do_fatality_2,a7
	jruc	fatality_xfer_close


st_lp_open
	movi	l_lp,a0
	calla	get_tsl			; a1 = amount of time passed since
	cmpi	>40*15,a1		; super long ?
	jrlo	death			; no

	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	calla	get_x_dist
	cmpi	>50,a3
	jrlo	death
	cmpi	>78,a3
	jrhi	death

	movi	do_kintaro_fatal,a7
	jruc	fatality_xfer




st_hp_open
	movi	l_hp,a0
	calla	get_tsl			; a1 = amount of time passed since

	cmpi	>30,a1			; within time frame ?
	jrlo	death			; no ---> ignore

	movi	do_st_2_fn2,a7
	jruc	restricted_xfer


fn2_hk_open
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	l_lk,a0
	calla	get_tsl
	cmpi	>80,a1			; held for 2 seconds ?
	jrlo	death			; no

	movi	>45,a1
	movi	do_fatality_2,a7
	jruc	fatality_xfer_close



fn2_hp_open
	movi	l_hp,a0
	calla	get_tsl			; a1 = amount of time passed since

	cmpi	>22,a1			; within time frame ?
	jrlo	death			; no ---> ignore
	movi	do_throw_sai,a7
	jruc	airborn_xfer

bo_lo_punch
	movi	char_lop_open,a1
	jruc	charjmp

char_lop_open
	.long	hh_lp_open		; 0 - hathead
	.long	sucide			; 1 - kang
	.long	jc_lp_open		; 2 - cage
	.long	sucide			; 3 - sword arm dude
	.long	sucide			; 4 - female ninja #1
	.long	sucide			; 5 - female ninja #2
	.long	st_lp_open		; 6 - shang
	.long	sucide			; 7
	.long	sz_lp_open		; 8
	.long	sucide			; 9
	.long	sucide			; 10
	.long	jx_lp_open		; 11


jx_block
	calla	distance_from_ground
	cmpi	>a0,a0			; high enough off ground ?
	jrlo	death			; no

	calla	get_x_dist
	cmpi	>60,a3	  		; close enough ?
	jrhi	death			; no
	calla	get_y_dist
	cmpi	>60,a3	  		; close enough ?
	jrhi	death			; no

	move	*a10(oypos),a2,w
	move	@ground_y,a0,w
	sub	a2,a0
	cmpi	>b0,a0			; high enough off ground ?
	jrlo	death			; no

	calla	is_he_a_boss
	jrc	death			; boss = sorry jax !!!

	movi	do_back_breaker,a7
	jruc	airborn_xfer




jx_lp_open
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	l_lp,a0
	calla	get_tsl			; a1 = amount of time passed since
	cmpi	>40,a1			; within time frame ?
	jrlo	death			; no ---> ignore

	movi	f1b0|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b2|f2b3|f2b4,a1
	movi	scom_jx_db1,a11
	callr	combo_look_lr
	jrnc	death

	movi	>53,a1
	movi	do_fatality_1,a7
	jruc	fatality_xfer_close


jc_lp_open
	jruc	death

;*****************************************************************

bo_lo_kick
	movi	char_lok_open,a1
	jruc	charjmp

char_lok_open
	.long	sucide			; 0 - hathead
	.long	lk_lk_open		; 1 - kang
	.long	sucide			;
	.long	sucide			;
	.long	fn1_lk_open		;
	.long	sucide			;
	.long	sucide			;
	.long	rd_lk_open	 	; 7
	.long	sucide			;
	.long	sucide			;
	.long	sucide			;
	.long	jx_lk_open		;

lk_down
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	f1b0|f1b1|f1b3|f1b4,a0
	movi	f2b0|f2b1|f2b3|f2b4,a1
	movi	scom_lk_db2,a11
	callr	combo_look_lr		; death blow ??
	jrnc	death			; no

	movi	>c8,a1
	movi	do_fatality_2,a7
	jruc	fatality_xfer_close


lk_lk_open
	movi	l_lk,a0
	calla	get_tsl			; a1 = amount of time passed since
	cmpi	>40*2,a1		; more than 2 seconds ago
	jrlo	death			; no ---> ignore
	movi	do_bicycle,a7
	jruc	restricted_xfer

**************************************************************************
*											     *
*  Character specific stuff starts here !						     *
*											     *
**************************************************************************

fn2_lo_kick
	movi	f1b1|f1b2|f1b3,a0
	movi	f2b1|f2b2|f2b3,a1
	movi	scom_fn2_teleport,a11
	callr	combo_look_lr
	jrnc	fn2lk3

	movi	do_fn2_teleport,a7
	jruc	restricted_xfer

fn2lk3	movi	f1b0|f1b1|f1b2|f1b3,a0
	movi	f2b0|f2b1|f2b2|f2b3,a1
	movi	scom_fn2_dtp,a11
	jruc	check_dtp



fn2_hi_kick
	movi	f1b1|f1b2|f1b4,a0
	movi	f2b1|f2b2|f2b4,a1
	movi	scom_kano,a11
	callr	combo_look_lr
	jrnc	fn2hk3

	movi	l_kano,a0
	calla	get_tsl
	cmpi	>20,a1
	jrlo	fn2hk3			; not too fast now

	movi	do_fn2_kano,a7
	jruc	restricted_xfer

fn2hk3	calla	bb_check
	calla	fs_check
	jruc	death



fn1_hi_kick
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	fn1hk3			; only during "finish him" mode

	calla	get_x_dist
	cmpi	>48,a3
	jrhi	fn1hk3

	movi	bcom_fn1_db2,a11
	callr	button_look_lr
	jrnc	fn1hk3	      		; no

	movi	do_fatality_2,a7
	jruc	fatality_xfer


fn1hk3	movi	f1b0|f1b1|f1b2|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b4,a1
	movi	scom_fn1_dtp,a11
	jruc	check_dtp


fn1_lo_kick
	calla	bb_check
	calla	fs_check
	jruc	death


fn1_lk_open
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	f1b0|f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_fn1_db,a11
	callr	combo_look_lr
	jrnc	death

	movi	l_lk,a0
	calla	get_tsl
	cmpi	>38,a1
	jrlo	death 			; gotta charge this puppy

	movi	>45,a1
	movi	do_fatality_1,a7
	jruc	fatality_xfer_close


fn1_hi_punch
	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_square,a11
	callr	combo_look_lr
	jrnc	fn1hp4

	movi	do_square_wave,a7
	jruc	restricted_xfer

fn1hp4
	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_spinfan,a11
	callr	combo_look_lr
	jrnc	fn1hp3

	calla	is_he_helpless
	jrc	fn1hp3

;	calla	get_his_action		; a1 = his action
;	cmpi	act_wave_sd,a1
;	jreq	fn1hp3			; dont allow double trap shit

	movi	do_spinfan,a7
	jruc	restricted_xfer

fn1hp3	movk	sw_lo_punch,a5		; look for this button
	jruc	fn1lp3


fn1_lo_punch
;	movk	sw_hi_punch,a5		; look for this button
	clr	a5

fn1lp3	callr	two_button_check	; made also ?
	jrnc	death

	movi	f1b2|f1b3|f1b4,a0
	movi	f2b2|f2b3|f2b4,a1
	movi	scom_throw_fan,a11
	callr	combo_look_lr
	jrnc	death

	movi	l_throw_fan,a0
	calla	get_tsl			; a1 = amount of time passed since
	cmpi	>40*2,a1		; more than 2 seconds ago
	jrlo	death			; no ---> ignore

	movi	do_throw_fans,a7
	jruc	airborn_xfer


fn2_lo_punch
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	f1b0|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b2|f2b3|f2b4,a1
	movi	scom_fn2_db,a11
	callr	combo_look_lr
	jrnc	death

	movi	>4c,a1
	movi	do_fatality_1,a7
	jruc	fatality_xfer_close

;*********************************************************************

sz_hi_kick
	movi	f1b0|f1b1|f1b2|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b4,a1
	movi	scom_super_ice,a11
	callr	combo_look_lr
	jrnc	szhk3

	calla	get_x_dist
	cmpi	>70,a3
	jrlo	szhk3
	cmpi	>c0,a3
	jrhi	szhk3

	movi	do_super_freeze,a7
	jruc	fatality_xfer

szhk3	calla	bb_check
	calla	fs_check
	jruc	death


sz_hi_punch
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_sz_db1,a11
	callr	combo_look_lr
	jrnc	death

	calla	get_his_action
	cmpi	act_super_froze,a1
	jrne	death

	movi	>45,a1
	movi	do_fatality_1,a7
	jruc	fatality_xfer_close
	

sz_block
;	callr	slide_check

rp_block
	callr	slide_check

check_nj_dtp
	movi	f1b0|f1b1|f1b3|f1b4,a0
	movi	f2b0|f2b1|f2b3|f2b4,a1
	movi	scom_nj_dtp,a11
	jruc	check_dtp


rp_lo_kick
	callr	slide_check
	calla	bb_check
	calla	fs_check
	jruc	death



sz_lo_kick
	callr	slide_check

	movi	f1b0|f1b1|f1b2|f1b3,a0
	movi	f2b0|f2b1|f2b2|f2b3,a1
	movi	scom_floor_ice,a11
	callr	combo_look_lr
	jrnc	death

	movi	pid_floor_ice1,a0
	movi	pid_floor_ice2,a1
	calla	p1p2_pick		; a0 = correct pid
	clr	a1	
	not	a1
	calla	existp			; only once floor ice at a time !
	jrne	death

	calla	get_his_action
	cmpi	act_frozen,a1		; he is frozen = no floor ice
	jreq	death

	movi	l_pud,a0
	calla	get_tsl
	cmpi	>40*3,a1
	jrlo	death

	calla	get_his_dfe
	cmpi	>60,a5
	jrlo	death
	cmpi	>60,a6
	jrlo	death			; he is too close to edge

	movi	do_floor_ice,a7
	jruc	restricted_xfer


sz_lo_punch
	callr	slide_check

	movi	f1b0|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b2|f2b3|f2b4,a1
	movi	scom_ice_ball,a11
	callr	combo_look_lr
	jrnc	death

	movi	pid_floor_ice1,a0
	movi	pid_floor_ice2,a1
	callr	does_p1p2_exist
	jrc	death			; ice already out there ---> exit

	movi	pid_ice1,a0
	movi	pid_ice2,a1
	callr	does_p1p2_exist
	jrc	death			; ice already out there ---> exit

	movi	do_throw_ice,a7
	jruc	restricted_xfer


slide_check
	calla	is_stick_away
	jrnc	slide_no

	movi	p1b2,a0
	movi	p1b1|p1b4,a1
	movi	p2b2,a2
	movi	p2b1|p2b4,a3
	callr	button_bit_check
	jrnc	slide_no

	pull	a0			; no deposit, no return
	movi	do_slide,a7
	jruc	restricted_xfer

slide_no
	rets


sz_lp_open
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	l_lp,a0
	calla	get_tsl
	cmpi	>30,a1
	jrlo	death			; not held long enough

	calla	get_x_dist
	cmpi	>100,a3
	jrlo	death

	movi	f1b0|f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_sz_db2,a11
	callr	combo_look_lr
	jrnc	death			; no

	movi	do_fatality_2,a7
	jruc	fatality_xfer

;**********************************************************************

rp_lo_punch
	callr	slide_check

	movi	f1b2|f1b3|f1b4,a0
	movi	f2b2|f2b3|f2b4,a1
	movi	scom_slow_proj,a11
	callr	combo_look_lr
	jrnc	reptile_db_check

	callr	get_bcq_next_pointer
	callr	previous_q_entry	; skip me
	callr	previous_q_entry	; a0 = previous [switch,time]
	move	a0,a1
	srl	16,a0
	cmpi	sw_hi_punch,a0		; last button hi punch ?
	jrne	death			; no
	zext	a1,w
	move	@tick,a0,w
	sub	a1,a0
	cmpi	4,a0			; within time frame ?
	jrhi	death			; no

	movi	pid_orb1,a0
	movi	pid_orb2,a1
	calla	p1p2_pick
	clr	a1
	not	a1
	calla	existp
	jrne	death			; only 1 orb at a time

	movi	do_slow_proj,a7
	jruc	restricted_xfer


reptile_db_check
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	f1b0|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b2|f2b3|f2b4,a1
	movi	scom_rp_db1,a11
	callr	combo_look_lr
	jrnc	death			; no

	move	*a8(oflags2),a0,w
	btst	b_inviso,a0
	jrne	death			; not allowed when invisible

	calla	get_x_dist
	cmpi	>a0,a3
	jrlo	death
	cmpi	>e0,a3
	jrhi	death			; must be within range

	movi	do_fatality_1,a7
	jruc	fatality_xfer

**************************************************************************
*											     *
*  button_bit_check - Checks if a specific pattern of buttons are being  *
*                     pressed.								     *
* 											     *
*  Input: a0 = player 1 port #1								     *
*         a1 = player 1 port #2								     *
*         a2 = player 2 port #1								     *
*         a3 = player 2 port #2								     *
*											     *
**************************************************************************
button_bit_check
	move	*a13(p_store4),a4,l
	move	*a4(procid),a4,w
	cmpi	pid_p1,a4		; player 1 ?
	jreq	bbc3			; yes
	move	a2,a0
	move	a3,a1			; player 2 bits
bbc3	move	@switch,a2,l
	move	@switch2,a3,l		; grab states of both ports
	not	a2
	not	a3
*	
* port #1
*
	and	a0,a2			; look only at our bits
	cmp	a0,a2			; same ?
	jrne	bbc_no			; no
*
* port #2
*
	and	a1,a3			; look only at our bits
	cmp	a1,a3			; same ?
	jrne	bbc_no			; no
	setc				; yes = carry set
	rets

bbc_no	clrc
	rets

;*********************************************************************

st_block
	movi	bcom_st_2_fn1,a11
	callr	button_look_lr
	jrnc	stblk3				; no
	movi	do_st_2_fn1,a7
	jruc	restricted_xfer


stblk3
	movi	f1b0|f1b1|f1b3|f1b4,a0
	movi	f2b0|f2b1|f2b3|f2b4,a1
	movi	scom_st_2_lk,a11
	callr	combo_look_lr
	jrnc	death

	movi	do_st_2_lk,a7
	jruc	restricted_xfer


st_hi_punch
	movi	l_hp,a0
	calla	update_tsl

	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_st_2_sz,a11
	callr	combo_look_lr
	jrnc	sthp3

	movi	do_st_2_sz,a7
	jruc	restricted_xfer

sthp3
	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_st_zap,a11
	callr	combo_look_lr
	jrnc	sthp5

	movi	do_st_zap1,a7
	jruc	restricted_xfer

sthp5
	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_st_2_rp,a11
	callr	combo_look_lr
	jrnc	sthp7

	movi	do_st_2_rp,a7
	jruc	restricted_xfer

sthp7
	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_st_zap2,a11
	callr	combo_look_lr
	jrnc	sthp9

	movi	do_st_zap2,a7
	jruc	restricted_xfer

sthp9	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_st_zap3,a11
	callr	combo_look_lr
	jrnc	death

	movi	do_st_zap3,a7
	jruc	restricted_xfer


sa_block
	jruc	death

	movi	l_block,a0
	calla	get_tsl
	move	a1,a5			; a5 = ticks since last block

	movi	l_block,a0
	calla	update_tsl		; update for next time

	cmpi	10,a5			; quick tap since last block ?
	jrhi	sa_slow_block		; no, reset counter

	movi	c_p1p2_fastblk,a0
	callr	getram_p1p2
	move	*a0,a1,w
	inc	a1
	cmpi	3,a1			; 4 in a row ?
	jrlo	slowb3

	movi	l_spin,a0
	calla	get_tsl
	cmpi	>60,a1
	jrlo	sa_slow_block		; too soon since last time

	movi	do_spin,a7
	jruc	restricted_xfer

sa_slow_block
	movi	c_p1p2_fastblk,a0
	callr	getram_p1p2
	clr	a1
slowb3	move	a1,*a0,w		; fast block tap count = 0
	jruc	death


sa_hi_kick
	calla	bb_check
	calla	fs_check

	movi	f1b0|f1b1|f1b2|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b4,a1
	movi	scom_sa_dtp,a11
	jruc	check_dtp

sa_lo_punch
	movi	f1b0|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b2|f2b3|f2b4,a1
	movi	scom_shred,a11
	callr	combo_look_lr
	jrnc	salop4

	movi	do_shred,a7
	jruc	restricted_xfer

salop4	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	f1b0|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b2|f2b3|f2b4,a1
	movi	scom_sa_stab,a11
	callr	combo_look_lr
	jrnc	death

	movi	>88,a1
	movi	do_fatality_2,a7
	jruc	fatality_xfer_close


sa_hi_punch
	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_spark,a11
	callr	combo_look_lr
	jrnc	sahp3

	movi	do_sa_zap,a7
	jruc	restricted_xfer


sahp3	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_sa_decap,a11
	callr	combo_look_lr
	jrnc	death

	movi	>63,a1
	movi	do_fatality_1,a7
	jruc	fatality_xfer_close


jc_up
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	f1b0|f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_jc_db2,a11
	callr	combo_look_lr
	jrnc	death			; no

	movi	>48,a1
	movi	do_fatality_2,a7
	jruc	fatality_xfer_close


jc_hi_kick
	calla	bb_check
	calla	fs_check

	movi	f1b0|f1b1|f1b2|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b4,a1
	movi	scom_jc_dtp,a11
	jruc	check_dtp


jc_hi_punch
	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_jc_zaphi,a11
	callr	combo_look_lr
	jrnc	jchip3			; no

	movi	do_jc_zaphi,a7
	jruc	restricted_xfer

jchip3
	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_jc_shoruken,a11
	callr	combo_look_lr		; shoruken ?
	jrnc	death			; no

	movi	do_jc_shoruken,a7
	jruc	restricted_xfer


jc_block
	movk	sw_lo_punch,a5		; look for this button
	callr	two_button_check	; made also ?
	jrnc	death			; no
	movi	do_jc_split,a7
	jruc	restricted_xfer		; yes, splits

;************************************************************************

sc_hi_kick
	calla	bb_check
	calla	fs_check
	jruc	death

sc_hp_open
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	l_hp,a0
	calla	get_tsl			; a1 = amount of time passed since
	cmpi	>28,a1			; within time frame ?
	jrlo	death			; no ---> ignore

	movi	f1b0|f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_sc_db2,a11
	callr	combo_look_lr
	jrnc	death

	movi	>45,a1
	movi	do_fatality_2,a7
	jruc	fatality_xfer_close


sc_lo_kick
	movi	f1b0|f1b1|f1b2|f1b3,a0
	movi	f2b0|f2b1|f2b2|f2b3,a1
	movi	scom_scissor,a11
	callr	combo_look_lr
	jrnc	death

	movi	do_scissor_kick,a7
	jruc	restricted_xfer


sc_lo_punch
	movi	f1b2|f1b3|f1b4,a0
	movi	f2b2|f2b3|f2b4,a1
	movi	scom_spear,a11
	callr	combo_look_lr
	jrnc	death

	movi	l_spear,a0
	calla	get_tsl
	cmpi	>66,a1		; too soon ?
	jrlo	death		; yes, abort, abort

	movi	do_spear,a7
	jruc	restricted_xfer



sc_hi_punch
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	schp3			; only during "finish him" mode

	movi	f1b1|f1b3|f1b4,a0
	movi	f2b1|f2b3|f2b4,a1
	movi	scom_sc_toasty,a11
	callr	combo_look_lr
	jrc	xfer_sc_toast

	movi	f1b1|f1b3|f1b4,a0
	movi	f2b1|f2b3|f2b4,a1
	movi	scom_sc_db1,a11
	callr	combo_look_lr
	jrnc	schp3

	calla	get_x_dist
	cmpi	>90,a3
	jrlo	schp3
	calla	get_x_dist
	cmpi	>b0,a3
	jrhi	schp3	  		; must be in window of >70 to >9d !!
	
	clr	a0
schp1	move	*a13(p_store4),a1,l
	move	a0,*a1(p_store6),w	; flag: no toasty
	movi	do_fatality_1,a7
	jruc	fatality_xfer

;*****************************

xfer_sc_toast
	movk	1,a0
	jruc	schp1

;*****************************

schp3
	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_decoy,a11
	callr	combo_look_lr
	jrnc	death

	movi	l_decoy,a0
	calla	get_tsl
	cmpi	>60,a1			; too soon ?
	jrlo	death			; yes, abort, abort

	movi	do_decoy,a7
	jruc	airborn_xfer


sc_block
	calla	distance_from_ground
	cmpi	>a0,a0			; high enough off ground ?
	jrlo	check_nj_dtp		; no

	calla	get_x_dist
	cmpi	>60,a3	  		; close enough ?
	jrhi	death			; no
	calla	get_y_dist
	cmpi	>60,a3	  		; close enough ?
	jrhi	death			; no

	move	*a10(oypos),a2,w
	move	@ground_y,a0,w
	sub	a2,a0
	cmpi	>a0,a0			; high enough off ground ?
	jrlo	death			; no

	calla	is_he_a_boss
	jrc	death			; boss = sorry scorpion !!!

	move	*a13(p_store4),a1,l
	move	*a1(p_action),a1,w
	cmpi	act_fk_sd,a1
	jreq	death			; sorry, but that was not fair !!

	movi	do_air_body_slam,a7
	jruc	airborn_xfer

;************************************************************************

jx_hi_kick
	movi	f1b1|f1b2,a0
	movi	f2b1|f2b2,a1
	movi	scom_jax_zap,a11
	callr	combo_look_lr
	jrnc	death			; no

	movi	do_jx_zap,a7
	jauc	restricted_xfer


jx_hi_punch
	movi	l_hp,a0
	calla	update_tsl		; mark this event
	jruc	death


jx_lo_punch
	movi	l_lp,a0
	calla	update_tsl		; mark this event

	movi	f1b0|f1b2|f1b3,a0
	movi	f2b0|f2b2|f2b3,a1
	movi	scom_noogy,a11
	callr	combo_look_lr
	jrnc	jxlp2			; no

	movi	do_noogy,a7
	jruc	restricted_xfer

jxlp2	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	calla	get_x_dist
	cmpi	>80,a3
	jrhi	death

	cmpi	>45,a3
	jrlo	death

	movi	f1b0|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b2|f2b3|f2b4,a1
	callr	button_mask
	jrne	death

	movi	bcom_jx_db2,a11
	callr	button_look_lr
	jrnc	death	      		; no

	movi	do_fatality_2,a7
	jruc	fatality_xfer



jx_lo_kick
	calla	bb_check
	calla	fs_check

	movi	f1b0|f1b1|f1b3,a0
	movi	f2b0|f2b1|f2b3,a1
	movi	scom_jx_dtp,a11
	jruc	check_dtp


jx_lk_open
	movi	l_lk,a0
	calla	get_tsl			; a1 = charge value
	cmpi	>60,a1
	jrlo	death			; not enough !!

	movi	do_joy_quake,a7	
	jruc	restricted_xfer

;************************************************************************

jc_lo_punch
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	jclop2			; only during "finish him" mode

	movi	f1b0|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b2|f2b3|f2b4,a1
	movi	scom_jc_db1,a11
	callr	combo_look_lr
	jrnc	jclop2			; no

	calla	get_x_dist
	cmpi	>44,a3
	jrhi	jclop2

	movi	do_fatality_1,a7
	jruc	fatality_xfer


jclop2
	movi	f1b0|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b2|f2b3|f2b4,a1
	movi	scom_jc_zaplo,a11
	callr	combo_look_lr
	jrnc	jclop3			; no
	movi	do_jc_zaplo,a7
	jruc	restricted_xfer

jclop3	movk	sw_block,a5		; look for this button
	callr	two_button_check	; made also ?
	jrnc	death			; no
	movi	do_jc_split,a7
	jruc	restricted_xfer		; yes, splits


st_lo_punch
	movi	f1b0|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b2|f2b3|f2b4,a1
	movi	scom_st_2_jc,a11
	callr	combo_look_lr
	jrnc	death				; no

	movi	do_st_2_jc,a7
	jruc	restricted_xfer


rd_lo_punch
	movi	f1b2|f1b3|f1b4,a0
	movi	f2b2|f2b3|f2b4,a1
	movi	scom_lightning,a11
	callr	combo_look_lr
	jrnc	death 			; no

	movi	do_throw_lightning,a7
	jruc	restricted_xfer

rd_hi_punch
	movi	f1b1|f1b3|f1b4,a0
	movi	f2b1|f2b3|f2b4,a1
	movi	scom_rd_dtp,a11
	jruc	check_dtp


rp_hi_punch
	movi	f1b1|f1b3|f1b4,a0
	movi	f2b1|f2b3|f2b4,a1
	movi	scom_inviso,a11
	callr	combo_look_lr
	jrnc	rphp4			; no

	movi	do_inviso,a7
	jruc	restricted_xfer


rphp4
	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_spit,a11
	callr	combo_look_lr
	jrnc	death			; no

	movi	do_spit,a7
	jruc	restricted_xfer


rp_hi_kick
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	f1b0|f1b1|f1b2|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b4,a1
	movi	scom_rp_db2,a11
	callr	combo_look_lr
	jrnc	death			; no

	move	*a8(oflags2),a0,w
	btst	b_inviso,a0
	jreq	death

	movi	>45,a1
	movi	do_fatality_2,a7
	jruc	fatality_xfer_close

**************************************************************************
*											     *
*  two_button_check - Check if another button is "pressed at the same ti *
* 											     *
*  Input: a5 = other button (in sw_ equated format)				     *
* 											     *
*  Returns: Carry set = yes								     *
*											     *
**************************************************************************
two_button_check
	move	@tick,a4,w		; a4 = current tick state
	callr	get_bcq_next_pointer
	callr	previous_q_entry	; a0 = previous [switch,time]
	callr	previous_q_entry	; a0 = previous [switch,time]

	move	a0,a2
	srl	16,a0			; a0 = last button
	cmp	a5,a0			; last button = other button ??
	jrne	tbcno			; no
	zext	a2,w			; a2 = tick state of last button
	sub	a2,a4			; a4 = elapsed time
	cmpi	2,a4
	jrhi	tbcno			; too much time !!

	setc
	rets

tbcno	clrc
	rets



jc_lo_kick
	movi	f1b0|f1b1|f1b2|f1b3,a0
	movi	f2b0|f2b1|f2b2|f2b3,a1
	movi	scom_jc_shadow,a11
	callr	combo_look_lr
	jrnc	death				; no
	movi	do_shadow_kick,a7
	jruc	restricted_xfer


lk_lo_kick
	calla	bb_check
	calla	fs_check

	movi	f1b0|f1b1|f1b2|f1b3,a0
	movi	f2b0|f2b1|f2b2|f2b3,a1
	movi	scom_lk_dtp,a11
	jruc	check_dtp

		      
st_lo_kick
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	stlk2				; only during "finish him" mode

	movi	f1b0|f1b1|f1b3,a0
	movi	f2b0|f2b1|f2b3,a1
	movi	scom_st_db1,a11
	callr	combo_look_lr
	jrnc	stlk2				; no
	calla	get_x_dist
	cmpi	>50,a3
	jrhi	stlk2

	movi	do_fatality_1,a7
	jruc	fatality_xfer

stlk2
	movi	f1b0|f1b1|f1b2|f1b3,a0
	movi	f2b0|f2b1|f2b2|f2b3,a1
	movi	scom_st_2_rd,a11
	callr	combo_look_lr
	jrnc	stlk3				; no

	movi	do_st_2_rd,a7
	jruc	restricted_xfer

stlk3
	movi	f1b0|f1b1|f1b2|f1b3,a0
	movi	f2b0|f2b1|f2b2|f2b3,a1
	movi	scom_st_2_sa,a11
	callr	combo_look_lr
	jrnc	death				; no

	movi	do_st_2_sa,a7
	jruc	restricted_xfer


st_hi_kick
	movi	f1b0|f1b1|f1b2|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b4,a1
	movi	scom_st_2_hh,a11
	callr	combo_look_lr
	jrnc	sthk3				; no

	movi	do_st_2_hh,a7
	jruc	restricted_xfer

sthk3	movi	f1b0|f1b1|f1b2|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b4,a1
	movi	scom_st_2_jx,a11
	callr	combo_look_lr
	jrnc	sthk5				; no

	movi	do_st_2_jx,a7
	jruc	restricted_xfer

sthk5	calla	bb_check
	calla	fs_check
	jruc	death


lk_hi_punch
	movi	f1b1|f1b2|f1b3,a0
	movi	f2b1|f2b2|f2b3,a1
	movi	scom_lk_zaphi,a11
	callr	combo_look_lr
	jrnc	death			; no

	movi	do_lk_zaphi,a7
	jruc	airborn_xfer

lk_lo_punch
	movi	f1b0|f1b2|f1b3,a0
	movi	f2b0|f2b2|f2b3,a1
	movi	scom_lk_zaplo,a11
	callr	combo_look_lr
	jrnc	death			; no
	movi	do_lk_zaplo,a7
	jruc	restricted_xfer

lk_hi_kick
	movi	f1b0|f1b1|f1b2,a0
	movi	f2b0|f2b1|f2b2,a1
	movi	scom_lk_flykick,a11
	callr	combo_look_lr
	jrnc	lkhk3			; no

	movi	do_lk_super,a7
	jruc	restricted_xfer

lkhk3	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	f1b0|f1b1|f1b2|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b4,a1
	movi	scom_lk_db1,a11
	callr	combo_look_lr
	jrnc	death			; no

	movi	>70,a1
	movi	do_fatality_1,a7
	jruc	fatality_xfer_close

;**************************************************************************

hh_lp_open
	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

	movi	l_lp,a0
	calla	get_tsl
	cmpi	>30,a1
	jrlo	death			; not held long enough

	calla	get_x_dist
	cmpi	>100,a3
	jrlo	death

	movi	f1b0|f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_hh_db2,a11
	callr	combo_look_lr
	jrnc	death			; no

	movi	do_fatality_2,a7
	jruc	fatality_xfer



hh_hi_punch
	movi	f1b1|f1b2|f1b3|f1b4,a0
	movi	f2b1|f2b2|f2b3|f2b4,a1
	movi	scom_hh_dtp,a11
	jruc	check_dtp


hh_hi_kick
	calla	fs_check
	calla	bb_check

	movi	f1b0|f1b1|f1b2|f1b4,a0
	movi	f2b0|f2b1|f2b2|f2b4,a1
	movi	scom_super_rep,a11
	callr	combo_look_lr
	jrnc	death				; no
	calla	distance_from_ground
	cmpi	>a0,a0
	jrlo	death				; must be at a certain height

	movi	do_reptile_superk,a7
	jruc	airborn_xfer


hh_lo_kick
	movi	f1b0|f1b1|f1b2|f1b3,a0
	movi	f2b0|f2b1|f2b2|f2b3,a1
	movi	scom_hh_spin,a11
	callr	combo_look_lr
	jrnc	hhlk3			; no

	movi	do_hh_spin,a7
	jruc	restricted_xfer

hhlk3	movi	f1b0|f1b1|f1b2|f1b3,a0
	movi	f2b0|f2b1|f2b2|f2b3,a1
	movi	scom_hh_db1,a11
	callr	combo_look_lr
	jrnc	death			; no

	calla	get_x_dist
	cmpi	>80,a3
	jrhi	death			; 2 far apart
	cmpi	>60,a3
	jrlo	death

	movi	do_fatality_1,a7
	jruc	fatality_xfer

hh_lo_punch
	movi	f1b0|f1b2|f1b3|f1b4,a0
	movi	f2b0|f2b2|f2b3|f2b4,a1
	movi	scom_hh_throw,a11
	callr	combo_look_lr		; hat head throw yer hat ?
	jrnc	death			; no

	movi	do_hh_throw,a7
	jruc	restricted_xfer

**************************************************************************
*											     *
*                    Body propelling moves						     *
*                    Body propelling moves						     *
*                    Body propelling moves						     *
*											     *
**************************************************************************
do_propell_a0
	jauc	do_body_propell

do_scissor_kick
	clr	a0
	jruc	do_propell_a0

do_fn2_teleport
	movk	1,a0
	jruc	do_propell_a0

do_fn2_kano
	movk	2,a0
	jruc	do_propell_a0

do_reptile_superk
	movk	3,a0
	jruc	do_propell_a0

do_decoy
	movk	4,a0
	jruc	do_propell_a0

do_slide
	movk	5,a0
	jruc	do_propell_a0

do_jc_shoruken
	movk	6,a0
	jruc	do_propell_a0

do_bicycle
	movk	7,a0
	jruc	do_propell_a0

do_shadow_kick
	movk	8,a0
	jruc	do_propell_a0

do_lk_super
	movk	9,a0
	jruc	do_propell_a0

do_hh_teleport
	movk	>0a,a0
	jruc	do_propell_a0

do_square_wave
	movk	>0b,a0
	jruc	do_propell_a0

;do_raiden_dive
;	movk	>0c,a0
;	jruc	do_propell_a0

do_raiden_melt
	movk	>0d,a0
	jruc	do_propell_a0

**************************************************************************
*											     *
*                        begin special moves					     *
*                        begin special moves					     *
*                        begin special moves					     *
*											     *
**************************************************************************

do_hh_spin
	movi	act_hhspin,a1
	callr	init_special_act

	movk	1,a9
	calla	get_char_ani2
	movk	2,a0
	calla	init_anirate
	movk	1,a11
*
* spin without need to tap button
*
	movk	20,a0
hhspin3	move	a0,*a13(p_store1),l
	sleep	1
	callr	spin_cycle
	move	*a13(p_store1),a0,w
	dsjs	a0,hhspin3
*
* now you gotta keep tapping !!
*
hhspin4	sleep	1
	callr	spin_cycle
	movi	l_lk,a0
	calla	get_tsl
	cmpi	>0e,a1			; still tapping button ?
	jrhi	hhspin_hit		; no, exit
	movi	>11,a0
	calla	strike_check_a0
	jrnc	hhspin4


hhspin_hit
	movk	3,a0
	calla	init_anirate
	movi	>20,a11
hhspin7	sleep	1
	calla	next_anirate
	dsjs	a11,hhspin7
	jruc	reaction_exit



spin_cycle
	calla	next_anirate
	dsjs	a11,spinc3
	tsound	>be				; spin sound
	create	pid_fx,spin_aura_left
	move	a8,*a0(pa11),l
	create	pid_fx,spin_aura_right
	move	a8,*a0(pa11),l
	movk	14,a11
spinc3	rets


spin_aura_right
	callr	get_aura
	calla	flip_single
	clr	a1
	movi	->28,a0
	calla	multi_adjust_xy
	jruc	aura2

spin_aura_left
	callr	get_aura
aura2	calla	insobja8
	movi	ft_hathead,a0
	move	a0,*a8(ochar),w
	movk	2,a9
	calla	get_char_ani2
	movk	4,a0
	jsrp	framew
	move	a8,a0
	calla	delobjp
	die

get_aura
	movi	TMAURA1,a5
	calla	gso_dmawnz
	movi	oid_fx,a0
	move	a0,*a8(oid),w
	move	a11,a1
	move	a8,a0
	jauc	lineup_1pwm		; lineup with kung lao

**************************************************************************

do_noogy
	callr	init_special

	movk	>10,a0
	move	a0,*a13(p_stk),w	; define my stk table offset

	movk	1,a9
	calla	get_char_ani2
	movk	3,a0
	movi	act_noogy,a1
	jsrp    act_mframew		; reach out and grab someone

	movk	6,a11			; scan for this many frames
noog3	movi	>10,a0
	calla	strike_check_a0
	jrc	noogy_hit
	sleep	1
	dsjs	a11,noog3

*
* missed = retract
*
noogy_blocked
	movk	1,a9
	calla	get_char_ani2
	move	a9,a10
	addi	32,a9
	calla	do_next_a9_frame	; frame 2
	sleep	6
	move	a10,a9
	calla	do_next_a9_frame	; frame 1
	sleep	6
	retp


noogy_hit
	move	b2,b2
	jrne	noogy_blocked

	tsound	>89			; speech: gotcha !
	calla	me_in_front

	movi	noogy_suspended,a7
	calla	takeover_him

	push	a9
	movi	>10,a9
	calla	is_he_a_boss
	jrnc	noog2
	movi	>13,a9			; goro getting noggied
noog2	calla	get_his_char_ani
	move	a9,a11
	addi	32*3,a9	      		; hit hi frame 1
	calla	do_his_next_a9_frame
	pull	a9
	callr	noog_lineup_1
*
* check for edge of world shit
*
	calla	get_his_dfe		; a5 / a6
	cmpi	>40,a5
	jrlo	noog8
	cmpi	>40,a6
	jrhi	noog9

noog8	movi	>60000,a0
	calla	away_x_vel		; bacdafucup !!
	movk	8,a10
noog1	sleep	1
	callr	noog_lineup_1		; keep him lined up wid me
	dsj	a10,noog1
	calla	stop_me
 	callr	noog_lineup_1		; keep him lined up wid me

noog9	movi	>00030003,a0
	movk	3,a1
	move	*a13(p_otherguy),a10,l
	jsrp	shake_him_up
	sleep	2

	calla	do_next_a9_frame
	movi	>00080035,a0
	calla	adjust_him_a0
	sleep	10
*
* pow pow pow !!
*
	clr	a0
	move	a0,*a13(p_store1),w	; flag: no exit

	movk	5,a0
noog5 	move	a0,*a13(p_anicount),w

	movk	2,a0
	jsrp	mframew			; wham !!

	movk	9,a0
	calla	damage_to_him
	tsound	>19

	movi	gotcha_react_voice,a0
	calla	calla_for_him				; scream for him

	move	*a13(p_anicount),a0,w
	cmpi	1,a0
	jreq	noogy_last_hit				; max hits ---> exit
	move	*a13(p_store1),a0,w
	jrne	noogy_last_hit				; not tapping button --> exit

	create	pid_fx,noogy_shaker
	move	*a13(p_otherguy),*a0(pa10),l

	pushp	a11
	movk	3,a0
	jsrp	double_mframew
	pullp	a11

	callr	noogy_early_check
	sleep	4
	callr	noogy_early_check
	sleep	4
	callr	noogy_early_check		; sleep 8

	move	*a13(p_anicount),a0,w
	dec	a0
	jruc	noog5


noog_lineup_1
	calla	match_him_with_me_f
	movi	>fff0ffa0,a7		; adjust him this much
	move	*a13(p_otherguy),a0,l
	move	*a0(ochar),a0,w
	cmpi	ft_final_boss,a0
	jrne	noog7
	movi	>ffd0ffa0,a7		; adjust him this much
	jruc	noog4
noog7	cmpi	ft_jax,a0
	jrne	noog4
	movi	>fff0ff90,a7		; jax adjust
noog4 	move	a7,a0
	calla	adjust_him_a0
	rets


gotcha_react_voice
	calla	am_i_a_boss
	jrc	grv3
	jauc	rsnd_wasted_voice
grv3	movi	ft_goro,a0
	calla	am_i_him
	jrnc	grv5

	movi	>000300ae,a0	; [total # of entries, 1st entry]
	calla	random_triple
	rets

grv5	tsound2	>3e
	rets



noogy_early_check
	movi	l_lp,a0
	calla	get_tsl		; mark this event
	cmpi	>08,a1		; still tapping ?
	jrlo	nec5		; no, exit
	movk	1,a0
	move	a0,*a13(p_store1),w	; flag: exit
nec5	rets

noogy_last_hit
	movi	r_last_noogy,a7
	calla	xfer_otherguy
	sleep	>10
	movk	5,a0
	jsrp	mframew			; get out of punch
	sleep	8
	retp

noogy_shaker
	movi	>00040006,a11
	calla	shake_a11
	movi	>00030005,a0
	movk	3,a1
	jsrp	shake_him_up
	die


noogy_suspended
	movk	4,a7
	move	a7,@f_norepell,w	; no repell while in this mode

	sleep	2
	calla	get_his_action
	cmpi	act_noogy,a1
	jreq	noogy_suspended
	jruc	reaction_exit

**************************************************************************

do_joy_quake
	jsrp	do_quake
	jauc	do_backup

do_quake
	movi	act_quake,a1
	callr	init_special_act	; i can't block !!

	movk	3,a9
	calla	get_char_ani2		; 1st frame of energy
	move	a9,a11
	calla	get_proj_obj_m
	move	a10,a0
	calla	insobj			; energy = on list

	clr	a9
	calla	get_char_ani2
	calla	double_next_a9
	sleep	10			; hold that fist up jax !!

	movk	2,a0
	jsrp	double_mframew		; wham !!

	mmtm	sp,a10,a11
	calla	is_he_airborn		; he in the air ?
	jrc	quake3			; yes, no damage
	calla	is_he_a_boss
	jrc	quake3			; yes, no damage

	movi	>15,a0
	calla	damage_to_him
	movi	r_quake,a7
	calla	takeover_him
quake3 	movi	>00090008,a11
	calla	shake_a11		; earthquake !!
	mmfm	sp,a10,a11

	tsound2	1			; boom sound

	movi	act_proj_sd,a1
	move	a1,*a13(p_action),w
	movk	6,a0
	jauc	double_mframew		; energy dissolving

**************************************************************************

do_random_morph
	movk	12,a0
	calla	randu
	dec	a0
	cmpi	6,a0
	jrne	drm5
	movk	5,a0		; morph to st = morph to mileena
drm5	move	a0,a9
	jruc	shang_morph


do_st_2_hh
	clr	a9
	jruc	shang_morph
do_st_2_lk
	movk	1,a9
	jruc	shang_morph
do_st_2_jc
	movk	2,a9
	jruc	shang_morph
do_st_2_sa
	movk	3,a9
	jruc	shang_morph
do_st_2_fn1
	movk	4,a9
	jruc	shang_morph
do_st_2_fn2
	movk	5,a9
	jruc	shang_morph
do_st_2_rd
	movk	7,a9
	jruc	shang_morph
do_st_2_sz
	movk	8,a9
	jruc	shang_morph
do_st_2_rp
	movk	9,a9
	jruc	shang_morph
do_st_2_sc
	movk	10,a9
	jruc	shang_morph
do_st_2_jx
	movk	11,a9
	jruc	shang_morph
*
* a0 = ochar of dude to turn into
*
shang_morph
	movi	act_morph,a1
	callr	init_special_act
	calla	stop_me

	tsound	>8d				; morph sound

	pushp	a9
	calla	get_char_ani2			; get animation
	calla	set_no_block			; no blocking while morphing

smorph2	movk	4,a0
	jsrp	mframew
	pullp	a9
	move	a9,*a8(ochar),w
	calla	ground_ochar				; new ground position
	move	*a8(oypos),*a13(p_ganiy),w    	; new grounded y pos

	move	*a13(p_otherguy),a1,l
	move	*a8(ochar),a0,w
	move	*a1(ochar),a1,w
	cmp	a0,a1		    		; are we the same person now ?
	jrne	smorph4		    		; no
	
	move	*a13(p_otherguy),a0,l	
	move	*a0(oflags2),a0,w
	btst	b_ugly_pal,a0			; yes, he using ugly pal ?
	jrne	smorph4				; yes...we are fine with original

;*******************
;	move	*a8(oflags2),a4,w
;	push	a4
;	ori	m_ugly_pal,a4
;	move	a4,*a8(oflags2),w		; trick next routine
;	calla	player_normpal			; switch to ugle pal
;	pull	a4
;	move	a4,*a8(oflags2),w		; restore original pal state
;	jruc	smorph5

	move	*a8(oflags2),a4,w
;	push	a4
	ori	m_ugly_pal,a4
	move	a4,*a8(oflags2),w		; trick next routine
	calla	player_normpal			; switch to ugly pal
;	pull	a4
;	move	a4,*a8(oflags2),w		; restore original pal state
	jruc	smorph5
;*******************


smorph4	calla	player_normpal			; new normal palette
smorph5	movi	l_morph,a0
	calla	update_tsl    			; mark this point
	retp

;***************************************************************************

do_spin
	movi	act_sa_spin,a1
	callr	init_special_act

	movk	3,a9
	calla	get_char_ani2

	movi	>00020005,a0
	jsrp	animate_a0_frames

	movk	2,a0
	calla	init_anirate
	calla	set_no_block

spin3	sleep	1

	movi	>15,a0
	calla	strike_check_a0
	jrc	spin_hit

	calla	next_anirate
	calla	am_i_joy
	jrnc	spin3

	callr	spin_continue_check
	jrhi	post_spin

	clr	a7
	calla	joystick_in_a0
	btst	bit_jright,a0
	jreq	spin4
	movi	>30000,a7
	jruc	spin5
spin4	btst	bit_jleft,a0
	jreq	spin5
	movi	->30000,a7
spin5	move	a7,a0
	calla	set_x_vel
	jruc	spin3


spin_hit
	movi	>40,a11			; max time cutting him up
spinh3	sleep	1
	calla	next_anirate
	callr	spin_continue_check	; still tapping button ?
	jrhi	post_spin		; no, exit
	dsj	a11,spinh3

post_spin
	movi	act_spin_sd,a0
	move	a0,*a13(p_action),w

	calla	stop_me
	movi	>00020003,a0
	jsrp	animate_a0_frames
	movi	>00030003,a0
	jsrp	animate_a0_frames
	movi	>00040003,a0
	jsrp	animate_a0_frames

	movi	l_spin,a0
	calla	update_tsl
	jruc	reaction_exit

spin_continue_check
	movi	c_p1p2_fastblk,a0
	callr	getram_p1p2
	clr	a1
	move	a1,*a0,w		; don't allow "restarting" 

	movi	l_block,a0
	calla	get_tsl
	cmpi	10,a1
	rets

;**********************************************************************

do_inviso
	callr	init_special			; i can't block !!

	movk	7,a9
	calla	get_char_ani2
	calla	do_next_a9_frame
	sleep	10
	calla	do_next_a9_frame
	create	pid_poof,fx_inviso_flame	; poof
	move	a8,*a0(pa10),l
	sleep	>0c

	move	*a8(oflags2),a4,w
	btst	b_inviso,a4
	jrne	do_un_inviso

	move	a8,a0
	calla	set_inviso

	movi	pid_inviso1,a0
	movi	pid_inviso2,a1
	calla	p1p2_pick		; a0 = correct pid
	move	a0,a1
	movi	inviso_proc,a7
	calla	getprc
	retp


do_un_inviso
	movi	pid_inviso1,a0
	movi	pid_inviso2,a1
	calla	p1p2_pick		; a0 = correct pid
	calla	dallprc			; kill
	clr	a9
	calla	get_char_ani2
	addi	32,a9
	calla	do_next_a9_frame	; pose: re-appear frame

	sleep	4
	move	a8,a0
	calla	clear_inviso
	sleep	12
	retp


inviso_proc
	sleep	2
	move	*a8(oflags2),a4,w
	btst	b_inviso,a4		; has someone else cleared this bit ?
	jreq	death	   		; yes, no need for me here
	move	@f_thatsall,a1,w
	jrne	now_i_see_ewe		; round over ---> no inviso
	jruc	inviso_proc

now_i_see_ewe
	move	a8,a0
	calla	clear_inviso
	jruc	death

**************************************************************************
*											     *
*  Throwing projectile moves	 							     *
*											     *
**************************************************************************
do_spit
	movk	>12,a0
	jruc	local_zap

do_st_zap3
	movk	>11,a0
	jruc	local_zap

do_st_zap2
	movk	>10,a0
	jruc	local_zap

do_sa_zap
	movi	>0f,a0
	jruc	local_zap

do_floor_ice
	movi	>0e,a0
	jruc	local_zap

do_throw_ice
	movi	>0d,a0
	jruc	local_zap

do_spear
	movi	>0c,a0
	jruc	local_zap

do_slow_proj
	movk	>0b,a0
	jruc	local_zap

do_st_zap1
	movk	9,a0
	jruc	local_zap

do_spinfan
	movk	>0a,a0
	jruc	local_zap

do_throw_sai
	movk	7,a0
	jruc	local_zap

do_throw_lightning
	movk	8,a0
	jruc	local_zap

do_throw_fans
	movk	6,a0
	jruc	local_zap

do_jc_zaplo
	movk	5,a0
	jruc	local_zap

do_jc_zaphi
	movk	4,a0
	jruc	local_zap

do_jx_zap
	movi	>14,a0
	jruc	local_zap

do_lk_zaphi
	calla	am_i_airborn
	jrc	lk_zapair

	movk	3,a0
	jruc	local_zap

lk_zapair
	movk	1,a0
	clr	a10
	jsrp	do_zap

	movk	6,a9
	calla	find_ani_last_frame
	clr	a0	 		; a0 = initial x vel
	clr	a1	  		; a1 = initial y vel
	movi	>c000,a2		; a2 = gravity	
	movk	6,a3			; a3 = ani speed
	jsrp	flight
	jsrp	do_land_animation
	jruc	reaction_exit	


do_lk_zaplo
	movk	2,a0
	jruc	local_zap

do_hh_throw
	clr	a0
	jruc	local_zap

local_zap
	clr	a10			; a10 = reverse flag = no
	jauc	do_zap

**************************************************************************
*											     *
*   standard moves									     *
*											     *
**************************************************************************
do_unblock_hi
	clr	a1
	move	a1,*a13(p_action),w
	movi	>0b,a9
	calla	find_ani_part2
	movk	4,a0
	jauc	mframew	  		; ani: standing unblock


do_block_hi
	calla	stop_me
	movi	>0b,a9
	calla	get_char_ani
	movk	3,a0
	movi	act_blockhi,a1
	jauc	act_mframew 		; block stance !


turn_around
	movi	>09,a9
turn5	calla	stop_me
	calla	disable_all_buttons
	calla	get_char_ani

	movi	ta_speeds,a0
	calla	get_char_long		; get my speed to animate
	move	a0,a10
	jsrp	mframew	     		; "turn around"

	move	a10,a0
	srl	16,a0
	jreq	turn9
	calla	prcslp

turn9	retp


duck_turnaround
	movi	>0a,a9
	calla	get_char_ani
	movk	2,a0
	jauc	mframew

*
* "turn around" speeds
*
ta_speeds
	.word	4,0	; hathead = 2 frames
	.word	2,0	; kang = 4 frames
	.word	2,0	; cage = 4 frames
	.word	2,2	; kano II = 3 frames
	.word	2,2	; female ninja = 3 frames
	.word	2,2	; female ninja = 3 frames
	.word	2,2	; shang tsung = 3 frames
	.word	2,2	; raiden = 3 frames
	.word	2,2
	.word	2,2
	.word	2,2	; ninjas = 3 frames
	.word	2,2	; jax = 3 frames

	.word	2,0	; goro
	.word	3,0	; shao kahn

	.word	2,2
	.word	2,2
	.word	2,2

;************************************************************

do_hi_kick
	callr	init_special			; i can't block !!

	movi	>0d,a9
	clr	a0
	move	a0,*a13(p_stk),w

	tsound	4
	calla	rsnd_attack

;	movi	hikick_ani_speeds,a0
;	calla	get_char_word		; a0 = ani speed

	movk	1,a0
 	clr	a11
	movi	act_hikick,a1

	jruc	kick2


do_lo_kick
	callr	init_special			; i can't block !!

	movi	>0e,a9
	movk	1,a0
	move	a0,*a13(p_stk),w

	tsound	4
	calla	rsnd_attack


;	movi	lokick_ani_speeds,a0
;	calla	get_char_word		; a0 = ani speed
	movk	1,a0

	movk	1,a11
	movi	act_medkick,a1

kick2	movk	6,a10
	jsrp	striker
	jrnc	kik3
	sleep	>12

kik3	movi	act_ret_kick,a1
	movk	4,a0
	jruc	retract_strike_act

do_sweep_kick
	callr	init_special

	movk	4,a0
	move	a0,*a13(p_stk),w

	move	*a13(p_otherguy),a0,l
	move	*a0(ochar),a0,w
	movk	3,a0			; speed
	movi	act_sweep,a1
	movi	>15,a9
	movk	1,a10
	movk	4,a11
	jsrp	behind_striker
	movk	5,a0			; miss retract speed timer
	jrnc	sweep3
      	sleep	6
	movk	6,a0  			; contact = finish animation slower
sweep3	movi	act_sweep_sd,a1		; flag: i am hittable
	jruc	retract_strike_act


do_duck_punch
	callr	init_special

	movk	3,a0
	movi	act_duckpunch,a1
	movk	>18,a9
	movk	1,a10
	movi	>05,a11
	move	a11,*a13(p_stk),w
	jsrp	striker
	movk	3,a0   		; retract speed
	jruc	retract_strike


do_duck_kickh
	callr	init_special

	movk	3,a0
	movi	act_duck_kickh,a1
	movk	>19,a9
	movk	5,a10
	movi	>06,a11		; changed so drones can stay altert after
	move	a11,*a13(p_stk),w
	jauc	striker


do_duck_kickl
	callr	init_special

	movk	2,a0
	movi	act_duck_kickl,a1
	movk	>1a,a9
	movk	2,a10
	movi	>07,a11		; changed so drones can stay altert after
	move	a11,*a13(p_stk),w
	jauc	striker


do_uppercut
	callr	init_special
	tsound	>04

	movk	>1c,a9	
	calla	do_first_a9_frame
	sleep	1
	calla	do_next_a9_frame
	sleep	1			; even FASTER uppercut !!!

	movk	2,a0
	movi	act_uppercut,a1
	movk	1,a10
	movi	>08,a11
	move	a11,*a13(p_stk),w
	jsrp	upcut_striker

	movi	act_upcut_sd,a0
	move	a0,*a13(p_action),w	; signal: i am a sitting duck
	
	movk	10,a0			; miss sleep
	jrnc	ucut4

	movk	18,a0			; blocked uppercut sleep time
	move	b2,b2			; blocked ?
	jrne	ucut4			; yes, use blocked sleep time
*
* full contact hit !!
*

;************************** new
	move	@curback,a0,w		; dead pool ?
	jrne	ucut3			; nope.
	move	@winner_status,a0,w
	cmpi	3,a0			; finish him ?
	jrne	ucut3			; nope.
	calla	am_i_joy
	jrnc	ucut2			; i am a drone ---> he is slimed

	move	@switch2,a3,l
	not	a3
	move	*a8(oid),a0,w
	cmpi	oid_p1,a0
	jreq	ucut1
	srl	4,a3			; p2 mask
ucut1	andi	>00000003,a3
	cmpi	3,a3			; magic ?
	jrne	ucut3			; nope..

ucut2 	move	*a13(p_otherproc),a1,l
	movi	act_slime_fall,a0
	move	a0,*a1(p_action),w	; prepare him for his slime fall
	calla	init_special
	calla	disable_all_buttons

	sleep	>20
	movk	4,a0
	movi	act_upcut_sd,a1
	jsrp	act_mframew		; un hi kick
	sleep	>10
	jauc	victory_animation

;************************** new


ucut3	sleep	>20
     	jruc	ucut6
ucut4	calla	prcslp
ucut6	movk	4,a0
	movi	act_upcut_sd,a1
	jsrp	act_mframew		; un hi kick

	move	@f_death,a0,w
	cmpi	spike_fatality,a0
	jreq	ucut7			; spike ---> dont wait for a landin

	movi	>50,a10
	jsrp	wait_for_his_dog

ucut7	calla	back_to_normal
	retp


do_jumpup_punch
	movi	act_juppunch,a0
	move	a0,*a13(p_action),w

	calla	face_opponent
	calla	rsnd_attack		; random attack sound
	calla	rsnd_whoosh

	movk	9,a0			; strike table offset
	move	a0,*a13(p_stk),w
	movk	15,a1			; # of strike frames
	movk	3,a2			; animation speed
	movi	>1f,a9
	jruc	jk6

up_grav	.set	>8000


do_jumpup_kick
	movi	act_jupkick,a0
	move	a0,*a13(p_action),w

	calla	face_opponent
	calla	rsnd_attack		; random attack sound
	calla	rsnd_whoosh

	movi	>0a,a0			; strike table offset
	move	a0,*a13(p_stk),w
	movk	16,a1			; # of strike frames
	movk	3,a2			; animation speed
	movi	>1d,a9

jk6	movi	up_grav,a3
	jsrp	air_strike
	jrnc	jk9

	movi	act_hitfall_sd,a0
	move	a0,*a13(p_action),w	; action: falling to ground !
	move	*a8(oyvel),a11,l
	move	*a8(ograv),a10,l
	clr	a0
	move	a0,*a8(ograv),l
	move	a0,*a8(oyvel),l		; stop in mid air
	sleep	8
	move	a11,*a8(oyvel),l
	move	a10,*a8(ograv),l

	addi	32,a9			; a9 ---> jump kick finish animation
	clr	a1			; dont mess with vel !
	movk	3,a0

	clr	a3
	move	a3,*a13(p_store4),l	; no more routine callin'
	movi	>e000,a3
	move	a3,*a8(ograv),l
	jsrp	flight_loop

jk9	tsound	>1e			; feet gently landing on the ground

	movi	act_land,a1
	move	a1,*a13(p_action),w
	movk	6,a9
	calla	find_ani_part2
	movk	3,a0
	jauc	mframew			; landing animation


do_flip_kick
	calla	face_opponent
	calla	rsnd_whoosh
	calla	rsnd_attack		; random attack sound

	movi	>0b,a0
	move	a0,*a13(p_stk),w
	movi	act_flykick,a0
	move	a0,*a13(p_action),w

	movi	>0b,a0			; stk table offset
	movk	16,a1			; # strike check frames
	movk	3,a2			; animation speed
	movi	>1e,a9			; animation table offset
	movi	angle_grav,a3
	jsrp	air_strike
	jrnc	jfk8
*
* wham !
*
	calla	me_in_front
	movi	act_fk_sd,a0
	move	a0,*a13(p_action),w	; flag: i'm vulnerable

	movk	8,a0			; pause ticks
	jsrp	mid_air_pause

	movk	3,a0
	clr	a1			; dont mess with vel !
	move	a1,*a13(p_store4),l	; avoid double drone kicks
	movi	>c000,a3
	move	a3,*a8(ograv),l
	jsrp	flight_loop

jfk8	movi	act_fk_sd,a0
	move	a0,*a13(p_action),w	; flag: I'm not kicking anymoe !
	jauc	do_land_animation



do_flip_punch
	calla	face_opponent
	calla	rsnd_whoosh
	calla	rsnd_attack		; random attack sound

	movi	>0c,a0
	move	a0,*a13(p_stk),w
	movi	act_flypunch,a0
	move	a0,*a13(p_action),w

	movi	>0c,a0			; stk table offset
	movk	16,a1			; # strike check frames
	movk	3,a2			; animation speed
	movi	>1f,a9			; animation table offset
	movi	angle_grav,a3
	jsrp	air_strike
	jrnc	jfp8
*
* pow !!
*
fly_punch_hit
	movk	8,a0
	jsrp	mid_air_pause

	movi	act_fk_sd,a0
	move	a0,*a13(p_action),w	; flag: I'm not kicking anymoe !
	clr	a1			; dont mess with vel !
	move	a1,*a13(p_store4),l	; avoid double drone kicks

	movk	3,a0
	clr	a1			; dont mess with vel !
	movi	>c000,a3
	move	a3,*a8(ograv),l
	jsrp	flight_loop

jfp8	movi	act_fk_sd,a0
	move	a0,*a13(p_action),w	; flag: I'm not kicking anymoe !
	jauc	do_land_animation



do_roundhouse
	callr	init_special

	tsound	>04			; whoosh
	calla	rsnd_attack

	movi	round_speeds,a0
	calla	get_char_word
	movi	act_rhouse,a1
	movi	>20,a9
	movk	3,a10
	movi	>0d,a11
	move	a11,*a13(p_stk),w

	jsrp	striker
	jrnc	rh_no
	sleep	10			; hit ---> hold this frame longer
rh_no	movk	4,a0
	jauc	retract_strike


round_speeds
	.word	3	;
	.word	3	;
	.word	3	;
	.word	3	;
	.word	3	;
	.word	3	;
	.word	3	;
	.word	2	;
	.word	2	; 8 - subzero
	.word	2	; 9 - reptile
	.word	2	; 10 = scorpion
	.word	2	; 11 = jax

	.word	3	;
	.word	3	;

	.word	3	;
	.word	3	;
	.word	3	;


do_knee
	callr	init_special

	movk	2,a0			; raiden knee = faster
	move	*a8(ochar),a1,w
	cmpi	ft_raiden,a1
	jreq	jkn2
	movk	3,a0
jkn2	movi	act_knee,a1
	movi	>21,a9
	movk	2,a10
	movi	>0e,a11
	jsrp	striker

	movi	act_knee_sd,a0
	move	a0,*a13(p_action),w	; action: knee sitting duck
	jrnc	jkne5

	movi	knee_hit_sleeps,a0
	calla	get_char_word
	calla	prcslp

jkne5	movi	ft_sa,a0
	calla	am_i_him		; am I sword arms ?
	jrne	jkne7			; no

	movi	bt_2nd_knee,b0
	calla	stuff_buttons
	sleep	6			; hold it ---> 2nd kick window

jkne7	calla	disable_all_buttons
	movk	6,a0
	jauc	retract_strike


bt_2nd_knee
	.long	0
	.long	0
	.long	0
	.long	joy_2nd_knee
	.long	0


joy_2nd_knee
	calla	disable_all_buttons
	jsrp	do_2nd_knee
	jruc	reaction_exit

do_2nd_knee
	callr	init_special
	movi	>21,a9
	calla	find_ani_part2
	calla	find_part2
	movk	2,a0
	movi	act_2nd_knee,a1
	jsrp	act_mframew    		; attack animation

	movk	3,a10
seckn2	movi	>11,a0
	calla	strike_check_a0		; look for strike
	jrc	seckn3
	sleep	1
	dsj	a10,seckn2
	sleep	6
	jruc	seckn4

seckn3 	move	b2,b2			; blocked ?
	jreq	seckn41
      	sleep	6

seckn41	calla	is_he_close_to_edge
	jac	super_ags

	sleep	10
seckn4	retp


knee_hit_sleeps
	.word	20
	.word	20
	.word	20
	.word	1

	.word	20
	.word	20
	.word	20
	.word	20

	.word	20
	.word	20
	.word	20
	.word	20

	.word	20
	.word	20
	.word	20

***************************************************************************

do_swipe
	callr	init_special		; this is considered a special move

	calla	rsnd_attack
	tsound	>c8			; big swipe whoosh sound

;	movk	4,a0
	movk	3,a0
	movi	act_swipe,a1
	movk	1,a9
	movk	4,a10
	movi	>12,a11
	move	a11,*a13(p_stk),w
	jsrp	striker_2

	sleep	10

	movk	4,a0
	jsrp	retract_strike
	retp

***************************************************************************

do_fan_swipe
	callr	init_special   		; this is considered a special move

	calla	rsnd_attack
	tsound	>c8			; big swipe whoosh sound

	movk	2,a0
	movi	act_fan_swipe,a1
	movk	3,a9
	movk	4,a10
	movi	>13,a11
	move	a11,*a13(p_stk),w
	jsrp	striker_2

	sleep	2
	movk	4,a0
	jsrp	retract_strike
	retp

***************************************************************************

do_elbow
	callr	init_special

	movi	elbow_speeds,a0
	calla	get_char_word		; a0 = my ani speed
	movi	act_elbow,a1
	movi	>22,a9
	movk	5,a10
	movi	>0f,a11
	jsrp	striker
	movi	act_elbow_sd,a0
	move	a0,*a13(p_action),w	; action: knee sitting duck
	jrnc	jelb5

	movi	elbow_pauses,a0
	calla	get_char_word		; a0 = my ani speed
	calla	prcslp

jelb5	movk	3,a0
	movi	act_elbow_sd,a1
	jsrp	retract_strike_act
	retp


elbow_pauses
	.word	14
	.word	14
	.word	14
	.word	14

	.word	14
	.word	14
	.word	14
	.word	14

	.word	14
	.word	14
	.word	14
	.word	22

	.word	14
	.word	14

	.word	14
	.word	14
	.word	14

elbow_speeds
	.word	2	; hathead
	.word	2	; kang
	.word	2	; cage
	.word	4	; sword arms (kano II)
	.word	2
	.word	2
	.word	2
	.word	2
	.word	2
	.word	2
	.word	2
	.word	2

	.word	2
	.word	2

	.word	2
	.word	2
	.word	2


do_shred
	callr	init_special

	movk	2,a2
	callr	init_special			; initialize for special move

	clr	a9
	calla	get_char_ani2
	movk	4,a0
	jsrp	mframew				; get into it (vulnerable)
*
* shred away !!
*
	movi	act_shred,a1
	move	a1,*a13(p_action),w

	movi	>14,a0
	move	a0,*a13(p_stk),w		; tell the world what I am doin'

	clr	a0
	move	a0,*a13(p_store1),w
	movk	2,a0
	calla	init_anirate			; speed of blades
	movk	1,a10				; 1st sound right away
 
	movi	>40*2,a11			; a11 = how long to do this
shred4	sleep	1

	movk	1,a1
	movk	2,a2
	movk	7,a3
	callr	sounds_of_shred			; whooshes
	calla	next_anirate
	movi	>14,a0
	calla	strike_check_a0			; contact ?
	jrc	shred_hit
	movi	>14,a0
	dsj	a11,shred4
	jruc	shred_done


sounds_of_shred
	dsj	a10,sos9
	move	a3,a10
	move	*a13(p_store1),a0,w
	inc	a0
	cmp	a2,a0
	jrlo	shred5
	clr	a0
shred5	move	a0,*a13(p_store1),w
	add	a1,a0
	calla	triple_sound
sos9	rets


shred_hit
	move	b2,b2			; blocked ?
	jrne	shhit1			; yea, no blood

	move	a13,a10	    		; pass knife man's proc

	movk	>0c,a0
	calla	create_blood_proc

shhit1	movk	2,a0
	calla	init_anirate
	movi	>30,a11
	movk	7,a10
shrhit	movi	>a0,a1
	movk	3,a2
	movk	5,a3
	callr	sounds_of_shred
	calla	next_anirate
	sleep	1
	dsj	a11,shrhit

	clr	a0
	move	a0,*a13(p_action),w
	calla	is_he_close_to_edge
	jac	attacker_getting_separated

shred_done
	clr	a0
	move	a0,*a13(p_action),w

	clr	a9
	calla	get_char_ani2
	calla	do_next_a9_frame		; get out of it frame !
	sleep	6
	retp

**********************************************************************

do_jc_split
	movi	act_splits,a1
	callr	init_special_act	; initialize for special move

	move	*a13(p_otherguy),a0,l
	move	*a0(ochar),a2,w
	movi	ft_fn1,a0
	movi	ft_fn2,a1
	calla	double_compare
	jreq	useless_splits 		; move is useless against females
	cmpi	ft_jade,a2
	jreq	useless_splits 		; move is useless against females

	calla	is_he_a_boss
	jrc	useless_splits		; boss monsters bhave no balls, dummy

	calla	get_his_action
	cmpi	act_balled,a1
	jreq	useless_splits

  	clr	a9
	movi	act_splits,a1
	movk	4,a10
	movi	>15,a11
	movk	2,a0
	jsrp	striker_2

	movk	12,a0			; assume miss sleep time
	jrnc	jcspl3

	movk	16,a0			; hit sleep time
jcspl3	calla	prcslp
	movk	5,a0
	jauc	mframew

useless_splits
	clr	a9
	calla	get_char_ani2
	movi	>00030003,a0		; sleep time, # frames
	jsrp	animate_a0_frames

	addi	32*4,a9
	movk	10,a0
	jruc	jcspl3


do_raiden_shocker
	callr	init_special
	tsound	>7c				; ngbas

	clr	a5				; no duck blocking needed
	calla	is_he_blocking
	jrc	useless_shock
	calla	get_x_dist
	cmpi	>44,a3
	jrhi	useless_shock

	calla	is_he_airborn
	jrc	useless_shock


	movi	act_shocker,a14
	move	a14,*a13(p_action),w
	movi	rsnd_death_voice,a0
	calla	calla_for_him
	tsound	>5a				; zzzzzzap !!
	movi	>20,a0
	calla	damage_to_him			; serious damage

	movi	shocked_suspend,a7
	calla	takeover_him

	movk	2,a9
	calla	get_char_ani2
	calla	do_next_a9_frame
	sleep	3

	callr	shocker_lineup
	movk	8,a11
	jsrp	shocker_shaker

	movi	post_shocker,a7
	calla	takeover_him
	retp


shocker_shaker
	jsrp	shock_shake
	movi	player_froze_pal,a1
	callr	zappal_change
	jsrp	shock_shake
	movi	player_normpal,a1
	callr	zappal_change
	dsj	a11,shocker_shaker
	retp


shocker_lineup
	push	a9
	movi	shocker_info,a0
	calla	get_his_char_long
	move	a0,a9
	move	a0,a1
	sll	8,a1
	srl	32-8,a1
	sll	5,a1				; a1 = amount to add to a9
	move	a0,a2
	zext	a2,w				; a2 = x:y adjust

	push	a2
	srl	32-8,a9
	calla	get_his_char_ani		; a9 = his animation
	add	a1,a9
	calla	do_his_next_a9_frame
	calla	match_him_with_me_f
	pull	a2

	move	a2,a0
	sll	16,a0
	sra	32-8,a0
	sll	32-8,a2
	sra	32-8,a2
	move	a2,a1
	calla	adjust_him_xy
	pull	a9
	rets


post_shocker
	movi	act_shock_sd,a1
	move	a1,*a13(p_action),w		; so he cant shock me again
	clr	a0
	clr	a1
	movi	>6000,a2	; a2 = gravity
	movk	5,a3		; a3 = ani speed
	jauc	fall_on_my_back


useless_shock
	movi	act_shocker_sd,a14		; blocked = i am a sitting duck
	move	a14,*a13(p_action),w

	movk	2,a9
	calla	get_char_ani2
	movi	>0003000f,a0
	jsrp	animate_a0_frames		; shake alone

	movk	2,a9
	calla	get_char_ani2
	calla	do_next_a9_frame		; back to normal
	sleep	3
	retp


zappal_change
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l
	call	a1
	mmfm	sp,a8,a13
	rets

shock_shake
	movk	10,a0
	move	a0,@f_norepell,w 	; disable repell !!

	movi	>04,a10
	calla	do_next_a9_frame
	move	a10,a1
	clr 	a0
	calla	adjust_him_xy
	sleep	3

	calla	do_next_a9_frame
	neg	a10
	move	a10,a1
	clr 	a0
	calla	adjust_him_xy
	sleep	3
	retp

shocked_suspend
	movi	act_shocker,a0
	jruc	suspend_wait

suspend_wait
	move	a0,a11
susw3	sleep	4
	move	*a13(p_otherproc),a0,l
	move	*a0(p_action),a1,w
	cmp	a1,a11	     			; he still doing his thing ?
	jreq	susw3				; yes, wait
	jauc	reaction_exit			; no, abort


shocker_info
	.long	>2303c0e0	; hat head
	.long	>2303bce0	; kang
	.long	>2300c8e0	; cage
	.long	>2304c8e0	; sword arms
	.long	>2301c0e0	; female ninja #1
	.long	>2301c0e0	; female ninja #2
	.long	>2300c0e0	; shang tsung
	.long	>2301c0e0	; raiden
	.long	>2301b8e0
	.long	>2301b8e0
	.long	>2301b8e0
	.long	>2305c0e0	; jax

	.long	>2301d0e0
	.long	>2301d0e0

	.long	>2301d0e0
	.long	>2301d0e0
	.long	>2301d0e0

**************************************************************************
*											     *
*  air_strike - routine for making a strike animation while in the air   *
* 											     *
*  input:  a0 = strike stk table offset						     *
*          a1 = number of frames to check for a strike			     *
*          a2 = animation speed									*
*          a3 = gravity										*
* 	  a9 = animation table offset						     *
* 											     *
*  carry set: contact was made !!!							     *
*											     *
**************************************************************************
air_strike
	move	a3,*a8(ograv),l		; set yer gravity
	move	a1,*a13(p_store1),w	; save # of strike check frames

	calla	get_char_stk
	move	a0,a11			; a11 = strike table
	move	a2,a0
	calla	init_anirate
	calla	get_char_ani		; a9 = animation table

as2	sleep	1
	calla	next_anirate
	move	*a9,a0,l		; strike frame ??
	jrne	as3			; no

;********************* flip kick < shred kludge !!!
	move	*a13(p_action),a0,w
	cmpi	act_flykick,a0		; flip kick ??
	jreq	as0			; nope.....
	cmpi	act_flypunch,a0		; flip punch ??
	jrne	as1			; nope.....

as0	move	*a13(p_otherproc),a0,l
	move	*a0(p_action),a0,w
	cmpi	act_shred,a0		; he shreddin ??
	jreq	as5			; yes, skip collision check
as1
;********************* flip kick < shred kludge !!!

	move	a11,a0
	calla	strike_check		; wham ?
	jrc	as6			; yes
as5	move	*a13(p_store1),a0,w
	dec	a0
	move	a0,*a13(p_store1),w	; no, count this attempt !!
	jreq	as7			; out of tries ---> we outta here
	
as3	move	*a8(oyvel),a0,l
	jrn	as2			; heading upwards = loop

	move	*a8(oypos),a2,w
	move	*a13(p_ganiy),a0,w	; a0 = grounded ani y
	cmp	a0,a2			; am i on the ground ?
	jrlt	as2			; no...loop

	calla	stop_me
	calla	ground_player		; landed ---> attack failed !!
	jruc	as8
*
* strike successful
*
as6	setc				; signal: wham !
as9	retp

*
* strike failed / land on the ground
*
as7	addi	32,a9			; a9 = 2nd part of animation

;*****************
	clr	a0
	move	a0,*a13(p_store4),l	; drones ---> dont try to kick again
;*****************

	jsrp	flight_loop
as8	clrc
	jruc	as9

************************************************************************

retract_strike
	clr	a1

retract_strike_act
	jsrp	act_mframew		; un hi kick
	calla	back_to_normal
	retp

do_land_animation
	movi	act_land,a1
	move	a1,*a13(p_action),w
	movk	6,a9
	calla	find_ani_part2

	calla	am_i_joy
	janc	drone_land

	tsound	>1e			; feet gently landing on the ground
	movk	3,a0
	jauc	mframew			; landing animation

**************************************************************************
*											     *
*  mid_air_pause - pause a dude (a8) in the air for a0 ticks		     *
*											     *
**************************************************************************
mid_air_pause
	push	a0
	calla	stop_me
	pull	a0			; sleep time
	calla	prcslp
	retp

**************************************************************************
*											     *
*  flight routines for people to fly with given:				     *
* 											     *
*  input: a0 = initial x velocity							     *
*         a1 = initial y velocity							     *
*         a2 = gravity to use								     *
*         a3 = animation speed (sleep ticks)						*
*         a9 = animation offset to use 							*
*											     *
**************************************************************************
flight
	clr	a6

flight_call
	push	a3
	cmpi	dont_touch,a1		; set y vel ?
	jreq	flgt2			; no, dont touch !!
	move	a1,*a8(oyvel),l		; yes, do it
flgt2	cmpi	dont_touch,a2		; modify gravity ?
	jreq	flgt3			; sans, dont touch
	move	a2,*a8(ograv),l		; yes, set gravity
flgt3
	cmpi	dont_touch,a0
	jreq	flgt6
	calla	away_x_vel
*
* setup animation (a9)
*
flgt6	move	a9,a9
	jrn	flgt5			; neg a9 = animation already setup
	movi	get_char_ani,a0
	move	a9,a1
	zext	a9,w
	srl	16,a1			; ani 2 ??
	jreq	flgt4			; no
	movi	get_char_ani2,a0
flgt4	call	a0			; get char ani #?
flgt5	pull	a0			; pull ani speed

	move	a6,*a13(p_store4),l	; routine to call every tick !!
	calla	init_anirate		; set things up to animate
*
* check if starting underground
*
	move	*a8(oypos),a1,w
	move	*a13(p_ganiy),a0,w	; a0 = grounded ani y
	cmp	a0,a1			; starting below ground level ?
	jrlt	flight_loop		; no, we are ok

	move	a0,*a8(oypos),w		; yes, start at ground level !!

flight_loop
	sleep	1
	move	*a13(p_store4),a6,l	; routine to call 
	jreq	flgt7			; none ---> skip o
	push	a10
	call	a6
	pull	a10

flgt7	calla	next_anirate
	move	*a8(oypos),a1,w
	move	*a13(p_ganiy),a0,w	; a0 = grounded ani y
	cmp	a0,a1			; hit ground yet ?
	jrlt	flight_loop 		; no, keep falling

	clr	a0
	move	a0,*a8(ograv),l		; no gravity
	calla	stop_me			; and stop me !
	calla	ground_player
	retp

do_fatality_1
	movi	db1_table,a0
	jruc	fat4

do_fatality_2
	movi	db2_table,a0
fat4	jauc	ochar_jump


**************************************************************************
*											     *
*  away_x_vel - left or right velocity   						     *
* 											     *
*  input: a0 = speed desired								     *
*											     *
**************************************************************************
away_x_vel
	calla	is_he_right
	janc	set_x_vel
      	neg	a0
	jauc	set_x_vel

towards_x_vel
	calla	is_he_right
	jac	set_x_vel
      	neg	a0
	jauc	set_x_vel

************************************************************************

check_dtp
	move	@f_no_violence,a0,w
	jrne	death			; the pit if too violent for kidz !!

	move	@winner_status,a4,w
	cmpi	3,a4
	jrne	death	       		; only during "finish him" mode

	move	@curback,a4,w
	cmpi	6,a4
	jreq	dtp_ok			; pit = kool
	cmpi	1,a4			; tomb ?
	jrne	death			; no, sorry charlie

dtp_ok	callr	combo_look_lr
	jrnc	death	       		; no

;check_dtp2
	movi	do_down_the_pit,a7
	move	@curback,a4,w
	cmpi	6,a4
	jreq	dtp4
	movi	do_up_the_spike,a7
dtp4	movi	>48,a1
	jruc	fatality_xfer_close

*
* a1 = minimum distance
*
fatality_xfer_close
	calla	get_x_dist
	cmp	a1,a3
	jrhi	death			; too far away

fatality_xfer
	move	@f_no_violence,a0,w
	jrne	death			; sorry, this is not allowed
	move	@f_no_blood,a0,w
	jrne	death			; sorry, this is not allowed

	move	@winner_status,a0,w
	cmpi	3,a0
	jrne	death			; only during "finish him" mode

;************
	move	@f_death,a0,w
	jrne	death			; only 1 fatality at a time
;************

	calla	is_he_airborn
	jrc	death			; not while he is in the air

	move	*a13(p_otherproc),a0,l
	move	*a0(pwake),a0,l

	cmpi	super_frozen,a0
	jreq	restricted_xfer

	cmpi	dizzy,a0		; he in dizzy move ?
	jrne	death			; no, no fatality

	jruc	restricted_xfer


restricted_xfer
	push	a13
	move	*a13(p_store4),a13,l	; trickery here, i'm pretending im his proc
	calla	am_i_airborn
	pull	a13
	jrc	death			; airborn = no xfer

airborn_xfer
	move	*a13(p_store4),a0,l
	move	*a0(p_flags),a4,w
	andi	pm_reacting|pm_special|pm_sitduck,a4
	jrne	death			; not allowed !!

	calla	get_my_strength		; a0 = my strength
	move	a0,a0
	jreq	death			; no power left = no move allowed

	move	*a13(p_store4),a0,l
	calla	fastxfer

	movi	reaction_exit,a7
	move	*a0(psptr),a1,l		; grab proc stack pointer
	move	a7,-*a1,l		; return address = reaction_exit
	move	a1,*a0(psptr),l		; and stuff back in

death	die

**************************************************************************
*											     *
*  do_switches_match - looks for a switch matchup					*
* 											     *
*  input: a0 = table of switch equates for player 1 / player 2		     *
*											     *
**************************************************************************
do_switches_match
	move	@switch,a1,l
	not	a1			; a1 = current switch state of the world
	move	@p1_obj,a2,l
	cmp	a2,a8			; player 1 ?
	jreq	abp4
	addi	32,a0			; player 2 ---> get his bits
abp4	move	*a0,a0,l
	and	a0,a1			; mask off unwanted bits
	cmp	a0,a1			; we got our button combo ?
	jreq	abp7
	clrc
	rets
abp7	setc
	rets

**************************************************************************
*											     *
*  combo_look_lr - routine to look and see if a certain joystick combo   *
*                  was made.								     *
* 											     *
*  input: a11 = combo table								     *
*         p_store4 = dude in question's proc					     *
*											     *
**************************************************************************
button_look_lr
	push	a8
	move	*a11+,a9,w		; a9 = time frame allowed
	callr	get_bcq_next_pointer	; a7 = next queue entry pointer
	jruc	combo4

combo_look_lr
	push	a8
	callr	button_mask
	jrne	combono			; other buttons pressed ---> NO !!!

	move	*a11+,a9,w		; a9 = time frame allowed
	push	a13
	move	*a13(p_store4),a13,l
	calla	is_he_right
	pull	a13			; trickery !!

	pushst
	callr	get_jcq_next_pointer	; a7 = next queue entry pointer
	popst
	jrc	combo4			; use "face-right" combo
	addi	16*6,a11		; use "face-left" combo

combo4	move	@tick,a10,w

combo5	move	*a11+,a8,w		; get a switch state from table
	jreq	combo7			; zero ---> done
	callr	previous_q_entry	; a0 = previous [switch,time]
	sll	16,a8
	cmpxy	a8,a0 			; match ?
	jryeq	combo5			; yes, loop

combono	pull	a8
	clrc
	rets

combo7	zext	a0,w			; a0 = time only
	sub	a0,a10			; a10 = ticks since we started
	cmp	a9,a10
	jrhi	combono			; too much time !!

	pull	a8
	setc
	rets

**************************************************************************
*											     *
*  previous_q_entry									     *
* 											     *
*  Input: a6 = top of queue we are talking about				     *
* 											     *
*  Returns: a0 = previous entry (from a7)						     *
*											     *
**************************************************************************
previous_q_entry
	subi	32,a7			; a7 = last entry made !!
	cmp	a6,a7			; are we at the top ?
	jrhi	back4			; no, we are cool
	addi	32*sqs,a7		; yes, a7 ---> bottom of queue
back4	move	*a7,a0,l		; a0 = [switch,time]
	rets

**************************************************************************
*											     *
* get_jcq_next_pointer										*
* 											     *
*    input: a8 = player object								     *
*  returns: a7 = pointer to next queue entry						*
*											     *
**************************************************************************
get_bcq_next_pointer
	movi	p1_bcq,a7
	move	@p1_obj,a0,l
	cmp		a0,a8
	jreq	gjq4
	movi	p2_bcq,a7
	jruc	gjq4

;get_boq_next_pointer
;	movi	p1_boq,a7
;	move	@p1_obj,a0,l
;	cmp	a0,a8
;	jreq	gjq4
;	movi	p2_boq,a7
;	jruc	gjq4

get_jcq_next_pointer
	movi	p1_jcq,a7
	move	@p1_obj,a0,l
	cmp	a0,a8
	jreq	gjq4
	movi	p2_jcq,a7
gjq4	move	a7,a6	  	; a6 = top of queue we are inspecting
	move	*a7,a7,l	; a7 = next available spot
	rets


does_p1p2_exist
	calla	p1p2_pick  	; a0 = correct pid
	clr	a1
	not	a1
	calla	existp
	jrne	dpey
	clrc
	rets
dpey	setc
	rets

**************************************************************************
*											     *
*  init_special - set things up before doing a special move !!		     *
*											     *
**************************************************************************
air_init_special
	calla	stop_me
	jruc	isp2

init_special_act
	move	a1,*a13(p_action),w	; define my action !!

init_special
	calla	stop_me
	calla	ground_player

isp2	calla	face_opponent
	calla	set_no_block		; i can't block !!
	calla	me_in_front

;************
	calla	player_normpal		; keep raiden at correct pal
;************

	move	*a13(p_flags),a4,w
	ori	pm_special,a4
	move	a4,*a13(p_flags),w	; flag: i am doing a special move
	jauc	disable_all_buttons


**************************************************************************
*											     *
*  button_mask - routine to check if any other buttons are pushed in     *
* 											     *
*  input: a8 = dude who wants 2 know							     *
*         a0 = player 1 requirement							     *
*         a1 = player 2 requirement							     *
* 											     *
*  returns: eq = no other buttons in							     *
*											     *
**************************************************************************
button_mask
	move	@switch,a2,l
	move	@switch2,a3,l
	not	a2
	not	a3
	andi	p1b0|p1b2|p1b3|p1sf2|p2b0|p2b2|p2b3|p2sf2,a2
	andi	p1b1|p1b4|p2b1|p2b4,a3

	btst	4,a3				; player 2 button 1 ??
	jreq	bmask3				; no
	ori	f2b1,a2				; yes, 'or' in fake bit
bmask3	btst	5,a3				; player 2 button 4 ??
	jreq	bmask4
	ori	f2b4,a2				; yes, 'or' in fake bit
bmask4	andi	p1b1|p1b4,a3			; we dont need em any more
	or	a3,a2

	move	@p1_obj,a4,l
	cmp	a8,a4
	jrne	ibi4
	and	a0,a2	 			; p2 button mask
	rets
ibi4	and	a1,a2				; p1 button mask
	rets

*
*   Input: a0 = LONGWORD p1p2 ram
* Returns: a0 = WORD p1p2 ram
*
getram_p1p2
	move	*a8(oid),a1,w
	cmpi	oid_p1,a1
	jreq	grp9
	addi	16,a0
grp9	rets

*
*   Input: a0 = LONGWORD p1p2 ram
*          a1 = value to stuff in
*
stuffram_p1p2
	move	*a8(oid),a1,w
	cmpi	oid_p1,a1
	jreq	srp9
	addi	16,a0
srp9	move	a1,*a0,w
	rets

;***************************************************************************

drone_do_a0
	sll	5,a0
	addi	do_a0_tbl,a0
	move	*a0,a0,l
	jump	a0

do_a0_tbl
	.long	do_hh_teleport	; 0
	.long	do_bicycle	; 1
	.long	do_shadow_kick	; 2
	.long	do_fn2_teleport	; 3
	.long	do_random_morph	; 4
	.long	do_raiden_melt	; 5
	.long	do_slide	; 6
	.long	do_slow_proj	; 7
	.long	do_quake	; 8
	.long	do_fn2_kano	; 9

**************************************************************************
*											     *
*  Switch Combo Tables									     *
*											     *
**************************************************************************
scom_st_dtp
	.word	>38	   	; time to do entire switch combo
	.word	sw_down
	.word	sw_up
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0

	.word	sw_down
	.word	sw_up
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0


scom_rp_db2
	.word	>38	   	; time to do entire switch combo
	.word	sw_down
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0

	.word	sw_down
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0


scom_sc_db2
	.word	>38	   	; time to do entire switch combo
	.word	sw_right
	.word	sw_right
	.word	sw_right
	.word	sw_down
	.word	0
	.word	0

	.word	sw_left
	.word	sw_left
	.word	sw_left
	.word	sw_down
	.word	0
	.word	0


scom_sz_db2
	.word	>38	   	; time to do entire switch combo
	.word	sw_right
	.word	sw_down
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0

	.word	sw_left
	.word	sw_down
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0


scom_super_ice
	.word	>38	   	; time to do entire switch combo
	.word	sw_down
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0

	.word	sw_down
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0


scom_sz_db1
	.word	>38	   	; time to do entire switch combo
	.word	sw_right
	.word	sw_right
	.word	sw_down
	.word	sw_right
	.word	0
	.word	0

	.word	sw_left
	.word	sw_left
	.word	sw_down
	.word	sw_left
	.word	0
	.word	0


scom_fn1_db
	.word	>38		   	; time to do entire switch combo
	.word	sw_right
	.word	sw_down
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0

	.word	sw_left
	.word	sw_down
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0


scom_kano
	.word	>30		   	; time to do entire switch combo
	.word	sw_down
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0

	.word	sw_down
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0

scom_jc_db2
	.word	>36		   	; time to do entire switch combo
	.word	sw_up
	.word	sw_down
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0

	.word	sw_up
	.word	sw_down
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0


scom_lk_db2
	.word	>20		   	; time to do entire switch combo
	.word	sw_down
	.word	sw_left
	.word	sw_up
	.word	sw_right
	.word	sw_down
	.word	0

	.word	sw_down
	.word	sw_right
	.word	sw_up
	.word	sw_left
	.word	sw_down
	.word	0

scom_super_rep
	.word	>20		   	; time to do entire switch combo
	.word	sw_down
	.word	sw_up
	.word	0
	.word	0
	.word	0
	.word	0

	.word	sw_down
	.word	sw_up
	.word	0
	.word	0
	.word	0
	.word	0

scom_hh_db1
	.word	>34		   	; time to do entire switch combo
	.word	sw_right
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0

	.word	sw_left
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0

scom_jax_zap
	.word	>18
	.word	sw_left
	.word	sw_down
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	sw_right
	.word	sw_down
	.word	sw_left
	.word	0
	.word	0
	.word	0

scom_jx_db1
	.word	>30
	.word	sw_right
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0


scom_lk_db1
	.word	>38
	.word	sw_left
	.word	sw_left
	.word	sw_right
	.word	sw_down
	.word	0
	.word	0

	.word	sw_right
	.word	sw_right
	.word	sw_left
	.word	sw_down
	.word	0
	.word	0


scom_sc_toasty
	.word	>38	   	; time to do entire switch combo
	.word	sw_up
	.word	sw_up
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0
	.word	sw_up
	.word	sw_up
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0


scom_rd_dtp
scom_sc_db1
	.word	>28	   	; time to do entire switch combo
	.word	sw_up
	.word	sw_up
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_up
	.word	sw_up
	.word	0
	.word	0
	.word	0
	.word	0

scom_st_db1
	.word	>30	   	; time to do entire switch combo
	.word	sw_up
	.word	sw_down
	.word	sw_up
	.word	0
	.word	0
	.word	0
	.word	sw_up
	.word	sw_down
	.word	sw_up
	.word	0
	.word	0
	.word	0


scom_hh_spin
	.word	>18	   	; time to do entire switch combo
	.word	sw_up
	.word	sw_up
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_up
	.word	sw_up
	.word	0
	.word	0
	.word	0
	.word	0

scom_scissor
	.word	>18
	.word	sw_left
	.word	sw_down
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	sw_right
	.word	sw_down
	.word	sw_left
	.word	0
	.word	0
	.word	0

scom_square
	.word	>18
	.word	sw_left
	.word	sw_down
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	sw_right
	.word	sw_down
	.word	sw_left
	.word	0
	.word	0
	.word	0

scom_rp_db1
	.word	>28
	.word	sw_down
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	sw_down
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0

scom_noogy
	.word	>18
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	0

scom_spit
	.word	>18
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	0

scom_fn2_teleport
	.word	>18	   	; time to do entire switch combo
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	0

scom_spark
scom_decoy
	.word	>10	   	; time to do entire switch combo
	.word	sw_left
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_right
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	0

scom_spear
	.word	>30
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	0

scom_jc_db1
	.word	>38
	.word	sw_right
	.word	sw_right
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0
	.word	sw_left
	.word	sw_left
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0

scom_st_2_rd
	.word	>38
	.word	sw_right
	.word	sw_left
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_right
	.word	sw_down
	.word	0
	.word	0
	.word	0

scom_st_2_jx
	.word	>38
	.word	sw_left
	.word	sw_right
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	sw_right
	.word	sw_left
	.word	sw_down
	.word	0
	.word	0
	.word	0


bcom_fn1_db2
	.word	>30
	.word	sw_hi_kick
	.word	sw_block
	.word	sw_block
	.word	sw_block
	.word	0
	.word	0

	.word	sw_hi_kick
	.word	sw_block
	.word	sw_block
	.word	sw_block
	.word	0
	.word	0


bcom_jx_db2
	.word	>30
	.word	sw_lo_punch
	.word	sw_block
	.word	sw_block
	.word	sw_block
	.word	sw_block
	.word	0

	.word	sw_lo_punch
	.word	sw_block
	.word	sw_block
	.word	sw_block
	.word	sw_block
	.word	0


bcom_st_2_fn1
	.word	>20
	.word	sw_block
	.word	sw_block
	.word	sw_block
	.word	0
	.word	0
	.word	0
	.word	sw_block
	.word	sw_block
	.word	sw_block
	.word	0
	.word	0
	.word	0

scom_st_2_sa
	.word	>38
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	0

scom_st_2_sc
	.word	>20	   	; time to do entire switch combo
	.word	sw_up
	.word	sw_up
	.word	0
	.word	0
	.word	0
	.word	0

	.word	sw_up
	.word	sw_up
	.word	0
	.word	0
	.word	0
	.word	0


scom_st_2_jc
	.word	>38
	.word	sw_down
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	sw_down
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0

scom_st_2_sz
	.word	>38
	.word	sw_right
	.word	sw_down
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_down
	.word	sw_left
	.word	0
	.word	0
	.word	0

scom_st_2_lk
	.word	>30
	.word	sw_right
	.word	sw_right
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_left
	.word	sw_right
	.word	0
	.word	0
	.word	0

scom_st_2_hh
	.word	>30
	.word	sw_left
	.word	sw_down
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	sw_right
	.word	sw_down
	.word	sw_right
	.word	0
	.word	0
	.word	0

scom_slow_proj
	.word	>20	   	; time to do entire switch combo
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	0

	.word	sw_right
	.word	sw_right
       	.word	0
	.word	0
	.word	0
	.word	0

scom_st_2_rp
	.word	>20	   	; time to do entire switch combo
	.word	sw_down
	.word	sw_up
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_down
	.word	sw_up
	.word	0
	.word	0
	.word	0
	.word	0


scom_inviso
	.word	>38	   	; time to do entire switch combo
	.word	sw_down
	.word	sw_up
	.word	sw_up
	.word	0
	.word	0
	.word	0

	.word	sw_down
	.word	sw_up
	.word	sw_up
	.word	0
	.word	0
	.word	0

scom_floor_ice
	.word	>10	   	; time to do entire switch combo
	.word	sw_left
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	0

	.word	sw_right
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	0


scom_ice_ball
scom_lightning
	.word	>10	   	; time to do entire switch combo
	.word	sw_right
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	0

	.word	sw_left
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	0

scom_rd_melt
	.word	>10
	.word	sw_up
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_up
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	0


scom_rd_dive
	.word	>20
	.word	sw_right
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0

scom_fn2_db
	.word	>24
	.word	sw_right
	.word	sw_left
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_right
	.word	sw_left
	.word	0
	.word	0
	.word	0

scom_throw_fan
	.word	>24
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	0

scom_sa_decap
	.word	>38
	.word	sw_left
	.word	sw_left
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0

	.word	sw_right
	.word	sw_right
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0

scom_sa_stab
	.word	>38
	.word	sw_right
	.word	sw_down
	.word	sw_right
	.word	sw_left
	.word	0
	.word	0

	.word	sw_left
	.word	sw_down
	.word	sw_left
	.word	sw_right
	.word	0
	.word	0

scom_spinfan
scom_shred
	.word	>22
	.word	sw_left
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	sw_right
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0

scom_jc_shoruken
	.word	>38
	.word	sw_left
	.word	sw_down
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	sw_right
	.word	sw_down
	.word	sw_right
	.word	0
	.word	0
	.word	0

scom_hh_teleport
	.word	>10
	.word	sw_up
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_up
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	0

scom_hh_db2
scom_hh_throw
scom_jc_shadow
	.word	>18
	.word	sw_right
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	0

scom_st_zap
	.word	>24
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	0

scom_st_zap2
	.word	>30
	.word	sw_right
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0

scom_st_zap3
	.word	>35
	.word	sw_right
	.word	sw_right
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	sw_left
	.word	sw_left
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0


scom_lk_flykick
scom_lk_zaphi
scom_lk_zaplo
	.word	>24
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	0

scom_jc_zaphi
	.word	>18
	.word	sw_left
	.word	sw_down
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	sw_right
	.word	sw_down
	.word	sw_left
	.word	0
	.word	0
	.word	0
	     
scom_jc_zaplo
	.word	>18
	.word	sw_right
	.word	sw_down
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_down
	.word	sw_right
	.word	0
	.word	0
	.word	0


scom_hh_dtp
	.word	>24
	.word	sw_right
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0

scom_lk_dtp
	.word	>24
	.word	sw_right
	.word	sw_right
	.word	sw_left
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_left
	.word	sw_right
	.word	0
	.word	0
	.word	0

scom_jc_dtp
	.word	>24
	.word	sw_down
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	sw_down
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0
      	.word	0

scom_sa_dtp
	.word	>24
	.word	sw_down
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	sw_down
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0
	.word	0

scom_fn1_dtp
scom_fn2_dtp
	.word	>24
	.word	sw_right
	.word	sw_down
	.word	sw_right
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_down
	.word	sw_left
	.word	0
	.word	0
	.word	0

scom_nj_dtp
	.word	>24
	.word	sw_right
	.word	sw_right
	.word	sw_down
	.word	0
	.word	0
	.word	0
	.word	sw_left
	.word	sw_left
	.word	sw_down
	.word	0
	.word	0
	.word	0

scom_jx_dtp
	.word	>30
	.word	sw_down
	.word	sw_up
	.word	sw_up
	.word	0
	.word	0
	.word	0
	.word	sw_down
	.word	sw_up
	.word	sw_up
	.word	0
	.word	0
	.word	0

;*************************************************************************

	.end
