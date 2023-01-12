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
	.file	'mkfriend.asm'
	.width	132
	.option	b,d,l,t
	.mnolist
*
* get the system stuff
*
	.include	dispequ.asm
	.include	sysequ.asm
	.include	macros.hdr
	.include	stringh.asm
	.include	mainequ.asm
	.include	imgtbl.glo
	.include	mkfriend.tbl
	.include	mkfrnd2.tbl
	.text

;*************************************************************************

fs_check
	move	@winner_status,a0,w
	cmpi	3,a0
 	jrne	fsno			; only during "finish him" mode

	movi	l_hp,a0
	callr	fs_get_tsl
	jrne	fsno
	movi	l_lp,a0
	callr	fs_get_tsl
	jrne	fsno

	movi	ochar_friendship_combos,a0
	calla	get_char_long
	move	a0,a11
	clr	a0
	clr	a1
	calla	combo_look_lr
	jrnc	fsno	  		; no

	pull	a0
	movi	do_friendship,a7
	jauc	restricted_xfer

fsno	rets


fs_get_tsl
	move	*a8(oid),a1,w
	cmpi	pid_p1,a1	; player 1 ??
	jreq	tsl4
    	addk	16,a0		; no, point to player 2's tick ram
tsl4	move	*a0,a0,w	; when was the last time we did this ?
	rets


ochar_friendship_combos
	.long	scom_hh_friend
	.long	scom_lk_friend
	.long	scom_jc_friend
	.long	scom_sa_friend
	.long	scom_fn_friend
	.long	scom_fn_friend
	.long	scom_st_friend
	.long	scom_rd_friend
	.long	scom_nj_friend
	.long	scom_nj_friend
	.long	scom_nj_friend
	.long	scom_jx_friend


friendship_start
	movk	1,a0				; fade = yes
	movk	fs_fatality,a1			; fatality #
	calla	init_death_blow
	sleep	>30				; dramatic pause
	retp

friendship_end
	movk	2,a0
	move	a0,@f_death2,w			; flag: friendship
	jauc	death_blow_complete


do_friendship
	movi	friendship_jumps,a0
	jauc	ochar_jump

friendship_jumps
	.long	hh_friend
	.long	lk_friend
	.long	jc_friend
	.long	sa_friend

	.long	fn1_friend
	.long	fn2_friend
	.long	st_friend
	.long	rd_friend

	.long	nj_friend
	.long	nj_friend
	.long	nj_friend
	.long	jx_friend

hh_friend
	jsrp	friendship_start

	movk	8,a0
	movi	a_hh_friend,a9
	jsrp	mframew

	movi	>3e,a3
	calla	send_code_a3
	callr	friendship_end

hhf3	movi	a_rabbit_wiggle,a9
	movk	8,a0
	jsrp	mframew
	jruc	hhf3


a_hh_friend
	.long	TMHATRICK1
	.long	TMHATRICK2
	.long	TMHATRICK3
	.long	TMHATRICK4
	.long	TMHATRICK5
	.long	TMHATRICK6
	.long	TMHATRICK7

a_rabbit_wiggle
	.long	TMHATRICK8
	.long	TMHATRICK9
	.long	TMHATRICK10
	.long	TMHATRICK11
	.long	0

TMHATRICK1
	.long	TMHATRICK1A,TMHATRICK1B,TMHATRICK1C,0
TMHATRICK2
	.long	TMHATRICK2A,TMHATRICK2B,TMHATRICK2C,0
TMHATRICK3
	.long	TMHATRICK3A,TMHATRICK3B,TMHATRICK3C,0
TMHATRICK4
	.long	TMHATRICK4A,TMHATRICK4B,TMHATRICK4C,0
TMHATRICK5
	.long	TMHATRICK5A,TMHATRICK5B,0
TMHATRICK6
	.long	TMHATRICK6A,TMHATRICK6B,0
TMHATRICK7
	.long	TMHATRICK7A,TMHATRICK7B,0
