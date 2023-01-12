 	.file	'diagtext.asm'
	.title	" <<< text processing routines >>>"
	.width	132
	.option	b,d,l
	.mnolist

**************************************************************************
*									    			*
*	copyright (c) 1990 williams electronics games, inc.		 	*
*	all rights reserved.						 			*
*									    			*
**************************************************************************
	.include 	macros.hdr
	.include	"dispequ.asm"	; display processor equates
	.include	"sysequ.asm"		; system equates
	.include	"mainequ.asm"
	.include	"imgtbl.glo"
	.include	"stringh.asm"

	.include	"diagsequ.asm"	; color defs

;		ascii character string definition
;		---------------------------------
;
;     an ascii string is n consecutive bytes terminated by a 0.
;
;     a string may contain:
;
;	1. printable ascii characters 20h - 7fh.
;
;	2. command character denoted by a leading \.
;
;	3. format specifier denoted by a leading %.
;
;     command characters:
;
;	a command character is identified by a preceding '\'. these
;	are used to embed command characters and the correct arguments
;	in the string.
;
;	arguments follow the string definition in the order that they,
;	along with format arguments, appear in the string.
;
;	to insert a single '\' into the string use '\\'.
;
;	character		argument					size
;	---------		--------					----
;	a			sleep time to embed			.word
;	b			print color to embed		.word
;	c			dma control word to embed	.word
;	d			font to embed				.long
;	e			[y,x] position to embed		.long
;	f			[dy,dx] position delta to embed	.long
;	i			[y,x] spacing to embed		.long
;	n	    		newline
;	p			use new palette, by i.d.		.long
;	u			turn underlining on
;	v			turn underlining off
;
;	inserting a '*' between the \ and the command character will
;	cause the argument to be indirected through the specified pointer.
;
;	example:
;		.string "switch \*b color",0
;		.long	color_ptr
;	  the color that would be inserted is pointed to by color_ptr.	
;
;     format specifiers:	(note: if a string contains format specifiers
;			       then you must call stringf before	
;			       passing it to the string routines.)	
;
;		%[flags][width][{h|l|l}]type
;
;	flags - used for justification of output and printing of
;		signs, blanks and hexadecimal prefixes
;
;		flag	meaning					default
;		----	-------					-------
;		+	prefix the output value with a sign	sign only for
;			+ or - if it is of signed type.		negatives
;		#	prefix x,x with 0x,0x.			no prefix
;		,	used with d,u to print commas		no commas		
;
;	width - a non-negative decimal integer controlling the
;		minimum number of characters printed. if width
;		is prefixed with a 0, zeros are added until the
;		minimum width is reached.
;
;	prefix		use
;	------		---
;	h		used as a prefix with d,u,x,x and c to specify
;			that the argument is a short (byte).
;	l,l		used as a prefix with d,u,x and x to specify
;			that the argument is a long.
;
;	if the % format character is followed by another % then no
;	format field is taken, rather a single % is written.
;
;	type	size		output format			
;	----	----		-------------
;	b	word		pointer to binary coded decimal (bcd) integer
;	d	word		pointer to signed decimal integer
;	u	word		pointer to unsigned decimal integer
;	x	word		pointer to unsigned hex integer using 'abcdef'
;	x	word		pointer to unsigned hex integer using 'abcdef'
;	c	word		pointer to single character
;	p	long		pointer to a null terminated string
;	s	long		address of a null terminated string	
;
;	arguments - must follow the string specification in order.
;
;	examples:
;	---------
;	  this will print the string verbatim,
;		.string	"let's print a string",0
;	
;	  this will put 'count' at the beginning of the string.
;		.string "%d this is item number %d",0
;		.long	count		;pointer to int count
;		.long	count		;pointer to int count
;
;	  this will print 'short_item' as a short and 'long_item' as a long.
;		.string "%hd this item is a long %ld",0
;		.long	short_item	;pointer to int count
;		.long	long_item	;pointer to long long_item
;
;	note: strings may be nested as deep as defined by numsfbufs
;	      also, these parameters have limits, i.e. width, it would	
;		not be wise to specify a width of 30 or greater, and so on.
;
;		commas are not recognized on lead zero fills.

	.ref	dict_lookup

numsfbufs equ	5	;number of buffers for stringf
sfbufsize equ	50*16	;stringf buffers are 99 characters + terminator

	.bss	strngram,30*16	;ram for building of strings by conversion routines
	.bss	stringf_ram,numsfbufs*sfbufsize	;reserve stringf buffers
	.bss	sfindex,16	;index of next usable stringf buffer
	.bss	string1,32	;temp ptr for nested strings, anyone can use
	.bss	string2,32
	.bss	string3,32
	.bss	string_shadow,16
	.bss	string_underline,16	; underline flag

text_zpos	.equ	7fff000ah

	.even
	.text

**************************************************************************
*												*
*	any of the following string print routines require		 	*
*	  these arguments. plus any others specified.			 	*
*									 			*
*	a0 = sleep time between characters						*
*	a4 = dma control						 			*
*	a5 = [color,palette]						 			*
*	a8 = ptr to string						 			*
*	a9 = [y,x] screen address					 			*
*	a10 = [y,x] spacing						 			*
*	a11 = ptr to font table						 			*
*									 			*
*	they all return these values intact, however, any changes	 	*
*	incurred from control bytes will remain.			 		*
*	also returned:							 			*
*									 			*
*	a8 = points to the next byte after the string terminator	 	*
*	a9 = next cursor position					 			*
*									 			*
*	note: call all of them with jsrp				 			*
*												*
**************************************************************************
											
**************************************************************************
*												*
* printf - format and print a string.					 			*
* a1 = routine to call for output					 			*
* a8 = ptr to string							 			*
* returns:								 			*
* a1 = intact								 			*
* a8 = pointing to word after the last argument of this string		 	*
*									 			*
* note: call with jsrp							 			*
*												*
**************************************************************************
printf
	callr	stringf
	mmtm	a12,a1,a3	;save routine and next string ptr
	jsrpr	a1
	mmfm	a12,a1,a8	;restore routine and next string (a8)
	retp

**************************************************************************
*												*
* strlnrm - print string with:						 			*
*		 left justify, normal, not put on the object list	 	*
* trashes a4 & a14							 			*
*												*
**************************************************************************
strlnrm
	movi	dmacnz,a4
	clr	a14
	jruc	stringer

**************************************************************************
*												*
* strcnrm - print string with:						 			*
*		 center justify, normal, not put on the object list	*
* trashes a4 & a14							 			*
*												*
**************************************************************************
strcnrm
	movi	dmacnz,a4
	movk	1,a14
	jruc	stringer

**************************************************************************
*												*
* strrnrm - print string with:						 			*
*		 right justify, normal, not put on the object list 	*
* trashes a4 & a14							 			*
*												*
**************************************************************************
strrnrm
	movi	dmacnz,a4
	movk	2,a14
	jruc	stringer

**************************************************************************
*												*
* strlnrmo - print string with:						 			*
*		 left justify, normal, insert on object list		 	*
* trashes a4 & a14							 			*
*												*
**************************************************************************
strlnrmo
	movi	dmacnz,a4
	movi	10000h|sm_noscroll,a14
	jruc	stringer

