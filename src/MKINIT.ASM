**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon									*
* 											     *
*  module: fbinit.asm -  system initialize routines					*
* 											     *
*  copyright (c) 1993 Midway Manufacturing							*
*											     *
**************************************************************************
	.file	'mkinit.asm'
	.width	132
	.option	b,d,l,t
	.mnolist
*
* get the system stuff
*
	.include	dispequ.asm		; display processor equates
	.include	sysequ.asm
	.include	macros.hdr		; macros
	.include	mainequ.asm
	.include	imgtbl.glo
	.include	bgndtbl.glo
	.include	diagaudn.asm
	.include	dipequ.asm

	.bss	mainled,16
	.bss	wdogram,32	;initialized long for watch dog detect
	.bss	worstbog,16,1
*
* routines referenced out of this module
*
	.ref	on_hstd, coinflag, xcoin, scoin, ccoin, lcoin, rcoin
	.ref	ckdiag, diag, nplayers, powercmos, powertst
	.ref	read_dip,coinint,illegal_opcode,slam

	.if printer
	.ref	fbalive
	.ref	doggyprint
	.ref	laststack,lasta0
	.endif

	.def	dirq
	.def	POWERUP
	.def	warmset
	.DEF	wipeout
	.DEF	g_cred
	.DEF	pcmosret
	.def	initdata
	.DEF	idatalen
	.DEF	dipinit
	.DEF	main_init
	.DEF	clscrach
	.def	sysinitl

wdognum	.set	01a2b3c4dh	;"system initialized" marker

**************************************************************************
*												*
*  powerup											*
*												*
*  pc starts here when the game is turned on.						*
*												*
**************************************************************************
*check out audit page
POWERUP
	dint
	setf	16,1,0			;word sign extend
	setf	32,1,1			;long word
	.if	printer
	move	sp,@laststack,l		; preserve value of this sucker
	move	a0,@lasta0,l		; a0 gonna get wasted, too
	.endif
	movi	stckst,sp,l
	movi	syscinit,a0
	move	a0,@sysctrl,w
	move	a0,@syscopy,w		;keep a copy in ram

**************************************************************************
*											     *
*    manual sound board reset								     *
*											     *
**************************************************************************

	movi	0fe00h,a0		;hit reset bit
	move	a0,@sound
	movi	100,a0			;wait for it to catch
	dsjs	a0,$	
	movi	0ffffh,a0		;let it go
	move	a0,@sound

	move	@talkport,a0
	btst	b_wdog,a0		; is this coming from a watchdog ?
	jrne	sans_watchdog		; no...
	movi	aud_watchdog,a0
	calla	aud1
sans_watchdog

	jauc	powertst		; do the patented power up test


POWERRET
warmset
	dint
	setf	16,1,0			; word with sign extend
	setf	32,0,1			; long word
	movi	stckst,sp,l

	calla	clscrach		; clear scratchpad ram

	movi	wdognum,a0
	move	a0,@wdogram,l		; mark system as initialized

;	move	@wdogram,a0,l
;	cmpi	wdognum,a0		; is this from powerup ?
;	jrne	sans_watchdog


	jauc	powercmos		; verify cmos and print opening message
pcmosret

	callr	main_init

	clr	a3
	calla	send_code_a3
	movi	>2000,a0
	dsjs	a0,$
	calla	set_game_volume

	clr	a0
	move	a0,@f_auto_erase,w

	movi	syscinit,a0
	move	a0,@sysctrl,w		; initialize system control register
	move	a0,@syscopy,w		; keep a copy in ram

	eint				; enable interrupts and we're off
	calla	check_hstd_cmos

	movk	1,a0
	move	a0,@displayon,w

	calla	ckdiag			; are any of the diag switches closed?
	jrnc	maingo			; br = no, the game may proceed as planned

	create	pid_diag,diag		; fire off the diag process
	jruc	mainlp			; and then dispatch it.

maingo	clr	a0
	move	a0,@coinflag,w		; not on coin page yet

        .if printer	
	calla	fbalive			; print out "alive" message
        .endif	

	create	pid_amode,amode
	calla	drone_kill_init

**************************************************************************
*											     *
* 	process dispatch main loop							     *
*											     *
**************************************************************************

mainlp	calla	prcdsp			; dispatch processes
	move	a13,a13
	jreq	main1
	lockup

main1	calla	soundup 		; update sounds

	movi	p1_bar,a0
	movi	p1_bar_view,a1
	callr	update_bar		; update player 1 strength bar
	movi	p2_bar,a0
	movi	p2_bar_view,a1
	callr	update_bar		; update player 2 strength bar
	move	@p2_bar_view,a1,w
	movi	>178,a0			; right justify player 2 bar
	sub	a1,a0
	move	a0,@p2_bar_xpos,w
*
* unstack the switches  (exec loop)
*
	movi	active,a13,l
	move	@swstack,a3,l
unstkl	cmpi	swstst,a3,l	; stack at start?
	jreq	unstkx		; yes, exit
	move	@free,a0,l
	jrz	unstkx		; no processes left, try next time around
	move	*a3+,a0,w	; get entry
	move	a3,@swstack,l	; update stack
	move	a0,a2
	add	a0,a2
	add	a0,a2		; mult by 3
	sll	4,a2		; adjust for word size (16)
	
	addi	swtab,a2
	move	*a2+,a1		; get pid
	move	*a2+,a7,l	; get starting addr
	jreq	unstkl		; null entry
	calla	getprc
	jruc	unstkl
