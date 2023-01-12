**************************************************************************
*											     *
*  video game project:	mortal kombat 2							*
* 											     *
*  game software:    	ed boon								     *
* 											     *
*  module: Liu Kang										*
*											     *
**************************************************************************
	.FILE	'MK2.ASM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
*
* GET THE SYSTEM STUFF
*
	.INCLUDE	MAINEQU.ASM
	.INCLUDE	MKLK.TBL
	.INCLUDE	MKLK2.TBL
	.INCLUDE	MKLK3.TBL
	.INCLUDE	IMGTBL.GLO

	.text

lk_anitab1
	.long	a_lkstance	;  0 - stance
	.long	a_lkwalkf	;  1 - walk forward
	.long	a_lkskipf	;  2 - skip forward
	.long	a_lkwalkb	;  3 - walk backward
	.long	a_lkskipb	;  4 - walk backward
	.long	a_lkduck  	;  5 - duck animation
	.long	a_lkjumpup	;  6 - jump straight up
	.long	a_lkfflip	;  7 - forward flip
	.long	a_lkbflip	;  8 - backward flip
	.long	a_lkturn	;  9 - turn around
	.long	a_lkduckturn	;  a - turn around while ducking
	.long	a_lkblockhi	;  b - standing block
	.long	a_lkduckblock	;  c - ducking block
	.long	a_lkhikick	;  d - hi kick
	.long	a_lklokick	;  e - lo kick
	.long	a_lkkdown	;  F - knocked down
	.long	a_lkhithi	; 10 - hit high
	.long	a_lkhitlo	; 11 - hit low
	.long	a_lkgetup	; 12 - normal getup
	.long	a_lkhipunch	; 13 - hi punch
	.long	a_lklopunch	; 14 - lo punch
	.long	a_lksweep	; 15 - sweep kick
	.long	a_lksweepfall	; 16 - sweep fall
	.long	a_lksweepup	; 17 - getup from sweep kick
	.long	a_lkduckpunch	; 18 - duck punch
	.long	a_lkduckkickh	; 19 - duck kick high
	.long	a_lkduckkickl	; 1a - duck kick low
	.long	a_lkduckhit	; 1b - hit while ducking
	.long	a_lkuppercut	; 1c - uppercut
	.long	a_lkjumpupkick	; 1d - jump straight up kick
	.long	a_lkflipkick	; 1e - flip kick
	.long	a_lkflippunch	; 1f - flip punch
	.long	a_lkroundh	; 20 - roundhouse kick
	.long	a_lkknee	; 21 - knee
	.long	a_lkelbow	; 22 - elbow
	.long	a_lkstumble	; 23 - stumble back
	.long	a_lkbodyslam	; 24 - body slam
	.long	a_shredded	; 25 -

	.long	a_lkzaphi	; 26 - lk throwing fireball hi
	.long	a_lkprojani	; 27 - fireball ani

	.long	a_lkstunned	; 28 - stunned
	.long	a_lkvictory	; 29 - victory

	.long	a_lk_fb_hh	; 2a - liu kang flipped by hatheat
	.long	a_lk_fb_lk	; 2b - liu kang flipped by liu kang
	.long	a_lk_fb_jc	; 2c - liu kang flipped by cage
	.long	a_lk_fb_sa	; 2d - liu kang flipped by sword arms
	.long	a_lk_fb_fn	; 2e - liu kang flipped by female ninja
	.long	a_lk_fb_fn	; 2f - liu kang flipped by female ninja
	.long	a_lk_fb_st	; 30 - liu kang flipped by shang tsung
	.long	a_lk_fb_rd	; 31 - liu kang flipped by raiden
	.long	a_lk_fb_nj	; 32 - liu kang flipped by ninja
	.long	a_lk_fb_nj	; 33 - liu kang flipped by ninja
	.long	a_lk_fb_nj	; 34 - liu kang flipped by ninja
	.long	a_lk_fb_jx	; 35 - liu kang flipped by jax

	.long	a_nutcrunched	; 36 - ouch
	.long	a_bike_kicked	; 37 - bicycle kicked
	.long	a_drained	; 38 - drained of my soul by shang tsung
	.long	a_torso_ripped	; 39 - torso ripped
	.long	a_banged	; 3a - hit by slow proj bang !!
	.long	a_impaled	; 3b - impaled
	.long	a_decapfall	; 3c - decapitated dude fall
	.long	a_head		; 3d - decapitated head
	.long	a_fb_goro	; 3e - flipped by goro's evil twin
	.long	a_back_broke	; 3f - back getting broken
	.long	DUMMY		; 40 -
	.long	a_swipe_torso	; 41 - scorpion swiped me torso


lk_anitab2
	.long	a_lkzaplo	; 0 - zap low
	.long	a_lkzapboom	; 1 - zap boom
	.long	a_lkjumpthrow	; 2 - jump throw (fireball)
	.long	a_lkdragon	; 3 -
	.long	a_lkwheel	; 4 - wheel kick
	.long	0
	.long	a_lkbike	; 6

DUMMY
a_lkstance
	.long	LKSTANCE1
	.long	LKSTANCE2
	.long	LKSTANCE3
	.long	LKSTANCE4
	.long	LKSTANCE5
	.long	LKSTANCE6
	.long	LKSTANCE7
	.long	ani_jump,a_lkstance

LKSTANCE1
	.long	LKSTANCE1A,LKSTANCE1B,LKSTANCE1C,0
LKSTANCE2
	.long	LKSTANCE2A,LKSTANCE2B,LKSTANCE2C,0
LKSTANCE3
	.long	LKSTANCE3A,LKSTANCE3B,LKSTANCE3C,0
LKSTANCE4
	.long	LKSTANCE4A,LKSTANCE4B,LKSTANCE4C,0
LKSTANCE5
	.long	LKSTANCE5A,LKSTANCE5B,LKSTANCE5C,0
LKSTANCE6
	.long	LKSTANCE6A,LKSTANCE6B,LKSTANCE6C,0
LKSTANCE7
	.long	LKSTANCE7A,LKSTANCE7B,LKSTANCE7C,0

**************************************************************

a_lkturn
	.long	LKTURN1
	.long	LKTURN2
	.long	ani_flip
	.long	LKTURN2
	.long	LKTURN1
  	.long	0

LKTURN1	.long	LKTURN1A,LKTURN1B,LKTURN1C,0
LKTURN2	.long	LKTURN2A,LKTURN2B,0

**************************************************************


a_lkwalkf
	.long	LKWALK1
	.long	LKWALK2
	.long	LKWALK3
	.long	LKWALK4
	.long	LKWALK5
	.long	LKWALK6
	.long	LKWALK7
	.long	LKWALK8
	.long	LKWALK9
	.long	ani_jump,a_lkwalkf

a_lkskipf
	.long	LKWALK1
	.long	LKWALK2
	.long	LKWALK8
	.long	LKWALK9
	.long	0

a_lkwalkb
	.long	LKWALK9
	.long	LKWALK8
	.long	LKWALK7
	.long	LKWALK6
	.long	LKWALK5
	.long	LKWALK4
	.long	LKWALK3
	.long	LKWALK2
	.long	LKWALK1
	.long	ani_jump,a_lkwalkb

a_lkskipb
	.long	LKWALK9
	.long	LKWALK8
	.long	LKWALK2
	.long	LKWALK1
	.long	0


LKWALK1	.long	LKWALKLEG1A
	.long	LKWALKTORSO1A,LKWALKTORSO1B,0
LKWALK2	.long	LKWALKLEG2A
	.long	LKWALKTORSO2A,LKWALKTORSO2B,0
