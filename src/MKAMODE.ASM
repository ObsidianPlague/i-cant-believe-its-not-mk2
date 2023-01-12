**************************************************************************
*											     *
*  video game project:	mortal kombat 2							*
* 											     *
*  game software:    	ed boon									*
* 											     *
*  module: attract mode									     *
* 											     *
*  copyright (c) 1993 Midway Manufacturing							*
*											     *
**************************************************************************
	.file	'mkamode.asm'
	.title	" <<< mortal kombat attract mode code >>> "

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
	.include	dipequ.asm
	.include	stringh.asm

	.ref	coin_page,read_dip,coinflag

	.even
	.text

**************************************************************************
*												*
*		     attract mode entry point						*
*												*
**************************************************************************
amode
	callr	amode_init
	movk	gs_amode,a0
	move	a0,@gstate,w		; game state = amode 

	clr	a0
	move	a0,*a13(p_anicount),w
	move	a0,@f_show_ranking,w		; flag: NOT showing rankings

amode_loop
	pushp	a0

	jsrp	midway_presents
	jsrp	mk2_court

	jsrp	the_story
	jsrp	here_is_where
	jsrp	mtv_style
	jsrp	mklogo_tada

	jsrp	mk2_intro
	jsrp	show_next_bio
	jsrp	amode_demo_fight

	jsrp	amode_coin_page
	jsrp	show_next_bio
	jsrp	amode_demo_fight

;	jsrp	print_rankings
;	jsrp	show_next_bio
;	jsrp	amode_demo_fight
;	jsrp	advertise_comic
;	jsrp	dcs_sound_ad
;	jsrp	huge_mk_logo

amode6	movk	1,a0
	move	a0,@f_show_ranking,w		; flag: showing rankings
	jsrp	print_rankings
	jsrp	advertise_comic
	jsrp	dcs_sound_ad
	jsrp	huge_mk_logo
	clr	a0
	move	a0,@f_show_ranking,w		; flag: NOT showing rankings

;	jsrp	show_next_bio
;	jsrp	amode_demo_fight

	pullp	a0
	inc	a0
	cmpi	3,a0
	jrlo	amode_loop

	push	a0
	calla	nosounds
	movk	1,a0
	move	a0,@f_nosound,w		; flag: no sounds allowed
	pull	a0
	jruc	amode_loop

;***********************************************************************

joy_show_rankings
	move	@f_show_ranking,a0,w
	jane	sucide			; already showing = die

	clr	a1
	not	a1
	movi	pid_amode,a0
	calla	existp
	jreq	jsr3			; no proc
	move	*a0(pwake),a0,l
	cmpi	joy_show_wake,a0
	jaeq	sucide			; already doing this ---> die

jsr3	movi	pid_amode,a0
	move	a0,*a13(procid),w

	calla	murder_myoinit_score
	calla	clr_scrn
	sleep	2

joy_show_wake
	movk	3,a0
	pushp	a0
      	jruc	amode6

;***********************************************************************

here_is_where
	movi	>5b,a3
	calla	send_code_a3		; start the reverse symbol

	movi	pf_here_is_where,a8
	jsrp	lm_printf

	movi	dlists_bogus,a0
	move	a0,@dlists,l
	movi	>20,a10			; sleep time after fade start
	jsrp	amode_fadein
	sleep	>20
	calla	fade_all_sky
	sleep	>10
	jruc	smooth_black_retp

pf_here_is_where
	mess_mac rd7font,2,200,>70,bpal_white*>10000,strcnrmos_scr,0
	.string	"NOW THE KOMBAT KONTINUES...."
	.byte	0
	.even

;***********************************************************************

the_story
	movi	>41,a3
	calla	send_code_a3

	clr	a0
	move	a0,@f_auto_erase,w
	movk	12,a8
	movk	>0e,a0
	movi	pf_story1,a9
	movi	(>1000*8)+(8*>34),a10	; a10 = coordinates of movie clip
	clr	a11
	clr	a1
	movi	>40*6,a2			; a2 = view time
	jsrp	one_story_screen

	movk	13,a8
	movk	>0f,a0
	movi	pf_story2a,a9
	movi	pf_story2b,a11
	movi	pf_story2c,a1
	movi	(>1000*8)+(8*>34),a10	; a10 = coordinates of movie clip
	movi	>40*6,a2			; a2 = view time
	jsrp	one_story_screen

	movk	14,a8
	movk	>10,a0
	movi	pf_story3,a9
	movi	(>1000*8)+(8*>34),a10	; a10 = coordinates of movie clip
	clr	a11
	clr	a1
	movi	>40*6,a2			; a2 = view time
	jsrp	one_story_screen

	movk	15,a8
	movk	>11,a0
	movi	pf_story4,a9
	movi	(>1000*8)+(8*>34),a10	; a10 = coordinates of movie clip
	clr	a11
	clr	a1
	movi	>40*6,a2			; a2 = view time
	jsrp	one_story_screen
	sleep	>08
	calla	display_on
	retp

