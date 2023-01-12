**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: Shang Tsung										*
*											     *
**************************************************************************
	.FILE	'MKST.ASM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
*
* GET THE SYSTEM STUFF
*
	.INCLUDE	MAINEQU.ASM
	.INCLUDE	MKST.TBL
	.INCLUDE	IMGTBL.GLO
	.include	dispequ.asm
	.include	sysequ.asm

	.text


st_anitab1
	.long	a_ststance	;  0 - stance
	.long	a_stwalkf	;  1 - walk forward
	.long	a_stskipf	;  2 - skip forward
	.long	a_stwalkb	;  3 - walk backward
	.long	a_stskipb	;  4 - walk backward
	.long	a_stduck  	;  5 - duck animation
	.long	a_stjumpup	;  6 - jump straight up
	.long	a_stfflip	;  7 - forward flip
	.long	a_stbflip	;  8 - backward flip
	.long	a_stturn	;  9 - turn around
	.long	a_stduckturn	;  a - turn around while ducking
	.long	a_stblockhi	;  b - standing block
	.long	a_stduckblock	;  c - ducking block
	.long	a_sthikick	;  d - hi kick
	.long	a_stlokick	;  e - lo kick
	.long	a_stkdown	;  f - knocked down
	.long	a_sthithi	; 10 - hit high
	.long	a_sthitlo	; 11 - hit low
	.long	a_stgetup	; 12 - normal getup
	.long	a_sthipunch	; 13 - hi punch
	.long	a_stlopunch	; 14 - lo punch
	.long	a_stsweep	; 15 - sweep kick
	.long	a_stsweepfall	; 16 - sweep fall
	.long	a_stsweepup	; 17 - getup from sweep kick
	.long	a_stduckpunch	; 18 - duck punch
	.long	a_stduckkickh	; 19 - duck kick high
	.long	a_stduckkickl	; 1a - duck kick low
	.long	a_stduckhit	; 1b - hit while ducking
	.long	a_stuppercut	; 1c - uppercut
	.long	a_stjumpupkick	; 1d - jump straight up kick
	.long	a_stflipkick	; 1e - flip kick
	.long	a_stflippunch	; 1f - flip punch
	.long	a_stroundh	; 20 - roundhouse kick
	.long	a_stknee	; 21 - knee
	.long	a_stelbow	; 22 - elbow
	.long	a_ststumble	; 23 - stumble back
	.long	a_stbodyslam	; 24 - body slam
	.long	a_shredded	; 25 -
	.long	a_stzap		; 26 - lk throwing fireball hi
	.long	a_stprojani	; 27 - fireball ani
	.long	a_ststunned	; 28 - stunned
	.long	a_stvictory	; 29 - victory

	.long	a_st_fb_hh	; 2a - shang tsung flipped by hatheat
	.long	a_st_fb_lk	; 2b - shang tsung flipped by liu kang
	.long	a_st_fb_jc	; 2c - shang tsung flipped by cage
	.long	a_st_fb_sa	; 2d - shang tsung flipped by sa
	.long	a_st_fb_fn	; 2e - shang tsung flipped by female ninja
	.long	a_st_fb_fn	; 2f - shang tsung flipped by female ninja
	.long	a_st_fb_st	; 30 - shang tsung flipped by shang tsung
	.long	a_st_fb_rd	; 31 - shang tsung flipped by raiden
	.long	a_st_fb_nj	; 32 - shang tsung flipped by ninja
	.long	a_st_fb_nj	; 33 - shang tsung flipped by ninja
	.long	a_st_fb_nj	; 34 - shang tsung flipped by ninja
	.long	a_st_fb_jx	; 35 - shang tsung flipped by jax

	.long	a_nutcrunched	; 36 - ouch
	.long	a_bike_kicked	; 37 - bicycle kicked
	.long	a_drained	; 38 - drained of my soul by shang tsung
	.long	a_torso_ripped	; 39 - torso ripped
	.long	a_banged	; 3a - banged by slow proj
	.long	a_impaled	; 3b - impaled
	.long	a_decapfall	; 3c - decapitated dude fall
	.long	a_head		; 3d - decapitated head
	.long	a_fb_goro	; 3e - flipped by goro's evil twin
	.long	a_back_broke	; 3f - back getting broken
	.long	0
	.long	a_swipe_torso	; 41 - scorpion swiped me torso




st_anitab2
	.long	a_st_2_hh	; 0 - shang tsung morph into kung lao
	.long	a_st_2_lk	; 1 - shang tsung morph into liu kang
	.long	a_st_2_jc	; 2 - shang tsung morph into cage
	.long	a_st_2_sa	; 3 - shang tsung morph into
	.long	a_st_2_fn1	; 4 - shang tsung morph into
	.long	a_st_2_fn2	; 5 - shang tsung morph into
	.long	dummy		; 6 - shang tsung morph into
	.long	a_st_2_rd	; 7 - shang tsung morph into
	.long	a_st_2_sz 	; 8 - subzero
	.long	a_st_2_rp 	; 9 - reptile
	.long	a_st_2_sc	; a - scorpion
	.long	a_st_2_jx	; b - shang tsung --> jax
	.long	a_st_drain	; c
	.long	a_burst		; d

dummy
a_ststance
	.long	STSTANCE1
	.long	STSTANCE2
	.long	STSTANCE3
	.long	STSTANCE4
	.long	STSTANCE5
	.long	STSTANCE6
	.long	STSTANCE7
	.long	ani_jump,a_ststance

STSTANCE1
	.long	STSTANCE1A,STSTANCE1B,0
STSTANCE2
	.long	STSTANCE2A,STSTANCE2B,0
STSTANCE3
	.long	STSTANCE3A,STSTANCE3B,0
STSTANCE4
	.long	STSTANCE4A,STSTANCE4B,0
STSTANCE5
	.long	STSTANCE5A,STSTANCE5B,0
STSTANCE6
	.long	STSTANCE6A,STSTANCE6B,0
STSTANCE7
	.long	STSTANCE7A,STSTANCE7B,0

;*************************************************************************

a_stwalkf
	.long	STWALK1
	.long	STWALK2
	.long	STWALK3
	.long	STWALK4
	.long	STWALK5
	.long	STWALK6
	.long	STWALK7
	.long	STWALK8
	.long	STWALK9
	.long	ani_jump,a_stwalkf

a_stskipf
	.long	STWALK1
	.long	STWALK2
	.long	STWALK8
	.long	STWALK9
	.long	0

a_stwalkb
	.long	STWALK9
	.long	STWALK8
	.long	STWALK7
	.long	STWALK6
	.long	STWALK5
	.long	STWALK4
	.long	STWALK3
	.long	STWALK2
	.long	STWALK1
	.long	ani_jump,a_stwalkb

a_stskipb
	.long	STWALK9
	.long	STWALK8
	.long	STWALK2
	.long	STWALK1
	.long	0

