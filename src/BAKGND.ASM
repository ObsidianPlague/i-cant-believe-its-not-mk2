	.file	'bakgnd.asm'
	.title	" <<< mortal kombat  -- background handlers >>>"

**************************************************************************
*												*
*	copyright (c) 1992 williams electronics games, inc.		 	*
*	all rights reserved.						 			*
*												*
**************************************************************************

	.option	b,d,l
	.mnolist

	.include	dispequ.asm
	.include	"sysequ.asm"
	.include	"macros.hdr"			; macros, yeah!
	.include	"mainequ.asm"
	.include	"bgndtbl.glo"		; background equates


	.bss	bgndpaltbl,32,1
;	.bss	mod_pos,32,1

	.bss	bak1bits,100*32,1
	.bss	bak2bits,100*32,1
	.bss	bak3bits,100*32,1
	.bss	bak4bits,100*32,1
	.bss	bak5bits,100*32,1
	.bss	bak6bits,100*32,1
	.bss	bak7bits,100*32,1
	.bss	bak8bits,100*32,1

	.bss	bak1mods,32,1
	.bss	bak2mods,32,1
	.bss	bak3mods,32,1
	.bss	bak4mods,32,1
	.bss	bak5mods,32,1
	.bss	bak6mods,32,1
	.bss	bak7mods,32,1
	.bss	bak8mods,32,1
	.bss	end_of_bakram,0,1

	.text

*background updater equates
blststrt	.equ	>8000
blstend	.equ	>8001

************* local constants for upd **************
disp_pad 	.set	>00300030	  ; y:x
widest_block	.set	250

;* must keep the size of these structures a multiple of 16
map_zflagspal	.set 0
map_pal		.set 0		;size 4 - palette select
map_flags	.set 4		;size 4 - bit 0 hflip, bit 1 yflip
map_z		.set 8		;size 8
map_x		.set 16		;size 16
map_y		.set 32		;size 16
map_hdr		.set 48		;size 16 - offset in long words from block_hdr_tbl
				; bits 12-15 are bits 4-7 of pal
				; map_hdr set to >ffff if block is not allocated
block_size	.set 64		;* if changed must get rid of shifts by 6

**************************************************************************
*											     *
*  offsets for a block hdr structure							     *
*											     *
**************************************************************************
map_size	.set	0
map_w		.set	0	;size 16	  ; these fields can't be changed
map_h		.set	16	;size 16	  ; because they are used as the
map_dataptr	.set	32	;size 32	  ;
block_hdr_size	.set	64

**************************************************************************
*											     *
*  bakclr - clear out background data structure					     *
*											     *
**************************************************************************
bakclr
	mmtm	sp,a0,a1
	movi	bgndpaltbl,a0

	clr	a1
	move	a1,@baklst1,l
	move	a1,@baklst2,l
	move	a1,@baklst3,l
	move	a1,@baklst4,l
	move	a1,@baklst5,l
	move	a1,@baklst6,l
	move	a1,@baklst7,l
	move	a1,@baklst8,l

bakclrl	move	a1,*a0+,l
	cmpi	end_of_bakram,a0
	jrne	bakclrl

	movi	dumbgnd,a1
	movi	bak1mods,a0
bakcl4	move	a1,*a0+,l
	cmpi	end_of_bakram,a0		; put in "dumb backgrounds"
	jrne	bakcl4

	clr	a0
	calla	set_all_worldtlx
	calla	stop_scrolling

	mmfm	sp,a0,a1
	rets

**************************************************************************
*											     *
*  dummy (null) background definition. this is global			     *
*											     *
**************************************************************************
dumbgnd
	.long	>ffffffff

**************************** bsrch1stxb ********************************
bsrch1stxb:
;*** parms
;	a0 - x coordinate of a block
;	a1 - start of background block table
;	a2 - end of block table
;*** returns
;	a0 - address of first block with x coordinate >= parm
;		if new x is highest returns next empty block
;		if no blocks with >= x, return 0

;* a0 = x val being searched for
;* a1 = block table base + offset to x val
;* a14 - threshhold for switching from binary to linear search
;* a9 = low # -- # greatest background block
;* a10 = mid # -- (high + low) >> 1
;* a2 = high # -- # of lowest background block

	mmtm	sp,a1,a2,a8,a9,a10
	clr	a9		;* set low = 0
	sub	a1,a2
	srl	6,a2	;* div by size of block (64)
	addi	map_x,a1	;* block tbl base + x offset
	movk	5,a14	;* threshhold for switching from binary to linear search
