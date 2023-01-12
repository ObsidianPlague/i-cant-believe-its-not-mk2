**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: mksel.asm --- player select							*
* 											     *
*  copyright (c) 1993 williams electronics games, inc.			     *
*											     *
**************************************************************************
	.file	'mksel.asm'
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
	.include	mksel.tbl

	.ref	get_aud

p1_x	.set	>28
p2_x	.set	>163

cthick	.set	4

x_size	.set	55
y_size	.set	70

	.text


join_in_during_psel
	tsound2	>2e

	movi	ps_psel,a0
	move	a0,*a2,w  	; my player state = player select mode
	movi	pid_master,a0
	calla	exprc_er	; find central controller

	move	*a0(psptr),a3,l	; his stack pointer (return address)
	move	*a3,a4,l	; a4 = retp address

	movi	player_joinin,a7
	calla	fastxfer
	move	a3,*a0(psptr),l	; restore proc stack to spot we found it in
	move	a4,*a3,l	; and place it !
	die


skip_psel
	movi	ps_active,a1
	move	@p1_state,a0,w
	jreq	sps3
	move	a1,@p1_state,w
sps3	move	@p2_state,a0,w
	jreq	sps4
	move	a1,@p2_state,w
sps4 

;************
;	jruc	erer
;	.if de bug
;	movi	ps_active,a1
;	move	a1,@p1_state,w
;	move	a1,@p2_state,w
;	.endif
;erer
;************

	retp

**************************************************************************
*											     *
*  player_select - code to let the players choose who they want to be !  *
*											     *
**************************************************************************
player_select
	move	@f_fastrun,a6,w
	jrne	skip_psel

	calla	murder_myoinit
	clr	a0
	move	a0,@f_doscore,w		; dont display score 'n stuff
	calla	init_player_variables
	calla	nosounds
	calla	display_off

	movi	psel_mod,a0
	calla	init_bakmods
	calla	multi_plane		; player select background !!

	clr	a0
	move	a0,@f_start,w		; flag: dont fight !!
	not	a0
	move	a0,@p1_char,w
	move	a0,@p2_char,w		; null the characters = >ffff
*
* display mugshots
*
	movi	mug_shot_table,a7
	move	@ofree,a9,l		; a9 = last object
	move	a9,*a13(p_store1),l	; save here

psel3	move	*a7+,a5,l		; a5 = mugshot image
	jreq	psel2

	calla	gso_dmawnz_ns
	move	a8,*a9(oslink),l	; link mugshots together
	move	a8,a9
	move	*a7+,a4,l
	calla	set_xy_coordinates

	movi	bpal_white,a1
	move	a1,*a8(oconst),w	; temp
	calla	insobja8		; on list 2
	jruc	psel3


psel2	clr	a0
	move	a0,*a8(oslink),l	; last object = 0 link

	movi	pf_select_msg,a8
	jsrp	lm_printf
	calla	display_on

	movi	>32,a3
	calla	send_code_a3	    	; player select tune
	movi	>21b,a3
	calla	send_code_a3		; gong !!
	callr	create_cursor_procs
	jruc	psel6


player_joinin
	callr	create_cursor_procs	; 2nd time = sans fancy

psel6	movi	>40*5,a11
psel5	sleep	3

waiting_for_psel
	dec	a11
	jreq	psel9			; timed out !!
	movi	pid_p1sel,a0
	calla	exprc
	jrne	psel5
	movi	pid_p2sel,a0
	calla	exprc
	jrne	psel5			; select proc exists ---> loop
	jruc	psel4

psel9	movi	pid_p1sel,a0
	callr	force_psel_choice
	movi	pid_p2sel,a0
	callr	force_psel_choice	; timeout ---> force a choice now !!

psel4	sleep	>1c

	movi	ps_active,a1		; activate the dudes who are in
	move	@p1_char,a0,w
	jrnn	psel7
	clr	a1			; assume non-active
psel7   	move	a1,@p1_state,w
	movi	ps_active,a1		; activate the dudes who are in
	move	@p2_char,a0,w
	jrnn	psel8
	clr	a1
psel8	move	a1,@p2_state,w

	movi	gs_post_psel,a0
	move	a0,@gstate,w		; game state: post player select
	sleep	>20

	movi	oid_cursor1,a0
	calla	dallobj
	movi	oid_cursor2,a0
	calla	dallobj			; delete cursor objects !!
	calla	murder			; stop color flash procs

;	calla	fade_all_fast
;	sleep	8
	retp

**************************************************************************
*											     *
*  create_cursor_procs - create a cursor proc for any player who is in   *
*                        the game.							     *
*											     *
**************************************************************************
create_cursor_procs
	move	@p1_state,a0,w
	cmpi	ps_active,a0
	jrne	ccp3
	movi	ps_psel,a0
ccp3	move	a0,@p1_state 	; active players --> now in pselect mode
	cmpi	ps_psel,a0
	jrne	ccp5

	movi	p1_select,a7
	movi	pid_p1sel,a0
	calla	create_if_gone

ccp5 	move	@p2_state,a1,w
	cmpi	ps_active,a1
	jrne	ccp6
	movi	ps_psel,a1
ccp6	move	a1,@p2_state,w	; active players --> now in pselect mode
	cmpi	ps_psel,a1
	jrne	ccp4

	movi	p2_select,a7
	movi	pid_p2sel,a0
	calla	create_if_gone

ccp4	rets


pf_select_msg
	mess_mac rd15font,2,200,>04,bpal_yellow*>10000,strcnrmos_scr,0
	.byte	"CHOOSE YOUR FIGHTER",0
	.even

mug1_x	.set	>53
mug1_y	.set	>18
x_space	.set	60
y_space	.set	75

mug_init
	.long	null_image,boonpal
	.word	oid_fx
	.word	0,0,0

mug_shot_table
	.long	LKBOX
	.word	mug1_x,mug1_y
	.long	HHBOX
	.word	mug1_x+(x_space*1),mug1_y
	.long	JCBOX
	.word	mug1_x+(x_space*2),mug1_y
	.long	RPBOX
	.word	mug1_x+(x_space*3),mug1_y

	.long	SZBOX
	.word	mug1_x,mug1_y+(y_space*1)
	.long	STBOX
	.word	mug1_x+(x_space*1),mug1_y+(y_space*1)
	.long	FN1BOX
	.word	mug1_x+(x_space*2),mug1_y+(y_space*1)
	.long	JXBOX
	.word	mug1_x+(x_space*3),mug1_y+(y_space*1)

	.long	FN2BOX
	.word	mug1_x,mug1_y+(y_space*2)
	.long	UGBOX
	.word	mug1_x+(x_space*1),mug1_y+(y_space*2)
	.long	SCBOX
	.word	mug1_x+(x_space*2),mug1_y+(y_space*2)
	.long	RDBOX
	.word	mug1_x+(x_space*3),mug1_y+(y_space*2)

	.long	0


p_mychar		.set	p_store6
p_hischar	.set	p_otherproc


fl_cursor1
	.word	bpal_flash1,4
	.word	0000000111100000b
	.word	0000001111100000b
	.word	end_stuff

fl_cursor2
	.word	bpal_flash2,4
	.word	0011110000000000b
	.word	0111110000000000b
	.word	end_stuff

fl_auto	.word	bpal_flash3,4
	.word	>ffff
	.word	rgb_blue
	.word	end_stuff


psel_drone_2
	movi	oid_p2,a0
	calla	dallobj			; kill any previous objects
	movi	pid_p2,a0
	calla	dallprc			; kill any previous procs

	calla	make_player_2_obj
	movi	scrrgt->24,a0
	jruc	psd4

psel_drone_1
	movi	oid_p1,a0
	calla	dallobj			; kill any previous objects
	movi	pid_p1,a0
	calla	dallprc			; kill any previous procs

	calla	make_player_1_obj
	movi	>25,a0
psd4	move	a0,*a8(oxpos),w		; position to the left of the mugshots
	calla	insobja8
	calla	stance_setup

psel_drone_loop
	sleep	1
	calla	next_anirate

	move	*a8(oid),a7,w
	cmpi	2,a7			; player 2 ?
	jrne	psel_drone_loop		; no, palette is fine
*
* player 2 ---> check if alternate palette is needed
*
	move	@p1_char,a0,w
	move	*a8(ochar),a7,w		; a7 = my ochar

	move	*a8(oflags2),a4,w
	btst	b_ugly_pal,a4
	jrne	psd8			; using alternate pal

	cmp	a0,a7			; player 1 same character as me ?
	jrne	psel_drone_loop		; no
	ori	m_ugly_pal,a4
	move	a4,*a8(oflags2),w	; set alternate palette bit
	jruc	psd9

psd8	cmp	a0,a7			; player 1 same character as me ?
	jreq	psel_drone_loop		; yes

	andni	m_ugly_pal,a4
	move	a4,*a8(oflags2),w	; clear alternate palette bit
  	movi	character_palettes_1,a0
	jruc	psda

psd9	movi	character_palettes_2,a0
psda	calla	get_char_long
	calla	player_swpal
	jruc	psel_drone_loop

**************************************************************************

menu_to_ochar
	sll	4,a0
	addi	mto_table,a0
	move	*a0,a0,w
	rets

mto_table
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

ochar_to_menu
	sll	4,a0
	addi	otm_table,a0
	move	*a0,a0,w
	rets

otm_table
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

;box_xlate
;	move	*a0,a1,w
;	jrn	bx9
;	sll	4,a1
;	addi	xlate_table,a1
;	move	*a1,a1,w
;	move	a1,*a0,w		; new p?_ochar value
;bx9	rets
;
;xlate_table
;	.word	1
;	.word	0
;	.word	2
;	.word	9
;	.word	8
;	.word	6
;	.word	4
;	.word	11
;	.word	5
;	.word	3
;	.word	10
;	.word	7