TMHATRICK8
	.long	TMHATRICK8A,TMHATRICK8B,TMHATRICK8C,RABBIT1,0
TMHATRICK9
	.long	TMHATRICK8A,TMHATRICK8B,TMHATRICK8C,RABBIT2,0
TMHATRICK10
	.long	TMHATRICK8A,TMHATRICK8B,TMHATRICK8C,RABBIT3,0
TMHATRICK11
	.long	TMHATRICK8A,TMHATRICK8B,TMHATRICK8C,RABBIT4,0

;*************************************************************************

lk_friend
	jsrp	friendship_start

	create	pid_fx,disco_ball_proc
	sleep	>10

	movi	>3b,a3
	calla	send_code_a3

	movk	3,a10
lkd3	movi	a_lk_dance,a9
	movk	6,a0
	jsrp	mframew
	dsj	a10,lkd3
	
	callr	friendship_end
	jauc	wait_forever




a_lk_dance
	.long	LKDANCIN1
	.long	LKDANCIN2
	.long	LKDANCIN3
	.long	LKDANCIN4
	.long	LKDANCIN5
	.long	LKDANCIN6
	.long	LKDANCIN7

	.long	LKDANCIN6
	.long	LKDANCIN5
	.long	LKDANCIN4
	.long	LKDANCIN3
	.long	LKDANCIN2
	.long	0

LKDANCIN1
	.long	LKDANCIN1A,LKDANCIN1B,LKDANCIN1C,LKDANCIN1D
	.long	0
LKDANCIN2
	.long	LKDANCIN2A,LKDANCIN2B,LKDANCIN2C,LKDANCIN2D
	.long	0
LKDANCIN3
	.long	LKDANCIN3A,LKDANCIN3B,LKDANCIN3C,LKDANCIN3D
	.long	0
LKDANCIN4
	.long	LKDANCIN4A,LKDANCIN4B,LKDANCIN4C,0
LKDANCIN5
	.long	LKDANCIN5A,LKDANCIN5B,LKDANCIN5C,LKDANCIN5D
	.long	0
LKDANCIN6
	.long	LKDANCIN6A,LKDANCIN6B,LKDANCIN6C,LKDANCIN6D
	.long	LKDANCIN6E,0
LKDANCIN7
	.long	LKDANCIN7A,LKDANCIN7B,LKDANCIN7C,LKDANCIN7D,0

;*************************************************************************

jc_friend
	jsrp	friendship_start

	movi	a_jc_friend,a9
	movk	6,a0
	jsrp	mframew			; scibble, scribble, scribble

	create	pid_bones,autograph_proc

	movi	a_jc_friend,a9
	calla	do_next_a9_frame	; let go of paper

	sleep	>20
	callr	friendship_end
	jauc	victory_animation

a_jc_friend
	.long	JCFSBONUS1
	.long	JCFSBONUS2
	.long	JCFSBONUS3
	.long	JCFSBONUS4
	.long	JCFSBONUS5
	.long	JCFSBONUS6

	.long	JCFSBONUS5
	.long	JCFSBONUS4
	.long	JCFSBONUS5
	.long	JCFSBONUS6

	.long	JCFSBONUS5
	.long	JCFSBONUS4
	.long	JCFSBONUS5
	.long	JCFSBONUS6

	.long	JCFSBONUS5
	.long	JCFSBONUS4
	.long	JCFSBONUS5
	.long	JCFSBONUS6
	.long	0

JCFSBONUS1
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B
	.long	JCFSBONUS1A,0
JCFSBONUS2
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B
	.long	JCFSBONUS2A,JCFSBONUS2B,JCFSBONUS2C,0
JCFSBONUS3
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B
	.long	JCFSBONUS3A,JCFSBONUS3B,0
JCFSBONUS4
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B
	.long	JCFSBONUS4A,0
JCFSBONUS5
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B
	.long	JCFSBONUS5A,0
JCFSBONUS6
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B
	.long	JCFSBONUS6A,0

