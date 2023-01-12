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
	.file	'main.asm'
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
	.include	mkbonus.tbl
	.global	setup
	.text

; dont reset pmap, look for (nrmnrm)
SETUP	jauc	POWERRET	 ; toddview needs this line 'o' code
	.ref	get_aud,clr_aud,coinflag
	.ref	seccall2

force_char
	.if ejbbug
	move	@f_fastrun,a6,w
	jrne	force_it
	rets
force_it
	.else
	rets
	.endif

	movk	1,a0
	move	a0,@p1_char,w
	movk	1,a0
	move	a0,@p2_char,w
	rets


p1_start_button
	clr	a0
	calla	toasty_check

	movi	p1_state,a2		; a2 ---> player state ram
	clr	a4			; a4 = player offset
	jruc	start_entry

p2_start_button
	movk	1,a0
	calla	toasty_check

	movi	p2_state,a2		; a2 ---> player state ram
	movk	1,a4	   		; a4 = player offset

start_entry

	.if ejbbug
	movk	1,a0
	move	a0,@f_fastrun,w		; run fast
	.endif

	movk	1,a0
	move	a0,@f_start_pressed,w	; flag: start button pressed !!
	move	@gstate,a0,w
	sll	5,a0
	addi	start_gstate_jumps,a0
	move	*a0,a0,l
	jump	a0


barge_game_start
	mmtm	a12,a2,a4		; save player info
	move	*a2,a0,w
	cmpi	ps_active,a0		; player already active ?
	jaeq	sucide			; yes, ignore
	calla	cr_strtp		; enough to start ?
	jalo	sucide			; no

	calla	p_start			; yes, take away proper # of credits

;*****************************
	.if ejbbug
	move	@f_fastrun,a6,w
	jrne	skip_barge
	jsrp	barge_in_message
skip_barge
	.else
	jsrp	barge_in_message
	.endif
;*****************************

	calla	clr_scrn
	calla	murder_myoinit

	move	@curback,a0,w
	cmpi	9,a0
	jrne	barge3
	clr	a0
barge3	move	a0,@curback,w		; we were in mk1 ---> get out of it

	move	@p1_state,b0,w
 	move	@p2_state,b1,w
	callr	game_init		; amode ---> reset everything
	move	b0,@p1_state,w
	move	b1,@p2_state,w		; leave pstates alone
	mmfm	a12,a2,a4		; save player info
	jruc	start_a_game


freeze_2_pages
	movk	1,a0
	move	a0,@f_novel,l
	clr	a0
	move	a0,@scrolly,l
	move	a0,@f_auto_erase,w
	calla	stop_scrolling		; no scrolling !!
	sleep	3			; time 4 both pages to show same thing

	calla	display_off
	calla	sync_wait_dma_q		; let dma q empty out
	calla	grab_screen
	retp



gover_game_start
amode_game_start
	calla	cr_strtp			; enough to start ?
	jalo	sucide				; no

	mmtm	sp,a2,a4
	calla	murder_myoinit_score
	calla	display_on
	mmfm	sp,a2,a4

	clr	a0
	move	a0,@c_1p_tries,w

	callr	zero_map_ram
	callr	game_init			; amode ---> reset everything
	movk	1,a0
	move	a0,@battle_num,w		; battle one !!

do_pstate_jump
	move	*a2,a0,w	 		; players current state ?
	move	a0,a1
	sll	5,a0
	addi	start_pstate_jumps,a0
	move	*a0,a0,l
	jump	a0


start_gstate_jumps
	.long	sucide			; 0
	.long	amode_game_start	; 1 - amode
	.long	barge_game_start	; 2 - fighting
	.long	do_pstate_jump		; 3 - buyin
	.long	do_pstate_jump		; 4 - fighter select
	.long	barge_game_start	; 5 - bonus count
	.long	barge_game_start	; 6 - pre-fight setup
	.long	barge_game_start	; 7 - round intro
	.long	sucide			; 8 - diag
	.long	sucide			; 9 - chop sequence
	.long	sucide			; a - enter initials
	.long	gover_game_start	; b - game over start !!
	.long	sucide			; c - octupus
	.long	sucide			; d - post player select fade shit
	.long	sucide			; e -
	.long	sucide			; f - intro effect
	.long	sucide			; 10 -
	.long	sucide			; 11 -

start_pstate_jumps
	.long	start_check		; 0 = not in game
	.long	sucide			; 1 = active
	.long	buyin_check		; 2 = buyin
	.long	auto_select_check	; 3 = player select
	.long	sucide			; 4 = 
	.long	sucide			; 5 = 
	.long	sucide			; 6 = 
	.long	sucide			; 7 = 

start_check
	calla	cr_strtp		; enough to start ?
	jalo	sucide			; no
	calla	p_start			; yes, take away proper # of credits
	jruc	start_a_game

buyin_check
	calla	cr_contp		; enough to continue ?
	jalo	sucide			; no
	calla	p_cont			; yes ---> dec credit count
	jruc	start_a_game


auto_select_check
	movk	1,a5			; p1 up mask
	movk	ft_kang,a6
	movi	pid_p1sel,a0
	cmpi	p1_state,a2		; which player am I ??
	jreq	asc3
	movi	>100,a5			; p2 up mask
	movk	ft_reptile,a6
	movi	pid_p2sel,a0
asc3	clr	a1
	not	a1
	calla	existp			; do I have a cursor proc out there
	jreq	asc9

	move	*a0(pwake),a1,l
	cmpi	psel_cursor_loop,a1	; yes, is it where it should be
	jrne	asc9			; no, sorry no auto shit

	move	*a0(p_store6),a1,l	; p_mychar !!!!
	move	*a1,a1,w		; a1 = my current ochar
	cmp	a1,a6			; on original spot ?
	jrne	asc9			; nope.

	move	@switch,a2,l
	not	a2			; switch bits
	and	a5,a2			; am I pushing joystick up ?
	jreq	asc9			; nope...

	movi	auto_player_select,a7
	calla	fastxfer		; yes ---> auto player select

asc9	die

**************************************************************************
*											     *
*  start_a_game - game start proc							     *
*											     *
**************************************************************************
start_a_game
	movi	pid_master,a0
	move	a0,*a13(procid),w	; i am the master game flow proc

;**************
;	move	*a2,a0,w		; a0 = my current state ?
;	cmpi	ps_active,a0
;	jaeq	sucide			; player already active ---> exit
;	cmpi	ps_psel,a0
;	jaeq	sucide			; player already active ---> exit
;**************

	movi	p1_wiar,a0
	movi	p1_rwon,a1
	movi	p1_state,a2
	move	a4,a4
	jreq	sag3
	movi	p2_wiar,a0
	movi	p2_rwon,a1
	movi	p2_state,a2

sag3	clr	a3
	move	a3,*a0,w		; buyin = clear wins in a row
	move	a3,*a1,w		; buyin = clear total rounds won

	calla	update_pmsg

	move	@gstate,a0,w
	cmpi	gs_psel,a0
	jaeq	join_in_during_psel	; during psel ---> join in

game4	movi	gs_psel,a0
	move	a0,@gstate,w		; game state = player select mode
	movk	ps_psel,a0
	move	a0,*a2,w
	calla	eliminate_buyins

	jsrp	player_select

;*****************************
	.if ejbbug
	move	@f_fastrun,a6,w
	jrne	skip_vs
	jsrp	vs_screen
skip_vs
	.else
	jsrp	vs_screen
	.endif
;*****************************

game_loop
	callr	count_active_players	; a0 = # of active players
	move	a0,a5
	jreq	game_over		; both players gone ---> game over

	callr	audit_game_starts

	cmpi	2,a5
	jreq	play1

	movi	gs_round_intro,a0
	move	a0,@gstate,w		; game state: intro

;*****************************
;	move	@map_position,a0,w
;	cmpi	>0e,a0
;	jrhs	www
;  	movi	>0e,a0
;www	move	a0,@map_position,w
;*****************************

	callr	set_drone_ochar 	; determine drone from current map position

;*****************************
	.if ejbbug
	move	@f_fastrun,a6,w
	jrne	skip_lad
	jsrp	do_ladder
skip_lad
	.else
	jsrp	do_ladder
	.endif
;*****************************

play1	movi	gs_pfsetup,a0
	move	a0,@gstate,w		; game state: pre-fight setup
	calla	murder_myoinit_score

	move	@battle_num,a0,w
	cmpi	pong_battle_num,a0	; time for that special game ?
	jrne	play2			; sans
	callr	count_active_players
	cmpi	2,a0
	jrne	play2			; 2 player game only
	move	@round_num,a0,w
	cmpi	1,a0
	jrne	play2			; pong only on round 1 !!!

	jsrp	pong_intro
	jsrp	play_pong
	calla	murder_myoinit_score

play2	jsrp	play_1_round
play3	jsrp	results_of_round

	move	@p1_matchw,a0,w
	move	@p2_matchw,a1,w
	movk	2,a2
	calla	double_compare		; anyone won 2 yet ?
	jrne	play7			; no ---> bonus count

	callr	inc_winners_wiar	; winner = 1 more "win in a row"
	callr	update_win_counters

	move	@clk_ones,a0,w
	move	@clk_tens,a1,w
	add	a0,a1
	jreq	play7			; timeout round ---> skip FINISH HIM !!

	jsrp	finish_him_sequence	; yes, give him a chance to finish !!

	movk	2,a1
	move	@p1_bar,a0,w
	jreq	play4
	movk	1,a1
play4	move	a1,@winner_status,w	; declare the winner !!

play7	movk	1,a0
	move	a0,@f_thatsall,w	; flag: enough fighting already
	jsrp	bonus_count		; print "winner is" msg / retp

	calla	jade_check
	calla	noob_check

	move	@p1_matchw,a0,w
	move	@p2_matchw,a1,w
	movk	2,a2
	calla	double_compare		; anyone won 2 yet ?
	jrne	play1			; no, play another round

play9	callr	end_of_match_chores
	callr	loser_in_buyin		; loser = buyin state

;*****************
;	movk 	12,a0
;	calla	randu
;	dec	a0
;	move	a0,@p1_char,w
;	movk 	12,a0
;	calla	randu
;	dec	a0
;	move	a0,@p2_char,w
;	jruc	play1
;*****************

	jsrp	check_enter_initials
	jsrp	do_buyin
	jsrp	check_enter_initials	; if loser didn't buyin, check hstd
	jruc	game_loop


