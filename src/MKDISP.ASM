**************************************************************************
*												*
*   mkdisp - mortal kombat gsp dma object handler		  			*
*												*
*   copyright (c) 1993 Midway Manufacturing						*
*												*
**************************************************************************
	.file	'mkdisp.asm'
	.title	"gsp display processor"

	.width	132
	.option	b,d,l,t
	.mnolist
*
* files required for assembly
*
	.include	sysequ.asm	    ;sys.inc and gsp.inc
	.include	macros.hdr
	.include	dispequ.asm
	.include	mainequ.asm
	.include	imgtbl.glo
	.include	scorarea.tbl

	.text

slowdma	.set	1
bog_line	.set	0

lm_fliph	.set	m_fliph*>10000

**************************************************************************
*											     *
*  dma queue ram										     *
*											     *
**************************************************************************

cell_size	.set	32*6			; # bits in 1 dma queue cell entry
q_size		.set	cell_size*500

      	.bss	dma_q,q_size,1

objq_1 	.set	dma_q+q_size		; object queue entry #1

	.bss	dmaqcur,32		; current dmaq
	.bss	qdmaflg,16		; special dmaq being updated=1
qsize	.set	nobj*bqcell		; size of queues
	.bss	dmaq,qsize		; misc. non-sync dma queue	
	.bss	objstr,nobj*obsiz	; object structure list start
	.bss	objlstnd,0		; object list end

**************************************************************************
*											     *
*   keep chache aligned									     *
*											     *
**************************************************************************
dclipl
	move	a0,a3
	addi	oxvel,a3		; a3 ---> vel/pos info we want
	mmfm	a3,a12,a11,a9,a8
	move	b0,b0			; add velocities ?
	jrne	skip_velocities		; sans

	add	a12,a9			; add in x velocity
	add	a11,a8			; add in y velocity
	mmtm	a3,a9,a8		; stuff in new coordinates

skip_velocities
	move	a8,a10
	srl	16,a9
	movx	a9,a10			; a10 = y:x coordinates
	move	a0,a3
	addi	oflags-16,a3			; get parameter location
	mmfm	a3,a12,a11,a9,a8,a7,a6	; a12 = oflags / a7 = oflags2

	btst	b_noscroll,a7		; do we scroll ?
	jrne	clip4			; no, then don't
	subxy	a4,a10

clip4	clr	a3			; assume "single part" image
	btst	b_multipart,a7
	jreq	no_multi

	btst	b_inviso,a7		; invisible ?
	jrne	dispnext		; yes, dont display this guy

	move	*a0(oimg),a3,l	 	; a3 = multipart ram
	move	a10,b3			; save original coordinates

clip41	move	b3,a10			; restore original coordinates
	move	*a3+,a11,l 		; ram entry #1 = sag
	jreq	dispnext
	move	*a3+,a9,l		; ram entry #2 = y:x size
			 		; if the becomes lw - see: "ejby"
	move	*a3+,a2,w		; ram entry #3 = control word
	sll	16,a2
;****************
;	andi	>803f0000,a12		; clear compress/clip bits
	andi	>803fffff,a12		; clear compress/clip bits
;****************
	or	a2,a12			; set "bits per pixel"

	move	*a3+,a2,l		; ram #4 --> a2 = y:x animation points
	subxy	a2,a10			; adjust coordinates
*
* on screen check
*
no_multi
	move	a10,a2
	addxy	a9,a2  		; a2 = bottom right (y,x) coordinate
	subxy	a14,a2
	jrylt	boxc3		; y greater than zero = offscreen
	jrxlt	boxc3		; x greater than zero = offscreen

	move	a2,b1		; b1 = # of pixels on screen

	move	a10,a2		; a2 = top left (y,x) coordinate
	subxy	a13,a2
	jrygt	boxc3		; y greater than zero = offscreen
	jrxgt	boxc3		; x greater than zero = offscreen

;******************************
;	movk	1,b2
;     	ori	dmaclp*>10000,a12	; set the clip bit in the dma
;*
;* right clip
;*
;	zext	a2,w
;	jreq	boxc3		; none ---> skip this object
;
;	move	a2,b5		; b5 = # of pixels on screen
;	addxy	a9,a2		; a2 = # of pixels to clip
;	jrxle	lclp1		; none.
;
;	addxy	b2,b5		; inc x --> one pixel loffy lockup ?
;	jrxne	rclp3		; no
;	dec	a2		; yes, clip one less (show 2 pixels)
;
;rclp3 	btst	b_fliph+16,a12	; flip horizontal ?
;	jreq	rclp4		; no ----> normal "right clip"
;
;	zext	a2,w
;	subxy	a2,a10		; yes ---> clip on other side of image		
;	jruc	rclp5
;		    
;rclp4  	sll	8,a2
;rclp5	movx	a2,a12
;	jruc	clip5
;
;*
;* left clip
;*
;lclp1	movx	a14,a2
;	subxy	a10,a2		; a2 = # of pixels to clip off left
;	jrxle	clip5		; no clip needed
;
;	move	a2,b5		; b5 = clip info
;	movx	a14,a10		; set x coordinate to left edge
;
;	subxy	b2,b1		; dec x --> how many pixels showing ??
;	jrxn	boxc3		; zero pixels showing ---> skip this object
;	jrxne	lclp2		; more than 1 showing ---> we cool
;	dec	a10		; one pixel showing ---> move left 1 pixel
;	dec	b5		; clip one less pixel so dma don't lock up
;
;lclp2	move	b5,a2
;	btst	b_fliph+16,a12	; flip horizontal ?
;	jreq	lclp3		; no
;	zext	a2,w
;	subxy	a2,a10		; yes ---> adjust coordinates
;	sll	8,a2		; yes ---> clip from other side
;lclp3	movx	a2,a12		; move clip info into its proper area in a12
;
;*************************************

clip5	clr	a2		; a2 = coorindate adjustment for flips
	btst	b_fliph+16,a12	; flip horizontal ?
	jreq	clip6		; no
	movx	a9,a2		; yes, add x size to coordinate
	dec	a2
clip6	btst	b_flipv+16,a12	; flip vertical ?
	jreq	clip7		; no
	movy	a9,a2		; yes, add y size to coordinate
	subi	>10000,a2 	; and nudge it back up
clip7
	addxy	a2,a10		; add flip adjustments

*
* put on dma queue
*
*  a6 = oscale
*  a7 = oflags2                a10 = destination y:x    
*  a8 = const:palette xlate    a11 = image sag
*  a9 = vsize:hsize	      a12 = control:offset
*
	addxy	a5,a10				; page offset
	mmtm	a1,a6,a8,a9,a10,a11,a12	; put entry on dma queue !
	inc	b13

;	cmpi	2,b13
;	jrhs	dispnext

	dint

	.if slowdma
 	setf	1,0,0				; field 0 is 1 bit
	movk	1,a2
	move	a2,@(intenb+b_x1e),0		; enable dma interupt
	setf	16,1,0
	.else
	move	b9,*b12,w			; enable dma interupt
	.endif

	move	@dmactrl,a2,w
	jrn	dma_is_busy			; dma busy = queue up this object

;	move	b13,b13
;	jrne	dma_is_busy

*
* dma is not busy
*

;	mmfm	b 5,b 7,b 8,b 9,b 10,b 11,b 12	; grab from dma queue
;	movi	dmaregs,b 6
;	mmtm	b 6,b 7,b 8,b 9,b 10,b 11,b 12	; stuff into dma registers
;	subi	cell_size*2,b 5
;	dec	b 13

	trap 	1				; call dma interupt
						; (1)

dma_is_busy
	eint
	btst	b_multipart,a7		; is this a multipart image ?
      	jrne	clip41			; yes


clipb	move	@pageaddr,a5,l
	jruc	dispnext

boxc3  	addxy	a5,a10	 		; undo the "unpad"
	move	a3,a3	 		; we in middle of "multiparter"
	jrne	clip41	 		; yes, grab the next piece

dispnext
	move	*a0,a0,l 		; get next link
	jrne	dclipl			; done?
	rets



