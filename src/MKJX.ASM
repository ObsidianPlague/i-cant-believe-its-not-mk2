**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: Jax											*
*											     *
**************************************************************************
	.FILE	'MKJX.ASM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
*
* GET THE SYSTEM STUFF
*
	.INCLUDE	MAINEQU.ASM
	.INCLUDE	MKJX.TBL
	.INCLUDE	IMGTBL.GLO
	.text


jx_anitab1
	.long	a_jxstance	;  0 - stance
	.long	a_jxwalkf	;  1 - walk forward
	.long	a_jxskipf	;  2 - skip forward
	.long	a_jxwalkb	;  3 - walk backward
	.long	a_jxskipb	;  4 - walk backward
	.long	a_jxduck  	;  5 - duck animation
	.long	a_jxjumpup	;  6 - jump straight up
	.long	a_jxfflip	;  7 - forward flip
	.long	a_jxbflip	;  8 - backward flip
	.long	a_jxturn	;  9 - turn around
	.long	a_jxduckturn	;  a - turn around while ducking
	.long	a_jxblockhi	;  b - standing block
	.long	a_jxduckblock	;  c - ducking block
	.long	a_jxhikick	;  d - hi kick
	.long	a_jxlokick	;  e - lo kick
	.long	a_jxkdown	;  f - knocked down
	.long	a_jxhithi	; 10 - hit high
	.long	a_jxhitlo	; 11 - hit low
	.long	a_jxgetup	; 12 - normal getup
	.long	a_jxhipunch	; 13 - hi punch
	.long	a_jxlopunch	; 14 - lo punch
	.long	a_jxsweep	; 15 - sweep kick
	.long	a_jxsweepfall	; 16 - sweep fall
	.long	a_jxsweepup	; 17 - getup from sweep kick
	.long	a_jxduckpunch	; 18 - duck punch
	.long	a_jxduckkickh	; 19 - duck kick high
	.long	a_jxduckkickl	; 1a - duck kick low
	.long	a_jxduckhit	; 1b - hit while ducking
	.long	a_jxuppercut	; 1c - uppercut
	.long	a_jxjumpupkick	; 1d - jump straight up kick
	.long	a_jxflipkick	; 1e - flip kick
	.long	a_jxflippunch	; 1f - flip punch
	.long	a_jxroundh	; 20 - roundhouse kick
	.long	a_jxknee	; 21 - knee
	.long	a_jxelbow	; 22 - elbow
	.long	a_jxstumble	; 23 - stumble back
	.long	a_jxbodyslam	; 24 - body slam
	.long	a_shredded	; 25 -
	.long	a_jxzap		; 26 - throwing fireball
	.long	a_jxprojani	; 27 - fireball ani
	.long	a_jxstunned	; 28 - stunned
	.long	a_jxvictory	; 29 - victory
	.long	a_jx_fb_hh	; 2a - jax flipped by hatheat
	.long	a_jx_fb_lk	; 2b - jax flipped by liu kang
	.long	a_jx_fb_jc	; 2c - jax flipped by cage
	.long	a_jx_fb_sa	; 2d - jax flipped by sa
	.long	a_jx_fb_fn	; 2e - jax flipped by female nijxa
	.long	a_jx_fb_fn	; 2f - jax flipped by female nijxa
	.long	a_jx_fb_st	; 30 - jax flipped by shang tsung
	.long	a_jx_fb_rd	; 31 - jax flipped by raiden
	.long	a_jx_fb_nj	; 32 - jax flipped by ninja
	.long	a_jx_fb_nj	; 33 - jax flipped by ninja
	.long	a_jx_fb_nj	; 34 - jax flipped by ninja
	.long	a_jx_fb_jx	; 35 - jax flipped by jax

	.long	a_nutcrunched	; 36 - ouch
	.long	a_bike_kicked	; 37 - bicycle kicked
	.long	a_drained	; 38 - drained of my soul by shang tsung
	.long	a_torso_ripped	; 39 - torso ripped
	.long	a_banged	; 3a	-
	.long	a_impaled	; 3b - impaled
	.long	a_decapfall	; 3c - decapitated dude fall
	.long	a_head		; 3d - decapitated head
	.long	a_fb_goro	; 3e - flipped by goro's evil twin
	.long	a_back_broke	; 3f - back getting broken
	.long	0		; 40
	.long	a_swipe_torso	; 41 - scorpion swiped me torso

jx_anitab2
	.long	a_quake		; 0 - punch the ground earthquake
	.long	a_noogy		; 1 - noogy !!
	.long	a_clap		; 2 - clap death blow
	.long	a_qenergy	; 3 - quake energy
	.long	a_litewave	; 4 - jax lightwave
	.long	a_back_breaker	; 5 - breaking someones back
	.long	a_arm_rip	; 6 - ripping of other dude's arms

;***********************************************************************

dummy
a_jxstance
	.long	JXSTANCE1
	.long	JXSTANCE2
	.long	JXSTANCE3
	.long	JXSTANCE4
	.long	JXSTANCE5
	.long	JXSTANCE6
	.long	JXSTANCE7
	.long	ani_jump,a_jxstance

JXSTANCE1
	.long	JXSTANCE1A,JXSTANCE1B,0
JXSTANCE2
	.long	JXSTANCE2A,JXSTANCE2B,0
JXSTANCE3
	.long	JXSTANCE3A,JXSTANCE3B,JXSTANCE3C,0
JXSTANCE4
	.long	JXSTANCE4A,JXSTANCE4B,JXSTANCE4C,0
JXSTANCE5
	.long	JXSTANCE5A,JXSTANCE5B,JXSTANCE5C,0
JXSTANCE6
	.long	JXSTANCE6A,JXSTANCE6B,JXSTANCE6C,0
JXSTANCE7
	.long	JXSTANCE7A,JXSTANCE7B,JXSTANCE7C,0

;***********************************************************************

a_jxwalkf
	.long	JXWALK1
	.long	JXWALK2
	.long	JXWALK3
	.long	JXWALK4
	.long	JXWALK5
	.long	JXWALK6
	.long	JXWALK7
	.long	JXWALK8
	.long	JXWALK9
	.long	ani_jump,a_jxwalkf

a_jxskipf
	.long	JXWALK1
	.long	JXWALK2
	.long	JXWALK8
	.long	JXWALK9
	.long	0

a_jxwalkb
	.long	JXWALK9
	.long	JXWALK8
	.long	JXWALK7
	.long	JXWALK6
	.long	JXWALK5
	.long	JXWALK4
	.long	JXWALK3
	.long	JXWALK2
	.long	JXWALK1
	.long	ani_jump,a_jxwalkb

a_jxskipb
	.long	JXWALK9
	.long	JXWALK8
	.long	JXWALK2
	.long	JXWALK1
	.long	0


JXWALK1	.long	JXWALKLEG1A,JXWALKLEG1B,JXWALKTORSO1A,JXWALKTORSO1B,0
JXWALK2	.long	JXWALKLEG2A,JXWALKLEG2B,JXWALKTORSO2A,JXWALKTORSO2B,0
JXWALK3	.long	JXWALKLEG3A,JXWALKTORSO3A,JXWALKTORSO3B,0
JXWALK4	.long	JXWALKLEG4A,JXWALKLEG4B,JXWALKTORSO4A,JXWALKTORSO4B,0
JXWALK5	.long	JXWALKLEG5A,JXWALKLEG5B,JXWALKTORSO5A,JXWALKTORSO5B,0
JXWALK6	.long	JXWALKLEG6A,JXWALKLEG6B,JXWALKTORSO6A,JXWALKTORSO6B,0
JXWALK7	.long	JXWALKLEG7A,JXWALKLEG7B,JXWALKTORSO7A,JXWALKTORSO7B,0
JXWALK8	.long	JXWALKLEG8A,JXWALKLEG8B,JXWALKTORSO8A,JXWALKTORSO8B,0
JXWALK9	.long	JXWALKLEG9A,JXWALKLEG9B,JXWALKTORSO9A,JXWALKTORSO9B,0

;*********************************************************************

