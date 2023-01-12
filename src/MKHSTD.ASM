**************************************************************************
*											     *
*  video game project:	mortal kombat 2							*
* 											     *
*  game software:    	ed boon								     *
* 											     *
*  module: high score stuff									*
* 											     *
*  copyright (c) 1992 williams electronics games, inc.			     *
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
	.include	diagsequ.asm

**************************************************************************
*											     *
*  entries consist of:									     *
* 											     *
*       initials = 3 bytes								     *
*     	 score  = 4 bytes								     *
*  wins in a row = 2 bytes 								     *
*   -------------------------								     *
* 	          9 bytes total								     *
*											     *
**************************************************************************
entry_size	.set	9
bits_per_entry	.set	entry_size*16

entries_per_page	 .set	15

last_entry	.set	rankorg+(entries_per_page-1)*bits_per_entry
hstd_checksum	.set	last_entry+bits_per_entry


	.ref	set_page,def_page
	.ref	cmoslock,cmosunlock

**************************************************************************
*											     *
*  coordinate equates									     *
*											     *
**************************************************************************
abc_start1	.set	>00240024
abc_start2	.set	>002400f4

abc_yspace	.set	>1b
abc_xspace	.set	>18


menu_initials
	movk	1,a0
	move	a0,@f_nopmsg,w			; no score shit
	calla	nosounds

	callr	rank_page_start
	movi	rankorg,a7
	callr	get_entry			; a3 = wiar / a4 = score
	callr	rank_page_end

	movk	10,a0
	calla	randu
	add	a0,a3
	move	a3,@p1_wiar,w

	movi	1000,a0
	calla	randu
	move	a0,a1
	movi	1000,a5
	mpys	a5,a1
	add	a1,a4				; better than #1

	move	a4,*a13(p_slave),l
	move	a3,*a13(p_anitab),l
	clr	a0
	move	a0,*a13(p_flags),w

; <<<<<<<<<<<< fall through >>>>>>>>>>>>>

**************************************************************************
*											     *
*  enter_initials - high score to date initial entry				     *
* 											     *
*  input: *a13(p_flags) = player offset (0-1)					     *
*											     *
**************************************************************************
enter_initials
	movi	>40,a3
	calla	send_code_a3		; play music

	movi	gs_initials,a0
	move	a0,@gstate,w		; set game state
*
* enter initials background
*
	calla	dont_show_scores
	movk	1,a0
	move	a0,@f_auto_erase,w	; erase stuff !!
	calla	clr_scrn
	calla	murder_myoinit_score
	sleep	2
	calla	page_0_setup_no_init

	movi	initials1_mod,b0
	movi	initials2_mod,b1
	calla	player_offset_pick

	move	b0,a0
	calla	init_bakmods
	calla	multi_plane		; put out the stone background objects

	calla	display_on
	calla	sync_wait_dma_q
	sleep	1
	calla	grab_screen		; sans all objects

	movi	print_p1_msg,b0
	movi	print_p2_msg,b1
	calla	player_offset_pick
	call	b0
*
* alphabet
*
	movi	'A',a0
	movi	abc_start1,b0		; y:x coordinate
	movi	abc_start2,b1
	callr	player_offset_pick	; b0 = correct choice
	move	b0,a2

	movk    6,a4

entin3	callr	print_1_character
	dec	a4
	jrne	entin5
	movk	6,a4
      	addi	abc_yspace*>10000,a2	; start a new line of letters
	subi	abc_xspace*6,a2

entin5	addi	abc_xspace,a2		; move one character to the right
	inc	a0
	cmpi	'Z'+1,a0		; do a-z
	jrne	entin3

;	subi	3,a2			; adjust coordinates for "rub"
;	movi	'z'+37,a0
	movi	'9'+3,a0
	callr	print_1_character	; print the "rub" character

	sleep	1

	movi	fl_enter_initials,a11
	create	pid_fx,boonpal_stuff			; flash letters
	create	pid_initials,get_initial_proc
	move	*a13(p_flags),*a0(p_flags),w	; pass player offset
	move	a0,a10
*
* time down
*
	movi	>40*10,a11
entin8	sleep	2
	move	*a10(pwake),a7,l
	cmpi	initials_done,a7		; got all characters ?
	jreq	entin9
	dsj	a11,entin8

	move	a10,a0
	calla	kill				; timeout ---> kill proc

	movk	2,a0
	movk	17,a1
	movk	11,a2				; hmmmm, crl !!
	jruc	entina

entin9	move	*a10(p_store4),a0,w
	move	*a10(p_store4+16),a1,w
	move	*a10(p_action),a2,w		; grab initials from proc

