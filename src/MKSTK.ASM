**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: strike tables										*
* 											     *
*  copyright (c) 1993 midway manufacturing							*
*											     *
**************************************************************************
	.file	'mkstk.asm'
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
	.text

**************************************************************************
*											     *
*  get_char_stk - get a characters strike entry					     *
* 											     *
*  input: a0 = offset									     *
*         a8 = object with "ochar" set						     *
* 											     *
*  returns: a0 = correct "stk" table							     *
*											     *
**************************************************************************
get_char_stk	
	move	*a8(ochar),a1,w
	sll	5,a0
	sll	5,a1
	addi	strike_tables,a1
	move	*a1,a1,l
	add	a1,a0
	move	*a0,a0,l	; a0 = correct "stk" table
	rets

strike_tables
	.long	hh_strikes  	;  0 - hathead
	.long	lk_strikes	;  1 - liu kang
	.long	jc_strikes	;  2
	.long	sa_strikes	;  3
	.long	fn_strikes	;  4
	.long	fn_strikes	;  5
	.long	st_strikes	;  6
	.long	rd_strikes	;  7 - raiden
	.long	nj_strikes	;  8 - subzero
	.long	nj_strikes	;  9 - reptile
	.long	nj_strikes	; 10 - scoprion
	.long	jx_strikes	; 11 - jax
	.long	go_strikes	; 12 - goro
	.long	sk_strikes	; 13 - shao kahn
	.long	nj_strikes	; 14 - smoke
	.long	nj_strikes	; 15
	.long	fn_strikes	; 16 - jade

stk_dummy
	.word	00		; x offset of collision box
	.word	00		; y offset of collision box
	.word	00		; x size of collision box
	.word	00		; y size of collision box
	.word	>0000		; strike routine
	.word	>0000		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

**************************************************************************
*											     *
*   Shao Kahn strike tables							   	     *
*											     *
**************************************************************************
sk_strikes
	.long	stk_sk_punch	; 0
	.long	stk_sk_kick	; 1
	.long	stk_sk_charge	; 2
	.long	stk_sk_uppercut	; 3
	.long	stk_sk_spear	; 4


stk_sk_punch
	.word	>59		; x offset of collision box
	.word	>28		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>20		; y size of collision box
	.word	>0025		; strike routine
	.word	>3010		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_sk_kick
	.word	>6c		; x offset of collision box
	.word	>3b		; y offset of collision box
	.word	>50		; x size of collision box
	.word	>18		; y size of collision box
	.word	>0026		; strike routine
	.word	>3412		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_sk_charge
	.word	>50		; x offset of collision box
	.word	>1b		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>68		; y size of collision box
	.word	>0026		; strike routine
	.word	>3412		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_sk_uppercut
	.word	>56		; x offset of collision box
	.word	>15		; y offset of collision box
	.word	>35		; x size of collision box
	.word	>3d		; y size of collision box
	.word	>0026		; strike routine
	.word	>3412		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_sk_spear
	.word	>78		; x offset of collision box
	.word	>2c		; y offset of collision box
	.word	>46		; x size of collision box
	.word	>10		; y size of collision box
	.word	>0225		; strike routine
	.word	>2808		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

**************************************************************************
*											     *
*   Goro strike tables									     *
*											     *
**************************************************************************
go_strikes
	.long	stk_goro_punch		;
	.long	stk_goro_kick		;
	.long	stk_goro_uppercut	;
	.long	stk_goro_punch		;
	.long	stk_goro_punch		;
	.long	stk_goro_punch		;
	.long	stk_goro_fireball	; 6


stk_goro_punch
	.word	>7a		; x offset of collision box
	.word	>20		; y offset of collision box
	.word	>60		; x size of collision box
	.word	>30		; y size of collision box
	.word	>0020		; strike routine
	.word	>280c		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_goro_kick
	.word	>7a		; x offset of collision box
	.word	>20		; y offset of collision box
	.word	>60		; x size of collision box
	.word	>30		; y size of collision box
	.word	>0020		; strike routine
	.word	>3510		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_goro_uppercut
	.word	>7a		; x offset of collision box
	.word	>20		; y offset of collision box
	.word	>60		; x size of collision box
	.word	>30		; y size of collision box
	.word	>0120		; strike routine
	.word	>280d		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_goro_fireball
	.word	>16		; x offset of collision box
	.word	->08		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>13		; y size of collision box
	.word	>0620		; strike routine
	.word	>280f		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

**************************************************************************
*											     *
*   Jax strike tables									     *
*											     *
**************************************************************************
jx_strikes
	.long	stk_jxhikick	; 0
	.long	stk_jxlokick	; 1
	.long	stk_jxhipunch	; 2
	.long	stk_jxlopunch	; 3
	.long	stk_jxsweepk	; 4
	.long	stk_jxduckpunch	; 5
	.long	stk_jxduckkickh	; 6
	.long	stk_jxduckkickl	; 7
	.long	stk_jxuppercut	; 8
	.long	stk_jxjumpupp	; 9
	.long	stk_jxjumpupk	; a
	.long	stk_jxflipk	; b
	.long	stk_jxflipp	; c
	.long	stk_jxroundh	; d
	.long	stk_jxknee	; e
	.long	stk_jxelbow	; f
	.long	stk_noogy	; 10
	.long	stk_jxzap		; 11
	.long	stk_dummy	; 12
	.long	stk_dummy	; 13
	.long	stk_dummy	; 14
	.long	stk_dummy	; 15


;
; note: if the # of entries in these tables changes then look for
;       the string "stksize"
;

stk_jxhikick
	.word	>76		; x offset of collision box
	.word	>1d		; y offset of collision box
	.word	>4c		; x size of collision box
	.word	>1d		; y size of collision box
	.word	>0000		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxlokick
	.word	>7f		; x offset of collision box

	.word	>28		; raised so people can duck under
;	.word	>38

	.word	>4a		; x size of collision box
	.word	>12		; y size of collision box
	.word	>0101		; strike routine
	.word	>1a06		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxhipunch
	.word	>58		; x offset of collision box
	.word	>12		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>14		; y size of collision box
	.word	>0202		; strike routine
	.word	>0b03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxlopunch
	.word	>5a		; x offset of collision box
	.word	>20		; y offset of collision box
	.word	>3b		; x size of collision box
	.word	>18		; y size of collision box
	.word	>0303		; strike routine
	.word	>0802		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxsweepk
	.word	>60		; x offset of collision box
	.word	>7b		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>16		; y size of collision box
	.word	>041c		; strike routine
	.word	>1405		; damage
	.long	0		; score value for hit
	.word	sf_duck

