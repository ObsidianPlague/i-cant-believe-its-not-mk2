	.file	'diagmenu.asm'
	.title	"<<< menu system main module >>>"
	.width	132
	.option	b,d,l,t
	.mnolist

**************************************************************************
*												*
*	diagnostic menu program									*
*												*
*	copyright (c) 1990 williams electronics games, inc.			*
*	all rights reserved.									*
*												*
**************************************************************************

	.include	"dispequ.asm"	; display processor equates
	.include	"sysequ.asm"		; system equates
	.include	"mainequ.asm"
	.include	"imgtbl.glo"
	.include	"stringh.asm"

	.include	"diagsequ.asm"
	.include	"diagmequ.asm"	; menu equates
	.include	"diagaudn.asm"	; auditing offsets
	.include	"dipequ.asm"
	.include	"diagdict.asm"
	.include	"macros.hdr"

	.def	p_fork, rom_name, any_but, wait_but, diag, cpu_ret
	.def	st_stick, getstick, mess_mm, menu_top, std_bord, b_menu
	.def	blnkhelp, col_inst, h_slave
	.def	ckdiag, cktest, diag_myoinit, diag_colors
	.def	wolf,digsrt
	.if	printer
	.def	printaudtable
	.def	printcointable
	.endif
	.def	get_plays,new_fac_stuf
;	.def	blastmess

	.ref	wipeout, strnglen, hextoasc, get_aud
	.ref	read_dip, go_adj

	.ref	lm_xfinis
	.ref	clr_audr
	.ref	no_creds, diagcputest, burnin
	.ref	warmset, cmoslock, cmosunlock
	.ref	form_adc, wc_word, cmos_val, fac_set, adj_page, f_adc_s
	.ref	clr_aud, do_adjh, wc_bytei, bad_aud
	.ref	men_adj, ckdip, store_audit
	.ref	get_cspt, gameunits
	.ref	cat_a0, strcat, duxpal

	.if	printer
	.ref	printauds,pbadguy
	.else
	.ref	switchtest, conv_plot, diptest
	.ref	colorbar
	.endif

*
*	main_ret
*
*	positive number here says return (upward) to main menu (gen_menu only)
*	negative number here says setup restore after ram test. (gen_menu)
*
****	.bss	bad_aud,16
	.bss	main_ret,16		;flag says return to main menu
	.bss	gmenulev,16		;how deep into gen_menu we are
	.bss	snd_made,16		;sound test flag
	.bss	no_clear,16		;flag tells get_menu not to clear!
	.bss	last_but,32
	.bss	scode,16
	.bss	dcode,16
	.bss	fac_flag,16		;flag says clear audits and hstable
	.bss	swset1,32
	.bss	swset2,32
	.bss	charout,16
	.bss	bline,16
	.bss	bchar,16
	.bss	ptsize,16		;bogus 15 pt font flag
	.bss	lastcolor,32
	.def	lastcolor

	.text

	.if	printer
go_print
	jauc	printauds
	.endif

**************************************************************************
*											     *
* 	diag										     *
* 											     *
* 	process started when diag switch is hit				     *
* 											     *
* 	entry	nothing									     *
* 	exit	warmboots the processor						     *
*											     *
**************************************************************************
diag

;	calla	sndresp		;reset the sound board for our purposes

	calla	nosounds
	movi	>2000,a0
	dsjs	a0,$
	calla	set_game_volume

;	clr	a0
;	move	a0,@noflip,w

	move	@gstate,a0,w
	cmpi	gs_diag,a0
	jrnz	diag_jump
	jauc	sucide

diag_jump
	clr	a0
	move	a0,@ptsize,w	; everything in 7pt
	callr	digsrt		;make sure we're in test mode
;	jsrp	ww_adv		;hold until he lets go!

	.if	printer
	movk	8,a0
	calla	pbadguy		; entering test mode
	.endif
	clr	a0
	move	a0,@main_ret,w	;clear the float to top flag.
	move	a0,@gmenulev,w	;indicate we're at level zero.

diag_restart
	clr	b4		;clear b4 to fix this bug  - MDP - PENACHO
	movi	men_main,a8
	jsrp	gen_menu		;process this menu!

**************************************************************************
*											     *
* 	diag_ex										     *
* 											     *
* 	diagnostic exit									     *
* 											     *
* 	entry	nothing									     *
* 	exit	nothing									     *
*											     *
**************************************************************************
diag_ex:
	sleep	2
;	calla	wdogdis
	calla	clr_scrn
	calla	cmos_val		; validate the cmos
	calla	cktest
	calla	read_dip

	andi	dip_diag,a0		; dipswitch diag ?
	jrne	de1			; yes

	move	@switch,a0,l
	not	a0
	btst	b_diag,a0
	jaeq	warmset			; dipswitch AND diag open = warmset
	jruc	de2

de1	movi	notcloseddip,a8
	calla	lm_setup
	jsrp	printf			; yes, put up message

de2	move	@switch,a0,l
	not	a0
	btst	b_diag,a0
	jreq	de3
	movi	notclosedjamma,a8
	calla	lm_setup
	jsrp	printf

de3	movi	notclosedwait,a8
	calla	lm_setup
	jsrp	printf
	move	@switch,a0,l			; hangout for a while
	andi	button_bits|00100000h,a0	;isolate buttons and test switch
	move	a0,@swset1,l			;store for the compare
	move	@switch+32,a0,l			;get the dip test switch
	andi	01000000h,a0
	move	a0,@swset2,l
de4
	sleep	1
	callr	cktest			; check status of test switch
	move	@switch,a0,l		; gotta see if time to leave
	move	@swset1,a1,l
	move	a0,a3			; save a copy around
	andi	button_bits,a0
	andi	button_bits,a1
	cmp	a0,a1			;did the buttons get hit?
	jrnz	de5			;br = yes, go back to the test mode

	move	@swset1,a1,l
	andi	00100000h,a1
	andi	00100000h,a3
	cmp	a1,a3			;is the test switch open?
	jrnz	diag_ex			;br = yesh

	move	@switch+32,a3,l
	move	@swset2,a1,l
	andi	01000000h,a1
	andi	01000000h,a3
	cmp	a1,a3			;is the dip test switch open?
	jrnz	diag_ex			;br = yesh

	jruc	de4
de5
	callr	cktest			; one final time ( still wrong )
	jruc	diag_jump

notcloseddip
	mess_mac  rd7font,spacing07,200,50,trog_pred,strcnrm,0
        .string	 w_dipswitch," ",w_test," SELECT (DS2 # 8) ",w_closed,".",0
	.even

notclosedjamma
	mess_mac  rd7font,spacing07,200,70,trog_pred,strcnrm,0
        .string	 "DIAGNOSTICS SWITCH IS CLOSED",0
	.even

notclosedwait
	mess_mac  rd7font,spacing07,200,120,trog_pred,strcnrm,0
	.string	"PRESS ANY ",w_button," TO ",w_return," TO ",w_test," MODE\nOR"
	.string	"\nOPEN THE ",w_switch,"(S) TO ",w_return," TO ",w_game,".",0
	.even

**************************************************************************
*												*
*	  digsrt										*
*												*
*	  this is called on entry to diagnostics.					*
*												*
**************************************************************************

digsrt
	callr	diag_state
	calla	wipeout			; re-init system

	calla	sndresp			; kill any sounds in progress
	calla	diag_myoinit		; initialize object lists
	rets

**************************************************************************
*									    			*
*	diag_state							 			*
*									 			*
*	get everything setup/killed off for diag state			 	*
*									 			*
*	entry								 			*
*		nothing							 			*
*									 			*
*	exit								 			*
*		nothing							 			*	
*									    			*
**************************************************************************

diag_state
	clr	a1
	calla	kilall			;kill absolutely everyone!

	movi	pid_diag,a1		;set our id to diagnostics man
	move	a1,*a13(procid),w	;pass our id to forked process

	movi	gs_diag,a0
	move	a0,@gstate,w		;put us in test mode!
	clr	a0
	move	a0,@f_nosound,w		; allow sound calls
	rets

**************************************************************************
*											     *
* diag_myoinit - special oinit for the diagnostic system only.		     *
* returns										     *
* 	display system on								     *
* 	auto-erase off									     *
* 	duxpal is palette 0								     *
*											     *
**************************************************************************
diag_myoinit
	push	a0
	calla	oinit

	movk	1,a0
	move	a0,@noflip,w	; no page flipping
	move	a0,@displayon,w	; display system on

	calla	clrpal		;let's set up our own palettes
	movi	duxpal,a0
	calla	getfpal		;get the fixed foreground palette

	callr	diag_colors

**************************************************************************
*											     *
*  mk 2 specific      									     *
*											     *
**************************************************************************

	calla	dont_show_scores	; scores = off
	clr	a0
	move	a0,@curback,w		; current background = 0
	move	a0,@f_auto_erase,w	; auto erase = off
	movk	1,a0
	move	a0,@noflip,w		; page flipping = off

	pull	a0
	rets

num_diag_cycle_colors	.equ	4
diag_cycle_color_start	.equ	0bh

	.bss	diag_cram,num_diag_cycle_colors*16,1	;ram for transfer

**************************************************************************
*									    			*
* diag_colors - process that cycle colors for the diagnostic menus.	 	*
*									    			*
**************************************************************************
diag_colors
	mmtm	sp,a0,a1,a7
	movi	pid_cycle,a0
	clr	a1
	not	a1
	calla	kilall
	create	pid_cycle,pc_transfer
	create	pid_cycle,lflash
	create	pid_cycle,rgb
	create	pid_cycle,bpr
	create	pid_cycle,decay
	mmfm	sp,a0,a1,a7
	rets

**************************************************************************
*												*
* table driven color ram processes					 *
*												*
**************************************************************************
*	18000b0(11)	-	bpr
*	18000c0(12)	-	decay
*	18000d0(13)	-	laser flash
*	18000e0(14)	-	rgb

rgb	callr	tabdrive
	.long	rgbtab,diag_cram+30h
	.word	8
rgbtab	.word	07c00h,001fh,>77a0,>741a,0ffffh

*
decay	callr	tabdrive
	.long	dcatab,diag_cram+010h
	.word	2
dcatab	.word	001ch,001ch,011ch,021ch,031ch,039ch,239ch,2390h,2388h
	.word	2380h,4300h,5280h,7180h,6180h,7080h,7000h,6000h,5000h
	.word	4000h,3000h,2000h,1000h,0ffffh
*
bpr	callr	tabdrive
	.long	bprtab,diag_cram
	.word	1
bprtab	.word	001ch,101ch,201ch,301ch,401ch,501ch,601ch,701ch,7010h
	.word	7010h,7008h,7008h,7000h,7000h,7008h,7008h,7010h,7010h
	.word	701ch,701ch,601ch,501ch,401ch,301ch,201ch,101ch,0ffffh

**************************************************************************
*									    *
* lflash - process to create the famous laser flash color 		 *
*									    *
**************************************************************************
lflash	movi	07fffh,a0
	move	a0,@diag_cram+20h,w
	sleep	2
lflash1
	move	@rand,a0,w
	andi	0000001fh,a0
	movi	coltab,a1
	sll	4,a0
	add	a0,a1
	move	*a1,a1,w
	move	a1,@diag_cram+020h,w
	sleep	6
	jruc	lflash

coltab	.word	0380h,1380h,2380h,3380h,4380h,5380h,6380h,7380h,7300h
	.word	7280h,7200h,7180h,7080h,7008h,7008h,7010h,7010h,701ch
	.word	701ch,601ch,501ch,409ch,309ch,209ch,219ch,029ch,039ch
	.word	139ch,239ch,339ch,539ch,739ch,7390h,7380h,6380h,4380h
	.word	0ffffh

**************************************************************************
*												*
* the table driven process						 *
*												*
**************************************************************************
tabdrive
	move	*sp+,a0,l
	move	*a0+,a11,l	;a11 = table start
	move	*a0+,a9,l	;a9 = location to stuff color
	move	*a0,a10,w	;a10 = sleep time
tabdrv1
	move	a11,a8		;reset to start of table
tabdrv2
	move	*a8+,a0,w	;get a color
	jrn	tabdrv1		;br = end of table
	move	a0,*a9,w
	move	a10,a0
	movi	tabdrv2,a7
	jauc	prclsp		;loop sleep

**************************************************************************
*									    *
* pc_transfer - process to transfer cycle colors to the color		 *
*		ram every tick.						 *
*									    *
**************************************************************************
pc_transfer
	movi	diag_cram,a0
	movi	diag_cycle_color_start,a1
	movi	num_diag_cycle_colors,a2
	calla	palset
	sloop	1,pc_transfer

**************************************************************************
*									    *
*	go_diag								 *
*									 *
*	enter the diagnostics menu					 *
*									    *
**************************************************************************

vb_height	.set	171
vb_y		.set	>2e


go_volume
	calla	diag_myoinit
	calla	clr_scrn
	create	pid_fx,background_sound

	movi	dlists_objlst,a0
	move	a0,@dlists,l		; simple display lists

	clr	a0
	move	a0,@noflip,w
	move	a0,@f_nosound,w		; allow sounds

	movk	1,a0
	move	a0,@f_auto_erase,w	; auto erase = on
	movi	rgb_grey,a0
	move	a0,@irqskye,w

	movi	boonpal,a0
	calla	getfpal

	movi	volume_table,a5
vol2	move	*a5+,a3,l
	jreq	vol4

	push	a5
	movi	bpal_yellow,a0
	calla	make_solid_object
	pull	a5

	move	*a5+,a4,l
	calla	set_xy_coordinates
	calla	insobja8
	jruc	vol2

vol4	movi	pf_volume_1,a8
	jsrp	lm_printf
	movi	pf_volume_2,a8
	jsrp	lm_printf
	movi	pf_volume_3,a8
	jsrp	lm_printf
	movi	pf_volume_4,a8
	jsrp	lm_printf

	movi	bpal_red,a0
	movi	(bw-(2*bthickx))+(bh-(2*bthicky))+>10000,a3
	calla	make_solid_object
	movi	bxy+bthickx+bthicky+>00010001,a4
	calla	set_xy_coordinates

	movi	adj_volume,a0
	calla	get_adj
	move	a0,a10				; a10 = cmos volume
	callr	set_volume_a10
	calla	insobja8
*
* read cmos value
*
vol6	cmpi	255,a10
	jrls	vol7
    	movi	255,a10
vol7	cmpi	4,a10
	jrhs	vol8
	movk	4,a10				; keep within limits
*
* send volume call to sound board
*
vol8	callr	set_volume_a10
	sleep	1

	move	@switch,a0,l
	not	a0
	btst	bit_jup,a0
	jrne	vol_up
	btst	bit_jdown,a0
	jrne	vol_down
	btst	b_vup,a0
	jrne	vol_up
	btst	b_vdown,a0
	jrne	vol_down

	srl	8,a0				; player 2 stick ?
	btst	bit_jup,a0
	jrne	vol_up
	btst	bit_jdown,a0
	jrne	vol_down
*
* button exit ?
*
	move	@switch,a0,l
	not	a0
	andi	p1b0|p1b2|p1b3|p1sf2|p2b0|p2b2|p2b3|p2sf2,a0
	jrne	volume_done
	move	@switch2,a0,l
	not	a0
	andi	p1b1|p1b4|p2b1|p2b4,a0
	jrne	volume_done
	jruc	vol6


set_volume_a10
	movi	>55aa,a3
	calla	send_code_a3
	move	a10,a3				; volume
	move	a10,a1
	not	a1				; sans volume
	sll	32-8,a1	
	srl	32-8,a1
	sll	8,a3
	or	a1,a3				; a3 = [volume,sans volume]
	calla	send_code_a3

	move	a10,a1				; a1 = volume
	movi	vb_height,a3
	mpys	a3,a1				; cross multiplication
	sll	16,a1
	movi	255*>10000,a5
	divu	a5,a1				; scale it down for bar height
	move	a1,*a8(osizey),w

	movi	vb_height,a3
	sub	a1,a3				; a3 = distance from top
	movi	vb_y,a1
	add	a3,a1
	move	a1,*a8(oypos),w			; adjust y pos for new size
	rets

volume_done
	move	a10,a1
	movi	adj_volume,a0
	calla	put_adj
	calla	f_adc_s			; make checksums kosher !

	movi	pid_fx,a0
	calla	dallprc			; kill background dude
	movi	>33,a3
	calla	send_code_a3

	movi	bpal_red,a9
	movi	bpal_blue,a11
	jsrp	flash_v
	jsrp	flash_v
	jsrp	flash_v
	jsrp	flash_v
	sleep	>20
	clr	a3
	calla	send_code_a3
	calla	diag_myoinit
	retp


vol_up	inc	a10
	jruc	vol6

vol_down
	dec	a10
	jruc	vol6


flash_v 
	move	a11,*a8(oconst),w
	sleep	3
	move	a9,*a8(oconst),w
	sleep	3
	retp

background_sound
	clr	a3
	calla	send_code_a3
	movk	1,a3
	calla	send_code_a3
	sleep	>40

bgsnd3	movi	sound_fx_table,a10
bgsnd6	move	*a10+,a3,w
	jreq	bgsnd3
	calla	send_code_a3
	sleep	>20
	jruc	bgsnd6


sound_fx_table
	.word	>258
	.word	>073
	.word	>25b
	.word	>076
	.word	>26a
	.word	>079
	.word	>26d
	.word	>0be
	.word	>270
	.word	>12c
	.word	>273
	.word	>171
	.word	0

pf_volume_1
	mess_mac rd15font,2,200,>0f,bpal_yellow*>10000,strcnrmos_scr,0
	.byte	"VOLUME ADJUST",0
	.even

pf_volume_2
	mess_mac rd7font,2,200,scrbot->1a,bpal_yellow*>10000,strcnrmos_scr,0
	.string	"USE JOYSTICKS OR VOLUME BUTTONS\nTO ADJUST VOLUME",0
	.even

pf_volume_3
	mess_mac rd7font,2,202,vb_y+>05,bpal_hot_green*>10000,strcnrmos_scr,0
	.string	"MAX",0
	.even

pf_volume_4
	mess_mac rd7font,2,202,vb_y+>a0,bpal_hot_green*>10000,strcnrmos_scr,0
	.string	"MIN",0
	.even


bxy	.set	>002a0000+200->18

bh	.set	>b0*>10000
bw	.set	>30

bthickx	.set	3
bthicky	.set	3*>10000

volume_table
	.long	bh+3,bxy		; height:width  /  y:x coordinates
	.long	bh+3,bxy+bw		; height:width  /  y:x coordinates

	.long	bthicky+bw,bxy			; height:width  /  y:x coordinates
	.long	bthicky+bw+bthickx,bxy+bh	; height:width  /  y:x coordinates
	.long	0


;************************************************************************

go_odiag
	movi	men_odiag,a8		;put up the menu and go!
	jauc	gen_menu		;this will return to level above us!


go_diag	movi	men_diag,a8		;put up the menu and go!
	jauc	gen_menu		;this will return to level above us!

go_switch
	mmtm	sp,a12,a13
	callr	test_init
	calla	switchtest
	mmfm	sp,a12,a13
	calla	diag_myoinit
	calla	clr_scrn
	retp

go_dip
	mmtm	sp,a12,a13
	callr	test_init
	calla	diptest
	mmfm	sp,a12,a13

test_return
	calla	diag_myoinit
	calla	clr_scrn
	retp


test_init
	calla	display_off
	jauc	clr_scrn


****************

go_cpu
	jauc	diagcputest

go_burn
	jauc	burnin

cpu_ret
	clr	a0
	move	a0,@gmenulev,w	;indicate we're at level zero.

	.if	printer
	.else
	movi	rtr_lev,a0	;this is the level to dive to
	neg	a0		;negate it as flag to dive.
	move	a0,@main_ret,w	;indicate
	.endif
	jauc	diag_restart	;now start it up....

	.if	printer
	.else
go_conv
	mmtm	sp,a12,a13
	calla	clr_scrn
	calla	conv_plot
	mmfm	sp,a12,a13
	jsrp	wait_but
	calla	diag_myoinit
	calla	clr_scrn
	retp

go_bars
	mmtm	sp,a12,a13

	calla	display_off
	calla	clr_scrn
	calla	colorbar
	mmfm	sp,a12,a13
	jsrp	wait_but
	calla	diag_myoinit
	calla	clr_scrn
	retp
	.endif

