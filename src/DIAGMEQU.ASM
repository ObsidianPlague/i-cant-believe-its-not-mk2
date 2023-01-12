**************************************************************************
*									    *
*	     copyright (c) 1990 midway manufacturing company,		 *
*	      manufacturers of bally/midway amusement games.		 *
*			 all rights reserved.				 *
*									    *
**************************************************************************

**************************************************************************
*									    *
*			    menu equates				 *
*									    *
**************************************************************************

**************************************************************************
*									    *
*	screen_wide							 *
*									 *
*	constant for menu screen size definitions			 *
*									 *
*	= 0	400 x 256 ( trog )					 *
*									 *
*	= 1	512 x 400 ( narc )					 *
*									    *
**************************************************************************

screen_wide	equ	0

*
*	for each entry in the menu
*
menu_text_ptr	equ	0		;offset of text pointer
menu_routine	equ	long_size	;offset of routine
menu_help	equ	menu_routine+long_size
menu_entry_size	equ	3*long_size	
*
blnk_help	equ	0		;no help box for this entry
no_help		equ	00000001h	;no help area in this menu
adj_help 	equ	00000002h	;pass structure pointer to adjustment help rout
snd_help 	equ	00000003h	;called on sound test menu
snd_play 	equ	00000004h	;called from sound "play" selections
*
snd_mess_y	equ	200
snd_box_h	equ	57

*
*	spacing between boxes on screen
*
	.if	screen_wide
box_ygap equ	6
box_xgap equ	6
	.else
box_ygap equ	3
box_xgap equ	5
	.endif
*
*
*	a centered box needs to be moved left this amount
*	(pixels) to correctely frame centered text at
*	the same position
*
*c_kludge equ	    3		;before "space width" bug fix
c_kludge equ	1
*
*	these determine the thickness of the box lines
*
	.if	screen_wide
mb_xwid	equ	5		; narc values
mb_ywid	equ	5
	.else
mb_xwid	equ	3
mb_ywid	equ	3
	.endif

*
*	gap between a menu border box and
*	the selection bar
*
gap	equ	2		;gap between border and selection bar
*
*	constant to pass to "do_border" for our
*	box size
*
border_size	equ	(mb_ywid*10000h)+mb_xwid

*******************************test title constants****************************
*
*	these are used to set top box and main title.
*	the menus and help screens will square off
*	to the numbers set here.
*
	.if	screen_wide
tm_x	equ	256		;used to position title and box together
tm_y	equ	24
	.else
tm_x	equ	200
tm_y	equ	24
	.endif

	.if	screen_wide
tit_ulx	equ	tm_x-212
tit_lrx	equ	tm_x+204
tit_uly	equ	tm_y-09
tit_lry	equ	tm_y+49
	.else
tit_ulx	equ	tm_x-195
tit_lrx	equ	tm_x+189
tit_uly	equ	tm_y-06
tit_lry	equ	tm_y+32
	.endif

********************************main menu constants***************************

inst_uly 	equ	tit_lry+box_ygap	   ;y range for instruction box
	.if	screen_wide
inst_lry 	equ	inst_uly+40
bar_dy		equ	-12
bar_wid	equ	235
menu_dy		equ	42
bar_hite 	equ	40
bar_dx		equ	8
	.else
inst_lry	equ	inst_uly+29
bar_dy		equ	-8
bar_wid	equ	183
;bar_wid 	equ	(tit_lrx-tit_ulx)
;menu_dy 	equ	27
menu_dy		equ	23
bar_hite 	equ	26
bar_dx		equ	6
	.endif

menu_x	equ	tit_ulx+gap+mb_xwid+(bar_wid/2)+c_kludge
menu_y	equ	inst_lry+box_ygap+mb_ywid+gap-bar_dy
*
*	help drawer constants
*
help_x_margin	equ	10			;margin for left justified help text
help_y_margin	equ	8			;top of box to 1st entry
help_ylo_margin	equ	help_y_margin-4	;bottom margin is a touch less due
*						;to spacing
help_dy		equ	12			;screen units per item.
*
*
*	adjustment menu constants
*
*	"current setting" box
*
cur_uly	equ	125
cur_lrx	equ	tit_lrx
cur_lry	equ	cur_uly+(inst_lry-inst_uly)	;same height as top box
cur_uly2	equ	180
cur_lry2	equ	cur_uly2+(inst_lry-inst_uly)
*
adj_uly	equ	cur_lry2+box_ygap			 ;use our "fixed" spacing.
adj_culy	equ	adj_uly-50		; coin upper left y
adj_puly	equ	adj_uly-28
*
;coin_head_y  equ    cur_uly+91				 ;1st of top coin info lines
coin_head_y  equ    cur_uly+71				;1st of top coin info lines
mess_cts     equ    coin_head_y+35		    ;start/continue place

