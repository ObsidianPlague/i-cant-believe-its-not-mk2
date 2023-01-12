**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: Johnny Cage										*
*											     *
**************************************************************************
	.FILE	'MK3.ASM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
*
* GET THE SYSTEM STUFF
*
	.INCLUDE	MAINEQU.ASM
	.INCLUDE	MKJC.TBL
	.INCLUDE	IMGTBL.GLO

	.text

jc_anitab1
	.long	a_jcstance	;  0 - stance
	.long	a_jcwalkf	;  1 - walk forward
	.long	a_jcskipf	;  2 - skip forward
	.long	a_jcwalkb	;  3 - walk backward
	.long	a_jcskipb	;  4 - walk backward
	.long	a_jcduck  	;  5 - duck animation
	.long	a_jcjumpup	;  6 - jump straight up
	.long	a_jcfflip	;  7 - forward flip
	.long	a_jcbflip	;  8 - backward flip
	.long	a_jcturn	;  9 - turn around
	.long	a_jcduckturn	;  a - turn around while ducking
	.long	a_jcblockhi	;  b - standing block
	.long	a_jcduckblock	;  c - ducking block
	.long	a_jchikick	;  d - hi kick
	.long	a_jclokick	;  e - lo kick
	.long	a_jckdown	;  f - knocked down
	.long	a_jchithi	; 10 - hit high
	.long	a_jchitlo	; 11 - hit low
	.long	a_jcgetup	; 12 - normal getup
	.long	a_jchipunch	; 13 - hi punch
	.long	a_jclopunch	; 14 - lo punch
	.long	a_jcsweep	; 15 - sweep kick
	.long	a_jcsweepfall	; 16 - sweep fall
	.long	a_jcsweepup	; 17 - getup from sweep kick
	.long	a_jcduckpunch	; 18 - duck punch
	.long	a_jcduckkickh	; 19 - duck kick high
	.long	a_jcduckkickl	; 1a - duck kick low
	.long	a_jcduckhit	; 1b - hit while ducking
	.long	a_jcuppercut	; 1c - uppercut
	.long	a_jcjumpupkick	; 1d - jump straight up kick
	.long	a_jcflipkick	; 1e - flip kick
	.long	a_jcflippunch	; 1f - flip punch
	.long	a_jcroundh	; 20 - roundhouse kick
	.long	a_jcknee	; 21 - knee
	.long	a_jcelbow	; 22 - elbow
	.long	a_jcstumble	; 23 - stumble back
	.long	a_jcbodyslam	; 24 - body slam
	.long	a_shredded	; 25 -

	.long	a_jczap		; 26 - cage throwing fireball
	.long	a_jcprojani	; 27 - fireball ani

	.long	a_jcstunned	; 28 - stunned
	.long	a_jcvictory	; 29 - victory

	.long	a_jc_fb_hh	; 2a - cage flipped by hatheat
	.long	a_jc_fb_lk	; 2b - cage flipped by liu kang
	.long	a_jc_fb_jc	; 2c - cage flipped by cage
	.long	a_jc_fb_sa	; 2d - cage flipped by sword arms
	.long	a_jc_fb_fn	; 2e - cage flipped by female ninja
	.long	a_jc_fb_fn	; 2f - cage flipped by female ninja
	.long	a_jc_fb_st   	; 30 - cage flipped by shang tsung
	.long	a_jc_fb_rd	; 31 - cage flipped by raiden
	.long	a_jc_fb_nj	; 32 - cage flipped by ninja
	.long	a_jc_fb_nj	; 33 - cage flipped by ninja
	.long	a_jc_fb_nj	; 34 - cage flipped by ninja
	.long	a_jc_fb_jx	; 35 - cage flipped by jax

	.long	a_nutcrunched	; 36 - ouch
	.long	a_bike_kicked	; 37 - bicycle kicked
	.long	a_drained	; 38 - drained of my soul by shang tsung
	.long	a_torso_ripped	; 39 - torso ripped
	.long	a_banged	; 3a - 
	.long	a_impaled	; 3b - impaled
	.long	a_decapfall	; 3c - decapitated dude fall
	.long	a_head		; 3d - decapitated head

	.long	a_fb_goro	; 3e - flipped by goro's evil twin
	.long	a_back_broke	; 3f - back getting broken
	.long	0
	.long	a_swipe_torso	; 41 - scorpion swiped me torso



jc_anitab2
	.long	a_splits	; 0 -
	.long	a_shoruken	; 1 -
	.long	a_jczaphi	; 2 -
	.long	a_jcgreenball	; 3 - green ball
	.long	a_jcshadow	; 4 - shadow kick
	.long	a_jcrip		; 5 - torso rip
	.long	a_jc_pp		; 6 - power punch


a_jcprojani
dummy
a_jcstance
	.long	JCSTANCE1
	.long	JCSTANCE2
	.long	JCSTANCE3
	.long	JCSTANCE4
	.long	JCSTANCE5
	.long	JCSTANCE6
	.long	JCSTANCE7
	.long	ani_jump,a_jcstance

JCSTANCE1
	.long	JCSTANCE1A,JCSTANCE1B,JCSTANCE1C,0
JCSTANCE2
	.long	JCSTANCE2A,JCSTANCE2B,JCSTANCE2C,0
JCSTANCE3
	.long	JCSTANCE3A,JCSTANCE3B,JCSTANCE3C,0
JCSTANCE4
	.long	JCSTANCE4A,JCSTANCE4B,JCSTANCE4C,0
JCSTANCE5
	.long	JCSTANCE5A,JCSTANCE5B,JCSTANCE5C,0
JCSTANCE6
	.long	JCSTANCE6A,JCSTANCE6B,JCSTANCE6C,0
JCSTANCE7
	.long	JCSTANCE7A,JCSTANCE7B,JCSTANCE7C,0

**************************************************************************

a_jcturn
	.long	JCTURN1
	.long	JCTURN2
	.long	JCTURN3
	.long	ani_flip
	.long	JCTURN1
	.long	0

JCTURN1	.long	JCTURN1A,JCTURN1B,JCTURN1C,0
JCTURN2	.long	JCTURN2A,JCTURN2B,JCTURN2C,0
JCTURN3	.long	JCTURN3A,JCTURN3B,JCTURN3C,0

;*************************************************************************

a_jcwalkf
	.long	JCWALK1
	.long	JCWALK2
	.long	JCWALK3
	.long	JCWALK4
	.long	JCWALK5
	.long	JCWALK6
	.long	JCWALK7
	.long	JCWALK8
	.long	JCWALK9
	.long	ani_jump,a_jcwalkf

a_jcwalkb
	.long	JCWALK9
	.long	JCWALK8
	.long	JCWALK7
	.long	JCWALK6
	.long	JCWALK5
	.long	JCWALK4
	.long	JCWALK3
	.long	JCWALK2
	.long	JCWALK1
	.long	ani_jump,a_jcwalkb

a_jcskipf
	.long	JCWALK1
	.long	JCWALK2
	.long	JCWALK8
	.long	JCWALK9
	.long	0

a_jcskipb
	.long	JCWALK9
	.long	JCWALK8
	.long	JCWALK2
	.long	JCWALK1
	.long	0


JCWALK1	.long	JCWALKLEG1A,JCWALKLEG1B
	.long	JCWALKTORSO1A,0

JCWALK2	.long	JCWALKLEG2A,JCWALKLEG2B
	.long	JCWALKTORSO2A,0

JCWALK3	.long	JCWALKLEG3A
	.long	JCWALKTORSO3A,0

JCWALK4	.long	JCWALKLEG4A,JCWALKLEG4B
	.long	JCWALKTORSO4A,0

JCWALK5	.long	JCWALKLEG5A,JCWALKLEG5B
	.long	JCWALKTORSO5A,0

