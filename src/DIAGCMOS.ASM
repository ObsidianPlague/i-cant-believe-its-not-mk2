**************************************************************************
*												*
*	     adjustments and audit storage						*
*												*
*	original: larry demar	november 10, 1988					*
*	revision: kurt mahan	february 19, 1990					*
*	revision: george petro	august 2, 1990						*
*												*
*	copyright (c) 1990 williams electronics games, inc.			*
*	all rights reserved.									*
*												*
**************************************************************************
	.file	'diagcmos.asm'
	.title	"<<< cmos adjusment and audit primitives >>>"
	.width	132
	.option	b,d,l,t
	.mnolist

	.include	macros.hdr
	.include	"dispequ.asm"		;display processor equates
	.include	"sysequ.asm"		;system equates
	.include	"mainequ.asm"		;game equates
	.include	"imgtbl.glo"
	.include	"stringh.asm"

	.include	"diagsequ.asm"
	.include	"diagmequ.asm"		;menu equates
	.include	"diagaudn.asm"		;auditing offsets

	.global		get_hscr
	.global		rc_bytei
	.global		rc_byte
	.global		rc_word
	.global		rc_long
	.global		rc_longi
	.global		wc_byte
	.global		wc_bytei
	.global		wc_word
	.global		wc_wordi
	.global		wc_long
	.global		wc_longi
	.global		pt_entry
	.global		p_fork
	.global		rom_ptrs
	.global		e_game
	.global		ishstd
	.global		set_page
	.global		a2_check

	.global		kill_aud
	.global		clr_audr
	.global		clr_aud

	.def	def_page, get_aud, cmos_val, fac_set
	.def	form_adc, f_adc_s, adj_page, put_adj
	.def	cmoslock, cmosunlock, store_audit, bad_aud

	.ref	no_creds
	.ref	rom_name

free_play	equ	1
	
*
*	bad_aud - anytime an audit number is fetched, if its
*		  checksum is bad, then bad_aud gets set to 1
*		  this causes "error" if any audit in a calculation
*		  is corrupted, and keeps a bad checksum bad when
*		  an audit is changed.

	.bss		bad_aud,16	;(bad_aud...not bad_dog!)	
	.text

**************************************************************************
*												*
*	  coin_pag									     *
*												*
*	  this sets the current cmos page for coin/credits			*
*												*
**************************************************************************
coin_pag
	mmtm	sp,a1
	movi	coin_select,a1		;this is coin/credits page
	calla	set_page		;set it please
	mmfm	sp,a1
	rets

**************************************************************************
*												*
*	 audit handling 									*
*												*
**************************************************************************
*												*
*	  point_at_audit									*
*												*
*	  this is called to point at the audit indicated by			*
*	  a0.  a0 is the audit number 0-30.  a7 is returned			*
*	  pointing at the beginning of the audit.					*
*												*
**************************************************************************
point_at_audit
	mmtm	sp,a1
	movi	audit_select,a1 	;this is audit page
	calla	set_page		;set it please
;	callr	audit_page
	movi	aud_size,a7		;this is size per audit
	mpyu	a0,a7			;a1 now has offset
	addi	auditorg,a7		;add base
	mmfm	sp,a1
	rets

;audit_page
;	mmtm	sp,a1
;	movi	audit_select,a1 	;this is audit page
;	calla	set_page		;set it please
;	mmfm	sp,a1
;	rets

**************************************************************************
*												*
*	  form_aud_cksum									*
*												*
*	  this is called to form the checksum for the audit			*
*	  specified in a0.									*
*												*
*	  a1 returns the checksum.								*
*												*
*	  z bit is set based on whether it matches the checksum there.	*
*												*
**************************************************************************

form_aud_cksum
	mmtm	sp,a0,a4,a7
	callr	point_at_audit			;a7 = pointer to current entry
	mmtm	sp,a7				;save pointer to entry
	movi	aud_bytes_to_check,a4	;count down the bytes
	clr	a1				;keep sum in a1