dma_interupt
	move	b11,b10
	move	-*b14,-*b10,l
	move	-*b14,-*b10,l
	move	-*b14,-*b10,l
	move	-*b14,-*b10,l
	move	-*b14,-*b10,l
	move	-*b14,-*b10,l
	dsjs	b13,dmaq9

	setf	1,0,0				; field 0 is 1 bit
	clr	b10
	move	b10,@(intenb+b_x1e),0	; disable dma interupt (ejbpatch?)
	setf	16,0,0

    	.if bog_line

; just us a flag to signal --> all objects are queued up? (ejbpatch)
	move	@last_dma,b10,l
	cmp	b14,b10				; was that the last one ??
	jrne	dmaq9				; no

	mmtm	sp,a1,a3
bog1	move	@dmactrl,a1,w
	jrn	bog1				; wait for last dma 
	movi	bpal_hot_green*>10000,a3
	callr	draw_bogline
bog2	move	@dmactrl,a1,w
	jrn	bog2				; wait for line
;	clr	a1
;	move	a1,@last_dma,l
	mmfm	sp,a1,a3

	.endif


dmaq9  	cmp	b14,b8				; are we at the shadows ?
	jreq	dmaq10				; ya !

	reti


dmaq10
	move	@f_shadows,b10,w
	jreq	dmaq12

	setf	1,0,0
	clr	b10
	move	b10,@(intenb+b_x1e),0	; disable dma interupt (ejbpatch?)
	setf	16,1,0

	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14
	mmtm	sp,b0,b1,b2,b3,b4,b5

	move	@pageaddr,a5,l		; a5 = page
	move	@worldtly,a4,l

dmaqw	move	@dmactrl,a0,w
	jrn	dmaqw			; dma busy = wait
	callr	shadow_p1p2

	move	b13,b13			; remaining queue entries ?
	jreq	dmaq11			; na !

	.if slowdma
 	setf	1,0,0			; field 0 is 1 bit
	movk	1,a2
	move	a2,@(intenb+b_x1e),0	; enable dma interupt
	setf	16,1,0
	.else
	move	b9,*b12,w	    	; enable dma interupt (1)
	.endif

	move	@dmactrl,b3,w
	jrn	dmaq11			; dma running ?
	trap 	1			; na, start it up

dmaq11	mmfm	sp,b0,b1,b2,b3,b4,b5
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14
dmaq12	reti

**************************************************************************
*												*
*		      end of cache alligned code					*
*		      end of cache alligned code					*
*		      end of cache alligned code					*
*												*
**************************************************************************

**************************************************************************
*												*
*		    display object lists							*
*												*
**************************************************************************
display
	move	@call_every_tick,a0,l	; routine to run every tick ?
	jreq	disp0				; no
	call	a0				; yes, call it
* y
* gravity & keep in bounds
*
disp0	move	@left_edge,a0,w
	addi	left_padding,a0
	move	@right_edge,a1,w
	addi	scrrgt-right_padding,a1
	clr	a4

	move	@p1_obj,a2,l	   	; player 1 defined ?
	jreq	grav1		   	; no
	callr	gravity_n_bounds
grav1	move	@p2_obj,a2,l	   	; player 2 defined ?
	jreq	grav2		   	; no
	callr	gravity_n_bounds
grav2
*
* update scrolling
*
	movi	scrollx8,a10
	movi	worldtlx8,a11
	mmfm	a10,a0,a2,a3,a4		; grab 1st 4 scroll values
	mmfm	a11,a5,a6,a7,a8		; grab 1st 4 world x values
	add	a0,a5
	add	a2,a6
	add	a3,a7
	add	a4,a8			; add 'em up
	mmtm	a11,a5,a6,a7,a8

	movi	scrollx4,a10
	movi	worldtlx4,a11
	mmfm	a10,a0,a2,a3,a4,a5	; scroll values
	mmfm	a11,a6,a7,a8,a9,a10	; world x values
	add	a0,a6
	add	a2,a7
	add	a3,a8
	add	a4,a9
	add	a5,a10			; add 'em up
	mmtm	a11,a6,a7,a8,a9,a10

**************************************************************************
*											     *
*  display object lists									     *
* 											     *
*  a0 = object pointer	       a14 = scrntl						*
*  a1 = queue pointer	        b0 = velocity flag					*
*  a4 = world top left y:x	b4 = dlist table pointer				*
*  a5 = pageaddr										     *
*											     *
**************************************************************************

	move	@scrolly,a7,l
	move	@worldtly,a4,l
	add	a7,a4
	move	a4,@worldtly,l		; do y scrolling for all planes
	callr	init_dma_regs
	move	@pageaddr,a5,l

	move	@dlists,b4,l		; any lists to display ?
	jreq	disp5			; no

	move	@scrntl,a14,l		; a14 = top left
	move	@f_novel,b0,w		; b0 = velocity flag !!

disp1	move	b4,a3
disp2	move	*a3+,a0,l		; a0 = object list
	jreq	disp5			; zero = we are done
	jrnn	disp3			; positive = object list
	inc	a0			; shadow time ?
	jreq	disp4			; no
	move	a1,b8			; yes, remember this spot
	jruc	disp2

disp4	move	*a3+,a2,l		; a2 = routine to call
	call	a2
	jruc	disp2
disp3	move	*a3+,a13,l		; a13
	move	*a13,a13,w
	movx	a13,a4			; a4 = combine to form top left y:x
	move	@scrnlr,a13,l		; a13 = lower right
	move	a3,b4
	callr	dispnext
	jruc	disp1
*
* do manual dma queue entries
*
disp5	push	a1
	move	@qdmaflg,a0,w			; q being modified blow it off
	jrne	dma_score_area

	move	@dmaqcur,a2,l			; a2 = current queue position
	movi	dmaq+qsize,a1
	move	a1,@dmaqcur,l			; reset misc dma queue
	addi	bqcell,a1
	jruc	dqlp
dql0	mmfm	a1,a8,a9,a10,a11,a12		; get q stuff
	addxy	a5,a10				; page offset
	movi	dmaregs,a7
	rl	16,a12	       			; shift flags to upper word
q_wait	move	@dmactrl,a6,w
	jrn	q_wait	     			; wait for dma while it is busy
	movi	>01000100,a6 			; a6 = scale
	mmtm	a7,a6,a8,a9,a10,a11,a12	; stuff the dma regs
dqlp	subi	2*bqcell,a1
	cmp	a2,a1
	jrhs	dql0

dma_score_area
	pull	a1

	move	@f_doscore,a0,w
	jreq	dsa9				; flag sez no !

	clr	a9				; used for zero x compare
	move	@score_1st,a0,l			; a0 = entry #1
dsa1	mmfm	a0,a2,a3,a4,a6,a7,a8		; grab dma inputs
	cmpxy	a4,a9
	jrxeq	dsa3				; x size = zero ---> skip dma
	add	a5,a6
	mmtm	a1,a2,a3,a4,a6,a7,a8 	; put entry on dma queue !
	inc	b13				; increment queue counter

	dint

	.if slowdma
 	setf	1,0,0				; field 0 is 1 bit
	movk	1,a2
	move	a2,@(intenb+b_x1e),0		; enable dma interupt
	setf	16,1,0
	.else
	move	b9,*b12,w			; enable dma interupt (1)
	.endif

	move	@dmactrl,a2,w
	jrn	dsa2				; dma busy = skip trap
	trap 	1				; call dma interupt
dsa2	eint
dsa3	cmpi	score_ram_end,a0		; are we done ?
	jrlo	dsa1				; no

dsa9 
	.if bog_line
	movi	bpal_hot_purple*>10000,a3	; purple = all objects are queued
	callr	q_bogline
	move	a1,@last_dma,l
	move	@dmactrl,a2,w
	jrn	dsaA				; dma busy = skip trap
	trap 	1				; call dma interupt
dsaA	.endif

	rets


gravity_n_bounds
	move	*a2(oxpos),a3,w
	cmp	a0,a3			; within left edge ?
	jrgt	kib4			; yes

	move	a0,a3			; x coordinate = exactly on edge
	move	*a2(oxvel),a5,l
	jrp	kib6			; moving right velocity = ok
	move	a4,*a2(oxvel),l		; moving left velocity = stop it
	jruc	kib6