JCWALK6	.long	JCWALKLEG6A,JCWALKLEG6B
	.long	JCWALKTORSO6A,0

JCWALK7	.long	JCWALKLEG7A
	.long	JCWALKTORSO7A,0

JCWALK8	.long	JCWALKLEG8A,JCWALKLEG8B
	.long	JCWALKTORSO8A,0

JCWALK9	.long	JCWALKLEG9A,JCWALKLEG9B
	.long	JCWALKTORSO9A,0

;*************************************************************************


a_jcduck
	.long	JCDUCK1
	.long	JCDUCK2
	.long	JCDUCK3
	.long	0


JCDUCK1	.long	JCDUCK1A,JCDUCK1B,0
JCDUCK2	.long	JCDUCK2A,JCDUCK2B,0
JCDUCK3	.long	JCDUCK3A,JCDUCK3B,0

;*************************************************************************

a_jcjumpup
	.long	JCJUMP2
	.long	JCJUMP3
	.long	0
	.long	JCJUMP2
	.long	JCJUMP1
	.long	0

JCJUMP1	.long	JCJUMP1A,JCJUMP1B,0
JCJUMP2	.long	JCJUMP2A,JCJUMP2B,JCJUMP2C,JCJUMP2D,JCJUMP2E,0
JCJUMP3	.long	JCJUMP3A,JCJUMP3B,0

;*************************************************************************

a_jcfflip
	.long	JCJUMPFLIP1
	.long	JCJUMPFLIP2
	.long	JCJUMPFLIP3
	.long	JCJUMPFLIP4
	.long	JCJUMPFLIP5
	.long	JCJUMPFLIP6
	.long	JCJUMPFLIP7
	.long	JCJUMPFLIP8
	.long	ani_jump,a_jcfflip+32

a_jcbflip
	.long	JCJUMPFLIP1
	.long	JCJUMPFLIP8
	.long	JCJUMPFLIP7
	.long	JCJUMPFLIP6
	.long	JCJUMPFLIP5
	.long	JCJUMPFLIP4
	.long	JCJUMPFLIP3
	.long	JCJUMPFLIP2
	.long	ani_jump,a_jcbflip+32

JCJUMPFLIP1
	.long	JCJUMPFLIP1A,JCJUMPFLIP1B,JCJUMPFLIP1C,0
JCJUMPFLIP2
	.long	JCJUMPFLIP2A,JCJUMPFLIP2B,0
JCJUMPFLIP3
	.long	JCJUMPFLIP3A,0
JCJUMPFLIP4
	.long	JCJUMPFLIP4A,JCJUMPFLIP4B,0
JCJUMPFLIP5
	.long	JCJUMPFLIP5A,JCJUMPFLIP5B,0
JCJUMPFLIP6
	.long	JCJUMPFLIP6A,JCJUMPFLIP6B,0
JCJUMPFLIP7
	.long	JCJUMPFLIP7A,0
JCJUMPFLIP8
	.long	JCJUMPFLIP8A,JCJUMPFLIP8B,0

;*************************************************************************

a_jcduckturn
	.long	JCDUCKTURN1
	.long	JCDUCKTURN2
	.long	ani_flip
	.long	ani_adjustx
	.word	-12
	.long	JCDUCKTURN1
	.long	JCDUCK3
	.long	0

JCDUCKTURN1
	.long	JCDUCKTURN1A,JCDUCKTURN1B,0
JCDUCKTURN2
	.long	JCDUCKTURN2A,JCDUCKTURN2B,0

;*************************************************************************

a_jcblockhi
	.long	JCBLOCK1
	.long	JCBLOCK2
	.long	JCBLOCK3
	.long	0
	.long	JCBLOCK2
	.long	JCBLOCK1
	.long	0

JCBLOCK1	.long	JCBLOCK1A,JCBLOCK1B,JCBLOCK1C,0
JCBLOCK2	.long	JCBLOCK2A,JCBLOCK2B,0
JCBLOCK3	.long	JCBLOCK3A,JCBLOCK3B,0

;*************************************************************************

a_jcduckblock
	.long	JCDUCKBLOCK1
	.long	JCDUCKBLOCK2
	.long	JCDUCKBLOCK3
	.long	0
	.long	JCDUCKBLOCK2
	.long	JCDUCKBLOCK1
	.long	JCDUCK3
	.long	0

JCDUCKBLOCK1
	.long	JCDUCKBLOCK1A,JCDUCKBLOCK1B,0
JCDUCKBLOCK2
	.long	JCDUCKBLOCK2A,JCDUCKBLOCK2B,0
JCDUCKBLOCK3
	.long	JCDUCKBLOCK3A,JCDUCKBLOCK3B,0

;*************************************************************************

a_jcshadow
	.long	JCHIKICK2
	.long	JCHIKICK5
	.long	JCHIKICK4
	.long	JCLOKICK1
	.long	0

	.long	JCHIKICK5
	.long	JCHIKICK4
	.long	JCHIKICK3
	.long	JCHIKICK2
	.long	JCHIKICK1
	.long	0

a_jclokick
	.long	JCHIKICK1
	.long	JCHIKICK2
	.long	JCHIKICK3
	.long	JCHIKICK4
	.long	JCHIKICK5
	.long	JCLOKICK1
	.long	0
	.long	JCHIKICK5
	.long	JCHIKICK4
	.long	JCHIKICK3
	.long	JCHIKICK2
	.long	JCHIKICK1
	.long	0

a_jchikick
	.long	JCHIKICK1
	.long	JCHIKICK2
	.long	JCHIKICK3
	.long	JCHIKICK4
	.long	JCHIKICK5
	.long	JCHIKICK6
	.long	0
	.long	JCHIKICK5
	.long	JCHIKICK4
	.long	JCHIKICK3
	.long	JCHIKICK2
	.long	JCHIKICK1
	.long	0

JCHIKICK1
	.long	JCHIKICK1A,JCHIKICK1B,JCHIKICK1C,0
JCHIKICK2
	.long	JCHIKICK2A,JCHIKICK2B,JCHIKICK2C,0
JCHIKICK3
	.long	JCHIKICK3A,0
JCHIKICK4
	.long	JCHIKICK4A,JCHIKICK4B,0
JCHIKICK5
	.long	JCHIKICK5A,JCHIKICK5B,0
JCHIKICK6
	.long	JCHIKICK6A,JCHIKICK6B,0
JCLOKICK1
	.long	JCLOKICK1A,JCLOKICK1B,JCLOKICK1C,0

;*************************************************************************

a_jckdown
	.long	JCKNOCKDOWN1
	.long	JCKNOCKDOWN2
	.long	JCKNOCKDOWN3
	.long	JCKNOCKDOWN4
	.long	0
*
* part 2 = landing on back
*
	.long	JCKNOCKDOWN5
	.long	JCKNOCKDOWN6
	.long	JCKNOCKDOWN7
	.long	0
*
* part 3 = shake on the ground
*
	.long	JCKNOCKDOWN6
	.long	JCKNOCKDOWN7
	.long	JCKNOCKDOWN6
	.long	JCKNOCKDOWN7
	.long	0

JCKNOCKDOWN1
	.long	JCKNOCKDOWN1A,0
JCKNOCKDOWN2
	.long	JCKNOCKDOWN2A,JCKNOCKDOWN2B,JCKNOCKDOWN2C,JCKNOCKDOWN2D
	.long	JCKNOCKDOWN2E,0
JCKNOCKDOWN3
	.long	JCKNOCKDOWN3A,JCKNOCKDOWN3B,0
JCKNOCKDOWN4
	.long	JCKNOCKDOWN4A,JCKNOCKDOWN4B,JCKNOCKDOWN4C,0
JCKNOCKDOWN5
	.long	JCKNOCKDOWN5A,JCKNOCKDOWN5B,0