**************************************************************************
*												*
* strcnrmo - print string with:						 			*
*		 center justify, normal, insert on object list		*
* trashes a4 & a14							 			*
*												*
**************************************************************************
strcnrmo
	movi	dmacnz,a4
	movi	10001h,a14
	jruc	stringer

**************************************************************************
*									    			*
* strlnc - print string with:						 			*
*		 left justify, normal, not put on the object list	 	*
*		 no constant substitute					 		*
* trashes a4 & a14							 			*
*									    			*
**************************************************************************
;strlnc:
;	movi	dmawnz,a4
;	clr	a14
;	jruc	stringer
**************************************************************************
*												*
* strcnc - print string with:						 			*
*		 center justify, normal, not put on the object list	*
*		 no constant substitute					 		*
* trashes a4 & a14							 			*
*												*
**************************************************************************
;strcnc:
;	movi	dmawnz,a4
;	movk	1,a14
;	jruc	stringer

**************************************************************************
*												*
* strrnc - print string with:						 *
*		 right justify, normal, not put on the object list 	 *
*		 no constant substitute					 *
* trashes a4 & a14							 *
*												*
**************************************************************************
;strrnc:
;	movi	dmawnz,a4
;	movk	2,a14
;	jruc	stringer

**************************************************************************
*												*
* strlnco - print string with:						 *
*		 left justify, normal, insert on object list		 *
*		 no constant substitute					 *
* trashes a4 & a14							 *
*												*
**************************************************************************
;strlnco
;	movi	dmawnz,a4
;	movi	10000h,a14
;	jruc	stringer

**************************************************************************
*												*
* strcnco - print string with:						 			*
*		 center justify, normal, insert on object list		*
*		 no constant substitute					 		*
* trashes a4 & a14							 			*
*												*
**************************************************************************
;strcnco:
;	movi	dmawnz,a4
;	movi	10001h,a14
;	jruc	stringer


**************************************************************************
*											     *
* 	shadow routines -- identical to above except you have to tack   *
* 	an "s" on the end of the routine name					     *
*											     *
**************************************************************************
strlnrms
	movi	dmacnz,a4
	movi	8000h,a14
	jruc	stringer
*
* object list / shadow / left justify / with scrolling
*
strlnrmos_scr
	movi	dmacnz,a4
	movi	18000h|sm_noscroll,a14
	jruc	stringer
*
* object list / shadow / right justify / with scrolling
*
strrnrmos_scr
	movi	dmacnz,a4
	movi	18002h|sm_noscroll,a14
	jruc	stringer
*
* object list / shadow / center justify / with scrolling bit set
*
strcnrmos_scr
	movi	dmacnz,a4
	movi	18001h|sm_noscroll,a14
	jruc	stringer

strcnrmo_scr
	movi	dmacnz,a4
;	movi	8001h|sm_noscroll,a14
	movi	10001h|sm_noscroll,a14
	jruc	stringer

strcnrmos
	movi	dmacnz,a4
	movi	18001h,a14
	jruc	stringer

strcnrms
	movi	dmacnz,a4
	movi	8001h,a14
	jruc	stringer

strrnrms
	movi	dmacnz,a4
	movi	8002h,a14
	jruc	stringer


sb_noscroll	.set	17
sm_noscroll	.set	>20000

**************************************************************************
*												*
* stringer - output a text string, this is a process!			 	*
* a14 = flags - insert:justify						 			*
*												*
*        bit 17 = set the "no_scroll" bit in oflags2					*
*	bit 16 = 1 insert on object list, 0 just queue the dma		*
*	bit 15 = 1 shadow the characters that get kicked out, too	 	*
*												*
*	justify = 0 left justify					 			*
*		  1 center justify					 			*
*		  2 right justify					 			*
*												*
* note: call with jsrp							 			*
**************************************************************************
stringer
	clr	b0
	move	b0,@string_underline,w	; clear out underlining
	btst	15,a14
	jrz	stringer_noshad
	movk	1,b0
stringer_noshad
	move	b0,@string_shadow,w
	callr	spacing		;calculate the spacing for this font

	move	a9,a3		;keep initial position for newlines

	callr	justify		;justify the position correctly

****	.if yunit
****	clr	a7
****	movx	a5,a7
****	cmpi	0f0fh,a7	;are we already adjusted?
****	jrhi	stringr2	;br = yes!
****	sll	4,a7		;do the yunit shuffle
****	movx	a7,a5
****	.endif

stringr2
	movb	*a8,a7		;get a character
	sll	24,a7
	srl	24,a7		;make sure we're positive
	jreq	stringrx	;br = string be gone brotha
	addk	8,a8		;next byte
	clr	b0		; not a space, yet

	cmpi	' ',a7
	jrhi	strnchar	;br = it's kosh baby 
	jrlo	strncont	; control characters

	clr	a7
	move	a9,b2		; save it away
	movx	a6,a7		;add x space
	addxy	a7,a9		;and add it in
	addxy	a10,a9		;add spacing

	move	@string_underline,b1	; check for underline
	jrz	stringr2	; nope -- don't do anything
	move	b2,b0	
	move	a9,b2
	move	b0,a9		; swap the locations
	movk	1,b0
	movi	'a',a7		; set to an 'a' for appearances
	jruc	strnchar	; process it
*
* check here for control characters
*
strncont:
	cmpi	new_sleep,a7
	jrne	strcc1
	move	*a8+,a0,w	;new sleep time
	jruc	stringr2
strcc1:
	cmpi	new_pcolor,a7
	jrne	strcc2
	move	*a8+,a1,w	;new print color
	sll	16,a1
	movy	a1,a5		;the correct position please
	jruc	stringr2
strcc2:
	cmpi	new_control,a7
	jrne	strcc3
	move	*a8+,a4,w	;new dma flags
	jruc	stringr2	
strcc3:
	cmpi	new_font,a7
	jrne	strcc4
	move	*a8+,a11,l	;new font
	callr	spacing		;re-calculate spacing for this font
	jruc	stringr2
strcc4:
	cmpi	new_xy,a7
	jrne	strcc5
	move	*a8+,a9,l	;new position
	jruc	stringr2
strcc5:
	cmpi	new_spacing,a7
	jrne	strcc6
	move	*a8+,a10,l	;new spacing
	jruc	stringr2
strcc6:
	cmpi	ascii_cr,a7
	jrne	strcc7
	move	a3,a9		;get back to where you once belonged
	clr	a7
	movy	a6,a7
	addxy	a7,a9		;next line down
	move	a9,a3		;store this position
	callr	justify		;and rejustify your position
	jruc	stringr2
strcc7:
	cmpi	add_dydx,a7
	jrne	strcc8
	move	*a8+,a1,l	;get deltas
	addxy	a1,a9		;and add them
	jruc	stringr2
strcc8:
	cmpi	new_palette,a7
	jrne	strcc9
	move	a0,a1
	move	*a8+,a0,l	;get palette i.d.

;	calla	findpal		;find it's spot
	calla	getfpal		; (ejb) - make jive with super high impact

	movx	a0,a5
	move	a1,a0
	jruc	stringr2
strcc9:
	cmpi	underline_on,a7		; underlining turned on?
	jrne	strcc10
	movk	1,b0
	move	b0,@string_underline,w
	jruc	stringr2	

