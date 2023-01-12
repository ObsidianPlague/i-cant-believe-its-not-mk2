**************************************************************************
*											     *
*  video game project:	mortal kombat 2							*
* 											     *
*  game software:    	ed boon									*
*												*
*  module: display system equates								*
* 											     *
*  copyright (c) 1993 williams electronics games, inc.			     *
*											     *
**************************************************************************

dpystrt0 	.set	>fffc	;line 0
dpystrt1 	.set	>effc	;line 256


page0adr 	.set	>0	;(1 dead, 254 playfield)*2, 2 autoerase
page1adr 	.set	>1000000 ;256*8*512

xpadding		.set	56	; 56 pixel padding for the lofredo curse !!

scrtop		.set	0
scrbot		.set	253
scrlft		.set	0
scrrgt		.set	399

scrnst		.set	[scrtop,scrlft]	   ; top left of screen
scrnend		.set	[scrbot+1,scrrgt+1]  ; bot right of screen (for scrnlr, clipper)
scrwidth 	.set	scrrgt-scrlft+1
scrhght		.set	scrbot-scrtop+1
scrnmid		.set	[(scrbot+scrtop+1)/2,(scrrgt+scrlft+1)/2] ;midpoint of screen

**************************************************************************
*												*
*	object block layout									*
*												*
**************************************************************************
olink	.set	0	; (32) link to next object block
oslink	.set	020h	; (32) bit special link to objects in class
oplink	.set	oslink	; (32) bit link to controlling process
ograv	.set	oslink	; (32) gravity

oxvel	.set	040h	; (32) bit x velocity 16.16
oyvel	.set	060h	; (32) bit y velocity 16.16
oxval	.set	080h	; (32) bit x position
oxpos	.set	090h	; (16) integer portion of x position
oyval	.set	0a0h	; (32) bit y position			
oypos	.set	0b0h	; (16) integer portion of y position
ozval	.set	0c0h	; (32) bit z position
ozpos	.set	0d0h	; (16) integer z position of object

;*****************************
ofset	.set	0e0h	;            (16) bits 16-31 precomputed offset
oflags	.set	0f0h	; mmtm a12 - (16) bits 0 - 5 dma control
osag	.set	100h	; mmtm a11 - (32) bit source address (unclipped, adjusted for flips)
osize	.set	120h	; mmtm  a9 - (32) bit h,w of object (16,16)	w=adjusted for morsel
osizex	.set	120h	;            (16) x size
osizey	.set	130h	;            (16) y size
opal	.set	140h	; mmtm  a8 - (16) bit b(0-15) palette
oconst	.set	150h	;            (16) bit b(16-31) constant color
oflags2	.set	160h	; mmtm  a7 - (32) game flags
oscale	.set	180h	; mmtm  a6 - (32) scale factor for dma
;*****************************

oimg	.set	1a0h	; (32) bit pointer to image data table	
oid	.set	1c0h	; (16) bit object id			
oshape	.set	1d0h	; (32) multipart "ani shape"
ochar	.set	1f0h	; (16) character i.d.
obsiz	.set	210h	; object block size

;nobj	.set	384	; objects to display
nobj	.set	358	; objects to display

bqcell	.set	>a0	; size of dma queue element

;****************************************************************** Removed
;oplink	.set	1d0h	; (32) bit link to controlling process
;oxclip	.set	1f0h	; (16) bit total x preclip
;oshad	.set	200h	; (32) shadow link
;omlink	.set	220h	; (32) master link
;omirror	.set	260h	; (32) mirror image of last shape i took
;****************************************************************** Removed

mp_sag		.set	0
mp_yxsize	.set	32
mp_sizex		.set	32
mp_sizey		.set	32+16
mp_control	.set	32+32
mp_anixy		.set	32+32+16
mp_anix		.set	32+32+16	; multipart animation x offset
mp_aniy		.set	32+32+16+16	; multipart animation y offset
mp_length	.set	32+32+16+32	; size of multipart node piece

**************************************************************************
*											     *
*   oflags										     *
*											     *
**************************************************************************
m_wrzero 	.set	>01	; write zero data
m_wrnonz 	.set	>02	; write non-zero data
m_conzer 	.set	>04	; replace zero data with constant
m_connon 	.set	>08	; replace non-zero data with constant
m_const		.set	>0c	; any constant data replacement
m_fliph		.set	>10	; flip horizontally
m_flipv		.set	>20	; flip vertically

b_wrzero		.set	0
b_wrnonz		.set	1
b_conzer		.set	2
b_connon		.set	3
b_fliph		.set	4
b_flipv		.set	5

**************************************************************************
*											     *
*    oflags2										     *
*											     *
**************************************************************************
m_noscroll	.set	>0001	; don't scroll this object
m_multipart	.set	>0002	; multipart object
m_noblock	.set	>0004	; player can't block at this point
m_noflip		.set	>0008	; i can't be flipped at this moment
m_shadow		.set	>0010	; shadow me
m_inviso		.set	>0020	; invisible object
m_ugly_pal	.set	>0040	; ugly palette


b_noscroll	.set	0	; don't scroll this object
b_multipart	.set	1	; multipart object
b_noblock	.set	2	; player can't block at this point
b_noflip		.set	3	; i can't be flipped at this moment
b_shadow		.set	4	; shadow me
b_inviso		.set	5	; invisible object
b_ugly_pal	.set	6	; ugly palette