a_jxturn
	.long	JXTURN1
	.long	JXTURN2
	.long	ani_flip
	.long	ani_adjustx
	.word	-6
	.long	JXTURN1
	.long	0

JXTURN1	.long	JXTURN1A,JXTURN1B,0
JXTURN2	.long	JXTURN2A,JXTURN2B,0

;*********************************************************************

a_jxhipunch
	.long	JXHIPUNCH1
jhp2	.long	JXHIPUNCH2
jhp3	.long	JXHIPUNCH3
	.long	0
	.long	JXHIPUNCH4
jhp5	.long	JXHIPUNCH5
	.long	JXHIPUNCH6
	.long	0
	.long	JXHIPUNCH5
	.long	JXHIPUNCH4
	.long	ani_jump,jhp3
	.long	0
*
* Unhipunch #1
*
	.long	JXHIPUNCH2
	.long	JXHIPUNCH1
	.long	0
*
* Unhipunch #2
*
	.long	JXHIPUNCH7
	.long	0
*
* Hi to Med #1
*
	.long	JXHIPUNCH4
	.long	JXLOPUNCH3
	.long	ani_jump,jlp4
	.long	0
*
* Hi to Med #2
*
	.long	JXHIPUNCH5
	.long	JXLOPUNCH1
	.long	ani_jump,jlp2
	.long	0

;***********************************************************************

a_jxlopunch
	.long	JXHIPUNCH1
	.long	JXLOPUNCH1
jlp2	.long	JXLOPUNCH2
	.long	0

;**************
	.long	JXLOPUNCH1
;	.long	JXHIPUNCH4
;**************

	.long	JXLOPUNCH3
jlp4 	.long	JXLOPUNCH4
	.long	0

	.long	JXLOPUNCH3
	.long	JXLOPUNCH1
	.long	ani_jump,jlp2
	.long	0
*
* Unlopunch #1
*
	.long	JXLOPUNCH1
	.long	JXHIPUNCH1
	.long	0
*
* Unlopunch #2
*
	.long	JXLOPUNCH3
	.long	0
*
* Med to High #1
*
	.long	JXLOPUNCH1
	.long	ani_jump,jhp5		; lo1 - hi5 - hi6
	.long	0
*
* Med to High #2
*
	.long	JXLOPUNCH3
	.long	ani_jump,jhp2		; lo3 - hi2 - hi3
	.long	0

JXHIPUNCH1
	.long	JXHIPUNCH1A,JXHIPUNCH1B,0
JXHIPUNCH2
	.long	JXHIPUNCH2A,JXHIPUNCH2B,JXHIPUNCH2C,0
JXHIPUNCH3
	.long	JXHIPUNCH3A,JXHIPUNCH3B,JXHIPUNCH3C,0
JXHIPUNCH4
	.long	JXHIPUNCH4A,JXHIPUNCH4B,JXHIPUNCH4C,0
JXHIPUNCH5
	.long	JXHIPUNCH5A,JXHIPUNCH5B,JXHIPUNCH5C,0
JXHIPUNCH6
	.long	JXHIPUNCH6A,JXHIPUNCH6B,JXHIPUNCH6C,0
JXHIPUNCH7
	.long	JXHIPUNCH7A,JXHIPUNCH7B,JXHIPUNCH7C,0

JXLOPUNCH1
	.long	JXLOPUNCH1A,JXLOPUNCH1B,JXLOPUNCH1C,0
JXLOPUNCH2
	.long	JXLOPUNCH2A,JXLOPUNCH2B,JXLOPUNCH2C,0
JXLOPUNCH3
	.long	JXLOPUNCH3A,JXLOPUNCH3B,JXLOPUNCH3C,0
JXLOPUNCH4
	.long	JXLOPUNCH4A,JXLOPUNCH4B,0

;*********************************************************************

a_jxelbow
	.long	JXHEADBOP1
	.long	JXHEADBOP2
	.long	JXHEADBOP3
	.long	JXHEADBOP4
	.long	0
	.long	JXHIPUNCH2
	.long	JXHIPUNCH1
	.long	0

JXHEADBOP1
	.long	JXHEADBOP1A,JXHEADBOP1B,JXHEADBOP1C,JXHEADBOP1D,0
JXHEADBOP2
	.long	JXHEADBOP2A,JXHEADBOP2B,JXHEADBOP2C,0
JXHEADBOP3
	.long	JXHEADBOP3A,JXHEADBOP3B,0
JXHEADBOP4
	.long	JXHEADBOP4A,JXHEADBOP4B,JXHEADBOP4C,0

;*********************************************************************

	.long	JXPOWPUNCH1
	.long	JXPOWPUNCH2
	.long	JXPOWPUNCH3
	.long	JXPOWPUNCH4
	.long	JXPOWPUNCH5
	.long	JXPOWPUNCH6
	.long	JXPOWPUNCH7 
	.long	0


JXPOWPUNCH1
	.long	JXPOWPUNCH1A,JXPOWPUNCH1B,0
JXPOWPUNCH2
	.long	JXPOWPUNCH2A,JXPOWPUNCH2B,0
JXPOWPUNCH3
	.long	JXPOWPUNCH3A,JXPOWPUNCH3B,0
JXPOWPUNCH4
	.long	JXPOWPUNCH4A,JXPOWPUNCH4B,0
JXPOWPUNCH5
	.long	JXPOWPUNCH5A,JXPOWPUNCH5B,0
JXPOWPUNCH6
	.long	JXPOWPUNCH6A,JXPOWPUNCH6B,JXPOWPUNCH6C,0
JXPOWPUNCH7
	.long	JXPOWPUNCH7A,JXPOWPUNCH7B,JXPOWPUNCH7C,0

;*********************************************************************

a_jxduckblock
	.long	JXDUCKBLOCK1
	.long	JXDUCKBLOCK2
	.long	JXDUCKBLOCK3
	.long	0
	.long	JXDUCKBLOCK2
	.long	JXDUCKBLOCK1
	.long	JXDUCK3
	.long	0

JXDUCKBLOCK1
	.long	JXDUCKBLOCK1A,JXDUCKBLOCK1B,JXDUCKBLOCK1C,JXDUCKBLOCK1D,0
JXDUCKBLOCK2
	.long	JXDUCKBLOCK2A,JXDUCKBLOCK2B,JXDUCKBLOCK2C,JXDUCKBLOCK2D,0
JXDUCKBLOCK3
	.long	JXDUCKBLOCK3A,JXDUCKBLOCK3B,JXDUCKBLOCK3C,0

;*********************************************************************

a_jxduck
	.long	JXDUCK1
	.long	JXDUCK2
	.long	JXDUCK3
	.long	0

JXDUCK1	.long	JXDUCK1A,JXDUCK1B,JXDUCK1C,0
JXDUCK2	.long	JXDUCK2A,JXDUCK2B,0
JXDUCK3	.long	JXDUCK3A,JXDUCK3B,JXDUCK3C,0

;*********************************************************************

a_jxduckturn
	.long	JXDUCKTURN1
	.long	JXDUCKTURN2
	.long	ani_adjustx
	.word	16
	.long	ani_flip
	.long	JXDUCKTURN1
	.long	JXDUCK3
	.long	0

JXDUCKTURN1
	.long	JXDUCKTURN1A,JXDUCKTURN1B,JXDUCKTURN1C,0
JXDUCKTURN2
	.long	JXDUCKTURN2A,JXDUCKTURN2B,0

;*********************************************************************

a_jxduckhit
	.long	JXDUCKHIT2
	.long	JXDUCKHIT3
	.long	JXDUCKHIT2
	.long	JXDUCKHIT1
	.long	JXDUCK3
	.long	0

JXDUCKHIT1
	.long	JXDUCKHIT1A,JXDUCKHIT1B,JXDUCKHIT1C,0
JXDUCKHIT2
	.long	JXDUCKHIT2A,JXDUCKHIT2B,JXDUCKHIT2C,0
JXDUCKHIT3
	.long	JXDUCKHIT3A,JXDUCKHIT3B,JXDUCKHIT3C,0

