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
	.file	'mktoast.asm'
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
	.include	bgndtbl.glo
	.include	stringh.asm
	.include	diagaudn.asm
	.text

***************************************************************************

noob_check
	calla	count_active_players
	cmpi	2,a0
	jrne	sans_noob		; 2 player game only

	move	@p1_wiar,a1,w
	move	@winner_status,a0,w
	cmpi	1,a0
	jreq	noob3
	move	@p2_wiar,a1,w
noob3	cmpi	50,a1			; XX wins = noob saibot !!!
	jrne	sans_noob

	pull	a0			; return address

	movi	aud_found_noob,a0
	calla	aud1

	calla	loser_in_buyin
	calla	eliminate_buyins
	calla	update_pmsg
*
* flash the bonus symbol !!
*
	move	@objlst2,a0,l
noob2	move	*a0(oid),a1,w
	cmpi	oid_symbol,a1
	jrne	noob4

	calla	nosounds
	movi	>39,a3
	calla	send_code_a3		; start tune

	move	a0,a8
	movk	12,a10
noob1	movi	500,a0
	jsrp	symbol_on_off
	movi	-500,a0
	jsrp	symbol_on_off
	dsj	a10,noob1
	jruc	noob5


noob4	move	*a0(olink),a0,l
	jrne	noob2

noob5	movi	objlst2,a2
	calla	delolist		; erase all text / symbols

	sleep	>30
	
	movi	fl_q,a11
	create	pid_fx,boonpal_stuff	; flash letters
	movi	pf_noob1,a8
	jsrp	lm_printf
	sleep	>40
	movi	pf_noob2,a8
	jsrp	lm_printf
	sleep	>80

	jsrp	white_flash

	movi	p2_char,a1
	move	@winner_status,a0,w
	cmpi	1,a0
	jreq	noob7
	movi	p1_char,a1
noob7	movi	ft_noob,a3
	move	a3,*a1,w		; set noobies ochar

	pushp	a0			; save original winner status
	calla	init_player_variables

noob6	calla	murder_myoinit_score
	calla	update_pmsg

	jsrp	play_1_round
	jsrp	results_of_round
	calla	inc_winners_wiar	; winner = 1 more "win in a row"
	calla	update_win_counters
	movk	1,a0
	move	a0,@f_thatsall,w	; flag: enough fighting already
	jsrp	bonus_count		; print "winner is" msg / retp

	move	@p1_matchw,a0,w
	move	@p2_matchw,a1,w
	movk	2,a2
	calla	double_compare		; anyone won 2 yet ?
	jrne	noob6			; no, play another round

	pullp	a0
	move	a0,@winner_status,w	; restore original winner_status
	movi	ps_active,a0
	move	a0,@p1_state,w
	move	a0,@p2_state,w		; reactivate both human players
	jauc	play9			; back 2 normal game play


sans_noob
	rets


pf_noob1
	mess_mac rd11font,2,scrrgt/2,>40,bpal_flash1*>10000,strcnrmos_scr,0
	.string	"INCREDIBLE WINNING STREAK!!",0
	.even

pf_noob2
	mess_mac rd11font,2,scrrgt/2,>58,bpal_flash1*>10000,strcnrmos_scr,0
	.string	"A NEW WARRIOR AWAITS YOU.",0
	.even


symbol_on_off
	move	*a8(oypos),a1,w
	add	a0,a1
	move	a1,*a8(oypos),w
	sleep	6
	retp

***************************************************************************

jade_check
	move	@map_position,a0,w
	cmpi	10,a0
	jrne	jade_no
	calla	count_active_players
	cmpi	2,a0
	jreq	jade_no

	movi	p1_bar,a0
	movi	l_hp,a1
	movi	l_lp,a2
	movi	l_block,a3
	movi	l_hk,a4
	movi	p1_state,a5
	move	@winner_status,a14,w
	cmpi	1,a14
	jreq	jadc3
	movi	p2_bar,a0
	movi	l_hp+16,a1
	movi	l_lp+16,a2
	movi	l_block+16,a3
	movi	l_hk+16,a4
	movi	p2_state,a5

jadc3	move	*a5,a5,w
	cmpi	ps_active,a5		; winner in the game ?
	jrne	jade_no			; sans

	move	*a1,a1,w
	jrne	jade_no
	move	*a2,a2,w
	jrne	jade_no
	move	*a3,a3,w
	jrne	jade_no
	move	*a4,a4,w
	jrne	jade_no	     		; any of these buttons = sans

	pull	a0

	movi	>0c,a0
	move	a0,@map_position,w

	movi	aud_found_jade,a0
	calla	aud1

	movi	ft_jade,a0
	move	a0,*a13(p_butport),w
	move	@winner_status,a14,w
	dec	a14

	movi	objlst2,a2
	calla	delolist
	jruc	jade_entry

