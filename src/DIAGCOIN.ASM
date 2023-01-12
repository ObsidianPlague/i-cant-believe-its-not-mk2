	.file	'diagcoin.asm'
	.title	"<<< coin handling routines >>>"
	.width	132
	.option	b,d,l,t
	.mnolist

**************************************************************************
*												*
*	copyright (c) 1990 williams electronics games, inc.			*
*	all rights reserved.									*
*												*
**************************************************************************
	.include	"dispequ.asm"		;display processor equates
	.include	"sysequ.asm"		;system equates
	.include	"mainequ.asm"
	.include	"imgtbl.glo"
	.include	"stringh.asm"
	.include	"diagsequ.asm"
	.include	"diagmequ.asm"
	.include	"diagaudn.asm"
	.include	"dipequ.asm"
	.include	macros.hdr
	.include	bgndtbl.glo

	.def	rcoin,lcoin,ccoin,xcoin, scoin,slam, coinint, no_creds
	.def	get_cstr, checkfree
	.def	coinflag, timeint, coin_page
	.def	cat_a0, strcat
	.def	cred_p
	.def	cred_string
	.def	octo_flag
	.def	gameunits
	.def	change_oid,coin_mess2
	.def	get_credits,adjust_credits

	.ref	def_page, set_page
	.ref	rc_byte, rc_bytei, rc_word, rc_wordi
	.ref	wc_byte, wc_bytei, wc_word, wc_wordi
	.ref	amode
	.ref	wipeout
	.ref	p_fork, adj_page
	.ref	checkdipfree, read_dip, forcedip
	.ref	g_cred
	.ref	get_cspt
	.ref	aud1, store_audit, get_aud
	.ref	on_hstd, tamperedp
	.ref	diag_myoinit, diag_colors

	.if	printer
	.ref	plcoin,prcoin,pscoin
	.endif

**************************************************************************
*									    			*
*	global variables						 			*
*									    			*
**************************************************************************
	.bss	c_flags,4*32		; interrupt coin bounce

	.bss	top_pcount,0
	.bss	ctrleft,16		; for the coin counters
	.bss	ctrright,16
	.bss	secram,16
	.bss	coinflag,16
	.bss	gameunits,16		; units used per current game
	.bss	timecnt,16		; time counter
	.bss	subtimecnt,16		; yet another timer counter
	.bss	ctimeaud,4*16		; credit time audits
	.bss	octo_flag,16		; octopus flag
	.bss	text_buff,(8*25)
	.bss	ramtemp1,32
	.bss	ramtemp2,32
	.bss	ramtemp3,32
	.bss	ramtemp4,32

**************************************************************************
*									    			*
*	coin equates							 			*
*									    			*
**************************************************************************

lc_flag	equ	c_flags
rc_flag	equ	c_flags+8
cc_flag	equ	rc_flag+8
xc_flag	equ	cc_flag+8

run_time equ	32		;2nd long word counts down long time
opens_left equ	run_time+32	;3rd long word counts down consec opens

pulse_max	equ	700/16	;frames till its too line.
min_opens	equ	4
acc_limit	equ	80h	;after 2 seconds of no-reply....re-set flag!
coin_sbit	equ	0
coin_succ_bit	equ	1
coin_fail_bit	equ	2
coin_ack_bit	equ	3

coin_sflag	equ	1
coin_succ_val	equ	2
coin_fail_val	equ	4
coin_ack_val	equ	8

coinenable	equ	0000h		; currently backwards!
coindisable	equ	0100h		; ha!
leftcoin		equ	0100h		; left coin mask
rightcoin	equ	0200h		; right coin mask

	.text
	.even

**************************************************************************
*											     *
* 	clickleft									     *
* 											     *
* 	click the left coin counter							     *
* 											     *
* 	entry -	nothing									     *
* 											     *
* 	exit  -	nothing									     *
*											     *
**************************************************************************
clickleft:
	mmtm	sp,a0,a1,a7
singleclick
	move	@ctrleft,a0,w
	inc	a0
	move	a0,@ctrleft,w

make_cc_proc
	callr	coinctr_p		; check to see if process exists
	jrne	clret
	create	pid_coinctr,coincounter
clret	mmfm	sp,a0,a1,a7
	rets

**************************************************************************
*											     *
* 	clickright									     *
* 											     *
* 	click the right coin counter							     *
* 											     *
* 	entry -	nothing									     *
* 	exit -	nothing									     *
*											     *
**************************************************************************
clickright:
	mmtm	sp,a0,a1,a7
	calla	read_dip
	andi	dip_counter,a0		; check for dual counters
	jrz	singleclick		; combined counter
	move	@ctrright,a0,w
	inc	a0
	move	a0,@ctrright,w
	callr	coinctr_p		; check to see if process exists
	jrne	crret

	create	pid_coinctr,coincounter

crret	mmfm	sp,a0,a1,a7
	rets

**************************************************************************
*											     *
* 	coincounter									     *
* 											     *
* 	process that deals with the coin counter				     *
* 											     *
* 	entry	nothing									     *
* 											     *
* 	exit	nothing									     *
*											     *
**************************************************************************
coincounter
	clr	a8
	move	@ctrleft,a1,w
	jrz	cc1
	movi	left_coin,a8
	dec	a1
	move	a1,@ctrleft,w
cc1
	move	@ctrright,a1,w
	jrz	cc2
	ori	right_coin,a8
	dec	a1
	move	a1,@ctrright,w
cc2
	move	a8,a8
	jrz	ccdie			; both were empty

	calla	read_dip
	andi	dip_counter,a0
	jrnz	cc3
   	ori	right_coin,a8
	ori	left_coin,a8		; make sure both trigger

cc3	move	a8,a0
	calla	counter_on

	sleep	7			; this sucks, but cary likes it

	move	a8,a0
	calla	counter_off

	sleep	7			; give them time to be off
	jruc	coincounter
ccdie
	die

**************************************************************************
*											     *
* 	coinctr_p									     *
* 											     *
* 	is there a coin counter process running				     *
* 											     *
* 	entry	nothing									     *
* 											     *
* 	exit	.eq.	no								     *
* 		.ne.	yes								     *
*											     *
**************************************************************************
coinctr_p
	movi	pid_coinctr,a0		; coin counter process
         movi    0ffffh,a1
         calla   existp
	rets


amode_coin_page
	clr	a0
	move	a0,@coinflag,w		; flag: coin page not already up
	jruc	coin_page


coin_page_jump
	clr	a0
	move	a0,@irqskye,w		; erase color = black
	move	a0,@noflip,w		; back to normal page flipping
	movk	1,a0			
	move	a0,@displayon,w		; make sure display system is on
	move	a0,@f_auto_erase,w
	calla	dont_show_scores
	jsrp	coin_page
	jauc	amode

**************************************************************************
*											     *
* 	coin_page									     *
* 											     *
* 	plot the appropriate coin page -- destroy anything that	     *
* 	happens to be around at the time						     *
* 											     *
* 	entry	nothing									     *
* 	exit	nothing									     *
*											     *
**************************************************************************
coin_page:
	move	@coinflag,a0,w		; are we already on the coin page?
	jrnz	cp1			; br = yes, don't replot

	calla	murder_myoinit
	calla	coin_page_bgnd

	movk	1,a0
	move	a0,@coinflag,w		; flag the coin page on

cp1	movi	oid_text,a0
	calla	dallobj

	callr	output_custom		; output custom message if necessary

	movi	coin_mess,a8
	move	a2,a2
	jrnz	cs2
	movi	coin_mess2,a8

