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
	.file	'mkend.asm'
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
	.include	diagaudn.asm
	.include	stringh.asm
	.text

************************************************************************

congrats
	calla	nosounds
	sleep	1

	movi	>40,a3
	calla	send_code_a3		; start the VICTORY tune !!!!

	movi	pid_fx,a0
	calla	dallprc			; kill object deleter !
	movi	fl_winner,a11
	create	pid_fx,boonpal_stuff	; flash letters

	calla	get_winner_ochar	; a0 = winner
	movi	>19,a1			; rise time !!
	movi	bpal_flash1,a2		; color
	jsrp	msg_rise
	sleep	>a0

	movk	12,a0
	movi	>15,a1			; rise time !!
	movi	bpal_hot_green,a2 	; color
	jsrp	msg_rise
	sleep	>38

	movk	13,a0
	movi	>10,a1			; rise time !!
	movi	bpal_white,a2		; color
	jsrp	msg_rise

	sleep	>140

	movi	pf_end_clue,a8
	calla	lm_setup

	push	a0
	movk	11,a0
	calla	randu
	dec	a0
	sll	5,a0
	addi	clue_table,a0
	move	*a0,a8,l
	pull	a0
	jsrp	printf			; print out a clue !!

	sleep	>80
	calla	murder
	jsrp	amode_fade_retp

	calla	murder_myoinit_score
	calla	clr_scrn

	calla	get_winner_ochar	; a0 = winner ochar
	jsrp	show_a0_ending

	calla	display_on
	jsrp	cast_of_characters
	calla	murder
	calla	fade_all_sky
	sleep	>40

	calla	murder_myoinit_score
	calla	clr_scrn
	jsrp	mk2_design_team

	calla	murder_myoinit
	calla	dont_show_scores
	retp


mk2_team_photos
	move	@c_1p_tries,a0,w
	cmpi	3,a0
	jrhi	sans_photos		; too many tries !!

oct_team_photos
	calla	murder_myoinit
	calla	dont_show_scores
	movi	>0b,a11
	calla	do_a11_background

	movi	pf_team_1,a8
	jsrp	lm_printf
	movi	pf_team_2,a8
	jsrp	lm_printf
	movi	pf_team_3,a8
	jsrp	lm_printf
	movi	pf_team_4,a8
	jsrp	lm_printf

	sleep	>40*8

	calla	murder_myoinit
	calla	clr_scrn
	sleep	2

sans_photos
	retp

pf_team_1
	mess_mac rd11font,2,>fa,>30,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"JOHN\nTOBIAS",0
	.even

pf_team_2
	mess_mac rd11font,2,>90,>30,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"ED\nBOON",0
	.even

pf_team_3
	mess_mac rd11font,2,>90,>A0,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"DAN\nFORDEN",0
	.even

pf_team_4
	mess_mac rd11font,2,>fa,>A0,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"TONY\nGOSKIE",0
	.even


pf_end_clue
	mess_mac rd7font,2,scrrgt/2,>f0,bpal_red*>10000,strcnrmos_scr,0
	.byte	0
	.even

clue_table
	.long	txt_c1
	.long	txt_c2
	.long	txt_c3
	.long	txt_c4
	.long	txt_c5
	.long	txt_c6
	.long	txt_c7
	.long	txt_c8
	.long	txt_c9
	.long	txt_c10
	.long	txt_c11


txt_c1	.string	"WHERE IS KANO ?",0
	.even
txt_c2	.string	"WHERE IS SONYA ?",0
	.even
txt_c3	.string	"WHERE IS GORO ?",0
	.even
txt_c4	.string	"WHO IS SMOKE ?",0
	.even
txt_c5	.string	"FRIENDSHIP ?",0
	.even
txt_c6	.string	"BABALITY ?",0
	.even
txt_c7	.string	"WHO IS JADE ?",0
	.even
txt_c8	.string	"CEAMR ODSE NTO EXITS",0
	.even
txt_c9	.string	"EMRO BATMOK OT MEOK",0
	.even
txt_c10	.string	"SRUEP GHIH MIPTAC",0
	.even
txt_c11 	.string	"THREE RAE ON STNIIIAAMEL",0
	.even