autograph_proc
	movi	>3e,a3
	calla	send_code_a3

	move	a8,a11
	movi	AUTOGRAPH1,a5
	calla	gso_dmawnz

	move	*a11(oypos),a0,w
	addi	>40,a0
	move	a0,*a8(oypos),w

	move	*a11(oxpos),a0,w
	addi	>00,a0
	move	a0,*a8(oxpos),w
	movi	50,a0
	move	a0,*a8(ozpos),w
	calla	insobja8

	movi	>50000,a0
	move	a0,*a8(oyvel),l		; drop towards ground
	movi	a_autograph,a9
	movk	2,a0
	jsrp	framew

	calla	stop_a8
	calla	set_noscroll

	movi	a_cage_page,a9
	calla	frame_a9
	movi	scrbot+10,a0
	move	a0,*a8(oypos),w
	movi	(scrrgt/2)->20,a0
	move	a0,*a8(oxpos),w
	sleep	8

	movi	->80000,a0
	move	a0,*a8(oyvel),l		; raise up
	sleep	>10

	calla	stop_a8
	die

a_autograph
	.long	AUTOGRAPH1
	.long	AUTOGRAPH2
	.long	AUTOGRAPH3
	.long	AUTOGRAPH4
	.long	AUTOGRAPH5
	.long	AUTOGRAPH6
	.long	0

a_cage_page
	.long	AUTOGRAPH8
	.long	0

;*************************************************************************

sa_friend
	jsrp	friendship_start

	movi	a_offer_gift,a9
	movk	4,a0
	jsrp	mframew			; one sec....
	sleep	>18

	movk	8,a0
	jsrp	mframew			; reach back

	push	a9
	movi	a_gift,a9
	move	a9,a11
	calla	get_proj_obj_m		; get an object for my fireball
	move	a10,a0
	calla	insobj
	pull	a9

	movi	>3e,a3
	calla	send_code_a3

	movk	8,a0
	jsrp	double_mframew
	sleep	10

	callr	friendship_end
	jauc	wait_forever


a_offer_gift
	.long	UGFSBONUS1
	.long	UGFSBONUS2
	.long	0

	.long	UGFSBONUS3
	.long	UGFSBONUS4
	.long	0

	.long	UGFSBONUS5
	.long	UGFSBONUS6
	.long	UGFSBONUS7
	.long	0

UGFSBONUS1
	.long	UGFSBONUS1A,UGFSBONUS1B,0
UGFSBONUS2
	.long	UGFSBONUS2A,UGFSBONUS2B,UGFSBONUS2C,0
UGFSBONUS3
	.long	UGFSBONUS3A,UGFSBONUS3B,0
UGFSBONUS4
	.long	UGFSBONUS4A,UGFSBONUS4B,0
UGFSBONUS5
	.long	UGFSBONUS5A,UGFSBONUS5B,0
UGFSBONUS6
	.long	UGFSBONUS6A,UGFSBONUS6B,0
UGFSBONUS7
	.long	UGFSBONUS7A,UGFSBONUS7B,UGFSBONUS7C,0


a_gift	.long	GIFT1
	.long	GIFT2
	.long	GIFT3
	.long	0

GIFT1	.long	UGGIFT1,0
GIFT2	.long	UGGIFT2,0
GIFT3	.long	UGGIFT3,0

;*************************************************************************

fn1_friend
	jsrp	friendship_start

	movi	a_bake_a_cake,a9
	movk	4,a0
	jsrp	mframew

	push	a9
	movi	a_cake,a9
	move	a9,a11
	calla	get_proj_obj_m		; get an object for my fireball
	move	a10,a0
	calla	insobj
	pull	a9

	movk	8,a0
	jsrp	double_mframew

	movi	>3e,a3
	calla	send_code_a3
	sleep	10
	callr	friendship_end
	jauc	wait_forever