unstkx

;***********************
	move	@dipswitch,a0,w	; read it in
	not	a0	       	; invert it for true bits
	btst	0,a0	 	; t-unit bit is different
	jreq	sans_diag	; sans

	move	@gstate,a0,w
	cmpi	gs_diag,a0
	jreq	sans_diag	; already in diagnostics

	movi	gs_diag,a0
	move	a0,@gstate,w		; declare game state now !!
	create	pid_diag,diag_jump 	; fire off the diag process
	
sans_diag
;***********************

	calla	random		; new seed please

	move	@mainled,a0,w
	inc	a0
	move	a0,@mainled,w
	cmpi	5,a0
	jrlt	mainlp
	clr	a0
	move	a0,@mainled,w

	pushst
	dint
	move	@syscopy,a0,w		; blink l.e.d. to ack operation
	xori	04h,a0
	move	a0,@syscopy,w
	move	a0,@sysctrl,w
	move	a0,@watchdog,w		; feed the watchdog
	popst
	jruc	mainlp

**************************************************************************
*											     *
*  update_bar - Update a player's strength bar					     *
* 											     *
*  Input: a0 = real bar value								     *
*         a1 = viewable value								     *
*											     *
**************************************************************************
update_bar
	move	*a0,a2,w    		; actual strength bar value
	jrn	upsb9			; neg = effect going on, don't touch
	jrne	upsb1			; power remaining !
*
* real power = 0
*
	move	*a1,a3,w		; a3 = viewable bar size
	jreq	upsb2			; viewable = 0 ---> stuff

	dec	a3			; drop the bar towards zero
	cmpi	3,a3
	jrhs	upsb2
	clr	a3   			; viewable = 2 or 1 ---> stuff a zero
	jruc	upsb2
*
* real power > 0
*
upsb1	move	*a1,a3,w		; a3 = viewable bar size
	cmp	a2,a3
	jreq	upsb3
	dec	a3			; different = decrease viewble bar
upsb3	cmpi	3,a3
	jrhs	upsb2
     	movk	3,a3
upsb2	move	a3,*a1,w		; stuff viewable bar size
upsb9	rets

;*************************************************************************
;*************************************************************************
;*************************************************************************
;*************************************************************************

swtab
	.word	pid_switch1
	.long	p1_joyup		; 0 - player 1 joystick up

	.word	pid_switch1
	.long	p1_joydown		; 1 - player 1 joystick down

	.word	pid_switch1
	.long	p1_joyleft 		; 2 - player 1 joystick left

	.word	pid_switch1
	.long	p1_joyright		; 3 - player 1 joystick right

	.word	pid_switch1
	.long	p1_button0		; 4 - player 1 button 0

	.word	pid_switch1
	.long	p1_button2		; 5 - player 1 button 2 (block)

	.word	pid_switch1
	.long	p1_button3		; 6 - player 1 button 3

	.word	0
	.long	0			; 7 -- print busy

	.word	pid_switch2
	.long	p2_joyup		; 8 - player 2 joystick up

	.word	pid_switch2
	.long	p2_joydown		; 9 - player 2 joystick down

	.word	pid_switch2
	.long	p2_joyleft 		; a - player 2 joystick left

	.word	pid_switch2
	.long	p2_joyright		; b - player 2 joystick right

	.word	pid_switch2
	.long	p2_button0		; c - player 2 button #0 (punch high)

	.word	pid_switch2
	.long	p2_button2		; d - player 2 button #2 (block)

	.word	pid_switch2
	.long	p2_button3		; e - player 2 button #3 (hi kick)

	.word	0
	.long	0			; f - printer paper out

	.word	pid_lc
	.long	lcoin			; 10	- left coin slot

	.word	pid_rc
	.long	rcoin			; 11- right coin slot

	.word	0
	.long	p1_start_button		; 12 - p1 start
	
	.word	pid_slam
	.long	slam			; 13 - slam

	.word	pid_diag
	.long	diag			; 14

	.word	0
	.long	p2_start_button		; 15

	.word	0606h
	.long	scoin			; 16	-- service credit

	.word	pid_cc
	.long	ccoin			; 17	- center coin

	.word	pid_xc			
	.long	xcoin			; 18	- fourth coin

	.word	0
	.long	0			; 19

	.word	0
	.long	0			; 1a

	.word	pid_volume
	.long	volume_switch_proc	; 1b - 

	.word	pid_volume
	.long	volume_switch_proc	; 1c - 

	.word	0
	.long	0			; 1d -

	.word	0
	.long	0			; 1e - 

	.word	0
	.long	0			; 1f - 