strcc10:
	cmpi	underline_off,a7
	jrne	strcc11
	clr	b0
	move	b0,@string_underline,w
	jruc	stringr2

strcc11:
*add new control characters here
	jruc	stringr2
*
* output a character
*
strnchar:
	mmtm	sp,a0,a2,a3,a4,a6,a10,a14

	move	a11,a1		;escape to the other side

	subi	21h,a7		;get a base
	sll	5,a7
	add	a7,a1
	move	*a1,a1,l		; load the address of the image header
	calla	gsagof
	calla	ganiof
	
	btst	16,a14
	jreq	strnqdma		; br = do normal dma of string
*
* create the character as an object, here
*
	calla	getobj
	jreq	strngdun		; br = no object

	btst	sb_noscroll,a14		; set no scroll bit ?
	jreq	stg1
	movi	m_noscroll,a14
	move	a14,*a0(oflags2),w
stg1

	move	a1,*a0(oimg),l
	push	a0
	movi	boonpal,a0
	calla	getfpal
	move	a0,a14
	pull	a0
	move	a14,*a0(opal),w		; normal letters use "boonpal"
	move	a5,a14
	srl	16,a14
	move	a14,*a0(oconst),w	; stuff constant color

	move	*a1(icontrol),a14,w
	ori	dmacnz,a14
	or	a14,a4			; rememeber control word info

	move	a2,*a0(osize),l		; y:x size
	move	a3,*a0(osag),l		; sag
	move	a4,*a0(oflags),w	; oflags

	clr	a14
	move	a14,*a0(oxvel),l
	move	a14,*a0(oyvel),l
	move	a14,*a0(oxval),l
	move	a14,*a0(oyval),l
	move	a14,*a0(ozval),l	; clear out positions / velocities

	movi	oid_text,a14
	move	a14,*a0(oid),w		;stuff a findable i.d.

	move	a9,a14
	move	a9,*a0(oxpos),w		; set x (no anioff)

	srl	16,a6
	movy	a7,a6

	subxy	a6,a14			;adjust for animation point

;	move	a14,*a0(oxpos),w

	srl	16,a14
	move	a14,*a0(oypos),w	;stuff positions
	movk	1,a14
	move	a14,*a0(ozval),l	; normal letters in front of shadows


;	move	*a0(oflags),a4,w
;	btst	b_noscroll,a4		;is this guy a scrolling string?
;	jrne	strn_nowc		;br = no, skip world coords.
;	callr	adjstwtl		;put us in the world
;strn_nowc:

	move	b0,b0
	jrnz	dont_insert
	calla	insobj2			;stuff this sheeeeeeet
dont_insert
*
* check for underlining
*
	move	@string_underline,a14,w
	jrz	str_no_underline_object
	cmpi	rd7font,a11		; only underlines 7 point
	jrnz	str_no_underline_object
	push	a0			; save object for shadowing
	push	a8			; save text pointer
	move	a0,a14
	calla	getobj
	jrz	str_obj_underline_done
	move	a14,a8			; object to copy
	callr	copy_obj		; dupe the old object
	move	a0,a8
	movi	font8underline,a1
	movi	dmacal,a4		; constant
	calla	ani			; presto
	move	*a8(oxpos),a14,w
	subk	1,a14
	move	a14,*a8(oxpos),w
	move	b0,b0			; check to see if it is a space
	jrnz	str_obj_underline_done
	calla	insobj2			; get it up
str_obj_underline_done
	pull	a8			; restore text pointer
	pull	a0			; grab object back for shadowing
str_no_underline_object
*
* check for shadowing
*
	move	@string_shadow,a14,w
	jrz	str_no_shadow_object
	move	a0,a14			; original object
	calla	getobj
	jreq	strngdun		; br = couldn't get an object
	push	a8			; gotta preserve a8, dudes!
	move	a14,a8
	callr	copy_obj		; dupe the old object

	movk	2,a8			; assume [1,1] offset
	cmpi	rd15font,a11		; 15 pt font gets [2,2] offset
	jreq	strn_spac2
	movk	1,a8

;	movk	2,a8			; assume [2,2] offset
;	cmpi	rd7font,a11		; 7 pt font gets [1,1] offset
;	jrnz	strn_spac2
;	movk	1,a8


strn_spac2
	move	*a0(oxpos),a14,w
	add	a8,a14
	move	a14,*a0(oxpos),w
	move	*a0(oypos),a14,w	; stuff positions
	add	a8,a14
	move	a14,*a0(oypos),w	; stuff positions

;	movi	text_zpos-1,a14		; just under the real thing
;	move	a14,*a0(ozval),l	; put it under regular stuff
	clr	a14
	move	a14,*a0(ozval),l	; normal letters in front of shadows

****************************
	movi	bpal_black,a14
	move	a14,*a0(oconst),w	; shadows are black
	push	a0
	movi	boonpal,a0
	calla	getfpal
	move	a0,a14
	pull	a0
	move	a14,*a0(opal),w		; shadows use "boonpal"
;	move	a14,*a0(opal),l
****************************

;	btst	b_noscroll,a4		; is this guy a scrolling string?
;	jrne	shad_strn_nowc		; br = no, skip world coords.
;	callr	adjstwtl		; put us in the world
;shad_strn_nowc:

	calla	insobj2
	pull	a8

str_no_shadow_object:
	jruc	strngdun

*simply dma the sucker, here
strnqdma
	move	a1,a10
	move	a5,a1		;constant:palette
	move	a4,a5		;offset:control
	move	a3,a4		;sag

	move	a9,a3
	srl	16,a6
	movy	a7,a6

;********************
;	subxy	a6,a3		;animation pnt adjusted dag
	subxy	a6,a3 		;adjust for animation point
;	zext	a6,w
;	subxy	a6,a9 		;adjust for animation point
;********************

	move	@string_shadow,a14,w
	jrz	no_dma_shadow
	mmtm	sp,a1,a3

	movi	bpal_black*>10000,a1

	addi	[1,1],a3		; [1,1] for the 7-11 pt font
	cmpi	rd7font,a11
	jrz	strnqd_spac1
	cmpi	rd11font,a11
	jrz	strnqd_spac1

	addi	[1,1],a3		; another for the bigger fonts

strnqd_spac1
	calla	qdman
	mmfm	sp,a1,a3
no_dma_shadow
	move	b0,b0			; check for space
	jrnz	dma_space
	calla	qdman
dma_space
*
* check for underlining
*
	move	@string_underline,a14,w
	jrz	no_dma_underline
	push	a1
	movi	font8underline,a1
	movi	dmacal,a4
	calla	gsagof
	calla	ganiof
	pull	a1
	move	a4,a5		;offset:control
	move	a3,a4		;sag
	move	a9,a3
	srl	16,a6
	movy	a7,a6
	subxy	a6,a3		; animation pnt adjusted dag
	subk	1,a3		; shift over 1 more
	calla	qdman
no_dma_underline
	move	a1,a5
	move	a10,a1
strngdun
	move	b0,b0		; check to see if char is a space
	jrz	strng_dun_no_space
	move	b2,a9		; setup the new spacing
	mmfm	sp,a2,a3,a4,a6,a10,a14
	jruc	strng_bypass_1

strng_dun_no_space