add_a_byte
	calla	rc_bytei			;get a byte into a0
	add	a0,a1				;add to sum
	dsj	a4,add_a_byte			;one more added
	not	a1				;checksum is now in low word
	andi	word_mask,a1			;mask so its cool
	mmfm	sp,a7				;get pointer back
	addi	aud_cksum,a7			;point at checkbyte
	calla	rc_word 			;read in the cksum
	cmp	a0,a1				;compare what's there to what we got
	mmfm	sp,a0,a4,a7			;z bit returns compare
	rets					;a1 returns cksum

**************************************************************************
*												*
*	  store_aud_cksum									*
*												*
*	  this will store the audit checksum in a1 for the			*
*	  audit number specified by a0.							*
*												*
**************************************************************************

store_aud_cksum
	mmtm	sp,a7,a0			;pointing register
	callr	point_at_audit			;a7 points at audit
	addi	aud_cksum,a7			;point at checkbyte
	move	a1,a0				;get checkbyte in a0
	calla	wc_word 			;write the cksum
	mmfm	sp,a7,a0			;pointing register
	rets

**************************************************************************
*												*
*	  form_aud_cksum_and_store								*
*												*
*	  the value at bad_aud is used to determine whether to store	*
*	  the correct or incorrect value! 						*
*												*
*	  a0 = audit number									*
*												*
**************************************************************************

form_aud_cksum_and_store
	mmtm	sp,a1,a2			   ;save a1!
	callr	form_aud_cksum
	move	@bad_aud,a2,w			   ;get the "fudge" word
	xor	a2,a1				   ;make cksum bad if audit is bad
	callr	store_aud_cksum
	mmfm	sp,a1,a2
	rets

**************************************************************************
*												*
*	  get_aud										*
*												*
*	  this is called to fetch the audit value for the audit		*
*	  specified in a0 into a1.  if the checkbyte for the			*
*	  audit is incorrect, then ram location bad_aud will be		*
*	  set to 1.										*
*												*
**************************************************************************
get_aud
	mmtm	sp,a7,a0
	callr	form_aud_cksum		;see if cksum is ok
	jrz	fetch_audit_1		;its ok....
*
*	checksum is bad....set global
*
	movk	1,a1
	move	a1,@bad_aud,w		;set the flag!

fetch_audit_1
	callr	point_at_audit		;a7 points at audit
	addi	aud_data,a7		;add zero offset
	calla	rc_long 		;fetch the long word to a0
	move	a0,a1			;return in a1
	mmfm	sp,a7,a0
	rets

**************************************************************************
*												*
*	  store_audit										*
*												*
*	  a0 = audit number to store value for 					*
*	  a1 = value to store.									*
*	  bad_aud = non zero if bad checksum is to be maintained.		*
*												*
**************************************************************************

store_audit
	mmtm	sp,a0,a7
	callr	point_at_audit		;a7 points at audit
	addi	aud_data,a7		;add zero offset
	move	a1,a0			;move data to writing register
	calla	wc_long 		;write the data back
	mmfm	sp,a0,a7		;get audit number back
	jruc	form_aud_cksum_and_store	  ;store good or bad cksum based
*						  ;on bad_aud

**************************************************************************
*												*
*	  clr_subs										*
*												*
*	  this is called to clear out the coinage sub-totals. 		*
*												*
**************************************************************************

clr_subs 
	retp
;	movi	frst_sub,a0
;	movi	last_sub,a1
;       callr   clr_audr        ;clear em out!
;	 retp

**************************************************************************
*												*
*	  clr_audr										*
*												*
*	  this is called to clear out a range of audits. 			*
*	  a0 = 1st audit number 								*
*	  a1 = last audit number (inclusive)						*
*												*
**************************************************************************

clr_audr
	mmtm	sp,a0,a1,a2
	move	a1,a2				;move "last" to a2
	clr	a1				;we'll store zeros
	move	a1,@bad_aud			;make cksums good on storing
car1	callr	store_audit			;store this audit
	inc	a0				;kick to next audit
	cmp	a2,a0
	jrls	car1
	mmfm	sp,a0,a1,a2
	rets

**************************************************************************
*												*
*	kill_aud							 			*
*									 			*
*	this is called to clear out an audit.				 		*
*									 			*
*	a0 = audit number.						 			*
*												*
**************************************************************************
kill_aud
	mmtm	sp,a1
        	clr     a1			    ;we'll store zeros
        	move    a1,@bad_aud		    ;make cksums good on storing
        	callr   store_audit		    ;store this audit
	mmfm	sp,a1
	rets

