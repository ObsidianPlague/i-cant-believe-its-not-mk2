**************************************************************************
*											     *
*  video game project:	mortal kombat 2							*
* 											     *
*  game software:    	ed boon								     *
* 											     *
*  module: hathead										*
*											     *
**************************************************************************
	.FILE	'MK1.ASM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
*
* GET THE SYSTEM STUFF
*
	.INCLUDE	MAINEQU.ASM
	.INCLUDE	MKHH.TBL
	.INCLUDE	IMGTBL.GLO
	.include	diagaudn.asm

	.TEXT

	.ref	POWERUP,aud1

hat_anitab1
	.long	a_hhstance	;  0 - stance
	.long	a_hhwalkf	;  1 - walk forward
	.long	a_hhskipf	;  2 - skip forward
	.long	a_hhwalkb	;  3 - walk backward
	.long	a_hhskipb	;  4 - walk backward
	.long	a_hhduck  	;  5 - duck animation
	.long	a_hhjumpup	;  6 - jump straight up
	.long	a_hhfflip	;  7 - forward flip
	.long	a_hhbflip	;  8 - backward flip
	.long	a_hhturn	;  9 - turn around
	.long	a_hhduckturn	;  A - turn around while ducking
	.long	a_hhblockhi	;  B - standing block
	.long	a_hhduckblock	;  C - ducking block
	.long	a_hhhikick	;  D - hi kick
	.long	a_hhlokick	;  E - lo kick
	.long	a_hhkdown	;  F - knocked down
	.long	a_hhhithi	; 10 - hit high
	.long	a_hhhitlo	; 11 - hit low
	.long	a_hhgetup	; 12 - normal getup
	.long	a_hhhipunch	; 13 - hi punch
	.long	a_hhlopunch	; 14 - lo punch
	.long	a_hhsweep	; 15 - sweep kick
	.long	a_hhsweepfall	; 16 - sweep fall
	.long	a_hhsweepup	; 17 - getup from sweep kick
	.long	a_hhduckpunch	; 18 - duck punch
	.long	a_hhduckkickh	; 19 - duck kick high
	.long	a_hhduckkickl	; 1a - duck kick low
	.long	a_hhduckhit	; 1b - hit while ducking
	.long	a_hhuppercut	; 1c - uppercut
	.long	a_hhjumpupkick	; 1d - jump straight up kick
	.long	a_hhflipkick	; 1e - flip kick
	.long	a_hhflippunch	; 1f - flip punch
	.long	a_hhroundh	; 20 - roundhouse kick
	.long	a_hhknee	; 21 - knee
	.long	a_hhelbow	; 22 - elbow
	.long	a_hhstumble	; 23 - stumble back
	.long	a_hhbodyslam	; 24 - body slam
	.long	a_shredded	; 25 -
	.long	a_hhprojectile	; 26 - throwing his hat
	.long	a_hhhatfly	; 27 - hat flying
	.long	a_hhstunned	; 28 - stunned
	.long	a_victory	; 29 - victory

	.long	a_hh_fb_hh	; 2a - hathead flipped by hh
	.long	a_hh_fb_lk	; 2b - hathead flipped by liu kang
	.long	a_hh_fb_jc	; 2c - hathead flipped by cage
	.long	a_hh_fb_sa	; 2d - hathead flipped by sword arms
	.long	a_hh_fb_fn	; 2e - hathead flipped by female ninja
	.long	a_hh_fb_fn	; 2f - hathead flipped by female ninja
	.long	a_hh_fb_st	; 30 - hathead flipped by shang tsung
	.long	a_hh_fb_rd	; 31 - hathead flipped by raiden
	.long	a_hh_fb_nj	; 32 - hathead flipped by ninja
	.long	a_hh_fb_nj	; 33 - hathead flipped by ninja
	.long	a_hh_fb_nj	; 34 - hathead flipped by ninja
	.long	a_hh_fb_jx	; 35 - hathead flipped by jax

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
	.long	a_change	; 40 -
	.long	a_swipe_torso	; 41 - scorpion swiped me torso

hat_anitab2
	.long	a_hatappear	; 0 - hat reappearing
	.long	a_spin		; 1 - hathead spin move
	.long	a_aura		; 2
	.long	dummy		; 3
	.long	dummy		; 4
	.long	a_impaled	; 5

**************************************************************************
*											     *
*  Hathead: Stance									     *
*											     *
**************************************************************************
dummy
a_hhstance
	.long	TMSTANCE1
	.long	TMSTANCE2
	.long	TMSTANCE3
	.long	TMSTANCE4
	.long	TMSTANCE5
	.long	TMSTANCE6
	.long	TMSTANCE7
	.long	TMSTANCE8
	.long	ani_jump,a_hhstance

TMSTANCE1
	.long	TMSTANCE1A,TMSTANCE1B,0
TMSTANCE2
	.long	TMSTANCE2A,TMSTANCE2B,0
TMSTANCE3
	.long	TMSTANCE3A,TMSTANCE3B,0
TMSTANCE4
	.long	TMSTANCE4A,TMSTANCE4B,0
TMSTANCE5
	.long	TMSTANCE5A,TMSTANCE5B,0
TMSTANCE6
	.long	TMSTANCE6A,TMSTANCE6B,0
TMSTANCE7
	.long	TMSTANCE7A,TMSTANCE7B,0
TMSTANCE8
	.long	TMSTANCE8A,TMSTANCE8B,0

**************************************************************************
*											     *
*  Hathead: Walk										     *
*											     *
**************************************************************************
a_hhwalkf
	.long	TMWALK1
	.long	TMWALK2
	.long	TMWALK3
	.long	TMWALK4
	.long	TMWALK5
	.long	TMWALK6
	.long	TMWALK7
	.long	TMWALK8
	.long	TMWALK9
	.long	ani_jump,a_hhwalkf

a_hhskipf
	.long	TMWALK1
	.long	TMWALK2
	.long	TMWALK8
	.long	TMWALK9
	.long	0

a_hhwalkb
	.long	TMWALK9
	.long	TMWALK8
	.long	TMWALK7
	.long	TMWALK6
	.long	TMWALK5
	.long	TMWALK4
	.long	TMWALK3
	.long	TMWALK2
	.long	TMWALK1
	.long	ani_jump,a_hhwalkb

a_hhskipb
	.long	TMWALK9
	.long	TMWALK8
	.long	TMWALK2
	.long	TMWALK1
	.long	0