STWALK1	.long	STWALKLEG1A,STWALKLEG1B,STWALKTORSO1A,STWALKTORSO1B,0
STWALK2	.long	STWALKLEG2A,STWALKLEG2B,STWALKTORSO2A,STWALKTORSO2B,0
STWALK3	.long	STWALKLEG3A,STWALKTORSO3A,STWALKTORSO3B,0
STWALK4	.long	STWALKLEG4A,STWALKLEG4B,STWALKTORSO4A,STWALKTORSO4B,0
STWALK5	.long	STWALKLEG5A,STWALKLEG5B,STWALKTORSO5A,STWALKTORSO5B,0
STWALK6	.long	STWALKLEG6A,STWALKLEG6B,STWALKTORSO6A,STWALKTORSO6B,0
STWALK7	.long	STWALKLEG7A,STWALKLEG7B,STWALKTORSO7A,STWALKTORSO7B,0
STWALK8	.long	STWALKLEG8A,STWALKLEG8B,STWALKTORSO8A,STWALKTORSO8B,0
STWALK9	.long	STWALKLEG9A,STWALKLEG9B,STWALKTORSO9A,STWALKTORSO9B,0

;************************************************************************

a_stduck  
	.long	STDUCK1
	.long	STDUCK2
	.long	STDUCK3
	.long	0

STDUCK1	.long	STDUCK1A,STDUCK1B,0
STDUCK2	.long	STDUCK2A,STDUCK2B,0
STDUCK3	.long	STDUCK3A,STDUCK3B,0

;************************************************************************

a_stjumpup
	.long	STJUMP2
	.long	STJUMP3
	.long	0
	.long	STJUMP2
	.long	STJUMP1
	.long	0

STJUMP1	.long	STJUMP1A,STJUMP1B,0
STJUMP2	.long	STJUMP2A,STJUMP2B,0
STJUMP3	.long	STJUMP3A,STJUMP3B,0

;************************************************************************

a_stfflip
	.long	STJUMPFLIP1
	.long	STJUMPFLIP2
	.long	STJUMPFLIP3
	.long	STJUMPFLIP4
	.long	STJUMPFLIP5
	.long	STJUMPFLIP6
	.long	STJUMPFLIP7
	.long	STJUMPFLIP8
	.long	ani_jump,a_stfflip+32

STJUMPFLIP1
	.long	STJUMPFLIP1A,STJUMPFLIP1B,0
STJUMPFLIP2
	.long	STJUMPFLIP2A,0
STJUMPFLIP3
	.long	STJUMPFLIP3A,0
STJUMPFLIP4
	.long	STJUMPFLIP4A,STJUMPFLIP4B,0
STJUMPFLIP5
	.long	STJUMPFLIP5A,STJUMPFLIP5B,0
STJUMPFLIP6
	.long	STJUMPFLIP6A,0
STJUMPFLIP7
	.long	STJUMPFLIP7A,0
STJUMPFLIP8
	.long	STJUMPFLIP8A,STJUMPFLIP8B,0


;************************************************************************

a_stbflip
	.long	STJUMPFLIP1

	.long	STJUMPFLIP8
	.long	STJUMPFLIP7
	.long	STJUMPFLIP6
	.long	STJUMPFLIP5
	.long	STJUMPFLIP4
	.long	STJUMPFLIP3
	.long	STJUMPFLIP2
	.long	ani_jump,a_stbflip+32

;************************************************************************

a_stturn
	.long	STTURN1
	.long	STTURN2

	.long	ani_flip  
	.long	ani_adjustx
	.word	4
	.long	STTURN1
	.long	0

STTURN1	.long	STTURN1A,STTURN1B,0
STTURN2	.long	STTURN2A,STTURN2B,0

;************************************************************************

a_stduckturn
	.long	STDUCKTURN1
	.long	STDUCKTURN2
	.long	ani_flip  
	.long	STDUCKTURN1
	.long	STDUCK3
	.long	0

STDUCKTURN1
	.long	STDUCKTURN1A,STDUCKTURN1B,0
STDUCKTURN2
	.long	STDUCKTURN2A,STDUCKTURN2B,0

;************************************************************************

a_stblockhi
	.long	STBLOCK1
	.long	STBLOCK2
	.long	STBLOCK3
	.long	0
	.long	STBLOCK2
	.long	STBLOCK1
	.long	0

STBLOCK1	.long	STBLOCK1A,STBLOCK1B,0
STBLOCK2	.long	STBLOCK2A,STBLOCK2B,STBLOCK2C,0
STBLOCK3	.long	STBLOCK3A,STBLOCK3B,0

;************************************************************************

a_stduckblock
	.long	STDUCKBLOCK1
	.long	STDUCKBLOCK2
	.long	STDUCKBLOCK3
	.long	0
	.long	STDUCKBLOCK2
	.long	STDUCKBLOCK1
	.long	STDUCK3
	.long	0

STDUCKBLOCK1
	.long	STDUCKBLOCK1A,STDUCKBLOCK1B,0
STDUCKBLOCK2
	.long	STDUCKBLOCK2A,STDUCKBLOCK2B,STDUCKBLOCK2C,0
STDUCKBLOCK3
	.long	STDUCKBLOCK3A,STDUCKBLOCK3B,STDUCKBLOCK3C,0

;************************************************************************

a_sthikick
	.long	STHIKICK1
	.long	STHIKICK2
	.long	STHIKICK3
	.long	STHIKICK4
	.long	STHIKICK5
	.long	STHIKICK6
	.long	0
	.long	STHIKICK5
	.long	STHIKICK4
	.long	STHIKICK3
	.long	STHIKICK2
	.long	STHIKICK1
	.long	0

STHIKICK1
	.long	STHIKICK1A,STHIKICK1B,0
STHIKICK2
	.long	STHIKICK2A,0
STHIKICK3
	.long	STHIKICK3A,STHIKICK3B,0
STHIKICK4
	.long	STHIKICK4A,STHIKICK4B,0
STHIKICK5
	.long	STHIKICK5A,STHIKICK5B,STHIKICK5C,0
STHIKICK6
	.long	STHIKICK6A,STHIKICK6B,0

;************************************************************************

a_stlokick
	.long	STHIKICK1
	.long	STHIKICK2
	.long	STHIKICK3
	.long	STHIKICK4
	.long	STHIKICK5
	.long	STLOKICK1
	.long	0
	.long	STHIKICK5
	.long	STHIKICK4
	.long	STHIKICK3
	.long	STHIKICK2
	.long	STHIKICK1
	.long	0

STLOKICK1
	.long	STLOKICK1A,STLOKICK1B,0

;************************************************************************

a_stkdown
	.long	STKNOCKDOWN1
	.long	STKNOCKDOWN2
	.long	STKNOCKDOWN3
	.long	STKNOCKDOWN4
	.long	STKNOCKDOWN5
	.long	0
*
* part 2 = landing on back
*
	.long	STKNOCKDOWN6
	.long	STKNOCKDOWN7
	.long	0
*
* part 3 = shake on the ground
*
	.long	STKNOCKDOWN6
	.long	STKNOCKDOWN7
	.long	STKNOCKDOWN6
	.long	STKNOCKDOWN7
	.long	0

STKNOCKDOWN1
	.long	STKNOCKDOWN1A,STKNOCKDOWN1B,STKNOCKDOWN1C,STKNOCKDOWN1D,0
STKNOCKDOWN2
	.long	STKNOCKDOWN2A,STKNOCKDOWN2B,STKNOCKDOWN2C,STKNOCKDOWN2D,0
STKNOCKDOWN3
	.long	STKNOCKDOWN3A,STKNOCKDOWN3B,0
STKNOCKDOWN4
	.long	STKNOCKDOWN4A,STKNOCKDOWN4B,0
STKNOCKDOWN5
	.long	STKNOCKDOWN5A,STKNOCKDOWN5B,0