**************************************************************************
*									    			*
*	operator message entry						 			*
*									    			*
**************************************************************************
;op_line_char	equ	pdata
;op_line_line	equ	pdata+word_size
;op_lets		equ	op_line_line+word_size
;op_stime 	equ	op_lets+(30 * byte_size)
;op_sval		equ	op_stime+word_size
;
;let_dist_x	equ	25
;let_dist_y	equ	20
;let_box_cx	equ	6
;let_box_cy	equ	3
;let_box_wx	equ	3
;let_box_wy	equ	1
;let_start_y1	equ	175
;let_start_y2	equ	let_start_y1+let_dist_y
;let_start_y3	equ	let_start_y2+let_dist_y
;let_start_y4	equ	let_start_y3+let_dist_y
;let_inst1	equ	60
;let_start_x	equ	15
;let_line_max	equ	3
;let_char_max	equ	14
;let_text_gap	equ	11
;let_text1	equ	120
;let_text2	equ	let_text1+let_text_gap
;let_text3	equ	let_text2+let_text_gap
;op_max_chars	equ	cmess_chars
;
;
;;**************************************
;;do_opmess:
;;	calla	clr_scrn
;;	movi	m_set_omess,a8		;set operator message...are you sure
;;	movi	opgoforit,a9	    ;george's entry point
;;	movi	null_st,a10		;this will never be seen!
;;	jauc	areusure		;ask em.
;;**************************************
;
;opgoforit
;	.if	printer
;	movk	1,a0
;	calla	pbadguy
;	.endif
;	calla	clr_scrn
;        movi    u_opmess,a2
;        movi    trog_yellow,a3
;        jsrp    top_box			; kick out top box
;	movi	ominst1,a8
;	calla	lm_setup
;	jsrp	printf
;	clr	a8			; do the three rows of letters
;	movi	0ffh,a10
;	callr	opplotline
;	movk	1,a8
;	movi	0ffh,a10
;	callr	opplotline
;	movk	2,a8
;	movi	0ffh,a10
;	callr	opplotline
;	movk	3,a8
;	movi	0ffh,a10
;	callr	opplotline
;	clr	a0
;	move	a0,@bline,w
;	move	a0,@bchar,w
;	clr	a8
;	move	a8,*a13(op_line_line),w	; on the first line
;	callr	omstartline		; initialize all the flags for it
;	clr	a10
;	movk	1,a11
;	callr	boxchar			; box initial one
;	movk	1,a11
;	callr	omplottext
;;
;;	loop for stick and things
;;
;	clr	a0
;	move	a0,*a13(op_sval),w
;	move	a0,*a13(op_stime),w
;doloop
;	sleep	1
;        callr   opgetstick		; check out the player board
;        move    a0,a0
;	jrnz	do1			; br = got something
;	move	a0,*a13(op_sval),w	; clear timer and direction
;	move	a0,*a13(op_stime),w
;	jruc	doloop
;do1
;	move	*a13(op_sval),a1,w	; get last direction
;	andi	7,a1			; mask off repeat bit
;	cmp	a0,a1
;	jrz	do2			; br = yes, still same thing
;	move	a0,*a13(op_sval),w
;	clr	a1
;	move	a1,*a13(op_stime),w	; clear the timer
;	jruc	dodone			; process initial hit
;do2
;	move	*a13(op_sval),a1,w	; snag the repeat bit
;	andi	80h,a1
;	jrnz	do3			; br = in repeat mode
;	move	*a13(op_stime),a0,w	; get timer
;	inc	a0
;	move	a0,*a13(op_stime),w
;	cmpi	15,a0
;	jrlo	doloop			; go back to sleep
;	clr	a0
;	move	a0,*a13(op_stime),w	; clear out the timer
;	move	*a13(op_sval),a1,w
;	move	a1,a0
;	ori	80h,a1			; put upper bit on
;	move	a1,*a13(op_sval),w	; set direction with repeat on
;	jruc	dodone
;do3
;	move	*a13(op_stime),a0,w	; get timer
;	inc	a0
;	move	a0,*a13(op_stime),w
;	cmpi	5,a0
;	jrlo	doloop			; go back to sleep
;	clr	a0
;	move	a0,*a13(op_stime),w	; clear out the timer
;	move	*a13(op_sval),a0,w
;	andi	7h,a0			; turn off repeat bit
;dodone
;        move    *a13(op_sval),a1,w	    ;get current entry...in a1
;	andi	7,a1
;	move	@bline,a8,w
;	move	@bchar,a10,w
;	clr	a11
;	callr	boxchar			; unhighlight it
;
;	cmpi	1,a1			; check up
;	jrnz	doc1
;	dec	a8
;	jruc	doproc
;doc1
;	cmpi	2,a1
;	jrnz	doc2
;	inc	a8
;	jruc	doproc
;doc2
;	cmpi	3,a1
;	jrnz	doc3
;	dec	a10
;	jruc	doproc
;doc3
;	cmpi	4,a1
;	jrnz	doc4
;	inc	a10
;	jruc	doproc
;doc4
;	cmpi	5,a1			; draw button
;	jrnz	docclr			; woof woof
;	callr	omaddchar		; add the char in a8/a10
;	cmpi	0ffh,a8			; check to see if done with all
;	jrz	docend
;	move	@bline,a8,w
;	move	@bchar,a10,w
;	movk	1,a11
;	callr	boxchar			; turn the box back on
;	jruc	doloop
;docclr
;	cmpi	6,a1			; start button
;	jrnz	doloop
;	clr	a7
;	move	a7,*a13(op_line_line),w
;	move	a7,*a13(op_lets),l
;	callr	omstorecmos
;	movk	1,a7
;	move	a7,*a13(op_line_line),w
;	callr	omstorecmos
;	movk	2,a7
;	move	a7,*a13(op_line_line),w
;	callr	omstorecmos
;	callr	blastmess
;	jruc	docclear
;	
;;
;;	check a8 ( bline ) and a10 ( bchar ) for boundary stuff
;;
;doproc
;	move	a8,a8
;	jrnn	doc5
;	clr	a8
;	jruc	doc6
;doc5
;	cmpi	let_line_max,a8
;	jrle	doc6
;	movi	let_line_max,a8
;doc6
;	move	a10,a10
;	jrnn	doc7
;	clr	a10
;	jruc	doc8
;doc7
;	cmpi	let_char_max,a10
;	jrle	doc8
;	movi	let_char_max,a10
;doc8
;	move	a8,@bline,w
;	move	a10,@bchar,w
;	movk	1,a11
;	callr	boxchar
;	jruc	doloop
;
;;
;;	here is where one comes when done entering the message -- already
;;	stored in cmos, too
;;
;
;docend
;	sleep	2			; get everybody caught up
;	calla	clr_scrn				;clear the screen
;	movi	mess_success,a8 			;this is success message
;	jsrp	sur_mess				;print the message	
;	retp
;
;docclear
;	sleep	2
;	calla	clr_scrn
;	movi	mess_cleared,a8
;	jsrp	sur_mess
;	retp
;
;mess_success
;	.string	w_message," stored",0
;	.even
;
;mess_cleared
;	.string	w_message," ",w_clear,"ed",0
;	.even
;
;blastmess:
;	calla	cmosunlock
;        calla   adj_page		; guy entereted a whole message
;	clr	a0
;        movi    valid_custom,a7
;        calla   wc_word
;        calla   f_adc_s			; fix up the checksum
;	calla	cmoslock
;	rets
;
;**************************************************************************
;*									    *
;*	opgetstick							 *
;*									    *
;**************************************************************************
;
;opgetstick
;	mmtm	sp,a1
;	move	@switch,a0,l
;	not	a0
;	move	a0,a2
;	andi	0004001fh,a0		; p1 draw/start/stick
;	move	a2,a1
;	andi	00201f00h,a1		; p2 draw/start/stick
;	srl	8,a1
;	or	a1,a0
;	move	a2,a1
;	andi	0f8000000h,a1		; p3 stick
;	srl	27,a1
;	or	a1,a0
;	andi	06000000h,a2		; start 3/4
;	or	a2,a0
;	move	@switch+32,a1,w
;	not	a1
;	andi	001fh,a1		; p4 draw/stick
;	or	a1,a0
;
;	move	a0,a1
;	andi	01h,a1
;	jrz	og2
;	movk	1,a0
;	jruc	ogret
;og2
;	move	a0,a1
;	andi	02h,a1
;	jrz	og3
;	movk	2,a0
;	jruc	ogret
;og3
;	move	a0,a1
;	andi	04h,a1
;	jrz	og4
;	movk	3,a0
;	jruc	ogret
;og4
;	move	a0,a1
;	andi	08h,a1
;	jrz	og5
;	movk	4,a0
;	jruc	ogret
;og5
;	move	a0,a1
;	andi	10h,a1
;	jrz	og6
;	movk	5,a0
;	jruc	ogret
;og6
;	move	a0,a1
;	andi	0ffffffe0h,a1		; any other bits are start buttons
;	jrz	og7
;	movk	6,a0
;	jruc	ogret
;og7
;	clr	a0
;ogret
;	mmfm	sp,a1
;	rets
;
;**************************************************************************
;*									    *
;*	omstartline							 *
;*									 *
;*	setup things for a new line of text				 *
;*									 *
;*	entry								 *
;*		nothing							 *
;*									 *
;*	exit								 *
;*		nothing							 *
;*									    *
;**************************************************************************
;
;omstartline:
;	push	a0
;	clr	a0
;	move	a0,*a13(op_lets),w
;	move	a0,*a13(op_line_char),w
;	pull	a0
;	rets
;
;**************************************************************************
;*									    *
;*	omplottext							 *
;*									 *
;*	plot out a line of text on the screen				 *
;*									 *
;*	entry								 *
;*		nothing ( well, almost )				 *
;*									 *
;*	exit								 *
;*		nothing							 *
;*									    *
;**************************************************************************
;
;omplottext:
;	mmtm	sp,a8,a10,a11
;	push	a11
;	movi	omtsetup,a8
;	calla	lm_setup
;	move	a13,a8
;	addi	op_lets,a8
;	move	*a13(op_line_line),a9,w
;	sll	5,a9
;	addi	omloc,a9
;	move	*a9,a9,l
;	sll	16,a9
;	mmtm	sp,a3,a4,a9
;	move	a9,a3
;	subi	20000h,a3
;	movi	[let_text_gap+2,394],a4
;	calla	blnkarea
;	mmfm	sp,a3,a4,a9
;	addi	200,a9
;	jsrp	printf
;	pull	a5
;	move	a5,a5			; flag for underscore or not
;	jrz	nounder
;	movi	trog_plf,a5
;	movi	omunderscore,a8
;	addi	5,a9			; shift the little guy over
;	jsrp	printf
;nounder
;	mmfm	sp,a8,a10,a11
;	rets
;
;**************************************************************************
;*									    *
;*	omaddchar							 *
;*									 *
;*	add the character pointed to by a8/a10				 *
;*									 *
;*	entry								 *
;*		a8	line						 *
;*		a10	char on line					 *
;*									 *
;*	exit								 *
;*		nothing							 *
;*									    *
;**************************************************************************
;
;omaddchar:
;	mmtm	sp,a8,a10
;	move	a8,a0
;	sll	16,a0
;	add	a10,a0
;	cmpi	[3,13],a0		; rub
;	jrnz	omac1
;	move	*a13(op_line_char),a1,w
;	jrz	omacret
;	dec	a1
;	move	a1,*a13(op_line_char),w
;	move	a1,a2
;	clr	a0
;	jruc	rubent
;
;omac1
;	cmpi	[3,14],a0		; cr
;	jrnz	omac2
;	clr	a11
;	callr	omplottext		; get rid of the flashing underscore
;	clr	a0
;	move	a0,@bline,w
;	move	a0,@bchar,w
;	callr	omstorecmos		; well, baby -- store it
;	move	*a13(op_line_line),a8,w	; grab the line
;	cmpi	2,a8
;	jrhs	omadone
;	inc	a8
;	move	a8,*a13(op_line_line),w	; on the first line
;	callr	omstartline		; initialize all the flags for it
;	movk	1,a11
;	callr	omplottext
;	jruc	omacret
;;
;;	here is just enter a normal character --
;;
;;	a8 = line
;;	a10 = character
;;
;omac2
;	sll	5,a8
;	addi	oltab,a8		; get table base address
;	move	*a8,a8,l
;	sll	3,a10			
;	add	a10,a8			; char offset
;	movb	*a8,a0			; snag the char
;	move	*a13(op_line_char),a1,w
;	move	a1,a2
;	cmpi	op_max_chars,a1
;	jrhs	omacmax
;	inc	a1
;	move	a1,*a13(op_line_char),w
;rubent
;	cmpi	7eh,a0			; check for the space character
;	jrnz	omnotspace
;	movi	20h,a0
;omnotspace
;	move	a13,a8
;	addi	op_lets,a8
;	sll	3,a2
;	add	a2,a8			; offset into local storage
;	movb	a0,*a8
;	addk	8,a8
;	clr	a0
;	movb	a0,*a8			; make sure zero terminated
;	movk	1,a11
;	callr	omplottext
;omacret	
;	mmfm	sp,a8,a10
;	rets
;
;omadone				; come here when really done
;	calla	cmosunlock
;        calla   adj_page		; guy entereted a whole message
;        movi    valid_custom,a7
;        movi    valid_value,a0
;        calla   wc_word
;        calla   f_adc_s			; fix up the checksum
;	calla	cmoslock
;	mmfm	sp,a8,a10
;	movi	0ffh,a8			; flag done with everything
;	rets
;
;omacmax
;	mmfm	sp,a8,a10		; like totally gross, man...
;	clr	a11
;	callr	boxchar
;	movk	3,a8
;	movk	14,a10
;	move	a8,@bline,w
;	move	a10,@bchar,w
;	rets
;
;
;**************************************************************************
;*									    *
;*	omstorecmos							 *
;*									 *
;*	store the message in cmos					 *
;*									 *
;*	entry								 *
;*		nothing							 *
;*									 *
;*	exit								 *
;*		nothing							 *
;*									    *
;**************************************************************************
;
;omstorecmos:
;	calla	cmosunlock
;	calla	adj_page		; point at adjustments page
;	move	*a13(op_line_line),a7,w
;	movi	cmess_line_size,a6
;	mpyu	a6,a7			; offset me, baby
;	addi	custom_message,a7	; a7 is cmos location
;	move	a13,a6
;	addi	op_lets,a6		; a6 is the process block loc
;	movi	cmess_chars,a5		; chars/line
;
;cmos_loop
;        movb    *a6,a0				    ;fetch a character
;        andi    byte_mask,a0
;        calla   wc_bytei 			    ;write a byte
;        addi    byte_size,a6			    ;point at next byte
;        dsjs    a5,cmos_loop
;
;        calla   f_adc_s				    ;refresh checksum
;	calla	cmoslock
;	rets
;
;omloc	.long	let_text1, let_text2, let_text3
;
;**************************************************************************
;*									    *
;*	boxchar								 *
;*									 *
;*	entry								 *
;*		a8	which line ( 0 - 2 )				 *
;*		a10	character on line				 *
;*		a11	color to use ( 0 = black, 1 = laser flash )	 *
;*									 *
;*	exit								 *
;*		nothing							 *
;*									    *
;**************************************************************************
;
;boxchar:
;	mmtm	sp,a1,a8,a10
;	movi	let_dist_y,a1
;	mpyu	a8,a1				; distance
;	addi	let_start_y1-let_box_cy,a1
;	sll	16,a1
;	move	a1,a4
;	movi	let_dist_x,a1
;	mpyu	a10,a1
;	addi	let_start_x-let_box_cx,a1
;	movx	a1,a4				; upper left in a4
;	move	a4,a5	
;	movi	[let_dist_y+let_box_wy,let_dist_x+let_box_wx],a0
;	addxy	a0,a5				; lower right in a5
;
;	movi	[1,1],a0			; border height,width
;	movi	trog_black,a9			; doborder is retarded
;	move	a11,a11
;	jrz	bc1
;	movi	trog_lf,a9
;bc1
;	callr	doborder
;
;	move	a11,a11
;	jrnz	bc2
;	movi	0ffh,a10
;bc2
;	callr	opplotline
;	mmfm	sp,a1,a8,a10
;	rets
;
;**************************************************************************
;*									    *
;*	opplotline							 *
;*									 *
;*	plot out a line of characters					 *
;*									 *
;*	entry								 *
;*		a8	table number					 *
;*		a10	which character to highlight			 *
;*									 *
;*	exit								 *
;*		nothing							 *
;*									    *
;**************************************************************************
;
;opplotline:
;	mmtm	sp,a8,a9,a10,a11
;	move	a8,a9
;	sll	5,a8
;	addi	oltab,a8
;	move	*a8,a8,l
;	sll	4,a9
;	addi	olytab,a9
;	move	*a9,a9,w
;	
;	sll	16,a9			; get in the y position
;	addi	let_start_x,a9
;oplloop	
;	movb	*a8,a0			; grab char number
;	move	a0,a0	
;	jrz	oplret
;	move	a0,@charout,w
;	push	a8
;	push	a9
;	push	a10
;	push	a9
;	movi	trog_pred,a5		; color
;	move	a10,a10
;	jrnz	opl1
;	movi	trog_plf,a5
;opl1
;	push	a5
;	movi	op_mess,a8
;	calla	lm_setup
;	pull	a5			; color
;	pull	a9			; set the position of the char
;	jsrp	printf
;	pull	a10
;	dec	a10
;	pull	a9
;	pull	a8
;	addk	8,a8
;	addi	let_dist_x,a9
;	jruc	oplloop
;oplret
;	mmfm	sp,a8,a9,a10,a11
;	rets
;
;op_mess:
;	mess_mac rd15font,1,200,95,trog_pred,strlnrm,0
;	.string	"%c",0
;	.long	charout
;	.even
;
;oltab	.long	ol1tab, ol2tab, ol3tab, ol4tab
;olytab	.word	let_start_y1, let_start_y2, let_start_y3, let_start_y4
;
;ol1tab	.byte	41h, 42h, 43h, 44h, 45h, 46h, 47h, 48h, 49h, 31h, 32h, 33h
;	.byte	3fh, 21h, 22h
;	.byte	00
;
;ol2tab	.byte	4ah, 4bh, 4ch, 4dh, 4eh, 4fh, 50h, 51h, 52h, 34h, 35h, 36h
;	.byte	28h, 29h, 2ah
;	.byte	00
;
;ol3tab	.byte	53h, 54h, 55h, 56h, 57h, 58h, 59h, 5ah, 7eh, 37h, 38h, 39h
;	.byte	30h, 3ah, 3bh
;	.byte	00
;
;ol4tab	.byte	23h, 24h, 20h, 26h, 27h
;	.byte	2bh, 2ch, 2dh, 2eh, 2fh
;	.byte	3dh, 82h, 7eh, 7fh, 83h
;	.byte	00
;
;ominst1:
;	mess_mac   rd7font,spacing07,200,let_inst1,trog_pwhite,strcnrm,0
;	.string	"use ",w_player," 1 controls to enter a ",w_message
;	.string	"\nof up to 3 lines of 25 letters."
;	.string	"\n\b",w_select," cr to end each line."
;	.string	"\npress \b",w_player," 1 ",w_start," \bto ",w_clear," out ",w_message,"."
;	.byte	0
;	.word	trog_yellow
;	.word	trog_red
;	.word	trog_yellow
;	.word	trog_red
;	.word	trog_yellow
;	.even
;
;omtsetup
;	mess_mac   rd7font,spacing07,200,let_inst1,trog_pblue,strcnrm,0
;	.even
;
;omunderscore
;	.string	"-",0
;	.even
;
;

**************************************************************************
*											     *
* 	sound system test								     *
*											     *
**************************************************************************

to_sd_bd equ	0
to_y_bd	equ	3		;a5 for sndsnd
test_yam equ	0f2h		;a3 gets code
test_dac equ	0f2h

**************************************************************************
*									    *
*	go_stest							 *
*									 *
*	setup the menu for the sound test				 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

go_stest clr	a0
	move	a0,@scode,w		;no "current" synth yet
	move	a0,@dcode,w		;no "current" dig yet
	movi	men_stest,a8		;put up the menu and go!
	jauc	gen_menu		;this will return to level above us!


**************************************************************************
*									    *
*	shut_up								 *
*									 *
*	tell the sound board to get screwed				 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

shut_up
	clr	a3
	calla	send_code_a3
        	sleep   1
        	retp

inc_if_nec
	move	a3,a3			;if its zero...kick it!
	jrz	inc_it
	move	@last_but,a0,l		;see which button
	cmpi	2,a0
	jrnz	no_inc			;then use same code
inc_it	inc	a3
no_inc	rets


****dctab	.byte	3ch,43h,45h,48h,49h,4ah,4eh,40h,41h
****last_dcode	    equ     ($-dctab)/byte_size
****	    .even


**************************************************************************
*									    *
*	go_digt								 *
*									 *
*	setup a generic sound board test				 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

go_digt	
****	calla	sndresp 		;reset in case crashed!
	clr	a3
;	calla	send_code_a3
        sleep   4		    ;let it go a sec!
        calla   clr_scrn
        movi    m_digt,a2
        movi    trog_green,a3
        jsrp    top_box		    ;print title box.

        calla   sure_box 	    ;put a nice box up!
	
	movi	0fe00h,a0
	move	a0,@sound,w
	movi	8,a14
	dsjs	a14,$			;slow it down a bit
	movi	0ff00h,a0
	move	a0,@sound,w		;pull on the sound interrupt

	movi	8,a14
	dsjs	a14,$			;let line settle

	movb	@talkport+b_sirq-7,a14	;are we connected?
	jrnn	sound_irq_connected	;br = yes sirree

;        movi    sirq_err,a8
;        jsrp    l_mess			;print error

;        jsrp    any_but			;and tell em any button to continue
	
;	callr	blnk_sure_box
	
        movi    sirq_err2,a8
        jsrp    l_mess			;remind the guy of the previous error
	jruc	sound_donger
sound_irq_connected
        movi    sirq_detect,a8
        jsrp    l_mess			;notify that sound irq was checked
sound_donger

	calla	sndres			; reset that puppy

        movi    dac_err,a8
        jsrp    l_mess		    ;print error
        jauc    any_but		    ;and tell em any button to continue

**************************************************************************
*												*
*	  go_synp										*
*												*
*	  this is the "play synthesizer" code. 					*
*												*
*	  get the next code...send it to the yamaha and				*
*	  display the corresponding title.						*
*												*
**************************************************************************

go_synp	
	calla	nosounds

	move	@scode,a3,w		;get the next code
	callr	inc_if_nec
	cmpi	last_scode,a3
	jrls	go_synp1		;in range
	movk	1,a3

go_synp1
	move	a3,@scode,w		;put in memory
	movi	sctab,a0
	dec	a3			;zero doesn't count
	sll	4,a3			;index to WORDS
	add	a3,a0
	move	*a0,a3,w

;	andi	byte_mask,a3

	callr	send_yam
	movk	1,a0
	move	a0,@no_clear
	retp				;thats it!