TMWALK1	.long	TMWALKLEG1A,TMWALKLEG1B,TMWALKTORSO1A,TMWALKTORSO1B,0
TMWALK2	.long	TMWALKLEG2A,TMWALKLEG2B,TMWALKTORSO2A,TMWALKTORSO2B,0
TMWALK3	.long	TMWALKLEG3A,TMWALKTORSO3A,TMWALKTORSO3B,0
TMWALK4	.long	TMWALKLEG4A,TMWALKLEG4B,TMWALKTORSO4A,TMWALKTORSO4B,0
TMWALK5	.long	TMWALKLEG5A,TMWALKLEG5B,TMWALKTORSO5A,TMWALKTORSO5B,0
TMWALK6	.long	TMWALKLEG6A,TMWALKLEG6B,TMWALKTORSO6A,TMWALKTORSO6B,0
TMWALK7	.long	TMWALKLEG7A,TMWALKLEG7B,TMWALKTORSO7A,TMWALKTORSO7B,0
TMWALK8	.long	TMWALKLEG8A,TMWALKLEG8B,TMWALKTORSO8A,TMWALKTORSO8B,0
TMWALK9	.long	TMWALKLEG9A,TMWALKLEG9B,TMWALKTORSO9A,TMWALKTORSO9B,0

**************************************************************************
*											     *
*  Hathead: Duck										     *
*											     *
**************************************************************************
a_hhduck
	.long	TMDUCK1
	.long	TMDUCK2
	.long	TMDUCK3
	.long	0

TMDUCK1	.long	TMDUCK1A,TMDUCK1B,0
TMDUCK2	.long	TMDUCK2A,TMDUCK2B,0
TMDUCK3	.long	TMDUCK3A,TMDUCK3B,0

**************************************************************************
*											     *
*  Hathead: Jump straight up								     *
*											     *
**************************************************************************
a_hhjumpup
	.long	TMJUMP2
	.long	TMJUMP3
	.long	0
	.long	TMJUMP2
	.long	TMJUMP1
	.long	0

TMJUMP1	.long	TMJUMP1A,TMJUMP1B,0
TMJUMP2	.long	TMJUMP2A,TMJUMP2B,0
TMJUMP3	.long	TMJUMP3A,TMJUMP3B,0


**************************************************************************
*											     *
*  Hathead: Forward flip									     *
*											     *
**************************************************************************
a_hhfflip
	.long	TMJUMPFLIP1
	.long	TMJUMPFLIP2
	.long	TMJUMPFLIP3
	.long	TMJUMPFLIP4
	.long	TMJUMPFLIP5
	.long	TMJUMPFLIP6
	.long	TMJUMPFLIP7
	.long	TMJUMPFLIP8
	.long	ani_jump,a_hhfflip+32

a_hhbflip
	.long	TMJUMPFLIP1
	.long	TMJUMPFLIP8
	.long	TMJUMPFLIP7
	.long	TMJUMPFLIP6
	.long	TMJUMPFLIP5
	.long	TMJUMPFLIP4
	.long	TMJUMPFLIP3
	.long	TMJUMPFLIP2
	.long	ani_jump,a_hhbflip+32

TMJUMPFLIP1
	.long	TMJUMPFLIP1A,TMJUMPFLIP1B,0
TMJUMPFLIP2
	.long	TMJUMPFLIP2A,0
TMJUMPFLIP3
	.long	TMJUMPFLIP3A,0
TMJUMPFLIP4
	.long	TMJUMPFLIP4A,0
TMJUMPFLIP5
	.long	TMJUMPFLIP5A,0
TMJUMPFLIP6
	.long	TMJUMPFLIP6A,0
TMJUMPFLIP7
	.long	TMJUMPFLIP7A,0
TMJUMPFLIP8
	.long	TMJUMPFLIP8A,0

**************************************************************************
*											     *
*  Hathead: Turnaround									     *
*											     *
**************************************************************************
a_hhturn
	.long	TMTURN1
	.long	ani_flip
	.long	ani_adjustx
	.word	-6
	.long	TMTURN1
	.long	0

TMTURN1	.long	TMTURN1A,TMTURN1B,0

**************************************************************************
*											     *
*  Hathead: Duck Turnaround	  							     *
*											     *
**************************************************************************
a_hhduckturn
	.long	TMDUCKTURN1
	.long	TMDUCKTURN2
	.long	ani_flip  
	.long	ani_adjustx
	.word	-8
	.long	TMDUCKTURN1
	.long	TMDUCK3
	.long	0

TMDUCKTURN1
	.long	TMDUCKTURN1A,TMDUCKTURN1B,0
TMDUCKTURN2
	.long	TMDUCKTURN2A,TMDUCKTURN2B,0

**************************************************************************
*											     *
*  Hathead: Standing block									*
*											     *
**************************************************************************
a_hhblockhi
	.long	TMHIBLOCK1
	.long	TMHIBLOCK2
	.long	TMHIBLOCK3
	.long	0

	.long	TMHIBLOCK2
	.long	TMHIBLOCK1
	.long	0

TMHIBLOCK1
	.long	TMHIBLOCK1A,TMHIBLOCK1B,0
TMHIBLOCK2
	.long	TMHIBLOCK2A,TMHIBLOCK2B,0
TMHIBLOCK3
	.long	TMHIBLOCK3A,TMHIBLOCK3B,0

**************************************************************************
*											     *
*  Hathead: Ducking block									*
*											     *
**************************************************************************
a_hhduckblock
	.long	TMDUCKBLOCK1
	.long	TMDUCKBLOCK2
	.long	TMDUCKBLOCK3
	.long	0
	.long	TMDUCKBLOCK2
	.long	TMDUCKBLOCK1
	.long	TMDUCK3
	.long	0

TMDUCKBLOCK1
	.long	TMDUCKBLOCK1A,TMDUCKBLOCK1B,0
TMDUCKBLOCK2
	.long	TMDUCKBLOCK2A,TMDUCKBLOCK2B,0
TMDUCKBLOCK3
	.long	TMDUCKBLOCK3A,TMDUCKBLOCK3B,0

**************************************************************************
*											     *
*  Hathead: High Kick									     *
*											     *
**************************************************************************
a_hhhikick
	.long	TMHIKICK1
	.long	TMHIKICK2
	.long	TMHIKICK3
	.long	TMHIKICK4
	.long	TMHIKICK5
	.long	TMHIKICK6
	.long	0
	.long	TMHIKICK5
	.long	TMHIKICK4
	.long	TMHIKICK3
	.long	TMHIKICK2
	.long	TMHIKICK1
	.long	0

TMHIKICK1
	.long	TMHIKICK1A,TMHIKICK1B,0
TMHIKICK2
	.long	TMHIKICK2A,0
TMHIKICK3
	.long	TMHIKICK3A,0
TMHIKICK4
	.long	TMHIKICK4A,TMHIKICK4B,0
TMHIKICK5
	.long	TMHIKICK5A,TMHIKICK5B,0
TMHIKICK6
	.long	TMHIKICK6A,TMHIKICK6B,0