STKNOCKDOWN6
	.long	STKNOCKDOWN6A,STKNOCKDOWN6B,STKNOCKDOWN6C,0
STKNOCKDOWN7
	.long	STKNOCKDOWN7A,0

;************************************************************************

a_sthithi
	.long	STHITHI2
	.long	STHITHI3
	.long	STHITHI2
	.long	STHITHI1
	.long	0

STHITHI1	.long	STHITHI1A,STHITHI1B,0
STHITHI2	.long	STHITHI2A,STHITHI2B,0
STHITHI3	.long	STHITHI3A,STHITHI3B,0

;************************************************************************

a_sthitlo
	.long	STLOHIT2
	.long	STLOHIT3
	.long	STLOHIT2
	.long	STLOHIT1
	.long	0

STLOHIT1	.long	STLOHIT1A,STLOHIT1B,0
STLOHIT2	.long	STLOHIT2A,STLOHIT2B,0
STLOHIT3	.long	STLOHIT3A,STLOHIT3B,0

;************************************************************************

a_stgetup
	.long	STGETUP1
	.long	STGETUP2
	.long	STGETUP3
	.long	STGETUP4
	.long	STGETUP5
	.long	0

STGETUP1	.long	STGETUP1A,STGETUP1B,0
STGETUP2	.long	STGETUP2A,STGETUP2B,0
STGETUP3	.long	STGETUP3A,STGETUP3B,0
STGETUP4	.long	STGETUP4A,STGETUP4B,0
STGETUP5	.long	STGETUP5A,STGETUP5B,0

;************************************************************************

a_sthipunch
	.long	STHIPUNCH1
	.long	STHIPUNCH2
	.long	STHIPUNCH3
	.long	0

	.long	STHIPUNCH4
	.long	STHIPUNCH5
	.long	STHIPUNCH6
	.long	0

	.long	STHIPUNCH5
	.long	STHIPUNCH4
	.long	ani_jump,a_sthipunch+(32*2)
	.long	0					; we NEED this "0"
*
* Unhipunch #1
*
	.long	STHIPUNCH2
	.long	STHIPUNCH1
	.long	0
*
* Unhipunch #2
*
	.long	STHIPUNCH7
	.long	0
*
* Hi to Med #1
*
	.long	STHIPUNCH4
	.long	STLOPUNCH1
	.long	ani_jump,a_stlopunch+(32*6)
	.long	0
*
* Hi to Med #2
*
	.long	STHIPUNCH5
	.long	STHIPUNCH4
	.long	ani_jump,a_stlopunch+(32*2)
	.long	0



a_stlopunch
	.long	STHIPUNCH1
	.long	STHIPUNCH2
	.long	STLOPUNCH1
	.long	0

	.long	STHIPUNCH4
	.long	STHIPUNCH5
	.long	STLOPUNCH2
	.long	0

	.long	STHIPUNCH5
	.long	STHIPUNCH4
	.long	ani_jump,a_stlopunch+(32*2)
	.long	0
*
* Unlopunch #1
*
	.long	STHIPUNCH2
	.long	STHIPUNCH1
	.long	0
*
* Unlopunch #2
*
	.long	STHIPUNCH7
	.long	0
*
* Med to High #1
*
	.long	STHIPUNCH4
	.long	STHIPUNCH5
	.long	ani_jump,a_sthipunch+(32*6)
	.long	0
*
* Med to High #2
*
	.long	STHIPUNCH5
	.long	STHIPUNCH4
	.long	ani_jump,a_sthipunch+(32*2)

STHIPUNCH1
	.long	STHIPUNCH1A,STHIPUNCH1B,0
STHIPUNCH2
	.long	STHIPUNCH2A,STHIPUNCH2B,STHIPUNCH2C,0
STHIPUNCH3
	.long	STHIPUNCH3A,STHIPUNCH3B,STHIPUNCH3C,0
STHIPUNCH4
	.long	STHIPUNCH4A,STHIPUNCH4B,STHIPUNCH4C,0
STHIPUNCH5
	.long	STHIPUNCH5A,STHIPUNCH5B,STHIPUNCH5C,0
STHIPUNCH6
	.long	STHIPUNCH6A,STHIPUNCH6B,STHIPUNCH6C,0
STHIPUNCH7
	.long	STHIPUNCH7A,STHIPUNCH7B,STHIPUNCH7C,0
STLOPUNCH1
	.long	STLOPUNCH1A,STLOPUNCH1B,STLOPUNCH1C,0
STLOPUNCH2
	.long	STLOPUNCH2A,STLOPUNCH2B,0

;************************************************************************

a_stsweep
	.long	STDUCK1
	.long	STSWEEPKICK1
	.long	STSWEEPKICK2
	.long	ani_calla,sweep_sounds
	.long	STSWEEPKICK3
	.long	0
	.long	STSWEEPKICK4
	.long	STSWEEPKICK5
	.long	STSWEEPKICK6
	.long	0

STSWEEPKICK1
	.long	STSWEEPKICK1A,STSWEEPKICK1B,0
STSWEEPKICK2
	.long	STSWEEPKICK2A,STSWEEPKICK2B,0
STSWEEPKICK3
	.long	STSWEEPKICK3A,STSWEEPKICK3B,STSWEEPKICK3C,0
STSWEEPKICK4
	.long	STSWEEPKICK4A,STSWEEPKICK4B,STSWEEPKICK4C,STSWEEPKICK4D,0
STSWEEPKICK5
	.long	STSWEEPKICK5A,STSWEEPKICK5B,0
STSWEEPKICK6
	.long	STSWEEPKICK6A,STSWEEPKICK6B,0

;************************************************************************

a_stsweepfall
	.long	STSWEEPFALL1
	.long	STSWEEPFALL2
	.long	STSWEEPFALL3
	.long	STSWEEPFALL4
	.long	STSWEEPFALL5
	.long	0
	.long	STSWEEPFALL6
	.long	0

STSWEEPFALL1
	.long	STSWEEPFALL1A,STSWEEPFALL1B,STSWEEPFALL1C,0
STSWEEPFALL2
	.long	STSWEEPFALL2A,STSWEEPFALL2B,STSWEEPFALL2C,STSWEEPFALL2D,0
STSWEEPFALL3
	.long	STSWEEPFALL3A,STSWEEPFALL3B,STSWEEPFALL3C,0
STSWEEPFALL4
	.long	STSWEEPFALL4A,STSWEEPFALL4B,STSWEEPFALL4C,0
STSWEEPFALL5
	.long	STSWEEPFALL5A,0
STSWEEPFALL6
	.long	STSWEEPFALL6A,STSWEEPFALL6B,0

;************************************************************************

a_stsweepup
	.long	STSWEEPUP1
	.long	STSWEEPUP2
	.long	STSWEEPUP3
	.long	STSWEEPUP4
	.long	STSWEEPUP5
	.long	0

STSWEEPUP1
	.long	STSWEEPUP1A,STSWEEPUP1B,0
STSWEEPUP2
	.long	STSWEEPUP2A,STSWEEPUP2B,0
STSWEEPUP3
	.long	STSWEEPUP3A,STSWEEPUP3B,0
STSWEEPUP4
	.long	STSWEEPUP4A,STSWEEPUP4B,0
STSWEEPUP5
	.long	STSWEEPUP5A,STSWEEPUP5B,0

;************************************************************************