kib4	cmp	a1,a3			; within right edge ?
	jrlt	kib7			; yes

	move	a1,a3			; x coordinate = exactly on edge
	move	*a2(oxvel),a5,l
	jrn	kib6			; moving left velocity = ok
	move	a4,*a2(oxvel),l		; moving right velocity = stop it
kib6	move	a3,*a2(oxpos),w

kib7	move	*a2(ograv),a5,l	   	; player 2 have gravity ?
	jreq	kib9			; no
	move	*a2(oyvel),a3,l
	add	a5,a3
	move	a3,*a2(oyvel),l		; yes add gravity to yvel
kib9	rets

**************************************************************************
*											     *
*  setup_score_ram - initialize things so we can display the score area  *
*                    stuff								     *
*											     *
**************************************************************************
setup_score_ram
	clr	a0
	move	a0,@f_doscore,w		; flag: don't do score area dma's
	movi	score_ram_end,a0	; a0 = 1st entry
	movi	>01000100,a1		; a1 = scale
*
* win knotches (4 entries)
*
	movi	MKMEDAL2,a7
	movi	>00000101,a2		; const:pal (score_p)
	move	*a7(isag),a5,l		; sag
	move	*a7(icontrol),a6,w	; control word
	ori	dmawnz,a6
	sll	16,a6
	clr	a3			; x size = 0 ---> no dma needed !!

	movi	>002f0018,a4
	mmtm	a0,a1,a2,a3,a4,a5,a6	; p1 knotch #1 = null
	movi	>002f0026,a4
	mmtm	a0,a1,a2,a3,a4,a5,a6	; p1 knotch #2 = null
	movi	>002f016b,a4
	mmtm	a0,a1,a2,a3,a4,a5,a6	; p2 knotch #1 = null
	movi	>002f015d,a4
	mmtm	a0,a1,a2,a3,a4,a5,a6	; p2 knotch #2 = null
*
* coin message / player score (2 entries)
*
;	clr	a2			; boonpal
	movi	>00000101,a2		; const:pal (score_p)

	clr	a3
	clr	a4
	clr	a5
	clr	a6
	mmtm	a0,a1,a2,a3,a4,a5,a6	; player 1 = null entry
	mmtm	a0,a1,a2,a3,a4,a5,a6	; player 2 = null entry
*
* character names in front of powerbars (2 entries)
*
	move	@p1_char,a7,w
	sll	6,a7
	addi	p1_powerbar_names,a7
	move	*a7(32),a4,l		; a4 = y:x coordinates
	move	*a7,a7,l
	movi	>00000101,a2		; const:pal
	move	*a7(isize),a3,l		; y:x size
	move	*a7(isag),a5,l		; sag
	move	*a7(icontrol),a6,w	; control word
	ori	dmawnz,a6
	sll	16,a6
	mmtm	a0,a1,a2,a3,a4,a5,a6	; put in score dma ram

	move	@p2_char,a7,w
	sll	6,a7
	addi	p2_powerbar_names,a7
	move	*a7(32),a4,l		; a4 = y:x coordinates
	move	*a7,a7,l
	move	*a7(isize),a3,l		; y:x size
	move	*a7(isag),a5,l		; sag
	move	*a7(icontrol),a6,w	; control word
	ori	dmawnz,a6
	sll	16,a6
	mmtm	a0,a1,a2,a3,a4,a5,a6	; put in score dma ram
*
* green powerbars (2 entries)
*
	movi	p1_bar,a3
	callr	get_safe_powerbar		; a3 = powerbar y:x size
	movi	bpal_bar_color*>10000,a2	; const:pal
	movi	>001e0016,a4			; a4 = y:x coordinates
	movi	>2000000,a5			; a5 = sag	
	movi	dmacal|>2000,a6
	sll	16,a6
	mmtm	a0,a1,a2,a3,a4,a5,a6		; put in ram queue

	movi	p2_bar,a3
	callr	get_safe_powerbar		; a3 = powerbar y:x size
	movi	>001e0178,a4			; a4 = p2 y:x coordinates
	move	a3,a7
	zext	a7,w
	subxy	a7,a4				; left justify for player 2
	mmtm	a0,a1,a2,a3,a4,a5,a6		; put in ram queue
*
* backdrops for powerbars (2 entries)
*
	movi	LIFEBOX,a7
	movi	>00000101,a2		; const:pal
	move	*a7(isize),a3,l		; y:x size
	movi	>001b0013,a4		; y:x coordinate
	move	*a7(isag),a5,l		; sag
	move	*a7(icontrol),a6,w	; control word
	ori	dmawnz,a6
	sll	16,a6
	mmtm	a0,a1,a2,a3,a4,a5,a6			; put in ram
	movi	>001b0000+(399-168->13),a4	; player 2  ---> new y:x coordinate
	mmtm	a0,a1,a2,a3,a4,a5,a6			; put in ram
*
* clock digits (2 entries)
*
	movi	REDFONT9,a7		; initialize with "9"
	move	*a7(isize),a3,l
	movi	tg_tens_yx,a4

	move	*a7(isag),a5,l
	move	*a7(icontrol),a6,w	; control word
	ori	dmawnz,a6
	sll	16,a6
	mmtm	a0,a1,a2,a3,a4,a5,a6	; put in ram
	movi	tg_ones_yx,a4
	mmtm	a0,a1,a2,a3,a4,a5,a6	; put in ram
;	move	a0,@score_1st,l		; set "1st dma" location
*
* score digits for player "# of wins" (6 entries)
*
	movi	SHADNUM0,a7
	move	*a7(isize),a3,l
	move	*a7(isag),a5,l
	move	*a7(icontrol),a6,w	; control word
	ori	dmawnz,a6
	sll	16,a6
	movi	p1d1_yx,a4
	mmtm	a0,a1,a2,a3,a4,a5,a6	; player 1 = digit #1 (hundreds)
	addk	12,a4
	mmtm	a0,a1,a2,a3,a4,a5,a6	; player 1 = digit #2 (tens)
	addk	12,a4
	mmtm	a0,a1,a2,a3,a4,a5,a6	; player 1 = digit #3 (ones)

	movi	p2d1_yx,a4
	mmtm	a0,a1,a2,a3,a4,a5,a6	; player 2 = digit #1 (hundreds)
	addk	12,a4
	mmtm	a0,a1,a2,a3,a4,a5,a6	; player 2 = digit #2 (tens)
	addk	12,a4
	mmtm	a0,a1,a2,a3,a4,a5,a6	; player 2 = digit #3 (ones)

	move	a0,@score_1st,l		; set "1st dma" location
	rets


p1_powerbar_names
	.long	BAR_KUNGLAO,>001e001d	; 0
	.long	BAR_KANG,>001e001d		; 1
	.long	BAR_CAGE,>001e001d		; 2
	.long	BAR_BARAKA,>001e001d		; 3
	.long	BAR_KITANA,>001e001d		; 4
	.long	BAR_MILEENA,>001e001d	; 5
	.long	BAR_SHANG,>001e001d		; 6
	.long	BAR_RAIDEN,>001e001d		; 7
	.long	BAR_SUBZERO,>001e001d	; 8
	.long	BAR_REPTILE,>001e001d	; 9
	.long	BAR_SCORPION,>001e001d	; 10
	.long	BAR_JAX,>001e001d		; 11
	.long	BAR_KINTARO,>001e001d	; 12
	.long	BAR_SHAOKAHN,>001e001d 	; 13
	.long	BAR_SMOKE,>001e001d	 	; 14
	.long	BAR_NOOB,>001d001d	 	; 15
	.long	BAR_NULL,>001e001d	 	; 16

p2_powerbar_names
	.long	BAR_KUNGLAO,>001e0128	; 0
	.long	BAR_KANG,>001e012e		; 1
	.long	BAR_CAGE,>001e014a		; 2
	.long	BAR_BARAKA,>001e0137		; 3
	.long	BAR_KITANA,>001e013c		; 4
	.long	BAR_MILEENA,>001e0133 	; 5
	.long	BAR_SHANG,>001e0112		; 6
	.long	BAR_RAIDEN,>001e0140		; 7
	.long	BAR_SUBZERO,>001e012a	; 8
	.long	BAR_REPTILE,>001e0138	; 9
	.long	BAR_SCORPION,>001e012d	; 10
	.long	BAR_JAX,>001e014e		; 11
	.long	BAR_KINTARO,>001e0135 	; 12
	.long	BAR_SHAOKAHN,>001e0123	; 13
	.long	BAR_SMOKE,>001e0140	 	; 14
	.long	BAR_NOOB,>001d0110	 	; 15
	.long	BAR_NULL,>001e0149	 	; 16