**************************************************************************
*											     *
*  play_1_round - Master process routine to play 1 round !!		     *
* 											     *
*  Returns: a11 --> 0 ---> player 1 won the round					*
*                   1 ---> player 2 won the round					*
*                   2 ---> tied									*
*                   3 ---> timeout (clock hit zero)				     *
*											     *
**************************************************************************
play_1_round
	callr	force_char
	callr	round_init

	move	@curback,a11,w
	calla	do_a11_background
	callr	play_background_tune
	calla	update_knotches
	calla	update_pmsg
	callr	update_win_counters
	sleep	1

	create	pid_repell,repell
	create	pid_scroll,scroller
	calla	setup_players
	calla	start_shadows

	movi	gs_round_intro,a0
	callr	set_game_state

;*****************************
	.if ejbbug
	move	@f_fastrun,a6,w
	jrne	skip_rintro
	jsrp	round_intro
skip_rintro
	.else
	jsrp	round_intro
	.endif
;*****************************

	.if ejbbug
	callr	debug_zero_power_bars
	.endif

	movk	1,a0
	move	a0,@f_start,w		; flag: start fighting !!
	callr	if_amode_die

	movi	gs_fighting,a0
	callr	set_game_state
*
* clock countdown
*
	movk	11,a9			; clock speed

	movk	9,a11			; 9 tens
   	movk	9,a10			; 9 ones = 99 seconds
clock3	move	a10,@clk_ones,w
	move	a11,@clk_tens,w

	move	a10,a1
	movi	entry_14,a0
	movi	tg_ones_yx,a5
	callr	update_clock_digit

	cmpi	2,a11
	jrhs	clock5
	tsound	>72			; time down tick
clock5	move	a10,a0
	add	a11,a0			; total digits
	jreq	round_timeout

	move	a9,a8			; reset counter
clock4	sleep	3

	move	@p1_bar,a0,w
	jreq	round_is_over
	move	@p2_bar,a0,w
	jreq	round_is_over		; either bar zero ---> round over !!

	dsjs	a8,clock4
	dec	a10			; dec ones
	jrnn	clock3

	movk	9,a10
	dec	a11
*
* update tens digit image
*
	move	a11,a1
	movi	entry_13,a0
	movi	tg_tens_yx,a5
	callr	update_clock_digit
	jruc	clock3

round_is_over
	move	@p1_bar,a1,w
	move	@p2_bar,a2,w
	cmp	a1,a2			; tie ?
	jreq	round_tied

	movi	p1_matchw,a5
	movk	1,a6
	cmp	a2,a1
	jrhi	p1_won

p2_won	movk	1,a11
	jruc	prend

p1_won	clr 	a11			; 0 = normal ending (somebody won)
	jruc	prend

round_timeout
	clr	a11
	move	a11,@clk_ones,w
	move	a11,@clk_tens,w		; zero clock digits
	movk	3,a11
	jruc	prend

round_tied
	movk	2,a11			; 2 = tie

prend	calla	killfx			; round is over
	callr	weed_out_cheaters	; keep things legit
	retp

**************************************************************************
*											     *
*  results_of_round - Acts on the results of the round based on	     *
* 											     *
*  a11 --> 0 ---> player 1 won the round						     *
*          1 ---> player 2 won the round						     *
*          2 ---> tied									     *
*          3 ---> timeout (clock hit zero)						     *
*											     *
**************************************************************************
results_of_round
	move	a11,a0
	sll	5,a0
	addi	round_results_tab,a0
	move	*a0,a0,l
	jump	a0

round_results_tab
	.long	player_1_won		; 0 - player 1 won
	.long	player_2_won		; 1 - player 2 won
	.long	its_a_tie		; 2 - tie
	.long	clock_ran_out		; 3 - timeout

player_1_won
	movk	1,a1
	move	a1,@winner_status,w	; winner status = player 1

	movi	p1_matchw,a0
	callr	local_inc_a0_word	; add to his match wins
	movi	p1_rwon,a0
	callr	local_inc_a0_word	; add to his total rounds won
	jruc	results_retp

player_2_won
	movk	2,a1
	move	a1,@winner_status,w	; winner status = player 2

	movi	p2_matchw,a0
	callr	local_inc_a0_word	; add to his match wins
	movi	p2_rwon,a0
	callr	local_inc_a0_word	; add to his total rounds won
	jruc	results_retp

its_a_tie
	retp

clock_ran_out
	movk	1,a0
	move	a0,@f_thatsall,w	; flag: enough fighting already
	jsrp	print_timeout_msg
	movi	play3,a0
	pushp	a0			; fake a return address
	jruc	round_is_over		; walk through results again

results_retp
	calla	update_knotches

	move	@p1_matchw,a2,w
	move	@p2_char,a1,w
	move	@winner_status,a0,w
	cmpi	1,a0
	jreq	res4
	move	@p1_char,a1,w
	move	@p2_matchw,a2,w

res4	cmpi	2,a2			; 2 wins ?
	jrne	res5			; nope
	cmpi	ft_final_boss,a1
	jreq	game_finished
res5	retp

game_finished
	movi	gs_gameover,a0
	move	a0,@gstate,w		; game start = over !!

	movi	aud_finish,a0
	calla	aud1			; audit this event !!

	jsrp	boss_die_sequence
	jsrp	kahn_explode
	jsrp	congrats
	jsrp	mk2_team_photos
	jsrp	show_rev_x
	jruc	ending_gover_entry

pf_entered
	mess_mac rd15font,2,scrrgt/2,>40,>01010000,strcnrmos_scr,0
	.byte	0
	.even

txt_p1_entered
	.string	"PLAYER ONE HAS ENTERED\nTHE TOURNAMENT !",0

txt_p2_entered
	.string	"PLAYER TWO HAS ENTERED\nTHE TOURNAMENT !",0


print_round_number
	move	@round_num,a0,w
	cmpi	4,a0
	jrhi	prn3

	addi	>17,a0
	calla	triple_sound2		; speech: ROUND #

prn3	movi	pf_round_num,a8
	jsrp	lm_printf
	sleep	>30
	movi	oid_text,a0
	calla	dallobj			; erase "round #" text
	retp

**************************************************************************
*											     *
*  who_is_next - returns a0 = next drone entry in map			     *
*											     *
**************************************************************************
who_is_next
	callr	who_is_alone

	move	@map_position,a3,w
	move	@map_start,a0,l
	inc	a3
	sll	4,a3
	add	a3,a0
	move	*a0,a0,w		; next opponent ?

	rets

**************************************************************************
*											     *
*  check_enter_initials - check if its time to enter initials, if so     *
*                         setup variables and call the routine		     *
*											     *
**************************************************************************
check_enter_initials
	move	@p1_state,a0,w
	move	@p2_state,a1,w
	move	a1,a5
	add	a0,a5
	jreq	sans_enter_initials	; nobody playing anymore = no initials

	move	@p1_state,a0,w
	cmpi	ps_active,a0
	jrne	cei7			; p1 not active ---> check
	move	@p2_state,a0,w
	cmpi	ps_buyin,a0		; im in / he's buyin ---->  skip
	jreq	cei8

cei7	move	@p1_wiar,a0,w
	calla	does_a0_cut_it		; p1 = enough wins to cut the mustard ?
	jrc	cei1

cei8	move	@p2_state,a0,w
	cmpi	ps_active,a0
	jrne	cei9			; p2 not active ---> check
	move	@p1_state,a0,w
	cmpi	ps_buyin,a0
	jreq	sans_enter_initials	; im in / he's buyin ---->  skip

cei9	move	@p2_wiar,a0,w
	calla	does_a0_cut_it		; p2 = enough wins to cut the mustard ?
	jrnc	sans_enter_initials	; no, exit
*
* player 2 enter your initials
*
	movk	1,a7
	move	@p2_wiar,a6,w
	jruc	cei2
*
* player 1 enter your initials
*
cei1	clr	a7
	move	@p1_wiar,a6,w

cei2  	move	a7,*a13(p_flags),w	; save player offset here
	move	a6,*a13(p_anitab),l
	jauc	enter_initials

sans_enter_initials
	retp

**************************************************************************
*											     *
*  is_finish_him_allowed - looks at the game situation an answers with   *
* 											     *
*  carry set = yes, run the finish him sequence					     *
*      clear = no, skip finish him							     *
*											     *
**************************************************************************
is_finish_him_allowed
	move	@p2_char,a2,w
	movi	ft_goro,a0
	movi	ft_final_boss,a1
	calla	double_compare
	jreq	fhimno			; either player a boss ---> no finish

	move	@p1_char,a2,w
	movi	ft_goro,a0
	movi	ft_final_boss,a1
	calla	double_compare
	jreq	fhimno			; either player a boss ---> no finish

	move	@clk_ones,a0,w
	move	@clk_tens,a1,w
	add	a0,a1
	jreq	fhimno			; no time left ---> no finish him

	setc				; everything else is just a light
	rets

fhimno	clrc
	rets

**************************************************************************
*											     *
*                MASTER CONTROL PROCESS ROUTINES				     *
*                MASTER CONTROL PROCESS ROUTINES				     *
*                MASTER CONTROL PROCESS ROUTINES				     *
*                MASTER CONTROL PROCESS ROUTINES				     *
*											     *
**************************************************************************

set_game_state
	move	@gstate,a1,w
	cmpi	gs_amode,a1
	jreq	sgs9			; amode = dont change game state
	move	a0,@gstate,w		; game state
sgs9	rets


barge_in_message
	movi	gs_barge,a0
	move	a0,@gstate,w		; game state = barge !

	movk	1,a0
	move	a0,@f_timeout,w		; flag: this round was timedout
	calla	murder

	jsrp	freeze_2_pages
	calla	display_on

	movi	>33,a3
	calla	send_code_a3		; Mortal Sans !!

	movi	txt_p1_entered,a14
	move	@p1_state,a0,w
	jreq	enter4
	movi	txt_p2_entered,a14