a_stduckpunch
	.long	STDUCKPUNCH1
	.long	STDUCKPUNCH2
	.long	STDUCKPUNCH3
	.long	0
	.long	STDUCKPUNCH2
	.long	STDUCKPUNCH1
	.long	STDUCK3
	.long	0


STDUCKPUNCH1
	.long	STDUCKPUNCH1A,STDUCKPUNCH1B,0
STDUCKPUNCH2
	.long	STDUCKPUNCH2A,STDUCKPUNCH2B,0
STDUCKPUNCH3
	.long	STDUCKPUNCH3A,STDUCKPUNCH3B,STDUCKPUNCH3C,0

;************************************************************************

a_stduckkickl
	.long	STDUCKICKLO1
	.long	ani_calla,kick_sounds
	.long	STDUCKICKLO3
	.long	STDUCKICKLO4
	.long	STDUCKICKLO5
	.long	0
	.long	STDUCKICKLO4
	.long	STDUCKICKLO3
	.long	STDUCKICKLO2
	.long	STDUCKICKLO1
	.long	STDUCK3
	.long	0


a_stduckkickh
;	.long	STDUCKICKLO1

	.long	STDUCKICKLO2
	.long	ani_calla,kick_sounds
	.long	STDUCKICKLO3
	.long	STDUCKICKHI1
	.long	STDUCKICKHI2
	.long	0
	.long	STDUCKICKHI1
	.long	STDUCKICKLO3
	.long	STDUCKICKLO2
	.long	STDUCKICKLO1
	.long	STDUCK3
	.long	0


STDUCKICKLO1
	.long	STDUCKICKLO1A,STDUCKICKLO1B,0
STDUCKICKLO2
	.long	STDUCKICKLO2A,STDUCKICKLO2B,STDUCKICKLO2C,0
STDUCKICKLO3
	.long	STDUCKICKLO3A,STDUCKICKLO3B,STDUCKICKLO3C,0
STDUCKICKLO4
	.long	STDUCKICKLO4A,STDUCKICKLO4B,STDUCKICKLO4C,0
STDUCKICKLO5
	.long	STDUCKICKLO5A,STDUCKICKLO5B,STDUCKICKLO5C,0

STDUCKICKHI1
	.long	STDUCKICKHI1A,STDUCKICKHI1B,0
STDUCKICKHI2
	.long	STDUCKICKHI2A,STDUCKICKHI2B,0

;************************************************************************

a_stduckhit
	.long	STDUCKHIT2
	.long	STDUCKHIT3
	.long	STDUCKHIT2
	.long	STDUCKHIT1
	.long	STDUCK3
	.long	0

STDUCKHIT1
	.long	STDUCKHIT1A,STDUCKHIT1B,0
STDUCKHIT2
	.long	STDUCKHIT2A,STDUCKHIT2B,0
STDUCKHIT3
	.long	STDUCKHIT3A,STDUCKHIT3B,0

;************************************************************************

a_stuppercut
	.long	STUPPERCUT2
	.long	STUPPERCUT3
	.long	STUPPERCUT4
	.long	STUPPERCUT5
	.long	ani_nosleep	; dont sleep after next frame
	.long	STUPPERCUT6
	.long	0

	.long	STHIPUNCH2
	.long	STHIPUNCH1
	.long	0

STUPPERCUT2
	.long	STUPPERCUT2A,STUPPERCUT2B,STUPPERCUT2C,0
STUPPERCUT3
	.long	STUPPERCUT3A,STUPPERCUT3B,STUPPERCUT3C,0
STUPPERCUT4
	.long	STUPPERCUT4A,STUPPERCUT4B,STUPPERCUT4C,0
STUPPERCUT5
	.long	STUPPERCUT5A,STUPPERCUT5B,STUPPERCUT5C,0
STUPPERCUT6
	.long	STUPPERCUT6A,STUPPERCUT6B,0

;************************************************************************

a_stjumpupkick
	.long	STJUMPKICK1
	.long	STJUMPKICK2
	.long	STJUMPKICK3
	.long	STJUMPKICK4
	.long	0
	.long	STJUMPKICK5
	.long	0

STJUMPKICK1
	.long	STJUMPKICK1A,STJUMPKICK1B,STJUMPKICK1C,STJUMPKICK1D,0
STJUMPKICK2
	.long	STJUMPKICK2A,STJUMPKICK2B,STJUMPKICK2C,0
STJUMPKICK3
	.long	STJUMPKICK3A,STJUMPKICK3B,STJUMPKICK3C,STJUMPKICK3D,0
STJUMPKICK4
	.long	STJUMPKICK4A,STJUMPKICK4B,STJUMPKICK4C,0
STJUMPKICK5
	.long	STJUMPKICK5A,STJUMPKICK5B,STJUMPKICK5C,0

;************************************************************************

a_stflipkick
	.long	STFLIPKICK1
	.long	STFLIPKICK2
	.long	STFLIPKICK3
	.long	0
	.long	STFLIPKICK2
	.long	STFLIPKICK1
	.long	0

STFLIPKICK1
	.long	STFLIPKICK1A,STFLIPKICK1B,0
STFLIPKICK2
	.long	STFLIPKICK2A,STFLIPKICK2B,0
STFLIPKICK3
	.long	STFLIPKICK3A,STFLIPKICK3B,STFLIPKICK3C,0

;************************************************************************

a_stflippunch
	.long	STFLIPUNCH1
	.long	STFLIPUNCH2
	.long	STFLIPUNCH3
	.long	0
	.long	STFLIPUNCH2
	.long	STFLIPUNCH1
	.long	0

STFLIPUNCH1
	.long	STFLIPUNCH1A,STFLIPUNCH1B,STFLIPUNCH1C,STFLIPUNCH1D,0
STFLIPUNCH2
	.long	STFLIPUNCH2A,STFLIPUNCH2B,0
STFLIPUNCH3
	.long	STFLIPUNCH3A,STFLIPUNCH3B,0

;************************************************************************

a_stroundh
	.long	STROUNDKIK1
	.long	STROUNDKIK2
	.long	STROUNDKIK3
	.long	STROUNDKIK4
	.long	0
	.long	STROUNDKIK5
	.long	STROUNDKIK6
	.long	STROUNDKIK7
	.long	0

STROUNDKIK1
	.long	STROUNDKIK1A,STROUNDKIK1B,0
STROUNDKIK2
	.long	STROUNDKIK2A,STROUNDKIK2B,0
STROUNDKIK3
	.long	STROUNDKIK3A,STROUNDKIK3B,STROUNDKIK3C,0
STROUNDKIK4
	.long	STROUNDKIK4A,STROUNDKIK4B,STROUNDKIK4C,0
STROUNDKIK5
	.long	STROUNDKIK5A,0
STROUNDKIK6
	.long	STROUNDKIK6A,STROUNDKIK6B,0
STROUNDKIK7
	.long	STROUNDKIK7A,STROUNDKIK7B,0

;************************************************************************

a_stknee
	.long	STKNEE1
	.long	STKNEE2
	.long	STKNEE3
	.long	0
	.long	STKNEE2
	.long	STKNEE1
	.long	0

STKNEE1	.long	STKNEE1A,STKNEE1B,0
STKNEE2	.long	STKNEE2A,0
STKNEE3	.long	STKNEE3A,STKNEE3B,STKNEE3C,0

;************************************************************************