**************************************************************************
*											     *
*  Hathead: Low Kick									     *
*											     *
**************************************************************************
a_hhlokick
	.long	TMHIKICK1
	.long	TMHIKICK2
	.long	TMHIKICK3
	.long	TMHIKICK4
	.long	TMHIKICK5
	.long	TMLOKICK1
	.long	0
	.long	TMHIKICK5
	.long	TMHIKICK4
	.long	TMHIKICK3
	.long	TMHIKICK2
	.long	TMHIKICK1
	.long	0

TMLOKICK1
	.long	TMLOKICK1A,TMLOKICK1B,0

**************************************************************************
*											     *
*  Hathead: Sweep kick									     *
*											     *
**************************************************************************
a_hhsweep
	.long	TMDUCK1
	.long	TMSWEEPKIK1
	.long	TMSWEEPKIK2
	.long	ani_calla,sweep_sounds
	.long	TMSWEEPKIK3
	.long	TMSWEEPKIK4
	.long	0
	.long	TMSWEEPKIK5
	.long	TMSWEEPKIK6
	.long	0

TMSWEEPKIK1
	.long	TMSWEEPKIK1A,TMSWEEPKIK1B,0
TMSWEEPKIK2
	.long	TMSWEEPKIK2A,TMSWEEPKIK2B,0
TMSWEEPKIK3
	.long	TMSWEEPKIK3A,TMSWEEPKIK3B,0
TMSWEEPKIK4
	.long	TMSWEEPKIK4A,TMSWEEPKIK4B,0
TMSWEEPKIK5
	.long	TMSWEEPKIK5A,TMSWEEPKIK5B,0
TMSWEEPKIK6
	.long	TMSWEEPKIK6A,TMSWEEPKIK6B,0

**************************************************************************
*											     *
*  Hathead: Sweep fall									     *
*											     *
**************************************************************************
a_hhsweepfall
	.long	TMSWEEPFALL1
	.long	TMSWEEPFALL2
	.long	TMSWEEPFALL3
	.long	TMSWEEPFALL4
	.long	0
	.long	TMSWEEPFALL5
	.long	TMSWEEPFALL6
	.long	0

TMSWEEPFALL1
	.long	TMSWEEPFALL1A,TMSWEEPFALL1B,0
TMSWEEPFALL2
	.long	TMSWEEPFALL2A,TMSWEEPFALL2B,0
TMSWEEPFALL3
	.long	TMSWEEPFALL3A,TMSWEEPFALL3B,0
TMSWEEPFALL4
	.long	TMSWEEPFALL4A,TMSWEEPFALL4B,0
TMSWEEPFALL5
	.long	TMSWEEPFALL5A,TMSWEEPFALL5B,0
TMSWEEPFALL6
	.long	TMSWEEPFALL6A,TMSWEEPFALL6B,0

**************************************************************************
*											     *
*  Hathead: Sweep up									     *
*											     *
**************************************************************************
a_hhsweepup
	.long	TMSWEEPUP1
	.long	TMSWEEPUP2
	.long	TMSWEEPUP3
	.long	TMSWEEPUP4
	.long	TMSWEEPUP5
	.long	0

TMSWEEPUP1
	.long	TMSWEEPUP1A,0
TMSWEEPUP2
	.long	TMSWEEPUP2A,TMSWEEPUP2B,0
	.long	0
TMSWEEPUP3
	.long	TMSWEEPUP3A,TMSWEEPUP3B,0
TMSWEEPUP4
	.long	TMSWEEPUP4A,TMSWEEPUP4B,0
	.long	0
TMSWEEPUP5
	.long	TMSWEEPUP5A,TMSWEEPUP5B,TMSWEEPUP5C,0

**************************************************************************
*											     *
*  Hathead: Knocked down									     *
*											     *
**************************************************************************
a_hhkdown
	.long	TMKNOCKDOWN1
	.long	TMKNOCKDOWN2
	.long	TMKNOCKDOWN3
	.long	TMKNOCKDOWN4
	.long	TMKNOCKDOWN5
	.long	0
*
* part 2 = landing on back
*
	.long	TMKNOCKDOWN6
	.long	TMKNOCKDOWN7
	.long	0
*
* part 3 = shake on the ground
*
	.long	TMKNOCKDOWN6
	.long	TMKNOCKDOWN7
	.long	TMKNOCKDOWN6
	.long	TMKNOCKDOWN7
	.long	0


TMKNOCKDOWN1
	.long	TMKNOCKDOWN1A,TMKNOCKDOWN1B,0
	.long	0
TMKNOCKDOWN2
	.long	TMKNOCKDOWN2A,TMKNOCKDOWN2B,0
	.long	0
TMKNOCKDOWN3
	.long	TMKNOCKDOWN3A,TMKNOCKDOWN3B,0
TMKNOCKDOWN4
	.long	TMKNOCKDOWN4A,TMKNOCKDOWN4B,0
	.long	0
TMKNOCKDOWN5
	.long	TMKNOCKDOWN5A,TMKNOCKDOWN5B,0
	.long	0
TMKNOCKDOWN6
	.long	TMKNOCKDOWN6A,TMKNOCKDOWN6B,0
	.long	0
TMKNOCKDOWN7
	.long	TMKNOCKDOWN7A,TMKNOCKDOWN7B,0

**************************************************************************
*											     *
*  Hathead: Hit high									     *
*											     *
**************************************************************************
a_hhhithi
	.long	TMHIHIT2
	.long	TMHIHIT3
	.long	TMHIHIT2
	.long	TMHIHIT1
	.long	0

TMHIHIT1
	.long	TMHIHIT1A,TMHIHIT1B,0
TMHIHIT2
	.long	TMHIHIT2A,TMHIHIT2B,0
TMHIHIT3
	.long	TMHIHIT3A,TMHIHIT3B,0

**************************************************************************
*											     *
*  Hathead: Hit low									     *
*											     *
**************************************************************************
a_hhhitlo
	.long	TMLOHIT2
	.long	TMLOHIT3
	.long	TMLOHIT2
	.long	TMLOHIT1
	.long	0

TMLOHIT1
	.long	TMLOHIT1A,TMLOHIT1B,0
TMLOHIT2
	.long	TMLOHIT2A,TMLOHIT2B,0
TMLOHIT3
	.long	TMLOHIT3A,TMLOHIT3B,0

**************************************************************************
*											     *
*  Hathead: Getup (normal)								     *
*											     *
**************************************************************************
a_hhgetup
	.long	TMGETUP1
	.long	TMGETUP2
	.long	TMGETUP3
	.long	TMGETUP4
	.long	0

TMGETUP1	.long	TMGETUP1A,TMGETUP1B,TMGETUP1C,0
TMGETUP2	.long	TMGETUP2A,0
TMGETUP3	.long	TMGETUP3A,TMGETUP3B,0
TMGETUP4	.long	TMGETUP4A,TMGETUP4B,0

