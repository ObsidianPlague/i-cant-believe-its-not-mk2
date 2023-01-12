	.file	'diagadj.asm'
	.title	"<<< adjustment human interface >>>"
	.width	132
	.option	b,d,l,t
	.mnolist

**************************************************************************
*												*
*	copyright (c) 1990 williams electronics games, inc.			*
*	all rights reserved.									*
*												*
**************************************************************************
	.include	"dispequ.asm"	;display processor equates
	.include	"sysequ.asm"		;system equates
	.include	"mainequ.asm"
	.include	"imgtbl.glo"
	.include	"stringh.asm"

	.include	"diagsequ.asm"
	.include	"diagmequ.asm"	;menu equates
	.include	"diagaudn.asm"	;auditing offsets
	.include	"dipequ.asm"
	.include	"diagdict.asm"
	.include	macros.hdr

*
*	in this module
*
	.global go_adj
	.global do_adjh
	.def	tamperedp
	.def	binbcd, usa_1, usa_2, usa_3, usa_4, usa_electitle
	.def	german_1, german_2, german_3, german_4, german_5
	.def	german_electitle
	.def	french_1, french_2, french_3, french_4, french_electitle
*
*	in narchstd
*
	.global cmos_val
	.global p_fork
*
*	in narctest
*
	.global	b_menu,cyan_box
	.global	l_mess,top_box
	.global	lm_finis
	.global	lm_setup
	.global	areusure
	.global	st_stick
	.global	getstick
	.global	sur_mess
	.global	sure_box
	.global	get_fac
	.global	menu_top
	.global	doborder
	.global	blnkhelp
	.global	h_slave
	.global	col_inst
	.global	std_bord
	.global	ld_ctab
*
*	in narcmenu
*
	.global	any_but
	.global	mess_mm
	.global	get_cspt
*
	.global	htohxasc
	.global	f_adc_s
	.global	cs_ents	  ;number of highest in coin table
	.global	strcat
	.global	no_creds
	.ref	lastcolor


	.def	dipcointab, set_coin_adj, men_adj, ckdip

	.ref	fac_set, cmosunlock, cmoslock, read_dip
	.ref	lm_xfinis

	.bss	ramtemp1,32
	.bss	ramtemp2,32

	.text

**************************************************************************
*											     *
* 	 get_cspt									     *
* 											     *
* 	 this is called to return in a6 the current				     *
* 	 cselct line as stored in the adjustment table.			     *
*											     *
**************************************************************************
get_cspt
	mmtm	sp,a0
	movi	adjprice,a0
	calla	get_adj		;get the coin select number being used.
	callr	cs_point
	mmfm	sp,a0
	rets

**************************************************************************
*											     *
* 	 cs_point									     *
* 											     *
* 	 this is called to point at an entry in the coinage		     *
* 	 select table.									     *
* 											     *
* 	 it takes offset in a0.								     *
* 	 it returns pointer in a6.							     *
*											     *
**************************************************************************
cs_point
	mmtm	sp,a0,a1
	move	a0,a0		;zero?
	jrz	cs1		;yep...return first line

	cmpi	cs_ents,a0	;in range?
	jrls	cs2		;yep...continue
	movi	1,a0		;too large.......use 1st line.
cs2
	dec	a0		;index into table
cs1
	movi	cs_size,a1	;size per entry
	mpyu	a0,a1		;offset into table
	addi	cselct,a1
	move	a1,a6		;return the pointer
	mmfm	sp,a0,a1
	rets

**************************************************************************
*									*
*	 binbcd							*
*									*
*	 convert binary number in a0 to bcd.			  *
*									*
**************************************************************************
binbcd	mmtm	sp,a1,a2,a3,a4,a5
	cmpi	99999999,a0		 ;are we too big?
	jrls	bbir			;in range
	movi	99999999h,a0		;return the largest number we have!
	jruc	bb_ret

bbir	movi	10,a1		    ;always divide by a0
	clr	a5			;accumulate result in a5
	clr	a4			;a4 has current shift count
	move	a0,a3		    ;<a2><a3> has numerator
do_bcd_again
	clr	a2
	divu	a1,a2		    ;a2 has leftover...a3 has current digit
	sll	a4,a3		    ;shift it correct number of times
	add	a3,a5		    ;add it into result reg
	addk	4,a4			;add 4 to shift count
	move	a2,a3		    ;refresh numerator
	jrnz	do_bcd_again

	move	a5,a0		    ;put out result
bb_ret	mmfm	sp,a1,a2,a3,a4,a5
	rets

**************************************************************************
*									*
*	 bcdbin							*
*									*
*	 this turns a bcd number (in a0) into a binary		*
*	 number.							 *
*									*
**************************************************************************
bcdbin	mmtm	sp,a1,a2,a3,a4,a5	   ;work reggies.
	clr	a2			;accumulate in a2
	movi	1,a3		   ;current factor is 1.
	movi	10,a4		  ;save some movi insts later
	movi	16,a5		  ;divide it down by 16 at a time
bcbloop	move	a0,a1		  ;dividend in <a0><a1>
	jrz	bcbdone		;all units exhausted!
	clr	a0
	divu	a5,a0		  ;divide by 10h...(remainder in a1)
	mpyu	a3,a1		  ;times position factor
	add	a1,a2		  ;into accumulation register
	mpyu	a4,a3		  ;next digit is worth 10 times this one
	jruc	bcbloop

bcbdone	move	a2,a0		  ;return result in a0
	mmfm	sp,a1,a2,a3,a4,a5	   ;work reggies.
	rets

*
*	adjustment menu requested.....make sure cmos is ok!
*
go_adj	movi	men_adj,a8
	movi	trog_white,a14
	move	a14,@lastcolor,w

gen_adjust
	move	a8,-*a12,l	  ;push menu on stack

	calla	cmos_val	   	; check out the region
	jrz	set_ok	     		; its ok.....continue....

	calla	fac_set
;	jsrp	get_fac	    		; bring to factory settings or quit.
;	jsrp	any_but

	calla	cmos_val	    ;can't go if we're not ok now
	jrnz	go_adq	      ;its not valid....no adjusting!

set_ok	movk	1,a0
	move	a0,-*a12,w	  ;like gen_menu...keep number on stack
*
adj_loop calla	clr_scrn	    ;clear the screen!

	movi	adj_adv,a8
	jsrp	l_mess	      ;print the new instructions

	move	*a12(word_size),a8,l ;get the menu
	jsrp	menu_top	    ;print out the top.
;	movi	trog_yellow,a9
	movi	trog_red,a9
	calla	col_inst	    ;put up a different instr. box

	move	*a12,a9,w	   ;get index to use.
	jsrp	b_menu	      ;fetch the entry to adjust.
*
*	each adjustment has a structure associated with it.
*	a9 returns a structure for the item selected.
*
	move	a9,a9		;0 is return to main menu
	jrz	go_adjx
*
*	a8 has the menu number.....unlike gen_menu...don't step!
*
	move	a8,*a12,w	   ;put it safely on our stack.

	move	*a9(ad_rout),a0,l	;get the routine to call for activation
	movi	adj_loop,a7
	move	a7,-*a12,l	  ;push return address
	jump	a0		  ;"call the routine (passing struct in a9)

go_adjx	addi	word_size,a12	;"pop" the position indicator
go_adq	addi	long_size,a12	;pop menu
	retp			;ok...return!


**************************************************************************
*									*
*	 gen_adj							 *
*									*
*	 this is the routine that is executed to do		   *
*	 the adjusting once a button is clicked on		    *
*	 an adjustment.						*
*									*
*	 a9 -> adjustment structure!				  *
*									*
**************************************************************************

men_off	equ	pdata		;word-offset into menu of selection
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

gen_adj	move	a9,*a13(pdata),l	;save the structure pointer

	move	a9,a8		;get to general pointing register
	jsrp	do_in_white	 ;go from lf to white right away.

;	jsrp	adj_door		;can't do it unless door is open.
;	move	a0,a0
;	jrnz	adj_can	     ;cancelled
*
	callr	clr_main	    ;clear out the main menu region
	callr	adj_inst	    ;put instructions at bottom.
	jsrp	st_stick	    ;lockout stuck switches
	clr	a0
	move	a0,*a13(men_hits),w
	move	a0,*a13(men_typo),l

	sleep	1		   ;stop race on instructions
	sleep	1		   ;be over paranoid
adj_chng sleep	1		   ;now loop on stick...exit

	jsrp	getstick		; check out the player board
	move	a0,a0
	jrnz	ml1			; br = got something
	move	a0,*a13(men_hits),w	; clear timer and direction
	move	a0,*a13(men_typo),w
	jruc	adj_chng
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
	jrlo	adj_chng		; go back to sleep
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
	jrlo	adj_chng		; go back to sleep
	clr	a0
	move	a0,*a13(men_typo),w	; clear out the timer
	move	*a13(men_hits),a0,w
	andi	7h,a0			; turn off repeat bit
mldone

	move	*a13(pdata),a8,l	;get our pointer
	move	a0,a1		   ;keep getstick value
	jrz	adj_chng		;its zero....no more work needed

	move	*a8(ad_cmos),a0,w	;get adj number
	move	a0,a2		   ;copy for later

	callr	get_eadj		 ;read it out (fixing zero if nec)
	move	a0,a3		    ;save "old" value
*
*	a0 = adjustment value
*	a1 = get_stick value
*	a2 = adjustment number
*	a3 = adjustment value read!
*	a8 = adjustment structure pointer
*
	cmpi	3,a1		    ;button......back to adj menu!
	jrz	adj_butt		;yep....we're out of here.

	cmpi	2,a1
	jrz	adj_down		;its down....
*
*	request to go up....
*
	callr	inc_adj		  ;increment it
	jruc	adj_join

adj_down callr	dec_adj		  ;decrement it
adj_join move	a2,a0		    ;adjustment number
	callr	get_eadj		 ;read it out (fixing zero if nec)
	cmp	a0,a3		    ;did it not change?
	jrz	adj_chng		 ;nope....no action!
*
*	it changed....we need to beep and re-plot lower
*	portion to reflect new setting.
*
	calla	menu_select_sound
	jsrp    do_in_white	   ;and update the adjustment
	jruc	adj_chng		 ;and loop!

do_in_white
	callr	clr_cur		;clear out current setting
	movi	trog_white,a11	;they're staring....no headaches
	jauc	ad_crval		 ;print the new value

adj_butt
	calla	menu_select_sound
*
*	kill the flashing arrow
*
*	move	*a13(procid),a0,w		;now kill him
*	movi	0ffffh,a1
*	calla	kilall			;this will do it!

adj_can	retp

price_check
	cmpi	do_price,a8
	jrnz	price_ret
	mmtm	sp,a0,a1,a6
	movi	adj1st6,a0	; non-stanadard title if 1st 6 modified
	calla	get_adj		; well?
	jrnz	price_proc_ret	; put out the title line as tampered!
	movi	adj1st6,a0
	movk	1,a1
	calla	put_adj
	callr	get_cspt
	callr	set_coin_adj		; set the adjustments up in cmos
	mmfm	sp,a0,a1,a6
	move	a0,a3
	inc	a0
	setz
	jruc	price_ret
price_proc_ret	
	mmfm	sp,a0,a1,a6
	clrz
price_ret
	rets

**************************************************************************
*									*
*	 dec_adj							 *
*									*
*	 this is called to move to the previous value.		*
*	 a0 = value read from cmos				    *
*	 a2 = adjustment number (to write it back)		    *
*	 a8 = adjustment structure pointer.			   *
*									*
*	 inc_adj is used to step to the next value		    *
*									*
**************************************************************************

dec_adj	mmtm	sp,a0,a1,a2,a3
	callr	price_check
	jrz	finish_change
	move	a0,a3			 ;copy original value
	move	*a8(ad_delta),a1,l	    ;get units between values
	callr	make_bin_if_nec		;change radix for math if necessary
	sub	a1,a0			 ;remove this from read value
	jruc	finish_change		 ;go to common routine to wrap it up

inc_adj	mmtm	sp,a0,a1,a2,a3
	callr	price_check
	jrz	finish_change
	move	a0,a3			 ;copy original value
	move	*a8(ad_delta),a1,l	    ;get units between values
	callr	make_bin_if_nec
	add	 a1,a0			;remove this from read value

finish_change
	callr	bcd_if_nec		    ;back to bcd after the math
	callr	put_in_range		  ;adjust to account for wrap and limits
	move	*a8(ad_zequ),a1,l		;this number becomes zero
	cmp	a0,a1			 ;is this the number?
	jrnz	fc_nz			 ;nope...store it!
	clr	a0			    ;use zero in place of this number!

fc_nz	move	a0,a1			 ;writing reg
	move	a2,a0			 ;adjustment number
	calla	put_adj			;write it back
*
*	see if we're doing master coinage.
*
	cmp	a1,a3			 ;did the number change?
	jrz	not_coin			 ;nope...don't load it up!
*
*	at this point we know that the value being adjusted changed.
*
	callr	dirty_if_nec		  ;if its a coin value take note!

	cmpi	adjprice,a0		   ;is it?
	jrnz	not_coin			 ;not coin

;	calla	ld_ctab			;batch write the values in!
	calla	no_creds			 ;remove credits and fractions when
*						 ;mode changes

not_coin
	calla	cmosunlock
	calla	f_adc_s			;make checksum valid!
	calla	cmoslock
	mmfm	sp,a0,a1,a2,a3
	rets

**************************************************************************
*									*
*	 dirty_if_nec						 *
*									*
*	 this is called by all adjustments when they actually	 *
*	 change their value.  for the coinage adjustments,	    *
*	 if any of the 1st 6 values are touched we need to make	*
*									*
*			 adj1st6 = zero.				 *
*									*
*	 if any of the 1st 8 values are touched we need to make	*
*									*
*			 adjvirgin = zero.			    *
*									*
*	 the ad_flags field in the adjustment structure have bits	    *
*	 indicating which (if any) should be dirtyed.		 *
*									*
**************************************************************************
dirty_if_nec
	mmtm	sp,a0,a1,a2
	move	*a8(ad_flags),a2,w	;fetch the flags

	btst	virg_bit,a2		 ;does changing this say set virg bit.
	jrz	not_1st_8		;nope

	movi	adjvirgin,a0
	clr	a1
	calla	put_adj

not_1st_8
	btst	six_bit,a2		;1st 6?
	jrz	not_1st_6

	movi	adj1st6,a0
	clr	a1
	calla	put_adj
not_1st_6
;	btst	hsr_bit,a2		;high score reset num?
;	jrz	not_hsr		  ;nope
;	calla	init_hsr		 ;it was changed....stuff the value!

not_hsr
	mmfm	sp,a0,a1,a2
	rets

**************************************************************************
*									*
*	 make_bin_if_nec						 *
*									*
*	 this is called after the a0 has the adjustment and	   *
*	 a1 has the amount to add or subtract.  if we're	      *
*	 doing bcd math then convert both a0 and a1.		  *
*									*
**************************************************************************
make_bin_if_nec
	mmtm	sp,a2
	move	*a8(ad_flags),a2,w	    ;get the flags
	btst	bcd_bit,a2		    ;bcd?
	jrz	mbinx			 ;nope

	calla	bcdbin			;convert a0 to binary
	move	a0,a2			 ;save
	move	a1,a0			 ;now a1
	calla	bcdbin
	move	a0,a1
	move	a2,a0			 ;now put a0 back
mbinx	mmfm	sp,a2
	rets

**************************************************************************
*									*
*	 bcd_if_nec						   *
*									*
*	 a0 has a result of the adjustment.....in binary.		*
*	 convert back to bcd if that's the mode.		      *
*									*
**************************************************************************
bcd_if_nec
	mmtm	sp,a2
	move	*a8(ad_flags),a2,w	    ;get the flags
	btst	bcd_bit,a2		    ;bcd?
	jrz	binx			  ;nope

	calla	binbcd			;back to bcd

binx	mmfm	sp,a2
	rets

adj_beep   .word 	>f3df,>10,>80a2,0		;low beep 
adj_cash   .word 	>f3df,>10,>8098,0		;cash reggie

**************************************************************************
*									*
*	 clr_cur							 *
*									*
*	 this is called to clear out the area where the		*
*	 "current setting" is being displayed.			*
*									*
**************************************************************************
clr_cur	mmtm	sp,a3,a4
	move	*a13(ads_struct),a4,l
	cmpi	do_price,a4
	jrz	ccskip
	cmpi	do_param,a4
	jrz	ccskip

	movi	am_hx,a3	    ;this is left margin of help area

	movi	cur_lrx,a4	  ;right x
	sub	a3,a4		;a4 has x distance

	addi	adj_uly*10000h,a3	;upper left y
	addi	(400-adj_uly)*10000h,a4  ;y goes to bottom of screen
	calla	blnkarea		;its blank now!
