**************************************************************************
*											     *
*  video game project:	  Mortal Kombat 2							*
* 											     *
*  program by:		  Edward J. Boon						     *
* 											     *
*  module: mkutil.asm --   often used utilites					     *
* 											     *
*  copyright (c) 1993 midway manufacturing							*
*											     *
**************************************************************************
 	.file	'mkutil.asm'
	.title	" <<< utilities >>> "

	.width	132
	.option	b,d,l
	.mnolist
*
* get the system stuff
*
	.include	dispequ.asm		; display processor equates
	.include	sysequ.asm		; sys.inc and gsp.inc
	.include	macros.hdr		; macros
	.include	mainequ.asm
	.include	imgtbl.glo
	.include	bgndtbl.glo
	.include	diagaudn.asm

	.even
	.text

	.ref	get_aud,store_audit



sans_boonpal
	.long	boonpal

all_palettes
	.long	0

;*******************************************************************

audit_event_check
	calla	aud1			; bumb audit counter
	calla	get_aud			; a1 = current audit value
	cmp	a2,a1
	jrlo	aec_no

	clr	a1			; clear the audit
	calla	store_audit		; store zero
	setc
	rets

aec_no	clrc
	rets

;*******************************************************************

center_around_me
	movi	pid_scroll,a0
	callr	dallprc				; kill old scroller
	movi	pid_shaker,a0
	callr	dallprc
	clr	a0
	move	a0,@worldtly,l
	create	pid_scroll,scroll_center	; make new one
	rets

;*******************************************************************

start_shadows
	movk	1,a0
	move	a0,@f_shadows,w		; flag: do shadows
	move	@p1_obj,a0,l
	callr	ss3
	move	@p2_obj,a0,l
ss3	move	*a0(oflags2),a1,w
	ori	m_shadow,a1		; set the shadow bit
	move	a1,*a0(oflags2),w
	rets

**************************************************************************
*											     *
*  back_to_shang_check - checks if it is time to revert back to shang    *
*                        tsung !								     *
*											     *
**************************************************************************
back_to_shang_check
	calla	am_i_shang		; everybody shang tsung tonight ?
	jrnc	btst9			; without !

	move	*a8(ochar),a0,w
	cmpi	ft_st,a0
	jreq	btst9			; I am in shang form ---> exit

	movi	l_morph,a0
	calla	get_tsl			; a1 = when I changed ?
	cmpi	>40*8,a1		; too much time passed ?
	jrlo	btst9			; no, you are ok
	pull	a0			; yes, time to revert back !!
;	pushp	a0			; we are gonna sleep here
	jsrp	back_to_shang_form	; and away we go
	jauc	reaction_exit

btst9	rets

**************************************************************************
*											     *
*  find_ani_part2 - find the 2nd part of an animation.			     *
* 											     *
*  input: a9 = animation table offset							     *
*											     *
**************************************************************************
find_ani_part2
	calla	get_char_ani
find_part2
	move	*a9+,a0,l
	jrne	find_part2
	rets

find_part_a14
	dec	a14
	jreq	fpa9
	callr	find_part2		; 1st call = part 2
	jruc	find_part_a14
fpa9	rets

**************************************************************************
*											     *
*  find_ani_last_frame - Returns a9 = last frame in an animation table   *
* 											     *
*  Input: a9 = animation table offset							     *
*											     *
**************************************************************************
find_ani_last_frame
	calla	get_char_ani

find_last_frame
	move	*a9+,a0,l
	jrne	find_last_frame

	subi	64,a9		; a9 = last frame of sequence
	rets


ani2	move	a0,*a8(oshape),l	; define current shape !
	move	*a8(oflags),a4,w	; a4 = flags
	move	*a8(oimg),a1,l		; a1 = multipart ram
	
an2	move	*a0+,a5,l		; a5 = img header
	jreq	an9			; zero ---> done

	move	*a5(isag),*a1+,l	; ram entry #1 = sag
	move	*a5(isize),a6,l
	move	a6,*a1+,l		; ram entry #2 = y:x size

	move	*a5(icontrol),a2,w
	andi	>ffcf,a2		; clear the "flip" bits
	move	a4,a3
	andi	>0030,a3		; look only at the "flip" bits
	or	a3,a2
	move	a2,*a1+,w		; ram entry #3 = control word

	move	*a5(ianioffx),a2,w
	move	*a5(ianioffy),a3,w	; grab animation point offsets
	btst	b_fliph,a4		; horz flip ?
	jreq	an3			; no

	neg	a2			; yes, reverse x
	move	a6,a7
	zext	a7,w			; a6 = [0,x] size
	addxy	a7,a2

an3	btst	b_flipv,a4		; vert flip ?
	jreq	an4

	neg	a3			; reverse ani y
	sra	16,a6
	add	a6,a3

an4	move	a2,*a1+,w		; ram entry #4 = dx
	move	a3,*a1+,w		; ram entry #5 = dy
	jruc	an2

an9	clr	a0
	move	a0,*a1,l		; flag: end of multipart pieces
	clrc
	rets

anx	setc
	rets

**************************************************************************
*											     *
*  get_his_action - get other players current p_action			     *
* 											     *
*  returns: a1 = it									     *
*											     *
**************************************************************************
get_his_action
	move	*a13(p_otherproc),a0,l
	move	*a0(p_action),a1,w		; a1 = his action
	rets

**************************************************************************
*											     *
*  get_my_height - Returns how tall I am in A1					     *
*											     *
**************************************************************************
get_my_height
	callr	highest_mpart
	move	@ground_y,a1,w
	sub	a0,a1
	rets

;half_oxvel
;	move	*a8(oxvel),a0,l
;	sra	1,a0
;	move	a0,*a8(oxvel),l
;	rets

**************************************************************************
*											     *
*  screen_half_a0 - Picks a negative or positive A0 based on		     *
* 											     *
*  a8 = left half of screen = negative / a8 = right half of screen = pos *
*											     *
**************************************************************************
screen_half_a0
	move	@worldtlx+16,a2,w
	addi	scrrgt/2,a2
	move	*a8(oxpos),a1,w
	move	*a8(osizex),a4,w
	srl	1,a4
	add	a4,a1			; a1 = middle of object
	cmp	a2,a1
	jrgt	sha0
	neg	a0
sha0	rets



inc_a0_word
	move	*a0,a1,w
	inc	a1
	move	a1,*a0,w
	rets


**************************************************************************
*											     *
*  set_no_block - set the b_noblock bit						     *
*											     *
**************************************************************************
set_no_block
	move	*a8(oflags2),a14,w
	ori	m_noblock,a14
	move	a14,*a8(oflags2),w 	; no blocking allowed by ewe
	rets

set_noflip
	move	*a8(oflags2),a4,w
	ori	m_noflip,a4
	move	a4,*a8(oflags2),w	; I can't be flipped
	rets

set_dmawnz
	move	*a8(oflags),a14,w
	andi	>fff0,a14 		; strip off dma commands
	ori		dmawnz,a14		; set "constant on non-zero"
	move	a14,*a8(oflags),w	
	rets

set_dmacnz
	move	*a8(oflags),a14,w
	andi	>fff0,a14 		; stip off dma commands
	ori	dmacnz,a14		; set "constant on non-zero"
	move	a14,*a8(oflags),w	
	rets

set_noscroll
	move	*a8(oflags2),a14,w
	ori		m_noscroll,a14
	move	a14,*a8(oflags2),w	; screen coordinates
	rets

set_inviso
	move	*a0(oflags2),a4,w
	ori	m_inviso,a4	 	; set inviso flag !
	andni	m_shadow,a4		; turn off shadow
	jruc	stuff_oflags2

clear_inviso
	move	*a0(oflags2),a4,w
	andni	m_inviso,a4	 	; clear inviso flag !
	ori	m_shadow,a4		; turn on shadow

stuff_oflags2
	move	a4,*a0(oflags2),w
	rets


olist_noscroll
	push	a8
oln7	move	*a0,a8,l
	jreq	olns9
	callr	set_noscroll		; sky dont scroll
	move	a8,a0
	jruc	oln7
olns9	pull	a8
	rets

**************************************************************************
*											     *
*  wait_for_start - fighters wait here for the fight to start !!!	     *
*											     *
**************************************************************************
wait_for_start
	calla	stance_setup		; get stance ani / ani speed

wfs4	sleep	1
	calla	next_anirate
	move	@f_start,a0,w 		; start fighting ??
	jreq	wfs4	      		; no ---> loop
	retp

**************************************************************************
*											     *
*  dude who is flipped by goro is xfered here					     *
* 											     *
*  input: a11 = action being done on me !						     *
*											     *
**************************************************************************
flipped_pause
	sleep	1
	move	*a13(p_otherproc),a0,l
	move	*a0(p_action),a0,w
	cmp	a0,a11				; still doing the same thing ?
	jreq	flipped_pause			; yes

	calla	ground_player
;	callr	clear_vflip
	jauc	reaction_exit

**************************************************************************
*											     *
*  wait_for_landing - wait for him 2 land						     *
*											     *
**************************************************************************
wait_for_landing
	sleep	1
	calla	is_he_airborn
	jrc	wait_for_landing
	retp


wait_for_his_dog
	sleep	1
	calla	get_his_dog
	cmp	a10,a0
	jrhi	wait_for_his_dog
	retp

**************************************************************************
*											     *
*  get_his_dfe - get his distance from each edge of the universe	     *
* 											     *
*  returns: a5 = distance from left edge						     *
*           a6 = distance from right edge						     *
*											     *
**************************************************************************
get_his_dfe
	move	*a13(p_otherguy),a0,l
	move	*a0(oxpos),a3,w		; a3 = his x

gdfe4	move	@left_edge,a5,w
	sub	a3,a5
	abs	a5			; a5 = distance from left

	move	@right_edge,a6,w
	addi	scrrgt,a6		; shift to right edge of screen
	sub	a3,a6
	abs	a6			; a6 = distance from right
	rets

get_my_dfe
	move	*a8(oxpos),a3,w
	jruc	gdfe4

get_my_dfeos
	move	*a8(oxpos),a3,w
	jruc	gdfeos4

**************************************************************************
*											     *
*  get_his_dfeos - get his distance from the edge of the screen	     *
* 											     *
*  returns: a5 = distance from left edge						     *
*           a6 = distance from right edge						     *
*											     *
**************************************************************************
get_his_dfeos
	move	*a13(p_otherguy),a3,l
	move	*a3(oxpos),a3,w

gdfeos4	move	@worldtlx+16,a5,w
	move	a5,a6
	addi	scrrgt,a6

	sub	a3,a5
	sub	a3,a6
	abs	a5
	abs	a6
	rets