bsrch:
	move	a2,a10
	sub	a9,a10	;* if (high - low) <= 5 finish with linear search
	cmp	a14,a10
	jrle	lsrch

	srl	1,a10
	add	a9,a10		

	;* get mid->x
	move	a10,a8
	sll	6,a8		;* multiply by block size (64)
	add	a1,a8
	move	*a8,a8,w	;* get x coor of the block
	cmp	a0,a8
	jrlt	blow
	move	a10,a2	;* high = mid
	jruc	bsrch
blow:
	move	a10,a9	;* low = mid
	jruc	bsrch
lsrch:
	;* finish with a linear search of block table from low to high
	;* ending with first block x coor that is >= a0
;* a0 = x val being searched for
;* a9 = low address -- pts to x offset of block
;* a2 = high address -- pts to x offset of block
	sll	6,a9		;* low block # to low block offset
	sll	6,a2		;* high block # to high block offset
	add	a1,a9
	add	a1,a2
	movi	block_size,a8
lsrchlp:
	move	*a9,a10,w	;* x coor
	cmp	a0,a10
	jrge	gotb		;* if low->x >= a0 goto found
	add	a8,a9
	cmp	a2,a9
	jrle	lsrchlp
;* block not found, return 0
	clr	a0
	jruc bsrchdone
gotb:
	;* return a ptr to the block
	move	a9,a0
	subi	map_x,a0

bsrchdone:
	mmfm	sp,a1,a2,a8,a9,a10
	rets

**************************************************************************
*											     *
*  bgnd_ud1 - deletes all display objects which are not			     *
* 	     on the screen insures all background blocks on		     *
* 	     screen are on the disp list						     *
* 											     *
*  input:  worldtl, scrntl, scrnlr, baklst, bakbits, bakmods		     *
* 											     *
*  this protects disp_mod and disp_del too !					     *
*											     *
**************************************************************************
bgnd_ud1
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14
	mmtm	sp,b0

	mmtm	sp,a0,a7
*
* delete offscreen objects
*
;	;* get coors of area to be put on display list.
;	move	@worldtl,a3,1
;	move	a3,a4

	move	@scrntl,a0,1
	addxy	a0,a3		
	move	@scrnlr,a0,1
	addxy	a0,a4		
	movi	disp_pad,a0
	subxy	a0,a3			; a3 - disp_tl
	addxy	a0,a4			; a4 - disp_lr

	move	a8,b4
	callr	disp_del
*
* add objects that have moved on screen
*
	mmfm	sp,a0,a7
	movi	insobj_v,b0
	callr	disp_mod

	mmfm	sp,b0
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14
	rets

*************************************************************************

;bgnd_ud2:		;* call to update secondary background
;;* input, bak2tlx, bak2tly, scrntl, scrnlr, bak2lst, bak2bits, bak2mods
;	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14
;	mmtm	sp,b0
;	;* get coors of area to be put on display list.
;	move	@bak2tlx+16,a3,w
;	move	@bak2tly+16,a0,w
;	sll	16,a0
;	movy	a0,a3
;	move	a3,a4
;	move	@scrntl,a0,l
;	addxy	a0,a3		
;	move	@scrnlr,a0,l
;	addxy	a0,a4		
;	movi	disp_pad,a0
;	subxy	a0,a3			; a3 = disp_tl
;	addxy	a0,a4			; a4 = disp_lr
;	movi	bak2lst,a8		; a8 - bakground list
;	callr	disp_del

;	movi	insb2obj,b0		;b0 - which insert routine
;	move	@bak2mods,a0,l		;* a0- ptr to the module list
;	movi	bak2bits,a7
;	callr	disp_mod
;	mmfm	sp,b0
;	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14
;	rets

*********************** d i s p	 m o d *******************************
;* scan a module list to find out which modules contain blocks
;* which need to be checked for addition to the display list.
;	b0 - which insert routine
;	a0 - module list
;	a3 - disp_tl
;	a4 - disp_lr
;	a7 - bakbits	;a7 - bit table for block being on disp list

;parms for disp_add
;	a1 - background block table
;	a2 - end of background block table
;	a5 - background hdr table
;	a9 - module start position y:x
;	a10 - ptr to palette table for new block
;	    ;passed from above
;	a3 - disp_tl
;	a4 - disp_lr
;	a6 - which bakground insert routine primary|secondary
;	a7 - bit table for block being on disp list