enter4	movi	pf_entered,a8
	calla	lm_setup
	move	a14,a8
	jsrp	printf

	movi	bpal_red,a0
	movi	>00400122,a3		; size
	calla	make_solid_object
	calla	set_noscroll
	movi	>00360038,a4	  	; coordinate
	calla	set_xy_coordinates
	movk	1,a0
	move	a0,*a8(ozpos),w
	calla	insobja8

	movi	bpal_yellow,a0
	movi	>00440126,a3		; size
	calla	make_solid_object
	calla	set_noscroll
	movi	>00340036,a4	  	; coordinate
	calla	set_xy_coordinates
	clr	a0
	move	a0,*a8(ozpos),w
	calla	insobja8

	movi	fl_entered,a11
	create	pid_fx,boonpal_stuff	; flash letters
	move	a0,a11
	movi	sans_boonpal,a0
	calla	join_in_fade1

	sleep	>32

	move	a11,a0
	calla	kill			; stop flasher shit

	sleep	>40
	calla	murder_myoinit_score
	calla	clr_scrn

;	calla	murder
;	movi	all_palettes,a0
;	calla	join_in_fade2
;	movi	>1000,a9
;	create	pid_fade,skydown
	retp


round_intro
	create	pid_fx,fx_charge_bars

	callr	is_final_boss_playing
	jreq	round_intro_with_kahn

	move	@gstate,a0,w
	cmpi	gs_amode,a0
	jreq	rint4	     		; amode = skip this

	movi	aud_clue,a0    		; a0 = audit to use
	movi	1000,a2	     		; a2 = max number
	calla	audit_event_check	; time 4 a clue ?
	jrnc	rint4		 	; sans
	jsrp	clue_giveaway		; yes, give one away

rint4
	move	@gstate,a0,w
	cmpi	gs_amode,a0
	jreq	rint5	     		; amode = skip this
	move	@f_sans_throws,a0,w	; are throws disabled
	jreq	rint5			; no
	create	pid_fx,no_throw_msg

rint5	jsrp	print_round_number
	create	pid_grow,grow_msg
	movi	>17,a1
	move	a1,*a0(pa8),l		; pass sound call
	clr	a1
	move	a1,*a0(pa10),l		; pass offset to fx
	sleep	>30
	retp

round_intro_with_kahn
	movi	pf_round_num,a8
	jsrp	lm_printf
	sleep	>60
	movi	oid_text,a0
	calla	dallobj			; erase "round #" text
	sleep	>10
	retp


clue_giveaway
	calla	nosounds
	sleep	1
	movi	>34,a3
	calla	send_code_a3   		; fade sound

	sleep	>20
	move	@ofree,a8,l		; get future object

	tsound	>68
	create	pid_fx,baby_flash
	create	pid_fx,baby_poof
	move	a8,*a0(pa10),l

	movi	smoke_info,a9
	movi	ft_smoke,a10
	movi	smoke_clues,a11

	move	@rand,a1,l
	jrn	clueg4
	movi	jade_info,a9
	movi	ft_jade,a10
	movi	jade_clues,a11

clueg4	calla	gmo_proc
	move	a0,*a8(oslink),l	; oslink = proc
	move	a10,*a8(ochar),w

	calla	ground_ochar
	move	@worldtlx+16,a0,w
	addi	scrrgt/2,a0
	move	a0,*a8(oxpos),w

	calla	insobja8
	movi	>29,a9
	calla	get_char_ani
	movk	4,a0
	jsrp	mframew			; victory pose !!

	pushp	a8
	movk	10,a0
	calla	randu
	dec	a0
	sll	5,a0
	add	a11,a0
	move	*a0,a8,l
	pushp	a8
	movi	pf_clues,a8
	calla	lm_setup
	pullp	a8
	jsrp	printf
	pullp	a8

	sleep	>90			; time 2 read the cloo !!
	movi	oid_text,a0
	calla	dallobj
	sleep	>20

	tsound	>68
	create	pid_fx,baby_flash
	create	pid_fx,baby_poof
	move	a8,*a0(pa10),l
	sleep	10

	move	*a8(oslink),a0,l
	calla	kill			; kill "data storage" process
	move	a8,a0
	calla	delobjp
	callr	play_background_tune

	sleep	>30
	retp


;*****************************************************************

no_throw_msg
	movi	fl_winner,a11
	create	pid_fx,boonpal_stuff		; flash letters
	movi	pf_no_throw,a8
	jsrp	lm_printf
	die

pf_no_throw
	mess_mac rd11font,2,200,>30,bpal_flash1*>10000,strcnrmos_scr,0
	.string	"THROWING DISABLED",0
	.even

;*****************************************************************


pf_clues
	mess_mac rd11font,2,200,>38,bpal_hot_green*>10000,strcnrmos_scr,0
	.byte	0
	.even

smoke_clues
	.long	txt_sm1
	.long	txt_sm2
	.long	txt_sm3
	.long	txt_sm4
	.long	txt_sm5
	.long	txt_sm6
	.long	txt_sm7
	.long	txt_sm8
	.long	txt_sm9
	.long	txt_sm10


txt_sm1	.string	"I AM CALLED SMOKE",0
	.even
txt_sm2	.string	"TOASTY",0
	.even
txt_sm3	.string	"YOU CAN START FINDING ME",0
	.even
txt_sm4	.string	"ERMAC WHO?",0
	.even
txt_sm5	.string	"YOU CAN NOT DEFEAT ME",0
	.even
txt_sm6	.string	"I AM ONE OF THREE",0
	.even
txt_sm7	.string	"PORTAL",0
	.even
txt_sm8	.string	"I WILL MEET YOU IN GORO'S LAIR",0
	.even
txt_sm9	.string	"MORTAL KOMBAT ONE",0
	.even
txt_sm10	.string	"PROVE YOURSELF",0
	.even


jade_clues
	.long	txt_jd1
	.long	txt_jd2
	.long	txt_jd3
	.long	txt_jd4
	.long	txt_jd5
	.long	txt_jd6
	.long	txt_jd7
	.long	txt_jd8
	.long	txt_jd9
	.long	txt_jd10

txt_jd1	.string	"I AM CALLED JADE",0
	.even
txt_jd2	.string	"BEFORE THE ?",0
	.even
txt_jd3	.string	"ERMAC WHO?",0
	.even
txt_jd4	.string	"I WILL MEET YOU IN GORO'S LAIR",0
	.even
txt_jd5	.string	"CHUN WHO?",0
	.even
txt_jd6	.string	"I AM ONE OF THREE",0
	.even
txt_jd7	.string	"RESTRICT YOURSELF",0
	.even
txt_jd8	.string	"ALONE IS HOW YOU WILL FIND ME",0
	.even
txt_jd9	.string	"ONE DAY WE WILL FIGHT !",0
	.even
txt_jd10	.string	"BRING ON KANO AND SONYA !",0
	.even

**************************************************************************
*											     *
*  weed_out_cheaters - Jump to GAME OVER if:					     *
* 											     *
*  a. Both players are at full strength						     *
*  b. 5th or later round									     *
*											     *
**************************************************************************
weed_out_cheaters
	move	@p1_bar,a0,w
	move	@p2_bar,a1,w
	add	a1,a0
	cmpi	full_strength*2,a0	; both players at full strength ??
	jreq	weed6			; yes, no cheating the game kids !
	move	@round_num,a0,w
	cmpi	5,a0
	jrhs	weed6			; no more than 2 ties allowed
	rets

weed6	pull	a0			; no return
	calla	reset_proc_stack
	jruc	game_over

**************************************************************************
*											     *
*  count_active_players - Returns a0 = # of active players		     *
*											     *
**************************************************************************
count_active_players
	clr	a0			; start with zero
	move	@p1_state,a1,w
	callr	cap5
	move	@p2_state,a1,w
cap5	cmpi	ps_active,a1		; in ?
	jrne	cap7			; no
	inc	a0			; yes, count him
cap7	rets


loser_in_buyin
	movi	p2_state,a11
	move	@winner_status,a2,w	; winner is...
	cmpi	1,a2			; player 1 ??
	jreq	lib3			; yes, player 2 must buyin
	movi	p1_state,a11

lib3	move	*a11,a0,w
	cmpi	ps_active,a0		; loser a human ?
	jrne	lib7			; no

	movi	ps_buyin,a0
	move	a0,*a11,w		; loser = human --> he is in buyin mode

lib7	rets

**************************************************************************
*											     *
*  print_timeout_msg - When a round times out we call this to interupt   *
*                      things and print "TIMES UP" msg			     *
*											     *
**************************************************************************
print_timeout_msg
	clr	a3
	calla	send_code_a3		; stop music
	movi	>21b,a3
	calla	send_code_a3		; gong !!

	movk	1,a0
	move	a0,@f_novel,l
	move	a0,@f_timeout,w		; flag: this round was timedout
	clr	a0
	move	a0,@scrolly,l
	calla	stop_scrolling		; no scrolling !!
	calla	murder

	movi	pf_times_up,a8
	jsrp	lm_printf
	
	movi	fl_finish,a11
	create	pid_fx,boonpal_stuff	; flash letters

rto6	sleep	>50
	movi	oid_fx,a0
	calla	dallobj			; erase text
	retp

**************************************************************************
*											     *
*  finish_him_sequence - Handle things for FINISH HIM			     *
*											     *
**************************************************************************
finish_him_sequence
	move	@p2_char,a0,w
	move	@p1_char,a1,w
	movi	ft_goro,a2
	calla	double_compare
	jreq	finish_him_exit
	movi	ft_final_boss,a2
	calla	double_compare
	jreq	finish_him_exit		; boss = no finish him !!
	movi	ft_smoke,a2
	calla	double_compare
	jreq	finish_him_exit
	movi	ft_jade,a2
	calla	double_compare
	jreq	finish_him_exit
	movi	ft_noob,a2
	calla	double_compare
	jreq	finish_him_exit

	movk	3,a0
	move	a0,@winner_status,w	; flag: finish him mode

	callr	finish_him_or_her

	movi	>28,a11
	jsrp	fatality_wait
	move	@f_thatsall,a0,w	; over ?
	jrne	finish_him_exit		; yes

	move	@curback,a3,w
	sll	4,a3
	addi	finish_tunes,a3
	move	*a3,a3,w
	calla	send_code_a3		; send proper "finish him" tune

	movi	>80,a11
	jsrp	fatality_wait

	move	@p1_proc,a0,l
	move	*a0(p_action),a0,w
	move	@p2_proc,a1,l
	move	*a1(p_action),a1,w

	movi	act_super_froze,a2
	calla	double_compare	  	; more time needed for superfreeze ?
	jrne	fhs2			; no
	movi	>40,a11
	jsrp	fatality_wait		; yes, one more second