entina
;	move	*a13(p_slave),a4,l		; a4 = score
	move	*a13(p_anitab),a3,l		; a3 = wins in a row
	callr	rank_page_start
	calla	insert_entry
	callr	update_checksum
	callr	rank_page_end

	movi	p1_wiar,a1
	move	*a13(p_flags),a0,w
	jreq	entinb
	movi	p2_wiar,a1
entinb	clr	a0
	move	a0,*a1,w			; clear out winner's wiar

	move	a0,@noflip,w
	calla	clr_scrn
	calla	murder_myoinit_score
	retp


print_1_character
	mmtm	sp,a0,a3,a4
	move	a0,@pf_ram,w
	movi	pf_abc,a8
	calla	lm_setup
	move	a2,a9
	jsrp	printf			; print one letter of the alphabet
	mmfm	sp,a0,a3,a4
	rets

pf_abc
	mess_mac rd15font,2,>00,>00,>0e0e0000,strlnrm,0
	.string	"%c",0
	.long	pf_ram
	.even


print_p1_msg
	move	@p1_wiar,a0,w
	move	a0,@pf_ram,l

	movi	pf_eimsg1a,a8
	jsrp	lm_printf
	movi	pf_eimsg1b,a8
	jsrp	lm_printf
	movi	pf_eimsg1c,a8
	jruc	ppm3

print_p2_msg
	move	@p2_wiar,a0,w
	move	a0,@pf_ram,l

	movi	pf_eimsg2a,a8
	jsrp	lm_printf
	movi	pf_eimsg2b,a8
	jsrp	lm_printf
	movi	pf_eimsg2c,a8
ppm3	jsrp	lm_printf
	rets


pf_eimsg1a
	mess_mac rd15font,2,>100,>22,>01010000,strcnrms,0
	.string	"PLAYER\nONE\n",0
	.even

pf_eimsg1b
	mess_mac rd11font,2,>120,>5a,bpal_yellow*>10000,strcnrms,0
	.string	"%d WINS IN A ROW !!\n"
	.string	"YOU HAVE MASTERED\n"
	.string	"MORTAL KOMBAT II\n\n"
	.string	"ENTER YOUR\nINITIALS\n\n",0
	.long	pf_ram
	.even

pf_eimsg2a
	mess_mac rd15font,2,>50,>22,>01010000,strcnrms,0
	.string	"PLAYER\nTWO\n",0
	.even

pf_eimsg2b
	mess_mac rd11font,2,>70,>5a,bpal_yellow*>10000,strcnrms,0
	.string	"%d WINS IN A ROW !!\n"
	.string	"YOU HAVE MASTERED\n"
	.string	"MORTAL KOMBAT II\n\n"
	.string	"ENTER YOUR\nINITIALS\n\n",0
	.long	pf_ram
	.even

pf_eimsg1c
	mess_mac rd11font,2,>120,>cd,bpal_hot_green*>10000,strcnrms,0
	.STRING	"PLAYER 2 STANDBY",0
	.even

pf_eimsg2c
	mess_mac rd11font,2,>70,>cd,bpal_hot_green*>10000,strcnrms,0
	.STRING	"PLAYER 1 STANDBY",0
	.even


p1_bmask1	.set	00000000000000000000000001110000b
p2_bmask1	.set	00000000000000000111000000000000b

p1_bmask2	.set	00000000000000000000000000000111b
p2_bmask2	.set	00000000000000000000000001110000b



fl_enter_initials
	.word	bpal_flash1,6
	.word	rgb_red
	.word	rgb_green
	.word	rgb_blue
	.word	end_stuff

**************************************************************************
*											     *
*  player_offset_pick - pick either b0 or b1 based on p_flags 		     *
*											     *
**************************************************************************
player_offset_pick
	move	*a13(p_flags),a7,w
	jreq	pop5
	move	b1,b0
pop5	rets

**************************************************************************
*											     *
*  process to get a player's id via joystick input. a10 = player (0-3)   *
*											     *
**************************************************************************
get_initial_proc
	movi	p1_bmask1,b0
	movi	p2_bmask1,b1
	callr	player_offset_pick
	move	b0,a0
	move	a0,*a13(p_store8),l		; button mask	

	movi	p1_bmask2,b0
	movi	p2_bmask2,b1
	callr	player_offset_pick
	move	b0,a0
	move	a0,*a13(p_dronevar1),l	; button mask 2

	movi	switch,b0
	movi	switch+8,b1
	callr	player_offset_pick
	move	b0,a6
	move	a6,*a13(p_store6),l		; remember our switch

	movi	abc_start1,b0
	movi	abc_start2,b1
	callr	player_offset_pick
	move	b0,a9
	movi	>00050008,a0
	subxy	a0,a9				; starting y:x coordinate

	movi	bpal_red*>10000,a1
	move	a1,*a13(p_store7),l		; color:palette