cs2	calla	lm_setup
	callr	get_cstr		; get the current credits
	jsrp	printf
*
* ready for 1-4 players / press start
*
	move	*a13(procid),a0,w
	calla	dallprc 		; only one "flashing" dude at once
	jsrp	add_prompt

	callr	checkfree
	jrnz	cs_nosc

	movi	suffix_bs,a14
	move	a14,@ramtemp2,l
	movi	adjcstrt,a0		; credits to start
	calla	get_adj	
	move	a0,@ramtemp1,l
	cmpi	1,a0
	jrne	rp_tostart
	movi	suffix_null,a14
	move	a14,@ramtemp2,l
rp_tostart
*print the credits required to continue
	movi	suffix_bs,a14
	move	a14,@ramtemp4,l
	movi	adjccont,a0		; credits to continue
	calla	get_adj	
	move	a0,@ramtemp3,l
	cmpi	1,a0
	jrne	rp_tocontinue
	movi	suffix_null,a14
	move	a14,@ramtemp4,l
rp_tocontinue
	movi	rtostart_mess,a8
	jsrp	lm_printf
cs_nosc

*
* Stupid Bill Validator Horse shit
*
	calla	read_dip	
	andi	dip_bill_val,a0
	jreq	skip_bv_msg		; skip this stupidity !!
	movi	pf_bill_val,a8
	jsrp	lm_printf

skip_bv_msg
	sleep	400

	clr	a0
	move	a0,@coinflag,w
	calla	wipeout
	retp

pf_bill_val
         mess_mac  rd7font,spacing20,194,>5d,bpal_white*>10000,strcnrmo_scr,0
	.string	"THIS GAME ACCEPTS DOLLAR BILLS",0
	.even

**************************************************************************
*											     *
* 	output_custom									     *
* 											     *
* 	output the coinup message.  this plots all the different	     *
* 	forms of it..									     *
* 											     *
* 	entry	nothing									     *
* 	exit	a2 = number of lines plotted					     *
*											     *
**************************************************************************

cm_line1 equ	custom_message
cm_line2 equ	custom_message+cmess_line_size
cm_line3 equ	custom_message+(2*cmess_line_size)

cm_y_gap	equ	15
cm_y_addgap	equ	[15,194]

;cm_y1		equ	83
;cm_y2		equ	73
;cm_y3		equ	68
;cm_y1		equ	142
;cm_y2		equ	142
;cm_y3		equ	142

; MKI
;cm_y1		equ	92
;cm_y2		equ	92
;cm_y3		equ	92

; MK II
cm_y1		equ	>a0
cm_y2		equ	>a0
cm_y3		equ	>a0



output_custom
	clr	a2
	callr	checkfree
	jrnz	ocgo			; br = freeplay

        movi    adjmaxc,a0
        calla   get_adj			; max credits allowed
        jrz	ocgo			; br = no max credits
	move	a0,a1
        callr   cred_p
	jrz	ocgo			; ain't got no credits
	cmp	a1,a0
	jrlo	ocgo			; credits < maxcredits
	movi	mess_max,a8
	calla	lm_setup
	jsrp	printf
	movi	1,a2
	jruc	ocret
;	jruc	ocnomess
ocgo
        calla   adj_page 
        movi    valid_custom,a7
        calla   rc_word
        cmpi    valid_value,a0		; check to see if message is valid
	jrnz	ocnomess		; br = not valid

	callr	num_clines		; compute number of displayable lines
	jrz	ocnomess		; nothing to show
	movk	1,a2
	sll	4,a0
	addi	cm_ytab,a0
	move	*a0,a9,w

	movi	cm_line1,a10
	callr	ck_line			; load it up, baby!
	jrz	oc1
	callr	cplotline
oc1
	movi	cm_line2,a10
	callr	ck_line
	jrz	oc2
	callr	cplotline
oc2
	movi	cm_line3,a10
	callr	ck_line
	jrz	oc3
	callr	cplotline
oc3
	jruc	ocret
ocnomess
	calla	tamperedp		;are we in custom coinage?
	jrz	ocret			;br = yes
	callr	plotcoinage
ocret
	rets


**************************************************************************
*									    *
*	cplotline							 *
*									 *
*	plot the line in pdata out on the screen			 *
*									 *
*	entry								 *
*		a9	y location to plot at				 *
*									 *
*	exit								 *
*		a9	new y location					 *
*									    *
**************************************************************************

cplotline:
	push	a9
	push	a9
	movi	custom_setup,a8
	calla	lm_setup
;	move	a13,a8
;	addi	pdata,a8
	movi	text_buff,a8
	pull	a9
	sll	16,a9
	addi	200,a9
	jsrp	printf
	pull	a9
	addi	cm_y_gap,a9
	rets

**************************************************************************
*											     *
*  COIN PAGE TEXT WITH COORDINATES							     *
*											     *
**************************************************************************
custom_setup:
	mess_mac  rd15font,spacing20,194,0,trog_prgb,strcnrmo,0

mess_max:
	mess_mac  rd15font,spacing20,195,>e7,bpal_hot_green*>10000,strcnrmos_scr,0
	.string	"MAXIMUM CREDITS !",0
	.even

rtostart_mess
         mess_mac  rd11font,spacing20,194,>80,bpal_white*>10000,strcnrmos_scr,0
	.string	"%d CREDIT%p TO START.\n"
	.string	"%d CREDIT%p TO CONTINUE.",0
	.long	ramtemp1
	.long	ramtemp2
	.long	ramtemp3
	.long	ramtemp4
	.even

pcsetup
;	mess_mac  rd11font,spacing20,200,>63,bpal_white*>10000,strcnrmos_scr,0
	mess_mac  rd11font,spacing20,200,>B3,bpal_white*>10000,strcnrmos_scr,0

*
* Custom message coordinate table
*
cm_ytab
	.word	0
	.word	cm_y1	; 92
	.word	cm_y2	; 92
	.word	cm_y3	; 92
	.word	cm_y3	; 92


suffix_bs:
	.string	"S"
suffix_null
	.byte	0

	.even

**************************************************************************
*									    *
*	num_clines							 *
*									 *
*	compute the number of displayable lines in custom ram		 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		a0	number of lines					 *
*									    *
**************************************************************************

num_clines
	mmtm	sp,a1,a10
	clr	a1
	movi	cm_line1,a10
	callr	ck_line
	jrz	nc2
	inc	a1
nc2
	movi	cm_line2,a10
	callr	ck_line
	jrz	nc3
	inc	a1
nc3
	movi	cm_line3,a10
	callr	ck_line
	jrz	nc4
	inc	a1
nc4
	move	a1,a0
	mmfm	sp,a1,a10
	rets

**************************************************************************
*									    *
*	ck_line								 *
*									 *
*	copy a line into pdata area, and return in a0 number of chars	 *
*									 *
*	entry								 *
*		a10	pointer to cmos loc of line			 *
*									 *
*	exit								 *
*		a0	number of valid chars in line			 *
*									    *
**************************************************************************

ck_line:
	mmtm	sp,a1,a2,a3,a4,a7,a10
        move    a10,a7		    ;input pointer to cmos
;	move	a13,a2		    ;our pdata area
;	addi	pdata,a2	    ;a10 is destination.
	movi	text_buff,a2

        movi    cmess_chars,a1	    ;counter
        calla   adj_page 	    ;point the page
	clr	a3		; only spaces so far

