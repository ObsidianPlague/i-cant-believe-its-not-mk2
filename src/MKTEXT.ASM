**************************************************************************
*											     *
*  video game project:	  mortal kombat							*
* 											     *
*  programmer:		  edward boon						     *
* 											     *
*  module: textutil.asm -- text utilities						     *
* 											     *
*  copyright (c) 1990 williams electronics games, inc.			     *
*											     *
**************************************************************************
	.file	'textutil.asm'
	.title	" <<< text utility routines >>> "

	.width	132
	.option	b,d,l
	.mnolist
*
* get the system stuff
*
	.include	dispequ.asm		; display processor equates
	.include	sysequ.asm 		; sys.inc and gsp.inc
	.include	macros.hdr		; macros
	.include	mainequ.asm
	.include	imgtbl.glo
	.include	mktext.tbl

	.even
	.text


;kfnt16g:
;	.word	10,17,4,-4
;	.long	>2043080


newlet_init
	.long	MK2FONTA,boonpal
	.word	oid_fx
	.word	0,0,0


p15_0s	movk	1,b1			; make shadows too
	mmtm	sp,a2,a5,a6,a8,a11
	callr	print_core
	mmfm	sp,a2,a5,a6,a8,a11
	rets

p15_3	clr	b0
	jruc	p1531

p15_3s	movk	1,b1			; make shadows too
p1531	mmtm	sp,a1,a2,a5,a6,a8,a11
	callr	print_core
prnti3	move	a4,a5
	move	a7,a6
	calla	a5a6ol3
	mmfm	sp,a1,a2,a5,a6,a8,a11
	rets

**************************************************************************
*											     *
*  p15_2 - prints a text string (objlst2) given:					*
* 											     *
*  a0 ---> x,y,color,"string"								     *
*											     *
**************************************************************************
p15_2
	clr	b1			; no shadows
	jruc	p15s
*
* shadowed version
*
p15_2s	movk	1,b1			; make shadows too
p15s	mmtm	sp,a1,a2,a5,a6,a8,a11
	callr	print_core
prnti2	move	a4,a5
	move	a7,a6
	calla	a5a6ol2
	mmfm	sp,a1,a2,a5,a6,a8,a11
	rets

print_core
	movi	rd15font,a6		; font table
	movk	10,a9			; size of space
	movk	2,a10			; space between letters
pcore1	move	*a0+,a2,w		; a2 = starting x coordinate
	move	*a0+,a3,w		; a3 = starting y coordinate
	move	*a0+,a11,w		; a11 = color of our letters
	movi	oid_fx,b0
	jruc	print_loop


p11_2s
	mmtm	sp,a1,a2,a5,a6,a8,a11
      	movk	1,b1
	jruc	p11bor

p11_2
	mmtm	sp,a1,a2,a5,a6,a8,a11
	clr	b1
p11bor	movi	rd11font,a6		; font table
	movk	5,a9			; size of space
	movk	1,a10			; space between letters
	callr	pcore1
	jruc	prnti2


p7_3s
	mmtm	sp,a1,a2,a5,a6,a8,a11
	movk	1,b1
	movi	rd7font,a6		; font table
	movk	5,a9			; size of space
	movk	1,a10			; space between letters
	callr	pcore1
	jruc	prnti3

p11_3s
	mmtm	sp,a1,a2,a5,a6,a8,a11
	movk	1,b1
	movi	rd11font,a6		; font table
	movk	5,a9			; size of space
	movk	1,a10			; space between letters
	callr	pcore1
	jruc	prnti3

**************************************************************************
*											     *
*  main print loop - given inputs of:							     *
* 											     *
*   a2 = x coordinate		  b0 = id to give each character		*
*   a3 = y coordinate		  b1 = shadow flag					*
*   a6 = font table								     	*
*   a9 = size of a space								     	*
*  a10 = space between letters							     	*
*  a11 = color to use										*
*											     *
**************************************************************************
print_loop
	clr	a4			; object list starts empty
	move	a2,b2			; b2 is used for starting a new line

ploop1	movb	*a0,a5			; gwab a wetter !!
	jreq	probj5			; zero --> we are done
	cmpi	' ',a5			; space ?
	jrne	probj3			; no --> skip
	addi	8,a0			; next letter
	add	a9,a2			; add the size of a space
	jruc	ploop1