**************************************************************************
*												*
*	  aud											*
*												*
*	  a0 = audit number.......a1 = count to add.				*
*												*
**************************************************************************

aud	mmtm	sp,a1,a2
	clr	a2			;set "bad_aud" good until otherwise proven!
	move	a2,@bad_aud,w		;its good.
	move	a1,a2			;copy our count
	callr	get_aud 		;fetch the current audit counter
	add	a2,a1			;add the new count
	callr	store_audit		;store it back
	callr	def_page		;switch page away from the data!
	mmfm	sp,a1,a2
	rets

aud1	mmtm	sp,a1
	movk	1,a1
	callr	aud
	mmfm	sp,a1
	rets

**************************************************************************
*												*
*	  clr_aud										*
*												*
*	  this is called to clear out all of the audits. 			*
*												*
*	  a relatively easy task given the primitives available.		*
*												*
**************************************************************************
clr_aud
	mmtm	sp,a0,a1
	movi	1,a0			;start at audit 1

	movi	n_audits-1,a1		;this is total allocated
;	movi	last_audit-1,a1
	callr	clr_audr
	mmfm	sp,a0,a1
	rets

**************************************************************************
*												*
*	  adjustments										*
*												*
**************************************************************************

**************************************************************************
*									    			*
*	cmos_val							 			*
*									 			*
*	validate the cmos values					 			*
*									 			*
*	entry								 			*
*		nothing							 			*
*									 			*
*	exit								 			*
*		.eq.	cool						 			*
*		.ne.	it is hosed					 			*
*									    			*
**************************************************************************

cmos_val
        callr   form_adc 	; see if cksum is ok.
        jrnz    cmos_bad        ; nope....return .ne.

        callr   check_name_and_rev   ;how about the name and rev?
cmos_bad
        rets

**************************************************************************
*									    			*
*	form_adc							 			*
*									 			*
*	do a checksum of the adjustments area -- returned in a1		*
*									 			*
*	entry								 			*
*		nothing							 			*
*									 			*
*	exit								 			*
*		a1	checksum value					 		*
*		.eq.	agrees with stored checksum			 		*
*		.ne.	it don't					 			*
*									    			*
**************************************************************************

form_adc:
        mmtm    sp,a7,a0,a6
        callr   adj_page 	 ;set cmos page for adjustments
        movi    adjustorg,a7	    ;point at first byte
        movi    adj_bytes_to_check,a6  ;number of bytes
        clr     a1			 ;accumulate cksum here

adj_c1  calla   rc_bytei 		 ;read a byte
        add     a0,a1			 ;add the byte to the sum
        dsjs    a6,adj_c1

        not     a1			 ;complement the sum
        andi    word_mask,a1		 ;keep a word.

        movi    adj_cksum,a7
        calla   rc_word			 ;fetch the checksum
        cmp     a0,a1			 ;compare to fetched value
	mmfm	sp,a7,a0,a6
	rets

**************************************************************************
*									    *
*	f_adc_s								 *
*									 *
*	form an adjustment checksum and store the value			 *
*									 *
*	entry								 *
*		nothing							 *
*									 *
*	exit								 *
*		nothing							 *
*									    *
**************************************************************************

f_adc_s:
        mmtm    sp,a0,a1,a7
        callr   form_adc 	;form the cksum
        move    a1,a0			 ;put in cmos writing reggie
        movi    adj_cksum,a7
        calla   wc_word			 ;and store it
	mmfm	sp,a0,a1,a7
	rets

**************************************************************************
*									    *
*	get_adj								 *
*									 *
*	gets an adjustment value					 *
*									 *
*	entry								 *
*		a0	adjustment number to get			 *
*									 *
*	exit								 *
*		a0	value of adjustment				 *
*									    *
**************************************************************************

get_adj:
	mmtm	sp,a1,a7
	.if	forcefree
	cmpi	adjfrepl,a0
	jrnz	ganotfree
	movk	1,a0
	jruc	gadone