**************************************************************************
*									    *
*	game utilities selected						 *
*									    *
**************************************************************************

go_util	movi	men_util,a8
	jauc	gen_menu		;process the utility menu!

**************************************************************************
*									    *
*	do_facset							 *
*									 *
*	reset the cmos to factory settings				 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************
do_facset:
	movi	mess_facset,a8
	movk	1,a0

;	jruc	def_adj_part
	jsrp	def_adj_part

	jsrp	new_fac_stuf
	retp

**************************************************************************
*									    *
*	do_def_adj							 *
*									 *
*	just reset the adjustments to the factory settings		 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

do_def_adj:
        movi    mess_def_adj,a8
        clr     a0

;	fall through

**************************************************************************
*											     *
* 	def_adj_part									     *
* 											     *
* 	setup cmos to default adjustments						     *
* 											     *
* 	entry										     *
* 		a0	how much to clear						     *
* 		a8	message to use						     *
* 											     *
* 	exit										     *
* 		nothing									     *
*											     *
**************************************************************************
def_adj_part:
	move    a0,@fac_flag,w	    ;indicate this is adjustments only

	move    a8,-*a12,l	    ;push the message
	move    *a12+,a8,l	    ;restore message

	movi    defadjsoft,a9
	movi    null_st,a10	    ;don't print anything....routine will.
	jsrp    areusure

	retp

*
* return a0=0 for failure
*
do_cancel
        clr     a0
        retp

defadjsoft
*
*	now smash the checksum
*
	.if	printer
	move	@fac_flag,a0,w
	addi	6,a0
	calla	pbadguy
	.endif
	calla	cmosunlock
        calla   form_adc 		 ;form the cksum
        move    a1,a0			 ;put in cmos writing reggie
        movi    adj_cksum,a7
        inc     a0			 ;this smashes adjustments
        calla   wc_word			 ;and store it
        calla	cmoslock
*
* now make sure its smashed
*
        calla   cmos_val
        jrz     ad_fail			;we can't do it.....print failure.
*
* now set the adjustments to the factory value.
*
        calla   fac_set		   ;this does the deed!
        calla   cmos_val 	   ;is it ok now?
        jrnz    ad_fail		   ;nope...print failure

        movi    defresmess,a8
        move    @fac_flag,a0,w	   ;do we need to clear the tables?
        jrz     dax		   ;nope...post single message
        movi    mess_defconf,a8	   ;this is single message

        calla   clr_scrn        ;clear the screen for our messages.

;;********************
;	jsrp	new_fac_stuf
;;        callr   fac_stuf        ;do audits and high score table
;;********************

        movi    mess_ffsconf,a8 ;print the rest of the messages
        jsrp    l_mess	       ;that does it!
notabs	retp

ad_fail	movi	mess_facfail,a8
	jruc	dax

def_can	movi	mess_cancelled,a8

dax	calla	clr_scrn
	jsrp	sur_mess
	retp

defresmess
	.string	w_adjustments," RESTORED",0
	.even

**************************************************************************
*											     *
* 	on a full factory setting (either requested or			     *
* 	adjustment failure) this clears the audits and			     *
* 	high score table.								     *
*											     *
**************************************************************************
;fac_stuf 
new_fac_stuf 
	calla   clr_aud 			; clear audits too
	callr   invalid_custom
	calla   clr_scrn			; clear screen
	retp

**************************************************************************
*											     *
* 	invalid_custom									     *
* 											     *
* 	this kills the custom message so that the factory message	     *
* 	will be used.  note that this checksums the adjustments,	     *
* 	so be careful with it!								     *
* 											     *
* 	entry	nothing									     *
* 	exit	nothing									     *
*											     *
**************************************************************************
invalid_custom:
        mmtm    sp,a0,a7
        calla   adj_page 	    ;point at adjustment page
        clr     a0
        movi    valid_custom,a7
        calla   wc_word
        calla   f_adc_s		    ;fixup checksum for our deed!
        mmfm	sp,a0,a7
        rets

**************************************************************************
*									    			*
*	octopus audits page						 			*
*									    			*
**************************************************************************
octo_print_auds:
	calla	clr_scrn
	movi	mes_octo,a2
	jsrp	top_box
	movi	octo_auds,a0
	jsrp	prnt_aud
	retp

**************************************************************************
*												*
*	 coin bookkeeping selected								*
*												*
**************************************************************************

go_book	calla	clr_scrn
	movi	mes_book,a2
	movi	trog_white,a3
	jsrp	top_box 		;print title box.

	movi	coin_auds,a0		;put table up.
	jsrp	prnt_aud

	movi	men_detail,a8
	movi	1,a9			;cursor on 1st entry
	jsrp	b_menu			;see if they want page 2.

	cmpi	1,a8			;did we get 1'st entry?
	jrnz	no_detail		;nope...return to our caller
detail_screen
	calla	clr_scrn		;clear out for action!
	movi	mes_totals,a2
	movi	trog_white,a3
	jsrp	top_box 		;print title box.

	movk	1,a0
	move	a0,@ptsize,w		; this box is in 15 pt

        movi    coin_d1,a2	    ;detailed audit 1
	movi	adjcdiv,a0
	calla	get_adj
	jrnz	dsgo
	movi	coin_sd1,a2
dsgo
	move	a2,a0
        jsrp    prnt_aud 	    ;print it
	clr	a0
	move	a0,@ptsize,w

	movi	men_clr_sub,a8		;clear subtotal or return to main menu
	movi	2,a9			;cursor on 2nd entry
	jsrp	b_menu			

	cmpi	1,a8			;choice 1 is clear.....
	jrnz	no_clear_sub		;nope...return to caller!

	movi	mess_clear_subs,a8	;clear coin sub-totals...are you sure
	movi	clr_coins,a9		 ;routine to do it
	movi	mess_subs_clear,a10	;confirmation.
	jsrp	areusure		;ask em.
	jruc	detail_screen		;now put this screen back up.

no_clear_sub
no_detail
	retp

**************************************************************************
*												*
*	  game audits selected									*
*												*
**************************************************************************

**************************************************************************
*												*
*	  audits to be shown on game audits page:					*
*												*
**************************************************************************
octo_aud
	calla	clr_scrn
	movi	mes_aud,a2
	movi	trog_blue,a3
	jsrp	top_box 		;print title box.
	movi	octo_auds,a0		;put table up.
	jruc	octo_entry


go_aud	calla	clr_scrn
	movi	mes_aud,a2
	movi	trog_blue,a3
	jsrp	top_box 		;print title box.
	movi	game_aud1,a0		;put table up.

octo_entry
	jsrp	prnt_aud

	movi	men_ap1,a8		;audit page 1 menu
	movi	1,a9			;cursor on 1st entry
	jsrp	b_menu			;see if they want page 2.

	cmpi	1,a8			;did we get 1'st entry?
	jrnz	no_ap2			;nope...return to our caller

ga2
	calla	clr_scrn
	movi	mes_aud,a2
	movi	trog_blue,a3
	jsrp	top_box 		;print title box.

	movi	game_aud2,a0		;put table up.
	jsrp	prnt_aud

	movi	men_ap2,a8
	movi	1,a9			;cursor on 2nd entry
	jsrp	b_menu			;see if they want page 2.
		
	cmpi	1,a8
	jrz	ga3
	cmpi	2,a8
	jrz	go_aud
	jruc	no_ap2

ga3
	calla	clr_scrn
	movi	mes_aud,a2
	movi	trog_blue,a3
	jsrp	top_box 		;print title box.

	movi	game_aud3,a0		;put table up.
	jsrp	prnt_aud

	movi	men_ap2,a8
	movi	1,a9			;cursor on 2nd entry
	jsrp	b_menu			;see if they want page 2.
		
	cmpi	1,a8
	jrz	ga4
	cmpi	2,a8
	jrz	ga2

;	jruc	no_ap2

ga4

;	calla	clr_scrn
;	movi	mes_aud,a2
;	movi	trog_blue,a3
;	jsrp	top_box 		;print title box.
;	movi	game_aud4,a0		;put table up.
;	jsrp	prnt_aud
;	movi	men_ap3,a8
;	movi	2,a9			;cursor on 2nd entry
;	jsrp	b_menu			;see if they want page 2.
;	cmpi	1,a8
;	jrz	ga3

no_ap2	retp



**************************************************************************
*												*
*	  prnt_aud										*
*												*
*	  this is called to print out an audit table.				*
*												*
**************************************************************************

at_ptr	equ	pdata			;long
at_y	equ	pdata+long_size 	;word
at_dy	equ	at_y+word_size		;word
at_lx	equ	at_dy+word_size 	;word   left margin x
at_rx	equ	at_lx+word_size 	;word   right margin x
at_obj	equ	at_rx+word_size 	;long   object pointer for collection rout
at_mess	equ	at_obj+long_size	;long   print_money message stash

prnt_aud
	move	*a0+,a1,w		;get starting height
	move	a1,*a13(at_y),w 	;store

	move	*a0+,a1,w		;get dy to use
	move	a1,*a13(at_dy),w	;stash it away

	movi	40,a14
	move	@ptsize,a1,w
	jrz	pago_pt
	movi	15,a14
pago_pt
	move	*a0+,a1,w		;get left margin
	add	a14,a1
	move	a1,*a13(at_lx),w	;store
	move	*a0+,a1,w		;get right margin
	sub	a14,a1
	move	a1,*a13(at_rx),w	;stash it away
	move	a0,*a13(at_ptr),l	 ;save pointer into area

pa1	
	move	@lastcolor,a14,l
	cmpi	trog_pyellow,a14
	jrz	pacolflip1
	movi	trog_pyellow,a14
	jruc	pacolflip2
pacolflip1
	movi	trog_ppurple,a14
pacolflip2
	move	a14,@lastcolor,l

	jsrp	do_an_audit		 ;print out the current audit

	move	*a13(at_ptr),a0,l	 ;get pointer
	addi	aud_t_size,a0
	move	a0,*a13(at_ptr),l	 ;put back

	callr	add_audit_dy



	move	*a0,a1,l		 ;are we done?
	jrnz	pa1

	retp

**************************************************************************
*												*
*	  add_audit_dy										*
*												*
*	  this is called to move the audit y (store in				*
*	  process area) to the next audit by adding the				*
*	  current dy (also stored in process area). 				*
*												*
**************************************************************************
add_audit_dy
	mmtm	sp,a1,a2
	move	*a13(at_y),a1,w
	move	*a13(at_dy),a2,w	 ;get delta y
	add	a2,a1			 ;move the y down
	move	a1,*a13(at_y),w
	mmfm	sp,a1,a2
	rets

begin_audit
	mmtm	sp,a0
	clr	a0
	move	a0,@bad_aud,w		    ;monitor corruption.
	mmfm	sp,a0
	rets

do_an_audit
	callr	begin_audit
	move	*a13(at_ptr),a3,l	    ;get pointer
	move	*a3(aud_routine),a4,l    ;routine to call?
	jrz	do_by_number		    ;nope....do it by number

	movi	daa_ret,a7
	move	a7,-*a12,l	;push ret addr
	jump	a4		;"call" the routine

do_by_number
	move	*a3(aud_number),a0,w    ;fetch the audit number
	calla	get_aud 		   ;turn into audit count!
	move	a1,a3			   ;protect for a second.


	jsrp	number_work		   ;get the number in a3 up there!

daa_ret	
	movi	mess_aud_line,a8
	move	@ptsize,a14,w
	jrz	daa_go
	movi	mess15_aud_line,a8
daa_go
	calla	lm_setup	;setup for audit printing.
	move	@lastcolor,a5,l

	move	*a13(at_ptr),a3,l   ;get audit pointer
	move	*a3(aud_mess),a8,l  ;get text pointer

	jsrp	left_finish
	retp			    ;that's all we do!

*
*	left_finish   and    right_finish
*
*	these are called to put audit info
*	on the left or right side once a8 points at
*	the correct data to print
*
left_finish
	callr	turn_red_if_nec
	callr	set_for_y	;set for audit's y
	callr	set_left_x	;set for left x
	jsrp	lm_xfinis		;and type up the message!
	retp

right_finish
	callr	turn_red_if_nec 	   ;change color if corrupted.
	callr	set_for_y		   ;set for audit's y
	callr	set_right_x
	jsrp	lm_xfinis		   ;finish the job!

	move	@bad_aud,a0,w		  ;is it corrupted?
	jrz	rfx			  ;nope....return

	movi	mess_error,a8
	calla	lm_setup		  ;setup "error"

	callr	set_for_y		  ;set for audit's y
****	addi	40000h,a9		  ;push 4 y units to center
	callr	set_right_x
	jsrp	lm_xfinis		   ;finish the job!

rfx	retp

turn_red_if_nec
	mmtm	sp,a3
	move	@bad_aud,a3,w	;change to red?
	jrz	daa_1		;nope...its ok!

	movi	trog_pred,a5    ;change color to red
			
daa_1	mmfm	sp,a3
	rets
			
set_for_y
	mmtm	sp,a3
	move	*a13(at_y),a3,w   ;get y coordinate
	sll	16,a3		  ;put it in position
	movy	a3,a9		  ;put it in place
	mmfm	sp,a3
	rets

set_left_x
	mmtm	sp,a3
	move	*a13(at_lx),a3,w
	movx	a3,a9		  ;put the x in place
	mmfm	sp,a3
	rets

set_right_x
	mmtm	sp,a3
	move	*a13(at_rx),a3,w
	movx	a3,a9		  ;put the x in place
	mmfm	sp,a3
	rets

**************************************************************************
*												*
*	  number_work										*
*												*
*	  a3 has the number to display.....do it!					*
*												*
**************************************************************************
number_work
	movi	mess_aud_num,a8 	   ;setup for audit number
	move	@ptsize,a14,w
	jrz	numgo
	movi	mess15_aud_num,a8
numgo
	calla	lm_setup
	move	@lastcolor,a5,l
	move	a3,a8			   ;now we have binary number
	calla	hextoasc		   ;now we point to the string.

	jsrp	right_finish

	retp

;starts	 callr	 get_starts
;	 move	 a2,a3		 ;get in printout reg.
;	 jauc	 number_work	 ;and print it

doplays	callr	get_plays
	move	a2,a3		;put in place
	jauc	number_work


**************************************************************************
*											     *
* 	get_plays									     *
* 											     *
* 	return the total plays ( starts + continues )			     *
* 											     *
* 	entry	nothing									     *
* 	exit	a2	total plays							     *
*											     *
**************************************************************************
get_plays:
	mmtm    sp,a0

	movi	aud_start,a0
	calla	get_aud
	move	a1,a2

	movi	aud_continue1,a0
	calla	get_aud
	add	a1,a2				; add in 1 player continues
	movi	aud_continue2,a0
	calla	get_aud
	add	a1,a2				; and 2 player continues also
	mmfm    sp,a0
	rets



dotottime
	clr	a3
	jauc	number_work


**************************************************************************
*											     *
* dohsleft										     *
* 	movi	adjhsres,a0								     *
* 	calla	get_adj 	;is if off?					     *
* 	jrz	dohsoff 	;yep...print it				     *
* 											     *
* ;	calla	get_hsc 	;get the counter value			     *
* 	move	a0,a3									     *
* 	jauc	number_work	;and show it!					     *
*											     *
**************************************************************************

dohsoff	movi	mess_aud_num,a8
	calla	lm_setup	;setup for audit printing.
	move	@lastcolor,a5,l

	movi	m_hsoff,a8     ;this effectively erases line!
	jauc	right_finish

**************************************************************************
*											     *
* 	get_conts									     *
* 											     *
* 	return total game continues in a2						     *
* 											     *
* 	entry	nothing									     *
* 	exit	a2	total game continues					     *
*											     *
**************************************************************************
get_conts:
        mmtm    sp,a0,a1

        movi    aud_continue1,a0
        calla   get_aud
        move    a1,a2

        movi    aud_continue2,a0
        calla   get_aud
        add     a1,a2			; add in both continues

        mmfm    sp,a0,a1
        rets

do_ptime
	movi	aud_ptime,a0
	jruc	timego


;****************************
;do_avgtc
;	clr	a3
;****************
;	movi	audnumtc,a0
;	calla	get_aud		; get the divisor
;	clr	a1
;****************
;	move	a1,a2
;	jrz	dtcgo		; no /0's here, bud
;
;****************
;	movi	audavgtc,a0
;	calla	get_aud		; get total time
;	clr	a1
;****************
;	clr	a0
;	divu	a2,a0		; a0 contains the real number
;	move	a0,a3		; number to display
;dtcgo
;	jruc	plottime
;******************************************


;do_uptime
;	movi	auduptime,a0
;	jruc	timego


do_on_time
	movi	aud_ontime,a0
	jruc	timego

do_p1time
	movi	aud_1time,a0
	jruc	timego

do_p2time
	movi	aud_2time,a0
	jruc	timego
	
timego
	calla	get_aud
	move	a1,a3
	jruc	plottime

**************************************************************************
*									    *
*	plottime								 *
*									 *
*	plot out the time specified in a3				 *
*									 *
*	entry								 *
*		a3	time ( in seconds )				 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

plottime:
	movi	mess_aud_num,a8
	calla	lm_setup
	move	@lastcolor,a5,l

	mmtm	sp,a0,a1,a2,a7,a9,a10,a11
	clr	a9			; no seconds
	clr	a10			; no minutes
	clr	a11			; no hours
	movi	stringf_ram,a7		; string to build in
	move	a3,a1			; base value
	jrz	pnotime

	clr	a0			; dividend in <a0><a1>
	movi	60,a2			; 60 secs/minute
	divu	a2,a0			; a0 = minutes, a1 = seconds
	move	a1,a9			; set seconds
	move	a0,a1			; minutes/hours
	jrz	pnotime
	clr	a0
	divu	a2,a0			; a0 = hours, a1 = minutes
	move	a1,a10
	move	a0,a11

pnotime
	move	a11,a0
	jrz	pnohours
	calla	cat_a0			; hours
	movi	me_colon,a8
	calla	strcat
pnohours
	move	a10,a0
	cmpi	10,a0
	jrhs	p1
	move	a11,a11			; no leading zero if no hours
	jrz	p1
	clr	a0
	calla	cat_a0			; insert extra zero
	move	a10,a0
p1
	calla	cat_a0			; minutes
	movi	me_colon,a8
	calla	strcat
	move	a9,a0
	cmpi	10,a0
	jrhs	p2
	clr	a0
	calla	cat_a0			; insert extra zero
	move	a9,a0
p2
	calla	cat_a0			; seconds
	mmfm	sp,a0,a1,a2,a7,a9,a10,a11
	movi	stringf_ram,a8
	jsrp	right_finish
	retp

me_colon:
	.string	":",0
	.even

**************************************************************************
*								         *
* do_money - routine to output money totals for a given standard coinage *
* 		if the coinage is custom, it just totals coins		 *
* 		received in coin slots.  used on the detailed		 *
* 		bookkeeping page.					 *
*								         *
**************************************************************************
do_money:
	movi	trog_pwhite,a8
	move	a8,@lastcolor,l			; a gross kludge
	move	*a13(at_y),a8,w
	addi	10h,a8
	move	a8,*a13(at_y),w
	movi	mess_aud_num,a8
	move	@ptsize,a14,w
	jrz	do_m_go
	movi	mess15_aud_num,a8
do_m_go
	calla	lm_setup
	move	@lastcolor,a5,l
	mmtm	sp,a0,a1,a2,a3,a4,a5,a7,a10,a11

	callr	begin_audit		;keep track of sanity of calc.
	movi	audlcoin,a8		;now print money for the chutes

	callr	sum_coins

	movk	1,a0			;divide coins by 1 if its been tampered with
	callr	sixp
	jrz	div_by_1		;tampered with...divide by 1 for "coins"

	movi	adjcdiv,a0		;get the coin parts please
	calla	get_adj
div_by_1
	move	a2,a11                ;setup <a10><a11> as dividend
	clr	a10
	divu	a0,a10		      ; dollars in a10, change in a11
	movi	100,a5
	divu	a0,a5
	mpyu	a5,a11

	movi	stringf_ram,a7		; string to build in
	callr	sixp			;have the 6 been tampered 
	jrz	no_prefix
	calla	get_cspt
	move	*a6(cs_lmes),a8,l
	calla	strcat
no_prefix

	move	a0,a2			;keep divisor for check
	move	a10,a0
	calla	cat_a0			;stuff in the whole grain value
	cmpi	1,a2			;we're we dealing fractions?
	jreq	no_fraction		;br = no
	movi	periodsign,a8
	calla	strcat
	cmpi	10,a11
	jrhs	dm2
	clr	a0
	calla	cat_a0
dm2
	move	a11,a0
	calla	cat_a0
no_fraction
	callr	sixp			;have the 6 been tampered 
	jrz	no_suffix
	move	*a6(cs_rmes),a8,l
	calla	strcat
no_suffix

	mmfm	sp,a0,a1,a2,a3,a4,a5,a7,a10,a11
	movi	stringf_ram,a8
	jsrp	right_finish
	retp

**************************************************************************
*                                                                        *
*          sum_coins                                                     *
*                                                                        *
*          a8 has first of the "chutes" audit numbers of interest        *
*                                                                        *
*          return coins times their factors in a2.                       *
*                                                                        *
**************************************************************************
sum_coins            
	mmtm	sp,a0,a1,a3,a6,a4

	move	a8,a0			;point at audit number
	clr	a2			;sum = zero

	calla	get_cspt		;a6 points at cselect table
	addi	cs_lval,a6		;point at 1st multiplier

	movi	chutes,a4		;now...iterate over the chutes

next_chute
	move	*a6+,a3,w		;get multplier for this chute
	callr	fix_a3			;replace a3 with 1 (multiplier) if 