;******************
;	zext	a6,w			; leave y coordinate alone
;	subxy	a6,a9			; ani adjust for next character
;******************

	cmpi	vfont1,a1
	jrne	nsp2

    	movi	vfont2,a6
	move	*a6(isize),a6,w
	jruc	spjump

nsp2
	move	*a1(isize),a6,w		; get the visible horizontal size
spjump	addxy	a6,a9			; get to the other side of the character
	mmfm	sp,a2,a3,a4,a6,a10,a14
	addxy	a10,a9			; add in spacing

strng_bypass_1
	move	*sp+,a0,l
	jreq	stringr2	;br = no sleep
	mmtm	a12,a0,a3,a4,a5,a6,a14
	calla	prcslp
	mmfm	a12,a0,a3,a4,a5,a6,a14
	jruc	stringr2
stringrx
	addk	8,a8		;get to the next byte
	move	a5,a6
	srl	16,a6		;return the color correctly
	retp

**************************************************************************
*												*
*	end of print routines.						 			*
*												*
**************************************************************************

**************************************************************************
*												*
*	print format and utility routines				 			*
*												*
**************************************************************************
*
*null string for dummies
*
dumstrng .word	0
*
*equates for stringf
b_ljustify	equ	0		;left justify within field
b_cjustify	equ	1		;center justify within field
b_psign		equ	2		;print sign if signed
b_commas		equ	3		;print commas
b_phex		equ	4		;print hex prefix
b_zprint		equ	5		;fill unused width with zeros
b_signed		equ	6		;this value is of signed type
b_cap		equ	7		;use capital letters for hex digits
*
*size equates
type_short	equ	8
type_int	equ	16
type_long	equ	32
**************************************************************************
*												*
* stringf - string format routine.					 *
*	  see "ascii character string definition" at the top of file.	 *
* a8 = ptr to string to format.						 *
* returns:								 *
* a3 = ptr to .even word after the last argument of the string		 *
* a8 = ptr to formatted string						 *
* note: trashes a14							 *
*												*
**************************************************************************
stringf:
	clrm	@sfindex,w	;clear the string build memory index
stringf_recurse:		;recursion entry point
	mmtm	sp,a0,a1,a2,a4,a5,a6,a7
	move	@sfindex,a7,w	;get the index of the next buffer to use
	cmpi	numsfbufs,a7
	jrlo	sfalloc		;more buffers to be had
	movi	dumstrng,a8	;point to a null string when out of mammary
	jruc	stringfx
*allocate a buffer in which to build the string
sfalloc
	incm	@sfindex,w	;increment the index for next mam grab
	movi	sfbufsize,a0
	mpyu	a0,a7		;offset to new array	
	addi	stringf_ram,a7	;add offset, a7 points to our build space
	move	a7,a5		;store ptr to bos here
	move	a8,a6
sfarglp:
	movb	*a6,a0		;find the argument list
	addk	8,a6		;and pnt a6 at it
	move	a0,a0
	jrnz	sfarglp		;searching for null terminator
	addk	0fh,a6		;do our own .even to match assembler
	srl	4,a6
	sll	4,a6		;mask fractional word
sfbuildlp:
	callr	getchar
	jrnc	sfbuildch	;we recieved a normal character
	movb	a0,*a7		;pass the control
	addk	8,a7
sfbuildarg:
	move	a1,a1
	jrz	sfbuildlp	;finished
	movb	*a8,*a7
	addk	8,a8
	addk	8,a7		;transfer args
	dec	a1		;dec arg count
	jruc	sfbuildarg
sfbuildch:
	btst	7,a0		; check the high bit
	jrz	sfvalidch
	move	a8,a1		; save it away
	calla	dict_lookup	; lookup the word in a0
	jrnz	sfa8toa7	; if there is something, use it	
	move	a1,a8		; if bad return
sfvalidch
	cmpi	'%',a0
	jrne	sfcontrol	;not a format character, how about control
*parse stringf format specifier here
	callr	getchari	;no special characters allowed in format
	cmpi	'%',a0
	jreq	sfxfer		;just print a percent sign

	callr	fflags		;get the format flags if there are any
	callr	fwidth		;get format width next
	callr	ftype		;get the format type
sftype_lp:
	cmpi	's',a0		;see if it's a string
	jrne	sftype0
	move	a8,a1		;store a8
	move	*a6+,a8,l	;get the address of the string(always long)
	callr	stringf_recurse
	jruc	sfa8toa7	;transfer the new #	