ganotfree
	.endif
	push	a0
	callr	form_adc	; checksum things
	pull	a0
	jrz	gacool		; br = cmos is cool
	sll	5,a0
	addi	factory_table,a0
	move	*a0,a0,l	; read up the factory adjustment
	jruc	gadone
gacool
        callr   adjpoint 	    ;point at adjustment
        calla   rc_long		    ;fetch the adjust please
        callr   def_page
gadone
        move    a0,a0		    ;return z bit based on adjustment!
        mmfm	sp,a1,a7
        rets

**************************************************************************
*									    			*
*	put_adj								 			*
*									 			*
*	store an adjustment value.  note!  does not rechecksum!!	 	*
*									 			*
*	entry								 			*
*		a0	adjustment number				 			*
*		a1	adjustment value				 			*
*									 			*
*	exit								 			*
*		nothing							 			*
*									    			*
**************************************************************************

put_adj:
	mmtm	sp,a7,a0
	calla	cmosunlock
         callr   adjpoint 	    ;point at requested adj.
         move    a1,a0		    ;get value in writing reggie!
         calla   wc_long		    ;write the adjustment
         callr   def_page 	    ;swap page away.
	calla	cmoslock
	mmfm	sp,a7,a0
	rets

**************************************************************************
*									    *
*	adjpoint							 *
*									 *
*	point a7 at the cmos memloc for the adjustment			 *
*									 *
*	entry								 *
*		a0	adjustment number				 *
*									 *
*	exit								 *
*		a7	pointer to cmos memory				 *
*									    *
**************************************************************************

adjpoint:
        callr   adj_page 	    ;set cmos page for adjustments
        movi    adj_size,a7	    ;size per adjustment in a7
        mpyu    a0,a7		    ;times adjustment requested.
        addi    adjustorg,a7	    ;add to base
        rets

**************************************************************************
*									    			*
*	check_name_and_rev						 			*
*									 			*
*	check the name and the revision against the cmos		 		*
*									 			*
*	entry								 			*
*		nothing							 			*
*									 			*
*	exit								 			*
*		.eq.	cool						 			*
*		.ne.	not cool					 			*
*									    			*
**************************************************************************

check_name_and_rev:
        mmtm    sp,a0,a1,a2,a3,a7
        callr   adj_page 	 ;make sure we're on the correct page

        movi    name_rev,a7	    ;point at cmos name storage
        movi    rom_name,a1	    ;point at our version
        movi    name_rev_size,a2     ;maximum name size

next_let1
        calla   rc_bytei 	    ;fetch a byte
        movb    *a1,a3		    ;get 1 from rom
        andi    byte_mask,a3	    ;mask any sign extends

        cmp     a3,a0		    ;they better be the same
        jrnz    return_now	    ;nope....bye  (return .ne.)

        addi    byte_size,a1	    ;kick source pointer
        move    a0,a0		    ;was it a zero?
        jrz     return_now	    ;yep....no more (return .eq.)
        dsjs    a2,next_let1
        clr     a0		    ;return .eq.

return_now
	mmfm	sp,a0,a1,a2,a3,a7
	rets

**************************************************************************
*									    			*
*	adj_page							 			*
*									 			*
*	set cmos to the adjustments page				 			*
*									 			*
*	entry								 			*
*		nothing							 			*
*									 			*
*	exit								 			*
*		nothing							 			*
*									    			*
**************************************************************************
		
adj_page:
        mmtm    sp,a1
        movi    adjust_select,a1 	;this is audit page
        calla   set_page 	    ;set it please
	mmfm	sp,a1
	rets

**************************************************************************
*									    			*
*	def_page							 			*
*									 			*
*	set to the default page -- the one we don't care about		*
*									 			*
*	entry								 			*
*		nothing							 			*
*									 			*
*	exit								 			*
*		nothing							 			*
*									    			*
**************************************************************************
def_page
        pushst			    ;preserve codes that are being returned
        mmtm    sp,a1
        movi    todays_select,a1     ;this is today's high scores page
        calla   set_page 	    ;set it please
        mmfm    sp,a1
        popst
        rets

