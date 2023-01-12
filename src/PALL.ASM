	.file	'pall.asm'
	.title	'palette allocator ver. 1.0'
	.width	132
	.option	b,d,l,t
	.mnolist

	.include	sysequ.asm 		;sys.inc and gsp.inc
	.include	dispequ.asm
	.include	mainequ.asm
	.include	macros.hdr

	.text


palq_entry_size	.equ	32+16+16		; src 32, dest 16, # cols 16
palq_max_entry	.equ	32			; max number of entries
palq_size	.equ	palq_entry_size*palq_max_entry

	.bss	paltrans_queue,palq_size
	.bss	paltrans_start,32		;start ptr in paltrans queue
	.bss	paltrans_end,32			;end ptr in paltrans queue

**************************************************************************
*											     *
*  init_paltrans_queue									     *
* 											     *
*  initialize the queue for palette transfers					     *
*											     *
**************************************************************************
init_paltrans_queue
	movi	paltrans_queue,a0
	move	a0,@paltrans_start,l	;empty queue (start = end = qstart)
	move	a0,@paltrans_end,l
	rets
 
**************************************************************************
*											     *
*  setup palette transfer								     *
* 											     *
*  args :										     *
*  a0 : pal_src	 = address of palette color data				     *
*  a1 : pal_dest	 = bit 8-15 destination palette | bit 0-7 start color   *
*  a2 : col_count = 16 bit colour count						     *
*											     *
**************************************************************************
palset
setup_pal_xfer
	push	a3
	move	@paltrans_end,a3,l

	move	a0,*a3+,l		;pal source address
	move	a1,*a3+			;pal dest address
	move	a2,*a3+			;number colours

	cmpi	paltrans_queue+palq_size,a3	;if ptr runs off end of
	jrlt	no_wrap					;queue then wrap around
	movi	paltrans_queue,a3			;to the start
no_wrap	move	a3,@paltrans_end,l

	pull	a3
	rets

**************************************************************************
*											     *
*  transfer palettes to colour ram (called during vblank)			     *
* 											     *
*  trashes   : a0-a6									     *
*											     *
**************************************************************************
transfer_palettes

* a0 = q_start
* a1 = q_end
* a2 = src
* a3 = dest
* a4 = col_count
* a5 = colour_base

	move	@paltrans_start,a0,l	;queue start pos
	move	@paltrans_end,a1,l	;queue end pos
	cmp	a0,a1			;start = end ?
	jreq	queue_empty

	movi	colram,a5	;base address of colour ram

next_transfer
	move	*a0+,a2,l	;palette source address
	move	*a0+,a3		;palette destination address
	move	*a0+,a4		;number of colours in palette
	zext	a3


	.if	yunit
	move	a3,a6		;convert to colour ram address
	sll	32-12,a6
	srl	32-12-4,a6	;*16
	srl	14,a3		;move b14/15 to b6/7
	sll	6+4,a3
	add	a6,a3
	.else
	sll	4,a3		;adjust for bit addr
	.endif

	add	a5,a3		; + colour ram base address

	srl	1,a4		;/2
	jrnc	no_1
	move	*a2+,*a3+	;do 1 colour
no_1
	srl	1,a4		;/4
	jrnc	no_2
	move	*a2+,*a3+,l	;do 2 colours
no_2
	srl	1,a4		;/8
	jrnc	no_4
	move	*a2+,*a3+,l	;do 4 colours
	move	*a2+,*a3+,l
no_4
	jrz	done		;count = 0 ?
xfer_loop
	move	*a2+,*a3+,l	;do 8 colours
	move	*a2+,*a3+,l
	move	*a2+,*a3+,l
	move	*a2+,*a3+,l
	dsj	a4,xfer_loop
done
	cmpi	paltrans_queue+palq_size,a0	; if ptr runs off end of
	jrlt	sans_wrap				; queue then wrap around
	movi	paltrans_queue,a0			; to the start
sans_wrap
	cmp	a0,a1					; start = end ?
	jrne	next_transfer
	move	a0,@paltrans_start,l			; save queue start pos

queue_empty
	rets

**************************************************************************
*												*
* delpal - delete an objects palette								*
* a0 = ptr to object										*
*												*
**************************************************************************
delpal
	push	a0
	move	*a0(opal),a0,w
	callr	freepal
	mmfm	sp,a0
	rets

**************************************************************************
*												*
* findpal - find the color map # to which the given palette is assigned. *
* a0 = 32 bit palette address									*
* returns:											*
* z bit set = palette not found ---> a0 = 0						*
* z bit clr = palette found ---> a0 = palette #(correct format for dma)	*
*												*
**************************************************************************
findpal
	mmtm	sp,a1,a2,a3
	movi	numpal,a3
	movi	palram,a1	