*
* get initials
*
	movi	>00b8005a,b0
	movi	>00b8012a,b1
	calla	player_offset_pick
	move	b0,a2				; print choices starting here

	clr	a11				; a11 = character offset
geti1	jsrp	get_one_initial
call1	callr	check_for_rub

	move	a11,*a13(p_store4),w
	addi	>10,a2
geti2	jsrp	get_one_initial
	movi	geti1,a1
	callr	check_for_rub
	move	a11,*a13(p_store4+16),w
	addi	>10,a2
	jsrp	get_one_initial			; get 3 initials
	movi	geti2,a1
	callr	check_for_rub
	move	a11,*a13(p_action),w

geti3	sleep	>40

initials_done
	jruc	geti3


get_one_initial
	pushp	a2				; save lower coordinate
	movi	>001a0018,a0
	movi	3,a2
	movi	>00060001,a3			; y:x movement count change
	movi	abc_yspace,a4			; vertical spacing
	movi	abc_xspace,a5			; horizontal spacing
	movi	abc_limits,a6			; a6 ---> limit bit table
	jsrp	box_entry

	move	a11,a0
	addi	'a',a0				; xlate to letter of alphabet
	move	a0,@pf_ram,w
	movi	pf_abc,a8
	pullp	a2				; restore lower coordinate
*
* check for "rub"
*
	cmpi	'z'+1,a0			; rub ??
	jrne	gone3				; nope..

	move	*a12,a0,l			; pull return address (leave stack)
	cmpi	call1,a0
	jreq	get_one_initial			; dont rub on space #1

	subi	>10,a2				; move back a space
	push	a2
	move	a2,a3
	movi	bpal_black*>10000,a1		; color:palette
	movi	>00110011,a2			; h:w
	movi	>2000000,a4			; starting address
	movi	dmacal,a5			; use constant color always
	calla	dman				; erase the old letter
	pull	a2
	jruc	gone4

gone3	callr	print_choice			; print initial in (a2) lower spot

gone4	jsrp	button_wait			; wait for button release
	retp

*
* wait for button to be released
*
button_wait
	mmtm	a12,a0,a2
butw2	sleep	1
	move	@switch,a0,l
	not	a0
	move	*a13(p_store8),a1,l		; button mask
	and	a1,a0
	jrne	butw2

;************
	move	@switch2,a0,l
	not	a0
	move	*a13(p_dronevar1),a1,l  	; button mask
	and	a1,a0
	jrne	butw2
;************

	movk	1,a4				; a4 = 1 ---> erase box
	callr	boxme				; box then return
	mmfm	a12,a0,a2
	retp


check_for_rub
	cmpi	26,a11
	jrne	cfrx
	pull	a0
	movi	>285,a3
	calla	send_code_a3			; rub sound
	jump	a1
cfrx	rets


print_choice
	mmtm	sp,a0,a1,a9,a11
	calla	lm_setup
	move	a2,a9
	jsrp	printf			; print line number
	mmfm	sp,a0,a1,a9,a11
	rets

**************************************************************************
*											     *
*  box_entry										     *
* 											     *
*  ultra generic box moving subroutine for getting information from a    *
*  player via yonder joystick.								     *
* 											     *
*  inputs: 	a0 = y:x size of box							     *
* 		a1 = color:palette							     *
* 		a2 = line thickness							     *
* 		a3 = y:x movement changes						     *
* 		a4 = cursor delta y							     *
* 		a5 = cursor delta x							     *
* 		a6 = limit bit table to use					     *
* 	       a11 = initial offset value						     *
* 											     *
*  uses:        	a8 = debounce counter for joystick		     		*
* 	       a10 = debounce counter for action button			     *
*											     *
**************************************************************************
box_entry
	move	a0,*a13(p_store2),l		; size o box
	move	a2,*a13(p_anitab),w		; line thickness
	move	a3,*a13(p_joyport),l		; y:x movement changes
	move	a4,*a13(p_store2),w		; cursor delta y
	move	a5,*a13(p_store1),w		; cursor delta x
	move	a6,*a13(p_store5),l

boxm1	clr	a8
	clr	a10				; init both debounce counters

boxm2	clr	a4   
	callr	boxme				; a4 = 0 ---> draw box
boxm3	sleep	1
	move	a10,a10
	jreq	boxm4
	dec	a10
boxm4	move	a8,a8
	jreq	boxm5
     	dec	a8				; update debounce counters