ccskip
	mmfm	sp,a3,a4
	rets

**************************************************************************
*									*
*	 clr_main							*
*									*
*	 this is called to clear out the adjustment menu and	  *
*	 the cyan instructions for this menu.			 *
*									*
**************************************************************************
clr_main mmtm	sp,a3,a4
	movi	tit_ulx,a3	  ;left edge
	movi	am_hx,a4	;up to this edge
	sub	a3,a4		;x's are set.
	addi	inst_uly*10000h,a3	;top y
	addi	(400-inst_uly)*10000h,a4	;y distance
	calla	blnkarea
	mmfm	sp,a3,a4
	rets

adj_lbeep   .word	>f3df,>10,>80a2,0		;low beep 
*	
**************************************************************************
*									*
*	 adj_inst							*
*									*
*	 this is called to put an instruction box out		 *
*	 while adjustment is taking place.			    *
*									*
**************************************************************************
adj_inst 
	move	*a13(pdata),a8,l	;pass the adjustment pointer
	movi	adj_inst_p,a7
	calla	p_fork	      ;start it up!
	rets

**************************************************************************
*									*
*	 adj_inst_p						   *
*									*
*	 this is called to put instructions for adjustment	    *
*	 modificaition up and flash the arrow (if its not		*
*	 too annoying)						*
*									*
**************************************************************************

adj_inst_p
	jsrp   adjusting	;put up "adjusting difficulty" message

	move	a10,a3	 ;stash # of arrows where it will be safe
	callr	adinbox	;put the box out

	movi	inst_to_adj,a8
	jsrp	l_mess	 ;print out instructions

	movi	adj_arrow,a8
	calla	lm_setup
	jsrp	printf
;	jsrp	l_mess

	jauc	sucide

**************************************************************************
*									*
*	 adinbox							 *
*									*
*	 this puts a box around the adjustment instructions.	  *
*									*
**************************************************************************
*
inbox_height	equ	80h

adinbox	mmtm	sp,a10
	movi	cur_uly,a10	 ;plot to square up with "current setting"
	sll	16,a10
	movi	tit_ulx,a4	  ;upper right x
	movy	a10,a4	      ;upper right

	movi	am_rx,a5
	movy	a10,a5	      ;start with base y
	addi	inbox_height*10000h,a5

	callr	wh_bord
	mmfm	sp,a10
	rets

**************************************************************************
*									*
*	 adjusting						    *
*									*
*	 this is called when we enter the "adjusting" phase	   *
*	 it puts a box in the left area to say what we are adjusting.  *
*									*
**************************************************************************

adjusting
	move	a8,a2		;put adjustment block ptr where its safe
	movi	(cur_uly-30h)*10000h,a4	;for do_border
	addi	tit_ulx,a4		    ;a4 is reasonably easy

	movi	(cur_uly+mb_ywid)*10000h,a5	;overlap the one below it
	addi	am_rx,a5			 ;this is right edge

	callr	wh_bord			;do a white border

	movi	mes_adname,a8		 ;put the adjustment name up
	calla	lm_setup
	move	*a2(ad_main),a8,l		;get the main menu message
	jsrp	lm_xfinis

	movi	mes_adjusting,a8
	jsrp	l_mess
	retp

**************************************************************************
*									*
*	 param_val						    *
*									*
*	 this is called to summarize the values of the		*
*	 important adjustments on the parameter page.		 *
*									*
**************************************************************************
*
*	we will pring out 3 lines in a box.
*
*	1) pricing:
*	2) free play:	yes/no
*	3) maximum credits:
*

;pdy	 equ	 help_dy+(help_dy/2)
pdy	equ	12
pmarg	equ	17

param_val
	movi	4,a1			;setup a box for our 3 lines
	movk	5,a4
	callr	padj_box		  ;(a10 is set as y for the 3 lines)

	subi	3,a10			; move that little puppy around

	callr	get_coin_title	   ;coin mode
	movi	mess_gp,a8
	jsrp	small_left_right	 ;print the lines

	addi	pdy,a10	      ;push to next line

	movi	m_no,a2		  ;assume "no"
	movi	adjfrepl,a0
	calla	get_adj		  ;get the free play adjustment
	jrz	not_free
	movi	m_yes,a2

not_free movi	mess_fp,a8
	jsrp	small_left_right	 ;print the lines

	addi	pdy,a10	      ;push to next line
	
	movi	adjmaxc,a0
	movi	mess_max,a8
	jsrp	adj_left_right		;a0 = adjust  a8 = message
*
*	credits to start and continue needs to handle plural etc.
*
	addi	pdy,a10	      ;push to next line
	movi	adjcstrt,a0	 ;get credits required to start
	movi	m_cts_pl,a8					
	jsrp	adj_left_right		;a0 = adjust  a8 = message
*									
*	now the credits to continue				
*									
	addi	pdy,a10	      ;push to next line
	movi	adjccont,a0	 ;get credits required to continu
	movi	m_ctc_pl,a8					
	jsrp	adj_left_right		;a0 = adjust  a8 = message

	retp

**************************************************************************
*									*
*	 adj_left_right						*
*									*
*	 a8 has message						*
*	 a0 has adjustment					    *
*	 a10 has height.						 *
*									*
*	 left justify a8 message					 *
*	 right justify a0 adjustment (after reading it)		*
*									*
**************************************************************************
adj_left_right
	move	a8,a3		;stash message

	calla	get_adj
	move	a0,a8
	calla	hextoasc	    ;a8 points to number string

	move	a8,a2
	move	a3,a8		;get message in a8

	jruc	small_left_right

**************************************************************************
*									*
*	 small_left_right						*
*									*
*	 this is called to print a left and right justified	   *
*	 pair of strings in the "current setting box"		 *
*									*
*	 a2 = right justified string				  *
*	 a8 = left justified string to print			  *
*	 a10 = y value						*
*									*
**************************************************************************
small_left_right
	mmtm	a12,a11,a6,a10,a9,a3

;	movi	trog_white,a6	    ;solid white for these multi-liners
	movi	trog_pwhite,a5
	movi	rd7font,a11	 ;use baby font

	movi	am_hx+pmarg,a9	  ;left x is inside left line

	move	a10,a3		 ;save y in a3
	sll	16,a3
	movy	a3,a9		;pointer set!

	movi	spacing07,a10

	clr	a0
	calla	stringf
	jsrp	strlnrm	     ;do it!

	move	a2,a8		;get right justified string
	movi	tit_lrx-pmarg,a9  ;inside right margin
	movy	a3,a9		;at our y
	calla	stringf
	jsrp	strrnrm	     ;print it!

	mmfm	a12,a11,a6,a10,a9,a3
	retp

**************************************************************************
*									*
*	 coin_set							*
*									*
*	 this is the routine that is called to display the current     *
*	 coinage settings.					    *
*									*
*	 a8 has pointer to adjustment block			   *
*	 a11 has the color to use					*
*									*
**************************************************************************
coin_set
	callr	tamperedp	   ;has the 1st 6 coin value been tampered with?
	jrz	sbo		 ;yep....small box only!

	callr	clr_cur
	movi	6,a1			;big box for outside
	movk	5,a4			; gross kludge to offset box
	callr	cadj_box
sbo	movi	1,a1			;draw a box to hold 1 line
	clr	a4
	callr	cadj_box		  ;draw the box....pass back 1st plot line

	movi	[adj_culy+5,am_hx+5],a3
	movi	[21,175],a4
	calla	blnkarea
	movi	[adj_culy+31,am_hx+5],a3
	movi	[58,178],a4
	calla	blnkarea

*
*	the above 2 calls should create a box like:
*
*
*		   ษอออออออออออออออออออป
*		   บ  current setting  บ
*		   ศอออออออออออออออออออผ
*		   ษอออออออออออออออออออป
*		   บ	 u.s.a. 1	  บ
*		   บอออออออออออออออออออน
*		   บ 1 coin / 1 credit บ
*		   บ			  บ
*		   บ		  	  บ
*		   บ 25c   $1.00   25c บ
*		   ศอออออออออออออออออออผ
*
*		f10 has the place to plot the title line.
*
	move	a10,a4	      ;keep the y handy.
*
	callr	get_coin_title		;get title for big box in a2.
*
*	a2 has string
*	a11 is color
*	a10 is y to print
*
coin_tit
;	addi	2,a10		    ;center the large text
***	inc	a10
	subk	5,a10
	movi	trog_lf,a11	    ;don't glow inside box if that's the mode
	jsrp	do_big_line		 ;print this line!

	movi	trog_white,a11	    ;don't glow inside box if that's the mode
;	callr	ckdip
;	jrz	no_info

	callr	tamperedp	   ;has the 1st 6 coin value been tampered with?
	jrz	no_info	     ;yep....just give the starts and continues

	calla	get_cspt	    ;a6 points at the cselect block

	callr	set_coin_adj		; setup the coin adjustments

	move	*a6(cs_list),a2,l	;fetch pointer to message list
	jrz	no_headers	  ;no list!

	movi	coin_head_y,a10 	;at this height

next_header
	move	*a2+,a8,l	
	jrz	no_headers	  ;headers are out...continue

	jsrp	print_small_line	;print the line
	addi	12,a10	      ;push to next line
	jruc	next_header

no_headers
	movi	mess_cts,a10	;set y for coin slot line.
	movi	m_slotval,a8
	jsrp	print_small_line	;header for coin slot value

	addi	12,a10	      ;push y up for a gap	    *

	calla	get_cspt	    ;a6 points at the cselect block
	move	*a6(cs_slots),a8,l	;print coin slot info
	jsrp	print_small_line	 ;print the line

	movi	adjcstrt,a0		; credits to start
	calla	get_adj	
	move	a0,@ramtemp1,l
*print the credits required to continue
	movi	adjccont,a0		; credits to continue
	calla	get_adj	
	move	a0,@ramtemp2,l
	movi	tostoc_mess,a8
	jsrp	lm_printf


no_info
	retp			;done for now


tostoc_mess
         mess_mac  rd7font,spacing07,am_hx+88,adj_culy+17,trog_pwhite,strcnrm,0
	.string	"%d TO START. %d TO CONTINUE.",0
	.long	ramtemp1
	.long	ramtemp2

erase_cur
	movi	(cur_uly2*10000h),a4
	move	*a13(ads_lx),a9,w		;get left x
	movx	a9,a4			 ;set it for this box.
	movi	cur_lrx+(cur_lry2*10000h),a5
	movi	trog_black,a9
	calla	std_bord			 ;adjustment border is up.

	movi	mess_curset,a8		;put up the current message text
	calla	lm_setup
	movi	trog_pblack,a5

	move	*a13(ads_cx),a2,w	;get center x
	movx	a2,a9		;put center x in
	jsrp	lm_xfinis
	rets


**************************************************************************
*									*
*	 get_coin_title						*
*									*
*	 this is called to fetch the character string message	 *
*	 for the current coin mode.	if its standard, then	    *
*	 it is fetched based on the coin select table.		*
*									*
*	 if the 1st 6 parameters have been modified, then		*
*	 it returns the string "non-standard".			*
*									*
**************************************************************************
get_coin_title
	mmtm	sp,a6		;preserve for coin select table

	calla	get_cspt	    ;a6 points at the cselect block
	movi	mess_dip,a2
	callr	ckdip
	jrz	gctx

	movi	mess_tampered,a2

	movi	adj1st6,a0	;non-stanadard title if 1st 6 modified
	calla	get_adj	     	;well?
	jrz	gctx		;put out the title line as tampered!

	move	*a6(cs_title),a2,l	;get the cselect title for its values

gctx	mmfm	sp,a6		;preserve for coin select table
	rets

**************************************************************************
*									*
*	 tamperedp						    *
*									*
*	 have the coin parameters been tampered with.		 *
*	 this is non-zero if any of the 1st 6 coin		    *
*	 parameters have been adjusted.				*
*									*
**************************************************************************
tamperedp
	mmtm	sp,a0
	movi	adj1st6,a0	  ;just check the 1st 6
	calla	get_adj	     ;has it been tampered with (0 means yes)
	mmfm	sp,a0
	rets

ckdip
	calla	read_dip
	andi	dip_cmoscoin,a0
	move	a0,a0
	rets


;	.if	yunit
;	calla	read_dip
;	andi	dip_cmoscoin,a0
;	.else
;	clr	a0
;	.endif
;	move	a0,a0
;	rets

**************************************************************************
*									*
*	set_coin_adj							*
*									*
*	set the coin adjustment stuff from whatever is pointed to by	*
*	a6								*
*									*
*	entry								*
*		a6	pointer to the first 6 adjustments ( sort of )	*
*									*
*	exit								*
*		nothing							*
*									*
**************************************************************************

set_coin_adj:
	mmtm	sp,a0,a1,a6,a7
	movi	adjlmult,a0
	move	*a6+,a1,w
	calla	put_adj
	movi	adjcmult,a0
	move	*a6+,a1,w
	calla	put_adj
	movi	adjrmult,a0
	move	*a6+,a1,w
	calla	put_adj
	movi	adj4mult,a0		; new addition, folks!
	move	*a6+,a1,w
	calla	put_adj
	movi	adjcunit,a0
	move	*a6+,a1,w
	calla	put_adj
	movi	adjbunit,a0
	move	*a6+,a1,w
	calla	put_adj
	movi	adjmunit,a0
	move	*a6+,a1,w
	calla	put_adj
	movi	adjcstrt,a0
	move	*a6+,a1,w
	calla	put_adj
	movi	adjccont,a0
	move	*a6+,a1,w
	calla	put_adj
	movi	adjcdiv,a0
	move	*a6+,a1,w
	calla	put_adj
	movi	adjfrac,a0
	move	*a6+,a1,w
	calla	put_adj

	calla	cmosunlock
	calla	f_adc_s			; keep the world a happy place
	calla	cmoslock

	mmfm	sp,a0,a1,a6,a7
	rets




**************************************************************************
*									*
*	 print_small_line						*
*									*
*	 this is called to print a line in the "current setting"	    *
*	 box for the coinage.					 *
*									*
*	 a8 = string to print					 *
*	 a11 = color						  *
*	 a10 = y value						*
*									*
*	 print in the 7 point font with x centered for the	    *
*	 help system.						 *
*									*
**************************************************************************
print_small_line
	mmtm	a12,a11,a6,a10,a9

;	move	a11,a6	      ;color set
	move	a11,a5
	sll	16,a5			; fix it up some more
	movi	rd7font,a11	 ;use baby font

	movi	am_hx,a9,w	  ;get left x
	callr	left_to_center		;convert it

	move	a10,a0
	sll	16,a0
	movy	a0,a9		;pointer set!

	movi	spacing07,a10

	clr	a0

	calla	stringf
	jsrp	strcnrm	     ;do it!

	mmfm	a12,a11,a6,a10,a9
	retp

*
*	do_adjh
*
*	this is called to plot the right half of the screen
*	for each adjustment as the user selects them on
*	the adjustment menu.
*
*	the format is as follows:
*
*    ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
*    บ		     a d j u s t m e n t	  m e n u					บ
*    บ			newgame revision  x.xx						บ
*    ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*    ษอออออออออออออออออออออออออออออป	ษออออออออออออออออออออออออออออออออออป
*    บ	select blah blah blah	  บ	บ	 game difficulty			บ
*    ศอออออออออออออออออออออออออออออผ	ศออออออออออออออออออออออออออออออออออผ
*    ษอออออออออออออออออออออออออออออป	ษอออออออออออออออออออออออออออออออออป
*    บ	  return to main menu	  บ	บ  this controls the overall	    บ
*    บ	    standard pricing	  บ	บ  difficulty of game play.	    บ
*    บ=======game difficulty=======บ	บ						    บ
*    บ	    lives per play	  บ	บ  range of settings:  1-9	    บ
*    บ	    extra man every	  บ	บ						    บ
*    บ	  number of extra men	  บ	บ  easiest setting: 1		    บ
*    บ	 auto high score reset	  บ	บ  hardest setting: 9		    บ
*    บ	      free play		  บ	บ  factory setting: 5		    บ
*    บ	   high score entry	  บ	ศอออออออออออออออออออออออออออออออออผ
*    บ	 allow game continue	  บ	ษออออออออออออออออออออออออออออออออออป
*    บ	 return to main menu	  บ	บ	current setting			บ
*    บ				  บ	ศออออออออออออออออออออออออออออออออออผ
*    บ				  บ	ษออออออออออออออออออออออออออออออออออป
*    บ				  บ	บ							บ
*    บ				  บ	บ	 9 - extra hard			บ
*    บ				  บ	บ							บ
*    ศอออออออออออออออออออออออออออออผ	ศออออออออออออออออออออออออออออออออออผ
*
*
*	on entry....a1 points at the 3 words for current
*	menu entry.
*
do_adjh
*
*	first we blank out the area...we need to do this from
*	the menu process since the right edge is determined by
*	menu pdata stuff.  it will return in a9 the margin we 
*	should work from.
*
	calla	blnkhelp	    ;blank out the area we're plotting!
	move	a1,a8		;pass the structure pointer to new process!
	movi	ad_slave,a7
	calla	p_fork	      ;this creates it!
	rets			;now return to menu handler!