stk_jxduckpunch
	.word	>5c		; x offset of collision box
	.word	>47		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>13		; y size of collision box
	.word	>0505		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxduckkickh
	.word	>70		; x offset of collision box
	.word	>50		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>1b		; y size of collision box
	.word	>0606		; strike routine
	.word	>0c03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxduckkickl
	.word	>60		; x offset of collision box
	.word	>80		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>14		; y size of collision box
	.word	>0707		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxuppercut
	.word	>5a		; x offset of collision box
	.word	->0a		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>40		; y size of collision box

;	.word	>58		; x offset of collision box
;	.word	>fffc		; y offset of collision box
;	.word	>2c		; x size of collision box
;	.word	>38		; y size of collision box

	.word	>081e		; strike routine
	.WORD	>280A		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxjumpupp
	.word	>56		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>24		; y size of collision box
	.word	>0909		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxjumpupk
	.word	>54		; x offset of collision box
	.word	>08		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>35		; y size of collision box
	.word	>0a0a		; strike routine
	.word	>2006		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxflipk
	.word	>63		; x offset of collision box
	.word	>34		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>20		; y size of collision box
	.word	>0b12		; strike routine
	.word	>1a07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxflipp
	.word	>59		; x offset of collision box
	.word	>16		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>24		; y size of collision box
	.word	>0c12		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxroundh
	.word	>5d		; x offset of collision box
	.word	>06		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0d1e		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxknee
	.word	>44		; x offset of collision box
	.word	>27		; y offset of collision box
	.word	>20		; x size of collision box
	.word	>20		; y size of collision box
	.word	>0e0e		; strike routine
	.word	>1004		; damage
	.long	0		; score value for hit
	.word	0

stk_jxelbow
	.word	>48 		; x offset of collision box
	.word	>08		; y offset of collision box
	.word	>2c		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0f0f		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_noogy
	.word	>6b 		; x offset of collision box
	.word	>18		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>12		; y size of collision box
	.word	>1010		; strike routine
	.word	>0000		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jxzap
	.word	>80 		; x offset of collision box
	.word	>18		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>10		; y size of collision box
	.word	>1008		; strike routine
	.word	>1205		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

**************************************************************************
*											     *
*   Ninja strike tables									     *
*											     *
**************************************************************************
nj_strikes
	.long	stk_njhikick	; 0
	.long	stk_njlokick	; 1
	.long	stk_njhipunch	; 2
	.long	stk_njlopunch	; 3
	.long	stk_njsweepk	; 4
	.long	stk_njduckpunch	; 5
	.long	stk_njduckkickh	; 6
	.long	stk_njduckkickl	; 7
	.long	stk_njuppercut	; 8
	.long	stk_njjumpupp	; 9
	.long	stk_njjumpupk	; a
	.long	stk_njflipk	; b
	.long	stk_njflipp	; c
	.long	stk_njroundh	; d
	.long	stk_njknee	; e
	.long	stk_njelbow	; f
	.long	stk_njbang	; 10
	.long	stk_njspear	; 11
	.long	stk_slide	; 12
	.long	stk_ice1	; 13
	.long	stk_ice2	; 14
	.long	stk_floor_ice	; 15
	.long	stk_decoy	; 16
	.long	stk_spit1	; 17
	.long	stk_spit2	; 18
	.long	stk_scissor	; 19
	.long	stk_superf	; 1a

stk_njhikick
	.word	>64		; x offset of collision box
	.word	>0c		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>1d		; y size of collision box
	.word	>0000		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njlokick
	.word	>6d		; x offset of collision box
	.word	>20		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>12		; y size of collision box
	.word	>0101		; strike routine
	.word	>1a06		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njhipunch
	.word	>4e		; x offset of collision box
	.word	>04		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>14		; y size of collision box
	.word	>0202		; strike routine
	.word	>0b03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njlopunch
	.word	>4a		; x offset of collision box
	.word	>16		; y offset of collision box
	.word	>2c		; x size of collision box
	.word	>14		; y size of collision box
	.word	>0303		; strike routine
	.word	>0802		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njsweepk
	.word	>60		; x offset of collision box
	.word	>6b		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>16		; y size of collision box
	.word	>041c		; strike routine
	.word	>1405		; damage
	.long	0		; score value for hit
	.word	sf_duck

stk_njduckpunch
	.word	>46		; x offset of collision box
	.word	>3a		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>1c		; y size of collision box
	.word	>0505		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njduckkickh
	.word	>50		; x offset of collision box
	.word	>38		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>1b		; y size of collision box
	.word	>0606		; strike routine
	.word	>0c03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njduckkickl
	.word	>50		; x offset of collision box
	.word	>70		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>14		; y size of collision box
	.word	>0707		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njuppercut
	.word	>4e		; x offset of collision box
	.word	->10		; y offset of collision box
	.word	>38		; x size of collision box
	.word	>40		; y size of collision box

;	.word	>48		; x offset of collision box
;	.word	>fffc		; y offset of collision box
;	.word	>2c		; x size of collision box
;	.word	>38		; y size of collision box

	.word	>081e		; strike routine
	.WORD	>280A		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njjumpupp
	.word	>59		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>24		; y size of collision box
	.word	>0909		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njjumpupk
	.word	>50		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>20		; y size of collision box
	.word	>0a0a		; strike routine
	.word	>2006		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njflipk
	.word	>63		; x offset of collision box
	.word	>24		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>20		; y size of collision box
	.word	>0b12		; strike routine
	.word	>1a07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njflipp
	.word	>59		; x offset of collision box
	.word	>0d		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>24		; y size of collision box
	.word	>0c12		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njroundh
	.word	>60		; x offset of collision box
	.word	>06		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0d1e		; strike routine
	.word	>1e08		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njknee
	.word	>40		; x offset of collision box
	.word	>1c		; y offset of collision box
	.word	>20		; x size of collision box
	.word	>20		; y size of collision box
	.word	>0e0e		; strike routine
	.word	>1004		; damage
	.long	0		; score value for hit
	.word	0

stk_njelbow
	.word	>37		; x offset of collision box
	.word	>08		; y offset of collision box
	.word	>2c		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0f0f		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_njbang
	.word	>20		; x offset of collision box
	.word	->18		; y offset of collision box
	.word	>34		; x size of collision box
	.word	>30		; y size of collision box
	.word	>1010		; strike routine
	.word	>1004		; damage
	.long	0		; score value for hit
	.word	0