**************************************************************************
*											     *
*  is_he_helpless - checks if the otherguy is in the air and reacting to *
*                   a collision. if so, carry set				     *
*											     *
**************************************************************************
is_he_helpless
	calla	is_he_airborn
	jrnc	ihh9			; on ground ---> he isn't helpless

	move	*a13(p_otherproc),a0,l
	move	*a0(p_flags),a0,w
	btst	pb_reacting,a0		; is he reacting to another hit ?
	jreq	ihh9			; no, he is jumping

	setc
	rets

ihh9	clrc
	rets


am_i_short
	calla	get_my_height		; a1 = my height
	cmpi	>60,a1
	jrhi	ais_no
	setc
	rets
ais_no	clrc
	rets


is_he_short
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l
	callr	am_i_short
	jruc	him_rets


is_he_close_to_edge
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l
	callr	am_i_close_to_edge
	mmfm	sp,a8,a13
	rets

am_i_close_to_edge
	calla	get_my_dfe		; a5 - a6 edge distances
	calla	is_he_right
	jrc	bsep5
	move	a6,a5
bsep5	movi	>40000,a0		; faster stumble for punched escape
	cmpi	close_to_edge,a5 	; enough room behind me ??
	jrlo	aicy
	clrc
	rets
aicy	setc
	rets


**************************************************************************
*											     *
*  fade_all_sky - fade down all palettes and sky as well.			     *
*											     *
**************************************************************************
fade_all_sky
	movi	>800,a9
	create	pid_fade,skydown

fade_all
	movi	all_palettes,a0
	jauc	fadeout


sync_wait_dma_q
	move	@tick,a0,w
vss2	move	@tick,a1,w
	cmp	a0,a1
	jreq	vss2
*
* a1 = current tick
*
swd7	move	b13,b13
	jreq	swd9
	move	@tick,a0,w
	cmp	a0,a1			; still in same interupt ?
	jreq	swd7			; yes, keep waiting
swd9	rets

**************************************************************************
*											     *
*  page_0_setup - set things up for a static (sans object) plot to	     *
*                 page zero. by doing the following:				     *
* 											     *
*  1. turn display off									     *
*  2. turn off autoerase									     *
*  3. look at page 0									     *
*  4. plot to page 0									     *
*											     *
**************************************************************************
page_0_setup
	calla	oinit			; clear objects !
	callr	dont_show_scores

page_0_setup_no_init
	clr	a0
	move	a0,@displayon,w
	move	a0,@f_auto_erase,w
	not	a0
	move	a0,@noflip,w	   	; take control of page flipping !!
	callr	view_page_0
	movi	page0adr+xpadding,a1	; plot to page 0
	move	a1,@pageaddr,l		; plot to page 0
	movi	[253,0],a0
	move	a0,@dmatplft,l 		; set dma window to page 0
	rets


view_page_1
	movi	dpystrt1,a0
	jruc	view2

view_page_0
	movi	dpystrt0,a0
view2	move	a0,@dpystrt,w		; look at page 0
	rets

**************************************************************************
*											     *
*  drone_kill_init - put initial value into c_drone_kill			     *
*											     *
**************************************************************************
drone_kill_init
	movk	20,a0
	move	a0,@c_drone_kill,w
	rets

**************************************************************************
*											     *
*  reset_proc_stack - reset the proc stack pointer a12 to its initial    *
*                     spot.								     *
*											     *
**************************************************************************
reset_proc_stack
	move	a13,a12
	addi	prcsiz,a12
	rets


**************************************************************************
*											     *
*  clear_p_ram - Clear a proc's (a0) "p" ram					     *
*											     *
**************************************************************************
clear_p_ram
	mmtm	sp,a0,a1,a2
	clr 	a1
	move	a0,a2
	addi	pdata,a0		; a0 --> pdata area
	addi	p_end,a2		; a2 --> end of pdata area

cpr4	movb	a1,*a0
	addk	8,a0
	cmp	a0,a2
	jrhs	cpr4

	mmfm	sp,a0,a1,a2
	rets

**************************************************************************
*											     *
*  whoosh_and_ya - make a whoosh sound and an attack voice sound	     *
*											     *
**************************************************************************
whoosh_and_ya
;	calla	whoosh_sound
;	jauc	punch_attack_voice
	rets

**************************************************************************
*											     *
*  double_compare - double compare command. if either a0 or a1 = a2	     *
*               	   then we return equal, else ne 				     *
*											     *
**************************************************************************
double_compare
	cmp	a0,a2
	jreq	dc_yes
	cmp	a1,a2
dc_yes	rets

**************************************************************************
*											     *
*  make_solid_object - create a solid color object given			     *
* 											     *
*  input: a0 = constant color to use							     *
*         a3 = y:x size of object	 						     *
*											     *
**************************************************************************
make_solid_object
	mmtm	sp,a0,a3
	movi	solid_object_img,a5
	calla	get_single_obj		; single object needed here

	move	*a8(oflags),a4,w
	andni	m_wrnonz,a4
	move	a4,*a8(oflags),w	; we dont want "write non-zero" set
	mmfm	sp,a0,a3

	move	a0,*a8(oconst),w 	; set color
	move	a3,*a8(osize),l	 	; set size
	rets

solid_object_img
	.word   10,10,0,0
	.long   >2000000
	.word   dmacal|>1000		; 1 bit per pixel
	.long   boonpal

**************************************************************************
*											     *
*  set_xy_coordinates - set an object exactly on a certain point	     *
* 											     *
*  input: a4 = y:x coordinate								     *
*         a8 = object									     *
*											     *
**************************************************************************
set_xy_coordinates
	move	a4,a14
	sra	16,a4
	move	a4,*a8(oypos),w
	sll	16,a14
	sra	16,a14
	move	a14,*a8(oxpos),w
	rets

**************************************************************************
*											     *
*  center_obj_x - center an object (a8) in the middle of the screen	     *
*											     *
**************************************************************************
center_obj_x
	movi	scrrgt/2,a0
	move	*a8(osizex),a1,w
	srl	1,a1			; 1/2 x size
	sub	a1,a0
	move	a0,*a8(oxpos),w		; set centered x

;	movi	scrbot/2,a0
;	move	*a8(osizey),a1,w
;	srl	1,a1
;	sub	a1,a0
;	move	a0,*a8(oypos),w

	rets

**************************************************************************
*											     *
*  display_on/off - put a "1/0" in displayon  					     *
*											     *
**************************************************************************
display_off
	clr	a0
	jruc	disp3

display_on
	movk	1,a0
disp3	move	a0,@displayon,w
	rets

**************************************************************************
*											     *
*  killfx - kill all fx procs and objects						     *
*											     *
**************************************************************************
killfx
	movi	oid_fx,a0
	calla	dallobj
	movi	pid_fx,a0
	jruc	dallprc

**************************************************************************
*											     *
*  idle_lightning - xfer raiden's lighting process so it does not zap    *
*                   no moe !								     *
*											     *
**************************************************************************
idle_lightning
	clr	a1
	not	a1
	movi	pid_lightning,a0
	calla	existp
	jreq	light9

	movi	lightning_idle_xfer,a7
	calla	fastxfer

light9	rets


lightning_idle_xfer
	move	*a13(p_butport),a8,l		; a8 = single object bolt
	movi	null_image,a1
	calla	ani_flag			; null image for ewe
	move	*a13(p_joyport),a8,l		; a8 = multi object bolt
	callr	multi_null			; null 4u2 !!
	jauc	wait_forever			; meanwhile i'll just hang out !

**************************************************************************
*											     *
*  damage_to_him - routine to cause damage to other player		     *
* 											     *
*  input: a0 = damage to inflict								     *
*											     *
**************************************************************************
damage_to_him
	mmtm	sp,a8,a10
	move	a0,a10
	move	*a13(p_otherguy),a8,l
	clr	b0
	calla	damage_to_me
	mmfm	sp,a8,a10
	rets

**************************************************************************
*												*
*  exobj_er											*
*												*
*  finds an object, if it does not exist then it errors.				*
*												*
*  input: a0 = object id 									*
*												*
**************************************************************************
exobj_er
	push	a1
	clr	a1
	not	a1
	calla	existobj		; anybody home ?
	jrne	eobjex
	ermac	3
eobjex	pull	a1
	rets

**************************************************************************
*												*
*  exprc_er											*
*												*
*  finds a process, if it does not exist then it errors.				*
*												*
*  input: a0 = process id									*
*												*
**************************************************************************
exprc_er
	push	a1
	clr	a1
	not	a1
	calla	existp			 ; anybody home ?
	jrne	eobjex
	ermac	4
eprcex	pull	a1
	rets


show_scores
	movk	1,a0
	jruc	ds3

dont_show_scores
	clr	a0
ds3	move	a0,@f_doscore,w		; dont display score
	rets

**************************************************************************
*											     *
*  score_b0 - score routine								     *
* 											     *
*  input: b0 = encoded score value (amount to add, byte offset)		*
*         a1 = score to add to (0 = player 1 ; 1 = player 2)	     	*
*											     *
**************************************************************************
score_b0
	move	b0,a0
	jreq	score9			; zero points ----> exit

	movi	p1_score,a2
	move	a1,a1
	jreq	score3
	movi	p2_score,a2		; pick the requested score area !!
score3	move	a2,a3			; a3 = 1st byte
	move	a0,a1

	sll	16,a1
	srl	16-3,a1			; a1 = byte offset * 8
	add	a1,a2			; a2 ---> byte to add to
	srl	16,a0			; a0 = amount to add

score4	movb	*a2,a1			; a1 = byte
	add	a0,a1
	cmpi	>0a,a1			; overflow ?
	jrlo	score5			; nope....

	subk	>0a,a1			; yes ---> use only the "ones"
	movb	a1,*a2			; and store
	subk	8,a2			; move back a digit
	movk	1,a0			; next digit goes up by "1"
	cmp	a3,a2 			; biggest digit ?
	jrhs	score4			; nope, loop
*
* score has maxed out
*
	movi	>09090909,a0
	move	a0,*a3,l
	move	a0,*a3(32),l		; stay at 99,999,999
	rets

score5	movb	a1,*a2
score9	rets

**************************************************************************
*											     *
*  get_single_obj - Get a single (non-multipart) object			     *
* 											     *
*  Input: a5 = OIMG to get info from								*
*											     *
**************************************************************************
get_single_obj
	callr	object_setup
	move	a5,*a8(oimg),l
	move	*a5(isag),*a8(osag),l	; pass sag
	move	*a5(isize),*a8(osize),l	; pass size
	rets

*
* set bits: dmawnz + m_noscroll
*
gso_dmawnz_ns
	callr	gso_dmawnz
	jruc	set_noscroll

gso_dmawnz
	callr	get_single_obj
	jruc	set_dmawnz

gso_dmacnz
	callr	get_single_obj
	jruc	set_dmacnz