ck_loop calla   rc_bytei 	    ;fetch a byte
        movb    a0,*a2		    ;store
	move	a0,a0
	jrz	cklx			; end of string
	cmpi	20h,a0			; check for non-spaces
	jrz	ckgo
	inc	a3
ckgo
        addi    byte_size,a2
        dsjs    a1,ck_loop
	clr	a0
	move	a0,*a2,w		; make sure of things
cklx
        calla   def_page 	    ;point away now
	move	a3,a3			; how many "real" characters
	mmfm	sp,a1,a2,a3,a4,a7,a10
	rets

**************************************************************************
*									    *
*	plotcoinage							 *
*									 *
*	plot out the current coinage on the screen			 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

plotcoinage:
	mmtm	sp,a0,a1,a6
	clr	a2
	movi	adjfrepl,a0
	calla	get_adj
	jrnz	pcnohead
        movi    adjmaxc,a0
        calla   get_adj			; max credits allowed
        jrz	pc1			; br = no max credits
	move	a0,a1
        callr   cred_p
	jrz	pc1			; ain't got no credits
	cmp	a1,a0
	jrhs	pcnohead
pc1
	movi	adjprice,a0
	calla	get_adj			; get the current pricing
        calla   get_cspt
        move    *a6(cs_list),a2,l	
        jrz	pcnohead		; no header, believe it or not
	movi	pcsetup,a8
	calla	lm_setup
	mmtm	sp,a0,a1,a2	
	clr	a0
pc2
	move	*a2+,a1,l		; count up number of messages
	jrz	pc3
	inc	a0
	jruc	pc2
pc3
	sll	4,a0
	addi	cm_ytab,a0
	move	*a0,a9,w
	sll	16,a9

;*****************
; nudge left for mortal kombat (ejb: 7-6-92)
;	addi	200,a9
	addi	200-5,a9
;*****************

	mmfm	sp,a0,a1,a2
pcnexthead
        move    *a2+,a8,l		; pickup the next pointer
	jrz	pcdone
	jsrp	printf
	srl	16,a9
	sll	16,a9			; mask off x address
	addi	cm_y_addgap,a9
	jruc	pcnexthead
pcdone
	movk	1,a2
	jruc	pcret

pcnohead
	clr	a2
pcret
	mmfm	sp,a0,a1,a6
	rets

**************************************************************************
*											     *
* 	get_cstr									     *
* 											     *
* 	create the credit string and return it in strngram		     *
* 											     *
* 	entry	nothing									     *
* 											     *
* 	exit	a8	points to *strngram					     *
*											     *
**************************************************************************
get_cstr:
	mmtm	sp,a0,a1,a7,a10

	callr	checkfree
	jrz	not_free

        	movi    mess_freep,a8		; freeplay message
        	jruc    get_cx

not_free
	.if	0
        	callr   form_coin_cksum	    ;this sets us to the coinage page!
        	jrz     gccool		    ;all is ok!
	movi	gccmosbad,a8
	jruc	get_cx
	.endif
gccool
        movi    stringf_ram,a7		; text string to build in
        movi    mess_credits,a8			    ;point at text part
        calla   strcat				    ;build this in.
        callr   cred_p
        move    a0,a10				    ;save credits
        callr   cat_a0
*
* now we need to see if we should add a fraction.
*
        movi    adjfrac,a0
        calla   get_adj				    ;check the adjustment
        jrz     nsfrac				    ;don't show it!
*
* add any fraction we have
*
        callr   coin_pag 			    ;put us on coin page
        callr   get_cunits			    ;a0 has cunits
        calla   def_page 			    ;flip cmos away
        move    a0,a0				    ;zero?
        jrz     nsfrac				    ;then no fraction.
*
* we have a fraction...were the credits zero?
*
        move    a10,a10	       ; we saved em in a10
        jrnz    nzm	       ; non zero mantissa

        movi    stringf_ram,a8	; walk down string looking for the "zero"
kill_z  movb    *a8,a1	       ; get a byte
        jrz     nzm	       ; couldn't find it....go on.
        cmpi    let_0,a1        ; is this the zero?
        jrz     got_zero
        addi    byte_size,a8
        jruc    kill_z

got_zero 
	clr	a1
        movb    a1,*a8	       ; kill the zero
	move	a8,a7		; update end of string location

nzm     movi    mess_2space,a8  ; space bet. mantissa and denmo
        calla   strcat

not_zm  callr   cat_a0	       ; add a0 onto fraction

        movi    mess_slash,a8
        calla   strcat	       ; add slash

        movi    adjcunit,a0     ; units required for credit
        calla   get_adj
        callr   cat_a0	       ; denominator

nsfrac
	movi	strngram,a7	; starting pointer
	movi	stringf_ram,a8
	callr	strcat
	movi	strngram,a8

get_cx  clrc					    ;return ok
get_cxx
	mmfm	sp,a0,a1,a7,a10
	rets

gccmosbad
	.string	"CMOS BAD",0
	.even

**************************************************************************
*									    			*
*	cat_a0								 			*
*									 			*
*	turn a0 into a decimal number and then concatenate it onto	 *
*	the end of the string we are building				 *
*									 *
*	entry								 *
*		a0	number for the end of the string		 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

cat_a0
	mmtm	sp,a8
        move    a0,a8				    ;credit count in a8
        calla   hextoasc 			    ;string
        calla   strcat				    ;now we have whole number.
	mmfm	sp,a8
	rets

**************************************************************************
*									    *
*	strcat								 *
*									 *
*	concatenate the string pointed to by a8 onto a7 starting at	 *
*	a7.  gross but effective					 *
*									 *
*	entry								 *
*		a7	starting position in string			 *
*		a8	zero-terminated string to stick onto a7		 *
*									 *
*	exit								 *
*		a7	points at zero terminator			 *
*									    *
**************************************************************************

strcat
	push	a0
strloop
	movb	*a8,*a7			; stick next char in
	movb	*a7,a0			; movb sucks
	jrz	strdone
	addi	8,a7
	addi	8,a8			; woof woof who cares
	jruc	strloop
strdone
	pull	a0
	rets

**************************************************************************
*											     *
* 	add_prompt									     *
* 											     *
* 	this is called on the credits page to add a word of		     *
* 	wisdom below the credits message -- it picks out the		     *
* 	best messages and blinks them						     *
* 											     *
* 	entry	nothing									     *
* 	exit	nothing									     *
*											     *
**************************************************************************
add_prompt:
        movi    prompt_proc,a7
        calla   p_fork		    ;start up another w/ same id to flash!
        retp

**************************************************************************
*											     *
* 	prompt_proc									     *
* 											     *
* 	process to pick a good message and show it				     *
* 											     *
* 	entry	nothing									     *
* 	exit	nothing									     *
*											     *
**************************************************************************
prompt_proc:
	callr	checkfree
;	jrnz	ppfree			; br = freeplay
	jrnz	free_play_prompt	; br = freeplay

	callr	cr_strtp		; enough to start ?
         jalo	no_cred_prompt		; br = not enough to start 1 player