**************************************************************************
*											     *
*  one_story_screen									     *
* 											     *
*  Input: a8 = offset into "zipped_pics" table				     	*
*         a0 = offset to background which accompanies this pic		     *
*         a1 = 3rd text										*
*         a2 = view time										*
*         a9 = text which accompanies this pic					     *
*        a10 = coordinates for compressed pic					     *
*        a11 = 2nd text                                                  *
*											     *
**************************************************************************
one_story_screen
	pushp	a2
	move	a0,*a13(p_store8),w
	move	a9,*a13(p_store7),l
	move	a11,*a13(p_store6),l
	move	a1,*a13(p_store5),l
	callr	page_0_zip_setup

	sll	5,a8
	addi	zipped_pics,a8
	move	*a8,a8,l
	clr	a9
	jsrp	movie_run

	calla	display_on
	
	move	*a13(p_store8),a0,w
	sll	5,a0
	addi	table_o_mods,a0
	move	*a0,a0,l
	calla	init_bakmods
	calla	multi_plane

	move	*a13(p_store7),a8,l
	jsrp	lm_printf
	sleep	4
	calla	display_off
	calla	sync_wait_dma_q

	move	*a13(p_store6),a8,l	; 2nd line of text ?
	jsrp	try_another_line
	move	*a13(p_store5),a8,l	; 3rd line of text ?
	jsrp	try_another_line

no_more_text
	calla	view_page_0
	calla	grab_screen

	pullp	a0
	calla	prcslp
	calla	murder_myoinit_score
	retp



try_another_line
	move	a8,a8
	jreq	tal9
	movi	objlst2,a2
	calla	delolist
	movi	baklst1,a2
	calla	delolist		; we're gonna need these objects
	calla	display_on
	jsrp	lm_printf
	sleep	2
	calla	display_off
	calla	sync_wait_dma_q
tal9	retp


page_0_zip_setup
	clr	a6
	move	a6,@f_auto_erase,w
	push	a8
	calla	display_off
	clr	a0
	not	a0
	move	a0,@noflip,w	   	; take control of page flipping !!
	calla	view_page_1
	movi	page0adr+xpadding,a1	; plot to page 0
	move	a1,@pageaddr,l		; plot to page 0
	movi	[253,0],a0
	move	a0,@dmatplft,l 		; set dma window to page 0
	pull	a8
	rets


pf_story1
	mess_mac rd7font,2,>20,>c7,bpal_white*>10000,strlnrmos_scr,0
	.string	"500 YEARS AGO, SHANG TSUNG WAS BANISHED TO\n"
	.string	"THE EARTH REALM. WITH THE AID OF GORO HE WAS\n"
	.string	"TO UNBALANCE THE FURIES AND DOOM THE PLANET\n"
	.string	"TO A CHAOTIC EXISTENCE."
	.byte	0
	.even

pf_story2a
	mess_mac rd7font,2,>1C,>c2,bpal_white*>10000,strlnrmos_scr,0
	.string "BY SEIZING CONTROL OF THE SHAOLIN TOURNAMENT\n"
	.string "HE TRIED TO TIP THE SCALES OF ORDER TOWARDS\n"
	.byte	0
	.even

pf_story2b
	mess_mac rd7font,2,>1C,>D9,bpal_white*>10000,strlnrmos_scr,0
	.string	"CHAOS. ONLY SEVEN WARRIORS SURVIVED THE\n"
	.string	"BATTLES AND SHANG TSUNG'S SCHEME WOULD COME\n"
	.byte	0
	.even

pf_story2c
	mess_mac rd7font,2,>1C,>f0,bpal_white*>10000,strlnrmos_scr,0
	.string "TO A VIOLENT END AT THE HANDS OF LIU KANG."
	.byte	0
	.even


pf_story3
	mess_mac rd7font,2,>20,>cd,bpal_white*>10000,strlnrmos_scr,0
	.string	"FACING EXECUTION FOR HIS FAILURE AND THE\n"
	.string	"APPARENT DEATH OF GORO, TSUNG CONVINCES\n"
	.string	"SHAO KAHN TO GRANT HIM A SECOND CHANCE."
	.byte	0
	.even

pf_story4
	mess_mac rd7font,2,>1C,>cd,bpal_white*>10000,strlnrmos_scr,0
	.string	"SHANG TSUNG'S NEW PLAN IS TO LURE HIS ENEMIES\n"
	.string	"TO COMPETE IN THE OUTWORLD WHERE THEY WILL\n"
	.string	"MEET CERTAIN DEATH BY SHAO KAHN HIMSELF."
	.byte	0
	.even

;***********************************************************************

amode_demo_fight
	calla	murder_myoinit_score
	movk	1,a0
	move	a0,@f_doscore,w
	create	pid_amode,amode_demo_game
	sleep	6
	create	pid_repell,repell
	sleep	>40*12
	jruc	amode_init_system


amode_init_system
	calla	murder_myoinit_score
	calla	clr_scrn
	clr	a0
	move	a0,@irqskye,w
	move	a0,@noflip,w			; page flipping on
	movk	1,a0
	move	a0,@f_doscore,w			; show scores
	move	a0,@f_auto_erase,w
	calla	dont_show_scores
	calla	nosounds
	retp

;***********************************************************************

	clr	a11
	move	a11,*a13(p_store1),w