stk_njspear
	.word	>8c		; x offset of collision box
	.word	>24		; y offset of collision box
	.word	>50		; x size of collision box
	.word	>10		; y size of collision box
	.word	>1110		; strike routine
	.word	>0802		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_slide
	.word	78		; x offset of collision box
	.word	125		; y offset of collision box
	.word	65		; x size of collision box
	.word	24		; y size of collision box
	.word	>1210		; strike routine
	.word	>0d03		; damage
	.long	sc_1000		; score value for hit
	.word	sf_squeeze

stk_ice1
	.word	>40		; x offset of collision box
	.word	->08		; y offset of collision box
	.word	>60		; x size of collision box
	.word	>10		; y size of collision box
	.word	>1313		; strike routine
	.word	>0000		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_ice2
	.word	>90		; x offset of collision box
	.word	->0c		; y offset of collision box
	.word	>60		; x size of collision box
	.word	>10		; y size of collision box
	.word	>1313		; strike routine
	.word	>0000		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_floor_ice
	.word	>9d		; x offset of collision box
	.word	>80		; y offset of collision box
	.word	>60		; x size of collision box
	.word	>10		; y size of collision box
	.word	>1515		; strike routine / block routine
	.word	>0000		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_decoy
	.word	>59		; x offset of collision box
	.word	>0d		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>24		; y size of collision box
	.word	>1611		; strike routine
	.word	>0d03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_spit1
	.word	>79		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>14		; y size of collision box
	.word	>1701		; strike routine
	.word	>0f04		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_spit2
	.word	>a9		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>14		; y size of collision box
	.word	>1701		; strike routine
	.word	>0f04		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_scissor
	.word	>60		; x offset of collision box
	.word	>03		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>30		; y size of collision box
	.word	>1818		; strike routine
	.word	>0003		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_superf
	.word	>90		; x offset of collision box
	.word	->0c		; y offset of collision box
	.word	>60		; x size of collision box
	.word	>10		; y size of collision box
	.word	>1919		; strike routine
	.word	>0000		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

**************************************************************************
*											     *
*  Raiden strike tables									     *
*											     *
**************************************************************************
rd_strikes
	.long	stk_rdhikick	; 0
	.long	stk_rdlokick	; 1
	.long	stk_rdhipunch	; 2
	.long	stk_rdlopunch	; 3
	.long	stk_rdsweepk	; 4
	.long	stk_rdduckpunch	; 5
	.long	stk_rdduckkickh	; 6
	.long	stk_rdduckkickl	; 7
	.long	stk_rduppercut	; 8
	.long	stk_rdjumpupp	; 9
	.long	stk_rdjumpupk	; a
	.long	stk_rdflipk	; b
	.long	stk_rdflipp	; c
	.long	stk_rdroundh	; d
	.long	stk_rdknee	; e
	.long	stk_rdelbow	; f
	.long	stk_rdzap1	; 10
	.long	stk_rdzap2	; 11
	.long	stk_dummy	; 12
	.long	stk_dummy	; 13
	.long	stk_dive	; 14 = raiden dive move


stk_rdhikick
	.word	>58		; x offset of collision box
	.word	>10		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>23		; y size of collision box
	.word	>0000		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdlokick
	.word	>63		; x offset of collision box
	.word	>2d		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0101		; strike routine
	.word	>1a06		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdhipunch
	.word	>49		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>3b		; x size of collision box
	.word	>24		; y size of collision box
	.word	>0202		; strike routine
	.word	>0b03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdlopunch
	.word	>4a		; x offset of collision box
	.word	>21		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>18		; y size of collision box
	.word	>0303		; strike routine
	.word	>0802		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdsweepk
	.word	>67		; x offset of collision box
	.word	>6b		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>22		; y size of collision box
	.word	>041c		; strike routine
	.word	>1405		; damage
	.long	0		; score value for hit
	.word	sf_duck

stk_rdduckpunch
	.word	>46		; x offset of collision box
	.word	>3d		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>1c		; y size of collision box
	.word	>0505		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdduckkickh
	.word	>58		; x offset of collision box
	.word	>38		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>1b		; y size of collision box
	.word	>0606		; strike routine
	.word	>0c03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdduckkickl
	.word	>5c		; x offset of collision box
	.word	>78		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>1b		; y size of collision box
	.word	>0707		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rduppercut
	.word	>4e		; x offset of collision box
	.word	->0a		; y offset of collision box
	.word	>36		; x size of collision box
	.word	>42		; y size of collision box

;	.word	>48		; x offset of collision box
;	.word	>fffc		; y offset of collision box
;	.word	>2c		; x size of collision box
;	.word	>38		; y size of collision box

	.word	>081e		; strike routine
	.WORD	>280A		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdjumpupp
	.word	>63		; x offset of collision box
	.word	>08		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>24		; y size of collision box
	.word	>0909		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdjumpupk
	.word	>62		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>25		; y size of collision box
	.word	>0a0a		; strike routine
	.word	>2006		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdflipk
	.word	>65		; x offset of collision box
	.word	>28		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>27		; y size of collision box
	.word	>0b12		; strike routine
	.word	>1a07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdflipp
	.word	>63		; x offset of collision box
	.word	>08		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>24		; y size of collision box
	.word	>0c12		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdroundh
	.word	>50		; x offset of collision box
	.word	>06		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>32		; y size of collision box
	.word	>0d1e		; strike routine
	.word	>2109		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdknee
	.word	>3b		; x offset of collision box
	.word	>15		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>2b		; y size of collision box
	.word	>0e0e		; strike routine
	.word	>1004		; damage
	.long	0		; score value for hit
	.word	0

stk_rdelbow
	.word	>39		; x offset of collision box
	.word	>0c		; y offset of collision box
	.word	>2c		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0f0f		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdzap1
	.word	>65		; x offset of collision box
	.word	>24		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>10		; y size of collision box
	.word	>1010		; strike routine
	.word	>1604		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_rdzap2
	.word	>85		; x offset of collision box
	.word	>24		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>10		; y size of collision box
	.word	>1010		; strike routine
	.word	>1604		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_dive
	.word	>50		; x offset of collision box
	.word	>2d		; y offset of collision box
	.word	>5a		; x size of collision box
	.word	>18		; y size of collision box
	.word	>141b		; strike routine
	.word	>1e07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