;*************************************************************************
;	move	a0,a1			; store creds in a1
;	movi	adjcstrt,a0		; credits to start
;	calla	get_adj	
;	cmp	a0,a1
;	jrlo	ppnocoin		; br = not enough to start
;	move	a0,a2			; creds required in a2
;	sub	a2,a1			; get us going here
;	movk	1,a0			; have enough for 1 player
;	sub	a2,a1
;	jrn	ppmess			; br = not enough for 2
;	inc	a0
;	sub	a2,a1
;	jrn	ppmess			; br = not enough for 3
;	inc	a0
;	sub	a2,a1
;	jrn	ppmess			; br = not enough for 4
;	inc	a0
;	jruc	ppmess			; can have up to 4 players
;
;ppfree
;	movk	4,a0			; freeplay is max players
;
;	a0	number of players we are ready for ( 0 = none )
;
;ppmess
;	move	@nplayers,a1,w		; grab game number of players
;	inc	a1
;	cmp	a1,a0
;	jrls	ppmess1			; br = cool number
;	move	a1,a0			; set to maximum number of players
;ppmess1
;	sll	5,a0
;	addi	prompt_tab,a0
;	move	*a0,a0,l		; get appropriate message
;	jrz	ppnocoin
;	push	a0
;	movi	prompt_setup,a8
;	calla	lm_setup
;	pull	a8			; pull out the message string
;	jsrp	printf
;*************************************************************************

free_play_prompt
	movk	1,a0		
	jruc	blink1

no_cred_prompt
	clr	a0
blink1	move	a0,*a13(pdata),w	; initialize "prompt offset"

	movi	prompt_setup2,a8
	calla	lm_setup
	move	*a13(pdata),a8,w	; get string
	sll	5,a8
	addi	prompt_messtab,a8
	move	*a8,a8,l
	jsrp	printf
	die



mess_slash .string "/",0
	  .even

mess_2space .string " "
mess_null   .byte 0
	   .even

mess_credits
	.STRING   "CREDITS: ",0
	.even

;prompt_setup
;	mess_mac  rd15font,spacing20,200,>e0,bpal_yellow*>10000,strcnrmos_scr,0

prompt_setup2
;	mess_mac  rd15font,spacing20,194,>c8,>01010000,strcnrmos_scr,0
	mess_mac  rd15font,spacing20,194,>cf,>01010000,strcnrmos_scr,0

prompt_messtab
	.long	txt_inscoin
	.long	txt_press_start	

txt_inscoin
	.STRING	"INSERT COIN",0
	.even

txt_press_start
	.STRING	"PRESS START",0
	.even

mess_freep
	.STRING "FREE  PLAY",0
	.even

coin_mess
;	mess_mac  rd15font,spacing20,196,>24,bpal_yellow*>10000,strcnrmos_scr,0
	mess_mac  rd15font,spacing20,196,>68,bpal_yellow*>10000,strcnrmos_scr,0
        .even
coin_mess2
; 	mess_mac  rd15font,spacing20,200,>24,bpal_hot_green*>10000,strcnrmos_scr,0
 	mess_mac  rd15font,spacing20,200,>68,bpal_hot_green*>10000,strcnrmos_scr,0
        .even

**************************************************************************
*											     *
* prompt_tab										     *
* 	.long	0									     *
* 	.long	prompt_1								     *
* 	.long	prompt_2								     *
* 	.long	prompt_3								     *
* 	.long	prompt_4								     *
* 											     *
* prompt_1										     *
* 	.string	"ready for 1 player.",0						     *
* 	.even										     *
* prompt_2										     *
* 	.string	"ready for 1 or 2 players.",0					     *
* 	.even										     *
* prompt_3										     *
* 	.string	"ready for 1 - 3 players.",0					     *
* 	.even										     *
* prompt_4										     *
* 	.string	"ready for 1 - 4 players.",0					     *
* 	.even										     *
*											     *
**************************************************************************

**************************************************************************
*									    			*
*	coin utility routines						 			*
*									    			*
**************************************************************************

**************************************************************************
*									    			*
*	cred_string							 			*
*									 			*
*	return a string to just the number of credits in a8		 	*
*									 			*
*	entry								 			*
*		nothing							 			*
*									 			*
*	exit								 			*
*		a8	string pointing to credits			 		*
*									    			*
**************************************************************************
cred_string:
	mmtm	sp,a0
	callr	cred_p			; get credits in a0
	move	a0,a8
	calla	hextoasc
	mmfm	sp,a0
	rets

**************************************************************************
*											     *
* 	checkfree									     *
* 											     *
* 	check to see if the game is in freeplay state			     *
* 											     *
* 	entry										     *
* 		nothing									     *
* 											     *
* 	exit										     *
* 		nz	= freeplay							     *
* 		z	= not in freeplay						     *
*											     *
**************************************************************************
checkfree:
	.if	forcefree
	movk	1,a0
	jruc	cfret
	.endif

        movi    adjfrepl,a0	
        calla   get_adj	
cfret
	move	a0,a0
	rets
	
**************************************************************************
*											     *
* 	scoin										     *
* 											     *
* 	process called when service coin switch triggered		     *
* 											     *
* 	entry										     *
* 		nothing									     *
* 											     *
* 	exit										     *
* 		nothing									     *
*											     *
**************************************************************************

scoin:
;	.if	printer
;	jsrp	pscoin
;	.endif

	move	@gstate,a0,w		;diagnostics?
	cmpi	gs_diag,a0
	jreq	crx			;then no action!

        movi    pid_lc,a0		; all 3 slots use this id now
        move    a0,*a13(procid),w	; set our id (in case table is wrong)

	callr	ck_max			;are we at maximum credits?
	jrhs	sc_kurt_damage		;br = yes, skip kurt brain damage

        movi    audpaidc,a0
	movi	-1,a1
        calla   aud			; offset for service, gross!!

sc_kurt_damage
****	movi	audscoin,a11
****	movk	1,a8

	movi	audscoin,a0
	calla	aud1
	callr	fetch_req
	move	a2,a8			;need this many for a credit here

	jruc	cgoproc

**************************************************************************
*									    *
*	xcoin								 *
*									 *
*	process called when fourth coin switch triggered		 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************
		
xcoin   movi    adj4mult,a8
        movi    xc_flag,a10	    ; left coin flag
        movi    aud4coin,a11
        jruc    coin_routine

**************************************************************************
*									    *
*	lcoin								 *
*									 *
*	process called when left coin switch triggered			 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************
		
lcoin
;	.if	printer
;	jsrp	plcoin
;	.endif
	movi	adjlmult,a8
        movi    lc_flag,a10	    ; left coin flag
        movi    audlcoin,a11
        jruc    coin_routine

**************************************************************************
*									    *
*	ccoin								 *
*									 *
*	process called when center coin switch triggered			 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

ccoin   movi    adjcmult,a8
        movi    cc_flag,a10	    ; center coin flag
        movi    audccoin,a11
        jruc    coin_routine

**************************************************************************
*									    *
*	rcoin								 *
*									 *
*	process called when right coin switch triggered			 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

rcoin
;	.if	printer
;	jsrp	prcoin
;	.endif
	movi	adjrmult,a8
        movi    rc_flag,a10	    ; right coin flag
        movi    audrcoin,a11

;	fall through

**************************************************************************
*												*
*	  coin_routine										*
*												*
*	  this is called from each of the coin switches when			*
*	  made.  it contains the following:						*
*												*
*		  a8 = multiplier for that switch.					*
*		  a10 = base of ram pointers						*
*		  a11 = base audit number 						*
*												*
**************************************************************************