msg_rise
	move	a1,*a13(p_store1),w
	sll	5,a0
	addi	end_winner_text,a0
	move	*a0,a0,l

	push	a0
	push	a2
	movi	pf_rise,a8
	calla	lm_setup
	pull	a5
	sll	16,a5
	pull	a8
	jsrp	printf

	movk 	1,a0
	move	a0,@f_novel,w		; avoid race condition

	movi	->80000,a1
	callr	set_objlst2_vel

	clr	a0
	move	a0,@f_novel,w		; start the letters movin up
	move	*a13(p_store1),a0,w
	calla	prcslp

	movk 	1,a0
	move	a0,@f_novel,w		; stop !!
	clr	a1
	callr	set_objlst2_vel		; stop each letter

	move	@objlst2,a0,l
rise4	move	a0,a5			; a5 = last object list #2
	move	*a0,a0,l
	jrne	rise4

	move	@objlst,a1,l
	move	@objlst2,a2,l

	clr	a0
	move	a0,@objlst,l
	move	a0,@objlst2,l

	move	a1,*a5(olink),l		; link: list2 ----> list1
	move	a2,@objlst,l

	retp


set_objlst2_vel
	move	@objlst2,a0,l
rise3	move	a1,*a0(oyvel),l		; heading upwards
	move	*a0,a0,l
	jrne	rise3
	rets

pf_rise
	mess_mac rd15font,2,200,>100,bpal_white*>10000,strcnrmos_scr,0
	.byte	0
	.even


end_winner_text
	.long	ew_hh
	.long	ew_lk
	.long	ew_jc
	.long	ew_sa
	.long	ew_fn1
	.long	ew_fn2
	.long	ew_st
	.long	ew_rd
	.long	ew_sz
	.long	ew_rp
	.long	ew_sc
	.long	ew_jx
	.long	txt_sk_dead
	.long	txt_once_again

	.long	txt_found_1	; 14
	.long	txt_found_2
	.long	txt_found_3
	.long	txt_found_4
	.long	txt_found_5


ew_hh	.string	"KUNG LAO WINS",0
	.even
ew_lk	.string	"LIU KANG WINS",0
	.even
ew_jc	.string	"CAGE WINS",0
	.even
ew_sa	.string	"BARAKA WINS",0
	.even
ew_fn1	.string	"KITANA WINS",0
	.even
ew_fn2	.string	"MILEENA WINS",0
	.even
ew_st	.string	"SHANG TSUNG WINS",0
	.even
ew_rd	.string	"RAIDEN WINS",0
	.even
ew_sz	.string	"SUB-ZERO WINS",0
	.even
ew_rp	.string	"REPTILE WINS",0
	.even
ew_sc	.string	"SCORPION WINS",0
	.even
ew_jx	.string	"JAX WINS",0
	.even

txt_sk_dead
	.string	"SHAO KAHN'S RULE IS OVER",0
	.even

txt_once_again
	.string	"ONCE AGAIN\n"
	.string "YOU ARE THE SUPREME\n"
	.string	"MORTAL KOMBAT WARRIOR !!",0
	.even

txt_found_1
	.string	"CONGRATULATIONS !!",0
	.even

txt_found_2
	.string	"YOU HAVE FOUND THE PASSAGE\n"
	.string	"FROM THE OUTWORLD TO THE\n"
	.string	"EARTH REALM.",0
	.even

txt_found_3
	.string	"NOW YOU MUST BATTLE WITH\n"
	.string	"AN UNDISCOVERED WARRIOR\n"
	.string	"FROM MORTAL KOMBAT ONE",0
	.even

txt_found_4
	.string	"PREPARE YOURSELF !!",0
	.even

txt_found_5
	.string	"TO RETURN TO GORO'S LAIR",0
	.even

;************************************************************************

pf_mk_cast
	mess_mac rd11font,2,scrrgt/2,>40,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"MORTAL KOMBAT II\nCAST OF CHARACTERS",0
	.even


cast_of_characters
	calla	murder_myoinit
	calla	dont_show_scores

	movk	6,a11
	calla	do_a11_background

	movi	pf_mk_cast,a8
	jsrp	lm_printf
	sleep	>40
	movi	oid_text,a0
	calla	dallobj



	movi	cast_table,a11
