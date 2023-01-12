**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: main.asm ---  main game flow							*
* 											     *
*  copyright (c) 1993 Midway Manufacturing							*
*											     *
**************************************************************************
	.file	'mkguys.asm'
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
*  setup_players - Create the objects and procs for both players !!	     *
*											     *
**************************************************************************
setup_players
	move	@p1_char,a0,w
	movi	p1_shadadj,a1
	callr	stuff_shad_adj		; setup shadow adjust ram
	move	@p2_char,a0,w
	movi	p2_shadadj,a1
	callr	stuff_shad_adj		; setup shadow adjust ram
*
* setup player 1
*
	callr	make_player_1_obj
	movi	pid_p1,a1		; set proc id
	movi	drone_1_proc,a7
	move	@p1_state,a0,w
	cmpi	ps_active,a0
	jrne	sag6
	movi	joy_1_proc,a7
sag6	calla	getprc
	move	a0,@p1_proc,l
	move	*a8(oypos),*a0(p_ganiy),w		; set the grounded y pos

	move	a8,*a0(pa8),l				; pass a8 to proc
	mmtm	sp,a0,a8				; save p1 proc/obj
	calla	clear_p_ram				; clear process ram

	move	*a8(oypos),*a0(p_ganiy),w		; set grounded y (player 2)

	movi	switch,a1
	move	a1,*a0(p_joyport),l
	movi	switch+33,a1
	move	a1,*a0(p_butport),l			; setup switch stuff
	calla	insobja8
*	
* setup player 2 
*
	calla	make_player_2_obj
	movi	pid_p2,a1				; set proc id
	movi	drone_2_proc,a7
	move	@p2_state,a0,w
	cmpi	ps_active,a0
	jrne	sag7
	movi	joy_2_proc,a7
sag7	calla	getprc

	move	*a8(oypos),*a0(p_ganiy),w		; set the grounded y pos
	move	a8,*a0(pa8),l				; pass a8 to proc
	calla	clear_p_ram				; clear process ram

	move	*a8(oypos),*a0(p_ganiy),w		; set grounded y (player 2)
	movi	switch+8,a1
	move	a1,*a0(p_joyport),l
	movi	switch+25,a1
	move	a1,*a0(p_butport),l			; setup switch stuff
	move	a0,@p2_proc,l

	mmfm	sp,a1,a9				; pull player 1 proc/obj
	move	a0,*a1(p_otherproc),l
	move	a1,*a0(p_otherproc),l
	move	a8,*a1(p_otherguy),l
	move	a9,*a0(p_otherguy),l

	calla	insobja8
	rets


make_player_1_obj
	move	@p1_char,a0,w
	movk	1,a1			; shadow = yes
	clr	a2			; player = 1
	callr	make_player_obj		; a8 = player 1 object
	move	a8,@p1_obj,l   		; player 1 object
	movi	p1_ram,a0
	move	a0,*a8(oimg),l
	movi	oid_p1,a0
	move	a0,*a8(oid),w
	movi	front_z,a0
	move	a0,*a8(ozval),l		; set x
	movi	>60,a0
	calla	set_x_woff  		; player 1 x offset
	clr	a9
	jauc	do_first_a9_frame	; pose: stance frame #1

make_player_2_obj
	move	@p2_char,a0,w
	movk	1,a1			; shadow = yes
	movk	1,a2			; player = 2
	callr	make_player_obj
	move	a8,@p2_obj,l   		; a8 = player 2 object
	movi	p2_ram,a0
	move	a0,*a8(oimg),l
	movi	oid_p2,a0
	move	a0,*a8(oid),w
	movi	back_z,a0
	move	a0,*a8(ozval),l		; set x
	movi	>120,a0
	calla	set_x_woff  		; player 1 x offset
	clr	a9
	calla	do_first_a9_frame	; pose: stance frame #1
	jauc	flip_multi


stuff_shad_adj
	sll	4,a0
	addi	shadow_adjustments,a0
	move	*a0,a0,w
	move	a0,*a1,w
	rets

shadow_adjustments
	.word	2	; hathead
	.word	2	; liu kang
	.word	2	; cage
	.word	2
	.word	0	; knockout
	.word	0	; bombshell
	.word	2	; shang tsung
	.word	2	; raiden

	.word	2	; subzero
	.word	2	; reptile
	.word	2	; scorpion
	.word	2	; jax
	.word	-5    ;	2	; kintaro
	.word	2	; shao kahn

	.word	2	; ??
	.word	2	; ??
	.word	2	; ??

get_char_ani2
	movi	character_anitabs2,a14	; a14 ---> proper anitab
	jruc	gca5

get_char_ani
	movi	character_anitabs1,a14	; a14 ---> proper anitab

gca5	move	*a8(ochar),a0,w
	sll	5,a0
	add	a14,a0
	move	*a0,a0,l
	sll	5,a9
	add	a0,a9
	move	*a9,a9,l		; a9 = correct animation
	rets

character_anitabs1
	.long	hat_anitab1
	.long	lk_anitab1
	.long	jc_anitab1
	.long	sa_anitab1
	.long	fn1_anitab1
	.long	fn2_anitab1
	.long	st_anitab1
	.long	rd_anitab1
	.long	sz_anitab1
	.long	rp_anitab1
	.long	sc_anitab1
	.long	jx_anitab1
	.long	go_anitab1
	.long	sk_anitab1

	.long	sm_anitab1
	.long	sm_anitab1
	.long	fn3_anitab1


character_anitabs2
	.long	hat_anitab2
	.long	lk_anitab2
	.long	jc_anitab2
	.long	sa_anitab2
	.long	fn1_anitab2
	.long	fn2_anitab2
	.long	st_anitab2
	.long	rd_anitab2
	.long	sz_anitab2
	.long	rp_anitab2
	.long	sc_anitab2
	.long	jx_anitab2
	.long	go_anitab2
	.long	sk_anitab2

	.long	sm_anitab2
	.long	sm_anitab2
	.long	fn3_anitab1


stance_setup
	movi	act_stance,a0
	move	a0,*a13(p_action),w
	clr	a9			; assume animation #0
	calla	get_char_ani
	movi	stance_speeds,a0
	calla	get_char_word
	jauc	init_anirate		; set animation speed
	
stance_speeds
	.word	5	; hathead
	.word	5	; kang
	.word	5	; cage
	.word	5	; sword arms
	.word	6	; knockout
	.word	6	; bombshell
	.word	5	; shang tsung
	.word	5	; raiden
	.word	6	; subzero
	.word	6	; reptile
	.word	5	; scorpion
	.word	6	; jax
	.word	6	; kintaro
	.word	8	; shao kahn

	.word	6	; smoke
	.word	6
	.word	6

**************************************************************************

*
* a0 ---> a1
* 
box_unxlate
	move	*a0,a1,w
	sll	4,a1
	addi	unxlate_table,a1
	move	*a1,a1,w
	move	a1,*a1,w	; new p?_ochar value
bx9	rets