a_bake_a_cake
	.long	KTBAKE1
	.long	KTBAKE2
	.long	KTBAKE3
	.long	KTBAKE4
	.long	KTBAKE5

	.long	KTBAKE4
	.long	KTBAKE3
	.long	KTBAKE4
	.long	KTBAKE5
	.long	KTBAKE4
	.long	KTBAKE3
	.long	KTBAKE4
	.long	KTBAKE5
	.long	KTBAKE4
	.long	KTBAKE3
	.long	KTBAKE4
	.long	KTBAKE5
	.long	0

	.long	KTBAKE6
	.long	KTBAKE7
	.long	KTBAKE8
	.long	0

KTBAKE1	.long	KTBAKE1A,KTBAKE1B,0
KTBAKE2	.long	KTBAKE2A,KTBAKE2B,KTBAKE2C,0
KTBAKE3	.long	KTBAKE3A,KTBAKE3B,KTBAKE3C,0
KTBAKE4	.long	KTBAKE4A,KTBAKE4B,0
KTBAKE5	.long	KTBAKE5A,KTBAKE5B,0
KTBAKE6	.long	KTBAKE6A,KTBAKE6B,0
KTBAKE7	.long	KTBAKE7A,KTBAKE7B,KTBAKE7C,0
KTBAKE8	.long	KTBAKE8A,KTBAKE8B,KTBAKE8C,0

a_cake	.long	CAKE1
	.long	CAKE2
	.long	CAKE3
	.long	0

CAKE1	.long	KTCAKE1,0
CAKE2	.long	KTCAKE2,0
CAKE3	.long	KTCAKE3,0

;*************************************************************************

fn2_friend
	jsrp	friendship_start

	movi	a_plant_seed,a9
	movk	6,a0
	jsrp	mframew
	move	a8,a11

	movi	bpal_white,a0
	movi	>00030003,a3
	calla	make_solid_object

	move	a8,a0
	move	a11,a1
	calla	lineup_1pwm
	movi	>26,a0
	movi	>1d,a1
	calla	multi_adjust_xy
	calla	insobja8

	movi	>10000,a0
seed3	move	a0,*a8(oyvel),l		; drop to ground
	sleep	1
	move	*a8(oyvel),a0,l
	addi	>6000,a0
	move	*a8(oypos),a3,w
	move	@ground_y,a1,w
	cmp	a1,a3
	jrlo	seed3

	calla	stop_a8
	move	@ground_y,a1,w
	move	a1,*a8(oypos),w
	sleep	>10
	move	a8,a0
	calla	delobjp

	movi	MEPLANT1,a5
	calla	gso_dmawnz
	move	a8,a0
	move	a11,a1
	calla	lineup_1pwm

	movi	>26,a0
	movi	>88,a1
	calla	multi_adjust_xy
	calla	insobja8

	movi	>3a,a3
	calla	send_code_a3
	movi	a_growing_plant,a9
	movk	4,a0
	jsrp	framew			; grow !!!
	sleep	>20

	sleep	10
	callr	friendship_end
	jauc	wait_forever


a_plant_seed
	.long	KTDPLANT1
	.long	KTDPLANT2
	.long	KTDPLANT3
	.long	0

KTDPLANT1
	.long	KTPLANT1A,KTPLANT1B,KTPLANT1C,0
KTDPLANT2
	.long	KTPLANT2A,KTPLANT2B,KTPLANT2C,0
KTDPLANT3
	.long	KTPLANT3A,KTPLANT3B,KTPLANT3C,0


a_growing_plant
	.long	MEPLANT1
	.long	MEPLANT2
	.long	MEPLANT3
	.long	MEPLANT4
	.long	MEPLANT5
	.long	MEPLANT6
	.long	MEPLANT7
	.long	0

;*************************************************************************

st_friend
	jsrp	friendship_start

	movi	>3a,a3
	calla	send_code_a3

	movi	a_happiness,a9
	movk	6,a0
	jsrp	mframew
	sleep	>10

	push	a9
	movi	a_rainbow,a9
	move	a9,a11
	calla	get_proj_obj_m		; get an object for my fireball
	move	a10,a0
	calla	insobj
	pull	a9

	movk	8,a0
	jsrp	double_mframew

	sleep	10
	callr	friendship_end
	jauc	wait_forever