**************************************************************************
*											     *
*  player select process						     			*
*											     *
**************************************************************************
p2_select
	create	pid_p2,psel_drone_2

	movi	fl_cursor2,a11
	create	pid_fx,boonpal_stuff		; flash letters
	move	a0,*a13(p_store2),l		; save cursor flash process

	movi	switch+8,a0
	move	a0,*a13(p_joyport),l
	movi	switch+33,a0
	move	a0,*a13(p_butport),l		; look at player 2 controls

	movi	p2_char,a0
	move	a0,*a13(p_mychar),l		; pointer to my "char"
	movi	p1_char,a0
	move	a0,*a13(p_hischar),l		; pointer to his "char"

	movi	>0202,a11
	movk	9,a4						; 1st ochar choice
	movi	(mug1_x-cthick)+(x_space*3),a5  	; initial x
	movi	mug1_y-cthick,a6	 		 	; initial y

	movk	11,b4						; 2nd ochar choice
	movi	(mug1_x-cthick)+(x_space*3),b5  	; initial x
	movi	mug1_y-cthick+y_space,b6 	  	 	; initial y
	movi	oid_cursor2,a2
	jruc	curs3


p1_select
	create	pid_p1,psel_drone_1

	movi	fl_cursor1,a11
	create	pid_fx,boonpal_stuff		; flash letters
	move	a0,*a13(p_store2),l		; save cursor flash process

	movi	switch,a0
	move	a0,*a13(p_joyport),l
	movi	switch+25,a0
	move	a0,*a13(p_butport),l		; look at player 1 controls

	movi	p1_char,a0
	move	a0,*a13(p_mychar),l		; pointer to my "char"
	movi	p2_char,a0
	move	a0,*a13(p_hischar),l		; pointer to his "char"

	movi	>0101,a11			; color to use
	movk	1,a4		 		; 1st ochar choice
	movi	mug1_x-cthick,a5	 	; initial x
	movi	mug1_y-cthick,a6	 	; initial y

	clr	b4				; 2nd ochar choice
	movi	mug1_x-cthick+x_space,b5 	; initial x
	movi	mug1_y-cthick,b6 		; initial y
	movi	oid_cursor1,a2

curs3	move	a2,*a13(p_store4),w
	move	*a13(p_hischar),a0,l		; where is he ?
	move	*a0,a0,w
	jrn	curs2				; not in ---> we cool
	cmp	a0,a4
	jrne	curs2
*
* other dude is already on this spot
*
	move	b4,a4
	move	b5,a5
	move	b6,a6	   		; use alternate spot

curs2	move	*a13(p_mychar),a0,l
	move	a4,*a0,w

	movi	cursor_table,a0
	move	@ofree,a9,l		; a9 = previous cursor object
	move	a9,a10

curs4	mmtm	sp,a0,a5,a6
	move	a11,a0			; a0 = constant color to use
	calla	make_solid_object
	calla	set_noscroll
	mmfm	sp,a0,a5,a6

	move	*a13(p_store4),a2,w
	move	a2,*a8(oid),w		; set oid of cur

	move	*a0+,a3,w
	move	a3,*a8(osizex),w	; define x size
	move	*a0+,a2,w
	move	a2,*a8(osizey),w	; define y size
	sll	16,a2
	or	a2,a3			; a3 = y:x size

	move	a8,*a9(oslink),l	; link cursor object together
	move	a11,*a8(oconst),w	; color of cursor

	move	*a0+,a1,w
	add	a5,a1
	move	a1,*a8(oxpos),w
	move	*a0+,a1,w
	add	a6,a1
	move	a1,*a8(oypos),w		; set coordinates

	push	a0
	calla	insobj2a8
	pull	a0
	move	a8,a9

	cmpi	cursor_table_end,a0
	jrne	curs4
*
* now do the player # indicator part of the cursor
*
	movi	solid_object_img,a5
	calla	gso_dmacnz

	move	*a13(p_store4),a2,w
	move	a2,*a8(oid),w			; set oid of cursor #

	movi	MK2FONT1,a1			; a1 = character shape
	movi	>10,a5				; a5 = y offset in box
	move	*a13(procid),a0,w
	cmpi	pid_p1sel,a0
	jreq	curs5
	movi	MK2FONT2,a1			; a1 = character shape
	movi	>30,a5	 			; a5 = y offset in box
curs5	calla	ani_flag

	move	a8,*a9(oslink),l		; link cursor object together
	move	*a9(oconst),*a8(oconst),w

	move	*a9(oypos),a0,w
	add	a5,a0
	move	a0,*a8(oypos),w			; y offset
	move	*a9(oxpos),a0,w
	subi	>1d,a0
	move	a0,*a8(oxpos),w			; centered in x
	calla	insobja8

	clr	a0
	move	a0,*a8(oslink),l	; last object = 0 link
	move	a10,a8			; a8 = 1st object of cursor

**************************************************************************
*											     *
*   scan joystick / buttons								     *
*											     *
**************************************************************************

cmove2	clr	a10			; a10 = joystick debounce
cmove3	sleep	1

psel_cursor_loop
	move	a10,a10
	jreq	cmove4
	dec	a10

cmove4	move	@switch,a0,l
	not	a0			  	; a0 = bit state ?
	move	@switch2,a1,l
	not	a1

	movi	p1b0|p1b2|p1b3|p1sf2,a2	; player 1 port 1 mask
	movi	p1b1|p1b4,a3			; player 1 port 2 mask
	move	*a13(procid),a7,w
	cmpi	pid_p1sel,a7
	jreq	cmove41

	movi	p2b0|p2b2|p2b3|p2sf2,a2	; player 2 port 1 mask
	movi	p2b1|p2b4,a3			; player 2 port 2 mask

cmove41	and	a2,a0
	jrne	cmove9			; choice made !!
	and	a3,a1
	jrne	cmove9			; choice made !!
	
	calla	joystick_in_a0		; any joystick movement ?
	jreq	cmove3			; no
	move	a10,a10			; still debouncing joystick ?
	jrne	cmove3			; yes, wait

	movk	12,a10			; joystick debounce speed
	move	*a13(p_mychar),a1,l
	move	*a1,a1,w		; a1 = my current ochar
*
* joystick = up
*
cmove5	btst	0,a0
	jreq	cmove6

	movi	upsans,a2
	callr	is_move_legal		; is this move legal ?
	jrnc	cmove6

	movi	up_change,a2
	clr	a3
	movi	-y_space,a4		; delta y
	jruc	new_cursor_position
*
* joystick = down
*
cmove6	btst	1,a0
	jreq	cmove7

	movi	dnsans,a2
	callr	is_move_legal		; is this move legal ?
	jrnc	cmove7

	movi	down_change,a2
	clr	a3
	movi	y_space,a4		; delta y
	jruc	new_cursor_position
*
* joystick = left
*
cmove7	btst	2,a0
	jreq	cmove8

	movi	lfsans,a2
	callr	is_move_legal		; is this move legal ?
	jrnc	cmove8

	movi	left_change,a2
	movi	-x_space,a3		; delta x
	clr	a4
	jruc	new_cursor_position
*
* joystick = right
*
cmove8	btst	3,a0
	jreq	cmove3

	movi	rtsans,a2
	callr	is_move_legal		; is this move legal ?
	jrnc	cmove3

	movi	right_change,a2
	movi	x_space,a3		; delta x
	clr	a4
	jruc	new_cursor_position
*
* button pressed ---> choice is made
*
cmove9	move	*a13(p_mychar),a0,l
	move	a0,a2
	move	*a0,a0,w		; a0 = my choice

	mmtm	sp,a0,a10
	move	a0,a10
	create	pid_selspeech,select_speech
	mmfm	sp,a0,a10

	movi	pid_master,a0
	calla	exprc_er		; a0 = master proc (or else)
	move	*a0(p_store1),a1,l	; a1 = 1st mugshot object

	move	*a2,a0,w
	move	a0,*a13(p_store1),w
	callr	ochar_to_menu		; xlate to menu position
	jreq	cmoveb			; zero ---> we got our object
cmovea	move	*a1(oslink),a1,l
	dsjs	a0,cmovea
cmoveb

*
* flash the mugshot chosen
*
	move	a1,a8
	movi	bpal_white,a0
	move	a0,*a8(oconst),w	; use this constant color

	movi	>2c,b1
	movi	>2d,b2
	callr	cursor_sound

	movi	>f002,a9		; normal flags
	movi	>f00c,a10		; white flags

	move	@p1_char,a6,w
	movi	pid_p1,a3
	movi	pid_p2sel,a1		; assume we are looking for 2 !
	move	*a13(procid),a5,w
	cmpi	pid_p1sel,a5
	jreq	look2

	move	@p2_char,a6,w
	movi	pid_p2,a3
	movi	pid_p1sel,a1		; we are lookin for 1 !!

look2	push	a1			; save pid of other player cursor !!!
	move	a3,a0
	calla	exprc_er		; a0 = dude doing the stance proc
	movi	victory_animation,a7
	calla	fastxfer
	move	a6,a0
	addi	aud_choose_hh,a0
	calla	aud1			; audit: chose this character
	pull	a0			; a0 = pid of other cursor proc

	clr	a1
	not	a1
	calla	existp			; a0 = other proc flashing ?
	jreq	look3			; sans

	move	*a0(pwake),a7,l
	cmpi	i_am_flashing,a7	; is he flashing a cursor too ??
	jrne	look3			; sans

	move	*a0(pa8),a1,l
	cmp	a8,a1	     		; he flashing the same as me ??
	jrne	look3			; no

	push	a0
	move	*a0(p_store4),a0,w
	calla	dallobj			; kill his cursor objects
	pull	a0
	calla	kill			; yes, sorry there can be only one !