fhs2	move	a11,a11
	jreq	finish_him_exit
*
* fatality started !!!
*
	movi	>40*8,a11
fhs3	sleep	1

wait_fatality_finish
	move	@f_death,a0,w
	cmpi	-1,a0			; death blow complete ??
	jreq	finish_him_exit		; yes
	dsj	a11,fhs3		; no, keep waiting

finish_him_exit
	retp

**************************************************************************
*											     *
*  fatality_wait - wait around for the FATALITY to start			     *
* 											     *
*    Input: a11 = max time i will wait						     *
* 											     *
*  Returns: a11 = 0 ---> timed out							     *
*           a11 > 0 ---> fatality started						     *
*											     *
**************************************************************************
fatality_wait
	sleep	1

fatality_waiting
	move	@f_death,a0,w		; death blow ?
	jrne	fatal_yes
	move	@f_thatsall,a0,w
	jrne	fatal_no		; thats all !!
	dsj	a11,fatality_wait
fatal_no
	clr	a11
fatal_yes
	retp

**************************************************************************
*											     *
*  play_background_tune - look at curback and play the current backgroun *
*                         tune.								     *
*											     *
**************************************************************************
play_background_tune
	movi	round_1_tunes,a1
	move	@round_num,a0,w
	cmpi	1,a0			; round 1 ??
	jreq	pbt3
	movi	round_23_tunes,a1
pbt3	move	@curback,a11,w		; a11 = current background counter
	move	a11,a0
	sll	4,a0
	add	a1,a0
	move	*a0,a3,w
	jauc	send_code_a3		; play this background's tune

round_1_tunes
	.word	>15	; 0 - dead pool
	.word	>19	; 1 - tomb
	.word	>01	; 2 - battlefield
	.word	>0d	; 3 - tower
	.word	>05	; 4 - forest
	.word	>09	; 5 - armory
	.word	>01	; 6 - bridge (the pit II) burning guy
	.word	>11	; 7 
	.word	>11	; 8 
	.word	>42	; 9 - mk1 cave

round_23_tunes
	.word	>16	; 0 - dead pool
	.word	>1a	; 1 - tomb
	.word	>02	; 2 - battlefield
	.word	>0e	; 3 - tower
	.word	>06	; 4 - forest
	.word	>0a	; 5 - armory
	.word	>02	; 6 - bridge
	.word	>12	; 7 
	.word	>12	; 8 
	.word	>42	; 9 - mk1 cave

finish_tunes
	.word	>17	; 0
	.word	>1b	; 1
	.word	>03	; 2
	.word	>0f	; 3
	.word	>07	; 4
	.word	>0b	; 5 - armory
	.word	>03	; 6
	.word	>13	; 7
	.word	>13	; 8
	.word	>07	; 9 - mk1 cave

winner_tunes
	.word	>18	; 0
	.word	>1c	; 1
	.word	>04	; 2
	.word	>10	; 3
	.word	>08	; 4
	.word	>0c	; 5 - armory
	.word	>04	; 6
	.word	>14	; 7
	.word	>14	; 8
	.word	>08	; 9

***************************************************************************

corpse_this_proc
	calla	exprc_er		; find the proc
	move	*a0(p_flags),a4,w
	ori	pm_corpse,a4
	move	a4,*a0(p_flags),w	; flag: i am one dead corpse
	move	a0,a5			; a5 = proc of corpse
	rets

**************************************************************************
*											     *
*  who_is_alone - answers the question with					     *
* 											     *
*  a0 = 1 ---> player 1 is the only human						     *
*       2 ---> player 2 is the only human						     *
* 											     *
**************************************************************************
who_is_alone
	move	@p1_state,a1,w
	move	@p2_state,a2,w

	cmpi	ps_active,a1
	jreq	p1_alone
	cmpi	ps_active,a2
	jreq	p2_alone

p1_alone
	cmpi	ps_active,a2		; is player 2 also in the game ?
	jreq	who_is_alone_error	; yes, something is wrong here
	movk	1,a0
	rets

p2_alone
	cmpi	ps_active,a1		; is player 1 also in the game ?
	jreq	who_is_alone_error	; yes, something is wrong here
	movk	2,a0
	rets

who_is_alone_error
	ermac	1


game_over
	movi	gs_gameover,a0
	move	a0,@gstate,w		; game state = game over

	movi	2,a3
	calla	send_code_a3		; start the grizzly tune

	calla	dont_show_scores
	clr	a0
	move	a0,@p1_state,w
	move	a0,@p2_state,w		; take players out of the game

	calla	murder			; i am the only proc in town
	calla	grab_screen

	calla	fade_all_sky
	sleep	30			; fade to black
	calla	murder			; stop skyfade

ending_gover_entry
	movk	2,a11
	movi	pf_gameover,a8

	movi	20,a0
	calla	randper
	jrnc	gover2

	movk	9,a11
	movi	pf_gameover2,a8

gover2	pushp	a11
	calla	clr_scrn
	calla	murder_myoinit_score

	calla	do_a11_background	; do the pit background !!
	movi	fl_finish,a11
	create	pid_fx,boonpal_stuff	; flash letters
	jsrp	lm_printf
	pullp	a11
	cmpi	9,a11
	jrne	gover3

	movi	big3,a5
	calla	gso_dmawnz_ns
	movi	>60,a0
	move	a0,*a8(oypos),w
	calla	center_obj_x
	calla	insobja8

gover3

;***************
	calla	clear_units
;*************** fixed for france

	movi	>40*6,a10		; pause after fade
	jsrp	amode_fadein

	calla	murder
	jauc	gover_amode_entry

**************************************************************************

bonus_count
	movi	gs_bonus,a0
	move	a0,@gstate,w		; game state = bonus count !!

	movi	pid_danger1,a0
	calla	dallobj
	calla	dallprc
	movi	pid_danger2,a0
	calla	dallobj
	calla	dallprc

	movi	pid_fx,a0
	calla	dallprc
	movi	oid_fx,a0
	calla	dallobj
	movi	oid_text,a0
	calla	dallobj			; avoid conflict with double-ice backfire text

	move	@p1_bar,a0,w
	move	@p2_bar,a1,w
	cmp	a0,a1
	jreq	bonus_count_draw
	
	callr	get_winner_text		; a8 = winner text
	jsrp	lm_printf	

	movi	objlst2,a0
	movi	oid_text,a1		; from 
	movi	oid_fx,a2		; to
	calla	change_oid_list		; change oid of PLAYER WINS text

	movi	fl_winner,a11
	create	pid_fx,boonpal_stuff	; flash letters
	move	a0,a11

**************************************************************************
*											     *
*  handle tunes/speech									     *
*											     *
**************************************************************************

	move	@f_death,a0,w
	cmpi	-1,a0
	jreq	skip_ending_chord	; death blow = let gloom linger

	move	@curback,a3,w
	sll	4,a3
	addi	winner_tunes,a3
	move	*a3,a3,w
	calla	send_code_a3		; send correct ending tune

skip_ending_chord
	sleep	>28
	callr	is_final_boss_playing
	jreq	pwt2

	callr	get_winner_ochar	; a0 = winner ochar
	move	a0,a9
	sll	4,a0
	addi	winner_speech,a0
	move	*a0,a0,w
	jreq	pwt2
	calla	triple_sound2		; "Whoever Wins"

pwt2	callr	flawless_tone_start

	sleep	>10
	cmpi	ft_goro,a9
	jrne	pwt3
	tsound	>b3			; kintaro wins = crowd likes it !!
pwt3	sleep	>10


pwt4	sleep	>12
	move	a11,a0
	calla	kill			; stop flashing "????? wins"

	move	@p1_state,a0,w
	move	@winner_status,a1,w
	cmpi	1,a1
	jreq	dchk4
	move	@p2_state,a0,w
dchk4	cmpi	ps_active,a0		; winner a human ?
	jrne	win6			; winner = drone ---> no bonus count

**************************************************************************
*											     *
*   total wins										     *
*											     *
**************************************************************************

	move	@p1_rwon,a10,w
	move	@winner_status,a7,w
	dec	a7			; a7 = player to give score to
	jreq	twin3
	move	@p2_rwon,a10,w
twin3	clr	a8			; no text for wins
	movi	>00500050,a4		; a4 = coordinates
	movk	2,a5			; x spacing
	clr	a8
	movi	wins_symbols,a9
	jsrp	bonus_symbols

**************************************************************************
*											     *
*  flawless victory ?									     *
*											     *
**************************************************************************

	move	@p1_bar,a3,w
	movi	p1_perfect,a4		; a4 = winners perfect
	movi	p2_perfect,a5		; a5 = losers perfect

	move	@winner_status,a0,w
	cmpi	1,a0
	jreq	win4

	move	@p2_bar,a3,w		; grab winners strength bar
	movi	p2_perfect,a4		; a4 = winners perfect
	movi	p1_perfect,a5		; a5 = losers perfect

win4	clr	a0
	not	a0
	move	a0,*a5,w		; loser = no chance for double perfect
	cmpi	full_strength,a3	; perfection ?
	jrne	win6			; no ---> say la vee

	push	a4
	movi	>4d,a0
	pull	a4			; a4 = pointer to "flawless" ram
	move	*a4,a0,w		; was the last round perfect too ?
	jreq	win5			; no
	jrn	win5			; neg = blew his chance for double !!

;******************* gninja
	movk	2,a0
	move	a0,*a4,w		; flag: double flawless !!
;******************* gninja

	movi	pf_double_perfect,a8
	jruc	win51

win5	movk	1,a0
	move	a0,*a4,w		; flag: perfect round
	movi	pf_single_perfect,a8

win51	sleep	>30			; dont interupt: "Xxxxx Wins" speech
	jsrp	lm_printf
	movi	fl_flawless,a11
	create	pid_fx,boonpal_stuff	; flash letters

	callr	is_final_boss_playing
	jreq	win6

	tsound2	>28			; speech: flawless victory
	sleep	>40