**************************************************************************
*									*
*	 ad_slave							*
*									*
*	 this is forked to plot the right side...it has		*
*	 its own pdata area for info storage.			 *
*									*
*	 a8 = pointer to the menu selection 3 long-word entry	 *
*	 a9 = left x margin for our work.				*
*									*
**************************************************************************
ads_struct	equ	pdata		 ;long-pointer to adjustment structure
ads_lx	  equ	  ads_struct+long_size   ;word-left x to work from
ads_cx	  equ	  ads_lx+word_size	    ;word-center x for work

ad_slave
	move	*a8(menu_routine),a11,l	;now we have our special structure!
	move	a11,*a13(ads_struct),l	;stash it...we'll need it
	move	a9,*a13(ads_lx),w	;also the x.....

	move	a9,a4		    ;copy left for border rout
	callr	left_to_center

	move	a9,*a13(ads_cx),w	;stash the center
*
*	 a4 = upper left y,x					
*	 a5 = lower right y,x					
*	 a0 = y,x width of border				
*	 a9 = color of border.					
*
	addi	inst_uly*10000h,a4	  ;add in the y
	movi	(inst_lry*10000h)+tit_lrx,a5 ;this is other edge.
;	movi	trog_purple,a9
;
	cmpi	do_param,a11		; really disgusting way to reset
	jrnz	ads1			; white color on return from custom
	movi	trog_white,a9
	move	a9,@lastcolor,w
ads1
	move	@lastcolor,a9,w
	calla	std_bord			 ;adjustment border is up.
*
	movi	adjt_setup,a8
	calla	lm_setup			 ;setup to print title

	move	*a13(ads_cx),a2,w		;get the x
	movx	a2,a9			 ;substitute our x in.

	move	*a13(ads_struct),a2,l	 ;get structure pointer
	move	*a2(ad_title),a8,l	    ;get message pointer

	jsrp	lm_xfinis			 ;box and title are up.
;
;	here is a really neat place to screw with the help structure for
;	dipswitch setting help -- gross, huh?
;
	move	*a2(ad_help),a8,l	; get the help structure
	callr	ckdip
	jrnz	adsskip
	cmpi	help_price,a8		; pricing help
	jrz	adsdip
	cmpi	help_param,a8		; parameter help
	jrz	adsdip
	cmpi	help_free,a8		; freeplay help
	jrnz	adsskip
adsdip
	movi	help_dip,a8
adsskip
	move	*a13(ads_lx),a9,w		;left x for help box
	movi	inst_lry+box_ygap,a10	 ;this is help box position
	addi	10000h,a10		    ;flag that this is top..not center!

	movi	h_slave,a7	  ;fork off so it can use pdata!
	calla	p_fork	      ;start up another w/ same id
*
*	now we need to show the current setting on the lower half of
*	the screen.
*
*	lets build the "current setting" title box first.
*
;
;	plots box 3 of things on the right hand side
;
	move	*a13(ads_struct),a4,l
	cmpi	do_price,a4
	jrz	skipcurrent
	cmpi	do_param,a4
	jrz	skipcurrent
	movi	((cur_uly2+5)*10000h),a4
	move	*a13(ads_lx),a9,w		;get left x
	movx	a9,a4			 ;set it for this box.
	movi	cur_lrx+(cur_lry2*10000h),a5
	move	@lastcolor,a9,w
;	movi	trog_purple,a9
	calla	std_bord			 ;adjustment border is up.

	movi	mess_curset,a8		;put up the current message text
	calla	lm_setup

	move	*a13(ads_cx),a2,w	;get center x
	movx	a2,a9		;put center x in
	jsrp	lm_xfinis
skipcurrent

	move	*a13(ads_struct),a8,l   ;get the adjustment structure
	movi	trog_lf,a11	  ;indicate standard color.
	jsrp	ad_crval		;print screen showing the current value

	jauc	sucide	      ;our job is done!...exit

**************************************************************************
*									*
*	 left_to_center						*
*									*
*	 this is called to find the center point for a box based on    *
*	 the left passed in a9.  center x returned in a9.		*
*									*
**************************************************************************
left_to_center
	addi	tit_lrx,a9		;find box center
	srl	1,a9			;now we have the center
	addi	c_kludge,a9		 ;make it center correctly
	rets

**************************************************************************
*									*
*	 ad_crval							*
*									*
*	 this is called to print the current value for any	    *
*	 adjustment.  the value should be printed and boxed	   *
*	 in the lower right region under the "current setting"	*
*	 header.							 *
*									*
*	 a8 -> adjustment structure				   *
*	 a11  -> color to use					 *
*	 adj_lefx (global ram) contains left margin for this.	 *
*									*
**************************************************************************

ad_crval move	*a8(ad_nameit),a0,l		;fetch the "name-it" routine
	jump	a0			;and "jsrp" that routine

**************************************************************************
*									*
*	 hex_or_mess						  *
*									*
*	 this is called for the extra man every...and		 *
*	 "last extra man" adjustments.  it prints out		 *
*	 the hex adjustment with commas, or prints		    *
*	 the message stored at a8(ad_namptr) on its lowest value.	    *
*									*
*	 ****** note that "bin_or_mess" (below) uses parts of this!    *
*									*
**************************************************************************
hex_or_mess
	mmtm	sp,a8		    ;preserve a8 please

	callr	adj_stuff		;get the reggies fixed up.
*
*	now a0 has the adjustment....form the c-string
*
	move	*a8(ad_min),a1,l	 ;get minimum value
	cmp	a0,a1		    ;are we at minimum?
	jrnz	not_min		  ;nope

at_min	move	*a8(ad_namptr),a8,l		;get the message pointer
	jruc	prt_min

not_min	move	a0,a8
	movk	1,a3			;indicate commas are desired
	calla	htohxasc		 ;convert a8 to this number

prt_min	move	a8,a2
	mmfm	sp,a8		    ;preserve a8 please

	subi	4,a10
	jsrp	do_big_line		 ;now print it out
	retp				;and return

**************************************************************************
*									*
*	 bin_or_mess						  *
*									*
*	 this is called to print a binary number or		   *
*	 a message at a8(ad_namptr) if it is at minimum.		 *
*									*
**************************************************************************
bin_or_mess
	mmtm	sp,a8		    ;preserve a8 please

	callr	adj_stuff		;get the reggies fixed up.
*
*	now a0 has the adjustment....form the c-string
*
	move	*a8(ad_min),a1,l	 ;get minimum value
	cmp	a0,a1		    ;are we at minimum?
	jrz	at_min		   ;yep.....print "off"

	calla	binbcd		   ;turn to bcd please
	jruc	not_min		  ;and now print with commas.

**************************************************************************
*									*
*	 just_bin							*
*									*
*	 this is called to print out the adjustment		   *
*	 (stored in binaray) in decimal.				 *
*									*
**************************************************************************
just_bin
	mmtm	sp,a8		    ;preserve a8 please

	callr	adj_stuff		;get the reggies fixed up.
*
*	now a0 has the adjustment....form the c-string
*
	calla	binbcd		   ;turn it to bcd!
	jruc	not_min

**************************************************************************
*									*
*	 list_1line						   *
*									*
*	 this is called to do a 1 line listing of messages	    *
*	 assocaited with the current adjustment.			 *
*	 a8 = structure						*
*	 a11 = color of text inside box.				 *
*									*
**************************************************************************
list_1line
	callr	adj_stuff		;get the reggies fixed up.

	move	*a8(ad_max),a1,l	 ;is it too high?
	cmp	a1,a0		    ;compare to adjustment
	jrls	l1l1			;in range.....
*
*	adjustment is too high...don't go through table!
*
	movi	m_null,a2		;use null pointer
	jruc	l1l2

l1l1	move	*a8(ad_min),a1,l	 ;get the lowest value
	sub	a1,a0		    ;this is offset
	movi	long_size,a1		;this many long words
	mpyu	a0,a1		    ;this is offset into table
	move	*a8(ad_namptr),a0,l		;this is table base
;
;	this is really gross here, but it is easier than doing it right
;
	cmpi	do_free,a8		; is it a freeplay item
	jrnz	ligo
	push	a0
	calla	ckdip			; check for dip switch setting
	pull	a0
	jrnz	ligo
	movi	list_dipnoyes,a0
ligo
	add	a1,a0		    ;a0 has the text of the single line
	move	*a0,a2,l		 ;get the vector
*
*	text pointer in a2
*	color in a11
*	y in a10
*
l1l2	
	subi	4,a10		; autoposition the single line
	jsrp	do_big_line		 ;print out this line
	retp				;now return

**************************************************************************
*									*
*	 adj_stuff						    *
*									*
*	 this is called by the routines that display		  *
*	 adjustments.  it plots the box and returns:		  *
*									*
*		 a10 = height for 15 point single text line	   *
*		 a0 =  adjustment with zero substitution completed.    *
*									*
**************************************************************************
adj_stuff
	movi	2,a1			;indicate 2 puny lines (for our big one)
	callr	adj_box		  ;draw the box....pass back 1st plot line
*
*	a10 has y height of 1st entry.
*
	addi	2,a10		    ;center the large text
*
	move	*a8(ad_cmos),a0,w	;get adjustment number
	callr	get_eadj		 ;fetch the current value.

	callr	put_in_range		;if its out of range, fix it!
	rets

**************************************************************************
*									*
*	 do_big_line						  *
*									*
*	 this is called to do a single line for an adjustment	 *
*	 "current adjustment" box.				    *
*									*
*	 a2 = pointer to text					 *
*	 a10 = y coordinate					   *
*	 a11 = color						  *
*									*
*	 x left coordinate is in global "adj_lefx"		    *
*									*
**************************************************************************
do_big_line
	mmtm	a12,a10,a11,a8		;save stuff for caller
;	move	a11,a6
	move	a11,a5
	sll	16,a5
	movi	am_hx,a9,w	  ;get left x
	callr	left_to_center		;convert it
	sll	16,a10	      ;shift y down
	movy	a10,a9	      ;x,y set
	move	a2,a8		;text pointer
	clr	a0		  ;no sleep
	movi	spacing07,a10
	movi	rd7font,a11
	calla	stringf
	jsrp	strcnrm	     ;do it!
	mmfm	a12,a10,a11,a8		;pop the stuff.
	retp

**************************************************************************
*									*
*	 get_eadj							*
*									*
*	 this is like get_adj, however if zero comes out,		*
*	 we check to see if there is a logical number to		 *
*	 pass out in place of the zero.				*
*									*
*	 a8 points at the adjustment structure.			*
*									*
**************************************************************************
get_eadj
	mmtm	sp,a1
	calla	get_adj	     ;fetch the adjustment
	jrnz	get_ea1	     ;its not zero....return
*
*	its zero....see if there's a value to sub
*
	move	*a8(ad_zequ),a1,l	;is there a sub value?
	jrz	get_ea1	     ;nope...return the zero (and flag)

	move	a1,a0		;return the substitute value
get_ea1	mmfm	sp,a1
	rets

**************************************************************************
*									*
*	 put_in_range						 *
*									*
*	 this is called to take an adjustment and make sure	   *
*	 it has a valid value.	if its between the min and max	*
*	 (inclusive) allowed, then we return with no action.	  *
*									*
*	 if its outside, then we set it according to the		 *
*	 "wrap_around" parameter.					*
*									*
*	 a0 has adjustment value					 *
*	 a8 points at adjustment structure.			   *
*									*
*	 return new value in a0.					 *
*									*
**************************************************************************
put_in_range
	mmtm	sp,a1,a2,a3
	move	*a8(ad_min),a1,l	 ;get minimum
	move	*a8(ad_max),a2,l	 ;get maximum
	move	*a8(ad_flags),a3,w	;are we wrapping around
	btst	wrap_bit,a3		 ;well?
	jrnz	ck_wrap		  ;yep....use a fancy handler.

	cmp	a1,a0		    ;are we too low?
	jrhs	not_lo
*
*	its too low.....use minimum
*
use_lo	move	a1,a0

*
*	we're not wrapping aroung....if its mega-high....keep it
*	at the low boundary.
*
not_lo	cmpi	090000000h,a0	
	jrhi	use_lo		   ;use the low value!

	cmp	a2,a0
	jrls	pirx

use_hi	move	a2,a0
	jruc	pirx
*
*	we need to wrap from lowest to highest
*
ck_wrap
	cmpi	090000000h,a0	    ;in this range, we must have wrapped down
	jrhi	use_hi		   ;so use high value

	cmp	a1,a0		    ;is it lower than lo?
	jrlo	use_hi		   ;it is ....use the high one.

	cmp	a2,a0		    ;is it too high?
	jrhi	use_lo		   ;it is....use the low one.

pirx	mmfm	sp,a1,a2,a3
	rets

**************************************************************************
*									*
*	 adj_box							 *
*									*
*	 a1 has number of lines for adjustment			*
*	 return a10 at y if 1st line of box.			  *
*									*
**************************************************************************

cadj_box
	mmtm	sp,a4,a5,a0,a9
	movi	adj_culy,a10
	jruc	adj_ent

padj_box
	mmtm	sp,a4,a5,a0,a9
	movi	adj_puly,a10
	jruc	adj_ent

adj_box	mmtm	sp,a4,a5,a0,a9
*
	movi	adj_uly,a10		 ;this is top of box
	clr	a4

adj_ent
	cmpi	2,a1
	jrnz	adj_ent_normal
	movk	8,a5			; 1 liner kludge
	jruc	adj_ent_go
adj_ent_normal
	movi	help_dy,a5		;distance per entry
	mpyu	a1,a5		    ;distance for all entries
adj_ent_go
	add	a4,a5			; fix it up a little
	addi	help_y_margin+(mb_ywid*2)+help_ylo_margin,a5
*
*	a5 now contains full height of box
*
*

*	now form upper left in a4
*
	move	a10,a4		   ;move y over
	sll	16,a4		    ;make room for x
	addi	am_hx,a4		    ;put in the x...this is upper left!

	add	a10,a5		   ;add base to offset
	sll	16,a5		    ;put in y position
	addi	tit_lrx,a5		;add in the x for the corner
*
*	now adjust from top of box to position of
*	1st entry.
*
	addi	mb_ywid+help_y_margin,a10  ;y of 1st entry
*
*	a10 is now set for return value
*
	movi	trog_yellow,a9	   ;make these boxes yellow

	calla	std_bord
	mmfm	sp,a4,a5,a0,a9
	rets

wh_bord	mmtm	sp,a9			; jkm
	movi	trog_white,a9
	calla	std_bord
	mmfm	sp,a9
	rets

**** data section begins ****

	.data
*
*	game adjustment
*
*	the following structures are for each adjustment
*
*	ad_rout  equ	 0			;long...routine to run when selected.
*	ad_title equ	 ad_rout+long_size	;long...pointer to title for right column
*	ad_help  equ	 ad_title+long_size	;long...point to help struct for explanation
*	ad_cmos  equ	 ad_help+long_size	;word...get_adj / put_adj number.
*	ad_min	 equ	 ad_cmos+word_size	;long...minimum value for adj.
*	ad_max	 equ	 ad_min+long_size	 ;long...maximum value for adj.
*	ad_delta equ	 ad_max+long_size	 ;long...units between values.
*	ad_zequ  equ	 ad_delta+long_size	;long...number to store in memory as zero
*	ad_nameit equ	 ad_hyper+long_size	;long...routine to print values.
*	ad_wrap  equ	 ad_nameit+long_size	    ;word...non zero to wrap from highest to lowest
*	ad_namptr equ	 ad_wrap+word_size	;long...pointer to data for nameit routine
*