*					;its some custom mode.
	callr	add_aud_a0_times_a3_to_a2 
	inc	a0			;next audit
	dsjs	a4,next_chute

	mmfm	sp,a0,a1,a3,a6,a4
	rets

add_aud_a0_times_a3_to_a2
	calla	get_aud			;fetch the audit
	mpyu	a1,a3			;time the factor
	add	a3,a2
	rets

**************************************************************************
*                                                                        *
*          fix_a3                                                        *
*                                                                        *
*          this is called by the low level money totalizer.              *
*          the multiplier for the coin slot that its working             *
*          on is in a3.  we replace it with "1" to sum "total coins"     *
*          if its in a non-standard coin mode.                           *
*                                                                        *
**************************************************************************
fix_a3
	callr	sixp			;has it been tampered with?
	jrnz	fix_a3x			;nope...leave a3
	movk	1,a3
fix_a3x
	rets

**************************************************************************
*                                                                        *
*          sixp                                                          *
*                                                                        *
*          this is called to see if the 1st 6 coin parameters have       *
*          been tampered with.                                           *
*                                                                        *
*          .eq.            yes                                           *
*          .ne.            no                                            *
*                                                                        *
**************************************************************************
sixp
	mmtm	sp,a0
	movi	adj1st6,a0
	calla	get_adj              ;has it been tampered with?
	mmfm	sp,a0
	rets

;

dollarsign:
	.string	"$ ",0
	.even
periodsign:
	.string	".",0
	.even


**************************************************************************
*									    			*
*	utility routines for utilities menu				 		*
*									    			*
**************************************************************************

do_clcred
	movi	mess_clcred,a8		;clear coin sub-totals...are you sure
	movi	clr_credits,a9		;routine to do it
	movi	mess_ccconf,a10 	;confirmation.
	jauc	areusure		;ask em......then return!

clr_credits
	.if	printer
	movk	2,a0
	calla	pbadguy
	.endif
	calla	no_creds		;call the routine that does it
	retp

do_clcoin
	movi	mess_clcoin,a8		;clear coin sub-totals...are you sure
	movi	clr_coins,a9	   ;routine to do it
	movi	mess_ccnconf,a10	 ;confirmation.
	jauc	areusure		;ask em......then return!

clr_coins
	.if	printer
	clr	a0
	calla	pbadguy
	.endif
	movi	frst_c,a0
	movi	last_c,a1
	calla	clr_audr
	retp

do_claud
	movi	mess_claud,a8	    ;clear coin sub-totals...are you sure
	movi	clr_audits,a9	    ;routine to do it
	movi	mess_caudconf,a10	  ;confirmation.
	jauc	areusure		;ask em......then return!

clr_audits
	.if	printer
	movk	4,a0
	calla	pbadguy
	.endif
	movi	frstgaud,a0
	movi	lastgaud,a1
	calla	clr_audr
;	 calla	 dump_fs		 ;and start the "dump" records over
	retp

do_hsres
	movi	mess_hsreset,a8
	movi	hssoft,a9
	movi	mess_hsrconf,a10
	jauc	areusure

hssoft	
	.if	printer
	movk	5,a0
	calla	pbadguy
	.endif
	callr	res_all
	retp				;program to do the job!

**************************************************************************
*											     *
* 	res_all										     *
* 											     *
* 	reset the all time highscore table and the reset counter	     *
*											     *
**************************************************************************
res_all:

;       	movi    all_tab,a8	    ;always clear out todays table
;       	calla   init_tb
;       	movi    tod_tab,a8	    ;always clear out todays table
;       	calla   init_tb
;       	calla   init_hsr 	    ;re-set the high score reset counter

	calla	fs_inits
	rets

**************************************************************************
*												*
*	  monitor patterns									*
*												*
**************************************************************************

	.if	printer
	.else

go_patterns
	movi	men_patterns,a8 	;put up the menu and go!
	jauc	gen_menu		;this will return to level above us!

* a1 = <color><palette>
* a3 = dag of area [ypos,xpos]						
* a4 = [y,x] size of area						

go_red	movi	trog_red,a1
	jauc	sc_col

go_green movi	trog_green,a1
	jauc	sc_col

go_blue	movi	trog_blue,a1
sc_col	sll	16,a1			;palette 0....color up high
	clr	a3			;upper left
	movi	00ff0190h,a4
	calla	fillarea		;this does the screen
	jauc	wait_but		;now wait for any button!
	.endif

**************************************************************************
*									    *
*	wait for a button menu						 *
*									    *
**************************************************************************

any_but
	movi	any_menu,a8		;any button to continue
	movi	1,a9			;cursor on entry 1
	jauc	b_menu			;do it....return when pressed.

**************************************************************************
*												*
*	  wait_but										*
*												*
*	  this is called on return from many of the "hard"			*
*	  diagnostic tests to hold control till any button is 		*
*	  hit.											*
*												*
**************************************************************************

wait_but
	move	@switch,a0,l		; hangout for a while
	andi	button_bits,a0
	move	a0,@swset1,l
	move	@switch+32,a0,l
;	andi	10h,a0
	andi	button_bits2,a0
	move	a0,@swset2,l
wb1
	callr	cktest			; check test switches
	move	@switch,a0,l		; gotta see if time to leave
	andi	button_bits,a0
	move	@swset1,a1,l
	cmp	a0,a1
	jrnz	wbend
	move	@switch+32,a0,l
	move	@swset2,a1,l
;	andi	10h,a0
	andi	button_bits2,a0
	cmp	a0,a1
	jrnz	wbend
	sleep	1
	jruc	wb1
wbend
	retp

**************************************************************************
*											     *
* 	cktest										     *
* 											     *
* 	check to see if either of the test buttons is closed,		     *
* 	if not, head out to warmset							     *
* 											     *
* 	entry	nothing									     *
* 	exit	nothing									     *
*											     *
**************************************************************************
cktest
	push	a0

	move	@gstate,a0,w
	cmpi	gs_octopus,a0
	jreq	ckret			; octopus mode = skip check

	calla	read_dip
	andi	dip_diag,a0
	jrnz	ckret			; dipswitch = ok

;	move	@switch,a0,l
;	not	a0
;	btst	b_diag,a0
;	jaz	warmset			; we be outta here!

ckret	pull	a0
	rets

**************************************************************************
*											     *
*  ckdiag - check to see if we need to go off to the diagnostics routine *
* 											     *
*    Carry set = yes diag								     *
*  Carry clear = no diag									     *
*											     *
**************************************************************************
ckdiag
	clr	a0
	calla	read_dip

	andi	dip_diag,a0
	jrnz	yes_diag
	move	@switch,a0,l
	not	a0
	btst	b_diag,a0
	jreq	no_diag

yes_diag	
	setc
	rets

no_diag	clrc
	rets
	
**************************************************************************
*												*
*	  force_main										*
*												*
*	  this is called to get to main menu from level further		*
*	  than 1 down.	it sets the global flag "main_ret"			*
*	  non zero.  gen_menu will keep returning until				*
*	  it gets back to the main menu.							*
*												*
**************************************************************************

force_main
	movk	1,a0			;positive number forces main menu.
	move	a0,@main_ret,w
	retp				;now "return to the menu"


**************************************************************************
*												*
*	  gen_menu										*
*												*
*	  this is a general menu handler.  it posts the menu			*
*	  with selection 1 available.  after a selection is			*
*	  made, if it has a routine code of zero, (exit) 			*
*	  it returns to the level above it.  else, it				*
*	  jsrp's the new routine.  when the new routine                 *
*	  returns, we re-post the same menu with the				*
*	  bar on the following entry.							*
*												*
*	  a8 = menu descriptor									*
*												*
**************************************************************************
*
*	menu rom offsets
*	
mr_font	equ	0
mr_tcal	equ	mr_font+long_size
mr_title equ	mr_tcal+long_size	;pointer to title for tile box (if nec)
mr_tclr	equ	mr_title+long_size	;color of title
mr_words equ	mr_tclr+word_size	;stream of words to copy to pdata starts here
mr_x	equ	mr_words
mr_y	equ	mr_x+word_size
mr_dy	equ	mr_y+word_size
mr_col	equ	mr_dy+word_size
mr_hite	equ	mr_col+word_size
mr_bdy	equ	mr_hite+word_size
mr_dx	equ	mr_bdy+word_size
mr_wid	equ	mr_dx+word_size

gen_menu
	callr	cktest			; round about 100 on plotbug
	move	@gmenulev,a0,w			;kick level pointer
	inc	a0
	move	a0,@gmenulev,w
*
	move	a8,-*a12,l			;save menu ptr
	movi	1,a8				;start with "first" entry
	move	a8,-*a12,w			;put menu number as a word
*
*	if we get here and main_ret is not zero, the we must
*	return to level above us if we're not the main
*	menu.
*

gen_loop move	@main_ret,a0,w			;are we in "exit" mode?
	jrz	no_exit 			;no

	jrn	dive_to_monitor 		;we're diving to monitor patterns.

	move	@gmenulev,a0,w			;check level
	cmpi	1,a0				;are we at level 1
	jrnz	gen_exit			;nope.....pop up a level.
*
*	we're at level 1....clear out the flag that
*	got us here.
*
dive_complete
	clr	a0
	move	a0,@main_ret,w			;now we may proceed!

no_exit	move	@no_clear,a0,w			;inhibit clear?
	jrnz	skip_clr

	calla	clr_scrn			;clear the screen

skip_clr clr	a0
	move	a0,@no_clear,w			;and re-set it!

	move	*a12(word_size),a8,l 	;get menu descriptor
	jsrp	menu_top
	jsrp	cyan_box			;put up main menu instructions

	move	*a12,a9,w			;get menu number to use
	jsrp	b_menu				;get result

phoney_menu_ret
	move	a10,a10 			;was it advance?
	jrz	no_kick 			;nope....leave where he came from

	inc	a8				;kick index by 1 for next time
no_kick	move	a8,*a12,w			;and leave on the stack

	move	a9,a9				;now jsrp the routine
	jrz	gen_exit			;none there....its "exit"
*
*	jsrp to a9
*
        movi    gen_loop,a7
	move	a7,-*a12,l	;push ret addr
	jump	a9

gen_exit addi	word_size+long_size,a12	;pop the arguments
	move	@gmenulev,a0,w			;kick level pointer
	dec	a0
	move	a0,@gmenulev,w
	retp

**************************************************************************
*												*
*	  dive_to_monitor									*
*												*
*	  we get control here when we are kludging the return 		*
*	  from "cpu" test (which blows away ram!)					*
*												*
**************************************************************************
dive_to_monitor
	move	@gmenulev,a0,w			;check level
	cmpi	1,a0				;are we at level 1
	jrnz	dtm1				;nope....set "monitor" level
*
*	we're at level 1......."select" the diagnostic menu
*	a8 = 1.....a9 = routine for diagnostic menu
*
	movk	1,a8
	.if	printer
	.else
	movi	go_diag,a9		;routine for diagnostic menu
	.endif
	movk	1,a10			;return as if advance was pressed
	jruc	phoney_menu_ret 	;we're ready to call diag menu
*
*	we're in diagnostic menu....now we just need to make
*	the "current" selection the one after cpu test
*	(monitor patterns)
*
dtm1	move	@main_ret,a8,w			;flag is opposite of entry number
	neg	a8				;this is return level!
	.if	printer
	.else
	movi	rtr_lev,a8			;start with "return" entry number
	.endif
	move	a8,*a12,w			;put menu number as a word
	jruc	dive_complete			;this completes the dive!

*
*	  for doborder
*
*	  a4 = upper left y,x									
*	  a5 = lower right y,x								
*	  a0 = y,x width of border							
*	  a9 = color of border. 								

**************************************************************************
*												*
*	  top_box										*
*												*
*	  this displays the test box at the top.					*
*												*
*	  a2 points at the string to center in the box.				*
*	  a3 is color to do it in.								*
*												*
**************************************************************************
menu_top move	*a8(mr_title),a2,l		;get title into a2
	move	*a8(mr_tclr),a3,w		;and color into a3

top_box
	move	a8,-*a12,l			;push menu ptr
*
*	first make the box...it blacks out the region
*
	callr	scr_box 				;put up the title box

	movi	mess_title,a8	 ;set parameters
	calla	lm_setup	 ;put it out.

	move	a2,a8		 ;get string in the correct reggie
	move	a3,a6		 ;move color to color reggie
;	move	a3,a5		; fixing this would break everything!
*
	jsrp	lm_xfinis	  ;and print it!

	jsrp	scr_rev 	 ;now add the rev.

	move	*a12+,a8,l	 ;restore the menu ptr

	retp

**************************************************************************
*												*
*	  scr_rev										*
*												*
*	  display rev in title box.								*
*												*
**************************************************************************
scr_rev
	movi	mess_rev,a8	;get ready for rev message
	calla	lm_setup	;setup for rev message

	movi	rom_name,a8	;use rom copy of rev.
	jsrp	lm_xfinis	 ;finish printing message
	retp

**************************************************************************
*												*
*	  scr_box										*
*												*
*	  this displays the title box.							*
*												*
**************************************************************************
scr_box
	movi	tit_ulx+(10000h*tit_uly),a4	;upper left
	movi	tit_lrx+(10000h*tit_lry),a5	;upper left
	movi	trog_yellow,a9
	callr	std_bord       ;taco bell has your order, make a ru-uuun......
	rets

**************************************************************************
*												*
*	  rev_to_pdata										*
*												*
*	  this copies the current rev. data to the					*
*	  calling (controlling) processes' pdata area.                  *
*												*
**************************************************************************
*												*
* rev_to_pdata											*
*	  mmtm	  sp,a2,a7,a6,a0								*
*	  calla   adj_page									*
*	  movi	  name_rev,a7		  ;point at cmos name storage 	*
*	  move	  a13,a6		  ;point with a6				*
*	  addi	  pdata,a6									*
*	  movi	  name_rev_size,a2	  ;maximum name size			*
*												*
* rev_xfer_loop											*
*	  calla   rc_bytei		  ;fetch a byte				*
*	  movb	  a0,*a6		  ;put in process area			*
*	  addi	  byte_size,a6		  ;push this pointer			*
*	  dsjs	  a2,rev_xfer_loop								*
*												*
*	  clr	  a0			  ;store a zero beyond in case its *
*	  move	  a0,*a6,w		  ;2 bytes doesn't hurt            *
*	mmfm	sp,a2,a7,a6,a0									*
*	rets											*
*												*
**************************************************************************
*
*	this prints the "move joystick" box.
*
*	a8 = menu descriptor that will accompany it
*	on screen.  we adjust the box edges and
*	message center in "x" only to correspond
*	to the menu box.
*
cyan_box
	move	a8,-*a12,l				  ;push the menu ptr

	movi	trog_red,a9
	callr	col_inst		;this prints box and stashes
*					;center x at *a13(pdata),w

	movi	mm_inst1,a8	;point at instructions message
	jsrp	c_pd_m

	movi	mm_inst2,a8	;point at instructions message
	jsrp	c_pd_m

	move	*a12+,a8,l	;get back menu ptr.
	retp

**************************************************************************
*												*
*	  col_inst										*
*												*
*	  this prints out the "cyan" instruction box				*
*	  in the color specified by a9.							*
*												*
**************************************************************************
col_inst
*
*	we need to determine left and right x
*
	callr	stuff_menu_process			  ;move data into pdata area
	callr	men_nums				  ;get the numbers for this menu
	move	a6,*a13(pdata),w			  ;stash the x center
	addi	10000h*inst_uly,a4			  ;upper left y
	addi	10000h*inst_lry,a5			  ;upper left x
	callr	std_bord       ;taco bell has your order, make a ru-uuun......
	rets

**************************************************************************
*												*
*	  men_nums										*
*												*
*	  this is called to get some numbers associated				*
*	  with a menu box.									*
*												*
*	  this returns: 									*
*												*
*	  a4 = left x										*
*	  a5 = right x										*
*	  a6 = center x 									*
*												*
**************************************************************************
men_nums
	callr	menu_ul_a4_a5				  ;left x in a4
	callr	menu_lr_a6_a5				  ;right x in a6
	move	a6,a5					  ;copy right x into a5
	add	a4,a6					  ;find center
	srl	1,a6					  ;a6 now has center x (for later)
	rets

**************************************************************************
*												*
*	  c_pd_m										*
*												*
*	  this prints a l_mess message passed in a8, centered 		*
*	  on the x stored at *a13(pdata),w						*
*												*
**************************************************************************
c_pd_m
	calla	lm_setup	;setup the message
	andi	0ffff0000h,a9	;remove x
	move	*a13(pdata),a3,w	;get the x
	add	a3,a9			;put our x in
;	 jump	 a1			 ;and "call" the routine
	jauc	lm_xfinis

**************************************************************************
*												*
*	  wt_adv										*
*												*
*	  wait till advance.  this holds control until advance		*
*	  button is pressed.									*
*												*
**************************************************************************
wt_adv	sleep	2

wt_a6	callr	get_adv 		 ;scan the button
	jrnz	wt_adv			 ;not pressed. 
	retp

coinsnd	.word	>f3df,>10,>8085,0		;"coin" sound
wolf	.word	>f3df,>10,>8088,0
bogus	.word	>f3df,>10,>803e,0

**************************************************************************
*												*
*	  ww_adv										*
*												*
*	  wait while advance.  this holds control while advance		*
*	  button is held (or stuck). 							*
*												*
**************************************************************************
ww_adv	sleep	2
	callr	get_adv
	jrz	ww_adv
	retp

**************************************************************************
*												*
*	  get_adv										*
*												*
*	  this gets physical state of advance button.				*
*												*
*	  .eq.	  pressed									*
*	  .ne.	  open										*
*												*
**************************************************************************
get_adv
	mmtm	sp,a0
	move	@coins,a0,w			;fetch coin switches (looking for advance)
;	 andi	 adv_bit,a0			 ;keep advance bit.
	mmfm	sp,a0
	rets

**************************************************************************
*												*
*	  get_menu										*
*												*
*	  this routine is called (via jsrp) to display a menu on		*
*	  screen and receive a selection from the operator.			*
*												*
*	  the menu descriptor is passed in a8. 					*
*												*
*	  the selection number is returned in a8. (line 1 = 1)		*
*	  the routine address is returned in a9.					*
*	  a10 is returned non-zero if advance was the button used		*
*												*
*	  a menu (pointed to by a8) is defined as follows:			*
*												*
*		      font to be used		   (long) 			*
*		      x for left margin		   (word) 			*
*		      y for top line 		   (word) 			*
*		      dy per entry			   (word) 			*
*		      text_color			   (word) 			*
*		      height of selection bar	   (word) 			*
*		      dx from top of text to sel. bar  (word) 		*
*												*
*	  a9 points at entry to start with						*
*												*
*	  then for each entry:									*
*												*
*		      text pointer		(long)					*
*		      activation routine	(long)					*
*												*
*	  the list is terminated by a zero.						*
*												*
*	  this routine forks a separate process to do the work		*
*	  for it.  therefore the caller has full use of				*
*	  the pdata area.									*
*												*
**************************************************************************
*
*	equates for get_menu slave process.
*
men_off	equ	pdata			;word-offset into menu of selection
men_rout equ	men_off+word_size	;long-routine for selection
men_rom	equ	men_rout+long_size	;long-pointer to rom structure
men_ulx	equ	men_rom+long_size	;word-left x  (center x when centering)
men_uly	equ	men_ulx+word_size	;word-top y
men_dy	equ	men_uly+word_size	;word-y units per entry
men_colr equ	men_dy+word_size	;word-color for entries
men_bar	equ	men_colr+word_size	;word-height of selection bar
men_bdy	equ	men_bar+word_size	;word-dy from top of text to top of bar.
men_bdx	equ	men_bdy+word_size	;word-dx from left of word to left of bar
men_bwid equ	men_bdx+word_size	;word-width of bar
men_scol equ	men_bwid+word_size	;word-color of selected text
men_tptr equ	men_scol+word_size	 ;long-pointer to beginning of text entries.
men_ents equ	men_tptr+long_size	;word-number of entries in menu
men_cur	equ	men_ents+word_size	;word-current selection (1st is 1)
men_walk equ	men_cur+word_size	;word-number of entry we're on as we walk
men_stik equ	men_walk+word_size	;long-"stuck" state of switches
men_act	equ	men_stik+long_size	;long-switch we're acting on. (bit)
men_typo equ	men_act+long_size	;word-typomatic counter
men_hits equ	men_typo+word_size	;word-consecutive typomatic hits
men_adv	equ	men_hits+word_size	;word-non-zero if advance was button used

word_ents    equ    (men_tptr-men_ulx)/word_size   ;number of word entries

b_menu	movi	bd_slave,a7
	jruc	gmjmp

get_menu
	movi	gm_slave,a7		;this is routine
gmjmp
	movi	menu_pid,a1		;this is id
	calla	getprc			;create it

	move	a0,a10			;save his pointer

gm1	sleep	2

	movi	mdun_pid,a0
	movi	0ffffh,a1
	calla	existp			;wait for id to change to this!

	jrz	gm1			;loop until it exists!

	move	*a10(men_off),a8,w	;return offset of selection
	move	*a10(men_rout),a9,l	;and routine that was selected.
	move	*a10(men_adv),a10,w	;indicate whether advance was used

	movi	mdun_pid,a0
	movi	0ffffh,a1
	calla	kilall			;kill the hanging menu getter!
	retp				;and return
	
**************************************************************************
*												*
*	  gm_slave										*
*												*
*	  this displays the menu.......moves the selection bar		*
*	  and returns the selection information by stuffing			*
*	  it in its process area and changing its id to				*
*	  mdun_pid once selection is made.						*
*												*
*	  on entry....a8 points at the get_menu data structure.		*
*		      a9 is which entry to start with selected.		*
*												*
**************************************************************************
bd_slave callr	menu_border		;draw the border for selctions.