coc3	move	*a11+,a0,w
	move	a0,@p1_char,w
	clr	a1
	clr	a2			; player = 1
	calla	make_player_obj		; a8 = player 1 object
	move	a8,@p1_obj,l   		; player 1 object
	movi	p1_ram,a0
	move	a0,*a8(oimg),l
	movi	oid_p1,a0
	move	a0,*a8(oid),w
	clr	a9
	calla	do_first_a9_frame	; pose: stance frame #1

	create	pid_p1,take_a_bow
	move	*a8(oypos),*a0(p_ganiy),w		; set the grounded y pos
	move	a0,*a13(p_store3),l

	move	*a11+,a0,w
	calla	set_x_woff  				; player 1 x offset

	move	@worldtly+16,a0,w
	subi	>70,a0
	move	a0,*a8(oypos),w
	calla	insobja8

	move	*a11+,a0,w

	move	a0,@p2_char,w
	clr	a1
	movk	1,a2			; player = 2
	calla	make_player_obj		; a8 = player 2 object
	move	a8,@p2_obj,l   		; player 2 object
	movi	p2_ram,a0
	move	a0,*a8(oimg),l
	movi	oid_p2,a0
	move	a0,*a8(oid),w
	clr	a9
	calla	do_first_a9_frame			; pose: stance frame #1
	calla	flip_multi
	create	pid_p2,take_a_bow
	move	*a8(oypos),*a0(p_ganiy),w		; set the grounded y pos
	move	a0,*a13(p_store4),l

	move	@worldtly+16,a0,w
	subi	>70,a0
	move	a0,*a8(oypos),w
	calla	insobja8
	move	*a11+,a0,w
	calla	set_x_woff  		; player 1 x offset

	sleep	>40

	move	*a11+,a14,l
	pushp	a11
	movi	pf_left_bow,a8
	push	a14
	calla	lm_setup
	pull	a8
	jsrp	printf
	pullp	a11

	move	*a11+,a14,l
	pushp	a11
	movi	pf_right_bow,a8
	push	a14
	calla	lm_setup
	pull	a8
	jsrp	printf
	pullp	a11

	sleep	>b0

	movi	make_room_4_next,a7
	move	*a13(p_store3),a0,l
	calla	fastxfer
	move	*a13(p_store4),a0,l
	calla	fastxfer
	sleep	>20
	movi	oid_text,a0
	calla	dallobj
	sleep	>10
	move	*a11,a0,w
	jrne	coc3

	sleep	>40
	retp



take_a_bow
	movk	6,a9
	calla	get_char_ani
	addi	32,a9
	calla	do_next_a9_frame
	clr	a0
	movi	>10000,a1
	movi	>8000,a2
	movi	never_ani,a3
	jsrp	flight

	movk	6,a9
	calla	find_ani_part2
	movk	3,a0
	jsrp	mframew			; landing animation

	movi	>29,a9
	calla	get_char_ani
	movk	6,a0
	jsrp	mframew
	jauc	wait_forever


make_room_4_next
	clr	a6
	push	a6
	calla	face_opponent
	pull	a6

	movk	8,a9
	calla	get_char_ani
	movi	>60000,a0
	move	*a8(oid),a1,w
	cmpi	oid_p2,a1
	jreq	bow3
	neg	a0
bow3	move	a0,*a8(oxvel),l

	movi	dont_touch,a0
  	movi	->a0000,a1		; initial y vel (upwards)
	movi	angle_grav,a2
	movk	3,a3			; animation speed
 	jsrp	flight_call

	move	a8,a0
	calla	delobjp
	die

;************************************************************************

mk2_design_team
	movk	5,a11
	calla	do_a11_background
	calla	display_off
	sleep	3
	calla	display_on
	movi	>30,a10			; sleep time after fade start
	jsrp	amode_fadein

	create	pid_fx,text_deleter

	movi	mk2_team_table,a11

des3	move	*a11+,a0,l
	cmpi	-1,a0
	jreq	des9

	move	*a11+,a1,w
	move	a1,*a13(p_anirate),w		; sleep time

	move	a0,a0
	jreq	des5

	pushp	a11
	push	a0
	movi	pf_scroll,a8
	calla	lm_setup			; print setup
	pull	a8
	jsrp	printf
	pullp	a11

	movk	1,a0
	move	a0,@f_novel,w
	callr	set_letter_vel
	clr	a0
	move	a0,@f_novel,w

des5	move	*a13(p_anirate),a0,w		; sleep time
	calla	prcslp
	jruc	des3

des9	sleep	>c0
	calla	murder
	jauc	amode_fade_retp



set_letter_vel
	move	@objlst2,a0,l
	jreq	slv9
	move	a0,a3
	clr	a1
	move	a1,@objlst2,l
		
	movi	->10000,a2