mont4	calla 	murder_myoinit_score
	calla	update_pmsg

	movk	1,a0
	move	a0,@f_doscore,w

	movk	12,a0
	calla	randu
	dec	a0
	move	a0,@p1_char,w
	movk	12,a0
	calla	randu
	dec	a0
	move	a0,@p2_char,w			; random characters

	move	*a13(p_store1),a11,w
	inc	a11
	cmpi	6,a11
	jrls	mont3
	clr	a11
mont3 	move	a11,*a13(p_store1),w

	calla	do_a11_background
	sleep	1
	create	pid_repell,repell
	create	pid_scroll,scroller
	calla	setup_players
	calla	start_shadows
	sleep	>10
	jruc	mont4

**************************************************************************
*											     *
*  gover_amode_entry - game over attract mode entry point			     *
*											     *
**************************************************************************
gover_amode_entry
	movi	>800,a9
	create	pid_fade,skydown
	jsrp	amode_fade_retp

;	jsrp	print_rankings
;	sleep	>40*6	 		; display this long
;	jsrp	advertise_comic

	jruc	amode			; start the attract mode
	

amode_shutup
	calla	nosounds
	movk	1,a0
	move	a0,@f_nosound,w		; no, shut up
	clr	a0
	movb	a0,*a13(p_hit)
	rets

amode_init
	movk	4,a0
	movb	a0,*a13(p_hit)
	clr	a0
	move	a0,@c_amodeloop,w
	calla	read_dip
	andi	dip_amsounds,a0		; attract sounds ?
	jreq	ainit4			; yes
	callr	amode_shutup
ainit4	movk	7,a0
	calla	randu
	dec	a0
	move	*a13(p_action),a0,w

	calla	update_pmsg		; update player message
	clr	a0
	move	a0,@coinflag,w		; flag: coin page not up

	movk	12,a0
	calla	randu
	dec	a0
	move	a0,@c_amode_bio,w
	rets


amode_flash_pmsg
	create	pid_amode,flash_pmsg
	rets

amode_fade_retp
	calla	fade_all_sky
	sleep	>40
	jruc	smooth_black_retp

except_boonpal
	.long	boonpal,0

smooth_black_retp
	callr	amode_display_reset
	sleep	>10

amode_retp
	retp

amode_display_reset
	clr	a0
	move	a0,@f_doscore,w		; score bars = no

	calla	clr_scrn
	movk	1,a0
	move	a0,@f_auto_erase,w
	calla	murder_myoinit
	jauc	clr_scrn

**************************************************************************

midway_presents
	callr	amode_init_no_score
	calla	display_off

	movi	(32*32*0)+(32*0)+3,a0
	move	a0,@irqskye,w

	movi	>5a,a3
	calla	send_code_a3

	movi	MIDPR5,a5
	calla	gso_dmawnz_ns
	movi	>00710000,a4
	calla	set_xy_coordinates
	calla	center_obj_x
	calla	insobja8

	sleep	3
	movi	>40,a10			; sleep time after fade start
	jsrp	amode_fadein
	jruc	amode_fade_retp


	.string	"MIDWAY PRESENTS",0
	.even

**************************************************************************

mklogo_tada
	callr	amode_init_no_score
	movi	huge_mod,a0
	calla	init_bakmods
	calla	multi_plane
	movi	>33,a3
	calla	send_code_a3

	sleep	>40*3

dragon_fade
	clr	a0
	move	a0,@irqskye,w
	calla	murder_myoinit_score
	sleep	8
	retp

**************************************************************************

huge_mk_logo
	callr	amode_init_no_score

	calla	display_off
	movi	huge_mod,a0
	calla	init_bakmods
	calla	multi_plane

	sleep	3
	movi	>30,a10			; sleep time after fade start
	jsrp	amode_fadein

	jsrp	mk2_morph_in
	jruc	dragon_fade

**************************************************************************
*											     *
*  advertise_comic - tell peple about the comic book				     *
*											     *
**************************************************************************
advertise_comic
	calla	read_dip	
	andi	dip_comic,a0
	jrne	adver9

	calla	murder_myoinit_score
	clr	a0
	move	a0,@f_doscore,w
	calla	clr_scrn

	calla	page_0_setup
	calla	view_page_1
	calla	display_on

	movi	>15,a11
	calla	do_a11_background
	sleep	4
	calla	grab_screen

	movi	mkcomdisk,a5
	calla	gso_dmawnz_ns
	movi	>00200118,a4
	calla	set_xy_coordinates
	calla	insobja8
	sleep	2
	move	a8,a0
	calla	delobjp			; lil picture of a cd

	movi	txt_comic1,a8
	movi	bpal_yellow*>10000,a5
	movi	>001000c0,a9
	jsrp	add_print

	movi	txt_comic2,a8
	movi	bpal_hot_green*>10000,a5
	movi	>005300c0,a9
	jsrp	add_print_11

	movi	txt_cd1,a8
	movi	bpal_red*>10000,a5
	movi	>006600c0,a9
	jsrp	add_print

	movi	pf_money,a8
	jsrp	lm_printf
	jsrp	wait_letter_plot

	movi	pf_money2,a8
	jsrp	lm_printf
	jsrp	wait_letter_plot

	movi	pf_address,a8
	jsrp	lm_printf
	jsrp	wait_letter_plot

	movi	pf_allow,a8
	jsrp	lm_printf
	jsrp	wait_letter_plot
	calla	view_page_0

	sleep	>40*15