gm_slave jsrp	st_stick	  ;tell stick(s) and buttons we're starting.

	callr	stuff_menu_process	;move data into pdata area
*
*	plot entire menu
*
*	do_menu_line will return carry set
*	when we get beyond the end.
*
	movk	1,a0				  ;setup for line 1.
do_another_line
	move	a0,*a13(men_walk),w		;walk through.

	jsrp	do_menu_line			;put out line in a0.
	move	*a13(men_walk),a0,w		;get back the counter

	inc	a0				;move to next entry.
	move	*a13(men_ents),a1,w		;see if we're done.
	cmp	a1,a0
	jrls	do_another_line
*
*	main menu plotted......now let the dma un-load before plotting help
*
	callr	plot_help			;plot help for 1st if necessary

*	 sleep	 2				 ;now make sure the help gets plotted
*
*	now we just want to update based on stick...act
*	on buttons!
*
*	responses:   up....down....button....nothing....
*
*	nothing = 0
*	up = 1
*	down = 2
*	button = 3
*
*	a0 = response
*	a1 = men_cur value.
*
	
	clr	a0
	move	a0,*a13(men_hits),w
	move	a0,*a13(men_typo),l
menu_loop
	sleep	1
        jsrp    getstick		; check out the player board
        move    a0,a0
	jrnz	ml1			; br = got something
	move	a0,*a13(men_hits),w	; clear timer and direction
	move	a0,*a13(men_typo),w
	jruc	menu_loop
ml1
	move	*a13(men_hits),a1,w	; get last direction
	andi	7,a1			; mask off repeat bit
	cmp	a0,a1
	jrz	ml2			; br = yes, still same thing
	move	a0,*a13(men_hits),w
	clr	a1
	move	a1,*a13(men_typo),w	; clear the timer
	jruc	mldone			; process initial hit
ml2
	move	*a13(men_hits),a1,w	; snag the repeat bit
	andi	80h,a1
	jrnz	ml3			; br = in repeat mode
	move	*a13(men_typo),a0,w	; get timer
	inc	a0
	move	a0,*a13(men_typo),w
	cmpi	15,a0
	jrlo	menu_loop		; go back to sleep
	clr	a0
	move	a0,*a13(men_typo),w	; clear out the timer
	move	*a13(men_hits),a1,w
	move	a1,a0
	ori	80h,a1			; put upper bit on
	move	a1,*a13(men_hits),w	; set direction with repeat on
	jruc	mldone
ml3
	move	*a13(men_typo),a0,w	; get timer
	inc	a0
	move	a0,*a13(men_typo),w
	cmpi	5,a0
	jrlo	menu_loop		; go back to sleep
	clr	a0
	move	a0,*a13(men_typo),w	; clear out the timer
	move	*a13(men_hits),a0,w
	andi	7h,a0			; turn off repeat bit
mldone
	move	*a13(men_cur),a1,w		;get current entry...in a1

	cmpi	3,a0				;button?
	jrz	menu_button			;yep....we're out of here.

	cmpi	2,a0
	jrz	menu_down			;its down....
*
*	request to go up....are we at #1
*
	cmpi	1,a1				;well?
	jrls	menu_loop			;yep....ignore

	jsrp	un_select			;put back the old "current one
	move	*a13(men_cur),a0,w		;get current entry
	dec	a0				;make one less.
	jruc	join_down			;now plot the new one.

menu_down
	move	*a13(men_ents),a2,w		;get number in menu
	cmp	a2,a1				;are we at max
	jrhs	menu_loop			;yep...no action

	jsrp	un_select			;put back the old "current one

	move	*a13(men_cur),a0,w		;get current entry
	inc	a0				;make this the next.

join_down
	move	a0,*a13(men_cur),w	;put back
	jsrp	do_menu_line		;put out line in a0.
*
*	make the "dink" sound here for entry to entry movement
*
	callr	plot_help		;plot help new one
	sleep	1			;delay beep 1 frame

	callr	menu_move_sound
	jruc	menu_loop		;and wait for next response.
*
*	control comes here when a button is pressed
*
*	  the selection number is returned in a8. (line 1 = 1)		
*	  the routine address is returned in a9.					

menu_button
*
*	a0 has a 3.
*	a2 has the button bit.....is it advance?
*
	move	*a13(men_rom),a0,l
	cmpi	men_adj,a0		; special case for menu adj
	jrnz	mbnotadj
	calla	ckdip
	jrnz	mbnotadj		; not using dip switches
	move	*a13(men_cur),a0,w	; get the select item
	cmpi	2,a0			; "standard pricing"
	jrz	mbabort
	cmpi	3,a0			; "custom pricing"
	jrz	mbabort
	cmpi	4,a0			; "free play"
	jrnz	mbnotadj
mbabort

	callr	menu_bong_sound
	jruc	menu_loop
mbnotadj
	clr	a0				;not advance

is_adv	move	a0,*a13(men_adv),w		;non zero if it was advance

	jsrp	button_stall			;highlight selection and hang on button

	move	*a13(men_cur),a0,w		;get "current" entry.
	callr	get_menu_data			;a1=current_offset	a2=text  a3=routine
	move	a0,*a13(men_off),w		;store the offset (choice num)
	move	a3,*a13(men_rout),l		;and the routine pointer
	movi	mdun_pid,a0
	move	a0,*a13(procid),w		;change our id.

menu_done
	sleep	20
	jruc	menu_done			;now hang till dispatcher sees id.



menu_move_sound
	movi	mm_sound,a3
	jauc	send_code_a3

menu_bong_sound
	movi	>273,a3
	jauc	send_code_a3

menu_select_sound
	movi	ms_sound,a3
	jauc	send_code_a3

**************************************************************************
*												*
*		 menu utilities 								*
*												*
**************************************************************************
**************************************************************************
*												*
*	  button_stall										*
*												*
*	  this is called when the menu gets a button hit.			*
*	  a1 has the bit of the button.							*
*												*
*	  we paint the menu square to feedback the hit.				*
*												*
*	  then we hang on the button until its let go.				*
*												*
**************************************************************************
button_stall
	move	a2,@last_but,l		;push the button state

	move	@scode,a0,w		;no cash for repeat sound codes
	move	@dcode,a1,w
	or	a0,a1
	jrnz	dont_wait		;its a sound repeat....don't hold either!

	callr	menu_select_sound

	move	*a13(men_cur),a0,w	;get current selection
	movi	trog_yellow,a1
	callr	menu_bar		;change the bar color.

	callr	get_menu_data		;get our text pointer back
	movi	trog_white,a1		;white on orange during hot moment
	jsrp	menu_text		;and write inverted text

	move	@last_but,a8,l		;get button back
	movi	08h,a9			;minimum time for button highlite

	movi	2ah,a10			;.5 seconds of advance hold-down
*					;will exit test mode.
wait_for_release
;	 cmpi	 adv_high,a8			 ;is it advance button?
;	 jrnz	 not_adv			 ;nope.....never mind

;	 dec	 a10			 ;1 less time unit
;	 jrz	 diag_ex	    ;if he holds advance...we're gone!

not_adv	sleep	1
	
	move	a9,a9			;reduce for held time
	jrz	wait_1			;zeroed out already.
	dec	a9

wait_1
	callr	form_sws	;wait for this one to go to zero
	and	a8,a0			;is our button still down?
	jrnz	wait_for_release
*
*	its released...now show orange bar for minimum time

	inc	a9			;make sure a9 has 1 or more
wait_2
	sleep	1
	dsjs	a9,wait_2

dont_wait
	move	*a13(men_cur),a0,w	;get current selection
	clr	a1			;erase bar
	callr	menu_bar		;change the bar color.

	callr	get_menu_data			;get our text pointer back
	move	*a13(men_colr),a1,w		;re-plot the normal text
	jsrp	menu_text			

	sleep	2			;now give some bounce protection.

	retp

**************************************************************************
*												*
*	  stuff_menu_process									*
*												*
*	  this is called to stuff the menu rom data into the			*
*	  current processes pdata area.							*
*												*
**************************************************************************
stuff_menu_process
	mmtm	sp,a0,a1,a2,a3,a8
	move	a13,a0			;point in process area
	addi	men_rom,a0		;this is where 1st tidbit goes
	move	a8,*a0+,l		;store our base pointer in structure
	addi	mr_words,a8		;move to word list

	movi	word_ents,a2		;now this many more words.

gms1	move	*a8+,a1,w
	move	a1,*a0+,w
	dsjs	a2,gms1
*
*	all the menu parameters are now in the pdata area.
*	a8 points at the first item to display.
*
	move	a8,*a13(men_tptr),l	;store in process area.
*
*	now we want to find the number of entries in the menu
*
	clr	a0				;start at #1.
how_many
	inc	a0				;move to next entry.
	callr	get_menu_data			;get the parameters for this entry
	move	a2,a2				;and see if a2=0
	jrnz	how_many			;its real.....put it up.

	dec	a0				;previous line was the last.
	move	a0,*a13(men_ents),w		;stuff number in menu.

	move	a9,a9				;did bozo pass zero as current?
	jrz	use_last
	cmp	a0,a9				;make sure its not too high
	jrhi	use_last			;a9 is too high
	move	a9,a0				;use the one past

use_last move	a0,*a13(men_cur),w	;make entry "1" current.

	mmfm	sp,a0,a1,a2,a3,a8
	rets

**************************************************************************
*												*
*	  do_menu_line										*
*												*
*	  a0 has the line to do. (1 through n).					*
*	  print text normal if not "men_cur".						*
*	  print invert bar followed by black text if				*
*	  its the current entry.								*
*												*
**************************************************************************
do_menu_line
	callr	get_menu_data			;get "current" in a1
	cmp	a0,a1				;is it "current" entry?
	jrz	do_current_ent			;yep....do inverse stuff
*
*	a0 has offset (for positioning)
*	a2 has text pointer (for message)
*	a1 needs color for message.
*
	move	*a13(men_colr),a1,w		;use the normal entry color
	jsrp	menu_text			;put up the "text" portion.
	retp					;and return

do_current_ent	
	movi	trog_white,a1		    ;do the bar in white (at a0 height)
	callr	menu_bar			;put it up (a0 preserved)

	callr	get_menu_data			;get our text pointer back
	move	*a13(men_scol),a1,w		;get "selected" color
	jsrp	menu_text			;and write inverted text
	retp					;that's all folks.

**************************************************************************
*												*
*	  un_select										*
*												*
*	  this is called to "un-select" the current entry.			*
*												*
**************************************************************************
un_select
	move	*a13(men_cur),a0,w		;point at current entry
	clr	a1				;use black for background
	callr	menu_bar			;this removes the bar.

	callr	get_menu_data			;now get a2 to text pointer
	move	*a13(men_colr),a1,w		;use the normal entry color
	jsrp	menu_text			;put up the "text" portion.
	retp					;and return

**************************************************************************
*												*
*	  menu_bar										*
*												*
*	  this is called to put up the selection bar for 			*
*	  the entry in a0, in the color in a1. 					*
*												*
*	  this routine must preserve a0.							*
*												*
**************************************************************************
* strnglen - returns the length, in pixels, of a given string		 *
* a8 = ptr to string							 *
* a10 = [y,x] spacing of string						 *
* a11 = ptr to font table						 *
* returns:								 *
* a7 = length of string							 *
* z bit set if length is zero						 *
*
*	for fillarea
*
* a1 = <color><palette>
* a3 = dag of area [ypos,xpos]						
* a4 = [y,x] size of area						
*
menu_bar mmtm	sp,a0,a1,a3,a4,a5,a6,a7,a8    ;save the offset
	mmtm	sp,a1				;save color!
	callr	get_menu_data			;get the text pointer
	callr	stlen_setup			;setup for strlen call.
	calla	strnglen			;find width of string.
*
*	a7 has length of string.
*
*	we need to get into a3 the coordinates uf upper left
*	and a4 the length.
*
*	if we're centering, we use the bar width parameter
*	along the center line.
*
*	if we're left justified, we'll let the box go the
*	length of the text for now.
*
	move	*a13(men_ulx),a3,w		;left x in a3				
*
*	if we're centering....we need to move the "left x" back half
*	the width of the string.
*
	move	*a13(men_rom),a6,l		;get rom pointer
	move	*a6(mr_tcal),a6,l		;check routine
	cmpi	strcnrm,a6
	jrnz	not_centering
*
*	we're centering....center x is in a3
*
	move	*a13(men_bwid),a7,w		;a7 is the register for bar width
	move	a7,a4				;get copy in a4
	srl	1,a4				;1/2 of width comes off of center
	sub	a4,a3				;a3 now has "left x"
	jruc	centering			;a7 is width...a3 is x

*
*	left justified....do it the old way!
*
not_centering
	move	*a13(men_bdx),a4,w		;get extra x units for bar
	sub	a4,a3

*	now add twice the extra x to the string length to
*	form the bar length.
*
	sll	1,a4				;now double the excess dx for bar
	add	a4,a7				;now a7 has width of bar

centering
	subi	c_kludge,a3		;kludge to nullify final space.

	callr	get_entry_y			;get y for entry in a5

	move	*a13(men_bdy),a6,w		;get bar dy (negative)
	add	a6,a5				;adjust y by bar dy
	sll	16,a5				;shift y into position

	add	a5,a3				;a3 now points at upper left

	move	*a13(men_bar),a4,w		;y height of bar
	sll	16,a4				;in position
	add	a7,a4				;a7 has x width of bar.

	mmfm	sp,a1				;now get color back!
	sll	16,a1				;shift color to high half (pal. 0) 
	calla	fillarea			;fill it up!

	mmfm	sp,a0,a1,a3,a4,a5,a6,a7,a8    ;save the offset
	rets

**************************************************************************
*												*
*	  menu_text										*
*												*
*	  this is called to display the text for an entry.			*
*												*
*	  a0 has offset (for positioning) 						*
*	  a1 has color for message.								*
*	  a2 has text pointer (for message)						*
*												*
*	  we need to shift the data for the text routine 			*
*	  as follows:										*
*												*
*	  a0 = sleep										*
*	  a5 = color										*
*	  a8 = pointer										*
*	  a9 = address										*
*	  a10 = spacing 									*
*	  a11 = font										*
*												*
**************************************************************************
menu_text
	callr	get_entry_y			;get y for entry in a5
	sll	16,a5				;shift y into position
	move	*a13(men_ulx),a9,w		;get the x
	add	a5,a9				;a9 set with screen address

;	 move	 a1,a6				 ;color -- this is narc style
	move	a1,a5			; fix for passing colors -- jkm
	sll	16,a5
	clr	a0				;no sleep

	callr	stlen_setup

	move	*a13(men_rom),a1,l
	move	*a1(mr_tcal),a1,l		;get the routine to use
;	 jump	 a1				 ;and call it!
	jauc	lm_xfinis

stlen_setup
	move	a2,a8				;text pointer
	movi	spacing20,a10			;spacing
	move	*a13(men_rom),a11,l
	move	*a11(mr_font),a11,l		;load font
	rets

**************************************************************************
*												*
*	  menu joystick handling								*
*												*
**************************************************************************

**************************************************************************
*											     *
* 	st_stick									     *
* 											     *
* 	initialize the stuck stick stuff						     *
* 											     *
* 	entry	nothing									     *
* 											     *
* 	exit	nothing									     *
*											     *
**************************************************************************
st_stick	
	move	@switch,a0,l
	move	a0,*a13(men_stik),l	; bits to ignore part 1

	move	@switch+32,a0,l

	andi	button_bits2,a0
;	andi	1fh,a0			; only stuff i need

	move	a0,*a13(men_act),l	; ignore this, too

	retp

**************************************************************************
*									    *
*	getstick							 *
*									 *
*	checks out all the sticks on the board and returns some		 *
*	useful info about them						 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		a0	stick/button condition				 *
*			0 = nothing					 *
*			1 = stick up					 *
*			2 = stick down					 *
*			3 = button down					 *
*									    *
**************************************************************************

getstick:
	callr	cktest			; check the test switch
;
	mmtm	sp,a3,a4
*
* this also takes care of stuck switches
*
	move	@switch,a2,l	
	move	*a13(men_stik),a0,l
	not	a0			; this is sooooo gross
	not	a2
	and	a2,a0
	not	a0
	move	a0,*a13(men_stik),l	
	and	a0,a2			; ignore some bits

	move	@switch+32,a3,l
	move	*a13(men_act),a0,l
	not	a0
	not	a3
	and	a3,a0
	not	a0
	move	a0,*a13(men_act),l	
	and	a0,a3

;	andi	1fh,a3			; mask off the bits
	andi    3fh,a3			; include p1 low kick
*
* scan for buttons
*
	move	a2,a4			; check for buttons

	andi	button_bits,a4
	jreq	gsck2			; no buttons in the first mess

	andi	bb_nostart,a4		; draw buttons
	jreq	gsck1

	movk	2,a2
	jruc	gsgotbuts

gsck1	movk	1,a2			; musta been a start button
	jruc	gsgotbuts

gsck2

;****************
	move	a3,a4
;	andi	10h,a4
	andi	button_bits2,a4
	jrz	gsckstk
	movk	2,a2			; was a draw button
	jruc	gsgotbuts
;**************** backin

;
;	scan for sticks
;
gsckstk
	move	a2,a4
	andi	03h,a4			; stick 1
	jrz	gsp2
	andi	01h,a4
	jrnz	gsgotup
	jruc	gsgotdown
gsp2
	move	a2,a4
	andi	0300h,a4		; stick 2
	srl	8,a4
	jrz	gsaintgot
	andi	01h,a4
	jrnz	gsgotup
	jruc	gsgotdown

gsaintgot
	clr	a0
	jruc	gsret

gsgotup
	movk	1,a0
	jruc	gsret

gsgotdown
	movk	2,a0
	jruc	gsret

gsgotbuts
	movk	3,a0

gsret
	move	a0,a0			; set the flags
	mmfm	sp,a3,a4
	retp

**************************************************************************
*												*
*	  frst_bit										*
*												*
*	  a0 has 1 or more bits set....return 1 of them. 			*
*												*
**************************************************************************
frst_bit mmtm	sp,a1,a2
	movk	1,a1		;shift till we find it.
fb1	move	a0,a2
	and	a1,a2
	jrnz	got_it		;we have on (in a1)
	sll	1,a1		;shift it
	jruc	fb1
got_it	move	a1,a0		;return the bit
	mmfm	sp,a1,a2
	rets

**************************************************************************
*												*
*	  form_sws										*
*												*
*	  get the switches....1=closed.....and save 				*
*	  this scan as "last state".  return:						*
*												*
*	  current state in a0									*
*	  previous state in a1									*
*												*
**************************************************************************
form_sws
	move	*a13(men_stik),a1,l	;return previous state
	move	@switch,a0,l		;get both switch words
	not	a0			;complement
	move	a0,*a13(men_stik),l	   ;save "stuck" state.
	rets

**************************************************************************
*												*
*	  get_menu_data 									*
*												*
*	  a0 is offset of entry of interest						*
*												*
*	  return  a1 = current offset							*
*		  a2 = text pointer								*
*		  a3 = routine									*
*												*
**************************************************************************
get_menu_data
	mmtm	sp,a0			;don't alter a0

	callr	pm_entry     ;point a1 at entry

	move	*a1(menu_text_ptr),a2,l	;fetch the text pointer
	move	*a1(menu_routine),a3,l	;fetch the routine
	move	*a13(men_cur),a1,w		;return current entry in a1
	mmfm	sp,a0			;don't alter a0
	rets

**************************************************************************
*												*
*	  pm_entry										*
*												*
*	  a0 = menu entry of interest							*
*	  return a1 -> points at <text><routine><help> for this		*
*	  entry.										*
*												*
**************************************************************************
pm_entry
	mmtm	sp,a0
	dec	a0			;index from zero
	movi	menu_entry_size,a1	;times size per entry
	mpyu	a0,a1			;a1 contains offset into table

	move	*a13(men_tptr),a0,l	;get the base of the menu text entries
	add	a0,a1			;add to offset
	mmfm	sp,a0
	rets

**************************************************************************
*												*
*	  plot_help										*
*												*
*	  this routine plots (or clears) the help area				*
*	  for the current entry.								*
*												*
**************************************************************************
plot_help
	move	*a13(men_cur),a0,w		;get current entry
	callr	pm_entry	  ;a1 points at group
	move	*a1(menu_help),a8,l		;get help table
	cmpi	no_help,a8			;not a "help" situation?
	jrz	no_help_for_this_one
	cmpi	adj_help,a8			;adjustment help requested?
	jaeq	do_adjh 			;then do it in adj module!
	cmpi	snd_help,a8			;are we in sound test?
	jreq	do_shelp
	cmpi	snd_play,a8
	jreq	do_splay
	callr	do_help_menu
no_help_for_this_one
	rets

**************************************************************************
*												*
*	  do_shelp										*
*												*
*	  this is called for each non playing entry in the sound		*
*	  table menu.  it causes the sound board to be shut			*
*	  up and the bottom line (where titles appear)				*
*	  to be erased. 									*
*												*
**************************************************************************

do_shelp
	move	@snd_made,a0,w		;did someone make a sound?
	jrz	do_sh1			;nope
	clr	a0
	move	a0,@snd_made,w		;clear this and reset the board!
	move	a0,@scode,w
	move	a0,@dcode,w
	calla	sndresp			;kill any sounds in progress
do_sh1
	callr	blnksnam		;blank out any writing!
	rets
*
*	a0 contains 3 for synthesizer...4 for digitizer...
*	if corresponding "code" byte is non zero, then display
*	the textline that corresponds.  else blank out the
*	area.
*
do_splay callr	blnksnam		; blank out last message
	cmpi	2,a0			; synthesizer?
	jrz	ck_synt 		; yep.

	clr	a1
	jruc	do_spqx