**************************************************************************
*											     *
*  Hathead: Hi punch									     *
*											     *
**************************************************************************
a_hhhipunch
	.long	TMHIPUNCH1
	.long	TMHIPUNCH2
hathip3	.long	TMHIPUNCH3
	.long	0

hathip4	.long	TMHIPUNCH4
	.long	TMHIPUNCH5
	.long	TMHIPUNCH6
	.long	0

	.long	TMHIPUNCH5
	.long	TMHIPUNCH4
	.long	ani_jump,hathip3
	.long	0			; we NEED this "0"
*
* Unhipunch #1
*
	.long	TMHIPUNCH2
	.long	TMHIPUNCH1
	.long	0
*
* Unhipunch #2
*
	.long	TMHIPUNCH7
	.long	0
*
* Hi to Med #1
*
	.long	TMHIPUNCH4
	.long	TMLOPUNCH5
	.long	ani_jump,hatlop6
	.long	0
*
* Hi to Med #2
*
	.long	TMHIPUNCH5
	.long	TMHIPUNCH4
	.long	ani_jump,hatlop3


TMHIPUNCH1
	.long	TMHIPUNCH1A,TMHIPUNCH1B,0
TMHIPUNCH2
	.long	TMHIPUNCH2A,TMHIPUNCH2B,TMHIPUNCH2C1,0
TMHIPUNCH3
	.long	TMHIPUNCH3A,TMHIPUNCH3B,TMHIPUNCH3C,0
TMHIPUNCH4
	.long	TMHIPUNCH4A,TMHIPUNCH4B,0
TMHIPUNCH5
	.long	TMHIPUNCH5A,TMHIPUNCH5B,TMHIPUNCH5C1,0
TMHIPUNCH6
	.long	TMHIPUNCH6A,TMHIPUNCH6B,TMHIPUNCH6C,0
TMHIPUNCH7
	.long	TMHIPUNCH7A,TMHIPUNCH7B,TMHIPUNCH7C,0

**************************************************************************
*											     *
*  Hathead: Lo punch									     *
*											     *
**************************************************************************
a_hhlopunch
	.long	TMHIPUNCH1
	.long	TMLOPUNCH2
hatlop3	.long	TMLOPUNCH3
	.long	0
	.long	TMHIPUNCH4
	.long	TMLOPUNCH5
hatlop6	.long	TMLOPUNCH6
	.long	0

	.long	TMLOPUNCH5
	.long	TMHIPUNCH4
	.long	ani_jump,hatlop3
	.long	0			; we NEED this "0"
*
* Unlopunch #1
*
	.long	TMLOPUNCH2
	.long	TMHIPUNCH1
	.long	0
*
* Unlopunch #2
*
	.long	TMHIPUNCH7
	.long	0
*
* Med to High #1
*
	.long	ani_jump,hathip4
	.long	0
*
* Med to High #2
*
	.long	TMLOPUNCH5
	.long	TMHIPUNCH4
	.long	ani_jump,hathip3

TMLOPUNCH2
	.long	TMHIPUNCH2A,TMHIPUNCH2B,TMHIPUNCH2C2,0
TMLOPUNCH3
	.long	TMLOPUNCH1A,TMLOPUNCH1B,TMLOPUNCH1C,0
TMLOPUNCH5
	.long	TMHIPUNCH5A,TMHIPUNCH5B,TMHIPUNCH5C2,0
TMLOPUNCH6
	.long	TMLOPUNCH2A,TMLOPUNCH2B,TMLOPUNCH2C,0

**************************************************************************
*											     *
*  Hathead: Duck punch									     *
*											     *
**************************************************************************
a_hhduckpunch
	.long	ani_calla,punch_sounds
	.long	TMDUCKPUNCH1
	.long	TMDUCKPUNCH2
	.long	TMDUCKPUNCH3
	.long	0
	.long	TMDUCKPUNCH2
	.long	TMDUCKPUNCH1
	.long	TMDUCK3
	.long	0

TMDUCKPUNCH1
	.long	TMDUCKPUNCH1A,TMDUCKPUNCH1B,0
TMDUCKPUNCH2
	.long	TMDUCKPUNCH2A,TMDUCKPUNCH2B,TMDUCKPUNCH2C,0
TMDUCKPUNCH3
	.long	TMDUCKPUNCH3A,TMDUCKPUNCH3B,TMDUCKPUNCH3C,0

**************************************************************************
*											     *
*  Hathad: Duck kick high								     *
*											     *
**************************************************************************
a_hhduckkickh
	.long	TMLODUCKIK1
	.long	ani_calla,kick_sounds
	.long	TMHIDUCKIK1
	.long	TMHIDUCKIK2
	.long	0
	.long	TMHIDUCKIK1
	.long	TMLODUCKIK1
	.long	TMDUCK3
	.long	0

TMHIDUCKIK1
	.long	TMHIDUCKIK1A,TMHIDUCKIK1B,TMHIDUCKIK1C,0
TMHIDUCKIK2
	.long	TMHIDUCKIK2A,TMHIDUCKIK2B,TMHIDUCKIK2C,0

**************************************************************************
*											     *
*  Hathad: Duck kick low									     *
*											     *
**************************************************************************
a_hhduckkickl
	.long	TMLODUCKIK1
	.long	ani_calla,kick_sounds
	.long	TMLODUCKIK2
	.long	TMLODUCKIK3
	.long	TMLODUCKIK4
	.long	0
	.long	TMLODUCKIK3
	.long	TMLODUCKIK2
	.long	TMLODUCKIK1
	.long	TMDUCK3
	.long	0

TMLODUCKIK1
	.long	TMLODUCKIK1A,TMLODUCKIK1B,0
TMLODUCKIK2
	.long	TMLODUCKIK2A,TMLODUCKIK2B,TMLODUCKIK2C,0
TMLODUCKIK3
	.long	TMLODUCKIK3A,TMLODUCKIK3B,TMLODUCKIK3C,0
TMLODUCKIK4
	.long	TMLODUCKIK4A,TMLODUCKIK4B,TMLODUCKIK4C,0

**************************************************************************
*											     *
*  Hathead: Duck hit									     *
*											     *
**************************************************************************
a_hhduckhit
	.long	TMDUCKHIT2
	.long	TMDUCKHIT3
	.long	TMDUCKHIT2
	.long	TMDUCKHIT1
	.long	TMDUCK3
	.long	0

TMDUCKHIT1
	.long	TMDUCKHIT1A,TMDUCKHIT1B,0
TMDUCKHIT2
	.long	TMDUCKHIT2A,TMDUCKHIT2B,0
TMDUCKHIT3
	.long	TMDUCKHIT3A,TMDUCKHIT3B,0