look3	movk	6,a11
look4	movi	boonpal,a0
	move	a10,*a8(oflags),w	; white flag
	jsrp	flash_sleep

	move	a9,*a8(oflags),w	; back to normal flags
	move	*a8(oimg),a1,l
	move	*a1(icmap),a0,l		; get back old palette
	jsrp	flash_sleep

	dsj	a11,look4

	move	*a13(p_store1),a0,w	; get char offset
	sll	5,a0
	addi	picked_palettes,a0
	move	*a0,a0,l
	calla	swpal			; dim down

	move	*a13(p_store4),a0,w
	calla	dallobj

	movi	ps_post_psel,a0		; new player state
	movi	p1_state,a2
	move	*a13(procid),a1,w
	cmpi	pid_p1sel,a1
	jreq	cmoved
	movi	p2_state,a2
cmoved	move	a0,*a2,w		; my player state = post player select
	die


flash_sleep
	calla	swpal			; switch to boonpal
	sleep	2
i_am_flashing
	retp

**************************************************************************
*											     *
*  select_speech - make a speech call for the choice that was selected   *
* 											     *
*  input: a10 = offset									     *
*											     *
**************************************************************************
select_speech
	sleep	8

selsp1	clr	a1
	not	a1
	movi	pid_selspeech,a0
	calla	existp
	jreq	selsp3			; dont interupt another proc

	move	*a0(pwake),a0,l
	cmpi	selsp1,a0		; has he made a speech call yet ?
	jreq	selsp3			; no, make mine now
	sleep	1
	jruc	selsp1			; yes ---> wait till he is done

selsp3	addi	>1c,a10
	move	a10,a0
	calla	triple_sound2
	sleep	>30
	die

**************************************************************************
*											     *
*  is_move_legal - answers this questions with a carry			     *
* 											     *
*  input: a2 = table of sans values.							     *
*											     *
**************************************************************************
is_move_legal
	move	*a2+,a3,w		; grab a table entry
	cmp	a1,a3			; sans ??
	jreq	imlno
	move	*a2+,a3,w		; grab a table entry
	cmp	a1,a3			; sans ??
	jreq	imlno
	move	*a2+,a3,w		; grab a table entry
	cmp	a1,a3			; sans ??
	jreq	imlno
	move	*a2+,a3,w		; grab a table entry
	cmp	a1,a3			; sans ??
	jreq	imlno
	move	*a2+,a3,w		; grab a table entry
	cmp	a1,a3			; sans ??
	jreq	imlno
	setc
	rets

imlno	clrc
	rets

upsans	.word	0,1,2,9,9
dnsans	.word	5,3,10,7,7
lfsans	.word	1,8,5,5,5
rtsans	.word	9,11,7,7,7

**************************************************************************
*											     *
*  cursor_sound - make a cursor sound							     *
* 											     *
*  input: b1 = player 1 sound								     *
*         b2 = player 2 sound								     *
*											     *
**************************************************************************
cursor_sound
	mmtm	sp,a0,a3,a4
	move	*a13(procid),a0,w
	cmpi	pid_p1sel,a0
	jreq	csnd3
	move	b2,b1			; player 2 use sound #2
csnd3	move	b1,a0
	calla	triple_sound2
	mmfm	sp,a0,a3,a4
	rets

up_change
	.word	ft_hathead	; 0 - kung lao
	.word	ft_kang		; 1 - liu kang
	.word	ft_cage		; 2 - cage
	.word	ft_st		; 3 - baraka
	.word	ft_cage		; 4 - kitana
	.word	ft_subzero	; 5 - mileena
	.word	ft_hathead	; 6 - shang tsung
	.word	ft_jax		; 7 - raiden
	.word	ft_kang		; 8 - subzero
	.word	ft_reptile	; 9 - reptile
	.word	ft_fn1		; 10 - scorpion
	.word	ft_reptile	; 11 - jax

down_change
	.word	ft_st           ; 0 - kung lao 
	.word	ft_subzero	; 1 - liu kang
	.word	ft_fn1		; 2 - cage
	.word	ft_sa		; 3 - baraka
	.word	ft_scorpion	; 4 - kitana
	.word	ft_fn2		; 5 - mileena
	.word	ft_sa		; 6 - shang tsung
	.word	ft_raiden	; 7 - raiden
	.word	ft_fn2		; 8 - subzero
	.word	ft_jax		; 9 - reptile
	.word	ft_scorpion	; 10 - scorpion
	.word	ft_raiden	; 11 - jax

left_change
	.word	ft_kang		; 0 - kung lao
	.word	ft_kang		; 1 - liu kang
	.word	ft_hathead	; 2 - cage
	.word	ft_fn2		; 3 - baraka
	.word	ft_st		; 4 - kitana
	.word	ft_fn2		; 5 - mileena
	.word	ft_subzero	; 6 - shang tsung
	.word	ft_scorpion	; 7 - raiden
	.word	ft_subzero	; 8 - subzero
	.word	ft_cage		; 9 - reptile
	.word	ft_sa		; 10 - scorpion
	.word	ft_fn1		; 11 - jax

right_change
	.word	ft_cage		; 0 - kung lao
	.word	ft_hathead	; 1 - liu kang
	.word	ft_reptile	; 2 - cage
	.word	ft_scorpion	; 3 - baraka
	.word	ft_jax		; 4 - kitana
	.word	ft_sa		; 5 - mileena
	.word	ft_fn1		; 6 - shang tsung
	.word	ft_raiden	; 7 - raiden
	.word	ft_st		; 8 - subzero
	.word	ft_reptile	; 9 - reptile
	.word	ft_raiden	; 10 - scorpion
	.word	ft_jax		; 11 - jax


**************************************************************************
*											     *
*  new_cursor_position - handles moving cursor to a new position, hence  *
*                        the name...							     *
* 											     *
*  input: a1 = current ochar									*
*         a2 = position change for new spot					     *
*         a3 = coordinate delta x							     *
*         a4 = corrdinate delta y							     *
*											     *
**************************************************************************
new_cursor_position
	sll	4,a1
	add	a2,a1			; direction table
	move	*a1,a1,w		; new ochar
	move	*a13(p_mychar),a5,l
	move	a1,*a5,w		; update my new ochar

	movi	>2a,b1
 	movi	>2b,b2
	callr	cursor_sound

	move	a8,a7
ncp4	move	*a7(oxpos),a5,w
	add	a3,a5
	move	a5,*a7(oxpos),w
	move	*a7(oypos),a5,w
	add	a4,a5
	move	a5,*a7(oypos),w		; do the deltas !!
	move	*a7(oslink),a7,l
	jrne	ncp4
*
* display new choice a fight'n
*
	movi	pid_p1,a1
	movi	psel_drone_1,a7

	move	*a13(procid),a0,w
	cmpi	pid_p1sel,a0
	jreq	ncp5

	movi	pid_p2,a1
	movi	psel_drone_2,a7

ncp5	calla	getprc
      	jruc	cmove3


cursor_table
	.word	x_size+4+4,4
	.word	0,0		; x:y size / x:y offset (top)
	.word	x_size+4+4,4
	.word	0,y_size+4	; x:y size / x:y offset (bottom)
	.word	4,y_size+4+4
	.word	0,0		; x:y size / x:y offset (left)
	.word	4,y_size+4+4
	.word	x_size+4,0	; x:y size / x:y offset (right)
cursor_table_end

;*********************************************************************

picked_palettes
	.long	BOX2D_P		; hathead
	.long	BOX8D_P		; kang
	.long	BOX9D_P		; cage
	.long	BOX12D_P	; sword arms
	.long	BOX6D_P		; fn1
	.long	BOX7D_P		; fn2
	.long	BOX4D_P		; shang
	.long	BOX5D_P		; raiden
	.long	BOX1D_P		; subzero
	.long	BOX10D_P	; reptile
	.long	BOX11D_P	; scorpion
	.long	BOX3D_P		; jax



; make sure this displays 1/2 credits (ejbejbejb)
**************************************************************************
*											     *
*  show_credits - show credits during the player select menu	     	*
*											     *
**************************************************************************
show_credits
	jsrp	print_credits

msc4	calla	get_credits
	move	a0,a10	  	; a10 = latest # of credits
	sleep	2
	calla	get_credits
	cmp	a0,a10
	jreq	msc4

	movi	objlst2,a2
	calla	delolist
	jruc	show_credits


print_credits
	movi	coin_mess,a8
	move	@gstate,a0,w
	cmpi	gs_buyin,a0
	jrne	pcred4
	movi	buyin_coin_mess,a8	; buyin ---> position inside box

pcred4	calla	lm_setup
	calla	get_cstr  		; get the current credits
	jauc	printf

coin_mess
	mess_mac  rd11font,spacing20,200,>e9,bpal_yellow*>10000,strcnrmos,0
        .even

buyin_coin_mess
	mess_mac  rd11font,spacing20,200,>e9,bpal_yellow*>10000,strcnrmos,0
        .even

**************************************************************************

BOX1D_P:
	.word   128
	.word   00000h,00007h,00003h,00000h,00000h,00000h,01c64h,00402h
	.word   00000h,00000h,00000h,00005h,00000h,00000h,00000h,00000h
	.word   00c01h,02ce8h,02d0ah,00006h,00000h,020c7h,00000h,00000h
	.word   00008h,0000bh,0000ch,0000ah,00000h,0314ch,035d0h,00000h
	.word   0000eh,00010h,00000h,00001h,024ebh,00000h,00050h,00032h
	.word   00053h,00000h,0358eh,03614h,00000h,00002h,00054h,00075h
	.word   00047h,00000h,000b5h,00000h,01044h,00000h,000f5h,00115h
	.word   000d3h,0000bh,00000h,02087h,01486h,00002h,00000h,00135h
	.word   00134h,00c03h,00154h,00175h,01194h,00000h,00000h,0000bh
	.word   00009h,0000fh,0002dh,000b1h,00115h,00092h,00001h,00005h
	.word   00000h,00113h,00090h,000d1h,0004fh,00112h,00db5h,0000ah
	.word   000d1h,0000ch,00400h,000f3h,014c7h,010ech,01d4fh,020a5h
	.word   00000h,00000h,00000h,00000h,00009h,00009h,0000bh,00009h
	.word   0000ah,0004bh,00028h,00009h,0000ah,0088ah,00888h,0002bh
	.word   010abh,00002h,01cebh,00004h,0254ch,02d4bh,010a8h,00825h
	.word   0254eh,004cfh,0190eh,00009h,0000ah,00004h,0000bh,0002fh