BAR_NULL
	.long	0,0,0,0,0


score_nums_tbl
	.long	SHADNUM0
	.long	SHADNUM1
	.long	SHADNUM2
	.long	SHADNUM3
	.long	SHADNUM4
	.long	SHADNUM5
	.long	SHADNUM6
	.long	SHADNUM7
	.long	SHADNUM8
	.long	SHADNUM9

**************************************************************************
*											     *
*  get_safe_powerbar - gives u back a powerbar x size that can be	     *
*                      stuffed into the dma ram area.			     *
* 											     *
*  input: a3 ---> ram variable p?_bar							     *
* 											     *
*  returns: a3 = value >= 3								     *
*											     *
**************************************************************************
get_safe_powerbar
	move	*a3,a3,w
	cmpi	3,a3				; danger zone ?
	jrhs	upw3
	movk	3,a3				; yes ---> keep at minimum of 3
upw3	ori	>000a0000,a3			; a3 = y:x size o bar
	rets

**************************************************************************
*											     *
*  update_knotches - updates the ram so the correct "knotches" state     *
*                    is represented in the score area.			     *
*											     *
**************************************************************************
update_knotches
	mmtm	sp,a0,a1,a2,a3,a4,a5
	movi	MKMEDAL2,a5      
	move	*a5(isize),a5,l		; a5 = medal image y:x size
*
* player 1
*
	clr	a0
	clr	a1
	move	@p1_matchw,a2,w		; any wins for p1 ?
	jreq	uk2			; no
	move	a5,a0
	dec	a2
	jreq	uk2
	move	a5,a1
uk2	move	a0,@p1_knotch1,l
	move	a1,@p1_knotch2,l	; update both knotches for p1
*
* player 2
*
	clr	a0
	clr	a1
	move	@p2_matchw,a2,w		; any wins for p2 ?
	jreq	uk4			; no
	move	a5,a0
	dec	a2
	jreq	uk4
	move	a5,a1
uk4	move	a0,@p2_knotch1,l
	move	a1,@p2_knotch2,l	; update both knotches for p2

uk7	mmfm	sp,a0,a1,a2,a3,a4,a5
	rets

**************************************************************************
*											     *
*  update_pmsg - update player message						     *
*											     *
**************************************************************************
update_pmsg
	mmtm	sp,a0,a1,a2,a3,a4,a5
	clr	a5				; for clearin'
*
* player 1 message
*
	movi	SHADWINS,a0
	movi	>000c0034,a4
	move	@p1_state,a1,w
	cmpi	ps_active,a1			; player 1 in ?
	jreq	up2				; yea

	move	a5,@entry_15+scr_size,l	; 100's digit = off
	move	a5,@entry_16+scr_size,l	;  10's digit = off
	move	a5,@entry_17+scr_size,l	;   1's digit = off
	callr	start_or_insertcoin		; msg = insert coin or push start
	movi	>000c001a,a4

up2	callr	grab_oimg_data
	movi	entry_6,a0			; 4 knotch + p1 + p2 = 6 entries
	clr	a5
	callr	stuff_info
*
* player 2 message
*
	movi	SHADWINS,a0
	movi	>000c014d,a4
	move	@p2_state,a1,w
	cmpi	ps_active,a1			; player 2 in ?
	jreq	up4				; yes

	move	a5,@entry_18+scr_size,l	; 100's digit = off
	move	a5,@entry_19+scr_size,l	;  10's digit = off
	move	a5,@entry_20+scr_size,l	;   1's digit = off
	callr	start_or_insertcoin
	movi	>000c010d,a4

up4	callr	grab_oimg_data
	movi	entry_5,a0		; 4 knotch + p1 = 5 entries
	clr	a5
	callr	stuff_info

	clr	a1
	not	a1
	movi	pid_flasher,a0
	calla	existp	      		; flasher proc running ?
	jreq	up9			; no

	movi	flash_pmsg2,a7
	calla	fastxfer		; yes, start him over again

up9	mmfm	sp,a0,a1,a2,a3,a4,a5
	rets


stuff_info
	move	a5,*a0(32*3),l		; zero size so dirq wont mess with us
	move	a3,*a0,l		; control:offset
	move	a2,*a0(32*1),l		; sag
	move	a4,*a0(32*2),l		; stuff y:x coordinates
	move	a1,*a0(32*3),l		; stuff y:x size (also says go to dirq)
	rets

start_or_insertcoin
	movi	INSERTCOIN,a0
	calla	cr_strtp		; enough credits 2 start ?
	jrlo	soic9			; no
	movi	PUSHSTART,a0
soic9	rets
	

grab_oimg_data
	move	*a0(isize),a1,l
	move	*a0(isag),a2,l
	move	*a0(icontrol),a3,w
	ori	dmawnz,a3
	sll	16,a3
	rets


clock_nums
	.long	REDFONT0
	.long	REDFONT1
	.long	REDFONT2
	.long	REDFONT3
	.long	REDFONT4
	.long	REDFONT5
	.long	REDFONT6
	.long	REDFONT7
	.long	REDFONT8
	.long	REDFONT9

**************************************************************************
*											     *
*  edge_limits - keep both players within limits of our defined universe *
* 											     *
*  input: a8 = player object in question						     *
*											     *
**************************************************************************
edge_limits
	jreq	elim3			; no object there ---> skip

	move	*a8(oxpos),a3,w
	sra	16,a3	     		; a3 = ani x

	move	*a8(oxvel),a9,l
	jreq	elim9			; zero velocity ----> skip
	jrp	elim6
*
* negative velocity / moving left
*
	cmp	a10,a3			; compare with left edge
	jrhi	elim3			; higher = cool
	jreq	elim4			; equal  = no moving left allowed

elim0	move	a10,a5
	sub	a3,a5			; a5 = how far off we iz
elim1	move	a8,a7
elim2	move	*a7(oxpos),a0,w
	add	a5,a0
	move	a0,*a7(oxpos),w		; too far left = adjust back to edge
	move	*a7(oslink),a7,l
	jrne	elim2
elim4	clr	a0
	move	a0,*a8(oxvel),l		; too far left = zero x vel
elim3	rets

*
* positive velocity / moving right
*
elim6	cmp	a11,a3			; compare with right edge
	jrlo	elim3			; lower = cool
	jreq	elim4			; equal  = no moving left allowed
elim7	sub	a11,a3
	move	a3,a5			; a5 = amount to adjust x left
	neg	a5
	jruc	elim1
*
* zero velocity
*
elim9	cmp	a10,a3			; compare with left edge
	jrlt	elim0			; too far left ---> adjust (neg=left)
	cmp	a11,a3			; compare with right edge
	jrhi	elim7			; too far right ---> adjust
	rets

**************************************************************************
*												*
*  yzsort - sort object list in z:y priority						*
*												*
*  sorts both object lists independently now (ejb)					*
*												*
**************************************************************************
yzsort:
	mmtm	sp,a0,a1,a2,a4,a5,a7,a8
	movi	objlst,a0
	callr	sort_list		; sort object list #1
	movi	objlst2,a0
	callr	sort_list		; sort object list #2
	movi	objlst3,a0
	callr	sort_list		; sort object list #3
	mmfm	sp,a0,a1,a2,a4,a5,a7,a8
	rets
*
* sort subroutine:
* input: a0 = object list to sort
*
sort_list
	movi	080000000h,a1		; lowest possible z
	movi	080000000h,a5		; lowest possible y
	move	*a0,a2,l
	jrne	yzlp0			; list not empty = sort away
	rets				; list is empty = return

yzlp0	move	*a2(ozval),a8,l		;test z
	move	*a2(oyval),a7,l		;test y
	cmp	a1,a8
	jrgt	priok
	jrlt	priswap

	cmp	a5,a7
	jrge	priok