a_happiness
	.long	STFSBONUS1
	.long	STFSBONUS2
	.long	0

	.long	STFSBONUS3
	.long	STFSBONUS4
	.long	STFSBONUS5
	.long	STFSBONUS6
	.long	STFSBONUS7
	.long	0

a_rainbow
	.long	RAINBOW1
	.long	RAINBOW2
	.long	RAINBOW3
	.long	RAINBOW4
	.long	RAINBOW5
	.long	0

STFSBONUS1
	.long	STFSBONUS1A,STFSBONUS1B,STFSBONUS1C,STFSBONUS1D,0
STFSBONUS2
	.long	STFSBONUS2A,STFSBONUS2B,STFSBONUS2C,STFSBONUS2D,0
STFSBONUS3
	.long	STFSBONUSLEG,STFSBONUS3A,STFSBONUS3B,0
STFSBONUS4
	.long	STFSBONUSLEG,STFSBONUS4A,STFSBONUS4B,STFSBONUS4C,0
STFSBONUS5
	.long	STFSBONUSLEG,STFSBONUS5A,STFSBONUS5B,STFSBONUS5C,0
STFSBONUS6
	.long	STFSBONUSLEG,STFSBONUS6A,STFSBONUS6B,STFSBONUS6C,0
STFSBONUS7
	.long	STFSBONUSLEG,STFSBONUS7A,STFSBONUS7B,STFSBONUS7C,0

RAINBOW1	.long	RAINBOW1A,0
RAINBOW2	.long	RAINBOW2A,0
RAINBOW3	.long	RAINBOW3A,RAINBOW3B,0
RAINBOW4	.long	RAINBOW4A,RAINBOW4B,0
RAINBOW5	.long	RAINBOW5A,RAINBOW5B,0

;**************************************************************************

rd_friend
	jsrp	friendship_start

	movk	4,a9
	calla	get_char_ani2
	movk	4,a0
	jsrp	mframew

	mmtm	sp,a8,a9
	movi	a_kidd_thunder,a9
	move	a9,a11
	calla	get_proj_obj_m		; get an object for my fireball

	movi	ELEC_P,A0
	move	a10,a8
	calla	swpal			; start off using elec pal
	move	a10,a0
	calla	insobj
	create	pid_bones,kidd_thunder_proc
	mmfm	sp,a8,a9

	sleep	>78
	movi	oid_text,a0
	calla	dallobj

	callr	friendship_end
	sleep	>10
	jauc	victory_animation


kidd_thunder_proc
	tsound2	>04
	addi	32,a9
	movk	3,a0
	jsrp	mframew			; zzzzap !!
	
	move	*a9,a5,l
	move	*a5,a5,l
	move	*a5(icmap),a0,l
	calla	swpal

	movk	4,a0
	jsrp	mframew			; last frame = kidd thunder
	movi	fl_kidd,a11
	create	pid_fx,boonpal_stuff	; flash letters
	movi	pf_kidd,a8
	jsrp	lm_printf

	tsound	>d5
	sleep	>40
	movi	>3e,a3
	calla	send_code_a3
	jauc	wait_forever

fl_kidd
	.word	bpal_flash1,4
	.word	>ffff
	.word	rgb_blue
	.word	end_stuff

pf_kidd
	mess_mac rd11font,2,scrrgt/2,>50,bpal_flash1*>10000,strcnrmos_scr,0
	.string	"KIDD THUNDER !!"
	.even


a_kidd_thunder
	.long	KIDD7

	.long	KIDD1
	.long	KIDD2
	.long	KIDD3
	.long	KIDD4
	.long	KIDD5
	.long	KIDD6
	.long	0

	.long	KIDD7
	.long	0