*
* port #1 - switch openning
*
	.word	0
	.long	0			; 20 / 0 - player 1 joystick up
	.word	0
	.long	0			; 21 / 1 - player 1 joystick down
	.word	0
	.long	0			; 22 / 2 - player 1 joystick left
	.word	0
	.long	0			; 23 / 3 - player 1 joystick right
	.word	pid_switch1
	.long	p1_button0_open		; 24 / 4 - player 1 button 0
	.word	pid_switch1
	.long	p1_button2_open		; 25 / 5 - player 1 button 2 (block)
	.word	pid_switch1
	.long	p1_button3_open		; 26 / 6 - player 1 button 3
	.word	0
	.long	0			; 27 / 7 -- print busy
	.word	0
	.long	0			; 28 / 8 - player 2 joystick up
	.word	0
	.long	0			; 29 / 9 - player 2 joystick down
	.word	0
	.long	0			; 2a / a - player 2 joystick left
	.word	0
	.long	0			; 2b / b - player 2 joystick right
	.word	pid_switch2
	.long	p2_button0_open		; 2c / c - player 2 button #0 (punch high)
	.word	pid_switch2
	.long	p2_button2_open		; 2d / d - player 2 button #2 (block)
	.word	pid_switch2
	.long	p2_button3_open		; 2e / e - player 2 button #3 (hi kick)
	.word	0
	.long	0			; 2f / f - printer paper out
	.word	0
	.long	0			; 30 / 10	- left coin slot
	.word	0
	.long	0			; 31 / 11	- right coin slot
	.word	0
	.long	0			; 32 / 12 - p1 start
	.word	0
	.long	0			; 33 / 13 - slam
	.word	0
	.long	0			; 34 / 14
	.word	0
	.long	0			; 35 / 15
	.word	0
	.long	0			; 36 / 16	-- service credit
	.word	0
	.long	0			; 37 / 17	- center coin
	.word	0
	.long	0			; 38 / 18	- fourth coin
	.word	0
	.long	0			; 39 / 19
	.word	0
	.long	0			; 3a / 1a
	.word	0
	.long	0			; 3b / 1b
	.word	0
	.long	0			; 3c / 1c
	.word	0
	.long	0			; 3d / 1d
	.word	0
	.long	0			; 3e / 1e - 
	.word	0
	.long	0			; 3f / 1f
*
* port #2 - switch closing
*
	.word	pid_switch1
	.long	p1_button1		; 40 / 0 - player 1 button 1

	.word	pid_switch1
	.long	p1_button4		; 41 / 1 - player 1 button 4

	.word	pid_switch1
	.long	p1_button2		; 42 / 2 - doubled for sf2 kit

	.word	0
	.long	0			; 43 / 3 -

	.word	pid_switch2
	.long	p2_button1		; 44 / 4 - player 2 button #1 (low punch)

	.word	pid_switch2
	.long	p2_button4		; 45 / 5 - player 2 button #4 (low high)

	.word	pid_switch2
	.long	p2_button2		; 46 / 6 - doubled for sf2 kit

	.word	0
	.long	0			; 47 / 7 -

	.word	0
	.long	0			; 48 / 8 -

	.word	0
	.long	0			; 49 / 9 -

	.word	0
	.long	0			; 4a / a -

	.word	0
	.long	0			; 4b / b -

	.word	0
	.long	0			; 4c / c -

	.word	0
	.long	0			; 4d / d -

	.word	0
	.long	0			; 4e / e -

	.word	0
	.long	0			; 4f / f -

	.word	0
	.long	0			; 50 / 10 -

	.word	0
	.long	0			; 51 / 11 -

	.word	0
	.long	0			; 52 / 12

	.word	0
	.long	0			; 53 / 13

	.word	0
	.long	0			; 54 / 14 -

	.word	0
	.long	0			; 55 / 15

	.word	0
	.long	0			; 56 / 16

	.word	0
	.long	0			; 57 / 17

	.word	0
	.long	0			; 58 / 18

	.word	0
	.long	0			; 59 / 19

	.word	0
	.long	0			; 5a / 1a

	.word	0
	.long	0			; 5b / 1b

	.word	0
	.long	0			; 5c / 1c

	.word	0
	.long	0			; 5d / 1d

	.word	0
	.long	0			; 5e / 1e

	.word	0
	.long	0			; 5f / 1f
*
* port #2 - switch openning
*
	.word	pid_switch1
	.long	p1_button1_open		; 60 / 0 - player 1 button 0
	.word	pid_switch1
	.long	p1_button4_open		; 61 / 1 - player 1 button 4
	.word	0
	.long	0			; 62 / 2
	.word	0
	.long	0			; 63 / 3
	.word	pid_switch2
	.long	p2_button1_open		; 64 / 4 - player 2 button #1 (low punch)
	.word	pid_switch2
	.long	p2_button4_open		; 65 / 5 - player 2 button #4 (low high)
	.word	0
	.long	0			; 66 / 6 -
	.word	0
	.long	0			; 67 / 7 -
	.word	0
	.long	0			; 68 / 8 - player 2 button #1 (punch med)
	.word	0
	.long	0			; 69 / 9 - player 2 button #4 (low high)
	.word	0
	.long	0			; 6a / a -
	.word	0
	.long	0			; 6b / b -
	.word	0
	.long	0			; 6c / c -
	.word	0
	.long	0			; 6d / d -
	.word	0
	.long	0			; 6e / e -
	.word	0
	.long	0			; 6f / f -
	.word	0
	.long	0			; 70 / 10 -
	.word	0
	.long	0			; 71 / 11 -
	.word	0
	.long	0			; 72 / 12 -
	.word	0
	.long	0			; 73 / 13 -
	.word	0
	.long	0			; 74 / 14 -
	.word	0
	.long	0			; 75 / 15 -
	.word	0
	.long	0			; 76 / 16
	.word	0
	.long	0			; 77 / 17
	.word	0
	.long	0			; 78 / 18
	.word	0
	.long	0			; 79 / 19
	.word	0
	.long	0			; 7a / 1a
	.word	0
	.long	0			; 7b / 1b
	.word	0
	.long	0			; 7c / 1c
	.word	0
	.long	0			; 7d / 1d
	.word	0
	.long	0			; 7e / 1e
	.word	0
	.long	0			; 7f / 1f