scrp4	move	a2,*a0(oyvel),l
	move	*a0(olink),a0,l
	jrne	scrp4

	move	@objlst,a4,l
	jreq	scrp6
scrp5	move	a4,a5
	move	*a4(olink),a4,l
	jrne	scrp5
	move	a3,*a5(olink),l
	jruc	slv9
scrp6	move	a3,@objlst,l
slv9	rets


text_deleter
	sleep	>8
	move	@objlst,a0,l
	jreq	text_deleter
objjd	move	*a0(olink),a2,l		; a2 = next
	move	*a0(oypos),a1,w
	sll	16,a1
	sra	16,a1
;	cmpi	>7fff,a1
	cmpi	-12,a1
	jrgt	objjc
	calla	delobjp			; offscreen ----> delete
objjc	move	a2,a0
	jrne	objjd
	jruc	text_deleter

pf_scroll
	MESS_MAC rd11font,2,scrrgt/2,>F8,bpal_white*>10000,strcnrmos_scr,0
	.BYTE	0
	.EVEN

fl_winner
	.word	bpal_flash1,4
	.word	>ffff
	.word	rgb_blue
	.word	end_stuff

mk2_team_table
	.long	txt_design_intro
	.word	>30

	.long	txt_boon
	.word	>40
	.long	txt_tobias
	.word	>40
	.long	txt_forden
	.word	>40
	.long	txt_goskie
	.word	>40
	.long	txt_vogel
	.word	>80

	.long	txt_exec
	.word	>70

	.long	txt_sheridan
	.word	>80
	.long	txt_hardware
	.word	>80
	.long	txt_dcs
	.word	>60

	.long	txt_speech1
	.word	>30
	.long	txt_speech2
	.word	>60

	.long	txt_runyon
	.word	>40

	.long	txt_thanks
	.word	>2b
	.long	txt_mdp
	.word	>2b
	.long	txt_gnp
	.word	>2b
	.long	txt_sl
	.word	>2b
	.long	txt_wbd
	.word	>2b
	.long	txt_bd
	.word	>2b
	.long	txt_jeff
	.word	>2b
	.long	txt_mjt
	.word	>2b
	.long	txt_sd
	.word	>2b
	.long	txt_jas
	.word	>2b
	.long	txt_pd
	.word	>2b
	.long	txt_rog
	.word	>2b
	.long	txt_buh
	.word	>2b
	.long	txt_bop
	.word	>2b
	.long	txt_sb
	.word	>2b
	.long	txt_pb
	.word	>2b
	.long	txt_mac
	.word	>2b
	.long	txt_lee
	.word	>2b
	.long	txt_jin
	.word	>2b
	.long	txt_net
	.word	>40

	.long	txt_testers
	.word	>20
	.long	txt_kerry
	.word	>20
	.long	txt_eddie
	.word	>20
	.long	-1

txt_design_intro
	.string	"MORTAL KOMBAT II DESIGN TEAM:",0
	.even
txt_boon
	.string	"DESIGN AND SOFTWARE:\nED BOON",0
	.even
txt_tobias
	.string	"DESIGN AND GRAPHICS:\nJOHN TOBIAS",0
	.even
txt_goskie
	.string	"BACKGROUND GRAPHICS:\nTONY GOSKIE",0
	.even
txt_forden
	.string	"SOUNDS AND MUSIC:\nDAN FORDEN",0
	.even
txt_vogel
	.string	"ADDITIONAL GRAPHICS:\nJOHN VOGEL",0
	.even

txt_sheridan
	.string	"SENIOR HARDWARE TECHNICIAN\nSHERIDAN OURSLER",0
	.even

txt_exec
	.string	"EXECUTIVE PRODUCERS\nNEIL NICASTRO\nKEN FEDESNA",0
	.even

txt_runyon
	.string	"SHAO KAHN COSTUME:\nMARK RUNYON",0
	.even


txt_hardware
	.string	"HARDWARE DESIGN:\n"
	.string	"RAY MACIKA\n"
	.string "PAT COX\n"
	.string	"CARY MEDNICK\n"
	.string "RAY GAY\n"
	.string	"AL LASKO"
	.byte	0
	.even

txt_dcs
	.string	"DCS SOUND SYSTEM:\n"
	.string	"MATT BOOTY\n"
	.string	"ED KEENAN\n"
	.string	"JOHN LOWES",0
	.even