LKWALK3	.long	LKWALKLEG3A
	.long	LKWALKTORSO3A,LKWALKTORSO3B,0
LKWALK4	.long	LKWALKLEG4A
	.long	LKWALKTORSO4A,LKWALKTORSO4B,0
LKWALK5	.long	LKWALKLEG5A
	.long	LKWALKTORSO5A,LKWALKTORSO5B,0
LKWALK6	.long	LKWALKLEG6A
	.long	LKWALKTORSO6A,LKWALKTORSO6B,0
LKWALK7	.long	LKWALKLEG7A,LKWALKLEG7B
	.long	LKWALKTORSO7A,LKWALKTORSO7B,0
LKWALK8	.long	LKWALKLEG8A,LKWALKLEG8B
	.long	LKWALKTORSO8A,LKWALKTORSO8B,0
LKWALK9	.long	LKWALKLEG9A,LKWALKLEG9B
	.long	LKWALKTORSO9A,LKWALKTORSO9B,0

**************************************************************************

a_lkhipunch
	.long	LKHIPUNCH1
	.long	LKHIPUNCH2
	.long	LKHIPUNCH3
	.long	0

	.long	LKHIPUNCH4
	.long	LKHIPUNCH5
	.long	LKHIPUNCH6
	.long	0

	.long	LKHIPUNCH5
	.long	LKHIPUNCH4
	.long	ani_jump,a_lkhipunch+(32*2)
	.long	0					; we NEED this "0"
*
* Unhipunch #1
*
	.long	LKHIPUNCH2
	.long	LKHIPUNCH1
	.long	0
*
* Unhipunch #2
*
	.long	LKHIPUNCH5
	.long	0
*
* Hi to Med #1
*
	.long	LKHIPUNCH4
	.long	LKLOPUNCH5
	.long	ani_jump,a_lklopunch+(32*6)
	.long	0
*
* Hi to Med #2
*
	.long	LKHIPUNCH5
	.long	LKLOPUNCH4
	.long	ani_jump,a_lklopunch+(32*2)
	.long	0



a_lklopunch
	.long	LKHIPUNCH1
	.long	LKHIPUNCH2
	.long	LKLOPUNCH3
	.long	0

	.long	LKLOPUNCH4
	.long	LKLOPUNCH5
	.long	LKLOPUNCH6
	.long	0

	.long	LKLOPUNCH5
	.long	LKLOPUNCH4
	.long	ani_jump,a_lklopunch+(32*2)
	.long	0
*
* Unlopunch #1
*
	.long	LKHIPUNCH2
	.long	LKHIPUNCH1
	.long	0
*
* Unlopunch #2
*
	.long	LKLOPUNCH5
	.long	0
*
* Med to High #1
*
	.long	LKLOPUNCH4
	.long	LKHIPUNCH5
	.long	ani_jump,a_lkhipunch+(32*6)
	.long	0
*
* Med to High #2
*
	.long	LKLOPUNCH5
	.long	LKHIPUNCH4
	.long	ani_jump,a_lkhipunch+(32*2)

LKHIPUNCH1
	.long	LKHIPUNCH1A,LKHIPUNCH1B,0
LKHIPUNCH2
	.long	LKHIPUNCH2A,LKHIPUNCH2B,0
LKHIPUNCH3
	.long	LKHIPUNCH3A,LKHIPUNCH3B,LKHIPUNCH3C,0
LKHIPUNCH4
	.long	LKHIPUNCH4ARM1
	.long	LKHIPUNCH4A,LKHIPUNCH4B,0
LKHIPUNCH5
	.long	LKHIPUNCH5ARM1
	.long	LKHIPUNCH5A,LKHIPUNCH5B,0
LKHIPUNCH6
	.long	LKHIPUNCH6A,LKHIPUNCH6B,0

******************

LKLOPUNCH3
	.long	LKLOPUNCH1A,LKLOPUNCH1B,0
LKLOPUNCH4
	.long	LKHIPUNCH4ARM2
	.long	LKHIPUNCH4A,LKHIPUNCH4B,0
LKLOPUNCH5
	.long	LKHIPUNCH5ARM2
	.long	LKHIPUNCH5A,LKHIPUNCH5B,0
LKLOPUNCH6
	.long	LKLOPUNCH2A,LKLOPUNCH2B,LKLOPUNCH2C,0

**********************************************************************

a_lkhikick
	.long	LKHIKIK1
	.long	LKHIKIK2
	.long	LKHIKIK3
	.long	LKHIKIK4
	.long	LKHIKIK5
	.long	LKHIKIK6
	.long	0
	.long	LKHIKIK5
	.long	LKHIKIK4
	.long	LKHIKIK3
	.long	LKHIKIK2
	.long	LKHIKIK1
	.long	0


a_lklokick
	.long	LKHIKIK1
	.long	LKHIKIK2
	.long	LKHIKIK3
	.long	LKHIKIK4
	.long	LKHIKIK5
	.long	LKLOKIK6
	.long	0
	.long	LKHIKIK5
	.long	LKHIKIK4
	.long	LKHIKIK3
	.long	LKHIKIK2
	.long	LKHIKIK1
	.long	0

LKHIKIK1
	.long	LKHIKIK1A,LKHIKIK1B,0
LKHIKIK2
	.long	LKHIKIK2A,LKHIKIK2B,LKHIKIK2C,0
LKHIKIK3
	.long	LKHIKICK3A,0
LKHIKIK4
	.long	LKHIKIK4A,LKHIKIK4B,LKHIKIK4C,0
LKHIKIK5
	.long	LKHIKIK5A,LKHIKIK5B,LKHIKIK5C,0
LKHIKIK6
	.long	LKHIKIK6A,LKHIKIK6B,0
LKLOKIK6
	.long	LKLOKIK1A,0

**********************************************************************

a_lkelbow
	.long	LKPALMSTRIKE1
	.long	LKPALMSTRIKE2
	.long	LKPALMSTRIKE3
	.long	0
	.long	LKPALMSTRIKE2
	.long	LKPALMSTRIKE1
	.long	0

LKPALMSTRIKE1
	.long	LKPALMSTRIKE1A,LKPALMSTRIKE1B,0
LKPALMSTRIKE2
	.long	LKPALMSTRIKE2A,LKPALMSTRIKE2B,LKPALMSTRIKE2C,0
LKPALMSTRIKE3
	.long	LKPALMSTRIKE3A,LKPALMSTRIKE3B,LKPALMSTRIKE3C,0

**********************************************************************

;LKBACKFIST1
;	.long	LKBACKFIST1A,LKBACKFIST1B,0
;LKBACKFIST2
;	.long	LKBACKFIST2A,LKBACKFIST2B,0
;LKBACKFIST3
;	.long	LKBACKFIST3A,LKBACKFIST3B,0
;LKBACKFIST4
;	.long	LKBACKFIST4A,LKBACKFIST4B,0

***************************************

a_lkknee
	.long	LKKNEE1
	.long	LKKNEE2
	.long	LKKNEE3
	.long	0
	.long	LKKNEE2
	.long	LKKNEE1
	.long	0

LKKNEE1
	.long	LKKNEE1A,LKKNEE1B,0
LKKNEE2
	.long	LKKNEE2A,LKKNEE2B,LKKNEE2C,0
LKKNEE3
	.long	LKKNEE3A,LKKNEE3B,0

***************************************

a_lkroundh
	.long	LKROUNDKIK1
	.long	LKROUNDKIK2
	.long	LKROUNDKIK3
	.long	ani_nosleep
	.long	LKROUNDKIK4
	.long	0
	.long	LKROUNDKIK5
	.long	LKROUNDKIK6
	.long	LKROUNDKIK7
	.long	LKROUNDKIK8
	.long	0