*
*	digitizer.
*
****	    move    @scode,a1,w     ;hold info if synth was running
****	    clr     a0
****	    move    a0,@scode,w     ;clear out synth code
****	    move    @dcode,a0	    ;any code
****	    jrz     do_spqx	    ;nothing here.....shut up sound sys.
****
****	    movi    dtable,a1	    ;base of pointer table for digitizer
****	    jruc    do_sp1	    ;print the string.


ck_synt	move	@dcode,a1,w	; hold info if digitizer was running
	clr	a0
	move	a0,@dcode,w	; clear out dig code
	move	@scode,a0	; any code
	jrz	do_spqx 	; nothing here.

	movi	stable,a1	; base of pointer table for digitizer

do_sp1	callr	men_nums				    ;a4 = left x  a5 = right x
	addi	10000h*snd_mess_y,a4 		    ;upper left y
	addi	10000h*(snd_mess_y+snd_box_h),a5   ;upper left x
	movi	trog_white,a9
	callr	std_bord       	; taco bell has your order, make a ru-uuun.

	dec	a0  	       	; index from 1.
	sll	5,a0
	add	a0,a1
	move	*a1,a2,l	; now we have the message

	movi	snd_inst,a8
	jsrp	l_mess				;put instruction out.

	movi	snd_setup,a8
	calla	lm_setup

	move	a2,a8			
	jsrp	lm_xfinis			 ;do the deed
	rets					;and return

do_spqx	move	a1,a1				;our selection isn't running...was other?
	jrz	do_spx				;nope
	calla	sndresp 			;kill sounds in progress
	clr	a0
	move	a0,@snd_made,w			;no reset necessary now
do_spx	rets

**************************************************************************
*												*
*	  blnksnam										*
*												*
*	  called to blank out the sound code name during 			*
*	  sound test.										*
*												*
**************************************************************************
*
*	a3 = pointer
*	a4 = size
*
blnksnam
	movi	(snd_mess_y*10000h)+20h,a3
	movi	(snd_box_h*10000h)+1e0h,a4
	jauc	blnkarea			;its blank!

**************************************************************************
*												*
*	  get_entry_y										*
*												*
*	  this returns the y positions for the entry specified		*
*	  in a0.										*
*												*
*	  a5 = y value in units.								*
*												*
**************************************************************************
get_entry_y
	mmtm	sp,a0,a1
	move	*a13(men_uly),a5,w
	move	*a13(men_dy),a1,w
	dec	a0
	mpyu	a0,a1			;a1 has offset per entry
	add	a1,a5
	mmfm	sp,a0,a1
	rets

**************************************************************************
*												*
*	  menu_border										*
*												*
*	  this is called to put a border around the menu.			*
*												*
*	  a8 = menu structure									*
*	  a9 = 1st item to activate as current 					*
*												*
*	  border is done in menu text color						*
*												*
*	  this assumes menu is in the centering format				*
*												*
**************************************************************************
*
*	1st we need to find upper left.
*
*
*	x = menu_x - (bar_width/2) - 2	   (less border width)
*	y = menu_y - bdy			   (less border height)
*
*	lower right :
*
*	x = menu_x + (bar_width/2) - 2	   (plus border width)
*	y = menu_y + (menu_entries-1) * dy)) - bdy + bar_hite
*
*
menu_border
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	callr	stuff_menu_process	;move data into pdata area
*
*	first compute upper left
*
	callr	menu_ul_a4_a5			;get upper left coordinates
	sll	16,a5
	add	a5,a4				;a4 points to upper left.
*
*	form lower right
*
	callr	menu_lr_a6_a5
	sll	16,a5				;shift a5 down
	add	a6,a5				;a5 points at lower right

	move	*a13(men_colr),a9,w		;get menu text color
	callr	std_bord

	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	rets