jade_no	rets

;*************************************************************************

toasty_check
	movi	p1_state,a3
	move	a0,a14	    		; save a14 = player offset
	jreq	toast3
	movi	p2_state,a3
toast3	move	*a3,a3,w    		; player state ?
	cmpi	ps_active,a3		; player active in game ?
	jrne	toast_no  		; sans

	move	@gstate,a0,w
	cmpi	gs_fighting,a0
	jrne	toast_no

	move	@curback,a0,w
	cmpi	7,a0
	jrne	toast_no

	move	@toasty,a0,w
	move	@tick,a1,w
	sub	a0,a1
	abs	a1
	cmpi	>40,a1
	jrhi	toast_no		; too much time elapsed

	move	@switch,a0,l
	not	a0
	move	a14,a14
	jreq	toast4
	btst	9,a0
	jrne	toast7
	jruc	toast_no
toast4	btst	1,a0			; down ?
	jreq	toast_no		; sans

toast7	pull	a0

	movi	aud_found_smoke,a0
	calla	aud1

	movi	ft_smoke,a0
	move	a0,*a13(p_butport),w

jade_entry
	move	a14,*a13(p_joyport),w	; save

	movi	pid_master,a0
	move	a0,*a13(procid),w	; declare I am the king !!
	movi	gs_sec_intro,a0
	move	a0,@gstate,w		; new game state
*
* say who got in !!
*
	clr	a0
	move	a0,@p1_perfect,w
	move	a0,@p2_perfect,w

	movk	1,a0
	move	a0,@f_secret,w		; flag: secret chr reached !!!

	movi	pf_p1_wins,a8
	move	a14,a14
	jreq	toast8
	movi	pf_p2_wins,a8
toast8	jsrp	lm_printf

;**********
	clr	a0
	move	a0,@scrolly,l
	calla	stop_scrolling		; stop a scrollin'
;**********

	movk 	1,a0
	move	a0,@f_novel		; dont move
	calla	murder
	movi	fl_q,a11
	create	pid_fx,boonpal_stuff	; flash letters
	calla	nosounds
	sleep	1

	tsound2	>41			; BOOM !!!
	jsrp	white_flash		; poof
	sleep	8
	tsound2	>41			; BOOM !!!
	jsrp	white_flash		; poof
	sleep	8
	tsound2	>41			; BOOM !!!
	jsrp	white_flash		; poof
	sleep	>70

	calla	murder_myoinit_score
	tsound	>d0			; poof sound
	jsrp	white_flash		; poof

	movk	7,a11
	calla	do_a11_background
	calla	nosounds
	sleep	2

	movi	>00030030,a11
	calla	shake_a11
	tsound	>a3
	sleep	>a0
	movi	pid_shaker,a0
	calla	dallprc

	tsound2	>41   			; sound: BOOM !!!
	jsrp	white_flash		; white
*
* growing question mark
*
	movi	mysterybox,a5
	move	*a5(isizex),a11,w
	sll	8,a11			; shift for the formula
	move	*a5(isizey),a10,w
	sll	8,a10			; shift for the formula

	calla	gso_dmawnz_ns
	movi	>008600c6,a4
	calla	set_xy_coordinates
	calla	insobja8

	movi	>03000300,a9
	move	a9,*a8(oscale),l	; start off real small
	callr	center_scaled

grow3	move	a9,*a8(oscale),l	; start off real small
	callr	center_scaled
	sleep	1
	subi	>00200020,a9
	cmpi	>00200020,a9
	jrne	grow3

	movi	>40,a3
	calla	send_code_a3

	mmtm	a12,a9,a10,a11
	jsrp	q_white
	jsrp	q_white
	jsrp	q_white
	mmfm	a12,a9,a10,a11

grow4	move	a9,*a8(oscale),l	; start off real small
	callr	center_scaled
	sleep	1
	addi	>00200020,a9
	cmpi	>03000300,a9
	jrne	grow4

	move	a8,a0
	calla	delobjp
