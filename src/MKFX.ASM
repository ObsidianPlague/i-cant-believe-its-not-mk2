**************************************************************************
*											     *
*  video game project:	mortal kombat 2							*
* 											     *
*  game software:    	ed boon								     *
* 											     *
*  module: mkfx.asm ---  special fx								*
* 											     *
*  copyright (c) 1993 midway manufacturing							*
*											     *
**************************************************************************
	.file	'mkfx.asm'
	.width	132
	.option	b,d,l,t
	.mnolist
*
* get the system stuff
*
	.include	dispequ.asm
	.include	sysequ.asm
	.include	macros.hdr
	.include	mainequ.asm
	.include	imgtbl.glo
	.include	mkfx.tbl
	.text

;*************************************************************************

MKRIGHT1:
	.word   156,14,0,0
	.long   0567636cH
	.word   01f80H
	.long   MKRITE_P

mk2_intro
	calla	murder_myoinit_score

	movi	>38,a3
	calla	send_code_a3
	movi	(32*32*12)+(32*0)+3,a0
	movi	(32*32*0)+(32*0)+3,a0
	move	a0,@irqskye,w
	movi	dlists_bogus,a0
	move	a0,@dlists,l

	movi	MKRIGHT1,a5
	calla	gso_dmawnz
	movi	>00e80000,a4
	calla	set_xy_coordinates
	calla	center_obj_x
	calla	insobja8

	movi	thunder_table,a7
mkint3	movi	bigthund1,a5
	calla	gso_dmawnz

	move	*a7+,a1,l
	calla	ani_flag
	move	*a7+,a4,l
	calla	set_xy_coordinates
	callr	make_pal_animator
	jrne	mkint3

	addi	32,a7

mkint5	push	a7
	movi	multi_cloud3,a9
	calla	gmo_proc
	pull	a7

	move	*a7+,a9,l
	calla	do_next_a9_frame
	
	move	*a7+,a4,l
	calla	set_xy_coordinates
	callr	make_pal_animator
	jrne	mkint5
*
* lightning strike
*
	sleep	>40*3

	movi	multi_cloud3,a9
	calla	gmo_proc
	movi	a_two_strike,a9
	calla	gmo_proc

	movi	>004000d0,a4
	calla	set_xy_coordinates
	calla	insobja8

	movi	a_two_strike,a9
	movk	4,a0
	jsrp	mframew

	sleep	>10

*
* slide in MK letters
*
	movi	>80000,a11
	movi	mortaltxt,a5
	calla	gso_dmawnz
	movi	>005d0010,a4
	calla	set_xy_coordinates
	move	a8,a9

	movi	kombatxt,a5
	calla	gso_dmawnz
	movi	>005d00c6,a4
	calla	set_xy_coordinates

	move	a11,*a9(oxvel),l
	neg	a11
	move	a11,*a8(oxvel),l

	movi	>a0,a6
	move	*a8(oxpos),a0,w
	add	a6,a0
	move	a0,*a8(oxpos),w
	move	*a9(oxpos),a0,w
	sub	a6,a0
	move	a0,*a9(oxpos),w

	movk	1,a0
	move	a0,@f_novel,w
	calla	insobj2a8
	move	a9,a0
	calla	insobj2

	clr	a0
	move	a0,@f_novel,w
	sleep	20

	tsound2	>01

	movk	1,a0
	move	a0,@f_novel,w

	movi	>00040006,a11
	calla	shake_a11
	sleep	>e0
	retp
*
* grow the letters
*
	movi	>01000100,a10
	jauc	wait_forever


;***************************************************************************

make_pal_animator
	move	*a8(oypos),*a8(ograv),w
	calla	insobja8
	move	*a7+,a10,l
	jreq	mkint4
	push	a7
	create	pid_fx,cloud_pal_animator
	pull	a7
mkint4	move	*a7,a5,l
	rets

;***************************************************************************

cloud_pal_animator
	move	*a8(oypos),a0,w
	move	a0,*a8(ograv),w
	addi	>f00,a0
	move	a0,*a8(oypos),w

	move	*a10+,a0,w
	calla	prcslp

cpani2	move	*a10+,a0,l
	jaeq	sucide

	cmpi	ani_sound,a0	
	jrne	cpani3
	move	*a10+,a0,w
	calla	triple_sound2
	jruc	cpani2


cpani3	cmpi	ani_jump,a0
	jrne	cpani1
	move	*a10,a10,l
	jruc	cpani2

cpani1	cmpi	-1,a0
	jrne	cpani4

	move	*a8(oypos),a0,w
	move	a0,*a8(ograv),w
	addi	>f00,a0
	move	a0,*a8(oypos),w
	jruc	cpani5

cpani4	move	*a8(ograv),*a8(oypos),w	; back on screen
	calla	swpal
cpani5	move	*a10+,a0,w
	calla	prcslp
	jruc	cpani2



thunder_table
	.long	thunder1,>00b00020,pa_thunder1
	.long	thunder2,>001000f0,pa_thunder2			; upper right
	.long	0

	.long	multi_cloud3,>00600148,pa_thunder5
	.long	multi_cloud4,>ff90ffd0,pa_thunder6
	.long	multi_logo1,>00200050,pa_thunder3		; bottom of logo
	.long	multi_logo2,>00280079,pa_thunder4		; top of logo
	.long	0

pa_thunder6
	.word	>c0
	.long	ani_jump,jthun3

pa_thunder5
	.word	>90
	.long	ani_jump,jthun3

pa_thunder2
	.word	>30
	.long	ani_jump,jthun3

pa_thunder1
	.word	>1

jthun3	.long	ani_sound
	.word	2


keep_flashing

jthun4	.long	KOMCLD1_p

	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD3_p
	.word	4
	.long	KOMCLD4_p
	.word	4
	.long	KOMCLD5_p
	.word	4
	.long	-1
	.word	>30

	.long	KOMCLD5_p
	.word	4
	.long	KOMCLD4_p
	.word	4
	.long	KOMCLD3_p
	.word	4

	.long	KOMCLD2_p
	.word	4
	.long	KOMCLD1_p
	.word	4
	.long	ani_jump,keep_flashing

	.long	0


pa_thunder4
	.word	>48

keep_flashing2
	.long	ani_sound
	.word	2
	.long	KOMCLD1_p

	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	5
	.long	KOMCLD2_p
	.word	5
	.long	KOMCLD3_p
	.word	5
	.long	KOMCLD4_p
	.word	5
	.long	KOMCLD5_p
	.word	5
	.long	-1
	.word	>40

	.long	ani_jump,keep_flashing2

	.long	0


pa_thunder3
	.word	>80

	.long	ani_sound
	.word	2
	.long	KOMCLD1_p

	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	5
	.long	KOMCLD2_p
	.word	5
	.long	KOMCLD3_p
	.word	5
	.long	KOMCLD4_p
	.word	5
	.long	KOMCLD5_p
	.word	5
	.long	-1

	.word	>10
*
* long delay
*
	.long	ani_sound
	.word	2

keep_flashing3
	.long	KOMCLD1_p

	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	4
	.long	KOMCLD2_p
	.word	4

	.long	KOMCLD1_p
	.word	6
	.long	KOMCLD2_p
	.word	6
	.long	KOMCLD3_p
	.word	6
	.long	KOMCLD4_p
	.word	6
	.long	KOMCLD5_p
	.word	6
	.long	-1
	.word	6

	.long	ani_jump,keep_flashing3


	.long	0

;*******************************************************************

multi_cloud3
	.long	thunder3
multi_cloud4
	.long	thunder4
multi_logo1
	.long	mklogo1
multi_logo2
	.long	mklogo2

thunder3	.long	thunder3a,thunder3b,thunder3c,0
thunder4	.long	thunder4a,thunder4b,thunder4c,thunder4d,0
mklogo1	.long	mk2logo1a,mk2logo1b,mk2logo1c,0
mklogo2	.long	mk2logo2a,mk2logo2b,mk2logo2c,0

;*******************************************************************

KOMCLD3_p:
   .word   62 
   .word   00003h,008aah,008eah,00401h,025d3h,02992h,02612h,02592h
   .word   021f1h,02571h,011b0h,0196eh,01dafh,019afh,0192dh,0118eh
   .word   01d4dh,0194eh,0150eh,0116dh,0096dh,0154ch,00d4ch,0150ch
   .word   0090ch,010ech,010cch,00d2bh,00d0bh,00ccah,008cah,0088ah
   .word   00ce9h,004e9h,00cc9h,004c8h,000c8h,00c88h,00488h,00088h
   .word   00448h,00048h,008a7h,000a7h,00466h,00066h,00446h,00046h
   .word   00006h,00465h,00065h,00025h,00444h,00024h,00404h,00004h
   .word   00004h,00023h,00003h,00003h,00003h,00001h