LKROUNDKIK1
	.long	LKROUNDKIK1A,LKROUNDKIK1B,0
LKROUNDKIK2
	.long	LKROUNDKIK2A,LKROUNDKIK2B,LKROUNDKIK2C,0
LKROUNDKIK3
	.long	LKROUNDKIK3A,LKROUNDKIK3B,LKROUNDKIK3C,0
LKROUNDKIK4
	.long	LKROUNDKIK4A,LKROUNDKIK4B,LKROUNDKIK4C,0
LKROUNDKIK5
	.long	LKROUNDKIK5A,LKROUNDKIK5B,LKROUNDKIK5C,0
LKROUNDKIK6
	.long	LKROUNDKIK6A,LKROUNDKIK6B,0
LKROUNDKIK7
	.long	LKROUNDKIK7A,LKROUNDKIK7B,LKROUNDKIK7C,LKROUNDKIK7D,0
LKROUNDKIK8
	.long	LKROUNDKIK8A,LKROUNDKIK8B,0

********************************************

a_lksweep
	.long	LKSWEEPKIK1
	.long	LKSWEEPKIK2
	.long	LKSWEEPKIK3
	.long	ani_calla,sweep_sounds
	.long	LKSWEEPKIK4
	.long	LKSWEEPKIK5
	.long	0
	.long	LKSWEEPKIK6
	.long	LKSWEEPKIK7
	.long	0

LKSWEEPKIK1
	.long	LKSWEEPKIK1A,LKSWEEPKIK1B,LKSWEEPKIK1C,LKSWEEPKIK1D
	.long	0
LKSWEEPKIK2
	.long	LKSWEEPKIK2A,LKSWEEPKIK2B,0
LKSWEEPKIK3
	.long	LKSWEEPKIK3A,LKSWEEPKIK3B,0
LKSWEEPKIK4
	.long	LKSWEEPKIK4A,LKSWEEPKIK4B,LKSWEEPKIK4C,0
LKSWEEPKIK5
	.long	LKSWEEPKIK5A,LKSWEEPKIK5B,LKSWEEPKIK5C,0
LKSWEEPKIK6
	.long	LKSWEEPKIK6A,LKSWEEPKIK6B,LKSWEEPKIK6C,0
LKSWEEPKIK7
	.long	LKSWEEPKIK7A,LKSWEEPKIK7B,0

***************************************

a_lkduck
	.long	LKDUCK1
	.long	LKDUCK2
	.long	LKDUCK3
	.long	0

LKDUCK1	.long	LKDUCK1A,LKDUCK1B,LKDUCK1C,0
LKDUCK2	.long	LKDUCK2A,LKDUCK2B,0
LKDUCK3	.long	LKDUCK3A,LKDUCK3B,0

***************************************

a_lkduckturn
	.long	LKDUCKTURN1
	.long	LKDUCKTURN2
	.long	ani_flip  
	.long	ani_adjustx
	.word	-8

	.long	LKDUCKTURN2
	.long	LKDUCK3
	.long	0

LKDUCKTURN1
	.long	LKDUCKTURN1A,LKDUCKTURN1B,0
LKDUCKTURN2
	.long	LKDUCKTURN2A,LKDUCKTURN2B,0

***************************************

a_lkduckpunch
	.long	LKDUCKPUNCH1
	.long	LKDUCKPUNCH2
	.long	LKDUCKPUNCH3
	.long	0
	.long	LKDUCKPUNCH2
	.long	LKDUCKPUNCH1
	.long	LKDUCK3
	.long	0

LKDUCKPUNCH1
	.long	LKDUCKPUNCH1A,LKDUCKPUNCH1B,0
LKDUCKPUNCH2
	.long	LKDUCKPUNCH2A,LKDUCKPUNCH2B,0
LKDUCKPUNCH3
	.long	LKDUCKPUNCH3A,LKDUCKPUNCH3B,LKDUCKPUNCH3C,0

***************************************

a_lkduckblock
	.long	LKDUCKBLOCK1
	.long	LKDUCKBLOCK2
	.long	LKDUCKBLOCK3
	.long	0
	.long	LKDUCKBLOCK2
	.long	LKDUCKBLOCK1
	.long	LKDUCK3
	.long	0

LKDUCKBLOCK1
	.long	LKDUCKBLOCK1A,LKDUCKBLOCK1B,LKDUCKBLOCK1C,0
LKDUCKBLOCK2
	.long	LKDUCKBLOCK2A,LKDUCKBLOCK2B,LKDUCKBLOCK2C,0
LKDUCKBLOCK3
	.long	LKDUCKBLOCK3A,LKDUCKBLOCK3B,LKDUCKBLOCK3C,LKDUCKBLOCK3D,0

***************************************

a_lkfflip
	.long	LKJUMPFLIP1
	.long	LKJUMPFLIP2
	.long	LKJUMPFLIP3
	.long	LKJUMPFLIP4
	.long	LKJUMPFLIP5
	.long	LKJUMPFLIP6
	.long	LKJUMPFLIP7
	.long	LKJUMPFLIP8
	.long	ani_jump,a_lkfflip+32

a_lkbflip
	.long	LKJUMPFLIP1
	.long	LKJUMPFLIP8
	.long	LKJUMPFLIP7
	.long	LKJUMPFLIP6
	.long	LKJUMPFLIP5
	.long	LKJUMPFLIP4
	.long	LKJUMPFLIP3
	.long	LKJUMPFLIP2
	.long	ani_jump,a_lkbflip+32

LKJUMPFLIP1
	.long	LKJUMPFLIP1A,LKJUMPFLIP1B,0
LKJUMPFLIP2
	.long	LKJUMPFLIP2A,0
LKJUMPFLIP3
	.long	LKJUMPFLIP3A,0
LKJUMPFLIP4
	.long	LKJUMPFLIP4A,0
LKJUMPFLIP5
	.long	LKJUMPFLIP5A,0
LKJUMPFLIP6
	.long	LKJUMPFLIP6A,0
LKJUMPFLIP7
	.long	LKJUMPFLIP7A,0
LKJUMPFLIP8
	.long	LKJUMPFLIP8A,0

*****************************************

a_lkflipkick	
	.long	LKFLIPKICK1
	.long	LKFLIPKICK2
	.long	LKFLIPKICK3
	.long	0
	.long	LKFLIPKICK2
	.long	LKFLIPKICK1
	.long	0

LKFLIPKICK1
	.long	LKFLIPKICK1A,LKFLIPKICK1B,0
LKFLIPKICK2
	.long	LKFLIPKICK2A,LKFLIPKICK2B,0
LKFLIPKICK3
	.long	LKFLIPKICK3A,LKFLIPKICK3B,0


*****************************************

a_lkflippunch
	.long	LKFLIPUNCH1
	.long	LKFLIPUNCH2
	.long	LKFLIPUNCH3
	.long	0
	.long	LKFLIPUNCH2
	.long	LKFLIPUNCH1
	.long	0

LKFLIPUNCH1
	.long	LKFLIPUNCH1A,LKFLIPUNCH1B,0
LKFLIPUNCH2
	.long	LKFLIPUNCH2A,LKFLIPUNCH2B,LKFLIPUNCH2C,0
LKFLIPUNCH3
	.long	LKFLIPUNCH3A,LKFLIPUNCH3B,0

*****************************************

a_lkstunned
	.long	LKSTUNNED1
	.long	LKSTUNNED2
	.long	LKSTUNNED3
	.long	LKSTUNNED4
	.long	LKSTUNNED5
	.long	LKSTUNNED6
	.long	LKSTUNNED7
	.long	ani_jump,a_lkstunned

