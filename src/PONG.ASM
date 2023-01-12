
	.include	dispequ.asm		; display processor equates
	.include	sysequ.asm		; sys.inc and gsp.inc
	.include	macros.hdr		; macros
	.include	mainequ.asm
;	.include	imgtbl.glo
;	.include	bgndtbl.glo
	.include	dipequ.asm
;	.include	stringh.asm

;	ram for pong


	.bss	pongscore1,16	;player 1 score
	.bss	pongscore2,16	;player 2 score
	.bss	ball,32		;ball object
	.bss	bxv,32		;ball velocity x
	.bss	byv,32		;ball velocity y
	.bss	play1,32	;player 1 object
	.bss	play2,32	;player 2 object
	.bss	globalvx,32	;global velocity x
	.bss	globalvy1,32	;global velocity y1 (inner hit)
	.bss	globalvy2,32	;global velocity y2 (outer hit)

	.bss	p1digit1,32*7
	.bss	p1digit2,32*7
	.bss	p2digit1,32*7
	.bss	p2digit2,32*7

play_pong
	movi	pid_pong_speed,a1		;id
	movi	speed_up_ball,a7
	calla	getprc
	clr	a0
	move	a0,@pongscore1,w
	move	a0,@pongscore2,w
	callr	init_screen
	callr	score_to_parts
	callr	init_velocities
	callr	start_ball

ponglp1	callr	move_paddles
	callr	move_ball
	jrc	pongover
	sleep	1
	jruc	ponglp1
pongover	callr	score_to_parts

	movi	pid_pong_speed,a0
	calla	dallprc
	sleep	>80
	retp


speed_up_ball
	sleep	700

	movk	6,a8
sb1	sleep	500
	move	@globalvx,a1,l
	movi	>1200,a2
	mpys	a2,a1
	sra	12,a1
	move	a1,@globalvx,l
	move	@globalvy1,a1,l
	mpys	a2,a1
	sra	12,a1
	move	a1,@globalvy1,l
	move	@globalvy2,a1,l
	mpys	a2,a1
	sra	12,a1
	move	a1,@globalvy2,l
	dsj	a8,sb1
	die


init_screen
	movi	dlists_bogus,a0		;boon init
	move	a0,@dlists,l

	clr	a0
	move	a0,@noflip,w		;we want page flipping
	movk	1,a0
	move	a0,@f_auto_erase,w	;and auto erase

	movi	[6,410],a3
	movi	[4,-5],a4
	callr	put_solid_down		;top bar
	movi	[6,410],a3
	movi	[246,-5],a4
	callr	put_solid_down		;bottom bar
	movi	[236,6],a3
	movi	[10,197],a4
	callr	put_solid_down		;center divider

	movi	[39,6],a3
	movi	[100,21],a4
	callr	put_solid_down		;player 1 paddle
	move	a8,@play1,l
	movi	[39,6],a3
	movi	[100,373],a4
	callr	put_solid_down		;player 2 paddle
	move	a8,@play2,l

	movi	p1digit1,a9		;a9 = ram to store objects
	movk	4,a7			;a7 = digits to do
	movi	digit_start_table,a1	;a1 = position of digits pointer
ndig	move	*a1+,a5,l		;a5 = starting position of digits
	movk	7,a6			;a6 = segments to do
	movi	segment_table,a2	;a2 = position of segments pointer
nseg	move	*a2+,a4,l			;position of block
	move	*a2+,a3,l			;size of block
	addxy	a5,a4
	mmtm	sp,a1,a2,a5,a6,a7,a9
	callr	put_solid_down
	mmfm	sp,a1,a2,a5,a6,a7,a9
	move	a8,*a9+,l
	dsjs	a6,nseg
	dsjs	a7,ndig
	rets


init_velocities
	movi	[3,>8000],a0
	move	a0,@globalvx,l
	movi	[1,>2aaa],a0
	move	a0,@globalvy1,l
	movi	[2,>5555],a0
	move	a0,@globalvy2,l
	rets

start_ball
	movi	[6,6],a3
	movi	[10,90],a4
	callr	put_solid_down		;ball
	move	a8,@ball,l
	;fall through
serve_ball_right
	move	@ball,a8,l
	movi	[90,0],a0
	move	a0,*a8(oxval),l
	movi	[10,0],a0
	move	a0,*a8(oyval),l
	move	@globalvx,@bxv,l	;x velocity start
	move	@globalvy1,@byv,l	;y velocity
	rets
serve_ball_left
	move	@ball,a8,l
	movi	[310,0],a0
	move	a0,*a8(oxval),l
	movi	[10,0],a0
	move	a0,*a8(oyval),l
	move	@globalvx,a0,l
	neg	a0
	move	a0,@bxv,l
	move	@globalvy1,@byv,l	;y velocity
	rets


move_paddles
	move	@switch,a1,w
	not	a1
	btst	0,a1
	jrz	mp1
	callr	move_p1_up
mp1	btst	1,a1
	jrz	mp2
	callr	move_p1_down
mp2	btst	8,a1
	jrz	mp3
	callr	move_p2_up
mp3	btst	9,a1
	jrz	mp4
	callr	move_p2_down
mp4	rets

move_p1_up
	move	@play1,a8,l
	jruc	mpup
move_p2_up
	move	@play2,a8,l
mpup	move	*a8(oypos),a0,w
	subk	3,a0
	cmpi	8,a0
	jrgt	mpup1
	movk	8,a0
mpup1	move	a0,*a8(oypos),w
	rets

move_p1_down
	move	@play1,a8,l
	jruc	mpdn
move_p2_down
	move	@play2,a8,l