**************************************************************************
*											     *
*  Hathead: Uppercut									     *
*											     *
**************************************************************************
a_hhuppercut
	.long	TMUPPERCUT1
	.long	TMUPPERCUT2
	.long	TMUPPERCUT3
	.long	TMUPPERCUT4
	.long	ani_nosleep	; dont sleep after next frame
	.long	TMUPPERCUT5
	.long	0
	.long	TMHIPUNCH4
	.long	0

TMUPPERCUT1
	.long	TMUPPERCUT1A,TMUPPERCUT1B,0
TMUPPERCUT2
	.long	TMUPPERCUT2A,TMUPPERCUT2B,TMUPPERCUT2C,0
TMUPPERCUT3
	.long	TMUPPERCUT3A,TMUPPERCUT3B,TMUPPERCUT3B,0
TMUPPERCUT4
	.long	TMUPPERCUT4A,TMUPPERCUT4B,TMUPPERCUT4C,0
TMUPPERCUT5
	.long	TMUPPERCUT5A,TMUPPERCUT5B,0


a_hhjumpupkick
	.long	TMJUMPKICK1
	.long	TMJUMPKICK2
	.long	0
	.long	TMJUMPKICK1
	.long	0

a_hhflipkick
	.long	TMFLIPKICK1
	.long	TMFLIPKICK2
	.long	TMFLIPKICK3
	.long	0
	.long	TMFLIPKICK2
	.long	TMFLIPKICK1
	.long	0

a_hhflippunch
	.long	TMFLIPUNCH1
	.long	TMFLIPUNCH2
	.long	TMFLIPUNCH3
	.long	0
	.long	TMFLIPUNCH2
	.long	TMFLIPUNCH1
	.long	0

TMJUMPKICK1
	.long	TMJUMPKICK1A,TMJUMPKICK1B,TMJUMPKICK1C,0
TMJUMPKICK2
	.long	TMJUMPKICK2A,TMJUMPKICK2B,0
TMFLIPUNCH1
	.long	TMFLIPUNCH1A,TMFLIPUNCH1B,TMFLIPUNCH1C,0
TMFLIPUNCH2
	.long	TMFLIPUNCH2A,TMFLIPUNCH2B,TMFLIPUNCH2C,0

TMFLIPUNCH3
	.long	TMFLIPUNCH3A,TMFLIPUNCH3B,TMFLIPUNCH3C,0
TMFLIPKICK3
	.long	TMFLIPKICK3A,TMFLIPKICK3B,TMFLIPKICK3C,0

TMFLIPKICK1
	.long	TMFLIPKICK1A,TMFLIPKICK1B,0
TMFLIPKICK2
	.long	TMFLIPKICK2A,TMFLIPKICK2B,TMFLIPKICK2C,0

**************************************************************************

a_hhroundh
	.long	TMROUNDKIK1
	.long	TMROUNDKIK2
	.long	TMROUNDKIK3
	.long	0
	.long	TMROUNDKIK4
	.long	TMROUNDKIK5
	.long	TMROUNDKIK6
	.long	TMROUNDKIK7
	.long	0

TMROUNDKIK1
	.long	TMROUNDKIK1A,0
TMROUNDKIK2
	.long	TMROUNDKIK2A,TMROUNDKIK2B,0
TMROUNDKIK3
	.long	TMROUNDKIK3A,TMROUNDKIK3B,0
TMROUNDKIK4
	.long	TMROUNDKIK4A,TMROUNDKIK4B,0
TMROUNDKIK5
	.long	TMROUNDKIK5A,TMROUNDKIK5B,0
TMROUNDKIK6
	.long	TMROUNDKIK6A,TMROUNDKIK6B,0
TMROUNDKIK7
	.long	TMROUNDKIK7A,TMROUNDKIK7B,0

a_hhknee
	.long	TMKNEE1
	.long	TMKNEE2
	.long	TMKNEE3
	.long	0
	.long	TMKNEE2
	.long	TMKNEE1
	.long	0

TMKNEE1
	.long	TMKNEE1A,TMKNEE1B,0
TMKNEE2
	.long	TMKNEE2A,0
TMKNEE3
	.long	TMKNEE3A,TMKNEE3B,0


a_hhelbow
	.long	TMHEDSWIPE1
	.long	TMHEDSWIPE2
	.long	0
	.long	TMHEDSWIPE3
	.long	TMHEDSWIPE4
	.long	0

TMHEDSWIPE1
	.long	TMHEDSWIPE1A,TMHEDSWIPE1B,0
TMHEDSWIPE2
	.long	TMHEDSWIPE2A,TMHEDSWIPE2B,TMHEDSWIPE2C,0
TMHEDSWIPE3
	.long	TMHEDSWIPE3A,TMHEDSWIPE3B,0
TMHEDSWIPE4
	.long	TMHEDSWIPE4A,TMHEDSWIPE4B,0


a_hhstumble
	.long	TMSTUMBLE1
	.long	TMSTUMBLE2
	.long	TMSTUMBLE3
	.long	TMSTUMBLE4
	.long	TMSTUMBLE5
	.long	TMSTUMBLE6
	.long	0

TMSTUMBLE1
	.long	TMSTUMBLE1A,TMSTUMBLE1B,0
TMSTUMBLE2
	.long	TMSTUMBLE2A,TMSTUMBLE2B,0
TMSTUMBLE3
	.long	TMSTUMBLE3A,0
TMSTUMBLE4
	.long	TMSTUMBLE4A,0
TMSTUMBLE5
	.long	TMSTUMBLE5A,TMSTUMBLE5B,0
TMSTUMBLE6
	.long	TMSTUMBLE6A,TMSTUMBLE6B,0

;*********************************************************************

a_shredded
	.long	ani_adjustxy
	.word	6,6
	.long	TMSTUMBLE1

	.long	ani_adjustxy
	.word	-6,-6
	.long	TMSTUMBLE2

	.long	ani_adjustxy
	.word	6,6
	.long	TMSTUMBLE3

	.long	ani_adjustxy
	.word	-6,-6
	.long	TMSTUMBLE2

	.long	ani_jump,a_shredded

;*********************************************************************


a_hhbodyslam
	.long	TMFLIPS1
	.long	TMFLIPS2
	.long	ani_adjustxy
	.word	>10,>00
	.long	TMFLIPS3
	.long	ani_adjustxy
	.word	>34,>00
	.long	TMFLIPS4
	.long	ani_adjustxy
	.word	>24,>00
	.long	TMFLIPS5
	.long	ani_adjustxy
	.word	>0a,>00
	.long	TMFLIPS6
	.long	TMFLIPS7
	.long	0

	.long	TMFLIPS1	; borrow this frame
	.long	TMFLIPS8
	.long	0
	.long	TMSWEEPKIK6
	.long	0
	

TMFLIPS1
	.long	TMFLIPS1A,TMFLIPS1B,TMFLIPS1C,0