**************************************************************************
*											     *
*   fatality ?										     *
*											     *
**************************************************************************

win6	move	@f_death,a0,w
	jreq	bonus_exit

	sleep	>40

	movi	oid_text,a0	
	calla	dallobj
	movi	oid_symbol,a0	
	calla	dallobj			; get rid of bs

	move	@f_death2,a0,w
	jreq	win7
	cmpi	2,a0
	jrne	win61
	calla	start_bounce

	tsound2	>58
	sleep	>3a
	tsound2	>59
	jruc	bonus_exit

win61	tsound2	>37
	movi	pf_change,a8
	jsrp	lm_printf
	jruc	bonus_exit

win7	tsound2	>16			; speech: fatality
	movk	>0d,a0
	calla	create_blood_proc
	sleep	>30

bonus_exit
	sleep	>60
	retp

bonus_count_draw
	movi	pf_tie,a8
	jsrp	lm_printf
	jruc	bonus_exit

**************************************************************************
*											     *
*  bonus_symbols - generic "bonus symbol" routine to show you those kute *
*                  lil medals 'n' stuff during bonus count		     *
* 											     *
*  Input: a4 = desired [y,x] coordinates						     *
*         a5 = x spacing										*
*         a8 = text to print up								     *
*         a9 = table of images for "ones/tens/fifties"			     *
*        a10 = # to represent								     *
*											     *
**************************************************************************
bonus_symbols
	move	a10,a10
	jreq	bons9				; no symbols ---> exit

	move	@ofree,a11,l			; a11 = next object we grab
	move	a11,*a13(p_store7),l
	clr	a0
	move	a0,*a13(p_store8),l		; total image length

	movk	8,a0
	move	a0,*a13(p_store5),w		; total # symbol allowed
	move	a5,*a13(p_store6),w		; x spacing
	move	a4,*a13(p_store4),l		; save starting coordinates
	move	a9,*a13(p_store2),l

	move	a10,a1
	movi	50,a3
	divs	a3,a1				; a1 = fifties
	jreq	bons3				; yea right

	move	a1,a0
	movi	50,a5
	mpys	a5,a1	
	sub	a1,a10				; subtract 50's from total
	move	*a9(32*2),a5,l
	callr	show_a0_symbols

bons3	move	a10,a1
	jreq	bons5
	movk	10,a3
	divs	a3,a1				; a1 = tens
	jreq	bons5				; yea right

	move	a1,a0
	movk	10,a5
	mpys	a5,a1	
	sub	a1,a10				; subtract 10's from total
	move	*a9(32*1),a5,l
	callr	show_a0_symbols

bons5	move	a10,a0				; remaining ones !!
	jreq	bons7				; none

	move	*a9,a5,l
	callr	show_a0_symbols

*
* center the bonus symbols in "x"
*
bons7	clr	a0
	move	a0,*a8(oslink),l		; last image ---> null

	move	*a13(p_store8),a0,w		; a0 = total images length
	srl	1,a0
	movi	scrrgt/2,a10
	sub	a0,a10				; a10 = leftmost x
	move	*a13(p_store7),a8,l		; a8 = 1st image

bons8	move	a10,*a8(oxpos),w
	calla	insobj2a8
	sleep	6
	move	*a8(osizex),a0,w
	move	*a13(p_store6),a1,w
	add	a0,a10
	add	a1,a10				; move right 1 position
	move	*a8(oslink),a8,l
	jrne	bons8

bons9	retp

;******************************************************************

show_a0_symbols
	move	a0,*a13(p_anicount),w	; counter
	move	*a13(p_store5),a0,w
	jreq	sas9
	dec	a0
	move	a0,*a13(p_store5),w		; count this

	push	a5
	calla	gso_dmawnz_ns
	pull	a5

	movi	oid_symbol,a4
	move	a4,*a8(oid),w			; give specific oid

	move	*a13(p_store4),a4,l
	calla	set_xy_coordinates
	move	a8,*a11(oslink),l		; link to previous bonus symbol
	move	a8,a11				; new previous
*
* x spacing
*
	move	*a13(p_store4),a4,l
	move	*a8(osizex),a0,w
	add	a0,a4
	move	*a13(p_store6),a1,w		; plus our xtra nudge
	add	a1,a4
	move	a4,*a13(p_store4),l		; move one position to the right

	move	*a13(p_store8),a3,w
	add	a0,a3
	add	a1,a3
	move	a3,*a13(p_store8),w		; add to total images length

	move	*a13(p_anicount),a0,w
	dec	a0
	jrne	show_a0_symbols

sas9	rets


wins_symbols
	.long	BC_WIN1
	.long	BC_WIN2
	.long	BC_WIN3

winner_text
	.long	pf_hh_win		; 0
	.long	pf_lk_win		; 1
	.long	pf_jc_win		; 2
	.long	pf_sa_win		; 3
	.long	pf_fn1_win		; 4
	.long	pf_fn2_win		; 5
	.long	pf_st_win		; 6
	.long	pf_rd_win		; 7
	.long	pf_sz_win		; 8
	.long	pf_rp_win		; 9
	.long	pf_sc_win		; a
	.long	pf_jx_win		; b

	.long	pf_goro_win		; c
	.long	pf_kahn_win		; d

	.long	pf_sm_win		; e
	.long	pf_new_win		; 10
	.long	pf_jd_win		; f



winner_speech
	.word	>06
	.word	>07
	.word	>08
	.word	>09
	.word	>0a
	.word	>0b
	.word	>0c
	.word	>0d
	.word	>0e
	.word	>0f
	.word	>10
	.word	>11

	.word	>35	; kintaro wins
	.word	>00

	.word	>12
	.word	>5a
	.word	>13

pf_times_up
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"TIME IS UP",0
	.even

pf_tie
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"DRAW",0
	.even


pf_hh_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"KUNG LAO WINS",0
	.even

pf_lk_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"LIU KANG WINS",0
	.even

pf_jc_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"CAGE WINS",0
	.even

pf_sa_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"BARAKA WINS",0
	.even

pf_fn1_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"KITANA WINS",0
	.even

pf_fn2_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"MILEENA WINS",0
	.even

pf_st_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"SHANG TSUNG WINS",0
	.even

pf_rd_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"RAIDEN WINS",0
	.even

pf_sz_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"SUB-ZERO WINS",0
	.even

pf_rp_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"REPTILE WINS",0
	.even

pf_sc_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"SCORPION WINS",0
	.even

pf_jx_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"JAX WINS",0
	.even

pf_goro_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"KINTARO WINS",0
	.even

pf_kahn_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"SHAO KAHN WINS",0
	.even

pf_sm_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"SMOKE WINS",0
	.even

pf_jd_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"JADE WINS",0
	.even

pf_new_win
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"NOOB SAIBOT WINS",0
	.even

pf_gameover
	mess_mac rd15font,2,>90,>60,>01010000,strlnrmos_scr,0
	.byte	"GAME OVER",0
	.even

pf_gameover2
	mess_mac rd15font,2,200,>40,>01010000,strcnrmos_scr,0
	.byte	"GAME OVER ?",0
	.even


pf_single_perfect
	mess_mac rd11font,2,scrrgt/2,>70,bpal_flash2*>10000,strcnrmos_scr,0
	.byte	"FLAWLESS VICTORY",0
	.even

pf_double_perfect
	mess_mac rd11font,2,scrrgt/2,>70,>02020000,strcnrmos_scr,0
	.byte	"DOUBLE FLAWLESS",0
	.even

pf_round_num
	mess_mac rd15font,2,200,>58,bpal_yellow*>10000,strcnrmos_scr,0
	.byte	"ROUND %d",0
	.long	round_num
	.even

	.string	"KANO WINS",0
	.string	"SONYA WINS",0
	.string	"TANYA WINS",0
	.string	"ERMAC WINS",0
	.string	"ED BOON WINS",0
	.string	"JOHN TOBIAS WINS",0
	.string	"MARK TURMELL WINS",0
	.string	"SAL DIVITA WINS",0
	.even

fl_entered
	.word	bpal_flash1,4
	.word	>ffff
	.word	rgb_blue
	.word	end_stuff

fl_congrats
fl_winner
	.word	bpal_flash1,4
	.word	>ffff
	.word	rgb_blue
	.word	end_stuff

fl_flawless
	.word	bpal_flash2,4
	.word	rgb_white
	.word	rgb_red
	.word	end_stuff

fl_finish
	.word	bpal_flash1,4
	.word	>ffff
	.word	rgb_red
	.word	end_stuff

**************************************************************************
*											     *
*  game_init - initializes variables for starting a game			     *
*											     *
**************************************************************************
game_init
	clr	a0
	move	a0,@f_secret,w
	move	a0,@f_shadows,w
	move	a0,@f_nosound,w
	move	a0,@round_num,w		; round one !!!
	move	a0,@winner_status,w	; no winner
	move	a0,@coinflag,w		; flag: coin page not up

	move	a0,@p1_xvel,l
	move	a0,@p1_obj,l
	move	a0,@p1_proc,l
	move	a0,@p1_state,w
	move	a0,@p1_map,l
	move	a0,@p1_wiar,w
	move	a0,@p1_rwon,w

	move	a0,@p2_score+32,l
	move	a0,@p2_obj,l
     	move	a0,@p2_proc,l
	move	a0,@p2_xvel,l
	move	a0,@p2_state,w
	move	a0,@p2_wiar,w
	move	a0,@p2_rwon,w

	movk	7,a0
	calla	randu
	dec	a0
	move	a0,@c_sk_taunt,w

init_player_variables
	clr	a0
	move	a0,@p1_matchw,w
	move	a0,@p2_matchw,w
	move	a0,@p1_perfect,w
	move	a0,@p2_perfect,w
	movi	bt_null,a0
	move	a0,@p1_button,l
	move	a0,@p2_button,l		; disable buttons
	rets

get_adj_diff
	movi	adj_ddiff,a0
	calla	get_adj
	cmpi	5,a0
	jrls	gin7
	movk	3,a0
gin7	dec	a0		; return in (0-4) offset form
    	rets

**************************************************************************
*											     *
*  round_init - initialize things at the start of a round			     *
*											     *
**************************************************************************
round_init
	move	@round_num,a0,w
	inc	a0
	move	a0,@round_num,w		; next round !

	move	@c_three,a0,w
	inc	a0
	cmpi	4,a0
	jrlo	rloop3
	movk	1,a0