LKSTUNNED1
	.long	LKSTUNNED1A,LKSTUNNED1B,0
LKSTUNNED2
	.long	LKSTUNNED2A,LKSTUNNED2B,0
LKSTUNNED3
	.long	LKSTUNNED3A,LKSTUNNED3B,0
LKSTUNNED4
	.long	LKSTUNNED4A,LKSTUNNED4B,0
LKSTUNNED5
	.long	LKSTUNNED5A,LKSTUNNED5B,0
LKSTUNNED6
	.long	LKSTUNNED6A,LKSTUNNED6B,0
LKSTUNNED7
	.long	LKSTUNNED7A,LKSTUNNED7B,0

***********************************************

a_lkjumpupkick
	.long	LKJUMPKICK1
	.long	LKJUMPKICK2
	.long	0
	.long	LKJUMPKICK1
	.long	0

LKJUMPKICK1
	.long	LKJUMPKICK1A,LKJUMPKICK1B,0
LKJUMPKICK2
	.long	LKJUMPKICK2A,LKJUMPKICK2B,0

***********************************************

a_lkjumpup
	.long	LKJUMP2
	.long	LKJUMP3
	.long	0
	.long	LKJUMP2
	.long	LKJUMP1
	.long	0

LKJUMP1	.long	LKJUMP1A,LKJUMP1B,0
LKJUMP2	.long	LKJUMP2A,LKJUMP2B,LKJUMP2C,0
LKJUMP3	.long	LKJUMP3A,LKJUMP3B,0

***********************************************

a_lkhithi
	.long	LKHIHIT2
	.long	LKHIHIT3
	.long	LKHIHIT2
	.long	LKHIHIT1
	.long	0

LKHIHIT1	.long	LKHIHIT1A,LKHIHIT1B,0
LKHIHIT2	.long	LKHIHIT2A,LKHIHIT2B,0
LKHIHIT3	.long	LKHIHIT3A,LKHIHIT3B,0

***********************************************

a_lkhitlo
	.long	LKLOHIT2
	.long	LKLOHIT3
	.long	LKLOHIT2
	.long	LKLOHIT1
	.long	0

LKLOHIT1	.long	LKLOHIT1A,LKLOHIT1B,LKLOHIT1C,LKLOHIT1D,0
LKLOHIT2	.long	LKLOHIT2A,LKLOHIT2B,0
LKLOHIT3	.long	LKLOHIT3A,LKLOHIT3B,0

***********************************************

a_lkuppercut
	.long	LKUPPERCUT1
	.long	LKUPPERCUT2
	.long	LKUPPERCUT3
	.long	LKUPPERCUT4
	.long	ani_nosleep	; dont sleep after next frame
	.long	LKUPPERCUT5
	.long	0
	.long	LKHIBLOCK1
	.long	0

LKUPPERCUT1
	.long	LKUPPERCUT1A,LKUPPERCUT1B,0
LKUPPERCUT2
	.long	LKUPPERCUT2A,LKUPPERCUT2B,0
LKUPPERCUT3
	.long	LKUPPERCUT3A,LKUPPERCUT3B,LKUPPERCUT3C,LKUPPERCUT3D,0
LKUPPERCUT4
	.long	LKUPPERCUT4A,LKUPPERCUT4B,LKUPPERCUT4C,LKUPPERCUT4D
	.long	LKUPPERCUT4E,0
LKUPPERCUT5
	.long	LKUPPERCUT5A,LKUPPERCUT5B,LKUPPERCUT5C,0

***********************************************

a_lkduckkickh
	.long	LKDUCKIKHI1
	.long	ani_calla,kick_sounds
	.long	LKDUCKIKHI2
	.long	LKDUCKIKHI3
	.long	LKDUCKIKHI4
	.long	0
	.long	LKDUCKIKHI3
	.long	LKDUCKIKHI2
	.long	LKDUCKIKHI1
	.long	LKDUCK3
	.long	0

a_lkduckkickl
	.long	LKDUCKIKHI1
	.long	LKDUCKIKHI2
	.long	ani_calla,kick_sounds
	.long	LKDUCKIKLO1
	.long	LKDUCKIKLO2
	.long	0
	.long	LKDUCKIKLO2
	.long	LKDUCKIKLO1
	.long	LKDUCKIKHI2
	.long	LKDUCK3
	.long	0

LKDUCKIKHI1
	.long	LKDUCKIKHI1A,LKDUCKIKHI1B,0
LKDUCKIKHI2
	.long	LKDUCKIKHI2A,LKDUCKIKHI2B,0
LKDUCKIKHI3
	.long	LKDUCKIKHI3A,LKDUCKIKHI3B,LKDUCKIKHI3C,0
LKDUCKIKHI4
	.long	LKDUCKIKHI4A,LKDUCKIKHI4B,0


LKDUCKIKLO1
	.long	LKDUCKIKLO1A,LKDUCKIKLO1B,LKDUCKIKLO1C,0
LKDUCKIKLO2
	.long	LKDUCKIKLO2A,LKDUCKIKLO2B,LKDUCKIKLO2C,0

***********************************************

a_lksweepup
	.long	LKSWEEPUP1
	.long	LKSWEEPUP2
	.long	LKSWEEPUP3
	.long	LKSWEEPUP4
	.long	LKSWEEPUP5
	.long	LKSWEEPUP6
	.long	0

LKSWEEPUP1
	.long	LKSWEEPUP1A,LKSWEEPUP1B,0
LKSWEEPUP2
	.long	LKSWEEPUP2A,LKSWEEPUP2B,0
LKSWEEPUP3
	.long	LKSWEEPUP3A,LKSWEEPUP3B,0
LKSWEEPUP4
	.long	LKSWEEPUP4A,LKSWEEPUP4B,0
LKSWEEPUP5
	.long	LKSWEEPUP5A,LKSWEEPUP5B,0
LKSWEEPUP6
	.long	LKSWEEPUP6A,LKSWEEPUP6B,LKSWEEPUP6C,0

***********************************************

a_lkduckhit
	.long	LKDUCKHIT2
	.long	LKDUCKHIT3
	.long	LKDUCKHIT2
	.long	LKDUCKHIT1
	.long	LKDUCK3
	.long	0

LKDUCKHIT1
	.long	LKDUCKHIT1A,LKDUCKHIT1B,0
LKDUCKHIT2
	.long	LKDUCKHIT2A,LKDUCKHIT2B,0
LKDUCKHIT3
	.long	LKDUCKHIT3A,LKDUCKHIT3B,0

***********************************************

a_lkstumble
	.long	LKSTUMBLE1
	.long	LKSTUMBLE2
	.long	LKSTUMBLE3
	.long	LKSTUMBLE4
	.long	LKSTUMBLE5
	.long	0

LKSTUMBLE1
	.long	LKSTUMBLE1A,LKSTUMBLE1B,0
LKSTUMBLE2
	.long	LKSTUMBLE2A,LKSTUMBLE2B,0
LKSTUMBLE3
	.long	LKSTUMBLE3A,LKSTUMBLE3B,LKSTUMBLE3C,LKSTUMBLE3D,0
LKSTUMBLE4
	.long	LKSTUMBLE4A,LKSTUMBLE4B,LKSTUMBLE4C,0
LKSTUMBLE5
	.long	LKSTUMBLE5A,0

***********************************************

a_shredded
	.long	ani_adjustxy
	.word	6,6
	.long	LKSTUMBLE1

	.long	ani_adjustxy
	.word	-6,-6
	.long	LKSTUMBLE2

	.long	ani_adjustxy
	.word	6,6
	.long	LKSTUMBLE3

	.long	ani_adjustxy
	.word	-6,-6
	.long	LKSTUMBLE2

	.long	ani_jump,a_shredded