unxlate_table
	.word	1
	.word	0
	.word	2
	.word	9
	.word	8
	.word	6
	.word	4
	.word	11
	.word	5
	.word	3
	.word	10
	.word	7

**************************************************************************
*											     *
*  get_walk_info_f - Returns the following walk forward info		     *
* 											     *
*  a0 = walk forward animate speed							     *
*  a1 = walk forward velocity								     *
*  a2 = walk forward ani offset								     *
*											     *
**************************************************************************
get_walk_info_b
	movk	3,a2			; walk backward ani = 3
	movi	walk_backward_info,a0
	callr	decode_walk_table
	neg	a1
	jruc	walk_flip_reverse

get_walk_info_f
	movk	1,a2			; walk forward ani = 1
	movi	walk_forward_info,a0
	callr	decode_walk_table

walk_flip_reverse
	move	*a8(oflags),a4,w
	btst	b_fliph,a4
	jreq	gwi9
	neg	a1
gwi9	rets

decode_walk_table
	calla	get_char_long
	move	a0,a1
	zext	a0,w			; a0 = animation speed
	srl	16,a1
	sll	4,a1			; a1 = vel
	rets

walk_forward_info
	.word	5,>3000	; hh
	.word	5,>2800	; lk
	.word	5,>2800	; jc
	.word	5,>3000	; sa

	.word	5,>3200	; fn1
	.word	4,>3200	; fn2
	.word	5,>2800	; st
	.word	5,>2800	; rd

	.word	5,>2800	; sz
	.word	5,>2800	; rp
	.word	5,>2800	; sc
	.word	5,>2800	; jx

	.word	4,>3000	; goro 
	.word	5,>3800	;

	.word	3,>4800	; smoke
	.word	5,>4000	;
	.word	3,>4800	; smoke

walk_backward_info
	.word	6,>2400	; hh
	.word	6,>2000	; lk
	.word	6,>2000	; jc
	.word	6,>2400	; sa
	.word	6,>2000	; fn1
	.word	6,>2000	; fn2
	.word	6,>2000	; st
	.word	6,>2000	; rd
	.word	6,>2000	; sz
	.word	6,>2000	; rp
	.word	6,>2000	; sc
	.word	6,>2000	; jx
	.word	6,>2000	;
	.word	6,>2000	;
	.word	4,>3000	;
	.word	4,>3000	;
	.word	4,>3000	;

**************************************************************************
*											     *
*  make_player_obj										*
* 											     *
*  input: a0 = ochar offset							     	*
*         a1 = shadow flag (1=shadow  0=sans shadow)				     *
*         a2 = 0-1 for player 1 or 2								*
* 											     *
**************************************************************************
make_player_obj
	mmtm	sp,a0,a1,a7
	move	a0,a9

	clr	a5
	movi	character_palettes_1,a3	; assume original cool palette

	move	@gstate,a4,w
	cmpi	gs_psel,a4
	jreq	leave_colors_alone		; player select = leave colors alone

	move	a2,a2
	jreq	leave_colors_alone		; yes, player 1 = original palette

	move	@p1_char,a6,w
	cmp		a0,a6				; same character ?
	jrne	leave_colors_alone		; no

	movi	m_ugly_pal,a5
	movi	character_palettes_2,a3	; player 2 = alternate palette

leave_colors_alone
	sll	5,a0
	add	a3,a0

	mmtm	sp,a2,a5
	movi	pobj_init,a14
	movi	dmawnz,a4
	calla	initobj
	mmfm	sp,a2,a5

	move	a9,*a8(ochar),w			; set my ochar

	move	*a0,a0,l			; a0 = palette to use
	calla	getfpal
	move	a0,*a8(opal),w

	move	*a8(oflags2),a0,w
	ori		m_multipart,a0
	or		a5,a0				; ugly or no !!
	move	a0,*a8(oflags2),w		; set the "multipart" bit

	callr	ground_ochar

	clr	a0
	move	a0,*a13(p_flags),w		; clear process flags
	move	a0,*a8(oimg),l

	calla	player_normpal

;**********************
;	movk	ft_raiden,a0
;	callr	am_i_him
;	jrnc	pim3
;	move	a13,a9
;	create	pid_lightning,lightning
;pim3
;**********************

	mmfm	sp,a0,a1,a7
	rets


pobj_init
	.long	first_image,0
	.word	0
	.word	0,0,0

first_image
	.word	0,0,0,0
	.long	>2000000
	.word	>0000
	.long	boonpal

menu_ochars
	.word	1
	.word	0
	.word	2
	.word	9

	.word	6
	.word	8
	.word	5
	.word	11

	.word	4
	.word	3
	.word	10
	.word	7

**************************************************************************
*											     *
*  player_swpal - players use this routine to switch to alternate	     *
*                 palettes								     *
* 											     *
*  input: a0 = palette to switch to								*
*	 a8 = object									     *
*        a13 = controlling process							     *
*											     *
**************************************************************************
player_swpal
	calla	swpal
	move	*a13(p_flags),a0,w
	ori	pm_alt_pal,a0
	move	a0,*a13(p_flags),w	; flag: i am using aleternate palette
	rets


**************************************************************************
*											     *
*  player_normpal - players use this routine to switch back to their     *
*                   normal palette							     *
* 											     *
*  input: a8 = object									     *
*        a13 = controlling process 							     *
*											     *
**************************************************************************
player_normpal
	move	*a13(p_flags),a0,w
	btst	pb_alt_pal,a0		; am i using an alternate palette ??
	jreq	pnorm3			; sans ---> dont switch

	move	*a13(p_otherguy),a0,l
	move	*a0(ochar),a0,w		; a0 = his ochar
	move	*a8(ochar),a1,w		; a1 = my ochar
	cmp		a0,a1
	jrne	player_nice_pal		; different characters ---> use nice pal

	move	*a13(p_otherguy),a0,l
	move	*a0(oflags2),a1,w	
	btst	b_ugly_pal,a1		; he using ugly palette ?
	jreq	player_ugly_pal		; yes, use the nice one

player_nice_pal
	move	*a8(oflags2),a1,w
	andni	m_ugly_pal,a1
	move	a1,*a8(oflags2),w	; flag: ugly pal
	movi	character_palettes_1,a0
	jruc	pnorm2

player_ugly_pal
	move	*a8(oflags2),a1,w
	ori		m_ugly_pal,a1
	move	a1,*a8(oflags2),w	; flag: ugly pal
	movi	character_palettes_2,a0

pnorm2	calla	get_char_long
	calla	swpal

	move	*a13(p_flags),a0,w
	andni	pm_alt_pal,a0
	move	a0,*a13(p_flags),w	; flag: i am not using aleternate palette

pnorm3	rets


character_palettes_1
	.long	TMBLUE_P
	.long	LKRED_P
	.long	CAGE_P
	.long	UGRED_P
	.long	KATBLU_P
	.long	KATPRPL_P
	.long	TYELO_P
	.long	RADBLU_P
	.long	SUB_P
	.long	REP_P
	.long	SCORP_P
	.long	JAXRED_P
	.long	TIGERDK_P
	.long	BGPAL1_P

	.long	smoke_p
	.long	noob_p
	.long	JADE_P