JCKNOCKDOWN6
	.long	JCKNOCKDOWN6A,JCKNOCKDOWN6B,0
JCKNOCKDOWN7
	.long	JCKNOCKDOWN7A,0

;*************************************************************************

a_jchithi
	.long	JCHIHIT2
	.long	JCHIHIT3
	.long	JCHIHIT2
	.long	JCHIHIT1
	.long	0

JCHIHIT1	.long	JCHIHIT1A,JCHIHIT1B,0
JCHIHIT2	.long	JCHIHIT2A,JCHIHIT2B,0
JCHIHIT3	.long	JCHIHIT3A,JCHIHIT3B,0

;*************************************************************************

a_jchitlo
	.long	JCLOHIT2
	.long	JCLOHIT3
	.long	JCLOHIT2
	.long	JCLOHIT1
	.long	0

JCLOHIT1	.long	JCLOHIT1A,JCLOHIT1B,0
JCLOHIT2	.long	JCLOHIT2A,JCLOHIT2B,0
JCLOHIT3	.long	JCLOHIT3A,JCLOHIT3B,0

;*************************************************************************

a_jcgetup
	.long	JCGETUP1
	.long	JCGETUP2
	.long	JCGETUP3
	.long	JCGETUP4
	.long	JCGETUP5
	.long	JCGETUP6
	.long	0

JCGETUP1	.long	JCGETUP1A,JCGETUP1B,0
JCGETUP2	.long	JCGETUP2A,JCGETUP2B,0
JCGETUP3	.long	JCGETUP3A,JCGETUP3B,0
JCGETUP4	.long	JCGETUP4A,JCGETUP4B,JCGETUP4C,0
JCGETUP5	.long	JCGETUP5A,0
JCGETUP6	.long	JCGETUP6A,0

;*************************************************************************

a_jchipunch
	.long	JCHIPUNCH1
	.long	JCHIPUNCH2
	.long	JCHIPUNCH3
	.long	0

	.long	JCHIPUNCH4
	.long	JCHIPUNCH5
	.long	JCHIPUNCH6
	.long	0

	.long	JCHIPUNCH5
	.long	JCHIPUNCH4
	.long	ani_jump,a_jchipunch+(32*2)
	.long	0
*
* Unhipunch #1
*
	.long	JCHIPUNCH2
	.long	JCHIPUNCH1
	.long	0
*
* Unhipunch #2
*
	.long	JCHIPUNCH5
	.long	0
*
* Hi to Med #1
*
	.long	JCHIPUNCH4
	.long	JCHIPUNCH5
	.long	ani_jump,a_jclopunch+(32*6)
	.long	0
*
* Hi to Med #2
*
	.long	JCHIPUNCH5
	.long	JCHIPUNCH4
	.long	ani_jump,a_jclopunch+(32*2)
	.long	0


a_jclopunch
	.long	JCHIPUNCH1
	.long	JCHIPUNCH2
	.long	JCLOPUNCH1
	.long	0

	.long	JCHIPUNCH4
	.long	JCHIPUNCH5
	.long	JCLOPUNCH2
	.long	0

	.long	JCHIPUNCH5
	.long	JCHIPUNCH4
	.long	ani_jump,a_jclopunch+(32*2)
	.long	0
*
* Unlopunch #1
*
	.long	JCHIPUNCH2
	.long	JCHIPUNCH1
	.long	0
*
* Unlopunch #2
*
	.long	JCHIPUNCH5
	.long	0
*
* Med to High #1
*
	.long	JCHIPUNCH4
	.long	JCHIPUNCH5
	.long	ani_jump,a_jchipunch+(32*6)
	.long	0
*
* Med to High #2
*
	.long	JCHIPUNCH5
	.long	JCHIPUNCH4
	.long	ani_jump,a_jchipunch+(32*2)


JCHIPUNCH1
	.long	JCHIPUNCH1A,JCHIPUNCH1B,0
JCHIPUNCH2
	.long	JCHIPUNCH2A,JCHIPUNCH2B,JCHIPUNCH2C,0
JCHIPUNCH3
	.long	JCHIPUNCH3A,JCHIPUNCH3B,JCHIPUNCH3C,0
JCHIPUNCH4
	.long	JCHIPUNCH4A,JCHIPUNCH4B,JCHIPUNCH4C,0
JCHIPUNCH5
	.long	JCHIPUNCH5A,JCHIPUNCH5B,JCHIPUNCH5C,0
JCHIPUNCH6
	.long	JCHIPUNCH6A,JCHIPUNCH6B,JCHIPUNCH6C,0
JCHIPUNCH7
	.long	JCHIPUNCH7A,JCHIPUNCH7B,JCHIPUNCH7C,0
JCLOPUNCH1
	.long	JCLOPUNCH1A,JCLOPUNCH1B,0
JCLOPUNCH2
	.long	JCLOPUNCH2A,JCLOPUNCH2B,0

;*************************************************************************

a_jcsweep
	.long	JCSWEEPKICK1
	.long	JCSWEEPKICK2
	.long	JCSWEEPKICK3
	.long	ani_calla,sweep_sounds
	.long	JCSWEEPKICK4
	.long	JCSWEEPKICK5
	.long	0
	.long	JCSWEEPKICK6
	.long	JCSWEEPKICK7
	.long	0

JCSWEEPKICK1
	.long	JCSWEEPKICK1A,JCSWEEPKICK1B,0
JCSWEEPKICK2
	.long	JCSWEEPKICK2A,JCSWEEPKICK2B,JCSWEEPKICK2C,JCSWEEPKICK2D,0
JCSWEEPKICK3
	.long	JCSWEEPKICK3A,JCSWEEPKICK3B,JCSWEEPKICK3C,0
JCSWEEPKICK4
	.long	JCSWEEPKICK4A,JCSWEEPKICK4B,0
JCSWEEPKICK5
	.long	JCSWEEPKICK5A,JCSWEEPKICK5B,JCSWEEPKICK5C,JCSWEEPKICK5D,0
JCSWEEPKICK6
	.long	JCSWEEPKICK6A,JCSWEEPKICK6B,JCSWEEPKICK6C,0
JCSWEEPKICK7
	.long	JCSWEEPKICK7A,JCSWEEPKICK7B,JCSWEEPKICK7C,0

;*************************************************************************

a_jcsweepfall
	.long	JCSWEEPFALL1
	.long	JCSWEEPFALL2
	.long	JCSWEEPFALL3
	.long	JCSWEEPFALL4
	.long	JCSWEEPFALL5
	.long	JCSWEEPFALL6
	.long	0
	.long	JCSWEEPFALL5
	.long	JCSWEEPFALL6
	.long	0

JCSWEEPFALL1
	.long	JCSWEEPFALL1A,JCSWEEPFALL1B,JCSWEEPFALL1C,JCSWEEPFALL1D,0
JCSWEEPFALL2
	.long	JCSWEEPFALL2A,JCSWEEPFALL2B,JCSWEEPFALL2C,JCSWEEPFALL2D,0
JCSWEEPFALL3
	.long	JCSWEEPFALL3A,JCSWEEPFALL3B,JCSWEEPFALL3C,JCSWEEPFALL3D,0
JCSWEEPFALL4
	.long	JCSWEEPFALL4A,JCSWEEPFALL4B,0
JCSWEEPFALL5
	.long	JCSWEEPFALL5A,JCSWEEPFALL5B,0
JCSWEEPFALL6
	.long	JCSWEEPFALL6A,JCSWEEPFALL6B,0

;*************************************************************************

a_jcsweepup
	.long	JCSWEEPUP1
	.long	JCSWEEPUP2
	.long	JCSWEEPUP3
	.long	JCSWEEPUP4
	.long	JCSWEEPUP5
	.long	0