findpal0
	move	*a1,a2,l	;get palette id
	cmp	a0,a2
	jreq	findpal1	;found
	addi	palrsiz,a1
	dsjs	a3,findpal0
	clr	a0		;set z bit ---> failure
	jruc	findpalx
findpal1
	subi	numpal,a3	;compute palette #
	neg	a3

	.if	yunit
	move	a3,a0		;move bits 4,5 to 6,7 for yunit
	sll	28,a3		;strip off bits 4,5
	srl	28,a3
	srl	4,a0
	sll	6,a0
	add	a0,a3
	.endif

	move	a3,a0		;return palette #
	sll	8,a3
	add	a3,a0		;double it up for loffredo brain damage
	inc	a3		;clr z bit ---> success
findpalx
	mmfm	sp,a1,a2,a3
	rets
*
*clear out palette allocation ram
*
clrpal:
	mmtm	sp,a0,a1,a2
	callr	init_paltrans_queue

	movi	fpalram,a0,l		;get address of ram
	movi	palrsiz*numpal/16,a2	;get # of words
	clr	a1
clrpalp:
	move	a1,*a0+,w
	dsjs	a2,clrpalp
clrptr:
	movi	ptrram,a0,l		;get address of ram
	movi	ptrsiz*numptr/16,a2	;get # of words
clrplp1:
	move	a1,*a0+,w
	dsjs	a2,clrplp1
	mmfm	sp,a0,a1,a2
	rets
*
*clear only foreground palettes
clrfpal:
	mmtm	sp,a0,a1,a2
	movi	fpalram,a0,l		;get address of ram
	movi	palrsiz*nmfpal/16,a2	;get # of words
	clr	a1
	jruc	clrpalp
*
*clear only background palettes
clrbpal:
	mmtm	sp,a0,a1,a2
	movi	bpalram,a0,l		;get address of ram
	movi	palrsiz*nmbpal/16,a2	;get # of words
	clr	a1
	jruc	clrpalp

**************************************************************************
*											     *
*  getfpal - get a foreground palette							     *
* 											     *
*  input: a0 = palette id (address of data)					     *
*  a0 returned with color map allocated (0000-0f0f)				     *
*  returns eq if no palette free								     *
*											     *
**************************************************************************
getfpal:
	mmtm	sp,a1,a2,a3,a4
*check if palette already exists
	movi	numpal,a3
	movi	palram,a1	
getpl0:
	move	*a1,a2,l	;get palette id
	cmp	a0,a2
	jreq	already_there	;already in color ram
	addi	palrsiz,a1
	dsjs	a3,getpl0
*
* check for a spare palette (foreground)
*
	movi	fpalram,a1
	movi	nmfpal,a3	; check all palettes

get_spare_forg
	move	*a1(palcnt),a2,w
	jrne	try_another_f  		; palette is in use ---> try another

	move	*a1(paltime),a2,w	; when wuz this guy released ?
	jreq	found_a_palette_f	; never ---> cool we can use it
	move	@tick,a4,w
	cmp	a2,a4			; just now ??
	jrne	found_a_palette_f	; no, use it

try_another_f
	addi	palrsiz,a1
	dsjs	a3,get_spare_forg
	move	a3,a3			; no palettes left set zero bit
	jruc	getplx			; exit

**************************************************************************
*											     *
*  getbpal - get a background palette							     *
* 											     *
*  input: a0 = palette id (address of data)					     *
*  returns: a0 returned with color map allocated (0000-0f0f)		     *
*  returns eq if no palette free								     *
*											     *
**************************************************************************
getbpal:
	mmtm	sp,a1,a2,a3,a4
*check if palette already exists
	movi	numpal,a3
	movi	palram,a1	
gtbpl0:
	move	*a1,a2,l	;get palette id
	cmp	a0,a2
	jreq	already_there	;already in color ram
	addi	palrsiz,a1
	dsjs	a3,gtbpl0
*
* check for a spare palette (background)
*
	movi	bpalram,a1
	movi	nmbpal,a3	;check all palettes

get_spare_back
	move	*a1(palcnt),a2,w
	jrne	try_another_b  		; palette is in use ---> try another

	move	*a1(paltime),a2,w	; when wuz this guy released ?
	jreq	found_a_palette_b	; never ---> cool we can use it
	move	@tick,a4,w
	cmp	a2,a4			; just now ??
	jrne	found_a_palette_b	; no, use it