character_palettes_2
	.long	tmgold_p
	.long	LKBLUE_P
	.long	CAGERED_P
	.long	UGBLUE_P
	.long	KATBLU3_P
	.long	KTPRPL2_P
	.long	TLBLUE_P
	.long	RADRED_P
	.long	SUB2_P
	.long	REP3_P
	.long	SCORP2_P
	.long	JAXBLU_P
	.long	TIGERDK_P
	.long	BGPAL1_P

	.long	smoke_p
	.long	noob_p
	.long	JADE_P

;***********************************************************************

smoke_info
	.long	smoke_frame1

smoke_frame1
	.long	SMSTANCE1A,0

SMSTANCE1A
	.word   30,133,25,-6
	.long   021515a8H
	.word   06580H
	.long   smoke_p

;***********************************************************************

jade_info
	.long	jade_frame1

jade_frame1
	.long	JDSTANCE1A,0

JDSTANCE1A
	.word   24,129,25,-9
	.long   0120358eH
	.word   06080H
	.long   JADE_P

;***********************************************************************

ground_ochar
	move	*a8(ochar),a0,w
	sll	4,a0
	addi	ochar_ground_offsets,a0
	move	*a0,a0,w		; grab the offset
	move	@ground_y,a1,w
	sub	a0,a1
	move	a1,*a8(oypos),w		; and set the y on the ground too
	rets


ochar_ground_offsets
	.word	>8c	; hathead
	.word	>85	; liu kang
	.word	>8c	; cage
	.word	>8c	; sword arms
	.word	>85	; knockout
	.word	>85	; bombshell
	.word	>81	; shang
	.word	>8c	; raiden
	.word	>83
	.word	>83
	.word	>83	; los tres ninjas !
	.word	>8b	; jax

	.word	>96	; goro II
	.word	>a0	; shao kahn

	.word	>83
	.word	>83
	.word	>85

death_fade_excludes
	.long	boonpal
	.long	SCORE_P
	.long	BLOOD_P
	.long	jtblood_p
	.long	PUFF_P

	.long	TMBLUE_P
	.long	LKRED_P
	.long	CAGERED_P
	.long	UGRED_P
	.long	KATBLU_P
	.long	KATPRPL_P
	.long	TYELO_P
	.long	RADBLU_P
	.long	SUB_P
	.long	REP_P
	.long	SCORP_P
	.long	JAXBLU_P
	.long	TIGERDK_P

	.long	tmgold_p
	.long	LKBLUE_P
	.long	CAGE_P
	.long	UGBLUE_P
	.long	KATBLU3_P
	.long	KTPRPL2_P
	.long	TLBLUE_P
	.long	RADRED_P
	.long	SUB2_P
	.long	REP3_P
	.long	SCORP2_P
	.long	JAXRED_P
	.long	TIGERDK_P
	.long	ELEC_P

	.long	smoke_p
	.long	boss_p
	.long	SNOB16		; subzero snow ball pal
	.long	FREEZE_P
*
* player froze pals
*
	.long	TMFREZ_P	; 0
	.long	LKFREZ_P	; 1
	.long	JCFREZ_P	; 2
	.long	UGFREZ_P	; 3
	.long	KTFREZ_P	; 4
	.long	KTFREZ_P	; 5
	.long	STFREZ_P	; 6
	.long	RNFREZ_P	; 7
	.long	NJFREZ_P	; 8
	.long	JXFREZ_P	; 11
	.long	0

**************************************************************************
*											     *
*  alternate color palettes for characters						     *
*											     *
**************************************************************************
tmgold_p:
	.word	 64
	.word	00h,0739ch,06f7bh,06739h,05ad6h,05294h,04e73h,04210h
	.word	039ceh,0318ch,0294ah,02108h,01ce7h,014a5h,00h,00h
	.word	07bb9h,07756h,06b13h,066d1h,062aeh,05e6dh,05a4bh,0564dh
	.word	05420h,0522ah,049e9h,045c8h,041a7h,03d87h,03c00h,03965h
	.word	03545h,03400h,02d25h,02800h,020a0h,02000h,01c80h,01800h
	.word	01482h,07aa0h,07706h,06a40h,066a5h,066cbh,05a64h,05224h
	.word	04e04h,049a0h,049e4h,045c4h,04180h,04160h,03d80h,03940h
	.word	03540h,03162h,02d00h,02922h,024c0h,01cc1h,01460h,0820h

LKBLUE_P:
	.word	 64
	.word	00H,06739H,056B5H,039CEH,018C6H,0842H,07F97H,07F0FH
	.word	07FB8H,07F54H,07F32H,07EEEH,07F51H,07EF0H,07F93H,07AADH
	.word	076F0H,07715H,076CDH,0728BH,072ACH,072AEH,06E8EH,06E8BH
	.word	06A6AH,06A6CH,06A49H,0664AH,0666CH,066B1H,06207H,06229H
	.word	05E09H,05E2AH,059E7H,055E8H,055C7H,05609H,051A6H,04DA6H
	.word	04D85H,04964H,04586H,03D66H,03D01H,038E0H,030A0H,028A1H
	.word	01800H,01H,01D1AH,018F8H,018D6H,014D3H,014B2H,010B0H
	.word	0108EH,0C8DH,0C6CH,0C6AH,0869H,0847H,0425H,07FFCH

CAGERED_P:
	.word   64 
	.word   00000h,07fffh,06f7bh,05ef7h,04a52h,039ceh,02529h,01084h
	.word   07fd9h,07f32h,07f30h,07f55h,07f0fh,07af1h,07aaeh,0768bh
	.word   0726ah,06e49h,06a8eh,06a6ch,06a29h,06ab1h,0664bh,061e8h
	.word   0622ah,05e0ah,05de8h,05a2dh,059eah,059a6h,05583h,051a6h
	.word   04d86h,049a9h,04965h,04921h,04567h,04541h,04122h,03d43h
	.word   03d00h,03925h,034c0h,030a0h,02860h,024c2h,02440h,02020h
	.word   01c00h,01460h,01063h,01000h,00c41h,06cc3h,0696ah,04cc5h
	.word   04c82h,04044h,03800h,03000h,02400h,01c00h,01063h,00400h

CAGEPUR_P:
	.word   64 
	.word   00000h,07fffh,06f7bh,05ef7h,04a52h,039ceh,02529h,01084h
	.word   07fd9h,07f32h,07f30h,07f55h,07f0fh,07af1h,07aaeh,0768bh
	.word   0726ah,06e49h,06a8eh,06a6ch,06a29h,06ab1h,0664bh,061e8h
	.word   0622ah,05e0ah,05de8h,05a2dh,059eah,059a6h,05583h,051a6h
	.word   04d86h,049a9h,04965h,04921h,04567h,04541h,04122h,03d43h
	.word   03d00h,03925h,034c0h,030a0h,02860h,024c2h,02440h,02020h
	.word   01c00h,01460h,01063h,01000h,00c41h,06cdbh,0697ah,04cd3h
	.word   04c93h,04050h,0380eh,0300ch,02409h,01c07h,01064h,00400h

