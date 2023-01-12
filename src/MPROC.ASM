	.file	'mproc.asm'
	.title	"gsp multi-processing system version 1.0 eugene p. jarvis"

**************************************************************************
*												*
*	copyright (c) 1988 williams electronics games, inc.			*
*	all rights reserved.									*
*												*
**************************************************************************

	.width	132
	.option	b,d,l,t
	.mnolist
*
* files required for assembly
*
	.include sysequ.asm	;sys.inc and gsp.inc
	.include dispequ.asm
	.include mainequ.asm
	.include macros.hdr

	.ref	timeint,get_aud
*
* global process variables
*
	.bss	active,32,1		; pointer to active process list
	.bss	free,32,1		; pointer to free process list
	.bss	timer,16		;irq timer 16 msec.
	.bss	timetemp,16		;last timer value
	.bss	overload,16		;overload checker
	.bss	prcstr,nproc*prcsiz	;process store allocation

	.text			;store in program rom

*
* process dispatch
*
prcdsp:	
	movi	active,a13,l	;long word init scan process list
prcwtsrt
	calla	yzsort		;sort display list

	move	@timer,a0
	jreq	prcwtsrt	;br = wait for timing from interrupt, sort
	move	a0,@timetemp,w	;save

	sll	1,a0
	move	@overload,a1,w
	add	a0,a1
	srl	1,a1
	move	a1,@overload,w

	calla	timeint		;call before clearing timer (CLOCK ROUTINE)

	clr	a0
	move	a0,@timer
	jruc	prcd1
*
* process sleep
* tos is wakeup addr ,a0 = sleep time
*
prcslp
	move	*sp+,a7,l		; calling pc->a7

prclsp	move	a13,a1
	addi	pdata,a1
	mmtm	a1,a7,a8,a9,a10,a11,a12 ;wakeup, regs, stack ptr
	move	a0,-*a1,w		;sleep

         .if debug			;this is for debug only
	move	a13,a0
	addi	psdata,a0
	cmp	a0,a12
	jrlt	$			;stick on stack overflow
	addi	prcsiz-psdata,a0
	cmp	a0,a12
	jrgt	$			;stick on stack underflow
         .endif

prcd1:	
************************************
*	move	@timetemp,a1,w		;get the last timer value
************************************
prcd1a
	move	*a13,a13,l
	jreq	prcdx		;null list, exit
	move	*a13(ptime),a0	;get count
************************************
*	sub	a1,a0
************************************
	dec	a0		;decrement count	
	move	a0,*a13(ptime)	;put it back
	jrgt	prcd1a		;not ready, loop for next

*process is ready for dispatch

prcd2:	
	move	a13,a1
	addi	>40,a1
	mmfm	a1,a7,a8,a9,a10,a11,a12	; wake, regs, stack ptr
	jump	a7				; fire off proc

*done with the scan

prcdx:	rets
*
*process suicide
*
sucide:	
	movi	active,a1,l
suclp:	
	move	a1,a2		;save previous
	move	*a1,a1,l
	jrne	suclp1
	.if debug		;this is for debug only
	lockup
	.endif
suclp1:
	cmp	a1,a13		;check for match to current process
	jrne	suclp		;not found keep looking
	move	*a1,*a2,l	;link around in active list	
	move	@free,a0,l	;get free pointer
	move	a0,*a1,l	;link into free list at start
	move	a1,@free,l
	move	a2,a13		;set current process to previous
	jruc	prcd1		;continue with dispatch

*
* process list initialize
* a13 returned pointing to active list (crproc)
*
pinit:	
	mmtm	sp,a0,a1,a2,a3	;save reg		
	movi	nproc,a3,w	;# of processes to init
	clr	a0
	move	a0,@active,l	;null active list
	movi	prcstr,a1,l
	move	a1,@free,l	;setup free list
pinitl:
	move	a1,a2
	addi	prcsiz,a1,w
	move	a1,*a2,l	;link em up
	dsjs	a3,pinitl	;continue for nproc
	move	a0,*a2,l	;zero last link
	movi	active,a13,l	;init current process
	mmfm	sp,a0,a1,a2,a3	;restore regs
	rets

*
*kill process
*a0 points to process to kill
*if process not present, causes error
*to kill yourself sucide must be used,
*if you attempt to kill yourself it will just return
*
kill:	
        cmp	a0,a13		;killing yourself?
	jreq	killxxx		;br = yes, just escape
	mmtm	sp,a1,a2
	movi	active,a1,l