***********************************************


a_lkblockhi
	.long	LKHIBLOCK1
	.long	LKHIBLOCK2
	.long	LKHIBLOCK3
	.long	0
	.long	LKHIBLOCK2
	.long	LKHIBLOCK1
	.long	0

LKHIBLOCK1
	.long	LKHIBLOCK1A,LKHIBLOCK1B,0
LKHIBLOCK2
	.long	LKHIBLOCK2A,LKHIBLOCK2B,LKHIBLOCK2C,0
LKHIBLOCK3
	.long	LKHIBLOCK3A,LKHIBLOCK3B,LKHIBLOCK3C,LKHIBLOCK3D,0

***********************************************

a_lkkdown
	.long	LKKNOCKDOWN1
	.long	LKKNOCKDOWN2
	.long	LKKNOCKDOWN3
	.long	LKKNOCKDOWN4
	.long	LKKNOCKDOWN5
	.long	0
*
* part 2 = landing on back
*
	.long	LKKNOCKDOWN6
	.long	LKKNOCKDOWN7
	.long	0
*
* part 3 = shake on the ground
*
	.long	LKKNOCKDOWN6
	.long	LKKNOCKDOWN7
	.long	LKKNOCKDOWN6
	.long	LKKNOCKDOWN7
	.long	0

LKKNOCKDOWN1
	.long	LKKNOCKDOWN1A,LKKNOCKDOWN1B,LKKNOCKDOWN1C,0
LKKNOCKDOWN2
	.long	LKKNOCKDOWN2A,LKKNOCKDOWN2B,LKKNOCKDOWN2C,LKKNOCKDOWN2D
	.long	0
LKKNOCKDOWN3
	.long	LKKNOCKDOWN3A,LKKNOCKDOWN3B,LKKNOCKDOWN3C,0
LKKNOCKDOWN4
	.long	LKKNOCKDOWN4A,LKKNOCKDOWN4B,0
LKKNOCKDOWN5
	.long	LKKNOCKDOWN5A,LKKNOCKDOWN5B,0
LKKNOCKDOWN6
	.long	LKKNOCKDOWN6A,LKKNOCKDOWN6B,0
LKKNOCKDOWN7
	.long	LKKNOCKDOWN7A,LKKNOCKDOWN7B,0

***********************************************

a_lksweepfall
	.long	LKSWEEPFALL1
	.long	LKSWEEPFALL2
	.long	LKSWEEPFALL3
	.long	LKSWEEPFALL4
	.long	0

	.long	LKSWEEPFALL5
	.long	0

LKSWEEPFALL1
	.long	LKSWEEPFALL1A,LKSWEEPFALL1B,0
LKSWEEPFALL2
	.long	LKSWEEPFALL2A,LKSWEEPFALL2B,LKSWEEPFALL2C,0
LKSWEEPFALL3
	.long	LKSWEEPFALL3A,LKSWEEPFALL3B,LKSWEEPFALL3C,0
LKSWEEPFALL4
	.long	LKSWEEPFALL4A,LKSWEEPFALL4B,LKSWEEPFALL4C,0
LKSWEEPFALL5
	.long	LKSWEEPFALL5A,LKSWEEPFALL5B,0

***********************************************

a_lkgetup
	.long	LKGETUP1
	.long	LKGETUP2
	.long	LKGETUP3
	.long	LKGETUP4
	.long	LKGETUP5
	.long	0

LKGETUP1	.long	LKGETUP1A,0
LKGETUP2	.long	LKGETUP2A,0
LKGETUP3	.long	LKGETUP3A,LKGETUP3B,0
LKGETUP4	.long	LKGETUP4A,LKGETUP4B,0
LKGETUP5	.long	LKGETUP5A,LKGETUP5B,LKGETUP5C,0

***********************************************

a_banged
	.long	LKFLIPPED1
	.long	LKFLIPPED2
	.long	LKFLIPPED3
	.long	LKFLIPPED4
	.long	0

a_lk_fb_sa
	.long	ani_adjustxy
	.word	->40,>00
	.long	LKSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>0f,->30
	.long	LKFLIPPED1

	.long	ani_adjustxy
	.word	>23,->10
	.long	LKFLIPPED2

	.long	ani_adjustxy
	.word	>3f,->20
	.long	LKFLIPPED3
	.long	0

a_lk_fb_fn
	.long	ani_adjustxy
	.word	->40,->13
	.long	ani_flip
	.long	LKKNOCKDOWN2
	.long	0

	.long	ani_adjustxy
	.word	->20,->1c
	.long	LKKNOCKDOWN2

	.long	ani_adjustxy
	.word	->38,->40
	.long	LKKNOCKDOWN5

	.long	ani_adjustxy
	.word	->30,>38
	.long	LKFLIPPED4

	.long	ani_adjustxy
	.word	->08,>2a
	.long	LKFLIPPED4

	.long	ani_adjustxy
	.word	>00,>20
	.long	LKFLIPPED4
	.long	0
*
* bounce on ground
*
	.long	LKKNOCKDOWN5
	.long	0



a_lk_fb_hh
	.long	ani_adjustxy
	.word	->44,>09		; we need even # of words here !
	.long	LKSTUMBLE1
	.long	0

	.long	ani_flip
	.long	LKSTUMBLE1
	.long	ani_adjustxy
	.word	>00,>07
	.long	0

	.long	ani_adjustxy
	.word	>70,->40

	.long	LKFLIPPED3
	.long	LKFLIPPED3
	.long	LKFLIPPED4
	.long	0


a_lk_fb_lk
	.long	ani_adjustxy
	.word	->40,>00
	.long	LKFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>15,>18
	.long	LKFLIPPED2

	.long	ani_adjustxy
	.word	>18,>06
	.long	LKFLIPPED2

	.long	ani_adjustxy
	.word	>28,->20
	.long	LKFLIPPED3

	.long	ani_adjustxy
	.word	>30,->10
	.long	LKFLIPPED3

	.long	ani_adjustxy
	.word	>30,->18
	.long	LKFLIPPED4
	.long	0
*
* land on the ground
*
	.long	LKKNOCKDOWN6
	.long	LKKNOCKDOWN7
	.long	LKKNOCKDOWN6
	.long	LKKNOCKDOWN7
	.long	0


a_lk_fb_jx
	.long	ani_adjustxy
	.word	->50,>08
	.long	LKSTUMBLE1
	.long	LKSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>10,->40
	.long	LKFLIPPED1	; jax 3

	.long	ani_adjustxy
	.word	>2a,>00
	.long	LKFLIPPED2	; jax 4

	.long	ani_adjustxy
	.word	>38,>00
	.long	LKFLIPPED3	; jax 5

	.long	ani_adjustxy
	.word	>20,>20
	.long	LKFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	>10,>1d
	.long	LKKNOCKDOWN7	; jax 7
	.long	0
*
* slammed again !
*
	.long	ani_adjustxy
	.word	->10,->20
	.long	LKFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	->10,->40
	.long	LKFLIPPED4	; jax 6

	.long	ani_flip
	.long	ani_adjustxy
	.word	>40,>00
	.long	LKFLIPPED3	; jax 4

	.long	ani_adjustxy
	.word	>2a,->08
	.long	LKFLIPPED4	; jax 3

	.long	ani_adjustxy
	.word	>10,>46
	.long	LKFLIPPED4

	.long	ani_adjustxy
	.word	>00,>20
	.long	LKKNOCKDOWN7	; jax 7
	.long	0