UGBLUE_P:
	.word   64 
	.word   00000h,07fffh,06739h,05ef7h,05294h,04a52h,04210h,0318ch
	.word   0294ah,01ce7h,00842h,07fd3h,07fb9h,07fb3h,07f73h,07f2eh
	.word   07f12h,07aceh,07752h,076ceh,0732dh,06b32h,06aceh,06a6dh
	.word   066f0h,0668ah,06646h,062adh,0624ah,05e8bh,05a49h,05a09h
	.word   059a2h,0566ch,05606h,05229h,051e9h,051c6h,04e09h,049a5h
	.word   04982h,045c9h,045a5h,04541h,041a6h,03da9h,03d43h,03920h
	.word   034c0h,03123h,03100h,02d26h,02d02h,028a0h,02505h,02440h
	.word   01cc4h,01c60h,01483h,00400h,01c5fh,01875h,0104dh,00c29h

;KATBLU_P:
;	.word   64 
;	.word   00000h,056b5h,02529h,01ce7h,014a5h,07f9ah,07fbch,07f56h
;	.word   07f35h,07f15h,07ef4h,07ed2h,076b1h,076d2h,0728fh,06e70h
;	.word   06a4fh,0662dh,0620dh,05debh,059cbh,055aah,04d68h,04568h
;	.word   03527h,028e5h,024e6h,024a2h,020a4h,01c83h,01041h,02e1fh
;	.word   03a3fh,0199fh,031feh,0157dh,025ddh,025bch,01d59h,000b9h
;	.word   01917h,004b5h,010f3h,00072h,018b2h,00070h,0002fh,008adh
;	.word   0004ch,0004bh,0002ah,00049h,00028h,00c47h,00026h,00825h
;	.word   00024h,00023h,00001h,07fffh,06b5ah,04e73h,03defh,02d6bh

RADRED_P:
	.word   64 
	.word   00000h,01000h,01800h,02000h,02800h,03000h,03400h,03800h
	.word   04000h,04800h,05000h,05800h,06000h,06800h,07000h,07c00h
	.word   07ce3h,07d88h,03d69h,05eb1h,06f35h,07f94h,00400h,04e2ch
	.word   07fffh,07ffch,07f97h,07ffbh,07755h,07779h,07756h,07fb9h
	.word   04a0bh,07332h,0524dh,066d0h,05eafh,0566eh,045e8h,03983h
	.word   05647h,00c63h,01084h,014a5h,018c6h,02108h,0294ah,0318ch
	.word   039ceh,04210h,04a52h,05294h,05ad6h,06319h,06b5ah,06f7bh
	.word   0739ch,077bdh,07bdeh,04e00h,06f00h,07bc0h,002ffh,005ffh

JAXBLU_P:
	.word   64 
	.word   00000h,07f9ah,07736h,06e8fh,06670h,06252h,05e4fh,05e2dh
	.word   05a0eh,055ech,055cbh,051adh,04da9h,04567h,04147h,04100h
	.word   03d25h,03904h,03948h,03526h,034e3h,034c1h,03104h,030c3h
	.word   03126h,02ce4h,02ca2h,02c80h,028a3h,028c3h,02861h,024c5h
	.word   02400h,02462h,02082h,020a4h,02060h,02040h,01c20h,01420h
	.word   01000h,07fffh,06318h,05ad6h,05294h,03defh,035adh,0294ah
	.word   02108h,018c6h,014a5h,01084h,00842h,00400h,020bfh,020bch
	.word   01878h,01476h,01895h,01472h,0104fh,00c4dh,00c2ah,00828h

TLBLUE_P:
	.word   64 
	.word   00000h,07fffh,06b5ah,056b5h,04a52h,04210h,039ceh,0318ch
	.word   0294ah,02108h,018c6h,01084h,00842h,07fbah,07fb8h,07f95h
	.word   07f55h,07f53h,07f13h,07f11h,07ed1h,07e8dh,07ef4h,07eb0h
	.word   07e6eh,07e4bh,07e66h,07dc2h,07b15h,07a8fh,076b2h,0764fh
	.word   0724fh,071c6h,06e2dh,0662dh,06145h,055aah,05546h,05522h
	.word   050c1h,04503h,044c1h,03860h,034a1h,03040h,02840h,02400h
	.word   01464h,01440h,00400h,05bdfh,01b9fh,01fdfh,003bfh,003dfh
	.word   0035eh,006fah,00298h,00254h,001f1h,0018eh,0014ch,000c9h


SUB2_P:
	.word   64 
	.word   00000h,03e77h,02a77h,02677h,01e77h,01677h,00e77h,00e37h
	.word   00617h,001f7h,00dd7h,001d7h,001d6h,00197h,015b3h,00577h
	.word   00177h,00157h,00156h,00155h,00155h,00136h,00116h,000f4h
	.word   000f1h,000b3h,000b3h,0008fh,0006eh,0000bh,0000ah,00866h
	.word   00003h,00400h,00842h,01084h,014a5h,018c6h,01ce7h,02529h
	.word   0318ch,039ceh,04210h,04e73h,062f7h,06b5ah,07fffh,07fdch
	.word   07f57h,07af7h,07a92h,07671h,06e4fh,06a0dh,05da9h,05587h
	.word   05165h,04d44h,04923h,04522h,040e0h,03cc0h,03480h,00000h

REP3_P:
	.word   64 
	.word   00000h,03fe6h,03be5h,037e0h,033e0h,033e0h,02fe0h,02380h
	.word   02360h,02340h,02320h,02320h,02320h,022e0h,02300h,022c0h
	.word   022c0h,022a0h,022a0h,022a0h,022a0h,02280h,02260h,02240h
	.word   02240h,02200h,02200h,021e0h,021c0h,02140h,02100h,00ca0h
	.word   00c00h,00400h,00842h,01084h,014a5h,018c6h,01ce7h,02529h
	.word   0318ch,039ceh,04210h,04e73h,062f7h,06b5ah,07fffh,07f9ah
	.word   07f59h,07af6h,07a92h,07671h,06e4fh,06a0dh,05da9h,05587h
	.word   05165h,04d44h,04923h,04522h,040e0h,03cc0h,03480h,00000h

SCORP2_P:
	.word   64 
	.word   00000h,06ad2h,06acdh,06acch,06acah,06ac8h,06ac6h,06a86h
	.word   06a64h,06a42h,06a26h,06a20h,06a20h,069e3h,05a08h,069c4h
	.word   069c0h,069a0h,069a0h,061a0h,061a0h,06580h,06560h,05d40h
	.word   05140h,05900h,05900h,048e0h,044c0h,03840h,03400h,00400h
	.word   00000h,00400h,00842h,01084h,014a5h,018c6h,01ce7h,02529h
	.word   0318ch,039ceh,04210h,04e73h,062f7h,06b5ah,07fffh,07f99h
	.word   07f37h,07b16h,07a92h,07671h,06e4fh,06a0dh,05da9h,05587h
	.word   05165h,04d44h,04923h,04522h,040e0h,03cc0h,03480h,00000h