adver9	retp


add_print_11
	mmtm	sp,a5,a8,a9
	movi	pf_comic11,a8
	jruc	addp3

add_print
	mmtm	sp,a5,a8,a9
	movi	pf_comic1,a8
addp3	calla	lm_setup
	mmfm	sp,a5,a8,a9
	jsrp	printf

wait_letter_plot
	sleep	2
	movi	oid_text,a0
	calla	dallobj
	retp


txt_comic1
	.string	"MORTAL KOMBAT II\nCOLLECTORS EDITION\n"
	.string	"COMIC BOOK",0
	.even

txt_comic2
	.string	"AND",0
	.even

txt_cd1	.string	"COMPACT DISC",0
	.even

pf_money
	mess_mac rd11font,2,>30,>80,bpal_hot_green*>10000,strlnrmos_scr,0
	.string	"MK 2 COMPACT DISC\n"
	.string	"MK 2 COMIC BOOK\n"
	.string	"MK 1 COMIC BOOK"
	.byte	0
	.even

pf_money2
	mess_mac rd11font,2,>130,>80,bpal_hot_green*>10000,strrnrmos_scr,0
	.string	"   . . . . . . . . $12.45\n"
	.string	". . . . . . . . . . $ 5.00\n"
	.string	". . . . . . . . . . $ 3.00"
	.byte	0
	.even

pf_address
	mess_mac rd7font,2,>c0,>b6,bpal_white*>10000,strcnrmos_scr,0
	.string	"MORTAL KOMBAT II\n"
	.string "1340 W. IRVING PARK RD. SUITE 414\n"
	.string	"CHICAGO, IL.  60613\n",0
	.even

pf_allow
	mess_mac rd7font,2,>c0,>e0,bpal_red*>10000,strcnrmos_scr,0
	.string	"CHECKS PAYABLE TO MIDWAY MANUFACTURING\n"
	.string	"6-8 WEEKS FOR DELIVERY. EXPIRES FEB. 22, 1995",0
	.even

pf_comic11
	mess_mac rd11font,2,>c0,>10,bpal_white*>10000,strcnrmos_scr,0
	.byte	0
	.even

pf_comic1
	mess_mac rd15font,2,>c0,>10,bpal_white*>10000,strcnrmos_scr,0
	.byte	0
	.even

;***************************************************************

amode_init_no_score
	callr	amode_oinit
	jauc	dont_show_scores

amode_oinit
	calla	murder_myoinit_score

	movi	dlists_bogus,a0
	move	a0,@dlists,l

	clr	a0
	move	a0,@irqskye,w
	move	a0,@noflip,w			; page flipping on
	movk	1,a0
	move	a0,@f_doscore,w			; show scores
	rets

;***************************************************************

*
* a10 = sleep time after fade
* assumes display sysyem = off
*
amode_fadein
	movi	all_palettes,a0
	calla	fadeblak		; fade all palette black (instantly)
	calla	display_on
	movi	all_palettes,a0
	calla	fadein			; fade in
	move	a10,a0
	calla	prcslp
	retp

;***************************************************************

show_next_bio
	calla	murder_myoinit_score
	calla	display_on
	calla	clr_scrn

	move	@c_amode_bio,a0,w
	inc	a0
	cmpi	11,a0
	jrls	bio2
	clr	a0
bio2	move	a0,@c_amode_bio,w

	push	a0
	move	a0,a2
	create	pid_amode,say_that_name_proc
	move	a2,*a0(pa8),l
	pull	a0

	move	a0,a8				; pkzip pic offset
	cmpi	ft_cage,a0			; cage ?
	jrne	bio3				; no...
	movi	>28,a8				; yes, use the old picture of him
bio3	sll	5,a0
	move	a0,a1
	sll	1,a1
	add	a1,a0
	addi	bio_table,a0
	move	*a0+,a9,l			; 1st text
	move	*a0+,a11,l			; 2nd text
	move	*a0,a1,l			; 3rd text

	movi	>14,a0
	movi	>40*12,a2			; view time
	movi	(>1000*>16)+(8*>1d),a10	; a10 = coordinates of zipped pic
	jsrp	one_story_screen
	calla	display_on
	retp

say_that_name_proc
	sleep	>0d
	move	a8,a0
	addi	>1c,a0
	calla	triple_sound2
	sleep	>20
	movi	>41,a3
	calla	send_code_a3			; tune also
	die

bio_table
	.long	pf_hh_title,pf_hh_bio1,pf_hh_bio2
	.long	pf_lk_title,pf_lk_bio1,pf_lk_bio2
	.long	pf_jc_title,pf_jc_bio1,pf_jc_bio2
	.long	pf_sa_title,pf_sa_bio1,pf_sa_bio2
	.long	pf_fn1_title,pf_fn1_bio1,pf_fn1_bio2

	.long	pf_fn2_title,pf_fn2_bio1,pf_fn2_bio2
	.long	pf_st_title,pf_st_bio1,pf_st_bio2
	.long	pf_rd_title,pf_rd_bio1,pf_rd_bio2
	.long	pf_sz_title,pf_sz_bio1,pf_sz_bio2
	.long	pf_rp_title,pf_rp_bio1,pf_rp_bio2
	.long	pf_sc_title,pf_sc_bio1,pf_sc_bio2
	.long	pf_jx_title,pf_jx_bio1,pf_jx_bio2