volume_switch_proc
	move	@gstate,a0,w
	cmpi	gs_diag,a0		; already in diag ?
	jaeq	local_sucide		; yes, die

	calla	murder

	movi	gs_diag,a0
	move	a0,@gstate,w		; game state = diag !!
	jsrp	go_volume
	jauc	warmset

**************************************************************************
*											     *
*  Player switch processes !!								     *
*											     *
**************************************************************************
p1_button0
	movi	sw_hi_punch,a0
	movi	p1_bcq,a1
	jruc	p1_switch_close

p1_button1
	movk	sw_lo_punch,a0
	movi	p1_bcq,a1
	jruc	p1_switch_close

p1_button2
	movk	sw_block,a0
	movi	p1_bcq,a1
	jruc	p1_switch_close

p1_button3
	movk	sw_hi_kick,a0
	movi	p1_bcq,a1
	jruc	p1_switch_close

p1_button4
	movk	sw_lo_kick,a0
	movi	p1_bcq,a1
	jruc	p1_switch_close

p1_joyup
	movi	sw_up,a0
	movi	p1_jcq,a1
	jruc	p1_switch_close

p1_joydown
	move	@gstate,a0,w
	cmpi	gs_amode,a0
	jaeq	joy_show_rankings

	movi	sw_down,a0
	movi	p1_jcq,a1
	jruc	p1_switch_close

p1_joyleft
	movi	sw_left,a0
	movi	p1_jcq,a1
	jruc	p1_switch_close

p1_joyright
	movi	sw_right,a0
	movi	p1_jcq,a1
	jruc	p1_switch_close

p2_button0
	movi	sw_hi_punch,a0
	movi	p2_bcq,a1
	jruc	p2_switch_close

p2_button1
	movk	sw_lo_punch,a0
	movi	p2_bcq,a1
	jruc	p2_switch_close

p2_button2
	movk	sw_block,a0
	movi	p2_bcq,a1
	jruc	p2_switch_close

p2_button3
	movk	sw_hi_kick,a0
	movi	p2_bcq,a1
	jruc	p2_switch_close

p2_button4
	movk	sw_lo_kick,a0
	movi	p2_bcq,a1
	jruc	p2_switch_close

p2_joyup
	movi	sw_up,a0
	movi	p2_jcq,a1
	jruc	p2_switch_close

p2_joydown
	move	@gstate,a0,w
	cmpi	gs_amode,a0
	jaeq	joy_show_rankings

	movi	sw_down,a0
	movi	p2_jcq,a1
	jruc	p2_switch_close

p2_joyright
	movi	sw_right,a0
	movi	p2_jcq,a1
	jruc	p2_switch_close

p2_joyleft
	movi	sw_left,a0
	movi	p2_jcq,a1
	jruc	p2_switch_close

;******************

p1_switch_close
	clr	a2	      		; player 1
	movk	1,a3
	jruc	queue_and_jump

p2_switch_close
	movk	1,a2			; a2 = player offset
	movk	1,a3
	jruc	queue_and_jump


**************************************************************************
*											     *
*  Switch openning procs									     *
*											     *
**************************************************************************
p1_button0_open
	movi	sw_hi_punch,a0
	movi	p1_boq,a1
	jruc	p1_switch_open

p1_button1_open
	movi	sw_lo_punch,a0
	movi	p1_boq,a1
	jruc	p1_switch_open

p1_button2_open
	movi	sw_block,a0
	movi	p1_boq,a1
	jruc	p1_switch_open

p1_button3_open
	movi	sw_hi_kick,a0
	movi	p1_boq,a1
	jruc	p1_switch_open

p1_button4_open
	movi	sw_lo_kick,a0
	movi	p1_boq,a1
	jruc	p1_switch_open


p2_button0_open
	movi	sw_hi_punch,a0
	movi	p2_boq,a1
	jruc	p2_switch_open

p2_button1_open
	movi	sw_lo_punch,a0
	movi	p2_boq,a1
	jruc	p2_switch_open

p2_button2_open
	movi	sw_block,a0
	movi	p2_boq,a1
	jruc	p2_switch_open

p2_button3_open
	movi	sw_hi_kick,a0
	movi	p2_boq,a1
	jruc	p2_switch_open

p2_button4_open
	movi	sw_lo_kick,a0
	movi	p2_boq,a1
	jruc	p2_switch_open

p1_switch_open
	clr 	a2			; a2 = player 1 offset
	clr	a3			; a3 = switch open flag
	jruc	queue_and_jump

p2_switch_open
	movk	1,a2			; a2 = player 1 offset
	clr	a3			; a3 = switch open flag
	jruc	queue_and_jump

**************************************************************************
*											     *
*  queue_and_jump - Does the following						     *
* 											     *
*  1. Queues up a switch equate								     *
*  2. Loads up a player's info into process ram					     *
*  3. Offset jumps to a switch address						     *
* 											     *
*  Given:  a0 = switch offset (0-8)							     *
*          a1 = queue to update								     *
*          a2 = player offset (0-1)							     *
*          a3 = (0-1) (open,close)							     *
*											     *
**************************************************************************
queue_and_jump
	movi	p1_die_check,a4
	move	a2,a2			; player 1 ?
	jreq	qaj2
	movi	p2_die_check,a4