KATBLU3_P:
	.word   64 
	.word   00000h,056b5h,02529h,01ce7h,014a5h,07f9ah,07fbch,07f56h
	.word   07f35h,07f15h,07ef4h,07ed2h,076b1h,076d2h,0728fh,06e70h
	.word   06a4fh,0662dh,0620dh,05debh,059cbh,055aah,04d68h,04568h
	.word   03527h,028e5h,024e6h,024a2h,020a4h,01c83h,01041h,073dfh
	.word   06b9fh,0635eh,05b1ch,056fbh,052dah,04eb9h,04a98h,04677h
	.word   04256h,03e35h,03a14h,035f3h,031d2h,02db1h,02990h,0256fh
	.word   0254eh,0252dh,0190ch,014ebh,014cah,00ca9h,00c88h,00467h
	.word   00046h,00025h,00001h,07fffh,06b5ah,04e73h,03defh,02d6bh

KTPRPL2_P:
	.word   64 
	.word   00000h,056b5h,02529h,01ce7h,014a5h,07f9ah,07fbch,07f56h
	.word   07f35h,07f15h,07ef4h,07ed2h,076b1h,076d2h,0728fh,06e70h
	.word   06a4fh,0662dh,0620dh,05debh,059cbh,055aah,04d68h,04568h
	.word   03527h,028e5h,024e6h,024a2h,020a4h,01c83h,01041h,07a15h
	.word   07e35h,07d95h,079f6h,07572h,075d0h,071b1h,06550h,064aeh
	.word   05d0fh,054abh,04cebh,0486ch,048a9h,04067h,03c27h,034a7h
	.word   03046h,02c46h,02825h,02444h,02023h,01c43h,01822h,01422h
	.word   01022h,00c22h,00001h,07fffh,06b5ah,04e73h,03defh,02d6bh

smoke_p
	.word   64 
	.word   00000h,07fffh,07bdeh,0739ch,06b5ah,06739h,06318h,05ef7h
	.word   05ad6h,056b5h,05294h,04e73h,04a52h,04631h,04210h,03defh
	.word   039ceh,035adh,0318ch,02d6bh,0294ah,02529h,02108h,01ce7h
	.word   018c6h,014a5h,01084h,00c63h,00842h,00000h,00000h,01862h
	.word   00c00h,00400h,00842h,01084h,014a5h,018c6h,01ce7h,02529h
	.word   0318ch,039ceh,04210h,04e73h,062f7h,06b5ah,07fffh,07f9ah
	.word   07f59h,07af6h,07a92h,07671h,06e4fh,06a0dh,05da9h,05587h
	.word   05165h,04d44h,04923h,04522h,040e0h,03cc0h,03480h,00000h

noob_p
	.word	64
	.word	0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0
	.word	0,0,0,0,0,0,0,0

noob_froze_p
	.word	64
	.word	>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff
	.word	>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff
	.word	>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff
	.word	>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff
	.word	>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff
	.word	>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff
	.word	>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff
	.word	>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff,>ffff

**************************************************************************
*											     *
*  Bloody cut up palettes for characters						     *
*											     *
**************************************************************************
change_to_bloody_pal
	move	*a8(ochar),a0,w
	sll	6,a0
	addi	bloody_palettes,a0

	move	*a8(oflags2),a1,w
	btst	b_ugly_pal,a1
	jreq	gcb3
	addi	32,a0			; ugly = get 2nd palette entry

gcb3	move	*a0,a0,l
	jauc	swpal			; switch to bloody pal


bloody_palettes
	.long	TMBLOOD_P,TMBLUD2_P	; hathead
	.long	LKBLUD1_P,LKBLUD2_P	; kang
	.long	JCBLUD1_P,JCBLUD2_P	; cage
	.long	UGBLUD2_P,UGBLUD1_P	; baraka

	.long	KT1BLUD_P,KT1BLD2_P	; female ninja 1
	.long	KT2BLUD_P,KT2BLD2_P	; female ninja 2
	.long	TYBLUD_P,TBBLUD_P	; shang tsung
	.long	RDBLUD1_P,RDBLUD2_P	; raiden

	.long	SUBBLD_P,SUBBLD2_P	; subzero
	.long	REPBLD_P,REPBLD3_P	; reptile
	.long	SCRBLD_P,SCRBLD2_P	; scorpion
	.long	JXBLUD2_P,JXBLUD1_P	; jax

	.long	TMBLOOD_P,TMBLOOD_P	; smoke
	.long	noob_p,noob_p
	.long	TMBLOOD_P,TMBLOOD_P	; bbq


RDBLUD2_P:
	.word   64 
	.word   00000h,07fffh,04a52h,04631h,03defh,0318ch,02d6bh,02108h
	.word   01084h,00c63h,07fb8h,07fc0h,07f97h,07ce0h,07c60h,07a72h
	.word   079ceh,0779ch,06860h,0737bh,0728ch,06f5ah,06f2eh,05840h
	.word   06a91h,06929h,06718h,05020h,062e0h,06207h,061aah,04820h
	.word   05ed6h,03820h,0564ch,05527h,03440h,03040h,0522fh,02840h
	.word   04a0eh,02440h,04549h,02040h,01820h,01000h,024c5h,00400h
	.word   07c20h,05f9ah,06000h,03eb3h,02e0dh,04c00h,03c00h,01dcdh
	.word   03401h,02c01h,01800h,00c83h,07ffch,07ffbh,056b4h,07bffh

LKBLUD2_P:
	.word   64 
	.word   00000h,06739h,056b5h,039ceh,018c6h,00842h,07f97h,07f0fh
	.word   07fb8h,07f54h,07f32h,07eeeh,07f51h,07ef0h,07f93h,07aadh
	.word   076f0h,076cdh,0728bh,072ach,072aeh,06e8eh,06a6ah,06a6ch
	.word   06a49h,0666ch,06207h,06229h,05e09h,05e2ah,059e7h,055e8h
	.word   05609h,051a6h,04964h,03d01h,038e0h,028a1h,01800h,00001h
	.word   01d1ah,018f8h,018d6h,014d3h,014b2h,010b0h,0108eh,00c8dh
	.word   00c6ch,00c6ah,00869h,00847h,00425h,07ffch,02400h,03400h
	.word   03800h,03c00h,04c00h,05c00h,06800h,07000h,07400h,07c00h

JCBLUD2_P:
	.word   64 
	.word   00000h,07fffh,06f7bh,05ef7h,04a52h,039ceh,02529h,01084h
	.word   07fd9h,07f32h,07f55h,07f0fh,07af1h,07aaeh,0768bh,0726ah
	.word   06e49h,06a29h,06ab1h,0664bh,061e8h,05e0ah,05de8h,05a2dh
	.word   059eah,059a6h,05583h,051a6h,049a9h,04965h,04921h,03d43h
	.word   03d00h,03925h,030a0h,02860h,024c2h,02440h,02020h,01c00h
	.word   01460h,01000h,00c41h,070c3h,0696ah,04040h,03800h,03000h
	.word   02400h,01c00h,00400h,00c00h,01c00h,02800h,03400h,04000h
	.word   04c00h,05800h,05c00h,06c00h,07000h,07400h,07c00h,07d44h