**************************************************************************
*											     *
*  fac_set										     *
* 											     *
*  restore the factory settings to the adjustment cmos		     	*
* 											     *
*  entry	nothing									     	*
*  exit	nothing									     	*
*											     *
**************************************************************************
fac_set: 
	mmtm	sp,a0,a1,a2,a7
	callr	cmosunlock
        	calla   no_creds 	    ;remove any coins
        	callr   adj_page 	    ;set cmos page correctly

        movi    factory_table,a1     ;rom
        movi    adjustorg,a7	    ;cmos
        movi    n_adjusts,a2	    ;number of adjustments allocated

facs1   move    *a1+,a0,l	    ;fetch a rom long word
        calla   wc_longi 	    ;write the word to cmos
        dsjs    a2,facs1 	    ;write 1 long word per adjust

;       callr 	switch_for_jumper  ;change coinage based on jumper.
;       callr	 ld_ctab      	    ;expand the cselct value

        callr   f_adc_s	;make the checksum correct.
*
* now store the game name and revision info
*
        movi    name_rev,a7	    ;point at cmos name storage
        movi    rom_name,a1	    ;point at our version
        movi    name_rev_size,a2     ;maximum name size

next_letter
        movb    *a1,a0		    ;fetch a byte
        calla   wc_bytei 	    ;write it to cmos
        addi    byte_size,a1	    ;kick source pointer
        move    a0,a0		    ;was it a zero?
        jrz     name_done	    ;yep....no more!
        dsjs    a2,next_letter
	
name_done
	callr	cmoslock
	calla	fs_inits	    	; clear "player ranking" cmos
	mmfm	sp,a0,a1,a2,a7
	rets

**************************************************************************
*									    			*
*	cmosunlock							 			*
*									 			*
*	call this to unlock the protected portion of cmos		 	*
*									 			*
*	entry								 			*
*		nothing							 			*
*									 			*
*	exit								 			*
*		nothing							 			*
*									    			*
**************************************************************************

cmosunlock:
	push	a0
	.if	yunit
	movi	0200h,a0
	move	a0,@secchip,w
	.endif
	pull	a0
	rets

**************************************************************************
*									    			*
*	cmoslock							 			*
*									 			*
*	call this to relock cmos					 			*
*									 			*
*	entry								 			*
*		nothing							 			*
*									 			*
*	exit								 			*
*		nothing							 			*
*									    			*
**************************************************************************
cmoslock
	push	a0
	.if	yunit
;	move	@syscopy,a0,w		; relock cmos
;	andi	00ffh,a0	
;	ori	0300h,a0		; or is it 3?
;	move	a0,@syscopy,w
;	move	a0,@sysctrl,w
;	move	@syscopy,a0,w
	movi	0300h,a0
	move	a0,@secchip,w
	.endif
	pull	a0
	rets

factory_table
	.long	0000h  ;adj_unused		equ	   0
	.long	0001h  ;adj_pricing		equ	   1 
	.long	0001h  ;adj_left_mult	equ	   2
	.long	0004h  ;adj_center_mult	equ	   3
	.long	0001h  ;adj_right_mult	equ	   4
	.long	0001h  ;adj_fourth_mult	equ	   5
	.long	0001h  ;adj_units_credit	equ	   6
	.long	0000h  ;adj_units_bonus	equ	   7
	.long	0000h  ;adj_min_units	equ	   8
	.long	0004h  ;adjcdiv 		equ	   9
	.long	0001h  ;show fractions	equ	   10	
	.long	2      ; adj_start_cred	equ	   11
	.long	2      ; adj_cont_cred	equ	   12
	.long	3      ; adj_hsreset		equ	   13
	.long	3      ; adj_ddiff		equ	   14
	.long	100    ; adj_volume		equ	   15
	.long	0      ; 			equ	   16
	.long	30     ; maximum credits	equ	   17
	.long	0      ; pay for play	equ	   18
	.long	0001h  ; adjvirgin		equ	   19	
	.long	0      ; adj_hsoff		equ	   20
	.long	0001h  ; non-zero means 1st 6 untouched.		    21
	.long	0      ;
	.long	0      ;
	.long	0000h  ; unused 			  24
	.long	0000h  ; unused 			  35