TMFLIPS2
	.long	TMFLIPS2A,TMFLIPS2B,TMFLIPS2C,0
TMFLIPS3
	.long	TMFLIPS3A,TMFLIPS3B,TMFLIPS3C,0
TMFLIPS4
	.long	TMFLIPS4A,TMFLIPS4B,TMFLIPS4C,0
TMFLIPS5
	.long	TMFLIPS5A,TMFLIPS5B,TMFLIPS5C,TMFLIPS5D
	.long	0
TMFLIPS6
	.long	TMFLIPS6A,TMFLIPS6B,TMFLIPS6C,TMFLIPS6D
	.long	0
TMFLIPS7
	.long	TMFLIPS7A,TMFLIPS7B,0
TMFLIPS8
	.long	TMFLIPS8A,TMFLIPS8B,TMFLIPS8C,TMFLIPS8D
	.long	0


a_hhprojectile
	.long	TMTHROW1
	.long	TMTHROW2
	.long	TMTHROW3
	.long	0

TMTHROW1
	.long	TMTHROW1A,TMTHROW1B,0
TMTHROW2
	.long	TMTHROW2A,TMTHROW2B,TMTHROW2C,0
TMTHROW3
	.long	TMTHROW3A,TMTHROW3B,0

a_hhhatfly
	.long	hatfly1

	.long	ani_adjustxy
	.word	>60,>30

	.long	hatfly2
	.long	hatfly3
	.long	hatfly3

j_hatloop
	.long	hatfly4
	.long	hatfly5
	.long	ani_jump,j_hatloop

	.long	0
	.long	hatfly8
	.long	hatfly9
	.long	hatfly10
	.long	hatfly11
	.long	0

hatfly1	.long	HATFLY1A,HATFLY1B,HATFLY1C,0
hatfly2	.long	HATFLY2,0
hatfly3	.long	HATFLY3,0
hatfly4	.long	HATFLY4,0
hatfly5	.long	HATFLY5,0
hatfly8	.long	HATFLY8,0
hatfly9	.long	HATFLY9,0
hatfly10	.long	HATFLY10,0
hatfly11	.long	HATFLY11,0


a_hatappear
	.long	HATAPPEAR1
	.long	HATAPPEAR2
	.long	HATAPPEAR3
	.long	HATAPPEAR4
	.long	HATAPPEAR5
	.long	HATAPPEAR6
	.long	HATAPPEAR7
	.long	HATAPPEAR8
	.long	HATAPPEAR9
	.long	0


a_hhstunned
	.long	TMSTUNNED1
	.long	TMSTUNNED2
	.long	TMSTUNNED3
	.long	TMSTUNNED4
	.long	TMSTUNNED5
	.long	TMSTUNNED6
	.long	TMSTUNNED7
	.long	ani_jump,a_hhstunned

TMSTUNNED1
	.long	TMSTUNNED1A,TMSTUNNED1B,0
TMSTUNNED2
	.long	TMSTUNNED2A,TMSTUNNED2B,0
TMSTUNNED3
	.long	TMSTUNNED3A,TMSTUNNED3B,0
TMSTUNNED4
	.long	TMSTUNNED4A,TMSTUNNED4B,0
TMSTUNNED5
	.long	TMSTUNNED5A,TMSTUNNED5B,0
TMSTUNNED6
	.long	TMSTUNNED6A,TMSTUNNED6B,0
TMSTUNNED7
	.long	TMSTUNNED7A,TMSTUNNED7B,0



a_victory
	.long	TMVICTORY1
	.long	TMVICTORY2
	.long	TMVICTORY3

	.long	TMVICTORY3	; pause here

	.long	TMVICTORY4
	.long	TMVICTORY5
	.long	TMVICTORY6
	.long	TMVICTORY7
	.long	TMVICTORY8
	.long	0

TMVICTORY1
	.long	TMVICTORY1A,TMVICTORY1B,0
TMVICTORY2
	.long	TMVICTORY2A,TMVICTORY2B,0
TMVICTORY3
	.long	TMVICTORY3A,TMVICTORY3B,TMVICTORY3C,TMVICTORY3D,0
TMVICTORY4
	.long	TMVICTORY4A,TMVICTORY4B,TMVICTORY4C,TMVICTORY4D,0
TMVICTORY5
	.long	TMVICTORY5A,TMVICTORY5B,0
TMVICTORY6
	.long	TMVICTORY6A,TMVICTORY6B,TMVICTORY6C,0
TMVICTORY7
	.long	TMVICTORY7A,TMVICTORY7B,TMVICTORY7C,0
TMVICTORY8
	.long	TMVICTORY8A,TMVICTORY8B,0


a_banged
	.long	TMFLIPPED1
	.long	TMFLIPPED2
	.long	TMFLIPPED3
	.long	TMFLIPPED4
	.long	0

a_hh_fb_nj
	.long	ani_adjustxy
	.word	->40,->08
	.long	TMSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	>04,>00
	.long	TMSTUMBLE4

	.long	ani_adjustxy
	.word	>12,>30
	.long	TMFLIPPED1

	.long	ani_adjustxy
	.word	>28,>00
	.long	TMFLIPPED2

	.long	ani_adjustxy
	.word	>30,->20
	.long	TMFLIPPED3

	.long	ani_adjustxy
	.word	>30,->28
	.long	TMFLIPPED4
	.long	0
*
* land on the ground
*
j_hhland
	.long	TMKNOCKDOWN6
	.long	TMKNOCKDOWN7
	.long	TMKNOCKDOWN6
	.long	TMKNOCKDOWN7
	.long	0


a_hh_fb_hh
	.long	ani_adjustxy
	.word	->4a,0		; we need even # of words here !
	.long	TMSTUMBLE4
	.long	0

	.long	ani_flip
	.long	TMSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	>60,->20
	.long	TMFLIPPED2
	.long	TMFLIPPED3
	.long	TMFLIPPED4
	.long	TMFLIPPED5
	.long	0


a_hh_fb_jx
	.long	ani_adjustxy
	.word	->50,>00
	.long	TMSTUMBLE4
	.long	TMSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	>1f,->2a
	.long	TMFLIPPED1

	.long	ani_adjustxy
	.word	>18,->06
	.long	TMFLIPPED1


	.long	ani_adjustxy
	.word	>28,>10
	.long	TMFLIPPED2

	.long	ani_adjustxy
	.word	>30,>30
	.long	TMFLIPPED3

	.long	ani_adjustxy
	.word	>10,->10
	.long	TMKNOCKDOWN7
	.long	0