boxm5	move	@switch,a0,l
	not	a0
	move	*a13(p_store8),a1,l		; button mask
	and	a1,a0
	jrne	boxm9				; button pressed

;*************
	move	@switch2,a0,l
	not	a0
	move	*a13(p_dronevar1),a1,l	; button mask
	and	a1,a0
	jrne	boxm9				; button pressed
;*************

	move	*a13(p_store6),a0,l
	move	*a0,a0,w
	not	a0				; a0 = switch bit states
	andi	>0f,a0				; only look at lower 8 bits
	jreq	boxm1				; no switch ---> clear debounce
*
* joystick switch made
*
	move	a8,a8
	jrne	boxm3				; switch not closed long enough

	movk	8,a8				; joystick debounce speed
	move	*a13(p_store5),a7,l		; limit bit table
	btst	bit_jup,a0			; joystick up ??
	jreq	boxm6				; nope...

	move	a7,a6				; dont destroy a7
	move	*a6,a6,l			; grab the limit bits for "up"
	move	a11,a3
	inc	a3
	neg	a3
	srl	a3,a6
	jrc	boxm6				; carry set ---> illegal move

	callr	valid_move
	move	*a13(p_joyport+16),a3,w	; a3 = y change
	sub	a3,a11				; move is legal ---> do it
	move	*a13(p_store2),a2,w
	sll	16,a2
	subxy	a2,a9				; move cursor up

boxm6	btst	bit_jdown,a0
	jreq	boxm7

	cmpi	31,a11
	jreq	boxm7				; kluge: we is outta bits ! (ejb)

	move	a7,a6				; dont destroy a7
	addi	32,a6
	move	*a6,a6,l			; grab the limit bits for "down"
	move	a11,a3
	inc	a3
	neg	a3
	srl	a3,a6
	jrc	boxm7				; carry set ---> illegal move
	callr	valid_move
	move	*a13(p_joyport+16),a3,w  	; a3 = y change
	add	a3,a11				; move is legal ---> do it
	move	*a13(p_store2),a2,w	
	sll	16,a2
	addxy	a2,a9				; move cursor down

boxm7	btst	bit_jleft,a0
	jreq	boxm8

	move	a7,a6				; dont destroy a7
	addi	64,a6
	move	*a6,a6,l			; grab the limit bits for "left"
	move	a11,a3
	inc	a3
	neg	a3
	srl	a3,a6
	jrc	boxm8				; carry set ---> illegal move
	callr	valid_move
	move	*a13(p_joyport),a3,w		; a3 = x change
	sub	a3,a11				; move is legal ---> do it
	move	*a13(p_store1),a2,w	
	subxy	a2,a9				; move cursor left

boxm8	btst	bit_jright,a0
	jreq	boxm2

	cmpi	31,a11
	jreq	boxm2				; kluge: we is outta bits ! (ejb)

	move	a7,a6				; dont destroy a7
	addi	96,a6
	move	*a6,a6,l			; grab the limit bits for "right"
	move	a11,a3
	inc	a3
	neg	a3
	srl	a3,a6
	jrc	boxm2				; carry set ---> illegal move
	callr	valid_move
	move	*a13(p_joyport),a3,w		; a3 = x change
	add	a3,a11				; move is legal ---> do it
	move	*a13(p_store1),a2,w	
	addxy	a2,a9				; move cursor right
	jruc	boxm2
*
* action button pressed
*
boxm9	move	a10,a10				; button allowed ?
	jrne	boxm3				; nope...
	movi	120,a10				; yes ----> reset debounce counter
	clr	a4
	callr	boxme				; draw box then return
	retp

valid_move
	push	a0
	movi	>20c,a3
	calla	send_code_a3
	movk	1,a4				; a4 = 1 ---> erase box
	callr	boxme
	pull	a0
	rets

**************************************************************************
*								         			*
*  draw box at current a9 coordinate where a4 = draw or erase		 	*
*								         			*
**************************************************************************
boxme	move	*a13(p_store2),a0,l		; size o box
	move	*a13(p_anitab),a2,w		; line thickness
	move	*a13(p_store7),a1,l		; color:palette
	move	a4,a4
	jreq	me4
	movi	bpal_black*>10000,a1		; alternate with background color
me4	move	a9,a3
;	<<<<<<<<<<<<<<< fall through >>>>>>>>>>>>>>