qaj2	call	a4			; call player ? die check routine

	push	a0
	callr	switch_queue_a0
	pull	a0
	move	a2,a2			; player 1 ?
	jrne	qaj5			; no
*
* load info for player 1
*
	move	@p2_obj,a8,l
	move	a8,*a13(p_otherguy),l
	move	@p2_proc,a8,l
	move	a8,*a13(p_otherproc),l
	move	@p1_proc,a8,l
	move	a8,*a13(p_store4),l	; player 1 proc
	move	*a8(p_joyport),*a13(p_joyport),l
	move	@p1_obj,a8,l	   	; a8 = player 1 dude !
	jruc	qaj7
*
* load info for player 2
*
qaj5	move	@p1_obj,a8,l
	move	a8,*a13(p_otherguy),l
	move	@p1_proc,a8,l
	move	a8,*a13(p_otherproc),l
	move	@p2_proc,a8,l
	move	a8,*a13(p_store4),l	; player 2 proc
	move	*a8(p_joyport),*a13(p_joyport),l
	move	@p2_obj,a8,l	   	; a8 = player 2 dude !

qaj7	movi	switch_close_jumps,a4
	move	a3,a3
	jrne	qaj8
    	movi	switch_open_jumps,a4
qaj8	move	a0,a1
	sll	5,a1
	add	a4,a1
	move	*a1,a1,l
	jump	a1			; jump to address offset of switch equ

**************************************************************************
*											     *
*  switch_queue_a0 - adds a switch entry to the current queue.	     	*
* 											     *
*  input: a0 = switch coded number						 	     *
*         a1 = queue to add to !								     *
*											     *
**************************************************************************
switch_queue_a0
	move	a0,a7
	move	@tick,a4,w	; look at the clock
	sll	16,a7		; put switch in upper word
	or	a4,a7		; a7 = [switch,time]
	move	*a1,a0,l	; a0 = next available spot !!
	move	a1,a4
	addi	(sqs+1)*32,a4	; a4 = last spot in queue
	move	a7,*a0+,l	; stuff in new entry
*
* update "next spot" pointer
*
	cmp	a4,a0		; have we reached the end of the queue ?
	jrlo	sq3		; no
	move	a1,a0		; yes
	addi	32,a0		; next available spot = 1st spot
sq3	move	a0,*a1,l	; stuff new "next spot" pointer
	rets

**************************************************************************
*											     *
*  p?_die_check - routine to die if the player who hit the button is not *
*                 in the game.								     *
*											     *
**************************************************************************
p2_die_check
	move	@p2_state,b0,w
	jruc	pdie2

p1_die_check
	move	@p1_state,b0,w
pdie2	cmpi	ps_active,b0		; in the game ?
	jrne	pdie3			; no
	move	@gstate,b0,w
	cmpi	gs_fighting,b0		; fighting mode ?
	jrne	pdie3			; no
	rets

pdie3	pull	b0			; no

local_sucide
	die				; bye, bye, out of your league !!

**************************************************************************
*												*
* clscrach - clear scratch pad									*
* note: destroys a0,a1,a2,a3									*
*												*
**************************************************************************
clscrach
	pull	a3
*clear scratchpad ram
	clr	a0
	movi	scratch,a1,l
	movi	>8000,a2,l		;clear two at a time
sctlp	move	a0,*a1+,l
	dsjs	a2,sctlp
	jump	a3


**************************************************************************
*												*
* main_init - this is the main system initialize routine.				*
*												*
**************************************************************************
main_init
	push	a0
	calla	sndres			; reset sound board
	callr	initio			; initialize the i/o regs
	callr	init_dma_window

	calla	setpproc		; set up ti pixel processing regs

	clr	a0
	move	a0,@dmactrl
	move	a0,@dmactrl,w		; dma = off (must do it 2 times)

	move	a0,@cmapsel		; clear color map select
	move	a0,@irqled
	move	a0,@mainled

	calla	scrclr			; clear the screen

	movi	81261a8ch,a0
	move	a0,@rand,l		; initialize random seed

	movi	die,a0			; enable display, ext1 interrupt

;	jruc	skip_x2e
	ori	x2e,a0			; enable rom protect interupt (ext 2)
skip_x2e
	move	a0,@intenb		; enable display interrupts

	movi	swstst,a0
	move	a0,@swstack,l		; initialize switch stack

	movi	syscinit,a0
	move	a0,@sysctrl,w		; initialize system control register
	move	a0,@syscopy,w		; keep a copy in ram

	callr	dipinit			; initialize dip switch options
	calla	pinit			; init process list
	calla	oinit			; initialize the object list
	pull	a0
	rets


set_game_volume
	movi	adj_volume,a0
	calla	get_adj
	move	a0,a10	    		; a10 = cmos volume
	movi	>55aa,a3
	calla	send_code_a3
	move	a10,a3	    		; volume
	move	a10,a1
	not	a1	    		; sans volume
	sll	32-8,a1	
	srl	32-8,a1
	sll	8,a3
	or	a1,a3	    		; a3 = [volume,sans volume]
	jauc	send_code_a3