**************************************************************************
*											     *
*  gmo_proc - Get multipart object using a process for the multipart ram *
* 											     *
*  Input: a9 = frame with all the info						     *
* 											     *
*  Returns: a0 = dummy process created						     *
*											     *
**************************************************************************
gmo_proc
	movi	multi_dummy_proc,a7
	movi	pid_mpo,a1
	calla	getprc	   	; grab a process for ram

	movi	>1000,a6
	move	a6,*a0(ptime),w	; sans wakeup

	push	a0
	move	a0,a6
	addi	pdata,a6   	; a6 = multipart ram starts here !!
	move	*a9,a5,l   	; a5 = frame #1
	callr	get_multi_obj
	pull	a0

	rets

**************************************************************************
*											     *
*  kmo_proc - Kill multipart object / process					     *
* 											     *
*  Input: a2 = object in question							     *
*											     *
**************************************************************************
kmo_proc
	move	*a2(oslink),a0,l	; proc
	move	*a0(pwake),a1,l
	cmpi	multi_dummy_wake,a1	; still a dummy proc ?
	jrne	kmop3			; no
	calla	kill			; yes, kill proc
kmop3	move	a2,a0
	jauc	delobjp			; kill obj


multi_dummy_proc
	sleep	>1000
multi_dummy_wake
	jruc	multi_dummy_proc

**************************************************************************
*											     *
*  get_multi_obj - Get a multipart object						     *
* 											     *
*  Input: a5 = frame #1									     *
*         a6 = multipart ram									*
*											     *
**************************************************************************
get_multi_obj
	push	a5
	move	*a5,a5,l
	callr	object_setup

;****************
	move	*a5(icontrol),a4,w
	ori	dmawnz,a4
	move	a4,*a8(oflags),w
;****************

	move	a6,*a8(oimg),l		; multipart ram
	move	*a8(oflags2),a4,w
	ori	m_multipart,a4		; set the multipart bit
	move	a4,*a8(oflags2),w
	pull	a0
	jruc	ani2			; object shape = frame #1


object_setup
	calla	getobj
	jrne	gmo4
	ermac	5	       		; error #8 - no objects left
gmo4  	move	a0,a8			; a8 = the obj
	move	*a5(icmap),a0,l		; a0 = multipart palette
	calla	getfpal
	move	a0,*a8(opal),w

	clr	a0
	move	a0,*a8(ozval),l    	; initial z

	move	*a5(icontrol),a4,w
	ori	dmago,a4
	move	a4,*a8(oflags),w
	rets


clear_shadow_bit
	move	*a8(oflags2),a4,w
	andni	m_shadow,a4
	move	a4,*a8(oflags2),w
	rets

**************************************************************************
*											     *
*  flip_multi - flip a multipart object						     *
* 											     *
*  input: a8 = 1st object on list (oslinked together)			     *
*											     *
**************************************************************************
flip_multi
	move	*a8(oflags),a4,w
	xori	m_fliph,a4
	move	a4,*a8(oflags),w	; reverse flip bit
	move	*a8(oshape),a0,l	; get current shape
	jauc	ani2			; and run through ani with flipped bit


flip_multi_v
	move	*a8(oflags),a4,w
	xori	m_flipv,a4
	move	a4,*a8(oflags),w	; reverse flip bit
	move	*a8(oshape),a0,l	; get current shape
	jauc	ani2			; and run through ani with flipped bit


flip_single
	move	*a8(oflags),a4,w
	xori	m_fliph,a4
	move	a4,*a8(oflags),w	; reverse flip bit

	move	*a8(oimg),a1,l		; get the current image pointer
	calla	ani0			; setup the "new" image
	rets

	btst	b_fliph,a4		; horz flip ?
	jreq	fsing4

	move	*a1(isizex),a0,w
	move	*a8(oxpos),a2,w
	sub	a0,a2
	move	a2,*a8(oxpos),w

fsing4	btst	b_flipv,a4		; vert flip ?
	jreq	fsing5

	move	*a1(isizey),a0,w
	move	*a8(oypos),a2,w
	sub	a0,a2
	move	a2,*a8(oypos),w

fsing5	rets


**************************************************************************
*											     *
*  get_char_long - get a characters longword entry from a table  	     *
* 											     *
*  input: a0 = table of entries (longwords)					     *
*											     *
**************************************************************************
get_char_long
	move	a0,a1
	move	*a8(ochar),a0,w
	sll	5,a0
	add	a1,a0
	move	*a0,a0,l
	rets

**************************************************************************
*											     *
*  ochar_call - character specific routine caller				     *
* 											     *
*  input: a0 = table of routines for each character				     *
*											     *
**************************************************************************
ochar_call
	callr	get_char_long
	jreq	chc4			; zero = no routine to call
	jump	a0
chc4	rets


ochar_jump
	callr	get_char_long
	jump	a0

**************************************************************************
*											     *
*  delete_multi - delete a multipart object					     *
* 											     *
*  input: a8 = object goin bye bye							     *
*											     *
**************************************************************************
delete_multi
	rets

**************************************************************************
*											     *
*  multi_null - make a multipart object all null_image			     *
* 											     *
*  input: a8 = object									     *
*											     *
**************************************************************************
multi_null
	movi	null_frame,a0
	move	a0,*a8(oshape),l
	rets

null_frame	
	.long	null_image
	.long	0

null_image
	.word	0,0,0,0
	.long	>2000000
	.long	0


do_first_a9_frame
	calla	get_char_ani		; a9 = frame #1
	jruc	do_next_a9_frame

do_next_a11_for_a10
	mmtm	sp,a8,a9
	move	a10,a8	
	move	a11,a9			; borrow these variables
	callr	do_next_a9_frame	; do it
	move	a8,a10
	move	a9,a11			; update em
	mmfm	sp,a8,a9
	rets

**************************************************************************
*											     *
*  do_next_a9_frame - standard "advance to next frame" routine		     *
* 											     *
*  input: a9 = animation table pointer						     *
* 											     *
*  returns: zero ---> end of animation reached !!				     *
* 	carry ---> skip sleep flag							     *
*											     *
**************************************************************************
do_next_a9_frame
	move	*a9+,a0,l
	jreq	gnf9			; zero = done

	cmpi	ani_lastcom,a0		; animation command ?
	jrls	gnf8			; yes, do it
	callr	ani2

	move	a9,a9			; dont set "zero" flag
	clrc
gnf9	rets

gnf8	sll	5,a0
	addi	animation_commands,a0
	move	*a0,a0,l
	jump	a0			; yes ---> jump to proper address

animation_commands
	.long	gnf9
	.long	do_ani_jump
	.long	do_ani_flip
	.long	do_ani_adjustx
	.long	do_ani_adjustxy
	.long	do_ani_nosleep
	.long	do_ani_calla
	.long	do_ani_sound
	.long	do_ani_ochar_jump
	.long	do_ani_flip_vert


do_ani_flip_vert
	callr	flip_multi_v
	jruc	do_next_a9_frame	; and go fetch a real image

do_ani_ochar_jump
	move	*a9+,a0,w		; grab ochar to check for
	calla	am_i_him		; am i this guy ?
	jrc	do_ani_jump		; yes, ani_jump
	addi	32,a9			; a9 ---> skip past jump
	jruc	do_next_a9_frame	; and go fetch a real image


do_ani_sound
	move	*a9+,a0,l		; a0 = sound call to make
	calla	triple_sound
	jruc	do_next_a9_frame	; and go fetch a real image

do_ani_calla
	move	*a9+,a0,l		; a0 = routine to call !!
	call	a0			; call it.
	jruc	do_next_a9_frame	; and go fetch a real image

do_ani_jump
	move	*a9,a9,l		; animation pointer jump
	jruc	do_next_a9_frame	; and go fetch a real image

do_ani_flip
	callr	flip_multi
	jruc	do_next_a9_frame	; and go fetch a real image

do_ani_adjustx
	move	*a9+,a0,w		; a0 = amount to adjust x by
	clr	a1			; a1 = amount to adjust y by
	callr	multi_adjust_xy
	jruc	do_next_a9_frame	; and go fetch a real image

do_ani_adjustxy
	move	*a9+,a0,w
	move	*a9+,a1,w
	callr	multi_adjust_xy
	jruc	do_next_a9_frame	; and go fetch a real image

do_ani_nosleep
	move	*a9+,a0,l		; grab frame which does not sleep
	callr	ani2
	move	a9,a9			; clear the zero flag
	setc				; flag: dont sleep please
	rets



**************************************************************************
*											     *
*  animate_a9 - animate through a sequence given				     *
* 											     *
*  a9 = [sleep time,animation offset]							     *
*											     *
**************************************************************************
animate_a9
	move	a9,a0
	srl	16,a0		; a0 = sleep time
	push	a0
	zext	a9,w		; a9 = animation offset
	calla	get_char_ani
	pull	a0
	jruc	mframew

animate2_a9
	move	a9,a0
	srl	16,a0		; a0 = sleep time
	push	a0
	zext	a9,w		; a9 = animation offset
	calla	get_char_ani2
	pull	a0
	jruc	mframew