**************************************************************************
*											     *
* drawbox - draw a box using the dma							     *
* a0 = [h,w] size of box									     *
* a1 = [color,palette]									     *
* a2 = line thickness in pixels								     *
* a3 = [y,x] screen address of box							     *
*											     *
**************************************************************************
drawbox
	mmtm	sp,a0,a2,a3,a4,a5,a6,a7,a8
	movi	dmacal,a5		;always this color
	movi	2000000h,a4		;let's use this as data
	move	a3,a7
	move	a2,a8			;keep pixel thickness here
	sll	16,a2
	movx	a0,a2
	move	a2,a6
	calla	dman			;draw top line
	rl	16,a2
	movy	a0,a2
	move	a2,a0
	calla	dman			;draw left line
	srl	16,a2
	sll	16,a2
	rl	16,a8
	subxy	a8,a2			;adjust for pixel thickness
	addxy	a2,a3			;move to ll corner
	move	a6,a2	
	calla	dman			;draw bottom line
	zext	a2
	dec	a2
	rl	16,a8
	subk	1,a8			;base on 1 pixel
	subxy	a8,a2			;adjust for pixel thickness
	addxy	a2,a7			
	move	a7,a3			;move to ur corner
	move	a0,a2
	calla	dman			;draw right line
	mmfm	sp,a0,a2,a3,a4,a5,a6,a7,a8
	rets

abc_limits
	.long	00000000000000000000000000111111b	; up
	.long	00000111111000000000000000000000b	; down
	.long	00000001000001000001000001000001b	; left
	.long	00000100100000100000100000100000b	; right


**************************************************************************
*											     *
*  amode_button_hstd - someone pressed an action button during attract   *
*                      mode, show hstd						     *
*											     *
**************************************************************************
amode_button_hstd
	movi	>ee,a3
	calla	send_code_a3  		; death blow start sound

	calla	page_0_setup  		; we gonna use page zero
	calla	view_page_1
	calla	display_on
	callr	high_score_background
	sleep	4
	calla	grab_screen		; sans all objects
	jsrp	high_score_text

	movi	all_palettes,a0
	calla	fadein			; fade all palette black (instantly)
	sleep	30
	retp


print_rankings
	calla	page_0_setup  		; we gonna use page zero
	calla	view_page_1
	calla	display_on
	callr	high_score_background
	sleep	4
	calla	grab_screen		; sans all objects
	jsrp	high_score_text

	movi	all_palettes,a0
	calla	fadein			; fade all palette black (instantly)
	calla	view_page_0
	movi	>33,a3
	calla	send_code_a3		; ta da !!
	sleep	>40*10
	retp


high_score_text
	movi	pf_rank_title,a8
	jsrp	lm_printf
	sleep	2

	movi	fl_number_1,a11
	create	pid_amode,boonpal_stuff	; # 1 player = flash

	movi	>00200014,a9		; starting coordinate
	callr	rank_page_start
	movi	rankorg,a7

	movk	1,a0
	movi	bpal_flash1,a5		; a5 = color to print in
	movk	1,a14 			; a14 = # of lines to print
	callr	print_a0_lines

	movi	bpal_red,a5		; a5 = color to print in
	movk	9,a14 			; a14 = # of lines to print
	callr	print_a0_lines

	movi	bpal_hot_green,a5		; a5 = color to print in
	movk	5,a14 			; a14 = # of lines to print
	callr	print_a0_lines
	retp



print_a0_lines
	sll	16,a5
	move	a5,*a13(p_joyport),l		; save color here

prank2	move	a14,*a13(p_butport),w
      	move	a0,*a13(p_anicount),w

	move	a9,a10
	mmtm	sp,a0,a1,a2,a3,a4,a7,a9,a10
	move	*a13(p_anicount),a0,w
	move	a0,@pf_ram,w
	push	a10
	movi	pf_rank_num,a8
	calla	lm_setup
	pull	a14
	movy	a14,a9				; lineup with others
	move	*a13(p_joyport),a5,l		; grab our current color
	jsrp	printf
	mmfm	sp,a0,a1,a2,a3,a4,a7,a9,a10

	callr	get_entry
	push	a7

	addi	>3d,a10			; move 1 character right
	addi	'A',a0
	move	a0,@pf_ram,w
	jsrp	print_one_rank_init
	addi	'A',a1
	move	a1,@pf_ram,w
	addi	>0d,a10			; move 1 character right
	jsrp	print_one_rank_init
	addi	'A',a2
	move	a2,@pf_ram,w
	addi	>0d,a10			; move 1 character right
	jsrp	print_one_rank_init
*
* print a3 = "wins in a row"
*
	move	a3,@pf_ram,w
	addi	>e0,a10
	mmtm	sp,a0,a1,a2,a3,a4,a9,a10
	push	a10
	movi	pf_rank_wiar,a8
	calla	lm_setup
	move	*a13(p_joyport),a5,l		; grab our current color
	pull	a9
	jsrp	printf
	mmfm	sp,a0,a1,a2,a3,a4,a9,a10