;*********************************************************************

a_jxduckpunch
	.long	JXDUCKPUNCH1
	.long	JXDUCKPUNCH2
	.long	JXDUCKPUNCH3
	.long	0
	.long	JXDUCKPUNCH2
	.long	JXDUCKPUNCH1
	.long	JXDUCK3
	.long	0

JXDUCKPUNCH1
	.long	JXDUCKPUNCH1A,JXDUCKPUNCH1B,JXDUCKPUNCH1C,JXDUCKPUNCH1D,0
JXDUCKPUNCH2
	.long	JXDUCKPUNCH2A,JXDUCKPUNCH2B,JXDUCKPUNCH2C,JXDUCKPUNCH2D,0
JXDUCKPUNCH3
	.long	JXDUCKPUNCH3A,JXDUCKPUNCH3B,JXDUCKPUNCH3C,0

;*********************************************************************

a_jxduckkickl
	.long	JXLODUCKICK1
	.long	ani_calla,kick_sounds
	.long	JXLODUCKICK3
	.long	JXLODUCKICK4
	.long	JXLODUCKICK5
	.long	0
	.long	JXLODUCKICK4
	.long	JXLODUCKICK3
	.long	JXLODUCKICK2
	.long	JXLODUCKICK1
	.long	JXDUCK3
	.long	0

JXLODUCKICK1
	.long	JXLODUCKICK1A,JXLODUCKICK1B,JXLODUCKICK1C,0
JXLODUCKICK2
	.long	JXLODUCKICK2A,JXLODUCKICK2B,0
JXLODUCKICK3
	.long	JXLODUCKICK3A,JXLODUCKICK3B,JXLODUCKICK3C,0
JXLODUCKICK4
	.long	JXLODUCKICK4A,JXLODUCKICK4B,JXLODUCKICK4C,JXLODUCKICK4D,0
JXLODUCKICK5
	.long	JXLODUCKICK5A,JXLODUCKICK5B,JXLODUCKICK5C,JXLODUCKICK5D,0

;*********************************************************************

a_jxduckkickh
;	.long	JXLODUCKICK1
	.long	JXLODUCKICK2
	.long	ani_calla,kick_sounds
	.long	JXLODUCKICK3
	.long	JXHIDUCKICK1
	.long	JXHIDUCKICK2
	.long	0
	.long	JXHIDUCKICK1
	.long	JXLODUCKICK3
	.long	JXLODUCKICK2
	.long	JXDUCK3
	.long	0

JXHIDUCKICK1
	.long	JXHIDUCKICK1A,JXHIDUCKICK1B,JXHIDUCKICK1C,JXHIDUCKICK1D,0
JXHIDUCKICK2
	.long	JXHIDUCKICK2A,JXHIDUCKICK2B,JXHIDUCKICK2C,JXHIDUCKICK2D,0

;*********************************************************************

a_jxuppercut
	.long	JXUPPERCUT2
	.long	JXUPPERCUT3
	.long	JXUPPERCUT4
	.long	JXUPPERCUT5
	.long	ani_nosleep	; dont sleep after next frame
	.long	JXUPPERCUT6
	.long	0
	.long	JXUPPERCUT5
	.long	0

JXUPPERCUT2
	.long	JXUPPERCUT2A,JXUPPERCUT2B,JXUPPERCUT2C,0
JXUPPERCUT3
	.long	JXUPPERCUT3A,JXUPPERCUT3B,JXUPPERCUT3C,JXUPPERCUT3D
	.long	JXUPPERCUT3E,0
JXUPPERCUT4
	.long	JXUPPERCUT4A,JXUPPERCUT4B,JXUPPERCUT4C,JXUPPERCUT4D
	.long	0
JXUPPERCUT5
	.long	JXUPPERCUT5A,JXUPPERCUT5B,JXUPPERCUT5C,JXUPPERCUT5D
	.long	0
JXUPPERCUT6
	.long	JXUPPERCUT6A,JXUPPERCUT6B,JXUPPERCUT6C,JXUPPERCUT6D
	.long	0

;*********************************************************************

a_jxroundh
	.long	JXROUNDKIK1
	.long	JXROUNDKIK2
	.long	JXROUNDKIK3
	.long	JXROUNDKIK4
	.long	ani_nosleep
	.long	JXROUNDKIK5
	.long	0
	.long	JXROUNDKIK6
	.long	JXROUNDKIK7
	.long	JXROUNDKIK8
	.long	JXROUNDKIK9
	.long	0

JXROUNDKIK1
	.long	JXROUNDKIK1A,JXROUNDKIK1B,JXROUNDKIK1C,JXROUNDKIK1D
	.long	0
JXROUNDKIK2
	.long	JXROUNDKIK2A,JXROUNDKIK2B,JXROUNDKIK2C,JXROUNDKIK2D
	.long	0
JXROUNDKIK3
	.long	JXROUNDKIK3A,JXROUNDKIK3B,JXROUNDKIK3C,0
JXROUNDKIK4
	.long	JXROUNDKIK4A,JXROUNDKIK4B,JXROUNDKIK4C,0
JXROUNDKIK5
	.long	JXROUNDKIK5A,JXROUNDKIK5B,JXROUNDKIK5C,0
JXROUNDKIK6
	.long	JXROUNDKIK6A,JXROUNDKIK6B,JXROUNDKIK6C,JXROUNDKIK6D
	.long	0
JXROUNDKIK7
	.long	JXROUNDKIK7A,JXROUNDKIK7B,JXROUNDKIK7C,JXROUNDKIK7D
	.long	0
JXROUNDKIK8
	.long	JXROUNDKIK8A,JXROUNDKIK8B,JXROUNDKIK8C,0
JXROUNDKIK9
	.long	JXROUNDKIK9A,JXROUNDKIK9B,0

;*********************************************************************

a_jxsweep
	.long	JXSWEEPKICK1
	.long	JXSWEEPKICK2
	.long	JXSWEEPKICK3
	.long	ani_calla,sweep_sounds
	.long	JXSWEEPKICK4
	.long	JXSWEEPKICK5
	.long	0
	.long	JXSWEEPKICK6
	.long	JXSWEEPKICK7
	.long	JXSWEEPKICK8
	.long	0

JXSWEEPKICK1
	.long	JXSWEEPKICK1A,JXSWEEPKICK1B,JXSWEEPKICK1C,0
JXSWEEPKICK2
	.long	JXSWEEPKICK2A,JXSWEEPKICK2B,0
JXSWEEPKICK3
	.long	JXSWEEPKICK3A,JXSWEEPKICK3B,JXSWEEPKICK3C,0
JXSWEEPKICK4
	.long	JXSWEEPKICK4A,JXSWEEPKICK4B,JXSWEEPKICK4C,JXSWEEPKICK4D
	.long	0
JXSWEEPKICK5
	.long	JXSWEEPKICK5A,JXSWEEPKICK5B,JXSWEEPKICK5C,JXSWEEPKICK5D
	.long	0
JXSWEEPKICK6
	.long	JXSWEEPKICK6A,JXSWEEPKICK6B,JXSWEEPKICK6C,0
JXSWEEPKICK7
	.long	JXSWEEPKICK7A,JXSWEEPKICK7B,JXSWEEPKICK7C,JXSWEEPKICK7D
	.long	0
JXSWEEPKICK8
	.long	JXSWEEPKICK8A,JXSWEEPKICK8B,JXSWEEPKICK8C,0

;*********************************************************************

a_jxlokick
	.long	JXLOKICK1
	.long	JXLOKICK2
	.long	JXLOKICK3
	.long	JXLOKICK4
	.long	JXLOKICK5
	.long	JXLOKICK6
	.long	0
	.long	JXLOKICK5
	.long	JXLOKICK4
	.long	JXLOKICK3
	.long	JXLOKICK2
	.long	JXLOKICK1
	.long	0