a_stelbow
	.long	STELBO3
	.long	STELBO4
	.long	STELBO5
	.long	0
	.long	STELBO4
	.long	STELBO3
	.long	0

	.long	STELBO3
	.long	STELBO4
	.long	STELBO5
	.long	0
	.long	STELBO4
	.long	0

STELBO1	.long	STELBO1A,0
STELBO2	.long	STELBO2A,STELBO2B,0
STELBO3	.long	STELBO3A,STELBO3B,0
STELBO4	.long	STELBO4A,STELBO4B,0
STELBO5	.long	STELBO5A,STELBO5B,0

;************************************************************************

a_ststumble
	.long	STSTUMBLE1
	.long	STSTUMBLE2
	.long	STSTUMBLE3
	.long	STSTUMBLE4
	.long	STSTUMBLE5
	.long	STSTUMBLE6
	.long	0

STSTUMBLE1
	.long	STSTUMBLE1A,STSTUMBLE1B,0
STSTUMBLE2
	.long	STSTUMBLE2A,STSTUMBLE2B,STSTUMBLE2C,STSTUMBLE2D,0
STSTUMBLE3
	.long	STSTUMBLE3A,STSTUMBLE3B,STSTUMBLE3C,0
STSTUMBLE4
	.long	STSTUMBLE4A,0
STSTUMBLE5
	.long	STSTUMBLE5A,STSTUMBLE5B,STSTUMBLE5C,STSTUMBLE5D,0
STSTUMBLE6
	.long	STSTUMBLE6A,STSTUMBLE6B,0

;************************************************************************

a_stbodyslam
	.long	STFLIP1
	.long	STFLIP2
	.long	0

	.long	STFLIP3
	.long	STFLIP4
	.long	STFLIP5
	.long	STFLIP6
	.long	0

	.long	STFLIP7
	.long	0

STFLIP1	.long	STFLIP1A,0
STFLIP2	.long	STFLIP2A,STFLIP2B,0
STFLIP3	.long	STFLIP3A,STFLIP3B,STFLIP3C,0
STFLIP4	.long	STFLIP4A,STFLIP4B,STFLIP4C,0
STFLIP5	.long	STFLIP5A,STFLIP5B,0
STFLIP6	.long	STFLIP6A,STFLIP6B,0
STFLIP7	.long	STFLIP7A,STFLIP7B,0

;************************************************************************

a_shredded
	.long	ani_adjustxy
	.word	6,6
	.long	STSTUMBLE1

	.long	ani_adjustxy
	.word	-6,-6
	.long	STSTUMBLE2

	.long	ani_adjustxy
	.word	6,6
	.long	STSTUMBLE3

	.long	ani_adjustxy
	.word	-6,-6
	.long	STSTUMBLE2

	.long	ani_jump,a_shredded

;************************************************************************

a_stzap
	.long	STTHROW1
	.long	STTHROW2
	.long	STTHROW3
	.long	0

STTHROW1	.long	STTHROW1A,STTHROW1B,0
STTHROW2	.long	STTHROW2A,STTHROW2B,STTHROW2C,0
STTHROW3	.long	STTHROW3A,STTHROW3B,STTHROW3C,0

;************************************************************************

a_stprojani
	.long	skullball1
	.long	skullball2
	.long	skullball3
	.long	skullball4
	.long	0
	.long	skullball5
	.long	skullball6
	.long	skullball7

j_skull	.long	skullball8
	.long	skullball9
	.long	ani_jump,j_skull

skullball1
	.LONG	SKULLBALL1,0
skullball2
	.LONG	SKULLBALL2,0
skullball3
	.LONG	SKULLBALL3,0
skullball4
	.LONG	SKULLBALL4,0
skullball5
	.LONG	SKULLBALL5,0
skullball6
	.LONG	SKULLBALL6,0
skullball7
	.LONG	SKULLBALL7,0
skullball8
	.LONG	SKULLBALL8,0
skullball9
	.LONG	SKULLBALL9,0

;************************************************************************

a_ststunned
	.long	STSTUNNED1
	.long	STSTUNNED2
	.long	STSTUNNED3
	.long	STSTUNNED4
	.long	STSTUNNED5
	.long	STSTUNNED6
	.long	STSTUNNED7
	.long	ani_jump,a_ststunned

STSTUNNED1
	.long	STSTUNNED1A,STSTUNNED1B,0
STSTUNNED2
	.long	STSTUNNED2A,STSTUNNED2B,0
STSTUNNED3
	.long	STSTUNNED3A,STSTUNNED3B,0
STSTUNNED4
	.long	STSTUNNED4A,STSTUNNED4B,0
STSTUNNED5
	.long	STSTUNNED5A,STSTUNNED5B,0
STSTUNNED6
	.long	STSTUNNED6A,STSTUNNED6B,0
STSTUNNED7
	.long	STSTUNNED7A,STSTUNNED7B,0

;************************************************************************

a_stvictory
	.long	STVIC1
	.long	STVIC1
	.long	STVIC1
	.long	STVIC1

j_vic	.long	STVIC2
	.long	STVIC3
	.long	STVIC4
	.long	STVIC5
	.long	STVIC4
	.long	STVIC3
	.long	ani_jump,j_vic

STVIC1	.long	STDEATHBLO11B,STDEATHBLO11C,STDEATHBLO11A,0

STVIC2	.long	STDEATHBLO11B,STDEATHBLO11C
	.long	STDEATHBLO12A,STDEATHBLO12B,STDEATHBLO12C,STDEATHBLO12D,0

STVIC3	.long	STDEATHBLO11B,STDEATHBLO11C
	.long	STDEATHBLO13A,STDEATHBLO13B,STDEATHBLO13C,STDEATHBLO13D,0

STVIC4  	.long	STDEATHBLO11B,STDEATHBLO11C
	.long	STDEATHBLO14A,STDEATHBLO14B,STDEATHBLO14C,STDEATHBLO14D,0

STVIC5  	.long	STDEATHBLO11B,STDEATHBLO11C
	.long	STDEATHBLO15A,STDEATHBLO15B,STDEATHBLO15C,STDEATHBLO15D,0

;************************************************************************

a_st_fb_hh
	.long	ani_adjustxy
	.word	->46,0		; we need even # of words here !
	.long	STSTUMBLE1
	.long	0

	.long	ani_flip
	.long	STSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>60,->30
	.long	STFLIPPED2
	.long	STFLIPPED3
	.long	STFLIPPED4
	.long	0

;************************************************************************

a_st_fb_lk
	.long	ani_adjustxy
	.word	->40,>00
	.long	STSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	>1b,>08
	.long	STFLIPPED1

	.long	ani_adjustxy
	.word	>1f,>06
	.long	STFLIPPED2

	.long	ani_adjustxy
	.word	>18,>00
	.long	STFLIPPED2

	.long	ani_adjustxy
	.word	>3a,->18
	.long	STFLIPPED3

	.long	ani_adjustxy
	.word	>20,->10
	.long	STFLIPPED4
	.long	0
*
* land on the ground
*
	.long	STKNOCKDOWN6
	.long	STKNOCKDOWN7
	.long	STKNOCKDOWN6
	.long	STKNOCKDOWN7
	.long	0

;**************************************************************************

a_st_fb_nj
	.long	ani_adjustxy
	.word	->40,>00
	.long	STSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	>04,>00
	.long	STSTUMBLE4

	.long	ani_adjustxy
	.word	>1f,>06
	.long	STFLIPPED2

	.long	ani_adjustxy
	.word	>18,>00
	.long	STFLIPPED2

	.long	ani_adjustxy
	.word	>3a,->18
	.long	STFLIPPED3

	.long	ani_adjustxy
	.word	>20,->10
	.long	STFLIPPED4
	.long	0