pf_hh_title
	mess_mac rd11font,2,>61,>c3,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"KUNG LAO"
	.byte	0
	.even

pf_hh_bio1
	mess_mac rd11font,2,>b2,>27,bpal_white*>10000,strlnrmos_scr,0
	.string	"A FORMER SHAOLIN MONK\n"
	.string	"AND MEMBER OF THE WHITE\n"
	.string	"LOTUS SOCIETY, HE IS\n"
	.string	"THE LAST DESCENDANT OF\n"
	.string	"THE GREAT KUNG LAO WHO\n"
	.byte	0
	.even

pf_hh_bio2
	mess_mac rd11font,2,>b2,>77,bpal_white*>10000,strlnrmos_scr,0
	.string	"WAS DEFEATED BY GORO\n"
	.string	"500 YEARS AGO. REALIZING\n"
	.string	"THE DANGER OF THE\n"
	.string	"OUTWORLD MENACE HE\n"
	.string	"JOINS LIU KANG IN\n"
	.string	"ENTERING SHAO KAHN'S\n"
	.string	"CONTEST."
	.byte	0
	.even


pf_lk_title
	mess_mac rd11font,2,>61,>c3,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"LIU KANG"
	.byte	0
	.even

pf_lk_bio1
	mess_mac rd11font,2,>b2,>19,bpal_white*>10000,strlnrmos_scr,0
	.string	"AFTER WINNING THE\n"
	.string	"SHAOLIN TOURNAMENT\n"
	.string	"FROM SHANG TSUNG'S\n"
	.string	"CLUTCHES KANG RETURNS\n"
	.string	"TO HIS TEMPLES. HE\n"
	.byte	0
	.even

pf_lk_bio2
	mess_mac rd11font,2,>b2,>69,bpal_white*>10000,strlnrmos_scr,0
	.string	"DISCOVERS HIS SACRED\n"
	.string	"HOME IN RUINS, HIS\n"
	.string	"SHAOLIN BROTHERS KILLED\n"
	.string	"IN A VICIOUS BATTLE WITH\n"
	.string	"A HORDE OF OUTWORLD\n"
	.string	"WARRIORS. NOW HE\n"
	.string	"TRAVELS INTO THE DARK\n"
	.string	"REALM TO SEEK REVENGE."
	.byte	0
	.even


pf_jc_title
	mess_mac rd11font,2,>61,>c3,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"JOHNNY CAGE"
	.byte	0
	.even

pf_jc_bio1
	mess_mac rd11font,2,>b2,>1b,bpal_white*>10000,strlnrmos_scr,0
	.string	"AFTER SHANG TSUNG'S\n"
	.string	"TOURNAMENT, THE\n"
	.string	"MARTIAL ARTS SUPERSTAR\n"
	.string	"DISAPPEARS. HE FOLLOWS\n"
	.string	"LIU KANG INTO THE\n"
	.byte	0
	.even

pf_jc_bio2
	mess_mac rd11font,2,>b2,>6b,bpal_white*>10000,strlnrmos_scr,0
	.string	"OUTWORLD.\n"
	.string	"THERE HE WILL COMPETE\n"
	.string	"IN A TWISTED TOURNA-\n"
	.string	"MENT WHICH HOLDS THE\n"
	.string	"BALANCE OF EARTH'S\n"
	.string	"EXISTENCE- AS WELL AS A\n"
	.string	"SCRIPT FOR ANOTHER\n"
	.string	"BLOCKBUSTER MOVIE.\n"
	.byte	0
	.even



pf_sa_title
	mess_mac rd11font,2,>61,>c3,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"BARAKA"
	.byte	0
	.even

pf_sa_bio1
	mess_mac rd11font,2,>b2,>26,bpal_white*>10000,strlnrmos_scr,0
	.string	"HE LED THE ATTACK\n"
	.string	"AGAINST LIU KANG'S\n"
	.string	"SHAOLIN TEMPLE. BARAKA\n"
	.string	"BELONGS TO A NOMADIC\n"
	.string	"RACE OF MUTANTS\n"
	.byte	0
	.even

pf_sa_bio2
	mess_mac rd11font,2,>b2,>76,bpal_white*>10000,strlnrmos_scr,0
	.string	"LIVING IN THE WASTE-\n"
	.string	"LANDS OF THE OUTWORLD.\n"
	.string	"HIS FIGHTING SKILLS\n"
	.string	"GAINED THE ATTENTION OF\n"
	.string	"SHAO KAHN WHO\n"
	.string	"RECRUITED HIM INTO HIS\n"
	.string	"ARMY.\n"
	.byte	0
	.even



pf_fn1_title
	mess_mac rd11font,2,>61,>c3,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"KITANA"
	.byte	0
	.even