probj3	cmpi	'\',a5			; special character
	jrne	probj7			; nope...
	addi	16,a0			; skip "n"
	push	a0
	move	b2,a2			; carrage return
	move	*a8(osizey),a0,w
	addk	3,a0			; plus spacing
	add	a0,a3			; next line down
	pull	a0
	jruc	ploop1

probj7	push	a4
	movi	newlet_init,a14
	calla	initobj_3 		; a8 = object for the letter

	move	b0,a1
	move	a1,*a8(oid),w		; give the character an id of b0

	move	a11,*a8(oconst),w	; constant color to use
	subi	>21,a5			; table starts at $21
	sll	5,a5			; 32 bit offset
	add	a6,a5
	move	*a5,a1,l		; ani input: a1 = image		
	move	*a8(oflags),a4,w	; ani input: a4 = flags

	move	a2,*a8(oxpos),w 	; plug in x coordinate
	move	a3,*a8(oypos),w 	; plug in y coordinate
	calla	ani
	pull	a4

	move	*a1,a5,w		; get width of letter
	add	a5,a2			; a2 = next x position
	add	a10,a2			; spacing between characters
*
* add object to list
*
	move	a4,a4			; 1st object on list ?
	jrne	probj6			; nope..
	move	a8,a7			; yes ---> a7 = last obj on list
probj6	move	a4,*a8(olink),l
	move	a8,a4			; new top 'o' list

	move	b1,b1			; shadow ?
	jreq	probj8			; nope...
*
* shadow
*
	mmtm	sp,a4,a9
	move	a8,a9			; a9 = letter we're gonna shadow
	movi	newlet_init,a14
	calla	initobj_3 		; a8 = object for the shadow
	move	b0,a1
	move	a1,*a8(oid),w		; give the character an id of b0
	movi	bpal_black,a1
	move	a1,*a8(oconst),w	; shadows are black

	move	*a9(oimg),a1,l	
	calla	ani
	move	*a9(oxpos),a1,w
	addk	2,a1
	move	a1,*a8(oxpos),w
	move	*a9(oypos),a1,w
	addk	2,a1
	move	a1,*a8(oypos),w
	move	*a9(ozpos),a1,w
	dec	a1
	move	a1,*a8(ozpos),w		; shadow coordinate offset
	mmfm	sp,a4,a9
	
	move	a4,*a8(olink),l
	move	a8,a4			; new top 'o' list

probj8	addi	8,a0			; a0 --> next letter
	jruc	ploop1			; go process it !!

probj5	rets

**************************************************************************
*												*
*			  7 POINT FONT							*
*												*
**************************************************************************
rd7font
	.LONG  FONT7excla,FONT7quote,FONT7pound,FONT7doll,FONT7percen
	.LONG  FONT7and
	.LONG  FONT7apost,FONT7parenl,FONT7parenr,FONT7ast,FONT7plus
	.LONG  FONT7comma,FONT7dash,FONT7period,FONT7forsp
FONT7_NUMS
	.LONG  FONT70,FONT71
	.LONG  FONT72,FONT73,FONT74,FONT75,FONT76,FONT77,FONT78,FONT79

	.LONG  FONT7colon,FONT7semicol,FONT7less,FONT7equal,FONT7more
	.LONG  FONT7quest,FONT7line
	.LONG  FONT7A,FONT7B,FONT7C,FONT7D,FONT7E,FONT7F,FONT7G,FONT7H
	.LONG  FONT7I,FONT7J,FONT7K,FONT7L,FONT7M,FONT7N,FONT7O,FONT7P
	.LONG  FONT7Q,FONT7R,FONT7S,FONT7T,FONT7U,FONT7V,FONT7W,FONT7X
	.LONG  FONT7Y,FONT7Z
	.LONG  FONT7excla,FONT7excla,FONT7excla,FONT7excla,FONT7line
	.LONG  FONT7apost	
	.LONG  FONT7A,FONT7B,FONT7C,FONT7D,FONT7E,FONT7F,FONT7G,FONT7H
	.LONG  FONT7I,FONT7J,FONT7K,FONT7L,FONT7M,FONT7N,FONT7O,FONT7P
	.LONG  FONT7Q,FONT7R,FONT7S,FONT7T,FONT7U,FONT7V,FONT7W,FONT7X
	.LONG  FONT7Y,FONT7Z
	.LONG  FONT7excla,FONT7excla,FONT7excla