**************************************************************************
*								         			*
* init_dma_window - initialize the dma window				 		*
*								         			*
**************************************************************************
init_dma_window
	movi	dmaywin|dmacf4,a2
	move	a2,@dmaconfig,w		; set to adjust window height

	movi	[2*scrhght,0],a2
	move	a2,@dmatplft,l		; full height window
	movk	dmacf4,a2
	move	a2,@dmaconfig,w		; set to: adjust window width
*
* set dma left/right clip to the full 512 pixels to counter the
* curse that lofredo bestowed upon us
*
	movi	[511,scrlft],a2		; a2 = dma [right,left] clip window
	move	a2,@dmatplft,l
	movi	dmaywin|dmacf4,a2
	move	a2,@dmaconfig,w		; leave configed to "top/bottom"
	rets

**************************************************************************
*												*
* wipeout - wipes the system clear of all other processes, objects	 	*
*	  and coordinates.						 			*
*	  it returns with the display system and auto-erase on,		*
*	  color ram cleared, and the bit map wiped clean.		 	*
*	  this is nice to use when switching between stuff.		 	*
*												*
**************************************************************************
wipeout
	mmtm	sp,a0,a1
	clr	a0
;	move	a0,@page,w
	move	a0,@coinflag,w		; not on coin page yet
	move	a0,@on_hstd,w		; not on high score page

	movi	08000h,a1
	clr	a0
	calla	kilall			;kill all procs, except for coins

	pushst
	dint
	calla	oinit			;re-init the object list
	callr	sysinitl
	popst

;*****************************
	move	@tick,a0,w
newsync	move	@tick,a1,w
	cmp	a0,a1
	jreq	newsync
;	calla	syncfull		;now wait for vblank to zap cmap
;*****************************

	calla	clr_scrn		;wipe out the bit map

	clr	a0
	move	a0,@irqskye,w		;clr the auto-erase color

	movk	1,a0
	move	a0,@displayon,w		;turn the display processor on

	mmfm	sp,a0,a1
	rets

**************************************************************************
*												*
* g_cred - this routine is called by the coin handler every time that	*
*	a coin is received during game play. use it as you will.		*
* a8 = ptr to credit string									*
*												*
**************************************************************************
g_cred
	rets

**************************************************************************
*												*
* dipinit - routine to initialize system according to the dipswitches.	*
*												*
**************************************************************************
dipinit
	movk	1,a0
	move	a0,@nplayers,w		; 2 player game

	clr	a3
	calla	read_dip	
	move	a0,a1
	andi	dip_violence,a1		; violence turned off ?
	jreq	dip3
	movk	1,a3
dip3	move	a3,@f_no_violence	; flag: sans violence

	clr	a3
	move	a0,a1
	andi	dip_blood,a1
	jreq	dip4
	movk	1,a3
dip4	move	a3,@f_no_blood,w	; flag: no blood
*
* low blow
*
	clr	a3
	move	a0,a1
	andi	dip_low_blow,a1
	jreq	dip5
	movk	1,a3
dip5	move	a3,@f_no_lb,w		; flag: no low blow

	rets

**************************************************************************
*												*
* initio - initialize the gsp i/o registers						*
*												*
**************************************************************************
initio
	mmtm	sp,b0,b2,b10
*initialize i/o
	movi	hesync,b2,l
	movi	initdata,b0,l
	movi	(idataend-initdata)/16,b10
initios:
	move	*b0+,*b2+
	dsjs	b10,initios
	mmfm	sp,b0,b2,b10
	rets

**************************************************************************
*												*
*	  video control registers initial values					*
*												*
**************************************************************************
initdata:
	.word	>0015		; >c0000000 -- hesync
	.word	>002d		; >c0000010 -- heblnk
	.word	>00f5		; >c0000020 -- hsblnk	;gnp change 7/22/92
	.word	>00fc		; >c0000030 -- htotal
	.word	>0003		; >c0000040 -- vesync

**************************************************************************
*												*
*	   before glen shipp's suggestion                               *
*	  .word   001bh 		   ; >c0000050 -- veblnk 		*
*	  .word   011ah 		   ; >c0000060 -- vsblnk only want *
*												*
**************************************************************************

	.word	0014h		; >c0000050 -- veblnk
	.word	0112h		; >c0000060 -- vsblnk only want 255 lines displayed
	.word	0120h		; >c0000070 -- vtotal
	.word	0f010h		; >c0000080 -- dpyctl
	.word	dpystrt0	; >c0000090 -- dpystrt
	.word	eosint		; >c00000a0 -- dpyint
	.word	ini_ctrl	; >c00000b0 -- control
	.word	0		; >c00000c0 -- hstdata
	.word	0		; >c00000d0 -- hstadrl
	.word	0		; >c00000e0 -- hstadrh
	.word	0		; >c00000f0 -- hstctll
	.word	0		; >c0000100 -- hstctlh
	.word	0		; >c0000110 -- intenbl
	.word	0		; >c0000120 -- intpend
	.word	0		; >c0000130 -- convsp
	.word	0		; >c0000140 -- convdp
	.word	pxsize		; >c0000150 -- psize
	.word	0		; >c0000160 -- pmask
	.word	0		; >c0000170 -- reserved
	.word	0		; >c0000180 -- reserved
	.word	0		; >c0000190 -- reserved
	.word	0		; >c00001a0 -- reserved
	.word	56/2		; >c00001b0 -- dpytap (adjust for the curse)