pf_fn1_bio1
	mess_mac rd11font,2,>b2,>26,bpal_white*>10000,strlnrmos_scr,0
	.string	"HER BEAUTY HIDES HER\n"
	.string	"TRUE ROLE AS PERSONAL\n"
	.string	"ASSASSIN FOR SHAO KAHN.\n"
	.string	"SEEN TALKING TO AN\n"
	.string	"EARTH REALM WARRIOR.\n"
	.byte	0
	.even

pf_fn1_bio2
	mess_mac rd11font,2,>b2,>76,bpal_white*>10000,strlnrmos_scr,0
	.string	"HER MOTIVES HAVE\n"
	.string	"COME UNDER SUSPICION\n"
	.string	"BY HER TWIN SISTER\n"
	.string	"MILEENA. BUT ONLY KITANA\n"
	.string	"KNOWS HER OWN TRUE\n"
	.string	"INTENTIONS.\n"
	.byte	0
	.even


pf_fn2_title
	mess_mac rd11font,2,>61,>c3,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"MILEENA"
	.byte	0
	.even

pf_fn2_bio1
	mess_mac rd11font,2,>b2,>26,bpal_white*>10000,strlnrmos_scr,0
	.string	"SERVING AS AN ASSASSIN\n"
	.string	"ALONG WITH HER TWIN\n"
	.string	"SISTER KITANA, MILEENA'S\n"
	.string	"DAZZLING APPEARANCE\n"
	.string	"CONCEALS HER HIDEOUS\n"
	.byte	0
	.even

pf_fn2_bio2
	mess_mac rd11font,2,>b2,>76,bpal_white*>10000,strlnrmos_scr,0
	.string	"INTENTIONS. AT SHAO\n"
	.string	"KAHN'S REQUEST SHE IS\n"
	.string	"ASKED TO WATCH FOR HER\n"
	.string	"TWIN'S SUSPECTED\n"
	.string	"DISSENSION. SHE MUST\n"
	.string	"PUT A STOP TO IT AT\n"
	.string	"ANY COST."
	.byte	0
	.even


pf_st_title
	mess_mac rd11font,2,>61,>c3,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"SHANG TSUNG"
	.byte	0
	.even

pf_st_bio1
	mess_mac rd11font,2,>b2,>26,bpal_white*>10000,strlnrmos_scr,0
	.string	"AFTER LOSING CONTROL\n"
	.string	"OF THE SHAOLIN\n"
	.string	"TOURNAMENT, TSUNG PRO-\n"
	.string	"MISES HIS RULER SHAO\n"
	.string	"KAHN TO SHAPE EVENTS\n"
	.byte	0
	.even

pf_st_bio2
	mess_mac rd11font,2,>b2,>76,bpal_white*>10000,strlnrmos_scr,0
	.string	"THAT WILL LURE THE\n"
	.string	"EARTH WARRIORS TO\n"
	.string	"COMPETE IN HIS OWN\n"
	.string	"CONTEST. CONVINCED OF\n"
	.string	"THIS PLAN, SHAO KAHN\n"
	.string	"RESTORES TSUNG'S YOUTH\n"
	.string	"AND ALLOWS HIM TO LIVE.\n"
	.byte	0
	.even


pf_rd_title
	mess_mac rd11font,2,>61,>c3,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"RAIDEN"
	.byte	0
	.even

pf_rd_bio1
	mess_mac rd11font,2,>b2,>19,bpal_white*>10000,strlnrmos_scr,0
	.string	"WATCHING EVENTS UNFOLD\n"
	.string	"FROM HIGH ABOVE, THE\n"
	.string	"THUNDER GOD REALIZES\n"
	.string	"THE GRIM INTENTIONS OF\n"
	.string	"SHAO KAHN. AFTER\n"
	.byte	0
	.even

pf_rd_bio2
	mess_mac rd11font,2,>b2,>69,bpal_white*>10000,strlnrmos_scr,0
	.string	"WARNING THE REMAINING\n"
	.string	"MEMBERS OF THE\n"
	.string	"SHAOLIN TOURNAMENT,\n"
	.string	"RAIDEN SOON DISAPPEARS.\n"
	.string	"HE IS BELIEVED TO HAVE\n"
	.string	"VENTURED INTO THE\n"
	.string	"OUTWORLD ALONE.\n"
	.byte	0
	.even


pf_sz_title
	mess_mac rd11font,2,>61,>c3,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"SUB-ZERO"
	.byte	0
	.even

pf_sz_bio1
	mess_mac rd11font,2,>b2,>19,bpal_white*>10000,strlnrmos_scr,0
	.string	"THOUGHT TO HAVE BEEN\n"
	.string	"KILLED IN THE SHAOLIN\n"
	.string	"TOURNAMENT, SUB-ZERO\n"
	.string	"MYSTERIOUSLY RETURNS.\n"
	.string	"IT IS BELIEVED HE\n"
	.byte	0
	.even