KIDD1	.long	KIDTHUNDER1,0
KIDD2	.long	KIDTHUNDER2,0
KIDD3	.long	KIDTHUNDER3,0
KIDD4	.long	KIDTHUNDER4,0
KIDD5	.long	KIDTHUNDER5A,KIDTHUNDER5B,0
KIDD6	.long	KIDTHUNDER6A,KIDTHUNDER6B,KIDTHUNDER6C,KIDTHUNDER6D,0
KIDD7	.long	KIDTHUNDER7A,KIDTHUNDER7B,KIDTHUNDER7C,KIDTHUNDER7D,0

;**************************************************************************

nj_friend
	jsrp	friendship_start

	movi	>3e,a3
	calla	send_code_a3
	movi	a_nj_friend,a9
	movk	6,a0
	jsrp	mframew

	pushp	a8
	movi	pf_sc_doll,a9
	movi	ft_scorpion,a0
	calla	am_i_him
	jrc	njf3
	movi	pf_sz_doll,a9
	movi	ft_subzero,a0
	calla	am_i_him
	jrc	njf3
	movi	pf_rp_doll,a9
njf3	move	a9,a8
	jsrp	lm_printf
	pullp	a8
	sleep	>60

	callr	friendship_end
	sleep	>10
	jauc	wait_forever

a_nj_friend
	.long	NJFSBONUS1
	.long	NJFSBONUS2
	.long	NJFSBONUS3
	.long	NJFSBONUS4
	.long	0

NJFSBONUS1
	.long	NJFSBONUS1A,NJFSBONUS1B,NJFSBONUS1C,0
NJFSBONUS2
	.long	NJFSBONUS2A,NJFSBONUS2B,NJFSBONUS2C,0
NJFSBONUS3
	.long	NJFSBONUS3A,NJFSBONUS3B,NJFSBONUS3C,NJFSBONUS3D,0
NJFSBONUS4
	.long	NJFSBONUS4A,NJFSBONUS4B,NJFSBONUS4C,0

pf_sc_doll
	mess_mac rd7font,2,scrrgt/2,>50,bpal_white*>10000,strcnrmos_scr,0
	.string	"BUY A SCORPION DOLL !",0
	.even

pf_sz_doll
	mess_mac rd7font,2,scrrgt/2,>50,bpal_white*>10000,strcnrmos_scr,0
	.string	"BUY A SUB-ZERO DOLL !",0
	.even

pf_rp_doll
	mess_mac rd7font,2,scrrgt/2,>50,bpal_white*>10000,strcnrmos_scr,0
	.string	"BUY A REPTILE DOLL !",0
	.even

;**************************************************************************

jx_friend
	jsrp	friendship_start
*
* tony goskie strikes again (which means, of course, more misery for Ed)
*
	move	a8,a10
	movi	->04,a0
	movi	>30,a1
	movi	JXVICTORY8B,a5
	movi	>2cd440e,a9
	callr	fix_goskie_fuckup
	movi	->04,a0
	movi	>30,a1
	movi	JXVICTORY8D,a5
	movi	>2cd8336,a9
	callr	fix_goskie_fuckup
	move	a10,a8

	movi	a_jax_friend,a9
	movk	5,a0
	jsrp	mframew

	movi	>3e,a3
	calla	send_code_a3
	movk	5,a0
	jsrp	mframew

	callr	friendship_end
	sleep	>10
	jauc	wait_forever


fix_goskie_fuckup
	mmtm	sp,a0,a1
	calla	gso_dmawnz
	move	a8,a0
	move	a10,a1
	calla	lineup_1pwm
	mmfm	sp,a0,a1
	calla	multi_adjust_xy
	calla	insobja8
	move	*a8(osizey),a0,w
	subi	>30,a0
	move	a0,*a8(osizey),w	; shrink a zoid
	move	a9,*a8(osag),l
	rets


a_jax_friend
	.long	JXFSBONUS1
	.long	JXFSBONUS2
	.long	JXFSBONUS3
	.long	JXFSBONUS4
	.long	JXFSBONUS5
	.long	JXFSBONUS4
	.long	JXFSBONUS3
	.long	JXFSBONUS4
	.long	JXFSBONUS5
	.long	JXFSBONUS4
	.long	JXFSBONUS3
	.long	JXFSBONUS4
	.long	JXFSBONUS5
	.long	JXFSBONUS4
	.long	0
	.long	JXFSBONUS6
	.long	JXFSBONUS7
	.long	JXFSBONUS8
	.long	0