idataend:
idatalen	equ	(idataend-initdata)/16

	.STRING	"MMOORRTTAALLKKOOMMBBAATT22"
	.STRING	"DDEESSIIGGNNEEDDBBYYEEDDBBOOOONN"
	.STRING "AANNDDJJOOHHNNTTOOBBIIAASS"
	.STRING "CCOOPPYYRRIIGGHHTT11999933MMIIDDWWAAYYMMAANNUUFFAACCTTUURRIINNGG"
	.even

**************************************************************************
*												*
* sysinitl - initialize low byte of system control register			*
*												*
**************************************************************************
sysinitl
	push	a0
	movi	syscinit,a0
	move	a0,@syscopy,w		;re-initialize system control reg
	move	a0,@sysctrl,w

	pull	a0
	rets

**************************************************************************
*												*
*	  display interrupt									*
*												*
**************************************************************************
dirq
	mmtm	sp,b0,b1,b2,b3,b4
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14

	setf	1,0,0
	clr	a1
	move	a1,@intpend+dip	; clear stupid interrupt pending
	move	a1,@intenb+dip	; disable display interrupt
	setf	16,1,0		; word sign extend
	eint			; enable other interrupts
	move	@irqskye,@eraseloc,w	; move in the correct color

*
* display last page plotted
*

;****************
	clr	a0
	move	@dmactrl,a0,w
	move	@dmactrl,a0,w		; stop dma

	move	@intpend,a0,w
	andni	x1e,a0
	move	a0,@intpend,w		; clear dma interupt pending
	move	@intenb,a0,w
	andni	x1e,a0
	move	a0,@intenb,w		; clear dma interupt enable
;****************

	movi	dpystrt0,a0		; assume: view page 0
	movi	page0adr+xpadding,b2	; plot to page 0
	movi	[253,0],b3		; window = page 0

	clr	a1
	move	@noflip,b0,w		; state of page flipping ??
	jrn	leave_page_alone
	jrne	stuffd			; no page flipping ---> show page 0


;	move	@gstate,a0,w
;	cmpi	gs_diag,a0	; are we in diagnostics?
;;	jreq	dirq2		; br = yes, no page flipping needed
;	jreq	leave_page_alone

*
* a0 = page to show
* b2 = page to plot to
* b3 = window clip for page
*
	movi	dpystrt0,a0		; assume: view page 0
	movi	page1adr+xpadding,b2	; plot to page 1
	movi	[509,256],b3

	move	@pageaddr,a2,l		; what page did we just plot to ??
	cmpi	page0adr+xpadding,a2
	jreq	stuffd			; page zero ---> show page zero

	movi	dpystrt1,a0		; view page 1
	movi	page0adr+xpadding,b2	; plot to page 0
	movi	[253,0],b3

stuffd
	move	a0,@dpyadr		; override dpystrt
	move	a0,@dpystrt,w		; set view page
dirq2	move	b2,@pageaddr,l		; set plot page

leave_page_alone
	move	b3,@dmatplft,l 		; set dma window to new page !

	move	@f_auto_erase,a0,w	; clear screen ?
	jreq	skip_auto		; no

	dint
	mmtm	sp,b10,b11,b12,b13,b14
	callr	srt_clr
	mmfm	sp,b10,b11,b12,b13,b14
	eint

skip_auto
	calla	transfer_palettes

	move	@timer,a1	
	inc	a1
	move	a1,@timer	; hit process timer

	move	@tick,a1,w
	inc	a1
	move	a1,@tick,w	; tick tick tick tick

	callr	swscan		; scan switches to trigger procs.

	move	@displayon,a0,w
	jreq	nodisp		; no processing while this is zero !!

	calla	display	    	; plot to new page

	move	@noflip,b0,w	; state of page flipping ??
	jrn		nodisp		; negative noflip --> don't alter anything

nodisp
	dint
	move	@intenb,a0,w	
	ori		die,a0
	move	a0,@intenb,w	; enable display interrupt
	
	calla	coinint	   	; handle some coins!

	move	@irqled,a0,w
	inc	a0
	move	a0,@irqled,w
	cmpi	8,a0
	jrlt	dirqx
*
* do everything from here to dirqx every 8 ticks
*
	clr	a0
	move	a0,@irqled,w
	move	@syscopy,a0,w	; blink l.e.d. to acknowledge operation
	xori	04h,a0
	move	a0,@syscopy,w
	move	a0,@sysctrl,w

dirqx	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14
	mmfm	sp,b0,b1,b2,b3,b4
	reti

**************************************************************************
*  clear screen routine -- using shift register transfer
srt_clr:
*	color to clear to stored in lines 510 and 511

	move	@convdp,a12,w
	movk	>12,b9
	move	b9,@convdp		;move to convdp io register

* set srt=1.  this converts pixel accesses to vram sr transfer cycles.

	move	@dpyctl,b10,w		;copy display control reg.
	move	b10,a13			; save in a file
	andni	sre+env,b10      	;turn off screen refresh
	ori	srt,b10	         	;enable sr transfers

srt3	move	@dmactrl,a0,w
	jrn	srt3

	move	b10,@dpyctl,0 		;load new display control