*
* land on the ground
*
	.long	STKNOCKDOWN6
	.long	STKNOCKDOWN7
	.long	STKNOCKDOWN6
	.long	STKNOCKDOWN7
	.long	0

;************************************************************************

a_st_fb_jx
	.long	ani_adjustxy
	.word	->46,>00
	.long	STSTUMBLE1
	.long	STSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>04,->38
	.long	STFLIPPED1	; jax 3

	.long	ani_adjustxy
	.word	>2f,->18
	.long	STFLIPPED2	; jax 4

	.long	ani_adjustxy
	.word	>38,>00
	.long	STFLIPPED3	; jax 5

	.long	ani_adjustxy
	.word	>25,>40
	.long	STFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	>00,>10
	.long	STKNOCKDOWN7	; jax 7
	.long	0
*
* slammed again !
*
	.long	ani_adjustxy
	.word	>00,->10
	.long	STFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	->10,->46
	.long	STFLIPPED4	; jax 6

	.long	ani_flip
	.long	ani_adjustxy
	.word	>4a,->18
	.long	STFLIPPED3	; jax 4

	.long	ani_adjustxy
	.word	>34,>18
	.long	STFLIPPED4	; jax 3

	.long	ani_adjustxy
	.word	>08,>46
	.long	STFLIPPED4

	.long	ani_adjustxy
	.word	->10,>10
	.long	STKNOCKDOWN7	; jax 7
	.long	0

;************************************************************************

a_st_fb_jc
	.long	ani_adjustxy
	.word	->40,>00
	.long	STSTUMBLE4
	.long	STSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	>13,->10
	.long	STFLIPPED1

	.long	ani_adjustxy
	.word	>68,->08
	.long	STFLIPPED3

	.long	ani_adjustxy
	.word	>20,>42
	.long	STFLIPPED4
	.long	0

;************************************************************************

a_st_fb_sa
	.long	ani_adjustxy
	.word	->40,>00
	.long	STSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	>0f,->28
	.long	STFLIPPED1

	.long	ani_adjustxy
	.word	>2a,->20
	.long	STFLIPPED2

	.long	ani_adjustxy
	.word	>3f,->20
	.long	STFLIPPED3
	.long	0

;************************************************************************

a_st_fb_fn
	.long	ani_adjustxy
	.word	->40,->10
	.long	ani_flip
	.long	STSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	->20,>60
	.long	ani_flip_v
	.long	ani_flip
	.long	STFLIPPED3

	.long	ani_adjustxy
	.word	>38,->08
	.long	STFLIPPED3

	.long	ani_adjustxy
	.word	>30,->68
	.long	ani_flip
	.long	ani_flip_v
	.long	STFLIPPED3

	.long	ani_adjustxy
	.word	->10,>30
	.long	STFLIPPED3

	.long	ani_adjustxy
	.word	->10,->10
	.long	STKNOCKDOWN5
	.long	0
*
* bounce on ground
*
	.long	STKNOCKDOWN5
	.long	0

;************************************************************************

a_st_fb_st
	.long	ani_adjustxy
	.word	->40,>00
	.long	STSTUMBLE5
	.long	STSTUMBLE5
	.long	0

	.long	ani_adjustxy
	.word	>10,->30
	.long	STFLIPPED1
	.long	ani_adjustxy
	.word	>38,->10
	.long	STFLIPPED2
	.long	ani_adjustxy
	.word	>38,>20
	.long	STFLIPPED3
	.long	ani_adjustxy
	.word	>18,>38
	.long	STFLIPPED4
	.long	0

	.long	ani_adjustxy
	.word	>20,>00
	.long	STKNOCKDOWN6
	.long	0

;************************************************************************

a_st_fb_rd
	.long	ani_adjustxy
	.word	->4c,>00
	.long	STSTUMBLE5
	.long	0

	.long	ani_adjustxy
	.word	>0a,->2f
	.long	STFLIPPED1

	.long	ani_flip
	.long	ani_adjustxy
	.word	->34,->60
	.long	STKNOCKDOWN6
	.long	STKNOCKDOWN6

	.long	ani_flip
	.long	ani_flip_v
	.long	ani_adjustxy
	.word	>0a,>f0
	.long	STFLIPPED2

	.long	ani_adjustxy
	.word	>38,>40
	.long	STFLIPPED2
	.long	0

	.long	ani_adjustxy
	.word	>18,>10
	.long	ani_flip
	.long	STKNOCKDOWN6
	.long	0

;************************************************************************

a_banged
	.long	STFLIPPED1
	.long	STFLIPPED2
	.long	STFLIPPED3
	.long	STFLIPPED4
	.long	0

STFLIPPED1
	.long	STFLIPPED1A,0
STFLIPPED2
	.long	STFLIPPED2A,STFLIPPED2B,0
STFLIPPED3
	.long	STFLIPPED3A,0
STFLIPPED4
	.long	STFLIPPED4A,STFLIPPED4B,0

;************************************************************************

a_nutcrunched
	.long	STNUT1
	.long	STNUT2
	.long	0
	.long	STNUT1
	.long	0

STNUT1	.long	STNUTCRUNCH1A,STNUTCRUNCH1B,0
STNUT2	.long	STNUTCRUNCH2A,STNUTCRUNCH2B,0

;************************************************************************

a_bike_kicked
	.long	STSTUMBLE1
	.long	STSTUMBLE2
	.long	STSTUMBLE3
	.long	STSTUMBLE4
	.long	STSTUMBLE5
	.long	STSTUMBLE6
	.long	ani_jump,a_bike_kicked

;************************************************************************


;STROUNDPUNCH1
;	.long	STROUNDPUNCH1A,STROUNDPUNCH1B,0
;STROUNDPUNCH2
;	.long	STROUNDPUNCH2A,STROUNDPUNCH2B,STROUNDPUNCH2C,0
;STROUNDPUNCH3
;	.long	STROUNDPUNCH3A,STROUNDPUNCH3B,STROUNDPUNCH3C,0
;STROUNDPUNCH4
;	.long	STROUNDPUNCH4A,STROUNDPUNCH4B,STROUNDPUNCH4C,0
;STROUNDPUNCH5
;	.long	STROUNDPUNCH5A,STROUNDPUNCH5B,0



a_st_drain
	.long	STDEATHBLO1
	.long	STDEATHBLO2
	.long	0

	.long	STDEATHBLO3
	.long	STDEATHBLO4
	.long	STDEATHBLO6
	.long	STDEATHBLO7
	.long	0

	.long	STDEATHBLO8
	.long	STDEATHBLO9
	.long	STDEATHBLO10
	.long	0

STDEATHBLO1
	.long	STDEATHBLO1A,STDEATHBLO1B,0
STDEATHBLO2
	.long	STDEATHBLO2A,STDEATHBLO2B,STDEATHBLO2C,0
STDEATHBLO3
	.long	STDEATHBLO3A,STDEATHBLO3B,STDEATHBLO3C,0
STDEATHBLO4
	.long	STDEATHBLO4A,STDEATHBLO4B,STDEATHBLO4C,0
STDEATHBLO5
	.long	STDEATHBLO5A,STDEATHBLO5B,0