txt_speech1
	.string	"SPEECH:\n"
	.string	"STEVE RITCHIE\n"
	.string	"JON HEY",0
	.even

txt_speech2
	.string	"VINCE PONTARELLI\n"
	.string	"DAN (TOASTY) FORDEN\n"
	.string	"ED BOON",0
	.even

txt_thanks
	.string	"SPECIAL THANKS TO:",0
	.even

txt_mdp	.string	"MARK PENACHO",0
	.even
txt_gnp	.string	"GEORGE PETRO",0
	.even
txt_wbd	.string	"WARREN DAVIS",0
	.even
txt_pb	.string	"PAUL BARKER",0
	.even
txt_sl	.string	"SHAWN LIPTAK",0
	.even
txt_mjt	.string	"MARK TURMELL",0
	.even
txt_sd	.string	"SAL DIVITA",0
	.even
txt_pd	.string	"PAUL DUSSAULT",0
	.even
txt_buh	.string	"ERIC KINKEAD",0
	.even
txt_bop	.string	"JAKE SIMPSON",0
	.even
txt_sb	.string	"STEVE BERAN",0
	.even
txt_bd	.string	"BILL DABELSTEIN",0
	.even
txt_rog	.string	"ROGER SHARPE",0
	.even
txt_mac	.string	"JOHN MCCAFFER",0
	.even
txt_jas	.string	"JASON SKILES",0
	.even
txt_lee	.string	"LEE SCHIFF",0
	.even
txt_jin	.string	"JIN IM",0
	.even
txt_net	.string	"THE INTERNET GUYS",0
	.even


txt_testers
	.string	"GAME TESTERS / SPECIALISTS:",0
	.even
txt_kerry
	.string	"KERRY MARZO",0
	.even
txt_eddie
	.string	"EDDIE FERRIER",0
	.even
txt_jeff
	.string	"JEFF JOHNSON",0
	.even


cast_table
	.word	ft_sa,>70
	.word	ft_kang,>120
	.long	txt_rich
	.long	txt_ho

	.word	ft_raiden,>60
	.word	ft_cage,>120
	.long	txt_cp
	.long	txt_dp

	.word	ft_fn1,>70
	.word	ft_hathead,>130
	.long	txt_fn1
	.long	txt_tony

	.word	ft_st,>68
	.word	ft_jax,>130
	.long	txt_phil
	.long	txt_jp

	.word	ft_fn2,>60
	.word	ft_subzero,>120
	.long	txt_fn2
	.long	txt_sz

	.word	ft_reptile,>60
	.word	ft_scorpion,>128
	.long	txt_rp
	.long	txt_sc

	.word	0


pf_left_bow
	mess_mac rd11font,2,scrrgt/4,>20,bpal_yellow*>10000,strcnrmos_scr,0
	.byte	0
	.even

pf_right_bow
	mess_mac rd11font,2,scrrgt/2+scrrgt/4,>20,bpal_yellow*>10000,strcnrmos_scr,0
	.byte	0
	.even

txt_rich	.string	"RICHARD DIVIZIO\nAS\nBARAKA",0
	.even
txt_ho	.string	"HOSUNG PAK\nAS\nLIU KANG",0
	.even
txt_cp	.string	"CARLOS PESINA\nAS\nRAIDEN",0
	.even
txt_dp	.string	"DANIEL PESINA\nAS\nJOHNNY CAGE",0
	.even
txt_sc	.string	"DANIEL PESINA\nAS\nSCORPION",0
	.even
txt_sz	.string	"DANIEL PESINA\nAS\nSUBZERO",0
	.even
txt_rp	.string	"DANIEL PESINA\nAS\nREPTILE",0
	.even
txt_tony	.string	"ANTHONY MARQUEZ\nAS\nKUNG LAO",0
	.even
txt_fn1	.string	"KATALIN ZAMIAR\nAS\nKITANA",0
	.even
txt_fn2	.string	"KATALIN ZAMIAR\nAS\nMILEENA",0
	.even
txt_jp	.string	"JOHN PARRISH\nAS\nJAX",0
	.even
txt_phil	.string	"PHILLIP AHN M.D.\nAS\nSHANG TSUNG",0
	.even
txt_bg	.string	"BRIAN GLYNN\nAS\nSHAO KAHN",0
	.even


**************************************************************************
	.end