do_price
	.long	gen_adj		; routine to run
	.long	mess_price	; pointer to header message
	.long	help_price	; pointer to help messages for right side
	.word	adjprice	; cmos adjustment we're setting
	.long	1		; minimum value
	.long	cs_ents		; maximum value
	.long	1		; move up and down by 1's
	.long	0		; don't sub zero for any
	.long	coin_set	; message list used for values.
	.word	wrap_val	; wrap around on coin modes
	.long	0		; list of messages for this adj.
	.long	mess_price	; pointer to header message

***********************************************************************

;	.long	gen_adj		; routine to run
;	.long	msg_card	; pointer to header message
;	.long	help_card	; pointer to help messages for right side
;	.word	adj_card	; cmos adjustment we're setting
;	.long	0		; minimum value
;	.long	6		; maximum value
;	.long	1		; move up and down by 1's
;	.long	0		; don't sub zero for any
;	.long	list_1line	; message list used for values.
;	.word	0		; don't wrap around
;	.long	card_choices	; list of messages for this adj.
;	.long	msg_card	; pointer to header message


do_ddiff
	.long	gen_adj		; routine to run
	.long	txt_ddiff	; pointer to header message
	.long	help_ddiff	; pointer to help messages for right side
	.word	adj_ddiff	; cmos adjustment we're setting
	.long	1		; minimum value
	.long	5		; maximum value
	.long	1		; move up and down by 1's
	.long	0		; don't sub zero for any
	.long	list_1line	; message list used for values.
	.word	0		; wrap around on coin modes
	.long	ddiff_msglist	; list of messages for this adj.
	.long	txt_ddiff  	; pointer to header message


txt_ddiff
	.STRING	"COMPUTER DIFFICULTY",0
	.even

ddiff_msglist
	.long	diffset1
	.long	diffset2
	.long	diffset3
	.long	diffset4
	.long	diffset5

diffset1	
	.STRING	"1 - VERY EASY",0
	.even
diffset2	
	.STRING	"2 - EASY",0
	.even
diffset3	
	.STRING	"3 - MEDIUM",0
	.even
diffset4	
	.STRING	"4 - HARD",0
	.even
diffset5	
	.STRING	"5 - VERY HARD",0
	.even

help_ddiff
	.word	1
	.word	trog_blue
	.word	3
	.long	diff1
	.long	diff2
	.long	diff3

diff1	.STRING	"LETS YOU ADJUST HOW",0
diff2	.STRING	"DIFFICULT THE COMPUTER",0
diff3	.STRING	"OPPONENTS WILL FIGHT",0
	.even

*************************************************************************

do_hsreset
	.long	gen_adj		; routine to run
	.long	txt_hsreset	; pointer to header message
	.long	help_hsreset	; pointer to help messages for right side
	.word	adj_hsreset	; cmos adjustment we're setting
	.long	1		; minimum value
	.long	6		; maximum value
	.long	1		; move up and down by 1's
	.long	0		; don't sub zero for any
	.long	list_1line	; message list used for values.
	.word	0		; no wrap around
	.long	hsreset_msglist	; list of messages for this adj.
	.long	txt_hsreset  	; pointer to header message

txt_hsreset
	.STRING	"WINNING STREAK RESET",0
	.even

hsreset_msglist
	.long	wsreset1
	.long	wsreset2
	.long	wsreset3
	.long	wsreset4
	.long	wsreset5
	.long	wsreset6

wsreset1	
	.STRING	"RESET EVERY 5,000 GAMES",0
	.even
wsreset2	
	.STRING	"RESET EVERY 10,000 GAMES",0
	.even
wsreset3	
	.STRING	"RESET EVERY 15,000 GAMES",0
	.even
wsreset4	
	.STRING	"RESET EVERY 30,000 GAMES",0
	.even
wsreset5	
	.STRING	"RESET EVERY 50,000 GAMES",0
	.even
wsreset6	
	.STRING	"DON'T RESET",0
	.even

help_hsreset
	.word	1
	.word	trog_blue
	.word	3
	.long	hsr1
	.long	hsr2
	.long	hsr3

hsr1	.STRING	"LETS YOU ADJUST HOW OFTEN",0
hsr2	.STRING	"THE LONGEST WINNING",0
hsr3	.STRING	"STREAKS WILL BE RESET",0
	.even

**********************************************************************

	.if printer
do_param
help_param
	.word	0    		; humor dudes who compare with these labels
	.else


**************************************************************************
*											     *
* 	 price_adj									     *
* 											     *
* 	 this is executed when the "custom pricing" entry is		     *
* 	 selected for adjustment from the adjustment menu.		     *
* 											     *
* 	 it creates a whole new adjustment menu contiaing:		     *
* 											     *
* 											     *
* 			 left slot units						     *
* 			 center slot units					     *
* 			 right slot units						     *
* 			 units / credit						     *
* 			 units / bonus						     *
* 			 minimum units						     *
* 			 credits to start						     *
* 			 credits to continue					     *
* 			 show credit fractions					     *
* 			 coins per dollar						     *
* 			 free play							     *
* 			 maximum credits						     *
* 			 coin page help						     *
*											     *
**************************************************************************
price_adj
	movi	men_cust,a8	  ;handle just like main adj. menu
	movi	trog_blue,a14
	move	a14,@lastcolor,w
	jauc	gen_adjust

do_param
	.long	price_adj	   ;routine to run
	.long	mess_param	   ;pointer to header message
	.long	help_param	   ;pointer to help messages for right side
	.word	adjprice	   ;cmos adjustment we're setting
	.long	1		   ;minimum value
	.long	cs_ents		   ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	param_val	   ;routine for showing current value
	.word	wrap_val	   ;wrap around on coin modes
	.long	0		   ;list of messages for this adj.
	.long	mess_param	   ;pointer to header message

mess_param
	.string w_custom," ",w_pricing
	.byte 0
	.even

help_param
	.word	0	      ;center justify
	.word	trog_blue    ;color
	.word	6	      ;5 entries
	.long	pp_0
	.long	pp_1
	.long	pp_2
	.long	pp_3
	.long	pp_4
	.long	pp_5

pp_0	.string "THIS ALLOWS ",w_adjustment
	.byte 0
	.even
pp_1	.string "OF ",w_pricing," PARAMETERS"
	.byte 0
	.even
pp_2	.string "(for non-",w_standard," modes),"
	.byte 0
	.even
pp_3	.string w_free," ",w_play,", maximum ",w_credits,","
	.byte 0
	.even
pp_4	.string w_credits," REQUIRED TO START"
	.byte 0
	.even
pp_5	.string "AND ",w_credits," TO CONTINUE."
	.byte 0
	.even

**********************************************************************

*
* these are all for the custom pricing menu
*
coinbits	equ	wrap_val+virg_val+six_val

do_lcoin
	.long	gen_adj	     ;routine to run
	.long	m_lcu		;pointer to header message
	.long	help_lcu	    ;pointer to help messages for right side
	.word	adjlmult	    ;cmos adjustment we're setting
	.long	0		   ;minimum value
	.long	99		  ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	just_bin	    ;just show the number
	.word	coinbits	    ;wrap around
	.long	0		   ;no extra info needed
	.long	m_lcu		;pointer to header message

do_ccoin
	.long	gen_adj	     ;routine to run
	.long	m_ccu	      ;pointer to header message
	.long	help_ccu	    ;pointer to help messages for right side
	.word	adjcmult	    ;cmos adjustment we're setting
	.long	0		   ;minimum value
	.long	99		  ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	just_bin	    ;just show the number
	.word	coinbits	    ;wrap around
	.long	0		   ;no extra info needed
	.long	m_ccu		;pointer to header message

do_rcoin
	.long	gen_adj	     ;routine to run
	.long	m_rcu		;pointer to header message
	.long	help_rcu	    ;pointer to help messages for right side
	.word	adjrmult	    ;cmos adjustment we're setting
	.long	0		   ;minimum value
	.long	99		  ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	just_bin	    ;just show the number
	.word	coinbits	    ;wrap around
	.long	0		   ;no extra info needed
	.long	m_rcu		;pointer to header message

do_4coin
	.long	gen_adj	     ;routine to run
	.long	m_4cu		;pointer to header message
	.long	help_4cu	    ;pointer to help messages for right side
	.word	adj4mult	    ;cmos adjustment we're setting
	.long	0		   ;minimum value
	.long	99		  ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	just_bin	    ;just show the number
	.word	coinbits	    ;wrap around
	.long	0		   ;no extra info needed
	.long	m_4cu		;pointer to header message


do_uc	.long	gen_adj	     ;routine to run
	.long	m_uc		;pointer to header message
	.long	help_uc	     ;pointer to help messages for right side
	.word	adjcunit	    ;cmos adjustment we're setting
	.long	1		   ;minimum value
	.long	99		  ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	just_bin	    ;just show the number
	.word	coinbits	    ;wrap around
	.long	0		   ;no extra info needed
	.long	m_uc		;pointer to header message

do_ub	.long	gen_adj	     ;routine to run
	.long	m_ub		;pointer to header message
	.long	help_ub	     ;pointer to help messages for right side
	.word	adjbunit	    ;cmos adjustment we're setting
	.long	0		   ;minimum value
	.long	99		  ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	bin_or_mess	 ;just show the number
	.word	coinbits	    ;wrap around
	.long	m_nobonus	   ;no extra info needed
	.long	m_ub		;pointer to header message

do_um	.long	gen_adj	     ;routine to run
	.long	m_um2		;pointer to header message
	.long	help_um	     ;pointer to help messages for right side
	.word	adjmunit	    ;cmos adjustment we're setting
	.long	0		   ;minimum value
	.long	99		  ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	bin_or_mess	 ;just show the number
	.word	coinbits	    ;wrap around
	.long	m_nomin	     ;no extra info needed
	.long	m_um		;pointer to header message

credbits	equ	virg_val+six_val	;gnp change 7/16/92 to make sure
					;custom credit adjs stay custom

do_cst	.long	gen_adj	     ;routine to run
	.long	m_cst		;pointer to header message
	.long	help_cs	     ;pointer to help messages for right side
	.word	adjcstrt	    ;cmos adjustment we're setting
	.long	1		   ;minimum value
	.long	4		   ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	just_bin	   ;just show the number
	.word	credbits	    ;wrap around
	.long	0		   ;no extra info needed
	.long	m_cst		;pointer to header message

do_cont	.long	gen_adj	     ;routine to run
	.long	m_cont2	      ;pointer to header message
	.long	help_cc	     ;pointer to help messages for right side
	.word	adjccont	    ;cmos adjustment we're setting
	.long	1		   ;minimum value
	.long	4		   ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	just_bin	    ;just show the number
	.word	credbits	    ;wrap around
	.long	0		   ;no extra info needed
	.long	m_cont	      ;pointer to header message


do_cpd	.long	gen_adj	     ;routine to run
	.long	m_cpd		;pointer to header message
	.long	help_cpd	    ;pointer to help messages for right side
	.word	adjcdiv	     ;cmos adjustment we're setting
	.long	0		   ;minimum value
	.long	20		  ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	bin_or_mess	    ;just show the number
	.word	0		   ;no wrap around
	.long	m_no_col	    ;no extra info needed
	.long	m_cpd		;pointer to header message

do_max	.long	gen_adj	     ;routine to run
	.long	m_max		;pointer to header message
	.long	help_max	    ;pointer to help messages for right side
	.word	adjmaxc	     ;cmos adjustment we're setting
	.long	5		   ;minimum value
	.long	99		  ;maximum value
	.long	1		   ;move up and down by 1's
	.long	0		   ;don't sub zero for any
	.long	just_bin	    ;just show the number
	.word	wrap_val	    ;wrap around
	.long	0		   ;no extra info needed
	.long	m_max		;pointer to header message


**************************************************************************
*											     *
*  help stuff for custom coinage								     *
*											     *
**************************************************************************
help_lcu
	.word	0
	.word	trog_white
	.word	6
	.long	lc_m1
	.long	lc_m2
	.long	lc_m3
	.long	lc_m4
	.long	lc_m5
	.long	lc_m6

help_ccu
	.word	0
	.word	trog_white
	.word	6
	.long	lc_m1
	.long	lc_m2
	.long	lc_m3
	.long	lc_m4
	.long	cc_m5
	.long	lc_m6

help_rcu
	.word	0
	.word	trog_white
	.word	6
	.long	lc_m1
	.long	lc_m2
	.long	lc_m3
	.long	lc_m4
	.long	rc_m5
	.long	lc_m6

help_4cu
	.word	0
	.word	trog_white
	.word	6
	.long	lc_m1
	.long	lc_m2
	.long	lc_m3
	.long	lc_m4
	.long	c4c_m5
	.long	lc_m6


help_uc	.word	0
	.word	trog_white
	.word	3
	.long	uc_m1
	.long	uc_m2
	.long	uc_m3

help_ub	.word	0
	.word	trog_white
	.word	3
	.long	ub_m1
	.long	ub_m2
	.long	ub_m3

help_um	.word	0
	.word	trog_white
	.word	3
	.long	um_m1
	.long	um_m2
	.long	um_m3


help_cs	.word	0
	.word	trog_white
	.word	3
	.long	cs_m1
	.long	cs_m2
	.long	cs_m3

help_cc	.word	0
	.word	trog_white
	.word	3
	.long	cs_m1
	.long	cs_m2
	.long	cc_m3

help_cpd .word	0
	.word	trog_white
	.word	6
	.long	cpd_m1
	.long	cpd_m2
	.long	cpd_m3
	.long	cpd_m4
	.long	cpd_m5
	.long	cpd_m6

help_max .word	0
	.word	trog_white
	.word	6
	.long	mc_m1
	.long	mc_m2
	.long	mc_m3
	.long	mc_m4
	.long	m_null
	.long	mc_m5


lc_m1	.string w_coins," INSERTED ACCUMULATE"
	.byte 0	
	.even
lc_m2	.string w_units,".  THIS ",w_adjustment
	.byte 0
	.even
lc_m3	.strinG "SPECIFIES THE NUMBER OF"
	.byte 0
	.even
lc_m4	.string w_units," GIVEN FOR EACH"
	.byte 0
	.even
lc_m5	.string w_coin," in the left ",w_chute,"."
	.byte 0
	.even
lc_m6	.string "(SEE "
	.byte ascii_dq
	.string w_units," / ",w_credit
	.byte ascii_dq
	.string ")"
	.byte 0
	.even
cc_m5	.string w_coin," IN THE THIRD ",w_chute,"."
	.byte 0
	.even
rc_m5	.string w_coin," IN THE RIGHT ",w_chute,"."
	.byte 0
	.even

c4c_m5	.string w_coin," IN THE FOURTH ",w_chute,"."
	.byte 0
	.even

uc_m1	.string "THIS IS THE NUMBER OF ",w_coin
	.byte 0
	.even
uc_m2	.string w_units," REQUIRED TO BUY ONE"
	.byte 0
	.even
uc_m3	.string w_credit,"."
	.byte 0
	.even
ub_m1	.string "1 BONUS ",w_credit," IS AWARDED"
	.byte 0
	.even
ub_m2	.string "AFTER THIS MANY ",w_coin," ",w_units
	.byte 0
	.even
ub_m3	.string "HAVE ACCUMULATED."
	.byte 0
	.even

um_m1	.string "no ",w_credits," WILL BE AWARDED"
	.byte 0
	.even
um_m2	.string "UNTIL THIS MANY ",w_coin
	.byte 0
	.even
um_m3	.string w_units," HAVE ACCUMULATED."
	.byte 0
	.even

cs_m1	.string "EACH ",w_play,"ER NEEDS THIS"
	.byte 0
	.even
cs_m2	.string "MENY ",w_credits," TO"
	.byte 0
	.even
cs_m3	.string "BEGIN ",w_play,"."
	.byte 0
	.even

cc_m3	.string "CONTINUE A ",w_game,"."
	.byte 0
	.even

cpd_m1	.string "THE DETAILED BOOKKEEPING"
	.byte 0
	.even
cpd_m2	.string "SCREEN SHOWS TOTAL"
	.byte 0
	.even
cpd_m3	.string "COLLECTIONS BASED ON THIS"
	.byte 0
	.even
cpd_m4	.string "MANY ",w_coins," PER DOLLAR."
	.byte 0
	.even
cpd_m5	.string "(SET TO ZERO TO DISABLE THE"
	.byte 0
	.even
cpd_m6	.string "DISPLAY OF MONEY TOTALS.)"
	.byte 0
	.even

mc_m1	.string "THIS IS THE LIMIT FOR"
	.byte 0
	.even
mc_m2	.string "THE ",w_credits," COUNTER."
	.byte 0
	.even
