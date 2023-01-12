**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: Reactions 										*
* 											     *
*  copyright (c) 1993 midway manufacturing							*
*											     *
**************************************************************************
	.file	'mkreact.asm'
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
	.text


reaction_tables
	.long	react_to_hh
	.long	react_to_lk
	.long	react_to_jc
	.long	react_to_sa
	.long	react_to_fn
	.long	react_to_fn
	.long	react_to_st
	.long	react_to_rd
	.long	react_to_nj
	.long	react_to_nj
	.long	react_to_nj	; react to ninja table
	.long	react_to_jx
	.long	react_to_go
	.long	react_to_sk
	.long	react_to_nj
	.long	react_to_nj
	.long	react_to_fn

react_to_sk
	.long	r_kahn_punch
	.long	r_kahn_kick
	.long	r_kahn_spear

react_to_go
	.long	r_goro_punch	; 0
	.long	r_goro_uppercut	; 1
	.long	r_goro_punch	; 2
	.long	r_goro_punch	; 3
	.long	r_goro_punch	; 4
	.long	r_goro_punch	; 5
	.long	r_goro_fireball	; 6

react_to_jx
	.long	r_hikicked	; 0
	.long	r_lokicked	; 1
	.long	r_hipunched	; 2
	.long	r_lopunched	; 3
	.long	r_sweep		; 4
	.long	r_duckpunched	; 5
	.long	r_duckkickedh	; 6
	.long	r_duckkickedl	; 7
	.long	r_upcutted	; 8
	.long	r_hhjumpupp	; 9
	.long	r_hhjumpupk	; a
	.long	r_flipk		; b
	.long	r_flipp		; c
	.long	r_roundh	; d
	.long	r_saknee	; e
	.long	r_jax_elbow    	; f
	.long	r_jax_zap	; 10
	.long	r_lokicked	; 11
	.long	r_lokicked	; 12
	.long	r_lokicked	; 13
	.long	r_lokicked	; 14
	.long	r_lokicked	; 15

react_to_nj
	.long	r_hikicked	; 0
	.long	r_lokicked	; 1
	.long	r_hipunched	; 2
	.long	r_lopunched	; 3
	.long	r_sweep		; 4
	.long	r_duckpunched	; 5
	.long	r_duckkickedh	; 6
	.long	r_duckkickedl	; 7
	.long	r_upcutted	; 8
	.long	r_hhjumpupp	; 9
	.long	r_hhjumpupk	; a
	.long	r_flipk	; b
	.long	r_flipp	; c
	.long	r_roundh	; d
	.long	r_saknee	; e
	.long	r_elbow		; f
	.long	r_orb		; 10
	.long	r_spear		; 11
	.long	r_slide		; 12
	.long	r_ice		; 13
	.long	r_lokicked	; 14 - bs
	.long	r_floor_ice	; 15 - slip on floor ice
	.long	r_decoy		; 16
	.long	r_spit		; 17
	.long	r_scissor	; 18
	.long	r_super_freeze	; 19

react_to_rd
	.long	r_hikicked	; 0
	.long	r_lokicked	; 1
	.long	r_hipunched	; 2
	.long	r_lopunched	; 3
	.long	r_sweep		; 4
	.long	r_duckpunched	; 5
	.long	r_duckkickedh	; 6
	.long	r_duckkickedl	; 7
	.long	r_upcutted	; 8
	.long	r_hhjumpupp	; 9
	.long	r_hhjumpupk	; a
	.long	r_flipk		; b
	.long	r_flipp		; c
	.long	r_roundh	; d
	.long	r_saknee	; e
	.long	r_saelbow     	; f
	.long	r_lightning	; 10
	.long	r_lightning	; 11
	.long	r_lokicked	; 12
	.long	r_lokicked	; 13
	.long	r_dive		; 14

react_to_st
	.long	r_hikicked	; 0
	.long	r_lokicked	; 1
	.long	r_hipunched	; 2
	.long	r_lopunched	; 3
	.long	r_sweep		; 4
	.long	r_duckpunched	; 5
	.long	r_duckkickedh	; 6
	.long	r_duckkickedl	; 7
	.long	r_upcutted	; 8
	.long	r_hhjumpupp	; 9
	.long	r_hhjumpupk	; a
	.long	r_flipk		; b
	.long	r_flipp		; c
	.long	r_roundh	; d
	.long	r_saknee	; e
	.long	r_saelbow     	; f
	.long	r_skull		; 10
	.long	r_lokicked	; 11
	.long	r_lokicked	; 12
	.long	r_lokicked	; 13


react_to_fn
	.long	r_hikicked	; 0
	.long	r_lokicked	; 1
	.long	r_hipunched	; 2
	.long	r_lopunched	; 3
	.long	r_sweep		; 4
	.long	r_duckpunched	; 5
	.long	r_duckkickedh	; 6
	.long	r_duckkickedl	; 7
	.long	r_upcutted	; 8
	.long	r_hhjumpupp	; 9
	.long	r_hhjumpupk	; a
	.long	r_flipk		; b
	.long	r_flipp		; c
	.long	r_roundh	; d
	.long	r_saknee	; e
	.long	r_saelbow     	; f
	.long	r_fan		; 10
	.long	r_tsai		; 11
	.long	r_spinfan	; 12
	.long	r_fn_swipe  	; 13
	.long	r_square	; 14
	.long	r_fn_tele	; 15
	.long	r_kano		; 16

react_to_sa
	.long	r_hikicked	; 0
	.long	r_lokicked	; 1
	.long	r_hipunched	; 2
	.long	r_lopunched	; 3
	.long	r_sweep		; 4
	.long	r_duckpunched	; 5
	.long	r_duckkickedh	; 6
	.long	r_duckkickedl	; 7
	.long	r_upcutted	; 8
	.long	r_hhjumpupp	; 9
	.long	r_hhjumpupk	; a
	.long	r_flipk		; b
	.long	r_flipp		; c
	.long	r_roundh	; d
	.long	r_saknee	; e
	.long	r_saelbow     	; f
	.long	r_jc_snot	; 10
	.long	r_jc_shadow	; 11
	.long	r_sa_swipe  	; 12
	.long	r_2nd_knee	; 13
	.long	r_shred		; 14
	.long	r_spin		; 15
	.long	r_spark		; 16
	.long	r_lokicked	; 17

react_to_jc
	.long	r_hikicked	; 0
	.long	r_lokicked	; 1
	.long	r_hipunched	; 2
	.long	r_lopunched	; 3
	.long	r_sweep		; 4
	.long	r_duckpunched	; 5
	.long	r_duckkickedh	; 6
	.long	r_duckkickedl	; 7
	.long	r_upcutted	; 8
	.long	r_hhjumpupp	; 9
	.long	r_hhjumpupk	; a
	.long	r_flipk	; b
	.long	r_flipp	; c
	.long	r_roundh	; d
	.long	r_jcaxe		; e
	.long	r_elbow		; f
	.long	r_jc_snot	; 10
	.long	r_jc_shadow	; 11
	.long	r_jc_shoruken	; 12
	.long	r_lokicked	; 13
	.long	r_jc_pp		; 14
	.long	r_jc_split	; 15
	.long	r_lokicked	; 16
	.long	r_lokicked	; 17


react_to_lk
	.long	r_hikicked	; 0
	.long	r_lokicked	; 1
	.long	r_hipunched	; 2
	.long	r_lopunched	; 3
	.long	r_sweep		; 4
	.long	r_duckpunched	; 5
	.long	r_duckkickedh	; 6
	.long	r_duckkickedl	; 7
	.long	r_upcutted	; 8
	.long	r_hhjumpupp	; 9
	.long	r_hhjumpupk	; a
	.long	r_flipk		; b
	.long	r_flipp		; c
	.long	r_roundh	; d
	.long	r_hhknee	; e
	.long	r_elbow		; f
	.long	r_hhhat		; 10
	.long	r_lkzap		; 11
	.long	r_lokicked	; 12
	.long	r_lokicked	; 13
	.long	r_lk_super	; 14
	.long	r_lk_bike	; 15
	.long	r_lokicked	; 16
	.long	r_lokicked	; 17
	.long	r_lk_dbuc	; 18 - 


react_to_hh
	.long	r_hikicked	; 0
	.long	r_lokicked	; 1
	.long	r_hipunched	; 2
	.long	r_lopunched	; 3
	.long	r_sweep		; 4
	.long	r_duckpunched	; 5
	.long	r_duckkickedh	; 6
	.long	r_duckkickedl	; 7
	.long	r_upcutted	; 8
	.long	r_hhjumpupp	; 9
	.long	r_hhjumpupk	; a
	.long	r_flipk	; b
	.long	r_flipp	; c
	.long	r_roundh	; d
	.long	r_hhknee	; e
	.long	r_elbow		; f
	.long	r_hhhat		; 10
	.long	r_lkzap		; 11
	.long	r_lkzap		; 12
	.long	r_lkzap		; 13
	.long	r_lk_flykick	; 14
	.long	r_lokicked	; 15
	.long	r_lokicked	; 16
	.long	r_hhspin	; 17
	.long	r_super_rep	; 18

**************************************************************************
*											     *
*  reaction_start - standard reaction start routine. everyone reacting   *
*                   to a hit should call this routine 1st.		     *
* 											     *
*  input: a6 = boss reaction offset								*
*											     *
**************************************************************************
reaction_start
	movi	act_reacting,a7
	move	a7,*a13(p_action),w
	clr	a7  			; flag: dont do an airborn check
	jruc	rst0

reaction_start_abc
	movk	1,a7			; flag: check if I am airborn
rst0	movi	rs_calls,a0
	calla	ochar_call
	jruc	rst5


blocked_start
	clr	a7  			; flag: dont do an airborn check
	movi	block_starts,a0
	calla	ochar_call

rst5	mmtm	sp,a5,a6,a7
	callr	reaction_start_chores
	mmfm	sp,a5,a6,a7
	move	a7,a7			; check for airborn hit ?
	jreq	rst2			; no

	calla	am_i_airborn	
	jrnc	rst2
	pull	a0			; no return
	jump	a5

rst2	rets

;*************************************************************************

generic_airborn_hit
	tsound	>19

airborn_hit_no_sound
	calla	rsnd_react_voice
	callr	no_unlimited_airhits

	movi	act_reacting,a1
	move	a1,*a13(p_action),w

	movi	>38000,a0	; a0 = initial x vel
	movi	->60000,a1	; a1 = initial y vel
	movi	>8000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jsrp	flight

	calla	rsnd_react_voice	; speech: uhh !!
	jruc	land_on_my_back

;*************************************************************************

reaction_start_chores
	mmtm	sp,a5,a6
	callr	inc_p_hit
	clr	a7
	move	a7,*a8(ograv),l

	move	*a13(p_flags),a4,w
	btst	pb_sitduck,a4
	jreq	rst1

	movk	1,a0
	move	a0,@f_thatsall,w	; i was a sitting duck ---> thats all !

rst1	ori	pm_reacting,a4
	move	a4,*a13(p_flags),w	; flag: i am reacting to an attack
	calla	delete_slave		; no slaves !!

	move	*a8(oflags2),a4,w
	andni	m_noblock,a4	 	; i am hit ---> now allow blocking !!
	andni	m_inviso,a4	 	; clear inviso flag !
	ori	m_shadow,a4		; turn on shadow
	move	a4,*a8(oflags2),w

	move	a8,a2
	calla	noflip_a2		; u can't flip me if i'm out o control

	clr	a0
	move	a0,*a13(p_stk),w	; I am no longer striking !!
	calla	player_normpal
	calla	face_opponent
	calla	stop_me


uhq_entry
	move	*a13(p_hitby),a7,w	; a7 = action i was hit by
	callr	get_my_hitq		; a0 = my hit queue ram
	move	*a0,a1,w
	move	*a0(16),a2,w
	move	*a0(32),a3,w
	move	*a0(48),a4,w
	move	*a0(64),a5,w		; grab 5 entries to shift down
	move	a7,*a0,w
	move	a1,*a0(16),w
	move	a2,*a0(32),w
	move	a3,*a0(48),w
	move	a4,*a0(64),w
	move	a5,*a0(80),w		; update queue
	mmfm	sp,a5,a6
	rets