coin_routine
	move	@gstate,a0,w	   ;diagnostics?
        cmpi    gs_diag,a0
        jreq    crx		    ;then no action!

        move    a8,a0		    ;move multiplier adjust number to a0
        calla   get_adj		    ;fetch it
        move    a0,a8		    ;and back to static reg...any there?
        jrz     crx		    ;nope....don't waste the time!

        callr   slam_p		    ;slam around?
        jrnz    crx		    ;then no action

        movi    pid_lc,a0	    ;all 3 slots use this id now
        move    a0,*a13(procid),w    ;set our id (in case table is wrong)

	movb	*a10,a0 		;get flag byte
	jrnz	crx			;someone else there...we're a bounce!
*
*	ok....this is a new positive edge....start the timing
*	wheels	 (a0 has a zero!)
*
	movi	pulse_max,a1		;maximum pulse width
	movb	a1,*a10(run_time)	;count it down here.

	movi	min_opens,a1		;this many frames of open til open
	movb	a1,*a10(opens_left)

	movi	coin_sflag,a1
	movb	a1,*a10 		;tell interrupt to start!

	movi	100h,a9 		;4 seconds max
coin_loop
	sleep	1			;now sleep tightly till we get success or fail
	movb	*a10,a0 		;get the flags
	btst	coin_fail_bit,a0	;too long?
	jrz	ck_succ
*
*	we have failure...acknowledge it
*
	ori	coin_ack_val,a0 	;this acknowledges we saw it.
	movb	a0,*a10 		;put it back
	jruc	crx			;and get out

ck_succ
	btst	coin_succ_bit,a0
	jrnz	coin_go 		;got it!...continue!

	dsjs	a9,coin_loop		;time out for safety


	.if	debug			; this is a stupid place to be
		jruc	$
	.endif

	jruc	crx			;timed out....just die!

coin_go	clr	a0
	movb	a0,*a10 		;clear the flags back out!

	callr	slam_p			;slam?
	jrnz	crx		    ;then we're out of here
*
*	we survived 1/2 second without a slam....its time to cash
*	in his stache.
*
* GNP changed 1/13/94 to click right counter on center and xtra once for
*	each input.
	cmpi	lc_flag,a10
	jrnz	cgo1
	callr	clickleft		; click left coin counter
	jruc	cgo4
cgo1
	cmpi	rc_flag,a10
	jrnz	cgo2
	callr	clickright		; click right coin counter
	jruc	cgo4
cgo2
	cmpi	cc_flag,a10
	jrnz	cgo3
	callr	clickright		; click right counter for center coin
	jruc	cgo4
cgo3
	cmpi	xc_flag,a10
	jrnz	cgo4
	callr	clickright	     ; click right counter for xtra coin
	jruc	cgo4
cgo4
	callr	chalk_coin		; strike up the audit(s)

* GNP end 1/13/94
************************************************************************

cgoproc
	move	a8,a8			; no cunits?
	jrz	crx			; then no more work to do.

	callr	adjust_credits		; give credit for the money.
	calla	def_page		; point page away!

	clr	a0
	move	a0,@f_nosound,w		; allow sounds

	move	@gstate,a0,w
	cmpi	8,a0
	jrlo	coinn4
	movk	8,a0
coinn4	sll	5,a0
	addi	coin_forks,a0
	move	*a0,a0,l
	jump	a0			; jump according to game state


jump_to_coin_page
	movi	pid_george,a0
	move	a0,*a13(procid),w	; make me killable

;	calla	nosounds
 	clr	a3
	calla	send_code_a3
	callr	mk_coin_stuff

	movi	pid_amode,a0
	move	a0,*a13(procid),w	; make me killable
	jruc	coin_page_jump

skip_coin_page

; this screws up coin text
;	callr	get_cstr		; get credit string
;	calla	g_cred			; call george
; this screws up coin text

	callr	mk_coin_stuff
crx	jauc	sucide


mk_coin_stuff
	clr	a0
	move	a0,@f_nosound,w		; allow sounds
	tsound2	>30			; coin sound !!
	jauc	update_pmsg		; and return

**************************************************************************
*											     *
*  coin_forks - adresses for coin procs to fork off to based on the	     *
*               game state (ejbcoin)							     *
*											     *
**************************************************************************
coin_forks
	.long	skip_coin_page		; 0
	.long	jump_to_coin_page	; 1 - attract mode
	.long	skip_coin_page		; 2
	.long	skip_coin_page		; 3
	.long	skip_coin_page		; 4
	.long	skip_coin_page		; 5
	.long	skip_coin_page		; 6
	.long	skip_coin_page		; 7
	.long	skip_coin_page		; 8
	.long	skip_coin_page		; 9
	.long	skip_coin_page		; a
	.long	skip_coin_page		; b
	.long	skip_coin_page		; c
	.long	skip_coin_page		; d
	.long	skip_coin_page		; e
	.long	skip_coin_page		; f
	.long	skip_coin_page		; 10
	.long	skip_coin_page		; 11
	.long	skip_coin_page		; 12

**************************************************************************
*												*
*	  chalk_coin										*
*												*
*	  a11 contains the base audit number.	chalk the audit for 	*
*	  1 more coin hit there!								*
*												*
*	  3 away from the base is the "door-closed" counter			*
*												*
*	  3 away from that is the "sub-total". 					*
*												*
*	  3 away from that is the "door-closed" sub-total.			*
*												*
*												*
**************************************************************************
chalk_coin:
        mmtm    sp,a0
        move    a11,a0
	callr	chalk_for_a0	;chalk relevant counters
	mmfm	sp,a0
	rets

**************************************************************************
*												*
*	  chalk_for_a0										*
*												*
*	  this is called to chalk the audits for a coin switch.		*
*	  a0 has the base audit for the coin switch.				*
*												*
**************************************************************************

chalk_for_a0
	mmtm	sp,a0
        calla   aud1	       ;chalk the direct audit
	mmfm	sp,a0
	rets

**************************************************************************
*									    *
*	adjust_credits							 *
*									 *
*	takes a valid coin switch hit and counts it towards credits	 *
*									 *
*	entry								 *
*		a8	chute multiplier				 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

adjust_credits
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
        callr   ck_max	       ;are we at maximum credits?
        jrhs    adcrxx	       ;yep.....don't rock the boat!
*
        callr   cccc	       ;validate the current totals (or clear!)

        callr   fetch_req       ;get the required for credit, bonus and minimum
*
*	a2 = required for credit
*	a3 = for bonus
*	a4 = minimum
*
        callr   add_to_cunits   ;add to our cunits
        move    a3,a3	       ;bonus effective?
        jrz     no_bunits       ;nope....don't run up the counter!

        callr   add_to_bunits   ;add to bonus units

no_bunits
        move    a4,a4	       ;minimum required?
        jrz     no_minimum      ;nope.....leave alone.

        movi    minunits,a7     ;point at minimum
        calla   rc_word	       ;get the amount accumulated
        add     a8,a0	       ;add amount received
        calla   wc_word	       ;write the minunits back in case not enough.

        sub     a4,a0	       ;do we have enough to act?
        jrlo    adcrx	       ;nope....no credits yet!

        clr     a0	       ;clear out minimum for next shot!
        calla   wc_word	       ;remove accumulated minimum.

no_minimum
        clr     a6	       ;count accumulated credits in a6
        clr     a10	       ;in case no bonus!

        clr     a8
        movi    bunits,a7
        calla   rc_word	       ;get the number of bunits
        move    a0,a9	       ;into a9

        move    a3,a3	       ;don't divide by zero!
        jrz     no_bu_bu
        divu    a3,a8	       ;divide bunits by number needed for bonus

        move    a9,a0	       ;write remainder back
        calla   wc_word

        move    a8,a6	       ;number of bonus credits earned.
        move    a8,a10	       ;remember if any bonus credits were earned!