mc_m3	.string "ADDITIONAL ",w_coins," INSERTED"
	.byte 0
	.even
mc_m4	.string "WILL BE LOST."
	.byte 0
	.even
mc_m5	.string w_facset,": 30"
	.byte 0
	.even


men_cust
	.long	rd7font	;font
	.long	strcnrm	;center please
	.long	m_cuspri	;title
	.word	trog_blue      ;color of title
	.word	menu_x	   ;ul x
	.word	menu_y	   ;ul y
	.word	11	    ;vertical spacing
	.word	trog_blue	;color when not selected
	.word	12	     ;height of selection bar
	.word	-2	     ;distance of bar from top of text (negative)
	.word	bar_dx	 ;extra x on each side.
	.word	bar_wid	 ;width of bar!
	.word	trog_decay     ;text color of selected item
	.long	mess_am,0,blnk_help	;return to main menu
	.long	m_lcu,do_lcoin,adj_help	  ;left slot units
	.long	m_rcu,do_rcoin,adj_help	  ;right slot units
	.long	m_ccu,do_ccoin,adj_help	  ;center slot units
	.long	m_4cu,do_4coin,adj_help
	.long	m_uc,do_uc,adj_help	;units for credit
	.long	m_ub,do_ub,adj_help	;units for bonus
	.long	m_um,do_um,adj_help	;minimum units
	.long	m_cst,do_cst,adj_help	  ;credits required to start
	.long	m_cont,do_cont,adj_help	  ;credits required to continue
	.long	m_cpd,do_cpd,adj_help	 ;coins per dollar
	.long	m_max,do_max,adj_help	 ;maximum credits
	.long	mess_am,0,blnk_help	;return to main menu
	.long	0


	.endif

**************************************************************************
*											     *
* 	end of printer conditional assembly					     *
*											     *
**************************************************************************


do_free
	.long	gen_adj	     ;routine to run
	.long	mess_free	   ;pointer to header message
	.long	help_free	   ;pointer to help messages for right side
	.word	adjfrepl	    ;cmos adjustment we're setting
	.long	0		   ;minimum value
	.long	1		   ;maximum value
	.long	1
	.long	0		   ;don't sub zero for any
	.long	list_1line	  ;message list used for values.
	.word	wrap_val	    ;wrap around
*
*	g_free:	replace  ".long list_noyes"   with	".long list_yesno"	
*
*        .long   list_yesno	  ; list of messages for this adj.
	.long	list_noyes	  ; list of messages for this adj.
	.long	mess_free	  ; pointer to header message

*
*	adjustment menu is skinny..leaving room for explanation.
*
am_bdy	equ	-7
;am_wid	 equ	 139
am_wid	equ	bar_wid
am_x	equ	tit_ulx+gap+mb_xwid+(am_wid/2)+c_kludge
am_y	equ	inst_lry+box_ygap+mb_ywid+gap-am_bdy
*
*	right margin of adjust menu box
*
am_rx	equ	tit_ulx+(2*gap)+am_wid+(2*mb_xwid)
*
*	left margin of help box
*
am_hx	equ	am_rx+box_xgap

men_adj	.long	rd7font		; font
	.long	strcnrm		; center please
	.long	m_gadj		; title
	.word	trog_white	; color of title
	.word	menu_x		; ul x
	.word	menu_y		; ul y
	.word	>0e
	.word	trog_white	; color when not selected
	.word	>0e		; height of selection bar
	.word	-3		; distance of bar from top of text (negative)
	.word	bar_dx		; extra x on each side.
	.word	bar_wid		; width of bar!
	.word	trog_decay	; text color of selected item

	.long	mess_mm,0,blnk_help			; return to main menu
	.long	mess_price,do_price,adj_help

	.if printer
	.else
	.long	mess_param,do_param,adj_help
	.endif

	.long	mess_free,do_free,adj_help	; free play
	.long	txt_ddiff,do_ddiff,adj_help
	.long	txt_hsreset,do_hsreset,adj_help
	.long	mess_mm,0,blnk_help			; return to main menu
	.long	0					; end


m_gadj	.string	w_game," ",w_adjustment
	.byte	  0
	.even

m_cuspri .string	w_custom," ",w_pricing
	.byte	  0
	.even

mess_free
	.string w_free," ",w_play,0
	.even

mess_price
	.string w_standard," ",w_pricing
	.byte 0
	.even


m_lcu	.string "LEFT ",w_chute," ",w_units
	.byte 0
	.even
m_ccu	.string "THIRD ",w_chute," ",w_units
	.byte 0
	.even
m_rcu	.string "RIGHT ",w_chute," ",w_units
	.byte 0
	.even
m_4cu	.string "FOURTH ",w_chute," ",w_units
	.byte 0
	.even
m_uc	.string w_units," / ",w_credit
	.byte 0
	.even
m_ub	.string w_units," / bonus"
	.byte 0
	.even
m_um	.string "MINIMUM ",w_units," REQUIRED"
	.byte 0
	.even
m_um2	.string  "MINIMUM ",w_units
	.byte 0
	.even
m_cst	.string w_credits," TO START"
	.byte 0
	.even
m_cont	.string w_credits," TO CONTINUE"
	.byte 0
	.even
m_cont2	.string "CRED. TO CONTINUE"
	.byte 0
	.even
m_cpd	.string w_coins," PER DOLLAR"
	.byte 0
	.even
m_max	.string "MAXIMUM ",w_credits
	.byte 0
	.even
mess_am	.string "RETURN TO ADJ. MENU"
	.byte 0
	.even
*
*	this is the adjustment name in the upper right
*	box
*
adjt_y	equ	inst_uly+12		;center in the box
adjt_setup
	mess_mac  rd7font,spacing07,200,adjt_y,trog_plf,strcnrm,0

cset_y	equ	cur_uly2+12
mess_curset
	mess_mac  rd7font,spacing07,200,cset_y+2,trog_pyellow,strcnrm,0
	.string   "current setting"
	.byte	  0
	.even

in_y1	equ	cur_uly+20
in_y2	equ	in_y1+10
;in_y3	 equ	 in_y2+62
in_y3	equ	in_y1+28h
in_y4	equ	in_y3+10

inst_to_adj
	 mess_mac  rd7font,spacing07,am_x,in_y1,trog_pwhite,strcnrm,0
	.STRING   "MODIFY VALUE WITH"			
	.byte	0,1
	.even
	 mess_mac  rd7font,spacing07,am_x,in_y2,trog_pwhite,strcnrm,0
	.STRING   "ANY STICK"
	.byte	0,1
	.even
	mess_mac  rd7font,spacing07,am_x,in_y3,trog_pwhite,strcnrm,0
	.STRING   "PRESS ANY BUTTON"
	.byte	0,1
	.even
	mess_mac  rd7font,spacing07,am_x,in_y4,trog_pwhite,strcnrm,0
	.STRING   "WHEN VALUE IS CORRECT"
	.byte	0,0
	.even
*
*	for the word under "adjusting" while the adjusting
*	is actually being done
*
adnow_y1 equ	cur_uly-33
adnow_y2 equ	adnow_y1+14

mes_adjusting
	mess_mac  rd7font,spacing07,am_x,adnow_y1,trog_plf,strcnrm,0
	.STRING   "ADJUSTING"
	.byte	0,0
	.even

mes_adname
	mess_mac  rd7font,spacing07,am_x,adnow_y2,trog_plf,strcnrm,0

instr_y	equ	inst_uly+5
instr_2y equ	instr_y+11

adj_adv
*gnp change 5/25/90
	 mess_mac  rd7font,spacing07,am_x,instr_y,trog_prgb,strcnrm,0
	.STRING   "SELECT WITH ANY STICK"
	.byte	0,1
	.even
*gnp change 5/25/90
	mess_mac  rd7font,spacing07,am_x,instr_2y,trog_prgb,strcnrm,0
	.STRING   "PRESS ANY BUTTON TO MODIFY."
	.byte	0,0
	.even

;aay	 equ	 in_y1+28h
aay	equ	in_y2+72
*aax	 equ	 am_rx-12

adj_arrow
	mess_mac  rd15font,0fffbh,am_x+12,aay-12,trog_plf,strcnrm,0
	.STRING   "\f-->\f-->\f-->\f-->",0
	.long	[0,-36]
	.long	[0,12]
	.long	[0,12]
	.long	[0,12]
	.even
*
*	if coin settings don't neatly fit into
*	a mode
*
mess_tampered
	.string w_custom
	.byte	0
	.even

mess_dip
	.STRING	"DIPSWITCH",0
	.even

m_slotval
	.string w_coin," SLOT VALUE"
	.byte	0
	.even

mess_gp	.string w_pricing,":",0
	.even

mess_fp	.string w_free," ",w_play,":"
	.byte	0
	.even
mess_max .string "MAXIMUM ",w_credits,":"
	.byte	0
	.even

m_cts_pl	.string w_credits," TO START:"
	.byte 0
	.even
m_ctc_pl	.string w_credits," TO CONTINUE:"
	.byte 0
	.even

**************************************************************************
*												*
*	 help structures for main adjustment menu!					*
*												*
**************************************************************************


m_null	.byte 0
	.even


help_price
	.word	0	      ;center justify
	.word	trog_blue    ;color
	.word	4	      ;5 entries
	.long	ph_0
	.long	ph_1
	.long	ph_2
	.long	ph_3


help_dip
	.word	0	      ;center justify
	.word	trog_red	;color
	.word	3
	.long	dih_0
	.long	dih_1
	.long	dih_2



;help_amode
;	.word	0	      ;center justify
;	.word	trog_blue    ;color
;	.word	5	      ;6 entries
;	.long	ham_1
;	.long	ham_2
;	.long	ham_3
;	.long	m_null
;	.long	ham_4

help_free
	.word	0
	.word	trog_blue
	.word	6
	.long	fp_m1
	.long	fp_m2
	.long	fp_m3
	.long	fp_m4
	.long	m_null
	.long	fp_m5

**************************************************************************
*												*
*	 help messages for main adjustment menu!					*
*												*
**************************************************************************

ph_0	.string "SELECT BUILT-IN ",w_pricing
	.byte 0
	.even
ph_1	.string "MODE, SELECTING ",w_coins
	.byte 0
	.even
ph_2	.string "PER ",w_credit,", AND"
	.byte 0
	.even
ph_3	.string w_coin," SLOT VALUE."
	.byte 0
	.even

dih_0	.string	"THIS OPTION IS BEING",0
	.even
dih_1	.string	"ADJUSTED FROM DIPSWITCH",0
	.even
dih_2	.string	"SETTINGS.",0
	.even
	

fp_m1	.string "SETTING ",w_free," ",w_play," TO"
	.byte 0
	.even
fp_m2	.byte	ascii_dq
	.STRING "YES"
	.byte	ascii_dq
	.STRING " ALLOWS UNLIMITED"
	.byte 0
	.even
fp_m3	.string w_play," WITHOUT INSERTING"
	.byte 0
	.even
fp_m4	.string "ANY ",w_coins,"."
	.byte 0
	.even
fp_m5	.string w_facset,": NO"
	.byte 0
	.even

**********************************************************

list_noyes
	.long	m_no,m_yes

list_yesno
	.long	m_yes,m_no

list_dipnoyes
	.long	m_dno, m_dyes

m_no	.string "NO"
	.byte	0
	.even

m_yes	.string "YES"
	.byte	0
	.even

m_dyes	.string	"DIPSWITCH - YES",0
	.even

m_dno	.string	"DIPSWITCH - NO",0
	.even



m_nobonus  .string "NO BONUS ",w_credit
	.byte 0
	.even

m_nomin	.string "NO MINIMUM"
	.byte 0
	.even

m_no_col .string "NO MONEY TOTALS"
	.byte 0
	.even

cselct

*note from gnp 7/16/92
*	all foreign coinages changed to 2 to start, 1 to continue
*	unless otherwise noted.

**************************************************************************
*											     *
*   usa 1: 1 coin = 1 credit								     *
* 											     *
*          2 to start / 2 to continue							     *
*											     *
**************************************************************************
	.word	1,4,1,0,1,0,0,2,2	;willy pricing
	.word	4			;4 coins per dollar (for calc)
	.word	1			;display coin fractions
	.word	1,0,1,0			;coin value
	.long	dollar_lead,null_st	;character strings.
	.long	ocop			;one coin one play
	.long	usa_1			;title of coin mode
	.long	q_q			;1 coin per credit (series of strings)
	.word	show_none		;no pricing line on 2/1
	.long	usa_qdq			;quarter

**************************************************************************
*											     *
*   usa 2: 1 coin = 1 credit								     *
* 											     *
*          2 to start / 1 to continue							     *
*											     *
**************************************************************************
	.word	1,4,1,0,1,0,0,2,1	;willy pricing
	.word	4			;4 coins per dollar (for calc)
	.word	1			;display coin fractions
	.word	1,0,1,0			;coin value
	.long	dollar_lead,null_st	;character strings.
	.long	ocop			;one coin one play
	.long	usa_2			;title of coin mode
	.long	q_q		;1 coin per credit (series of strings)
	.word	show_none		;no pricing line on 2/1
	.long	usa_qdq			;quarter


**************************************************************************
*											     *
* 	usa 3	 coinage is 25 cent		 					     *
*		 1 to start / 1 to continue						*
*											     *
**************************************************************************

	.word	1,4,1,0,1,0,0,1,1	   ;willy pricing
	.word	4				;4 coins per dollar (for calc)
	.word	1				;display coin fractions
	.word	1,0,1,0			 ;coin value
	.long	dollar_lead,null_st	   ;character strings.
	.long	csm_list			 ;one coin one play
	.long	usa_3			 ;title of coin mode
	.long	q_q			 ;1 coin per credit (series of strings)
	.word	show_none		;no pricing line on 2/1
	.long	usa_qdq			;quarter

**************************************************************************
*											     *
* 	usa 4	 coinage is 50 cent	 3/$1.00					     *
*		 1 to start / 1 to continue						*
*											     *
**************************************************************************

	.word	1,4,1,0,2,4,0,1,1     ; willy pricing
	.word	4		  	; 4 coins per dollar (for calc)
	.word	1		  	; display coin fractions
	.word	1,0,1,0		   	; coin value
	.long	dollar_lead,null_st	; character strings.
	.long	csm_list		; print the 2 the op sees
	.long	usa_4			; title of coin mode
	.long	dollar_3		; 1 coin per credit (series of strings)
	.word	show_2			; show line 2
	.long	usa_qdq			; quarter
						
**************************************************************************
*											     *
*  addition "full price" coinages							     *
*											     *
**************************************************************************

	.if	fullprice

**************************************************************************
*											     *
* 	usa 5	 coinage is 50 cent	 4/$1.00					     *
*		 2 to start / 1 to continue						*
*											     *
**************************************************************************

	.word	3,0,3,0,4,12,6,2,1	; willy pricing
	.word	4			; 4 coins per dollar (for calc)
	.word	0			; no coin fractions
	.word	1,0,1,0			; coin value
	.long	dollar_lead,null_st	; character strings.
	.long	csm_list		; print the 2 the op sees
	.long	usa_5			; title of coin mode
	.long	dollar_4		; 1 coin per credit (series of strings)
	.word	show_2			; show line 2
	.long	usa_qdq			; quarter

*
*	usa 6	 50 per credit
*
	.word	1,4,1,0,2,0,0,1,1	; willy pricing
	.word	4		  	; 4 coins per dollar (for calc)
	.word	1		  	; display coin fractions
	.word	1,4,1,0		   	; coin value
	.long	dollar_lead,null_st	; character strings.
	.long	csm_list		; 2 coins per player
	.long	usa_6			; title of coin mode
	.long	f_f_1s1c		; 2 coins per credit (series of strings)
	.word	show_1			; show line 1
	.long	usa_qdq			; quarter
*						
*	usa 7	 coinage is 50 cent	 3/$1.00
*
	.word	1,4,1,0,2,4,0,1,1	   ;willy pricing
	.word	4				;4 coins per dollar (for calc)
	.word	1				;display coin fractions
	.word	1,4,1,0			 ;coin value
	.long	dollar_lead,null_st	   ;character strings.
	.long	csm_list			 ;print the 2 the op sees
	.long	usa_7			 ;title of coin mode
	.long	ufs3d			 ;1 coin per credit (series of strings)
	.word	show_2			;show line 2
	.long	usa_qdq			;quarter