BOX2D_P:
	.word   127
	.word   00000h,00005h,00808h,0102ah,0184ah,028cah,03d4eh,01c67h
	.word   00c05h,00405h,00000h,00000h,00000h,00004h,00004h,00003h
	.word   00007h,00007h,020c9h,024ceh,00c03h,00003h,00001h,00006h
	.word   00005h,00009h,00008h,00007h,00005h,00c47h,00807h,00000h
	.word   00003h,00004h,00007h,00003h,00004h,00002h,00003h,00003h
	.word   00001h,00004h,00002h,00008h,00003h,00002h,0000bh,0084dh
	.word   00006h,00001h,00c6eh,00406h,02113h,00004h,00006h,035b8h
	.word   014b0h,00007h,00006h,00005h,0004dh,000d1h,020adh,03132h
	.word   02d11h,00c06h,00001h,00006h,0188dh,03dd6h,03974h,00003h
	.word   0025dh,001b8h,03572h,00005h,049d6h,00004h,0248ch,00c05h
	.word   00404h,00002h,00007h,0523ah,00001h,00000h,00001h,0529ch
	.word   0514eh,02c8ah,05219h,00003h,00006h,01407h,038cch,02534h
	.word   0421bh,0463ch,0529fh,00008h,02d76h,0525ch,00c6dh,01cd0h
	.word   020f1h,02d54h,03175h,00c4dh,00071h,0000dh,00492h,008b3h
	.word   00cf5h,0000bh,01515h,0004eh,01936h,02178h,02598h,02ddah
	.word   0361ch,03a3dh,01913h,035fbh,02577h,031fch,01136h

BOX3D_P:
	.word   128
	.word   00000h,04e16h,0452eh,01002h,02446h,038cbh,034a9h,038c9h
	.word   034aah,02468h,038cch,040ech,0410bh,00005h,04e59h,04db2h
	.word   02c87h,04d8eh,034c9h,02c89h,038aah,040eah,03069h,01408h
	.word   00805h,01803h,03d0bh,034a6h,0390eh,03ca9h,04970h,03067h
	.word   01c49h,01005h,049d5h,00802h,02009h,034cbh,01c25h,00001h
	.word   03952h,01000h,00000h,02023h,00006h,02003h,00000h,00000h
	.word   00001h,02004h,04e13h,01c03h,00001h,028adh,00c09h,0346ch
	.word   00002h,02c6ch,01404h,00806h,00000h,00000h,0146dh,00000h
	.word   00005h,01452h,0040ch,00007h,00001h,00002h,00005h,03179h
	.word   02979h,02957h,00008h,00002h,0359ah,01cf6h,0000ah,01c8dh
	.word   00472h,0000dh,024f0h,02932h,03996h,02d9ah,045d9h,00002h
	.word   00829h,03575h,04e7ch,02004h,00008h,0000ah,00006h,0000ah
	.word   0000dh,0000dh,0044eh,0000eh,0000dh,00004h,0000ah,00011h
	.word   0000dh,00003h,00010h,00002h,00014h,00013h,03d92h,00031h
	.word   00014h,00001h,00055h,00003h,00002h,0002eh,00009h,00003h
	.word   00c07h,02d97h,00c02h,010b2h,00005h,01d59h,008b3h,00003h
BOX4D_P:
	.word   128
	.word   00000h,00000h,00000h,04945h,00802h,03501h,0184dh,0082bh
	.word   00001h,00003h,00001h,00006h,00005h,00406h,0180ah,01827h
	.word   02427h,0242ah,0384ah,01802h,04942h,024a5h,01885h,04e00h
	.word   00400h,049a9h,00001h,01461h,00002h,00004h,00002h,01409h
	.word   0388bh,049a6h,03129h,018aah,00004h,04dd2h,00008h,00000h
	.word   01407h,0288ah,034ceh,0410fh,049ech,04e0eh,0398fh,018afh
	.word   04e56h,00809h,03d0eh,04e32h,039b2h,00c26h,04952h,04e3ah
	.word   039b6h,00001h,00002h,00004h,0244ch,02d09h,00005h,00002h
	.word   00002h,04db6h,03d89h,03945h,01ca3h,00405h,0384dh,00402h
	.word   00003h,03d12h,02809h,040aeh,02806h,02c8eh,034f1h,044d1h
	.word   00803h,00004h,024d1h,03955h,02003h,00006h,01806h,00404h
	.word   04575h,01802h,01005h,02406h,00c6fh,02913h,014b1h,02535h
	.word   00009h,049f9h,04e7dh,0042dh,02808h,03598h,03409h,0406dh
	.word   03007h,0404ah,03427h,049fch,03007h,00005h,02cf4h,0000bh
	.word   0240ch,0340dh,00006h,0000ah,0000ch,00006h,00002h,00008h
	.word   03cf4h,0000ch,00808h,00002h,0000ah,0000bh,00008h,00007h
BOX5D_P:
	.word   126
	.word   00000h,00091h,0000dh,00005h,00002h,00004h,00009h,0000dh
	.word   00c71h,00009h,00115h,0021fh,001bah,00006h,0319ah,00000h
	.word   02117h,00010h,00000h,04a5fh,00411h,0000eh,0000ch,0000bh
	.word   0000ah,00009h,01495h,0000dh,0000bh,00009h,00002h,02939h
	.word   00c53h,00006h,00009h,01cd6h,0000fh,00009h,00006h,00001h
	.word   00000h,00010h,00002h,00002h,00004h,00006h,00005h,00006h
	.word   00408h,00006h,0142ah,01c4ah,0248dh,03531h,024d1h,00001h
	.word   0204ch,0248ah,04531h,028edh,038efh,030adh,00003h,04a16h
	.word   04a3ah,049b5h,02d0fh,01406h,01406h,00001h,00402h,02427h
	.word   0412eh,030abh,0144dh,0186ah,04591h,00000h,00004h,03cadh
	.word   00002h,00c09h,030b0h,01001h,02005h,03449h,00000h,00002h
	.word   0350ch,00001h,00000h,01002h,028f0h,03995h,03554h,049d8h
	.word   04554h,00009h,0000dh,014f2h,0186dh,00006h,00005h,0002fh
	.word   000d3h,000f5h,00005h,00007h,0458eh,00805h,0394eh,04a12h
	.word   0310ch,0412ah,0392dh,0350bh,034e6h,02881h,030a4h,00808h
	.word   0396fh,03ddch,0312fh,03971h,039dch,02979h
BOX6D_P:
	.word   126
	.word   00000h,0598ch,00010h,00075h,00898h,0091dh,000bbh,0007bh
	.word   00019h,0001dh,00015h,0193dh,0529eh,00447h,02cech,0390bh
	.word   06319h,0633eh,062d6h,06274h,06252h,06211h,0000dh,00009h
	.word   00010h,00495h,0197eh,0005ah,00015h,0000dh,05e9dh,04df6h
	.word   04990h,04909h,00008h,0040fh,00034h,0259eh,00018h,00010h
	.word   06299h,05a35h,00000h,00003h,00098h,03d71h,03d09h,061edh
	.word   059b0h,00004h,00009h,04d4ah,03883h,04905h,04d6dh,038c6h
	.word   040a7h,00cf9h,0596ah,01915h,02159h,01919h,02cc9h,02841h
	.word   00004h,00472h,00072h,02c65h,0000eh,028a8h,01c01h,00001h
	.word   00800h,0000ah,01c66h,00055h,0011dh,00cd4h,000dah,00c68h
	.word   00d7eh,00005h,01cech,02970h,01c89h,008bbh,049b4h,05218h
	.word   03155h,05a3ah,0142bh,03d30h,01405h,00c02h,04df0h,01400h
	.word   0452dh,052bah,00803h,01027h,01045h,0394ch,014abh,02d78h
	.word   00018h,0001dh,035d3h,00001h,01803h,00c05h,01424h,01402h
	.word   00802h,00803h,00002h,00003h,00002h,02447h,02403h,02802h
	.word   00002h,00000h,00000h,00001h,00004h,00003h
BOX7D_P:
	.word   128
	.word   00000h,05adeh,049f6h,045b3h,040edh,03ccah,02c46h,02005h
	.word   01001h,00401h,00002h,00000h,00007h,00c0ah,00408h,0100bh
	.word   0140ch,01c0eh,02410h,03414h,02c12h,00000h,0412fh,03489h
	.word   00000h,00004h,0200fh,0180dh,03c16h,04417h,02811h,03013h
	.word   04571h,00809h,04c19h,03815h,01404h,04e38h,040cch,00000h
	.word   051f5h,051d3h,04d92h,00006h,03013h,03c16h,03815h,00005h
	.word   00000h,00429h,02531h,04438h,01428h,00002h,00003h,00001h
	.word   00004h,00003h,00001h,00002h,00005h,00808h,00005h,034ach
	.word   02448h,00004h,00003h,00006h,0180dh,00006h,03814h,0200fh
	.word   02811h,02c12h,03414h,04c59h,04c9ah,050bbh,00007h,04498h
	.word   02410h,050fah,0511bh,00408h,01405h,02c47h,014adh,0581ch
	.word   01009h,00005h,00000h,0350eh,02869h,04d50h,028ach,00002h
	.word   02d73h,00005h,03530h,049f7h,00807h,00c2fh,0180fh,0240fh
	.word   0140ch,0040ch,0000dh,0100eh,00009h,0000ch,0000ah,0000bh
	.word   0000bh,0080dh,0040ah,0240fh,0100ah,0200eh,0340fh,0240dh
	.word   0300eh,00008h,03010h,03c10h,0080ah,0100ah,02c0eh,03c0eh
