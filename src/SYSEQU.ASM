**************************************************************************
*                                                                        *
* 	the y-unit system specific equates 				 		*
*                                                                        *
**************************************************************************
*assembly time conditional variables

;debug		equ	1	;this version is currently under construction
debug		equ	0	;add this before release!!!!!

ejbbug		equ	0

printer		equ	0 	; if 1, there is a printer hooked to sound port
yunit		equ	0 	;if 1, this version is for the y-unit at 6 bits/pixel
tunit		equ	1 	;only for palette testing
forcefree	equ	0	;1 = game hardwired free
fullprice	equ	1	;1 = all the pricings are included
ntsc		equ	0    	;if 1, then set the video to ntsc compatible

*
* machine timings
*
;machine_cycle	.equ	133	;number of nanoseconds per machine cycle:
machine_cycle	.equ	160	;number of nanoseconds per machine cycle:
				;	40mhz = 200 ns
				;	48mhz = 166 ns
				;	50mhz = 160 ns
				;	60mhz = 133 ns
micro_second	.equ	1000/machine_cycle	;machine cycles per microsecond

*
*general system equates
*
wdognum	.set	01a2b3c4dh	;"system initialized" marker

*
* pixblt stuff
*
pxsize    .set		8
scrn_ptch .set		512*pxsize
stack_st  .set		0fffc0000h
offsetval .set		0
planemsk  .set		0

	.if tunit
ini_ctrl  .set		2ch	; add cas b4 ras bit
	.else
ini_ctrl  .set		28h
	.endif


screen_width .equ	400	;screen width in pixels
screen_height .equ	254	;screen length in pixels  new

*
*system z memory map
*
scratch	.set	01000000h	;start of scratch
stckst	.set	010ffff0h	;top of stack
cmos	.equ	01400000h	;start of cmos ram
screen	.set	00h		;start of screen memory
scrne	.set	0200000h	;end of screen+1

  .if	yunit
colram	.set	01810000h	;color ram b0-b4 blu, b5-b9 grn, b10-b14 red
  .else
colram	.set	01800000h	;color ram b0-b4 blu, b5-b9 grn, b10-b14 red
  .endif

palsize .set	01000h		;physical size of a palette in color ram


*
* useful system addresses
*
rom	.set	0ff800000h	;program rom
irom	.set	02000000h	;image rom
cmapsel	.set	01a80080h	;color map select (0-15)

switch		.set	01600000h	;i/o (jamma connector and wired inputs)
switch2		.set	01600020h	;i/o (wired inputs and dip switches) 
coins		.set	01600010h
dipswitch	.set	01600030h	; dip switches for y unit

;newnew
;watchdog	.equ	1d81070h	; watch dog port
watchdog		.equ	1d01070h	; watch dog port

coin_counters	.equ	1d01020h	;coin counter drivers


**************************************************************************
*											     *
*  t-unit 2 sound equates								     *
*											     *
**************************************************************************
;newnew

;sound		.equ	1d01010h	; aux port (kludged  fpga 2.11 mk2)
;sound		.equ	1d81010h	; aux port (kludged)

sound		.equ	1d01030h	;auto strobe


soundirq 	.equ	1d00000h	;* irq input


b_sirq		.equ	7		;irq bit #

;soundbit 	.equ	0ff00h		;no strobe needed
;soundbit 	.equ	0200h		;no strobe needed
soundbit 	.equ	0100h		;no strobe needed

**************************************************************************
*											     *
*  t-unit sound equates									     *
*											     *
**************************************************************************
;sound		.equ	1c01030h	;auto strobe
;soundirq 	.equ	1c00050h	;* irq input
;b_sirq		.equ	3		;irq bit #
;soundbit 	.equ	0ff00h		;no strobe needed

talkport		.equ	1d00000h	;port to find this line
b_wdog 		.equ	4		;(l) for watchdog triggered