*
* print a4 = score
*
;	move	a4,@pf_ram,l
;	mmtm	sp,a0,a1,a2,a3,a4,a9,a10
;	movi	>160,a0
;	movx	a0,a10				; line up for score
;	push	a10
;	movi	pf_rank_score,a8
;	calla	lm_setup
;	pull	a9
;	jsrp	printf
;	mmfm	sp,a0,a1,a2,a3,a4,a9,a10

	pull	a7

	addi	>000e0000,a9			; move down a line of text
	addi	bits_per_entry,a7

	move	*a13(p_anicount),a0,w
	inc	a0
	move	*a13(p_butport),a14,w
	dsj	a14,prank2
	push	a0
	callr	rank_page_end
	pull	a0
	rets


print_one_rank_init
	mmtm	sp,a0,a1,a2,a3,a4,a9,a10
	push	a10
	movi	pf_rank1,a8
	calla	lm_setup
	move	*a13(p_joyport),a5,l		; grab our current color
	pull	a9
	jsrp	printf
	mmfm	sp,a0,a1,a2,a3,a4,a9,a10
	retp

pf_rank_title
	mess_mac rd11font,2,scrrgt/2,>0f,bpal_yellow*>10000,strcnrms,0
	.STRING	"LONGEST WINNING STREAKS",0
	.even

pf_rank_num
	mess_mac rd11font,2,>40,>33,bpal_white*>10000,strrnrms,0
	.string	"%d.",0
	.long	pf_ram
	.even

pf_rank1
	mess_mac rd11font,2,>00,>00,>0e0e0000,strcnrms,0
	.string	"%c",0
	.long	pf_ram
	.even

pf_rank_wiar
	mess_mac rd11font,2,>00,>00,>0e0e0000,strrnrms,0
	.string	"%d WINS IN A ROW",0
	.long	pf_ram
	.even

pf_rank_score
	mess_mac rd11font,2,>00,>00,>0e0e0000,strrnrms,0
	.byte	"%,ld",0
	.long	pf_ram
	.even


high_score_background
	movi	hstd_mod,a0
	calla	init_bakmods
	calla	multi_plane		; put out the stone background objects
	rets

fl_number_1
	.word	bpal_flash1,4
	.word	rgb_blue
	.word	>ffff
	.word	end_stuff


**************************************************************************
*											     *
*    cmos routines									     *
*											     *
**************************************************************************

**************************************************************************
*											     *
*  zero_rank_ram										     *
* 											     *
*  clears out all the names in the "player ranking" cmos ram.		     *
*											     *
**************************************************************************
zero_rank_ram
	callr	rank_page_start
	clr	a0
	movi	rankorg,a7
zero2	callr	write_a0_to_a7
	addk	16,a7

	cmpi	last_entry+bits_per_entry,a7

	jrne	zero2
	callr	rank_page_end
	rets

**************************************************************************
*											     *
*  zero_one_entry									     *
* 											     *
*  zeros out one entry starting at a7.						     *
*											     *
**************************************************************************
zero_one_entry
	mmtm	sp,a0,a1,a7
	movk	entry_size,a1		; # of bytes to clear
zero1	clr	a0
	callr	write_a0_to_a7
	addk	16,a7
	dsjs	a1,zero1
	mmfm	sp,a0,a1,a7
	rets

**************************************************************************
*											     *
*  does_a0_cut_it - answers the question with a carry.			     *
* 											     *
*  input: a0 = # of wins in a row							     *
*											     *
**************************************************************************
does_a0_cut_it
	move	a0,a14
	callr	rank_page_start
	movi	rankorg,a7
dac3	calla	get_entry		; a3 = wins in a row
	cmp	a14,a3			; good enough ?
	jrlo	dac4			; yes
	addi	bits_per_entry,a7
	cmpi	last_entry+bits_per_entry,a7
	jrne	dac3

	callr	rank_page_end
	clrc
	rets

dac4	callr	rank_page_end
	setc
	rets

**************************************************************************
*								         			*
*  insert_entry								 			*
* 									 			*
*  input:  a0 = initial #1									*
*  	  a1 = initial #2									*
*  	  a2 = initial #3									*
* 	  a3 = wins in a row									*
*          a4 = score										*
*								         			*
**************************************************************************
insert_entry
	mmtm	sp,a0,a1,a2,a3,a4,a5,a8

	move	a0,a5
	move	a1,a6
	move	a2,a8
	move	a3,a9
	move	a4,a10			; save old entry info

	movi	rankorg,a7