**************************************************************************
*												*
*		  coin select table offsets						*
*												*
**************************************************************************
*
*	if "chutes" value changes.....extra words must be put here
*
cs_lmult equ	0
cs_cmult equ	cs_lmult+word_size
cs_rmult equ	cs_cmult+word_size
cs_xmult equ	cs_rmult+word_size
cs_ucred equ	cs_xmult+word_size
cs_ubon	equ	cs_ucred+word_size
cs_umin	equ	cs_ubon+word_size
cs_strt  equ	cs_umin+word_size	
cs_cont  equ	cs_strt+word_size	
cs_cdiv	equ	cs_cont+word_size
cs_frac	equ	cs_cdiv+word_size
cs_copy	equ	cs_frac+word_size		;up to here is copied as adjustments
cs_lval	equ	cs_copy
cs_cval	equ	cs_lval+word_size
cs_rval	equ	cs_cval+word_size
cs_xval	equ	 cs_rval+word_size
cs_lmes	equ	cs_xval+word_size
cs_rmes	equ	cs_lmes+long_size
cs_prompt equ	cs_rmes+long_size
cs_title equ	cs_prompt+long_size
cs_list	equ	cs_title+long_size
cs_pick	equ	cs_list+long_size		;which line to add to 2 to start...1 to
cs_slots equ	cs_pick+word_size		;text describing coin slots
cs_size	equ	cs_slots+long_size
*
*
*	adjustment structure.	this structure is
*	pointed to by the 2nd menu long word (where normally
*	the routine lives).
*
ad_rout	equ	0				;long...routine to run when selected.
ad_title equ	ad_rout+long_size		;long...pointer to title for right column
ad_help	equ	ad_title+long_size		;long...point to help struct for explanation
ad_cmos	equ	ad_help+long_size		;word...get_adj / put_adj number.
ad_min	equ	ad_cmos+word_size		;long...minimum value for adj.
ad_max	equ	ad_min+long_size		;long...maximum value for adj.
ad_delta equ	ad_max+long_size		;long...units between values.
ad_zequ	equ	ad_delta+long_size		;long...number to store as a zero.
ad_nameit equ	ad_zequ+long_size		;long...routine to print values.
ad_flags  equ	ad_nameit+long_size		;word...bit zero non zero says wrap
*						;	   bit one non zero says bcd
						;	   bit two says flag "1st 8 coinage changed"  (adjvirgin)
						;	   bit three says flag 1st 6 changed  (adj1st6)
						;	   bit four says its hsr counter
ad_namptr equ	ad_flags+word_size		;long...pointer to data for nameit routine
ad_main	equ	ad_namptr+long_size		;long...main menu string

wrap_bit equ	0
bcd_bit	equ	1
virg_bit equ	2
six_bit	equ	3
hsr_bit	equ	4
wrap_val equ	1
bcd_val	equ	2
virg_val equ	4
six_val	equ	8
hsr_val	equ	16
*
*	for cselect table......
*
*	a1 = 1	plot only the string list (1 or 2 pointers
*		centered appropriately
*
*	a1 = 2	plot the 1st line of the string list along
*		with the 2 credits to start...1 to continue
*	
*	a1 = 3	plot the 2nd line of the string list along
*		with the 2 credits to start...1 to continue
*
csm_list equ	1
csm_1w_21 equ	2
csm_2w_21 equ	3
csm_3w_21 equ	4
csm_last equ	4

*
*	for cs_pick:
*
show_none	equ	0		;just use 2/1 by itself
show_1		equ	2		;show 1st line
show_2		equ	3		;show 2nd line
show_3		equ	4		;show 3rd line

* masks for button bits read from the switch latch

button_bits	.set	00000000001001000111000001110000b
button_bits2	.set	00000000000000000000000001110111b

bb_nostart	.set	00000000000000000111000001110000b

;button_bits	.equ	0be247070h	;all buttons
;bb_nostart	.equ	0be007070h	;all buttons sans starts