BOX8D_P:
	.word   126
	.word   00000h,02803h,01c02h,05237h,052dfh,052dfh,052bbh,05298h
	.word   05215h,04990h,04170h,00802h,0350dh,028abh,030ech,0392eh
	.word   02d0fh,028a8h,049b3h,051f1h,01827h,01002h,03c02h,03d4fh
	.word   00c07h,00c04h,030e9h,00802h,00c02h,038ach,00002h,00c06h
	.word   03d93h,00804h,01402h,00002h,0208ch,00002h,0498dh,02068h
	.word   00005h,034c9h,02c28h,00002h,03909h,0350eh,03950h,00002h
	.word   05130h,03d50h,03d0eh,03910h,00002h,00003h,00004h,02d74h
	.word   00002h,02402h,01c05h,00005h,020aeh,02cceh,00006h,00007h
	.word   00008h,00008h,0106ch,03953h,00005h,00007h,00004h,00008h
	.word   00005h,00003h,00003h,0525ah,00004h,018f1h,00003h,0423ch
	.word   02d32h,0529eh,04dd6h,00004h,041d7h,01406h,04219h,02db8h
	.word   02133h,00004h,01c03h,0102ah,02802h,00004h,02c02h,03ccfh
	.word   01c4ah,00004h,05152h,04c8ch,04407h,01c02h,01402h,050ceh
	.word   0504ah,02804h,03c49h,02c02h,03005h,03402h,02c02h,02004h
	.word   02006h,01804h,02804h,02c02h,03002h,03402h,03482h,030a2h
	.word   00006h,00008h,0000ah,00004h,00004h,02802h
BOX9D_P:
	.word   128
	.word   00000h,04a5fh,04554h,04995h,04131h,0410eh,04951h,034cdh
	.word   02c6bh,02449h,0286bh,0242bh,0288dh,030aeh,038eeh,03511h
	.word   0308eh,0282ch,00406h,01408h,034ceh,03ccfh,03cf0h,04932h
	.word   04972h,034d0h,0202ah,02029h,01407h,0306ch,030adh,00007h
	.word   04a5ch,04a1ah,01809h,01006h,00008h,049f7h,049b8h,00402h
	.word   00002h,04511h,00009h,0348dh,0000bh,0000ah,00002h,0000eh
	.word   01c09h,0000ch,00432h,028f0h,00010h,014b5h,024d0h,034ebh
	.word   01cf7h,01093h,028efh,02539h,04132h,00854h,0319bh,03972h
	.word   01c07h,0240ah,0200ah,02c4ch,039dch,02c4bh,01c08h,02409h
	.word   03dfdh,0421eh,00000h,00009h,00005h,03555h,03cd0h,0348eh
	.word   04512h,00001h,00005h,03996h,00c03h,04112h,0144dh,01003h
	.word   00001h,00000h,00002h,00000h,00408h,00005h,00001h,00003h
	.word   00002h,0040eh,00004h,00002h,00009h,00007h,00003h,00005h
	.word   00408h,00011h,00007h,00001h,0001fh,00019h,00004h,00004h
	.word   03e3fh,0000dh,0000bh,00016h,00001h,00004h,0000eh,00009h
	.word   00073h,021bbh,00003h,00002h,00009h,00002h,00005h,04a1ch

BOX10D_P:
	.word   128
	.word   00000h,00001h,00001h,00062h,00002h,00021h,00002h,00009h
	.word   0044ch,00002h,00004h,00c8eh,0000ah,00001h,00103h,0000ah
	.word   00041h,000a2h,000c3h,05221h,014d1h,00006h,0000ah,00000h
	.word   00002h,00009h,0000ah,00009h,0000bh,00001h,00001h,0000ch
	.word   00002h,00001h,00002h,00002h,0000ch,00104h,00164h,002a7h
	.word   001a5h,0000bh,00008h,00007h,00006h,0002ch,00005h,0000ch
	.word   00005h,0000ch,0004dh,0046fh,0004eh,00206h,00246h,0002eh
	.word   0042fh,00007h,02ab4h,01ab4h,0026eh,00205h,00870h,00008h
	.word   012afh,052bdh,001e5h,00005h,00a71h,002abh,0022ah,00008h
	.word   001e6h,01805h,038e9h,05233h,04dcfh,02445h,0498fh,0396eh
	.word   00400h,01c46h,0390eh,04592h,05256h,0288ah,01c28h,00000h
	.word   04df6h,04e79h,028adh,02ceeh,00806h,01c69h,0088fh,00cb1h
	.word   04e1ah,03d72h,02d20h,00005h,010d2h,039b6h,04594h,014d2h
	.word   00002h,00405h,00891h,01009h,00005h,010b2h,03151h,00002h
	.word   0104ah,00004h,01d34h,01913h,02977h,02156h,031b8h,039d9h
	.word   03dd9h,039b8h,041fah,01d13h,014b0h,02535h,0004dh,0002eh

BOX11D_P:
	.word   127
	.word   00000h,0367fh,03676h,0365bh,03651h,0364fh,0362bh,035fah
	.word   035efh,03606h,03604h,029dbh,03601h,035b7h,035e7h,035e4h
	.word   035e3h,035cah,035e1h,035c1h,03573h,029abh,03175h,031a3h
	.word   029a7h,031a1h,03581h,01d78h,02955h,02d81h,0254fh,02566h
	.word   02932h,03129h,03521h,03505h,02141h,034e3h,0192ch,034e1h
	.word   01d26h,020f2h,034a6h,034c1h,034a1h,034a1h,03483h,03466h
	.word   020d0h,01cd1h,03461h,01901h,02ca1h,03441h,03423h,018cch
	.word   00cebh,03421h,018afh,014e1h,03401h,02c21h,03401h,03401h
	.word   03401h,02c03h,02c01h,03401h,008a8h,03401h,0106dh,02c01h
	.word   00c6eh,03001h,01c21h,02401h,00881h,03001h,02c01h,02401h
	.word   02c01h,01c02h,00005h,02401h,0042bh,00442h,02801h,02401h
	.word   00026h,00026h,02801h,01c01h,02401h,00021h,0000ah,0000dh
	.word   02001h,01c01h,0000ah,00405h,00009h,01401h,00802h,00001h
	.word   01801h,00001h,01401h,00007h,00009h,00007h,00002h,00007h
	.word   00801h,00004h,00001h,00006h,00005h,00001h,00002h,00002h
	.word   00005h,00001h,00005h,00004h,00001h,00002h,00001h

BOX12D_P:
	.word   128
	.word   00000h,00007h,0000ah,0000ah,0000eh,00001h,00002h,00007h
	.word   0102ah,0148fh,02137h,018f4h,00c6fh,00c0ah,00c02h,00005h
	.word   010d3h,00002h,00002h,00001h,01406h,02027h,0204ah,0208bh
	.word   020aeh,030ceh,03132h,0467dh,03e1bh,02d56h,031bbh,02cabh
	.word   0350fh,035b6h,045d6h,02cf1h,03a1dh,01002h,041fah,00001h
	.word   0463eh,0467fh,00c06h,00001h,00001h,00002h,04152h,01c6dh
	.word   00003h,00003h,00003h,00001h,045feh,00006h,00004h,00002h
	.word   03001h,01802h,00003h,0392eh,00003h,02006h,01007h,00003h
	.word   03801h,04406h,04637h,04570h,03d56h,02009h,0467ch,04614h
	.word   045b3h,02c4ah,02003h,0452ch,0467ah,045d4h,02c27h,02488h
	.word   03d50h,00c71h,0463ah,02806h,040eeh,0450fh,03d2fh,045d2h
	.word   040cbh,045b1h,01403h,018f5h,03db4h,02006h,00002h,03a1ah
	.word   01c04h,02533h,00471h,0000ah,0450eh,02c6dh,03088h,02809h
	.word   00003h,00003h,00004h,00005h,00005h,0458fh,0463ch,00005h
	.word   02804h,00004h,01409h,00c05h,040a8h,03868h,03c69h,0456eh
	.word   02824h,01805h,00003h,00002h,00003h,00003h,00005h,00003h

;************************************************************************

do_ladder
	calla	murder_myoinit_score
	clr	a1
	move	a1,@f_sans_throws,w
	move	a1,*a13(p_store6),w	; clear button press count
	jsrp	setup_ladder_screen

	movi	>36,a3
	calla	send_code_a3	    	; start the mountain tune

	move	@winner_status,a0,w 	; have we played a tune yet ?
	jrne	lad2		  	; yes, skip pan down
	move	@map_position,a0,w	; no, position 1 ??
	jreq	mountain_pandown	; yes, pan down the entire mountain

lad2	move	*a13(p_store3),a8,l
	move	*a13(p_store4),a9,l
	move	*a13(p_store5),a10,l	; grab player box object / frame
*
* player box ----> move up !
*
	movi	>30,a0
	jsrp	ladder_sleep
	move	@map_position,a1
	jreq	lad5			; position 0 ---> dont move player box

	jsrp	box_move_up_1
	move	@map_position,a1
	dec	a1			; a1 = previous position
	sll	4,a1

	move	@map_start,a0,l
	add	a0,a1
	move	*a1,a1,w		; ochar last position ???
	cmpi	ft_smoke,a1		; secrets char ?
	jrne	lad5			; no

	jsrp	box_move_up_1		; yes, be sneaky, pass it up

lad5	movi	>40,a0
	jsrp	ladder_sleep
	jruc	ladder_exit