**************************************************************************
*												*
*	  mcsetup										*
*												*
*	  return:										*
*		  a0 = center of menu							*
*		  a1 = 1/2 bar width 							*
*		  a2 = y for first line of text of menu				*
*		  a3 = delta y (negative to get from text to bar.		*
*												*
**************************************************************************
mcsetup
	move	*a13(men_ulx),a0,w		;upper left x (actually center)
	move	*a13(men_bwid),a1,w		;bar_width
	srl	1,a1				;all calcs use bar_width/2
	move	*a13(men_uly),a2,w		;upper left y
	move	*a13(men_bdy),a3,w		;delta y (negative)
	rets


**************************************************************************
*												*
*	  menu_ul_a4_a5 									*
*												*
*	  return window upper left corner 						*
*												*
*	  a4 = x										*
*	  a5 = y										*
*												*
**************************************************************************
menu_ul_a4_a5
	mmtm	sp,a0,a1,a2,a3
	callr	mcsetup 			;stuff the reggies
	move	a0,a4				;form ulx
	sub	a1,a4
	subi	c_kludge,a4		;a4 has upper left x

	move	a2,a5
	add	a3,a5				;a5 has upper left y

	subi	mb_xwid+gap,a4			;now we point at upper left for frame
	subi	mb_ywid+gap,a5
	mmfm	sp,a0,a1,a2,a3
	rets

**************************************************************************
*												*
*	  menu_lr_a6_a5 									*
*												*
*	  return window lower right corner						*
*												*
*	  a6 = x										*
*	  a5 = y										*
*												*
**************************************************************************
menu_lr_a6_a5
	mmtm	sp,a0,a1,a2,a3
	callr	mcsetup 			;stuff the reggies

	move	a0,a6				;lower right x
	add	a1,a6
	subi	c_kludge,a6		;this is the x

	move	*a13(men_ents),a0,w		;this is last entry
	callr	get_entry_y			;a5 has the y for the last entry
	add	a3,a5				;a5 now has top of last box
	move	*a13(men_bar),a7,w		;height of bar
	add	a7,a5				;a5 now has lower right y

	addi	mb_ywid+gap,a5
	addi	mb_xwid+gap,a6			;this is end of border
	mmfm	sp,a0,a1,a2,a3
	rets


**************************************************************************
*												*
*	  f_title										*
*												*
*	  this is called to frame a title in the same width			*
*	  as the main title.									*
*												*
*	  a0 = y level of 15 point text							*
*	  a9 = color										*
*												*
**************************************************************************
f_title	mmtm	sp,a4,a5,a0
	move	a0,a4		;copy y
;	 subi	 12,a4
	subi	8,a4
	sll	16,a4
	addi	tit_ulx,a4	;upper left set

	move	a0,a5		;lower right
;	 addi	 27,a5
	addi	23,a5
	sll	16,a5
	addi	tit_lrx,a5	;lower right set

	callr	std_bord       ;taco bell has your order, make a ru-uuun......
	mmfm	sp,a4,a5,a0
	rets

first_border_color	equ	0e0e0h
last_border_color	equ	0efefh
**************************************************************************
*												*
*	  g_border										*
*												*
*	  this is called to do a "hstd table" type cycling			*
*	  border.  this routine gets:							*
*												*
*	  a4 = upper left y,x									*
*	  a5 = lower right y,x									*
*	  a6 = number of slices going in. 						*
*												*
**************************************************************************
g_border mmtm	sp,a0,a1,a2,a3,a4,a5,a6
	movi	10001h,a0			;1 by 1 dimension

	movi	last_border_color,a9 	;use last one 1st
next_ring
	callr	doborder			;do this ring

	movi	10001h,a1			 ;this is 1 unit in x and y
	addxy	a1,a4
	subxy	a1,a5

	subi	101h,a9
	cmpi	first_border_color,a9
	jrhs	colok
	movi	last_border_color,a9

colok	dsjs	a6,next_ring
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6
	rets

**************************************************************************
*												*
*	  doborder									    *
*												*
*	  this is called to draw a border frame.					*
*												*
*	  a4 = upper left y,x									*
*	  a5 = lower right y,x									*
*	  a0 = y,x width of border								*
*	  a9 = color of border. 								*
*												*
*	  this routine *** clears out all area inside the border***	*
*	  as a function of its operation. 						*
*												*
*	  the border is done in the "trog" palette				    *
*												*
*	  it is assumed that the display system is running!			*
*												*
**************************************************************************
*
* a1 = <color><palette>
* a3 = dag of area [ypos,xpos]						
* a4 = [y,x] size of area						
*
doborder
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	move	a9,a1				;get color
	sll	16,a1				;color on top..palette 0
*
*	now we need to make 4 bars!
*
	move	a0,a2				;separate delta
	andi	sx_mask,a0
	andi	sy_mask,a2

	move	a4,a6				;upper lefts here
	move	a4,a7

	move	a5,a8				;lower rights here
	move	a5,a9

	andi	sx_mask,a6			 ;left x
	andi	sx_mask,a8			 ;right x

	andi	sy_mask,a7			 ;top y
	andi	sy_mask,a9			 ;bottom y

*
*	first bar goes from original ul xy to right x
*	and top y+delta y
*
*	a3 is original a4 passed.
*	form destination in a4
*
	move	a4,a3

	movx	a8,a4
	movy	a7,a4
	addxy	a2,a4				;add the delta

	callr	do_a_line			;do this line
*
*	going around clockwise.....this one starts at right x-delta
*	and top y
*
	movx	a8,a3
	subxy	a0,a3
	movy	a7,a3
*
*	this is the natural lower right corner
*
	movx	a8,a4
	movy	a9,a4

	callr	do_a_line
*
*	now for bottom line.....a4 is still set!
*
	movx	a6,a3
	movy	a9,a3
	subxy	a2,a3

	callr	do_a_line
*
*	left wall....from upper left
*
	movx	a6,a3
	movy	a7,a3

	movx	a6,a4
	addxy	a0,a4
	movy	a9,a4

	callr	do_a_line

	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	rets

do_a_line
	mmtm	sp,a4
	subxy	a3,a4		;form distance
	calla	fillarea	;and do the fill
	mmfm	sp,a4
	rets

std_bord mmtm	sp,a0
	movi	border_size,a0
	calla	doborder
	mmfm	sp,a0
	rets
**************************************************************************
*												*
*	  do_help_menu										*
*												*
*	  this is called to display a help menu for the current		*
*	  menu entry.										*
*												*
*	  a help menu is defined as follows:						*
*												*
*	  hm_just	  word	  0=center   1=left 				*
*	  hm_color	  word	  color of menu					*
*	  hm_ents	  word	  number of lines in menu			*
*			  long	  long word pointers for each line!	*
*												*
*	  the process area is filled with the current menu			*
*	  parameters.										*
*												*
*	  a8 = pointer to help menu structure above 				*
*												*
**************************************************************************
do_help_menu
	callr	blnkhelp

	move	a8,a8			;check if help menu exists.
	jrz	dhmx			;nope just clearing was our job.

	move	*a13(men_cur),a0,w	;this is current entry
	move	a0,a11			;pass entry number in a11
	callr	get_entry_y		;a5 has the y for the current entry
*
*	now we need to move to make top entry box line up.
*
	move	*a13(men_bdy),a10,w	;this is negative to give us box top
	add	a5,a10			;now we have box top

	move	*a13(men_bar),a5,w	;get bar height
	srl	1,a5			;find center of bar
	add	a5,a10			;now we're at bar center.

*	 subi	 mb_ywid+gap,a10	 ;this is main menu top. (for top entry)

	movi	h_slave,a7	  ;fork off so it can use pdata!
	calla	p_fork			;start up another w/ same id to flash!
dhmx	rets

**************************************************************************
*												*
*	  blnkhelp										*
*												*
*	  this is called to blank out the help area.  it is			*
*	  used by both the "normal" help plotter and is				*
*	  called by the adjustment help program.					*
*												*
*	  this returns the left x for the help menu in a9			*
*												*
**************************************************************************
blnkhelp
	mmtm	sp,a3,a4,a5,a6
	callr	menu_lr_a6_a5		;get right x of main menu in a6
	move	a6,a9			;pass to help menu slave
*
*	now blank out the "help" region
*
	move	a6,a3			;upper left x of region to blank out
	addi	inst_uly*10000h,a3	;this is upper left of block

	movi	tit_lrx+(10000h*400),a4 ;coordinate of lower right of help area
	subxy	a3,a4			   ;this is size of region to blank
	calla	blnkarea		   ;blank out the help area
	addi	box_xgap,a9		   ;return x for help menus
	mmfm	sp,a3,a4,a5,a6
	rets

p_fork
        mmtm    sp,a1
        move    *a13(procid),a1,w    ;pass our id to forked process
        calla   getprc		    ;make the process
	mmfm	sp,a1
	rets


**************************************************************************
*												*
*	  h_slave										*
*												*
*	  this is a process created to plot the help box.			*
*	  it does its plotting then dies.   this allows it			*
*	  to use the pdata area without disturbing the caller.		*
*												*
*	  a8 = pointer to help box structure						*
*	  a9 = left margin for the help box.						*
*	  a10 = y of center of box ...high half is zero for y centing	*
*		if high half is non-zero, then this is top of box		*
*												*
**************************************************************************
hm_just		equ	0
hm_color 	equ	hm_just+word_size
hm_ents		equ	hm_color+word_size
hm_data		equ	hm_ents+word_size 	;entry pointers

hs_rout		equ	pdata			;long-text routine
hs_x		equ	hs_rout+long_size ;word-x for text routine
hs_y		equ	hs_x+word_size	;word-current y
hs_ents		equ	hs_y+word_size	;word-entries left to do
hs_color 	equ	hs_ents+word_size ;word-color of menu
hs_ptr		equ	hs_color+word_size ;long-current text pointer

h_slave
*
*	a9 has right x of menu
*
	move	a9,a1				;put this x value in a1

	move	*a8(hm_just),a0,w		;0 = center  1=left
	jrz	hs_cent 			;center....setup x accordingly
*
*	left justify....store routine
*
	movi	strlnrm,a0			;left justify routin
*
*	now form x as some margin from window....
*
	addi	mb_xwid+help_x_margin,a1	;add margin to form x for text
	jruc	center_join			;continue

hs_cent	movi	strcnrm,a0			;use centering routine
*
*	a1 has left x of help box...find right x
*
	addi	tit_lrx,a1
	srl	1,a1				;this is center x

center_join
	move	a1,*a13(hs_x),w 		;store x
	move	a0,*a13(hs_rout),l		;store routine

	move	*a8(hm_ents),a1,w		;get number of entries
	move	a1,*a13(hs_ents),w		;count it down in p-area

	move	*a8(hm_color),a0,w		;get color
	move	a0,*a13(hs_color),w		;stash it

	addi	hm_data,a8			;point at 1st entry
	move	a8,*a13(hs_ptr),l		;now we're ready.
*
*	all pdata area set.....now we need to draw the border
*
*	  for doborder
*
*	  a4 = upper left y,x									
*	  a5 = lower right y,x								
*	  a0 = y,x width of border							
*	  a9 = color of border. 								
*
*	lower right x is such that it lines up with title box.
*	the y is a bit trickier......number of entries is
*	sitting in a1
*
	movi	help_dy,a5			;distance per entry
	mpyu	a1,a5				;distance for all entries
	addi	help_y_margin+(mb_ywid*2)+help_ylo_margin,a5
*
*	a5 now contains full height of box
*
*	now see if we're centering on a10 or if a10 is the top.
*
	callr	top_in_a10
*
*	now form upper left in a4
*
	move	a10,a4				;move y over
	sll	16,a4				;make room for x
	add	a9,a4				;put in the x...this is upper left!

	add	a10,a5				;add base to offset
	sll	16,a5				;put in y position
	addi	tit_lrx,a5			;add in the x for the corner
*
*	now adjust from top of box to position of
*	1st entry.
*
	addi	mb_ywid+help_y_margin,a10  ;y of 1st entry
	move	a10,*a13(hs_y),w		 ;put away

	move	*a13(hs_color),a9,w		;get the color for doborder

	callr	std_bord
*
*	now we need to walk through and plot the help
*	menu entries.
*
*	a0 = sleep
*	a1 = routine
*	a6 = color
*	a8 = pointer
*	a9 = address
*	a10 = spacing
*	a11 = font
*	a14 = flags
*
next_help
	move	*a13(hs_ptr),a2,l		;get our current pointer
	move	*a2+,a8,l			;get the current message pointer
	move	a2,*a13(hs_ptr),l		;and put pointer back

	clr	a0
	move	*a13(hs_rout),a1,l		;routine in a1
;	 move	 *a13(hs_color),a6,w 	 ;stuff color -- old narc style
        move    *a13(hs_color),a5,w	    ;stuff color
	sll	16,a5

	move	*a13(hs_y),a9,w 		;get y
	sll	16,a9				;shift into place
	move	*a13(hs_x),a10,w
	add	a10,a9				;a9 is now pointing at screen

	movi	spacing07,a10			;spacing
	movi	rd7font,a11			;font is baby font
	jsrp	lm_xfinis			 ;print it out!

	move	*a13(hs_y),a9,w 		;get the y
	addi	help_dy,a9			;kick it
	move	a9,*a13(hs_y),w 		;put it back

	move	*a13(hs_ents),a0,w		;entry count
	dec	a0
	move	a0,*a13(hs_ents),w		;put it back
	jrnz	next_help

	jauc	sucide				;our work is done!

**************************************************************************
*												*
*	  top_in_a10										*
*												*
*	  this is called by h_slave to get the upper left			*
*	  corner of the box in a10.	a10 has the passed parameter. 	*
*	  a5 has the height of the box.  if the top half of a10		*
*	  is zero, then then we want the box center at the			*
*	  a10 level.  if the top half of a10 is non-zero then 		*
*	  a10 was passed as the top. 							*
*												*
*	  return a10 as the y for the top of the help box.			*
*												*
**************************************************************************
top_in_a10
	mmtm	sp,a5
	cmpi	0ffffh,a10			;is the top half zero?
	jrhi	top_is_top			;top is set..return
	srl	1,a5				;top of box is half up from main menu bar center
	sub	a5,a10				;now a10 has y base of box
top_is_top
	mmfm	sp,a5
	rets

**************************************************************************
*												*
*	  areusure										*
*												*
*	  this is called to get a confirmation from the user. 		*
*	  a8 = prompt...this will appear above the "are you sure"		*
*	  a9 = routine to jsrp to do the desired action				*
*	  a10 = message to display confirming completion 			*
*												*
*	  return a0=0 means yes was chosen.						*
*		 a0 .ne. 0 means no								*
*												*
**************************************************************************
areusure
	calla	clr_scrn		;blank it all out!
	move	a9,*a13(pdata),l	;save routine
	move	a10,-*a12,l		;and confirm message

	callr	sure_box

	move	a8,a2			;put message text in safe place
	movi	mess_sure,a8		;setup for title
	calla	lm_setup		;stuff reggies
	move	a2,a8			;get string in there
	jsrp	lm_xfinis		 ;and print it

	movi	m_sure,a8		;now the "are you sure" part
	jsrp	l_mess			;put it up.

	movi	men_yn,a8		;put up the "yes/no" selector.
	movi	2,a9			;cursor on 2nd entry (no)

	jsrp	b_menu			;and get a response.
	cmpi	1,a8			;was it yes?
	jrnz	sure_x			;nope....get out

	calla	clr_scrn		;clear the screen first, so routine can plot!

	move	*a13(pdata),a0,l	;get the routine to call
	movi	sure_ret,a7
	move	a7,-*a12,l		;push return address
	jump	a0			;and "jsrp" the routine

sure_ret callr	sure_box		;box it!
	move	*a12+,a8,l
	jsrp	sur_mess		;print the message

	jsrp	any_but 		;now retrieve any button then return
		
	clr	a0			;return success
	retp

sure_x	addi	long_size,a12		;pop message
	movi	2,a0			;return failure
	retp

**************************************************************************
*												*
*	  sur_mess										*
*												*
*	  this prints message in a8 in the are u sure box			*
*	  confirmation spot.									*
*												*
**************************************************************************
sur_mess
	move	a8,-*a12,l
	movi	mess_confirm,a8
	calla	lm_setup		;get confirmation data ready.
	move	*a12+,a8,l
	jsrp	lm_xfinis		 ;print our part
	retp

sure_box
	movi	trog_yellow,a9
	movi	0003d0025h,a4
	movi	000f6016ah,a5
	callr	std_bord	    ;border-ize the whole thing.
	rets

*
*blank the inside of the "are you sure box"
*
blnk_sure_box
	movi	[41h,29h],a3
	movi	[0f2h,166h]-[41h,29h],a4
	jauc	blnkarea		;its blank!

cent_box
	movi	trog_red,a9
cbox_col
	movi	0006e0030h,a4
	movi	0011a01d0h,a5
	callr	std_bord	    ;border-ize the whole thing.
	rets

**************************************************************************
*											     *
* 		messages								     *
*											     *
**************************************************************************

	.if	screen_wide
instr_y	equ	inst_uly+10
instr_2y equ	instr_y+12
	.else
instr_y	equ	inst_uly+6
instr_2y equ	instr_y+10
	.endif

mm_inst1
*gnp change 5/25/90
	mess_mac  rd7font,spacing07,menu_x,instr_y,trog_prgb,strcnrm,0
	.string   w_select," WITH ANY STICK"
	.byte	0
	.even

mm_inst2
*gnp change 5/25/90
	mess_mac  rd7font,spacing07,menu_x,instr_2y,trog_prgb,strcnrm,0
	.string   "ACTIVATE WITH ANY ",w_button
	.byte	0
	.even

mess_fail
	mess_mac  rd15font,spacing20,256,176,trog_pred,strcnrm,0
	.string  "INVALID ",w_game," ",w_settings
	.byte	0,1			;0 = end of string...1 = more messages!
	.even
	mess_mac  rd15font,spacing20,256,226,trog_pwhite,strcnrm,0
	.string  "ATTEMPT TO RESTORE"
	.byte	0,1			;0 = end of string...1 = more messages!
	.even
	mess_mac  rd15font,spacing20,256,256,trog_pwhite,strcnrm,0
	.string  w_facset,"S HAS FAILED."
	.byte	 0,0
	.even

mess_title
	mess_mac  rd15font,spacing20,tm_x,tm_y,trog_pgreen,strcnrm,0
	
	.if	screen_wide
rv_y	equ	tm_y+25
	.else
rv_y	equ	tm_y+18
	.endif

mess_rev
	mess_mac  rd7font,spacing07,tm_x,rv_y,trog_pyellow,strcnrm,0
*
*	this is setup for the question being asked
*	by "are you sure"
*
mess_sure
	mess_mac  rd15font,spacing20,200,102,trog_plf,strcnrm,0
*
*	this is the "are you sure" part.
*
m_sure
	mess_mac  rd15font,spacing20,200,128,trog_pyellow,strcnrm,0
	.string   "ARE YOU SURE?"
	.byte	   0,0
	.even

mess_confirm
	mess_mac  rd15font,spacing20,200,115,trog_plf,strcnrm,0

siy1	equ	snd_mess_y+30
siy3	equ	snd_mess_y+41
siy2	equ	snd_mess_y+8

snd_inst
	 mess_mac  rd7font,spacing07,200,siy1,trog_pwhite,strcnrm,0
	.string   "PRESS START BUTTON TO REPEAT"
	.byte	  0,1
	.even
	 mess_mac  rd7font,spacing07,200,siy3,trog_pwhite,strcnrm,0
	.string   "ACTION BUTTON FOR NEXT SOUND"
	.byte	  0,0
	.even

snd_setup mess_mac  rd15font,spacing20,200,siy2,trog_plf,strcnrm,0

stable
	.long	dt1
	.long	dt2
	.long	dt3
	.long	dt4
	.long	dt5
	.long	0

dt1	.string	"MAIN TUNE",0
	.even
dt2	.string	"FATALITY",0
	.even
dt3	.string	"RAINBOW",0
	.even
dt4	.string	"DISCO TUNE",0
	.even
dt5	.string	"VS SCREEN",0
	.even

**************************************************************************
*												*
*  sound test table										*
*												*
*  these are the actual codes which are send out to the sound board 	*
*  for the sound test.										*
*												*
**************************************************************************
sctab
	.word	>01	; main tune
	.word	>34	; fatality
	.word	>3A	; rainbow
	.word	>3b	; disco
	.word	>33	; vs screen

last_scode	equ	($-sctab)/16


*
* input a3 = sound code to send
*
send_yam 
	mmtm	sp,a5
	movi	to_y_bd,a5
	move	a3,@snd_made,w		;indicate we made a sound!
	calla	send_code_a3		;send it!
	mmfm	sp,a5
	rets

	.even

rom_name .string   "REVISION 3.0"

	.if printer
	.string   "  (PRINTER)" 	 ; if printer ----> say so
	.endif

	.byte	0
	.even

go_endings
	movi	men_endings,a8
	jauc	gen_menu		;process the utility menu!

men_endings
	.long	rd7font		; font
	.long	strcnrm 	; center please
	.long	txt_octo	; title
	.word	trog_white     	; color of title
	.word	menu_x		; ul x
	.word	menu_y		; ul y
	.word	12	 	; vertical spacing
	.word	trog_white     	; color when not selected
	.word	>0d		; height of selection bar
	.word	-3		; distance of bar from top of text (negative)
	.word	bar_dx		; extra x on each side.
	.word	bar_wid       	; width of bar!
	.word	trog_decay	; text color of selected item

	.long	txt_hh,go_hh,0
	.long	txt_lk,go_lk,0
	.long	txt_jc,go_jc,0
	.long	txt_sa,go_sa,0
	.long	txt_f1,go_f1,0
	.long	txt_f2,go_f2,0
	.long	txt_st,go_st,0
	.long	txt_rd,go_rd,0
	.long	txt_sz,go_sz,0
	.long	txt_rp,go_rp,0
	.long	txt_sc,go_sc,0
	.long	txt_jx,go_jx,0
	.long	0

txt_hh	.string	"KUNG LAO",0
	.even
txt_lk	.string	"LIU KANG",0
	.even
txt_jc	.string	"CAGE",0
	.even
txt_sa	.string	"BARAKA",0
	.even
txt_f1	.string	"KITANA",0
	.even
txt_f2	.string	"MILEENA",0
	.even
txt_st	.string	"SHANG TSUNG",0
	.even
txt_rd	.string	"RAIDEN",0
	.even
txt_sz	.string	"SUB-ZERO",0
	.even
txt_rp	.string	"REPTILE",0
	.even
txt_sc	.string	"SCORPION",0
	.even
txt_jx	.string	"JAX",0
	.even

;*********************************************************************

go_hh	clr	a0
	jruc	end2
go_lk	movk	1,a0
	jruc	end2
go_jc	movk	2,a0
	jruc	end2
go_sa	movk	3,a0
	jruc	end2
go_f1	movk	4,a0
	jruc	end2
go_f2	movk	5,a0
	jruc	end2
go_st	movk	6,a0
	jruc	end2
go_rd	movk	7,a0
	jruc	end2
go_sz	movk	8,a0
	jruc	end2
go_rp	movk	9,a0
	jruc	end2
go_sc	movk	10,a0
	jruc	end2
go_jx	movk	11,a0

end2	push	a0
	calla	murder_myoinit
	movi	>40,a3
	calla	send_code_a3		; start "victory" tune !!!
	pull	a0

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
	jsrp	show_rev_x
	jsrp	oct_team_photos
	calla	murder_myoinit
	jauc	POWERRET

**************************************************************************
*												*
*	menu data for mortal kombat	  							*
*												*
**************************************************************************

**************************************************************************
*												*
*	main test menu and associated data						*
*												*
**************************************************************************

men_main
	.long	rd7font         ;font
	.long	strcnrm 	;center please
	.long	messmain	;title
	.word	trog_white      ;color of title
	.word	menu_x		;ul x
	.word	menu_y		;ul y
	.word	menu_dy-4 	;vertical spacing
	.word	trog_white      ;color when not selected
	.word	bar_hite-6	;height of selection bar
	.word	-7		;distance of bar from top of text (negative)
	.word	bar_dx		;extra x on each side.
	.word	bar_wid         ;width of bar!
	.word	trog_decay	;text color of selected item

	.long	mess_diag,go_diag,diag_help
	.long	mess_coin_aud,go_book,coin_help
	.long	mess_game_aud,go_aud,audit_help
	.long	mess_game_adj,go_adj,adjust_help
	.long	mess_util,go_util,util_help
	.long	mess_volume,go_volume,volume_help
;	.long	m_print,go_print,blnk_help
	.long	mess_exit,0,exit_help		  	; special case!
	.long	0						; end

messmain
	.string   "MORTAL KOMBAT 2 ",w_test," MENU",0
	.even

mess_diag
	.string	"DIAGNOSTIC ",w_test,"S",0
	.even

mess_volume
	.string	"VOLUME ADJUST",0
	.even



mess_coin_aud
	.string	w_coin," ",w_book,"KEEPING"
	.byte	  0
	.even
mess_game_aud
	.string	w_game," ",w_audits
	.byte	  0
	.even

mess_game_adj
	.string	w_game," ",w_adjustment
	.byte	  0
	.even
mess_util
	.string	"UTILITIES"
	.byte	  0
	.even

mess_exit
	.string	"EXIT TEST MENU"
	.byte	  0
	.even

diag_help
	.word	0		; center justify
	.word	trog_blue	; color
	.word	6		; # of entries
	.long	mess_swtest
	.long	mess_diptest
	.long	mess_cputest
	.long	m_stest
	.long	mess_patterns
	.long	u_burnin

coin_help
	.word	0		;center justify
	.word	trog_blue      ;color
	.word	3		;2 entries
	.long	ch_0
	.long	ch_1
	.long	ch_2

audit_help
	.word	0		;center justify
	.word	trog_blue      ;color
	.word	2		;2 entries
	.long	ah_1
	.long	ah_2

adjust_help
	.word	0		;center justify
	.word	trog_blue      ;color
	.word	3		;3 entries
	.long	ad_1
	.long	ad_2
	.long	ad_3

util_help
	.word	0			; center justify
	.word	trog_blue		; color
	.word	5			; 6 entries

;**********************
;	.long	u_opmess
;**********************

	.long	u_clr_cred
	.long	u_clr_coin
	.long	u_clr_aud
	.long	u_hsreset
	.long	u_factory

;*******************************************************************

volume_help
	.word	0		; center justify
	.word	trog_blue	; color
	.word	2		; # of entries
	.long	txt_vh1
	.long	txt_vh2

txt_vh1	.string	"ADJUST THE VOLUME",0
	.even

txt_vh2	.string	"OF THE GAME",0
	.even

;*******************************************************************


exit_help
	.word	0			; center justify
	.word	trog_blue		; color
	.word	1			; 1 entry
	.long	u_end

mess_swtest	     .string w_switch," ",w_test
	.byte	0
	.even
mess_diptest	     .string "DIP ",w_switch," ",w_test
	.byte	0
	.even
mess_cputest	     .string "CPU ",w_board," ",w_test
	.byte	0
	.even
mess_stest
m_stest		     .string "SOUND ",w_board," ",w_test
	.byte	0
	.even

mess_patterns
	.string "MONITOR PATTERNS"
	.byte	0
	.even
mess_burn
u_burnin 	.string "BURN-IN ",w_test
	.byte	0
	.even
ch_0	.string 	"VIEW COINBOX"
	.byte	0
	.even
ch_1	.string 	w_totals," AND"
	.byte	0
	.even
ch_2	.string 	w_game,w_play," COUNTERS"
	.byte	0
	.even

ah_1	.string 	"VIEW ",w_game
	.byte	0
	.even
ah_2	.string 	w_play," STATISTICS"
	.byte	0
	.even

ad_1	.string 	"MAKE CHANGES"
	.byte	0
	.even
ad_2	.string 	"TO PRICING AND"
	.byte	0
	.even
ad_3	.string 	w_game," FEATURES"
	.byte	0
	.even

mess_mm
	.string 	"RETURN TO MAIN MENU"
	.byte		0
	.even

mess_hsreset
u_hsreset
	.STRING "RESET HIGH SCORES"
	.byte	0
	.even


;****************************
;u_opmess 	.string "operator ",w_message
;	.byte	0
;	.even
;****************************


u_factory
	.string w_facset,"S"
	.byte	0
	.even

u_end
	.string "END ",w_test,"ING"
	.byte	0
	.even

**************************************************************************
*									    *
*	sounds system tests menu					 *
*									    *
**************************************************************************

men_stest
	.long	rd7font	;font
	.long	strcnrm	;center please
	.long	m_stest	;title
	.word	trog_green	;color of title
	.word	200		;ul x
	.word	menu_y-3	;ul y
	.word	18	       ;vertical spacing
	.word	trog_red	;color when not selected
	.word	18		;height of selection bar
	.word	-6		;distance of bar from top of text (negative)
	.word	bar_dx		;extra x on each side.
	.word	195		;width of bar!
	.word	trog_decay	;text color of selected item
	.long	m_digt,go_digt,snd_help
	.long	m_synp,go_synp,snd_play
****	    .long   m_digp,go_digp,snd_play
	.if	printer
	.else
	.long	mess_diagm,0,snd_help
	.endif
	.long	mess_mm,force_main,snd_help
	.long	0

m_digt
	.string	"GENERAL ",w_test,0
	.even
m_synp
	.string	w_play," SOUNDS",0
	.even

dac_lx	equ	125

*
*message for sound board irq not working
*
;sirq_err
;	mess_mac rd15font,spacing07,200,95,trog_plf,strcnrm,0
;	.string	"** warning! **",0,1
;	.even
;	mess_mac rd7font,spacing07,200,120,trog_pyellow,strcnrm,0
;	.string	"unable to detect sound board irq.",0,1
;	.even
;	mess_mac rd7font,spacing07,200,135,trog_pyellow,strcnrm,0
;	.string	"this may result in errant sounds.",0,0
;	.even

*
*footnote message to remind us that the irq failed
*
sirq_err2
         mess_mac  rd7font,spacing07,200,168,trog_pred,strcnrm,0
	.string	"ERROR - SOUND IRQ NOT DETECTED.",0,0
	.even

*
*footnote message to tell us that the irq line was checked
*
sirq_detect
         mess_mac  rd7font,spacing07,200,168,trog_pgreen,strcnrm,0
	.string	"SOUND IRQ DETECT FUNCTIONAL.",0,0
	.even

*
*clue operator in on how to tell if his sound board is working
*
dac_lx2  equ     dac_lx+52

dac_err
	mess_mac rd7font,spacing07,200,68,trog_plf,strcnrm,0
	.STRING	"LISTEN FOR TONES:",0,1
	.even
	mess_mac rd7font,spacing07,dac_lx,80,trog_pyellow,strlnrm,0
	.STRING	"0 TONES - CHECK HARDWARE",0,1
	.even
	mess_mac rd7font,spacing07,dac_lx,92,trog_pyellow,strlnrm,0
	.STRING	"1 TONE",0,1
	.even
	mess_mac rd7font,spacing07,dac_lx2,92,trog_pyellow,strlnrm,0
	.STRING	"- SOUND BOARD OK",0,1
	.even
	mess_mac rd7font,spacing07,dac_lx,104,trog_pyellow,strlnrm,0
	.STRING	"2 TONES - BAD U2 CHECKSUM",0,1
	.even
         mess_mac  rd7font,spacing07,dac_lx,116,trog_pyellow,strlnrm,0
	.STRING	"3 TONES - BAD U3 CHECKSUM",0,1
	.even
         mess_mac  rd7font,spacing07,dac_lx,128,trog_pyellow,strlnrm,0
	.STRING	"4 TONES - BAD U4 CHECKSUM",0,1
	.even
         mess_mac  rd7font,spacing07,dac_lx,140,trog_pyellow,strlnrm,0
	.STRING	"5 TONES - BAD U5 CHECKSUM",0,1
	.even
         mess_mac  rd7font,spacing07,dac_lx,152,trog_pyellow,strlnrm,0
	.STRING	"6 TONES - BAD U6 CHECKSUM",0,0
	.even


**************************************************************************
*									    			*
*	diagnostic tests menu						 			*
*									    			*
**************************************************************************

	.if	printer
	.else
men_diag
	.long	rd7font		; font
	.long	strcnrm 	; center please
	.long	mess_diag	; title
	.word	trog_red       	; color of title
	.word	200		; ul x
	.word	menu_y-3	; ul y

;	.word	menu_dy-3	; vertical spacing
	.word	menu_dy-6	; vertical spacing

	.word	trog_red       	; color when not selected

;	.word	bar_hite-4	; height of selection bar
	.word	bar_hite-7	; height of selection bar

	.word	-6	       	; distance of bar from top of text (negative)
	.word	bar_dx		; extra x on each side.
	.word	195		; width of bar!  (a little fatter)
	.word	trog_decay	; text color of selected item (should be decay)

	.long	mess_swtest,go_switch,blnk_help
	.long	mess_diptest,go_dip,blnk_help	
	.long	mess_cputest,go_cpu,blnk_help	
	.long	m_stest,go_stest,blnk_help
	.long	mess_patterns,go_patterns,blnk_help
	.long	mess_burn,go_burn,blnk_help
	.long	mess_mm,0,blnk_help		 ; return to main menu
	.long	0


;**********************************************************
; octupus diagnostics
men_odiag
	.long	rd7font		; font
	.long	strcnrm 	; center please
	.long	mess_diag	; title
	.word	trog_red       	; color of title
	.word	200		; ul x
	.word	menu_y-3	; ul y
	.word	menu_dy-6	; vertical spacing
	.word	trog_red       	; color when not selected
	.word	bar_hite-7	; height of selection bar

	.word	-6	       	; distance of bar from top of text (negative)
	.word	bar_dx		; extra x on each side.
	.word	195		; width of bar!  (a little fatter)
	.word	trog_decay	; text color of selected item (should be decay)
	.long	mess_swtest,go_switch,blnk_help
	.long	mess_diptest,go_dip,blnk_help	
	.long	mess_cputest,go_cpu,blnk_help	
	.long	m_stest,go_stest,blnk_help
	.long	mess_patterns,go_patterns,blnk_help
	.long	mess_mm,0,blnk_help		 ; return to main menu
	.long	0
;**********************************************************

	.endif

rom_lev	equ	3		;test number following rom test
rtr_lev	equ	4		;test number following cpu test (for return)

**************************************************************************
*											     *
* 	bookkeeping									     *
*											     *
**************************************************************************

**************************************************************************
*												*
*	  audit table structure 								*
*												*
**************************************************************************

aud_mess 	equ	0				;long-ptr to text
aud_routine	equ	aud_mess+long_size	;long - non zero means call for number
aud_number	equ	aud_routine+long_size	;word - if above zero, then audit number
aud_t_size	equ	aud_number+word_size

amac	$macro	mess,rout,audit
	.long	:mess:
	.long	:rout:
	.word	:audit:
	$end

aud_lm		equ	tit_ulx 	;square off audits w/ header.
aud_rm		equ	tit_lrx
aud_y_start	equ	58
aud_dy		equ	18

cp2_y		equ	142		;part 2 of coin audit page.

mes_book
	.string w_coin,"  ",w_book,"KEEPING"
	.byte	0
	.even

mes_octo:
	.STRING	"OCTOPUS BOOKKEEPING",0
	.even

mes_totals
	.string	w_total," ",w_collection,0
	.even

*
*	detailed coinage available (on 1st coinage page)
*

men_detail
	.long	rd7font 	;font
	.long	strcnrm 	;center please
	.long	mess_patterns		 ;title
	.word	trog_yellow	  ;color of title
	.word	200		;ul x	 (center it!)
	.word	227		;ul y
	.word	12		;vertical spacing
	.word	trog_blue      ;color when not selected
	.word	12		;height of selection bar
	.word	-2		;distance of bar from top of text (negative)
	.word	bar_dx		;extra x on each side.
	.word	170		;width of bar!
	.word	trog_decay     ;text color of selected item
	.long	mess_detail,0,no_help			;detailed section
	.long	mess_mm,force_main,no_help   ;return to main menu
	.long	0

mess_detail
	.STRING 	"MORE DETAILED DATA"
	.byte		0
	.even

*
*	top half of coin audit page 1 table
*
coin_auds
        .word   aud_y_start		;y start
        .word   16		 ;y between entries
        .word   aud_lm			;left margin x
        .word   aud_rm			;right margin x
	amac	m_lcoin,0,audlcoin
	amac	m_rcoin,0,audrcoin
	amac	m_ccoin,0,audccoin
	amac	m_4coin,0,aud4coin
	amac	m_scoin,0,audscoin
	amac	m_paidc,0,audpaidc
;	amac	m_start,starts,0
	amac	m_plays,doplays,0
;	amac	m_hsleft,dohsleft,0
        .long   0


;octo_auds2
;	.word	aud_y_start+10		; y start
;	.word	16			 ; y between entries
;	.word	aud_lm			 ; left margin x
;	.word	aud_rm			 ; right margin x
;        .long   0


*
*	bottom half of coin audit page 1 table
*
m_lcoin
        .string w_left," ",w_slot," ",w_coins,0
        .even

m_ccoin	
        .string "third ",w_slot," ",w_coins,0
        .even

m_rcoin	
        .string w_right," ",w_slot," ",w_coins,0
        .even
m_4coin	
        .string	w_fourth," ",w_slot," ",w_coins,0
        .even

m_scoin .string	"SERVICE ",w_credits
        .byte	0
        .even

m_paidc .string "PAID ",w_credits
        .byte   0
        .even

m_hibattle	
	.STRING	"HIGHEST BATTLE REACHED",0
	.even

m_watchdog
	.string	"WATCHDOGS",0
	.even

m_ws_reset
	.STRING	"WINNING STREAK RESET COUNT",0
	.even

m_cont	.string w_games," CONTINUED"
	.byte	0
	.even

m_plays	.string w_total," ",w_plays
	.byte	0
	.even

m_hsleft .string w_plays," UNTIL H.S. RESET"
	.byte	0
	.even

m_hsoff	.string "OFF"
	.byte	0
	.even
*
*	audit text
*
mess_error
	mess_mac  rd7font,spacing07,0,0,trog_pred,strlnrm,0
	.string   "  ",w_error
	.byte	  0
	.even

mess_aud_num
	mess_mac  rd7font,spacing07,367,227,trog_pyellow,strrnrm,0

mess15_aud_num
	mess_mac  rd15font,spacing07,367,227,trog_pyellow,strrnrm,0

mess_aud_line
	mess_mac  rd7font,spacing07,30,355,trog_pyellow,strlnrm,0

mess15_aud_line
	mess_mac  rd15font,spacing07,30,355,trog_pyellow,strlnrm,0


mes_aud	.string w_game," ",w_audits
	.byte	0
	.even

dt_y1	equ	13
dt_y2	equ	122

detail_titles
	mess_mac  rd15font,spacing20,197,dt_y1,trog_pyellow,strcnrm,0
	.string w_total," ",w_collection
	.byte	0,0
	.even

**************************************************************************
*												*
*	  coin_d1										*
*												*
*	  this is top half of detailed coin audit page				*
*	  its the same as the other coin page with the y positioning	*
*	  a little different									*
*												*
**************************************************************************
coin_d1
	.word	aud_y_start+10
        .word   24		    ;y between entries
	.word	aud_lm			 ;left margin x
	.word	aud_rm			 ;right margin x
	amac	m_lcoin,0,audlcoin
	amac	m_rcoin,0,audrcoin
	amac	m_ccoin,0,audccoin
	amac	m_4coin,0,aud4coin
	amac	m_totcol,do_money,0
	.long	0

coin_sd1
	.word	aud_y_start+10
        .word   24		    ;y between entries
	.word	aud_lm			 ;left margin x
	.word	aud_rm			 ;right margin x
	amac	m_lcoin,0,audlcoin
	amac	m_rcoin,0,audrcoin
	amac	m_ccoin,0,audccoin
	amac	m_4coin,0,aud4coin
	.long	0

*
*	door closed audits.
*
m_totcol
	.string	w_total," ",w_collection,0
	.even

mess_clear_subs
	.string 	w_clear," ",w_coincounts
	.byte		0
	.even

mess_subs_clear
	.string 	w_coincounts," ",w_clear,"ed"
	.byte		0
	.even

mess_yes
	.string 	"YES"
	.byte		0
	.even

mess_no	.string 	"NO"
	.byte		0
	.even


*
*	clear sub-totals (on detailed coinage page)
*

men_clr_sub
	.long	rd7font 	;font
	.long	strcnrm 	;center please
	.long	mess_patterns		 ;title
	.word	trog_yellow	  ;color of title
	.word	200		;ul x	 (center it!)
	.word	230	       ;ul y
	.word	12		;vertical spacing
	.word	trog_blue      ;color when not selected
	.word	12		;height of selection bar
	.word	-2		;distance of bar from top of text (negative)
	.word	bar_dx		;extra x on each side.
	.word	170		;width of bar!
	.word	trog_decay     ;text color of selected item
	.long	mess_clear_subs,0,no_help 		;clear sub-totals
	.long	mess_mm,force_main,no_help   ;return to main menu
	.long	0

*
*	yes/no	 (for are you sure?)
*

men_yn	.long	rd7font        ;font
	.long	strcnrm 	;center please
	.long	mess_patterns		;title
	.word	trog_red       ;color of title
	.word	200		;ul x
	.word	166		;ul y
	.word	17		;vertical spacing
	.word	trog_yellow    ;color when not selected
	.word	17		;height of selection bar
	.word	-4		;distance of bar from top of text (negative)
	.word	bar_dx		;extra x on each side.
	.word	78	       ;width of bar!	(a little fatter)
	.word	trog_decay	;text color of selected item
	.long	mess_yes,0,no_help
	.long	mess_no,0,no_help
	.long	0

**************************************************************************
*												*
*	  game play audit screen								*
*												*
**************************************************************************
octo_auds
	.word	>3e			 	; y start
	.word	>0c			 	; y between entries
	.word	aud_lm			 	; left margin x
	.word	aud_rm			 	; right margin x

	amac   m_secbac,0,aud_secbad
	amac   m_traps,0,aud_traps	 	; boon error traps
	amac   m_syslock,0,aud_syslock	; system "lockups"
	amac   m_illop,0,aud_illop		; illegal opcodes

	amac   m_ontime,do_on_time,0
	amac   m_1time,do_p1time,0
	amac   m_2time,do_p2time,0
	amac   m_plays,doplays,0		; plays on top
	amac   m_conts1,0,aud_continue1
	amac   m_conts2,0,aud_continue2
	amac   txt_clue,0,aud_clue
        .long   0


game_aud1
        .word   61			; y start
        .word   16			; y between entries
        .word   aud_lm			; left margin x
        .word   aud_rm			; right margin x
	amac   m_ontime,do_on_time,0
	amac   m_1time,do_p1time,0
	amac   m_2time,do_p2time,0
	amac   m_plays,doplays,0		; plays on top
	amac   txt_game_starts,0,aud_game_starts
	amac   m_hibattle,0,aud_hibattle
	amac   m_conts1,0,aud_continue1
	amac   m_conts2,0,aud_continue2
	amac   m_burnin,0,audauto
        .long   0


game_aud2
        	.word   61			; y start
        	.word   12			; y between entries
        	.word   aud_lm			; left margin x
        	.word   aud_rm			; right margin x
	amac	txt_choose_hh,0,aud_choose_hh
	amac	txt_choose_lk,0,aud_choose_lk
	amac	txt_choose_jc,0,aud_choose_jc
	amac	txt_choose_sa,0,aud_choose_sa
	amac	txt_choose_fn1,0,aud_choose_fn1
	amac	txt_choose_fn2,0,aud_choose_fn2
	amac	txt_choose_st,0,aud_choose_st
	amac	txt_choose_rd,0,aud_choose_rd
	amac	txt_choose_sz,0,aud_choose_sz
	amac	txt_choose_rp,0,aud_choose_rp
	amac	txt_choose_sc,0,aud_choose_sc
	amac	txt_choose_jx,0,aud_choose_jx
        .long   0

game_aud3
        .word   61			; y start
        .word   14			; y between entries
        .word   aud_lm			; left margin x
        .word   aud_rm			; right margin x
	amac   m_hibattle,0,aud_hibattle
	amac   m_ws_reset,0,aud_ws_reset
	amac   txt_sec_powerup,0,aud_sec_powerup
	amac   m_watchdog,0,aud_watchdog

	amac   txt_smoke,0,aud_found_smoke
	amac   txt_jade,0,aud_found_jade
	amac   txt_noob,0,aud_found_noob
	amac   txt_kano,0,aud_secbad
        .long   0


*
*	next audit page
*
men_ap1	.long	rd7font 	;font
	.long	strcnrm 	;center please
	.long	mess_patterns		 ;title
	.word	trog_yellow	  ;color of title
	.word	200		;ul x	 (center it!)
	.word	227		;ul y
	.word	12		;vertical spacing
	.word	trog_blue      ;color when not selected
	.word	12		;height of selection bar
	.word	-2		;distance of bar from top of text (negative)
	.word	bar_dx		;extra x on each side.
	.word	170		;width of bar!
	.word	trog_decay     ;text color of selected item
	.long	mess_topage2,0,no_help			 ;detailed section
	.long	mess_mm,force_main,no_help   ;return to main menu
	.long	0
*
*	previous audit page?  (on 2nd game audit page)
*
men_ap2	.long	rd7font 	;font
	.long	strcnrm 	;center please
	.long	mess_patterns		 ;title
	.word	trog_yellow	  ;color of title
	.word	200		;ul x	 (center it!)
	.word	217		;ul y
	.word	12		;vertical spacing
	.word	trog_blue      ;color when not selected
	.word	12		;height of selection bar
	.word	-2		;distance of bar from top of text (negative)
	.word	bar_dx		;extra x on each side.
	.word	170		;width of bar!
	.word	trog_decay     ;text color of selected item
	.long	mess_topage2,0,no_help			 ;detailed section
	.long	mess_backp1,0,no_help			;detailed section
	.long	mess_mm,force_main,no_help   ;return to main menu
	.long	0

*
*	previous audit page?  (on 2nd game audit page)
*
;men_ap3	.long	rd7font 	;font
;	.long	strcnrm 	;center please
;	.long	mess_patterns		 ;title
;	.word	trog_yellow	  ;color of title
;	.word	200		;ul x	 (center it!)
;	.word	227		;ul y
;	.word	12		;vertical spacing
;	.word	trog_blue      ;color when not selected
;	.word	12		;height of selection bar
;	.word	-2		;distance of bar from top of text (negative)
;	.word	bar_dx		;extra x on each side.
;	.word	170		;width of bar!
;	.word	trog_decay     ;text color of selected item
;	.long	mess_backp1,0,no_help			;detailed section
;	.long	mess_mm,force_main,no_help   ;return to main menu
;	.long	0


mess_topage2
	.string 	"NEXT ",w_audit," PAGE"
	.byte		0
	.even

mess_backp1
	.string 	"PREVIOUS ",w_audit," PAGE"
	.byte		0
	.even

m_burnin
	.STRING	"BURNIN LOOPS SUCCESSFULLY COMPLETED",0
	.even

txt_kano
	.string	"KANO TRANSFORMATIONS",0
	.even

txt_game_starts
	.STRING	"GAMES STARTED",0
	.even

txt_sec_powerup
	.STRING	"SHAWN ATTACKS",0
	.even

m_conts1
	.STRING	"1 PLAYER CONTINUES TAKEN",0
	.even

m_conts2
	.STRING	"2 PLAYER CONTINUES TAKEN",0
	.even

;**********************************************************************

txt_clue
	.string	"CLUE COUNTER",0
	.even
txt_jade
	.string	"BATTLES WITH JADE",0
	.even
txt_smoke
	.string	"BATTLES WITH SMOKE",0
	.even
txt_noob
	.string	"BATTLES WITH NOOB SAIBOT",0
	.even
txt_choose_hh
	.string	"KUNG LAO CHOSEN",0
	.even
txt_choose_lk
	.string	"LIU KANG CHOSEN",0
	.even
txt_choose_jc
	.string	"JOHNNY CAGE CHOSEN",0
	.even
txt_choose_sa
	.string	"BARAKA CHOSEN",0
	.even
txt_choose_fn1
	.string	"KITANA CHOSEN",0
	.even
txt_choose_fn2
	.string	"MILEENA CHOSEN",0
	.even
txt_choose_st
	.string	"SHANG TSUNG CHOSEN",0
	.even
txt_choose_rd
	.string	"RAIDEN CHOSEN",0
	.even
txt_choose_sz
	.string	"SUBZERO CHOSEN",0
	.even
txt_choose_rp
	.string	"REPTILE CHOSEN",0
	.even
txt_choose_sc
	.string	"SCORPION CHOSEN",0
	.even
txt_choose_jx
	.string	"JAX CHOSEN",0
	.even

;**********************************************************************

m_ontime
	.STRING	"HOURS GAME WAS ON",0
	.even
m_1time
	.STRING	"HOURS PLAYED WITH 1 PLAYER",0
	.even
m_2time
	.STRING	"HOURS PLAYED WITH 2 PLAYERS",0
	.even
m_traps 
	.STRING "ERROR TRAPS",0
	.even
m_secbac
	.STRING	"SEC CHIP FAILURE",0
	.even
m_syslock
	.STRING	"SYSTEM LOCKUPS",0
	.even
m_illop
	.STRING	"ILLEGAL OPCODES",0
	.even
m_conttak
	.string	w_game," ",w_continue,"S TAKEN",0
	.even
m_slams
	.string	w_coin," DOOR SLAMS",0
	.even

**************************************************************************
*									    			*
*	utilities menu							 			*
*									    			*
**************************************************************************

*
*	utilites menu goes left of center
*

um_wid	equ	206
um_x	equ	tit_ulx+gap+mb_xwid+(um_wid/2)+c_kludge

men_util .long	rd7font        ;font
	.long	strcnrm 	;center please
	.long	mess_util	 ;title
	.word	trog_white	;color of title
	.word	um_x		;ul x
	.word	menu_y-5	;ul y
	.word	18	       ;vertical spacing
	.word	trog_white	;color when not selected
	.word	19		;height of selection bar
	.word	-5		;distance of bar from top of text (negative)
*	 .word	 bar_hite	 ;height of selection bar
*	 .word	 bar_dy 	 ;distance of bar from top of text (negative)
	.word	bar_dx		;extra x on each side.
	.word	um_wid		;width of bar!
	.word	trog_decay	;text color of selected item

;********************
;	.long	mess_opmess,do_opmess,opmess_help
;********************
	.long	mess_clcred,do_clcred,clcred_help
	.long	mess_clcoin,do_clcoin,clcoin_help
	.long	mess_claud,do_claud,claud_help
	.long	mess_hsreset,do_hsres,hsres_help
	.long	mess_def_adj,do_def_adj,def_adj_help
	.long	mess_facset,do_facset,facset_help
	.long	mess_mm,0,blnk_help		 	; return to main menu
	.long	0					; end


mess_clcred
u_clr_cred	.string w_clear," ",w_credits
	.byte	0
	.even

mess_ccconf	.string w_credits," ",w_clear,"ed"
	.byte	0
	.even

mess_clcoin
u_clr_coin	.string w_clear," ",w_coincounts
	.byte	0
	.even

mess_claud
u_clr_aud	.string w_clear," ",w_game," ",w_audits
	.byte	0
	.even

;********************************
;m_set_omess
;mess_opmess	.string "set operator ",w_message
;	.byte	0
;	.even
;********************************


mess_facset    
	.STRING "FULL FACTORY RESTORE"
	.byte	0
	.even

mess_facfail
	.STRING  "FAILURE IN CMOS RAM"
	.byte	 0
	.even

mess_cancelled
	.STRING "CANCELLED"
	.byte	0
	.even


mess_def_adj   
	.string "default ",w_adjustments
	.byte	0
	.even

*
*	help for utility menu
*
clcred_help
	.word	0		;center justify
	.word	trog_blue      ;color
	.word	3		;2 entries
	.long	meh_clcred1
	.long	meh_clcred2
	.long	meh_clcred3

clcoin_help
	.word	0		;center justify
	.word	trog_blue      ;color
	.word	4		;2 entries
	.long	meh_clcoin1
	.long	meh_clcoin2
	.long	meh_clcoin3
	.long	meh_clcoin4

claud_help
	.word	0		;center justify
	.word	trog_blue      ;color
	.word	2		;2 entries
	.long	meh_claud1
	.long	meh_claud2

hsres_help
	.word	0		;center justify
	.word	trog_blue      ;color
	.word	3		;2 entries
	.long	meh_reshs1
	.long	meh_reshs2
	.long	meh_reshs3

;*******************
;opmess_help
;	.word	0		;center justify
;	.word	trog_blue      ;color
;	.word	4		;2 entries
;	.long	meh_cusm1
;	.long	meh_cusm2
;	.long	meh_cusm3
;	.long	meh_cusm4
;*******************

def_adj_help
	.word	0		;center justify
	.word	trog_blue      ;color
	.word	4		;2 entries
	.long	meh_defa1
	.long	meh_defa2
	.long	meh_defa3
	.long	meh_defa4

facset_help
	.word	0		;center justify
	.word	trog_blue      ;color
	.word	3		;2 entries
	.long	meh_fac1
	.long	meh_fac2
	.long	meh_fac3

;**************************************************************************

sec_random_trash
	movk	5,a0
	calla	randu
	dec	a0
	sll	5,a0
	addi	trash_table,a0
	move	*a0,a0,l
	jump	a0

trash_table
	.long	trash_1
	.long	trash_2
	.long	trash_3
	.long	trash_4
	.long	trash_5

dumnum1	.set	>4598ff
dumnum2	.set	>3995d1
dumnum3	.set	>556660

trash_1	clr	a14
	movi	p1_bar+dumnum1,a3
	movi	p2_bar-dumnum2,a4
	subi	dumnum1,a3
	addi	dumnum2,a4
	move	a14,*a3,w
	move	a14,*a4,w
	jruc	post_trash

trash_2	movi	p1_bar+dumnum1,a4
	subi	dumnum1,a4
	move	a14,*a4,w
	jruc	post_trash

trash_3	movi	p2_bar+dumnum2,a4
	subi	dumnum2,a4
	move	a14,*a4,w
	jruc	post_trash

trash_4	sleep	1
	jruc	trash_4			; hang sans locking up

trash_5	move	@p1_char,a0,l
	move	@p2_char,a1,l
	move	a1,@p1_char,l
	move	a1,@p2_char,l
	jruc	post_trash

post_trash
	movi	post_sec_trash-dumnum3,a14
	addi	dumnum3,a14
	jump	a14

**************************************************************************
*												*
*	  strings for utility help menus							*
*												*
**************************************************************************

meh_clcred1     
		.STRING "REMOVE ANY" 
		.byte	0
		.even
meh_clcred2	.string "POSTED ",w_credits
		.byte	0
		.even
meh_clcred3	.string "FROM THE ",w_game
		.byte	0
		.even
meh_clcoin1	.string w_clear," OUT PAID"
		.byte	0
		.even
meh_clcoin2	.string w_credits," ",w_total
		.byte	0
		.even
meh_clcoin3	.string "and the ",w_coin
		.byte	0
		.even
meh_clcoin4	.string w_slot," COUNTERS"
		.byte	0
		.even
meh_claud1	.string w_clear," ",w_game,w_play
		.byte	0
		.even
meh_claud2	.string "STATISTICS"
		.byte	0
		.even
meh_reshs1	.string "RESET HIGH SCORE"
		.byte	0
		.even
meh_reshs2	.string "TABLE TO FACTORY"
		.byte	0
		.even
meh_reshs3	.string "DEFAULT VALUES"
		.byte	0
		.even

;********************************************
;meh_cusm1	.string "enter your own"
;		.byte	0
;		.even
;meh_cusm2	.string w_message," to"
;		.byte	0
;		.even
;meh_cusm3	.string "appear in the"
;		.byte	0
;		.even
;meh_cusm4	.string "attract mode"
;		.byte	0
;		.even
;********************************************

meh_defa1	.string "SET ALL ",w_game
		.byte	0
		.even
meh_defa2	.string w_adjustments," TO"
		.byte	0
		.even
meh_defa3	.string "THEIR FACTORY"
		.byte	0
		.even
meh_defa4	.string "DEFAULT VALUE"
		.byte	0
		.even
meh_fac1 	.string "RESET ALL ",w_audits,","
		.byte	0
		.even
meh_fac2 	.string "COUNTERS, ",w_adjustments
		.byte	0
		.even
meh_fac3 	.string "AND THE HIGH SCORES."
		.byte	0
		.even

**************************************************************************
*									    *
*	press any button to continue					 *
*									    *
**************************************************************************

any_menu
	.long	rd7font        ;font
	.long	strcnrm 	;center please
	.long	0		;title
	.word	0		;color of title
	.word	200		;ul x
	.word	195	       ;ul y
	.word	menu_dy 	;vertical spacing
	.word	trog_blue      ;color when not selected
	.word	bar_hite	;height of selection bar
	.word	bar_dy		;distance of bar from top of text (negative)
	.word	bar_dx		;extra x on each side.
	.word	234		;width of bar!
	.word	trog_decay	;text color of selected item
	.long	mess_any,0,no_help	
	.long	0

mess_any
	.string 	"ANY ",w_button," TO ",w_continue
	.byte		0
mess_ffsconf
mess_fac mess_mac  rd7font,spacing07,200,96,trog_pwhite,strcnrm,0
mess_defconf
	.string   "DEFAULT ADJUSTMENTS RESTORED."
	.byte	  0,1
	.even
	mess_mac  rd7font,spacing07,200,112,trog_pyellow,strcnrm,0
	.even
mess_ccnconf
	.string  "COIN COUNTERS CLEARED."
	.byte	0,1			;0 = end of string...1 = more messages!
	.even
	mess_mac  rd7font,spacing07,200,128,trog_pblue,strcnrm,0
mess_caudconf
	.string	"GAME AUDITS CLEARED."
	.byte	 0,0
;	.byte	 0,1
	.even


	mess_mac  rd7font,spacing07,200,144,trog_pred,strcnrm,0
mess_hsrconf
	.string  "HIGH SCORE TABLE RESET."
	.byte	 0,0
	.even

*
*	monitor patterns
*

	.if	printer
	.else

men_patterns
	.long	rd7font        ;font
	.long	strcnrm 	;center please
	.long	mess_patterns		 ;title
	.word	trog_red    ;color of title
	.word	200		;ul x	 (center it!)
	.word	menu_y-3	;ul y
	.word	20		;vertical spacing
	.word	trog_yellow    ;color when not selected
	.word	20		;height of selection bar
	.word	-6	       ;distance of bar from top of text (negative)
	.word	bar_dx		;extra x on each side.
	.word	234		;width of bar!
	.word	trog_decay	;text color of selected item
	.long	mess_red,go_red,blnk_help
	.long	mess_green,go_green,blnk_help
	.long	mess_blue,go_blue,blnk_help
	.long	mess_bars,go_bars,blnk_help
	.long	mess_cross,go_conv,blnk_help
	.long	mess_diagm,0,blnk_help
	.long	mess_mm,force_main,no_help	   ;return to main menu
	.long	0

mess_red 	.string "RED ",w_screen
	.byte	0
	.even
mess_green	.string "GREEN ",w_screen
	.byte	0
	.even
mess_blue	.string "BLUE ",w_screen
	.byte	0
	.even
mess_bars
	.string "COLOR BARS"
	.byte	0
	.even
mess_cross
	.string "CROSSHATCH  PATTERN"
	.byte	0
	.even
mess_diagm
	.string "BACK TO DIAGNOSTICS MENU"
	.byte	0
	.even
	.endif

null_st
	.byte	0
	.even

	.if	printer
**************************************************************************
*									    *
*	audit printing tables						 *
*									    *
**************************************************************************

pamac	$macro	text,adjust,format
	.long	:text:
	.word	:adjust:
	.word	:format:
	$end

;
;	format
;
;		0 = straight number
;		1 = time
;		2 = total number of plays ( gross, huh? )
;

printaudtable:
	pamac	m_plays,0,2		;plays on top
	pamac	m_1time,aud_1time,1
	pamac	m_2time,aud_2time,1

;	pamac	m_traps,aud_traps,0		; boon error traps
;	pamac	m_syslock,0,aud_syslock	; system "lockups"
;	pamac	m_illop,0,aud_illop		; illegal opcodes
;	pamac	m_1time,aud_1time,1
;	pamac	m_2time,aud_2time,1

	.long	0

printcointable:
	pamac	m_lcoin,audlcoin,0
;	pamac	m_rcoin,audrcoin,0
;	pamac	m_ccoin,audccoin,0
;	pamac	m_4coin,aud4coin,0
;	pamac	m_scoin,audscoin,0
;	pamac	m_paidc,audpaidc,0
	.long	0

	.endif