STDEATHBLO6
	.long	STDEATHBLO6A,STDEATHBLO6B,STDEATHBLO6C,0
STDEATHBLO7
	.long	STDEATHBLO7A,STDEATHBLO7B,STDEATHBLO7C,0
STDEATHBLO8
	.long	STDEATHBLO8A,STDEATHBLO8B,STDEATHBLO8C,STDEATHBLO8D,0
STDEATHBLO9
	.long	STDEATHBLO9A,STDEATHBLO9B,STDEATHBLO9C,0
STDEATHBLO10
	.long	STDEATHBLO10A,STDEATHBLO10B,0

**********************************************************************

a_burst
	.long	STBURST1
	.long	STBURST2
	.long	0

	.long	STBURST3
	.long	STBURST4
	.long	STBURST5
	.long	STBURST6
	.long	STBURST7
	.long	0
	.long	STBURST8
	.long	STBURST9
	.long	STBURST10
	.long	STBURST11
	.long	STBURST12
	.long	0

	.long	STBURST13
	.long	STBURST14
	.long	STBURST15
	.long	STBURST16
	.long	0

STBURST1	.long	STBURST1A,STBURST1B,0
STBURST2	.long	STBURST2A,STBURST2B,0
STBURST3	.long	STBURST3A,STBURST3B,0
STBURST4	.long	STBURST4A,STBURST4B,0
STBURST5	.long	STBURST5A,STBURST5B,0
STBURST6	.long	STBURST6A,STBURST6B,0
STBURST7	.long	STBURST7A,0
STBURST8	.long	STBURST8A,0
STBURST9	.long	STBURST9A,0
STBURST10
	.long	STBURST10A,0
STBURST11
	.long	STBURST11A,0
STBURST12
	.long	STBURST12A,0
STBURST13
	.long	STBURST13A,0
STBURST14
	.long	STBURST14A,0
STBURST15
	.long	STBURST15A,STBURST15B,STBURST15C,STBURST15D,0
STBURST16
	.long	STBURST16A,STBURST16B,STBURST16C,STBURST16D,0

;***********************************************************************

a_drained
	.long	ani_adjustxy
	.word	->4a,->13
	.long	STSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	->06,>18
	.long	STDRAIN0
	.long	ani_adjustxy
	.word	>13,->08
	.long	STDRAIN0
	.long	ani_adjustxy
	.word	>08,->14
	.long	STDRAIN0
	.long	ani_adjustxy
	.word	0,0
	.long	STDRAIN0
	.long	0

;******************************************************************

morph_swpal2
	jauc	player_normpal

	move	*a9(32),a0,l
	jruc	msp3

morph_swpal
	move	*a9,a0,l
msp3	move	*a0,a0,l
	move	*a0(icmap),a0,l
	jauc	player_swpal


a_st_2_rp
	.long	STSTANCE1
	.long	ani_calla,morph_swpal
	.long	STREPTILE1
	.long	STREPTILE2
	.long	STREPTILE3
;	.long	ani_calla,morph_swpal2
	.long	ani_nosleep			; dont sleep after next frame
	.long	NJ2STANCE1
	.long	0


a_st_2_fn1
	.long	STSTANCE1
	.long	ani_calla,morph_swpal
	.long	STBLUE1
	.long	STBLUE2
	.long	STBLUE3
;	.long	ani_calla,morph_swpal2
	.long	ani_nosleep			; dont sleep after next frame
	.long	KT1STANCE1
	.long	0


a_st_2_fn2
	.long	STSTANCE1
	.long	ani_calla,morph_swpal
	.long	STPURPLE1
	.long	STPURPLE2
	.long	STPURPLE3
;	.long	ani_calla,morph_swpal2
	.long	ani_nosleep			; dont sleep after next frame
	.long	KT2STANCE1
	.long	0

a_st_2_rd
	.long	STSTANCE1
	.long	ani_calla,morph_swpal
	.long	STRAIDEN1
	.long	STRAIDEN2
	.long	STRAIDEN3
;	.long	ani_calla,morph_swpal2
	.long	ani_nosleep			; dont sleep after next frame
	.long	RNSTANCE1
	.long	0

a_st_2_sa
	.long	STSTANCE1
	.long	ani_calla,morph_swpal
	.long	STUGLY2
	.long	STUGLY3
	.long	ani_nosleep			; dont sleep after next frame
	.long	UGSTANCE1
	.long	0

;	.long	STUGLY1		; thanks vogel


a_st_2_jc
	.long	STSTANCE1
	.long	ani_calla,morph_swpal
	.long	STCAGE1
	.long	STCAGE2
	.long	STCAGE3
;	.long	ani_calla,morph_swpal2
	.long	ani_nosleep			; dont sleep after next frame
	.long	JCSTANCE1
	.long	0


a_st_2_lk
	.long	STSTANCE1
	.long	ani_calla,morph_swpal
	.long	STLIUKANG1
	.long	STLIUKANG2
	.long	STLIUKANG3
;	.long	ani_calla,morph_swpal2
	.long	ani_nosleep			; dont sleep after next frame
	.long	LKSTANCE1
	.long	0

a_st_2_hh
	.long	STSTANCE1
	.long	ani_calla,morph_swpal
	.long	STHAT1
	.long	STHAT2
	.long	STHAT3
;	.long	ani_calla,morph_swpal2
	.long	ani_nosleep			; dont sleep after next frame
	.long	TMSTANCE1
	.long	0

a_st_2_sz
	.long	STSTANCE1
	.long	ani_calla,morph_swpal
	.long	STSUBZERO1
	.long	STSUBZERO2
	.long	STSUBZERO3
;	.long	ani_calla,morph_swpal2
	.long	ani_nosleep			; dont sleep after next frame
	.long	NJ1STANCE1
	.long	0

a_st_2_sc
	.long	STSTANCE1
	.long	ani_calla,morph_swpal
	.long	STSCORPION1
	.long	STSCORPION2
	.long	STSCORPION3
;	.long	ani_calla,morph_swpal2
	.long	ani_nosleep			; dont sleep after next frame
	.long	NJ3STANCE1
	.long	0

a_st_2_jx
	.long	STSTANCE1
	.long	ani_calla,morph_swpal
	.long	STJAX1
	.long	STJAX2
	.long	STJAX3
;	.long	ani_calla,morph_swpal2
	.long	ani_nosleep			; dont sleep after next frame
	.long	JXSTANCE1
	.long	0


STHAT1	.long	STHAT1A,STHAT1B,0
STHAT2	.long	STHAT2A,STHAT2B,0
STHAT3	.long	STHAT3A,STHAT3B,0

STLIUKANG1
	.long	STLIUKANG1A,STLIUKANG1B,0
STLIUKANG2
	.long	STLIUKANG2A,STLIUKANG2B,STLIUKANG2C,0
STLIUKANG3
	.long	STLIUKANG3A,STLIUKANG3B,STLIUKANG3C,0
STCAGE1
	.long	STCAGE1A,STCAGE1B,0
STCAGE2
	.long	STCAGE2A,STCAGE2B,0
STCAGE3
	.long	STCAGE3A,STCAGE3B,0
STUGLY1
	.long	STUGLY1A,STUGLY1B,0
STUGLY2
	.long	STUGLY2A,STUGLY2B,0
STUGLY3
	.long	STUGLY3A,STUGLY3B,STUGLY3C,0