**************************************************************************
*											     *
*  Shang Tsung strike table								     *
*											     *
**************************************************************************
st_strikes
	.long	stk_sthikick	; 0
	.long	stk_stlokick	; 1
	.long	stk_sthipunch	; 2
	.long	stk_stlopunch	; 3
	.long	stk_stsweepk	; 4
	.long	stk_stduckpunch	; 5
	.long	stk_stduckkickh	; 6
	.long	stk_stduckkickl	; 7
	.long	stk_stuppercut	; 8
	.long	stk_stjumpupp	; 9
	.long	stk_stjumpupk	; a
	.long	stk_stflipk	; b
	.long	stk_stflipp	; c
	.long	stk_stroundh	; d
	.long	stk_stknee	; e
	.long	stk_stelbow	; f

	.long	stk_skull1	; 10
	.long	stk_skull2	; 10
	.long	stk_dummy	; 12
	.long	stk_dummy	; 13

stk_sthikick
	.word	>5d		; x offset of collision box
	.word	>08		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>2b		; y size of collision box
	.word	>0000		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_stlokick
	.word	>5d		; x offset of collision box
	.word	>2d		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0101		; strike routine
	.word	>1a06		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_sthipunch
	.word	>4d		; x offset of collision box
	.word	>09		; y offset of collision box
	.word	>3b		; x size of collision box
	.word	>24		; y size of collision box
	.word	>0202		; strike routine
	.word	>0b03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_stlopunch
	.word	>4e		; x offset of collision box
	.word	>18		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>24		; y size of collision box
	.word	>0303		; strike routine
	.word	>0802		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_stsweepk
	.word	>60		; x offset of collision box
	.word	>64		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>28		; y size of collision box
	.word	>041c		; strike routine
	.word	>1405		; damage
	.long	0		; score value for hit
	.word	sf_duck

stk_stduckpunch
	.word	>42		; x offset of collision box
	.word	>42		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0505		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_stduckkickh
	.word	>5d		; x offset of collision box
	.word	>3d		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0606		; strike routine
	.word	>0c03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_stduckkickl
	.word	>5c		; x offset of collision box
	.word	>68		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>1b		; y size of collision box
	.word	>0707		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_stuppercut
	.word	>4e		; x offset of collision box
	.word	->10		; y offset of collision box
	.word	>36		; x size of collision box
	.word	>40		; y size of collision box

;	.word	>48		; x offset of collision box
;	.word	>fffc		; y offset of collision box
;	.word	>2c		; x size of collision box
;	.word	>38		; y size of collision box

	.word	>081e		; strike routine
	.WORD	>280A		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_stjumpupp
	.word	>53		; x offset of collision box
	.word	>24		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>28		; y size of collision box
	.word	>0909		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_stjumpupk
	.word	>42		; x offset of collision box
	.word	>04		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>32		; y size of collision box
	.word	>0a0a		; strike routine
	.word	>2006		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_stflipk
	.word	>55		; x offset of collision box
	.word	>28		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>2d		; y size of collision box
	.word	>0b12		; strike routine
	.word	>1a07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_stflipp
	.word	>50		; x offset of collision box
	.word	>26		; y offset of collision box
	.word	>33		; x size of collision box
	.word	>1b		; y size of collision box
	.word	>0c12		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_stroundh
	.word	>50		; x offset of collision box
	.word	>06		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>2c		; y size of collision box
	.word	>0d1e		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_stknee
	.word	>3b		; x offset of collision box
	.word	>2a		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>2b		; y size of collision box
	.word	>0e0e		; strike routine
	.word	>1004		; damage
	.long	0		; score value for hit
	.word	0

stk_stelbow
	.word	>39		; x offset of collision box
	.word	>0c		; y offset of collision box
	.word	>2c		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0f0f		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_skull1
	.word	>50		; x offset of collision box
	.word	>10		; y offset of collision box
	.word	>2c		; x size of collision box
	.word	>1e		; y size of collision box
	.word	>1010		; strike routine
	.word	>1304		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_skull2
	.word	>8a		; x offset of collision box
	.word	>10		; y offset of collision box
	.word	>2c		; x size of collision box
	.word	>1e		; y size of collision box
	.word	>1010		; strike routine
	.word	>1304		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

**************************************************************************
*											     *
*  Female Ninja strike table								     *
*											     *
**************************************************************************
fn_strikes
	.long	stk_fnhikick	; 0
	.long	stk_fnlokick	; 1
	.long	stk_fnhipunch	; 2
	.long	stk_fnlopunch	; 3
	.long	stk_fnsweepk	; 4
	.long	stk_fnduckpunch	; 5
	.long	stk_fnduckkickh	; 6
	.long	stk_fnduckkickl	; 7
	.long	stk_fnuppercut	; 8
	.long	stk_fnjumpupp	; 9
	.long	stk_fnjumpupk	; a
	.long	stk_fnflipk	; b
	.long	stk_fnflipp	; c
	.long	stk_fnroundh	; d
	.long	stk_fnknee	; e
	.long	stk_fnelbow	; f
	.long	stk_fnfans	; 10
	.long	stk_fntsai	; 11
	.long	stk_spinfan	; 12
	.long	stk_fan_swipe	; 13
	.long	stk_fn2_tele	; 14
	.long	stk_square	; 15
	.long	stk_kano	; 16

stk_fnhikick
	.word	>5d		; x offset of collision box
	.word	>0a		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>23		; y size of collision box
	.word	>0000		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnlokick
	.word	>64		; x offset of collision box
	.word	>25		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0101		; strike routine
	.word	>1a06		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnhipunch
	.word	>44		; x offset of collision box
	.word	>10		; y offset of collision box
	.word	>32		; x size of collision box
	.word	>24		; y size of collision box
	.word	>0202		; strike routine
	.word	>0b03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnlopunch
	.word	>4c		; x offset of collision box
	.word	>1b		; y offset of collision box
	.word	>38		; x size of collision box
	.word	>18		; y size of collision box
	.word	>0303		; strike routine
	.word	>0802		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnsweepk
	.word	>6d		; x offset of collision box
	.word	>64		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>28		; y size of collision box
	.word	>041c		; strike routine
	.word	>1405		; damage
	.long	0		; score value for hit
	.word	sf_duck