mountain_pandown
	create	pid_fx,player_box_decend
	move	*a13(p_store3),*a0(pa8),l
	move	*a13(p_store4),*a0(pa9),l
	move	*a13(p_store5),*a0(pa10),l	; pass player box objects

	movi	>30,a0
	jsrp	ladder_sleep
	
;	movi	>20000,a0
	movi	>30000,a0

	move	a0,@scrolly,l
mpan3	sleep	1

	callr	escape_button_update
	jrnc	mpan4
	movi	>a0000,a0
	move	a0,@scrolly,l			; button pressed = scroll fast

mpan4	move	@worldtly+16,a0,w
	cmpi	>310,a0
	jrlt	mpan3	    			; wait till we hit bottom

	clr	a0
	move	a0,@scrolly,l
	movi	>310,a0
	move	a0,@worldtly+16,w

	movi	>20,a0
	jsrp	ladder_sleep

ladder_exit
	calla	fade_all_sky
	sleep	>40
	calla	murder_myoinit_score
	retp	


ladder_sleep
	move	a0,*a13(p_anicount),w
	sleep	1
	callr	escape_button_update
	jrc	lslp9
	move	*a13(p_anicount),a0,w
	dec	a0
	jrne	ladder_sleep
lslp9	retp

*
* return carry set ---> player wants to escape this boring shit
*
escape_button_update
	move	@switch,a1,l
	not	a1
	andi	p1b0|p1b2|p1b3|p1sf2|p2b0|p2b2|p2b3|p2sf2,a1
	jrne	ebu_add

	move	@switch2,a1,l
	not	a1
	andi	p1b1|p1b4|p2b1|p2b4,a1
	jreq	ebu_check

ebu_add	move	*a13(p_store6),a1,w
	inc	a1
	move	a1,*a13(p_store6),w		; count this tick

ebu_check
	move	*a13(p_store6),a1,w
	cmpi	>10,a1
	jrlo	ebu_no
	setc
	rets
ebu_no	clrc
	rets


box_move_up_1
	movi	->20000,a2
	movi	->60000,a3
	callr	set_box_vel

	movi	y_spacing,a1
	move	@map_position,a0,w
	cmpi	>0e,a0
	jrne	bmu0
	sll	1,a1			; last guy = move up 2x as long
bmu0
	move	*a9(oypos),a0,w
	sub	a1,a0
	move	a0,*a9(ograv),w
	move	*a10(oypos),a0,w
	sub	a1,a0
	move	a0,*a10(ograv),w
	move	*a8(oypos),a11,w
	sub	a1,a11

bmu1	sleep	1
	movi	->20000,a2
	movi	->60000,a3
	callr	set_box_vel
	move	*a8(oypos),a1,w
	cmp	a1,a11
	jrlo	bmu1			; loop till traveled y_spacing

	callr	restore_box_start_y
	retp

restore_box_start_y
	clr	a0
	move	a0,*a8(oyvel),l
	move	a0,*a9(oyvel),l
	move	a0,*a10(oyvel),l	; box/frame ---> stop
	move	a11,*a8(oypos),w
	move	*a9(ograv),*a9(oypos),w		; end on exact spot
	move	*a10(ograv),*a10(oypos),w		; end on exact spot
	rets


player_box_decend
	clr	a1
	move	a1,*a13(p_store6),w	; clear button press count

	movi	>30,a0
	jsrp	ladder_sleep

	move	*a9(oypos),a0,w
	addi	>40,a0
	move	a0,*a9(ograv),w
	move	*a10(oypos),a0,w
	addi	>40,a0
	move	a0,*a10(ograv),w
	move	*a8(oypos),a11,w
	addi	>40,a11

pbd3	sleep	1
	movi	>10000,a2
	movi	>20000,a3
	callr	set_box_vel
	move	*a8(oypos),a1,w
	cmp	a1,a11
	jrhi	pbd3			; loop till traveled y_spacing

	callr	restore_box_start_y
	die


setup_ladder_screen
	calla	display_off

	movi	>0d,a11
	calla	do_a11_background	; put up mountain and sky background
	movi	pid_backg,a0
	calla	dallprc			; kill background updater

	movi	pf_battle_plan,a8
	jsrp	lm_printf		; text: Mortal Kombat Battle Plan

	movi	peakboss,a5
	calla	gso_dmawnz
	movi	>000800eb,a4
	calla	set_xy_coordinates
	calla	insobj2a8
*
* player's box
*
	move	@p1_char,a0,w
	move	@p1_state,a1,w
	cmpi	ps_active,a1
	jreq	ladder0
	move	@p2_char,a0,w		; a0 = player's ochar
ladder0
	movi	>009e0080,a4
	move	@winner_status,a1,w	; first time around ?
	jrne	ladder3			; no.
	move	@map_position,a1,w
	jrne	ladder3			; no.
	movi	>005e0080,a4		; yes, start higher

ladder3	callr	plot_a_box		; your players box !!
	move	a8,*a13(p_store3),l
	move	a9,*a13(p_store4),l
	move	a10,*a13(p_store5),l

	movi	objlst,a0
	calla	olist_noscroll

	move	@map_start,a3,l
	movi	box_coordinate_table,a1
ladder1	move	*a3+,a0,w		; ochar
	jrn	ladder2
	cmpi	ft_final_boss,a0
	jreq	ladder2			; final boss = no box for him

	move	*a1+,a4,w		; y coordinate
	sll	16,a4
	addi	>f8,a4
	mmtm	sp,a1,a3
	callr	plot_a_box
	mmfm	sp,a1,a3
	jruc	ladder1

ladder2
	calla	multi_plane
	callr	set_starting_worldy

	movi	baklst3,a0
	calla	olist_noscroll		; sky is stationary
	movi	skip_bakmod,a0
	move	a0,@bak3mods,l		; dont update the sky list anymore

	calla	multi_plane
	create	pid_backg,background
	calla	display_on
	sleep	1
	retp

*
*  a4 = y:x coordinates
* a0 = character offset
*
plot_a_box
	push	a0
	move	a4,a2
	movi	smframe1,a5
	calla	gso_dmawnz
	move	a2,a4
	subi	>00030003,a4			; adjust for left frame
	calla	set_xy_coordinates
	calla	insobja8
	move	a8,a10

	movi	smframe2,a5
	calla	gso_dmawnz
	move	a2,a4
	addk	18,a4
	subi	>00030000,a4			; adjust for right frame
	calla	set_xy_coordinates
	calla	insobja8
	move	a8,a9

	pull	a0
	sll	5,a0
	addi	mini_mug_table,a0
	move	*a0,a5,l
	calla	gso_dmawnz
	move	a2,a4
	calla	set_xy_coordinates
	jauc	insobja8

set_box_vel
	move	a2,a0
	callr	escape_button_update
	jrnc	sbv5
	move	a3,a0
sbv5	move	a0,*a8(oyvel),l
	move	a0,*a9(oyvel),l
	move	a0,*a10(oyvel),l	; box/frame ---> heading upwards
	rets

;**********************************************************************

set_starting_worldy
	move	@winner_status,a0,w 	; have we played a tune yet ?
	jreq	sswy9
	move	@map_position,a0,w
;	jreq	sswy9

	sll	4,a0
	addi	world_y_spots,a0
	move	*a0,a0,w
	sll	16,a0
	move	a0,@worldtly,l
sswy9	rets

;**********************************************************************

mini_mug_table
	.long	smhhbox		; 0
	.long	smlkbox		; 1
	.long	smjcbox		; 2
	.long	smugbox		; 3
	.long	smktbox		; 4
	.long	smlabox		; 5
	.long	smstbox		; 6
	.long	smrdbox		; 7
	.long	smszbox		; 8
	.long	smrpbox		; 9
	.long	smscbox		; 10
	.long	smjxbox		; 11
	.long	smgorobox	; 12 = kintaro = goro
	.long	mysterybox	; 13 - shao kahn
	.long	mysterybox	; 14 - 3 hidden characters
	.long	mysterybox	; 15 - 3 hidden characters
	.long	mysterybox	; 16 - 3 hidden characters


world_y_spots
	.word	>310
	.word	>310
	.word	>310-(1*y_spacing)
	.word	>310-(2*y_spacing)
	.word	>310-(3*y_spacing)
	.word	>310-(4*y_spacing)
	.word	>310-(5*y_spacing)
	.word	>310-(6*y_spacing)
	.word	>310-(7*y_spacing)
	.word	>310-(8*y_spacing)
	.word	>310-(9*y_spacing)
	.word	>310-(10*y_spacing)

	.word	>310-(10*y_spacing)	; secret

	.word	>310-(12*y_spacing)
	.word	>310-(13*y_spacing)->1a


y_spacing	.set	>3a

**************************************************************************
*											     *
*  init_map_start - Initialize the map start pointer !!!			     *
*											     *
**************************************************************************
init_map_start
	movk	6,a0
	calla	randu
	dec	a0
	sll	5,a0
	addi	rom_maps_tbl,a0
	move	*a0,a0,l
	move	a0,@map_start,l
	rets

rom_maps_tbl
	.long	map_1
	.long	map_2
	.long	map_3
	.long	map_4
	.long	map_5
	.long	map_6

**************************************************************************

map_1	.word	ft_jax		; 10
	.word	ft_raiden      	; 6
	.word	ft_fn1		; 4
	.word	ft_hathead	; 0
	.word	ft_sa		; 3
	.word	ft_reptile     	; 8
	.word	ft_cage		; 2
	.word	ft_scorpion    	; 9
	.word	ft_fn2		; 5
	.word	ft_subzero     	; 7
	.word	ft_kang		; 1
	.word	ft_smoke       	; 11
	.word	ft_st		; 12
	.word	ft_goro		; 13
	.word	ft_final_boss	; 14
	.word	-1