*
* slammed again !
*
	.long	TMFLIPPED4

	.long	ani_adjustxy
	.word	->20,->4a
	.long	TMFLIPPED4

	.long	ani_adjustxy
	.word	->30,->10
	.long	TMFLIPPED4

	.long	ani_flip
	.long	ani_adjustxy
	.word	>40,>18
	.long	TMFLIPPED4

	.long	ani_adjustxy
	.word	>20,>30
	.long	TMFLIPPED5

	.long	ani_adjustxy
	.word	->13,>10
	.long	TMKNOCKDOWN7

	.long	0



a_hh_fb_lk
	.long	ani_adjustxy
	.word	->40,>00
	.long	TMSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	>1f,>21
	.long	TMFLIPPED1

	.long	ani_adjustxy
	.word	>18,>06
	.long	TMFLIPPED1

	.long	ani_adjustxy
	.word	>28,>00
	.long	TMFLIPPED2

	.long	ani_adjustxy
	.word	>30,->10
	.long	TMFLIPPED3

	.long	ani_adjustxy
	.word	>30,->20
	.long	TMFLIPPED4
	.long	0
*
* land on the ground
*
	.long	TMKNOCKDOWN6
	.long	TMKNOCKDOWN7
	.long	TMKNOCKDOWN6
	.long	TMKNOCKDOWN7
	.long	0


a_hh_fb_sa
	.long	ani_adjustxy
	.word	->40,>00
	.long	TMSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	>0f,->10
	.long	TMFLIPPED1

	.long	ani_adjustxy
	.word	>2a,->20
	.long	TMFLIPPED3

	.long	ani_adjustxy
	.word	>3f,->20
	.long	TMFLIPPED4
	.long	0


a_hh_fb_fn
	.long	ani_adjustxy
	.word	->40,->10
	.long	ani_flip
	.long	TMSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	->20,>30
	.long	ani_flip_v
	.long	ani_flip
	.long	TMFLIPPED3

	.long	ani_adjustxy
	.word	>38,->08
	.long	TMFLIPPED3

	.long	ani_adjustxy
	.word	>30,->10
	.long	ani_flip
	.long	ani_flip_v
	.long	TMFLIPPED3

	.long	ani_adjustxy
	.word	->10,>30
	.long	TMFLIPPED3

	.long	ani_adjustxy
	.word	>00,->30
	.long	ani_flip
	.long	TMKNOCKDOWN5
	.long	0
*
* bounce on ground
*
	.long	TMKNOCKDOWN5
	.long	0



a_hh_fb_jc
	.long	ani_adjustxy
	.word	->40,>00
	.long	TMSTUMBLE4
	.long	TMSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	>0f,->10
	.long	TMFLIPPED1

	.long	ani_adjustxy
	.word	>78,>18
	.long	TMFLIPPED3

	.long	ani_adjustxy
	.word	>28,>10
	.long	TMFLIPPED5
	.long	0

;******************************************************************

a_hh_fb_st
	.long	ani_adjustxy
	.word	->30,>00
	.long	TMSTUMBLE6
	.long	TMSTUMBLE6
	.long	0

	.long	ani_adjustxy
	.word	>00,->18
	.long	TMFLIPPED1
	.long	ani_adjustxy
	.word	>40,>00
	.long	TMFLIPPED2
	.long	ani_adjustxy
	.word	>30,>30
	.long	TMFLIPPED3
	.long	ani_adjustxy
	.word	>10,>18
	.long	TMFLIPPED4
	.long	0

	.long	ani_adjustxy
	.word	>10,>00
	.long	TMKNOCKDOWN5
	.long	0


a_hh_fb_rd
	.long	ani_adjustxy
	.word	->45,>00
	.long	TMSTUMBLE4
	.long	0

	.long	ani_adjustxy
	.word	>0a,->18
	.long	TMFLIPPED1

	.long	ani_adjustxy
	.word	>28,->18
	.long	TMFLIPPED1
	.long	TMFLIPPED1		; pause

	.long	ani_adjustxy
	.word	>04,>70
	.long	ani_flip_v
	.long	TMFLIPPED1

	.long	ani_adjustxy
	.word	>38,>40
	.long	TMFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>18,>10
	.long	ani_flip
	.long	TMKNOCKDOWN7
	.long	0


TMFLIPPED1
	.long	TMFLIPPED1A,TMFLIPPED1B,TMFLIPPED1C,0
TMFLIPPED2
	.long	TMFLIPPED2A,TMFLIPPED2B,TMFLIPPED2C,0
TMFLIPPED3
	.long	TMFLIPPED3A,TMFLIPPED3B,TMFLIPPED3C,0
TMFLIPPED4
	.long	TMFLIPPED4A,TMFLIPPED4B,TMFLIPPED4C,TMFLIPPED4D,0
TMFLIPPED5
	.long	TMFLIPPED5A,TMFLIPPED5B,TMFLIPPED5C,TMFLIPPED5D,0

**************************************************************************

a_impaled
	.long	ani_adjustxy
	.word	->60,>00
	.long	TMIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	TMIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	TMIMPALED1

	.long	ani_adjustxy
	.word	>10,->18
	.long	TMIMPALED1

	.long	0