no_bu_bu
        clr     a8
        callr   get_cunits      ;read in the cunits
        move    a0,a9

        move    a2,a2	       ;don't divide by zero.
        jrz     no_cr

        divu    a2,a8	       ;get credits!
        move    a9,a0	       ;remainder is leftover cunits
        callr   put_cunits
        add     a8,a6	       ;a6 has what we've won!

no_cr   move    a6,a1
        movi    audpaidc,a0
        calla   aud	       ;chalk up the earned credits!

        callr   get_credits
        add     a6,a0	       ;add in the new ones.
        callr   put_credits     ;now store em back (enforce max)

        move    a10,a10	       ;was the bonus earned?
        jrz     adcrx	       ;nope...exit!
*
*	when bonus earned...we start the whole system over!
*
        callr   clear_units

adcrx
	callr	form_coin_cksum_and_store
adcrxx	
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

**************************************************************************
*									    *
*	put_credits							 *
*									 *
*	store the credit count in a0 to cmos -- enforce max credits	 *
*									 *
*	entry								 *
*		a0	credit count					 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

put_credits
	mmtm	sp,a0,a6,a7
        callr   get_max	       ;get max creds in a1....be on coin page
        cmp     a1,a0	       ;see how we stack up.
        jrlo    use_a0	       ;we're lower...just store.
*
*	we're at (or over) maximum credits
*
        callr   clear_units     ;clear out the unit fractions.
        move    a1,a0	       ;use maximum

use_a0  movi    credits,a7
        calla   wc_byte	       ;write the credits out.
	mmfm	sp,a0,a6,a7
	rets

**************************************************************************
*									    *
*	get_max								 *
*									 *
*	get maximum credits in a1 ( leaves you on coin page )		 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		a1	maximum credits					 *
*									    *
**************************************************************************

get_max
	mmtm	sp,a0
        movi    adjmaxc,a0
        calla   get_adj_for_coin    ;fetch maximum credits (put us on coin page)
        move    a0,a1
	mmfm	sp,a0
	rets

**************************************************************************
*									    *
*	ck_max								 *
*									 *
*	caled to see if we are at maximum credits			 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		.hs.	at maximum credits				 *
*									    *
**************************************************************************

ck_max	mmtm	sp,a0,a1
        callr   get_max		    ;get maximum in a1
        callr   cred_p		    ;get credits in a0 (and flip page away)
        cmp     a1,a0		    ;jrhs for maximum credits!
	mmfm	sp,a0,a1
	rets

**************************************************************************
*									    *
*	clear_units							 *
*									 *
*	clear out any fractions of a unit in cmos			 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

clear_units
	mmtm	sp,a0,a7
        	clr     a0
        	movi    cunits,a7       ;3 consecutive words of cmos
        	calla   wc_wordi
        	calla   wc_wordi
        	calla   wc_word
	mmfm	sp,a0,a7
	rets

**************************************************************************
*									    *
*	fetch_req							 *
*									 *
*	snag the number of units required for credit, bonus and		 *
*	minimum								 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		a2	required for credits				 *
*		a3	required for bonus				 *
*		a4	minimum						 *
*									    *
**************************************************************************

fetch_req
	mmtm	sp,a0
        movi    adjcunit,a0
        calla   get_adj
        move    a0,a2

        movi    adjbunit,a0
        calla   get_adj
        move    a0,a3

        movi    adjmunit,a0
        callr   get_adj_for_coin
        move    a0,a4
	mmfm	sp,a0
	rets

**************************************************************************
*									    *
*	get_adj_for_coin						 *
*									 *
*	get the passed adjustment and put back on coin page		 *
*									 *
*	entry								 *
*		a0	adjustment requested				 *
*									 *
*	exit								 *
*		a0	adjustment value				 *
*									    *
**************************************************************************

get_adj_for_coin:
	calla	get_adj		; get the adjustment
        jauc    coin_pag        ; then re-instate the coin page!

**************************************************************************
*											     *
* 	cred_p 2									     *
* 											     *
* 	return number of credits in a0.  also clears z bit if		     *
* 	credits exist or in free play						     *
* 											     *
* 	entry	nothing									     *
* 											     *
* 	exit	a0	number of credits						     *
* 		.nz.	credits or freeplay					     *
*											     *
**************************************************************************
cred_p:
	callr	cccc			; checksum coin credits

get_credits
        mmtm    sp,a7
        callr	coin_pag	; coin page
        movi    credits,a7	; want number of credits
        calla   rc_byte		; read current credits

;       jrnz    gc1	       ; we got some!
;       movi    adjfrepl,a0	
;       calla   get_adj	       ;see if freeplay......(z bit clear if so!)

gc1     calla   def_page        ;flip cmos away
        mmfm    sp,a7
        rets

**************************************************************************
*									    *
*	add_to_cunits							 *
*									 *
*	add a value to the credit units					 *
*									 *
*	entry								 *
*		a8	number of cunits to add				 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

add_to_cunits
        mmtm    sp,a0,a7
        callr   get_cunits
        add     a8,a0
        callr   put_cunits
	mmfm	sp,a0,a7
	rets

**************************************************************************
*									    *
*	get_cunits							 *
*									 *
*	get the number of credit units hanging around			 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		a0	number of cunits				 *
*									    *
**************************************************************************

get_cunits
        mmtm    sp,a7
        movi    cunits,a7
        calla   rc_word
	mmfm	sp,a7
	rets

**************************************************************************
*									    *
*	put_cunits							 *
*									 *
*	put the number of credit units in a0 out to cmos		 *
*									 *
*	entry								 *
*		a0	number of cunits				 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

put_cunits
        mmtm    sp,a7
        movi    cunits,a7
        calla   wc_word
	mmfm	sp,a7
	rets

**************************************************************************
*									    *
*	add_to_bunits							 *
*									 *
*	add a number of bonus units to the bonus counter		 *
*									 *
*	entry								 *
*		a8	number of bonus units to add			 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

add_to_bunits
        mmtm    sp,a7,a0
        movi    bunits,a7
        calla   rc_word
        add     a8,a0
        calla   wc_word
	mmfm	sp,a7,a0
	rets

**************************************************************************
*									    *
*	form_coin_cksum							 *
*									 *
*	this routine is called to form the coins/credits checksum.	 *
*	the checksum is returned in a1					 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		a1	checksum					 *
*		.eq.	matches what's there				 *
*		.ne.	it don't match, dude				 *
*									    *
**************************************************************************

form_coin_cksum:
        mmtm    sp,a0,a7,a2
        callr   coin_pag 		   ;make sure we're on the right page.
        movi    coin_cksum_start,a7	    ;point at first byte to check
        movi    coin_cksum_bytes,a2
        clr     a1			    ;clear out checksum

cn_sum  calla   rc_bytei 		    ;fetch a byte in a0
        add     a0,a1			    ;add to sum
        dsjs    a2,cn_sum		    ;till we have em all

        not     a1			    ;complement of course
        andi    byte_mask,a1		    ;and keep the byte

        movi    coin_cksum,a7
        calla   rc_byte			    ;fetch the current cksum
        cmp     a0,a1			    ;compare to this
	mmfm	sp,a0,a7,a2
	rets

**************************************************************************
*									    *
*	form_coin_cksum_and_store					 *
*									 *
*	checksum the coins and then store it out			 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