KOMCLD4_p:
   .word   62 
   .word   00003h,00048h,00088h,00000h,0096eh,00d2fh,009b0h,0090eh
   .word   0058fh,0090ch,0014eh,000ech,0014dh,0014dh,000cbh,0012ch
   .word   000ebh,000ech,000ach,0010bh,0010bh,000eah,000eah,000aah
   .word   000aah,0008ah,0006ah,000c9h,000a9h,00068h,00068h,00028h
   .word   00087h,00087h,00067h,00066h,00066h,00026h,00026h,00026h
   .word   00006h,00006h,00045h,00045h,00004h,00004h,00004h,00004h
   .word   00004h,00003h,00003h,00003h,00002h,00003h,00003h,00003h
   .word   00003h,00003h,00003h,00003h,00003h,00003h

KOMCLD5_p:
   .word   62 
   .word   00003h,00005h,00025h,00003h,000cbh,000c9h,0014dh,000a9h
   .word   0012ch,00089h,000ebh,00088h,000eah,000eah,00067h,000c9h
   .word   00088h,00067h,00046h,000a8h,000a8h,00087h,00087h,00045h
   .word   00047h,00026h,00005h,00066h,00046h,00004h,00005h,00003h
   .word   00024h,00024h,00004h,00003h,00003h,00003h,00003h,00003h
   .word   00003h,00003h,00003h,00002h,00003h,00003h,00003h,00003h
   .word   00003h,00003h,00003h,00003h,00000h,00003h,00003h,00003h
   .word   00003h,00003h,00003h,00003h,00003h,00003h

;*************************************************************************

a_two_strike
	.long	stk1	
	.long	stk2	
	.long	stk3	
	.long	ani_calla,zap_sound
	.long	stk4	
	.long	stk5	
	.long	stk6	
	.long	stk7	
	.long	stk8	
	.long	stk9	
	.long	stk10
	.long   stk11
	.long	stk12
	.long	stk13
	.long	0

zap_sound
	tsound2	>04
	rets


stk1	.long	strike1,0
stk2	.long	strike2,0
stk3	.long	strike3,0
stk4	.long	strike4,0
stk5	.long	strike5a,strike5b,strike5c,0
stk6	.long	strike6a,strike6b,strike6c,0
stk7	.long	strike7,0
stk8	.long	strike8,0
stk9	.long	strike9,strike9b,0
stk10	.long	strike10,strike10b,0
stk11	.long	strike11,0
stk12	.long	strike12,0
stk13	.long	strike13,0

;******************************************************************
;PON>
;---> bigthund1,mortaltxt,kombatxt,mortalbolt1
;POF>
;---> 
;---> 
;---> 
;---> 
;---> 
;---> thunder1,thunder2
;---> thunder3a,thunder3b,thunder3c,
;---> mortalbolt2,mortalbolt3,mortalbolt4,mortalbolt5,mortalbolt6
;---> 

;*************************************************************************

;wdmatest
;	movi	dlists_bogus,a0
;	move	a0,@dlists,l
;
;	movi	FIGHT,a5
;	movi	TMSTANCE1A,a5
;	calla	gso_dmawnz_ns
;	movi	>00500050,a4
;	calla	set_xy_coordinates
;	calla	insobja8
;	jauc	wait_forever



drain_table
	.long	a_hhdrained
	.long	a_lkdrained
	.long	a_jcdrained
	.long	a_sadrained

	.long	a_fn1drained
	.long	a_fn2drained
	.long	a_stdrained
	.long	a_rddrained

	.long	a_szdrained
	.long	a_rpdrained
	.long	a_scdrained
	.long	a_jxdrained

	.long	a_hhdrained
	.long	a_hhdrained
	.long	a_hhdrained
	.long	a_hhdrained

a_hhdrained
	.long	HHDRAIN1
	.long	HHDRAIN2
	.long	HHDRAIN3
	.long	0

	.long	HHDRAIN2
	.long	HHDRAIN1
	.long	HHDRAIN2
	.long	HHDRAIN3
	.long	0

HHDRAIN0	.long	TMSOULSUCK1,0
HHDRAIN1	.long	SOULSUCKHAT1A,0
HHDRAIN2	.long	SOULSUCKHAT2A,0
HHDRAIN3	.long	SOULSUCKHAT3A,0

a_lkdrained
	.long	LKDRAIN1
	.long	LKDRAIN2
	.long	LKDRAIN3
	.long	0
	.long	LKDRAIN2
	.long	LKDRAIN1
	.long	LKDRAIN2
	.long	LKDRAIN3
	.long	0

LKDRAIN0	.long	LKSOULSUCK1,0
LKDRAIN1	.long	SOULSUCKHO1A,0
LKDRAIN2	.long	SOULSUCKHO2A,0
LKDRAIN3	.long	SOULSUCKHO3A,0

a_jcdrained
	.long	JCDRAIN1
	.long	JCDRAIN2
	.long	JCDRAIN3
	.long	0
	.long	JCDRAIN2
	.long	JCDRAIN1
	.long	JCDRAIN2
	.long	JCDRAIN3
	.long	0

JCDRAIN0	.long	JCSOULSUCK1,0
JCDRAIN1	.long	SOULSUCKJC1A,SOULSUCKJC1B,0
JCDRAIN2	.long	SOULSUCKJC2A,SOULSUCKJC2B,0
JCDRAIN3	.long	SOULSUCKJC3A,SOULSUCKJC3B,0

a_sadrained
	.long	SADRAIN1
	.long	SADRAIN2
	.long	SADRAIN3
	.long	0
	.long	SADRAIN2
	.long	SADRAIN1
	.long	SADRAIN2
	.long	SADRAIN3
	.long	0

SADRAIN0	.long	UGSOULSUCK1,0
SADRAIN1	.long	SOULSUCKUG1A,0
SADRAIN2	.long	SOULSUCKUG2A,0
SADRAIN3	.long	SOULSUCKUG3A,0

a_fn1drained
a_fn2drained
	.long	FNDRAIN1
	.long	FNDRAIN2
	.long	FNDRAIN3
	.long	0
	.long	FNDRAIN2
	.long	FNDRAIN1
	.long	FNDRAIN2
	.long	FNDRAIN3
	.long	0

FNDRAIN0	.long	KTSOULSUCK1,0
FNDRAIN1	.long	SOULSUCKKT1A,0
FNDRAIN2	.long	SOULSUCKKT2A,0
FNDRAIN3	.long	SOULSUCKKT3A,0

a_stdrained
	.long	STDRAIN1
	.long	STDRAIN2
	.long	STDRAIN3
	.long	0
	.long	STDRAIN2
	.long	STDRAIN1
	.long	STDRAIN2
	.long	STDRAIN3
	.long	0

STDRAIN0	.long	STSOULSUCK1,0
STDRAIN1	.long	SOULSUCKST1A,0
STDRAIN2	.long	SOULSUCKST2A,0
STDRAIN3	.long	SOULSUCKST3A,0

a_rddrained
	.long	RDDRAIN1
	.long	RDDRAIN2
	.long	RDDRAIN3
	.long	0
	.long	RDDRAIN2
	.long	RDDRAIN1
	.long	RDDRAIN2
	.long	RDDRAIN3
	.long	0

RDDRAIN0	.long	RDSOULSUCK1,0
RDDRAIN1	.long	SOULSUCKRAD1A,0
RDDRAIN2	.long	SOULSUCKRAD2A,0
RDDRAIN3	.long	SOULSUCKRAD3A,0

a_szdrained
a_rpdrained
a_scdrained
	.long	NJDRAIN1
	.long	NJDRAIN2
	.long	NJDRAIN3
	.long	0
	.long	NJDRAIN2
	.long	NJDRAIN1
	.long	NJDRAIN2
	.long	NJDRAIN3
	.long	0

NJDRAIN0	.long	NJSOULSUCK1,0
NJDRAIN1	.long	SOULSUCKNIN1A,0
NJDRAIN2	.long	SOULSUCKNIN2A,0
NJDRAIN3	.long	SOULSUCKNIN3A,0

a_jxdrained
	.long	JXDRAIN1
	.long	JXDRAIN2
	.long	JXDRAIN3
	.long	0
	.long	JXDRAIN2
	.long	JXDRAIN1
	.long	JXDRAIN2
	.long	JXDRAIN3
	.long	0

JXDRAIN0	.long	JXSOULSUCK1,0
JXDRAIN1	.long	SOULSUCKJAX1A,0
JXDRAIN2	.long	SOULSUCKJAX2A,0
JXDRAIN3	.long	SOULSUCKJAX3A,0


a_final_drain
	.long	FINALDRN
	.long	0

FINALDRN	.long	CORPSE1A,0


alternate_suck_pals
	.long	TMG_SK_P
	.long	LKR_SK_P
	.long	JCR_SK_P
	.long	UGR_SK_P

	.long	KTP_SK_P
	.long	KTP_SK_P

	.long	STY_SK_P
	.long	RDR_SK_P
	.long	SUB_SK_P
	.long	REP_SK_P
	.long	SCR_SK_P
	.long	JXR_SK_P


TMG_SK_P:
   .word   60 
   .word   00000h,06b5ah,04e73h,04210h,0318ch,01ce7h,014a5h,07796h
   .word   06b12h,05aaeh,04e4ah,045e8h,03dc6h,03586h,057b5h,017a7h
   .word   00f6eh,00f44h,0272ah,04f04h,046f6h,002eah,056d1h,03ecah
   .word   022a9h,02a2eh,03620h,03e0eh,025c1h,025aah,029a6h,011a1h
   .word   01989h,02966h,02565h,02122h,01d22h,00d26h,01504h,018e0h
   .word   014e2h,008e5h,004a4h,00ca0h,00c82h,00862h,00860h,00440h
   .word   05ecah,03583h,00400h,06735h,056b4h,04a4eh,03de9h,02943h
   .word   02106h,01080h,035a5h,02101h