a_jxhikick
	.long	JXLOKICK1
	.long	JXLOKICK2
	.long	JXLOKICK3
	.long	JXLOKICK4
	.long	JXLOKICK5
	.long	JXHIKICK1
	.long	0
	.long	JXLOKICK5
	.long	JXLOKICK4
	.long	JXLOKICK3
	.long	JXLOKICK2
	.long	JXLOKICK1
	.long	0

JXLOKICK1
	.long	JXLOKICK1A,JXLOKICK1B,JXLOKICK1C,0
JXLOKICK2
	.long	JXLOKICK2A,JXLOKICK2B,JXLOKICK2C,0
JXLOKICK3
	.long	JXLOKICK3A,JXLOKICK3B,JXLOKICK3C,0
JXLOKICK4
	.long	JXLOKICK4A,JXLOKICK4B,JXLOKICK4C,JXLOKICK4D
	.long	0
JXLOKICK5
	.long	JXLOKICK5A,JXLOKICK5B,JXLOKICK5C,JXLOKICK5D
	.long	JXLOKICK5E,0
JXLOKICK6
	.long	JXLOKICK6A,JXLOKICK6B,0
JXHIKICK1
	.long	JXHIKICK1A,JXHIKICK1B,JXHIKICK1C,JXHIKICK1D
	.long	0

;*********************************************************************

a_jxknee
	.long	JXKNEE1
	.long	JXKNEE2
	.long	JXKNEE3
	.long	0
	.long	JXKNEE2
	.long	JXKNEE1
	.long	0

JXKNEE1	.long	JXKNEE1A,JXKNEE1B,0
JXKNEE2	.long	JXKNEE2A,JXKNEE2B,0
JXKNEE3	.long	JXKNEE3A,JXKNEE3B,JXKNEE3C,0

;*********************************************************************

a_jxjumpup
	.long	JXJUMP2
	.long	JXJUMP3
	.long	0
	.long	JXJUMP2
	.long	JXJUMP1
	.long	0

JXJUMP1	.long	JXJUMP1A,JXJUMP1B,JXJUMP1C,0
JXJUMP2	.long	JXJUMP2A,JXJUMP2B,JXJUMP2C,0
JXJUMP3	.long	JXJUMP3A,JXJUMP3B,JXJUMP3C,JXJUMP3D,JXJUMP3E,0

;*********************************************************************

a_jxflippunch
	.long	JXFLIPUNCH1
	.long	JXFLIPUNCH2
	.long	JXFLIPUNCH3
	.long	0
	.long	JXFLIPUNCH2
	.long	JXFLIPUNCH1
	.long	0

JXFLIPUNCH1
	.long	JXFLIPUNCH1A,JXFLIPUNCH1B,JXFLIPUNCH1C,0
JXFLIPUNCH2
	.long	JXFLIPUNCH2A,JXFLIPUNCH2B,0
JXFLIPUNCH3
	.long	JXFLIPUNCH3A,JXFLIPUNCH3B,JXFLIPUNCH3C,0

;*********************************************************************

a_jxflipkick
	.long	JXFLIPKICK1
	.long	JXFLIPKICK2
	.long	JXFLIPKICK3
	.long	0
	.long	JXFLIPKICK2
	.long	JXFLIPKICK1
	.long	0

JXFLIPKICK1
	.long	JXFLIPKICK1A,JXFLIPKICK1B,0
JXFLIPKICK2
	.long	JXFLIPKICK2A,JXFLIPKICK2B,0
JXFLIPKICK3
	.long	JXFLIPKICK3A,JXFLIPKICK3B,JXFLIPKICK3C,0

;*********************************************************************

a_jxjumpupkick
	.long	JXJUMPKICK1
	.long	JXJUMPKICK2
	.long	0
	.long	JXJUMPKICK1
	.long	0

JXJUMPKICK1
	.long	JXJUMPKICK1A,JXJUMPKICK1B,0

JXJUMPKICK2
	.long	JXJUMPKICK2A,JXJUMPKICK2B,JXJUMPKICK2C,0

;*********************************************************************

a_jxbflip
	.long	JXJUMPFLIP1
	.long	JXJUMPFLIP8
	.long	JXJUMPFLIP7
	.long	JXJUMPFLIP6
	.long	JXJUMPFLIP5
	.long	JXJUMPFLIP4
	.long	JXJUMPFLIP3
	.long	JXJUMPFLIP2
	.long	ani_jump,a_jxbflip+32

a_jxfflip
	.long	JXJUMPFLIP1
	.long	JXJUMPFLIP2
	.long	JXJUMPFLIP3
	.long	JXJUMPFLIP4
	.long	JXJUMPFLIP5
	.long	JXJUMPFLIP6
	.long	JXJUMPFLIP7
	.long	JXJUMPFLIP8
	.long	ani_jump,a_jxfflip+32

JXJUMPFLIP1
	.long	JXJUMPFLIP1A,JXJUMPFLIP1B,0
JXJUMPFLIP2
	.long	JXJUMPFLIP2A,JXJUMPFLIP2B,0
JXJUMPFLIP3
	.long	JXJUMPFLIP3A,0
JXJUMPFLIP4
	.long	JXJUMPFLIP4A,JXJUMPFLIP4B,JXJUMPFLIP4C,0
JXJUMPFLIP5
	.long	JXJUMPFLIP5A,JXJUMPFLIP5B,0
JXJUMPFLIP6
	.long	JXJUMPFLIP6A,JXJUMPFLIP6B,0
JXJUMPFLIP7
	.long	JXJUMPFLIP7A,JXJUMPFLIP7B,0
JXJUMPFLIP8
	.long	JXJUMPFLIP8A,JXJUMPFLIP8B,JXJUMPFLIP8C,0

;*********************************************************************

a_jxblockhi
	.long	JXBLOCK1
	.long	JXBLOCK2
	.long	JXBLOCK3
	.long	0
	.long	JXBLOCK2
	.long	JXBLOCK1
	.long	0

JXBLOCK1	.long	JXBLOCK1A,JXBLOCK1B,0
JXBLOCK2	.long	JXBLOCK2A,JXBLOCK2B,0
JXBLOCK3	.long	JXBLOCK3A,JXBLOCK3B,JXBLOCK3C,0

;*********************************************************************

a_jxhithi
	.long	JXHIHIT2
	.long	JXHIHIT3
	.long	JXHIHIT2
	.long	JXHIHIT1
	.long	0

JXHIHIT1	.long	JXHIHIT1A,JXHIHIT1B,0
JXHIHIT2	.long	JXHIHIT2A,JXHIHIT2B,0
JXHIHIT3	.long	JXHIHIT3A,JXHIHIT3B,0

;*********************************************************************

a_jxhitlo
	.long	JXLOHIT2
	.long	JXLOHIT3
	.long	JXLOHIT2
	.long	JXLOHIT1
	.long	0

JXLOHIT1	.long	JXLOHIT1A,JXLOHIT1B,0
JXLOHIT2	.long	JXLOHIT2A,JXLOHIT2B,0
JXLOHIT3	.long	JXLOHIT3A,JXLOHIT3B,0

;*********************************************************************

a_jxstumble
	.long	JXSTUMBLE1
	.long	JXSTUMBLE2
	.long	JXSTUMBLE3
	.long	JXSTUMBLE4
	.long	JXSTUMBLE5
	.long	JXSTUMBLE6
	.long	0

a_bike_kicked
	.long	JXSTUMBLE1
	.long	JXSTUMBLE2
	.long	JXSTUMBLE3
	.long	JXSTUMBLE4
	.long	JXSTUMBLE5
	.long	JXSTUMBLE6
	.long	ani_jump,a_bike_kicked

a_shredded
	.long	ani_adjustxy
	.word	6,6
	.long	JXSTUMBLE1

	.long	ani_adjustxy
	.word	-6,-6
	.long	JXSTUMBLE2

	.long	ani_adjustxy
	.word	6,6
	.long	JXSTUMBLE3

	.long	ani_adjustxy
	.word	-6,-6
	.long	JXSTUMBLE2
	.long	ani_jump,a_shredded

;***************************************************************************