form_coin_cksum_and_store
        mmtm    sp,a1,a7,a0
        callr   form_coin_cksum
        movi    coin_cksum,a7
        move    a1,a0
        calla   wc_byte
	mmfm	sp,a1,a7,a0
	rets

**************************************************************************
*									    *
*	cccc								 *
*									 *
*	check coin and clear on bad checksum -- basically just		 *
*	checks out the coin checksums and if they are wrong it		 *
*	clears them out							 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

cccc	
	mmtm	sp,a0,a1,a7,a2
        callr   form_coin_cksum	    ;this sets us to the coinage page!
        jrz     ccccx		    ;all is ok!

        movi    coin_cksum_start,a7  ;point at first byte
        movi    coin_cksum_bytes,a2  ;number of bytes to clear
        clr     a0

cccc_loop
        calla   wc_bytei 	    ;write a byte
        dsjs    a2,cccc_loop	    ;until they're done!

        callr   form_coin_cksum_and_store	;now make the cksum valid

ccccx   mmfm    sp,a0,a1,a7,a2
	rets

**************************************************************************
*									    *
*	coin_pag							 *
*									 *
*	set the current cmos page to to coins/credits			 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

coin_pag
        mmtm    sp,a1
        movi    coin_select,a1	    ;this is coin/credits page
        calla   set_page 	    ;set it please
	mmfm	sp,a1
	rets

**************************************************************************
*									    *
*	no_creds							 *
*									 *
*	this is called to remove credits and stuff from the machine	 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

no_creds 
	mmtm	sp,a0,a1,a7
        callr   form_coin_cksum
        movi    coin_cksum,a7
        move    a1,a0
        inc     a0	       ;make the cksum bad!
        calla   wc_byte
	mmfm	sp,a0,a1,a7
	rets

**************************************************************************
*									    *
*	cr_both								 *
*									 *
*	check to see if things are good for a lot of stuff		 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		a2	0 = neither					 *
*			1 = can start					 *
*			2 = can continue				 *
*			3 = you can do anything you want		 *
*									    *
**************************************************************************

cr_both:
	mmtm	sp,a0,a1

	.if	forcefree
	movk	3,a2
	jruc	cr_bx
	.endif

	movk	3,a2		; assume freeplay

        movi    adjfrepl,a0
        calla   get_adj		; are we in free play?
	move	a0,a0
	jrnz	cr_bx

	clr	a2		; assume nothing
        callr   get_credits	; get current creds
	cmpi	1,a0
	jrlo	cr_bx
        move    a0,a1
        movi    adjcstrt,a0
        calla   get_adj		; get start creds
        cmp     a0,a1
	jrlo	cr_b1
	movk	1,a2		; yes, enough to start
cr_b1
	movi	adjccont,a0
	calla	get_adj		; get continue creds
	cmp	a0,a1
	jrlo	cr_bx
	ori	2,a2		; set second bit

cr_bx	mmfm	sp,a0,a1
	rets

**************************************************************************
*											     *
* 	cr_strtp									     *
* 											     *
* 	check to see if there are enough credits to start		     *
* 											     *
* 	entry	nothing									     *
* 	exit	.hs.	enough credits to start				     *
*											     *
**************************************************************************
cr_strtp:
	mmtm	sp,a0,a1

	.if	forcefree
	movk	1,a0
;	move	a0,a0
	cmpi	0,a0
	jruc	cr_stx
	.endif

        movi    adjfrepl,a0
        calla   get_adj		    ;are we in free play?
	move	a0,a0
	jrnz	cr_stx

        callr   get_credits	    ;get current credits
	cmpi	1,a0
	jrlo	cr_stx
        move    a0,a1
        movi    adjcstrt,a0
        calla   get_adj		    ;get number needed
        cmp     a0,a1		    ;do we have enough to start?

cr_stx  mmfm    sp,a0,a1
	rets

**************************************************************************
*											     *
* 	cr_contp									     *
* 											     *
* 	check to see if there are enough credits to continue		     *
* 											     *
* 	entry	nothing									     *
* 	exit	.hs.	enough credits to start				     *
*											     *
**************************************************************************
cr_contp
	mmtm	sp,a0,a1

	.if	forcefree
	movk	1,a0
;	move	a0,a0
	cmpi	0,a0
	jruc	cr_ctx
	.endif

        	movi    adjfrepl,a0
        	calla   get_adj		    ;are we in free play?
	move	a0,a0
	jrnz	cr_ctx

        	callr   get_credits	    ;get current credits
        	move    a0,a1
	cmpi	1,a0
	jrlo	cr_stx
        	movi    adjccont,a0
        	calla   get_adj		    ;get number needed
	cmp     a0,a1		    ;do we have enough to start?

cr_ctx
	mmfm    sp,a0,a1
	rets

**************************************************************************
*											     *
* 	p_start										     *
* 											     *
* 	player started -- deduct requisite number of credits		     *
* 											     *
* 	entry	nothing									     *
* 											     *
* 	exit	nothing									     *
*											     *
**************************************************************************
p_start mmtm    sp,a0,a1,a8
        callr   cred_p
        move    a0,a1
        movi    adjcstrt,a0
        calla   get_adj		; get number needed ( in a0 )
        addrm   a0,@gameunits,w	; continuing cost of the game
        callr   remove_credits
;       calla   dec_hsr		; take 1 from high score reset counter
        callr   get_cstr	    	; get credit string
        calla   g_cred		; call george

        movi	aud_start,a0
        calla	aud1	    	; count this (ejb)

        mmfm    sp,a0,a1,a8
        rets

**************************************************************************
*											     *
* 	p_cont										     *
* 											     *
* 	player continued -- deduct requisite number of credits	     *
* 											     *
* 	entry	nothing									     *
* 	exit	nothing									     *
*											     *
**************************************************************************
p_cont  mmtm    sp,a0,a1,a8
	callr   cred_p
        	move    a0,a1
        	movi    adjccont,a0
        	calla   get_adj		    	; get number needed
        	addrm   a0,@gameunits,w		; continuing cost of the game
        	callr   remove_credits
;       	calla   dec_hsr			; take 1 from high score reset counter
        	callr   get_cstr			; get credit string
        	calla   g_cred			; call george

	movi	aud_continue1,a0
	clr	a2
        	move	@p1_state,a1,w
	jreq	pcont2
      	inc	a2
pcont2  	move	@p2_state,a1,w
	jreq	pcont3
	inc	a2
pcont3	cmpi	1,a2			; 1 player in ?
	jreq	pcont4			; yes
	movi	aud_continue2,a0	; no, 2
pcont4	calla	aud1		    	; count this (ejb)
	mmfm	sp,a0,a1,a8
        	rets

**************************************************************************
*									    *
*	remove_credits							 *
*									 *
*	remove n credits from the machine				 *
*									 *
*	entry								 *
*		a0	number of credits to remove			 *
*		a1	number of credits on the machine		 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

remove_credits
        sub     a0,a1		    ;remove start amount from what we have
        jrhs    ps1		    ;we're ok.
        clr     a1		    ;it went negative....make zero.
ps1     callr   coin_pag
        movi    credits,a7
        move    a1,a0		    ;put whats left out to write
        calla   wc_byte		    ;write the new amount
        callr   form_coin_cksum_and_store
        calla   def_page 	    ;point at default page.
        rets

**************************************************************************
*											     *
* 	timeint										     *
* 											     *
* 	time interrupt -- called once every time through the exec	     *
* 	loop..										     *
* 											     *
* 	entry	nothing									     *
* 	exit	nothing									     *
*											     *
**************************************************************************