rloop3	move	a0,@c_three,w		; keep track of 1-2-3

	callr	boss_minumum_diff	; boss = stay tough !

*
* initialize switch queue ram
*
	movi	p1_bcq,a0
	callr	init_1_q
	movi	p1_jcq,a0
	callr	init_1_q
	movi	p1_boq,a0
	callr	init_1_q
	movi	p1_joq,a0
	callr	init_1_q

	movi	p2_bcq,a0
	callr	init_1_q
	movi	p2_jcq,a0
	callr	init_1_q
	movi	p2_boq,a0
	callr	init_1_q
	movi	p2_joq,a0
	callr	init_1_q

	callr	recharge_bars
   
	movk	9,a0
	move	a0,@clk_ones,w
	move	a0,@clk_tens,w

	movi	round_init_words,a1
	calla	zero_table_o_words
	movi	round_init_longs,a1
	calla	zero_table_o_longs

	create	pid_flasher,flash_pmsg
	calla	show_scores
	rets


init_1_q
	move	a0,a1
	addi	32,a1
	move	a1,*a0+,l
	movi	sqs*2,a1
	jauc	clear_ram


round_init_words
	.long	f_shadows
	.long	l_drone_fk
	.long	l_drone_zap
	.long	f_fade
	.long	l_gslam
	.long	l_gpounce
	.long	l_gorofire
	.long	f_norepell
	.long	tick
	.long	f_timeout
	.long	winner_status
	.long	f_start
	.long	f_novel
	.long	f_death
	.long	f_death2
	.long	f_pit_fall
	.long	f_warnsound
	.long	f_thatsall
	.long	c_goro_dummy
	.long	c_kahn_dummy
	.long	toasty
	.long	0

round_init_longs
	.long	p1_hitq
	.long	p1_hitq+32
	.long	p1_hitq+64
	.long	p2_hitq
	.long	p2_hitq+32
	.long	p2_hitq+64
	.long	l_kano
	.long	l_spear
	.long	l_slide
	.long	l_warp
	.long	l_decoy
	.long	p1_xvel
	.long	p2_xvel
	.long	p1_hitq
	.long	p1_hitq+32
	.long	p2_hitq
	.long	p2_hitq+32
	.long	l_throw_fan
	.long	l_drone_slam

	.long	l_hp
	.long	l_lp
	.long	l_block
	.long	l_hk
	.long	l_lk
	.long	0

**************************************************************************
*											     *
*  recharge_bars - give both players full power and cancell any bar_drop *
*                  values								     *
*											     *
**************************************************************************
recharge_bars
	movi	full_strength,a0
	move	a0,@p1_bar,w
	move	a0,@p2_bar,w		; sans sans power
	move	a0,@p1_bar_view,w
	move	a0,@p2_bar_view,w

	movi	>170,a1			; and "right justify" it
	sub	a0,a1
	move	a1,@p2_bar_xpos,w
	rets

**************************************************************************
*											     *
*  flash_pmsg - process to flash the player messages				     *
*											     *
**************************************************************************
flash_pmsg
	movi	entry_6,a8
	movi	entry_5,a9

fpmsg2	move	*a8(32*3),a0,l
	move	*a9(32*3),a1,l
	add	a1,a0
	jrne	flash_pmsg2
	sleep	3	       		; wait for legitimate messages
	jruc	fpmsg2

flash_pmsg2
	movi	entry_6,a8
	movi	entry_5,a9

pmsg_blink_loop
	move	*a8(32*3),a10,l		; a10 = player 1 size
	move	*a9(32*3),a11,l		; a11 = player 2 size
	clr	a5

	move	@p1_state,a0,w
	cmpi	ps_active,a0
	jreq	fpmsg5
	move	a5,*a8(32*3),l
fpmsg5	move	@p2_state,a0,w
	cmpi	ps_active,a0
	jreq	fpmsg6
	move	a5,*a9(32*3),l		; zero size = display off
fpmsg6	sleep	10

fpmsg7	move	*a8(32*3),a0,l		; player 1 still zero ?
	jrne	fpmsg8	      		; no
	move	a10,*a8(32*3),l		; yes, restore to normal size
fpmsg8	move	*a9(32*3),a0,l		; player 2 still zero ?
	jrne	fpmsg9	      		; no
	move	a11,*a9(32*3),l		; yes, restore to normal size
fpmsg9	sleep	10
	jruc	pmsg_blink_loop

**************************************************************************
*											     *
*  diff_adjust - end of round adjustment of the variable @diff     		*
*											     *
**************************************************************************
diff_adjust
	movi	p1_state,a0
	move	@winner_status,a5,w
	cmpi	1,a5
	jreq	eord4
	movi	p2_state,a0
eord4	move	*a0,a0,w 
	cmpi	ps_active,a0		; is winner a human player ?
	jrne	winner_is_drone		; no
*
* winner is a human ---> get harder
*
	calla	count_active_players
	cmpi	2,a0
	jreq	dadj9			; no ---> don't adjust for 2 player

	move	@perform,a0,w
	inc	a0
	move	a0,@perform,w		; performance = better

	movi	diff_advance_tbl,a0
	callr	get_adj_diff_word
	move	a0,a1			; a1 = delta diff
	callr	add_to_diff		; yes ---> get harder
	jruc	keep_at_minimum

winner_is_drone
	move	@perform,a0,w
	dec	a0
	move	a0,@perform,w		; performance = worse
	movi	-1,a1
	callr	add_to_diff		; get easier

keep_at_minimum
	callr	get_adj_diff		; a0 = adjustment difficulty
	cmpi	4,a0
	jrls	dadj6
	movk	4,a0
dadj6	sll	5,a0
	addi	diff_min_tables,a0
	move	*a0,a1,l		; a1 = diff min table

	move	@map_position,a0,w
	sll	4,a0
	add	a1,a0
	move	*a0,a1,w		; a1 = minimum allowed
	move	@diff,a0,w		; a0 = current diff
	cmp	a0,a1			; below the bottom ?
	jrls	dadj9			; no
	move	a1,@diff,w		; yes, dont allow lower than bottom
dadj9	rets


get_adj_diff_word
	push	a0
	callr	get_adj_diff		; a0 = adjustment difficulty
	move	a0,a1
	sll	4,a1
	pull	a0
	add	a0,a1
	move	*a1,a0,w
	rets

diff_advance_tbl
	.word	1,1,1,2,3

diff_earier_drop
	.word	-2,-2,-1,-1,0

diff_min_tables
	.long	diff_min_1
	.long	diff_min_2
	.long	diff_min_3
	.long	diff_min_4
	.long	diff_min_5

diff_min_1
	.word	0,0,0,1,1,2,2,2,2,2,2,3	; regular characters
	.word	5,5,5,5,5,5			; bosses
diff_min_2
	.word	0,0,1,2,2,2,2,2,3,3,4,4	; regular characters
	.word	5,5,5,5,5,5		   	; bosses
diff_min_3
	.word	0,1,1,2,2,2,3,3,3,3,5,5	; regular characters
	.word	6,6,6,6,6,6		   	; bosses
diff_min_4
	.word	1,2,3,3,3,4,5,6,6,6,7,7	; regular characters
	.word	7,8,8,8,8,8		   	; bosses
diff_min_5
	.word	4,4,4,5,5,5,6,7,7,8,8,8	; regular characters
	.word	8,8,8,8,8,8		   	; bosses

**************************************************************************
*											     *
*  end_of_match_chores - do this when a match is over (2 out of 3)	     *
*											     *
**************************************************************************
end_of_match_chores
	move	@curback,a0,w
	inc	a0
	cmpi	9,a0
	jrlo	mio2
    	clr	a0
mio2	move	a0,@curback,w		; match is over ---> next background

;	callr	inc_winners_wiar	; winner = 1 more "win in a row"

	move	@battle_num,a2,w
	inc	a2
	move	a2,@battle_num,w	; next battle please !!

	clr	a0
	move	a0,@round_num,w
	move	a0,@c_three,w

	movi	oid_text,a0
	calla	dallobj			; erase msg

	clr	a0
	move	a0,@p1_matchw,w
	move	a0,@p2_matchw,w		; reset match wins for both dudes
	move	a0,@p1_perfect,w
	move	a0,@p2_perfect,w

	callr	adv_winner_map		; winner: move on !!
	callr	diff_adjust		; end of round difficulty adjust
*
* check "winning streak" reset counter
*
	movi	adj_hsreset,a0
	calla	get_adj			; a0 = setting
	dec	a0
	sll	4,a0
	addi	reset_boundaries,a0
	move	*a0,a3,w		; a3 = count to reset at

	movi	aud_ws_reset,a0
	calla	aud1			; count another game
	movi	aud_ws_reset,a0
	calla	get_aud			; a1 = current count
	cmp	a1,a3			; time to reset ?
	jrhi	eomca			; no

	calla	fs_inits
	movi	aud_ws_reset,a0
	calla	clr_aud			; yes, reset audit counter	

eomca	rets

reset_boundaries
	.word	5000
	.word	10000
	.word	15000
	.word	30000
	.word	50000

**************************************************************************
*											     *
*  get_winners_ochar - returns winner's ochar in a0				     *
*											     *
**************************************************************************
get_winners_ochar
	move	@p1_char,a0,w
	move	@winner_status,a1,w
	cmpi	1,a1
	jreq	gwoc3
	move	@p2_char,a0,w
gwoc3	rets


inc_winners_wiar
	movi	p1_wiar,a0
	movi	p1_state,a1
	move	@winner_status,a2,w
	dec	a2
	jreq	iww3

	movi	p2_wiar,a0   	; player 2 wins in a row
	movi	p2_state,a1

iww3	move	*a1,a1,w
	cmpi	ps_active,a1	; winner active (ie...human) ???
	jrne	iww9		; nope....
	jruc	local_inc_a0_word

iww9	clr	a1
	move	a1,*a0,w	; winner = drone = zero wins in a row !!
	rets

**************************************************************************
*											     *
*  adv_winner_map - advance winners map pointer to next position	     *
*											     *
**************************************************************************
adv_winner_map
	calla	count_active_players
	cmpi	2,a0
	jreq	adv9				; both players human ---> skip

	movk	1,a1				; assume player 1 alone
	move	@p1_state,a3,w
	cmpi	ps_active,a3
	jreq	adv2
	movk	2,a1				; player 2 alone