;	move	@dpyctl,b10,0 		;read back to be safe!
	movi	scrn_ptch*2,b3	 	;get screen pitch

* load frame buffer for 1st line into vram shift registers.

	clr	b4		    	;origin at start of memory
	movi	255*>2000,b2		;daddr
	pixt	*b2,b2			;load vram shift registers

* transfer contents of vram shift registers to rest of frame buffer.

	move	@pageaddr,b4,l
	srl	4,b4
	addi	scrtop*>1000,b4     	;origin at start of memory
	clr	b2
	movi	(1*x)+(((scrbot+1-scrtop)/2)*y),b7 ;set dydx ;*2nd +1 kluge for now

	fill	xy			; 200 sr-to-memory transfers

* restore previous contents of registers.

	move	a12,@convdp,w
   	move 	a13,@dpyctl,w		;copy display control reg.
	rets

**************************************************************************
*											     *
*  switches scanned here will activate the processes in the switch proce *
*  table.										     *
*  bashes a0,a1,a2 & a3 so beware!							     *
*											     *
**************************************************************************
swscan
	move	@switch,a0,l	; current switch state
	move	@swtemp1,a1,l	; last tick switch state
	move	@swtemp2,a2,l	; 2 ticks ago switch state
	move	a1,@swtemp2,l	; new previous previous
	move	a0,@swtemp1,l	; new previous
	move	a1,a6		; save last state
	xor	a0,a1		; a1 = bits that changed
	jreq	swsc2		; no change ---> exit
	movk	31,a7
	callr	scan_port
*
* switch port 2
*
swsc2	move	@switch2,a0,l
	move	@swtemp3,a1,l	; last tick switch state
	move	@swtemp4,a2,l	; 2 ticks ago switch state
	move	a1,@swtemp4,l	; new previous previous
	move	a0,@swtemp3,l	; new previous

	move	a1,a6		; save last state
	xor	a0,a1		; a1 = bits that changed
	jreq	swsc9		; no change ---> exit
	movi	>5f,a7

scan_port
	move	a0,a4
	not	a4
	move	a1,a5		; a5 = bits that changed
	and	a4,a5		; a5 = bits that just closed
	jreq	swsc5		; none
*
* stack the switches which just closed
*
	and	a2,a6		; only pass if last 2 states ---> open,open
	and	a6,a5		; and now its closed
	move	a5,a2		; a2 = bits to stack
	callr	stack_switch_bits
*
* stack the switches which just opened
*
swsc5	and	a0,a1		; a1 = bits that just opened
	jreq	swsc9		; none
	move	a1,a2		; a2 = bits to stack
	addi	32,a7		; next 32 bit offset
	callr	stack_switch_bits

swsc9	rets

**************************************************************************
*											     *
*  stack_switch_bits - Switch scan subroutine to put switches on the     *
*                      stack.								     *
* 											     *
*  Input: a0 = @switch									     *
*         a2 = bits to stack								     *
*         a7 = offset # to use								     *
*											     *
**************************************************************************
stack_switch_bits
	move	@swstack,a3,l	;switch activation stack
ssb2	cmpi	swstmn,a3	;switch stack overflow?
	jreq	ssb3		;yep, quit
	lmo	a2,a0		;1's comp leftmost bit
	rl	a0,a2		;get rid of bit
	sll	1,a2
	move	a7,a1		;calc true bit #
	sub	a0,a1
	move	a1,-*a3		;push switch number on stack (0-15)
	rl	a1,a2		;restore switch word without bit
	jrne	ssb2
	move	a3,@swstack,l	;restore switch stack
ssb3	rets

*************************************************************************

romtrap
	dint
	.if debug
	jauc	$
	.endif
	reti

**************************************************************************
*												*
* badtrap - come here when a trap is hit that is not defined and log it. *
*												*
**************************************************************************
badtrap
	lockup

**************************************************************************
*												*
*	  initialize all 32 trap vectors							*
*												*
**************************************************************************
	.sect	"VECTORS"

	.long	badtrap		;trap 31
	.long	illegal_opcode	;trap 30	illop --- illegal opcode
	.long	badtrap		;trap 29
	.long	badtrap		;trap 28
	.long	badtrap		;trap 27
	.long	badtrap		;trap 26
	.long	badtrap		;trap 25
	.long	badtrap		;trap 24
	.long	badtrap		;trap 23
	.long	badtrap		;trap 22
	.long	badtrap		;trap 21
	.long	badtrap		;trap 20
	.long	badtrap		;trap 19
	.long	badtrap		;trap 18
	.long	badtrap		;trap 17
	.long	badtrap		;trap 16
	.long	badtrap		;trap 15
	.long	badtrap		;trap 14
	.long	badtrap		;trap 13
	.long	badtrap		;trap 12
	.long	badtrap		;trap 11	wv --- window violation
	.long	dirq		;trap 10	di --- display interrupt
	.long	badtrap		;trap 9	hi --- host interrupt
	.long	badtrap		;trap 8	nmi -- nonmaskable interrupt
	.long	badtrap		;trap 7
	.long	badtrap		;trap 6
	.long	badtrap		;trap 5
	.long	badtrap		;trap 4
	.long	badtrap		;trap 3
	.long	romtrap		;trap 2	int2 --- external interrupt 2
	.long	dma_interupt	;trap 1	int1 --- external interrupt 1
	.long	POWERUP		;trap 0	reset

	.end