killp:	
	move	a1,a2		;save previous
	move	*a1,a1,l
	jrnz	killchk

	lockup

*	callerr	2		;log the error
*	jruc	killx
killchk
	cmp	a1,a0
	jrne	killp		;not found keep looking
	move	*a0,*a2,l	;link around in active list	
	move	@free,a1,l	;link into free list at start
	move	a1,*a0,l
	move	a0,@free,l
killx
	mmfm	sp,a1,a2
killxxx
	rets
*
*create a process
*a1=id,a7=pc,a8,a9,a10,a11 passed parameters
*a13=current process
*a0 is returned pointing to created process
*
getprc:	
	mmtm	sp,a2,a12
	move	@free,a0,l
	jreq	getpx		;none available
	move	*a0,a2,l	                
	move	a2,@free,l	;remove from free list
	move	*a13,*a0,l	;link into active list after current process
	move	a0,*a13,l	;crproc>>new proc
	jruc	xferprc0

* xferproc - transfer control of an existing process
* a0 = ptr of process to be xfer'd
* a1 = new i.d.
* a7 = wake up
* a8 - a11 = passed to the xfer'd proc

xferproc
	mmtm	sp,a2,a12
xferprc0
	move	a0,a2
	addi	pdata,a2		
	move	a0,a12			;reset process stack pointer
	addi	prcsiz,a12
	mmtm	a2,a7,a8,a9,a10,a11,a12	;stuff wake, regs, p stack ptr
	movk	1,a12
	move	a12,-*a2,w		;wake up as soon as possible
	move	a1,-*a2,w		;id
getpx
	mmfm	sp,a2,a12
	rets
*
*kill a class of processes
*a0=procid (16 bits) ,a1=mask (16 bits)
*mask bits of zero are dont cares
*will not kill calling process (a13)
*
kilall:	
	mmtm	sp,a0,a1,a2,a3,a4,a5
	and	a1,a0		;form match
	movi	active,a2,l

kilalp:	
	move	a2,a3		;save previous
	move	*a2,a2,l	;get next
	jreq	kilalx		;all done
	move	*a2(procid),a4
	and	a1,a4		;can dont care bits
	cmp	a0,a4		;match?
	jrne	kilalp		;no

	cmp	a2,a13		;current process?
	jreq	kilalp		;yes dont kill

	move	*a2,*a3,l	;link around in active list	
	move	@free,a5,l	;link into free list at start
	move	a5,*a2,l
	move	a2,@free,l	;point free to cell
	move	a3,a2
	jruc	kilalp		;kill the rest
kilalx:	
	mmfm	sp,a0,a1,a2,a3,a4,a5
	rets

*
* find if at least one process, other than calling process,
* exists.
* a0=procid (16 bits) ,a1=mask (16 bits)
* mask bits of zero are dont cares
* returns:
* z bit set = no match, a0 = 0
* z bit clr = match,	a0 = ptr to process
*
existp:	
	mmtm	sp,a1,a2,a4
	sext	a0,w
	and	a1,a0		;form match
	movi	active,a2,l

exnxt:	
	move	*a2,a2,l	;get next
	jreq	exsc		;all done
	move	*a2(procid),a4
	and	a1,a4		;can dont care bits
	cmp	a0,a4		;match?
	jrne	exnxt		;no

	cmp	a2,a13		;current process?
	jreq	exnxt		;yes, then we don't care
exsc
	move	a2,a0
	mmfm	sp,a1,a2,a4
	rets

*get a preserved register from a sleeping process
*a0 = ptr to sleeper

;geta11	move	*a0(pa11),a11,l
;	rets
;geta10	move	*a0(pa10),a10,l
;	rets
;geta9	move	*a0(pa9),a9,l
;	rets
;getregs
;	move	*a0(pa11),a11,l
;	move	*a0(pa10),a10,l
;	move	*a0(pa9),a9,l
;geta8	move	*a0(pa8),a8,l
;	rets
;getwake	move	*a0(pwake),a7,l
;	rets


;puta11	move	a11,*a0(pa11),l
;	rets
;puta10	move	a10,*a0(pa10),l
;	rets
;puta9	move	a9,*a0(pa9),l
;	rets
;putregs
;	move	a11,*a0(pa11),l
;	move	a10,*a0(pa10),l
;	move	a9,*a0(pa9),l
;puta8	move	a8,*a0(pa8),l
;	rets
;puta7
;putwake	move	a7,*a0(pwake),l
;	rets


	.end