stk_fnduckpunch
	.word	>3c		; x offset of collision box
	.word	>3a		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0505		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnduckkickh
	.word	>60		; x offset of collision box
	.word	>43		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>32		; y size of collision box
	.word	>0606		; strike routine
	.word	>0c03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnduckkickl
	.word	>4d		; x offset of collision box
	.word	>70		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>1b		; y size of collision box
	.word	>0707		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnuppercut
	.word	>4e		; x offset of collision box
	.word	->0a		; y offset of collision box
	.word	>34		; x size of collision box
	.word	>40		; y size of collision box

;	.word	>45		; x offset of collision box
;	.word	>fffc		; y offset of collision box
;	.word	>2c		; x size of collision box
;	.word	>38		; y size of collision box

	.word	>081e		; strike routine
	.WORD	>280A		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnjumpupp
	.word	>58		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>36		; y size of collision box
	.word	>0909		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnjumpupk

;	.word	>42		; x offset of collision box
	.word	>4d		; x offset of collision box

	.word	->03		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>42		; y size of collision box
	.word	>0a0a		; strike routine
	.word	>2006		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnflipk
	.word	>5a		; x offset of collision box
	.word	>20		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>33		; y size of collision box
	.word	>0b12		; strike routine
	.word	>1a07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnflipp
	.word	>58		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>36		; y size of collision box
	.word	>0c12		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnroundh
	.word	>60		; x offset of collision box
	.word	->03		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>2c		; y size of collision box
	.word	>0d1e		; strike routine
	.word	>2109		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnknee
	.word	>38		; x offset of collision box
	.word	>30		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>2b		; y size of collision box
	.word	>0e0e		; strike routine
	.word	>1004		; damage
	.long	0		; score value for hit
	.word	0

stk_fnelbow
	.word	>39		; x offset of collision box
	.word	>0c		; y offset of collision box
	.word	>2c		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0f0f		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fnfans
	.word	>3a		; x offset of collision box
	.word	>10		; y offset of collision box
	.word	>38		; x size of collision box
	.word	>10		; y size of collision box
	.word	>1010		; strike routine
	.word	>2004		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fntsai
	.word	>4d		; x offset of collision box
	.word	>18		; y offset of collision box
	.word	>38		; x size of collision box
	.word	>20		; y size of collision box
	.word	>1110		; strike routine
	.word	>1705		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_spinfan
	.word	>6d		; x offset of collision box
	.word	->30		; y offset of collision box
	.word	>4d		; x size of collision box
	.word	>40		; y size of collision box
	.word	>1210		; strike routine
	.word	>0000		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fan_swipe
	.word	>5a		; x offset of collision box
	.word	>1c		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>12		; y size of collision box
	.word	>1313		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_fn2_tele
	.word	>5a		; x offset of collision box
	.word	>20		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>33		; y size of collision box
	.word	>151d		; strike routine
	.word	>2004		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_square
	.word	>5d		; x offset of collision box
	.word	>24		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>26		; y size of collision box
	.word	>1414		; strike routine
	.word	>1505		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_kano
	.word	>40		; x offset of collision box
	.word	>10		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>30		; y size of collision box
	.word	>1608		; strike routine
	.word	>1505		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

**************************************************************************
*											     *
*  Sword Arms' strike table  								     *
*											     *
**************************************************************************
sa_strikes
	.long	stk_sahikick	; 0
	.long	stk_salokick	; 1
	.long	stk_sahipunch	; 2
	.long	stk_salopunch	; 3
	.long	stk_sasweepk	; 4
	.long	stk_saduckpunch	; 5
	.long	stk_saduckkickh	; 6
	.long	stk_saduckkickl	; 7
	.long	stk_sauppercut	; 8
	.long	stk_sajumpupp	; 9
	.long	stk_sajumpupk	; a
	.long	stk_saflipk	; b
	.long	stk_saflipp	; c
	.long	stk_saroundh	; d
	.long	stk_saknee	; e
	.long	stk_saelbow	; f
	.long	stk_sazap1	; 10
	.long	stk_sa2ndknee	; 11
	.long	stk_swipe	; 12
	.long	stk_sazap4	; 13
	.long	stk_shred	; 14
	.long	stk_spin	; 15
	.long	stk_spark1	; 16
	.long	stk_spark2	; 17

stk_sahikick
	.word	>53		; x offset of collision box
	.word	>0a		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>23		; y size of collision box
	.word	>0000		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_salokick
	.word	>60		; x offset of collision box
	.word	>2a		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0101		; strike routine
	.word	>1a06		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_sahipunch
	.word	>51		; x offset of collision box
	.word	>10		; y offset of collision box
	.word	>32		; x size of collision box
	.word	>24		; y size of collision box
	.word	>0202		; strike routine
	.word	>0b03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_salopunch
	.word	>54		; x offset of collision box
	.word	>20		; y offset of collision box
	.word	>38		; x size of collision box
	.word	>18		; y size of collision box
	.word	>0303		; strike routine
	.word	>0802		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_sasweepk
	.word	>63		; x offset of collision box
	.word	>70		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>23		; y size of collision box
	.word	>041c		; strike routine
	.word	>1405		; damage
	.long	0		; score value for hit
	.word	sf_duck

stk_saduckpunch
	.word	>4a		; x offset of collision box
	.word	>4d		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>12		; y size of collision box
	.word	>0505		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_saduckkickh
	.word	>4d		; x offset of collision box
	.word	>3e		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>32		; y size of collision box
	.word	>0606		; strike routine
	.word	>0c03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_saduckkickl
	.word	>4d		; x offset of collision box
	.word	>78		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>1b		; y size of collision box
	.word	>0707		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_sauppercut
	.word	>4e		; x offset of collision box
	.word	->08		; y offset of collision box
	.word	>33		; x size of collision box
	.word	>40		; y size of collision box

;	.word	>45		; x offset of collision box
;	.word	>fffc		; y offset of collision box
;	.word	>2c		; x size of collision box
;	.word	>38		; y size of collision box

	.word	>081e		; strike routine
	.WORD	>280A		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_sajumpupp
	.word	>58		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>36		; y size of collision box
	.word	>0909		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_sajumpupk
	.word	>46		; x offset of collision box
	.word	>03		; y offset of collision box
	.word	>40		; x size of collision box
	.word	>32		; y size of collision box
	.word	>0a0a		; strike routine
	.word	>2006		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_saflipk
	.word	>60		; x offset of collision box
	.word	>28		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>2e		; y size of collision box
	.word	>0b12		; strike routine
	.word	>1a07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_saflipp
	.word	>59		; x offset of collision box
	.word	>24		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>25		; y size of collision box
	.word	>0c12		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_saroundh
	.word	>60		; x offset of collision box
	.word	>10		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>2c		; y size of collision box
	.word	>0d1e		; strike routine
	.word	>2208		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_saknee
	.word	>35		; x offset of collision box
	.word	>30		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>2b		; y size of collision box
	.word	>0e0e		; strike routine
	.word	>1004		; damage
	.long	0		; score value for hit
	.word	0