UGBLUD2_P:
	.word   64 
	.word   00000h,07fffh,06739h,05ef7h,05294h,04a52h,04210h,0318ch
	.word   0294ah,01ce7h,00842h,07fd3h,07fb9h,07fb3h,07f73h,07f29h
	.word   07f12h,07acah,07752h,076ceh,0732dh,06b32h,06aceh,06a6dh
	.word   066f0h,06646h,062adh,0624ah,05e8bh,05a49h,059a1h,051e9h
	.word   051c6h,04e09h,045a5h,04541h,041a6h,03d43h,03920h,034c0h
	.word   03123h,03100h,02d02h,028a0h,02505h,02440h,01cc4h,01c60h
	.word   01483h,00400h,07c47h,05466h,03444h,02423h,01800h,02800h
	.word   03400h,03c00h,04800h,05800h,06400h,06c00h,07000h,07c00h

KT2BLUD_P:
	.word   64 
	.word   00000h,056b5h,014a5h,07f9ah,07fbch,07f56h,07f35h,07f15h
	.word   07ef4h,07ed2h,076b1h,06e70h,06a4fh,0662dh,0620dh,05debh
	.word   059cbh,055aah,04d68h,04568h,03527h,028e5h,024e6h,020a4h
	.word   01041h,07e1fh,07e3fh,079feh,0757dh,075ddh,071bch,06559h
	.word   05d17h,054b5h,04cf3h,04872h,048b2h,04070h,03c2fh,034adh
	.word   0304ch,02c4bh,0282ah,02449h,02028h,01c47h,01826h,01425h
	.word   00024h,00023h,00001h,07fffh,06b5ah,03defh,02d6bh,01800h
	.word   02000h,02c00h,04000h,04800h,05000h,06000h,06400h,07400h

KT1BLD2_P:
	.word   64 
	.word   00000h,056b5h,014a5h,07f9ah,07fbch,07f56h,07f35h,07f15h
	.word   07ef4h,07ed2h,076b1h,06e70h,06a4fh,0662dh,0620dh,05debh
	.word   059cbh,055aah,04d68h,04568h,03527h,028e5h,024e6h,020a4h
	.word   01041h,01138h,01d58h,01517h,00096h,008f6h,008d5h,00072h
	.word   00030h,0000eh,0000ch,0000bh,0000bh,00009h,00008h,00006h
	.word   00005h,00004h,00003h,00002h,00001h,00000h,00000h,00000h
	.word   00000h,00000h,00001h,07fffh,06b5ah,03defh,02d6bh,01800h
	.word   02000h,02c00h,04000h,04800h,05000h,06000h,06400h,07400h

KT2BLD2_P:
	.word   64 
	.word   00000h,056b5h,014a5h,07f9ah,07fbch,07f56h,07f35h,07f15h
	.word   07ef4h,07ed2h,076b1h,06e70h,06a4fh,0662dh,0620dh,05debh
	.word   059cbh,055aah,04d68h,04568h,03527h,028e5h,024e6h,020a4h
	.word   01041h,07edfh,07ebfh,07a15h,075b0h,075d4h,071b2h,0654fh
	.word   05d0dh,054abh,04cebh,04867h,048a9h,04067h,03c27h,034a7h
	.word   03045h,02c45h,02822h,02443h,02022h,01c43h,01822h,01422h
	.word   00024h,00023h,00001h,07fffh,06b5ah,03defh,02d6bh,01800h
	.word   02000h,02c00h,04000h,04800h,05000h,06000h,06400h,07400h

TBBLUD_P:
   .word   64 
   .word   00000h,0567fh,01c5fh,045beh,0355eh,028ddh,01859h,01436h
   .word   01030h,00c2dh,0082bh,00828h,00405h,07fffh,06b5ah,056b5h
   .word   039ceh,0318ch,02108h,018c6h,01084h,00842h,07fbah,07fb8h
   .word   07f53h,07f13h,07f11h,07e8dh,07af4h,076b0h,0766eh,0764bh
   .word   07266h,071c2h,06f15h,06ab2h,0664fh,065c6h,0622dh,05a2dh
   .word   05545h,049aah,044c1h,038c1h,02c60h,028a1h,02440h,01c40h
   .word   01800h,01440h,00400h,01000h,02000h,02c00h,03400h,04000h
   .word   04800h,04c00h,05800h,05800h,06000h,06000h,06c00h,07c00h


TMBLUD2_P:
   .word   59 
   .word   00000h,07c20h,04000h,07fffh,02108h,06ed1h,06b5ah,01ce7h
   .word   04e73h,02400h,05a2ah,04210h,01484h,039ceh,0666dh,0318ch
   .word   00400h,0294ah,0668fh,028c1h,00842h,05a4dh,07f74h,07f11h
   .word   00800h,045c9h,05294h,00841h,01840h,03800h,05020h,07313h
   .word   07ff8h,03120h,034e5h,00022h,00064h,000a7h,024c0h,03d60h
   .word   04580h,028e0h,02d00h,049a0h,04dc0h,051e0h,05a00h,06640h
   .word   03d83h,072a0h,06a60h,07ae0h,045eah,03c00h,06aa6h,07333h
   .word   05e8bh,060e3h,07cc5h


SUBBLD_P:
   .word   64 
   .word   00000h,02e9bh,04f7fh,036ffh,057ffh,04fdfh,05fffh,036ffh
   .word   0433fh,067ffh,047bfh,04fffh,0377fh,07fffh,01e18h,032dfh
   .word   0125dh,026bfh,02f1fh,00081h,01595h,00027h,0225dh,00effh
   .word   0575dh,0088ah,0177fh,00400h,014a5h,018c6h,02529h,0318ch
   .word   039ceh,04210h,04e73h,062f7h,06b5ah,07fffh,07f99h,07f37h
   .word   07b16h,07a92h,07671h,06a0dh,05da9h,05165h,04d44h,04522h
   .word   040e0h,03cc0h,01000h,01800h,02800h,03400h,04000h,04800h
   .word   05000h,05c00h,06400h,06c00h,07000h,07400h,07c00h,03480h

SUBBLD2_P:
   .word   64 
   .word   00000h,000b2h,01196h,00116h,01a16h,011f6h,02216h,00116h
   .word   00556h,02a16h,009d6h,01216h,00196h,04216h,0002fh,000f6h
   .word   00074h,000d6h,00136h,00000h,0000ch,00000h,00074h,00116h
   .word   01974h,00001h,00196h,00400h,014a5h,018c6h,02529h,0318ch
   .word   039ceh,04210h,04e73h,062f7h,06b5ah,07fffh,07f99h,07f37h
   .word   07b16h,07a92h,07671h,06a0dh,05da9h,05165h,04d44h,04522h
   .word   040e0h,03cc0h,01000h,01800h,02800h,03400h,04000h,04800h
   .word   05000h,05c00h,06400h,06c00h,07000h,07400h,07c00h,03480h