JCSWEEPUP1
	.long	JCSWEEPUP1A,JCSWEEPUP1B,0
JCSWEEPUP2
	.long	JCSWEEPUP2A,JCSWEEPUP2B,0
JCSWEEPUP3
	.long	JCSWEEPUP3A,JCSWEEPUP3B,0
JCSWEEPUP4
	.long	JCSWEEPUP4A,JCSWEEPUP4B,JCSWEEPUP4C,JCSWEEPUP4D,0
JCSWEEPUP5
	.long	JCSWEEPUP5A,JCSWEEPUP5B,0

;*************************************************************************

a_jcduckpunch
	.long	JCDUCKPUNCH1
	.long	JCDUCKPUNCH2
	.long	JCDUCKPUNCH3
	.long	0
	.long	JCDUCKPUNCH2
	.long	JCDUCKPUNCH1
	.long	JCDUCK3
	.long	0

JCDUCKPUNCH1
	.long	JCDUCKPUNCH1A,JCDUCKPUNCH1B,JCDUCKPUNCH1C,0
JCDUCKPUNCH2
	.long	JCDUCKPUNCH2A,JCDUCKPUNCH2B,JCDUCKPUNCH2C,JCDUCKPUNCH2D,0
JCDUCKPUNCH3
	.long	JCDUCKPUNCH3A,JCDUCKPUNCH3B,JCDUCKPUNCH3C,0

;*************************************************************************

a_jcduckkickl
	.long	JCDUCKICKLO1
	.long	ani_calla,kick_sounds
	.long	JCDUCKICKLO2
	.long	JCDUCKICKLO3
	.long	JCDUCKICKLO4
	.long	0

	.long	JCDUCKICKLO3
	.long	JCDUCKICKLO2
	.long	JCDUCKICKLO1
	.long	JCDUCK3
	.long	0


a_jcduckkickh
	.long	JCDUCKICKLO1
	.long	ani_calla,kick_sounds
	.long	JCDUCKICKLO2
	.long	JCDUCKICKHI1
	.long	JCDUCKICKHI2
	.long	0
	.long	JCDUCKICKHI1
	.long	JCDUCKICKLO2
	.long	JCDUCKICKLO1
	.long	JCDUCK3
	.long	0

JCDUCKICKLO1
	.long	JCDUCKICKLO1A,JCDUCKICKLO1B,JCDUCKICKLO1C,0
JCDUCKICKLO2
	.long	JCDUCKICKLO2A,JCDUCKICKLO2B,JCDUCKICKLO2C,JCDUCKICKLO2D,0
JCDUCKICKLO3
	.long	JCDUCKICKLO3A,JCDUCKICKLO3B,JCDUCKICKLO3C,JCDUCKICKLO3D,0
JCDUCKICKLO4
	.long	JCDUCKICKLO4A,JCDUCKICKLO4B,JCDUCKICKLO4C,JCDUCKICKLO4D,0
JCDUCKICKHI1
	.long	JCDUCKICKHI1A,JCDUCKICKHI1B,JCDUCKICKHI1C,0
JCDUCKICKHI2
	.long	JCDUCKICKHI2A,JCDUCKICKHI2B,JCDUCKICKHI2C,0

;*************************************************************************

a_jcduckhit
	.long	JCDUCKHIT2
	.long	JCDUCKHIT3
	.long	JCDUCKHIT2
	.long	JCDUCKHIT1
	.long	JCDUCK3
	.long	0

JCDUCKHIT1
	.long	JCDUCKHIT1A,JCDUCKHIT1B,0
JCDUCKHIT2
	.long	JCDUCKHIT2A,JCDUCKHIT2B,0
JCDUCKHIT3
	.long	JCDUCKHIT3A,JCDUCKHIT3B,0

;*************************************************************************

a_jcuppercut
	.long	JCUPPERCUT1
	.long	JCUPPERCUT2
	.long	JCUPPERCUT3
	.long	JCUPPERCUT4
	.long	ani_nosleep	; dont sleep after next frame
	.long	JCUPPERCUT5
	.long	0
	.long	JCHIPUNCH2
	.long	0

JCUPPERCUT1
	.long	JCUPPERCUT1A,JCUPPERCUT1B,0
JCUPPERCUT2
	.long	JCUPPERCUT2A,JCUPPERCUT2B,0
JCUPPERCUT3
	.long	JCUPPERCUT3A,JCUPPERCUT3B,JCUPPERCUT3C,0
JCUPPERCUT4
	.long	JCUPPERCUT4A,JCUPPERCUT4B,JCUPPERCUT4C,0
JCUPPERCUT5
	.long	JCUPPERCUT5A,JCUPPERCUT5B,0

;*************************************************************************

a_jcjumpupkick	
	.long	JCJUMPKICK1
	.long	JCJUMPKICK2
	.long	JCJUMPKICK3
	.long	0
	.long	JCJUMPKICK4
	.long	JCJUMPKICK5
	.long	0

JCJUMPKICK1
	.long	JCJUMPKICK1A,JCJUMPKICK1B,JCJUMPKICK1C,JCJUMPKICK1D,0
JCJUMPKICK2
	.long	JCJUMPKICK2A,JCJUMPKICK2B,JCJUMPKICK2C,0
JCJUMPKICK3
	.long	JCJUMPKICK3A,JCJUMPKICK3B,0
JCJUMPKICK4
	.long	JCJUMPKICK4A,JCJUMPKICK4B,JCJUMPKICK4C,JCJUMPKICK4D,0
JCJUMPKICK5
	.long	JCJUMPKICK5A,0

;*************************************************************************

a_jcflipkick
	.long	JCFLIPKICK1
	.long	JCFLIPKICK2
	.long	JCFLIPKICK3
	.long	0
	.long	JCFLIPKICK2
	.long	JCFLIPKICK1
	.long	0

JCFLIPKICK1
	.long	JCFLIPKICK1A,JCFLIPKICK1B,JCFLIPKICK1C,0
JCFLIPKICK2
	.long	JCFLIPKICK2A,JCFLIPKICK2B,0
JCFLIPKICK3
	.long	JCFLIPKICK3A,JCFLIPKICK3B,JCFLIPKICK3C,JCFLIPKICK3D,0

;*************************************************************************

a_jcflippunch
	.long	JCFLIPUNCH1
	.long	JCFLIPUNCH2
	.long	JCFLIPUNCH3
	.long	0
	.long	JCFLIPUNCH2
	.long	JCFLIPUNCH1
	.long	0

JCFLIPUNCH1
	.long	JCFLIPUNCH1A,JCFLIPUNCH1B,JCFLIPUNCH1C,JCFLIPUNCH1D,0
JCFLIPUNCH2
	.long	JCFLIPUNCH2A,JCFLIPUNCH2B,JCFLIPUNCH2C,JCFLIPUNCH2D,0
JCFLIPUNCH3
	.long	JCFLIPUNCH3A,JCFLIPUNCH3B,JCFLIPUNCH3C,0

;*************************************************************************

a_jcroundh
	.long	JCROUNDKICK1
	.long	JCROUNDKICK2
	.long	JCROUNDKICK3
	.long	JCROUNDKICK4
	.long	ani_nosleep
	.long	JCROUNDKICK5
	.long	0
	.long	JCROUNDKICK6
	.long	JCROUNDKICK7
	.long	JCROUNDKICK8
	.long	0

JCROUNDKICK1
	.long	JCROUNDKICK1A,JCROUNDKICK1B,JCROUNDKICK1C,0
JCROUNDKICK2
	.long	JCROUNDKICK2A,JCROUNDKICK2B,JCROUNDKICK2C,JCROUNDKICK2D
	.long	JCROUNDKICK2E,0
JCROUNDKICK3
	.long	JCROUNDKICK3A,JCROUNDKICK3B,0