priswap	pushst
	dint
	move	a2,*a4,l
	move	*a2,*a0,l
	move	a0,*a2,l
	popst
	move	a2,a4
	jruc	yzlp

priok	move	a0,a4
	move	a2,a0
	move	a8,a1
	move	a7,a5

yzlp	move	*a0,a2,l	; current link in a2, prev in a4
	jrne	yzlp0
	rets

**************************************************************************
*												*
*  scrtst - test if an object is on screen 						*
*												*
*  input: a8 = object to test	  returns: eq if on screen			*
*												*
**************************************************************************
*
* enter here and provide your own screen boundries
*
scrtstg	mmtm	sp,a0,a1,a2,a3
	jruc	scrtst1
*
* normal screen boundaries
*
scrtst	mmtm	sp,a0,a1,a2,a3	
	move	@scrntl,a2,l		;get screen top left
	move	@scrnlr,a3,l		;get screen lower rt.

scrtst1	move	*a8(oypos),a0,w
	move	*a8(oxpos),a1,w
	sll	16,a0
	movx	a1,a0			; a0 = top left [y,x] of object

	move	@worldtly,a1,l
	move	@worldtlx+16,a4
	movx	a4,a1			; a1 = packed worldtl [y,x]

	subxy	a1,a0			; subtract out world base
	move	*a8(osize),a1,l
	addxy	a0,a1			;get lower rt of object

	cmpxy	a3,a0			;is it lower than lower rt?
	jryge	scrtf			;lower
	jrxge	scrtf			;to the right

	cmpxy	a2,a1
	jryle	scrtf			;above...
	jrxle	scrtf			;to the left..

	clr	a0
	jruc	scrtx			;return eq (on screen)
scrtf:
	movk	1,a0
	move	a0,a0			;return ne (not on screen)
scrtx:
	mmfm	sp,a0,a1,a2,a3
	rets

**************************************************************************
*											     *
*  oinit - Initialize object system							     *
*											     *
**************************************************************************
oinit	mmtm	sp,a0,a1,a2,a3,a4,a5

	pushst
	dint
	move	@intenb,a0,w
	andni	x1e,a0			;no more dma interrupts
	move	a0,@intenb,w
	popst

	movi	zero_words_oinit,a1
	calla	zero_table_o_words

	movi	zero_longs_oinit,a1
	calla	zero_table_o_longs

	calla	dmawait			;wait on dma
	move	a0,@dmacmap,w

	movi	-1,a0
	move	a0,@swtemp1,l
	move	a0,@swtemp2,l
	move	a0,@swtemp3,l
	move	a0,@swtemp4,l		; all previous switch states = open

**************************************************************************
*											     *
*  setup last 2 lines of bitmap for autoerase color				     *
*											     *
**************************************************************************

	movi	510*512*8,a1		;store to last 2 lines of bitmap
	movi	erasecol,a14		;color pair
	movi	512*8*2/16,b0
lp	move	a14,*a1+
	dsj	b0,lp

	calla	clrpal			; clear palette ram

	movk	1,a0
	move	a0,@f_auto_erase,w

	movi	boonpal,a0
	calla	getfpal 		; palette #1
	mmfm	sp,a0,a1,a2,a3,a4,a5

	calla	bakclr			; clear background !!

	mmtm	sp,a0,a1,a2,a3	; save reg		
	movi	nobj,a3		; # of object blocks to init

	movi	scrnst,a0,l	; init screen top left [y,x]
	move	a0,@scrntl,l
	move	a0,@scrntl2,l

	movi	scrnend,a0,l	; init screen lower right [y,x]
	move	a0,@scrnlr,l
	move	a0,@scrnlr2,l

	movi	dmaq+qsize,a1
	move	a1,@dmaqcur,l		; init misc dma queue

; removed 7/6/93
;	pushst
;	dint
;	move	@intenb,a0,w
;	andni	x1e,a0		; no more dma interrupts
;	move	a0,@intenb,w
;	popst

	movi	objstr,a1,l
	move	a1,@ofree,l		;setup free list

oinitl	move	a1,a2
	addi	obsiz,a1,w
	move	a1,*a2,l		; link em up
	dsjs	a3,oinitl		; continue for nproc
	move	a0,*a2,l		; zero last link
	mmfm	sp,a0,a1,a2,a3		; restore regs

**************************************************************************
*											     *
*  init_dma_regs - Initialize dma registers where:				     *
* 											     *
*   a1 = dirq queue pointer								     *
* 											     *
*  b11 = dmaregs	(dedicated)									*
*  b12 = intenb	(dedicated)									*
*  b13 = counter										     *
*  b14 = dma int queue pointer								     *
*											     *
**************************************************************************
init_dma_regs
	clr	b8			; 1st shadow queue spot pointer
	movi	x1e,b9			; dedicated for speed	
	movi	dmaregs,b11		; dedicated for speed
	movi	intenb,b12		; dedicated for speed
	movi	objq_1,a1		; a1 = object queue entry #1 (dirq)
	move	a1,b14
	clr	b13			; b13 = queue count
	rets


zero_words_oinit
	.long	f_novel
	.long	f_auto_erase
	.long	f_shadows
	.long	noflip
	.long	f_skew
	.long	skew_y
	.long	skew_height
	.long	skew_stack
	.long	0

zero_longs_oinit
	.long	call_every_tick
	.long	dlists
	.long	skew_oc
	.long	skew_sag
	.long	skew_constpal
	.long	skew_dx

	.long	p1_shape
	.long	p2_shape
	.long	p1_obj
	.long	p2_obj
	.long	worldtly
	.long	worldtlx

	.long	objlst
	.long	objlst2
	.long	objlst3
	.long	baklst1
	.long	baklst2
	.long	baklst3
	.long	baklst4
	.long	baklst5
	.long	baklst6
	.long	baklst7
	.long	baklst8
	.long	scrolly
	.long	scrollx
	.long	scrollx2
	.long	scrollx3
	.long	scrollx4
	.long	scrollx5
	.long	scrollx6
	.long	scrollx7
	.long	scrollx8

	.long	p1_xvel
	.long	p2_xvel
	.long	0

**************************************************************************
*												*
* getobj - get a free object block for use							*
*												*
* returns: a0 = ptr to object block								*
* if no blocks were available then the z flag is set					*
*												*
**************************************************************************
getobj	mmtm	sp,a1,a2
	move	@ofree,a0,l	; pointer to next available obj block
	jreq	getox
	move	*a0,a2,l
	move	a2,@ofree,l	; adjust pointer to free list

	clr	a2		; used for zero-ing object data
	movi	(obsiz/16)-2,a1
	addk	32,a0
	srl	1,a1
	jrnc	getobj1
	move	a2,*a0+,w
getobj1	move	a2,*a0+,l
	dsjs	a1,getobj1
	subi	obsiz,a0 	; restore a0, set non zero flag

	movi	>01000100,a2
	move	a2,*a0(oscale),l	; default scale = 100 / 100

getox	mmfm	sp,a1,a2 	; dont screw up z-flag
	rets

**************************************************************************
*												*
*  insert an object block into an object list						*
*												*
*  list is sorted by increasing z and increasing y within constant z	*
*												*
*  input: a0 = object block to be inserted 						*
*												*
**************************************************************************

*
* insert an object onto object list #3 (sorted)
*
insobj3	mmtm	sp,a1,a2,a3,a4,a5
	movi	objlst3,a4
	jruc	insobj0
*
* insert an object onto object list #2 (sorted)
*
insobj2	mmtm	sp,a1,a2,a3,a4,a5
	movi	objlst2,a4
	jruc	insobj0
*
* insert background object (sorted)
*
insbobj	mmtm	sp,a1,a2,a3,a4,a5
	movi	baklst1,a4
	jruc	insobj0

**************************************************************************
*											     *
*  insobj_v - insert background object on a variable list		     	*
* 											     *
*  input: b4 = object list to add to !						     *
*											     *
**************************************************************************
insobj_v
	mmtm	sp,a1,a2,a3,a4,a5
	move	b4,a4			; he wants it in a4
	jruc	insobj0

*
* insert object into object list #1
*
insobj:
	mmtm	sp,a1,a2,a3,a4,a5
	movi	objlst,a4