STBLUE1
	.long	STBLUE1A,STBLUE1B,0
STBLUE2
	.long	STBLUE2A,STBLUE2B,0
STBLUE3
	.long	STBLUE3A,STBLUE3B,0
STPURPLE1
	.long	STPURPLE1A,STPURPLE1B,0
STPURPLE2
	.long	STPURPLE2A,STPURPLE2B,0
STPURPLE3
	.long	STPURPLE3A,STPURPLE3B,0
STRAIDEN1
	.long	STRAIDEN1A,STRAIDEN1B,0
STRAIDEN2
	.long	STRAIDEN2A,STRAIDEN2B,0
STRAIDEN3
	.long	STRAIDEN3A,STRAIDEN3B,0
STSUBZERO1
	.long	STSUBZERO1A,STSUBZERO1B,0
STSUBZERO2
	.long	STSUBZERO2A,STSUBZERO2B,0
STSUBZERO3
	.long	STSUBZERO3A,STSUBZERO3B,0
STREPTILE1
	.long	STREPTILE1A,STREPTILE1B,0
STREPTILE2
	.long	STREPTILE2A,STREPTILE2B,0
STREPTILE3
	.long	STREPTILE3A,STREPTILE3B,0
STSCORPION1
	.long	STSCORPION1A,STSCORPION1B,0
STSCORPION2
	.long	STSCORPION2A,STSCORPION2B,0
STSCORPION3
	.long	STSCORPION3A,STSCORPION3B,0

STJAX1	.long	STJAX1A,STJAX1B,0
STJAX2	.long	STJAX2A,STJAX2B,0
STJAX3	.long	STJAX3A,STJAX3B,0


a_head	.long	STHEAD1
	.long	STHEAD2
	.long	STHEAD3
	.long	STHEAD4
	.long	STHEAD5
	.long	STHEAD6
	.long	STHEAD7
	.long	STHEAD8
	.long	ani_jump,a_head


a_decapfall
	.long	NJDECAP1
	.long	NJDECAP2
	.long	NJDECAP3	; on knees
	.long	0
*
* wobble on yer knees
*
	.long	NJDECAP4
	.long	NJDECAP3
	.long	NJDECAP4
	.long	NJDECAP3
	.long	NJDECAP4
	.long	NJDECAP3
	.long	0
*
* fall to ground
*
	.long	NJDECAP4
	.long	NJDECAP5
	.long	NJDECAP6
	.long	NJDECAP7
	.long	0

NJDECAP1	.long	STDECAPLEG1A,STDECAPTORSO1,0
NJDECAP2	.long	STDECAPLEG2A,STDECAPTORSO2,0
NJDECAP3	.long	STDECAPLEG3A,STDECAPLEG3B,STDECAPTORSO3,0
NJDECAP4	.long	STDECAPLEG4A,STDECAPLEG4B,STDECAPTORSO4,0
NJDECAP5	.long	STDECAPLEG5A,STDECAPLEG5B,STDECAPTORSO5,0
NJDECAP6	.long	STDECAPLEG6A,STDECAPLEG6B,STDECAPTORSO6,0
NJDECAP7	.long	STDECAPLEG7A,STDECAPTORSO7,0

STDECAPLEG1
	.long	STDECAPLEG1A,0
;STDECAPLEG2
;	.long	STDECAPLEG2A,0
;STDECAPLEG3
;	.long	STDECAPLEG3A,STDECAPLEG3B,0
;STDECAPLEG4
;	.long	STDECAPLEG4A,STDECAPLEG4B,0
;STDECAPLEG5
;	.long	STDECAPLEG5A,STDECAPLEG5B,0
;STDECAPLEG6
;	.long	STDECAPLEG6A,STDECAPLEG6B,0
;STDECAPLEG7
;	.long	STDECAPLEG7A,0



a_impaled
	.long	ani_adjustxy
	.word	->60,>10
	.long	STIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	STIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	STIMPALED1

	.long	ani_adjustxy
	.word	>10,->15
	.long	STIMPALED1

	.long	0
*
* suffering (that's Christmas)
*
	.long	STIMPALED1
	.long	STIMPALED2
	.long	STIMPALED3

	.long	STIMPALED2
	.long	STIMPALED1
	.long	STIMPALED2
	.long	STIMPALED3
	.long	0



STIMPALED1
	.long	STIMPALED1A,0
STIMPALED2
	.long	STIMPALED2A,0
STIMPALED3
	.long	STIMPALED3A,STIMPALED3B,0



a_back_broke
	.long	STBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>0a
	.long	STBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>30
	.long	STBACKBREAK1
	.long	STBACKBREAK2
	.long	STBACKBREAK3
	.long	0
	.long	STBACKBREAK2
	.long	STBACKBREAK1
	.long	0

STBACKBREAK1
	.long	STBACKBREAK1A,STBACKBREAK1B,STBACKBREAK1C,0
STBACKBREAK2
	.long	STBACKBREAK2A,STBACKBREAK2B,STBACKBREAK2C,STBACKBREAK2D
	.long	0
STBACKBREAK3
	.long	STBACKBREAK3A,STBACKBREAK3B,STBACKBREAK3C,STBACKBREAK3D
	.long	STBACKBREAK3E,0

;**********************************************************************

a_torso_ripped
	.long	ani_adjustxy
	.word	->43,>0a
	.long	STSTUMBLE3
	.long	0

	.long	ani_calla,change_to_bloody_pal	; switch to bloody pal
	.long	STRIPTORSO1

	.long	ani_adjustxy
	.word	>18,->2a
	.long	STRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>00,>08
	.long	STRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>30,>20
	.long	STRIPTORSO3

	.long	ani_adjustxy
	.word	>30,>40
	.long	STRIPTORSO4
	.long	0

	.long	STRIPTORSO5
	.long	STRIPTORSO6
	.long	0
*
* standing legz
*
	.long	STDECAPLEG1		; legz
	.long	0


STRIPTORSO1
	.long	STRIPTORSO1A,STRIPTORSO1B,0
STRIPTORSO2
	.long	STRIPTORSO2A,STRIPTORSO2B,0
STRIPTORSO3
	.long	STRIPTORSO3A,STRIPTORSO3B,STRIPTORSO3C,0
STRIPTORSO4
	.long	STRIPTORSO4A,STRIPTORSO4B,STRIPTORSO4C,0
STRIPTORSO5
	.long	STRIPTORSO5A,0
STRIPTORSO6
	.long	STRIPTORSO6A,STRIPTORSO6B,0


a_swipe_torso
	.long	STRIPTORSO1
	.long	STRIPTORSO2
	.long	STRIPTORSO3
	.long	STRIPTORSO4 
	.long	STRIPTORSO5
	.long	STRIPTORSO6
	.long	0

;**************************************************************************

a_fb_goro
	.long	ani_adjustxy
	.word	->60,->20
	.long	STSTUMBLE4

	.long	ani_adjustxy
	.word	>10,->70
	.long	STKNOCKDOWN6

	.long	ani_adjustxy
	.word	>20,>00
	.long	STKNOCKDOWN6

	.long	ani_adjustxy
	.word	>3a,>20
	.long	STKNOCKDOWN5

	.long	ani_adjustxy
	.word	>38,>10
	.long	STKNOCKDOWN5

	.long	ani_adjustxy
	.word	>00,>68
	.long	STKNOCKDOWN6
	.long	0

;************************************************************************

	.end