JCROUNDKICK4
	.long	JCROUNDKICK4A,JCROUNDKICK4B,0
JCROUNDKICK5
	.long	JCROUNDKICK5A,JCROUNDKICK5B,0
JCROUNDKICK6
	.long	JCROUNDKICK6A,JCROUNDKICK6B,0
JCROUNDKICK7
	.long	JCROUNDKICK7A,JCROUNDKICK7B,0
JCROUNDKICK8
	.long	JCROUNDKICK8A,JCROUNDKICK8B,0

;*************************************************************************

a_jcknee
	.long	JCAXKICK1
	.long	JCAXKICK2
	.long	JCAXKICK3
	.long	ani_nosleep	; dont sleep after next frame
	.long	JCAXKICK4
	.long	0
	.long	JCAXKICK3
	.long	JCAXKICK2
	.long	JCAXKICK1
	.long	0

JCAXKICK1
	.long	JCAXKICK1A,JCAXKICK1B,JCAXKICK1C,JCAXKICK1D
	.long	JCAXKICK1E,0
JCAXKICK2
	.long	JCAXKICK2A,JCAXKICK2B,JCAXKICK2C,JCAXKICK2D,0
JCAXKICK3
	.long	JCAXKICK3A,JCAXKICK3B,JCAXKICK3C,JCAXKICK3D,0
JCAXKICK4
	.long	JCAXKICK4A,JCAXKICK4B,0

;*************************************************************************

a_jcelbow
	.long	ani_adjustx
	.word	>04
	.long	JCPALMSTRIKE1

	.long	ani_adjustx
	.word	>04
	.long	JCPALMSTRIKE2

	.long	ani_adjustx
	.word	>04
	.long	JCPALMSTRIKE3
	.long	0
	.long	JCPALMSTRIKE2
	.long	JCPALMSTRIKE1
	.long	0

JCPALMSTRIKE1
	.long	JCPALMSTRIKE1A,JCPALMSTRIKE1B,JCPALMSTRIKE1C,0
JCPALMSTRIKE2
	.long	JCPALMSTRIKE2A,JCPALMSTRIKE2B,0
JCPALMSTRIKE3
	.long	JCPALMSTRIKE3A,JCPALMSTRIKE3B,JCPALMSTRIKE3C,JCPALMSTRIKE3D,0

;*************************************************************************

a_jcstumble
	.long	JCSTUMBLE1
	.long	JCSTUMBLE2
	.long	JCSTUMBLE3
	.long	JCSTUMBLE4
	.long	JCSTUMBLE5
	.long	0

JCSTUMBLE1
	.long	JCSTUMBLE1A,JCSTUMBLE1B,0
JCSTUMBLE2
	.long	JCSTUMBLE2A,0
JCSTUMBLE3
	.long	JCSTUMBLE3A,JCSTUMBLE3B,0
JCSTUMBLE4
	.long	JCSTUMBLE4A,JCSTUMBLE4B,JCSTUMBLE4C,0
JCSTUMBLE5
	.long	JCSTUMBLE5A,JCSTUMBLE5B,JCSTUMBLE5C,0



***********************************************

a_shredded
	.long	ani_adjustxy
	.word	6,6
	.long	JCSTUMBLE1

	.long	ani_adjustxy
	.word	-6,-6
	.long	JCSTUMBLE2

	.long	ani_adjustxy
	.word	6,6
	.long	JCSTUMBLE3

	.long	ani_adjustxy
	.word	-6,-6
	.long	JCSTUMBLE2

	.long	ani_jump,a_shredded


;*************************************************************************

a_jcbodyslam
	.long	JCFLIP1
	.long	JCFLIP2
	.long	0
	.long	JCFLIP3
	.long	JCFLIP4
	.long	JCFLIP5
	.long	0
	.long	JCFLIP6
	.long	0

JCFLIP1	.long	JCFLIP1A,JCFLIP1B,JCFLIP1C,0
JCFLIP2	.long	JCFLIP2A,JCFLIP2B,0
JCFLIP3	.long	JCFLIP3A,JCFLIP3B,0
JCFLIP4	.long	JCFLIP4A,JCFLIP4B,JCFLIP4C,0
JCFLIP5	.long	JCFLIP5A,JCFLIP5B,JCFLIP5C,0
JCFLIP6	.long	JCFLIP6A,JCFLIP6B,0

;*************************************************************************

a_banged
	.long	JCFLIPPED1
	.long	JCFLIPPED2
	.long	JCFLIPPED3
	.long	JCFLIPPED4
	.long	0


a_jc_fb_sa
	.long	ani_adjustxy
	.word	->40,>00
	.long	JCSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>12,->28
	.long	JCFLIPPED1

	.long	ani_adjustxy
	.word	>23,->10
	.long	JCFLIPPED2

	.long	ani_adjustxy
	.word	>3f,->20
	.long	JCFLIPPED3
	.long	0


a_jc_fb_fn
	.long	ani_adjustxy
	.word	->4d,->10
	.long	ani_flip
	.long	JCKNOCKDOWN1
	.long	0

	.long	ani_adjustxy
	.word	->28,->20
	.long	JCKNOCKDOWN1

	.long	ani_adjustxy
	.word	->40,->25
	.long	JCKNOCKDOWN3

	.long	ani_adjustxy
	.word	->20,>20
	.long	JCKNOCKDOWN3

	.long	ani_adjustxy
	.word	->10,>30
	.long	JCFLIPPED4

	.long	ani_adjustxy
	.word	>00,>20
	.long	JCFLIPPED4
	.long	0
*
* bounce on ground
*
	.long	JCFLIPPED4
	.long	0


a_jc_fb_hh
	.long	ani_adjustxy
	.word	->2a,>00		; we need even # of words here !
	.long	JCSTUMBLE3
	.long	0

	.long	ani_flip
	.long	ani_adjustxy
	.word	>25,->05
	.long	JCSTUMBLE3
	.long	0

	.long	ani_adjustxy
	.word	>70,->40

	.long	JCFLIPPED3
	.long	JCFLIPPED3
	.long	JCFLIPPED4
	.long	0

a_jc_fb_lk
	.long	ani_adjustxy
	.word	->40,>00
	.long	JCFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>20,>10
	.long	JCFLIPPED1

	.long	ani_adjustxy
	.word	>20,>00
	.long	JCFLIPPED2

	.long	ani_adjustxy
	.word	>28,->08
	.long	JCFLIPPED3

	.long	ani_adjustxy
	.word	>40,->28
	.long	JCFLIPPED4

	.long	ani_adjustxy
	.word	>10,->08
	.long	JCFLIPPED4
	.long	0
*
* land on the ground
*
	.long	JCKNOCKDOWN6
	.long	JCKNOCKDOWN7
	.long	JCKNOCKDOWN6
	.long	JCKNOCKDOWN7
     	.long	0


a_jc_fb_nj
	.long	ani_adjustxy
	.word	->40,>00
	.long	JCFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>04,>00
	.long	JCFLIPPED1

	.long	ani_adjustxy
	.word	>20,>20
	.long	JCFLIPPED2

	.long	ani_adjustxy
	.word	>28,->08
	.long	JCFLIPPED3

	.long	ani_adjustxy
	.word	>40,->28
	.long	JCFLIPPED4

	.long	ani_adjustxy
	.word	>10,->08
	.long	JCFLIPPED4
	.long	0
*
* land on the ground
*
	.long	JCKNOCKDOWN6
	.long	JCKNOCKDOWN7
	.long	JCKNOCKDOWN6
	.long	JCKNOCKDOWN7
     	.long	0