*
* suffering (that's Christmas)
*
	.long	TMIMPALED2
	.long	TMIMPALED3
	.long	TMIMPALED4
	.long	TMIMPALED3
	.long	TMIMPALED2
	.long	TMIMPALED3
	.long	TMIMPALED4
	.long	0

TMIMPALED1
	.long	TMIMPALED1A,TMIMPALED1B,TMIMPALED1C,0
TMIMPALED2
	.long	TMIMPALED2A,TMIMPALED2B,0
TMIMPALED3
	.long	TMIMPALED3A,TMIMPALED3B,0
TMIMPALED4
	.long	TMIMPALED4A,TMIMPALED4B,TMIMPALED4C,TMIMPALED4D,0

**************************************************************************

a_decapfall
	.long	HHDECAP1
	.long	HHDECAP2
	.long	HHDECAP3	; on knees
	.long	0
*
* wobble on yer knees
*
	.long	HHDECAP4
	.long	HHDECAP3
	.long	HHDECAP4
	.long	HHDECAP3
	.long	HHDECAP4
	.long	HHDECAP3
	.long	0
*
* fall to ground
*
	.long	HHDECAP4
	.long	HHDECAP5
	.long	HHDECAP6
	.long	HHDECAP7
	.long	0

HHDECAP1	.long	TMDEADLEG1A,TMDEADLEG1B,TMDEADTORSO1A,0
HHDECAP2	.long	TMDEADLEG2A,TMDEADLEG2B,TMDEADTORSO2A,0
HHDECAP3	.long	TMDEADLEG3A,TMDEADLEG3B,TMDEADTORSO3A,0
HHDECAP4	.long	TMDEADLEG4A,TMDEADLEG4B,TMDEADTORSO4A,0
HHDECAP5	.long	TMDEADLEG5A,TMDEADLEG5B,TMDEADTORSO5A,0
HHDECAP6	.long	TMDEADLEG6A,TMDEADLEG6B,TMDEADTORSO6A,0
HHDECAP7	.long	TMDEADLEG7A,TMDEADTORSO7A,TMDEADTORSO7B,0

a_head
	.long	TMHEAD1
	.long	TMHEAD2
	.long	TMHEAD3
	.long	TMHEAD4
	.long	TMHEAD5
	.long	TMHEAD6
	.long	TMHEAD7
	.long	ani_jump,a_head

;	.long	TMDEADLEG1A,TMDEADLEG1B,0
;	.long	TMDEADLEG2A,TMDEADLEG2B,0
;	.long	TMDEADLEG3A,TMDEADLEG3B,0
;	.long	TMDEADLEG4A,TMDEADLEG4B,0
;	.long	TMDEADLEG5A,TMDEADLEG5B,TMDEADLEG5C,0
;	.long	TMDEADLEG6A,TMDEADLEG6B,0
;	.long	TMDEADLEG7A,0

;	.long	TMDEADTORSO1A,0
;	.long	TMDEADTORSO2A,0
;	.long	TMDEADTORSO3A,0
;	.long	TMDEADTORSO4A,0
;	.long	TMDEADTORSO5A,0
;	.long	TMDEADTORSO6A,0
;	.long	TMDEADTORSO7A,TMDEADTORSO7B,0

**************************************************************************

a_nutcrunched
	.long	TMNUTCRUNCH1
	.long	TMNUTCRUNCH2
	.long	0
	.long	TMNUTCRUNCH1
	.long	0

TMNUTCRUNCH1
	.long	TMNUTCRUNCH1A,TMNUTCRUNCH1B,0
TMNUTCRUNCH2
	.long	TMNUTCRUNCH2A,TMNUTCRUNCH2B,0

**************************************************************************

a_bike_kicked
	.long	TMSTUMBLE1
	.long	TMSTUMBLE2
	.long	TMSTUMBLE3
	.long	TMSTUMBLE4
	.long	TMSTUMBLE5
	.long	TMSTUMBLE6
	.long	ani_jump,a_bike_kicked

**************************************************************************

a_drained
	.long	ani_adjustxy
	.word	->40,->13
	.long	TMSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	->1c,>16
	.long	HHDRAIN0
	.long	ani_adjustxy
	.word	>13,->08
	.long	HHDRAIN0
	.long	ani_adjustxy
	.word	>08,->14
	.long	HHDRAIN0
	.long	ani_adjustxy
	.word	>08,>08
	.long	HHDRAIN0
	.long	0

**************************************************************************

a_torso_ripped
	.long	ani_adjustxy
	.word	->4a,>00
	.long	TMSTUMBLE5
	.long	0

	.long	ani_calla,change_to_bloody_pal	; switch to bloody pal
	.long	TMRIPTORSO1

	.long	ani_adjustxy
	.word	>28,->20
	.long	TMRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>00,>08
	.long	TMRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>30,>20
	.long	TMRIPTORSO3

	.long	ani_adjustxy
	.word	>30,>40
	.long	TMRIPTORSO4
	.long	0

	.long	TMRIPTORSO6
	.long	TMRIPTORSO7
	.long	0
*
* standing legz
*
	.long	HHLEGZ1			; legz
	.long	0


HHLEGZ1	.long	TMDEADLEG1A,TMDEADLEG1B,0


TMRIPTORSO1
	.long	TMRIPTORSO1A,TMRIPTORSO1B,0
TMRIPTORSO2
	.long	TMRIPTORSO2A,TMRIPTORSO2B,0
TMRIPTORSO3
	.long	TMRIPTORSO3A,0
TMRIPTORSO4
	.long	TMRIPTORSO4A,0
TMRIPTORSO5
	.long	TMRIPTORSO5A,TMRIPTORSO5B,0
TMRIPTORSO6
	.long	TMRIPTORSO6A,TMRIPTORSO6B,0
TMRIPTORSO7
	.long	TMRIPTORSO7A,0


a_swipe_torso
	.long	TMRIPTORSO1
	.long	TMRIPTORSO2
	.long	TMRIPTORSO3
	.long	TMRIPTORSO4
	.long	TMRIPTORSO5
	.long	TMRIPTORSO6
	.long	TMRIPTORSO7
	.long	0

**************************************************************************

a_spin
	.long	TMSPIN1
	.long	TMSPIN2
	.long	TMSPIN3
	.long	TMSPIN4
	.long	TMSPIN5
	.long	ani_flip
	.long	TMSPIN5
	.long	TMSPIN4
	.long	TMSPIN3
	.long	TMSPIN2
	.long	TMSPIN1
	.long	ani_flip
	.long	ani_jump,a_spin


TMSPIN1	.long	TMSPINNIN1,0
TMSPIN2	.long	TMSPINNIN2,0
TMSPIN3	.long	TMSPINNIN3,0
TMSPIN4	.long	TMSPINNIN4,0
TMSPIN5	.long	TMSPINNIN5,0

**************************************************************************

a_back_broke
	.long	TMBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>0a
	.long	TMBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>30
	.long	TMBACKBREAK1
	.long	TMBACKBREAK2
	.long	TMBACKBREAK3
	.long	0
	.long	TMBACKBREAK2
	.long	TMBACKBREAK1
	.long	0


TMBACKBREAK1
	.long	TMBACKBREAK1A,TMBACKBREAK1B,TMBACKBREAK1C,0
TMBACKBREAK2
	.long	TMBACKBREAK2A,TMBACKBREAK2B,TMBACKBREAK2C,0
TMBACKBREAK3
	.long	TMBACKBREAK3A,TMBACKBREAK3B,TMBACKBREAK3C,0

;***************************************************************************

a_fb_goro
	.long	ani_adjustxy
	.word	->60,->20
	.long	TMSTUMBLE4

	.long	ani_adjustxy
	.word	>10,->70
	.long	TMKNOCKDOWN6

	.long	ani_adjustxy
	.word	>20,>00
	.long	TMKNOCKDOWN6

	.long	ani_adjustxy
	.word	>3a,>20
	.long	TMKNOCKDOWN5

	.long	ani_adjustxy
	.word	>38,>10
	.long	TMKNOCKDOWN5

	.long	ani_adjustxy
	.word	>00,>68
	.long	TMKNOCKDOWN6

	.long	0


a_aura	.long	TMAURA1
	.long	TMAURA2
	.long	TMAURA3
	.long	TMAURA4
	.long	TMAURA5
	.long	TMAURA6
	.long	0


a_change
	.long	TMVICTORY1
	.long	TMVICTORY2
	.long	TMVICTORY3
	.long	0

	.long	TMVICTORY4
	.long	TMVICTORY5
	.long	TMVICTORY6
	.long	TMVICTORY7
	.long	TMVICTORY8
	.long	0

;***************************************************************************

	.END