one_second	equ	55			;this many ticks a second

timeint
	mmtm	sp,a0,a1,a2
;
;	every tick
;
timecheck
	move	@timecnt,a0,w
	move	@timer,a1,w
	add	a1,a0
	move	a0,@timecnt,w
	cmpi	one_second,a0
	jrlo	timeret

	clr	a0
	move	a0,@timecnt,w		; reset timer

	movi	aud_ontime,a0		; audit: on time
	calla	aud1

	clr	a0
	move	@p1_state,a2,w		; player 1 in ?
	jreq	paud1			; sans
	inc	a0			; yes, count him
paud1	move	@p2_state,a2,w		; player 2 in ?
	jreq	paud2			; sans
     	inc	a0			; yes, count him
paud2	move	a0,a0
	jreq	timeret			; zero - no players are in
	dec	a0
	sll	4,a0
     	addi	ptime_audits,a0
	move	*a0,a0,w		; grab an audit
	calla	aud1

timeret	mmfm	sp,a0,a1,a2
	rets


ptime_audits
	.word	aud_1time
	.word	aud_2time

**************************************************************************
*											     *
* 	coinint										     *
* 											     *
* 	interrupt routine processing for coins					     *
* 											     *
* 	entry	nothing									     *
* 	exit	nothing									     *
*											     *
**************************************************************************
coinint:
	move	@c_flags,a0,l		;any flags set?
	jrz	no_coin_work		;nope!

	movi	c_flags,a10		;walk through the 3 counters
	movi	4,a9
	movi	l_coin_bit,a8		;this is the bit to check
*
*	i believe that lc_flag is in the low byte...then cc_flag...then rc_flag
*
next_slot
	move	a0,a1			;get current byte in a1
	srl	8,a0			;shift down to next
	andi	0ffh,a1 		;just hold left switch
	jrz	try_next		;not left

	btst	 coin_fail_bit,a1	;fail looking for open?
	jrz	 check_start		;yep...that's all we need do!
*
*	we're in a fail condition see if we can cancel it!
*
	btst	coin_ack_bit,a1 	;has it been acknowledged?
	jrnz	fail_acked		;yep.....just run down the "open" timer
*
*	hasn't been acknowledged.....time down and auto ack if
*	process is dead!	this shouldn't happen, but
*	deadlocks are ugly!
*
	movb	*a10(run_time),a3	;we're running out of time
	dec	a3
	movb	a3,*a10(run_time)	;put it back!
	jrnz	try_to_open		;now continue to open the switch
*
*	no ack in all this time!
*	provide the ack ourselves!
*
	.if	debug			;this is a fail-safe...trap during debug
		jruc	$
	.endif

	ori	coin_ack_val,a1 	;add in the ack!
	movb	a1,*a10 		;and store it back!
*
*	we have ack...have we had our open?
*
fail_acked
	movb	*a10(opens_left),a3		;have we made it?
	jrnz	try_to_open			;not yet...keep trying.
*
*	were open and have our ack clear out the flags!
*
	movb	a3,*a10 			;this clears out the flag
	jruc	try_next			;flags are clear...step to next

check_start
	btst	coin_sbit,a1		;"start" flag?
	jrnz	time_start		;yep......keep timing
*
*	here by process of elimination...its "succ" bit or
*	somthing else got set.....simply time it down
*	in case someone trashed in on this byte
*
	movb	*a10(run_time),a3	;we're running out of time
	dec	a3
	movb	a3,*a10(run_time)	;put it back!
	jrnz	try_next		;when it hits zero...we'll clear out!

	.if	debug			;this is a fail-safe...trap during debug
		jruc	$
	.endif

	movb	a3,*a10 		;clear out the flags...proc is gone!
	jruc	try_next		;must be success...no action.

time_start
	movb	*a10(run_time),a3	;we're running out of time
	dec	a3
	movb	a3,*a10(run_time)	;put it back!
	jrnz	try_to_open		;now continue to open the switch
*
*	this one timed out......its fail flag time!
*
	movi	coin_fail_val,a3
	movb	a3,*a10 		;we have failure

	movi	acc_limit,a3
	movb	a3,*a10(run_time)	;this is time limit for process to answer!
*
try_to_open
	cmpi	8,a8
	jrz	ttofourth		; another kludge for xcoin
	move	@coins,a2,w		;the switch has 1/2 second to open
	cmpi	4,a8			; special check for center chute
	jrz	ttocenter
	and	a8,a2			;a1 contiains zero for closed
	jrz	still_closed		;its closed...re-start the open count
	jruc	ttogo
ttocenter
	andi	80h,a2			; mask for jamma center
	jrz	still_closed
	jruc	ttogo
ttofourth
	move	@switch2,a2,w
	andi	20h,a2
	jrz	still_closed
ttogo
*
*	its open
*
	movb	*a10(opens_left),a3		;have we made it?
	jrz	hit_zero			;we have a long enough open
	dec	a3
	movb	a3,*a10(opens_left)		;put it back
	jrnz	try_next			;try the next byte
*
*	we hit zero....if "start flag" is on then we have success
*
hit_zero btst	coin_sbit,a1		;"start" flag?
	jrz	try_next		;nope....

	movi	coin_succ_val,a3
	movb	a3,*a10 		;indicate we made it!

	movi	acc_limit,a3
	movb	a3,*a10(run_time)	;this is time limit for process to answer!

	jruc	try_next

still_closed
	movi	min_opens,a1		;this many frames of open til open
	movb	a1,*a10(opens_left)

try_next
	addi	8,a10			;next byte
	sll	1,a8			;next coin bit

	dsj	a9,next_slot

no_coin_work
	rets

**************************************************************************
*									    *
*	slam_p								 *
*									 *
*	is there a slam process running					 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		.eq.	no						 *
*		.ne.	yes						 *
*									    *
**************************************************************************

slam_p	movi	pid_slam,a0		;slam process active?
	movi	0ffffh,a1
	calla	existp
	 rets

**************************************************************************
*									    *
*	slam								 *
*									 *
*	process that starts up when we get slammed on			 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

slam	
        movi	aud_slam,a0
        calla	aud1
        movi	pid_slam,a0

        move    a0,*a13(procid),w    ;set our id to slam
        movi    0ffffh,a1
        calla   kilall		    ;kill any other incarnations
        sleep   40h		    ;1 second of coin ignoring.
        jauc    sucide

**************************************************************************
*									    *
* change_oid - change all matching oid's on the object list		 *
*		to the given new one.					 *
* a0 = oid to change							 *
* a1 = new oid								 *
*									    *
**************************************************************************
change_oid
	mmtm	sp,a2,a3
	sext	a0
	movi	objlst,a2
chngolp
	move	*a2,a2,l
	jrz	chngoidx		;br = done with the list
	move	*a2(oid),a3,w
	cmp	a0,a3
	jrne	chngolp			;this is not one of them
	move	a1,*a2(oid),w		;stuff the new one
	jruc	chngolp
chngoidx
	mmfm	sp,a2,a3
	rets

**************************************************************************
*												*
*	sound(s?)										*
*												*
**************************************************************************

coinsnd	.word	>f0fe,>30,>8049,0		;"coin" sound

pcoinleft	
	.STRING	"LEFT COIN",0AH,0
	.even

pcoinright
	.STRING	"RIGHT COIN",0AH,0
	.even