ins2	callr	get_entry
	jreq	ins4

	cmp	a9,a3			; more wins than this entry ?
	jrlo	ins3			; yes
	addi	bits_per_entry,a7	; no, a7 ---> next entry in ram
	cmpi	last_entry+bits_per_entry,a7
	jrlo	ins2
	jruc	ins9
	
ins3	callr	shift_down		; make room for new entry

ins4	move	a5,a0
	move	a6,a1
	move	a8,a2
	move	a9,a3
	move	a10,a4			; restore our entry
	callr	stuff_entry

ins9	mmfm	sp,a0,a1,a2,a3,a4,a5,a8
	rets

**************************************************************************
*											     *
*  shift_down - shift all entries down to make room for a new one.	     *
* 											     *
*  input: a7 = place we wanna make the hole					     *
*											     *
**************************************************************************
shift_down
	move	a7,a11			; a11 = hole spot
	subi	bits_per_entry,a11	; we are done after we do this pos.

	cmpi	last_entry,a7
	jreq	shdown9			; we are at last entry ---> exit

	movi	last_entry-bits_per_entry,a7
	movi	last_entry,a14
shdown3	callr	get_entry		; grab from above
	push	a7
	move	a14,a7
	callr	stuff_entry		; stuff one position ahead
	pull	a7

	subi	bits_per_entry,a7
	subi	bits_per_entry,a14	; both pointers up one position
	cmp	a7,a11			; we done ?
	jrne	shdown3			; sans

	addi	bits_per_entry,a7	; restore "hole" position

shdown9	rets

**************************************************************************
*											     *
*  get_entry - get an entry								     *
* 											     *
*  input: a7 = cmos ram pointer								     *
* 											     *
*  returns:  a0 = initial #1								     *
*   	    a1 = initial #2								     *
*   	    a2 = initial #3								     *
*  	    a3 = wins in a row								     *
*            a4 = score									     *
* 											     *
*  zero bit = null entry									     *
*											     *
**************************************************************************
get_entry
	mmtm	sp,a7,a14
	movb	*a7,a0			; grab initial #1
	addk	16,a7
	movb	*a7,a1			; grab initial #2
	addk	16,a7
	movb	*a7,a2			; grab initial #3
	addk	16,a7

	movb	*a7,a3
	sll	24,a3
	srl	24,a3
	addk	16,a7
	movb	*a7,a14
	sll	24,a14
	srl	24-8,a14
	addk	16,a7
	or	a14,a3			; grab wins in a row

	movb	*a7,a4
	sll	24,a4
	srl	24,a4
	addk	16,a7
	movb	*a7,a14
	sll	24,a14
	srl	24-8,a14
	addk	16,a7
	or	a14,a4
	movb	*a7,a14
	addk	16,a7
	sll	24,a14
	srl	24-16,a14
	or	a14,a4
	movb	*a7,a14
	addk	16,a7
	sll	24,a14
	or	a14,a4			; grab score

	clr	a14
	or	a0,a14
	or	a1,a14
	or	a2,a14
	or	a3,a14
	or	a4,a14
	move	a14,a14

	mmfm	sp,a7,a14
	rets

**************************************************************************
*											     *
*  stuff_entry - stuff an entry into cmos						     *
* 											     *
*  input: a0 = initial #1								     *
*         a1 = initial #2								     *
*         a2 = initial #3								     *
*         a3 = wins in a row								     *
*         a4 = score									     *
*         a7 = cmos ram pointer								     *
*											     *
**************************************************************************
stuff_entry
	mmtm	sp,a3,a4
	callr	write_a0_to_a7
	addk	16,a7
	callr	write_a1_to_a7
	addk	16,a7
	callr	write_a2_to_a7
	addk	16,a7			; stuff initials

	callr	write_a3_to_a7
	addk	16,a7
	srl	8,a3
	callr	write_a3_to_a7
	addk	16,a7			; stuff wins in a row !

	callr	write_a4_to_a7
	addk	16,a7
	srl	8,a4
	callr	write_a4_to_a7
	addk	16,a7
	srl	8,a4
	callr	write_a4_to_a7
	addk	16,a7
	srl	8,a4
	callr	write_a4_to_a7
	addk	16,a7
	srl	8,a4			; stuff score
	
	mmfm	sp,a3,a4
	rets

**************************************************************************
*											     *
*  check_hstd_cmos - make sure things are cool with hstd cmos memory     *
*											     *
**************************************************************************
check_hstd_cmos
	callr	compute_new_checksum		; a5 = current checksum
	move	a5,a6
	callr	read_cmos_checksum
	cmp	a5,a6				; match ?
	jreq	chks8				; yes
	callr	fs_inits			; no, reset to default