*
* congrats message
*
	movi	fl_q,a11
	create	pid_fx,boonpal_stuff	; flash letters

	movi	14,a0
	movi	>1a,a1
	movi	bpal_flash1,a2		; color
	jsrp	msg_rise
	sleep	>70

	movi	15,a0
	movi	>15,a1			; rise time !!
	movi	bpal_white,a2		; color
	jsrp	msg_rise
	sleep	>110

	movi	objlst,a2
	calla	delolist		; erase text
	sleep	>20

	movi	16,a0
	movi	>1c,a1
	movi	bpal_white,a2		; color
	jsrp	msg_rise
	sleep	>a0

	movi	17,a0
	movi	>10,a1			; rise time !!
	movi	bpal_white,a2		; color
	jsrp	msg_rise
	sleep	>60

	movi	18,a0
	movi	>0b,a1			; rise time !!
	movi	bpal_white,a2		; color
	jsrp	msg_rise
	sleep	>60

	calla	nosounds
	sleep	2
	movi	>21b,a3
	calla	send_code_a3
	calla	fade_all_sky
	sleep	>60
	calla	murder_myoinit_score
	calla	clr_scrn
*
* temporarily eliminate the other player
*
	movi	p2_state,a5
	movi	p2_char,a6
	move	*a13(p_joyport),a0,w
	move	a0,a0
	jreq	toast5
	movi	p1_state,a5
	movi	p1_char,a6

toast5	clr	a1
	move	*a5,a3,w
;	move	a3,*a13(p_store2),w 	; save old state of other player
	move	a1,*a5,w	    	; now you are out (for now)
;	move	a5,*a13(p_store3),l

	mmtm	a12,a3,a5


	clr	a0
	move	a0,@p1_matchw,w
	move	a0,@p2_matchw,w
	move	a0,@round_num,w
	move	a0,@c_three,w

	move	*a13(p_butport),a0,w	; smoke or jade ??
	move	a0,*a6,w		; set ochar for smokey !!		

toast6	calla	murder_myoinit_score

	jsrp	play_1_round
	jsrp	results_of_round
	calla	inc_winners_wiar	; winner = 1 more "win in a row"
	calla	update_win_counters
	movk	1,a0
	move	a0,@f_thatsall,w	; flag: enough fighting already
	jsrp	bonus_count		; print "winner is" msg / retp

	move	@p1_matchw,a0,w
	move	@p2_matchw,a1,w
	movk	2,a2
	calla	double_compare		; anyone won 2 yet ?
	jrne	toast6			; no, play another round
*
* restore player who didn't have any fun !!
*

;	move	*a13(p_store3),a5,l
;	move	*a13(p_store2),a3,w 	; grab old state
	mmtm	a12,a3,a5

	move	a3,*a5,w		; stuff back in

	movi	objlst2,a2
	calla	delolist
	movi	pf_return,a8
	jsrp	lm_printf

	movi	>33,a3
	calla	send_code_a3

	sleep	>80
	calla	murder
	calla	fade_all_sky
	sleep	>40
	movk	8,a0
	move	a0,@curback,w		; next background

	clr	a0
	move	a0,@round_num,w
	jauc	game4

toast_no
	rets


pf_p1_wins
	mess_mac rd15font,2,100,>40,>01010000,strcnrmos_scr,0
	.string	"PLAYER ONE\n"
	.string	"GET READY !!",0
	.even

pf_p2_wins
	mess_mac rd15font,2,300,>40,>01010000,strcnrmos_scr,0
	.string	"PLAYER TWO\n"
	.string	"GET READY !!",0
	.even


pf_return
	mess_mac rd15font,2,scrrgt/2,>40,>01010000,strcnrmos_scr,0
	.string	"NOW, YOU MUST RETURN\n"
	.string	"TO THE OUTWORLD",0
	.even


fl_q	.word	bpal_flash1,4
	.word	>ffff
	.word	rgb_blue
	.word	end_stuff


dlists_only_q
	.long	objlst,worldtlx+16
	.long	0

q_white
	move	@irqskye,a9,w		; save original background color
	movi	>ffff,a0
	move	a0,@irqskye,w		; white

	move	@dlists,a11,l
	movi	dlists_only_q,a0
	move	a0,@dlists,l
	sleep	6
	move	a11,@dlists,l
	move	a9,@irqskye,w		; original background color
	sleep	6
	retp


center_scaled
	move	a11,a1
	move	a9,a3
	zext	a3,w			; only look at x
	divs	a3,a1			; a1 = new scaled x size
	movi	scrrgt/2,a2
	srl	1,a1			; 1/2 of x size
	sub	a1,a2			; center the image on the screen
	move	a2,*a8(oxpos),w

	move	a10,a1
	move	a9,a3
	srl	16,a3			; only look at y
	divs	a3,a1			; a1 = new scaled x size
	movi	scrbot/2,a2
	srl	1,a1			; 1/2 of x size
	sub	a1,a2			; center the image on the screen
	move	a2,*a8(oypos),w

	rets

;************************************************************************

	.end