insobj0	move	*a0(ozval),a1,l		; get z position
	move	*a0(oyval),a5,l		; get y position

ins_loop move	a4,a2			; ptr to prev in a2
	move	*a2,a4,l		; ptr to next in a4
	jreq	ins_at_end		; bra if at end of list
	move	*a4(ozval),a3,l		; zpos in a3
	cmp	a3,a1
	jrgt	ins_loop
	jrlt	ins_at_end

	move	*a4(oyval),a3,l		;test y position
	cmp	a3,a5
	jrgt	ins_loop
ins_at_end:
	move	a4,*a0,l		; put next link in new block
	move	a0,*a2,l		; put link to new in prev block
	mmfm	sp,a1,a2,a3,a4,a5
	rets


delobj3
	mmtm	sp,a0,a2,a3,a4,a8
	movi	objlst3,a4
	jruc	del_loop

delobj2
	mmtm	sp,a0,a2,a3,a4,a8
	movi	objlst2,a4
	jruc	del_loop

*
* a0 = object
* a4 = object list to delete from
*
delobj_lista4
	mmtm	sp,a0,a2,a3,a4,a8
	jruc	del_loop



*
* delete foreground object
*
delobj:
	mmtm	sp,a0,a2,a3,a4,a8
	movi	objlst,a4
del_loop
	move	a4,a2		; ptr to prev in a2
	move	*a2,a4,l	; ptr to next in a4
	jrnz	del_chk
	lockup
	jruc	delobjx

del_chk
	cmp	a4,a0
	jrne	del_loop
	
	move	*a0,*a2,l	; put next link in prev block
	move	@ofree,a2,l				
	move	a2,*a0,l
	move	a0,@ofree,l	; return deleted block to free stack

delobjx
	mmfm	sp,a0,a2,a3,a4,a8
	rets
**************************************************************************
*												*
* kill a class of objects						 			*
* a0=oid (16 bits) ,a1=mask (16 bits)					 			*
* mask bits of zero are dont cares					 			*
*												*
**************************************************************************

*kill a class from the background
;kilbobj
;	mmtm	sp,a0,a2,a3,a4,a5
;	movi	baklst,a2,l
;	jruc	kilgen


**************************************************************************
*											     *
*  Kill an object from list #2								     *
*											     *
**************************************************************************
kilobj2
	mmtm	sp,a0,a2,a3,a4,a5
	movi	objlst2,a2,l
	jruc	kilgen

**************************************************************************
*											     *
*  Kill an object from list #1								     *
*											     *
**************************************************************************
kilobj
	mmtm	sp,a0,a2,a3,a4,a5
	movi	objlst,a2,l

kilgen
	and	a1,a0		;form match

kilobp:	
	move	a2,a3		;save previous
	move	*a2,a2,l	;get next
	jreq	kilobx		;all done
	move	*a2(oid),a4
	and	a1,a4		;can dont care bits
	cmp	a0,a4		;match?
	jrne	kilobp		;no

	move	*a2,*a3,l	;link around in active list	
	move	@ofree,a5,l	;link into free list at start
	move	a5,*a2,l
	move	a2,@ofree,l	;point free to cell
	move	a3,a2
	jruc	kilobp		;kill the rest
kilobx:	
	mmfm	sp,a0,a2,a3,a4,a5
	rets

**************************************************************************
*												*
* existobj - does an object from a certain class exist?				*
* a0 = oid											*
* a1 = mask (0's don't care)									*
* returns:											*
*	z bit set = no object, a0 = 0							*
*	z bit clr = no object, a0 = ptr to object					*
*												*
**************************************************************************
existobj
	mmtm	sp,a2,a3
	sext	a0
	and	a1,a0		; form match
	movi	objlst,a2,l
	callr	existobp	; try object list #1
	movi	objlst2,a2,l
	callr	existobp	; try object list #2
	jruc	existo3 	; object ain't out there....

existobp	move	*a2,a2,l	; get next
	jreq	existo4 	; end of list ---> return
	move	*a2(oid),a3,w
	and	a1,a3		; can dont care bits
	cmp	a0,a3		; match?
	jrne	existobp	; no
	pull	a0		; pull return address off stack
	move	a2,a0		; return a0 = found object (non-zero)
existo3	mmfm	sp,a2,a3
existo4	rets

**************************************************************************
*												*
* isobj - is an object on the object list? 						*
* a0 = ptr to object										*
* returns:											*
*	z bit set = no object, a0 = 0							*
*	z bit clr = no object, a0 = ptr to object					*
*												*
**************************************************************************
isobj:	
	push	a2
	movi	objlst,a2,l
	jruc	isobp
**************************************************************************
*												*
* isfree - is an object on the free list?							*
* a0 = ptr to object										*
* returns:											*
*	z bit set = no object, a0 = 0							*
*	z bit clr = no object, a0 = ptr to object					*
*												*
**************************************************************************
isfree:	
	push	a2
	movi	ofree,a2,l
	jruc	isobp
isobp:	
	move	*a2,a2,l	;get next
	jreq	isobx		;all done
	cmp	a0,a2		;object?
	jrne	isobp		;no
	move	a0,a0		;clr z bit
isobx:
	pull	a2
	rets

**************************************************************************
*												*
* ganisag - adjust current object image with respect to it's		     *
*	   animation pnt. and flip flags							*
*												*
* note: call only after initializing with stfobj, or something.		*
*												*
* a0 = ptr to object block									*
* a2 = new oyval											*
* a3 = new oxval											*
* a4 = new flags											*
* returns											*
* a2 = adjusted oyval										*
* a3 = adjusted oxval										*
*												*
**************************************************************************
ganisag
	mmtm	sp,a1,a4,a6,a7
	mmtm	sp,a2,a3
	move	*a0(oimg),a1,l
	callr	gsagof
	move	a3,*a0(osag),l
	move	a2,*a0(osize),l
	move	a4,*a0(oflags),l
	callr	ganiof
	mmfm	sp,a2,a3
	sub	a6,a3	
	sub	a7,a2			;adjust upper left corner
	move	a3,*a0(oxval),l
	move	a2,*a0(oyval),l
	mmfm	sp,a1,a4,a6,a7
	rets

**************************************************************************
*											     *
*  bkgsagof - special version of gsagof for backgrounds with no animatio *
*											     *
**************************************************************************
bkgsagof:
	move	*a1(isag->20),a3,l	; get top left sag (-20 -> no ani off)
	zext	a4,w			; zero offset in a4
	move	*a1(>40),a2,w		; grab backgrounds control offset info
	or	a2,a4			; stuff into flags
	jruc	gsag3

**************************************************************************
*											     *
* gsagof - get sag for object - adjusts sag for flip				     *
* 											     *
* input: a1 = ptr to image header (oimg)						     *
* 	a4 = object flags								     *
* 											     *
* returns: a2 = returned with new osize						     *
* 	  a3 = returned with new sag							     *
* 	  a4 = returned with new offset:oflags					     *
*											     *
**************************************************************************
gsagof
	move	*a1(isag),a3,l		; get top left sag
	zext	a4,w			; zero offset in a4
	move	*a1(icontrol),a2,w	; grab control info
	or	a2,a4			; stuff into flags
gsag3	move	*a1(isize),a2,l
	rets


;****************************************
badani
	.if debug
	dint
	jruc	$
	.endif
	jruc	anigx			; ignore bad ani calls
;****************************************



ani_flag
	move	*a8(oflags),a4,w

**************************************************************************
*												*
* ani - animation subroutine									*
* a1=new image pointer										*
* a4=new oflags											*
* a8=object structure pointer to be updated						*
*												*
**************************************************************************
ani	mmtm	sp,a0,a2,a3,a4,a5,a6,a7,a9

;*************************************
	cmpi	rom,a1
	jrlo	badani
;*************************************

	andi	dmago|dmaclp|m_fliph|m_flipv|>0f,a4	; keep flip info and dma info
	move	*a1(icontrol),a2,w
	or	a2,a4

	move	*a8(oflags),a5,w
	move	*a8(oimg),a3,l
	cmp	a1,a3
	jrne	anig1			; br = not the same image as last time

	zext	a4
	zext	a5
	cmp	a4,a5
	jreq	anig2		;br = every thing is the same