*						
*	usa 8	 coinage is 50 cent	 4/$1.00
*
	.word	3,12,3,0,4,12,6,1,1	 ;willy pricing
	.word	4				;4 coins per dollar (for calc)
	.word	0				;no coin fractions
	.word	1,4,1,0			 ;coin value
	.long	dollar_lead,null_st	   ;character strings.
	.long	csm_list			 ;print the 2 the op sees
	.long	usa_8			 ;title of coin mode
	.long	ufs4d			 ;1 coin per credit (series of strings)
	.word	show_2			;show line 2
	.long	usa_qdq			;quarter

	.endif
*
*	usa electronic
*
	.word	20,2,5,1,5,0,0,2,2	; l,c,r,4,u/c,u/b,minunits
	.word	20			; coins/dollar
	.word	1			; display fractions
	.word	20,2,5,1		; l,c,r,4
	.long	dollar_lead,null_st	; character strings.
	.long	usa_electronic		; special message
	.long	usa_electitle		; title of coin mode
	.long	usa_el			; settings description
	.word	show_2			; lines to show on
	.long	usa_eslot		; quarter

*
*	german 1    coinage is 6 plays for 5 dm
*			 2 to start, 2 to continue
*
	.word	6,12,30,0,5,0,0,2,2	 ;willy pricing
	.word	1		   	 ;dms have no fractions
	.word	0			 ;don't display coin fractions
	.word	1,2,5,0			 ;coin value
	.long	null_st,dm_trail		 ;character strings.
	.long	csm_list
	.long	german_1			 ;title of coin mode
	.long	dm_6			  ;1 coin per credit (series of strings)
	.word	show_2
	.long	german_15			;1 dm / 5 dm

g1sel	equ	($-cselct)/cs_size	    ;coin select value for german 1
*
*	german 2    coinage is 7 plays for 5 dm
*			 2 to start, 1 to continue
*
	.word	6,12,30,0,5,30,0,2,1		;willy pricing
	.word	1				;dms have no fractions
	.word	0				;don't display coin fractions
	.word	1,2,5,0			 ;coin value
	.long	null_st,dm_trail		 ;character strings.
	.long	csm_list
	.long	german_2			 ;title of coin mode
	.long	dm_7			  ;1 coin per credit (series of strings)
	.word	show_2
	.long	german_15			;1 dm / 5 dm
*
*	german 3    coinage is 8 plays for 5 dm
*			 2 to start, 1 to continue
*
	.word	7,14,35,0,5,35,0,2,1		;willy pricing
	.word	1				;dms have no fractions
	.word	0				;don't display coin fractions
	.word	1,2,5,0			 ;coin value
	.long	null_st,dm_trail		 ;character strings.
	.long	csm_list
	.long	german_3			 ;title of coin mode
	.long	dm_8			  ;1 coin per credit (series of strings)
	.word	show_2
	.long	german_15			;1 dm / 5 dm
*
*	german 4    coinage is 5 plays for 5 dm
*			 2 to start, 1 to continue
*
	.word	1,2,5,0,1,0,0,2,1	   ;willy pricing
	.word	1				;dms have no fractions
	.word	0				;don't display coin fractions
	.word	1,2,5,0			 ;coin value
	.long	null_st,dm_trail		 ;character strings.
	.long	csm_list
	.long	german_4			 ;title of coin mode
	.long	dm_5			  ;1 coin per credit (series of strings)
	.word	show_2
	.long	german_15			;1 dm / 5 dm

*
*	german 5    coinage is 6 plays for 5 dm
*			 2 to start, 1 to continue
*
	.word	6,12,30,0,5,0,0,2,1	 ;willy pricing
	.word	1		   	 ;dms have no fractions
	.word	0			 ;don't display coin fractions
	.word	1,2,5,0			 ;coin value
	.long	null_st,dm_trail		 ;character strings.
	.long	csm_list
	.long	german_5			 ;title of coin mode
	.long	dm_6			  ;1 coin per credit (series of strings)
	.word	show_2
	.long	german_15			;1 dm / 5 dm

*
*	german electronic
*			 2 to start, 1 to continue
*
	.word	60,12,24,0,10,0,0,2,2	; l,c,r,4,u/c,u/b,minunits
	.word	12			; coins/dollar
	.word	0			; display fractions
	.word	60,12,24,0		; l,c,r,4
	.long	null_st,dm_trail	;character strings.
	.long	german_electronic	; special message
	.long	german_electitle	; title of coin mode
	.long	dm112265		; settings description
	.word	show_3			; lines to show on
	.long	german_eslot		; quarter

****************************************************************************
****************************************************************************
*******	the following numbers are figured for the french settings
*******	requested by dimitri k. of p.s.d.
*******
*******			 	1f   5f   10f   u/c   u/b  m/u
*******				--------------------------------
*******	1/2f  3/5f    7/10f	3	15	 30	  5	  30    0
*******	1/3f  2/5f    5/10f	2	10	 20	  5	  20    0
*******	1/5f  3/10f		1	 5	 10    5    10    0
*******	1/5f  3/10f   7/20f	3	15	 30	 10	  60   15
*******	2/5f  4/10f   9/20f	2	10	 20	  5	  40   10
*******	2/5f  5/10f  11/20f	1	 5	 10	  2	  20    5
*******
*
*
*	french 1	      2/5f	 5/10f
*
*
	.word	2,0,4,0,1,4,0,2,2		; 2/5f    5/10f
	.word	1				;1 franc per franc
	.word	0				;don't display coin fractions
	.word	5,0,10,0			;coin value
	.long	null_st,franc_trail		;character strings.
	.long	csm_list			;wait till he says "if it is not possible"
	.long	french_1			;title of coin mode
	.long	five_10				;1 coin per credit (series of strings)
	.word	show_2
	.long	french510

f1sel	equ	($-cselct)/cs_size	    ;coin select value for french 1

*
*	french 2	      2/5f	 4/10f
*
*
	.word	2,0,4,0,1,0,0,2,1	   ; 2/5f    4/10f
	.word	1				;1 franc per franc
	.word	0				;don't display coin fractions
	.word	5,0,10,0			;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list			 ;wait till he says "if it is not possible"
	.long	french_2			 ;title of coin mode
	.long	four_10			;1 coin per credit (series of strings)
	.word	show_2
	.long	french510
*
*	french 3	      1/5f  3/10f	
*
*
	.word	1,0,2,0,1,2,0,2,1	    ;1/5f  3/10f	
	.word	1				;1 franc per franc
	.word	0				;don't display coin fractions
	.word	5,0,10,0			;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list			 ;wait till he says "if it is not possible"
	.long	french_3			 ;title of coin mode
	.long	three_10			 ;1 coin per credit (series of strings)
	.word	show_2
	.long	french510
*
*	french 4	      1/5f  2/10f 
*
*
	.word	1,0,2,0,1,0,0,2,1	 ;1/5f  2/10f
	.word	1				;1 franc per franc
	.word	0				;don't display coin fractions
	.word	5,0,10,0			;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list			 ;wait till he says "if it is not possible"
	.long	french_4			 ;title of coin mode
	.long	two_10			;1 coin per credit (series of strings)
	.word	show_1
	.long	french510

	.if	fullprice

*
*
*	french 5	      2/5f	 5/10f	11/2 x 10f
*
*
	.word	5,0,10,0,2,20,0,2,1		 ;2/5f  5/10f	11/20f
	.word	1				;1 franc per franc
	.word	0				;don't display coin fractions
	.word	5,0,10,0			;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list			 ;wait till he says "if it is not possible"
	.long	french_5			 ;title of coin mode
	.long	five_10_11		    ;1 coin per credit (series of strings)
	.word	show_3			;use line 3 when only 1 will fit
	.long	french510
*
*	french 6	      2/5f	 4/10f	9/2 x 10f
*
*
	.word	2,0,4,0,1,8,0,2,1		   ;2/5f	4/10f   9/20f
	.word	1				;1 franc per franc
	.word	0				;don't display coin fractions
	.word	5,0,10,0			;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list			 ;wait till he says "if it is not possible"
	.long	french_6			 ;title of coin mode
	.long	four_10_9			;1 coin per credit (series of strings)
	.word	show_3			;use line 3 when only 1 will fit
	.long	french510
*
*	french 7	      1/5f	 3/10f	7/2 x 10f
*
*
	.word	3,0,6,0,2,12,0,2,1		  ;1/5f  3/10f   7/20f
	.word	1				;1 franc per franc
	.word	0				;don't display coin fractions
	.word	5,0,10,0			;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list			 ;wait till he says "if it is not possible"
	.long	french_7			 ;title of coin mode
	.long	three_10_7		    ;1 coin per credit (series of strings)
	.word	show_3			;use line 3 when only 1 will fit
	.long	french510
*
*	french 8	      1/5f	 2/10f	5/2 x 10f
*
*
	.word	1,0,2,0,1,4,0,2,1		   ;1/5f	2/10f  5/20f
	.word	1				;1 franc per franc
	.word	0				;don't display coin fractions
	.word	5,0,10,0			;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list			 ;wait till he says "if it is not possible"
	.long	french_8			 ;title of coin mode
	.long	two_10_5			 ;1 coin per credit (series of strings)
	.word	show_3			;use line 3 when only 1 will fit
	.long	french510

*
*	french 9	      1/3 x 1f	  2/5f
*
*	coin slots are	1f -- 5f
*
*
	.word	2,0,10,0,5,0,0,2,1		  ;1/3x1f  2/5f
	.word	1				;1 franc per franc
	.word	0				;don't display coin fractions
	.word	1,0,5,0			 ;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list			 ;wait till he says "if it is not possible"
	.long	french_9			 ;title of coin mode
	.long	f1325			 ;1 coin per credit (series of strings)
	.word	show_2			;use line 2 when only 1 will fit
	.long	french1f5f
*
*	french 10	      1/2 x 1f	  3/5f
*
*	coin slots are	1f -- 5f
*
*
	.word	3,0,15,0,5,0,0,2,1		  ;1/2x1f  3/5f
	.word	1				;1 franc per franc
	.word	0				;don't display coin fractions
	.word	1,0,5,0			 ;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list			 ;wait till he says "if it is not possible"
	.long	french_10			;title of coin mode
	.long	f1235			 ;1 coin per credit (series of strings)
	.word	show_2			;use line 2 when only 1 will fit
	.long	french1f5f
*
*	french 11	      1/3 x 1f	  2/5f	5/2 x 5f
*
*	coin slots are	1f -- 5f
*
*
	.word	2,0,10,0,5,20,0,2,1		 ;1/3x1f	2/5f  5/10f
	.word	1				;1 franc per franc
	.word	0				;don't display coin fractions
	.word	1,0,5,0			 ;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list			 ;wait till he says "if it is not possible"
	.long	french_11			;title of coin mode
	.long	f13255			 ;1 coin per credit (series of strings)
	.word	show_3			;use line 2 when only 1 will fit
	.long	french1f5f

*
*	french 12	      1/2 x 1f	  3/5f	  7 / 2 x 5f
*
*	coin slots are	1f -- 5f
*
*
	.word	3,0,15,0,5,30,0,2,1		 ;1/2x1f	3/5f  7/10f
	.word	1				;1 franc per franc
	.word	0				;don't display coin fractions
	.word	1,0,5,0			 ;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list			 ;wait till he says "if it is not possible"
	.long	french_12			;title of coin mode
	.long	f12355			 ;1 coin per credit (series of strings)
	.word	show_3			;use line 2 when only 1 will fit
	.long	french1f5f

	.endif

*
*	france electronic
*
	.word	1,15,6,0,3,0,0,2,2	; l,c,r,4,u/c,u/b,minunits
	.word	1			; coins/dollar
	.word	0			;don't display coin fractions
	.word	1,15,6,0		; l,c,r,4
	.long	null_st,franc_trail	; character strings.
	.long	france_electronic	; special message
	.long	french_electitle	; title of coin mode
	.long	f13255			;coin page description
	.word	show_3			;three lines for this baby
	.long	france_eslot		; quarter

*
*	canada    coinage is 50 cent   3/$1.00
*
	.word   1,0,4,0,2,4,0,2,2    ;willy pricing
	.word	4			;4 coins per dollar (for calc)
	.word	1			;display coin fractions
	.word	1,0,4,0			;coin value
	.long	dollar_lead,null_st	;character strings.
	.long	csm_list		;print the 2 the op sees
	.long   canada			;title of coin mode
	.long	can_1503d		;1 play 50, 3 for a dollar
	.word	show_2			;show line 2
	.long   can_qd			;quarter

	.if	fullprice