;**********************************************************************

LKR_SK_P:
   .word   63 
   .word   00000h,07bb9h,07b97h,07795h,07775h,07752h,0760bh,06b32h
   .word   06aceh,06947h,0628dh,05eaeh,05a4bh,055c9h,05208h,050e4h
   .word   04cc3h,04944h,048a3h,04609h,045e9h,045c6h,045a4h,04483h
   .word   04163h,040e2h,03cc2h,039a9h,039a4h,03923h,03564h,03523h
   .word   034a2h,02d01h,02c82h,02923h,024c1h,01881h,03fceh,01ba6h
   .word   02b6ch,02f28h,01ee8h,01a81h,02a6bh,0464dh,02e43h,00622h
   .word   015c0h,011a5h,00541h,018e0h,010a1h,00c81h,00461h,035a4h
   .word   02d64h,02526h,02103h,018c4h,018c2h,014a2h,00841h

;**********************************************************************

JCR_SK_P:
   .word   64 
   .word   00000h,07b73h,07b32h,07730h,06aaeh,05ab2h,05a6ch,0564ch
   .word   05609h,0520bh,04e08h,045c8h,041a7h,03dc8h,03986h,03983h
   .word   03564h,03142h,02d24h,020e5h,020e2h,018a1h,023c8h,01ee5h
   .word   036ceh,02a6bh,00229h,00622h,03e0ah,019e7h,015a1h,01d05h
   .word   01d02h,00101h,018e2h,014c2h,010a4h,010a2h,00c82h,00c80h
   .word   00440h,00020h,039f3h,04926h,03140h,02c40h,02882h,024c5h
   .word   01c41h,00866h,00444h,04e71h,0420dh,0318bh,02946h,02944h
   .word   02943h,02104h,02102h,01ce0h,01080h,00840h,05318h,008a5h

;**********************************************************************

UGR_SK_P:
   .word   64 
   .word   00000h,07bb9h,07752h,06b35h,06b32h,066cdh,05ab2h,05aadh
   .word   05649h,04a2eh,04a08h,04a06h,049a2h,041e9h,03983h,02d44h
   .word   02922h,02500h,024c0h,01060h,00c40h,00820h,043d1h,037adh
   .word   04f74h,01f68h,04749h,02ac6h,0368dh,01e89h,02a2ah,011c0h
   .word   015a6h,00c80h,00440h,070ebh,069d1h,06525h,06488h,05e75h
   .word   055f1h,0550bh,0456dh,04524h,044c9h,02923h,028a6h,01822h
   .word   039cch,039c7h,035a9h,02d63h,02949h,02102h,01ce4h,01ce2h
   .word   018c0h,014a2h,01080h,00420h,000c9h,004c7h,00065h,00022h

;**********************************************************************

KTP_SK_P:
   .word   64 
   .word   00000h,07fdch,07778h,07755h,06b36h,066d1h,05ab1h,05a4ch
   .word   0562ah,051eah,04a29h,045c6h,04588h,039a9h,03584h,03147h
   .word   02d24h,02922h,020e2h,01480h,023e9h,05fd5h,03fcfh,03b6ah
   .word   05732h,01b10h,01f09h,02a69h,00a69h,02a22h,015a0h,02124h
   .word   01d25h,00521h,01d03h,014e6h,018e2h,014c3h,010a4h,010a3h
   .word   00c82h,00c81h,00862h,00441h,00020h,06e5bh,05e97h,05a56h
   .word   055b5h,04e13h,0396eh,0398eh,0350dh,034cdh,024c9h,024c9h
   .word   024a9h,01886h,01846h,01044h,05ad5h,00840h,0254ah,00442h

;**********************************************************************

RDR_SK_P:
   .word   64 
   .word   00000h,039ceh,07b97h,066eah,05eb1h,0524dh,039a2h,00400h
   .word   05bd6h,037aeh,0036eh,04732h,050a0h,0272ah,05713h,05a2fh
   .word   03aceh,002c9h,04eb1h,0498ah,04e8eh,04a6fh,04651h,02623h
   .word   00a21h,03e0dh,039edh,031a7h,015a9h,011a0h,02987h,02549h
   .word   02542h,02127h,01d25h,00520h,010a4h,00c81h,00040h,05d27h
   .word   048e6h,02460h,07bddh,07384h,06f78h,06b57h,06737h,06720h
   .word   05ad5h,05ad1h,056a0h,0528fh,04a4bh,04628h,04621h,03de7h
   .word   039c9h,01ce4h,01082h,01080h,00c60h,05463h,03442h,02821h

;**********************************************************************

STY_SK_P:
   .word   64 
   .word   00000h,07bbah,07ba9h,07774h,07752h,072cfh,06b32h,066e4h
   .word   066aeh,0664dh,0664bh,05ea5h,05aadh,05aaah,055cah,055a5h
   .word   05241h,04dc9h,04a2dh,04a29h,04a26h,045a7h,04545h,041e1h
   .word   03da4h,03580h,03144h,028a0h,020e0h,018a0h,01482h,01060h
   .word   00c40h,00820h,05ff0h,05fe3h,03ff0h,01fa6h,02b6ch,03ec0h
   .word   01aa2h,02246h,00a42h,035c9h,015c6h,015a1h,02964h,02122h
   .word   00521h,01d05h,00c80h,00440h,05ad2h,03de5h,035a5h,03183h
   .word   02948h,02943h,02940h,02520h,01ce2h,01ce0h,01080h,00420h

;**********************************************************************

SUB_SK_P:
   .word   62 
   .word   02400h,06ab2h,05aaeh,05a4ch,0562ah,04a2dh,041c9h,03da8h
   .word   0358ah,03545h,02d40h,028c1h,020e4h,020e0h,01cc4h,018a3h
   .word   01482h,01060h,00c40h,00820h,043f7h,023c7h,067b7h,05bbah
   .word   02f97h,03b8bh,00f4eh,05731h,04737h,03b37h,0372eh,016f3h
   .word   03ed1h,00ec5h,02646h,02a2fh,00601h,031a5h,031a3h,029a7h
   .word   01d47h,02122h,00520h,018e0h,00ce6h,014c0h,00c80h,00440h
   .word   02a57h,015f2h,01d32h,019aeh,0006dh,077b9h,06b55h,03deah
   .word   02943h,02520h,02105h,01ce2h,01080h,00420h

REP_SK_P:
   .word   62 
   .word   00000h,06ab2h,05aaeh,05a4ch,0562ah,04a2dh,041c9h,03da8h
   .word   0358ah,03545h,02d40h,028c1h,020e4h,020e0h,01cc4h,018a3h
   .word   01482h,01060h,00c40h,00820h,047edh,007c5h,047b6h,053b3h
   .word   01794h,0178bh,02340h,03f2eh,0472eh,0472bh,0232ah,036e2h
   .word   02ecch,002c0h,00246h,02627h,00200h,019a2h,019a0h,011a4h
   .word   00544h,00920h,00120h,000e0h,000e3h,000c0h,00080h,00040h
   .word   04647h,031e2h,03124h,021a3h,01c60h,077b9h,06b55h,03deah
   .word   02943h,02520h,02105h,01ce2h,01080h,00420h

SCR_SK_P:
   .word   62 
   .word   00000h,06ab2h,05aaeh,05a4ch,0562ah,04a2dh,041c9h,03da8h
   .word   0358ah,03545h,02d40h,028c1h,020e4h,020e0h,01cc4h,018a3h
   .word   01482h,01060h,00c40h,00820h,05ff0h,01fc8h,05fb9h,06bb6h
   .word   02f97h,02f8eh,03b43h,05731h,05f31h,05f2eh,03b2dh,04ee5h
   .word   046cfh,016c3h,01a49h,03e2ah,00601h,031a5h,031a3h,029a7h
   .word   01d47h,02122h,00520h,018e0h,00ce6h,014c0h,00c80h,00440h
   .word   05e4ah,049e5h,04927h,039a6h,03460h,077b9h,06b55h,03deah
   .word   02943h,02520h,02105h,01ce2h,01080h,00420h

;**********************************************************************

JXR_SK_P:
   .word   64 
   .word   00000h,07bb9h,07949h,07756h,075edh,06b12h,06ad1h,068c5h
   .word   066aeh,06529h,05e4dh,05aaeh,0562bh,054c5h,048c4h,04883h
   .word   045c8h,04525h,041a6h,03965h,038a2h,03545h,03122h,02d46h
   .word   02d42h,02d23h,028e1h,020e5h,020e3h,018a0h,01060h,00820h
   .word   057f6h,01bc8h,03fabh,01364h,02f2bh,022c5h,0464eh,0264ah
   .word   01626h,03e0ah,00601h,035cah,031a7h,015a0h,02122h,01921h
   .word   01d05h,018e2h,018e0h,014c2h,010a2h,00c81h,00440h,06737h
   .word   05ad1h,04628h,035a4h,02101h,018c4h,01080h,00840h,00420h