a_jc_fb_jx
	.long	ani_adjustxy
	.word	->46,>00
	.long	JCSTUMBLE1
	.long	JCSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>10,->38
	.long	JCFLIPPED1	; jax 3

	.long	ani_adjustxy
	.word	>2a,->08
	.long	JCFLIPPED2	; jax 4

	.long	ani_adjustxy
	.word	>38,>00
	.long	JCFLIPPED3	; jax 5

	.long	ani_adjustxy
	.word	>20,>28
	.long	JCFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	>00,>1d
	.long	JCKNOCKDOWN7	; jax 7
	.long	0
*
* slammed again !
*
	.long	ani_adjustxy
	.word	->10,->20
	.long	JCFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	->10,->46
	.long	JCFLIPPED4	; jax 6

	.long	ani_flip
	.long	ani_adjustxy
	.word	>4a,>07
	.long	JCFLIPPED3	; jax 4

	.long	ani_adjustxy
	.word	>34,->08
	.long	JCFLIPPED4	; jax 3

	.long	ani_adjustxy
	.word	>10,>46
	.long	JCFLIPPED4

	.long	ani_adjustxy
	.word	->10,>20
	.long	JCKNOCKDOWN7	; jax 7
	.long	0


a_jc_fb_jc
	.long	ani_adjustxy
	.word	->28,>08
	.long	JCSTUMBLE1
	.long	JCSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>1f,->40
	.long	JCFLIPPED2

	.long	ani_adjustxy
	.word	>58,>20
	.long	JCFLIPPED4

	.long	ani_adjustxy
	.word	>18,>40
	.long	JCFLIPPED4
	.long	0


a_jc_fb_st
	.long	ani_adjustxy
	.word	->30,>00
	.long	JCSTUMBLE5
	.long	JCSTUMBLE5
	.long	0

	.long	ani_adjustxy
	.word	>00,->20
	.long	JCFLIPPED1
	.long	ani_adjustxy
	.word	>40,->10
	.long	JCFLIPPED2
	.long	ani_adjustxy
	.word	>40,>10
	.long	JCFLIPPED4
	.long	ani_adjustxy
	.word	>10,>28
	.long	JCFLIPPED4
	.long	0

	.long	ani_adjustxy
	.word	>20,>00
	.long	JCKNOCKDOWN6
	.long	0


a_jc_fb_rd
	.long	ani_adjustxy
	.word	->4a,>00
	.long	JCSTUMBLE5
	.long	0

	.long	ani_adjustxy
	.word	>0a,->25
	.long	JCFLIPPED1

	.long	ani_adjustxy
	.word	>34,->20
	.long	JCFLIPPED2
	.long	JCFLIPPED2

	.long	ani_adjustxy
	.word	>0a,>A0
	.long	ani_flip_v
	.long	JCFLIPPED2

	.long	ani_adjustxy
	.word	>38,>40
	.long	JCFLIPPED2
	.long	0

	.long	ani_adjustxy
	.word	>18,>10
	.long	ani_flip
	.long	JCKNOCKDOWN7
	.long	0



JCFLIPPED1
	.long	JCFLIPPED1A,JCFLIPPED1B,0
JCFLIPPED2
	.long	JCFLIPPED2A,JCFLIPPED2B,JCFLIPPED2C,0
JCFLIPPED3
	.long	JCFLIPPED3A,JCFLIPPED3B,0
JCFLIPPED4
	.long	JCFLIPPED4A,JCFLIPPED4B,0


;*************************************************************************

a_jczap
	.long	JCTHROW1
	.long	JCTHROW2
;	.long	JCTHROW3
	.long	0
	.long	JCTHROW4
	.long	JCTHROW5
	.long	0

JCTHROW1	.long	JCTHROW1A,JCTHROW1B,0
JCTHROW2	.long	JCTHROW2A,JCTHROW2B,0	;,JCTHROW2C,JCTHROW2D,0
JCTHROW3	.long	JCTHROW3A,JCTHROW3B,0
JCTHROW4	.long	JCTHROW4A,JCTHROW4B,JCTHROW4C,0
JCTHROW5	.long	JCTHROW5A,JCTHROW5B,0

;*************************************************************************


;*************************************************************************

a_jcstunned
	.long	JCSTUNNED1
	.long	JCSTUNNED2
	.long	JCSTUNNED3
	.long	JCSTUNNED4
	.long	JCSTUNNED5
	.long	JCSTUNNED6
	.long	JCSTUNNED7
	.long	ani_jump,a_jcstunned

JCSTUNNED1
	.long	JCSTUNNED1A,JCSTUNNED1B,0
JCSTUNNED2
	.long	JCSTUNNED2A,JCSTUNNED2B,JCSTUNNED2C,0
JCSTUNNED3
	.long	JCSTUNNED3A,JCSTUNNED3B,0
JCSTUNNED4
	.long	JCSTUNNED4A,JCSTUNNED4B,0
JCSTUNNED5
	.long	JCSTUNNED5A,JCSTUNNED5B,0
JCSTUNNED6
	.long	JCSTUNNED6A,JCSTUNNED6B,0
JCSTUNNED7
	.long	JCSTUNNED7A,JCSTUNNED7B,0

;*************************************************************************

a_jcvictory
	.long	JCVICTORY1
	.long	JCVICTORY2
	.long	JCVICTORY3
	.long	JCVICTORY4
	.long	JCVICTORY5
	.long	JCVICTORY6
	.long	JCVICTORY7
	.long	0

	.long	JCVICTORY8
	.long	0

	.long	JCVICTORY9
	.long	JCVICTORY10
	.long	0

	.long	JCVICTORY11
	.long	JCVICTORY12
	.long	JCVICTORY13
	.long	JCVICTORY14
	.long	0

JCVICTORY1
	.long	JCVICTORY1A,JCVICTORY1B,JCVICTORY1C
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY2
	.long	JCVICTORY2A
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY3
	.long	JCVICTORY3A,JCVICTORY3B,JCVICTORY3C
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY4
	.long	JCVICTORY4A,JCVICTORY4B,JCVICTORY4C
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY5
	.long	JCVICTORY5A,JCVICTORY5B,JCVICTORY5C
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY6
	.long	JCVICTORY6A
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY7
	.long	JCVICTORY7A
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY8
	.long	JCVICTORY8A
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY9
	.long	JCVICTORY9A,JCVICTORY9B,JCVICTORY9C
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY10
	.long	JCVICTORY10A,JCVICTORY10B,JCVICTORY10C
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY11
	.long	JCVICTORY11A,JCVICTORY11B,JCVICTORY11C
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY12
	.long	JCVICTORY12A
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY13
	.long	JCVICTORY13A
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0
JCVICTORY14
	.long	JCVICTORY14A
	.long	JCVICTORYLEG1A,JCVICTORYLEG1B,0

;*************************************************************************

a_splits
	.long	JCSPLIT1
	.long	JCSPLIT2
	.long	JCSPLIT3
	.long	JCSPLIT4
	.long	JCSPLIT5		; reach yer arm out !
	.long	0

	.long	JCSPLIT4
	.long	JCSPLIT3
	.long	JCSPLIT2
	.long	JCSPLIT1
	.long	0

JCSPLIT1	.long	JCSPLITLEG1A,JCSPLITLEG1B,JCSPLITORSO1A,JCSPLITORSO1B,0
JCSPLIT2	.long	JCSPLITLEG2A,JCSPLITLEG2B,JCSPLITORSO2A,JCSPLITORSO2B,0
JCSPLIT3	.long	JCSPLITLEG3A,JCSPLITLEG3B,JCSPLITORSO3A,JCSPLITORSO3B,0
JCSPLIT4	.long	JCSPLITLEG3A,JCSPLITLEG3B,JCSPLITORSO4A,JCSPLITORSO4B,0
JCSPLIT5	.long	JCSPLITLEG3A,JCSPLITLEG3B,JCSPLITORSO5A,JCSPLITORSO5B,0