a_drained
	.long	ani_adjustxy
	.word	->48,->13
	.long	JXSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	->0a,>1a
	.long	JXDRAIN0
	.long	ani_adjustxy
	.word	>13,->08
	.long	JXDRAIN0
	.long	ani_adjustxy
	.word	>08,->14
	.long	JXDRAIN0
	.long	ani_adjustxy
	.word	0,0
	.long	JXDRAIN0
	.long	0

JXSTUMBLE1
	.long	JXSTUMBLE1A,JXSTUMBLE1B,JXSTUMBLE1C,JXSTUMBLE1D,0
JXSTUMBLE2
	.long	JXSTUMBLE2A,JXSTUMBLE2B,JXSTUMBLE2C,JXSTUMBLE2D,0
JXSTUMBLE3
	.long	JXSTUMBLE3A,JXSTUMBLE3B,JXSTUMBLE3C,JXSTUMBLE3D,0
JXSTUMBLE4
	.long	JXSTUMBLE4A,JXSTUMBLE4B,0
JXSTUMBLE5
	.long	JXSTUMBLE5A,JXSTUMBLE5B,JXSTUMBLE5C,0
JXSTUMBLE6
	.long	JXSTUMBLE6A,JXSTUMBLE6B,0

;*********************************************************************

a_jxstunned
	.long	JXSTUNNED1
	.long	JXSTUNNED2
	.long	JXSTUNNED3
	.long	JXSTUNNED4
	.long	JXSTUNNED5
	.long	JXSTUNNED6
	.long	JXSTUNNED7
	.long	ani_jump,a_jxstunned

JXSTUNNED1
	.long	JXSTUNNED1A,JXSTUNNED1B,JXSTUNNED1C,0
JXSTUNNED2
	.long	JXSTUNNED2A,JXSTUNNED2B,JXSTUNNED2C,0
JXSTUNNED3
	.long	JXSTUNNED3A,JXSTUNNED3B,0
JXSTUNNED4
	.long	JXSTUNNED4A,JXSTUNNED4B,JXSTUNNED4C,0
JXSTUNNED5
	.long	JXSTUNNED5A,JXSTUNNED5B,0
JXSTUNNED6
	.long	JXSTUNNED6A,JXSTUNNED6B,JXSTUNNED6C,0
JXSTUNNED7
	.long	JXSTUNNED7A,JXSTUNNED7B,0

;*********************************************************************

a_jxzap
	.long	JXTHROW1
	.long	JXTHROW2
	.long	JXTHROW3
	.long	JXTHROW4
	.long	JXTHROW5
	.long	JXTHROW6
	.long	0
	.long	JXTHROW6
	.long	JXTHROW6
	.long	JXTHROW6
	.long	JXTHROW6	; let the lightwave catchup
	.long	0

JXTHROW1
	.long	JXTHROW1A,JXTHROW1B,JXTHROW1C,JXTHROW1D,0
JXTHROW2
	.long	JXTHROW2A,JXTHROW2B,0
JXTHROW3
	.long	JXTHROW3A,JXTHROW3B,JXTHROW3C,0
JXTHROW4
	.long	JXTHROW4A,JXTHROW4B,JXTHROW4C,0
JXTHROW5
	.long	JXTHROW5A,JXTHROW5B,JXTHROW5C,0
JXTHROW6
	.long	JXTHROW6A,JXTHROW6B,0


a_litewave
	.long	JXLIGHT1
	.long	JXLIGHT2
	.long	JXLIGHT3
	.long	JXLIGHT4
	.long	JXLIGHT5
	.long	0

	.long	JXLIGHT6
	.long	JXLIGHT7
	.long	JXLIGHT8
	.long	JXLIGHT9
	.long	0

JXLIGHT1	.long	JXLIGHTWAVE1,0
JXLIGHT2	.long	JXLIGHTWAVE2,0
JXLIGHT3	.long	JXLIGHTWAVE3,0
JXLIGHT4	.long	JXLIGHTWAVE4,0
JXLIGHT5	.long	JXLIGHTWAVE5,0
JXLIGHT6	.long	JXLIGHTWAVE6,0
JXLIGHT7	.long	JXLIGHTWAVE7,0
JXLIGHT8	.long	JXLIGHTWAVE8,0
JXLIGHT9	.long	JXLIGHTWAVE9,0

a_jxprojani
	.long	JXPROJ1
	.long	JXPROJ2
	.long	JXPROJ3
	.long	JXPROJ4
	.long	JXPROJ5
	.long	JXPROJ6
	.long	JXPROJ7
	.long	0

	.long	JXPROJ8
	.long	JXPROJ9
	.long	JXPROJ10
	.long	JXPROJ11
	.long	JXPROJ12
	.long	0

JXPROJ1	.long	JXPROJECTILE1,0
JXPROJ2	.long	JXPROJECTILE2,0
JXPROJ3	.long	JXPROJECTILE3,0
JXPROJ4	.long	JXPROJECTILE4,0
JXPROJ5	.long	JXPROJECTILE5,0
JXPROJ6	.long	JXPROJECTILE6,0
JXPROJ7	.long	JXPROJECTILE7,0
JXPROJ8	.long	JXPROJECTILE8,0
JXPROJ9	.long	JXPROJECTILE9,0
JXPROJ10	.long	JXPROJECTILE10,0
JXPROJ11	.long	JXPROJECTILE11,0
JXPROJ12	.long	JXPROJECTILE12,0

;*********************************************************************

a_jxkdown
	.long	JXKNOCKDOWN1
	.long	JXKNOCKDOWN2
	.long	JXKNOCKDOWN3
	.long	JXKNOCKDOWN4
	.long	JXKNOCKDOWN5
	.long	0
*
* part 2 = landing
*
	.long	JXKNOCKDOWN6
	.long	JXKNOCKDOWN7
	.long	0
*
* part 3 = shake on ground
*
	.long	JXKNOCKDOWN6
	.long	JXKNOCKDOWN7
	.long	JXKNOCKDOWN6
	.long	JXKNOCKDOWN7
	.long	0

JXKNOCKDOWN1
	.long	JXKNOCKDOWN1A,0
JXKNOCKDOWN2
	.long	JXKNOCKDOWN2A,JXKNOCKDOWN2B,0
JXKNOCKDOWN3
	.long	JXKNOCKDOWN3A,JXKNOCKDOWN3B,JXKNOCKDOWN3C,JXKNOCKDOWN3D
	.long	0
JXKNOCKDOWN4
	.long	JXKNOCKDOWN4A,JXKNOCKDOWN4B,JXKNOCKDOWN4C,JXKNOCKDOWN4D
	.long	0
JXKNOCKDOWN5
	.long	JXKNOCKDOWN5A,JXKNOCKDOWN5B,0
JXKNOCKDOWN6
	.long	JXKNOCKDOWN6A,JXKNOCKDOWN6B,0
JXKNOCKDOWN7
	.long	JXKNOCKDOWN7A,JXKNOCKDOWN7B,0

;*********************************************************************

a_jxgetup
	.long	JXGETUP1
	.long	JXGETUP2
	.long	JXGETUP3
	.long	JXGETUP4
	.long	JXGETUP5
	.long	JXGETUP6
	.long	0

JXGETUP1
	.long	JXGETUP1A,JXGETUP1B,JXGETUP1C,JXGETUP1D
	.long	0
JXGETUP2
	.long	JXGETUP2A,JXGETUP2B,0
JXGETUP3
	.long	JXGETUP3A,JXGETUP3B,0
JXGETUP4
	.long	JXGETUP4A,JXGETUP4B,JXGETUP4C,0
JXGETUP5
	.long	JXGETUP5A,JXGETUP5B,JXGETUP5C,0
JXGETUP6
	.long	JXGETUP6A,JXGETUP6B,JXGETUP6C,0

;*********************************************************************

a_banged
	.long	JXFLIPPED1
	.long	JXFLIPPED2
	.long	JXFLIPPED3
	.long	JXFLIPPED4
	.long	0

;*********************************************************************