;**********************************************************************

jump_to_next_long	.set	>20

mtv_style
	move	@f_nosound,a0,w		; sounds on ?
	pushp	a0		   	; remember sound state

	movk	1,a0
	move	a0,@f_nosound,w		; yes, temporparily turn em off
	move	a0,@winner_status,w

	movi	mtv_table,a10
	movk	6,a11
	callr	smooth_bgnd
	sleep	1
	calla	display_on
	sleep	>10

	move	*a12,a0,l		; borrow state of sounds
	jrne	mtv3			; no sounds

	clr	a0
	move	a0,@f_nosound,w		; sounds on !
	movi	>39,a3
	calla	send_code_a3		; start tune
	movk	1,a0
	move	a0,@f_nosound,w		; sounds off

mtv3	sleep	>18

	clr	a11
mtv4	move	*a10,a0,w
	jrn	mtv_done

	cmpi	jump_to_next_long,a0
	jrne	mtv5
	addi	16,a10
	move	*a10+,a0,l
	jump	a0


mtv5	pushp	a11
	callr	smooth_bgnd
	sleep	1
	calla	display_on
	move	*a10+,a0,w
	pullp	a11
	calla	prcslp

	inc	a11
	cmpi	8,a11
	jrlo	mtv4
	clr	a11
	jruc	mtv4

mtv_done
	pullp	a0		   		; restore state of sounds
	move	a0,@f_nosound,w	
	calla	nosounds
	calla	murder_myoinit_score
	retp

**************************************************************************
*											     *
*  mtv_table										     *
* 											     *
*  1 = ochar										     *
*  2 = world x offset									     *
*  3 = anitab offset / frame offset							     *
*											     *
**************************************************************************
mtv_table
	.word	ft_sa		; ochar
	.word	>60		; world x offset
	.word	>1c,0		; anitab offset / frame offset
	.long	do_uppercut	; process address

	.word	ft_cage		; ochar
	.word	>a5		; world x offset
	.word	>28,0		; anitab offset / frame offset
	.long	dizzy_dude	; process address
;	.word	30

;************

	.word	ft_hathead	; ochar
	.word	>b0		; world x offset
	.word	>28,0		; anitab offset / frame offset
	.long	dizzy_dude	; process address

	.word	ft_cage		; ochar
	.word	>f5		; world x offset
	.word	>21,0		; anitab offset / frame offset
	.long	do_knee		; process address
	.word	30

;************

	.word	ft_subzero	; ochar
	.word	>e0		; world x offset
	.word	>28,0		; anitab offset / frame offset
	.long	dizzy_dude	; process address

	.word	ft_fn2		; ochar
	.word	>125		; world x offset
	.word	>1c,0		; anitab offset / frame offset
	.long	do_hi_kick	; process address
	.word	>15

;************

	.word	ft_jax		; ochar
	.word	>60		; world x offset
	.word	>28,0		; anitab offset / frame offset
	.long	hk_show_off	; process address

	.word	ft_hathead	; ochar
	.word	>b0		; world x offset
	.word	>0d,0		; anitab offset / frame offset
	.long	dizzy_dude	; process address
	.word	>6a

	.word	jump_to_next_long
	.long	mtv_break_1

;************

	.word	ft_kang		; ochar
	.word	>30		; world x offset
	.word	>24,0		; anitab offset / frame offset
	.long	do_lk_super	; process address

	.word	ft_raiden	; ochar
	.word	>f0		; world x offset
	.word	>28,0		; anitab offset / frame offset
	.long	dizzy_dude	; process address
	.word	>18

;************

	.word	ft_scorpion	; ochar
	.word	>50		; world x offset
	.word	>0100,0		; anitab offset / frame offset
	.long	do_spear	; process address

	.word	ft_raiden	; ochar
	.word	>110		; world x offset
	.word	>28,0		; anitab offset / frame offset
	.long	dizzy_dude	; process address
	.word	40

;************

	.word	ft_st		; ochar
	.word	>40		; world x offset
	.word	>0d,0		; anitab offset / frame offset
	.long	do_hi_kick	; process address

	.word	ft_kang		; ochar
	.word	>a0		; world x offset
	.word	>28,0		; anitab offset / frame offset
	.long	dizzy_dude	; process address
	.word	30

;************

	.word	ft_fn2		; ochar
	.word	>e0		; world x offset
	.word	>28,0		; anitab offset / frame offset
	.long	dizzy_dude	; process address

	.word	ft_hathead	; ochar
	.word	>110		; world x offset
	.word	>20,0		; anitab offset / frame offset
	.long	do_body_slam	; process address
	.word	>30

;************

	.word	ft_raiden	; ochar
	.word	>60		; world x offset
	.word	>22,0		; anitab offset / frame offset
	.long	do_raiden_dive	; process address

	.word	ft_reptile	; ochar
	.word	>f0		; world x offset
	.word	>28,0		; anitab offset / frame offset
	.long	dizzy_dude	; process address
	.word	>28

;************

	.word	ft_jax		; ochar
	.word	>c0		; world x offset
	.word	>22,0		; anitab offset / frame offset
	.long	dizzy_dude	; process address

	.word	ft_fn1		; ochar
	.word	>100		; world x offset
	.word	>28,0		; anitab offset / frame offset
	.long	do_spinfan	; process address
	.word	>2d

;************

	.word	-1


hk_show_off
	jsrp	do_hi_kick
	movi	>00020029,a9
	jsrp	animate_a9
	jauc	wait_forever


mtv_break_1
    	mmtm	a12,a10,a11

;	calla	display_off
;	calla	murder_myoinit
;	calla	clr_scrn
;	movi	huge_mod,a0
;	calla	init_bakmods
;	calla	multi_plane
;	calla	display_on
;	sleep	18

	calla	display_off
	calla	murder_myoinit
	calla	clr_scrn
	clr	a0
	move	a0,@winner_status,w

	calla	init_map_start
	jsrp	setup_ladder_screen
	calla	display_on

	movi	>60000,a0
	move	a0,@scrolly,l
	sleep	>40

    	mmfm	a12,a10,a11

	jruc	mtv5

;********************************************************************


smooth_bgnd
	calla	display_off
	calla	murder_myoinit
	calla	clr_scrn
	calla	do_a11_background

	move	*a10+,a0,w
	move	a0,@p1_char,w		; mtv entry #1 = ochar
	movk	1,a1			; shadow = yes
	clr	a2			; player = 1
	calla	make_player_obj		; a8 = player 1 object
	move	a8,@p1_obj,l   		; player 1 object
	movi	p1_ram,a0
	move	a0,*a8(oimg),l
	movi	oid_p1,a0
	move	a0,*a8(oid),w
	movi	front_z,a0
	move	a0,*a8(ozval),l		; set x

	callr	set_x_and_pose
	calla	insobja8

	move	*a10+,a7,l		; mtv #4 = proc address
	movi	pid_p1,a1      		; set proc id
	calla	getprc
	move	a0,@p1_proc,l

	movi	wait_forever,a7
	move	*a0(psptr),a1,l
	move	a7,-*a1,l		; return address !
	move	a1,*a0(psptr),l

	mmtm	a12,a0,a8

	calla	clear_p_ram    		; clear process ram

	move	*a8(oypos),*a0(p_ganiy),w		; set the grounded y pos
	move	a8,*a0(pa8),l				; pass a8 to proc
*
* player 2
*
	move	*a10+,a0,w
	move	a0,@p2_char,w		; mtv entry #1 = ochar
	movk	1,a1			; shadow = yes
	movk	1,a2			; player = 1
	calla	make_player_obj		; a8 = player 1 object
	move	a8,@p2_obj,l   		; player 1 object
	movi	p2_ram,a0
	move	a0,*a8(oimg),l
	movi	oid_p2,a0
	move	a0,*a8(oid),w
	movi	back_z,a0
	move	a0,*a8(ozval),l		; set x

	callr	set_x_and_pose

	calla	flip_multi
	subi	32,a9
	calla	do_next_a9_frame

	calla	insobja8

	move	*a10+,a7,l		; mtv #4 = proc address
	movi	pid_p2,a1      		; set proc id
	calla	getprc
	move	a0,@p2_proc,l

	movi	wait_forever,a7
	move	*a0(psptr),a1,l
	move	a7,-*a1,l		; return address !
	move	a1,*a0(psptr),l

	calla	clear_p_ram    				; clear process ram

	mmfm	a12,a1,a9
	move	a0,*a1(p_otherproc),l
	move	a1,*a0(p_otherproc),l
	move	a8,*a1(p_otherguy),l
	move	a9,*a0(p_otherguy),l

	move	*a8(oypos),*a0(p_ganiy),w		; set the grounded y pos
	move	a8,*a0(pa8),l				; pass a8 to proc

	move	*a0(psptr),a1,l		; grab player's proc stack
	movi	wait_forever,a2
	move	a2,-*a1,l      
	move	a1,*a0(psptr),l		; push a return address for him

	calla	start_shadows
	create	pid_repell,repell
	create	pid_scroll,scroller
	rets