stk_sa2ndknee
	.word	>48		; x offset of collision box
	.word	>10		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>2b		; y size of collision box
	.word	>1313		; strike routine
	.word	>0a03		; damage
	.long	0		; score value for hit
	.word	0

stk_saelbow
	.word	>39		; x offset of collision box
	.word	>0c		; y offset of collision box
	.word	>2c		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0f0f		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_shred
	.word	>50		; x offset of collision box
	.word	>0c		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>4a		; y size of collision box
	.word	>1414		; strike routine
	.word	>280A		; damage
	.long	0		; score value for hit
	.word	sf_squeeze


stk_sazap1
stk_sazap4
	.word	>0a		; x offset of collision box
	.word	->08		; y offset of collision box
	.word	50		; x size of collision box
	.word	20		; y size of collision box
	.word	>1010		; strike routine
	.word	>1805		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_swipe
	.word	>68		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>46		; x size of collision box
	.word	>18		; y size of collision box
	.word	>1210		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_spin
	.word	>68		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>46		; x size of collision box
	.word	>18		; y size of collision box
	.word	>1516		; strike routine
	.word	>0000		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_spark1
	.word	>74		; x offset of collision box
	.word	>1e		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>12		; y size of collision box
	.word	>1602		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_spark2
	.word	>94		; x offset of collision box
	.word	>1e		; y offset of collision box
	.word	>46		; x size of collision box
	.word	>12		; y size of collision box
	.word	>1602		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

**************************************************************************
*											     *
*  Cage strike table									     *
*											     *
**************************************************************************
jc_strikes
	.long	stk_jchikick	; 0
	.long	stk_jclokick	; 1
	.long	stk_jchipunch	; 2
	.long	stk_jclopunch	; 3
	.long	stk_jcsweepk	; 4
	.long	stk_jcduckpunch	; 5
	.long	stk_jcduckkickh	; 6
	.long	stk_jcduckkickl	; 7
	.long	stk_jcuppercut	; 8
	.long	stk_jcjumpupp	; 9
	.long	stk_jcjumpupk	; a
	.long	stk_jcflipk	; b
	.long	stk_jcflipp	; c
	.long	stk_jcroundh	; d
	.long	stk_jcknee	; e
	.long	stk_jcelbow	; f
	.long	stk_jczap1	; 10
	.long	stk_jcshadow	; 11
	.long	stk_jcshoruken	; 12
	.long	stk_jczap4	; 13
	.long	stk_jc_pp	; 14
	.long	stk_jc_split	; 15

stk_jchikick
	.word	92		; x offset of collision box
	.word	20		; y offset of collision box
	.word	60		; x size of collision box
	.word	>23		; y size of collision box
	.word	>0000		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jclokick
	.word	>67		; x offset of collision box
	.word	>2e		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>10		; y size of collision box
	.word	>0101		; strike routine
	.word	>1a06		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jchipunch
	.word	>54		; x offset of collision box
	.word	>10		; y offset of collision box
	.word	>32		; x size of collision box
	.word	>24		; y size of collision box
	.word	>0202		; strike routine
	.word	>0b03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jclopunch
	.word	>54		; x offset of collision box
	.word	>20		; y offset of collision box
	.word	>38		; x size of collision box
	.word	>18		; y size of collision box
	.word	>0303		; strike routine
	.word	>0802		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jcsweepk
	.word	>5f		; x offset of collision box
	.word	>70		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>23		; y size of collision box
	.word	>041c		; strike routine
	.word	>1405		; damage
	.long	0		; score value for hit
	.word	sf_duck

stk_jcduckpunch
	.word	>5c		; x offset of collision box
	.word	>42		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>12		; y size of collision box
	.word	>0505		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jcduckkickh
	.word	>4c		; x offset of collision box
	.word	>46		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>32		; y size of collision box
	.word	>0606		; strike routine
	.word	>0c03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jcduckkickl
	.word	>5c		; x offset of collision box
	.word	>70		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>22		; y size of collision box
	.word	>0707		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jcuppercut
	.word	>4e		; x offset of collision box
	.word	->08		; y offset of collision box
	.word	>3a		; x size of collision box
	.word	>40		; y size of collision box

;	.word	>48		; x offset of collision box
;	.word	>fffc		; y offset of collision box
;	.word	>36		; x size of collision box
;	.word	>38		; y size of collision box

	.word	>081e		; strike routine
	.WORD	>280A		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jcjumpupp
	.word	>58		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>36		; y size of collision box
	.word	>0909		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jcjumpupk
	.word	>54		; x offset of collision box
	.word	>08		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>32		; y size of collision box
	.word	>0a0a		; strike routine
	.word	>2006		; damage
	.long	0		; score value for hit

;***************** experiment
	.word	0
;	.word	sf_squeeze
;***************** experiment

stk_jcflipk
	.word	>58		; x offset of collision box
	.word	>2e		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>29		; y size of collision box
	.word	>0b12		; strike routine
	.word	>1a07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jcflipp
	.word	>59		; x offset of collision box
	.word	>14		; y offset of collision box
	.word	>3c		; x size of collision box
	.word	>35		; y size of collision box
	.word	>0c12		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jcroundh
	.word	>60		; x offset of collision box
	.word	>10		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>2c		; y size of collision box
	.word	>0d1e		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jcknee
	.word	>4b		; x offset of collision box
	.word	>00		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>53		; y size of collision box
	.word	>0e1e		; strike routine
	.word	>1406		; damage
	.long	0		; score value for hit
	.word	0

stk_jcelbow
	.word	>38		; x offset of collision box
	.word	>34		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>12		; y size of collision box
	.word	>0f0f		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jczap1