update_hit_queue
	mmtm	sp,a5,a6
	jruc	uhq_entry


block_starts
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
	.long	goro_block_calla
	.long	kahn_block_calla
	.long	0
	.long	0
	.long	0

goro_block_calla
	pull	a7
	pull	a7		       	; no deposit no return
	callr	reaction_start_chores
	calla	am_i_airborn
	jrc	goro_hit_while_airborn
	movi	goro_blocks,a7
	jruc	a6_offset_jump

goro_blocks
	.long	goro_block_0
	.long	goro_block_1
	.long	goro_block_2
	.long	goro_block_3
	.long	goro_block_4
	.long	goro_block_5

*
* slide away slightly
*
goro_block_2
	movi	>30000,a0
	calla	away_x_vel  		; move away from him
	movk	8,a9
	calla	get_char_ani
	movk	3,a0
	jsrp	mframew	  			; ani: standing block
	movk	3,a0
	jsrp	drone_beware_mframew		; ani: standing block
	jruc	local_reaction_exit


goro_block_0
goro_block_1
goro_block_3
goro_block_4
goro_block_5
	callr	inc_p_hit
	cmpi	7,a0
	jrlo	gorob3
	jauc	stop_abusive_attackers

gorob3	movk	8,a9
	calla	get_char_ani
	movk	3,a0
	jsrp	mframew			; goro blocking ani
	jruc	local_reaction_exit

;************************************************************************

kahn_block_calla
	pull	a7
	pull	a7		       	; no deposit no return
	callr	reaction_start_chores
	calla	am_i_airborn
	jrc	kahn_hit_while_airborn
	movi	kahn_blocks,a7
	jruc	a6_offset_jump

kahn_blocks
	.long	kahn_block0	; 0 - punch
	.long	kahn_block1	; 1 - kick
	.long	kahn_block2	; 2
	.long	kahn_block0	; 3
	.long	kahn_block0	; 4
	.long	kahn_block0	; 5
	.long	kahn_block0	; 6
	.long	kahn_block0	; 7
	.long	kahn_block0	; 8
	.long	kahn_block0	; 9


kahn_block1
	movi	>20000,a0
	calla	away_x_vel     	; head away from otherguy
	movk	8,a9
	movk	3,a11
	movk	3,a10
	jsrp	block_shake
	jruc	block_exit

kahn_block0
	movi	>c000,a0
	calla	away_x_vel		; head away from otherguy

	movk	3,a5			; not pulling away hits
	movk	3,a6			; pulling away hits
	callr	punch_stumble_check

	movk	8,a9
	movk	2,a11
	movk	3,a10
	jsrp	block_shake
	jruc	block_exit

kahn_block2
	tsound	>18			; block a major hit sound
	movi	>00040004,a11
	calla	shake_a11

	movi	>40000,a0
	calla	away_x_vel   	  	; head away from otherguy
	movk	8,a9
	movk	3,a11
	movk	3,a10
	jsrp	block_shake
	jruc	block_exit

**************************************************************************

rs_calls
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
	.long	goro_reaction_calla
	.long	kahn_reaction_calla

	.long	0
	.long	0
	.long	0

**************************************************************************

kahn_reaction_calla
	pull	a7
	pull	a7		   	; no deposit no return
	callr	reaction_start_chores

	calla	am_i_airborn
	jrc	kahn_hit_while_airborn
	movi	kahn_reactions,a7

a6_offset_jump
	cmpi	9,a6
	jrls	aoj3
    	clr	a6			; out of range = use zero
aoj3	sll	5,a6
	add	a7,a6
	move	*a6,a6,l
	jump	a6


kahn_reactions
	.long	kahn_hit_0	; 0 - barely tapped
	.long	kahn_hit_1	; 1 - med
	.long	kahn_hit_2	; 2 - sweep kicked
	.long	kahn_hit_3	; 3 - stumble #1 (no shake)
	.long	kahn_hit_4	; 4 - stumble / shake / smack
	.long	kahn_hit_5	; 5 - repell hit
	.long	kahn_hit_6	; 6 - uppercutted
	.long	kahn_hit_0	; 7
	.long	kahn_hit_8	; 8
	.long	kahn_hit_9	; 9


kahn_hit_while_airborn
	tsound	>19			; smack
	callr	kahn_wasted_voice

	movk	4,a1
	callr	repell_on_a1_hit	; avoid hacky sack
	
	movi	>38000,a0
	movi	->60000,a1
	movi	>8000,a2		; a2 = gravity
	movk	4,a3			; a3 = ani speed
	movi	>09,a9
	jsrp	flight

	callr	shake_n_sound
	movk	3,a0			; ani speed
	movi	>09,a9
	calla	find_ani_part2
	movk	4,a0
	jsrp	mframew			; shake on yer back
	jruc	getup_local_reaction_exit

;*******************************************************************

kahn_hit_0
	tsound	>19

	movk	3,a5			; not pulling away hits
	movk	3,a6			; pulling away hits
	callr	punch_stumble_check

	movi	>0c,a9
	calla	get_char_ani

	movk	4,a0
	jsrp	mframew			; bump !!!!!
	jruc	local_reaction_exit

;*******************************************************************

kahn_hit_1
	tsound	>19

	movk	3,a5			; not pulling away hits
	movk	3,a6			; pulling away hits
	callr	punch_stumble_check

	movi	>40000,a0
	calla	away_x_vel   		; move away from him
	movi	>0c,a9
	calla	get_char_ani
	movk	4,a0
	jsrp	mframew			; bump !!!!!
	jruc	local_reaction_exit

;*******************************************************************

kahn_hit1
	movi	>20000,a0
	calla	away_x_vel   		; move away from him

kahn_hit_med
	movi	>0c,a9
	calla	get_char_ani
	movi	>00040002,a0
	jsrp	animate_a0_frames
	calla	drone_beware

	movk	5,a11
kht4	sleep	1
	calla	drone_beware
	dsjs	a11,kht4

	movk	4,a0
	jsrp	drone_beware_mframew	; finish hit ani
	jruc	local_reaction_exit

**************************************************************************

kahn_hit_3
	movi	>001b001c,a1
	calla	randsnd			; either of these monster hit sounds

kahn_hit_2
	callr	kahn_wasted_voice

	movi	>30000,a0
	calla	away_x_vel   		; move away from him
	movi	>10,a9
	calla	get_char_ani
	movk	4,a0
	jsrp	mframew			; stumble back !!
	jruc	local_reaction_exit

**************************************************************************

kahn_hit_4
	movi	>001b001c,a1
	calla	randsnd	 	; either of these monster hit sounds

kahn_hit_5
	callr	kahn_wasted_voice

	movi	>40000,a0	; a0 = initial x vel
	movi	->70000,a1	; a1 = initial y vel
	movi	>8000,a2	; a2 = gravity	
	movk	4,a3		; a3 = ani speed
	movi	>09,a9		; a9 = ani offset
	jsrp	flight
	jruc	reaction_land

**************************************************************************

kahn_hit_6
	movi	>00080008,a11
	calla	shake_a11

	callr	kahn_wasted_voice

	movi	>20000,a0	; a0 = initial x vel
	movi	->c0000,a1	; a1 = initial y vel
	movi	>6000,a2	; a2 = gravity	
	movk	4,a3		; a3 = ani speed
	movi	>09,a9		; a9 = ani offset
	jsrp	flight
	jruc	reaction_land

**************************************************************************

kahn_hit_8
	calla	kahn_wasted_voice
	movi	>10,a9
	jruc	kahn_spell_entry

**************************************************************************


kahn_wasted_voice
	movi	>00560057,a1
	jauc	randsnd2

**************************************************************************

goro_reaction_calla
	pull	a7
	pull	a7		   	; no deposit no return
	callr	reaction_start_chores

	cmpi	6,a6
	jreq	goro_hit_6		; goro upcutted ---> do in air too

	cmpi	8,a6
	jreq	goro_hit_8		; goro hit with fan ---> do fan react

	calla	am_i_airborn
	jrc	goro_hit_while_airborn

	cmpi	9,a6
	jrls	grc3
    	movk	9,a6
grc3	sll	5,a6
	addi	goro_reaction_table,a6
	move	*a6,a6,l
	jump	a6

goro_reaction_table
	.long	goro_hit_0
	.long	goro_hit_1
	.long	goro_hit_2
	.long	goro_hit_3
	.long	goro_hit_4
	.long	goro_hit_5
	.long	goro_hit_6
	.long	goro_hit_7
	.long	goro_hit_8 	; goro caught in fan spell
	.long	goro_hit_9	; goro tripped by kano move

goro_hit_0
goro_hit_1
	movi	>28000,a0
	calla	away_x_vel   		; move away from him

	tsound	>af			; goro hit sound
	movi	>0c,a9
	calla	get_char_ani
	movk	4,a0
	jsrp	mframew		   	; hit animation
	jruc	local_reaction_exit

*
* goro long stumble back !!
*
goro_hit_7
	movi	>00040004,a11
	calla	shake_a11
	tsound	>19			; smack
	tsound	>ae			; goro hit hard voice
	movi	>38000,a0
	jruc	stumble_back_vel

*
* goro stumble with: roar only
*
goro_hit_2
	jruc	gost3

*
* goro stumble with: smack / shake screen / roar
*
goro_hit_3
	movi	>00040004,a11
	calla	shake_a11
	tsound	>19			; smack
gost3	tsound	>ae			; goro hit hard voice
	movi	>28000,a0
	jruc	stumble_back_vel