chks8	rets

**************************************************************************
*											     *
*  fs_inits										     *
* 											     *
*  routine to reset all the initials to the default ones upon factory    *
*  setting.										     *
*											     *
**************************************************************************
fs_inits
	move	@switch,a0,l
	not	a0

	btst	1,a0
	jreq	fsin1
	btst	9,a0
	jreq	fsin1
	jruc	skip_fs_inits		; bypass via joysticks

fsin1	callr	zero_rank_ram
	callr	rank_page_start
	movi	factory_initials,a8	; from this table

fsin2	move	*a8+,a0,w
	subi	'A',a0
	move	*a8+,a1,w
	subi	'A',a1
	move	*a8+,a2,w		; 3 initials
	subi	'A',a2
	move	*a8+,a3,w		; wins in a row
	move	*a8+,a4,l		; score

	calla	insert_entry

	cmpi	factory_end,a8		; done ?
	jrne	fsin2			; nope..

	callr	update_checksum
	callr	rank_page_end

skip_fs_inits
	rets


factory_initials
	.word	'C','R','L',10 			; 1
	.long	3356790
	.word	'M','D','P',9 			; 2
	.long	3251200
	.word	'G','N','P',9  			; 3
	.long	3155600
	.word	'B','Y','L',8  			; 4
	.long	3040930
	.word	'B','B','B',8  			; 5
	.long	2992200
	.word	'F','E','L',8  			; 6
	.long	800000
	.word	'S','A','N',8  			; 7
	.long	700000
	.word	'H','A','I',7 			; 8
	.long	600000
	.word	'S','F','T',7 			; 9
	.long	500000
	.word	'B','B','D',7 			; 10
	.long	400000
	.word	'W','I','T',7 			; 11
	.long	300000
	.word	'H','O','U',6 			; 12
	.long	200000
	.word	'T','T','T',6 			; 13
	.long	100000
	.word	'R','Y','U',6 			; 14
	.long	90000
	.word	'T','W','G',6 			; 15
	.long	80000
factory_end


update_checksum
	callr	compute_new_checksum

stuff_new_checksum
	callr	rank_page_start
	movi	hstd_checksum,a7
	callr	write_a5_to_a7
	addk	16,a7
	srl	8,a5
	callr	write_a5_to_a7
	callr	rank_page_end
	rets

**************************************************************************
*											     *
*  read_cmos_checksum									     *
* 											     *
*  returns: a5 = cmos checksum								     *
*											     *
**************************************************************************
read_cmos_checksum
	callr	rank_page_start
	movi	hstd_checksum,a7
	movb	*a7,a5
	sll	24,a5
	srl	24,a5
	addk	16,a7
	movb	*a7,a0
	sll	24,a0
	srl	24-8,a0
	or	a0,a5
	callr	rank_page_end
	rets

**************************************************************************
*											     *
*  compute_new_checksum - walks through hstd cmos and returns		     *
* 											     *
*  returns: a5 = new checksum								     *
*											     *
**************************************************************************
compute_new_checksum
	callr	rank_page_start
	movi	rankorg,a7
	clr	a5

cnc4	movb	*a7,a0
	sll	24,a0
	srl	24,a0
	add	a0,a5				; add to running checksum
	addk	16,a7
	cmpi	hstd_checksum,a7
	jrne	cnc4
	
	callr	rank_page_end
	rets


rank_page_start
	push	a1
	movi	rank_select,a1
	calla	set_page		; set page to "rank select" page
	calla	cmosunlock
	pull	a1
	rets

rank_page_end
	calla	def_page
	jauc	cmoslock

	.string	"THIS IS MORTAL KOMBAT II"
	.string	"COPYRIGHT (C) 1992,93 MIDWAY MANUFACTURING"
	.string	"ALL RIGHTS RESERVED",0
	.even

;*************************************************************************

write_a5_to_a7
	push	a0
	move	a5,a0
	jruc	write9

write_a4_to_a7
	push	a0
	move	a4,a0
	jruc	write9

write_a3_to_a7
	push	a0
	move	a3,a0
	jruc	write9

write_a2_to_a7
	push	a0
	move	a2,a0
	jruc	write9

write_a1_to_a7
	push	a0
	move	a1,a0
write9	callr	write_a0_to_a7
	pull	a0
	rets

write_a0_to_a7
        .if tunit
	movb	a0,@wp_unlock		; unlock cmos for a one shot write
        .endif
	movb	a0,*a7
	rets

;*************************************************************************

	.end