**************************************************************************
*											     *
*  pose_a9 - Pose me according to:							     *
* 											     *
*  a9 = [longword # offset , animation offset]					     *
*											     *
**************************************************************************
pose_a9	move	a9,a0
	srl	16-5,a0		; a0 = longword offset
	push	a0
	zext	a9,w		; a9 = animation offset
	calla	get_char_ani
	jruc	pose2

pose2_a9
	move	a9,a0
	srl	16-5,a0		; a0 = longword offset
	push	a0
	zext	a9,w		; a9 = animation offset
	calla	get_char_ani2
pose2	pull	a0
	add	a0,a9
	jruc	do_next_a9_frame

**************************************************************************
*											     *
*  act_mframew - same as routine below but my action is also defined.    *
* 											     *
*  input: a1 = action being done (stuffed into p_action)			     *
*         a8 = 1st object on list							     *
*         a0 = sleep time between each frame					     *
*         a9 = table of animations							     *
*											     *
**************************************************************************
act_mframew_z
	move	a1,*a13(p_action),w
	jsrp	mframew
	clr	a1
	move	a1,*a13(p_action),w		; clear "action"
	retp

act_mframew
	move	a1,*a13(p_action),w
;	<<<<<<<< fall through >>>>>>>>>

**************************************************************************
*											     *
*  mframew - animate through a list of multipart frames.			     *
* 											     *
*  input: a8 = 1st object on list							     *
*         a0 = sleep time between each frame					     *
*         a9 = table of animations							     *
*											     *
**************************************************************************
mframew
	move	a0,-*a12,l		; save sleep time (pushp a0)
mfr5	callr	do_next_a9_frame
	jreq	mfr9
	jrc	mfr5			; carry set = skip sleep
	move	*a12,a0,l		; pull sleep time but keep stack same
	calla	prcslp			; sleep
	jruc	mfr5
mfr9	pullp 	a0
	retp


**************************************************************************
*											     *
*  backwards_ani - walk through an animation backwards given:		     *
* 											     *
*  input: a9 = animaition table offset						     *
*         a1 = sleep time between frames						     *
*											     *
**************************************************************************
backwards_ani
	move	a1,-*a12,l		; save sleep time (pushp a0)
	calla	get_char_ani
	move	a9,a10			; a10 = frame #1
bani3	addi	32,a9
	move	*a9,a0,l		; end of animation ?
	jrne	bani3			; no

bani4	move	-*a9,a0,l
	calla	ani2

	move	*a12,a0,l		; pull sleep time but keep stack same
	calla	prcslp
	cmp	a9,a10
	jrne	bani4

	pullp	a1
	retp

**************************************************************************
*											     *
*  animate_a0_frames - walk an animation script according to..		     *
* 											     *
*  a0 = [sleep time,# of frames]							     	*
*											     *
**************************************************************************
animate_a0_frames
	pushp	a10
	move	a0,a1
	srl	16,a1
	move	a1,-*a12,l		; save sleep time (pushp a1)

	move	a0,a10
	sll	16,a10
	srl	16,a10			; a10 = # of frames

mwa05	callr	do_next_a9_frame
	jreq	mwa09			; zero = we done !!
	move	*a12,a0,l		; pull sleep time but keep stack same
	calla	prcslp			; sleep
	dsjs	a10,mwa05

mwa09	pullp 	a0
	pullp	a10
	retp

**************************************************************************
*											     *
*  mframew_a0 - same as mframew but a0 = [sleep time, # of frames]		*
* 											     *
**************************************************************************
mframew_a0
	pushp	a10
	move	a0,a10
	sll	16,a10
	srl	16,a10			; a10 = # of frames
	srl	16,a0			; a0 = sleep time !
	move	a0,-*a12,l		; save sleep time (pushp a0)

mfa03	callr	do_next_a9_frame	; end of line ----> abort
	move	*a12,a0,l		; pull sleep time but keep stack same
	calla	prcslp			; sleep
	move	*a9,a0,l
	jreq	mfa04	 		; end of ani reached ----> abort
	dsjs	a10,mfa03

mfa04	pullp	a0
	pullp	a10
	retp

**************************************************************************
*											     *
*  init_anirate - initialize p_anirate and zero p_anicount so we will    *
*                 animate on first call of next_anirate			     *
* 											     *
*  input: a0 = animation speed								     *
*											     *
**************************************************************************
init_anirate
	cmpi	never_ani,a0			; animate ?
	jreq	inita2				; no

	move	a0,*a13(p_anirate),w		; speed o animation
	movk	1,a0
	move	a0,*a13(p_anicount),w	; 1st call = animate !!
	rets

inita2	move	a0,*a13(p_anirate),w		; speed o animation
	move	a0,*a13(p_anicount),w	; never animate
	rets

**************************************************************************
*											     *
*  mframe_a0 - animate through a list of multipart frames and sleep time *
* 											     *
*  input: a8 = 1st object on list							     *
*         a9 = table of animations / sleep times				     *
*											     *
**************************************************************************
mframe_a0
	move	*a9+,a0,l
	jreq	mfra09
	callr	ani2

	move	*a9+,a0,w		; a0 = sleep time
	jreq	mfra09			; zero ----> return
	calla	prcslp
	jruc	mframe_a0

mfra09	retp

**************************************************************************
*											     *
*  set_x_woff - set animation x for a multipart object			     *
* 											     *
*  input: a0 = desired ani x								     *
*         a8 = object									     *
*											     *
**************************************************************************
set_x_woff
	move	@worldtlx+16,a2,w
	add	a2,a0
	move	a0,*a8(oxpos),w
	rets

**************************************************************************
*											     *
*  ground_multi - plants a dudes feet on da ground				     *
* 											     *
*  input: a8 = 1st object of his multi-part object				     *
*											     *
**************************************************************************
ground_multi
	callr	lowest_mpart		; a6 = lowest multipart

	move	@ground_y,a0,w		; a0 = ground y
	sub	a1,a0			; a0 = distance we gotta travel

	push	a8

grmul6	move	*a8(oypos),a1,w
	add	a0,a1
	move	a1,*a8(oypos),w		; adjust each object
	move	*a8(oslink),a8,l
	jrne	grmul6

	pull	a8
	rets


adjust_xy_a5
	push	a8
	move	a5,a8
	callr	multi_adjust_xy
	pull	a8
	rets


multi_adjust_xy
	push	a4
	move	*a8(oflags),a4,w
	btst	b_fliph,a4
	jreq	maj4
	neg	a0			; flipped image = flip x direction
maj4	move	*a8(oxpos),a2,w
	add	a0,a2
	move	a2,*a8(oxpos),w		; adjust x coordinate

	move	*a8(oypos),a2,w
	add	a1,a2
	move	a2,*a8(oypos),w		; adjust y

	pull	a4
	rets

**************************************************************************
*											     *
*  face_opponent - make sure i am pointing at the other dude.		     *
* 											     *
*  input: a8 = object (multipart)							     *
*											     *
**************************************************************************
face_opponent
	move	*a8(oflags),a0,w
	andi	m_fliph,a0		; only interested in this bit
	movi	m_fliph,a1
	calla	is_he_right		; attacker to the right of me ??
	jrnc	face3			; no, i should be flipped
	clr	a1			; yes, i should not be flipped
face3	cmp	a1,a0			; are we cool ?
	jreq	face4
    	jruc	flip_multi		; no, correct me
face4	rets

**************************************************************************
*											     *
*  match_ani_points - set a multipart object's animation x to match		*
*                     another object's ani x,y						*
* 											     *
*  input: a8 = object to match with								*
*         a0 = object which changes								*
*											     *
**************************************************************************
match_ani_points
	move	*a8(oxval),*a0(oxval),l
	move	*a8(oyval),*a0(oyval),l

	move	*a8(oflags),a1,w	; my flags
	move	*a0(oflags),a2,w	; his flags

	move	*a0(oflags2),a3,w
	btst	b_multipart,a3		; multipart ?
	jreq	match_single		; no, single

	andi	m_fliph,a1
	andi	m_fliph,a2		; look only at flip bits
	cmp	a1,a2			; same direction ?
	jreq	map9			; yes, exit

	mmtm	sp,a0,a8
	move	a0,a8
	callr	flip_multi		; flip multiparter
	mmfm	sp,a0,a8

map9	rets


match_single
	andi	m_fliph,a1
	andi	m_fliph,a2		; look only at flip bits
	cmp	a1,a2			; same direction ?
	jreq	maps1			; yes, exit

	move	*a0(oflags),a2,w
	xori	m_fliph,a2
	move	a2,*a0(oflags),w	; reverse flip bit

maps1	move	*a0(oimg),a1,l
	move	*a1(ianioffx),a3,w
	move	*a1(ianioffy),a4,w	; grab animation point offsets
	move	*a0(oxpos),a5,w
	move	*a0(oypos),a6,w

	move	*a0(oflags),a2,w

	btst	b_fliph,a2		; horz flip ?
	jreq	maps2			; no
	neg	a3

	move	*a1(isizex),a1,w
	sub	a1,a5

maps2	btst	b_flipv,a2
	jreq	maps3
	neg	a4
maps3	sub	a3,a5			; ani adjust x
	sub	a4,a6			; ani adjust y
	
	move	a5,*a0(oxpos),w
	move	a6,*a0(oypos),w		; stuff ani adjusted coordinates
	rets

**************************************************************************
*											     *
*  ground_player - grounds a player according to his animation point     *
* 											     *
*  input: a8 = object										*
*											     *
**************************************************************************
ground_player
	move	*a13(p_ganiy),*a8(oypos),w	; a0 = grounded ani y
 	rets

**************************************************************************
*											     *
*  is_he_right - answers the question: is the other dude to the right 	*
*                of me ?								     	*
* 											     *
*  returns: carry set = yes								     *
*											     *
**************************************************************************
is_he_right
	move	*a13(p_otherguy),a4,l
	move	*a4(oxval),a4,l
	move	*a8(oxval),a3,l
	cmp	a3,a4
	jrgt	right_yes
	clrc
	rets

right_yes
	setc
	rets


am_i_shang
	move	@p1_char,a1,w
	move	@p1_obj,a0,l
	cmp	a0,a8
	jreq	imp1
	move	@p2_char,a1,w
imp1	cmpi	ft_st,a1     	; was I originally shang tsung ?
	jreq	amisyes	     	; yup
	clrc
	rets

amisyes	setc
	rets


*
* a9 = [goro ani offset, normal ani offset]
*
boss_pick_ani
goro_pick_ani
	mmtm	sp,a0,a1,a2,a3
	move	*a8(ochar),a0,w
	cmpi	ft_goro,a0
	jreq	gpa3
	cmpi	ft_final_boss,a0
	jreq	gpa3
	zext	a9,w		; normal guys use the lower part
	jruc	gpa5

gpa3	srl	16,a9
gpa5	mmfm	sp,a0,a1,a2,a3
	rets


am_i_a_boss
	move	a8,a14
	jruc	ihab1

is_he_a_boss
	move	*a13(p_otherguy),a14,l
ihab1	move	*a14(ochar),a14,w
	cmpi	ft_final_boss,a14
	jreq	ihaby

ihab2	cmpi	ft_goro,a14
	jreq	ihaby
	clrc
	rets
ihaby	setc
	rets

;***********************************************************************



if_not_boss_branch
	pull	a7   		; a7 = return address
	mmtm	sp,a0,a1,a2,a3

	move	*a8(ochar),a0,w
	cmpi	ft_goro,a0
	jreq	igb2
	cmpi	ft_final_boss,a0
	jreq	igb2
	jruc	igb3

if_boss_branch
	pull	a7   		; a7 = return address
	mmtm	sp,a0,a1,a2,a3

	move	*a8(ochar),a0,w
	cmpi	ft_goro,a0
	jreq	igb3
	cmpi	ft_final_boss,a0
	jreq	igb3

igb2	addi	32,a7		; skip the long word
	jruc	igb9

igb3	move	*a7,a7,l
igb9	mmfm	sp,a0,a1,a2,a3
	jump	a7


**************************************************************************
*											     *
*  highest_mpart - finds the object on a multipart object		 		*
*                  thats highest off the ground (lowest value)			*
* 											     *
*  input: a8 = 1st obect	    returns: a0 = coordinate of highest point   *
*                                          (lowest value)                *
*											     *
**************************************************************************
highest_mpart
	mmtm	sp,a1,a2,a3,a7
	move	*a8(oypos),a1,w		; a1 = ani y
	move	*a8(oimg),a7,l		; a7 = multipart ram
	movi	>ffff,a0		; a0 = smallest value so far

fhi2	move	*a7(32+32+16+16),a2,w	; a2 = ani y
	move	a1,a3
	sub	a2,a3	      		; a3 = y coordinate of piece
	cmp	a0,a3			; highest object so far ?
	jrge	fhi3			; no
	move	a3,a0			; yes ---> new "lowest y value"

fhi3	addi	32+32+16+32,a7
	move	*a7,a2,l		; sag ? (another piece?)
	jrne	fhi2			; yes
	mmfm	sp,a1,a2,a3,a7
	rets

**************************************************************************
*											     *
*  lowest_mpart - finds the lowest part of a multipart obj			*
* 											     *
*  input: a8 = 1st obect	    returns: a1 = coordinate of lowest point    *
*                                          (highest value)               *
*											     *
**************************************************************************
lowest_mpart 
	mmtm	sp,a0,a2,a3,a7
	move	*a8(oypos),a0,w		; a1 = ani y
	move	*a8(oimg),a7,l		; a7 = multipart ram
	clr	a1			; a1 = biggest value so far

flo2	move	*a7(32+32+16+16),a2,w	; a2 = ani y
	move	a0,a3
	sub	a2,a3	      		; a3 = y coordinate of piece
	move	*a7(32+16),a2,w		; a2 = y size
	add	a2,a3			; a3 = bottom of piece

	cmp	a1,a3			; lowest object so far ?
	jrle	flo3			; no
	move	a3,a1			; yes ---> new "highest y value"

flo3	addi	32+32+16+32,a7
	move	*a7,a2,l		; sag ? (another piece?)
	jrne	flo2			; yes
	mmfm	sp,a0,a2,a3,a7
	rets

**************************************************************************
*											     *
*  leftmost_mpart - finds the object on a multipart object list 		*
*                   thats the leftmost (smallest x)					*
* 											     *
*  input: a8 = 1st obect	    returns: a2 = leftmost coordinate			*
*											     *
**************************************************************************
leftmost_mpart 
	mmtm	sp,a0,a1,a3,a4,a7
	move	*a8(oxpos),a0,w		; a1 = ani x
	move	*a8(oimg),a7,l		; a7 = multipart ram
	movi	>ffff,a2		; a2 = leftmost value so far

flm2	move	*a7(32+32+16),a4,w	; a4 = ani x
    	move	a0,a3
	sub	a4,a3	      		; a3 = x coordinate of piece
	cmp	a2,a3			; leftmost object so far ?
	jrge	flm3			; no
	move	a3,a2			; yes ---> new "leftmost y value"

flm3	addi	32+32+16+32,a7
	move	*a7,a4,l		; sag ? (another piece?)
	jrne	flm2			; yes

	mmfm	sp,a0,a1,a3,a4,a7
	rets

**************************************************************************
*											     *
*  rightmost_mpart - finds the object on a multipart object list 		*
*                    thats the rightmost (biggest x)					*
* 											     *
*  input: a8 = 1st obect	    returns: a3 = rightmost coordinate		*
*											     *
**************************************************************************
rightmost_mpart
	mmtm	sp,a0,a1,a2,a4,a7
	move	*a8(oxpos),a0,w		; a1 = ani x
	move	*a8(oimg),a7,l		; a7 = multipart ram

	movi	-5000,a3		; a3 = leftmost value so far

frm2	move	*a7(32+32+16),a2,w	; a2 = ani x
	move	a0,a4
	sub	a2,a4	      		; a4 = x coordinate of piece

	move	*a7(32),a2,w		; a2 = x size
	add	a2,a4			; a4 = right side of piece
	cmp	a3,a4			; rightmost object so far ?
	jrle	frm3			; no
	move	a4,a3			; yes ---> new "rightmost"

frm3	addi	32+32+16+32,a7
	move	*a7,a2,l		; sag ? (another piece?)
	jrne	frm2			; yes

	mmfm	sp,a0,a1,a2,a4,a7
	rets

**************************************************************************
*											     *
*  distance_from_ground										*
* 											     *
*  returns: a0 = distance								     *
*											     *
**************************************************************************
distance_from_ground
	move	@ground_y,a0,w
dfg2	move	*a8(oypos),a2,w
	sub	a2,a0
	rets

distance_off_ground
	move	*a13(p_ganiy),a0,w
	jruc	dfg2

**************************************************************************
*											     *
*  gravity_ani - gravity / animation loop routine				     *
* 											     *
*  input:  a0 = animation speed								     *
*          a1 = initial y velocity							     *
* 	  a6 = routine to call everytick (zero = no routine)		     *
*          a9 = animation table								     *
*         a10 = gravity									     *
* 											     *
*        *a13(p_ganiy) = ground level							     *
*											     *
**************************************************************************
gravity_ani
	move	*a8(oflags2),a4,w
	btst	b_multipart,a4
	jreq	gravani_single

	move	a6,*a13(p_store4),l	; save routine to call 

	move	a1,a1
	jreq	gani1			; zero yvel ---> don't stuff
	move	a1,*a8(oyvel),l		; send 'em skywards
gani1	callr	init_anirate		; setup animation speed

gani2	sleep	1

	move	*a13(p_store4),a6,l	; routine to call 
	jreq	gani3			; none ---> skip o
	push	a10
	call	a6
	pull	a10

gani3	callr	next_anirate
	move	*a8(oyvel),a0,l
	add	a10,a0
	move	a0,*a8(oyvel),l		; gravity
	jrn	gani2			; heading upwards = loop
	callr	hit_ground_yet
	jrnc	gani2

	calla	stop_me
	callr	ground_player
	clr	a0
	movb	a0,*a13(p_hit)
	retp

*
* single object version of gravity ani
*
gravani_single
	cmpi	gnull,a1
	jreq	gani5
	move	a1,*a8(oyvel),l		; send 'em skywards
gani5	cmpi	gnull,a0
	jreq	gani6
	callr	init_anirate		; setup animation speed
gani6	cmpi	gnull,a6
	jreq	gani7
	move	a6,*a13(p_store4),l	; save routine to call 
*
* single part object gravity loop
*
gani7	sleep	1
	cmpi	gnull,a9
	jreq	gani8
	callr	next_anirate

gani8	move	*a8(oyvel),a0,l
	add	a10,a0
	move	a0,*a8(oyvel),l		; single object = gravity by hand
	jrn	gani7			; heading upwards = loop

	callr	hit_ground_yet 		; well ??
	jrnc	gani7
	calla	stop_a8
	retp

hit_ground_yet
	move	*a8(oypos),a2,w
	move	*a8(osizey),a0,w
	add	a0,a2			; a2 = bottom of object
	move	*a13(p_ganiy),a0,w
	cmp	a0,a2
	jrlt	hgy5
	setc
	rets
hgy5	clrc
	rets


get_his_strength
	push	a8
	move	*a13(p_otherguy),a8,l
	callr	get_my_strength
	pull	a8
	rets

**************************************************************************
*											     *
*  get_my_strength - returns my current strength value in a0		     *
* 											     *
*  input: a8 = object in question							     *
*											     *
**************************************************************************
get_my_strength
	movi	p1_bar,a0
	move	@p1_obj,a2,l
	cmp	a2,a8			; player 1 ?
	jreq	gmst4
	movi	p2_bar,a0
gmst4	move	*a0,a0,w		; a0 = current value
	rets

**************************************************************************
*											     *
*  get_my_matchw - get my (a8) # of wins this match in a0			     *
*											     *
**************************************************************************
get_my_matchw
	move	@p1_matchw,a0,w
	move	@p1_obj,a1,l
	cmp	a1,a8
	jreq	getmmw
	move	@p2_matchw,a0,w
getmmw	rets

get_his_matchw
	push	a8
	move	*a13(p_otherguy),a8,l
	callr	get_my_matchw
	pull	a8
	rets

get_char_ani_a11
	push	a9
	move	a11,a9
	calla	get_char_ani
	move	a9,a11
	pull	a9
	rets

**************************************************************************
*											     *
*  lineup_1pwm - Lineup a 1 part obj (a0) with a multipart obj (a1) 	*
*											     *
**************************************************************************
lineup_1pwm
	move	*a1(oxpos),*a0(oxpos),w
	move	*a1(oypos),*a0(oypos),w

	move	*a1(oflags),a5,w
	andi	m_fliph,a5		; look only at flip from multi	
	move	*a0(oflags),a4,w
	andni	m_fliph,a4		; clear flip bit from single obj
	or	a5,a4
	move	a4,*a0(oflags),w	; match flip bits
*
* adjust single part obj according to animation points
*
ani_adjust_single
	move	*a0(oimg),a1,l
	move	*a1(ianioffx),a2,w
	move	*a1(ianioffy),a3,w	; grab the animation points
	move	*a1(isize),a6,l

	btst	b_fliph,a4		; horz flip ?
	jreq	aas3			; no
	neg	a2			; yes, reverse x
	zext	a6,w			; a6 = [0,x] size
	addxy	a6,a2

aas3	btst	b_flipv,a4		; vert flip ?
	jreq	aas4
	neg	a3
aas4	move	*a0(oxpos),a1,w
	sub	a2,a1
	move	a1,*a0(oxpos),w
	move	*a0(oypos),a1,w
	sub	a3,a1
	move	a1,*a0(oypos),w
	rets

**************************************************************************
*											     *
*  next_anirate - animate according to p_anirate value			     *
* 											     *
*  input: a9 = animation frames to use						     *
*         *a13(p_anitab) = base animation table					     *
*											     *
**************************************************************************
next_anirate
	move	*a13(p_anicount),a0,w
	dec	a0
	move	a0,*a13(p_anicount),w
	jrne	nexta2						; not time yet

	move	*a13(p_anirate),*a13(p_anicount),w	; reload p_anirate
	move	*a9,a1,l					; grab a frame
	jreq	nexta2						; zero = skip

	move	*a8(oflags2),a1,w
	btst	b_multipart,a1
	jrne	nexta1
	callr	frame_a9
	rets

nexta1	callr	do_next_a9_frame
nexta2	rets

**************************************************************************
*											     *
*  sans_repell - disables the repell process					     *
*											     *
**************************************************************************
sans_repell
	movi	>40,a7
	move	a7,@f_norepell,w	; start the count down
	rets

***************** end of multipart object routines ***********************
***************** end of multipart object routines ***********************
***************** end of multipart object routines ***********************
***************** end of multipart object routines ***********************
***************** end of multipart object routines ***********************

**************************************************************************
*											     *
*  back_to_normal - player characters call this routine to clear any     *
*                   funky states or flags to get normal again		     *
* 											     *
*   1 - i can now be flipped								     *
*   2 - dont ignore my block button							     *
*   3 - rid of slave objects								     *
*											     *
**************************************************************************
back_to_normal
	clr	a0
	movb	a0,*a13(p_hit)			; hit count = 0
	move	a0,*a13(p_action),w		; sans action
	move	a0,*a13(p_stk),w		; I am no longer striking !!

	calla	player_normpal
	callr	delete_slave
	move	*a8(oflags2),a4,w
	andni	m_noflip|m_noblock,a4
	move	a4,*a8(oflags2),w

	move	*a8(oflags),a4,w
	andni	m_flipv,a4
	move	a4,*a8(oflags),w

	move	*a13(p_flags),a4,w
	andni	pm_special,a4		; flag: i am not doing a special move
	andni	pm_reacting,a4	  	; flag: i am not reacting to an attack
	move	a4,*a13(p_flags),w
	rets

*
* delete multipart slave object
*
delete_slave
	move	*a13(p_slave),a0,l	; slave object ?
	jreq	dels2			; nope...

	callr	delobjp			; delete object and palette
clear_slave_ram
	clr	a0
	move	a0,*a13(p_slave),l	; clear slave lw
dels2	rets

**************************************************************************
*											     *
*  grab_screen - does the following						     	*
* 											     *
*  1. turns off autoerase								     *
*  2. zeros all object lists								     *
*  3. returns with a screwed up system (beware)					     *
*											     *
**************************************************************************
grab_screen
	clr	a0
	move	a0,@f_auto_erase,w

	clr	a0
	movi	baklst8,a1
grab3	move	a0,*a1+,l		; zero object list
	cmpi	last_objlst,a1		; all of 'em
	jrne	grab3
*
* free up objects
*
	movi	objstr,a1,l
	move	a1,@ofree,l		; setup free list
	movi	nobj,a3			; # of object blocks to init
gscr4	move	a1,a2
	addi	obsiz,a1,w
	move	a1,*a2,l		; link em up
	dsjs	a3,gscr4		; continue for nproc
	rets

**************************************************************************
*											     *
*  skip_a0_frames 									     *
*											     *
**************************************************************************
skip_a0_frames
	addi	32+16,a9
	dsjs	a0,skip_a0_frames
	rets

set_all_worldtlx
	move	a0,@worldtlx0,l
	move	a0,@worldtlx,l
	move	a0,@worldtlx2,l
	move	a0,@worldtlx3,l
	move	a0,@worldtlx4,l
	move	a0,@worldtlx5,l
	move	a0,@worldtlx6,l
	move	a0,@worldtlx7,l
	move	a0,@worldtlx8,l
	rets

**************************************************************************
*											     *
*  murder_myoinit_score - calls murder_myoinit and then set the second   *
*                         palette to the vogel score palette		     *
*											     *
**************************************************************************
murder_myoinit_score
	callr	murder_myoinit
	calla	setup_score_ram

	movi	SCORE_P,a0
	jauc	getfpal 		; palette #2 = vogel's score palette


murder_myoinit
	calla	oinit
	calla	clear_sound_ram

;	<<<<<<<<<<<<<< fall through >>>>>>>>>>>>>>>

**************************************************************************
*												*
*  murder											*
*												*
*  kill every process except "indestuctables"						*
*												*
**************************************************************************
murder
	clr	a0
	movi	>8000,a1
	jauc	kilall				; kill all but indestructables

insobj3a8
	move	a8,a0
	jauc	insobj3

insobj2a8
	move	a8,a0
	jauc	insobj2

insobja8
	move	a8,a0
	jauc	insobj


**************************************************************************
*											     *
*  clear_ram - Clears a bank of ram given						     *
* 											     *
*  a0 = 1st location									     *
*  a1 = word count									     *
*											     *
**************************************************************************
clear_ram
	mmtm	sp,a0,a1,a2

	clr	a2
clr2	move	a2,*a0+,w	; clear one word
	dsjs	a1,clr2

	mmfm	sp,a0,a1,a2
	rets

**************************************************************************
*												*
*  unclip											*
*												*
*  unclips everything										*
*												*
**************************************************************************
unclip
	push	a0
	movi	scrnst,a0,l	; init screen top left [y,x]
	move	a0,@scrntl,l
	move	a0,@scrntl2,l
;	move	a0,@shad_scrntl,l

	movi	scrnend,a0,l	; init screen lower right [y,x]
	move	a0,@scrnlr,l
	move	a0,@scrnlr2,l
	pull	a0
	rets

totally_clip
	push	a0
	clr	a0
	move	a0,@scrntl,l
	move	a0,@scrntl2,l
;	move	a0,@shad_scrntl,l

	move	a0,@scrnlr,l
	move	a0,@scrnlr2,l
	pull	a0
	rets

**************************************************************************
*												*
*  fastxfer											*
*												*
*  like xferproc except you cannot give a new id or new a8-a11 values.	*
*												*
*  input: a0 - process to xfer									*
*   	 a7 - wakeup address									*
*												*
**************************************************************************
fastxfer
	mmtm	sp,a0,a2
	addi	ptime,a0		; a0 --> wake up timer
	movk	1,a2
	move	a2,*a0+,w		; wake up right away !!
	move	a0,a2
	addi	prcsiz-psptr,a2 	; a2 = top of process stack
	move	a2,*a0,l		; store into pointer ram
	addi	pwake-psptr,a0		; a0 --> wake up area
	move	a7,*a0,l
	mmfm	sp,a0,a2
	rets

**************************************************************************
*												*
*  waitproc (jsrp)										*
*												*
*  wait for a process to die. a10 = id of process to wait for			*
*												*
**************************************************************************
waitproc
	sleep	1
	clr	a1
	not	a1
	move	a10,a0
	calla	existp
	jrne	waitproc
	retp

*
* oflags = dmacnz + no scroll
*
initobj_3
	movi	dmacnz,a4
	calla	initobj
	jruc	set_noscroll

*
* oflags = dmawnz
*
initobj_1
	movi	dmawnz,a4			; a4 = oflags = dmawnz

**************************************************************************
*												*
*   initobj -  initialize an object								*
*												*
*   input      a14 = initialization table of the form:				*
*												*
*	     .long   oimg,opal									*
*	     .word   oid,x,y,z									*
*												*
*  returns:    a1 = oimg 									*
*	      a4 = oflags									*
*	      a8 --> object structure							*
*	     a14 --> word following the table						*
*												*
**************************************************************************
initobj
	mmtm	sp,a0,a2,a3,a6,a7,a9,a10
	calla	getobj				; get a free object
	jrne	iobj2				; all is well..
	ermac	6				; error #8 - no objects left
iobj2	move	a0,a8
	move	*a14+,a1,l
	move	a1,*a8(oimg),l			; a1=(oimg)=input for gsagof
	move	*a14+,a0,l			; (opal)
	jreq	iobj4				; 0 = no pallete yet
	calla	getfpal
	jrne	iobj3
	ermac	7				; error #10 - no palletes left
iobj3	move	a0,*a8(opal),w

iobj4	move	*a14+,a0,w
	move	a0,*a8(oid),w			; set object id

iobj21	move	*a14+,a9,w
	sll	16,a9				; a9 = x
	move	*a14+,a10,w
	sll	16,a10				; a10 = y

	calla	gsagof
	calla	ganiof				; adjust animation offset
	move	a2,*a8(osize),l 		; output from "gsagof"
	move	a3,*a8(osag),l			; output from "gsagof"
	move	a4,*a8(oflags),l		; output from "gsagof"

	sub	a6,a9				; subtract x anioff
	sub	a7,a10				; subtract y anioff
	move	a9,*a8(oxval),l 		; initial x
	move	a10,*a8(oyval),l		; initial y
	move	*a14+,a9,w
	sll	16,a9
	move	a9,*a8(ozval),l 		; initial z

	clr	a0
	move	a0,*a8(oflags2),w		; clear out object's flag #2
	mmfm	sp,a0,a2,a3,a6,a7,a9,a10
	rets

**************************************************************************
*												*
*  initins											*
*												*
*  handy routine to initialize and insert an object onto the object list *
*  given:											*
*	  a14 --> initialization table (for routine: initobj) 		*
*												*
**************************************************************************
initins
	calla	initobj
	jruc	insobja8			; put on the list and return

**************************************************************************
*												*
*  dallobj											*
*												*
*  deletes every object with the id of a0. no masking bullshit needed	*
*  in a1.											*
*												*
**************************************************************************
dallobj
	clr	a1	
	not	a1
	jauc	kill_ocp	    ; kill with no "dont care" bits

**************************************************************************
*												*
*  dallprc											*
*												*
*  deletes every process with the id of a0. no masking bullshit needed	*
*  in a1.											*
*												*
**************************************************************************
dallprc
	clr	a1	
	not	a1
	jauc	kilall			; kill with no "dont care" bits


**************************************************************************
*											     *
*  create_and_kill - creates a process and kills any old ones with	     *
*  		  the same id								     *
* 											     *
*  input: a0 = id									     *
*         a7 = address of proc								     *
*											     *
**************************************************************************
create_and_kill
	callr	dallprc
	move	a0,a1
	jauc	getprc

create_if_gone
	clr	a1
	not	a1
	push	a0
	calla	existp
	pull	a0
	jreq	cig4  		; not there ---> create one
	clrc	      		; carry clear ---> process already there
	rets

cig4	move	a0,a1
	calla	getprc
	setc	      		; carry set ---> process was created
	rets


exprc	clr	a1
	not	a1		; get this hassle out of the way
	jauc	existp

**************************************************************************
*											     *
*  move_object_list - Move a list of object list from one objlst	     *
*                     to another								     *
* 											     *
*  Input: a0 = from list									     *
*         a1 = to list									     *
*											     *
**************************************************************************
move_object_list
	mmtm	sp,a2,a14
	clr	a14
	move	*a0,a2,l		; grab "from"
	move	*a1,a3,l		; grab "to"
	jreq	mol6

mol4	move	a3,a1
	move	*a3,a3,l
	jrne	mol4			; find the end of the "to" list
*
* "to" list is empty
*
mol6	move	a14,*a0,l		; clear "from"
	move	a2,*a1,l		; tack onto "to" list
	mmfm	sp,a2,a14
	rets

**************************************************************************
*												*
*  delolist											*
*												*
*  deletes and zeros an object list. input: a2 = list to delete		*
*												*
**************************************************************************
delolist
	move	*a2,a0,l		; list empty ??
	jreq	delo9			; yes, skip
	clr	a1
	move	a1,*a2,l		; null the list
delo2	move	*a0(olink),a1,l 	; a1 = next in list
	calla	delpal			; delete the palette 1st
	move	@ofree,a2,l
	move	a2,*a0(olink),l 	; object ---> top o free list
	move	a0,@ofree,l		; objest is top o free list
	move	a1,a0			; end of list ??
	jrne	delo2			; no
delo9	rets

**************************************************************************
*												*
*  delete object and palette									*
*												*
*  delete an object from the object list and from the palette count.	*
*  use this routine for deleting objects to avoid mismatching palette	*
*  counts with # of objects.									*
*												*
*  input: a0 --> object block to delete							*
*												*
**************************************************************************
delobjp
	calla	delpal
	jauc	delobj

delobjp2
	calla	delpal
	jauc	delobj2

delobjp3
	calla	delpal
	jauc	delobj3


**************************************************************************
*											     *
*  set_oid_list - Set every object on a list to a specific id		     *
* 											     *
*  Input: a0 = object list								     *
*         a1 = oid									     *
*											     *
**************************************************************************
;set_oid_list
;	move	*a0,a0,l
;	jreq	sol3
;	move	a1,*a0(oid),w
;	jruc	set_oid_list
;sol3	rets

**************************************************************************
*											     *
*  change_oid_list - Change objects from one oid to another		     *
* 											     *
*  Input: a0 = object list								     *
*         a1 = from oid									     *
*         a2 = to oid									     *
*											     *
**************************************************************************
change_oid_list
	push	a3
col2	move	*a0,a0,l
	jreq	col3
	move	*a0(oid),a3,w
	cmp	a1,a3			; match with "from" ???
	jrne	col2			; no, skip
	move	a2,*a0(oid),w		; yes, set to new oid
	jruc	col2
col3	pull	a3
	rets


**************************************************************************
*												*
*  kill object class and palettes								*
*												*
*  kill a class of objects and delete them from the palette count they	*
*  were on.											*
*	   input: a0 = id of object								*
*		  a1 = mask bits								*
*												*
**************************************************************************
kill_ocp
	mmtm	sp,a0,a2,a3,a4,a5
	and	a1,a0		; form match
	movi	objlst,a2,l	; traverse object list #1
	callr	koc2
	movi	objlst2,a2,l	; traverse object list #2
	callr	koc2
	movi	objlst3,a2,l	; traverse object list #3
	callr	koc2
	mmfm	sp,a0,a2,a3,a4,a5
	rets

koc2	move	a2,a3		; save previous
	move	*a2,a2,l	; get next
	jreq	koc5		; zero --> we are done
	move	*a2(oid),a4,w	; get id
	and	a1,a4		; can dont care bits
	cmp	a0,a4		; match?
	jrne	koc2		; no

	push	a0
	move	*a2(opal),a0,w
	calla	freepal 	; decrement the palette count
	pull	a0
	move	*a2,*a3,l
	move	@ofree,a5,l	; delete object from list
	move	a5,*a2,l
	move	a2,@ofree,l
	move	a3,a2
	jruc	koc2		; loop til we reach the end
koc5	rets			; end reached ---> return

**************************************************************************
*												*
*  framew											*
*												*
*  walks through a table of frames sleeping the same amount every time.	*
*												*
*  inputs:  a9 --> table of frames (in frame_a9 format)				*
*	   a0 = sleep time between each frame						*
*												*
*		  <<<< warning: call with jsrp >>>>>				*
*												*
**************************************************************************
framew
	move	a0,-*a12,l		; save sleep time (pushp a0)
fwloop	callr	frame_a9		; do a frame
	jrc	fwdone			; carry set = we just did last frame
	move	*a12,a0,l		; pull sleep time but keep stack same
	calla	prcslp			; sleep
	jruc	fwloop

fwdone	pullp	a0
	calla	prcslp			; sleep
	retp


framew_a10a11
	move	a0,-*a12,l		; save sleep time (pushp a0)
fw1011	callr	frame_a10a11
	jrc	fw1011x			; carry set = we just did last frame
	move	*a12,a0,l		; pull sleep time but keep stack same
	calla	prcslp			; sleep
	jruc	fw1011

fw1011x	pullp	a0
	calla	prcslp			; sleep
	retp


frame_a10a11
	mmtm	sp,a8,a9
	move	a10,a8
	move	a11,a9
	callr	frame_a9		; do a frame
	move	a9,a11
	mmfm	sp,a8,a9
	rets


jframea9
	move	*a8(oflags),a4,w	; ani input: a4 = flags
	jruc	frame2 			; skip range check


ani_end		.set	0
newflag		.set	>00020000		; new flag command for "frame_a9"

**************************************************************************
*											     *
*  frame_a9 - frame animator								     *
* 											     *
*  input: a8 = object to use	 returns: a9 = next frame entry	     *
*         a9 = frame list entry 	     	cc = end of list not reached	*
* 			   			cs = end of list was reached  *
*											     *
**************************************************************************
frame_a9
	move	*a8(oflags),a4,w		; ani input: a4 = flags

;	cmpi	legalbeg,a9
;	jrlt	out_of_range
;	cmpi	legalend,a9
;	jrgt	out_of_range

frame2	move	*a9+,a1,l			; get a table entry
	jrn	frame5				; negative ---> this is a frame

frame1	movi	newflag,a0
	cmpxy	a0,a1				; new flag command ?
	jryne	frame4				; no ---> check for other command
	andni	(m_flipv+m_fliph),a4		; always assume no flip bits set
	sll	16,a1
	srl	16,a1				; a1 = new flag
	or	a1,a4				; put it in

	move	*a9,a1,l
	jrp	frame3
	addi	32,a9 				; next is ani ---> do it
	jruc	frame5

frame3	cmpi	ani_jump,a1
	jrne	frame1
       	move	*a9(32),a9,l
	jruc	frame2				; now go process a real frame
*
* got a frame ---> ani
*
frame5	calla	ani
	move	*a9,a1,l			; a1 = peek ahead
	jrn	frame8				; next lw is a frame ---> we done
frame4	cmpi	ani_end,a1
	jreq	frame6				; sequence done ---> return
	cmpi	ani_jump,a1
	jrne	frame8
	move	*a9(32),a9,l			; jump ---> next lw redirects a9
frame8	clrc					; carry clear = end not reached
	rets

frame6	setc					; carry set = end was reached
	rets

**************************************************************************
*												*
*  a5a6ol2											*
*												*
*  used along with getblimp, adds a list of objects onto objlst2.		*
*												*
*  input: a5 --> list of objects to add to objlst2					*
*	 a6 --> end of object list to add to objlst2				*
*												*
**************************************************************************
a5a6ol2
	move	@objlst2,a0,l
	move	a0,*a6(olink),l 	; end of menu --> objlst2
	move	a5,@objlst2,l		; objlst2 --> beginning of list
	rets

a5a6ol1
	move	@objlst,a0,l
	move	a0,*a6(olink),l 	; end of menu --> objlst
	move	a5,@objlst,l		; objlst --> beginning of list
	rets

a5a6ol3
	move	@objlst3,a0,l
	move	a0,*a6(olink),l 	; end of menu --> objlst3
	move	a5,@objlst3,l		; objlst3 --> beginning of list
	rets

**************************************************************************
*												*
*      section: palette utilities								*
*												*
**************************************************************************

**************************************************************************
*												*
*  swpal 											*
*												*
*  handy routine to switch the palette of an object. 				*
*  input: a8 = object to switch palette							*
*	 a0 = palette to switch to (in address form)				*
*												*
**************************************************************************
swpal	push	a0
	push	a0
	move	a8,a0
	calla	delpal	      		; delete old palette
	pull	a0	      		; restore new palette
	calla	getfpal       		; get it in [#,#] form
	jrne	allm5
	ermac	8
allm5	move	a0,*a8(opal),w		; store new palette "double" #'s
	pull	a0
	rets


boonpal_stuff
	movi	boonpal,a0		; assume "boonpal" is our palette
	jruc	nrgbs0

rgb_stuff
	move	*a11+,a0,l		; a0  = palette

nrgbs0	move	*a11+,a10,w		; a10 = color
	srl	8,a10			; get rid of double shit
	move	*a11+,a9,w		; a9  = sleep time (speed)

	calla	findpal 		; find the palette address
	jrne	nrgbs1			; non-zero ---> ok
	ermac	9
nrgbs1	srl	8,a0			; a0 = palette offset
	move	a0,a2
	sll	8,a2			; [palette #,0]
	or	a2,a10			; a10 = [palette,color]

nrgbs2	move	a11,a8			; a8 ---> rgb table of colors
nrgbs3	movk	1,a2			; a2 = color count
	move	a10,a1			; a1 = [palette,color]
	move	a8,a0			; a0 = source
	calla	palset
	move	a9,a0
	calla	prcslp			; tick
	addi	>10,a8			; a8 --> next rgb value in table
	move	*a8,a0,w
	sll	16,a0
	srl	16,a0
	cmpi	end_stuff,a0		; end of "rgb" table ??
	jrne	nrgbs3			; no
	jruc	nrgbs2			; yes --> reset and loop


rgbs0	move	*a11+,a0,l		; get palette
	move	*a11,a8,l		; table of "rgb" values
	move	*a11(32),a10,w		; color to mess with	
	move	*a11(32+16),a9,w	; sleep time between messings
*
* keep a11 --> rgb table
*
	calla	findpal 		; find the palette address
	jrne	rgbs1			; non-zero ---> ok
	ermac	10
rgbs1	srl	8,a0			; a0 = palette offset
	move	a0,a2
	sll	8,a2			; [palette #,0]
	or	a2,a10			; a10 = [palette,color]

rgbs2	movk	1,a2			; a2 = color count
	move	a10,a1			; a1 = [palette,color]
	move	a8,a0			; a0 = source
	calla	palset
	move	a9,a0
	calla	prcslp			; tick
	addi	>10,a8			; a8 --> next rgb value in table
	move	*a8,a0,w
	sll	16,a0
	srl	16,a0
	cmpi	end_stuff,a0		; end of "rgb" table ??
	jrne	rgbs2			; no
	move	*a11,a8,l		; yes --> back to beginning of table		
	jruc	rgbs2			; don't stop till you get enough !!!


**************************************************************************
*											     *
*  cycle_forward	 / cycle_backward								*
* 											     *
*  a10 = palette										     *
*  a11 = [a,b,c,d]	a = starting color				     	*
* 			b = # of colors to cycle				     *
* 			c = sleep time between each iteration		     *
* 			d = unused							     *
*											     *
**************************************************************************
cycle_forward
	movk	1,a0
	jruc	cyc0

cycle_backward
	clr	a0			; a0 = 0 ---> forward

cyc0	pushp	a0
	move	a11,a9			; save parameters
	move	a10,a0
	calla	findpal
	jrne	cyc1
	ermac	11			; huh ?

cyc1	srl	8,a0			; a0 = palette offset
	movi	palram,a1		; a1 = top of palette ram
	movi	palrsiz,a5
	mpys	a0,a5
	add	a5,a1			; a1 --> palette to cycle
	sll	8,a0			; in upper nibble only
	move	a0,a8			; a8 = [palette,0]

	srl	24,a11			; a11 = starting color
	add	a11,a8			; a8 = [palette,starting color]

	sll	4,a11			; one word per color
	move	*a1,a4,l		; a4 --> palette data
	addi	>10,a4			; skip "# of colors word"
	add	a11,a4			; a4 = source

	move	a13,a1
	addi	pdata,a1		; a1 = 1st copy
	
	move	a9,a10
	sll	8,a10
	srl	24,a10			; a10 = color count
	move	a10,a2
	sla	4,a2			; each color is a word
	add	a1,a2			; a2 = 2nd copy
	move	a10,a0			; a0 = color count

*	
* block move:
* a0 = count
* a4 = source
* a1 = destination 1
* a2 = destination 2
*
cyc2	move	*a4+,a7,w
	move	a7,*a1+,w		; 1st copy
	move	a7,*a2+,w		; 2nd copy
	dsjs	a0,cyc2
	sll	16,a9
	srl	24,a9			; a9 = sleep time

	movi	>10,a1			; assume forward cycle
	pullp	a0
	move	a0,a0			; forward or backward ??
	jreq	cyc5
	movi	->10,a1 		; backward color cycle
cyc5	pushp	a1			; save "movement" on process stack
*
* color cycle loop
*
cyc3	move	a10,a4			; a4 = reset counter
	move	a13,a11
	addi	pdata,a11		; a11 = beginning of pdata
	move	*a12,a0,l		; pull "movement" but keep stack same
	move	a0,a0
	jrp	cyc4			; positive movement = forward cycle
	move	a10,a0
	sll	4,a0
	add	a0,a11			; backward cycle = start at end of pdata

cyc4	move	a11,a0			; a0 = source
	move	a8,a1			; a1 = [palette,starting color]
	move	a10,a2			; a2 = count
	calla	palset			; do the transfer
	pushp	a4
	move	a9,a0
	calla	prcslp			; snooze
	pullp	a4
	move	*a12,a0,l		; pull "movement" but keep stack same
	add	a0,a11			; advance to next color
	dec	a4
	jrne	cyc4
	jruc	cyc3

**************************************************************************
*											     *
*  zero_table_o_words									     *
* 											     *
*  Input: a1 = table of pointers to words (ends with zero)		     *
*											     *
**************************************************************************
zero_table_o_words
	clr	a0
ztow3	move	*a1+,a2,l		; grab an address
	jreq	ztow9			; zero ---> end of list
	move	a0,*a2,w		; clear it
	jruc	ztow3
ztow9	rets


zero_table_o_longs
	clr	a0
ztol3	move	*a1+,a2,l		; grab an address
	jreq	ztol9			; zero ---> end of list
	move	a0,*a2,l		; clear it
	jruc	ztol3
ztol9	rets


**************************************************************************
*											     *
*  p1p2_pick - Pick either a0 or a1 based on a8(oid)			     	*
* 											     *
*  Input: a0 = player 1 choice								     *
*         a1 = player 2 choice								     *
*											     *
**************************************************************************
p1p2_pick
	move	*a8(oid),a2,w
	cmpi	oid_p1,a2
	jreq	p1p2
	move	a1,a0		; use player 2
p1p2	rets


**************************************************************************
*											     *
*  get_tsl - get the amount of time (ticks) that has elapsed     		*
*            since the last time we updated this ram. (a0)	     	*
* 											     *
*  input: a0 = points to two 16 bit locations (p1-p2)			     *
*         a8 = dude who wants 2 know							     *
* 											     *
*  returns: a1 = elapsed time								     *
*											     *
**************************************************************************
get_tsl
	move	*a8(oid),a1,w
	cmpi	pid_p1,a1	; player 1 ??
	jreq	tsl4
    	addk	16,a0		; no, point to player 2's tick ram
tsl4	move	*a0,a0,w	; when was the last time we did this ?
	jreq	tsl8		; never
	move	@tick,a1,w
	sub	a0,a1		; a1 = time elapsed since last time !!
	rets

tsl8	movi	>40*30,a1	; default setting = 30 seconds ago
	rets

**************************************************************************
*											     *
*  update_tsl - stuff current value of @tick into "last time" ram	     *
* 											     *
*  input: a0 = points to two 16 bit locations (p1-p2)			     *
*         a8 = dude who wants 2 know							     *
*											     *
**************************************************************************
update_tsl
	move	*a8(oid),a1,w
	cmpi	pid_p1,a1	; player 1 ??
	jreq	usl4
    	addk	16,a0		; no, point to player 2's tick ram
usl4	move	@tick,a1,w
	move	a1,*a0,w	; update this player's ram
	rets


**************************************************************************
*												*
*	  section: unrelated utilities							*
*												*
**************************************************************************
wait_forever
	sleep	>40
	jruc	wait_forever

**************************************************************************
*											     *
*              Controlling of the other player routines				*
*              Controlling of the other player routines				*
*              Controlling of the other player routines				*
*              Controlling of the other player routines				*
*              Controlling of the other player routines				*
*											     *
**************************************************************************
match_him_with_me_f
	push	a8
	callr	match_him_with_me
	move	*a13(p_otherguy),a8,l
	callr	flip_multi			; flip him !
	pull	a8
	rets

match_him_with_me
	move	*a13(p_otherguy),a0,l
	jauc	match_ani_points		; lineup victim with me

match_me_with_him
	mmtm	sp,a0,a8
	move	*a13(p_otherguy),a0,l
	swap	a0,a8
	callr	match_ani_points
	mmfm	sp,a0,a8
	rets

**************************************************************************
*											     *
*  shake_him_up - Shake other player by A0 where:				     *
* 											     *
*  a0 = [# of pixels , # of shakes]							     *
*  a1 = sleep time between shakes								*
* a10 = dude to shake										*
*											     *
**************************************************************************
shake_him_up
	mmtm	a12,a9,a11

	pushp	a1
	move	a0,a9
	move	a0,a11
	srl	16,a9		;  a9 = # of pixels
	zext	a11,w		; a11 = # of shakes

shake3	move	*a10(oxpos),a0,w
	add	a9,a0
	move	a0,*a10(oxpos),w
	move	*a12,a0,l	; borrow sleep time from proc stack
	calla	prcslp
	move	*a10(oxpos),a0,w
	sub	a9,a0
	move	a0,*a10(oxpos),w
	move	*a12,a0,l	; borrow sleep time from proc stack
	calla	prcslp
	dsj	a11,shake3

	pullp	a1
	mmfm	a12,a9,a11
	retp

do_his_next_a9_frame
	push	a8
	move	*a13(p_otherguy),a8,l
	callr	do_next_a9_frame
	pull	a8
	rets

mframew_him
	mmtm	a12,a8,a9
	move	a11,a9				; input a11 = animation table
	move	*a13(p_otherguy),a8,l
	jsrp	mframew
	move	a9,a11
	mmfm	a12,a8,a9
	retp

pose_him_a0
	mmtm	sp,a8,a9
	move	a0,a9
	move	*a13(p_otherguy),a8,l	; pretend I am him
	calla	get_char_ani			; a9 = frame 1
	callr	do_next_a9_frame		; pose
	move	*a13(p_otherproc),a0,l
	move	a9,*a0(pa9),l			; pass him the new a9
	mmfm	sp,a8,a9
	rets


**************************************************************************
*											     *
*  double_mframew - animate 2 multipart objects at the same time	     *
* 											     *
*  input: a0 = sleep time between frames						     *
*         a8 = object #1									     *
*         a9 = animation #1								     *
*        a10 = object #2									     *
*        a11 = animation #2								     *
*											     *
**************************************************************************
double_mframew
	move	a0,-*a12,l		; save sleep time (pushp a0)
dmfr5	callr	double_next_a9
	jreq	mfr9			; last frame ---> exit
	move	*a12,a0,l		; pull sleep time but keep stack same
	calla	prcslp			; sleep
	jruc	dmfr5

**************************************************************************
*											     *
*  input: a8 = object #1									     *
*         a9 = ani #1									     *
*        a10 = object #2									     *
*        a11 = ani #2									     *
*											     *
**************************************************************************
double_next_a9
	callr	do_next_a9_frame
	mmtm	sp,a8,a9
	move	a10,a8
	move	a11,a9			; load up the second guys
	callr	do_next_a9_frame
	pushst
	move	a9,a11
	popst
	mmfm	sp,a8,a9		; restore 1st guys
	rets

**************************************************************************
*											     *
*  takeover_him - routine to do the chores of taking over someone.	     *
*											     *
**************************************************************************
takeover_him
	push	a7
	jruc	take3

takeover_him_sr
	push	a7
	callr	sans_repell

take3	calla	stop_him
	calla	disable_his_buttons

	move	*a13(p_otherguy),a0,l
	calla	clear_inviso

	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l	; put on disguise !!
	move	*a13(p_otherproc),a13,l
	clr	a0
	move	a0,*a13(p_action),w		; sans his action !!

	move	*a13(p_flags),a4,w
	ori	pm_reacting,a4
	move	a4,*a13(p_flags),w		; flag: reacting !!

	calla	player_normpal			; make sure he is using correct pal
	callr	delete_slave
	mmfm	sp,a8,a13
	pull	a7

xfer_otherguy
	move	*a13(p_otherproc),a0,l
	jauc	fastxfer

**************************************************************************
*											     *
*  adjust_him_x - adjust the other player x coordinates			     *
* 											     *
*  input: a0 = amount to adjust								     *
*											     *
**************************************************************************
adjust_him_x
	push	a8
	move	*a13(p_otherguy),a8,l
	clr	a1			; no y adjusting needed
	jruc	adhim3

adjust_him_xy
	push	a8
	move	*a13(p_otherguy),a8,l
adhim3	callr	multi_adjust_xy
	pull	a8
	rets

adjust_him_tbl
	calla	get_his_char_long

adjust_him_a0
	move	a0,a1
	zext	a0,w
	srl	16,a1
	jauc	adjust_him_xy


get_his_dog
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l
	callr	distance_off_ground
	jruc	him_rets

;get_his_dfg
;	mmtm	sp,a8,a13
;	move	*a13(p_otherguy),a8,l
;	move	*a13(p_otherproc),a13,l
;	callr	distance_from_ground
;	jruc	him_rets

calla_for_him
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l
	call	a0
	jruc	him_rets

ground_him
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l
	callr	ground_player
	jruc	him_rets

away_x_vel_him
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l
	calla	away_x_vel
	jruc	him_rets

get_his_char_ani
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l	; pretend I am him
	calla	get_char_ani
	jruc	him_rets

get_his_char_ani2
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l	; pretend I am him
	calla	get_char_ani2
	jruc	him_rets

get_his_char_long
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l	; pretend I am him
	calla	get_char_long
	jruc	him_rets

get_his_char_word
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l	; pretend I am him
	calla	get_char_word

him_rets
	mmfm	sp,a8,a13
	rets

;*****************************************************************

	.end