mpdn	move	*a8(oypos),a0,w
	addk	3,a0
	cmpi	207,a0
	jrlt	mpdn1
	movi	207,a0
mpdn1	move	a0,*a8(oypos),w
	rets

move_ball
	move	@ball,a8,l
	move	@bxv,a0,l
	move	*a8(oxval),a1,l
	add	a0,a1
	move	a1,*a8(oxval),l


	cmpi	[-15,0],a1
	jrlt	score_p2
	cmpi	[410,0],a1
	jrgt	score_p1

	move	@byv,a2,l
	move	*a8(oyval),a3,l		;add in velocities
	add	a2,a3
	cmpi	[-15,0],a1
	jrlt	mb_sc
	cmpi	[410,0],a1
	jrgt	mb_sc
	cmpi	[9,0],a3
	jrlt	rev_y
	cmpi	[241,0],a3
	jrle	nrevy
rev_y	neg	a2

	tsound2	>2b			; top of screen

	move	a2,@byv,l
	add	a2,a3
	add	a2,a3
nrevy	move	a3,*a8(oyval),l

	move	@play1,a9,l		;player 1 paddle check
	move	*a9(oxval),a0,l
	sub	a1,a0
	cmpi	[-5,0],a0
	jrlt	not_p1			;not hitting player 1
	cmpi	[5,0],a0
	jrgt	not_p1
	move	*a9(oyval),a0,l
	sub	a3,a0
	neg	a0
	cmpi	[-5,0],a0
	jrlt	not_p1
	cmpi	[38,0],a0
	jrgt	not_p1
	move	@globalvx,@bxv,l	;set x velocity
	move	@globalvy2,a1,l		;wide angle y
	cmpi	[27,0],a0
	jrgt	p1_sty			;regions -5,5   6,16   17,27   28,38
	neg	a1
	cmpi	[6,0],a0
	jrlt	p1_sty
	move	@globalvy1,a1,l
	cmpi	[16,0],a0
	jrgt	p1_sty
	neg	a1
p1_sty	calla	random
	sra	18,a0
	add	a0,a1
	move	a1,@byv,l

	tsound2	>2a			; hit paddle sound

not_p1	move	@play2,a9,l		;player 2 paddle check
	move	*a9(oxval),a0,l
	sub	a1,a0
	cmpi	[-5,0],a0
	jrlt	not_p2			;not hitting player 2
	cmpi	[5,0],a0
	jrgt	not_p2
	move	*a9(oyval),a0,l
	sub	a3,a0
	neg	a0
	cmpi	[-5,0],a0
	jrlt	not_p2
	cmpi	[38,0],a0
	jrgt	not_p2
	move	@globalvx,a1,l		;set x velocity
	neg	a1
	move	a1,@bxv,l
	move	@globalvy2,a1,l		;wide angle y
	cmpi	[27,0],a0
	jrgt	p2_sty			;regions -5,5   6,16   17,27   28,38
	neg	a1
	cmpi	[6,0],a0
	jrlt	p2_sty
	move	@globalvy1,a1,l
	cmpi	[16,0],a0
	jrgt	p2_sty
	neg	a1
p2_sty	calla	random
	sra	18,a0
	add	a0,a1
	move	a1,@byv,l

	tsound2	>2a			; hit paddle sound

not_p2	clrc
	rets
score_p1	move	@pongscore1,a0,w
	inc	a0
	move	a0,@pongscore1,w
	cmpi	7,a0
	jrz	sop_5
;	sleep	30
	callr	serve_ball_right
	jruc	mb_sc
score_p2	move	@pongscore2,a0,w
	inc	a0
	move	a0,@pongscore2,w
	cmpi	7,a0
	jrz	sop_5
;	sleep	30
	callr	serve_ball_left
mb_sc
	tsound2	>2f
	callr	score_to_parts
	clrc
	rets
sop_5	setc
	rets


score_to_parts
	move	@pongscore1,a9,w
	movi	p1digit1,a2
	callr	stp3
	move	@pongscore2,a9,w
	movi	p2digit1,a2
stp3	sll	4,a9
	addi	digit_table,a9
	move	*a9,a9,w		;now we have bits
	movk	14,a1
stp2	move	*a2+,a8,l
	move	*a8(oflags),a0,w
	andi	~m_const,a0
	srl	1,a9
	jrnc	stp1
	ori	m_const,a0
stp1	move	a0,*a8(oflags),w
	dsjs	a1,stp2
	rets



digit_table
	.word	01111110111111b	;0
	.word	00001100111111b	;1
	.word	11011010111111b	;2
	.word	10011110111111b	;3
	.word	10101100111111b	;4
	.word	10110110111111b	;5
	.word	11110110111111b	;6
	.word	00011100111111b	;7
	.word	11111110111111b	;8
	.word	10111100111111b	;9
	.word	01111110000110b	;10
	.word	00001100000110b	;11
	.word	11011010000110b	;12
	.word	10011110000110b	;13
	.word	10101100000110b	;14
	.word	10110110000110b	;15

segment_table
	.word	0,26,21,6	;segment 0
	.word	15,16,6,16	;segment 1
	.word	15,0,6,16	;segment 2
	.word	0,0,21,6	;segment 3
	.word	0,0,6,16	;segment 4
	.word	0,16,6,16	;segment 5
	.word	0,13,21,6	;segment 6

digit_start_table
	.word	80,15
	.word	105,15
	.word	275,15
	.word	300,15


put_solid_down		;a3=xysize, a4=xypos 
	movi	bpal_white,a0			;color
	mmtm	sp,a4
	calla	make_solid_object
	mmfm	sp,a4
	calla	set_xy_coordinates
	calla	set_noscroll
	jauc	insobja8