pf_sz_bio2
	mess_mac rd11font,2,>b2,>69,bpal_white*>10000,strlnrmos_scr,0
	.string	"TRAVELLED INTO THE\n"
	.string	"OUTWORLD TO AGAIN\n"
	.string	"ATTEMPT TO\n"
	.string	"ASSASSINATE SHANG\n"
	.string "TSUNG. TO DO SO HE\n"
	.string	"MUST FIGHT HIS WAY\n"
	.string	"THROUGH SHAO KAHN'S\n"
	.string	"TOURNAMENT."
	.byte	0
	.even


pf_rp_title
	mess_mac rd11font,2,>61,>c3,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"REPTILE"
	.byte	0
	.even

pf_rp_bio1
	mess_mac rd11font,2,>b2,>19,bpal_white*>10000,strlnrmos_scr,0
	.string	"AS SHANG TSUNG'S\n"
	.string	"PERSONAL PROTECTOR\n"
	.string	"THE ELUSIVE REPTILE\n"
	.string	"LURKS IN THE SHADOWS\n"
	.string	"STOPPING ALL THOSE\n"
	.byte	0
	.even

pf_rp_bio2
	mess_mac rd11font,2,>b2,>69,bpal_white*>10000,strlnrmos_scr,0
	.string	"WHO WOULD DO HIS\n"
	.string	"MASTER HARM. HIS HUMAN\n"
	.string	"FORM IS BELIEVED TO\n"
	.string	"DISGUISE A HORRID\n"
	.string	"REPTILIAN CREATURE\n"
	.string	"WHOSE RACE WAS\n"
	.string	"THOUGHT EXTINCT\n"
	.string	"MILLIONS OF YEARS AGO."
	.byte	0
	.even


pf_sc_title
	mess_mac rd11font,2,>61,>c3,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"SCORPION"
	.byte	0
	.even

pf_sc_bio1
	mess_mac rd11font,2,>b2,>26,bpal_white*>10000,strlnrmos_scr,0
	.string	"THE HELL-SPAWNED\n"
	.string	"SPECTER RISES FROM THE\n"
	.string	"PITS. AFTER LEARNING\n"
	.string	"OF SUB-ZERO'S RETURN,\n"
	.string	"HE AGAIN STALKS THE\n"
	.byte	0
	.even

pf_sc_bio2
	mess_mac rd11font,2,>b2,>76,bpal_white*>10000,strlnrmos_scr,0
	.string	"NINJA ASSASSIN-\n"
	.string	"FOLLOWING HIM INTO\n"
	.string	"THE DARK REALM OF\n"
	.string	"THE OUTWORLD WHERE\n"
	.string	"HE CONTINUES HIS OWN\n"
	.string	"UNHOLY MISSION.\n"
	.byte	0
	.even

pf_jx_title
	mess_mac rd11font,2,>61,>c3,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"JAX"
	.byte	0
	.even

pf_jx_bio1
	mess_mac rd11font,2,>b2,>19,bpal_white*>10000,strlnrmos_scr,0
	.string	"HIS REAL NAME IS MAJ.\n"
	.string	"JACKSON BRIGGS, LEADER\n"
	.string	"OF A TOP U.S. SPECIAL\n"
	.string	"FORCES UNIT. AFTER\n"
	.string	"RECEIVING A DISTRESS\n"
	.byte	0
	.even

pf_jx_bio2
	mess_mac rd11font,2,>b2,>69,bpal_white*>10000,strlnrmos_scr,0
	.string	"SIGNAL FROM LT. SONYA\n"
	.string	"BLADE, JAX EMBARKS ON\n"
	.string	"A RESCUE MISSION. ONE\n"
	.string	"THAT LEADS HIM INTO A\n"
	.string	"GHASTLY WORLD WHERE HE\n"
	.string	"BELIEVES THAT SONYA\n"
	.string	"IS STILL ALIVE."
	.byte	0
	.even