*	swiss 1    coinage is 6 plays for 5 franc

	.word	6,0,30,0,5,0,0,2,2		 ;willy pricing
	.word	1				;francs have no fractions
	.word	0				;don't display coin fractio
	.word	1,0,5,0			 ;coin value
	.long	null_st,franc_trail		 ;character strings.
	.long	csm_list
	.long	swiss_1			;title of coin mode
	.long	sfranc_6			 ;1 coin per credit (series
	.word	show_2
	.long	swiss15

*	swiss 2    coinage is 7 plays for 5 franc

	.word	6,0,30,0,5,30,0,2,2		;willy pricing
	.word	1				;francs have no fractions
	.word	0				;don't display coin fractio
	.word	1,0,5,0			 ;coin value
	.long	null_st,franc_trail		 ;character strings.
	.long	csm_list
	.long	swiss_2			;title of coin mode
	.long	sfranc_7			 ;1 coin per credit (series
	.word	show_2
	.long	swiss15

*	swiss 3     coinage is 8 plays for 5 franc

	.word	7,0,35,0,5,35,0,2,2		;willy pricing
	.word	1				;francs have no fractions
	.word	0				;don't display coin fractio
	.word	1,0,5,0				;coin value
	.long	null_st,franc_trail		;character strings.
	.long	csm_list
	.long	swiss_3				;title of coin mode
	.long	sfranc_8			;1 coin per credit (series
	.word	show_2
	.long	swiss15

*	italy coinage is 1 plays for 500 lire

	.word	1,0,1,0,1,0,0,2,2		;willy pricing
	.word	1				;lire have no fractions
	.word	0				;don't display coin fractio
	.word	500,0,500,0			 ;coin value
	.long	null_st,lire_trail		 ;character strings.
	.long	csm_list
	.long	italy_1			;title of coin mode
	.long	p1500l			;1 coin per credit (series of st
	.word	show_1
	.long	italylire

*	u.k. 1	 coinage is 1 play for 20p   3 for 50p

	.word	6,0,15,0,5,0,0,2,2	;willy pricing
	.word	10			;pence are fractions!
	.word	0			;don't display coin fractio
	.word	2,0,5,0			;coin value
	.long	null_st,pound_trail	;character strings.
	.long	csm_list
	.long	uk_1			;title of coin mode
	.long	uk_120			;1 coin per credit (series of st
	.word	show_2
	.long	uk2050

*	u.k. 2	 coinage is 2 play for 20p   5 for 50p

	.word	2,0,5,0,1,0,0,2,2		   ;willy pricing
	.word	10			    ;pence are fractions!
	.word	0				;don't display coin fractio
	.word	2,0,5,0			 ;coin value
	.long	null_st,pound_trail	;character strings.
	.long	csm_list
	.long	uk_2			  ;title of coin mode
	.long	uk_220			;1 coin per credit (series of st
	.word	show_1
	.long	uk2050

*	u.k. electronic 1

*	center = 20p  xtra = 10p  left = 1p  right = 50p
*	1 play / 30 p
*	2 play / 50 p
*	4 play / 1 pound

*		 l, c,	r, 4,u/c,u/b,minunits
	.word	28, 4, 12, 2,  4,  0,0,2,2		;numbers for 1l/20p/50p/10p
	.word	10					;pence suck!
	.word	0					;don't display coin fractio
	.word	5,1,10,0				;coin value
	.long	null_st,pound_trail	;character strings.
	.long	uk_electronic				;special title w/ pound
	.long	uk_3					;title of coin mode
	.long	uk_420					;.5/10p 1/20p	3/50p  7/1l
	.word	show_2
	.long	uk_elec

*	u.k. electronic 2  (ccu)

*	credits are awarded 1 coin / 1 play.....

*	ccu accumulates 4 coins and strokes us as follows:

*	1 play / 30 p
*	2 play / 50 p
*	4 play / 1 pound

	.word	1,0,0,0,1,0,0,2,2		   ;numbers for
	.word	1				;pence are fractions!
	.word	0				;don't display coin fractio
	.word	1,0,0,0			 ;coin value
	.long	null_st,coins_trail	   ;character strings.
	.long	uk_electronic		 ;special title w/ pound
	.long	uk_4			  ;title of coin mode
	.long	uk_320			;1/30p  2/50p	4/1l
	.word	show_2
	.long	uk_ccu

*gnp start 7/16/92
*	done because we learned some new spanish shit!

*	spain 1     1 play / 100 peseta   6 play / 500 peseta

	.word	1,0,5,0,1,5,0,2,2		;willy pricing
	.word	1				;no fractions
	.word	0				;don't display coin fractio
	.word	100,0,500,0			;coin value
	.long	null_st,peseta_trail		;character strings.
	.long	csm_list
	.long	sp_1				;title of coin mode
	.long	sp_5100				;1 coin per credit (series of st
	.word	show_2
	.long	peseta100


*	spain 2     1 play / 100 peseta   5 play / 100 peseta

	.word	1,0,5,0,1,0,0,2,2		   ;willy pricing
	.word	1				;no fractions
	.word	0				;don't display coin fractio
	.word	100,0,500,0			 ;coin value
	.long	null_st,peseta_trail	  ;character strings.
	.long	csm_list
	.long	sp_2			  ;title of coin mode
	.long	sp_4100			;1 coin per credit (series of st
	.word	show_2
	.long	peseta100

*gnp end

*	australia 1   1 play / 3 x 20 cents	2 for $1.00

	.word	2,0,10,0,5,0,0,2,2		  ;willy pricing
	.word	5				;dollars
	.word	0				;don't show fractions for t
	.word	1,0,5,0			 ;coin value
	.long	dollar_lead,null_st	  ;character strings.
	.long	csm_list
	.long	aus_1			 ;title of coin mode
	.long	au_60			 ;1 coin per credit (series of s
	.word	show_2
	.long	aust20c
*
*	australia 2   1 play / $1.00    2 plays for $2.00
*
	.word	1,0,5,0,5,0,0,1,1	 ; willy pricing
	.word	5			 ; dollars
	.word	1			 ; show fractions for the 3 c
	.word	1,0,5,0			 ; coin value
	.long	dollar_lead,null_st	 ; character strings.
	.long	csm_list
	.long	aus_2			 ; title of coin mode
	.long	au_100			 ; 1 coin per credit (series of st
	.word	show_2
	.long	aust20c

	.endif

*	japan 1  1 play / 100 yen

	.word	1,1,1,0,1,0,0,2,2		   ;willy pricing
	.word	1				;dollars
	.word	1				;fractions ok
	.word	100,100,100,0		   ;coin value
	.long	null_st,yen_trail		;character strings.
	.long	csm_list
	.long	jap_1			 ;title of coin mode
	.long	jap_100			;1 coin per credit (series of st
	.word	show_1
	.long	yen100

	.if	fullprice
*	japan 2  2 play / 100 yen

	.word	2,2,2,0,1,0,0,2,2		   ;willy pricing
	.word	1				;dollars
	.word	1				;fractions ok
	.word	100,100,100,0		   ;coin value
	.long	null_st,yen_trail		;character strings.
	.long	csm_list
	.long	jap_2			 ;title of coin mode
	.long	jap_200			;1 coin per credit (series of st
	.word	show_1
	.long	yen100

*	austria  1   1 play / 5 schilling  2 play / 10 schilling

	.word	1,0,2,0,1,0,0,2,2		   ;willy pricing
	.word	1				;dollars
	.word	1				;fractions ok
	.word	5,0,10,0			;coin value
	.long	null_st,shill_trail	   ;character strings.
	.long	csm_list
	.long	asta_1			 ;title of coin mode
	.long	asta_15			;1 coin per credit (series of st
	.word	show_1
	.long	shill510

*	austria  2   1 play / 2 x 5 schilling	3 play / 10 schilling

	.word	1,0,2,0,2,4,0,2,2		   ;willy pricing
	.word	1				;dollars
	.word	1				;fractions ok
	.word	5,0,10,0			;coin value
	.long	null_st,shill_trail	   ;character strings.
	.long	csm_list
	.long	asta_2			 ;title of coin mode
	.long	asta_10			;1 coin per credit (series of st
	.word	show_2
	.long	shill510

*	belgium 1  1 play / 20f

	.word	1,0,1,0,1,0,0,2,2		   ;willy pricing
	.word	1				;dollars
	.word	1				;fractions ok
	.word	20,0,20,0			 ;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list
	.long	bel_1			 ;title of coin mode
	.long	bel_120			;1 coin per credit (series of st
	.word	show_1
	.long	franc20

*	belgium 2  3 play / 20f

	.word	3,0,3,0,1,0,0,2,2		   ;willy pricing
	.word	1				;dollars
	.word	1				;fractions ok
	.word	20,0,20,0			 ;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list
	.long	bel_2			 ;title of coin mode
	.long	bel_320			;1 coin per credit (series of st
	.word	show_1
	.long	franc20

*	belgium 3  2 play / 20f

	.word	2,0,2,0,1,0,0,2,2		   ;willy pricing
	.word	1				;dollars
	.word	1				;fractions ok
	.word	20,0,20,0			 ;coin value
	.long	null_st,franc_trail	   ;character strings.
	.long	csm_list
	.long	bel_3			 ;title of coin mode
	.long	bel_220			;1 coin per credit (series of st
	.word	show_1
	.long	franc20

*
*	belgium electronic
*
	.word	10,1,4,0,4,0,0,2,2		; l,c,r,4,u/c,u/b,minunits
	.word	4			; coins/dollar
	.word	1			; display fractions
	.word	10,1,4,0		; l,c,r,4
	.long	null_st,franc_trail		 ;character strings.
	.long	belgium_electronic		; special message
	.long	belgium_electitle		; title of coin mode
	.long	usa_el			; settings description
	.word	show_2			; lines to show on
	.long	belgium_eslot		; quarter

*	sweden	1 play / 3 x 1 krona   2 play	5 krona

	.word	2,0,10,0,5,0,0,2,2		 ;willy pricing
	.word	1				;dollars
	.word	0				;don't show fractions
	.word	1,0,5,0			 ;coin value
	.long	null_st,krona_trail	   ;character strings.
	.long	csm_list
	.long	swed_1			;title of coin mode
	.long	swed_2x5			 ;1 coin per credit (series
	.word	show_1
	.long	krona5

*	new zealand 1	1 play / 3 x 20 cent

	.word	1,0,1,0,3,0,0,1,1		   ;willy pricing
	.word	5				;five per
	.word	1				;show fractions
	.word	1,0,1,0			 ;coin value
	.long	dollar_lead,null_st	  ;character strings.
	.long	csm_list
	.long	nz_1			  ;title of coin mode
	.long	nz_13			 ;1 coin per credit (series of s
	.word	show_1
	.long	nz20


*	new zealand 2	1 play / 2 x 20 cent

	.word	1,0,1,0,2,0,0,1,1		   ;willy pricing
	.word	5				;five per
	.word	1				;show fractions
	.word	1,0,1,0			 ;coin value
	.long	dollar_lead,null_st	  ;character strings.
	.long	csm_list
	.long	nz_2			  ;title of coin mode
	.long	nz_12			 ;1 coin per credit (series of s
	.word	show_1
	.long	nz20

*	netherlands	1 play / 1 hfl.	3 play / 2.5 hfl.

	.word	1,0,3,0,1,0,0,2,2		   ;willy pricing
	.word	2				;five per
	.word	0				;don't show fractions
	.word	2,0,5,0			 ;coin value
	.long	null_st,hfl_trail		;character strings.
	.long	csm_list
	.long	neth			  ;title of coin mode
	.long	neth_hf			;1 coin per credit (series of st
	.word	show_2
	.long	hfslot


*	finland	1 play / 1 markka

	.word	1,0,1,0,1,0,0,2,2		   ;willy pricing
	.word	1				;five per
	.word	0				;don't show fractions
	.word	1,0,1,0			 ;coin value
	.long	null_st,markka_trail	  ;character strings.
	.long	csm_list
	.long	finland			;title of coin mode
	.long	finmka			;1 coin per credit (series of st
	.word	show_1
	.long	mkslot

*	norway	1 play / 2 x 1 krone    3/ 5 x 1 krone

	.word	3,0,3,0,5,0,0,2,2		   ;willy pricing
	.word	1				;five per
	.word	0				;don't show fractions
	.word	1,0,1,0			 ;coin value
	.long	null_st,krone_trail	  ;character strings.
	.long	csm_list
	.long	norway			;title of coin mode
	.long	kr_list			 ;1 coin per credit (series of stri
	.word	show_2
	.long	nkrslot

*	denmark	1 play / 2 x 1 krone    3/ 5 krone	  7 / 10 krone

	.word	3,0,15,0,5,30,0,2,2		 ;willy pricing
	.word	1				;five per
	.word	0				;don't show fractions
	.word	1,0,5,0			 ;coin value
	.long	null_st,krone_trail	  ;character strings.
	.long	csm_list
	.long	denmark			;title of coin mode
	.long	dkr_list			 ;1 coin per credit (series
	.word	show_3
	.long	dkrslot


*	antilles      1 play / 25 cents	4 plays / 1 guilder

	.word	1,0,4,0,1,0,0,2,2		   ;willy pricing
	.word	4				;five per
	.word	0				;don't show fractions
	.word	1,0,4,0			 ;coin value
	.long	null_st,guilder_trail	  ;character strings.
	.long	csm_list
	.long	antilles			 ;title of coin mode
	.long	ant_list			 ;1 coin per credit (series
	.word	show_1
	.long	antslot

*gnp start 7/16/92, added hungary
*	hungary     1 credit / 2x10 forint  3 credits / 2x20 forint

	.word	1,0,2,0,2,4,0,2,2		;willy pricing
	.word	1				;1 to 1
	.word	0				;don't show fractions
	.word	10,0,20,0			;coin value
	.long	null_st,forint_trail		;character strings.
	.long	csm_list
	.long	hungary				;title of coin mode
	.long	hung_list			 ;1 coin per credit (series
	.word	show_1
	.long	hungslot

*gnp end 
	.endif

cs_ents	equ	($-cselct)/cs_size	    ;number of entries in table


;
;	dip switch tables
;

usabase	equ	1
gerbase	equ	g1sel
frabase	equ	f1sel

	.if	fullprice

usadip	.word	usabase+0, usabase+1, usabase+2, usabase+3, usabase+8
	.word	usabase+8, usabase+8

gerdip	.word	gerbase+0, gerbase+1, gerbase+2, gerbase+3, gerbase+4
	.word	gerbase+4, gerbase+4

fradip	.word	frabase+0, frabase+1, frabase+2, frabase+3, frabase+12
	.word	frabase+12, frabase+12

	.else

usadip	.word	usabase+0, usabase+1, usabase+2, usabase+3, usabase+4
	.word	usabase+4, usabase+4

gerdip	.word	gerbase+0, gerbase+1, gerbase+2, gerbase+3, gerbase+4
	.word	gerbase+4, gerbase+4

fradip	.word	frabase+0, frabase+1, frabase+2, frabase+3, frabase+4
	.word	frabase+4, frabase+4

	.endif


dipcointab	.long	usadip, gerdip, fradip, usadip


**************************************************************************
*									*
*	 collection messages					  *
*									*
**************************************************************************
me_zero	 .string "0"
	.byte	0
	.even

me_decimal	.string "."
	.byte	0
	.even

me_colon .string ":"
	.byte	0
	.even

dollar_lead	.string "$  "
	.byte	0
	.even

pound_lead
	.string font_epound,"  ",0
	.even
pound_trail
	.string	"  PND",0
	.even

null_st	
	.byte	0
	.even

dm_trail	.string "  DM"
	.byte	0
	.even

franc_trail	.string "  FRANCE"
	.byte	0
	.even
	
	.if	fullprice
lire_trail    
	.STRING "  LIRE"
	.byte	0
	.even

peseta_trail   
	.STRING "  PESETA"
	.byte	0
	.even
	.endif

yen_trail
	.STRING "  YEN"
	.byte	0
	.even

	.if	fullprice
shill_trail
	.STRING "  SCHILLINGS"
	.byte	0
	.even

krona_trail
	.STRING "  KRONA"
	.byte	0
	.even
	.endif

coins_trail
	.string "  ",w_coins
	.byte	0
	.even

	.if	fullprice
hfl_trail
	.STRING "  HFI."
	.byte	0
	.even

markka_trail
	.STRING "  MARKKA"
	.byte	0
	.even

krone_trail
	.STRING "  KRONE"
	.byte 0
	.even

guilder_trail
	.STRING "  GUILDER"
	.byte 0
	.even

forint_trail
	.STRING	"  FT",0
	.endif

*
*	for the coinage adjustment mode:
*
*
*	this set is titles for the canned modes.
*
usa_1	.STRING "USA 1",0
	.even
usa_2	.STRING "USA 2",0
	.even
usa_3	.STRING "USA 3",0
	.even
usa_4	.STRING "USA 4",0
	.even

	.if	fullprice
usa_5	.STRING "USA 5",0
	.even
usa_6	.STRING "USA 6",0
	.even
usa_7	.STRING "USA 7",0
	.even
usa_8	.STRING "USA 8",0
	.even
	.endif

usa_electitle
	.STRING	"USA ECA",0
	.even

french_electitle
	.STRING	"FRANCE ECA",0
	.even

german_electitle
	.STRING	"GERMAN ECA",0
	.even


german_1 .STRING "GERMAN 1",0
	.even
german_2 .STRING "GERMAN 2",0
	.even
german_3 .STRING "GERMAN 3",0
	.even
german_4 .STRING "GERMAN 4",0
	.even
german_5 .STRING "GERMAN 5",0
	.even

french_1 .STRING "FRANCE 1",0
	.even
french_2 .STRING "FRANCE 2",0
	.even
french_3 .STRING "FRANCE 3",0
	.even
french_4 .STRING "FRANCE 4",0
	.even

	.if	fullprice
french_5 .string w_france," 5",0
	.even
french_6 .string w_france," 6",0
	.even
french_7 .string w_france," 7",0
	.even
french_8 .string w_france," 8",0
	.even
french_9 .string "france 9",0
	.even
french_10 .string "france 10",0
	.even
french_11 .string "france 11",0
	.even
french_12 .string w_france," 12",0
	.even

canada
	.STRING	"CANADA",0
	.even

swiss_1 .STRING "SWISS 1"
	.byte	0
	.even
swiss_2 .STRING "SWISS 2"
	.byte	0
	.even
swiss_3 .STRING "SWISS 3"
	.byte	0
	.even
italy_1 .STRING "ITALY"
	.byte	0
	.even
uk_1	.STRING "U.K. 1"
	.byte	0
	.even
uk_2	.STRING "U.K. 2"
	.byte	0
	.even
uk_3	.STRING "U.K. ECA"
	.byte	0
	.even
uk_4	.STRING "U.K. ELEC W/CCU"
	.byte	0
	.even
sp_1	.STRING "SPAIN 1"
	.byte	0
	.even
sp_2	.STRING "SPAIN 2"
	.byte	0
	.even
aus_1	.STRING "AUSTRALIA 1"
	.byte	0
	.even
aus_2	.STRING "AUSTRALIA 2"
	.byte	0
	.even
	.endif

jap_1	.STRING "JAPAN 1"
	.byte	0
	.even

	.if	fullprice
jap_2	.STRING "JAPAN 2"
	.byte	0
	.even
asta_1	.STRING "AUSTRIA 1"
	.byte	0
	.even
asta_2	.STRING "AUSTRIA 2"
	.byte	0
	.even
bel_1	.STRING "BELGIUM 1"
	.byte	0
	.even
bel_2	.STRING "BELGIUM 2"
	.byte	0
	.even
bel_3	.STRING "BELGIUM 3"
	.byte	0
	.even
belgium_electitle
	.STRING	"BELGIUM ECA",0
	.even
swed_1	.STRING "SWEDEN"
	.byte	0
	.even
nz_1	.STRING "NEW ZEALAND 1"
	.byte	0
	.even
nz_2	.STRING "NEW ZEALAND 2"
	.byte	0
	.even
neth	.STRING "NETHERLANDS"
	.byte	0
	.even

finland	.STRING "FINLAND"
	.byte 0
	.even

norway	.STRING "NORWAY"
	.byte 0
	.even

denmark	.STRING "DENMARK"
	.byte 0
	.even

antilles .STRING "ANTILLES"
	.byte 0
	.even

hungary
	.STRING "HUNGARY",0
	.even

	.endif
*
*	this section is a pointer to string lists
*	for the "current setting" box.
*
usa_el
	.long	ec1
	.long	doll4
	.long	0
*
*	1 coin / 1 credit
q_q
	.long	c11		 ;this points at message
	.long	0		   ;this ends list
*
*	2 coins / 1 credit
*
f_f_1s1c
	.long	c21
	.long	0

*************************************************************************


*
*	2 coins / 1 credit
*	4 coins / 3 credits
*
dollar_3 .long	c21
	.long	c43
	.long	0
*
*	2 coins / 1 credit
*	4 coins / 4 credits
*
dollar_4 .long	c21
	.long	c44
	.long	0


********************************************************************


	.if	fullprice

u1q4d	.long	c11		 ;this points at message
	.long	doll4		;4 for a dollar
	.long	0

;ufs2d	.long	c21		; this points at message
;	.long	doll2		; 2 for a dollar
;	.long	0

ufs3d	.long	c21		 ;this points at message
	.long	doll3		;3 for a dollar
	.long	0

ufs4d	.long	c21		 ;this points at message
	.long	doll4		;4 for a dollar
	.long	0

	.endif

*
*	1 play 1/dm
*	5 play 5/dm
*
dm_5	.long	dm11
	.long	dm55
	.long	0

dm_6	.long	dm11
	.long	dm65
	.long	0

dm_7	.long	dm11
	.long	dm75
	.long	0

dm_8	.long	dm11
	.long	dm85
	.long	0

dm112265
	.long	dm11
	.long	dm22
	.long	dm65
	.long	0

sfranc_6     .long   sfranc11
	.long	sfranc65
	.long	0

can_1503d
	.long   c15		;this points at message
	.long   doll3		;3 for a dollar
	.long   0

sfranc_7     .long   sfranc11
	.long	sfranc75
	.long	0

sfranc_8     .long   sfranc11
	.long	sfranc85
	.long	0
*
*	2 plays 5f / 5 plays 10f
*
five_10	.long	f25
	.long	f510
	.long	0

five_10_11
	.long	f25
	.long	f510
	.long	f1120
	.long	0

four_10	.long	f25
	.long	f410
	.long	0

four_10_9
	.long	f25
	.long	f410
	.long	f4109
	.long	0

three_10 .long	f15
	.long	f310
	.long	0

three_10_7
	.long	f15
	.long	f310
	.long	f4107
	.long	0

two_10	.long	f15
	.long	f210
	.long	0

two_10_5 .long	f15
	.long	f210
	.long	f4105
	.long	0

f1325	.long	f3x1f
	.long	f2f5
	.long	0

f13255	.long	f3x1f
	.long	f2f5
	.long	f52x5
	.long	0

f1235	.long	f2x1f
	.long	f3f5
	.long	0

f12355	.long	f2x1f
	.long	f3f5
	.long	f72x5
	.long	0

	.if	fullprice

*	500 lire

p1500l	.long	p1500l_p
	.long	0

*	1 play / 20 p	 3 plays 50 p

uk_120	.long	uk_1201
	.long	uk_1202
	.long	0

uk_220	.long	uk_2201
	.long	uk_2202
	.long	0

uk_320	.long	uk_3201
	.long	uk_3202
	.long	uk_3203
	.long	0

uk_420	.long	uk_4201
	.long	uk_4202
	.long	uk_4203
	.long	0

sp_4100	.long	sp_11
	.long	sp_44
	.long	0

sp_5100	.long	sp_11
	.long	sp_54
	.long	0

au_60	.long	au_36
	.long	au_2d
	.long	0

au_100	.long	au_520
	.long	au_1d
	.long	0

	.endif

jap_100	.long	jap_101
	.long	0

	.if	fullprice

jap_200	.long	jap_201
	.long	0

asta_10	.long	asta101
	.long	asta102
	.long	0

asta_15	.long	asta151
	.long	asta152
	.long	0

bel_120	.long	bel_1201
	.long	0
bel_220	.long	bel_2201
	.long	0
bel_320	.long	bel_3201
	.long	0

swed_2x5 .long	swed_s51
	.long	swed_s52
	.long	0

nz_12	.long	nz_121
	.long	0

nz_13	.long	nz_131
	.long	0

neth_hf	.long	hf_11
	.long	hf_32
	.long	0

finmka	.long	fin_1
	.long	0

kr_list	.long	nor_12
	.long	nor_35
	.long	0

dkr_list .long	den_12
	.long	den_35
	.long	den_710
	.long	0

ant_list .long	ant1p25
	.long	ant4dol
	.long	0

hung_list
	.long	hung2x10
	.long	hung2x20
	.long	0

	.endif

ec1	.STRING	"1 CREDIT / 25 CENTS",0
	.even
c11	.string  "1 ",w_credit," / 1 ",w_coin
	.byte 0
	.even
c21	.string  "1 ",w_credit," / 2 ",w_coins
	.byte 0
	.even
c43	.string  "3 ",w_credit,"s / 4 ",w_coins
	.byte 0
	.even
c44	.string  "4 ",w_credit,"s / 4 ",w_coins
	.byte 0
	.even
c15
	.string	"1 ",w_credit," / 2 x 25 cents",0
	.even

doll2	.string  "2 ",w_credit,"s / $1.00"
	.byte 0
	.even

doll3	.string  "3 ",w_credit,"s / $1.00"
	.byte 0
	.even

doll4	.string  "4 ",w_credit,"s / $1.00"
	.byte 0
	.even

dm11	.string  "1 ",w_credit," / 1 dm",0
	.even
dm22	.string  "2 ",w_credit,"s / 2 dm",0
	.even
dm55	.string  "5 ",w_credit,"s / 5 dm",0
	.even
dm65	.string  "6 ",w_credit,"s / 5 dm",0
	.even
dm75	.string  "7 ",w_credit,"s / 5 dm",0
	.even
dm85	.string  "8 ",w_credit,"s / 5 dm",0
	.even

f3f5	.string  "3 ",w_credit,"s / 5f"
	.byte 0
	.even
f2f5
f25	.string  "2 ",w_credit,"s / 5f"
	.byte 0
	.even
f15	.string  "1 ",w_credit," / 5f"
	.byte 0
	.even
f510	.string  "5 ",w_credit,"s / 10f"
	.byte 0
	.even
f1120	.string  "11 ",w_credit,"s / 2 x 10f"
	.byte 0
	.even
f4109	.string  "9 ",w_credit,"s / 2 x 10f"
	.byte 0
	.even
f4107	.string  "7 ",w_credit,"s / 2 x 10f"
	.byte 0
	.even
f4105	.string  "5 ",w_credit,"s / 2 x 10f"
	.byte 0
	.even
f410	.string  "4 ",w_credit,"s / 10f"
	.byte 0
	.even
f310	.string  "3 ",w_credit,"s / 10f"
	.byte 0
	.even
f210	.string  "2 ",w_credit,"s / 10f"
	.byte 0
	.even

f3x1f	.string  "1 ",w_credit," / 3 x 1f"
	.byte	0
	.even

f2x1f	.string  "1 ",w_credit," / 2 x 1f"
	.byte	0
	.even

f52x5	.string  "5 ",w_credit,"s / 2 x 5f"
	.byte	0
	.even

f72x5	.string  "7 ",w_credit,"s / 2 x 5f"
	.byte	0
	.even

sfranc11     .string  "1 ",w_credit," / 1f"
	.byte 0
	.even
sfranc65     .string  "6 ",w_credit,"s / 5f"
	.byte 0
	.even
sfranc75     .string  "7 ",w_credit,"s / 5f"
	.byte 0
	.even
sfranc85     .string  "8 ",w_credit,"s / 5f"
	.byte 0
	.even

	.if	fullprice
p1500l_p .string      "1 CREDIT / 500 LIRE"
	.byte 0
	.even

uk_1201	.string	"1 CREDIT / 20 P"
	.byte 0
	.even
uk_1202	.string	"3 CREDITS / 50 P"
	.byte 0
	.even

uk_2201	.string	"2 CREDITS / 20 P"
	.byte 0
	.even
uk_2202	.string	"5 CREDITS / 50 P"
	.byte 0
	.even

uk_3201	.string	"1 CREDIT / 30 P"
	.byte 0
	.even
uk_3202	.STRING	"2 CREDITS / 50 P"
	.byte 0
	.even
uk_3203	.STRING	"4 CREDITS / L1.00"
	.byte 0
	.even

uk_4201	.STRING	"1 CREDIT / 20 P"
	.byte 0
	.even
uk_4202	.STRING	"3 CREDITS / 50 P"
	.byte 0
	.even
uk_4203	.STRING	"7 CREDITS / L1.00"
	.byte 0
	.even

sp_11	.STRING	"1 CREDIT / 100 PESETA"
	.byte	0
	.even

sp_44	.STRING	"5 CREDITS / 500 PESETA"
	.byte	0
	.even

sp_54	.STRING	"6 CREDITS / 500 PESETA"
	.byte	0
	.even
nz_131
au_36	.STRING	"1 CREDIT / 3 X 20 CENTS"
	.byte	0
	.even
au_2d	.STRING	"2 CREDITS / $ 1.00"
	.byte	0
	.even
au_520	.STRING	"1 CREDIT / 5 X 20 CENTS"
	.byte	0
	.even
au_1d	.STRING	"1 CREDIT / $ 1.00"
	.byte	0
	.even
	.endif

jap_101	.STRING	"1 CREDIT / 100 YEN"
	.byte	0
	.even

	.if fullprice

jap_201	.STRING	"2 CREDITS / 100 YEN"
	.byte	0
	.even
asta101	.STRING	"1 CREDIT / 2 X 5 SCHILLING"
	.byte	0
	.even
asta102	.STRING	"3 CREDITS / 2 X 10 SCHILLING"
	.byte	0
	.even
asta151	.STRING	"1 CREDIT / 5 SCHILLING"
	.byte	0
	.even
asta152	.STRING	"2 CREDITS / 10 SCHILLING"
	.byte	0
	.even

bel_1201 .STRING	"1 CREDIT / 2OF"
	.byte	0
	.even
bel_2201 .STRING	"2 CREDITS / 2OF"
	.byte	0
	.even
bel_3201 .STRING	"3 CREDITS / 2OF"
	.byte	0
	.even

swed_s51 .STRING	"1 CREDIT / 3 X 1 KRONA"
	.byte	0
	.even
swed_s52 .STRING	"2 CREDITS / 5 KRONA"
	.byte	0
	.even

nz_121	.STRING	"1 CREDIT / 2 X 20 CENTS"
	.byte	0
	.even

hf_11	.STRING	"1 CREDIT / 1 HFI"
	.byte	0
	.even

hf_32	.STRING	"3 CREDITS / 2.5 HFI"
	.byte	0
	.even

fin_1	.STRING	"1 CREDIT / 1 MARKKA"
	.byte	0
	.even

den_12
nor_12	.STRING	"1 CREDIT / 2 X 1 KRONE"
	.byte 0
	.even

nor_35	.STRING	"3 CREDITS / 5 X 1 KRONE"
	.byte 0
	.even

den_35	.STRING	"3 CREDITS / 5 KRONE"
	.byte 0
	.even

den_710	.STRING	"7 CREDITS / 2 X 5 KRONE"
	.byte 0
	.even

ant1p25	.STRING	"1 CREDIT / 25 CENTS"
	.byte 0
	.even

ant4dol	.STRING	"4 CREDITS / 1 GUILDER"
	.byte 0
	.even

hung2x10
	.STRING	"1 CREDIT / 2 X 10 FORINT",0
	.even

hung2x20
	.STRING	"3 CREDITS / 2 X 20 FORINT",0
	.even

	.endif

**************************************************************************
*									*
*	 coin slot titles						*
*									*
**************************************************************************

usa_eslot	
	.STRING	"1 DOLLAR  10/25/5 CENT",0
	.even

france_eslot
	.STRING	"1/10/5 FRANCS",0
	.even

german_eslot
	.STRING	"5/1/2 DM",0
	.even

belgium_eslot
	.STRING	"50/5/20 FR",0
	.even

usa_qq	    .STRING   "25 CENT       25 CENT"
	    .byte 0
	    .even

	.if	fullprice
usa_qdq
	.STRING   "25 CENT     $1.00     25 CENT",0
	.even
	.endif

german_15    .STRING   "1 DM      5 DM"
	    .byte 0
	    .even
french510    .STRING   "5 F       10 F"
	    .byte 0
	    .even
french1f5f
	.STRING   "1 F       5 F",0
	.even

can_qd
	.STRING	"25 CENT       $ 1.00",0
	.even

	.if	fullprice
swiss15	    .STRING   "1 F       5 F"
	    .byte 0
	    .even
italylire    .STRING   "500 LIRE      500 LIRE"
	    .byte 0
	    .even
uk2050	    .STRING   "20 P      50 P"
	    .byte 0
	    .even
uk_elec	    .STRING   "L1.00  20P  50P  10P"
	    .byte 0
	    .even
uk_ccu	    .STRING   "CCU ON LEFT SLOT	   "
	    .byte 0
	    .even
peseta100
	.STRING   "100 PESETA     500 PESETA",0
	.even
aust20c
	.STRING   "20 CENT       $ 1.00",0
	.even

	.endif

yen100	    .STRING   "100 YEN       100 YEN"
	    .byte 0
	    .even

	.if	fullprice
shill510     .STRING   "5 SCHILLING   10 SCHILLING"
	    .byte 0
	    .even
franc20	    .STRING   "20 F      20 F"
	    .byte 0
	    .even
krona5	    .STRING   "1 KRONA       5 KRONA"
	    .byte 0
	    .even
nz20	    .STRING   "20 CENT       20 CENT"
	    .byte 0
	    .even
hfslot	    .STRING   "1 HFI     2.5 HFI"
	    .byte 0
	    .even

mkslot	    .STRING   "1 MARKKA      1 MARKKA"
	    .byte 0
	    .even

nkrslot	    .STRING   "1 KRONE       1 KRONE"
	    .byte 0
	    .even

dkrslot	    .STRING   "1 KRONE       5 KRONE"
	    .byte 0
	    .even

antslot	    .STRING   "25 CENTS      1 GUILDER"
	    .byte 0
	    .even

hungslot
	.STRING	"10 FORINT     20 FORINT",0
	.even

	.endif

cp_cx	equ	200
cp_11	equ	11
cp_13	equ	13
cp_23	equ	23
cp_33	equ	33




txt_2_to_start
	mess_mac rd15font,spacing20,cp_cx,cp_11,trog_plf,strcnrm,0
	.byte	"2 CREDITS TO START",0,1
	.even
	mess_mac rd15font,spacing20,cp_cx,cp_23,trog_plf,strcnrm,0
	.BYTE	"1 CREDIT TO CONTINUE",0,0
	.even

;two_per_player
;	mess_mac  rd7font,spacing07,cp_cx,cp_11,trog_plf,strcnrm,0
;	.string   "2 ",w_coins," per ",w_play,"er"
;	.byte	  0,0
;	.even

ocop	mess_mac  rd7font,spacing07,cp_cx,cp_11,trog_plf,strcnrm,0
	.string   "1 ",w_coin," / 1 ",w_play
	.byte	  0,0
	.even

usa_electronic:
	mess_mac  rd7font,spacing07,cp_cx,cp_13,trog_plf,strcnrm,0
	.string	"1 credit  /  25 cents"	
	.string	"\n4 CREDITS /  1 DOLLAR",0,1
	.even

france_electronic:
	mess_mac  rd7font,spacing07,cp_cx,cp_13,trog_plf,strcnrm,0
	.STRING	"1 CREDIT  /  25 CENTS"	
	.string	"\n4 CREDITS /  1 DOLLAR",0,1
	.even

german_electronic:
	mess_mac  rd7font,spacing07,cp_cx,cp_13,trog_plf,strcnrm,0
	.STRING	"1 CREDIT  /  1 DM"	
	.string	"\n6 CREDITS /  5 DM",0,1
	.even

	.if	fullprice
belgium_electronic:
	mess_mac  rd7font,spacing07,cp_cx,cp_13,trog_plf,strcnrm,0
	.STRING	"1 CREDIT  /  20 FR"	
	.even

uk_electronic
	mess_mac  rd7font,spacing07,cp_cx,cp_13,trog_plf,strcnrm,0
	.string   "1 ",w_credit," / 30 P"
	.byte	  0,1
	.even
	mess_mac  rd7font,spacing07,cp_cx,cp_23,trog_plf,strcnrm,0
	.string   "2 ",w_credit,"s / 50 P"
	.byte	  0,1
	.even
	mess_mac  rd7font,spacing07,cp_cx,cp_33,trog_plf,strcnrm,0
	.string	"4 ",w_credit,"s / "
	.byte	  font_epound
	.string	"1.00"
	.byte	  0,0
	.even
	.endif

	.end