;* caller is responsible for pushing and popping all a-registers

disp_mod:
	clr	a9			;init y:x starting position
	clr	a11			;ending y:x pos
	move	a7,a6			;a6 will point to bakbits after mod

modlp:	
	move	a6,a7
	move	*a0+,a8,l		;load module ptr
	move	*a8+,a10,l		;load y:x size

	move	*a0+,a14,w		;x start position
	zext	a14,w
	cmpi	blststrt,a14
	jrnz	notlaststartx
	move	a11,a14		
	subxy	a10,a14
	jruc	gotnewx
notlaststartx:
	cmpi	blstend,a14
	jrnz	gotnewx
	move	a11,a14
gotnewx:
	move	*a0+,a5,w		;y start position
	zext	a5,w
	cmpi	blststrt,a5
	jrnz	notlaststarty
	move	a11,a5		
	subxy	a10,a5
	jruc	gotnewy
notlaststarty:
	cmpi	blstend,a5
	jrnz	notlastendy
	move	a11,a5
	jruc	gotnewy
notlastendy:
	sll	16,a5
gotnewy:
	movy	a5,a14
	move	a14,a9

	move	a9,a11
	addxy	a10,a11			; a11 is module y:x end
	move	*a8+,a10,w		; load # of blocks
	add	a10,a6			; a6 is new bakbits ptr

;	cmpxy	a9,a4
;	jrxle	modx		;jump to exit loop if mod start x > screen end x

	cmpxy	a3,a11
	jrxlt	skdadd		;skip if mod x end < tl x
	jrylt	skdadd		;skip if mod y end < tl y

	cmpxy	a9,a4
	jrxlt	skdadd		;use this if modules aren't sorted left to right
				;jump to if mod start x > screen end x
	jrylt	skdadd		;skip if mod y start > br y

	move	*a8+,a1,l	;a1-block table	
	move	a10,a2
	sll	6,a2	     	; each block is 4 words long
	add	a1,a2	     	; a2-block table end
	move	*a8+,a5,l     	; a5-hdrs
	move	*a8+,a10,l    	; a10-pal tbl
	subxy	a9,a3
	subxy	a9,a4
	callr	disp_add
	addxy	a9,a3
	addxy	a9,a4
;********************************* (multiple module code)
;	jruc	modlp
;********************************* (multiple module code)

skdadd:
modx:
	rets
***********************************************************************

*********************** d i s p	 a d d *******************************
;* this function adds all module blocks in the given range of module
;* relative coors to the display list.
;* the boundries are included in the group to add.
disp_add:
;***	parms:
;       b0 - which bakground insert routine primary|secondary
;	a5 - background hdr table
;	a7 - bit table for block being on disp list
;	a9 - module start position y:x
;	a10 - ptr to palette table for new block
;	a1 - background block table
;	a2 - end of background block table
;	a3 - disp_tl	- relative to the module start pos
;	a4 - disp_lr	- " 
;*** returns nothing

;thrashes a1,a8,a14
	mmtm	sp,a0,a6,a7,a11

	;* find first universe block with an x coor >= a9
	movx	a3,a0
	sext	a0,w
	subi	widest_block,a0
;a0 - x coordinate of a block
;a1 - start of background block table
;a2 - end of block table
	callr	bsrch1stxb
;a0 is now the address of a block
	jrz	dadone	;* no blocks with gtr xcoor
	
	movi	block_size,a6

	move	a0,a8
	sub	a1,a8	;* subtract off start of table
	srl	6,a8	;* divide by block size (64)
	add	a7,a8	;* a8 - ptr to bit which indicates block on list
	subk	8,a8	;* after inc a8, use movb *a8 to load sign bit
	sub	a6,a0	;subtract block size
bscanlp0:
	inc	a8
	add	a6,a0	;* get next block
	;* check if there are no more bgnd blocks
	cmp	a2,a0
	jrge	dadone

	;* if block already on display list try again
	movb	*a8,a11
	jrn	bscanlp0

	;* check if x to big
	move	*a0(map_x),a11,w
	cmpxy	a3,a11
	jrxge	bscan1		;* jump if blockx >= tl x