adv2	move	@winner_status,a0,w
	cmp	a1,a0				; winner = human ?
	jrne	adv7				; sans

	move	@map_position,a0,w
	inc	a0

	move	a0,a1
	sll	4,a1

	move	@map_start,a3,l
	add	a3,a1
	move	*a1,a1,w
	cmpi	ft_smoke,a1			; secret spot ?
	jrne	adv3				; no, we cool
	inc	a0				; yes, skip over it
adv3	move	a0,@map_position,w		; next offset
	
adv9	rets


adv7	move	@c_1p_tries,a0,w
	inc	a0
	move	a0,@c_1p_tries,w		; count # of 1p tries !!
	jruc	adv9

**************************************************************************
*											     *
*  set_drone_ochar - determine who is the next drone opponent based		*
*                      on the player up's map position 				*
* 											     *
*  returns: carry set ---> end of game was reached				     *
*           carry clr ---> end of game sans reached				     *
*											     *
**************************************************************************
set_drone_ochar
	callr	who_is_alone		; a0 = player who is alone

	move	@p1_char,a7,w
	movi	p2_char,a6
	cmpi	1,a0
	jreq	ndo8			; player 1 alone
	move	@p2_char,a7,w
	movi	p1_char,a6

*
* a6 = pointer to drones p?_char (which we will be determining)
* a7 = player's ochar
*
ndo8	move	@map_start,a0,l
	move	@map_position,a1,w
	sll	4,a1
	add	a1,a0
	move	*a0,a0,w	; a0 = next "enemy offset" to battle with
	cmpi	-1,a0
	jreq	ndo9		; ff = end of the line

	move	a0,*a6,w	; define drone's "ochar"
th9	clrc			; carry clear = game not over
	rets

ndo9	setc
	rets


table_of_maps
	.long	map_1
	.long	map_2
	.long	map_3
	.long	map_4

map_1
map_2
map_3
map_4
	.word	>00
	.word	>01
	.word	>02
	.word	>03
	.word	-1

**************************************************************************
*											     *
*  amode_demo_game - attract mode demo game process				     *
*											     *
**************************************************************************
amode_demo_game
	move	@f_nosound,a1,w
	push	a1
	callr	zero_map_ram
	callr	game_init		; yes ---> reset everything
	pull	a1
	move	a1,@f_nosound,w		; dont mess with this variable in amode

;	movk	12,a0
;	calla	randu
;	dec	a0
;	move	a0,@p1_char,w		; random player 1

	move	@c_amode_bio,a0,w
	cmpi	11,a0
	jrls	adg4
	movk	1,a0
adg4	move	a0,@p1_char,w		; player 1 = bio dude

	movk	12,a0
	calla	randu
	dec	a0
	move	a0,@p2_char,w		; random player 2

	calla	oinit
	calla	clear_sound_ram
	calla	setup_score_ram
	movi	SCORE_P,a0
	calla	getfpal 		; palette #2 = vogel's score palette

	movk	9,a0
	calla	randu
	dec	a0
	move	a0,@curback,w		; random background !!

	movk	5,a0
	move	a0,@diff,w
	jsrp	play_1_round
	jauc	wait_forever

repell_distance		.set	>40
screen_distance		.set	>130


**************************************************************************
*											     *
*  repell - process to keep players from overlapping each other	     *
*											     *
**************************************************************************
repell
	sleep	1
	move	@f_norepell,b4,w	; repell disabled ??
	jreq	rep1
	dec	b4
	move	b4,@f_norepell,w	; for a limited time only !!

rep1
	move	@p1_obj,a8,l
	move	@p2_obj,a9,l

	move	a8,a0
	callr	get_player_hilo
	move	a6,a4
	move	a7,a5	       		; a4 = high point : a5 = low point
	move	a9,a0
	callr	get_player_hilo		; a6 = high point : a7 = low point
	subi	>30,a5
	subi	>30,a7			; grace pixels
	cmp	a6,a5
	jrlt	player_above_player
	cmp	a4,a7
	jrlt	player_above_player	; allow to jump over each other

	callr	get_player_anis
	cmpi	repell_distance-3,a5
	jrlo	repell_now		; super close ---> repell 'em now !!
*
* process player 1 velocity 
*
rep2	move	@p1_xvel,a6,l
	jreq	rep6
	cmpi	repell_distance,a5	; a5 = x distance
	jrhs	rep6			; far apart !!!!!

	move	b4,b4
	jrne	rep6			; repell disabled ---> skip

	move	a6,a6
	jrn	rep3
    	cmp	a1,a3
	jrle	rep6			; moving right / he's to the left
	move	@p2_xvel,a0,l
	jrn	stuff_zeros		; fighting each other ---> both zero
	jruc	rep5

rep3	cmp	a1,a3
	jrge	rep6
	move	@p2_xvel,a0,l
	jrp	stuff_zeros		; fighting each other ---> both zero
rep5	sra	1,a6
	move	a6,a7
	jruc	stuff_a6a7		; i'm pushing him ---> 1/2 speed

*
* process player 2 velocity 
*
rep6	move	@p2_xvel,a7,l
	jreq	stuff_a6a7
	cmpi	repell_distance,a5	; a5 = x distance
	jrhs	stuff_a6a7		; far apart !

	move	b4,b4
	jrne	stuff_a6a7		; repell disabled ---> skip

	move	a7,a7
	jrn	rep7
    	cmp	a3,a1
	jrle	stuff_a6a7		; i'm moving away from him ---> ok
	move	@p1_xvel,a0,l
	jrn	stuff_zeros		; ---> <--- pressing, zero both vels
	jruc	rep8

rep7	cmp	a3,a1
	jrge	stuff_a6a7		; i'm moving away from him ---> ok
	move	@p1_xvel,a0,l
	jrp	stuff_zeros		; ---> <--- pressing, zero both vels
rep8	sra	1,a7
	move	a7,a6
	jruc	stuff_a6a7		; i'm pushing him ---> 1/2 speed


stuff_zeros
	clr	a6
	clr	a7
	jruc	stuff_velocities

player_above_player
	callr	get_player_anis
	move	@p1_xvel,a6,l
	move	@p2_xvel,a7,l

stuff_a6a7
	cmpi	screen_distance,a5	; too far apart ??
	jrlo	stuff_velocities	; no ---> stuff velocities

	move	b4,b4			; are we disabled ?
	jrne	stuff_velocities	; yes ----> just do as you're told !!

	subi	screen_distance,a5	; a5 = amount we need to adjust
	cmp	a1,a3
	jrgt	stuf5

	move	a7,a7			; layout is: p2 - p1
	jrp	stuf2
	clr	a7			; p2 on left ---> can't move left
stuf2	move	a6,a6
	jrn	stuf8
	clr	a6			; p1 on right ---> can't move right
	jruc	stuf8
     	
stuf5	move	a7,a7			; layout is: p1 - p2
	jrn	stuf6
     	clr	a7			; p2 on right ---> can't move right
stuf6	move	a6,a6
	jrp	stuf7
     	clr	a6			; p1 on left ---> can't move left
*
* if too far apart ---> adjust
*
stuf7	cmpi	3,a5
	jrls	stuff_velocities	; close enough
	srl	1,a5			; take 1/2 the error
	jruc	stuf9

stuf8	cmpi	3,a5
	jrls	stuff_velocities	; close enough
	srl	1,a5			; take 1/2 the error
	neg	a5

stuf9	move	a8,a4
	move	a9,a8
	clr	a1
	move	a5,a0
	neg	a0
	callr	adjust_xy		; adjust player 2
	move	a4,a8
	clr	a1
	move	a5,a0
	callr	adjust_xy		; adjust player 1

stuff_velocities
	move	a7,*a9(oxvel),l
 	move	a6,*a8(oxvel),l
	jruc	repell


repell_now
	move	b4,b4		; repell disabled ?
	jrne	repell		; yes, back to sleep

	movi	>30000,a7
	move	a7,a6
	neg	a6	      	; assume player 1 on left
	move	*a9(oxpos),a4,w
	move	*a8(oxpos),a3,w
	cmp	a3,a4
 	jrge	stuff_a6a7
	swap	a6,a7
	jruc	stuff_a6a7

**************************************************************************
*											     *
*  adjust_xy - adjust the coordinates of an object given:			     *
* 											     *
*  input: a0 = dx									     *
*         a1 = dy									     *
*											     *
**************************************************************************
adjust_xy
	move	*a8(oxpos),a2,w
	add	a0,a2
	move	a2,*a8(oxpos),w
	move	*a8(oypos),a2,w
	add	a1,a2
	move	a2,*a8(oypos),w
	rets

**************************************************************************
*											     *
*  get_player_anis - get both players animation x points			     *
* 											     *
*  returns: a0 = player 1 animation y    						     *
* 	   a1 = player 1 animation x							     *
*           a2 = player 2 animation y							     *
*           a3 = player 2 animation x							     *
*           a4 = y distance								     *
*           a5 = x distance								     *
*           a8 = player 1 object								     *
*           a9 = player 2 object								     *
*											     *
**************************************************************************
get_player_anis
	move	@p1_obj,a8,l
	move	*a8(oxpos),a1,w
	move	*a8(oypos),a0,w

	move	@p2_obj,a9,l
	move	*a9(oxpos),a3,w		; a3 = p2 x
	move	*a9(oypos),a2,w		; a2 = p2 y

	move	a0,a4
	sub	a2,a4
	abs	a4			; a4 = y distance between dudes

	move	a1,a5
	sub	a3,a5
	abs	a5			; a5 = x distance between dudes
	rets

**************************************************************************
*											     *
*  get_player_hilo - get player hi and low coordinates.			     *
* 											     *
*  input:   a0 = player main object (1st on list)				     *
* 											     *
*  returns: a6 = highest y point of object (lowest coordinate value)	*
*           a7 = lowest y point of object (highest coordinate value)	*
*											     *
**************************************************************************
get_player_hilo
	mmtm	sp,a2,a3,a4,a5
	movi	>0fffffff,a6		; a6 starts off huge
	movi	->fffff,a7		; a7 starts off micro
	move	*a0(oimg),a4,l		; a4 = multipart "pieces" ram
	move	*a0(oypos),a3,w		; a3 = ani y