set_x_and_pose
	move	*a10+,a0,w
	calla	set_x_woff  		; mtv #2 = world x offset

	move	*a10+,a9,w		; mtv #3 = anitab offset
	cmpi	>100,a9,w
	jrlo	sxap3
	subi	>100,a9
	calla	get_char_ani2		; 100 = anitab 2
	jruc	sxap4

sxap3	calla	get_char_ani
sxap4	move	*a10+,a0,w
	add	a9,a0			; go to correct frame
	jauc	do_next_a9_frame


mk2_morph_in
	movi	MK2MORPH1A,a5
	calla	gso_dmawnz
	movi	>0094ffe9,a4
	calla	set_xy_coordinates
	calla	insobja8
	move	a8,a10

	movi	MK2MORPH1B,a5
	calla	gso_dmawnz
	movi	>00b7ffe9,a4
	calla	set_xy_coordinates
	calla	insobja8

	movi	a_mk2_morph,a9

	movk	5,a11
mk22	move	a8,a0
	callr	mk2_morph_ani
	move	a10,a0
	callr	mk2_morph_ani
	sleep	4
	dsj	a11,mk22

	sleep	>c0
	retp

mk2_morph_ani
	push	a8
	move	a0,a8
	move	*a9+,a1,l
	move	*a1(icmap),a0,l
	calla	swpal
	calla	ani_flag
	pull	a8
	rets

a_mk2_morph
	.long	MK2MORPH1A,MK2MORPH1B
	.long	MK2MORPH2A,MK2MORPH2B
	.long	MK2MORPH3A,MK2MORPH3B
	.long	MK2MORPH4A,MK2MORPH4B
	.long	MK2MORPH5A,MK2MORPH5B
	.long	0


amode_coinpage_mk2
	movi	MK2MORPH1A,a5
	calla	gso_dmawnz_ns
	movi	>00130028,a4
	calla	set_xy_coordinates
	move	a8,a10

	movi	MK2MORPH1B,a5
	calla	gso_dmawnz_ns
	movi	>00360028,a4
	calla	set_xy_coordinates

	movi	MK2MORPH5A,a1
	move	*a1(icmap),a0,l
	calla	swpal
	calla	ani_flag
	calla	insobja8

	move	a10,a8
	movi	MK2MORPH5B,a1
	move	*a1(icmap),a0,l
	calla	swpal
	calla	ani_flag
	calla	insobja8
	rets


;*************************************************************************

kang_smoke
	movk	9,a11
	jruc	ssm3

spit_smoke
	movk	4,a11
ssm3	create	pid_fx,one_puff
	sleep	4
	dsjs	a11,ssm3

one_puff
	movi	PUFF1,a5
	calla	gso_dmawnz

	movi	front_z+1,a0
	move	a0,*a8(ozval),l		; in front of players

	move	*a10(oxpos),*a8(oxpos),w
	move	@ground_y,a0,w
	subi	>68,a0
	move	a0,*a8(oypos),w		; at spit y level

	movi	->30000,a0
	move	a0,*a8(oyvel),l

	movi	>10000,a0
	move	*a10(oflags),a4,w
	btst	b_fliph,a4
	jreq	smoke4
	neg	a0
smoke4	move	a0,*a8(oxvel),l

	calla	insobja8
	movi	a_puff,a9
	movk	5,a0
	jsrp	framew
	move	a8,a0
	calla	delobjp
	die

a_puff
	.long	PUFF1
	.long	PUFF2
	.long	PUFF3
	.long	PUFF4
	.long	PUFF5
	.long	0

;*************************************************************************

fx_inviso_flame
	tsound	>d0

	movi	NJBIGPOOF1,a5
	calla	gso_dmawnz

	push	a8
	move	*a10(oxpos),a0,w
	subi	>10,a0
	move	a0,*a8(oxpos),w

	move	@ground_y,a0,w
	subi	>15,a0
	move	a0,*a8(oypos),w

	movi	front_z+1,a0
	move	a0,*a8(ozval),l
	pull	a8
	calla	insobja8

	movi	a_poof,a9
	movk	3,a0
	jsrp	framew
	move	a8,a0
	calla	delobjp
	die

a_poof
	.long	NJBIGPOOF1
	.long	NJBIGPOOF2
	.long	NJBIGPOOF3
	.long	NJBIGPOOF4
	.long	NJBIGPOOF5
	.long	NJBIGPOOF6
	.long	NJBIGPOOF7
	.long	NJBIGPOOF8
	.long	NJBIGPOOF9
	.long	NJBIGPOOF10
	.long	NJBIGPOOF11
	.long	NJBIGPOOF12
	.long	0

**************************************************************************
*											     *
*  fx_charge_bars - Grow the powerbars from 0 to maxpower			     *
*											     *
**************************************************************************
fx_charge_bars
	movi	-1,a0
	move	a0,@p1_bar,w
	move	a0,@p2_bar,w		; neg bar = flag: dont mess with bars !

	clr	a0
	move	a0,@p1_bar_view,w
	move	a0,@p2_bar_view,w

	movk	4,a10
gxcb5	callr	charge_stuff
	sleep	1
	addk	2,a10
	cmpi	full_strength,a10
	jrlo	gxcb5

	movi	full_strength,a10
	callr	charge_stuff
	die

charge_stuff
	move	a10,@p1_bar_view,w
	move	a10,@p2_bar_view,w
	move	a10,@p1_bar,w
	move	a10,@p2_bar,w		; neg bar = flag: dont mess with bars !
	rets

**************************************************************************
*											     *
*  trail_proc - process to make a trail of images of a dude		     *
* 	       for superkick								     *
* 											     *
*  input: a8 = dude/multipart object to follow					     *
*											     *
**************************************************************************
trail_proc
	move	a8,a11

	clr	a0
	move	a0,*a13(p_store1),l
	move	@ofree,a8,l
	move	a8,*a13(p_store2),l		; save 1st object
	clr	a7				; no previous object yet
				    	
	movk	7,a0
trail5	move	a0,*a13(p_anirate),w		; max number of shadow dudes

	move	*a11(ochar),a0,w

	move	a11,a8
	clr	a9
	calla	get_char_ani
	move	*a9,a5,l			; a5 = frame #1

	push	a7
	calla	get_jc_pid
	movi	shadow_dummy_proc,a7
	calla	getprc				; grab a process for ram
	move	a0,a6
	addi	pdata,a6  			; a6 = multipart ram starts here !!
	calla	get_multi_obj

	move	*a11(oshape),a0,l
	calla	ani2				; same shape as cage

	push	a8
	move	a8,a0
	move	a11,a8
	calla	match_ani_points		; lineup with cage
	pull	a8
	pull	a7

	move	a7,a7				; do we have a previous ?
	jreq	trail6				; no
	move	a8,*a7(oplink),l		; yes, link to previous object

trail6
	movi	white_kahn_p,a0			; kahn = white shadow
	move	*a11(ochar),a1,w
	cmpi	ft_cage,a1
	jrne	trail4

	movi	green_cage1_p,a0
	move	*a13(p_store3),a1,l		; green shadow
	jreq	trail4				; yup
	movi	red_cage_p,a0
trail4	calla	swpal

	move	*a13(p_store1),a0,l
	inc	a0
	move	a0,*a13(p_store1),l
	move	a0,*a8(ozval),l

	calla	insobja8

	sleep	3
	move	a8,a7			; a7 = previous shadow object
	move	*a11(oxvel),a0,l
	jreq	trail7			; stopped moving ---> no moe trail

	move	*a13(p_anirate),a0,w
	dec	a0
	jrne	trail5			; limit the # of shadows
	clr	a0
	move	a0,*a8(oplink),l	; zero the last one
*
* erase trail
*
trail7	move	*a13(p_store2),a8,l	; save 1st object
trail8	move	*a8(oplink),a10,l	; grab next one !!
	move	a8,a0
	calla	delobjp
	sleep	2
	move	a10,a8
	jrne	trail8

	callr	get_jc_pid
	move	a1,a0
	calla	dallprc			; rid of procs too
	die

get_jc_pid
	movi	pid_jc_shadow1,a1
	move	*a11(oid),a0,w
	cmpi	oid_p1,a0
	jreq	getjc4
	movi	pid_jc_shadow2,a1
getjc4	rets


shadow_dummy_proc
	sleep	>80
	die

green_cage1_p
	.word   64 
   	.word   00000h,047f1h,03f8fh,0332ch,02aaah,02248h,015c5h,00d63h
   	.word   047cdh,0474ah,04749h,0476bh,04728h,04329h,042e8h,042c6h
   	.word   03ec6h,03ea5h,03ac8h,03ac7h,03a85h,03ae9h,036a6h,03665h
   	.word   03686h,03286h,03265h,03287h,03266h,03224h,02e22h,02e24h
   	.word   02a24h,02a25h,02a03h,029c1h,02604h,025e1h,025c2h,021e2h
   	.word   021c0h,021c3h,01d80h,01d80h,01940h,01582h,01520h,01520h
   	.word   01100h,00d40h,00d42h,00d00h,00921h,0098fh,01a0eh,00d8ah
   	.word   0096ah,00129h,00108h,00107h,00105h,00104h,00943h,00101h