map_2	.word	ft_subzero     	; 7
	.word	ft_cage		; 2
	.word	ft_hathead	; 0
	.word	ft_kang		; 1
	.word	ft_reptile     	; 8
	.word	ft_sa		; 3
	.word	ft_jax		; 10
	.word	ft_fn1		; 4
	.word	ft_fn2		; 5
	.word	ft_scorpion    	; 9
	.word	ft_raiden      	; 6
	.word	ft_smoke       	; 11
	.word	ft_st		; 12
	.word	ft_goro		; 13
	.word	ft_final_boss	; 14
	.word	-1

map_3	.word	ft_sa		; 3
	.word	ft_reptile     	; 8
	.word	ft_jax		; 10
	.word	ft_raiden      	; 6
	.word	ft_fn1		; 4
	.word	ft_kang		; 1
	.word	ft_subzero     	; 7
	.word	ft_fn2		; 5
	.word	ft_cage		; 2
	.word	ft_hathead	; 0
	.word	ft_scorpion    	; 9
	.word	ft_smoke       	; 11
	.word	ft_st		; 12
	.word	ft_goro		; 13
	.word	ft_final_boss	; 14
	.word	-1

map_4	.word	ft_sa		; 3
	.word	ft_reptile     	; 8
	.word	ft_jax		; 10
	.word	ft_raiden      	; 6
	.word	ft_fn1		; 4
	.word	ft_kang		; 1
	.word	ft_subzero     	; 7
	.word	ft_fn2		; 5
	.word	ft_cage		; 2
	.word	ft_hathead	; 0
	.word	ft_scorpion    	; 9
	.word	ft_smoke       	; 11
	.word	ft_st		; 12
	.word	ft_goro		; 13
	.word	ft_final_boss	; 14
	.word	-1

map_5	.word	ft_scorpion    	; 9
	.word	ft_fn2		; 5
	.word	ft_sa		; 3
	.word	ft_jax		; 10
	.word	ft_cage		; 2
	.word	ft_fn1		; 4
	.word	ft_kang		; 1
	.word	ft_reptile     	; 8
	.word	ft_subzero     	; 7
	.word	ft_raiden      	; 6
	.word	ft_hathead	; 0
	.word	ft_smoke       	; 11
	.word	ft_st		; 12
	.word	ft_goro		; 13
	.word	ft_final_boss	; 14
	.word	-1

map_6	.word	ft_raiden      	; 6
	.word	ft_fn1		; 4
	.word	ft_hathead	; 0
	.word	ft_jax		; 10
	.word	ft_kang		; 1
	.word	ft_sa		; 3
	.word	ft_subzero     	; 7
	.word	ft_fn2		; 5
	.word	ft_reptile     	; 8
	.word	ft_cage		; 2
	.word	ft_scorpion    	; 9
	.word	ft_smoke       	; 11
	.word	ft_st		; 12
	.word	ft_goro		; 13
	.word	ft_final_boss	; 14
	.word	-1

**************************************************************************

box_coordinate_table
	.word	>80+(14*y_spacing)
	.word	>80+(13*y_spacing)
	.word	>80+(12*y_spacing)
	.word	>80+(11*y_spacing)
	.word	>80+(10*y_spacing)
	.word	>80+(9*y_spacing)
	.word	>80+(8*y_spacing)
	.word	>80+(7*y_spacing)
	.word	>80+(6*y_spacing)
	.word	>80+(5*y_spacing)
	.word	>80+(4*y_spacing)
	.word	>80+(3*y_spacing)
	.word	>80+(2*y_spacing)
	.word	>80+(1*y_spacing)
	.word	>80
	.word	-1

pf_battle_plan
	mess_mac rd15font,2,200,->22,bpal_yellow*>10000,strcnrmos,0
	.byte	"MORTAL KOMBAT BATTLE PLAN",0
	.even

;***************************************************************************

vs_screen
	calla	count_active_players
	cmpi	2,a0
	jrne	vs_exit

	move	@battle_num,a2,w	; a2 = current battle number
	movi	aud_hibattle,a0
	calla	get_aud			; a1 = highest battle reached
	sub	a2,a1		  	; highest ever ?
	jrnn	not_highest_battle	; sans

	neg	a1			; a1 = amount we wanna adjust audit by
	movi	aud_hibattle,a0
	calla	aud			; adjust - o - ra - ma - vitch

not_highest_battle

	clr	a0
	move	a0,@f_auto_erase,w
	calla	display_off

	calla	sync_wait_dma_q

	calla	bakclr
	calla	grab_screen

	clr	a0
	not	a0
	move	a0,@noflip,w	   	; take control of page flipping !!
	calla	view_page_1
	movi	page0adr+xpadding,a1	; plot to page 0
	move	a1,@pageaddr,l		; plot to page 0
	movi	[253,0],a0
	move	a0,@dmatplft,l 		; set dma window to page 0

	movi	vs_mod,a0
	calla	init_bakmods
	calla	multi_plane

	callr	print_battle_number
	jsrp	print_background_name
	calla	display_on

	move	@tick,a0,w
vs3	move	@tick,a1,w
	cmp	a0,a1
	jreq	vs3			; let diplay run

vs5	move	b13,b13			; wait for dma to blow out background
	jrne	vs5			; objects

	calla	display_off		; dont conflict with interupt
	move	a0,@baklst1,l
	move	a0,@objlst,l
	move	a0,@objlst2,l

	move	@p1_char,a8,w
	sll	5,a8
	addi	zipped_pics,a8
	move	*a8,a8,l
	clr	a9
	MOVI	(>1000*48)+(8*>32),A10	; A10 = COORDINATES OF MOVIE CLIP
	jsrp	movie_run

	move	@p2_char,a8,w
	sll	5,a8
	addi	zipped_pics,a8
	move	*a8,a8,l
	clr	a9
	MOVI	(>1000*48)+(8*>ce),A10	; A10 = COORDINATES OF MOVIE CLIP
	jsrp	movie_run

	calla	display_on
	jsrp	position_badge
	sleep	2

	calla	display_off
	calla	view_page_0

	movi	>33,a3
	calla	send_code_a3
	sleep	>80
*
* disable throwing ??
*
	movi	>20,a10			; timer
vs7	move	@switch,a0,l
	not	a0
	btst	1,a0
	jreq	vs6
	btst	9,a0
	jreq	vs6
	btst	4,a0
	jreq	vs6
	btst	>0c,a0
	jreq	vs6
	dsj	a10,vs7

vs6	movk 	1,a11		; assume throws are NOT disabled !!
	move	a10,a0		; combo made the whole time ?
	jreq	vs9		; yes

	cmpi	>20,a0
	jrls	vs8
	movi	>20,a0
vs8	calla	prcslp
	clr	a11
vs9	move	a11,@f_sans_throws,w

	calla	murder_myoinit_score
	calla	display_on

vs_exit	retp

print_background_name
	movi	pf_battle_zone,a8
	jsrp	lm_printf		; print "BATTLEZONE"

	movi	pf_battle_name,a8	
	calla	lm_setup
	move	@curback,a8,w
	sll	5,a8
	addi	background_names,a8
	move	*a8,a8,l

	push	a0
	move	@battle_num,a0,w
	cmpi	pong_battle_num,a0
	jrne	pbnp3
	movi	txt_pong,a8
pbnp3	pull	a0

	jauc	printf

pf_battle_zone
	mess_mac rd7font,2,200,>D8,bpal_red*>10000,strcnrmos_scr,0
	.string	"KOMBAT ZONE:",0
	.even

pf_battle_name
	mess_mac rd15font,2,200,>e6,bpal_hot_green*>10000,strcnrmos_scr,0
	.byte	0
	.even

background_names
	.long	txt_bg1
	.long	txt_bg2
	.long	txt_bg3
	.long	txt_bg4
	.long	txt_bg5
	.long	txt_bg6
	.long	txt_bg7
	.long	txt_bg8
	.long	txt_bg9
	.long	txt_bg10

txt_bg1	.string	"THE DEAD POOL",0
	.even
txt_bg2	.string	"KOMBAT TOMB",0
	.even
txt_bg3	.string	"WASTELAND",0
	.even
txt_bg4	.string	"THE TOWER",0
	.even
txt_bg5	.string	"LIVING FOREST",0
	.even
txt_bg6	.string	"THE ARMORY",0
	.even
txt_bg7	.string	"THE PIT II",0
	.even
txt_bg8	.string	"THE PORTAL",0
	.even
txt_bg9	.string	"KAHN'S ARENA",0
	.even
txt_bg10	.string	"NO NAME",0
	.even
txt_pong	.string	"BACK IN TIME",0
	.even

*************************************************************************

position_badge
	move	@winner_status,a0,w
	jreq	posb9

	movi	battle_numbers+(32*11),a5
	move	*a5,a5,l
	calla	gso_dmawnz

	movi	>00040003,a4		; assume player 1
	move	@winner_status,a0,w	; who won the last match ?
	cmpi	1,a0			; player 1 ?
	jreq	mint2			; yes, we are cool
	movi	>0004012b,a4		; player 2 side
mint2	calla	set_xy_coordinates
	calla	insobja8
;	create	pid_fx,sparkle_proc

*
* print "?? Wins in a Row"
*
	movi	>17,a6			; x position for player 1
	movi	pf_iar_num,a8		; msg: "x wins in a row"
	move	@winner_status,a0,w
	movi	p1_wiar,a7
	cmpi	1,a0
	jreq	mint1
	movi	p2_wiar,a7		; a7 = "wins in a row"
	movi	>175,a6			; x position for player 2
mint1	move	*a7,a0,w
	move	a0,@pf_ram,l
	cmpi	2,a0			; a0 = # of wins in a row
	jrhs	mint0			; 2 or more ---> "x wins in a row"

	movi	pf_new_champ,a8		; 1 win ---> "new champ"
	push	a6
	jruc	mint8