a_lk_fb_jc
	.long	ani_adjustxy
	.word	->30,>08
	.long	LKSTUMBLE1
	.long	LKSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>1f,->50
	.long	LKFLIPPED3

	.long	ani_adjustxy
	.word	>58,>20
	.long	LKFLIPPED4

	.long	ani_adjustxy
	.word	>18,>40
	.long	LKFLIPPED4
	.long	0


a_lk_fb_st
	.long	ani_adjustxy
	.word	->30,>00
	.long	LKSTUMBLE5
	.long	LKSTUMBLE5
	.long	0

	.long	ani_adjustxy
	.word	>00,->18
	.long	LKFLIPPED2
	.long	ani_adjustxy
	.word	>30,->10
	.long	LKFLIPPED2
	.long	ani_adjustxy
	.word	>30,>18
	.long	LKFLIPPED3
	.long	ani_adjustxy
	.word	>28,>18
	.long	LKFLIPPED4
	.long	0

	.long	ani_adjustxy
	.word	>20,>00
	.long	LKKNOCKDOWN7
	.long	0

LKFLIPPED1
	.long	LKFLIPPED1A,LKFLIPPED1B,0
LKFLIPPED2
	.long	LKFLIPPED2A,LKFLIPPED2B,LKFLIPPED2C,0
LKFLIPPED3
	.long	LKFLIPPED3A,LKFLIPPED3B,0
LKFLIPPED4
	.long	LKFLIPPED4A,LKFLIPPED4B,0

***********************************************

a_lk_fb_rd
	.long	ani_adjustxy
	.word	->4a,>00
	.long	LKSTUMBLE5
	.long	0

	.long	ani_adjustxy
	.word	>0a,->18
	.long	LKFLIPPED2

	.long	ani_adjustxy
	.word	>28,->20
	.long	LKFLIPPED2
	.long	LKFLIPPED2

	.long	ani_adjustxy
	.word	>0a,>80
	.long	ani_flip_v
	.long	LKFLIPPED2

	.long	ani_adjustxy
	.word	>38,>40
	.long	LKFLIPPED2
	.long	0

	.long	ani_adjustxy
	.word	>18,>10
	.long	ani_flip
	.long	LKKNOCKDOWN7
	.long	0



a_lk_fb_nj
	.long	ani_adjustxy
	.word	->40,>00
	.long	LKFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>04,>00
	.long	LKFLIPPED1

	.long	ani_adjustxy
	.word	>18,>26
	.long	LKFLIPPED2

	.long	ani_adjustxy
	.word	>28,->20
	.long	LKFLIPPED3

	.long	ani_adjustxy
	.word	>30,->10
	.long	LKFLIPPED3

	.long	ani_adjustxy
	.word	>30,->18
	.long	LKFLIPPED4
	.long	0
*
* land on the ground
*
	.long	LKKNOCKDOWN6
	.long	LKKNOCKDOWN7
	.long	LKKNOCKDOWN6
	.long	LKKNOCKDOWN7
	.long	0

***********************************************

a_lkbodyslam
	.long	LKFLIP1		; step #1 = grab
	.long	0
	.long	LKFLIP2
	.long	LKFLIP3
	.long	LKFLIP4
	.long	LKFLIP5
	.long	LKFLIP6			; step #2 = throw
	.long	0
	.long	ani_jump,a_lkgetup	; step #3 = back 2 normal


LKFLIP1	.long	LKFLIP1A,LKFLIP1B,0
LKFLIP2	.long	LKFLIP2A,LKFLIP2B,0
LKFLIP3	.long	LKFLIP3A,LKFLIP3B,LKFLIP3C,0
LKFLIP4	.long	LKFLIP4A,LKFLIP4B,LKFLIP4C,LKFLIP4D,0
LKFLIP5	.long	LKFLIP5A,LKFLIP5B,LKFLIP5C,LKFLIP5D,0
LKFLIP6	.long	LKFLIP6A,LKFLIP6B,LKFLIP6C,0



a_lkvictory
	.long	LKVICTORY1
	.long	LKVICTORY2
	.long	LKVICTORY3
	.long	LKVICTORY4
	.long	LKVICTORY5
	.long	LKVICTORY6
	.long	LKVICTORY7
	.long	LKVICTORY8
	.long	0

LKVICTORY1
	.long	LKVICTORY1A,LKVICTORY1B,LKVICTORY1C,0
LKVICTORY2
	.long	LKVICTORY2A,LKVICTORY2B,0
LKVICTORY3
	.long	LKVICTORYLEGSA,LKVICTORYLEGSB
	.long	LKVICTORY3A,LKVICTORY3B,LKVICTORY3C,0
LKVICTORY4
	.long	LKVICTORYLEGSA,LKVICTORYLEGSB
	.long	LKVICTORY4A,LKVICTORY4B,LKVICTORY4C,0
LKVICTORY5
	.long	LKVICTORYLEGSA,LKVICTORYLEGSB
	.long	LKVICTORY5A,LKVICTORY5B,LKVICTORY5C,0
LKVICTORY6
	.long	LKVICTORYLEGSA,LKVICTORYLEGSB
	.long	LKVICTORY6A,LKVICTORY6B,0
LKVICTORY7
	.long	LKVICTORYLEGSA,LKVICTORYLEGSB
	.long	LKVICTORY7A,0
LKVICTORY8
	.long	LKVICTORYLEGSA,LKVICTORYLEGSB
	.long	LKVICTORY8A,0

****************************************************************************

a_lkzaplo
	.long	LKTHROWLO1
	.long	LKTHROWLO2
	.long	0

LKTHROWLO1
	.long	LKTHROWLO1A,LKTHROWLO1B,0
LKTHROWLO2
	.long	LKTHROWLO2A,LKTHROWLO2B,0

****************************************************************************


a_lkzaphi
	.long	LKTHROWHI1
	.long	LKTHROWHI2
	.long	LKTHROWHI3
	.long	0

LKTHROWHI1
	.long	LKTHROWHI1A,LKTHROWHI1B,0
LKTHROWHI2
	.long	LKTHROWHI2A,LKTHROWHI2B,0
LKTHROWHI3
	.long	LKTHROWHI3A,LKTHROWHI3B,0


a_lkprojani
	.long	LKFB1
	.long	LKFB2
	.long	LKFB3
	.long	LKFB4
	.long	0

	.long	LKFB5
	.long	LKFB6
	.long	LKFB5
	.long	LKFB6
	.long	LKFB5
	.long	LKFB6
	.long	LKFB5
	.long	LKFB6
	.long	0

LKFB1	.LONG	DRAGNBALL1,0
LKFB2	.LONG	DRAGNBALL2,0
LKFB3	.LONG	DRAGNBALL3,0
LKFB4	.LONG	DRAGNBALL4,0
LKFB5	.LONG	DRAGNBALL5,0
LKFB6	.LONG	DRAGNBALL6,0


a_lkzapboom
	.long	HOBOOMM10
	.long	HOBOOMM11
	.long	HOBOOMM12

	.long	HOBOOM13
	.long	HOBOOM14
	.long	HOBOOM15
	.long	0

HOBOOMM10
	.long	HOBOOM10,0
HOBOOMM11
	.long	HOBOOM11,0
HOBOOMM12
	.long	HOBOOM12,0

HOBOOM13
	.long	HOBOOM13A,HOBOOM13B,HOBOOM13C,HOBOOM13D
	.long	HOBOOM13E,HOBOOM13F,HOBOOM13G,HOBOOM13H
	.long	0
HOBOOM14
	.long	HOBOOM14A,HOBOOM14B,HOBOOM14C,HOBOOM14D
	.long	HOBOOM14E,HOBOOM14F,HOBOOM14G,HOBOOM14H
	.long	0