REPBLD_P:
   .word   64 
   .word   00000h,01e45h,02f2dh,02ea7h,02fafh,02f8dh,02fb1h,02ea7h
   .word   02eeah,03fadh,02f6bh,02fadh,02f27h,053fah,011c1h,02e86h
   .word   02600h,02e63h,02ec5h,00040h,00540h,00000h,02602h,02ea0h
   .word   0270fh,00040h,02f20h,00400h,014a5h,018c6h,02529h,0318ch
   .word   039ceh,04210h,04e73h,062f7h,06b5ah,07fffh,07f99h,07f37h
   .word   07b16h,07a92h,07671h,06a0dh,05da9h,05165h,04d44h,04522h
   .word   040e0h,03cc0h,01000h,01800h,02800h,03400h,04000h,04800h
   .word   05000h,05c00h,06400h,06c00h,07000h,07400h,07c00h,03480h

REPBLD3_P:
   .word   64 
   .word   00000h,01aa5h,02b8dh,02b07h,02bafh,02badh,02bb1h,02b07h
   .word   02b4ah,03badh,02babh,02badh,02b87h,04fbah,00e21h,02ae6h
   .word   02260h,02ac3h,02b25h,00040h,00540h,00000h,02602h,02ea0h
   .word   0270fh,00040h,02f20h,00400h,014a5h,018c6h,02529h,0318ch
   .word   039ceh,04210h,04e73h,062f7h,06b5ah,07fffh,07f99h,07f37h
   .word   07b16h,07a92h,07671h,06a0dh,05da9h,05165h,04d44h,04522h
   .word   040e0h,03cc0h,01000h,01800h,02800h,03400h,04000h,04800h
   .word   05000h,05c00h,06400h,06c00h,07000h,07400h,07c00h,03480h

SCRBLD2_P:
   .word   64 
   .word   00000h,05d61h,06e49h,06dc3h,06ecbh,06ea9h,06ecdh,06dc3h
   .word   06e06h,06ecfh,06e87h,06ec9h,06e43h,06ed5h,050e0h,06da2h
   .word   06520h,06d80h,06de1h,04000h,04460h,00c00h,06520h,06dc0h
   .word   0662bh,01800h,06e40h,00400h,014a5h,018c6h,02529h,0318ch
   .word   039ceh,04210h,04e73h,062f7h,06b5ah,07fffh,07f99h,07f37h
   .word   07b16h,07a92h,07671h,06a0dh,05da9h,05165h,04d44h,04522h
   .word   040e0h,03cc0h,01000h,01800h,02800h,03400h,04000h,04800h
   .word   05000h,05c00h,06400h,06c00h,07000h,07400h,07c00h,03480h


JXBLUD1_P:
   .word   64 
   .word   00000h,020bfh,020bch,01476h,01895h,01472h,0104fh,00c4dh
   .word   00c2ah,00828h,06b16h,06ab2h,05e2eh,05a10h,0560dh,055ebh
   .word   051cch,04daah,04d89h,04567h,03d25h,03905h,038c0h,034e3h
   .word   03106h,02ce4h,02ca1h,02c80h,02881h,028e4h,024a2h,02460h
   .word   02081h,01c00h,01840h,01862h,01820h,01800h,01400h,00c00h
   .word   00800h,07fffh,06318h,05294h,035adh,0294ah,02108h,018c6h
   .word   014a5h,01084h,00842h,00400h,01000h,02400h,03000h,03800h
   .word   04400h,05000h,05800h,06000h,06400h,06c00h,07400h,07c00h

;***************************************************************

player_froze_pal
	movi	ochar_froze_pals,a0
	calla	get_char_long
	jruc	player_swpal


ochar_froze_pals
	.long	TMFREZ_P	; 0
	.long	LKFREZ_P	; 1
	.long	JCFREZ_P	; 2
	.long	UGFREZ_P	; 3
	.long	KTFREZ_P	; 4
	.long	KTFREZ_P	; 5
	.long	STFREZ_P	; 6
	.long	RNFREZ_P	; 7
	.long	NJFREZ_P	; 8
	.long	NJFREZ_P	; 9
	.long	NJFREZ_P	; 10
	.long	JXFREZ_P	; 11
	.long	gorof_p		; 12 - kintaro
	.long	BGFREZ_P	; 13 - shao kahn

	.long	NJFREZ_P	; 14
	.long	noob_froze_p	; 15
	.long	KTFREZ_P	; 16


BGFREZ_P:
   .word   64 
   .word   00000h,067ffh,05fffh,053ffh,04bffh,043ffh,03fffh,03bffh
   .word   037ffh,02bffh,023dfh,01b9fh,0135fh,00b1fh,006ffh,0029fh
   .word   0025fh,067ffh,067ffh,067ffh,063ffh,05bffh,057ffh,057ffh
   .word   0575fh,053ffh,04fffh,04bffh,047ffh,047ffh,03fffh,03fffh
   .word   03fdfh,03bdfh,037ffh,037bfh,033dfh,032dfh,0335fh,0337fh
   .word   02fbfh,02e3fh,02b5fh,02b9fh,02abfh,0263fh,026dfh,0233fh
   .word   0235fh,0231fh,0227fh,0237fh,01e3fh,01effh,01b1fh,01adfh
   .word   016ffh,0165fh,012dfh,00e3fh,00abfh,0025fh,0023fh,0021fh

gorof_p:
   .word   64 
   .word   00000h,053ffh,053ffh,053ffh,053ffh,053ffh,053ffh,053ffh
   .word   04bffh,053ffh,04bffh,053ffh,053ffh,053ffh,053ffh,053ffh
   .word   03fffh,043ffh,053ffh,03fffh,04bffh,04fffh,03fffh,04bffh
   .word   0537fh,033ffh,03fffh,0531fh,03fdfh,03bbfh,02bffh,04ebfh
   .word   03b7fh,02fdfh,03f1fh,01fffh,02b9fh,02f5fh,03e9fh,0235fh
   .word   02b1fh,01b3fh,01effh,00f7fh,01affh,00f1fh,01a9fh,00effh
   .word   00adfh,00a9fh,002ffh,0029fh,0029fh,053ffh,043ffh,037ffh
   .word   02bffh,01bffh,013ffh,007dfh,0037fh,0033fh,002ffh,002bfh


TMFREZ_P:
   .word   64 
   .word   00000h,053ffh,04fffh,047ffh,03bffh,033ffh,02fffh,023ffh
   .word   01bffh,013ffh,00bdfh,0039fh,0037fh,0033fh,0029fh,0029fh
   .word   057ffh,057ffh,04bffh,047ffh,043ffh,03fffh,03bffh,037ffh
   .word   036bfh,033ffh,02bffh,027ffh,023ffh,01fffh,01e9fh,01bffh
   .word   017dfh,0169fh,00fbfh,00a9fh,0033fh,0029fh,0031fh,0029fh
   .word   0031fh,003ffh,003ffh,003ffh,003ffh,00fffh,003ffh,003ffh
   .word   003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003dfh
   .word   003dfh,003ffh,0039fh,003bfh,0035fh,0035fh,002ffh,002bfh