try_another_b
	addi	palrsiz,a1
	dsjs	a3,get_spare_back
	move	a3,a3			; no palettes left set zero bit
	jruc	getplx			; exit

found_a_palette_f
	addi	nmbpal,a3

found_a_palette_b
	mmtm	sp,a0,a1,a2
	move	a3,a1		;palette #
	subi	numpal,a1	;compute palette #
	neg	a1

	.if	yunit
	move	a1,a2		;move bits 4,5 to 6,7 for yunit
	sll	28,a1		;strip off bits 4,5
	srl	28,a1
	srl	4,a2
	sll	6,a2
	add	a2,a1
	.endif

	sll	8,a1		;x 256
	move	*a0+,a2,w	;get # colors in palette
	callr	palset		;setup palette transfer
	mmfm	sp,a0,a1,a2
	jreq	getplx		;failed to get transfer
	move	a0,*a1,l	;stuff palette i.d.

already_there
	subi	numpal,a3	;compute palette #
	neg	a3

	.if	yunit
	move	a3,a0		;move bits 4,5 to 6,7 for yunit
	sll	28,a3		;strip off bits 4,5
	srl	28,a3
	srl	4,a0
	sll	6,a0
	add	a0,a3
	.endif

	move	a3,a0			; return palette #
	sll	8,a3
	add	a3,a0			; double it up for lofredo brain damage
	move	*a1(palcnt),a2,w	; increment count
	addk	1,a2			; set ne for success 
	move	a2,*a1(palcnt),w
getplx:
	mmfm	sp,a1,a2,a3,a4
	rets
	
**************************************************************************
*											     *
*  free a palette									     *
* 											     *
*  a0 = palette # (0-numpal) to free							     *
*											     *
**************************************************************************
freepal:	
	mmtm	sp,a0,a1
	sll	24,a0		;mask off garbage
	srl	24,a0

	.if	yunit
	move	a0,a1		;move bits 6,7 into 4,5 for yunit
	sll	28,a0
	srl	28,a0
	srl	6,a1
	sll	4,a1
	add	a1,a0
	.endif

	cmpi	numpal,a0	;error...palette number erroneous
	jrlo	freepal1

	lockup

freepal1
	movi	palrsiz,a1
	mpyu	a0,a1
	addi	palram,a1
	move	*a1(palcnt),a0,w
	dec	a0			; decrement its count
	jrnn	freepal2
	lockup				; negative palette count, oh shit !!

freepal2
	move	a0,*a1(palcnt),w	; store updated palette count
	jrp	freplx			; other guys use this, leave time alone

**************************************************************************
*											     *
*  remember when this was freed, and store it cuz we are not allowed to  *
*  reallocate this palette on this same tick					     *
*											     *
**************************************************************************

;	incm	@freepalcnt,w
	move	@tick,a0,w
	move	a0,*a1(paltime),w

freplx
	mmfm	sp,a0,a1
	rets
	
**************************************************************************
*											     *
*  ungetpal - clears out a palettes allocation count				     *
* 											     *
*  input: a0 = palette # (0-numpal) to unallocate				     *
*											     *
**************************************************************************
ungetpal:	
	mmtm	sp,a0,a1
	sll	24,a0		;mask off garbage
	srl	24,a0

	.if	yunit
	move	a0,a1		;move bits 6,7 into 4,5 for yunit
	sll	28,a0
	srl	28,a0
	srl	6,a1
	sll	4,a1
	add	a1,a0
	.endif

	cmpi	numpal,a0 	;error...palette number erroneous
	jrlo	ungpal1
	lockup
ungpal1
	movi	palrsiz,a1
	mpyu	a0,a1
	addi	palram,a1
	move	*a1(palcnt),a14,w
	jrz	ungpalx
;	incm	@freepalcnt,w

	clr	a0
	move	a0,*a1(palcnt),w
*
* record time when freed, can't reallocate on same tik
*
	move	@tick,a0,w
	move	a0,*a1(paltime),w
ungpalx
	mmfm	sp,a0,a1
	rets

*
* blowout a palette - zero out the address and color count of a palette
* input: a0 = palette address
*
blowpal
	mmtm	sp,a1,a2,a3
	movi	numpal,a3	; a3 = total # of palettes
	movi	palram,a1	

blow1	move	*a1,a2,l	; get palette id
	cmp	a0,a2
	jreq	blow2		; found
	addi	palrsiz,a1
	dsjs	a3,blow1
	clr	a0		; set z bit ---> failure
	jruc	blowx

blow2	clr	a0
	move	a0,*a1,l		; blow out address
	move	a0,*a1(palcnt),w	; blow out color count

blowx	mmfm	sp,a1,a2,a3
	rets

	.end