HOBOOM15
	.long	HOBOOM15A,HOBOOM15B,HOBOOM15C,HOBOOM15D
	.long	HOBOOM15E,HOBOOM15F,HOBOOM15G,HOBOOM15H,0


a_lkjumpthrow
	.long	LKJUMPTHROW1
	.long	LKJUMPTHROW2
	.long	0
	.long	LKJUMPTHROW1
	.long	0

LKJUMPTHROW1
	.long	LKJUMPTHROW1A,LKJUMPTHROW1B,0
LKJUMPTHROW2
	.long	LKJUMPTHROW2A,LKJUMPTHROW2B,LKJUMPTHROW2C,0

*********************************************************

a_impaled
	.long	ani_adjustxy
	.word	->60,>10
	.long	LKIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	LKIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	LKIMPALED1

	.long	ani_adjustxy
	.word	>10,->18
	.long	LKIMPALED1

	.long	0
*
* suffering (that's Christmas)
*
	.long	LKIMPALED1
	.long	LKIMPALED2
	.long	LKIMPALED3
	.long	LKIMPALED2
	.long	LKIMPALED1
	.long	LKIMPALED2
	.long	LKIMPALED3
	.long	0

LKIMPALED1
	.long	LKIMPALED1A,0
LKIMPALED2
	.long	LKIMPALED4A,LKIMPALED4B,0
LKIMPALED3
	.long	LKIMPALED2A,0

*********************************************************

a_nutcrunched
	.long	LKNUTCRUNCH1
	.long	LKNUTCRUNCH2
	.long	0
	.long	LKNUTCRUNCH1
	.long	0

LKNUTCRUNCH1
	.long	LKNUTCRUNCH1A,LKNUTCRUNCH1B,0
LKNUTCRUNCH2
	.long	LKNUTCRUNCH2A,LKNUTCRUNCH2B,0

*********************************************************

a_lkbike
	.long	LKBIKEKICK1
	.long	LKBIKEKICK2
	.long	LKBIKEKICK3
	.long	LKBIKEKICK4
	.long	LKBIKEKICK5
	.long	LKBIKEKICK6
	.long	LKBIKEKICK7
	.long	ani_jump,a_lkbike

LKBIKEKICK1
	.long	LKBIKEKICK1A,LKBIKEKICK1B,LKBIKEKICK1C,LKBIKEKICK1D,0
LKBIKEKICK2
	.long	LKBIKEKICK2A,LKBIKEKICK2B,0
LKBIKEKICK3
	.long	LKBIKEKICK3A,LKBIKEKICK3B,LKBIKEKICK3C,0
LKBIKEKICK4
	.long	LKBIKEKICK4A,LKBIKEKICK4B,LKBIKEKICK4C,0
LKBIKEKICK5
	.long	LKBIKEKICK5A,LKBIKEKICK5B,LKBIKEKICK5C,0
LKBIKEKICK6
	.long	LKBIKEKICK6A,LKBIKEKICK6B,LKBIKEKICK6C,0
LKBIKEKICK7
	.long	LKBIKEKICK7A,LKBIKEKICK7B,LKBIKEKICK7C,0

*********************************************************

a_bike_kicked
	.long	LKSTUMBLE1
	.long	LKSTUMBLE2
	.long	LKSTUMBLE3
	.long	LKSTUMBLE4
	.long	LKSTUMBLE5
	.long	ani_jump,a_bike_kicked

*********************************************************

a_drained
	.long	ani_adjustxy
	.word	->48,->13
	.long	LKSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	->0a,>1a
	.long	LKDRAIN0
	.long	ani_adjustxy
	.word	>13,->08
	.long	LKDRAIN0
	.long	ani_adjustxy
	.word	>08,->14
	.long	LKDRAIN0
	.long	ani_adjustxy
	.word	0,0
	.long	LKDRAIN0
	.long	0

;****************************************************************

a_torso_ripped
	.long	ani_adjustxy
	.word	->4a,>04
	.long	LKSTUMBLE5
	.long	0

	.long	ani_calla,change_to_bloody_pal	; switch to bloody pal
	.long	LKRIPTORSO1

	.long	ani_adjustxy
	.word	>28,->20
	.long	LKRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>00,>08
	.long	LKRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>30,>20
	.long	LKRIPTORSO3

	.long	ani_adjustxy
	.word	>30,>40
	.long	LKRIPTORSO4
	.long	0

	.long	LKRIPTORSO6
	.long	LKRIPTORSO6
;	.long	LKRIPTORSO7
	.long	0
*
* standing legz
*
	.long	LKDEADLEG1			; legz
	.long	0


LKRIPTORSO1
	.long	LKRIPTORSO1A,LKRIPTORSO1B,0
LKRIPTORSO2
	.long	LKRIPTORSO2A,LKRIPTORSO2B,LKRIPTORSO2C,0
LKRIPTORSO3
	.long	LKRIPTORSO3A,0
LKRIPTORSO4
	.long	LKRIPTORSO4A,LKRIPTORSO4B,0
LKRIPTORSO5
	.long	LKRIPTORSO5A,LKRIPTORSO5B,0
LKRIPTORSO6
	.long	LKRIPTORSO6A,LKRIPTORSO6B,0


a_swipe_torso
	.long	LKRIPTORSO1
	.long	LKRIPTORSO2
	.long	LKRIPTORSO3
	.long	LKRIPTORSO4
	.long	LKRIPTORSO5
	.long	LKRIPTORSO6
	.long	0



a_head	.long	LKHEAD1
	.long	LKHEAD2
	.long	LKHEAD3
	.long	LKHEAD4
	.long	LKHEAD5
	.long	LKHEAD6
	.long	LKHEAD7
	.long	ani_jump,a_head


a_decapfall
	.long	LKDECAP1
	.long	LKDECAP2
	.long	LKDECAP3
	.long	0
*
* wobble on yer knees
*
	.long	LKDECAP4
	.long	LKDECAP3
	.long	LKDECAP4
	.long	LKDECAP3
	.long	LKDECAP4
	.long	LKDECAP3
	.long	0
*
* fall to ground
*
	.long	LKDECAP4
	.long	LKDECAP5
	.long	LKDECAP6
	.long	LKDECAP7
	.long	0

LKDECAP1
	.long	LKDEADLEG1A,LKDEADLEG1B
	.long	LKDEADTORSO1A,LKDEADTORSO1B,0
LKDECAP2
	.long	LKDEADLEG2A,LKDEADLEG2B
	.long	LKDEADTORSO2A,LKDEADTORSO2B,LKDEADTORSO2C,0
LKDECAP3
	.long	LKDEADLEG3A,LKDEADLEG3B
	.long	LKDEADTORSO3A,LKDEADTORSO3B,LKDEADTORSO3C,0
LKDECAP4
	.long	LKDEADLEG4A,LKDEADLEG4B
	.long	LKDEADTORSO4A,0
LKDECAP5
	.long	LKDEADLEG5A,LKDEADLEG5B
	.long	LKDEADTORSO5A,0
LKDECAP6
	.long	LKDEADLEG6A,LKDEADLEG6B,LKDEADLEG6C
	.long	LKDEADTORSO6A,LKDEADTORSO6B,0
LKDECAP7
	.long	LKDEADLEG7A,LKDEADLEG7B
	.long	LKDEADTORSO7A,0

LKDEADLEG1
	.long	LKDEADLEG1A,LKDEADLEG1B,0
;LKDEADLEG2
;	.long	LKDEADLEG2A,LKDEADLEG2B,0
;LKDEADLEG3
;	.long	LKDEADLEG3A,LKDEADLEG3B,0
;LKDEADLEG4
;	.long	LKDEADLEG4A,LKDEADLEG4B,0
;LKDEADLEG5
;	.long	LKDEADLEG5A,LKDEADLEG5B,0
;LKDEADLEG6
;	.long	LKDEADLEG6A,LKDEADLEG6B,LKDEADLEG6C,0
;LKDEADLEG7
;	.long	LKDEADLEG7A,LKDEADLEG7B,0
;LKDEADTORSO1
;	.long	LKDEADTORSO1A,LKDEADTORSO1B,0
;LKDEADTORSO2
;	.long	LKDEADTORSO2A,LKDEADTORSO2B,LKDEADTORSO2C,0
;LKDEADTORSO3
;	.long	LKDEADTORSO3A,LKDEADTORSO3B,LKDEADTORSO3C,0
;LKDEADTORSO4
;	.long	LKDEADTORSO4A,0
;LKDEADTORSO5
;	.long	LKDEADTORSO5A,0
;LKDEADTORSO6
;	.long	LKDEADTORSO6A,LKDEADTORSO6B,0
;LKDEADTORSO7
;	.long	LKDEADTORSO7A,0


;****************************************************************


a_back_broke
	.long	LKBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>0a
	.long	LKBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>30
	.long	LKBACKBREAK1
	.long	LKBACKBREAK2
	.long	LKBACKBREAK3
	.long	0
	.long	LKBACKBREAK2
	.long	LKBACKBREAK1
	.long	0

LKBACKBREAK1
	.long	LKBACKBREAK1A,LKBACKBREAK1B,LKBACKBREAK1C,0
LKBACKBREAK2
	.long	LKBACKBREAK2A,LKBACKBREAK2B,LKBACKBREAK2C,0
LKBACKBREAK3
	.long	LKBACKBREAK3A,LKBACKBREAK3B,LKBACKBREAK3C,0

;****************************************************************

a_fb_goro
	.long	ani_adjustxy
	.word	->60,->20
	.long	LKSTUMBLE1

	.long	ani_adjustxy
	.word	>10,->70
	.long	LKKNOCKDOWN6

	.long	ani_adjustxy
	.word	>20,>00
	.long	LKKNOCKDOWN6

	.long	ani_adjustxy
	.word	>3a,>20
	.long	LKKNOCKDOWN5

	.long	ani_adjustxy
	.word	>38,>10
	.long	LKKNOCKDOWN5

	.long	ani_adjustxy
	.word	>00,>68
	.long	LKKNOCKDOWN6

	.long	0

;***************************************************************************

a_lkdragon
	.long	ani_calla,morph_swpal
	.long	LKDRAGON1
	.long	LKDRAGON2
	.long	LKDRAGON3
	.long	LKDRAGON4
	.long	LKDRAGON5
	.long	ani_calla,morph_swpal
	.long	LKDRAGON6
	.long	LKDRAGON7
	.long	LKDRAGON8
	.long	LKDRAGON9
	.long	LKDRAGON10
	.long	0
*
* part 2 = bite
*
	.long	LKDRAGON11
	.long	LKDRAGON12
	.long	LKDRAGON13
	.long	LKDRAGON14
	.long	LKDRAGON15
	.long	0
*
* part 3 = backup
*
	.long	LKDRAGON14
	.long	LKDRAGON13
	.long	LKDRAGON12
	.long	LKDRAGON11
	.long	LKDRAGON10
	.long	0
*
* part 4 = back to kang
*
	.long	LKDRAGON9
	.long	LKDRAGON8
	.long	LKDRAGON7
	.long	LKDRAGON6
	.long	ani_calla,morph_swpal
	.long	LKDRAGON5
	.long	LKDRAGON4
	.long	LKDRAGON3
	.long	LKDRAGON2
	.long	LKDRAGON1
	.long	ani_calla,morph_swpal
	.long	LKSTANCE1
	.long	0


LKDRAGON1
	.long	LKDRAGON1A,LKDRAGON1B,0
LKDRAGON2
	.long	LKDRAGON2A,LKDRAGON2B,0
LKDRAGON3
	.long	LKDRAGON3A,LKDRAGON3B,LKDRAGON3C,0
LKDRAGON4
	.long	LKDRAGON4A,LKDRAGON4B,LKDRAGON4C,LKDRAGON4D
	.long	LKDRAGON4E,0
LKDRAGON5
	.long	LKDRAGON5A,LKDRAGON5B,LKDRAGON5C,LKDRAGON5D
	.long	0
LKDRAGON6
	.long	LKDRAGON6A,LKDRAGON6B,LKDRAGON6C,LKDRAGON6D
	.long	0
LKDRAGON7
	.long	LKDRAGON7A,LKDRAGON7B,LKDRAGON7C,LKDRAGON7D
	.long	0
LKDRAGON8
	.long	LKDRAGON8A,LKDRAGON8B,LKDRAGON8C,LKDRAGON8D
	.long	0
LKDRAGON9
	.long	LKDRAGON9A,LKDRAGON9B,LKDRAGON9C,0
LKDRAGON10
	.long	LKDRAGON10A,LKDRAGON10B,LKDRAGON10C,LKDRAGON10D
	.long	0
LKDRAGON11
	.long	LKDRAGON11A,LKDRAGON11B,LKDRAGON11C,LKDRAGON11D
	.long	0
LKDRAGON12
	.long	LKDRAGON12A,LKDRAGON12B,LKDRAGON12C,LKDRAGON12D
	.long	0
LKDRAGON13
	.long	LKDRAGON13A,LKDRAGON13B,LKDRAGON13C,LKDRAGON13D
	.long	0
LKDRAGON14
	.long	LKDRAGON14A,LKDRAGON14B,LKDRAGON14C,0
LKDRAGON15
	.long	LKDRAGON15A,LKDRAGON15B,LKDRAGON15C,0

;***************************************************************************

a_lkwheel
	.long	LKWHEELKIK1
	.long	LKWHEELKIK2
	.long	LKWHEELKIK3
	.long	LKWHEELKIK4
	.long	LKWHEELKIK5
	.long	0
	.long	LKWHEELKIK6
	.long	LKWHEELKIK7
	.long	0
	.long	LKWHEELKIK8
	.long	LKWHEELKIK9
	.long	0

LKWHEELKIK1
	.long	LKWHEELKIK1A,LKWHEELKIK1B,LKWHEELKIK1C,0
LKWHEELKIK2
	.long	LKWHEELKIK2A,LKWHEELKIK2B,LKWHEELKIK2C,0
LKWHEELKIK3
	.long	LKWHEELKIK3A,LKWHEELKIK3B,LKWHEELKIK3C,0
LKWHEELKIK4
	.long	LKWHEELKIK4A,LKWHEELKIK4B,LKWHEELKIK4C,LKWHEELKIK4D,0
LKWHEELKIK5
	.long	LKWHEELKIK5A,LKWHEELKIK5B,LKWHEELKIK5C,LKWHEELKIK5D,LKWHEELKIK5E,0
LKWHEELKIK6
	.long	LKWHEELKIK6A,LKWHEELKIK6B,LKWHEELKIK6C,0
LKWHEELKIK7
	.long	LKWHEELKIK7A,LKWHEELKIK7B,LKWHEELKIK7C,0
LKWHEELKIK8
	.long	LKWHEELKIK8A,LKWHEELKIK8B,LKWHEELKIK8C,LKWHEELKIK8D,0
LKWHEELKIK9
	.long	LKWHEELKIK9A,LKWHEELKIK9B,LKWHEELKIK9C,0

;***************************************************************************


	.end