goro_hit_4
	movi	>0002001b,a0		; [total # of entries, 1st entry]
	calla	random_triple		; random big smack

goro_hit_5
	tsound	>ae			; goro hit hard voice

	movi	>40000,a0		; a0 = initial x vel
	movi	->80000,a1   		; initial y vel
	movi	>8000,a2		; grav
	movk	5,a3			; a3 = ani speed
	clr	a6	     		; routine
	movk	9,a9
	jsrp	flight
	jruc	goro_shake_on_back

*
* goro getting uppercutted
*
goro_hit_6
	tsound	>ae		; goro hit hard voice
	movi	>00080008,a11
	calla	shake_a11

	movi	>40000,a0	; a0 = initial x vel
	movi	->b0000,a1   	; initial y vel
	movi	>8000,a2	; grav
	movk	5,a3		; a3 = ani speed
	clr	a6	     	; routine
	movk	>0e,a9
	jsrp	flight
	jruc	goro_shake_on_back


goro_hit_while_airborn
	tsound	>19			; smack
	movi	>00ae00b0,a1
	calla	randsnd		    	; random goro big hit voice

	movk	4,a1
	callr	repell_on_a1_hit	; avoid hacky sack

	movi	>38000,a0
	movi	->60000,a1
	movi	>8000,a2		; a2 = gravity
	movk	4,a3			; a3 = ani speed
	jruc	fall_on_my_back

goro_last_noogy
	calla	ground_player
	movi	>50000,a0
	jruc	stumble_back_vel

**************************************************************************
*											     *
*  get_my_hitq - get a pointer to my hit queue					     *
* 											     *
*  input: a8 = object who wants 2 know						     *
* 											     *
*  returns: a0 = pointer to my hit queue						     *
*											     *
**************************************************************************
get_my_hitq
	push	a1
	movi	p1_hitq,a0
	move	@p1_obj,a1,l		; a1 = player 1 object
	cmp	a1,a8			; me ?
	jreq	gmhq3			; yes
	movi	p2_hitq,a0		; no, use hit queue for player 2 (me)
gmhq3  	pull	a1
	rets

;************************************************************************

r_goro_uppercut
	tsound	>1b

	clr	a6
	callr	reaction_start
	calla	rsnd_wasted_voice
	movi	>00080008,a11
	calla	shake_a11      	; shake the earth

	movi	>20000,a0	; a0 = initial x vel
	movi	->130000,a1	; a1 = initial y vel
	movi	>8000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jruc	fly_from_goro


r_kahn_kick
r_kahn_punch
r_goro_punch
	tsound	>1b

r_goro_fireball
	clr	a6
	callr	reaction_start
	calla	rsnd_wasted_voice
	movi	>00080008,a11
	calla	shake_a11      	; shake the earth

	movi	>50000,a0	; a0 = initial x vel
	movi	->80000,a1	; a1 = initial y vel
	movi	>8000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset

fly_from_goro
	push	a0
	tsound	>b3		; crowd
	pull	a0

	jsrp	flight
	callr	shake_n_sound

	movi	>0f,a9		; a9 = ani offset
	calla	find_ani_part2
	movk	6,a0
	jsrp	mframew		; thudd ani
;	sleep	8
	jruc	getup_local_reaction_exit

;************************************************************************

r_square
	clr	a6
	callr	reaction_start
	calla	rsnd_react_voice
	movi	>00080008,a11
	calla	shake_a11			; shake the earth
	tsound	>1b

	movi	>40000,a0
	movi	->20000,a1
	movi	>8000,a2			; a2 = gravity
	movk	5,a3				; a3 = ani speed
	jruc	fall_on_my_back

;************************************************************************

r_quake
	movi	act_quake,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated

	clr	a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc
	movi	>28000,a0
	calla	away_x_vel   		; move away from her
	movk	20,a10
	movi	>00040023,a9
	jsrp	animate_a9		; stumble ani
	jruc	local_reaction_exit

;************************************************************************

r_floor_ice
	movi	act_floor_ice,a1
	move	a1,*a13(p_hitby),w

	calla	am_i_joy
	jrc	rfloor3			; joy = sucka !!

	callr	get_his_floor_ice
	jaeq	reaction_exit
	move	*a0(pa11),a1,l		; how much more time was left over ?
	cmpi	>20,a1
	jrhi	rfloor3			; too much ---> slip slidin away
	jauc	reaction_exit		; i am free of this ice

rfloor3	movi	act_floor_ice,a1
	move	a1,*a13(p_hitby),w	; make sure this gets queued

	clr	a6
	callr	reaction_start

	calla	set_no_block		; sans blocking
	calla	ground_player
	movi	act_slipping,a0
	move	a0,*a13(p_action),w	; define my action !
	movi	>37,a9
	calla	get_char_ani

	movi	>50,a14
	calla	am_i_joy
	jrc	rfloor4
	movi	>40,a14			; drones = shorter slip time

rfloor4	move	a14,a0
	move	a0,*a13(p_store8),w
	movk	1,a0
	move	a0,*a13(p_store7),w	; 1st slip voice sound now
	move	a0,*a13(p_store6),w	; 1st slip fx sound now

	movk	4,a0
	calla	init_anirate
*
* decide initial vel
*
	move	*a8(oxpos),a2,w		; a2 = my x
	move	a2,a3
	sub	a10,a2
	sub	a11,a3
	abs	a2
	abs	a3
	cmp	a2,a3
	jrlo	rfi6

rfi1	movi	>10000,a0
	calla	set_x_vel		; start moving !
rfi5	jsrp	slip_sleep
	move	*a8(oxpos),a2,w		; a2 = my x
	sub	a11,a2
	abs	a2			; distance from right side
	cmpi	>05,a2
	jrhi	rfi5

rfi6	movi	->10000,a0
	calla	set_x_vel		; start moving !
rfi7	jsrp	slip_sleep
	move	*a8(oxpos),a2,w		; a2 = my x
	sub	a10,a2
	abs	a2			; distance from right side
	cmpi	>05,a2
	jrhi	rfi7
	jruc	rfi1

slip_sleep
	sleep	1
	calla	next_anirate

	move	*a13(p_store7),a0,w
	dec	a0
	jrne	sslp3

	movi	next_left_slip,a1
	move	*a8(oid),a2,w
	cmpi	oid_p1,a2
	jreq	sslp1
	movi	next_right_slip,a1
sslp1	move	*a8(ochar),a2,w
	cmpi	ft_fn1,a2
	jreq	sslp2
	cmpi	ft_fn2,a2
	jreq	sslp2
	cmpi	ft_jade,a2
	jrne	sslp5

sslp2	movi	next_girl_slip,a1
sslp5	call	a1
	movk	25,a0
sslp3	move	a0,*a13(p_store7),w

	move	*a13(p_store6),a0,w	; 1st slip voice sound now
	dec	a0
	jrne	sslp6
	movk	4,a0
	calla	randu
	dec	a0
	addi	>ec,a0
	calla	triple_sound
	movk	12,a0
sslp6	move	a0,*a13(p_store6),w

	move	*a13(p_store8),a0,w
	dec	a0
	move	a0,*a13(p_store8),w
	jreq	slip_done
	retp

slip_done
	pullp	a0
	jruc	local_reaction_exit


get_his_floor_ice
	movi	pid_floor_ice2,a0
	move	*a8(oid),a1,w
	cmpi	1,a1
	jreq	rfloor2
	movi	pid_floor_ice1,a0
rfloor2	clr	a1
	not	a1
	jauc	existp


get_ice_ends
	move	a10,a3
	move	a11,a4
	move	*a8(oxpos),a2,w	; a2 = my x
	sub	a2,a3
	sub	a2,a4
	abs	a3	    	; distance from left
	abs	a4	    	; distance from right
	rets


next_left_slip
	movi	>e0,a1
	jruc	next_slip

next_right_slip
	movi	>d9,a1
	jruc	next_slip

next_girl_slip
	movi	>e6,a1

next_slip
	movk	5,a0
	calla	randu
	dec	a0
	add	a1,a0
	jauc	triple_sound

;************************************************************************

r_ice
	movi	act_throw_ice,a1
	move	a1,*a13(p_hitby),w	; make sure this gets queued

	callr	reaction_start_chores

	cmpi	freeze_wakeup,a9	; re-freeze ??
	jreq	freeze_backfire		; yes, teach that fucker a lesson
	
;************************
;	calla	am_i_airborn
;	jrnc	frz1
;	move	a13,a10
;	create	pid_comment,crowd_ooo_proc	; froze in air = "ooo"
;frz1
;************************

	calla	stop_me			; sans movement
	calla	set_no_block		; sans blocking
	calla	me_in_back

	movi	act_frozen,a0
	move	a0,*a13(p_action),w	; define my state !

	calla	player_froze_pal

;	move	*a13(p_flags),a4,w
;	andni	pm_reacting,a4
;	move	a4,*a13(p_flags),w	; flag: i am not reacting anymore !!

	move	*a8(oflags2),a4,w
	andni	m_noflip,a4
	move	a4,*a8(oflags2),w	; flag: i can be flipped !!
	movi	freeze_wakeup,a9	; flag: i am frozen

	move	a8,a10
	movk	2,a1
	movi	>00040008,a0
	jsrp	shake_him_up

	sleep	>80

freeze_wakeup
	calla	player_normpal
	jauc	reaction_exit


freeze_backfire
	movi	r_ice,a7
	calla	takeover_him		; freeze the otherguy !!
	jruc	freeze_wakeup		; and un-freeze me !

;************************************************************************

r_null_speared
	clr	a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc
	jruc	stumble_back

r_spear	
	movi	ft_goro,a0
	calla	am_i_him
	jrnc	rspear2
	tsound	>ae		 	; goro = roar
	jruc	rspear4

rspear2	movi	kahn_wasted_voice,a6
	movi	ft_final_boss,a0
	calla	am_i_him
	jrc	rspear3
	movi	rsnd_wasted_voice,a6
rspear3	call	a6

rspear4	clr	a6
	callr	reaction_start_chores
	sleep	2
	move	*a13(p_otherproc),a11,l
	move	*a11(p_action),a0,w
	cmpi	act_rope_pull,a0	; still doing spear move ?
	jreq	rspear4			; yes, let him do his thang !!
	jruc	local_reaction_exit	; no, I'm free !!

;************************************************************************
kahn_hit_9
	callr	kahn_wasted_voice
	calla	face_opponent
	calla	flip_multi		; face away for this animation
	movk	9,a9			; knocked down ani
	movi	->40000,a0		; a0 = initial x vel
	jruc	goro_kanoed_entry

goro_hit_9
	tsound	>ae			; roar
	calla	face_opponent
	calla	flip_multi		; face away for this animation

	movk	9,a9			; knocked down ani
	movi	->40000,a0		; a0 = initial x vel
	jruc	goro_kanoed_entry

r_kano	movi	act_kano,a1
	move	a1,*a13(p_hitby),w	; make sure this gets queued
	movi	>00080008,a11
	calla	shake_a11

	tsound	>1a

	movk	9,a6
	callr	reaction_start
	calla	rsnd_react_voice

	movi	>3a,a9			; a9 = ani offset
	movi	->30000,a0		; a0 = initial x vel

goro_kanoed_entry
	movi	->a0000,a1   		; initial y vel
	movi	>8000,a2		; grav
	movk	4,a3			; a3 = ani speed
	clr	a6	     		; routine
	jsrp	flight
	jruc	land_on_my_back


r_orb	movi	act_slow_orb,a1
	move	a1,*a13(p_hitby),w	; make sure this gets queued

	clr	a6
	callr	reaction_start
	calla	rsnd_react_voice

	movi	->38000,a0	; a0 = initial x vel
	movi	->80000,a1   	; initial y vel
	movi	>6000,a2	; grav
	movk	4,a3		; a3 = ani speed
	clr	a6	     	; routine
	movi	>3a,a9		; a9 = ani offset
	jsrp	flight
	jruc	land_on_my_back

;************************************************************************

post_broken_back
	movi	>3f,a9
	calla	get_char_ani
	calla	find_last_frame
	calla	do_next_a9_frame

	movi	>38000,a0
	movi	->80000,a1
	movi	>a000,a2
	movi	never_ani,a3
	jsrp	flight

	calla	player_normpal		; thanks tobias (sarcasm again)
	jruc	land_on_my_back

;************************************************************************

r_slide
	movk	4,a6
	callr	reaction_start
	calla	rsnd_react_voice
	movi	>30000,a0
	calla	away_x_vel       	; zoom !!

	movi	>38000,a0		; a0 = initial x vel
	movi	->60000,a1   		; initial y vel
	movi	>6000,a2		; grav
	movk	4,a3			; a3 = ani speed
	clr	a6	     		; routine
	movi	>0f,a9			; a9 = ani offset
	jsrp	flight
	jruc	land_on_my_back

;************************************************************************

r_lightning
	movi	act_throw_bolt,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated

	movk	2,a6
	movi	airborn_hit_no_sound,a5
	callr	reaction_start_abc
	movi	>30000,a0
	calla	away_x_vel   		; move away from him

	calla	rsnd_wasted_voice

	movi	ochar_froze_pals,a0
	calla	get_char_long
	move	a0,a10			; zappped pal

	jsrp	lightning_stumble
	jsrp	lightning_stumble

	jruc	local_reaction_exit

lightning_stumble
	movi	>23,a9
	calla	get_char_ani
	movk	2,a0
	calla	init_anirate

	movk	3,a11
rlight2	sleep	1
	calla	next_anirate
	jreq	rlight9			; animation done
	dsj	a11,rlight2
	movk	5,a11
	movi	player_froze_pal,a1
	move	*a13(p_flags),a4,w
	btst	pb_alt_pal,a4		; we using alternate pal ?
	jreq	rlight3			; yes
	movi	player_normpal,a1
rlight3	call	a1
	jruc	rlight2

rlight9	calla	player_normpal
	retp

;************************************************************************

r_dive
	movi	act_dive,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated

	movi	>60,a11
dif2	sleep	2
	move	*a13(p_otherproc),a0,l
	move	*a0(pwake),a0,l		; raidens wakeup address
	cmpi	raiden_dragging,a0	; is he in control still ?
	jrne	dif3			; no, exit
	dsj	a11,dif2		; max time in this state
dif3	jauc	local_reaction_exit	; in case things fuck up

;************************************************************

goro_hit_8
	tsound	>ae			; bob ROAR-man !
	movi	>10,a9
	jruc	goro_spell_entry


r_spinfan
	movk	8,a6
	callr	reaction_start
	movi	>37,a9

kahn_spell_entry
goro_spell_entry
	calla	do_first_a9_frame

	movi	act_wave_sd,a1
	move	a1,*a13(p_action),w

	clr	a6
	calla	distance_from_ground
	cmpi	>a8,a0
	jrhi	rwave2
	movi	->10000,a6
rwave2	move	a6,*a8(oyvel),l		; if close to ground ---> head up !

	movi	>00040008,a0
	movk	3,a1
	move	a8,a10
	jsrp	shake_him_up		; start things off with a shake
*
* float up / away !
*
	clr	a6			; assume no yvel setting
	calla	distance_from_ground
	cmpi	>f0,a0
	jrhi	rwave4
	movi	->10000,a6
rwave4	move	a6,*a8(oyvel),l

	movi	>20000,a0
	callr	is_he_flipped
	jrc	rwave5
	neg	a0
rwave5	calla	set_x_vel   		; move away from her

	movk	3,a10			; ticks between shakes
	movk	4,a9			; x adjustment
	movi	>40,a11
rwave7	sleep	1
	dsj	a10,rwave9

	movk	3,a10
	neg	a9			; flip x adjustment direction	
	move	a9,a0
	move	a9,a1
	calla	multi_adjust_xy		; shake while floating

rwave9	calla	distance_from_ground
	cmpi	>f0,a0			; too high ?
	jrls	rwave8			; no
	clr	a0
	move	a0,*a8(oyvel),l		; yes, stop raising up !!
rwave8	dsj	a11,rwave7

	jruc	local_reaction_exit

;********************************************

is_he_flipped
	move	*a13(p_otherguy),a4,l
	move	*a4(oflags),a4,w
	btst	b_fliph,a4
	jreq	ihfy
	clrc
	rets
ihfy	setc
	rets

;********************************************

r_jax_zap
	movi	act_jax_zap,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated

	movi	>00050005,a11
	calla	shake_a11

	movk	2,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	calla	rsnd_wasted_voice

	movi	>30000,a0
	calla	away_x_vel
	movk	20,a10
	movi	>00040023,a9
	jsrp	animate_a9		; stumble ani
	jruc	local_reaction_exit

;********************************************

r_tsai
	movi	act_throw_tsai,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated

	movk	2,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	calla	rsnd_wasted_voice

	movi	>28000,a0
	calla	away_x_vel   		; move away from her
	movk	20,a10
	movi	>00040023,a9
	jsrp	animate_a9		; stumble ani
	jruc	local_reaction_exit

;********************************************

r_fan
	movi	act_throw_fans,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated

	calla	am_i_a_boss
	jrc	rfan0
	calla	rsnd_wasted_voice
rfan0	movi	ft_goro,a0
	calla	am_i_him
	jrnc	rfan00
	tsound	>ae			; goro = roar
rfan00
	clr	a6
	callr	reaction_start_chores
	calla	am_i_airborn		; hit while in the air ?
	jrnc	rfan1			; no

	clr	a0
	clr	a1
	movi	>3000,a2		; a2 = gravity
	movk	4,a3			; a3 = ani speed

	movi	>00110037,a9		; a9 = ani offset
	calla	goro_pick_ani
	jsrp	flight

rfan1	movi	>20000,a0
	calla	away_x_vel   		; move away from her
rfan2	movk	12,a10

rfan3	movi	>00040023,a9
	calla	if_not_boss_branch
	.long	rfan4
	movi	>00040010,a9
rfan4	jsrp	animate_a9		; stumble ani
	dsj	a10,rfan3
	jruc	local_reaction_exit

;*****************************************************

r_lk_bike
	sleep	4
	jruc	local_reaction_exit		; in case KANG gets distracted

;************************************************************************

r_sa_swipe
	movi	act_swipe,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated
	jruc	swipe3

r_fn_swipe
	movi	act_fan_swipe,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated

;*****************
	calla	am_i_airborn
	jrnc	swipe3
	calla	am_i_close_to_edge
	jrnc	swipe3			; edge = repell
	movi	attacker_getting_separated,a7
	calla	xfer_otherguy
;*****************

swipe3	clr	a0
	calla	create_blood_proc

	tsound	>44
	movk	2,a6
	movi	airborn_hit_no_sound,a5
	callr	reaction_start_abc

	calla	rsnd_wasted_voice
	movi	>40000,a0
	calla	away_x_vel   		; move away from him
	movi	>00040023,a9
	jsrp	animate_a9		; stumble ani
	jruc	local_reaction_exit

;************************************************************************

b_sweep
	clr	a6
	callr	blocked_start
	calla	rsnd_block

	movi	>30000,a0
	movi	>30000,a1
	clr	a7
	callr	repell_one_of_us

	calla	am_i_short		; am I crouched down low ?
	jrc	duck_block_shake	; yes

	movk	2,a11
	movk	2,a10
	jruc	block_shake_n_exit

duck_block_shake
	movi	>0c,a9
	movk	2,a11
	movk	2,a10
	jsrp	block_shake

	calla	am_i_joy
	jac	joy_duck_block_loop	; joy dude = back to the loop
	jauc	drone_post_duck_hit

;************************************************************************

b_big_hit
	movk	2,a6
	callr	blocked_start
	tsound	>18			; block a major hit sound

	movi	>00040004,a11
	calla	shake_a11

	movi	>40000,a0
	calla	away_x_vel

	movk	2,a11
	movk	3,a10
	jruc	block_shake_n_exit

;************************************************************************

b_spin
	movk	2,a6
	callr	blocked_start
	movk	3,a10
	calla	damage_to_me		; ow !

bspin5	calla	rsnd_block

	movi	>0b,a9
	movk	2,a11
	movk	2,a10
	jsrp	block_shake
	sleep	2
	calla	next_anirate
	calla	get_his_action
	cmpi	act_sa_spin,a1		; still spinning ?
	jreq	bspin5			; yes

	movk	2,a11
	movk	4,a10
	jruc	block_shake_n_exit

;************************************************************************

r_spin
	movi	act_sa_spin,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated

	clr	a6
	callr	reaction_start
	movi	>25,a9
	calla	get_char_ani
	movk	2,a0
	calla	init_anirate

rspin5	sleep	2

	movk	1,a10
	calla	damage_to_me		; ow !

	calla	next_anirate
	calla	get_his_action
	cmpi	act_sa_spin,a1		; still spinning ?
	jreq	rspin5			; yes

	movi	>00020008,a0
	jsrp	animate_a0_frames
	jruc	local_reaction_exit

;************************************************************************
r_shred
	callr	reaction_start_chores
	calla	am_i_a_boss
	jrc	rshrd1				; bosses dont scream like people
	calla	rsnd_wasted_voice
	jruc	rshrd00

rshrd1	movi	ft_goro,a0
	calla	am_i_him
	jrnc	rshrd0
	tsound	>b1				; goro = roar sound
	jruc	rshrd00
rshrd0	callr	kahn_wasted_voice

rshrd00
	clr	a0
	move	a0,*a13(p_action),w

	calla	get_x_dist
	cmpi	>50,a3
	jrhi	rshrd2

	calla	match_me_with_him
	calla	flip_multi
	movi	->30,a0
	movi	->20,a1
	calla	multi_adjust_xy			; no, lineup on blades

rshrd2	movi	>00150025,a9
	calla	boss_pick_ani
	calla	get_char_ani
	movk	2,a0
	calla	init_anirate

	movk	5,a10
rshrd3	sleep	2
	calla	face_opponent
	clr	a7
	calla	distance_from_ground
 	cmpi	>b0,a0
	jrls	rshrd5
	movi	>10000,a7	; too high off ground ---> head down
rshrd5	move	a7,*a8(oyvel),l

	calla	next_anirate
	calla	get_his_action
	cmpi	act_shred,a1
	jreq	rshrd3

	movi	>60000,a0
	movi	->50000,a1
	movi	>8000,a2	; a2 = gravity
	movk	5,a3		; a3 = ani speed
	movi	>0009000f,a9	; a9 = ani offset
	calla	boss_pick_ani
	
	jsrp	flight
	jruc	land_on_my_back


post_fanned
	movi	>40000,a0
	movi	->40000,a1
	movi	>6000,a2	; a2 = gravity
	movk	5,a3		; a3 = ani speed
	movi	>0009000f,a9 	; a9 = ani offset
	calla	goro_pick_ani
	jsrp	flight
	jruc	land_on_my_back


r_jax_elbow
	calla	rsnd_wasted_voice

	clr	a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc
	tsound	>19
	movi	>00060006,a11
	calla	shake_a11

	movi	act_jax_dizzy,a0
	move	a0,*a13(p_action),w	; define my action
	calla	set_no_block		; sans blocking

	movi	>40000,a0
	calla	away_x_vel		; head away from otherguy
	movi	>10,a9
	calla	get_char_ani
	movi	>00030002,a0
	jsrp	animate_a0_frames
	calla	stop_me

	movi	>00030005,a0
	movk	3,a1
	move	a8,a10
	jsrp	shake_him_up

	movi	>28,a9
	calla	get_char_ani		; ani: dizzy
	movi	>00060009,a0
	jsrp	animate_a0_frames
	jruc	local_reaction_exit



r_saelbow
	movk	3,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	tsound	>19
	calla	rsnd_wasted_voice

	movi	>00050005,a11
	calla	shake_a11
	movi	>60000,a0
	calla	away_x_vel		; head away from otherguy

hikicked_entry
	movi	>10,a9
	calla	get_char_ani
	calla	do_next_a9_frame
	sleep	2
	calla	do_next_a9_frame

	sleep	12

	move	*a8(oxvel),a0,l
	abs	a0
	srl	2,a0
	calla	away_x_vel

	movi	>00030023,a9
	jsrp	animate_a9

*
* slow down !!
*
;	movk	6,a11
;sael3	move	*a8(oxvel),a0,l
;	abs	a0
;	move	a0,a1
;	srl	5,a1
;	sub	a1,a0
;	calla	away_x_vel		; head away from otherguy
;	sleep	1
;	dsj	a11,sael3

	calla	stop_me		; stop !
	movi	>10,a9
	calla	get_char_ani
	addi	32,a9		; head snapped way back frame !
	movk	4,a0
	jsrp	mframew
	jruc	local_reaction_exit

r_spit
	movi	act_spit,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated

	create	pid_fx,spit_smoke
	move	a8,*a0(pa10),l		; pass me to smoke proc
	movk	2,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	calla	rsnd_wasted_voice
	jruc	stumble_back

;****************************************************************************

r_lkzap
	movi	act_lkzap_hi,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated

	create	pid_fx,kang_smoke
	move	a8,*a0(pa10),l		; pass me to smoke proc

	movk	2,a6
	movi	ar_lkzap,a5
	callr	reaction_start_abc

	calla	rsnd_wasted_voice
	jruc	stumble_back

ar_lkzap
	movi	>38000,a0		; a0 = initial x vel
	movi	->60000,a1		; a1 = initial y vel
	movi	>7000,a2		; a2 = gravity	
	movk	5,a3			; a3 = ani speed
	movi	>0f,a9			; a9 = ani offset
	jsrp	flight
	jruc	land_on_my_back

;****************************************************************************

r_lk_dbuc
	tsound	>1b
	calla	rsnd_wasted_voice
	movk	1,a0
	calla	create_blood_proc
	movi	>00060006,a11
	calla	shake_a11	; shake upon contact

	movk	6,a6
	callr	reaction_start

	movi	>10000,a0	; a0 = initial x vel
	movi	->100000,a1	; a1 = initial y vel
	movi	>6000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jsrp	flight
	jruc	reaction_land


r_hhspin
r_upcutted
	move	*a13(p_action),a1,w

	cmpi	act_slime_fall,a1
	jaeq	r_fall_in_slime		; into the slime
	cmpi	act_pre_shatter,a1
	jaeq	r_shatter_punch
	cmpi	act_pit_fall,a1
	jreq	r_fall_down_pit		; 365 degrees, falling down the pit !!
	cmpi	act_spike_rise,a1
	jreq	r_spike_rise		; up the spikes

	calla	am_i_close_to_edge
	jrnc	rupc3

	movi	attacker_getting_separated,a7
	calla	takeover_him

rupc3	create	pid_fx,upcut_comment

	movk	1,a0
	calla	create_blood_proc
	movi	>001b001c,a1
	calla	randsnd			; either of these monster hit sounds

	movk	6,a6
	callr	reaction_start

	calla	rsnd_wasted_voice
	movi	>00060006,a11
	calla	shake_a11		; shake upon contact

	movi	>20000,a0		; a0 = initial x vel
	movi	->c0000,a1		; a1 = initial y vel
	movi	>6000,a2		; a2 = gravity	
	movk	5,a3			; a3 = ani speed
	movi	>0f,a9			; a9 = ani offset
	jsrp	flight

	calla	rsnd_react_voice	; speech: uhh !!
	jruc	reaction_land

;*************************************************************************

upcut_comment
	sleep	>10
	calla	am_i_a_boss
	jrc	upc9			; dont compliment on a boss

	move	@gstate,a0,w
	cmpi	gs_amode,a0
	jreq	upc9			; amode = no comment

;****************
	move	@curback,a0,w
	cmpi	7,a0			; portal ?
	jrne	upc3			; no....
	calla	count_active_players
	cmpi	2,a0
	jrne	upc1			; portal and 1 player ---> no toasty !!
;****************

upc3	movi	40,a0
	calla	randper
	jac	forden_peek

upc1	move	@curback,a0,w
	cmpi	8,a0
	jrne	upc5

	movi	>b3,a0			; arena = crowd
	jruc	upc4

upc5	movk	5,a0
	calla	randu
	dec	a0
	addi	>30,a0
upc4	calla	triple_sound2		; random comment
upc9	die

;*******************************************************************

r_hhjumpupk
	clr	a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	tsound	>19
	calla	rsnd_react_voice

	movi	>00040004,a11
	calla	shake_a11

	movi	>10000,a0
	calla	away_x_vel			; head away from otherguy
	movi	>00040011,a9
	jsrp	animate_a9		; ani: hit in chest
	jruc	local_reaction_exit


***************************************************************

r_duckkickedl
	calla	rsnd_body_hit

	movk	1,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	movi	>30000,a0
	movi	>70000,a1
	movi	attacker_getting_separated,a7
	callr	repell_one_of_us

	movi	>11,a9
	calla	get_my_height		; a1 = my height
	cmpi	>60,a1
	jrhi	dked4
	movi	>1b,a9	     		; hit while ducking

dked4  	calla	get_char_ani
	addi	32*2,a9	     		; for low duck kick skip frame 3
	movk	4,a0
	jsrp	mframew
	jruc	local_reaction_exit


r_duckkickedh
	calla	rsnd_smack

	movk	1,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	movi	>40000,a0
	movi	>70000,a1
	movi	attacker_getting_separated,a7
	callr	repell_one_of_us

	movi	>00030011,a9			; hit while standing
	calla	get_my_height			; a1 = my height
	cmpi	>60,a1
	jrhi	dked6
	movi	>0003001b,a9			; hit while ducking
dked6	jsrp	animate_a9			; ani: hit in chest
	jruc	local_reaction_exit


r_duckpunched
	calla	rsnd_smack

	movk	5,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	movi	>30000,a0
	movi	>70000,a1
	movi	attacker_getting_separated,a7
	callr	repell_one_of_us

	calla	highest_mpart	
	move	@ground_y,a1,w
	sub	a0,a1		; a1 = my current height
	cmpi	>80,a1		; was i ducking ?
	jrhi 	r_lopunched	; no

	movi	>0003001b,a9
	jsrp	animate_a9	; yes ---> ani = duck hit
	calla	stop_me

	calla	am_i_joy
	janc	drone_post_duck_hit

duck_ani_exit
	calla	is_stick_down
	jac	joy_getup_entry	; stay down while stick = down
	jauc	joy_back_up

************************************************************************

r_jc_split
	clr	a6
	callr	reaction_start
	calla	rsnd_wasted_voice
	calla	ground_player

	movi	act_balled,a1
	move	a1,*a13(p_action),w	; define my action

	tsound	>1d
	movi	>00040006,a11
	calla	shake_a11

	movi	>36,a9
	calla	get_char_ani
	movk	4,a0
	jsrp	mframew			; bend over
*
* shake
*
	movi	>00050007,a0
	movk	4,a1
	move	a8,a10
	jsrp	shake_him_up

	movi	>10000,a0
	calla	away_x_vel

	movi	>00050002,a0
	movk	4,a1
	move	a8,a10
	jsrp	shake_him_up
	movi	>36,a9
	calla	find_ani_part2

	movk	6,a0
	jsrp	mframew	
	jruc	local_reaction_exit
	
************************************************************************

r_jc_shoruken
	tsound	>19

     	movk	4,a6
	callr	reaction_start
	calla	rsnd_wasted_voice

	movi	>00040004,a11
	calla	shake_a11

	movi	>38000,a0	; a0 = initial x vel
	movi	->d0000,a1	; a1 = initial y vel
	movi	>8000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jsrp	flight

	callr	shake_n_sound

	movi	>0f,a9		; a9 = ani offset
	calla	find_ani_part2
	movk	6,a0
	jsrp	mframew		; thudd ani
	sleep	8
	jruc	getup_local_reaction_exit

************************************************************************

r_jc_shadow
	movk	7,a6
	movk	4,a6

	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	tsound	>1b
	calla	rsnd_wasted_voice
	movi	>00040004,a11
	calla	shake_a11

	movi	>60000,a0
	calla	away_x_vel	     		; zoom !!

	movi	>0004000f,a9
	jsrp	animate_a9
*
* hit the ground
*
	calla	rsnd_react_voice	; speech: uhh !!
	calla	stop_me
	movi	>00040004,a11
	calla	shake_a11
	movk	4,a0
	jsrp	mframew
	sleep	10
	jruc	getup_local_reaction_exit


r_jc_snot
	movi	act_jcsnot_lo,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated
	jruc	snot_entry

r_spark
	movi	act_spark,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated
	jruc	snot_entry


r_hhhat
	move	*a13(p_otherproc),a0,l
	move	*a0(p_stk),a0,w
	cmpi	act_hat_killer,a0	; is he trying to decap me ?
	jrne	hat_chop_cancell	; no, skip

	calla	get_his_proj_proc	; a0 = projectile process
	jreq	hat_chop_cancell

	move	*a0(pa8),a0,l		; a0 = projectile
	move	*a0(oypos),a0,w
	move	@ground_y,a1,w
	sub	a0,a1
	abs	a1
	cmpi	>68,a1
	jrlo	hat_chop_cancell	; not on target
	cmpi	>76,a1
	jrhi	hat_chop_cancell	; not on target
	jauc	r_hat_decap		; bingo !!!

hat_chop_cancell
	clr	a1
	move	a1,@f_death,w	  	; cacell the party !!!
	jruc	hat33


r_skull	movi	act_throw_skull1,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated

	movk	2,a6	   		; stumble sans noise
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc
	calla	rsnd_wasted_voice

	movi	>00040004,a11
	calla	shake_a11
	movi	>30000,a0
	calla	away_x_vel		; head away from otherguy
	movi	>00030023,a9
	jsrp	animate_a9		; ani: stumble

	calla	am_i_joy
	janc	drone_post_skull_hit
	jruc	local_reaction_exit

;*************************************************************************


hat33	movi	>13,a0
	calla	create_blood_proc

r_kahn_spear
	movk	2,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	calla	rsnd_wasted_voice
	jruc	hit_by_proj

snot_entry
	movk	2,a6	   		; stumble sans noise
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc
	calla	rsnd_wasted_voice

hit_by_proj
	movi	>00040004,a11
	calla	shake_a11
	movi	>30000,a0
	calla	away_x_vel		; head away from otherguy
	movi	>00040023,a9
	jsrp	animate_a9		; ani: hit in face
	jruc	local_reaction_exit


r_sweep
	movk	2,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc
	calla	rsnd_body_hit
	calla	rsnd_tripped_voice

	movi	act_reacting,a0
	move	a0,*a13(p_action),w

	movi	>00050016,a9
	jsrp	animate_a9
	callr	shake_n_sound

	calla	am_i_joy
	jrc	joy_swept3

	movk	4,a0
	jsrp	drone_beware_mframew		; ani: standing unblock

	clr	a0
	move	a0,*a13(p_otheract),w
	calla	drone_beware
	sleep	1
	calla	drone_beware
	sleep	1
	calla	drone_beware
	sleep	1
	jruc	swept5	

joy_swept3
	movk	4,a0
	jsrp	mframew			; finish fall ani
;	sleep	4

swept5	callr	check_stay_down
	jruc	sweepup_local_reaction_exit


r_hipunched
	clr	a6
	movi	r_airpunch,a5
	callr	reaction_start_abc
	calla	rsnd_face_hit
	calla	rsnd_react_voice

	movk	18,a0
	calla	create_blood_proc

	movk	6,a5			; not pulling away hits
	movk	4,a6			; pulling away hits
	callr	punch_stumble_check
	movi	>00030010,a9
	jsrp	animate_a9
	jruc	local_reaction_exit

;*************************************************************************

r_lopunched
	clr	a6
	movi	r_airpunch,a5
	callr	reaction_start_abc
	calla	rsnd_body_hit
	calla	rsnd_react_voice

	movk	5,a5			; not pulling away hits
	movk	3,a6			; pulling away hits
	callr	punch_stumble_check

	movi	>00030011,a9		; ani: hit in chest
	calla	am_i_short
	jrnc	rlp3
	movi	>0003001b,a9		; ani: duck hit
rlp3	jsrp	animate_a9
	jruc	local_reaction_exit

;*************************************************************************

r_airpunch
	tsound	>19
	calla	rsnd_react_voice
	movk	4,a1
	callr	repell_on_a1_hit	; avoid hacky sack

	movi	>38000,a0	; a0 = initial x vel
	movi	->60000,a1	; a1 = initial y vel
	movi	>8000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jsrp	flight
	jruc	land_on_my_back

r_jc_pp
	clr	a6
	callr	reaction_start

	tsound	>19
	calla	rsnd_wasted_voice

	movi	>00070007,a11
	calla	shake_a11

	movi	>60000,a0	; a0 = initial x vel
	movi	->40000,a1	; a1 = initial y vel
	movi	>8000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jsrp	flight

	callr	shake_n_sound

	movi	>0f,a9		; a9 = ani offset
	calla	find_ani_part2
	movk	6,a0
	jsrp	mframew		; thudd ani
	sleep	8
	jruc	getup_local_reaction_exit


r_lk_super
	movk	4,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	tsound	>19
	calla	rsnd_wasted_voice
	movi	>00050005,a11
	calla	shake_a11

	movi	>60000,a0	; a0 = initial x vel
	movi	->30000,a1	; a1 = initial y vel
	movi	>4000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jsrp	flight

	callr	shake_n_sound

	movi	>0f,a9		; a9 = ani offset
	calla	find_ani_part2
	movk	6,a0
	jsrp	mframew		; thudd ani
	sleep	8
	jruc	getup_local_reaction_exit


r_lk_flykick
	clr	a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc
	tsound	>19
	calla	rsnd_wasted_voice

	movi	>40000,a0	; a0 = initial x vel
	movi	->30000,a1	; a1 = initial y vel
	movi	>4000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jsrp	flight

	callr	shake_n_sound

	movi	>0f,a9		; a9 = ani offset
	calla	find_ani_part2
	movk	6,a0
	jsrp	mframew		; thudd ani
	sleep	8
	jruc	getup_local_reaction_exit

**************************************************************************
*											     *
*  punch_stumble_check									     *
* 											     *
*  Input: a5 = # of hits if stick is NOT pulled away				     *
*         a6 = # of hits if stick is pulled away				     *
*											     *
**************************************************************************
punch_stumble_check
	calla	am_i_joy
	jrnc	stck4			; drone: assume stick pulled away

	calla	is_stick_away		; am I pulling stick away ?
	jrc	stck4			; yes	
	move	a5,a6
stck4	move	*a13(p_hit),a0,w
	cmp	a0,a6			; enough hits to separate players ?
	jrhi	stck6			; no
 	pull	a0			; no return
	jruc	separate_us		; yes
stck6	rets

**************************************************************************

r_decoy
	calla	am_i_airborn
	jrc	r_decoy_airborn

r_fn_tele
	movi	act_fntele,a0
	move	a0,*a13(p_hitby),w	; kludge this in so hit q is updated

	movk	4,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	calla	rsnd_react_voice
	tsound	>19

	movi	act_reacting,a0
	move	a0,*a13(p_action),w
	movi	>00040004,a11
	calla	shake_a11
	movi	>40000,a0
	calla	away_x_vel		; head away from otherguy
	movi	>00040023,a9
	jsrp	animate_a9		; ani: hit in face
	jruc	local_reaction_exit


r_elbow
	tsound	>19
	movk	3,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc
	jruc	rfp3

;************************************************************************

r_hhjumpupp
r_flipp
	movk	3,a6
	movi	ar_flipp,a5
	callr	reaction_start_abc

rfp3	calla	rsnd_react_voice
	tsound	>19

	movk	18,a0
	calla	create_blood_proc

	movi	act_reacting,a0
	move	a0,*a13(p_action),w

	movi	>00040004,a11
	calla	shake_a11
	movi	>30000,a0
	calla	away_x_vel		; head away from otherguy
	movi	>00040023,a9
	jsrp	animate_a9		; ani: hit in face
	jruc	local_reaction_exit


ar_flipp
	tsound	>19
	calla	rsnd_react_voice
	callr	no_unlimited_airhits

	movi	>38000,a0	; a0 = initial x vel
	movi	->60000,a1	; a1 = initial y vel
	movi	>6000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jsrp	flight
	jruc	land_on_my_back

;************************************************************************

r_decoy_airborn
	clr	a6
	callr	reaction_start
	tsound	>19
	calla	rsnd_react_voice

	movi	>30000,a0	; a0 = initial x vel
	movi	->60000,a1	; a1 = initial y vel
	movi	>6000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jsrp	flight
	jruc	land_on_my_back

;*********************************************************************

r_lokicked
	calla	rsnd_body_hit

	movk	3,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	movi	act_reacting,a0
	move	a0,*a13(p_action),w
	
	movi	>20000,a0
	calla	away_x_vel		; head away from otherguy

	movi	>00040011,a9		; hit in chest
	calla	am_i_short
	jrnc	rlk3
	movi	>0004001b,a9		; duck hit
rlk3	jsrp	animate_a9
	jruc	local_reaction_exit

;*********************************************************************

r_last_noogy
	calla	if_boss_branch
	.long	goro_last_noogy

r_roundh
	movi	>14,a0
	calla	create_blood_proc

	movk	4,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	tsound	>19
	calla	rsnd_wasted_voice

;	movi	>14,a0
;	calla	create_blood_proc

	movi	>60000,a0	; a0 = initial x vel
	movi	->80000,a1	; a1 = initial y vel
	movi	>8000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jsrp	flight

	calla	rsnd_react_voice	; speech: uhh !!
	callr	shake_n_sound
	movi	>0f,a9		; a9 = ani offset
	calla	find_ani_part2
	movk	6,a0
	jsrp	mframew		; thudd ani
	sleep	8
	jruc	getup_local_reaction_exit


r_jcaxe
	movk	4,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	tsound	>19
	calla	rsnd_wasted_voice
	movi	>00060006,a11
	calla	shake_a11	; shake upon contact

	movi	>20000,a0	; a0 = initial x vel
	movi	->d0000,a1	; a1 = initial y vel
	movi	>8000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jsrp	flight

	calla	rsnd_react_voice	; speech: uhh !!
	callr	shake_n_sound

	movi	>0f,a9		; a9 = ani offset
	calla	find_ani_part2
	movk	6,a0
	jsrp	mframew		; thudd ani
	sleep	8
	jruc	getup_local_reaction_exit

;***************************************************************************

r_hikicked
	movk	2,a0
	calla	create_blood_proc

	movi	>0019001a,a1
	calla	randsnd			; random big smack !

	movi	act_reacting,a0
	move	a0,*a13(p_action),w

	movk	3,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	calla	rsnd_react_voice
	movi	>48000,a0
	calla	away_x_vel		; head away from otherguy
	jruc	hikicked_entry

;***************************************************************************

r_saknee
	movk	3,a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc
	tsound	>19
	jruc	stumble_back

r_hhknee
	movk	3,a6
	jruc	rfk4

r_super_rep
r_flipk
	movk	4,a6

rfk4	move	*a13(p_action),a14,w
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc

	tsound	>19			; smak !
	calla	rsnd_react_voice	; speech: uuh !!

	movk	2,a0
	calla	create_blood_proc

	movi	act_reacting,a0
	move	a0,*a13(p_action),w

	cmpi	act_speared_sd,a14	; wuz I spear dizzy ?
	jreq	r_fast_fall		; yes, fall faster !!

	movi	>30000,a0		; a0 = initial x vel
	movi	->80000,a1		; a1 = initial y vel
	movi	>8000,a2		; a2 = gravity	
	movk	5,a3			; a3 = ani speed
	movi	>0f,a9			; a9 = ani offset
	jsrp	flight

post_fall_shake
	callr	shake_n_sound
	movi	>0f,a9		; a9 = ani offset
	calla	find_ani_part2
	movk	6,a0
	jsrp	mframew		; thudd ani
	sleep	4
	jruc	getup_local_reaction_exit


r_fast_fall
	movi	>50000,a0		; a0 = initial x vel
	movi	->60000,a1		; a1 = initial y vel
	movi	>9000,a2		; a2 = gravity	
	movk	5,a3			; a3 = ani speed
	movi	>0f,a9			; a9 = ani offset
	jsrp	flight
	jruc	post_fall_shake



stumble_back
	movi	>30000,a0

stumble_back_vel
	calla	away_x_vel		; move away from him

	movi	>00040023,a9
	calla	if_not_boss_branch
	.long	stumb3
	movi	>00040010,a9
stumb3	jsrp	animate_a9		; stumble ani
	jruc	local_reaction_exit



r_2nd_knee
	clr	a6
	movi	generic_airborn_hit,a5
	callr	reaction_start_abc
	tsound	>19
	movi	>20000,a0	; a0 = initial x vel
	movi	->80000,a1	; a1 = initial y vel
	movi	>8000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0f,a9		; a9 = ani offset
	jsrp	flight
	jruc	land_on_my_back



r_bike_kicked
	sleep	>80

r_bike_kicked_done
	calla	am_i_airborn
	jrnc	stumble_back
	clr	a0
	clr	a1
	movi	>6000,a2	; a2 = gravity
	movk	5,a3		; a3 = ani speed
	jruc	fall_on_my_back


fall_on_my_back
	calla	if_boss_branch
	.long	goro_fall_on_back

	movi	>0f,a9		; a9 = ani offset
	jsrp	flight
	jruc	land_on_my_back


goro_fall_on_back
	movi	>09,a9
	jsrp	flight

goro_shake_on_back
	callr	shake_n_sound
	movk	3,a0			; ani speed
	movi	>09,a9
	calla	find_ani_part2
	movk	4,a0
	jsrp	mframew			; goro shake on yer back

	callr	check_stay_down

	movk	>0b,a9
	calla	get_char_ani
	movk	4,a0
	jsrp	drone_beware_mframew	; goro getting up
	jruc	local_reaction_exit

;***********************************************************************

r_post_dived
	calla	stop_me
	calla	player_normpal
	calla	disable_all_buttons
	calla	face_opponent

	movi	>0009000f,a9
	calla	goro_pick_ani
	calla	get_char_ani

	calla	ground_player
	movk	5,a0
	jsrp	mframew
	movk	5,a0
	jsrp	mframew			; fall ani: part 2
	sleep	4
	jauc	getup_local_reaction_exit

;***********************************************************************

post_fb_xfers
	.long	tossed_flight	; 0
	.long	tossed_flight	; 1
	.long	slammed_by_cage	; 2
	.long	tossed_flight	; 3
	.long	slammed_by_fn	; 4
	.long	slammed_by_fn	; 5
	.long	slammed_by_st	; 6
	.long	slammed_by_rd	; 7
	.long	tossed_flight	; 8
	.long	tossed_flight	; 9
	.long	tossed_flight	; a
	.long	slammed_by_jx	; b

	.long	tossed_flight
	.long	tossed_flight

	.long	tossed_flight
	.long	tossed_flight
	.long	slammed_by_fn


slammed_by_jx
	movi	18,a10
	clr	b0
	calla	damage_to_me
	jruc	slammed2

slammed_by_fn
	movi	30,a10
	clr	b0
	calla	damage_to_me
	movi	>2e,a9			; flipped by fn ani
	calla	find_ani_part2
	calla	find_part2		; part 3 = slammed on ground
	jruc	slammed3

slammed_by_st
	movi	24,a10
	clr	b0
	calla	damage_to_me
	movi	>30,a9			; flipped by tsung ani
	calla	find_ani_part2
	calla	find_part2		; part 3 = slammed on ground
	jruc	slammed3

slammed_by_rd
	move	*a8(oflags),a4,w
	andni	m_flipv,a4
	move	a4,*a8(oflags),w	; right side up !

	movi	20,a10
	clr	b0
	calla	damage_to_me
	movi	>31,a9			; flipped by raiden
	calla	find_ani_part2
	calla	find_part2		; part 3 = slammed on ground
	calla	do_next_a9_frame

	movi	>00080008,a11
	calla	shake_a11
	calla	rsnd_ground
	calla	ground_player

	movk	3,a0			; ani speed
	movk	1,a10			; # of times to shake
	jsrp	shake_on_my_back

	movi	>2c,a9
	calla	find_ani_part2
	calla	find_part2		; part 3 = slammed on ground
	subi	32*2,a9			; a9 = flight frame

	movi	>40000,a0		; a0 = initial x vel
	movi	->60000,a1		; a1 = initial y vel
	movi	>8000,a2		; a2 = gravity
	movi	>fff,a3			; a3 = ani speed
	jsrp	flight
	jruc	slammed5



slammed_by_cage
	movi	34,a10
	clr	b0
	calla	damage_to_me
	jruc	slammed3

slammed_by_goro
	movi	40,a10
	clr	b0
	calla	damage_to_me

slammed2	movi	>2c,a9
	calla	find_ani_part2
	calla	find_part2		; part 3 = slammed on ground

slammed3
	movi	>00080008,a11
	calla	shake_a11
	calla	rsnd_ground
	calla	ground_player

	movk	3,a0			; ani speed
	movk	1,a10			; # of times to shake
	jsrp	shake_on_my_back
*
* bounce #1
*
	movi	>2c,a9
	calla	find_ani_part2
	calla	find_part2		; part 3 = slammed on ground
	subi	32*2,a9			; a9 = flight frame

	movi	>30000,a0		; a0 = initial x vel
	movi	->60000,a1		; a1 = initial y vel
	movi	>8000,a2		; a2 = gravity
	movi	>fff,a3			; a3 = ani speed
	jsrp	flight
*
* bounce #2
*
slammed5
	callr	shake_n_sound
	movk	3,a0			; ani speed
	movk	1,a10			; # of times to shake
	jsrp	shake_on_my_back

	callr	check_stay_down		; should I even get up at all ?
	calla	flip_multi
	jruc	getup_local_reaction_exit

;**************************************************************

tossed_flight
	movi	>2a,a9			; knocked down ani
	calla	find_ani_part2
	calla	find_part2
	calla	find_last_frame		; fly with last "flipped" frame

	movi	>80000,a0		; a0 = initial x vel
	movi	->10000,a1		; a1 = initial y vel
	movi	>8000,a2		; a2 = gravity	
	movk	6,a3			; a3 = ani speed
	jsrp	flight

	push	a8
	movi	flip_damage_table,a0
	move	*a13(p_otherguy),a8,l
	calla	get_char_word		; get damage from being flipped
	pull	a8
	move	a0,a10
	clr	b0
	calla	damage_to_me

	callr	shake_n_sound

	movi	>2b,a9
	calla	find_ani_part2
	calla	find_part2
	movk	4,a0	
	jsrp	mframew
	jruc	local_reaction_exit


flip_damage_table
	.word	40	; hathead throw damage
	.word	32	; kang throw damage
	.word	34	; cage
	.word	34	; sword arms

	.word	34
	.word	34
	.word	34
	.word	34

	.word	34
	.word	34
	.word	34
	.word	34

	.word	34
	.word	34

	.word	45
	.word	45
	.word	45	; hidden guys = serious damage


tossed_by_hathead
	movi	>2a,a9
	calla	find_ani_part2
	calla	find_part2
	addi	32*2,a9		; we already did this coord adjust

	movi	>80000,a0	; a0 = initial x vel
	movi	->30000,a1	; a1 = initial y vel
	movi	>8000,a2	; a2 = gravity	
	movk	6,a3		; a3 = ani speed
	jsrp	flight

	movi	sc_500,b0
	movi	30,a10
	calla	damage_to_me	; inflict damage

	movi	>0f,a9
	calla	find_ani_part2
	calla	find_part2    	; a9 = shake on ground


	callr	shake_n_sound
	movk	4,a0
	jsrp	mframew		; shake on the ground
	jruc	getup_local_reaction_exit

**************************************************************************
*											     *
*  no_unlimited_airhits - Dudes who get hit in the air use should call   *
*                         this to ensure that there is a limits to the   *
*                         number of times they can get hit in the air    *
*											     *
**************************************************************************
no_unlimited_airhits
	move	*a13(p_hit),a0,w	; how many hits is that ??
	cmpi	3,a0			; too many ?
	jrls	ronh9			; not yet
	jruc	repell_attacker

repell_on_a1_hit
	calla	am_i_close_to_edge
	jrc	repell_attacker		; edge = enough !!

	move	*a13(p_hit),a0,w	; how many hits is that ??
	cmp	a1,a0			; have I been hit this many times
	jrlo	ronh9			; no

repell_attacker
	movi	attacker_getting_separated,a7
	calla	xfer_otherguy
ronh9	rets

**************************************************************************
*											     *
*  getup_local_reaction_exit - Getup then goto local_reaction_exit	     *
* 											     *
**************************************************************************
sweepup_local_reaction_exit
	movi	>17,a9			; sweepup animation
	movi	sweepup_speeds,a11
	jruc	gup2

getup_local_reaction_exit
	movi	>12,a9			; getup animation
	movi	getup_speeds,a11

gup2   	move	a9,a10			; remember ani
	callr	check_stay_down		; should I even get up at all ?
	calla	check_winner_status
	calla	back_to_normal		; clear "phit not getting zeroed" bug

	calla	am_i_joy		; me joy dude ?
	janc	drone_getup		; no
*
* joystick dude getup
*
	calla	is_stick_down
	jrc	getup_stay_ducked	; stick down = stay ducked down

	callr	raiden_getup_pal

	calla	get_char_ani
	move	a11,a0
	calla	get_char_word		; getup /sweepup speeds
	calla	init_anirate

gup4	calla	next_anirate
	move	*a9,a0,l
	jreq	gup6			; last frame = exit

	cmpi	>17,a10
	jreq	gup3			; sweepup ani = no aborting allowed

	calla	is_stick_down
	jrc	joy_getup_abort
	calla	joystick_in_a0
	btst	bit_jup,a0		; is joystick up ?
	jrne	joy_getup_jump

gup3	sloop	1,gup4

gup6	sleep	2
	jruc	local_reaction_exit


joy_getup_abort
	calla	player_normpal
	jauc	joy_down		; stick down = duck NOW !

joy_getup_jump
	calla	player_normpal
	jauc	joy_up			; yes, quickly jump up

raiden_getup_pal
	movi	ft_raiden,a0
	calla	am_i_him
	jrnc	rgu9
	push	a9
	movi	>12,a9
	calla	get_char_ani
	move	*a9,a0,l
	move	*a0,a0,l
	move	*a0(icmap),a0,l		; grab "raiden getup" palette
	calla	player_swpal
	tsound	>5c 			; raiden getup sound

	pull	a9
rgu9	rets


getup_stay_ducked
	calla	back_to_normal
	movk	5,a9
	calla	find_ani_last_frame
	calla	do_next_a9_frame	; pose: ducked frame
	jauc	joy_getup_entry

sweepup_speeds
getup_speeds
	.word	4
	.word	4
	.word	4
	.word	4

	.word	4
	.word	4
	.word	4
	.word	2

	.word	4
	.word	4
	.word	4
	.word	4

	.word	4
	.word	4
	.word	4
	.word	4

	.word	4


check_stay_down
	move	@winner_status,a0,w
	jreq	gup9			; no winner ----> get up
	cmpi	3,a0
	jreq	gup9			; finish him ---> get up !!
	move	*a13(procid),a1,w
	cmp	a0,a1			; am i the winner ?
	jreq	gup9			; yes, getup
*
* I lose ---> stay down !
*
	pull	a0		; no return

	calla	check_sk_death

	calla	clear_shadow_bit
	jauc	wait_forever

gup9  	rets


check_sk_death
	movi	ft_final_boss,a0
	calla	am_i_him
	jrnc	csd3
	move	@p2_matchw,a1,w
	move	*a8(oid),a2,w
	cmpi	oid_p1,a2
	jreq	bcol1
	move	@p1_matchw,a1,w
bcol1	cmpi	2,a1
	pull	a0
	jaeq	kahn_death	; I am beaten shao kahn ---> be dramatic
	push	a0
csd3  	rets


torso_bounce
	move	*a13(p_ganiy),a1,w
	addi	>50,a1
	move	a1,*a13(p_ganiy),w
	calla	ground_player
	callr	torso_flat
	calla	rsnd_react_voice

	sleep	4
	
	move	a10,a9
	calla	do_next_a9_frame	; bounce frame

	movi	>20000,a0
	movi	->48000,a1
	movi	>6000,a2
	movi	never_ani,a3
	clr	a9			; not used
	jsrp	flight

	callr	torso_flat
	calla	rsnd_react_voice
	jauc	wait_forever

torso_flat
	movi	>39,a9
	calla	find_ani_part2
	calla	find_part2
	calla	find_part2
	calla	find_part2
	move	a9,a10
	addi	32,a9
	calla	do_next_a9_frame	; laying flat
	jruc	shake_n_sound

inc_p_hit
	movb	*a13(p_hit),a0
	inc	a0
	movb	a0,*a13(p_hit)		; add to hit counter
	rets

**************************************************************************
*											     *
*                         BLOCKED REACTIONS					     *
*                         BLOCKED REACTIONS					     *
*                         BLOCKED REACTIONS					     *
*											     *
**************************************************************************

block_xfers
	.long	b_hikick	; 0
	.long	b_lokick	; 1
	.long	b_hipunch	; 2
	.long	b_lopunch	; 3
	.long	b_standard	; 4

	.long	b_duckpunched	; 5
	.long	b_duckkickedh	; 6
	.long	b_duckkickedl	; 7

	.long	b_standard	; 8
	.long	b_standard	; 9
	.long	b_standard	; a
	.long	b_standard	; b
	.long	b_standard	; c
	.long	b_standard	; d
	.long	b_standard	; e
	.long	b_standard	; f
	.long	b_standard	; 10
	.long	b_decoy		; 11
	.long	b_flipkp	; 12
	.long	b_standard	; 13
	.long	b_shred		; 14
	.long	r_floor_ice	; 15
	.long	b_spin		; 16
	.long	b_superkang	; 17
	.long	b_scissor	; 18
	.long	b_standard	; 19

	.long	b_hhspin	; 1a
	.long	b_dive		; 1b
	.long	b_sweep		; 1c
	.long	b_fntele	; 1d
	.long	b_big_hit	; 1e
	.long	b_standard	; 1f
*
* block goro hits
*
	.long	b_goro_punch	; 20
	.long	b_standard	; 21
	.long	b_standard	; 22
	.long	b_standard	; 23
	.long	b_standard	; 24

*
* block shao kahn hits
*
	.long	b_kahn_punch	; 25
	.long	b_kahn_kick	; 26


;************************************************************************

b_flipkp
	tsound	>18			; block a major hit sound

	movk	2,a6
	callr	blocked_start

	movi	>40000,a0
	calla	away_x_vel       	; head away from otherguy
	movk	2,a11
	movk	3,a10
	jruc	block_shake_n_exit

;************************************************************************

b_hikick
b_lokick
	tsound	>18			; block a major hit sound

	movk	2,a6
	callr	blocked_start

	movi	>20000,a0
	calla	away_x_vel	     	; head away from otherguy

	movk	2,a11
	movk	3,a10
	jruc	block_shake_n_exit

;************************************************************************

b_scissor
	clr	a6
	callr	blocked_start
	calla	rsnd_block
	movk	2,a11
	movk	4,a10
	jruc	block_shake_n_exit


b_superkang
	movk	2,a6
	callr	blocked_start
	movi	ochar_block_superk,a0
	calla	get_char_word
	jreq	b_superk_lite		; 0 = lite hit
	jruc	b_superk_hard		; 1 = hard hit

ochar_block_superk
	.word	0   ;
	.word	0   ;
	.word	0   ;
	.word	0   ;

	.word	1   ; - fn1
	.word	1   ; - fn2
	.word	0   ;
	.word	0   ;

	.word	1   ; - subzero
	.word	1   ; - reptile
	.word	0   ;
	.word	0   ; - jax

	.word	0   ;
	.word	0   ;
	.word	0   ;
	.word	0   ;


b_superk_hard
	movi	>20000,a0
	calla	away_x_vel		; head away from otherguy
	callr	get_block_ani_offset
	movk	2,a11
	movk	3,a10
	jruc	block_shake_n_exit

b_superk_lite
	callr	get_block_ani_offset
	movk	2,a11
	movk	4,a10
	jruc	block_shake_n_exit

;************************************************************************

b_kahn_kick
b_kahn_punch
b_goro_punch
	tsound	>18			; block a major hit sound
	movi	>00040004,a11
	calla	shake_a11

	clr	a6
	callr	blocked_start
	movi	>60000,a0
	calla	away_x_vel		; head away from otherguy
	movi	>00030023,a9
	jsrp	animate_a9
	jruc	local_reaction_exit

************************************************************************

b_hhspin
	clr	a6
	callr	blocked_start
	movi	>60000,a0
	calla	away_x_vel		; head away from otherguy
	movi	>00030023,a9
	jsrp	animate_a9
	jruc	local_reaction_exit

************************************************************************

b_hipunch
	calla	rsnd_block

	clr	a6
	callr	blocked_start
	movi	>c000,a0
	calla	away_x_vel		; head away from otherguy
	jruc	blkp3

b_lopunch
	calla	rsnd_block

	clr	a6
	callr	blocked_start
	movi	>e000,a0
	calla	away_x_vel		; head away from otherguy

blkp3	move	*a13(p_hit),a0,w	; a0 = hit count
	cmpi	3,a0
	jrls	blkp4			; enough abuse - separate the two

	movi	>30000,a0
	movi	>70000,a1
	movi	attacker_getting_separated,a7
	callr	repell_one_of_us

blkp4

;	movk	>0b,a9			; standing block ani
;	calla	am_i_short		; am I crouched down low ?
;	jrnc	blkp5	  		; no, use standing block ani
;	movk	>0c,a9			; yes, switch to duck block ani
;blkp5
;	movk	2,a11
;	movk	3,a10
;
;	jsrp	block_shake
;	jruc	block_exit

	movk	2,a11
	movk	3,a10
	jruc	block_shake_n_exit


*
* blocking dude who has been hit too many times
*
separate_us
	calla	am_i_close_to_edge
	jrnc	stumble_back_vel	; yea, stumble back

	movi	attacker_getting_separated,a7
	calla	takeover_him

bsep3	jruc	block_exit

**************************************************************************
*											     *
*  repell_one_of_us - Repells one of us based on our position on the scr *
* 											     *
*  Input: a0 = velocity to repell me at						     *
*         a1 = velocity to repell him at							*
*         a7 = routine to xfer attacker						     *
*											     *
**************************************************************************
repell_one_of_us
	calla	am_i_close_to_edge
	jrnc	rus7 				; I am cornered ---> move him

	move	a7,a7 				; routine to xfer ?
	jreq	rus3				; without

	mmtm	sp,a0,a1
	calla	takeover_him			; yes ---> xfer him to it
	mmfm	sp,a0,a1

rus3	mmtm	sp,a13,a8
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l	; put on his mask
	move	a1,a0
	calla	away_x_vel
	mmfm	sp,a13,a8
	rets

rus7	jauc	away_x_vel 		  	; head away from otherguy

**************************************************************************
*											     *
*  attacker_getting_separated - Dudes who abuse the system are sentenced *
*                               to this address					     *
*											     *
**************************************************************************
super_ags
	movi	>a0000,a0
   	jruc	ags3

attacker_getting_separated
	movi	>70000,a0

ags3	push	a0
	calla	am_i_airborn
	pull	a0
	jrnc	ags_on_ground
*
* getting separated in the air
*
	movi	>38000,a0	; a0 = initial x vel
	movi	->60000,a1	; a1 = initial y vel
	movi	>8000,a2	; a2 = gravity	
	movk	5,a3		; a3 = ani speed
	movi	>0009000f,a9	; a9 = ani offset
	calla	boss_pick_ani

	jsrp	flight
	jruc	land_on_my_back

ags_on_ground
	calla	away_x_vel		; move away from him
	sleep	10
*
* slow down
*
ags6	sleep	1
	move	*a8(oxvel),a0,l
	sra	1,a0			; 1/2 speed
	abs	a0
	cmpi	>1000,a0
	jrlo	ags7
	calla	away_x_vel		; move away from him
	jruc	ags6

ags7	movi	>50,a10
	jsrp	wait_for_his_dog
	jruc	local_reaction_exit

;************************************************************************

b_duckpunched
	clr	a6
	callr	blocked_start
	movi	>20000,a0
	movi	>50000,a1
	movi	attacker_getting_separated,a7
	callr	repell_one_of_us
	jruc	blocked3

b_duckkickedh
	clr	a6
	callr	blocked_start
	movi	>40000,a0
	movi	>60000,a1
	movi	attacker_getting_separated,a7
	callr	repell_one_of_us
	jruc	blocked3

b_duckkickedl
	clr	a6
	callr	blocked_start
	movi	>30000,a0
	movi	>60000,a1
	movi	attacker_getting_separated,a7
	callr	repell_one_of_us
	jruc	blocked3

b_dive
	clr	a6
	callr	blocked_start
	calla	rsnd_block
	callr	get_block_ani_offset
	movk	2,a11
	movk	1,a10
	jruc	block_shake_n_exit


b_fntele
	movk	2,a6
	callr	blocked_start
	calla	rsnd_block
	calla	am_i_short		; am I crouched down low ?
	jrc	duck_block_shake	; yes
	movk	2,a11
	movk	2,a10
	jruc	block_shake_n_exit

;************************************************************************

b_decoy
	clr	a6
	callr	blocked_start
	tsound	>18			; block a major hit sound
	movk	2,a11
	movk	2,a10
	jruc	block_shake_n_exit

;************************************************************************

b_standard
	clr	a6
	callr	blocked_start

blocked3
	calla	rsnd_block

	calla	am_i_short		; am I crouched down low ?
	jrc	duck_block_shake	; yes

	movk	2,a11
	movk	2,a10
	jruc	block_shake_n_exit


b_shred
	clr	a6
	callr	blocked_start

	movi	>20000,a0
	calla	away_x_vel			; head away from otherguy

	movi	>0b,a9
	calla	get_char_ani
	addi	32,a9

	movk	12,a10
bshr2	calla	do_next_a9_frame	; show frame 2
	sleep	2
	calla	do_next_a9_frame	; show frame 1
	sleep	2

	calla	get_x_dist
	cmpi	>70,a3
	jrhi	bshr3			; beyond reach of blades
	subi	32*2,a9
	dsj	a10,bshr2

bshr3	calla	stop_me
	jruc	block_exit

**************************************************************************
*											     *
*  block_shake_n_exit									     *
* 											     *
*  Input: a10 = # of times to shake							     *
*         a11 = sleep time								     *
*											     *
**************************************************************************
block_shake_n_exit
	callr	get_block_ani_offset		; tall/short/or boss
	jsrp	block_shake

block_exit
	clr	a0
	move	a0,*a13(p_hit),w	; ok, but you gotta start the count over

	calla	am_i_joy
	janc	drone_post_block

	calla	am_i_short
	jac	joy_duck_block_loop
	jauc	joy_block_loop


get_block_ani_offset
	movi	>0b,a9
	movi	>0c,a5
	callr	tall_or_short_ani	; pick one based on height
	calla	am_i_a_boss
	jrnc	gbao8
	movk	>08,a9			; goro / kahn = different offset
gbao8	rets

*
* Input: a9 = standing animation
*        a5 = ducking animation
*
tall_or_short_ani
	calla	am_i_short
	jrnc	tos9
	move	a5,a9			; short = use duck ani
tos9	rets


**************************************************************************
*											     *
*  block_shake - Handy routine to shake someone who is blocking	     *
* 											     *
*  Input: a9 = animation offset								     *
*        a10 = # of times to shake							     *
*        a11 = sleep time								     *
*											     *
**************************************************************************
block_shake
	calla	get_char_ani
	addi	32,a9

blk2	calla	do_next_a9_frame	; show frame 2
	move	a11,a0
	calla	prcslp
	calla	do_next_a9_frame	; show frame 1

	move	a11,a0
	calla	prcslp
	subi	32*2,a9
	dsj	a10,blk2
	calla	stop_me
	retp

**************************************************************************
*											     *
*           LANDING AND RECOVERING HANDY PLACES TO JUMP TO		     *
*           LANDING AND RECOVERING HANDY PLACES TO JUMP TO		     *
*           LANDING AND RECOVERING HANDY PLACES TO JUMP TO		     *
*           LANDING AND RECOVERING HANDY PLACES TO JUMP TO		     *
*											     *
**************************************************************************
reaction_land
	callr	shake_n_sound
	movi	>0009000f,a9		; a9 = ani offset
	calla	boss_pick_ani
	calla	find_ani_part2
	movk	4,a0
	jsrp	mframew			; thudd ani
	sleep	3
	jruc	getup_local_reaction_exit

land_on_my_back
	callr	shake_n_sound
	movk	3,a0			; ani speed
	movk	1,a10			; # of times to shake
	jsrp	shake_on_my_back
	jruc	getup_local_reaction_exit


shake_n_sound
	movi	>00060006,a11
	calla	shake_a11
	jauc	rsnd_ground

**************************************************************************
*											     *
*  shake_on_my_back - Do the "shake on my back" animation given:	     *
* 											     *
*  Input: a0 = speed of ani								     *
*        a10 = # of times to shake (2 frames each)				     *
*											     *
**************************************************************************
shake_on_my_back
	pushp	a0

somb2	movi	>0009000f,a9
	calla	boss_pick_ani

	calla	find_ani_part2
	calla	find_part2		; part 3 = shake on back
	addi	32*2,a9			; a9 = last 2 frames of shake
	move	a9,a11			; save here

somb3	move	a11,a9
	move	*a12,a0,l		; pull sleep time but keep stack same
	jsrp	mframew
	dsj	a10,somb3

	pullp	a0
	retp

local_reaction_exit
	jauc	reaction_exit

;*********************************************************************

dlists_pitfall
	.long	baklst8,worldtlx8+16
	.long	baklst7,worldtlx7+16
	.long	baklst6,worldtlx6+16
	.long	baklst5,worldtlx5+16
	.long	baklst4,worldtlx4+16
	.long	baklst3,worldtlx3+16
	.long	baklst2,worldtlx2+16
	.long	baklst1,worldtlx+16
	.long	objlst,worldtlx+16
	.long	objlst2,worldtlx+16
	.long	0

*************************************************************************

r_spike_rise
	calla	spike_the_ceiling

	movk	1,a0
	calla	create_blood_proc
;	movi	>00060006,a11
;	calla	shake_a11		; shake upon contact
	movk	6,a6
	callr	reaction_start
	tsound	>1b

	clr	a1
	not	a1
	movi	pid_scroll,a0
	calla	existp
	movi	ceiling_scroll,a7
	calla	fastxfer		; scroller ---> follow my ass !!
	move	a8,*a0(pa11),l		; pass my object

	movi	>10000,a0		; a0 = initial x vel
	movi	->e0000,a1		; a1 = initial y vel
	movi	>2000,a2		; a2 = gravity	
	movk	5,a3			; a3 = ani speed
	movi	>0f,a9			; a9 = ani offset
	movi	scan_for_ceiling,a6
	jsrp	flight_call
	jauc	wait_forever

scan_for_ceiling
	move	*a8(oypos),a0,w
	move	@ceiling_y,a1,w
	subi	>60,a1
	cmp	a1,a0
	jrlt	sfc9

	calla	distance_off_ground
	cmpi	>a0,a0
	jrlo	sfc4
	clr	a0
	move	a0,@f_shadows,w		; way off ground = no shadows
sfc4	rets

sfc9	pull	a0
	pull	a0
	calla	reset_proc_stack
	tsound	>44			; sword slice sound
	calla	disturbing_scream
	calla	stop_me

	movi	>00080008,a11
	calla	shake_a11		; shake upon contact

	movi	>0f,a9
	calla	get_char_ani
	calla	find_part2
	calla	find_part2
	calla	find_last_frame
	calla	do_next_a9_frame	; flat on back frame !!
	clr	a0
	movi	->40,a1
	calla	multi_adjust_xy

	move	@switch,a0,l
	not	a0
	btst	1,a0
	jreq	sfc8
	btst	9,a0
	jrne	sfcc

sfc8	movi	50,a0
	calla	randper			; fall off spikes ??
	jrnc	sfca			; no

sfcc	sleep	>80
	movi	>2000,a0
	move	a0,*a8(oyvel),l		; start slidin slowly
	sleep	>70
	calla	rsnd_wasted_voice	; ouch !!!
	clr	a0
	movi	>20000,a1
	movi	>8000,a2
	movi	never_ani,a3
	jsrp	flight
	calla	shake_n_sound
	jruc	sfcb

sfca	movk	>11,a0
	calla	create_blood_proc
	move	a8,*a0(pa11),l		; pass my object
sfcb	jauc	wait_forever

*************************************************************************

r_fall_down_pit
	movi	gs_pitfall,a0
	move	a0,@gstate,w		; new game state !!

	calla	nosounds
	sleep	1

	tsound	>1b
	movi	>cbcbcbcd,a1
	calla	ochar_sound		; ahh !!!!

	movk	1,a0
	calla	create_blood_proc

	movi	>00060006,a11
	calla	shake_a11		; shake upon contact
	movk	6,a6
	callr	reaction_start

	movi	dlists_pitfall,a0	
	move	a0,@dlists,l

	clr	a1
	not	a1
	movi	pid_scroll,a0
	calla	existp
	movi	pit_scroll,a7
	calla	fastxfer		; scroller ---> follow my ass down
	move	a8,*a0(pa11),l		; pass my object

	move	*a13(p_ganiy),a0,w
	addi	>400,a0
	move	a0,*a13(p_ganiy),w	; floor = way down there

	movi	>20000,a0		; a0 = initial x vel
	movi	->c0000,a1		; a1 = initial y vel
	movi	>6000,a2		; a2 = gravity	
	movk	5,a3			; a3 = ani speed
	movi	>0f,a9			; a9 = ani offset
	jsrp	flight

	jauc	wait_forever

;*********************************************************************

	.end