anig1	swap	a4,a5
	swap	a1,a3
	move	*a8(osize),a2,l
	callr	ganiof		;get old animation offset
	mmtm	sp,a6,a7
	move	a5,a4		;new oflags
	move	a3,a1		;new oimg

	callr	gsagof		;get sag, offset, hw
	callr	ganiof		;get new animation offset
	mmfm	sp,a0,a5	;bring back old animation delta
	sub	a6,a0		;subtract new from old
	sub	a7,a5

	move	a2,*a8(osize),l
	move	a3,*a8(osag),l
	move	a4,*a8(oflags),w

;	move	a8,a9			;get push address of oflags,osag,osize
;	addi	oflags+>60,a9
;	mmtm	a9,a2,a3,a4		;blow this stuff out

	move	a1,*a8(oimg),l

	move	*a8(oyval),a6,l
	add	a5,a6			;adjust oyval, oxval for delta x
	move	a6,*a8(oyval),l
	move	*a8(oxval),a7,l
	add	a0,a7
	move	a7,*a8(oxval),l

anigx
	mmfm	sp,a0,a2,a3,a4,a5,a6,a7,a9
	rets

anig2

;	move	*a8(ozvel),*a0(oyvel),l
;	move	*a8(ozvel),*a0(ozvel),l
	move	*a8(oxvel),*a0(oxvel),l	;copy just the velocities
	jruc	anigx

**************************************************************************
*											     *
*  ani0											     *
* 											     *
*  same as ani except this does not check for repeating images		     *
*											     *
**************************************************************************
ani0	mmtm	sp,a0,a2,a3,a4,a5,a6,a7,a9
	move	*a8(oflags),a5,w

;*****************
;	move	*a8(oimg),a2,l
	move	*a8(oimg),a3,l
;*****************

	jruc	anig1

**************************************************************************
*												*
*  get animation offset										*
*  a1=oimg, a2=h:w, a4=oflags									*
*												*
*  output:											*
*  a6=x animation offset x 64k									*
*  a7=y animation offset x 64k									*
*												*
**************************************************************************
ganiof:	
	mmtm	sp,a2,a3
	move	*a1(ianioff),a6,l		
	clr	a7		;make sure a7 is 0
	movy	a6,a7
	sll	16,a6		;move to upper word		
	subi	>00010001,a2	;adjust for -1
	clr	a3
	movy	a2,a3
	sll	16,a2		;move to upper word
	btst	b_fliph,a4
	jrz	gani1
	neg	a6
	add	a2,a6		;sub ths-1 for h-flip
gani1:
	btst	b_flipv,a4
	jrz	gani2
	neg	a7
	add	a3,a7		;sub tvs-1 for v-flip
gani2:
	mmfm	sp,a2,a3
	rets

**************************************************************************
*												*
*		   dma queue support routines						*
*												*
**************************************************************************
*
* qdma puts image on dma q
* inputs:
* a1: constant color:palette
* a3: destination y:x
* a5: offset:control
* a14: address of image header
* gets: a2=h/w; a4=sag
*
qdma
	mmtm	sp,a2,a4,a13
	move	*a14,a2,l		;get vsize:hsize
	move	*a14(isag),a4,l		;get sag
qdma1	movk	1,a13
	move	a13,@qdmaflg,w		;q being modified
	move	@dmaqcur,a13,l
	cmpi	dmaq,a13
	jrls	qdmax			;q overload, can it

	mmtm	a13,a1,a2,a3,a4,a5
	move	a13,@dmaqcur,l
	clr	a13
	move	a13,@qdmaflg,w
qdmax	mmfm	sp,a2,a4,a13
	rets


*manual dma (setup your own regs)
*inputs:
*a1: constant color:palette
*a2: vsize:hsize
*a3: destination y:x
*a4: sag
*a5: offset:control
qdman:
	mmtm	sp,a2,a4,a13
	jruc	qdma1

**************************************************************************
*                                                                        *
* dman - manual dma, all regs must be setup upon calling		 		*
* a1 = [constant color,palette]						 			*
* a2 = size [h,w]							 			*
* a3 = destination [y,x]						 				*
* a4 = starting address							 			*
* a5 = [offset,control]							 			*
*                                                                        *
**************************************************************************
dman
	jruc	qdman

**************************************************************************
*											     *
*  Cache aligned code #2 - Shadow code						     *
*											     *
**************************************************************************

;	.sect	"SHADORG"

**************************************************************************
*											     *
*   shadow_a8 - Does multipart shadows THE HARD WAY. Using		     *
* 											     *
*   a5 = page offset to add to coordinates							*
*   a8 = y:x coordinates										*
*   a9 = multipart ram pointer								     *
*  a10 = sag pointer									     *
*  a11 =	x size of piece									     *
*  a13 = scratch											*
*  a14 = control:offset									     *
* 											     *
*   b1 = lead multiplier									     *
*   b2 = ground y										*
*   b3 = counter											*
*   b4 = ani y:x										     *
*   b5 = line counter										*
*											     *
**************************************************************************
shadow_p1p2
	movi	>01000100,a2
	move	a2,@dmaxscl,l	 	; dma input #1 = scale
	movi	bpal_black*>10000,a2
	move	a2,@dmacmap,l	    	; dma input #2 = const:palette
*
* setup dedicated registers
*
*  b0 = dmactrl
*  b1 = worldtly
*  a2 = dma y:x size pointer
*  a3 = dma control:offset
*  a6 = dma y coordinate pointer
* a12 = dma sag pointer
*
	movi	dmahsize,a2		; a2 = faster dma y:x size

;**********
;newshad
	movk	1,a8
;	movk	2,a8
;**********

	move	a8,*a2(16),w		; y size is always "1"
	movi	dmaoffst,a3
	clr	a8
	move	a8,*a3+,w     		; offset is always "0"
	movi	dmavert,a6
	movi	dmahoriz,a7
	movi	dmasagl,a12

	movi	dmactrl,b0
	move	@worldtly,b1,l
	move	@ceiling_y,b6,w		; ceiling y

	move	@p2_shadadj,b7,w	; player 2 shadow adjust y
	push	b7
	move	@p1_obj,a8,l
	move	@p1_shadadj,b7,w	; player 1 shadow adjust y
	jruc	shadorg

	.sect	"SHADORG"

shadorg	callr	shad0
	move	@p2_obj,a8,l
	pull	b7

shad0	move	*a8(oflags2),a0,w
	btst	b_shadow,a0		; shadow ?
	jreq	shad9			; no

	move	*a8(oimg),a9,l		; a9 ---> multipart ram
	move	*a8(oypos),a13,w
	move	*a8(oxpos),a0,w
	zext	a0,w
	sll	16,a13
	or	a13,a0			; a0 = ani y:x for all pieces (world)

	move	b1,a14			; a14 = worldtly
	move	@worldtlx+16,a13,w

;************ fix elevated shadows
	zext	a13,w			; clear out the Y in case x = neg
;************ fix elevated shadows

	or	a14,a13			; a13 = world y:x
	subxy	a13,a0
	move	a0,b4			; b4 = ani y:x (screen coordinates)

	move	@ground_y,a14,w
	sll	16,a14
	subxy	a13,a14			; a14 = [screen ground y,??]
	move	a14,b2
	srl	16,b2
	add	b7,b2			; personal adjust for each ochar
	sll	16,b2			; b2 = [screen ground y,0]

**************************************************************************
*											     *
*  piece by piece loop									     *
*											     *
**************************************************************************

shad2	move	*a9(mp_sag),a10,l	; a10 = sag of this piece
	jreq	shad9			; sag = 0 ---> we are done

	addi	>2000000,a10		; cpu read = add 2 mil

	move	b4,a0			; get ani y:x
	move	*a9(mp_anixy),a13,l
	subxy	a13,a0			; a0 = y:x of this piece

	move	b2,a13			; a13 = [ground y,0]
	subxy	a0,a13			; a13 = [distance from ground,??]
	srl	16,a13

	sll	16-2,a13	  	; a13 = [1/4 distance,0]

	move	b2,a14			; a14 = [ground y,0]
	subxy	a13,a14			; a14 = [shadow y,0]

	movy	a14,a0			; a0 = shadow [1/4 y:x]

	move	*a9(mp_sizey),a13,w	; a13 = # of lines
	srl	2,a13			; shadows are 1/4 the normal height

	move	a13,b5

	move	*a9(mp_sizex),a11,w
	move	a11,*a2,w		; set a11 = x size for this piece

	move	*a9(mp_control),a14,w
	btst	b_fliph,a14		; flip horizontal ?
	jreq	shad1
	addxy	a11,a0			; yes, adjust coordinates for flip
	dec	a0			; and nudge..