red_cage_p
	.word   64 
	.word   00000h,07e10h,07d8ch,07508h,06063h,05000h,03c00h,02800h
	.word   07deah,07d43h,07d41h,07d66h,07d20h,07d02h,07cc0h,07ca0h
	.word   07c80h,07c60h,07ca0h,07c80h,07c40h,07cc2h,07c60h,07800h
	.word   07840h,07420h,07400h,07040h,07000h,07000h,06c00h,06800h
	.word   06400h,06000h,06000h,06000h,05c00h,05c00h,05800h,05400h
	.word   05400h,05000h,04c00h,04800h,04000h,03c00h,03c00h,03800h
	.word   03400h,02c00h,02800h,02800h,02400h,0240ch,0400bh,02c04h
	.word   02004h,01801h,01800h,01800h,01800h,01800h,02400h,01800h

**************************************************************************
*											     *
*  grow_msg - Grow a message like "FIGHT" or "FINISH HIM"			     *
* 											     *
*  Input: a10 = offset into grow table	  						*
*											     *
**************************************************************************
grow_msg
	move	a8,a0
	jreq	grow1
	calla	triple_sound2

grow1	sll	5,a10
	addi	grow_table,a10
	move	*a10+,a5,l		; grab img header

	move	*a5(isizex),a11,w
	sll	8,a11			; shift for the formula
	move	*a5(isizey),a10,w
	sll	8,a10			; shift for the formula

	calla	gso_dmawnz_ns

	movi	FIN_P,a0
	calla	swpal			; always start red

	movi	oid_grow,a0
	move	a0,*a8(oid),w		; set oid for grow obj

	movi	>03000300,a9
	move	a9,*a8(oscale),l	; start off real small
	callr	center_scaled
	calla	insobj2a8
*
* grow loop
*
grow3	move	a9,*a8(oscale),l	; start off real small
	callr	center_scaled
	sleep	1
	subi	>00200020,a9
	cmpi	>01000100,a9
	jrne	grow3
	move	a9,*a8(oscale),l	; full size !
	calla	center_obj_x
*
* flash yellow and red
*
	movk	6,a9
grow5	movi	FIN_Y_P,a0
	jsrp	flash_yr
	movi	FIN_P,a0
	jsrp	flash_yr
	dsjs	a9,grow5
*
* shrink loop
*
	movi	>01000100,a9
grow7	move	a9,*a8(oscale),l	; start off real small
	callr	center_scaled
	sleep	1
	addi	>00200020,a9
	cmpi	>03000300,a9
	jrne	grow7
	move	a9,*a8(oscale),l	; full size !

	move	a8,a0
	calla	delobjp2
	die


flash_yr
	calla	swpal
	sleep	4
	retp

grow_table
	.long	FIGHT	 	; 0 = fight
	.long	FINISHHIM	; 1 = finish him
	.long	FINISHHER	; 2 = fihish her

yelfight_p:
	.word	3
	.word	>0,>842,>FFE0

;*********************************************************************

center_scaled
	move	a11,a1
	move	a9,a3
	zext	a3,w			; only look at x
	divs	a3,a1			; a1 = new scaled x size
	movi	scrrgt/2,a2
	srl	1,a1			; 1/2 of x size
	sub	a1,a2			; center the image on the screen
	move	a2,*a8(oxpos),w

	move	a10,a1
	move	a9,a3
	srl	16,a3			; only look at y
	divs	a3,a1			; a1 = new scaled x size
	movi	(scrbot/2)->30,a2
	srl	1,a1			; 1/2 of x size
	sub	a1,a2			; center the image on the screen
	move	a2,*a8(oypos),w
	rets

**************************************************************************
*											     *
*  pp_number - The growing little number that tells you how strong	     *
*              a POWER PUNCH is.								     *
* 											     *
*  Input: a8 = dude to follow								     *
*											     *
**************************************************************************
pp_number
	move	a8,a11
	movi	LIFEBOX,a5
	calla	gso_dmawnz

	movi	front_z+1,a0
	move	a0,*a8(ozval),l

	movi	>30000,a0
	move	*a11(oflags),a4,w
	btst	b_fliph,a4     		; head in same direction as cage
	jreq	ppn3
	neg	a0
ppn3	move	a0,*a8(oxvel),l

	move	*a11(oxpos),a2,w	; a2 = x coordinate
	move	*a11(oypos),a4,w
	addi	>2a,a4			; a4 = y coordinate
	move	a2,*a13(p_store1),w
	move	a4,*a13(p_store2),w

	move	*a13(p_store3),a0,w
	cmpi	10,a0
	jrhi	ppn9			; out of range = no effect
	jrne	ppn2
    	movk	9,a0

ppn2	sll	5,a0
	addi	clock_nums,a0
	move	*a0,a1,l
	calla	ani_flag

	move	*a8(osizex),a11,w
	sll	8,a11			; shift for the formula
	move	*a8(osizey),a10,w
	sll	8,a10			; shift for the formula
	movi	>03000300,a9		; a9 = scale
	move	*a13(p_store1),a2,w
	move	*a13(p_store2),a4,w
	callr	center_about_a2a4	; set coordinates
	calla	insobja8

	movi	->20000,a0
	move	a0,*a8(oyvel),l		; head upwards
*
* grow loop
*
	movk	21,a0
ppn5	move	a0,*a13(p_anirate),w
	subi	>00200020,a9		; grow scale

	move	*a13(p_store1),a2,w
	move	*a8(oxvel),a0,l
	sra	16,a0
	add	a0,a2
	move	a2,*a13(p_store1),w	; adjust for vel

	move	*a13(p_store2),a4,w
	move	*a8(oyvel),a0,l
	sra	16,a0
	add	a0,a4
	move	a4,*a13(p_store2),w	; adjust for vel

	callr	center_about_a2a4	; set coordinates
	sleep	1
	move	*a13(p_anirate),a0,w
	dsj	a0,ppn5
	calla	stop_a8
*
* flash
*
;	movi	bpal_white,a0
;	move	a0,*a8(oconst),w
;
;	movk	6,a10
;ppn7	movi	boonpal,a0
;	calla	swpal
;	calla	set_dmacnz
;	sleep	4
;
;	movi	SCORE_P,a0
;	calla	swpal
;	calla	set_dmawnz
;	sleep	4
;	dsj	a10,ppn7

	sleep	10
	move	a8,a0
	calla	delobjp

ppn9	die

**************************************************************************
*											     *
*  center_about_a2a4 - Center a scaled object about				     *
* 											     *
*   a2 = x coordinate									     *
*   a4 = y coordinate									     *
*   a9 = scale											*
*											     *
**************************************************************************
center_about_a2a4
	move	a9,*a8(oscale),l

	move	a11,a1
	move	a9,a3
	zext	a3,w			; only look at x
	divs	a3,a1			; a1 = new scaled x size
	srl	1,a1			; 1/2 of x size
	sub	a1,a2			; center the image on the screen
	move	a2,*a8(oxpos),w

	move	a10,a1
	move	a9,a3
	srl	16,a3			; only look at y
	divs	a3,a1			; a1 = new scaled x size
	srl	1,a1			; 1/2 of x size
	sub	a1,a4			; center the image on the screen
	move	a4,*a8(oypos),w
	rets