a_jx_fb_hh
	.long	ani_adjustxy
	.word	->3a,>00		; we need even # of words here !!
	.long	JXSTUMBLE1
	.long	0

	.long	ani_flip
	.long	ani_adjustxy
	.word	>10,>00
	.long	JXSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>70,->40

	.long	JXFLIPPED3
	.long	JXFLIPPED4
	.long	JXKNOCKDOWN4
	.long	0

a_jx_fb_lk
	.long	ani_adjustxy
	.word	->40,->05
	.long	JXFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>20,>08
	.long	JXFLIPPED2

	.long	ani_adjustxy
	.word	>20,->0a
	.long	JXFLIPPED3

	.long	ani_adjustxy
	.word	>28,>00
	.long	JXFLIPPED3

	.long	ani_adjustxy
	.word	>30,->10
	.long	JXFLIPPED4

	.long	ani_adjustxy
	.word	>30,->08
	.long	JXFLIPPED4
	.long	0
*
* land on the ground
*
	.long	JXKNOCKDOWN6
	.long	JXKNOCKDOWN7
	.long	JXKNOCKDOWN6
	.long	JXKNOCKDOWN7
     	.long	0

;***************************************************************

a_jx_fb_jx
	.long	ani_adjustxy
	.word	->46,>00
	.long	JXSTUMBLE1
	.long	JXSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>0d,->40
	.long	JXFLIPPED2	; jax 3

	.long	ani_adjustxy
	.word	>2a,->20
	.long	JXFLIPPED3	; jax 4

	.long	ani_adjustxy
	.word	>38,>08
	.long	JXFLIPPED3	; jax 5

	.long	ani_adjustxy
	.word	>20,>48
	.long	JXFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	>00,>10
	.long	JXKNOCKDOWN7	; jax 7
	.long	0
*
* slammed again !
*
	.long	ani_adjustxy
	.word	->08,->10
	.long	JXFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	->10,->46
	.long	JXFLIPPED4	; jax 6

	.long	ani_flip
	.long	ani_adjustxy
	.word	>30,->18
	.long	JXFLIPPED3	; jax 4

	.long	ani_adjustxy
	.word	>34,>18
	.long	JXFLIPPED4	; jax 3

	.long	ani_adjustxy
	.word	>05,>46
	.long	JXFLIPPED4

	.long	ani_adjustxy
	.word	>00,>10
	.long	JXKNOCKDOWN7	; jax 7
	.long	0

;***************************************************************

a_jx_fb_jc
	.long	ani_adjustxy
	.word	->30,>00
	.long	JXSTUMBLE1
	.long	JXSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>10,->28
	.long	JXFLIPPED2

	.long	ani_adjustxy
	.word	>68,>10
	.long	JXFLIPPED4

	.long	ani_adjustxy
	.word	>18,>40
	.long	JXFLIPPED4
	.long	0


a_jx_fb_sa
	.long	ani_adjustxy
	.word	->40,>00
	.long	JXSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>12,->28
	.long	JXFLIPPED1

	.long	ani_adjustxy
	.word	>23,->20
	.long	JXFLIPPED2

	.long	ani_adjustxy
	.word	>3f,->20
	.long	JXFLIPPED3
	.long	0

a_jx_fb_fn
	.long	ani_adjustxy
	.word	->40,->10
	.long	ani_flip
	.long	JXKNOCKDOWN1
	.long	0

	.long	ani_adjustxy
	.word	->20,->20
	.long	JXKNOCKDOWN1

	.long	ani_adjustxy
	.word	->40,->10
	.long	JXKNOCKDOWN3

	.long	ani_adjustxy
	.word	->20,>20
	.long	JXFLIPPED4

	.long	ani_adjustxy
	.word	->08,>30
	.long	JXFLIPPED4

	.long	ani_adjustxy
	.word	>00,>00
	.long	JXKNOCKDOWN4
	.long	0
*
* bounce on ground
*
	.long	JXKNOCKDOWN4
	.long	0

a_jx_fb_st
	.long	ani_adjustxy
	.word	->30,->08
	.long	JXSTUMBLE5
	.long	JXSTUMBLE5
	.long	0

	.long	ani_adjustxy
	.word	>08,->20
	.long	JXFLIPPED1
	.long	ani_adjustxy
	.word	>30,->08
	.long	JXFLIPPED2
	.long	ani_adjustxy
	.word	>30,>10
	.long	JXFLIPPED4
	.long	ani_adjustxy
	.word	>08,>33
	.long	JXFLIPPED4
	.long	0

	.long	ani_adjustxy
	.word	>20,>00
	.long	JXKNOCKDOWN6
	.long	0

a_jx_fb_rd
	.long	ani_adjustxy
	.word	->4a,>00
	.long	JXSTUMBLE5
	.long	0

	.long	ani_adjustxy
	.word	>0a,->25
	.long	JXFLIPPED1

	.long	ani_adjustxy
	.word	>34,->40
	.long	JXKNOCKDOWN4
	.long	JXKNOCKDOWN4

	.long	ani_adjustxy
	.word	>0a,>30
	.long	JXKNOCKDOWN4

	.long	ani_adjustxy
	.word	>18,>40
	.long	JXKNOCKDOWN4
	.long	0

	.long	ani_adjustxy
	.word	>28,>10
	.long	JXKNOCKDOWN4
	.long	0

a_jx_fb_nj
	.long	ani_adjustxy
	.word	->38,->08
	.long	JXSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>04,>08
	.long	JXFLIPPED1

	.long	ani_adjustxy
	.word	>08,>08
	.long	JXFLIPPED2

	.long	ani_adjustxy
	.word	>28,->08
	.long	JXFLIPPED3

	.long	ani_adjustxy
	.word	>40,->08
	.long	JXFLIPPED4

	.long	ani_adjustxy
	.word	>28,->08
	.long	JXFLIPPED4
	.long	0
*
* land on the ground
*
	.long	JXKNOCKDOWN4
	.long	JXKNOCKDOWN5
	.long	JXKNOCKDOWN6
	.long	JXKNOCKDOWN7
     	.long	0


JXFLIPPED1
	.long	JXFLIPPED1A,0
JXFLIPPED2
	.long	JXFLIPPED2A,JXFLIPPED2B,0
JXFLIPPED3
	.long	JXFLIPPED3A,JXFLIPPED3B,0
JXFLIPPED4
	.long	JXFLIPPED4A,JXFLIPPED4B,JXFLIPPED4C,0

a_jxsweepfall
	.long	JXSWEEPFALL1
	.long	JXSWEEPFALL2
	.long	JXSWEEPFALL3
	.long	JXSWEEPFALL4
	.long	JXSWEEPFALL5
	.long	JXSWEEPFALL6
	.long	0
	.long	JXSWEEPFALL5
	.long	JXSWEEPFALL6
	.long	0

JXSWEEPFALL1
	.long	JXSWEEPFALL1A,JXSWEEPFALL1B,JXSWEEPFALL1C,JXSWEEPFALL1D
	.long	0
JXSWEEPFALL2
	.long	JXSWEEPFALL2A,JXSWEEPFALL2B,JXSWEEPFALL2C,0
JXSWEEPFALL3
	.long	JXSWEEPFALL3A,JXSWEEPFALL3B,JXSWEEPFALL3C,JXSWEEPFALL3D
	.long	0
JXSWEEPFALL4
	.long	JXSWEEPFALL4A,JXSWEEPFALL4B,0
JXSWEEPFALL5
	.long	JXSWEEPFALL5A,JXSWEEPFALL5B,JXSWEEPFALL5C,0
JXSWEEPFALL6
	.long	JXSWEEPFALL6A,JXSWEEPFALL6B,JXSWEEPFALL6C,0

;*********************************************************************

a_jxsweepup
	.long	JXSWEEPUP1
	.long	JXSWEEPUP2
	.long	JXSWEEPUP3
	.long	JXSWEEPUP4
	.long	JXSWEEPUP5
	.long	0

JXSWEEPUP1
	.long	JXSWEEPUP1A,JXSWEEPUP1B,0
JXSWEEPUP2
	.long	JXSWEEPUP2A,JXSWEEPUP2B,0
JXSWEEPUP3
	.long	JXSWEEPUP3A,JXSWEEPUP3B,0