mint0	calla	lm_setup
	movx	a6,a9
	push	a6
 	jsrp	printf

	movi	pf_in_a_row_1,a8
mint8	calla	lm_setup
	pull	a6
	movx	a6,a9
	jsrp	printf

posb9	retp


pf_iar_num
	mess_mac rd15font,2,>30,>50,>0C0C0000,strcnrmos_scr,0
	.byte	"%d",0
	.long	pf_ram
	.even

pf_new_champ
	mess_mac rd11font,2,200,>50,>0C0C0000,strcnrmos_scr,0
	.byte	"NEW\n"
	.byte	"CHAMP",0
	.even

pf_in_a_row_1
	mess_mac rd11font,2,>30,>65,>07070000,strcnrmos_scr,0
	.string	"WINS\n"
	.string	"IN A\n"
	.string	"ROW",0
	.even

*************************************************************************

print_battle_number
	callr	get_battle_obj

	move	@battle_num,a0,w
	cmpi	999,a0
	jrlo	nomax
     	movi	999,a0
nomax
	movi	>00090060,a4		; battle position
	movi	>ed,a5			; a5 = starting x position
	cmpi	99,a0			; 3 digits ?
	jrhi	pbn3			; yes, we are set

	movi	>00090060,a4		; battle position
	movi	>ea,a5			; a5 = starting x position
	cmpi	9,a0			; 2 digits ?
	jrhi	pbn3			; yes, we are set
	movi	>00090070,a4		; battle position
	movi	>fa,a5			; a5 = starting x position

pbn3	push	a0
	calla	set_xy_coordinates
	calla	insobja8		; this is the "BATTLE:" object
	pull	a0

	move	a0,a7
	movi	100,a2
	divs	a2,a7
	move	a7,b0			; b0 = 100's

	movi	100,a2
	mpys	a2,a7
	move	a0,a3
	sub	a7,a3			; a3 = tens/ones
	move	a3,a7
	movk	10,a2
	divs	a2,a3
	move	a3,b1			; b1 = tens 

	mpys	a2,a3
	sub	a3,a7
	move	a7,b2			; b2 = ones

	move	b0,a7
	jreq	mint6
	callr	do_mk_number		; print 100's
	move	b1,a7
	callr	do_mk_number		; print 10's
	move	b2,a7
	callr	do_mk_number		; print 1's
	jruc	mint9

mint6	move	b1,a7			; 10's ?
	jreq	mint7			; no
	callr	do_mk_number
mint7	move	b2,a7
	callr	do_mk_number
mint9	rets


do_mk_number
	mmtm	sp,a0,a4,a7,a9

	callr	get_battle_obj
	sll	5,a7
	addi	battle_numbers,a7
	move	*a7,a1,l
	calla	ani_flag

	movk	9,a4
	move	a4,*a8(oypos),w
	move	a5,*a8(oxpos),w
	move	*a8(osizex),a4,w
	addk	2,a4
	add	a4,a5			; update for next object
	move	a8,a9
	calla	insobja8
	mmfm	sp,a0,a4,a7,a9
	rets


get_battle_obj
	push	a5
	movi	battle_numbers+(32*10),a5
	move	*a5,a5,l
	calla	gso_dmawnz
	pull	a5
	rets

;************************************************************************

force_psel_choice
	clr	a1
	not	a1
	calla	exprc			; player select proc out there ?
	jreq	fpc9
	movi	cmove9,a7
	calla	fastxfer		; yes ---> make him select
fpc9	rets

**************************************************************************
*											     *
*  New code for "auto player select" feature					     *
*											     *
**************************************************************************
a_up	.set	1
a_down	.set	2
a_left	.set	3
a_right	.set	4


auto_player_select
	clr	a1
	not	a1
	movi	pid_master,a0
	calla	existp
	jreq	aps0

	move	*a0(pwake),a1,l		; grab master wakeup address
	cmpi	waiting_for_psel,a1	; where he should be ?
	jrne	aps0			; no, skip
	movi	>40*5,a1
	move	a1,*a0(pa11),l		; yes, tell him to wait longer

aps0	clr	a1
	not	a1
	movi	pid_auto_cycle,a0
	calla	existp	      				; already got letters up there ?
	jrne	aps1

	movi	fl_auto,a11
	create	pid_auto_cycle,boonpal_stuff		; flash letters

aps1	tsound	>f8						; musical hit !

	pushp	a8
	movi	pf_auto_msg_1,a8
	move	*a13(procid),a1,w
	cmpi	pid_p1sel,a1
	jreq	aps6
	movi	pf_auto_msg_2,a8
aps6	jsrp	lm_printf
	pullp	a8

	sleep	4

	movk	12,a0
	calla	randu
	dec	a0
	sll	5,a0
	movi	p1_movements,a2
	move	*a13(procid),a1,w
	cmpi	pid_p1sel,a1
	jreq	aps2
	movi	p2_movements,a2
aps2	add	a2,a0
	move	*a0,a11,l

aps3	movb	*a11,a0		; grab a direction
	jreq	aps9
	addk	8,a11
	cmpi	1,a0
	jreq	auto_move_up
	cmpi	2,a0
	jreq	auto_move_down
	cmpi	3,a0
	jreq	auto_move_left
	jruc	auto_move_right

aps9	sleep	6
	jruc	cmove9

auto_move_down
	movi	down_change,a2
	clr	a3
	movi	y_space,a4		; delta y
	jruc	new_auto_position

auto_move_up
	movi	up_change,a2
	clr	a3
	movi	-y_space,a4		; delta y
	jruc	new_auto_position

auto_move_left
	movi	left_change,a2
	movi	-x_space,a3		; delta x
	clr	a4
	jruc	new_auto_position

auto_move_right
	movi	right_change,a2
	movi	x_space,a3		; delta x
	clr	a4
*
*  input: a1 = current ochar
*         a2 = position change for new spot
*         a3 = coordinate delta x
*         a4 = corrdinate delta y
*
new_auto_position
	move	*a13(p_mychar),a1,l
	move	*a1,a1,w		; a1 = my current ochar

	sll	4,a1
	add	a2,a1			; direction table
	move	*a1,a1,w		; new ochar
	move	*a13(p_mychar),a5,l
	move	a1,*a5,w		; update my new ochar

	movi	>2a,b1
 	movi	>2b,b2
	callr	cursor_sound

	move	a8,a7
nap4	move	*a7(oxpos),a5,w
	add	a3,a5
	move	a5,*a7(oxpos),w
	move	*a7(oypos),a5,w
	add	a4,a5
	move	a5,*a7(oypos),w		; do the deltas !!
	move	*a7(oslink),a7,l
	jrne	nap4
*
* display new choice a fight'n
*
	movi	pid_p1,a1
	movi	psel_drone_1,a7

	move	*a13(procid),a0,w
	cmpi	pid_p1sel,a0
	jreq	nap5

	movi	pid_p2,a1
	movi	psel_drone_2,a7

nap5	calla	getprc
	sleep	>0a
	jruc	aps3


pf_auto_msg_1
	mess_mac rd7font,2,>28,>48,bpal_flash3*>10000,strcnrmos_scr,0
	.byte	"RANDOM\nSELECT",0
	.even

pf_auto_msg_2
	mess_mac rd7font,2,>166,>48,bpal_flash3*>10000,strcnrmos_scr,0
	.byte	"RANDOM\nSELECT",0
	.even


p1_movements
	.long	p1_hh
	.long	p1_lk
	.long	p1_jc
	.long	p1_sa
	.long	p1_fn1
	.long	p1_fn2
	.long	p1_st
	.long	p1_rd
	.long	p1_sz
	.long	p1_rp
	.long	p1_sc
	.long	p1_jx

p2_movements
	.long	p2_hh
	.long	p2_lk
	.long	p2_jc
	.long	p2_sa
	.long	p2_fn1
	.long	p2_fn2
	.long	p2_st
	.long	p2_rd
	.long	p2_sz
	.long	p2_rp
	.long	p2_sc
	.long	p2_jx


p1_hh	.byte	a_down,a_right,a_right,a_up,a_left,0
p1_lk	.byte	a_right,a_down,a_down,a_up,a_left,a_up,0
p1_jc	.byte	a_right,a_down,a_right,a_up,0
p1_sa	.byte	a_down,a_down,a_up,a_right,a_down,0
p1_fn1	.byte	a_right,a_right,a_right,a_down,a_left,0
p1_fn2	.byte	a_down,a_up,a_down,a_down,0
p1_st	.byte	a_right,a_down,a_down,a_up,0
p1_rd	.byte	a_right,a_right,a_right,a_down,a_down,0
p1_sz	.byte	a_down,a_down,a_right,a_left,a_up,0
p1_rp	.byte	a_right,a_down,a_right,a_up,a_right,0
p1_sc	.byte	a_down,a_down,a_right,a_right,0
p1_jx	.byte	a_right,a_down,a_right,a_right,0

p2_hh	.byte	a_down,a_left,a_left,a_up,0
p2_lk	.byte	a_left,a_left,a_down,a_up,a_left,0
p2_jc	.byte	a_left,a_left,a_down,a_up,a_right,0
p2_sa	.byte	a_left,a_left,a_down,a_down,0
p2_fn1	.byte	a_down,a_left,a_down,a_up,0
p2_fn2	.byte	a_down,a_down,a_left,a_left,a_left,0
p2_st	.byte	a_down,a_left,a_left,a_up,a_down,0
p2_rd	.byte	a_down,a_left,a_down,a_right,0
p2_sz	.byte	a_left,a_left,a_down,a_left,0
p2_rp	.byte	a_left,a_down,a_right,a_up,0
p2_sc	.byte	a_left,a_left,a_down,a_right,a_down,0
p2_jx	.byte	a_down,a_down,a_up,a_left,a_right,0
	.even

**************************************************************************

	.end