;sound		.set	01e00000h	;sound i/o (b0-b7 = sound#)
				;	    b8 =  music strobe (0 en)
				;	    b9 =  sound strobe (0 en)
;newnew				;	    b10 = reset (0 en)
sysctrl	.set	01b00000h	;system control latch
				;bit 0 - fg scroll 0
				;bit 1 - fg scroll 1
				;bit 2 - always 1
				;bit 3 - always 1
				;bit 4 - auto-erase enable(0)
				;bit 5 - object palette enable(0)
				;bit 6 - always 1
				;bit 7 - always 1
				;bits 8 - 15 7 seg. (dp,g - a)

;	system control latch on y unit
;
;	bit 0	+ watchdog clock
;	bit 1	+ watchdog data
;	bit 2	- led on
;	bit 3	set to 1
;	bit 4	- auto-erase enable
;	bit 5	- object palette enable
;	bit 6	+ cmos page bit 0
;	bit 7 	+ cmos page bit 1
;
*
* system stuff
*
;autoeras	.equ	10h

objpalet	.equ	20h

;newnew
;syscinit      	.equ	077ch	  	; t-unit initial sysctrl value
syscinit		.equ	007ch	  	; t-unit initial sysctrl value

;syscinit	.equ	07fch		; y-unit initial sysctrl value
;syscinit	.equ	0fffch		; other initial sysctrl value

*
*solenoid driver constants
*
coil_enable	equ	0000h		;coil enable command
left_coin	equ	1h		;left coin mask
right_coin	equ	2h		;right coin mask

*
*equates for reading sound board irq request line
*
;talkport	.equ	switch+10h	;port to find this line
;b_sirq		.equ	14		;bit to read for sound irq line

*
*interrupt constants
	.if	ntsc
endvblnk		.equ	13h		;scan line to end vertical blanking
hsint		.equ	108+endvblnk	;half screen
eosint		.equ	229+endvblnk	;end of screen
dirq2int		.equ	210+endvblnk	;just before eos
*scoreint	.equ	18+endvblnk	;end of score area interrupt
normdpys 	.equ	0febch		;normal dpystrt value
	.else
endvblnk		.equ	14h		;scan line to end vertical blanking
hsint		.equ	135+endvblnk	;half screen
eosint		.equ	254+endvblnk	;end of screen
dirq2int		.equ	246+endvblnk	;just before eos
*scoreint	.equ	18+endvblnk	;end of score area interrupt
normdpys 	.equ	0fffch		;normal dpystrt value
	.endif

eraseloc        .equ	colram + 03f0h	;game auto erase color location
erasecol        .equ	03f3f3f3fh	;game auto erase color #

gnderaloc        .equ	colram + 03e0h	;game auto erase color location
gnderacol        .equ	03e3e3e3eh	;game auto erase color #

;dpystrt0 equ	0dffch	;line 511
;dpystrt1 equ	0f01ch	;line 255
;page0adr equ	00h	;(1 dead, 44 score, 210 playfield)*2, 2 autoerase
;page1adr equ	scrhght*8*512 ;256*8*512

*dpypage0	.equ	normdpys	;dpystrt value to display page0
*dpypage1	.equ	((~(eosint-endvblnk))*10h)|0ch
*page1xy		.equ	[256,0]		;origin of graphics page 1 (x must =0)
page0e		.equ	0fe000h	;end of page0+1

*
* dma stuff
*
dmaregs:	.equ	01a800c0h	;bottom of dma registers for mmtm

					;bit 15:
					;1=start dma (write)
					;0=stop dma  (write)
				
					;1=dma busy (read)
					;0=dma idle (read)
dmaoffst:	.equ	01a80000h	;dma offset register
dmactrl:		.equ	01a80010h	;dma control register
dmasagl:		.equ	01a80020h	;dma data starting address low 16 bits
dmasagh:		.equ	01a80030h	;dma data starting address high 16 bits
dmahoriz:	.equ	01a80040h	;dma destination, x coordinate
dmavert:		.equ	01a80050h	;dma destination, y coordinate
dmahsize:	.equ	01a80060h	;dma destination, x size	
dmavsize:	.equ	01a80070h	;dma destination, y size
dmacmap:		.equ	01a80080h	;dma color map select
dmaconst:	.equ	01a80090h	;dma constant color substitute
dmaxscl:		.equ	01a800a0h	;dma x scale reg
dmayscl:		.equ	01a800b0h	;dma y scale reg
dmatplft:	.equ	01a800c0h	;dma top left window border
dmartbot:	.equ	01a800d0h	;dma rt bottom window border
dmarsrvd1:	.equ	01a800e0h	;dma reserved test register
dmaconfig:	.equ	01a800f0h	;dma config register

**************************************************************************
*											     *
*  these are different equates of the same shit. why, you might ask ?    *
*  cuz shawn likes to be different from everyone else, thats why !	     *
*											     *
**************************************************************************
dmascalex	.equ	1a800a0h	;x scale 8:8
dmascaley	.equ	1a800b0h	;y ^
dmawindow	.equ	1a800c0h	;window lr or tb
dmatest		.equ	1a800e0h	;?
dmaconf		.equ	1a800f0h	;config
*
* layout of dma config register
*
dmawin		.set	20h		; bit 5	  (0 = rt/lft, 1 = top/bot)
dmacf4		.set	10h		; bit 4	  timing parameter


*	layout of dma control register
dmawz	.set	8001h	; bit 0	     write zero data
dmawnz	.set	8002h	; bit 1	     write non-zero data
dmacz	.set	8004h	; bit 2	     subst zero data with constant
dmacnz	.set	8008h	; bit 3      subst non-zero data with constant
dmawal	.set	8003h	; write both zero & non-zero data
dmacal	.set	800ch	; write constant on both zero & non-zero data
dmahfl	.set	0010h	; bit 4	     horz flip
dmavfl	.set	0020h	; bit 5	     vert flip
dmaclp	.set	0040h	; bit 6	     clip using udlr method (0=offset method)
dmacmp	.set	0080h	; bit 7	     zero compression on
dmaldx	.set	0300h	; bits 8-9   leading zero multiplier (0-3 = 1x,2x,4x,8x)
dmatrx	.set	0c00h	; bits 10-11 trailing zero multiplier (0-3 = 1x,2x,4x,8x)
dmabpp	.set	7000h	; bits 12-14 bits per pixel (1-7, 0=8)
dmago	.set	8000h	; bit 15     dma go/halt
			;	    (one '0' write halts dma,
			;     	     two '0' writes kills xfer,
			;     	     one '1' write restarts/starts) 


b_dmago	.set	15	; dma "go" bit
b_dmacmp	.set	7	; dma zero compression "on" bit


*	layout of dma config register
;note:
;try fixing auto-erase line trashing bug by changing equate to 030h
dmaywin	.set	20h	; bit 5	  (0 = rt/lft, 1 = top/bot)
dmacf4	.set	10h	; bit 4 (dma timing bit)

*
* layout of image header (new)
*
isize		equ	0
isizex		equ	0
isizey		equ	10h
ianioff		equ	20h
ianioffx 	equ	20h
ianioffy 	equ	30h
isag		equ	40h
icontrol  	equ	60h
icmap		equ	70h

zm		.set	1		;z minus multiplier
zp		.set	010000h		;z plus multiplier
*
*sound processor equates
nint	.equ	0800h		;sound non-interruptable

*------- register names for tms34010 assembly language functions -------

*-----------------------------------------------------------------------
* define names of i/o registers
*-----------------------------------------------------------------------
hesync	.set	0c0000000h
heblnk	.set	0c0000010h
hsblnk	.set	0c0000020h
htotal	.set	0c0000030h
vesync	.set	0c0000040h
veblnk	.set	0c0000050h
vsblnk	.set	0c0000060h
vtotal	.set	0c0000070h
dpyctl	.set	0c0000080h
dpystrt	.set	0c0000090h
dpyint	.set	0c00000a0h
control	.set	0c00000b0h
hstdata	.set	0c00000c0h
hstadrl	.set	0c00000d0h
hstadrh	.set	0c00000e0h
hstctll	.set	0c00000f0h
hstctlh	.set	0c0000100h
intenb	.set	0c0000110h
intpend	.set	0c0000120h
convsp	.set	0c0000130h
convdp	.set	0c0000140h
psize	.set	0c0000150h
pmask	.set	0c0000160h
* i/o register locations 23-27 are reserved for future expansion
hcount	.set	0c00001c0h
vcount	.set	0c00001d0h
dpyadr	.set	0c00001e0h
refcnt	.set	0c00001f0h


x	.set	1
y	.set	010000h

w	.set	0
l	.set	1
w	.set	0
l	.set	1


*-----------------------------------------------------------------------
* masks for i/o register fields:
*-----------------------------------------------------------------------

*	status bit masks
cbit	.equ	40000000h

*	display control register bit definitions
hsd	.set	01h		; horizontal sync direction
dudate	.set	0000001111111100b	; display update (2-9)
org	.set	0400h		; origin (1 = lower left; 0 = upper left)
srt	.set	0800h		; shift reg transfer enable
sre	.set	01000h		; screen refresh enable
dxv	.set	02000h		; disable external video
nil	.set	04000h		; non-interlaced video enable
env	.set	08000h		; enable video

*	bit fields within control register
cd	.set	08000h		;mask for cache dis bit in control
ppop	.set	07c00h		;mask for pix proc oper in control
pbh	.set	0200h		;mask for pbh bit in control
pbv	.set	0100h		;mask for pbv bit in control
win	.set	0c0h		;mask for window field in control
t	.set	020h		;mask for transparency field in control
rr	.set	018h		;mask for dram refresh rate bit in control
rm	.set	04h		;mask for dram refresh mode bit in control

*	bits within intpend and intenb
wvp	.set	0800h		;mask for window violation in intpend
die	.set	0400h		;mask for disp int in intpend
hie	.set	0200h		;mask for host int in intpend
x2e	.set	04h		;mask for ext int 2 in intpend 
x1e	.set	02h		;mask for ext int 1 in intpend
b_x1e	.set	1		;bit pos for ext int 1 in intpend

*	bit positions in intpend
dip	.equ	10		;bit test for display interrupt pending

*	fields within hstctll
msgin		.set	07h	; message from host to gsp
intin_msk	.set	08h	; gsp can write 0 to this bit (andni)
intin_bit	.set	03h 	; gsp can write 0 to this bit (andni)
intout_msk	.set	080h	; gsp can write 1 to this bit (ori)
intout_bit 	.set	07h 	; gsp can write 1 to this bit (ori)

* options for window field in control reg
*w0	(andni) no writes inhibited, no interrupt
w3	.set 0c0h	;inhibit writes outside window, no interrupt
w2	.set	080h	;inhibit all writes, int on attempt to write within window
w1	.set	040h	;int on attempt to write outside window.

*options for pixel proc operations in control reg 
* ppop  (andni)	replace
p_and	.set	0400h
p_andnot	.set	0800h
p_zero	.set	0c00h
p_ornot	.set	01000h
p_xnor	.set	01400h
p_neg	.set	01800h
p_nor	.set	01c00h
p_or	.set	02000h
p_nop	.set	02400h
p_xor	.set	02800h
p_notand	.set	02c00h
p_ones	.set	03000h
p_notor	.set	03400h
p_nand	.set	03800h
p_not	.set	03c00h
p_add	.set	04000h
p_adds	.set	04400h
p_sub	.set	04800h
p_subs	.set	04c00h
p_max	.set	05000h
p_min	.set	05400h

saddr		.set	b0		;source address register
sptch		.set	b1		;source pitch register
daddr		.set	b2		;dest. address register
dptch		.set	b3		;dest. pitch register
offset		.set	b4		;xy offset register
***wstart	.set	b5		;window start register
***wend		.set	b6		;window end register
dydx		.set	b7		;delta x/delta y register
color0		.set	b8		;color 0 register
color1		.set	b9		;color 1 register
***count		.set	b10
***inc1		.set	b11
***inc2		.set 	b12
***pattrn	.set	b13