JXSWEEPUP4
	.long	JXSWEEPUP4A,JXSWEEPUP4B,JXSWEEPUP4C,JXSWEEPUP4D
	.long	0
JXSWEEPUP5
	.long	JXSWEEPUP5A,JXSWEEPUP5B,JXSWEEPUP5C,0


;*********************************************************************

a_noogy
	.long	JXNOOGY1
	.long	JXNOOGY2
	.long	JXNOOGY3
	.long	0

j_nogg	.long	JXNOOGY4
	.long	JXNOOGY5
	.long	JXNOOGY6
	.long	0

	.long	JXNOOGY6
	.long	JXNOOGY6
	.long	JXNOOGY5
	.long	JXNOOGY4
	.long	0

	.long	ani_jump,j_nogg


JXNOOGY1
	.long	JXNOOGY1A,JXNOOGY1B,JXNOOGY1C,0
JXNOOGY2
	.long	JXNOOGY2A,JXNOOGY2B,JXNOOGY2C,0
JXNOOGY3
	.long	JXNOOGY3A,JXNOOGY3B,JXNOOGY3C,0
JXNOOGY4
	.long	JXNOOGY4A,JXNOOGY4B,JXNOOGY4C,JXNOOGY4D,0
JXNOOGY5
	.long	JXNOOGY5A,JXNOOGY5B,JXNOOGY5C,0
JXNOOGY6
	.long	JXNOOGY6A,JXNOOGY6B,JXNOOGY6C,0

;*********************************************************************

a_quake
	.long	JXQUAKE1
	.long	JXQUAKE2
	.long	JXQUAKE3
	.long	JXQUAKE4
	.long	0

	.long	JXQUAKE4
	.long	JXQUAKE4
	.long	JXQUAKE4
	.long	0

JXQUAKE1
	.long	JXQUAKE1A,JXQUAKE1B,JXQUAKE1C,JXQUAKE1D,0
JXQUAKE2
	.long	JXQUAKE2A,JXQUAKE2B,JXQUAKE2C,JXQUAKE2D,0
JXQUAKE3
	.long	JXQUAKE3A,JXQUAKE3B,JXQUAKE3C,0
JXQUAKE4
	.long	JXQUAKE4A,JXQUAKE4B,JXQUAKE4C,0

;*********************************************************************

a_nutcrunched
	.long	JXNUTCRUNCH1
	.long	JXNUTCRUNCH2
	.long	0
	.long	JXNUTCRUNCH1
	.long	0

JXNUTCRUNCH1
	.long	JXNUTCRUNCH1A,JXNUTCRUNCH1B,0
JXNUTCRUNCH2
	.long	JXNUTCRUNCH2A,JXNUTCRUNCH2B,0

;*********************************************************************

a_jxvictory
	.long	JXVICTORY1
	.long	JXVICTORY2
	.long	JXVICTORY3
	.long	JXVICTORY4
	.long	JXVICTORY5
	.long	JXVICTORY6
	.long	JXVICTORY7
	.long	JXVICTORY8
	.long	0

JXVICTORY1
	.long	JXVICTORY1A,JXVICTORY1B,0
JXVICTORY2
	.long	JXVICTORY2A,JXVICTORY2B,0
JXVICTORY3
	.long	JXVICTORY3A,JXVICTORY3B,0
JXVICTORY4
	.long	JXVICTORY4A,JXVICTORY4B,JXVICTORY4C,JXVICTORY4D,0
JXVICTORY5
	.long	JXVICTORY5A,JXVICTORY5B,JXVICTORY5C,0
JXVICTORY6
	.long	JXVICTORY6A,JXVICTORY6B,JXVICTORY6C,JXVICTORY6D,0
JXVICTORY7
	.long	JXVICTORY7A,JXVICTORY7B,JXVICTORY7C,JXVICTORY7D,0
JXVICTORY8
	.long	JXVICTORY8A,JXVICTORY8B,JXVICTORY8C,JXVICTORY8D,0

;*********************************************************************

a_jxbodyslam
	.long	JXBODYSLAM1
	.long	JXBODYSLAM2
	.long	0

	.long	JXBODYSLAM3
	.long	JXBODYSLAM4
	.long	JXBODYSLAM5
j_slam	.long	JXBODYSLAM6
	.long	JXBODYSLAM7
	.long	0

	.long	JXBODYSLAM6
	.long	JXBODYSLAM5
	.long	JXBODYSLAM4
	.long	JXBODYSLAM3
	.long	ani_flip
	.long	ani_jump,j_slam
	.long	0

	.long	JXBODYSLAM8
	.long	0


JXBODYSLAM1
	.long	JXBODYSLAM1A,JXBODYSLAM1B,0
JXBODYSLAM2
	.long	JXBODYSLAM2A,JXBODYSLAM2B,JXBODYSLAM2C,0
JXBODYSLAM3
	.long	JXBODYSLAM3A,JXBODYSLAM3B,JXBODYSLAM3C,0
JXBODYSLAM4
	.long	JXBODYSLAM4A,JXBODYSLAM4B,0
JXBODYSLAM5
	.long	JXBODYSLAM5A,JXBODYSLAM5B,JXBODYSLAM5C,0
JXBODYSLAM6
	.long	JXBODYSLAM6A,JXBODYSLAM6B,JXBODYSLAM6C,0
JXBODYSLAM7
	.long	JXBODYSLAM7A,JXBODYSLAM7B,JXBODYSLAM7C,JXBODYSLAM7D,0
JXBODYSLAM8
	.long	JXBODYSLAM8A,JXBODYSLAM8B,0

;*********************************************************************

a_clap
	.long	JXCLAPPER1
	.long	JXCLAPPER2
	.long	JXCLAPPER3
	.long	JXCLAPPER4
	.long	0
	.long	JXCLAPPER3
	.long	0

JXCLAPPER1
	.long	JXCLAPPER1A,JXCLAPPER1B,JXCLAPPER1C,0
JXCLAPPER2
	.long	JXCLAPPER2A,JXCLAPPER2B,0
JXCLAPPER3
	.long	JXCLAPPER3A,JXCLAPPER3B,0
JXCLAPPER4
	.long	JXCLAPPER4A,JXCLAPPER4B,JXCLAPPER4C,0

;*********************************************************************

a_back_broke
	.long	JXBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>0a
	.long	JXBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>30
	.long	JXBACKBREAK1
	.long	JXBACKBREAK2
	.long	JXBACKBREAK3
	.long	0
	.long	JXBACKBREAK2
	.long	JXBACKBREAK1
	.long	0

JXBACKBREAK1
	.long	JXBACKBREAK1A,JXBACKBREAK1B,JXBACKBREAK1C,0
JXBACKBREAK2
	.long	JXBACKBREAK2A,JXBACKBREAK2B,0
JXBACKBREAK3
	.long	JXBACKBREAK3A,JXBACKBREAK3B,0


a_back_breaker
	.long	JXAIRSNAP
	.long	JXBACKSNAP3
	.long	JXBACKSNAP4
	.long	JXBACKSNAP5

	.long	JXBACKSNAP5
	.long	JXBACKSNAP5		; him bending
	.long	0

	.long	JXBACKSNAP5
	.long	JXBACKSNAP5
	.long	0

JXAIRSNAP	
	.long	JXAIRSNAP1A,JXAIRSNAP1B,JXAIRSNAP1C,0
JXBACKSNAP3
	.long	JXBACKSNAP3A,JXBACKSNAP3B,JXBACKSNAP3C,JXBACKSNAP3D,0
JXBACKSNAP4
	.long	JXBACKSNAP4A,JXBACKSNAP4B,JXBACKSNAP4C,0
JXBACKSNAP5
	.long	JXBACKSNAP5A,JXBACKSNAP5B,JXBACKSNAP5C,JXBACKSNAP5D,0

;************************************************************************

a_head	.long	JXDECAPHEAD1
	.long	JXDECAPHEAD2
	.long	JXDECAPHEAD3
	.long	JXDECAPHEAD4
	.long	JXDECAPHEAD5
	.long	JXDECAPHEAD6
	.long	JXDECAPHEAD7
	.long	JXDECAPHEAD8
	.long	ani_jump,a_head