stk_jczap2
stk_jczap3
stk_jczap4
	.word	>0a		; x offset of collision box
	.word	->08		; y offset of collision box
	.word	50		; x size of collision box
	.word	20		; y size of collision box
	.word	>1010		; strike routine
	.word	>1505		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jcshadow
	.word	>67		; x offset of collision box
	.word	>2e		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>10		; y size of collision box
	.word	>111e		; strike routine
	.WORD	>1e07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jcshoruken
	.word	>20		; x offset of collision box
	.word	-8		; y offset of collision box
	.word	>30		; x size of collision box
	.word	>68		; y size of collision box
	.word	>1210		; strike routine
	.WORD	>1d06		; damage
	.long	0		; score value for hit
	.word	0		; no squeeze

stk_jc_pp
	.word	>66		; x offset of collision box
	.word	>26		; y offset of collision box
	.word	>4a		; x size of collision box
	.word	>22		; y size of collision box
	.word	>1414		; strike routine
	.word	>0001		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_jc_split
	.word	>3f		; x offset of collision box
	.word	>4a		; y offset of collision box
	.word	>2a		; x size of collision box
	.word	>0a		; y size of collision box
	.word	>1500		; strike routine
	.word	>2204		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

**************************************************************************
*											     *
*  Liu Kang strike table									     *
*											     *
**************************************************************************
lk_strikes
	.long	stk_lkhikick	; 0
	.long	stk_lklokick	; 1
	.long	stk_lkhipunch	; 2
	.long	stk_lklopunch	; 3
	.long	stk_lksweepk	; 4
	.long	stk_lkduckpunch	; 5
	.long	stk_lkduckkickh	; 6
	.long	stk_lkduckkickl	; 7
	.long	stk_lkuppercut	; 8
	.long	stk_lkjumpupp	; 9
	.long	stk_lkjumpupk	; a
	.long	stk_lkflipk	; b
	.long	stk_lkflipp	; c
	.long	stk_lkroundh	; d
	.long	stk_lkknee	; e
	.long	stk_lkelbow	; f

	.long	stk_lkzap1	; 10
	.long	stk_lkzap2	; 11
	.long	stk_lkzap3	; 12
	.long	stk_lkzap4	; 13
	.long	stk_lksuper	; 14
	.long	stk_lk_bike	; 15
	.long	stk_lk_dbuc	; 16


stk_lkhikick
	.word	>5e		; x offset of collision box
	.word	>05		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>17		; y size of collision box
	.word	>0000		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lklokick
	.word	>68		; x offset of collision box
	.word	>2a		; y offset of collision box
	.word	>43		; x size of collision box
	.word	>14		; y size of collision box
	.word	>0101		; strike routine
	.word	>1a06		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkhipunch
	.word	80		; x offset of collision box
	.word	8		; y offset of collision box
	.word	45		; x size of collision box
	.word	30		; y size of collision box
	.word	>0202		; strike routine
	.word	>0b03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lklopunch
	.word	80		; x offset of collision box
	.word	20		; y offset of collision box
	.word	45		; x size of collision box
	.word	20		; y size of collision box
	.word	>0303		; strike routine
	.word	>0802		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lksweepk
	.word	92		; x offset of collision box
	.word	105		; y offset of collision box
	.word	60		; x size of collision box
	.word	30		; y size of collision box
	.word	>041c		; strike routine
	.word	>1405		; damage
	.long	0		; score value for hit
	.word	sf_duck

stk_lkduckpunch
	.word	75		; x offset of collision box
	.word	64		; y offset of collision box
	.word	50		; x size of collision box
	.word	25		; y size of collision box
	.word	>0505		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkduckkickh
	.word	85		; x offset of collision box
	.word	70		; y offset of collision box
	.word	65		; x size of collision box
	.word	30		; y size of collision box
	.word	>0606		; strike routine
	.word	>0c03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkduckkickl
	.word	85		; x offset of collision box
	.word	120		; y offset of collision box
	.word	65		; x size of collision box
	.word	21		; y size of collision box
	.word	>0707		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_duck

stk_lkuppercut
	.word	>4b		; x offset of collision box
	.word	->0a		; y offset of collision box
	.word	>35		; x size of collision box
	.word	>40		; y size of collision box

;	.word	65		; x offset of collision box
;	.word	-5		; y offset of collision box
;	.word	45		; x size of collision box
;	.word	60		; y size of collision box

	.word	>081e		; strike routine
	.WORD	>280A		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkjumpupp
	.word	80		; x offset of collision box
	.word	5		; y offset of collision box
	.word	55		; x size of collision box
	.word	45		; y size of collision box
	.word	>0c0c		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkjumpupk
	.word	77		; x offset of collision box
	.word	12		; y offset of collision box
	.word	55		; x size of collision box
	.word	65		; y size of collision box
	.word	>0a0a		; strike routine
	.word	>2006		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkflipk
	.word	89		; x offset of collision box
	.word	3		; y offset of collision box
	.word	70		; x size of collision box
	.word	37		; y size of collision box
	.word	>0b12		; strike routine
	.word	>1a07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkflipp
	.word	80		; x offset of collision box
	.word	5		; y offset of collision box
	.word	55		; x size of collision box
	.word	45		; y size of collision box
	.word	>0c12		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkroundh
	.word	88		; x offset of collision box
	.word	5		; y offset of collision box
	.word	45		; x size of collision box
	.word	>30		; y size of collision box
	.word	>0d1e		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkknee
	.word	60		; x offset of collision box
	.word	47		; y offset of collision box
	.word	30		; x size of collision box
	.word	45		; y size of collision box
	.word	>0e0e		; strike routine
	.word	>1406		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkelbow
	.word	58		; x offset of collision box
	.word	15		; y offset of collision box
	.word	35		; x size of collision box
	.word	45		; y size of collision box
	.word	>0f0f		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkzap1
	.word	52		; x offset of collision box
	.word	20		; y offset of collision box
	.word	45		; x size of collision box
	.word	30		; y size of collision box
	.word	>1110		; strike routine
	.word	>1605		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkzap2
	.word	112		; x offset of collision box
	.word	25		; y offset of collision box
	.word	100		; x size of collision box
	.word	20		; y size of collision box
	.word	>1110		; strike routine
	.word	>1605		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkzap3
	.word	148		; x offset of collision box
	.word	25		; y offset of collision box
	.word	125		; x size of collision box
	.word	20		; y size of collision box
	.word	>1110		; strike routine
	.word	>1605		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lkzap4
	.word	197		; x offset of collision box
	.word	25		; y offset of collision box
	.word	70		; x size of collision box
	.word	20		; y size of collision box
	.word	>1110		; strike routine
	.word	>1606		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lksuper
	.word	89		; x offset of collision box
	.word	3		; y offset of collision box
	.word	70		; x size of collision box
	.word	37		; y size of collision box
	.word	>1417		; strike routine
	.word	>1a07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lk_bike
	.word	>44		; x offset of collision box
	.word	>23		; y offset of collision box
	.word	>38		; x size of collision box
	.word	>20		; y size of collision box
	.word	>1503		; strike routine
	.word	>3006		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_lk_wheel
	.word	80		; x offset of collision box
	.word	35		; y offset of collision box
	.word	70		; x size of collision box
	.word	40		; y size of collision box
	.word	>1818		; strike routine
	.word	>0101		; damage
	.long	0	  	; score value for hit
	.word	sf_squeeze