JXFSBONUS1
	.long	JXFSBONUS1A,JXFSBONUS1B,0
JXFSBONUS2
	.long	JXFSBONUS2A,JXFSBONUS2B,JXFSBONUS2C,0
JXFSBONUS3
	.long	JXFSBONUS3A,0
JXFSBONUS4
	.long	JXFSBONUS4A,0
JXFSBONUS5
	.long	JXFSBONUS5A,0
JXFSBONUS6
	.long	JXFSBONUS6A,JXFSBONUS6B,0
JXFSBONUS7
	.long	JXFSBONUS7A,JXFSBONUS7B,JXFSBONUS7C,0
JXFSBONUS8
	.long	JXFSBONUS8A,JXFSBONUS8B,JXFSBONUS8C,0

;**************************************************************************

start_bounce
	movi	objlst2,a2
	calla	delolist		; rid of text

	movk	10,a10
	movi	friendship_letters,a11
stb3	create	pid_fx,letter_bounce
	addi	32*2,a11
	dsjs	a10,stb3
	rets

letter_bounce
	move	*a11+,a5,l
	calla	gso_dmawnz_ns
	move	*a11,a4,l
	calla	set_xy_coordinates
	calla	insobj2a8

	movi	>10000,a0
	srl	1,a10
	jrc	lb3
	neg	a0
lb3	move	a0,*a8(oyvel),l
	sleep	8
	move	*a8(oyvel),a0,l
	neg	a0
	jruc	lb3

friendship_letters
	.long	FRIENDSHIP_F,>00400030
	.long	FRIENDSHIP_R,>00400050
	.long	FRIENDSHIP_I,>00400078
	.long	FRIENDSHIP_E,>0040008b
	.long	FRIENDSHIP_N,>004000ad
	.long	FRIENDSHIP_D,>004000d0
	.long	FRIENDSHIP_S,>004000f4
	.long	FRIENDSHIP_H,>00400114
	.long	FRIENDSHIP_I,>0040013b
	.long	FRIENDSHIP_P,>00400150
	.long	0

;**************************************************************************

scom_hh_friend
	.word	>38	   	; time to do entire switch combo
	.word	sw_down
	.word	sw_left
	.word	sw_left
	.word	sw_left
	.word	0
	.word	0

	.word	sw_down
	.word	sw_right
	.word	sw_right
	.word	sw_right
	.word	0
	.word	0

scom_lk_friend
	.word	>38	   	; time to do entire switch combo
	.word	sw_left
	.word	sw_left
	.word	sw_left
	.word	sw_right
	.word	0
	.word	0

	.word	sw_right
	.word	sw_right
	.word	sw_right
	.word	sw_left
	.word	0
	.word	0

scom_jc_friend
	.word	>38	   	; time to do entire switch combo
	.word	sw_down
	.word	sw_down
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0

	.word	sw_down
	.word	sw_down
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0

scom_sa_friend
	.word	>38	   	; time to do entire switch combo
	.word	sw_right
	.word	sw_right
	.word	sw_up
	.word	0
	.word	0
	.word	0

	.word	sw_left
	.word	sw_left
	.word	sw_up
	.word	0
	.word	0
	.word	0


scom_fn_friend
	.word	>38	   	; time to do entire switch combo
	.word	sw_up
	.word	sw_down
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0

	.word	sw_up
	.word	sw_down
	.word	sw_down
	.word	sw_down
	.word	0
	.word	0

scom_st_friend
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

scom_rd_friend
	.word	>38	   	; time to do entire switch combo
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

scom_nj_friend
	.word	>38	   	; time to do entire switch combo
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

scom_jx_friend
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

;************************************************************************

	.end