;*************************************************************************

a_nutcrunched
	.long	JCNUTCRUNCH1
	.long	JCNUTCRUNCH2
	.long	0
	.long	JCNUTCRUNCH1
	.long	0

JCNUTCRUNCH1
	.long	JCNUTCRUNCH1A,JCNUTCRUNCH1B,0
JCNUTCRUNCH2
	.long	JCNUTCRUNCH2A,JCNUTCRUNCH2B,0

;*************************************************************************

a_shoruken
;	.long	JCFLYBO1
	.long	JCFLYBO2
	.long	JCFLYBO3
	.long	0
	.long	JCFLYBO2
	.long	JCJUMP1
	.long	0

JCFLYBO1	.long	JCFLYBO1A,JCFLYBO1B,0
JCFLYBO2	.long	JCFLYBO2A,JCFLYBO2B,0
JCFLYBO3	.long	JCFLYBO3A,JCFLYBO3B,0

;*************************************************************************

a_jczaphi
	.long	JCTHROWUP1
	.long	JCTHROWUP2
	.long	JCTHROWUP3
	.long	0

JCTHROWUP1
	.long	JCTHROWUP1A,JCTHROWUP1B,0
JCTHROWUP2
	.long	JCTHROWUP2A,JCTHROWUP2B,JCTHROWUP2C,JCTHROWUP2D
	.long	0
JCTHROWUP3
	.long	JCTHROWUP3A,JCTHROWUP3B,JCTHROWUP3C,JCTHROWUP3D
	.long	0


;*************************************************************************

a_jcgreenball
	.long	GREEN1
	.long	GREEN2
;	.long	GREEN3
	.long	0

	.long	GREEN10
	.long	0

	.long	GREENBALL9	; 2nd largest piece
	.long	GREENBALL8
	.long	GREENBALL7
	.long	GREENBALL6
	.long	GREENBALL5
	.long	GREENBALL4	; smallest
	.long	0

	.long	GREENBALL11
	.long	GREENBALL12
	.long	GREENBALL13
	.long	GREENBALL14
	.long	GREENBALL15
	.long	GREENBALL16
	.long	0

GREEN1	.long	GREENBALL1,0
GREEN2	.long	GREENBALL2,0
GREEN3	.long	GREENBALL3,0
GREEN10	.long	GREENBALL10,0


GREENBALL11
	.long	GREENBALL11A,GREENBALL11B,0
GREENBALL12
	.long	GREENBALL12A,GREENBALL12B,GREENBALL12C,GREENBALL12D,0
GREENBALL13
	.long	GREENBALL13A,GREENBALL13B,GREENBALL13C,GREENBALL13D
	.long	GREENBALL13E,0
GREENBALL14
	.long	GREENBALL14A,GREENBALL14B,GREENBALL14C,GREENBALL14D,0
GREENBALL15
	.long	GREENBALL15A,GREENBALL15B,GREENBALL15C,GREENBALL15D,0
GREENBALL16
	.long	GREENBALL16A,GREENBALL16B,GREENBALL16C,GREENBALL16D,0

;*************************************************************************

a_jc_pp
;	.long	JCPOWERPUNCH1
;	.long	JCPOWERPUNCH2	; wind up sans moving
;	.long	JCPOWERPUNCH3
;	.long	0
;
;	.long	JCPOWERPUNCH4
;	.long	0
;	.long	JCPOWERPUNCH3
;	.long	JCPOWERPUNCH2
;	.long	JCPOWERPUNCH1
;	.long	0
;
;JCPOWERPUNCH1
;	.long	JCPOWERPUNCH1A,JCPOWERPUNCH1B,0
;JCPOWERPUNCH2
;	.long	JCPOWERPUNCH2A,JCPOWERPUNCH2B,JCPOWERPUNCH2C,0
;JCPOWERPUNCH3
;	.long	JCPOWERPUNCH3A,JCPOWERPUNCH3B,JCPOWERPUNCH3C,JCPOWERPUNCH3D,0
;JCPOWERPUNCH4
;	.long	JCPOWERPUNCH4A,JCPOWERPUNCH4B,JCPOWERPUNCH4C,JCPOWERPUNCH4D,0
;
;
;JC2DEATHBLO1
;	.long	JC2DEATHBLO1A,JC2DEATHBLO1B,JC2DEATHBLO1C,JC2DEATHBLO1D
;	.long	0
;JC2DEATHBLO2
;	.long	JC2DEATHBLO2A,JC2DEATHBLO2B,JC2DEATHBLO2C,0
;JC2DEATHBLO3
;	.long	JC2DEATHBLO3A,JC2DEATHBLO3B,JC2DEATHBLO3C,JC2DEATHBLO3D
;	.long	0
;JC2DEATHBLO4
;	.long	JC2DEATHBLO4A,JC2DEATHBLO4B,0
;JC2DEATHBLO5
;	.long	JC2DEATHBLO5A,JC2DEATHBLO5B,0
;JC2DEATHBLO6
;	.long	JC2DEATHBLO6A,JC2DEATHBLO6B,JC2DEATHBLO6C,0
;JC2DEATHBLO7
;	.long	JC2DEATHBLO7A,JC2DEATHBLO7B,JC2DEATHBLO7C,0
;JC2DEATHBLO8
;	.long	JC2DEATHBLO8A,JC2DEATHBLO8B,JC2DEATHBLO8C,0
;JC2DEATHBLO9
;	.long	JC2DEATHBLO9A,JC2DEATHBLO9B,JC2DEATHBLO9C,0
;JC2DEATHBLO10
;	.long	JC2DEATHBLO10A,JC2DEATHBLO10B,0

;******************************************************************

a_bike_kicked
	.long	JCSTUMBLE1
	.long	JCSTUMBLE2
	.long	JCSTUMBLE3
	.long	JCSTUMBLE4
	.long	JCSTUMBLE5
	.long	ani_jump,a_bike_kicked

;******************************************************************


;JCFLYBO3A:
;	.word   38,157,35-20,7
;	.long   02b803b7H
;;	.word   06580H
;
;JCFLYBO3B:
;	.word   22,106,-3-20,7
;	.long   02b84b23H
;	.word   06480H

;******************************************************************


a_drained
	.long	ani_adjustxy
	.word	->3a,->13
	.long	JCSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	->20,>1c
	.long	JCDRAIN0
	.long	ani_adjustxy
	.word	>13,->08
	.long	JCDRAIN0
	.long	ani_adjustxy
	.word	>08,->14
	.long	JCDRAIN0
	.long	ani_adjustxy
	.word	8,-8
	.long	JCDRAIN0

	.long	0

*********************************************************

a_jcrip
	.long	JCDEATHBLOW1
	.long	JCDEATHBLOW1
	.long	JCDEATHBLOW1
	.long	JCDEATHBLOW1
	.long	JCDEATHBLOW1
	.long	JCDEATHBLOW2
	.long	JCDEATHBLOW3	; grab
	.long	0
	.long	JCDEATHBLOW4
	.long	JCDEATHBLOW5	; wind up
	.long	0
	.long	JCDEATHBLOW6
	.long	JCDEATHBLOW7	; rip
	.long	0
	.long	JCDEATHBLOW8
	.long	0
	.long	JCDEATHBLOW9
	.long	JCDEATHBLOW10
	.long	0

JCDEATHBLOW1
	.long	JCDEATHBLOW1A,JCDEATHBLOW1B,0
JCDEATHBLOW2
	.long	JCDEATHBLOW2A,JCDEATHBLOW2B,0
JCDEATHBLOW3
	.long	JCDEATHBLOW3A,JCDEATHBLOW3B,JCDEATHBLOW3C,0