sftype0:
	cmpi	'p',a0		;see if it's a pointer to a string
	jrne	sftype1
	move	a8,a1		;store a8
	move	*a6+,a8,l	;get the ptr to the string(it's always long)
	move	*a8,a8,l	;now get the address
	callr	stringf_recurse
	jruc	sfa8toa7	;transfer the new #	
sftype1:
	move	a8,a1		;save a8
	callr	getargi
	cmpi	'b',a0
	jrne	sftype5		;bcd
	callr	bcd_to_ascii_dec	;convert
	jruc	sfa8toa7
sftype5:
	cmpi	'd',a0		;signed decimal
	jrne	sftype6
	bset	b_signed,a4
	cmpi	type_int,a2	;sign extend little brother
	jrne	sftype5a
	sext	a8
	jruc	sftype5b
sftype5a:
	cmpi	type_short,a2	;and the youngest
	jrne	sftype5b
	sll	24,a8	
	sra	24,a8
sftype5b:
	callr	hex_to_ascii_dec	;convert
	jruc	sfa8toa7
sftype6:
	cmpi	'u',a0		;unsigned decimal
	jrne	sftype7
	callr	hex_to_ascii_dec
	jruc	sfa8toa7
sftype7:
	cmpi	'x',a0		;unsigned hexadecimal with 'abcdef'
	jrne	sftype8
	callr	hex_to_ascii_hex
	jruc	sfa8toa7
sftype8:
	CMPI	'X',A0		;UNSIGNED HEXADECIMAL WITH 'ABCDEF'
	jrne	sftype9
	bset	b_cap,a4
	callr	hex_to_ascii_hex
	jruc	sfa8toa7
sftype9:
	cmpi	'c',a0		;single character
	jrne	sftype10
	movb	a8,*a7
	addk	8,a7
	move	a1,a8
	jruc	sfbuildlp
sftype10:
*add new type specifiers here
	jruc	sfbuildlp
*transfer new format string to the string we are building
sfa8toa7:
	movb	*a8,a0
	jrz	sfa8a7done
	addk	8,a8	
	movb	a0,*a7	
	addk	8,a7
	jruc	sfa8toa7
sfa8a7done:
	move	a1,a8
	jruc	sfbuildlp
*
*check for a control character
sfcontrol:
	cmpi	'\',a0
	jrne	sfxfer		;just another character
	callr	getchari	;now get the control character
	cmpi	'\',a0
	jreq	sfxfer		;oh! he wants to print this
	clr	a3		;assume no indirection
	cmpi	'*',a0		;is there indirection here?
	jrne	sfcontrol_imm	;br = no
	movk	1,a3		;control indirect flag
	callr	getchari	;this time get the control character for real!

sfcontrol_imm:
	cmpi	'a',a0
	jrne	sfc1
	movi	new_sleep,a0	;new sleep time
	movi	type_int,a2
	callr	putcarg		;get the control arg
	jruc	sfbuildlp
sfc1:
	cmpi	'b',a0
	jrne	sfc2
	movi	new_pcolor,a0	;new print color
	movi	type_int,a2
	callr	putcarg		;get the control arg
	jruc	sfbuildlp
sfc2:
	cmpi	'c',a0
	jrne	sfc3
	movi	new_control,a0	;new dma control word
	movi	type_int,a2
	callr	putcarg		;get the control arg
	jruc	sfbuildlp
sfc3:
	cmpi	'd',a0
	jrne	sfc4
	movi	new_font,a0	;new font
	movi	type_long,a2
	callr	putcarg		;get the control arg
	jruc	sfbuildlp
sfc4:
	cmpi	'e',a0
	jrne	sfc5
	movi	new_xy,a0	;new [y,x] cursor position
	movi	type_long,a2
	callr	putcarg		;get the control arg
	jruc	sfbuildlp
sfc5:
	cmpi	'i',a0
	jrne	sfc6
	movi	new_spacing,a0	;new spacing
	movi	type_long,a2
	callr	putcarg		;get the control arg
	jruc	sfbuildlp
sfc6:
	cmpi	'n',a0
	jrne	sfc7
	movi	ascii_cr,a0	;newline
	jruc	sfxfer
sfc7:
	cmpi	'f',a0
	jrne	sfc8
	movi	add_dydx,a0	;add [dy,dx]
	movi	type_long,a2
	callr	putcarg		;get the control arg
	jruc	sfbuildlp
sfc8:
	cmpi	'p',a0
	jrne	sfc9
	movi	new_palette,a0	;use a new palette
	movi	type_long,a2
	callr	putcarg		;get the control arg
	jruc	sfbuildlp
sfc9:
	cmpi	'u',a0		; underlining activated?
	jrne	sfc10
	movi	underline_on,a0
	jruc	sfxfer
sfc10:
	cmpi	'v',a0		; underlining de-activated?
	jrne	sfc11
	movi	underline_off,a0
	jruc	sfxfer
sfc11:
*add new control characters here
	jruc	sfbuildlp
sfxfer:
	movb	a0,*a7
	addk	8,a7
	move	a0,a0
	jrnz	sfbuildlp	;add on another character
*string is done
	move	a5,a8		;pass back the ptr to the new
	decm	@sfindex,w	;free this buffer
stringfx
	move	a6,a3		;return end
	mmfm	sp,a0,a1,a2,a4,a5,a6,a7
	rets

**************************************************************************
*												*
* justify - justify the string starting point from the given position	 *
*	  based on the justification byte				 *
* a8 = ptr to string							 *
* a9 = string position							 *
* a14 = justification byte						 *
*		0 = left						 *
*		1 = center						 *
*		2 = right						 *
* returns:								 *
* a9 = justified starting position					 *
*												*
**************************************************************************
justify:
	push	a7
	clr	a7
	movx	a14,a7
	sll	30,a7
	srl	30,a7		; mask off the shadow bit
	dec	a7
	jrn	justifyx	;normal left justify
	jreq	justifyc	;center justify
*right justify
	callr	strnglen	;get the string length
	jruc	justifya
*center justify
justifyc:
	callr	strnglen
	srl	1,a7		;strnglen/2
justifya:
	subxy	a7,a9		;adjust string starting position
justifyx:
	pull	a7
	rets

**************************************************************************
*												*
* spacing - calculate spacing for this font				 *
* a11 = ptr to current font table					 *
* returns:								 *
* a6 = [y,x] spacing							 *
*												*
**************************************************************************
spacing:
	push	a7
	MOVI	'H' - 21H,A6	;USE 'H' FOR SPACE AND NEWLINE STUFF
	sll	5,a6
	add	a11,a6
	move	*a6,a6,l	;load the address of the image header
	move	*a6(isize),a6,l	;get the visible size of 'h'
	movy	a6,a7
	zext	a6
	srl	1,a6		;(x size of 'h')/2 = x spacing
	movy	a7,a6
	srl	17,a7
	sll	16,a7
	addxy	a7,a6		;(y size of 'h') + (y size of 'h')/2 = y space
	pull	a7
	rets

**************************************************************************
*												*
* fflags - parse the format flags (if there are any).			 *
*	 sets the appropriate bits in the flag register.		 *
* a0 = current character from string					 *
* a8 = ptr to string after *a0						 *
* returns:								 *
* a0 = next character after flags or same if no flags present		 *
* a4 = flag register with appropriate bits set or cleared		 *
* a8 = ptr to next character						 *
* note: trashes a14							 *
*												*
**************************************************************************
fflags:
	clr	a4		;clear flag register to start
fflag_lp:
	cmpi	'-',a0		;check for left justify flag
	jrne	fflagp1
	bset	b_ljustify,a4
	bclr	b_cjustify,a4
	jruc	fflag_nxt
fflagp1:
	cmpi	'^',a0		;check for center justify flag
	jrne	fflagp2
	bset	b_cjustify,a4
	bclr	b_ljustify,a4
	jruc	fflag_nxt
fflagp2:
	cmpi	'+',a0		;check for print sign flag
	jrne	fflagp3
	bset	b_psign,a4
	jruc	fflag_nxt
fflagp3:
	cmpi	',',a0		;check for comma flag
	jrne	fflagp4
	bset	b_commas,a4
	jruc	fflag_nxt
fflagp4:
	cmpi	'#',a0		;check for hex prefix flag
	jrne	fflagp5
	bset	b_phex,a4
	jruc	fflag_nxt
fflagp5:
*add new flags here
	jruc	fflagx
fflag_nxt:
	callr	getchari
	jruc	fflag_lp
fflagx
	rets

**************************************************************************
*												*
* fwidth - grab the format width from the current string (if present).	 *
*	 sets zprint flag is flag register if necessary			 *
* a0 = current character from string					 *
* a4 = flag register							 *
* a8 = ptr to string after *a0						 *
* returns:								 *
* a0 = next character after width or same if no width present		 *
* a3 = width , 0 = no width specified					 *
* a4 = flag register with zprint flag set if necessary			 *
* a8 = ptr to next character							 *
*												*
**************************************************************************
fwidth:
	push	a1
	movk	10,a1		;decimal multiplier
	clr	a3		;field width will be here
	cmpi	'0',a0		;check for leading zero print flag
	jrne	fwidth_lp
	bset	b_zprint,a4
	callr	getchari	;get the next
fwidth_lp:
	cmpi	'0',a0
	jrlt	fwidthx		;not a number
	cmpi	'9',a0
	jrgt	fwidthx		;not a number
	subi	'0',a0		;ascii to decimal
	mpyu	a1,a3		;up it by 10
	add	a0,a3		;and add in the new
	callr	getchari
	jruc	fwidth_lp
fwidthx
	pull	a1
	rets

**************************************************************************
*												*
* ftype - return the format type, i.e. short, int or long.		 *
* a0 = ptr to current character to check				 *
* a8 = ptr to string that is being formatted				 *
* returns:								 *
* a0 = next character to process after type or same if no type specified *
* a8 = ptr to next character						 *
* default return is int							 *
*												*
**************************************************************************
ftype:
	movk	type_int,a2
ftype_lp:
	cmpi	'h',a0			;check for type short
	jrne	ftypep1
	movk	type_short,a2
	jruc	ftype_nxt
ftypep1:
	cmpi	'l',a0			;check for type long
	jrne	ftypep2
	movk	type_long,a2
	jruc	ftype_nxt
ftypep2:
	CMPI	'L',A0			;CHECK FOR TYPE LONG
	jrne	ftypep3
	movk	type_long,a2
	jruc	ftype_nxt
ftypep3:
*add new type here
	jruc	ftypex
ftype_nxt:
	callr	getchari
	jruc	ftype_lp
ftypex
	rets

**************************************************************************
*												*
* getchar - get next character from a string.				 *
*	  masks the high 24 bits of the long word.			 *
* a8 = ptr string							 *
* returns:								 *
*	c = control byte, args follow, a1 = # of byte arguments		 *
*      nc = normal character or terminator.				 *	
*	z = byte is a terminator					 *
* a0 = character							 *
* a8 = ptr to next							 *
*												*
**************************************************************************
getchar:
	movb	*a8,a0
	sll	24,a0
	srl	24,a0		;make sure this number is positive
	addk	8,a8		;point to next character
	cmpi	0,a0
	jreq	getcharx	;terminator
	cmpi	' ',a0
	jrnc	getcharx	;same as jrhs
	move	a0,a1	
	dec	a1
	sll	3,a1
	addi	control_tab,a1
	movb	*a1,a1		;get number of bytes
	setc	
getcharx:
	move	a0,a0
	rets

*
*number of argument bytes for control character (1-1f)
control_tab
	.byte	2,2,2,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.even

**************************************************************************
*												*
* getchari - get next character, skip command bytes and arguments.	 *
*	   used with strgnlen, fflags, fwidth, ftype, etc.		 *
* a8 = ptr to string							 *
* returns:								 *
*  z = character is a terminator					 *
* a0 = character or terminator						 *
* a8 = ptr to next							 *
*												*
**************************************************************************
getchari:
	push	a1
getchari_lp:
	callr	getchar	
	jrnc	getcharix		;valid character or terminator
	sll	3,a1
	add	a1,a8			;skip args
	jruc	getchari_lp
getcharix:
	pull	a1	
	rets

**************************************************************************
*												*
* getargi - get next argument indirect in the argument list.		 *
*	    next arg is a long ptr to argument type.			 *
* a2 = argument type, i.e. short, int or long				 *
* a6 = ptr to argument							 *
* returns:								 *
* a6 = ptr to next argument						 *
* a8 = unsigned argument						 *
*												*
**************************************************************************
getargi:
	move	*a6+,a8,l	;get the pointer
	cmpi	type_int,a2	;get the value for printing now		
	jrne	getarg1	
	move	*a8,a8,w	;ah and int
	zext	a8
	jruc	getargx
getarg1:
	cmpi	type_long,a2
	jrne	getarg2
	move	*a8,a8,l	;it's very long
	jruc	getargx
getarg2:
	movb	*a8,a8		;are you small? small! hah! like french bread!
	sll	24,a8
	srl	24,a8		;zextb a8
getargx:
	rets

**************************************************************************
*									    *
* putcarg - get the control argument from the arg list and transfer	 *
*	current string under construction. first it will transfer	 *
*	the control byte.						 *
* a0 = control byte							 *
* a2 = arg type								 *
* a3 = indirection flag, if <> 0 then indirect argument			 *
* a7 = ptr to list under construction					 *
* returns:								 *
* a7 next byte in string						 *
* a0 & a2 preserved							 *
* a3 is trashed if argument is indirect					 *
*									    *
**************************************************************************
putcarg:
	movb	a0,*a7
	addk	8,a7
	move	a3,a3		;should we handle indirection
	jrne	putcargi	;br = yes
*get argument immeadiately
	cmpi	type_int,a2
	jrne	putclarg
	move	*a6+,*a7+,w
	jruc	putcargx
putclarg:
	move	*a6+,*a7+,l	;argument is long
putcargx:	
	rets
*get argument via indirection
putcargi:
	move	*a6+,a3,l	;get pointer
	cmpi	type_int,a2
	jrne	putclargi
	move	*a3+,*a7+,w
	jruc	putcargx
putclargi:
	move	*a3+,*a7+,l
	jruc	putcargx

**************************************************************************
*												*
* strnglen - returns the length, in pixels, of a given string		 *
* a8 = ptr to string							 *
* a10 = [y,x] spacing of string						 *
* a11 = ptr to font table						 *
* returns:								 *
* a7 = length of string							 *
* z bit set if length is zero						 *
*												*
**************************************************************************
strnglen
	mmtm	sp,a0,a1,a2,a6,a8,a10
	clr	a2
	MOVI	'H' - 21H,A6	;USE 'H' FOR SPACE
	sll	5,a6
	add	a11,a6
	move	*a6,a6,l	;load the address of the image header
	move	*a6(isize),a6,w	;get the visible size of 'h'
	srl	1,a6		;(x size of h)/2 = x spacing

strnlen:
	callr	getchar
	jrz	strnlenx	;end o' string. for real!
	jrnc	strnlen0	;real character

	cmpi	ascii_cr,a0
	jreq	strnlenx	;o.k. that's it!
	cmpi	new_spacing,a0
	jrne	strnlen_skip
	move	*a8+,a10,l	;get the new spacing, 'cause we care
	jruc	strnlen
strnlen_skip:
	sll	3,a1
	add	a1,a8		;skip args
	jruc	strnlen
strnlen0:
	cmpi	' ',a0		;look for a space, man
	jrne	strnlen1
	addxy	a6,a2		;add a space
	jruc	strnlen3
strnlen1:
	subi	21h,a0		;get a base
	sll	5,a0
	add	a11,a0		;a7 = ptr to correct character header
	move	*a0,a0,l

;*****************
	cmpi	vfont1,a0
	jrne	no_special
	movi	vfont2,a0
no_special
	move	*a0(isize),a0,w	;get the actual x length
;*****************

strnlen2
	addxy	a0,a2		;add digit length
	movx	a10,a0
	addxy	a0,a2		;add space length
strnlen3:
	jruc	strnlen
strnlenx
	move	a2,a7		;pass return value in a7
	mmfm	sp,a0,a1,a2,a6,a8,a10
	rets

**************************************************************************
*												*
* hextoasc - converts a 32 bit hex # to an ascii string terminated	 *
*	   by 0 with commas.						 *
* a8 = hex #								 *
* returns:								 *
* a8 ptr to the string							 *
*												*
**************************************************************************
hextoasc
	mmtm	sp,a3,a4,a14
	clr	a3
	clr	a4
	bset	b_commas,a4
	callr	hex_to_ascii_dec
	mmfm	sp,a3,a4,a14
	rets

**************************************************************************
*											     *
* hex_to_ascii_dec - format a hexadecimal # to an decimal ascii string.  *
* 		     uses the flags and width in a4 and a3.		     *
* a3 = width, minimum # of characters to output					     *
* a4 = flags, uses: b_commas - put commas in the number			     *
* 		    b_zprint - if width is not reached, fill with 0's   *
* 			       not spaces.					     *
* 		    b_signed - passed number is signed			     *
* 		    b_psign  - print sign if number is of signed type   *
* a8 = hexadecimal #									     *
* returns:										     *
* a8 = ptr to string									     *
* a3 & a4 preserved									     *
*											     *
**************************************************************************
hex_to_ascii_dec
	mmtm	sp,a1,a2,a3,a5,a9
	clr	a5			;clr negative flag
	btst	b_signed,a4
	jreq	hextnos			;not a signed number
	move	a8,a8
	jrnn	hextnos			;not a negative number
	neg	a8
	inc	a5
hextnos:
	clr	a1
	clr	a2			;comma count
	move	a1,-*sp,w		;here's the null terminator
        movk	10,a1			;divisor for decimal
	move	a8,a9
hextasc2
	clr	a8
	divu	a1,a8
	addi	'0',a9			;make the remainder ascii
	move	a9,-*sp,w		;save here
	dec	a3			;decrement the width
	move	a8,a9
	jrz	hextasc3		;br = done!

	btst	b_commas,a4
	jreq	hextasc2		;br = don't worry about commas

	inc	a2
	cmpi	3,a2			;comma check	
	jrlo	hextasc2		;br = no comma
	movi	',',a2
	move	a2,-*sp,w		;stuff a comma
	clr	a2
	jruc	hextasc2
hextasc3
	move	a3,a3
	jrz	hextasc3a		;width has been fulfilled
	jrn	hextasc3a		;thanx ti
	btst	b_zprint,a4
	jrne	hextasc30		;yes, fill width with zeros
	movi	' ',a2
	jruc	hextasc31
hextasc30:
	movi	'0',a2
hextasc31:
	move	a2,-*sp,w		;stuff the leader
	dsjs	a3,hextasc31
hextasc3a:
	btst	b_signed,a4
	jreq	hextasc3d		;this is not a signed number
	move	a5,a5
	jrnz	hextasc3b		;number is negative
	btst	b_psign,a4
	jreq	hextasc3d		;doesn't want the sign printed
	movi	'+',a2	
	jruc	hextasc3c
hextasc3b:
	movi	'-',a2
hextasc3c:
	move	a2,-*sp,w		;stuff the sign
hextasc3d
	movi	strngram,a1		;store here for blow out 	
	move	a1,a8
hextasc4
	move	*sp+,a9,w
	movb	a9,*a1
	addk	8,a1
	move	a9,a9
	jrnz	hextasc4
	mmfm	sp,a1,a2,a3,a5,a9
	rets

**************************************************************************
*												*
* htohxasc - convert a 32 bit hexadecimal # to a null terminated	 *
*	   hexadecimal ascii string. uses 'abcdef' and no ox prefix	 *
*	   or commas.							 *
* a8 = hex #								 *
* returns:								 *
* a8 = ptr to ascii hex string						 *
*												*
**************************************************************************
htohxasc
	mmtm	sp,a3,a4,a14
	clr	a3
	clr	a4
	bset	b_cap,a4	
	callr	hex_to_ascii_hex
	mmfm	sp,a3,a4,a14
	rets
	
**************************************************************************
*											     *
* hex_to_ascii_hex - converts a 32 bit hex # to a null terminated	     *
* 		   ascii string.							     *
* a3 = width, minimum # of characters converted					     *
* a4 = flags, uses: b_commas - put commas in the number			     *
* 		  b_zprint - if width is not reached, fill with 0's     *
* 			     not spaces.						     *
* 		  b_cap	   - use 'abcdef'						     *
* 		  b_phex   - prefix with hex specifier 0x or 0x	     *
* a8 = hex #										     *
* returns:										     *
* a8 ptr to the string									     *
* a3 & a4 are preserved									     *
*											     *
**************************************************************************
hex_to_ascii_hex
	mmtm	sp,a1,a2,a3,a9
	clr	a1
	clr	a2			;comma count
	move	a1,-*sp,w		;here's the null terminator
	movk	16,a1			;divisor for hex
	move	a8,a9
hextasch2
	clr	a8
	divu	a1,a8
	addi	'0',a9			;make the remainder ascii
	cmpi	'9',a9			;is it in a-f range?
	jrls	hhh1
	btst	b_cap,a4		;are we in capital mode
	jrne	hhh0			;yes
	addi	'a' - ':',a9		;make alpha!
	jruc	hhh1
hhh0:
	ADDI	'A' - ':',A9		;MAKE ALPHA!
hhh1:
	dec	a3			;decrement the width
	move	a9,-*sp,w		;save here
	move	a8,a9
	jrz	hextasch3		;br = done!
	inc	a2
	cmpi	3,a2			;comma check	
	jrlo	hextasch2		;br = no comma
*
*	see if we're doing commas
*
	btst	b_commas,a4		;commas?
	jreq	hextasch2		;nope....ignore!

	movi	',',a2
	move	a2,-*sp,w		;stuff a comma
	clr	a2
	jruc	hextasch2
hextasch3:
	move	a3,a3
	jrz	hextasch3a		;width has been fulfilled
	jrn	hextasch3a		;thanx ti
	btst	b_zprint,a4
	jrne	hextasch30		;yes, fill width with zeros
	movi	' ',a2
	jruc	hextasch31
hextasch30:
	movi	'0',a2
hextasch31:
	move	a2,-*sp,w		;stuff the leader
	dsjs	a3,hextasch31
hextasch3a:
*check for 0x prefix
	btst	b_phex,a4
	jreq	hextasch3d		;no prefix necessary
	btst	b_cap,a4
	jrne	hextasch3b		;print a capital x
	movi	'x',a2
	jruc	hextasch3c
hextasch3b:
	MOVI	'X',A2
hextasch3c:
	move	a2,-*sp,w
	movi	'0',a2
	move	a2,-*sp,w
hextasch3d:
*dump the string and pass it back
	movi	strngram,a1		;store here for blow out 	
	move	a1,a8
hextasch4:
	move	*sp+,a9,w
	movb	a9,*a1
	addk	8,a1
	move	a9,a9
	jrnz	hextasch4
	mmfm	sp,a1,a2,a3,a9
	rets

**************************************************************************
*												*
* bcdtoasc - convert a 32 bit hexadecimal # to a null terminated	 	*
*	   hexadecimal ascii string. commas and lead zero blanking	 	*
*	   are asserted.						 			*
* a8 = bcd #								 			*
* returns:								 			*
* a8 = ptr to ascii hex string						 			*
*												*
**************************************************************************
bcdtoasc
	mmtm	sp,a3,a4,a14
	clr	a3
	clr	a4
	bset	b_commas,a4	
	callr	bcd_to_ascii_dec
	mmfm	sp,a3,a4,a14
	rets

**************************************************************************
*												*
* bcd_to_ascii_dec - converts a bcd number into a null terminated	 *
*		   ascii decimal string.				 *
* a3 = width, minimum # of characters contained in the string		 *
* a4 = flags, uses: b_commas - put commas in the number			 *
*		  b_zprint - if width is not reached, fill with 0's	 *
*			     not spaces.				 *
* a8 = bcd #								 *
* returns:								 *
* a8 ptr to the string							 *
* a3 & a4 are preserved							 *
*												*
**************************************************************************
bcd_to_ascii_dec:
	mmtm	sp,a1,a2,a3,a5,a9
	move	a8,a1
	movk	1,a2
	move	a2,a5		;digit count
	srl	4,a1		;we will always print the first dude
bcdzlp:
	move	a1,a9	
	srl	4,a1		;slide digit off the end
	inc	a2		;knock up another digit
	sll	28,a9
	srl	28,a9
	jreq	bcdz		;it's a zero
	move	a2,a5		;update valid digit count
bcdz:
	cmpi	8,a2
	jrlo	bcdzlp		;more digits to check
*o.k. let's string this bitch
	clr	a2			;comma count
	move	a2,-*sp,w		;here's the null terminator
bcdclp:
	move	a8,a9
	srl	4,a8			;shit this digit
	sll	28,a9
	srl	28,a9			;isolate
	addi	'0',a9			;make ascii
	cmpi	'9',a9
	jrls	bcdisnum		;it's a valid number.
	movi	' ',a9			;substitute a space for error
bcdisnum:
	move	a9,-*sp,w		;push on my man
	dec	a3			;decrement width
	dec	a5			;digit count
	jrz	bcddone			;we have finished
*comma shit
	inc	a2
	cmpi	3,a2			;comma check	
	jrlo	bcdclp			;br = no comma
	btst	b_commas,a4		;print commas?
	jreq	bcdclp			;nope....ignore!
	movi	',',a2
	move	a2,-*sp,w		;stuff a comma
	clr	a2
	jruc	bcdclp
bcddone:
	move	a3,a3
	jrz	bcdxfer			;width has been fulfilled
	jrn	bcdxfer 		;thanx ti
	btst	b_zprint,a4
	jrne	bcdzp1			;yes, fill width with zeros
	movi	' ',a2
	jruc	bcdzp2
bcdzp1:
	movi	'0',a2
bcdzp2:
	move	a2,-*sp,w		;stuff the leader
	dsjs	a3,bcdzp2
bcdxfer:
*dump the string and pass it back
	movi	strngram,a1		;store here for blow out 	
	move	a1,a8
bcdxfer_lp:
	move	*sp+,a9,w
	movb	a9,*a1
	addk	8,a1
	move	a9,a9
	jrnz	bcdxfer_lp

	mmfm	sp,a1,a2,a3,a5,a9
	rets

**************************************************************************
*												*
*	  l_mess										*
*												*
*	  a8 points at mess_mac followed by message text.			*
*	     pop all reggies leaving a8 pointing at text.			*
*	     and jump to the text processor!						*
*												*
*	  the mmfm pops the routine to call into a1.				*
*												*
*	  you ***must*** use jsrp to get here. 					*
*												*
**************************************************************************
l_mess_loop
	addi	8,a8			;push beyond this byte
l_mess
	addi	0fh,a8			;if it ends in other than zero..
*					;kick to next word (i.e. .even)
	srl	4,a8
	sll	4,a8			;mask fractional word

	mmfm	a8,a1,a5,a9,a10,a11	;load up reggies from a8.
	mmfm	a8,a0			;you may sleep

	jsrpr	a1			;jsrp to the routine
	movb	*a8,a0			;check next byte 0=done...1=more.
	jrnz	l_mess_loop
	retp
	
**************************************************************************
*												*
*	  lm_setup										*
*												*
*	  this is called to setup the world for a string 			*
*	  operation, but not physically make the call.				*
*												*
*	  this allows tweaking of reggies before the call.			*
*												*
*	  lm_finis									     *
*												*
*	  this is called once the modifications are made!			*
*												*
*												*
**************************************************************************
lm_setup mmfm	a8,a1,a5,a9,a10,a11		;load up reggies from a8.
	mmfm	a8,a0			     ;sleepy time
	rets
lm_finis
	jump	a1				    ;this runs routine and

**************************************************************************
*									    *
* lm_printf - this routine combines lm_setup with printf, use if you	 *
*		don't need to tweak the registers			 *
* a8 = mess_mac followed by string.					 *
* note: call with jsrp							 *
*									    *
**************************************************************************
lm_printf:
	callr	lm_setup
	jruc	printf

**************************************************************************
*												*
* clrtext - clear all text on the object list.				 *
*												*
**************************************************************************
clrtext
	mmtm	sp,a0,a1
	movi	oid_text,a0
	clr	a1
	not	a1
	calla	kilobj
	mmfm	sp,a0,a1
	rets
	
**************************************************************************
*												*
* copy_obj - copies the contents of one object block to the other.	 *
* a0 = ptr to destination block						 *
* a8 = ptr to source block						 *
* note: trashes a14							 *
*												*
**************************************************************************
copy_obj:
	mmtm	sp,a0,a8
	movi	obsiz,a14,w	;get the size of the block in words
	addi	64,a0
	addi	64,a8		;don't copy the links
	srl	4,a14		;divide by 16		
	subk	4,a14		;subtract to account for the 1st two links
copyobj_lp:
	move	*a8+,*a0+,w	;move a word
	dsjs	a14,copyobj_lp
	mmfm	sp,a0,a8
	clr	a14
;	move	a14,*a0(oshad),l	;kludge misplaced links
	move	a14,*a0(oplink),l
	rets

**************************************************************************
*												*
* adjstwtl - adjust the object's coordinates in relation to the          *
*	   world. it is assumed that the current coordinates			*
*	   are screen relative. 								*
* a0 = ptr to the object block									*
*												*
**************************************************************************
;adjstwtl
;	mmtm	sp,a3,a5
;	move	@worldtlx,a5,l
;	move	*a0(oxval),a3,l
;	add	a5,a3
;	move	a3,*a0(oxval),l
;	move	@worldtly,a5,l
;	move	*a0(oyval),a3,l
;	add	a5,a3
;	move	a3,*a0(oyval),l
;	mmfm	sp,a3,a5
;	rets

*
*7 point font.
*
****rd7font
****	.long  font8exc,font8apos,font8num,font8doll,font8perc,font8and
****	.long  font8apos,font8lparen,font8rparen,font8astr,font8plus
****	.long  font8comm,font8min,font8per,font8sla,font80,font81
****	.long  font82,font83,font84,font85,font86,font87,font88,font89
****	.long  font8colon,font8smcol,font8lparen,font8eql,font8rparen
****	.long  font8quest,font8min
****	.long  font8a,font8b,font8c,font8d,font8e,font8f,font8g,font8h
****	.long  font8i,font8j,font8k,font8l,font8m,font8n,font8o,font8p
****	.long  font8q,font8r,font8s,font8t,font8u,font8v,font8w,font8x
****	.long  font8y,font8z
****	.long  font8lparen,font8arrw,font8rparen,font8exc,font8min
****	.long  font8apos	
****	.long  font8a,font8b,font8c,font8d,font8e,font8f,font8g,font8h
****	.long  font8i,font8j,font8k,font8l,font8m,font8n,font8o,font8p
****	.long  font8q,font8r,font8s,font8t,font8u,font8v,font8w,font8x
****	.long  font8y,font8z
****	.long  font8lparen,font8exc,font8rparen,font8blk
****	.long	font8underline, font8blk, font8blk, font8pou

****font8blk:
****	.word	4,4,2,-2
****	.long	>2000000
****
font8underline:
	.word	6,1,0,-9
	.long	>2000000

	.end