shad1	move	a14,a1
	move	a14,a4

	sll	16+4,a1
	srl	32-2,a1			; a1 = trail multiplier
	sll	16+4+2,a4
	srl	32-2,a4			; a4 = lead multiplier

	ori	dmacnz,a14

	addxy	a5,a0
	move	a0,*a7,w		; set x coordinate here !!
	srl	16,a0

**************************************************************************
*											     *
*  line by line loop									     *
*											     *
**************************************************************************

shad4
shad3	move	*b0,b3,w
	jrn	shad3 	      	; wait for dma while busy

	subi	>2000000,a10
	move	a10,*a12,l	; stuff sag
	addi	>2000000,a10

	move	a0,*a6,w      	; set y coordinate
	move	a14,*a3,w     	; set the GO! bit
	dsjs	b5,shad5

**************************************************************************
*											     *
*  do the last line again to fill in "holes"					     *
*											     *
**************************************************************************
	inc	a0
	move	a0,*a6,w	; set y 1 line down
	dec	a0

shad6	move	*b0,b3,w
	jrn	shad6	    	; wait for dma while busy

	move	a14,*a3,w	; set the GO
	addi	mp_length,a9   	; a9 ---> next multipart piece
	jruc	shad2
*
* skip 4 lines
*
shad5	move	*b0,b3,w
	jrn	shad5	 	; wait for dma while busy

	inc	a0
	movk	4,b3
 	setf	8,0,0	 	; field 0 is 8 bits (zero extend)

shad7	move	*a10+,a8,w	; grab a BYTE !!

	move	a8,a13
	sll	32-4,a13
	srl	32-4,a13	; mask off upper b.s.
	sll	a4,a13		; a13 = lead zeros

	srl	4,a8		
	sll	a1,a8		; a8 = trailing zeros

	add	a8,a13		; a13 = lead + trailing = all compressed zeros
	move	a11,a8		; a8 = x size
	sub	a13,a8		; a8 = uncompressed pixels to skip

	sll	1,a8  		; 2x
	add	a8,a10
	sll	1,a8  		; + 4x = 6 bits per pixel
	add	a8,a10		; a10 ---> sag for next line
	dsjs	b3,shad7

	setf	16,1,0		; field 0 is back to 16 bits
	jruc	shad4

shad9	rets


;************** (2)
;	move	@intenb,a0,w
;	andni	x1e,a0
;	move	a0,@intenb,w 	  	; disable dma interrupts
;************** (2)

;*************** (1)
; 	setf	1,0,0				; field 0 is 1 bit
;	movk	1,a2
;	move	a2,@(intenb+b_x1e),0		; enable dma interupt
;	setf	16,1,0
;*************** (1)


**************************************************************************
*											     *
*  Cache aligned code #2 - Shadow code						     *
*											     *
**************************************************************************

	.sect	"FLOORORG"

**************************************************************************
*											     *
*   floor code											*
* 											     *
*   a0 = floor_x                      b0 = DON'T TOUCH !			     *
*   a1 = dma queue pointer            b1 = DON'T TOUCH !			     *
*   a2 = scale                        b2 = DON'T TOUCH !			     *
*   a3 = const:pal                    b3 = loop counter			     *
*   a4 = piece #2 y:x size            b4 = loop counter			     *
*   a5 = DONT TOUCH                   b5 = sag holder (for a8)		     *
*   a6 = piece #1 y:x size            b6 = [1,x] size holder (for a6)    *
*   a7 = piece #1 y:x coordinates     b7 = unused				     *
*   a8 = sag										     *
*   a9 = control:offset									     *
*  a10 = skew x (running x)								     *
*  a11 = skew dx										     *
*  a13 = scratch										     *
*  a14 = piece #2 y:x coordinates							     *
* 											     *
*  a12 = running y									     *
*											     *
**************************************************************************
floor_x	.set	1200

floor_code
	move	@f_skew,a2,w		; skew the ground ?
	jreq	kib9			; no
	mmtm	sp,a3,a14
*
* scroll the floor
*
	move	@skew_scroll,a9,l
	move	*a9,a9,l
	move	@skew_oc,a10,l
	sub	a9,a10
	move	a10,@skew_oc,l		; scroll "OFF CENTER" indicator !!

	move	@skew_calla,a0,l
	jump	a0
skew_rets				; a11 = dx per line
	move	a11,@skew_dx,l

	move	@worldtly+16,b6,w
	move	@ceiling_y,b3,w
	sub	b6,b3 			; b3 = # of pixels above ceiling
	move	@skew_y,b6,w
	add	b3,b6 			; adjust starting y
	sll	16,b6
	move	b3,b3
	jrnn	floor5
	clr	b3    			; don't ADD to # of lines to DMA out
floor5	move	@skew_height,b4,w	; # of lines in block
	sub	b3,b4
	jrn	floor_exit
	jreq	floor_exit		; no lines ----> exit

	move	@skew_sag,a8,l
*
* CONSTANTS !!
*
	movi	>01000100,a2		; scale
	move	@skew_constpal,a3,l	; const:pal
	movi	>00010190,a6		; y:x size
	movi	>e0020000,a9		; conrtol:offset
*
*  a10 = how far off center we are !
*  a11 = skew value to add for EACH LINE
*
floor6	move	b6,a13
	clr	a7
	movy	a13,a7	     	 	; move current y into a7
	addxy	a5,a7			; a7 = piece #1 y:x coordinates

	move	a8,a12
	move	a10,a13
	sra	16,a13	     	 	; a13 = pixels off center (integer)
	sll	1,a13
	move	a13,a0
	sll	1,a13
	add	a13,a0			; a0 = 6 bits/pixel
	sub	a0,a8			; adjust sag
	mmtm	a1,a2,a3,a6,a7,a8,a9	; floor piece ---> on the queue
	inc	b13

	move	a12,a8			; restore sag

	addi	floor_x*6,a8	  	; beginning of next line
	add	a11,a10			; start skew on line two
      	addi	>00010000,b6		; down 1 line
	dsj	b4,floor6

floor_exit
	mmfm	sp,a3,a14
	rets

**************************************************************************

	.if bog_line

**************************************************************************
*											     *
* q_bogline										     *
* 											     *
* draw_bogline -  debugging routine to draw a line across the screen at  *
*                 point where vblank currently is				     *
* 											     *
*  Input: a3 = color of line								     *
*											     *
**************************************************************************
q_bogline
	callr	bogl2
	inc	b13				; count it
	rets

draw_bogline
	push	a1
	move	b11,a1				; dmaregs	
	callr	bogl2
	pull	a1
	rets

bogl2	mmtm	sp,a2,a5
	move	@pageaddr,a5,l
	movi	>01000100,a2
	move	a2,-*a1,l			; #1 = scale xx
	move	a3,a2
	move	a2,-*a1,l			; #2 = const:pal
	movi	>00010180,a2
	move	a2,-*a1,l			; #3 = y:x size
	move	@vcount,a2,w
	sll	16,a2
	addxy	a5,a2
	move	a2,-*a1,l			; #4 = y:x coordinates
	movi	>3000000,a2
	move	a2,-*a1,l			; #5 = sag
	movi	>900c0000,a2
	move	a2,-*a1,l			; #6 = control:offset
	mmfm	sp,a2,a5
	rets

	.endif

battle_numbers
	.long	BATTLE0
	.long	BATTLE1
	.long	BATTLE2
	.long	BATTLE3
	.long	BATTLE4
	.long	BATTLE5
	.long	BATTLE6
	.long	BATTLE7
	.long	BATTLE8
	.long	BATTLE9

	.long	BATTLE
	.long	BADGE2

;**********************************************************************

	.end