;*************************
; mk1 code
;	;* load map header
;	move	*a0(map_hdr),a14,w
;	sll	20,a14	;* only want bottom 12 bits, top 4 are pal bits
;	srl	15,a14	;* leaves b9 << 5 == long word offset
;	add	a5,a14	;* a14 now pts to block hdr
;*************************

	move	*a0(map_hdr),a14,w	; a14 = header offset
	sll	20,a14			; shift off top 4 palette bits
	srl	20,a14			; a14 = offset only
	move	a14,a1			; a1 = offset only
	sll	6,a14			;  4 words
	sll	4,a1			; +1 word
	add	a1,a14			; = 5 word offset
	add	a5,a14			; a14 now pts to block hdr

	;* check if right end of block hangs onto screen
	move	*a14,a1,w		; a1 is now the width of the block
	add	a11,a1
	cmpxy	a3,a1			; right end of block doesn't hang on to screen
	jrxlt	bscanlp0		; jump if block x+w < tl x

	;* if ycoor to big try again
	move	*a0(map_y),a1,0
	sll	16,a1
	cmpxy	a1,a4
	jrylt bscanlp0		;* jump if block y > br y

	;* if ycoor+height to small try again
	move	*a14(map_h),a11,0
	sll	16,a11
	add	a11,a1
	cmpxy	a3,a1
	jrylt bscanlp0		;* jump if block y+h < tl y

	move	a0,a7
	callr	addblock	;thrashes a1,a14
	jrnc bscanlp0
	jruc	dadone		;* was unable to add block - no blocks left

bscan1:
	dec	a8		;* bit ptr for block on disp list
	sub	a6,a0		;subtract off block size
bscanlp1:
	inc	a8
	add	a6,a0	;get next block
	;* check if there are no more bgnd blocks
	cmp	a2,a0
	jrge	dadone

	;* if block already on display list try again
	movb	*a8,a11
	jrn	bscanlp1

	;* if ycoor to big try again
	move	*a0(map_y),a1,w
	sll	16,a1
	cmpxy	a1,a4
	jrylt bscanlp1		;* jump if block y > br y

;*******************
; mk1 code
;	;* if ycoor+height to small try again
;	move	*a0(map_hdr),a14,w
;	sll	20,a14	;* only want bottom 12 bits, top 4 are pal bits
;	srl	15,a14	;* leaves b9 << 5 == long word offset
;	add	a5,a14	;* b9 now pts to block hdr
;*******************

	move	*a0(map_hdr),a14,w	; a14 = header offset
	sll	20,a14			; shift off top 4 palette bits
	srl	20,a14			; a14 = offset only
	move	a14,a11			; a11 = offset only
	sll	6,a14			;  4 words
	sll	4,a11			; +1 word
	add	a11,a14			; = 5 word offset
	add	a5,a14			; a14 now pts to block hdr

	move	*a14(map_h),a11,w
	sll	16,a11
	add	a11,a1
	cmpxy	a3,a1
	jrylt bscanlp1		;* jump if block y+h < tl y

	;* if xcoor to big quit
	move	*a0(map_x),a1,w
	cmpxy	a1,a4
	jrxlt dadone	;* jump if block x > br x

	move	a0,a7
	callr	addblock
	jrnc	bscanlp1

dadone:
	mmfm	sp,a0,a6,a7,a11
	rets
***********************************************************************

***********************************************************************
addblock:
;* parms
; b0 - which ins routine
; a5 - base of background block hdr
; a7 - ptr to background block
; a8 - ptr to bit map for block on disp list
; a9 - module start position y:x
; a10 - ptr to palette table for new block

;* returns carry set if getobj fails...
	;* also destroys a1,a14 but they are used as temps in disp_add
	mmtm	sp,a0,a2,a3,a4

	calla	getobj
	jrz	addx

	;* set bit in bitmap for block on list
	movb	*a8,a14
	ori	>80,a14
	movb	a14,*a8
	move	a8,*a0(oplink),l ;set oplink to be a ptr to the disp list bit
	
	move	*a7(map_x),a1,l	;a1 ypos:xpos of block from mod base
	addxy	a9,a1		;add in module base position
	move	a1,*a0(oxpos),w
	srl	16,a1
	move	a1,*a0(oypos),w
	move	*a7,a4,w	;a4 - map_z,8:map_flags,4:map_pal,4
	move	a4,a3
	srl	8,a3
	sll	24,a3