**************************************************************************
*											     *
*  shake_a11 - shake the earth according to					     *
* 											     *
*  a11 = [ # of pixels , # of shakes ]						     *
*											     *
**************************************************************************
shake_a11
	push	a10
	move	a11,a10
	srl	16,a11		; a11 = # of pixels
	sll	16,a10
	srl	16,a10

	movi	pid_shaker,a0
	movi	es_sub,a7
	calla	create_and_kill
	pull	a10
	rets

es_sub	move	@worldtly+16,a6,l
;	add	a11,a6
	sub	a11,a6
	move	a6,@worldtly+16,l
	sleep	3	       	; hey, check out the fault !!!
	neg	a11
	dsjs	a10,es_sub
	die


;************************************************************************

scorpion_flame
	mmtm	a12,a8,a9,a10,a11
	move	a8,a11
	movi	a_scorpion_flame,a9
	calla	gmo_proc

	movi	front_z+1,a0
	move	a0,*a8(ozval),l		; in front of player characters

	calla	insobja8
	move	a8,a9
	move	a8,a0
	move	a11,a8
	calla	match_ani_points	; line flame with scorpion
	move	a9,a8

	movi	>20,a0
	movi	>20,a1
	calla	multi_adjust_xy		; thanks for doing this tony (sarcasm)

	movi	a_scorpion_flame,a9
	movk	4,a0
	jsrp	mframew
*
* right side flame image
*
	move	a9,a14
	move	a8,a11			; a11 = left half
	movi	a_scorpion_flame,a9
	calla	gmo_proc
	movi	front_z+1,a0
	move	a0,*a8(ozval),l		; in front of player characters
	calla	insobja8
	move	a8,a9
	move	a8,a0
	move	a11,a8
	calla	match_ani_points	; line flame with left half
	move	a9,a8
	calla	flip_multi

	movi	->f4,a0
	clr	a1
	calla	multi_adjust_xy		; thanks for doing this tony (sarcasm)
	move	a14,a9
*
* animate left and right halves together
*
	tsound	>93			; mega burning sound

	movk	2,a10
	jsrp	double_flame_ani	; get to the skeleton xfer frame

	movi	flaming_skeleton,a7
	calla	takeover_him

	movk	5,a10
	jsrp	double_flame_ani	; get to the skeleton xfer frame

	move	a8,a0
	calla	delobjp
	move	a11,a0
	calla	delobjp			; rid of flame images

	mmfm	a12,a8,a9,a10,a11
	retp


flaming_skeleton
	calla	center_around_me

	movi	>8585b8b7,a1		; a1 = left / right / kang / female
	calla	ochar_sound 		; disturbing scream

	movi	a_flaming_skeleton,a9
	calla	do_next_a9_frame
	calla	ground_multi
	calla	flip_multi
	move	*a8(oypos),a0,w
	addk	8,a0
	move	a0,*a8(oypos),w
	sleep	5

	movi	>00050010,a0
	jsrp	animate_a0_frames

	movi	>0008000c,a11
	calla	shake_a11

	movi	a_boom,a9
	calla	do_next_a9_frame
	sleep	3
	jsrp	white_flash

	tsound	>90				; exploding dude sound

	create	pid_bones,flaming_bones
	move	*a8(oxval),*a0(pa10),l
	move	*a8(oyval),*a0(pa11),l

	move	a8,a0
	calla	set_inviso

	jauc	wait_forever



white_flash
	move	@irqskye,a9,w		; save original background color
	movi	>ffff,a0
	move	a0,@irqskye,w		; white
	calla	display_off
	sleep	2
	move	a9,@irqskye,w		; original background color
	calla	display_on
	retp

a_flaming_skeleton
	.long	ani_calla,morph_swpal
j_fsk	.long	burn1
	.long	burn2
	.long	burn3
	.long	burn4
	.long	burn5
	.long	burn6
	.long	ani_jump,j_fsk

a_boom	.long	burn_bang


burn_bang
	.long	fireskelexpld,0

burn1	.long	fireskel1,0
burn2	.long	fireskel2,0
burn3	.long	fireskel3,0
burn4	.long	fireskel4,0
burn5	.long	fireskel5,0
burn6	.long	fireskel6,0

;***********************************************************************

double_flame_ani
	move	a9,a14
	calla	do_next_a9_frame
	push	a8
	move	a11,a8
	move	a14,a9
	calla	do_next_a9_frame
	pull	a8
	sleep	4
	dsj	a10,double_flame_ani
	retp

a_scorpion_flame
	.long	sflame1
	.long	sflame2
	.long	sflame3
	.long	sflame4
	.long	sflame5		; single part flame
	.long	0

	.long	sflame6
	.long	sflame7

	.long	sflame8
	.long	sflame9
	.long	sflame10
	.long	sflame11
	.long	sflame12
	.long	0

sflame1	.long	scorpfire1,a0
sflame2	.long	scorpfire2,a0
sflame3	.long	scorpfire3,a0
sflame4	.long	scorpfire4,a0
sflame5	.long	scorpfire5,a0
sflame6	.long	scorpfire6,a0
sflame7	.long	scorpfire7,a0
sflame8	.long	scorpfire8,a0
sflame9	.long	scorpfire9,a0
sflame10	.long	scorpfire10,a0
sflame11	.long	scorpfire11,a0
sflame12	.long	scorpfire12,a0

;************************************************************************

flaming_bones
	srl	16,a10
	srl	16,a11
	subi	>20,a10
	addi	>40,a11

	movi	>10000,a0		; x vel range
	clr	a1  			; x vel minimum
	movi	>a0000,a2		; y vel range
	movi	>50000,a3		; y vel minimum
	movi	a_big_bone,a4
	movi	a_lil_bone,a5
	movk	10,a6			; a6 = how many pieces
	callr	spawn_a6_bones
*
* 4 quandrant bones
*
	movk	13,a3
bexp4	movi	>70000,a0
	calla	randu
	addi	>30000,a0
	move	a0,a5
	movi	>70000,a0
	calla	randu
	addi	>30000,a0
	move	a0,a6				; x:y vel

	movi	bone_explode1,a7
	callr	make_1_exp
	movi	bone_explode2,a7
	callr	make_1_exp
	movi	bone_explode3,a7
	callr	make_1_exp
	movi	bone_explode4,a7
	callr	make_1_exp
	dsj	a3,bexp4
*
* skull head
*
	movi	fireskull,a5
	calla	gso_dmawnz

	movi	500,a0
	move	a0,*a8(ozpos),w

	move	a10,*a8(oxpos),w
	move	a11,*a8(oypos),w
	calla	insobja8

	movi	->f0000,a0
	movi	>4000,a10
	jsrp	skull_bounce
	movi	->80000,a0
	movi	>6000,a10
	jsrp	skull_bounce
	die

skull_bounce
	move	a0,*a8(oyvel),l
	movi	never_ani,a0
	jauc	blood_fall

;************************************************************************

spawn_a6_bones
	mmtm	sp,a0,a1
	create	pid_bones,bone_flight
	move	a0,a14
	create	pid_bones,bone_flight
	move	a0,a7
	mmfm	sp,a0,a1

	swap	a4,a5

	push	a0
	calla	randu
	add	a1,a0
	move	a0,*a7(p_store1),l
	neg	a0
	move	a0,*a14(p_store1),l

	move	a2,a0
	calla	randu
	add	a3,a0
	neg	a0
	move	a0,*a7(p_store2),l
	move	a0,*a14(p_store2),l

	move	a4,*a7(p_store3),l
	move	a4,*a14(p_store3),l
	pull	a0

	dsj	a6,spawn_a6_bones
	rets

;****************************************************************************

bone_explode4
	move	*a13(p_store1),a7,l
	neg	a7
	move	a7,*a13(p_store1),l
	jruc	bone_explode3

bone_explode1
	move	*a13(p_store1),a7,l
	neg	a7
	move	a7,*a13(p_store1),l

bone_explode2
	move	*a13(p_store2),a7,l
	neg	a7
	move	a7,*a13(p_store2),l

bone_explode3
	movi	a_big_bone,a1
	move	@rand,a0,l
	jrn	exp5
	movi	a_lil_bone,a1
exp5	move	a1,*a13(p_store3),l

	callr	bone_init
	calla	insobja8
	move	*a13(p_store1),*a8(oxvel),l
	move	*a13(p_store2),*a8(oyvel),l
	sleep	>30
	move	a8,a0
	calla	delobjp
	die


make_1_exp
	movi	pid_bones,a1
	calla	getprc
	move	a5,*a0(p_store1),l
	move	a6,*a0(p_store2),l
	rets

;****************************************************************************

bone_flight
	callr	bone_init
	calla	insobja8

	move	*a13(p_store1),*a8(oxvel),l
	move	*a13(p_store2),*a8(oyvel),l
	move	*a13(p_store3),a9,l
	movi	>4000,a10
	movk	3,a0
	calla	randu
	addk	2,a0
	jsrp	blood_fall

	movi	>20000,a0
	movi	>38000,a1
	jsrp	bone_bounce
	movi	>20000,a0
	movi	>20000,a1
	jsrp	bone_bounce
	die

bone_bounce
	move	*a13(p_store1),*a8(oxvel),l
	calla	randu
	add	a1,a0
	neg	a0
	move	a0,*a8(oyvel),l
	sleep	2
	movi	>4000,a10
	movk	3,a0
	jauc	blood_fall

;**************************************************************************

bone_init
	move	*a13(p_store3),a5,l
	move	*a5,a5,l
	calla	gso_dmawnz

	movi	>30,a0
	calla	randu
	add	a10,a0
	move	a0,*a8(oxpos),w
	movi	>50,a0
	calla	randu
	add	a11,a0
	move	a0,*a8(oypos),w			; random starting spot
	rets


a_big_bone
	.long	lgfirebone1
	.long	lgfirebone2
	.long	lgfirebone3
	.long	lgfirebone4
	.long	lgfirebone5
	.long	lgfirebone6
	.long	ani_jump,a_big_bone

a_lil_bone
	.long	smfirebone1
	.long	smfirebone2
	.long	smfirebone3
	.long	smfirebone4
	.long	smfirebone5
	.long	smfirebone6
	.long	ani_jump,a_lil_bone

**************************************************************************
*											     *
*  danger_danger - print a little danger by the players power bar who is *
*                  trouble								     *
*											     *
**************************************************************************
danger_danger
	calla	if_amode_die

	movi	danger,a5
	calla	gso_dmawnz_ns
	movi	pid_danger1,a7
	movi	>0030008c,a4
	dec	a11
	jreq	ddd4
	movi	pid_danger2,a7
	movi	>003000d7,a4
ddd4 	move	a7,*a13(procid),w
	move	a7,*a8(oid),w

	calla	set_xy_coordinates
	calla	insobja8

	move	*a13(procid),a1,w
	movi	danger_flasher,a7
	calla	getprc

	tsound	>bc				; yes ---> warning sound !!
	sleep	>20

	calla	is_final_boss_playing
	jreq	ddd5

	tsound2	>36				; short laugh

ddd5	sleep	>20
	move	a8,a0
	calla	delobjp

	move	*a13(procid),a0,w
	calla	dallprc				; stop my color cycler
	die


danger_flasher
	movi	danger,a0			; assume "boonpal" is our palette
	move	*a0(icmap),a0,l
	movi	fl_danger,a11
	jauc	nrgbs0

fl_danger
	.word	>0101,4
	.word	>ffff
	.word	rgb_blue
	.word	end_stuff

;*************************************************************************

green_soul
	movi	SOUL1,a5
	calla	gso_dmawnz

	move	a8,a0			; single = green shit
	move	a11,a1			; multi = shang
	calla	lineup_1pwm

	calla	flip_single
	movi	->10,a0
	movi	->1d,a1
	calla	multi_adjust_xy

	movk	1,a0
	move	a0,*a8(ozpos),w		; behind corpse in front of shang
	calla	insobja8

	tsound	>c1
	movi	8,a11
	movi	a_soul,a9
	movi	>10,a10
gsoul3	calla	frame_a9
	sleep	4
	dsj	a11,gsoul5
	movk	8,a11
	tsound	>c1

gsoul5	dsj	a10,gsoul3

	tsound	>c2

	movi	a_soul2,a9
	movk	4,a0
	jsrp	framew

	move	a8,a0
	calla	delobjp
	die

a_soul
	.long	SOUL1
	.long	SOUL2
	.long	SOUL3
	.long	ani_jump,a_soul


a_soul2	.long	SOUL4
	.long	SOUL5
	.long	SOUL6
	.long	SOUL7
	.long	SOUL8
	.long	SOUL9
	.long	SOUL10
	.long	SOUL11
	.long	SOUL12
	.long	SOUL13
	.long	SOUL14
	.long	SOUL15
	.long	SOUL16
	.long	SOUL17
	.long	0

**************************************************************************
*											     *
*  smoke_a_guy - proc which hangs out and makes a dude smoke like a	     *
*                haystack								     *
* 											     *
*  Input: a11 = dude to smoke								     *
*											     *
**************************************************************************

smoke_a_guy4
	create	pid_1_puff,smoke_a_1
	create	pid_1_puff,smoke_a_1
	create	pid_1_puff,smoke_a_1
	create	pid_1_puff,smoke_a_1
	sleep	2
	jruc	smoke_a_guy4

smoke_a_guy
	create	pid_1_puff,smoke_a_1
	sleep	4
	jruc	smoke_a_guy

smoke_a_1
	movi	PUFF1,a5
	calla	gso_dmawnz

	movi	oid_1_puff,a0
	move	a0,*a8(oid),w

	movi	front_z+1,a0
	move	a0,*a8(ozval),l		; in front of players

	push	a8
	move	a11,a8
	calla	highest_mpart		; a0 = highest
	calla	lowest_mpart		; a1 = lowest
	calla	leftmost_mpart		; a2 = leftmost
	calla	rightmost_mpart		; a3 = rightmost
	pull	a8

	move	a10,a10			; squeeze routine ?
	jreq	smk3			; no
	call	a10

smk3	move	a0,a14
	sub	a14,a1			; a1 = his object height
	move	a1,a0
	calla	randu
	add	a14,a0
	move	a0,*a8(oypos),w

	sub	a2,a3			; a3 = width
	move	a3,a0
	calla	randu
	add	a2,a0
	move	a0,*a8(oxpos),w

	movi	>30000,a0
	calla	randu
	addi	>10000,a0
	neg	a0
	move	a0,*a8(oyvel),l		; random upwards speed

	movi	>10000,a0
	calla	srand
	move	a0,*a8(oxvel),l

	calla	insobja8
	movi	a_puff,a9
	movk	6,a0
	jsrp	framew
	move	a8,a0
	calla	delobjp
	die

;****************************************************************************

boss_die_sequence
	clr	a0
	move	a0,@p1_state,w
	move	a0,@p2_state,w			; take players out of the game
	movi	gs_gameover,a0
	move	a0,@gstate,w			; game state = game over

	calla	nosounds			; stop the music
	sleep	1

	tsound2	>3e				; kahn wasted voice
	jsrp	long_white_flash
	sleep	>0a
	jsrp	long_white_flash
	sleep	>0a
	jsrp	long_white_flash

	move	@p2_obj,a8,l
	move	@p2_proc,a9,l
	move	@winner_status,a0,w
	cmpi	1,a0
	jreq	bds3
	move	@p1_obj,a8,l
	move	@p1_proc,a9,l
bds3	move	*a9(p_ganiy),*a13(p_ganiy),w
	tsound2	>3a	   		  	; start rumble sound

bds5	sleep	1
	calla	am_i_airborn			; is sk airborn ?
	jrc	bds5				; yes, wait for him 2 land

	movi	pid_scroll,a0
	calla	dallprc				; kill old scroller
	movi	pid_shaker,a0
	calla	dallprc
	clr	a0
	move	a0,@worldtly,l

	create	pid_scroll,scroll_center	; make new one
	create	pid_fx,final_earthshaker

	tsound2	>3a	   		  	; start rumble sound
	sleep	>30

	tsound2	>3b				; no..
	sleep	>28

	tsound2	>3c				; NO.
	sleep	>28

	tsound2	>3d				; NO !!!!!
	sleep	>78
*
* start flippin through the backgrounds
*
	calla	killfx
	calla	nosounds			; stop the music
	sleep	3

	clr	a11
bchg3	move	a11,*a13(p_anicount),w
	jsrp	bgnd_flash
	create	pid_fx,kahn_shaker
	sleep	>0b
	move	*a13(p_anicount),a11,w
	inc	a11
	cmpi	6,a11
	jrlo	bchg3

	movk	8,a11
	jsrp	bgnd_flash
	create	pid_fx,kahn_shaker
	sleep	>0b
*
* turn to stone on a black background
*
	calla	murder_myoinit_score

	movi	dlists_bogus,a0
	move	a0,@dlists,l	 	; blackness !!
	clr	a0
	move	a0,@irqskye,w
*
* create stone kahn which kkkkracks !!!
*
	callr	make_kahn_obj
	move	@worldtlx+16,a0,w
	addi	scrrgt/2,a0
	move	a0,*a8(oxpos),w
	calla	insobja8
	tsound2	>40		 	; turn 2 stone sound

	movi	>16,a9
	calla	get_char_ani
	move	*a9,a5,l
	move	*a5,a5,l
	move	*a5(icmap),a0,l
	calla	player_swpal
	movk	5,a0
	jsrp	mframew
	sleep	6
	retp



bgnd_flash
;	tsound	>a4				; BOOM !!!
	tsound2	>41				; BOOM !!!

	movi	>ffff,a0
	move	a0,@irqskye,w			; white
	calla	display_off
	calla	murder_myoinit_score
	sleep	4
	calla	do_a11_background
	sleep	2
	calla	display_on
	retp

;************************************************************************

kahn_shaker
	callr	make_kahn_obj

	move	@worldtlx+16,a0,w
	addi	scrrgt/2,a0
	move	a0,*a8(oxpos),w
	calla	insobja8

	move	a8,a11
	clr	a10
	create	pid_fx,smoke_a_guy4
	movi	>00070030,a0
	movk	2,a1
	move	a8,a10
	jsrp	shake_him_up
	jauc	wait_forever

make_kahn_obj
	movk	13,a0
	clr	a1
	clr	a2			; player = 1
	calla	make_player_obj		; a8 = player 1 object

	movi	p1_ram,a0
	move	a0,*a8(oimg),l
	movi	>0d,a9
	calla	get_char_ani
	addi	32*3,a9
	calla	do_next_a9_frame
	rets


long_white_flash
	tsound2	>41				; sound: BOOM !!!

	move	@irqskye,a9,w
	movi	>ffff,a0
	move	a0,@irqskye,w			; white
	calla	display_off
	sleep	4
	calla	display_on
	move	a9,@irqskye,w			; back to normal background color
	retp

;******************************************************************


final_earthshaker
	movi	>00030050,a11
	movi	>30,a10
	callr	final_shake

	movi	>00050050,a11
	movi	>40,a10
	callr	final_shake

	movi	>00070050,a11
	movi	>f40,a10
	callr	final_shake

	movi	pid_shaker,a0
	calla	dallprc
	die

final_shake
	movi	pid_shaker,a0
	calla	dallprc
	calla	shake_a11
	move	a10,a0
	jauc	prcslp

;************************************************************************

white_kahn_p
	.word   64 
	.word   00000h,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
	.word   07fffh,07fffh,077bfh,06f7fh,0673fh,05effh,05adfh,04e7fh
	.word   0463fh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
	.word   07f3fh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fdfh
	.word   07fbfh,07fbfh,07fffh,07f9fh,07fbfh,07ebfh,07f3fh,07f5fh
	.word   07f9fh,07e1fh,07f3fh,07f7fh,07e9fh,07a1fh,07abfh,0771fh
	.word   0773fh,076ffh,0765fh,0775fh,0721fh,072dfh,06effh,06ebfh
	.word   06adfh,06a3fh,066bfh,0621fh,05e9fh,0563fh,04e1fh,041ffh

;************************************************************************

 	.end