;mk2_story
;	callr	amode_init_no_score
;	calla	display_off
;	movi	huge_mod,a0
;	calla	init_bakmods
;	calla	multi_plane
;	sleep	3
;	movi	>30,a10			; sleep time after fade start
;	jsrp	amode_fadein
;
;	create	pid_fx,text_deleter
;
;	movi	txt_story1,a8
;	movk	22,a0
;	movi	>05,a1
;	jsrp	scroll_a_chunk
;	sleep	>40
;
;	movi	txt_story2,a8
;	movk	22,a0
;	movk	1,a1
;	jsrp	scroll_a_chunk
;	sleep	>30
;
;	movi	txt_story3,a8
;	movk	22,a0
;	movk	1,a1
;	jsrp	scroll_a_chunk
;	sleep	>30
;
;	sleep	>40*3
;	jruc	amode_fade_retp
;
;
;txt_story1
;	.STRING	"WITH THE AID OF GORO, SHANG TSUNG USED THE",0
;	.EVEN
;	.STRING	"SHAOLIN TOURNAMENT AS A MEANS OF ATTRACTING",0
;	.EVEN
;	.STRING	"EARTH'S MIGHTIEST WARRIORS. BY DEFEATING THEM",0
;	.EVEN
;	.STRING	"ONE-BY-ONE THE FURIES SLOWLY BECAME UNBALANCED.",0
;	.BYTE	-1
;	.EVEN
;
;txt_story2
;	.STRING	"BUT THIS SCHEME WOULD COME TO A VIOLENT END",0
;	.EVEN
;	.STRING	"AT THE HANDS OF LIU KANG.",0
;	.EVEN
;	.STRING	"FACING EXECUTION, SHANG TSUNG RETURNS TO THE",0
;	.EVEN
;	.STRING	"OUTWORLD WITH WORD OF HIS DEFEAT AND THE",0
;	.EVEN
;	.STRING	"APPARENT DEATH OF GORO.",0
;	.BYTE	-1
;	.EVEN
;
;txt_story3
;	.string "TO CONVINCE SHAO KAHN TO GRANT HIM A SECOND",0
;	.EVEN
;	.STRING	"CHANCE, HE CONCEIVES A PLAN TO LURE HIS",0
;	.EVEN
;	.string	"ADVERSARIES INTO THE OUTWORLD. THERE THEY",0
;	.EVEN
;	.STRING	"WILL MEET DEATH AT THE HANDS OF",0
;	.EVEN
;	.STRING	"SHAO KAHN HIMSELF.",0
;	.BYTE	-1
;	.EVEN
;
;scroll_a_chunk
;	pushp	a1
;	move	a0,*a13(p_anirate),w
;am3	movb	*a8,a0
;	jrne	am5			; zero = blank line
;	addk	8,a8			; a8 ---> after zero
;	jruc	am8
;am5	cmpi	-1,a0
;	jreq	am9
;	jsrp	scroll_print
;am8   	move	*a13(p_anirate),a0,w
;ama	calla	prcslp
;	jruc	am3
;
;am9	pullp	a0
;	calla	prcslp
;
;	movk	1,a0
;	move	a0,@f_novel,w
;	sleep	>60
;	clr	a0
;	move	a0,@f_novel,w
;	retp
;
;
;scroll_print
;	movb	*a8,a0
;	jreq	scrp9			; blank line ---> retp
;	push	a8	
;	movi	pf_scroll,a8
;	calla	lm_setup		; print setup
;	pull	a8
;	jsrp	printf
;	subk	8,a8
;
;	callr	set_letter_vel
;	jruc	scrp7
;scrp9	addk	8,a8
;scrp7	retp
;
;
;set_letter_vel
;	move	@objlst2,a0,l
;	jreq	slv9
;	move	a0,a3
;	clr	a1
;	move	a1,@objlst2,l
;		
;	movi	->10000,a2
;scrp4	move	a2,*a0(oyvel),l
;	move	*a0(olink),a0,l
;	jrne	scrp4
;
;	move	@objlst,a4,l
;	jreq	scrp6
;scrp5	move	a4,a5
;	move	*a4(olink),a4,l
;	jrne	scrp5
;	move	a3,*a5(olink),l
;	jruc	slv9
;scrp6	move	a3,@objlst,l
;slv9	rets
;
;
;text_deleter
;	sleep	>8
;	move	@objlst,a0,l
;	jreq	text_deleter
;objjd	move	*a0(olink),a2,l		; a2 = next
;	move	*a0(oypos),a1,w
;	sll	16,a1
;	sra	16,a1
;;	cmpi	>7fff,a1
;	cmpi	-12,a1
;	jrgt	objjc
;	calla	delobjp			; offscreen ----> delete
;objjc	move	a2,a0
;	jrne	objjd
;	jruc	text_deleter
;
;pf_scroll
;;	MESS_MAC rd11font,2,scrrgt/2,>F8,bpal_yellow*>10000,strcnrmos_scr,0
;	MESS_MAC rd11font,2,scrrgt/2,>F8,bpal_yellow*>10000,strcnrmo_scr,0
;	.BYTE	0
;	.EVEN
;


dcs_sound_ad
	calla	clr_scrn
	calla	murder_myoinit_score

	calla	page_0_zip_setup
	calla	view_page_1
	calla	display_on

	movi	blue_grad_pal,a0
	calla	getfpal

	sleep	2			; time for palette to be put in place

	clr	a3
    	movi	>00000202,a1

	movi	31,a10
loop	movi	>00040180,a2
	movi	>2000000,a4
	movi	>800c,a5
	calla	dman
	addi	>01010000,a1
	addi	>00040000,a3
	dsj	a10,loop

	addi	>00070000,a3

	movi	32,a10
loop2	movi	>00040180,a2
	movi	>2000000,a4
	movi	>800c,a5
	calla	dman
	subi	>01010000,a1
	addi	>00040000,a3
	dsj	a10,loop2

	sleep	4
	calla	display_off
	jsrp	show_dcs_logo
	calla	display_on
	calla	view_page_0
	movi	>21b,a3
	calla	send_code_a3		; gong
	sleep	>40*5

	calla	murder_myoinit_score
	sleep	3
	retp


blue_grad_pal
	.word	32

	.word	31
	.word	30
	.word	29
	.word	28
	.word	27
	.word	26
	.word	25
	.word	24
	.word	23
	.word	22
	.word	21
	.word	20
	.word	19
	.word	18
	.word	17
	.word	16

	.word	15
	.word	14
	.word	13
	.word	12
	.word	11
	.word	10
	.word	9
	.word	8
	.word	7
	.word	6
	.word	5
	.word	4
	.word	3
	.word	2
	.word	1
	.word	0



	.end