a_decapfall
	.long	JXDECAP1
	.long	JXDECAP2
	.long	JXDECAP3	; on knees
	.long	0
*
* wobble on yer knees
*
	.long	JXDECAP4
	.long	JXDECAP3
	.long	JXDECAP4
	.long	JXDECAP3
	.long	JXDECAP4
	.long	JXDECAP3
	.long	0
*
* fall to ground
*
	.long	JXDECAP4
	.long	JXDECAP5
	.long	JXDECAP6
	.long	JXDECAP7
	.long	0


JXDECAP1
	.long	JXDECAPLEG1A
	.long	JXDECAPTORSO1A,0
JXDECAP2
	.long	JXDECAPLEG2A
	.long	JXDECAPTORSO2A,0
JXDECAP3
	.long	JXDECAPLEG3A
	.long	JXDECAPTORSO3A,0
JXDECAP4
	.long	JXDECAPLEG4A
	.long	JXDECAPTORSO4A,0
JXDECAP5
	.long	JXDECAPLEG5A
	.long	JXDECAPTORSO5A,0
JXDECAP6
	.long	JXDECAPLEG6A,JXDECAPLEG6B
	.long	JXDECAPTORSO6A,0
JXDECAP7
	.long	JXDECAPLEG7A,JXDECAPLEG7B
	.long	JXDECAPTORSO7A,0


JXDECAPLEG1
	.long	JXDECAPLEG1A,0
;JXDECAPLEG2
;	.long	JXDECAPLEG2A,0
;JXDECAPLEG3
;	.long	JXDECAPLEG3A,0
;JXDECAPLEG4
;	.long	JXDECAPLEG4A,0
;JXDECAPLEG5
;	.long	JXDECAPLEG5A,0
;JXDECAPLEG6
;	.long	JXDECAPLEG6A,JXDECAPLEG6B,0
;JXDECAPLEG7
;	.long	JXDECAPLEG7A,JXDECAPLEG7B,0

;JXDECAPTORSO1
;	.long	JXDECAPTORSO1A,0
;JXDECAPTORSO2
;	.long	JXDECAPTORSO2A,0
;JXDECAPTORSO3
;	.long	JXDECAPTORSO3A,0
;JXDECAPTORSO4
;	.long	JXDECAPTORSO4A,0
;JXDECAPTORSO5
;	.long	JXDECAPTORSO5A,0
;JXDECAPTORSO6
;	.long	JXDECAPTORSO6A,0
;JXDECAPTORSO7
;	.long	JXDECAPTORSO7A,0


;************************************************************************

a_torso_ripped
	.long	ani_adjustxy
	.word	->43,>00
	.long	JXSTUMBLE3
	.long	0

	.long	ani_calla,change_to_bloody_pal	; switch to bloody pal
	.long	JXRIPTORSO1

	.long	ani_adjustxy
	.word	>18,->24
	.long	JXRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>00,>08
	.long	JXRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>30,>20
	.long	JXRIPTORSO3

	.long	ani_adjustxy
	.word	>30,>40
	.long	JXRIPTORSO4
	.long	0

	.long	JXRIPTORSO5
	.long	JXRIPTORSO6
	.long	0
*
* standing legz
*
	.long	JXDECAPLEG1		; legz
	.long	0


JXRIPTORSO1
	.long	JXRIPTORSO1A,0
JXRIPTORSO2
	.long	JXRIPTORSO2A,0
JXRIPTORSO3
	.long	JXRIPTORSO3A,JXRIPTORSO3B,0
JXRIPTORSO4
	.long	JXRIPTORSO4A,JXRIPTORSO4B,JXRIPTORSO4C,JXRIPTORSO4D
	.long	0
JXRIPTORSO5
	.long	JXRIPTORSO5A,JXRIPTORSO5B,0
JXRIPTORSO6
	.long	JXRIPTORSO6A,JXRIPTORSO6B,0


a_swipe_torso
	.long	JXRIPTORSO1
	.long	JXRIPTORSO2
	.long	JXRIPTORSO3
	.long	JXRIPTORSO4
	.long	JXRIPTORSO5
	.long	JXRIPTORSO6
	.long	0

a_impaled
	.long	ani_adjustxy
	.word	->60,>00
	.long	JXIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	JXIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	JXIMPALED1

	.long	ani_adjustxy
	.word	>10,->08
	.long	JXIMPALED1

	.long	0
*
* suffering (that's Christmas)
*
	.long	JXIMPALED1
	.long	JXIMPALED2
	.long	JXIMPALED3

	.long	JXIMPALED2
	.long	JXIMPALED1
	.long	JXIMPALED2
	.long	JXIMPALED3
	.long	0


JXIMPALED1
	.long	JXIMPALED1A,JXIMPALED1B,0
JXIMPALED2
	.long	JXIMPALED2A,JXIMPALED2B,0
JXIMPALED3
	.long	JXIMPALED3A,JXIMPALED3B,0


;*******************************************************************

a_fb_goro
	.long	ani_adjustxy
	.word	->60,->20
	.long	JXSTUMBLE1

	.long	ani_adjustxy
	.word	>10,->70
	.long	JXKNOCKDOWN6

	.long	ani_adjustxy
	.word	>20,>00
	.long	JXKNOCKDOWN6

	.long	ani_adjustxy
	.word	>3a,>20
	.long	JXKNOCKDOWN5

	.long	ani_adjustxy
	.word	>28,>18
	.long	JXKNOCKDOWN5

	.long	ani_adjustxy
	.word	>20,>50
	.long	JXKNOCKDOWN6

	.long	0

;*******************************************************************

a_qenergy
	.long	JAXEN1
	.long	JAXEN2
	.long	JAXEN3
	.long	JAXEN4
	.long	0

	.long	JAXEN5
	.long	JAXEN6
	.long	JAXEN7
	.long	0

JAXEN1	.long	JXQENERGY1,0
JAXEN2	.long	JXQENERGY2,0
JAXEN3	.long	JXQENERGY3,0
JAXEN4	.long	JXQENERGY4,0
JAXEN5	.long	JXQENERGY5,0
JAXEN6	.long	JXQENERGY6,0
JAXEN7	.long	JXQENERGY7,0

;**************************************************************************

a_arm_rip
	.long	JXARMRIP1
	.long	JXARMRIP2
	.long	0

	.long	JXARMRIP3
	.long	JXARMRIP4
	.long	JXARMRIP5
	.long	JXARMRIP6
	.long	JXARMRIP7
	.long	JXARMRIP8
	.long	JXARMRIP9
	.long	JXARMRIP10
	.long	JXARMRIP11
	.long	JXARMRIP12
	.long	ani_jump,a_jxvictory

JXARMRIP1
	.long	JXARMRIP1A,JXARMRIP1B,0
JXARMRIP2
	.long	JXARMRIP2A,JXARMRIP2B,0
JXARMRIP3
	.long	JXARMRIP3A,JXARMRIP3B,0
JXARMRIP4
	.long	JXARMRIP4A,JXARMRIP4B,0
JXARMRIP5
	.long	JXARMRIP5A,JXARMRIP5B,0
JXARMRIP6
	.long	JXARMRIP6A,JXARMRIP6B,0
JXARMRIP7
	.long	JXARMRIP7A,JXARMRIP7B,0
JXARMRIP8
	.long	JXARMRIP8A,JXARMRIP8B,0
JXARMRIP9
	.long	JXARMRIP9A,JXARMRIP9B,JXARMRIP9C,0
JXARMRIP10
	.long	JXARMRIP10A,JXARMRIP10B,JXARMRIP10C,0
JXARMRIP11
	.long	JXARMRIP11A,JXARMRIP11B,JXARMRIP11C,JXARMRIP11D,0
JXARMRIP12
	.long	JXARMRIP12A,JXARMRIP12B,JXARMRIP12C,JXARMRIP12D,0

;*******************************************************************

	.end