JCDEATHBLOW4
	.long	JCDEATHBLOW4A,JCDEATHBLOW4B,JCDEATHBLOW4C,0
JCDEATHBLOW5
	.long	JCDEATHBLOW5A,JCDEATHBLOW5B,JCDEATHBLOW5C,0
JCDEATHBLOW6
	.long	JCDEATHBLOW6A,JCDEATHBLOW6B,JCDEATHBLOW6C,0
JCDEATHBLOW7
	.long	JCDEATHBLOW7A,JCDEATHBLOW7B,0
JCDEATHBLOW8
	.long	JCDEATHBLOW8A,JCDEATHBLOW8B,0
JCDEATHBLOW9
	.long	JCDEATHBLOW9A,JCDEATHBLOW9B,JCDEATHBLOW9C,0
JCDEATHBLOW10
	.long	JCDEATHBLOW10A,JCDEATHBLOW10B,JCDEATHBLOW10C,0

*********************************************************

a_torso_ripped
	.long	ani_adjustxy
	.word	->3b,>00
	.long	JCSTUMBLE4
	.long	0

	.long	ani_calla,change_to_bloody_pal	; switch to bloody pal
	.long	JCRIPTORSO1

	.long	ani_adjustxy
	.word	>28,->20
	.long	JCRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>00,>08
	.long	JCRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>30,>20
	.long	JCRIPTORSO3

	.long	ani_adjustxy
	.word	>30,>40
	.long	JCRIPTORSO4
	.long	0

	.long	JCRIPTORSO6
	.long	JCRIPTORSO6
	.long	0
*
* standing legz
*
	.long	JCDEADLEG1			; legz
	.long	0


JCRIPTORSO1
	.long	JCRIPTORSO1A,JCRIPTORSO1B,0
JCRIPTORSO2
	.long	JCRIPTORSO2A,JCRIPTORSO2B,JCRIPTORSO2C,0
JCRIPTORSO3
	.long	JCRIPTORSO3A,JCRIPTORSO3B,0
JCRIPTORSO4
	.long	JCRIPTORSO4A,0
JCRIPTORSO5
	.long	JCRIPTORSO5A,JCRIPTORSO5B,0
JCRIPTORSO6
	.long	JCRIPTORSO6A,JCRIPTORSO6B,0


a_swipe_torso
	.long	JCRIPTORSO1
	.long	JCRIPTORSO2
	.long	JCRIPTORSO3
	.long	JCRIPTORSO4
	.long	JCRIPTORSO5
	.long	JCRIPTORSO6
	.long	0


a_head
	.long	JCHEADS1
	.long	JCHEADS2
	.long	JCHEADS3
	.long	JCHEADS4
	.long	JCHEADS5
	.long	JCHEADS6
	.long	JCHEADS7
	.long	JCHEADS8
	.long	ani_jump,a_head


a_decapfall
	.long	JCDECAP1
	.long	JCDECAP2
	.long	JCDECAP3	; on knees
	.long	0
*
* wobble on yer knees
*
	.long	JCDECAP4
	.long	JCDECAP3
	.long	JCDECAP4
	.long	JCDECAP3
	.long	JCDECAP4
	.long	JCDECAP3
	.long	0
*
* fall to ground
*
	.long	JCDECAP4
	.long	JCDECAP5
	.long	JCDECAP6
	.long	JCDECAP7
	.long	0




JCDECAP1
	.long	JCDEADLEG1A
	.long	JCDEADTORSO1A,0
JCDECAP2
	.long	JCDEADLEG2A
	.long	JCDEADTORSO2A,0
JCDECAP3
	.long	JCDEADLEG3A,JCDEADLEG3B
	.long	JCDEADTORSO3A,0
JCDECAP4
	.long	JCDEADLEG4A,JCDEADLEG4B,JCDEADLEG4C
	.long	JCDEADTORSO4A,0
JCDECAP5
	.long	JCDEADLEG5A,JCDEADLEG5B,JCDEADLEG5C
	.long	JCDEADTORSO5A,JCDEADTORSO5B,0
JCDECAP6
	.long	JCDEADLEG6A,JCDEADLEG6B,JCDEADLEG6C
	.long	JCDEADTORSO6A,0
JCDECAP7
	.long	JCDEADLEG7A,JCDEADLEG7B
	.long	JCDEADTORSO7A,0


JCDEADLEG1
	.long	JCDEADLEG1A,0
;JCDEADLEG2
;	.long	JCDEADLEG2A,0
;JCDEADLEG3
;	.long	JCDEADLEG3A,JCDEADLEG3B,0
;JCDEADLEG4
;	.long	JCDEADLEG4A,JCDEADLEG4B,JCDEADLEG4C,0
;JCDEADLEG5
;	.long	JCDEADLEG5A,JCDEADLEG5B,JCDEADLEG5C,0
;JCDEADLEG6
;	.long	JCDEADLEG6A,JCDEADLEG6B,JCDEADLEG6C,0
;JCDEADLEG7
;	.long	JCDEADLEG7A,JCDEADLEG7B,0
;JCDEADTORSO1
;	.long	JCDEADTORSO1A,0
;JCDEADTORSO2
;	.long	JCDEADTORSO2A,0
;JCDEADTORSO3
;	.long	JCDEADTORSO3A,0
;JCDEADTORSO4
;	.long	JCDEADTORSO4A,0
;JCDEADTORSO5
;	.long	JCDEADTORSO5A,JCDEADTORSO5B,0
;JCDEADTORSO6
;	.long	JCDEADTORSO6A,0
;JCDEADTORSO7
;	.long	JCDEADTORSO7A,0


a_back_broke
	.long	JCBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>0a
	.long	JCBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>30
	.long	JCBACKBREAK1
	.long	JCBACKBREAK2
	.long	JCBACKBREAK3
	.long	0
	.long	JCBACKBREAK2
	.long	JCBACKBREAK1
	.long	0

JCBACKBREAK1
	.long	JCBACKBREAK1A,JCBACKBREAK1B,0
JCBACKBREAK2
	.long	JCBACKBREAK2A,JCBACKBREAK2B,JCBACKBREAK2C,0
JCBACKBREAK3
	.long	JCBACKBREAK3A,JCBACKBREAK3B,JCBACKBREAK3C,JCBACKBREAK3D,0

;********************************************************************

a_impaled
	.long	ani_adjustxy
	.word	->60,>00
	.long	JCIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	JCIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	JCIMPALED1

	.long	ani_adjustxy
	.word	>10,->22
	.long	JCIMPALED1

	.long	0
*
* suffering (that's Christmas)
*
	.long	JCIMPALED1
	.long	JCIMPALED2
	.long	JCIMPALED3

	.long	JCIMPALED2
	.long	JCIMPALED1
	.long	JCIMPALED2
	.long	JCIMPALED3
	.long	0

JCIMPALED1
	.long	JCIMPALED1A,JCIMPALED1B,JCIMPALED1C,0
JCIMPALED2
	.long	JCIMPALED2A,JCIMPALED2B,JCIMPALED2C,0
JCIMPALED3
	.long	JCIMPALED3A,JCIMPALED3B,JCIMPALED3C,0

;********************************************************************

a_fb_goro
	.long	ani_adjustxy
	.word	->60,->20
	.long	JCSTUMBLE1

	.long	ani_adjustxy
	.word	>10,->70
	.long	JCKNOCKDOWN6

	.long	ani_adjustxy
	.word	>20,>00
	.long	JCKNOCKDOWN6

	.long	ani_adjustxy
	.word	>3a,>20
	.long	JCKNOCKDOWN5

	.long	ani_adjustxy
	.word	>38,>10
	.long	JCKNOCKDOWN5

	.long	ani_adjustxy
	.word	>00,>68
	.long	JCKNOCKDOWN6

	.long	0

;****************************************************************

	.end