stk_lk_dbuc
	.word	65		; x offset of collision box
	.word	-5		; y offset of collision box
	.word	45		; x size of collision box
	.word	60		; y size of collision box
	.word	>1818		; strike routine
	.word	>0000		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

**************************************************************************
*											     *
*  Hathead strike table									     *
*											     *
**************************************************************************
hh_strikes
	.long	stk_hhhikick	; 0
	.long	stk_hhlokick	; 1
	.long	stk_hhhipunch	; 2
	.long	stk_hhlopunch	; 3
	.long	stk_hhsweepk	; 4
	.long	stk_hhduckpunch	; 5
	.long	stk_hhduckkickh	; 6
	.long	stk_hhduckkickl	; 7
	.long	stk_hhuppercut	; 8
	.long	stk_hhjumpupp	; 9
	.long	stk_hhjumpupk	; a
	.long	stk_hhflipk	; b
	.long	stk_hhflipp	; c
	.long	stk_hhroundh	; d
	.long	stk_hhknee	; e
	.long	stk_hhelbow	; f
	.long	stk_hhhat	; 10
	.long	stk_hhspin	; 11
	.long	stk_super_rep	; 12

stk_hhhat
	.word	>12		; x offset of collision box
	.word	->08		; y offset of collision box
	.word	>32		; x size of collision box
	.word	>15		; y size of collision box
	.word	>1010		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhelbow
	.word	53		; x offset of collision box
	.word	21		; y offset of collision box
	.word	25		; x size of collision box
	.word	45		; y size of collision box
	.word	>0f0f		; strike routine
	.word	>1806		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhknee
	.word	73		; x offset of collision box
	.word	47		; y offset of collision box
	.word	40		; x size of collision box
	.word	45		; y size of collision box
	.word	>0e0e		; strike routine
	.word	>1406		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhroundh
	.word	100		; x offset of collision box
	.word	17		; y offset of collision box
	.word	66		; x size of collision box
	.word	>2c		; y size of collision box
	.word	>0d1e		; strike routine
	.word	>2109		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhflipp
	.word	80		; x offset of collision box
	.word	5		; y offset of collision box
	.word	55		; x size of collision box
	.word	55		; y size of collision box
	.word	>0c12		; strike routine
	.word	>1005		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhflipk
	.word	82		; x offset of collision box
	.word	20		; y offset of collision box
	.word	70		; x size of collision box
	.word	40		; y size of collision box
	.word	>0b12		; strike routine
	.word	>1a07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhjumpupk
	.word	77		; x offset of collision box
	.word	12		; y offset of collision box
	.word	55		; x size of collision box
	.word	65		; y size of collision box
	.word	>0a0a		; strike routine
	.word	>2006		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhjumpupp
	.word	80		; x offset of collision box
	.word	5		; y offset of collision box
	.word	55		; x size of collision box
	.word	55		; y size of collision box
	.word	>0909		; strike routine
	.word	>1805		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhuppercut
	.word	>4d		; x offset of collision box
	.word	->07		; y offset of collision box
	.word	45		; x size of collision box
	.word	65		; y size of collision box

;	.word	70		; x offset of collision box
;	.word	5		; y offset of collision box
;	.word	45		; x size of collision box
;	.word	65		; y size of collision box

	.word	>081e		; strike routine
	.WORD	>280A		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhduckkickl
	.word	>5d		; x offset of collision box
	.word	125		; y offset of collision box
	.word	65		; x size of collision box
	.word	25		; y size of collision box
	.word	>0707		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_duck

stk_hhduckkickh
	.word	88		; x offset of collision box
	.word	80		; y offset of collision box
	.word	65		; x size of collision box
	.word	25		; y size of collision box
	.word	>0606		; strike routine
	.word	>0e03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhduckpunch
	.word	85		; x offset of collision box
	.word	64		; y offset of collision box
	.word	50		; x size of collision box
	.word	25		; y size of collision box
	.word	>0505		; strike routine
	.word	>0602		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhsweepk
	.word	85		; x offset of collision box
	.word	115		; y offset of collision box
	.word	68		; x size of collision box
	.word	30		; y size of collision box
	.word	>041c		; strike routine
	.word	>1405		; damage
	.long	0		; score value for hit
	.word	sf_duck

stk_hhlopunch
	.word	86		; x offset of collision box
	.word	25		; y offset of collision box
	.word	45		; x size of collision box
	.word	25		; y size of collision box
	.word	>0303		; strike routine
	.word	>0802		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhhipunch
	.word	76		; x offset of collision box
	.word	12		; y offset of collision box
	.word	45		; x size of collision box
	.word	45		; y size of collision box
	.word	>0202		; strike routine
	.word	>0b03		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhlokick
	.word	>67		; x offset of collision box
	.word	>32		; y offset of collision box
	.word	>45		; x size of collision box
	.word	>14		; y size of collision box
	.word	>0101		; strike routine
	.word	>1a06		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhhikick
	.word	>5e		; x offset of collision box
	.word	>11		; y offset of collision box
	.word	>44		; x size of collision box
	.word	>18		; y size of collision box
	.word	>0000		; strike routine
	.word	>2008		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

stk_hhspin
	.word	>30		; x offset of collision box
	.word	>00		; y offset of collision box
	.word	>60		; x size of collision box
	.word	>94		; y size of collision box
	.word	>171a		; strike routine
	.word	>2404		; damage
	.long	0		; score value for hit
	.word	0

stk_super_rep
	.word	82		; x offset of collision box
	.word	20		; y offset of collision box
	.word	70		; x size of collision box
	.word	40		; y size of collision box
	.word	>1813		; strike routine
	.word	>1a07		; damage
	.long	0		; score value for hit
	.word	sf_squeeze

;*************************************************************************

	.end