**************************************************************************
*											     *
*    VOGEL'S 11 POINT FONT									*
*											     *
**************************************************************************
rd11font
	.long	vfontexc,vfontquo,vfontnum,vfontdol,vfontper,vfontand
	.long	vfontapp,vfontpr1,vfontpr2,vfontast,vfontpls
	.long	vfontcom,vfontmin,vfontperiod,vfontslash

	.long	vfont0,vfont1,vfont2,vfont3,vfont4
	.long	vfont5,vfont6,vfont7,vfont8,vfont9

	.long	vfontcol,vfontsem,vfontles,vfontequ,vfontgrt
	.long	vfontque,BSCHAR

	.long	vfontA,vfontB,vfontC,vfontD,vfontE,vfontF,vfontG,vfontH
	.long	vfontI,vfontJ,vfontK,vfontL,vfontM,vfontN,vfontO,vfontP
 	.long	vfontQ,vfontR,vfontS,vfontT,vfontU,vfontV,vfontW,vfontX
	.long	vfontY,vfontZ

	.long	BSCHAR,BSCHAR,BSCHAR,BSCHAR,BSCHAR,BSCHAR

	.long	vfontA,vfontB,vfontC,vfontD,vfontE,vfontF,vfontG,vfontH
	.long	vfontI,vfontJ,vfontK,vfontL,vfontM,vfontN,vfontO,vfontP
 	.long	vfontQ,vfontR,vfontS,vfontT,vfontU,vfontV,vfontW,vfontX
	.long	vfontY,vfontZ

	.long	BSCHAR,BSCHAR,BSCHAR

**************************************************************************
*												*
*			  15 POINT FONT							*
*												*
**************************************************************************

BSCHAR	.SET	MK2FONTA


rd15font
     	.long	MK2FONTexc,MK2FONTquo,MK2FONTnum,MK2FONTdol,MK2FONTper,MK2FONTand
	.long	MK2FONTapp,MK2FONTpr1,MK2FONTpr2,MK2FONTast,MK2FONTpls
	.long	MK2FONTcom,MK2FONTmin,MK2FONTperiod,MK2FONTslash

font15_nums
     	.long	MK2FONT0,MK2FONT1,MK2FONT2,MK2FONT3,MK2FONT4
	.long	MK2FONT5,MK2FONT6,MK2FONT7,MK2FONT8,MK2FONT9

	.long	MK2FONTcol,MK2FONTsem,MK2FONTles,MK2FONTequ,MK2FONTgrt
	.long	MK2FONTque,MK2FONTmin
	
	.long	MK2FONTA,MK2FONTB,MK2FONTC,MK2FONTD,MK2FONTE,MK2FONTF
	.long	MK2FONTG,MK2FONTH,MK2FONTI,MK2FONTJ,MK2FONTK,MK2FONTL
	.long	MK2FONTM,MK2FONTN,MK2FONTO,MK2FONTP,MK2FONTQ,MK2FONTR
	.long	MK2FONTS,MK2FONTT,MK2FONTU,MK2FONTV,MK2FONTW,MK2FONTX
	.long	MK2FONTY,MK2FONTZ

	.long	BSCHAR,BSCHAR,BSCHAR,BSCHAR,BSCHAR,BSCHAR

	.long	MK2FONTA,MK2FONTB,MK2FONTC,MK2FONTD,MK2FONTE,MK2FONTF
	.long	MK2FONTG,MK2FONTH,MK2FONTI,MK2FONTJ,MK2FONTK,MK2FONTL
	.long	MK2FONTM,MK2FONTN,MK2FONTO,MK2FONTP,MK2FONTQ,MK2FONTR
	.long	MK2FONTS,MK2FONTT,MK2FONTU,MK2FONTV,MK2FONTW,MK2FONTX
	.long	MK2FONTY,MK2FONTZ

	.long	BSCHAR,BSCHAR,BSCHAR

****************************

	.end