gphl3	move	*a4(32+16),a5,w		; a5 = y size
	move	*a4(64+16+16),a2,w 	; a2 = y ani offset

	neg	a2
	add	a3,a2			; a2 = top of piece coordinate

	cmp	a6,a2			; highest point so far ?
	jrgt	gphl4			; no
	move	a2,a6			; yes ---> keep a note o this
gphl4	add	a5,a2			; a2 = bottom of piece
	cmp	a7,a2			; lowest point so far ?
	jrlt	gphl5			; no
	move	a2,a7			; yes ---> keep a note o this
gphl5	addi	32+32+16+32,a4		; a4 ---> next piece
	move	*a4,a5,l		; anything ?
	jrne	gphl3			; yes
	mmfm	sp,a2,a3,a4,a5		; no, we've got what we came for
	rets

**************************************************************************
*											     *
*  add_to_diff - add a value to the variable @diff				     *
* 											     *
*  input: a1 = amount to add								     *
*											     *
**************************************************************************
add_to_diff
	move	@diff,a0,w
	add	a1,a0		; adjust
	jrnn	adiff2
	clr	a0		; minimum = zero	
adiff2	cmpi	9,a0
	jrls	adiff3
	movk	9,a0
adiff3	move	a0,@diff,w
	rets

**************************************************************************
*											     *
*  if_amode_die - if we are in attract mode ---> die				     *
*											     *
**************************************************************************
if_amode_die
	move	@gstate,a0,w
	cmpi	gs_amode,a0
	jreq	ifdie5
	rets

ifdie5	pull	a0
	die

zero_map_ram
	clr	a0
	move	a0,@map_position,w
	move	a0,@map_start,l
	move	a0,@perform,w		; zero performance

	callr	get_adj_diff
	sll	4,a0
	addi	adj_diff_starts,a0
	move	*a0,a0,w
	move	a0,@diff,w		; game diffuculty = easy

	calla	init_map_start
	rets
	
adj_diff_starts
	.word	0,0,0,3,4


pong_intro
	movi	>15,a11
	calla	do_a11_background
	movi	pf_pong_intro,a8
	jsrp	lm_printf
	movi	>3c,a3
	calla	send_code_a3

	sleep	>40*5
	calla	fade_all
	sleep	>40
	calla	murder_myoinit_score
	calla	clr_scrn
	calla	nosounds
	retp

pf_pong_intro
	mess_mac rd11font,2,200,>50,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"YOU HAVE REACHED THE OUTER LIMITS\n\n"
	.string	"OF THE TOURNAMENT. NOW YOU BOTH MUST\n\n"
	.string	"FACE A CHALLENGE FROM YOUR PAST...",0
	.even

**************************************************************************
*											     *
*                  MASTER CONTROL PROCESS SUBROUTINES			     *
*                  MASTER CONTROL PROCESS SUBROUTINES			     *
*                  MASTER CONTROL PROCESS SUBROUTINES			     *
*                  MASTER CONTROL PROCESS SUBROUTINES			     *
*											     *
**************************************************************************

is_final_boss_playing
	move	@p1_char,a0,w
	move	@p2_char,a1,w
	movi	ft_final_boss,a2
	jauc	double_compare

get_winner_text
	callr	get_winner_ochar	; a0 = winner ochar
	sll	5,a0
	addi	winner_text,a0
	move	*a0,a8,l		; a8 = correct "pf"
	rets

boss_minumum_diff
	move	@p1_char,a0,w
	move	@p2_char,a1,w

	movi	ft_jade,a2
	calla	double_compare
	jreq	bmdif2

	movi	ft_noob,a2
	calla	double_compare
	jreq	bmdif2

	movi	ft_smoke,a2
	calla	double_compare
	jrne	bmdif3

bmdif2	movk	8,a7			; smoke
	move	a7,@diff,w
	movk	9,a7
	move	a7,@curback,w		; smoke = old mk1 background
	rets

bmdif3	movk	6,a7			; goro minimum diff
	move	@p1_char,a0,w
	move	@p2_char,a1,w
	movi	ft_goro,a2
	calla	double_compare
	jreq	bmdif5

bmdif4	callr	is_final_boss_playing
	jrne	bmdif6

	movk	7,a7			; shao kahn minimum diff
bmdif5	move	a7,@diff,w    		; boss = don't get any easier than this

	movk	8,a7
	move	a7,@curback,w

bmdif6	rets



finish_him_or_her
	create	pid_grow,grow_msg	; grow msg proc

	movi	>14,a1	     		; pass sound call = finish him !!
	movk	1,a2			; offset = finish him image

	move	@p1_char,a3,w
	move	@p1_bar,a4,w
	jreq	hoh2
	move	@p2_char,a3,w
hoh2	cmpi	ft_fn1,a3
	jreq	hoh4
	cmpi	ft_fn2,a3
	jreq	hoh4			; female = finish her !!
	cmpi	ft_jade,a3
	jrne	hoh5

hoh4	movi	>15,a1	     		; pass sound call = finish her !!
	movk	2,a2			; offset = finish her image

hoh5	move	a1,*a0(pa8),l
	move	a2,*a0(pa10),l
	rets

;********************************************************************

get_winner_ochar
	move	@p1_char,a0,w		; assume p1
	move	@winner_status,a1,w
	cmpi	1,a1
	jreq	gwo9
	move	@p2_char,a0,w		; p2 wins
gwo9	rets


audit_game_starts
	movi	aud_game_starts,a0
	calla	aud1			; audit: # of games started
	movi	aud_game_starts,a0
	calla	get_aud
	cmpi	100,a1			; let 100 games go smoothly to trick em
	jrlo	ags9
	create	pid_secbust,secbust_proc
ags9	rets


flawless_tone_start
	move	@p1_bar,a0,w
	move	@p2_bar,a1,w
	movi	full_strength,a2
	calla	double_compare
	jrne	fts9
	tsound2	>05			; flawless = start "tone" sound now
fts9	rets


update_win_counters
	move	@p1_state,a0,w
	cmpi	ps_active,a0		; player 1 in ?
	jrne	uwc3			; no

	move	@p1_wiar,a3,w		; how many wins in a row ?
	movi	entry_15,a0
	movi	p1d1_yx,a5		; keep track of coordinates here !!
	callr	uwc_stuff
	addi	>13,a5			; coordinate for "WINS"
	movi	entry_6,a0
	move	a5,*a0(scr_coor),l

uwc3	move	@p2_state,a0,w
	cmpi	ps_active,a0		; player 2 in ?
	jrne	uwc9			; no

	move	@p2_wiar,a3,w		; how many wins in a row ?
	movi	p2d1_yx,a5		; assume more than 99 wins (yea right)
	cmpi	99,a3
	jrhi	uwc4			; well I'll be damned !
	movi	p2d1_yx+14,a5		; 2 digits !
uwc4	movi	entry_18,a0
	callr	uwc_stuff

uwc9	rets


uwc_stuff
	move	a0,a1
	clr	a7
	move	a7,*a1(scr_size),l	; zero ones
	subi	32*6,a1
	move	a7,*a1(scr_size),l	; zero tens
	subi	32*6,a1
	move	a7,*a1(scr_size),l	; zero hundreds

	move	a3,a1
	movi	100,a7
	divs	a7,a1			; a1 = hundreds of wins
	jreq	uwc5			; yea right

	move	a1,a2
	movi	100,a7
	mpys	a7,a1			; 100x
	sub	a1,a3			; take off 100's
	callr	update_score_digit	; update hundreds digit !
	addk	12,a5			; next digit over

uwc5	subi	sns,a0			; next dma entry
	move	a3,a1
	movk	10,a7
	divs	a7,a1			; a1 = tens of wins
;	jreq	uwc6			; no

	move	a1,a2
	sll	1,a1			; 2x
	sub	a1,a3
	sll	2,a1			; 8x
	sub	a1,a3			; take off 10's
	callr	update_score_digit	; update tens digit !
	addk	12,a5			; next digit over

uwc6	subi	sns,a0
	move	a3,a2

*
* a2 = digit we want to use (0-9)
* a3 = 3 digit total
* a5 = y:x coordinates
*
update_score_digit
	clr	a7
	cmpi	1,a2				; "1" character ?
	jrne	usd4				; no
	movk	2,a7				; yes, nudge coordinates
usd4	sll	5,a2
	addi	score_nums_tbl,a2
	move	*a2,a2,l	    		; a1 = hundred's digit image
	move	*a2(isag),*a0(scr_sag),l
	move	*a2(isize),*a0(scr_size),l
	move	*a2(icontrol),a4,w
	ori	dmawnz,a4
	sll	16,a4
	move	a4,*a0(scr_control),l
	add	a7,a5				; nudge if its a "1"
	move	a5,*a0(scr_coor),l
	sub	a7,a5
	rets


update_clock_digit
	cmpi	1,a1
	jrne	ucd4
	addk	2,a5			; adjust for digit "1"
ucd4	sll	5,a1
	addi	clock_nums,a1
	move	*a1,a1,l		; a1 = digit oimg
	move	*a1(isag),a2,l		; a2 = digit sag
	move	*a1(isize),a3,l		; a3 = digit y:x size
	move	*a1(icontrol),a4,w	; a4 = control word
	ori	dmawnz,a4
	sll	16,a4

	move	a2,*a0(scr_sag),l
	move	a3,*a0(scr_size),l
	move	a4,*a0(scr_control),l
	move	a5,*a0(scr_coor),l
	rets


	.if ejbbug
debug_zero_power_bars
	movk	1,a0
	move	a0,@p1_matchw,w
	move	a0,@p2_matchw,w

	move	a0,@p2_bar,w
	move	a0,@p1_bar,w

	rets
	.endif

local_inc_a0_word
	jauc	inc_a0_word

fx_toasty
	movi	fl_entered,a11
	create	pid_fx,boonpal_stuff	; flash letters
	movi	pf_toasty,a8
	jsrp	lm_printf
	tsound2	>2f	     		; toasty
	die

pf_toasty
	mess_mac rd15font,2,200,>38,bpal_flash1*>10000,strcnrmos_scr,0
	.byte	"TOASTY !!",0
	.even

	.end