LKFREZ_P:
   .word   64 
   .word   00000h,01bffh,00bffh,0037fh,0027ah,001f6h,033ffh,033ffh
   .word   033ffh,033ffh,033ffh,033ffh,033ffh,033ffh,033ffh,02fffh
   .word   02bffh,02bffh,02bffh,027ffh,027ffh,027ffh,023ffh,023ffh
   .word   01ffeh,01fffh,01ffdh,01bfeh,01bffh,01bffh,017bbh,017ddh
   .word   013bdh,013deh,00f9bh,00b9ch,00b7bh,00bbdh,0075ah,0035ah
   .word   00339h,00318h,0033ah,0031ah,002b5h,00294h,00254h,00255h
   .word   001b4h,001b4h,02a57h,01e58h,00e38h,00237h,00237h,00258h
   .word   00238h,00237h,00217h,00217h,00216h,001f6h,001d5h,033ffh

JCFREZ_P:
   .word   64 
   .word   00000h,013ffh,003ffh,003ffh,003ffh,003ffh,0039fh,002ffh
   .word   013ffh,013ffh,013ffh,013ffh,013ffh,00fffh,00fffh,00bffh
   .word   007ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh
   .word   003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh
   .word   003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh
   .word   003dfh,003ffh,0039fh,0037fh,0033fh,0039fh,0031fh,002ffh
   .word   0027fh,002dfh,002dfh,0027fh,002bfh,0033fh,003dfh,0033fh
   .word   002ffh,002bfh,0027fh,0027fh,0027fh,0027fh,002dfh,0027fh

UGFREZ_P:
   .word   64 
   .word   00000h,043ffh,02bffh,023ffh,017ffh,00fffh,007ffh,003ffh
   .word   003ffh,003dfh,0033fh,043ffh,043ffh,043ffh,043ffh,043ffh
   .word   043ffh,03fffh,03bffh,03bffh,037ffh,02fffh,02fffh,02fffh
   .word   02bffh,02bffh,02bffh,027ffh,027ffh,023ffh,01fffh,01fffh
   .word   01fffh,01bffh,01bffh,017ffh,017ffh,017ffh,013ffh,00fffh
   .word   00fffh,00bffh,00bffh,00bffh,007ffh,003ffh,003ffh,003ffh
   .word   003bfh,003ffh,003ffh,003ffh,003ffh,0039fh,003ffh,0033fh
   .word   003bfh,0035fh,0037fh,002ffh,0433fh,01b5fh,0033fh,0031fh

KTFREZ_P:
   .word   64 
   .word   00000h,00bffh,003bdh,0037bh,00339h,033ffh,033ffh,033ffh
   .word   033ffh,033ffh,033ffh,033ffh,02bffh,02bffh,027ffh,023ffh
   .word   01fffh,01bffh,017ffh,013ffh,00fffh,00bfeh,003fch,003fch
   .word   003bbh,00379h,0037ah,00336h,00338h,00317h,002d5h,02fffh
   .word   033ffh,033ffh,02fffh,02bffh,02bffh,027ffh,01bdfh,01b3fh
   .word   0139fh,00b3fh,0037fh,002ffh,0033fh,002ffh,002bfh,0033fh
   .word   002dfh,002dfh,002beh,002ddh,002bch,002dbh,002bah,002b9h
   .word   002b8h,002b7h,00295h,033ffh,01fffh,003ffh,003ffh,003ffh

STFREZ_P:
   .word   64 
   .word   00000h,067ffh,053ffh,03fffh,033ffh,02bffh,023ffh,01bffh
   .word   013ffh,00bbfh,0037fh,0033fh,002ffh,067ffh,067ffh,067ffh
   .word   067ffh,067ffh,067ffh,067ffh,067ffh,067ffh,067ffh,067ffh
   .word   067ffh,067ffh,067ffh,067ffh,063ffh,063ffh,05fffh,05fffh
   .word   05bffh,05bffh,057ffh,04fffh,04bffh,03fffh,03fffh,03fdfh
   .word   03b7fh,02fbfh,02f7fh,0231fh,01f5fh,01affh,012ffh,00ebfh
   .word   0031fh,002ffh,002bfh,067ffh,067ffh,067ffh,067ffh,067ffh
   .word   063ffh,053ffh,04bffh,03bffh,02fffh,023ffh,01bffh,00f7fh

RNFREZ_P:
   .word   64 
   .word   00000h,0033fh,0033fh,0033fh,0037fh,003bfh,003dfh,003ffh
   .word   003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh
   .word   003ffh,003ffh,003ffh,023ffh,033ffh,043ffh,0033fh,013ffh
   .word   043ffh,043ffh,043ffh,043ffh,03bffh,03bffh,03bffh,043ffh
   .word   00fffh,037ffh,017ffh,02bffh,023ffh,01bffh,00bffh,003ffh
   .word   01bffh,0039fh,003bfh,003dfh,003ffh,003ffh,003ffh,003ffh
   .word   003ffh,007ffh,00fffh,017ffh,01fffh,027ffh,02fffh,033ffh
   .word   037ffh,03bffh,03fffh,013ffh,033ffh,03fffh,003ffh,003ffh

NJFREZ_P:
   .word   64 
   .word   00000h,00bffh,00bffh,003ffh,003ffh,003ffh,003ffh,003ffh
   .word   003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh
   .word   003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh,003ffh
   .word   003ffh,003ffh,003ffh,003dfh,003bfh,0033fh,0029fh,002ffh
   .word   0029fh,0029fh,002dfh,0031fh,0033fh,0035fh,0037fh,003bfh
   .word   003ffh,003ffh,003ffh,007ffh,01bffh,023ffh,037ffh,037ffh
   .word   037ffh,033ffh,033ffh,02fffh,027ffh,023ffh,017ffh,00fffh
   .word   00bffh,007dfh,003bfh,003bfh,0037fh,0035fh,0031fh,0029fh

JXFREZ_P:
   .word   64 
   .word   00000h,037ffh,02fffh,027ffh,01fffh,01bffh,017ffh,017ffh
   .word   013ffh,00fffh,00fffh,00bffh,007ffh,003ffh,003ffh,003bfh
   .word   003dfh,003bfh,003ffh,003dfh,0039fh,0037fh,003bfh,0037fh
   .word   003dfh,0039fh,0035fh,0033fh,0035fh,0037fh,0031fh,0037fh
   .word   002bfh,0031fh,0033fh,0035fh,0031fh,002ffh,002dfh,002dfh
   .word   002bfh,037ffh,01bffh,013ffh,00bffh,003ffh,003ffh,003ffh
   .word   003bfh,0037fh,0035fh,0033fh,002ffh,002bfh,0373fh,0275fh
   .word   01b1fh,0131fh,00f3fh,0031fh,002ffh,002ffh,002dfh,002dfh

;*************************************************************************

	.end