*************************************************************************
*
* background modification for football (4/3/90)
* the instruction: srl 24,a3 replaces srl 8,a3 to make the zval of each
* background block be fractional and not affect the screen coordinate.
*
*	srl	8,a3
	srl	24,a3
*
*************************************************************************

	move	a3,*a0(ozval),l

	move	*a7(map_hdr),a1,w
	movx	a1,a14
	sll	16,a14
	srl	28,a14
	sll	4,a14		;* bits 12-15 are bits 4-7 of pal index

;******************
; mk1
;	sll	20,a1		;* bits 0-11 are hdr ptr;
;	srl	15,a1		;* a1-long word offset into block hdr tbl
;	add	a5,a1		;* a1 - ptr to oimg hdr - input to gsagof
;******************

	sll	20,a1		; strip off unwanted palette data
	srl	20,a1
	move	a1,a3
	sll	6,a1		; a1 = 4 word offset
	sll	4,a3		; a3 = 1 word offset
	add	a3,a1		; a1 = 5 word offset
	add	a5,a1		; offset into table gets oimg !

	;a4 - map_z,8:map_flags,4:map_pal,4
	move	a4,a3
	sll	28,a4		;* last four bits for pal
	srl	28,a4
	add	a14,a4	
	sll	5,a4		;* a4 is lword ptr from pal tbl
	add	a10,a4		;* add in pal tbl
	move	a0,a2		;save a0
	move	*a4,a0,l	;* get palette
	calla	getbpal
	jrnz	bsetpal
	clr	a0
bsetpal:
	move	a0,*a2(opal),w
	move	a2,a0		;restore a0

	movi	>8002,a4	;>8000 dma go, 2
	srl	4,a3	;* remove palette bits
	sll	30,a3		
	jrc	skip0	;* carry bit is the transparency bit
	addk	1,a4
skip0:
	srl	26,a3	;* line up flip h,v bits
	add	a3,a4	;a4 - flags for gsagof
	move	a1,*a0(oimg),l
*a1=data block pointer
*a4=object flags
****	calla	gsagof
	calla	bkgsagof	;uses isag->20 for isag
*a2=returned with new osize
*a3=returned with new sag
*a4=returned with new offset:oflags

	move	a2,*a0(osize),l
	move	a3,*a0(osag),l
	move	a4,*a0(oflags),w

	call	b0
	clrc
	mmfm	sp,a0,a2,a3,a4
	rets
addx: ;failure to get object
	setc
	mmfm	sp,a0,a2,a3,a4
	rets
**********************************************************************


************************ d i s p   d e l *****************************
;* this function deletes all objs outside the given range
;* of coors from the display list.
;* the boundries are not included in the group to delete.
disp_del:
;***	parms:
;	a8 - bak list	
;	a3 - disp_tl
;	a4 - disp_lr
;*** returns nothing

;thrashes a0,a6,a7,a8,a9	;all of which are pushed by caller

del_loop:
	move	a8,a9		; ptr to prev in a9
	move	*a9,a8,l	; ptr to next in a8
	jrz	del_done		; quit if at end of list

	;if x > xmax continue
	move	*a8(oxpos),a7,w
	cmpxy	a7,a4
	jrxlt	del_it		;* jump if br x < block x

	;if y > ymax continue
	move	*a8(oypos),a0,w
	sll	16,a0
	cmpxy	a0,a4
	jrylt	del_it		;* jump if br y < block y

	move *a8(oimg),a1,l
	;if x+width < xmin continue
	move	*a1,a6,w		;a6 block width
	add	a6,a7
	cmpxy	a3,a7
	jrxlt	del_it		;* jump if tl x > block x+w

	;if y+height < ymin continue
	move	*a1(map_h),a7,0		;a7 block height
	sll	16,a7
	add	a7,a0
	cmpxy	a3,a0
	jrylt	del_it		;* jump if tl y > block y+h

	jruc	del_loop

del_it:	;* delete the obj
    ;* free the palette
	move	*a8(opal),a0,w
	jrz	nofreep
	calla	freepal
nofreep:

	;* unset the on display list bit
	move	*a8(oplink),a0,l
	movb	*a0,a7
	andi	>7f,a7
	movb	a7,*a0
		
	move	*a8,*a9,l	; put next link in prev obj
	move	@ofree,a0,l				
	move	a0,*a8,l
	move	a8,@ofree,l	; return deleted block to free stack
	move	a9,a8		;a1- points to last obj
	jruc	del_loop

del_done:
	rets

	.end
