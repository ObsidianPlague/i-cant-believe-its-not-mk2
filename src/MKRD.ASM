**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: Raiden										*
*											     *
**************************************************************************
	.FILE	'MKRD.ASM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
*
* GET THE SYSTEM STUFF
*
	.INCLUDE	MAINEQU.ASM
	.INCLUDE	MKRD.TBL
	.INCLUDE	MKRD2.TBL
	.INCLUDE	MKBOLTS.TBL
	.INCLUDE	IMGTBL.GLO
	.text

rd_anitab1
	.long	a_rdstance	;  0 - stance
	.long	a_rdwalkf	;  1 - walk forward
	.long	a_rdskipf	;  2 - skip forward
	.long	a_rdwalkb	;  3 - walk backward
	.long	a_rdskipb	;  4 - walk backward
	.long	a_rdduck  	;  5 - duck animation
	.long	a_rdjumpup	;  6 - jump straight up
	.long	a_rdfflip	;  7 - forward flip
	.long	a_rdbflip	;  8 - backward flip
	.long	a_rdturn	;  9 - turn around
	.long	a_rdduckturn	;  a - turn around while ducking
	.long	a_rdblockhi	;  b - standing block
	.long	a_rdduckblock	;  c - ducking block
	.long	a_rdhikick	;  d - hi kick
	.long	a_rdlokick	;  e - lo kick
	.long	a_rdkdown	;  f - knocked down
	.long	a_rdhithi	; 10 - hit high
	.long	a_rdhitlo	; 11 - hit low
	.long	a_rdgetup	; 12 - normal getup
	.long	a_rdhipunch	; 13 - hi punch
	.long	a_rdlopunch	; 14 - lo punch
	.long	a_rdsweep	; 15 - sweep kick
	.long	a_rdsweepfall	; 16 - sweep fall
	.long	a_rdsweepup	; 17 - getup from sweep kick
	.long	a_rdduckpunch	; 18 - duck punch
	.long	a_rdduckkickh	; 19 - duck kick high
	.long	a_rdduckkickl	; 1a - duck kick low
	.long	a_rdduckhit	; 1b - hit while ducking
	.long	a_rduppercut	; 1c - uppercut
	.long	a_rdjumpupkick	; 1d - jump straight up kick
	.long	a_rdflipkick	; 1e - flip kick
	.long	a_rdflippunch	; 1f - flip punch
	.long	a_rdroundh	; 20 - roundhouse kick
	.long	a_rdknee	; 21 - knee
	.long	a_rdelbow	; 22 - elbow
	.long	a_rdstumble	; 23 - stumble back
	.long	a_rdbodyslam	; 24 - body slam
	.long	a_shredded	; 25 -
	.long	a_rdzap		; 26 - throwing fireball hi
	.long	a_rdprojani	; 27 - fireball ani
	.long	a_rdstunned	; 28 - stunned
	.long	a_rdvictory	; 29 - victory
	.long	a_rd_fb_hh	; 2a - raiden flipped by hatheat
	.long	a_rd_fb_lk	; 2b - raiden flipped by liu kang
	.long	a_rd_fb_jc	; 2c - raiden flipped by cage
	.long	a_rd_fb_sa	; 2d - raiden flipped by sa
	.long	a_rd_fb_fn	; 2e - raiden flipped by female ninja
	.long	a_rd_fb_fn	; 2f - raiden flipped by female ninja
	.long	a_rd_fb_st	; 30 - raiden flipped by shang tsung
	.long	a_rd_fb_rd	; 31 - raiden flipped by raiden
	.long	a_rd_fb_nj	; 32 - raiden flipped by ninja
	.long	a_rd_fb_nj	; 33 - raiden flipped by ninja
	.long	a_rd_fb_nj	; 34 - raiden flipped by ninja
	.long	a_rd_fb_jx	; 35 - raiden flipped by jax

	.long	a_nutcrunched	; 36 - ouch
	.long	a_bike_kicked	; 37 - bicycle kicked
	.long	a_drained	; 38 - drained of my soul by shang tsung
	.long	a_torso_ripped	; 39 - torso ripped
	.long	a_banged	; 3a
	.long	a_impaled	; 3b - impaled
	.long	a_decapfall	; 3c - decapitated dude fall
	.long	a_head		; 3d - decapitated head
	.long	a_fb_goro	; 3e - flipped by goro's evil twin
	.long	a_back_broke	; 3f - back getting broken
	.long	0
	.long	a_swipe_torso	; 41 - scorpion swiped me torso
	
rd_anitab2
	.long	a_superman	; 0 - Raiden Superman dive
	.long	a_melt_grow	; 1 - Raiden melt / grow animation combo
	.long	a_shocker	; 2 - Raiden shocker !!
	.long	a_death_shock	; 3 - Raiden death blow shocker !!
	.long	a_death_zap2	; 4 - zap #2
	.long	a_victory_bolts	; 5 - raiden victory bolts

dummy
a_rdstance
	.long	RNSTANCE1
	.long	RNSTANCE1
	.long	RNSTANCE2
	.long	RNSTANCE3
	.long	RNSTANCE4
	.long	RNSTANCE5
	.long	RNSTANCE6
	.long	RNSTANCE6
	.long	RNSTANCE5
	.long	RNSTANCE4
	.long	RNSTANCE3
	.long	RNSTANCE2
	.long	ani_jump,a_rdstance

RNSTANCE1
	.long	RNSTANCE1A,RNSTANCE1B,0
RNSTANCE2
	.long	RNSTANCE2A,RNSTANCE2B,0
RNSTANCE3
	.long	RNSTANCE3A,RNSTANCE3B,0
RNSTANCE4
	.long	RNSTANCE4A,RNSTANCE4B,0
RNSTANCE5
	.long	RNSTANCE5A,RNSTANCE5B,0
RNSTANCE6
	.long	RNSTANCE6A,RNSTANCE6B,0


;RN1BOLT1
;	.long	RN1BOLT1A,0
;RN1BOLT2
;	.long	RN1BOLT2A,RN1BOLT2B,0
;RN1BOLT3
;	.long	RN1BOLT3A,RN1BOLT3B,0
;RN1BOLT4
;	.long	RN1BOLT4A,0
;RN1BOLT5
;	.long	RN1BOLT5A,RN1BOLT5B,0
;RN1BOLT6
;	.long	RN1BOLT6A,RN1BOLT6B,0
;RN1BOLT7
;	.long	RN1BOLT7A,RN1BOLT7B,0

;*********************************************************************

a_rdwalkf
	.long	RNWALK1
	.long	RNWALK2
	.long	RNWALK3
	.long	RNWALK4
	.long	RNWALK5
	.long	RNWALK6
	.long	RNWALK7
	.long	RNWALK8
	.long	RNWALK9
	.long	ani_jump,a_rdwalkf

a_rdskipf
	.long	RNWALK1
	.long	RNWALK2
	.long	RNWALK8
	.long	RNWALK9
	.long	0

a_rdwalkb
	.long	RNWALK9
	.long	RNWALK8
	.long	RNWALK7
	.long	RNWALK6
	.long	RNWALK5
	.long	RNWALK4
	.long	RNWALK3
	.long	RNWALK2
	.long	RNWALK1
	.long	ani_jump,a_rdwalkb

a_rdskipb
	.long	RNWALK9
	.long	RNWALK8
	.long	RNWALK2
	.long	RNWALK1
	.long	0

RNWALK1	.long	RNWALKLEG1A,RNWALKLEG1B,RNWALKTORSO1A,RNWALKTORSO1B,0
RNWALK2	.long	RNWALKLEG2A,RNWALKLEG2B,RNWALKTORSO2A,RNWALKTORSO2B,0
RNWALK3	.long	RNWALKLEG3A,RNWALKTORSO3A,RNWALKTORSO3B,0
RNWALK4	.long	RNWALKLEG4A,RNWALKLEG4B,RNWALKTORSO4A,RNWALKTORSO4B,0
RNWALK5	.long	RNWALKLEG5A,RNWALKLEG5B,RNWALKTORSO5A,RNWALKTORSO5B,0
RNWALK6	.long	RNWALKLEG6A,RNWALKLEG6B,RNWALKTORSO6A,RNWALKTORSO6B,0
RNWALK7	.long	RNWALKLEG7A,RNWALKLEG7B,RNWALKTORSO7A,RNWALKTORSO7B,0
RNWALK8	.long	RNWALKLEG8A,RNWALKLEG8B,RNWALKTORSO8A,RNWALKTORSO8B,0
RNWALK9	.long	RNWALKLEG9A,RNWALKLEG9B,RNWALKTORSO9A,RNWALKTORSO9B,0

;***********************************************************************

a_rdduck  
	.long	RNDUCK1
	.long	RNDUCK2
	.long	RNDUCK3
	.long	0

RNDUCK1	.long	RNDUCK1A,RNDUCK1B,RNDUCK1C,0
RNDUCK2	.long	RNDUCK2A,RNDUCK2B,RNDUCK2C,0
RNDUCK3	.long	RNDUCK3A,RNDUCK3B,0

;***********************************************************************

a_rdjumpup
	.long	RNJUMP2
	.long	RNJUMP3
	.long	0
	.long	RNJUMP2
	.long	RNJUMP1
	.long	0

RNJUMP1	.long	RNJUMP1A,RNJUMP1B,RNJUMP1C,0
RNJUMP2	.long	RNJUMP2A,RNJUMP2B,RNJUMP2C,0
RNJUMP3	.long	RNJUMP3A,RNJUMP3B,RNJUMP3C,0

;***********************************************************************

a_rdfflip
	.long	RNJUMPFLIP1
	.long	RNJUMPFLIP2
	.long	RNJUMPFLIP3
	.long	RNJUMPFLIP4
	.long	RNJUMPFLIP5
	.long	RNJUMPFLIP6
	.long	RNJUMPFLIP7
	.long	RNJUMPFLIP8
	.long	ani_jump,a_rdfflip+32

RNJUMPFLIP1
	.long	RNJUMPFLIP1A,RNJUMPFLIP1B,0
RNJUMPFLIP2
	.long	RNJUMPFLIP2A,RNJUMPFLIP2B,0
RNJUMPFLIP3
	.long	RNJUMPFLIP3A,0
RNJUMPFLIP4
	.long	RNJUMPFLIP4A,RNJUMPFLIP4B,0
RNJUMPFLIP5
	.long	RNJUMPFLIP5A,RNJUMPFLIP5B,0
RNJUMPFLIP6
	.long	RNJUMPFLIP6A,RNJUMPFLIP6B,0
RNJUMPFLIP7
	.long	RNJUMPFLIP7A,RNJUMPFLIP7B,0
RNJUMPFLIP8
	.long	RNJUMPFLIP8A,RNJUMPFLIP8B,0

;***********************************************************************

a_rdbflip
	.long	RNJUMPFLIP1
	.long	RNJUMPFLIP8
	.long	RNJUMPFLIP7
	.long	RNJUMPFLIP6
	.long	RNJUMPFLIP5
	.long	RNJUMPFLIP4
	.long	RNJUMPFLIP3
	.long	RNJUMPFLIP2
	.long	ani_jump,a_rdbflip+32

;***********************************************************************

a_rdturn
	.long	RNTURN1
	.long	RNTURN2
	.long	ani_flip  
	.long	ani_adjustx
	.word	0
	.long	RNTURN1
	.long	0

RNTURN1	.long	RNTURN1A,RNTURN1B,0
RNTURN2	.long	RNTURN2A,RNTURN2B,0

;***********************************************************************

a_rdduckturn
	.long	RNDUCKTURN1
	.long	RNDUCKTURN2
	.long	ani_flip  
	.long	ani_adjustx
	.word	>00
	.long	RNDUCKTURN1
	.long	RNDUCK3
	.long	0

RNDUCKTURN1
	.long	RNDUCKTURN1A,RNDUCKTURN1B,0
RNDUCKTURN2
	.long	RNDUCKTURN2A,RNDUCKTURN2B,0

;***********************************************************************

a_rdblockhi
	.long	RNBLOCK1
	.long	RNBLOCK2
	.long	RNBLOCK3
	.long	0
	.long	RNBLOCK2
	.long	RNBLOCK1
	.long	0

RNBLOCK1	.long	RNBLOCK1A,RNBLOCK1B,RNBLOCK1C,0
RNBLOCK2	.long	RNBLOCK2A,RNBLOCK2B,0
RNBLOCK3	.long	RNBLOCK3A,RNBLOCK3B,0

;***********************************************************************

a_rdduckblock
	.long	RNDUCKBLOCK1
	.long	RNDUCKBLOCK2
	.long	RNDUCKBLOCK3
	.long	0
	.long	RNDUCKBLOCK2
	.long	RNDUCKBLOCK1
	.long	RNDUCK3
	.long	0

RNDUCKBLOCK1
	.long	RNDUCKBLOCK1A,RNDUCKBLOCK1B,0
RNDUCKBLOCK2
	.long	RNDUCKBLOCK2A,RNDUCKBLOCK2B,RNDUCKBLOCK2C,0
RNDUCKBLOCK3
	.long	RNDUCKBLOCK3A,RNDUCKBLOCK3B,0

;***********************************************************************

a_rdhikick
	.long	RNHIKICK1
	.long	RNHIKICK2
	.long	RNHIKICK3
	.long	RNHIKICK4
	.long	RNHIKICK5
	.long	RNHIKICK6
	.long	0
	.long	RNHIKICK5
	.long	RNHIKICK4
	.long	RNHIKICK3
	.long	RNHIKICK2
	.long	RNHIKICK1
	.long	0

RNHIKICK1
	.long	RNHIKICK1A,RNHIKICK1B,0
RNHIKICK2
	.long	RNHIKICK2A,RNHIKICK2B,0
RNHIKICK3
	.long	RNHIKICK3A,RNHIKICK3B,0
RNHIKICK4
	.long	RNHIKICK4A,RNHIKICK4B,0
RNHIKICK5
	.long	RNHIKICK5A,RNHIKICK5B,RNHIKICK5C,0
RNHIKICK6
	.long	RNHIKICK6A,RNHIKICK6B,0

;***********************************************************************

a_rdlokick
	.long	RNHIKICK1
	.long	RNHIKICK2
	.long	RNHIKICK3
	.long	RNHIKICK4
	.long	RNHIKICK5
	.long	RNLOKICK1
	.long	0
	.long	RNHIKICK5
	.long	RNHIKICK4
	.long	RNHIKICK3
	.long	RNHIKICK2
	.long	RNHIKICK1
	.long	0

RNLOKICK1
	.long	RNLOKICK1A,RNLOKICK1B,0

;***********************************************************************

a_rdkdown
	.long	RNKNOCKDOWN1
	.long	RNKNOCKDOWN2
	.long	RNKNOCKDOWN3
	.long	RNKNOCKDOWN4
	.long	0
*
* part 2 = landing on back
*
	.long	RNKNOCKDOWN6
	.long	RNKNOCKDOWN7
	.long	0
*
* part 3 = shake on the ground
*
	.long	RNKNOCKDOWN6
	.long	RNKNOCKDOWN7
	.long	RNKNOCKDOWN6
	.long	RNKNOCKDOWN7
	.long	0

RNKNOCKDOWN1
	.long	RNKNOCKDOWN1A,RNKNOCKDOWN1B,0
RNKNOCKDOWN2
	.long	RNKNOCKDOWN2A,RNKNOCKDOWN2B,RNKNOCKDOWN2C,0
RNKNOCKDOWN3
	.long	RNKNOCKDOWN3A,RNKNOCKDOWN3B,RNKNOCKDOWN3C,RNKNOCKDOWN3D,0
RNKNOCKDOWN4
	.long	RNKNOCKDOWN4A,RNKNOCKDOWN4B,RNKNOCKDOWN4C,0
RNKNOCKDOWN6
	.long	RNKNOCKDOWN6A,RNKNOCKDOWN6B,0
RNKNOCKDOWN7
	.long	RNKNOCKDOWN7A,RNKNOCKDOWN7B,RNKNOCKDOWN7C,0

;***********************************************************************

a_rdhithi
	.long	RNHIHIT2
	.long	RNHIHIT3
	.long	RNHIHIT2
	.long	RNHIHIT1
	.long	0

RNHIHIT1	.long	RNHIHIT1A,RNHIHIT1B,RNHIHIT1C,0
RNHIHIT2	.long	RNHIHIT2A,RNHIHIT2B,RNHIHIT2C,0
RNHIHIT3	.long	RNHIHIT3A,RNHIHIT3B,RNHIHIT3C,0

;***********************************************************************

a_rdhitlo
	.long	RNLOHIT2
	.long	RNLOHIT3
	.long	RNLOHIT2
	.long	RNLOHIT1
	.long	0

RNLOHIT1	.long	RNLOHIT1A,RNLOHIT1B,RNLOHIT1C,0
RNLOHIT2	.long	RNLOHIT2A,RNLOHIT2B,0
RNLOHIT3	.long	RNLOHIT3A,RNLOHIT3B,0

;***********************************************************************

a_melt_grow
	.long	RNBEAMUP7
	.long	RNBEAMUP6
	.long	RNBEAMUP5
	.long	RNBEAMUP4
	.long	RNBEAMUP3
	.long	RNBEAMUP2
	.long	0

a_rdgetup
	.long	RNBEAMUP1
	.long	RNBEAMUP3
	.long	RNBEAMUP4
	.long	RNBEAMUP5
	.long	RNBEAMUP6
	.long	RNBEAMUP7
	.long	0


RNBEAMUP1
	.long	RNBEAMUP1A,RNBEAMUP1B,RNBEAMUP1C,0
RNBEAMUP2
	.long	RNBEAMUP2A,RNBEAMUP2B,0
RNBEAMUP3
	.long	RNBEAMUP3A,RNBEAMUP3B,0
RNBEAMUP4
	.long	RNBEAMUP4A,RNBEAMUP4B,0
RNBEAMUP5
	.long	RNBEAMUP5A,RNBEAMUP5B,0
RNBEAMUP6
	.long	RNBEAMUP6A,RNBEAMUP6B,0
RNBEAMUP7
	.long	RNBEAMUP7A,RNBEAMUP7B,0

;***********************************************************************

a_rdhipunch
	.long	RNHIPUNCH1
rhp2	.long	RNHIPUNCH2
rhp3	.long	RNHIPUNCH3
	.long	0

rhp4	.long	RNHIPUNCH4
	.long	RNHIPUNCH5
	.long	RNHIPUNCH6
	.long	0

	.long	RNHIPUNCH5
	.long	RNHIPUNCH4
	.long	ani_jump,rhp3
	.long	0
*
* Unhipunch #1
*
	.long	RNHIPUNCH2
	.long	RNHIPUNCH1
	.long	0
*
* Unhipunch #2
*
	.long	RNHIPUNCH7
	.long	0
*
* Hi to Med #1
*
	.long	RNHIPUNCH4
	.long	RNLOPUNCH3
	.long	ani_jump,rlp4
	.long	0
*
* Hi to Med #2
*
	.long	RNHIPUNCH5
	.long	RNLOPUNCH1
	.long	ani_jump,rlp2
	.long	0

;***********************************************************************

a_rdlopunch
	.long	RNHIPUNCH1
	.long	RNLOPUNCH1
rlp2	.long	RNLOPUNCH2
	.long	0

;**************
	.long	RNLOPUNCH1
;	.long	RNHIPUNCH4
;**************

	.long	RNLOPUNCH3
rlp4 	.long	RNLOPUNCH4
	.long	0

	.long	RNLOPUNCH3
	.long	RNLOPUNCH1
	.long	ani_jump,rlp2
	.long	0
*
* Unlopunch #1
*
	.long	RNLOPUNCH1
	.long	RNHIPUNCH1
	.long	0
*
* Unlopunch #2
*
	.long	RNLOPUNCH3
	.long	0
*
* Med to High #1
*
	.long	ani_jump,rhp4
	.long	0
*
* Med to High #2
*
	.long	RNLOPUNCH3
	.long	ani_jump,rhp2
	.long	0

RNHIPUNCH1
	.long	RNHIPUNCH1A,RNHIPUNCH1B,0
RNHIPUNCH2
	.long	RNHIPUNCH2A,RNHIPUNCH2B,0
RNHIPUNCH3
	.long	RNHIPUNCH3A,RNHIPUNCH3B,0
RNHIPUNCH4
	.long	RNHIPUNCH4A,RNHIPUNCH4B,0
RNHIPUNCH5
	.long	RNHIPUNCH5A,RNHIPUNCH5B,RNHIPUNCH5C,0
RNHIPUNCH6
	.long	RNHIPUNCH6A,RNHIPUNCH6B,RNHIPUNCH6C,0
RNHIPUNCH7
	.long	RNHIPUNCH7A,RNHIPUNCH7B,RNHIPUNCH7C,0

RNLOPUNCH1
	.long	RNLOPUNCH1A,RNLOPUNCH1B,0
RNLOPUNCH2
	.long	RNLOPUNCH2A,RNLOPUNCH2B,0
RNLOPUNCH3
	.long	RNLOPUNCH3A,RNLOPUNCH3B,RNLOPUNCH3C,0
RNLOPUNCH4
	.long	RNLOPUNCH4A,RNLOPUNCH4B,0

;***********************************************************************

a_rdsweep
	.long	RNSWEEPKICK1
	.long	RNSWEEPKICK2
	.long	RNSWEEPKICK3
	.long	ani_calla,sweep_sounds
	.long	RNSWEEPKICK4
	.long	RNSWEEPKICK5
	.long	0
	.long	RNSWEEPKICK6
	.long	RNSWEEPKICK7
	.long	0

RNSWEEPKICK1
	.long	RNSWEEPKICK1A,RNSWEEPKICK1B,0
RNSWEEPKICK2
	.long	RNSWEEPKICK2A,RNSWEEPKICK2B,RNSWEEPKICK2C,0
RNSWEEPKICK3
	.long	RNSWEEPKICK3A,RNSWEEPKICK3B,RNSWEEPKICK3C,0
RNSWEEPKICK4
	.long	RNSWEEPKICK4A,RNSWEEPKICK4B,RNSWEEPKICK4C,RNSWEEPKICK4D,0
RNSWEEPKICK5
	.long	RNSWEEPKICK5A,RNSWEEPKICK5B,RNSWEEPKICK5C,0
RNSWEEPKICK6
	.long	RNSWEEPKICK6A,RNSWEEPKICK6B,0
RNSWEEPKICK7
	.long	RNSWEEPKICK7A,RNSWEEPKICK7B,0

;***********************************************************************

a_rdsweepfall
	.long	RNSWEEPFALL1
	.long	RNSWEEPFALL2
	.long	RNSWEEPFALL3
	.long	RNSWEEPFALL4
	.long	RNSWEEPFALL5
	.long	0
	.long	RNSWEEPFALL6
	.long	0

RNSWEEPFALL1
	.long	RNSWEEPFALL1A,RNSWEEPFALL1B,RNSWEEPFALL1C,RNSWEEPFALL1D,0
RNSWEEPFALL2
	.long	RNSWEEPFALL2A,RNSWEEPFALL2B,RNSWEEPFALL2C,RNSWEEPFALL2D,0
RNSWEEPFALL3
	.long	RNSWEEPFALL3A,RNSWEEPFALL3B,RNSWEEPFALL3C,0
RNSWEEPFALL4
	.long	RNSWEEPFALL4A,RNSWEEPFALL4B,RNSWEEPFALL4C,RNSWEEPFALL4D,0
RNSWEEPFALL5
	.long	RNSWEEPFALL5A,RNSWEEPFALL5B,RNSWEEPFALL5C,RNSWEEPFALL5D,0
RNSWEEPFALL6
	.long	RNSWEEPFALL6A,RNSWEEPFALL6B,0

;***********************************************************************

a_rdsweepup
	.long	RNBEAMUP2
	.long	ani_jump,a_rdgetup+32

;***********************************************************************

a_rdduckpunch
	.long	RNDUCKPUNCH1
	.long	RNDUCKPUNCH2
	.long	RNDUCKPUNCH3
	.long	0
	.long	RNDUCKPUNCH2
	.long	RNDUCKPUNCH1
	.long	RNDUCK3
	.long	0

RNDUCKPUNCH1
	.long	RNDUCKPUNCH1A,RNDUCKPUNCH1B,0
RNDUCKPUNCH2
	.long	RNDUCKPUNCH2A,RNDUCKPUNCH2B,0
RNDUCKPUNCH3
	.long	RNDUCKPUNCH3A,RNDUCKPUNCH3B,RNDUCKPUNCH3C,0

;***********************************************************************

a_rdduckkickh
	.long	RNLODUCKICK1
	.long	ani_calla,kick_sounds
	.long	RNLODUCKICK3
	.long	RNHIDUCKICK1
	.long	RNHIDUCKICK2
	.long	0
	.long	RNHIDUCKICK2
	.long	RNHIDUCKICK1
	.long	RNLODUCKICK3
	.long	RNLODUCKICK1
	.long	RNDUCK3
	.long	0

RNLODUCKICK1
	.long	RNLODUCKICK1A,RNLODUCKICK1B,RNLODUCKICK1C,0
RNLODUCKICK3
	.long	RNLODUCKICK3A,RNLODUCKICK3B,0
RNLODUCKICK4
	.long	RNLODUCKICK4A,RNLODUCKICK4B,0
RNLODUCKICK5
	.long	RNLODUCKICK5A,RNLODUCKICK5B,0

RNHIDUCKICK1
	.long	RNHIDUCKICK1A,RNHIDUCKICK1B,0
RNHIDUCKICK2
	.long	RNHIDUCKICK2A,RNHIDUCKICK2B,0

;***********************************************************************

a_rdduckkickl
	.long	RNLODUCKICK1
	.long	ani_calla,kick_sounds
	.long	RNLODUCKICK3
	.long	RNLODUCKICK4
	.long	RNLODUCKICK5
	.long	0
	.long	RNLODUCKICK4
	.long	RNLODUCKICK3
	.long	RNLODUCKICK1
	.long	RNDUCK3
	.long	0

;***********************************************************************

a_rdduckhit
	.long	RNDUCKHIT2
	.long	RNDUCKHIT3
	.long	RNDUCKHIT2
	.long	RNDUCKHIT1
	.long	RNDUCK3
	.long	0

RNDUCKHIT1
	.long	RNDUCKHIT1A,RNDUCKHIT1B,0
RNDUCKHIT2
	.long	RNDUCKHIT2A,RNDUCKHIT2B,0
RNDUCKHIT3
	.long	RNDUCKHIT3A,RNDUCKHIT3B,0

;***********************************************************************

a_rduppercut
	.long	RNUPPERCUT2
	.long	RNUPPERCUT3
	.long	RNUPPERCUT4
	.long	RNUPPERCUT5
	.long	ani_nosleep	; dont sleep after next frame
	.long	RNUPPERCUT6
	.long	0
	.long	RNHIPUNCH2
	.long	RNHIPUNCH1
	.long	0

RNUPPERCUT2
	.long	RNUPPERCUT2A,RNUPPERCUT2B,0
RNUPPERCUT3
	.long	RNUPPERCUT3A,RNUPPERCUT3B,0
RNUPPERCUT4
	.long	RNUPPERCUT4A,RNUPPERCUT4B,RNUPPERCUT4C,RNUPPERCUT4D,0
RNUPPERCUT5
	.long	RNUPPERCUT5A,RNUPPERCUT5B,RNUPPERCUT5C,RNUPPERCUT5D,0
RNUPPERCUT6
	.long	RNUPPERCUT6A,RNUPPERCUT6B,RNUPPERCUT6C,0

;**************************************************************************

a_rdjumpupkick
	.long	RNJUMPKICK1
	.long	RNJUMPKICK2
	.long	0
	.long	RNJUMPKICK1
	.long	0

RNJUMPKICK1
	.long	RNJUMPKICK1A,RNJUMPKICK1B,0
RNJUMPKICK2
	.long	RNJUMPKICK2A,RNJUMPKICK2B,0

;***********************************************************************

a_rdflipkick
	.long	RNFLIPKICK1
	.long	RNFLIPKICK2
	.long	RNFLIPKICK3
	.long	0
	.long	RNFLIPKICK2
	.long	RNFLIPKICK1
	.long	0

RNFLIPKICK1
	.long	RNFLIPKICK1A,RNFLIPKICK1B,0
RNFLIPKICK2
	.long	RNFLIPKICK2A,RNFLIPKICK2B,0
RNFLIPKICK3
	.long	RNFLIPKICK3A,RNFLIPKICK3B,0

;***********************************************************************

a_rdflippunch
	.long	RNFLIPUNCH1
	.long	RNFLIPUNCH2
	.long	RNFLIPUNCH3
	.long	0
	.long	RNFLIPUNCH2
	.long	RNFLIPUNCH1
	.long	0

RNFLIPUNCH1
	.long	RNFLIPUNCH1A,RNFLIPUNCH1B,0
RNFLIPUNCH2
	.long	RNFLIPUNCH2A,RNFLIPUNCH2B,0
RNFLIPUNCH3
	.long	RNFLIPUNCH3A,RNFLIPUNCH3B,RNFLIPUNCH3C,0

;***********************************************************************

a_rdroundh
	.long	RNROUNDKIK1
	.long	RNROUNDKIK2
	.long	RNROUNDKIK3
	.long	RNROUNDKIK4
	.long	0
	.long	RNROUNDKIK5
	.long	RNROUNDKIK6
	.long	RNROUNDKIK7
	.long	0

RNROUNDKIK1
	.long	RNROUNDKIK1A,RNROUNDKIK1B,0
RNROUNDKIK2
	.long	RNROUNDKIK2A,RNROUNDKIK2B,0
RNROUNDKIK3
	.long	RNROUNDKIK3A,RNROUNDKIK3B,0
RNROUNDKIK4
	.long	RNROUNDKIK4A,RNROUNDKIK4B,RNROUNDKIK4C,0
RNROUNDKIK5
	.long	RNROUNDKIK5A,0
RNROUNDKIK6
	.long	RNROUNDKIK6A,RNROUNDKIK6B,0
RNROUNDKIK7
	.long	RNROUNDKIK7A,RNROUNDKIK7B,0

;***********************************************************************

a_rdknee
	.long	RNFOOTSMACK1
	.long	RNFOOTSMACK2
	.long	RNFOOTSMACK3
	.long	ani_nosleep	; dont sleep after next frame
	.long	RNFOOTSMACK4
	.long	0

	.long	RNFOOTSMACK2
	.long	RNFOOTSMACK1
	.long	0

RNFOOTSMACK1
	.long	RNFOOTSMACK1A,RNFOOTSMACK1B,RNFOOTSMACK1C,0
RNFOOTSMACK2
	.long	RNFOOTSMACK2A,RNFOOTSMACK2B,RNFOOTSMACK2C,0
RNFOOTSMACK3
	.long	RNFOOTSMACK3A,RNFOOTSMACK3B,RNFOOTSMACK3C,0
RNFOOTSMACK4
	.long	RNFOOTSMACK4A,RNFOOTSMACK4B,RNFOOTSMACK4C,0

;***********************************************************************

a_rdelbow
	.long	RNSHORTCUT1
	.long	RNSHORTCUT2
	.long	RNSHORTCUT3
	.long	RNSHORTCUT4
	.long	ani_nosleep	; dont sleep after next frame
	.long	RNSHORTCUT5
	.long	0
	.long	RNSHORTCUT3
	.long	RNSHORTCUT2
	.long	RNSHORTCUT1
	.long	0

RNSHORTCUT1
	.long	RNSHORTCUT1A,RNSHORTCUT1B,0
RNSHORTCUT2
	.long	RNSHORTCUT2A,RNSHORTCUT2B,0
RNSHORTCUT3
	.long	RNSHORTCUT3A,RNSHORTCUT3B,RNSHORTCUT3C,RNSHORTCUT3D
	.long	0
RNSHORTCUT4
	.long	RNSHORTCUT4A,RNSHORTCUT4B,RNSHORTCUT4C,RNSHORTCUT4D
	.long	0
RNSHORTCUT5
	.long	RNSHORTCUT5A,RNSHORTCUT5B,0

;***********************************************************************

a_rdstumble
	.long	RNSTUMBLE1
	.long	RNSTUMBLE2
	.long	RNSTUMBLE3
	.long	RNSTUMBLE4
	.long	RNSTUMBLE5
	.long	RNSTUMBLE6
	.long	0

RNSTUMBLE1
	.long	RNSTUMBLE1A,RNSTUMBLE1B,0
RNSTUMBLE2
	.long	RNSTUMBLE2A,RNSTUMBLE2B,RNSTUMBLE2C,RNSTUMBLE2D,0
RNSTUMBLE3
	.long	RNSTUMBLE3A,RNSTUMBLE3B,RNSTUMBLE3C,0
RNSTUMBLE4
	.long	RNSTUMBLE4A,RNSTUMBLE4B,RNSTUMBLE4C,0
RNSTUMBLE5
	.long	RNSTUMBLE5A,RNSTUMBLE5B,RNSTUMBLE5C,0
RNSTUMBLE6
	.long	RNSTUMBLE6A,RNSTUMBLE6B,0

;***********************************************************************

a_rdbodyslam
	.long	RNFLIP1
	.long	RNFLIP2
	.long	0		; step #1 = grab

	.long	ani_calla,me_in_back
	.long	RNFLIP3

	.long	RNFLIP5
	.long	RNFLIP5

	.long	RNFLIP7
	.long	RNFLIP8
	.long	0

	.long	RNFLIP8
	.long	ani_flip  
	.long	RNTURN1
	.long	0

RNFLIP1	.long	RNFLIP1A,RNFLIP1B,0
RNFLIP2	.long	RNFLIP2A,RNFLIP2B,RNFLIP2C,0
RNFLIP3	.long	RNFLIP3A,RNFLIP3B,RNFLIP3C,0
RNFLIP5	.long	RNFLIP5A,RNFLIP5B,RNFLIP5C,RNFLIP5D,0
RNFLIP7	.long	RNFLIP7A,RNFLIP7B,RNFLIP7C,0
RNFLIP8	.long	RNFLIP8A,RNFLIP8B,0

;***********************************************************************

a_shredded
	.long	ani_adjustxy
	.word	6,6
	.long	RNSTUMBLE1

	.long	ani_adjustxy
	.word	-6,-6
	.long	RNSTUMBLE2

	.long	ani_adjustxy
	.word	6,6
	.long	RNSTUMBLE3

	.long	ani_adjustxy
	.word	-6,-6
	.long	RNSTUMBLE2

	.long	ani_jump,a_shredded


;***********************************************************************

a_rdzap
	.long	RNTHROBOLT1
	.long	RNTHROBOLT2
	.long	RNTHROBOLT3
	.long	RNTHROBOLT4
	.long	0

RNTHROBOLT1
	.long	RNTHROBOLT1A,RNTHROBOLT1B,0
RNTHROBOLT2
	.long	RNTHROBOLT2A,RNTHROBOLT2B,0
RNTHROBOLT3
	.long	RNTHROBOLT3A,RNTHROBOLT3B,0
RNTHROBOLT4
	.long	RNTHROBOLT4A,RNTHROBOLT4B,0

;***********************************************************************

a_rdprojani
	.long	ZAP1
	.long	ZAP2
	.long	ZAP3
	.long	ZAP4
	.long	0

	.long	ZAP5
	.long	ZAP6
	.long	0
	.long	ZAP7
	.long	ZAP8

bolt_loop
	.long	ZAP9
	.long	ZAP10
	.long	ZAP11
	.long	ZAP12
	.long	ani_jump,bolt_loop
	.long	0
*
* bolt hit
*
	.long	ZAP12
	.long	ZAP13
	.long	ZAP14
	.long	ZAP15
	.long	ZAP16
	.long	ZAP17
	.long	ZAP18
	.long	ZAP19
	.long	0

ZAP1	.long	RNFLYBOLT1A,RNFLYBOLT1B,0
ZAP2	.long	RNFLYBOLT2A,RNFLYBOLT2B,0
ZAP3	.long	RNFLYBOLT3A,RNFLYBOLT3B,0
ZAP4	.long	RNFLYBOLT4A,RNFLYBOLT4B,0
ZAP5	.long	RNFLYBOLT5A,RNFLYBOLT5B,0
ZAP6	.long	RNFLYBOLT6A,RNFLYBOLT6B,RNFLYBOLT6C,0
ZAP7	.long	RNFLYBOLT7A,RNFLYBOLT7B,RNFLYBOLT7C,RNFLYBOLT7D,0
ZAP8	.long	RNFLYBOLT8A,RNFLYBOLT8B,RNFLYBOLT8C,0
ZAP9	.long	RNFLYBOLT9A,RNFLYBOLT9B,0
ZAP10	.long	RNFLYBOLT10A,RNFLYBOLT10B,0
ZAP11	.long	RNFLYBOLT11A,RNFLYBOLT11B,0
ZAP12	.long	RNFLYBOLT12A,RNFLYBOLT12B,0
ZAP13	.long	RNFLYBOLT13A,RNFLYBOLT13B,RNFLYBOLT13C,RNFLYBOLT13D,0
ZAP14	.long	RNFLYBOLT14A,RNFLYBOLT14B,RNFLYBOLT14C,RNFLYBOLT14D,RNFLYBOLT14E,0
ZAP15	.long	RNFLYBOLT15A,RNFLYBOLT15B,RNFLYBOLT15C,RNFLYBOLT15D,RNFLYBOLT15E,0
ZAP16	.long	RNFLYBOLT16A,RNFLYBOLT16B,RNFLYBOLT16C,RNFLYBOLT16D,RNFLYBOLT16E,0
ZAP17	.long	RNFLYBOLT17A,RNFLYBOLT17B,RNFLYBOLT17C,RNFLYBOLT17D,RNFLYBOLT17E,0
ZAP18	.long	RNFLYBOLT18A,RNFLYBOLT18B,RNFLYBOLT18C,RNFLYBOLT18D,RNFLYBOLT18E,0
ZAP19	.long	RNFLYBOLT19A,RNFLYBOLT19B,0

;***********************************************************************

a_rdstunned
	.long	RNSTUNNED1
	.long	RNSTUNNED2
	.long	RNSTUNNED3
	.long	RNSTUNNED4
	.long	RNSTUNNED5
	.long	RNSTUNNED6
	.long	RNSTUNNED7
	.long	ani_jump,a_rdstunned

RNSTUNNED1
	.long	RNSTUNNED1A,RNSTUNNED1B,0
RNSTUNNED2
	.long	RNSTUNNED2A,RNSTUNNED2B,0
RNSTUNNED3
	.long	RNSTUNNED3A,RNSTUNNED3B,0
RNSTUNNED4
	.long	RNSTUNNED4A,RNSTUNNED4B,0
RNSTUNNED5
	.long	RNSTUNNED5A,RNSTUNNED5B,0
RNSTUNNED6
	.long	RNSTUNNED6A,RNSTUNNED6B,0
RNSTUNNED7
	.long	RNSTUNNED7A,RNSTUNNED7B,0

;***********************************************************************

a_rdvictory
	.long	RNVICTORY1
	.long	RNVICTORY2
	.long	RNVICTORY3
	.long	RNVICTORY4
	.long	RNVICTORY5
	.long	RNVICTORY6
	.long	RNVICTORY7
	.long	0


RNVICTORY1
	.long	RNVICTORY1A,RNVICTORY1B,RNVICTORY1C,RNVICTORY1D,0
RNVICTORY2
	.long	RNVICTORY2A,RNVICTORY2B,RNVICTORY2C,RNVICTORY2D,0
RNVICTORY3
	.long	RNVICTORY3A,RNVICTORY3B,0
RNVICTORY4
	.long	RNVICTORY4A,RNVICTORY4B,0
RNVICTORY5
	.long	RNVICTORY5A,RNVICTORY5B,0
RNVICTORY6
	.long	RNVICTORY6A,RNVICTORY6B,RNVICTORY6C,RNVICTORY6D,0
RNVICTORY7
	.long	RNVICTORY7A,RNVICTORY7B,RNVICTORY7C,RNVICTORY7D,0

;***********************************************************************

a_rd_fb_hh
	.long	ani_adjustxy
	.word	->4a,0		; we need even # of words here !
	.long	RNFLIPPED1
	.long	0

	.long	ani_flip
	.long	RNFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>80,->20
	.long	RNFLIPPED3
	.long	RNFLIPPED4
	.long	RNKNOCKDOWN4
	.long	0

;*************************************************************************

a_banged
	.long	RNFLIPPED1
	.long	RNFLIPPED2
	.long	RNFLIPPED3
	.long	RNFLIPPED4
	.long	0

RNFLIPPED1
	.long	RNFLIPPED1A,RNFLIPPED1B,0
RNFLIPPED2
	.long	RNFLIPPED2A,RNFLIPPED2B,RNFLIPPED2C,RNFLIPPED2D,0
RNFLIPPED3
	.long	RNFLIPPED3A,RNFLIPPED3B,RNFLIPPED3C,0
RNFLIPPED4
	.long	RNFLIPPED4A,RNFLIPPED4B,0

;***********************************************************************

a_rd_fb_lk
	.long	ani_adjustxy
	.word	->40,>00
	.long	RNFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>1f,>11
	.long	RNFLIPPED2

	.long	ani_adjustxy
	.word	>13,>02
	.long	RNFLIPPED2

	.long	ani_adjustxy
	.word	>30,>08
	.long	RNFLIPPED3

	.long	ani_adjustxy
	.word	>30,->10
	.long	RNFLIPPED3

	.long	ani_adjustxy
	.word	>20,->1a
	.long	RNFLIPPED4
	.long	0
*
* land on the ground
*
	.long	RNKNOCKDOWN6
	.long	RNKNOCKDOWN7
	.long	0


a_rd_fb_nj
	.long	ani_adjustxy
	.word	->40,>00
	.long	RNFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>04,>00
	.long	RNFLIPPED1

	.long	ani_adjustxy
	.word	>13,>12
	.long	RNFLIPPED2

	.long	ani_adjustxy
	.word	>30,>08
	.long	RNFLIPPED3

	.long	ani_adjustxy
	.word	>30,->10
	.long	RNFLIPPED3

	.long	ani_adjustxy
	.word	>20,->1a
	.long	RNFLIPPED4
	.long	0
*
* land on the ground
*
	.long	RNKNOCKDOWN6
	.long	RNKNOCKDOWN7
	.long	0

;***********************************************************************

a_rd_fb_jx
	.long	ani_adjustxy
	.word	->52,>00
	.long	RNSTUMBLE1
	.long	RNSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>15,->40
	.long	RNFLIPPED2	; jax 3

	.long	ani_adjustxy
	.word	>35,->20
	.long	RNFLIPPED3	; jax 4

	.long	ani_adjustxy
	.word	>38,>18
	.long	RNFLIPPED3	; jax 5

	.long	ani_adjustxy
	.word	>20,>40
	.long	RNFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	>00,>05
	.long	RNKNOCKDOWN7	; jax 7
	.long	0
*
* slammed again !
*
	.long	RNFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	->18,->46
	.long	RNFLIPPED4	; jax 6

	.long	ani_flip
	.long	ani_adjustxy
	.word	>4a,->18
	.long	RNFLIPPED3	; jax 4

	.long	ani_adjustxy
	.word	>34,>18
	.long	RNFLIPPED4	; jax 3

	.long	ani_adjustxy
	.word	>10,>46
	.long	RNFLIPPED4

	.long	ani_adjustxy
	.word	->10,>00
	.long	RNKNOCKDOWN7	; jax 7
	.long	0

;***********************************************************************

a_rd_fb_jc
	.long	ani_adjustxy
	.word	->40,>08
	.long	RNFLIPPED1
	.long	RNFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>0f,->20
	.long	RNFLIPPED2

	.long	ani_adjustxy
	.word	>70,>04
	.long	RNFLIPPED3

	.long	ani_adjustxy
	.word	>20,>40
	.long	RNFLIPPED4
	.long	0

;***********************************************************************

a_rd_fb_sa
	.long	ani_adjustxy
	.word	->40,>00
	.long	RNFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>0d,->28
	.long	RNFLIPPED1

	.long	ani_adjustxy
	.word	>2a,->20
	.long	RNFLIPPED2

	.long	ani_adjustxy
	.word	>3f,->10
	.long	RNFLIPPED3
	.long	0

;***********************************************************************

a_rd_fb_fn
	.long	ani_adjustxy
	.word	->40,->10
	.long	ani_flip
	.long	RNFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	->20,->4a
	.long	RNKNOCKDOWN4

	.long	ani_adjustxy
	.word	->30,->08
	.long	RNKNOCKDOWN4

	.long	ani_adjustxy
	.word	->30,>b9
	.long	ani_flip
	.long	ani_flip_v
	.long	RNFLIPPED2

	.long	ani_adjustxy
	.word	>00,->40
	.long	ani_flip
	.long	ani_flip_v
	.long	RNFLIPPED3

	.long	ani_adjustxy
	.word	->20,>10
	.long	RNFLIPPED3
	.long	0
*
* bounce on ground
*
	.long	RNKNOCKDOWN6
	.long	0

;***********************************************************************

a_rd_fb_st
	.long	ani_adjustxy
	.word	->38,>00
	.long	RNFLIPPED1
	.long	RNFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>06,->20
	.long	RNFLIPPED1
	.long	ani_adjustxy
	.word	>40,->20
	.long	RNFLIPPED3
	.long	ani_adjustxy
	.word	>30,>30
	.long	RNFLIPPED4
	.long	ani_adjustxy
	.word	>18,>30
	.long	RNFLIPPED4
	.long	0

	.long	ani_adjustxy
	.word	>10,>00
	.long	RNKNOCKDOWN6
	.long	0

;***********************************************************************

a_rd_fb_rd
	.long	ani_adjustxy
	.word	->4c,>00
	.long	RNFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>0a,->2f
	.long	RNFLIPPED1

	.long	ani_flip
	.long	ani_adjustxy
	.word	->34,->60
	.long	RNKNOCKDOWN6
	.long	RNKNOCKDOWN6

	.long	ani_adjustxy
	.word	->0a,>30
	.long	RNKNOCKDOWN6

	.long	ani_adjustxy
	.word	->18,>40
	.long	RNKNOCKDOWN6
	.long	0

	.long	ani_adjustxy
	.word	->28,>10
	.long	RNKNOCKDOWN6
	.long	0

;********************************************************************

a_nutcrunched
	.long	RNUTCRUNCH1
	.long	RNUTCRUNCH2
	.long	0
	.long	RNUTCRUNCH1
	.long	0

RNUTCRUNCH1
	.long	RNUTCRUNCH1A,RNUTCRUNCH1B,0
RNUTCRUNCH2
	.long	RNUTCRUNCH2A,RNUTCRUNCH2B,0

;***********************************************************************

a_bike_kicked
	.long	RNSTUMBLE1
	.long	RNSTUMBLE2
	.long	RNSTUMBLE3
	.long	RNSTUMBLE4
	.long	RNSTUMBLE5
	.long	RNSTUMBLE6
	.long	ani_jump,a_bike_kicked

;***********************************************************************

a_drained
	.long	ani_adjustxy
	.word	->48,->13
	.long	RNSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	->11,>1a
	.long	RDDRAIN0
	.long	ani_adjustxy
	.word	>13,->08
	.long	RDDRAIN0
	.long	ani_adjustxy
	.word	>08,->14
	.long	RDDRAIN0
	.long	ani_adjustxy
	.word	8,0
	.long	RDDRAIN0
	.long	0

;*********************************************************************

a_superman
	.long	RNFLY1
	.long	RNFLY2
	.long	0
	.long	RNFLY3
	.long	RNFLY4
	.long	0

RNFLY1	.long	RNFLY1A,RNFLY1B,RNFLY1C,0
RNFLY2	.long	RNFLY2A,RNFLY2B,RNFLY2C,RNFLY2D
	.long	RNFLY2E,0
RNFLY4	.long	RNFLY4A,RNFLY4B,RNFLY4C,RNFLY4D
	.long	0
RNFLY3	.long	RNFLY3A,RNFLY3B,RNFLY3C,RNFLY3D
	.long	0

;*********************************************************************

a_death_shock
	.long	RNSHOCKER1
	.long	0

a_shocker
	.long	RNSHOCKER1
jshok	.long	RNSHOCKER2
	.long	RNSHOCKER3
	.long	ani_jump,jshok

RNSHOCKER1
	.long	RNSHOCKER1A,RNSHOCKER1B,RNSHOCKER1C,0
RNSHOCKER2
	.long	RNSHOCKER2A,RNSHOCKER2B,RNSHOCKER2C,0
RNSHOCKER3
	.long	RNSHOCKER3A,RNSHOCKER3B,RNSHOCKER3C,0


;*********************************************************************


;RNSHORTZAP1
;	.long	RNSHORTZAP1A,RNSHORTZAP1B,0
;RNSHORTZAP2
;	.long	RNSHORTZAP2A,RNSHORTZAP2B,0
;RNSHORTZAP3
;	.long	RNSHORTZAP3A,RNSHORTZAP3B,RNSHORTZAP3C,0
;RNSHORTZAP4
;	.long	RNSHORTZAP4A,RNSHORTZAP4B,RNSHORTZAP4C,0

a_death_zap2
	.long	RN2DETHBLO1
	.long	RN2DETHBLO2
	.long	RN2DETHBLO3
	.long	0

RN2DETHBLO1
	.long	RN2DETHBLO1A,RN2DETHBLO1B,0
RN2DETHBLO2
	.long	RN2DETHBLO2A,RN2DETHBLO2B,RN2DETHBLO2C,0
RN2DETHBLO3
	.long	RN2DETHBLO3A,RN2DETHBLO3B,RN2DETHBLO3C,0

;************************************************************************

RN1DETHBLO1
	.long	RN1DETHBLO1A,RN1DETHBLO1B,RN1DETHBLO1C,0
RN1DETHBLO2
	.long	RN1DETHBLO2A,RN1DETHBLO2B,RN1DETHBLO2C,0
RN1DETHBLO3
	.long	RN1DETHBLO3A,RN1DETHBLO3B,RN1DETHBLO3C,0
RN1DETHBLO4
	.long	RN1DETHBLO4A,RN1DETHBLO4B,RN1DETHBLO4C,0
RN1DETHBLO5
	.long	RN1DETHBLO5A,RN1DETHBLO5B,RN1DETHBLO5C,0
RN1DETHBLO6
	.long	RN1DETHBLO6A,RN1DETHBLO6B,RN1DETHBLO6C,RN1DETHBLO6D,0
RN1DETHBLO7
	.long	RN1DETHBLO7A,RN1DETHBLO7B,RN1DETHBLO7C,RN1DETHBLO7D,0
RN1DETHBLO8
	.long	RN1DETHBLO8A,RN1DETHBLO8B,RN1DETHBLO8C,RN1DETHBLO8D,0
RN1DETHBLO9
	.long	RN1DETHBLO9A,RN1DETHBLO9B,RN1DETHBLO9C,RN1DETHBLO9D,0
RN1DETHBLO10
	.long	RN1DETHBLO10A,RN1DETHBLO10B,RN1DETHBLO10C,RN1DETHBLO10D,0

;**********************************************************************

RN1BOLT1
	.long	RN1BOLT1A,0
RN1BOLT2
	.long	RN1BOLT2A,RN1BOLT2B,0
RN1BOLT3
	.long	RN1BOLT3A,RN1BOLT3B,0
RN1BOLT4
	.long	RN1BOLT4A,0
RN1BOLT5
	.long	RN1BOLT5A,RN1BOLT5B,0
RN1BOLT6
	.long	RN1BOLT6A,RN1BOLT6B,0
RN1BOLT7
	.long	RN1BOLT7A,RN1BOLT7B,0
RN2BOLT1
	.long	RN2BOLT1A,RN2BOLT1B,0
RN2BOLT2
	.long	RN2BOLT2A,RN2BOLT2B,0
RN2BOLT3
	.long	RN2BOLT3A,RN2BOLT3B,RN2BOLT3C,0
RN2BOLT4
	.long	RN2BOLT4A,RN2BOLT4B,0
RN2BOLT5
	.long	RN2BOLT5A,RN2BOLT5B,0
RN2BOLT6
	.long	RN2BOLT6A,RN2BOLT6B,0
RN2BOLT7
	.long	RN2BOLT7A,RN2BOLT7B,RN2BOLT7C,0
RN2BOLT8
	.long	RN2BOLT8A,RN2BOLT8B,RN2BOLT8C,0
RN2BOLT9
	.long	RN2BOLT9A,RN2BOLT9B,RN2BOLT9C,0
RN3BOLT1
	.long	RN3BOLT1A,0
RN3BOLT2
	.long	RN3BOLT2A,0
RN3BOLT3
	.long	RN3BOLT3A,RN3BOLT3B,0
RN3BOLT4
	.long	RN3BOLT4A,RN3BOLT4B,0
RN3BOLT5
	.long	RN3BOLT5A,RN3BOLT5B,0
RN3BOLT6
	.long	RN3BOLT6A,RN3BOLT6B,0
RN3BOLT7
	.long	RN3BOLT7A,RN3BOLT7B,0
RN3BOLT8
	.long	RN3BOLT8A,RN3BOLT8B,0
RN3BOLT9
	.long	RN3BOLT9A,RN3BOLT9B,0
RN3BOLT10
	.long	RN3BOLT10A,0
RN4BOLT1
	.long	RN4BOLT1A,0
RN4BOLT2
	.long	RN4BOLT2A,RN4BOLT2B,0
RN4BOLT3
	.long	RN4BOLT3A,RN4BOLT3B,0
RN4BOLT4
	.long	RN4BOLT4A,RN4BOLT4B,RN4BOLT4C,0
RN4BOLT5
	.long	RN4BOLT5A,RN4BOLT5B,RN4BOLT5C,0
RN4BOLT6
	.long	RN4BOLT6A,RN4BOLT6B,RN4BOLT6C,0
RN4BOLT7
	.long	RN4BOLT7A,RN4BOLT7B,RN4BOLT7C,0
RN5BOLT1
	.long	RN5BOLT1A,0
RN5BOLT2
	.long	RN5BOLT2A,RN5BOLT2B,0
RN5BOLT3
	.long	RN5BOLT3A,RN5BOLT3B,0
RN5BOLT4
	.long	RN5BOLT4A,RN5BOLT4B,0
RN5BOLT5
	.long	RN5BOLT5A,RN5BOLT5B,0
RN5BOLT6
	.long	RN5BOLT6A,RN5BOLT6B,0
RN5BOLT7
	.long	RN5BOLT7A,RN5BOLT7B,0
RN5BOLT8
	.long	RN5BOLT8A,RN5BOLT8B,0
RN5BOLT9
	.long	RN5BOLT9A,RN5BOLT9B,0
RN6BOLT1
	.long	RN6BOLT1A,0
RN6BOLT2
	.long	RN6BOLT2A,0
RN6BOLT3
	.long	RN6BOLT3A,0
RN6BOLT4
	.long	RN6BOLT4A,RN6BOLT4B,0
RN6BOLT5
	.long	RN6BOLT5A,0
RN6BOLT6
	.long	RN6BOLT6A,0
RN6BOLT7
	.long	RN6BOLT7A,0
RN6BOLT8
	.long	RN6BOLT8A,RN6BOLT8B,0
RN6BOLT9
	.long	RN6BOLT9A,RN6BOLT9B,0
RN6BOLT10
	.long	RN6BOLT10A,RN6BOLT10B,0
RN6BOLT11
	.long	RN6BOLT11A,RN6BOLT11B,0
RN6BOLT12
	.long	RN6BOLT12A,0

;***********************************************************************

a_torso_ripped
	.long	ani_adjustxy
	.word	->43,>00
	.long	RNSTUMBLE1
	.long	0

	.long	ani_calla,change_to_bloody_pal	; switch to bloody pal
	.long	RNRIPTORSO1

	.long	ani_adjustxy
	.word	>18,->20
	.long	RNRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>00,>08
	.long	RNRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>30,>20
	.long	RNRIPTORSO3

	.long	ani_adjustxy
	.word	>30,>40
	.long	RNRIPTORSO4
	.long	0

	.long	RNRIPTORSO5
	.long	RNRIPTORSO5
	.long	0
*
* standing legz
*
	.long	RNDECAPLEG1		; legz
	.long	0


RNRIPTORSO1
	.long	RNRIPTORSO1A,RNRIPTORSO1B,0
RNRIPTORSO2
	.long	RNRIPTORSO2A,RNRIPTORSO2B,RNRIPTORSO2C,0
RNRIPTORSO3
	.long	RNRIPTORSO3A,RNRIPTORSO3B,0
RNRIPTORSO4
	.long	RNRIPTORSO4A,RNRIPTORSO4B,0
RNRIPTORSO5
	.long	RNRIPTORSO5A,RNRIPTORSO5B,0
RNRIPTORSO6
	.long	RNRIPTORSO6A,RNRIPTORSO6B,0

a_swipe_torso
	.long	RNRIPTORSO1
	.long	RNRIPTORSO2
	.long	RNRIPTORSO3
	.long	RNRIPTORSO4
	.long	RNRIPTORSO5
	.long	RNRIPTORSO6
	.long	0

;***********************************************************************

a_head
	.long	RNHEAD1
	.long	RNHEAD2
	.long	RNHEAD3
	.long	RNHEAD4
	.long	RNHEAD5
	.long	RNHEAD6
	.long	RNHEAD7
	.long	RNHEAD8
	.long	ani_jump,a_head

a_decapfall
	.long	RNDECAP1
	.long	RNDECAP2
	.long	RNDECAP3	; on knees
	.long	0
*
* wobble on yer knees
*
	.long	RNDECAP4
	.long	RNDECAP3
	.long	RNDECAP4
	.long	RNDECAP3
	.long	RNDECAP4
	.long	RNDECAP3
	.long	0
*
* fall to ground
*
	.long	RNDECAP4
	.long	RNDECAP5
	.long	RNDECAP6
	.long	RNDECAP7
	.long	0


RNDECAP1
	.long	RNDECAPLEG1A
	.long	RNDECAPTORSO1A,0
RNDECAP2
	.long	RNDECAPLEG2A
	.long	RNDECAPTORSO2A,0
RNDECAP3
	.long	RNDECAPLEG3A,RNDECAPLEG3B
	.long	RNDECAPTORSO3A,0
RNDECAP4
	.long	RNDECAPLEG4A,RNDECAPLEG4B
	.long	RNDECAPTORSO4A,0
RNDECAP5
	.long	RNDECAPLEG5A,RNDECAPLEG5B,RNDECAPLEG5C
	.long	RNDECAPTORSO5A,0
RNDECAP6
	.long	RNDECAPLEG6A,RNDECAPLEG6B,RNDECAPLEG6C
	.long	RNDECAPTORSO6A,0
RNDECAP7
	.long	RNDECAPLEG7A,RNDECAPLEG7B
	.long	RNDECAPTORSO7A,0

;RNDECAPTORSO1
;	.long	RNDECAPTORSO1A,0
;RNDECAPTORSO2
;	.long	RNDECAPTORSO2A,0
;RNDECAPTORSO3
;	.long	RNDECAPTORSO3A,0
;RNDECAPTORSO4
;	.long	RNDECAPTORSO4A,0
;RNDECAPTORSO5
;	.long	RNDECAPTORSO5A,0
;RNDECAPTORSO6
;	.long	RNDECAPTORSO6A,0
;RNDECAPTORSO7
;	.long	RNDECAPTORSO7A,0
RNDECAPLEG1
	.long	RNDECAPLEG1A,0
;RNDECAPLEG2
;	.long	RNDECAPLEG2A,0
;RNDECAPLEG3
;	.long	RNDECAPLEG3A,RNDECAPLEG3B,0
;RNDECAPLEG4
;	.long	RNDECAPLEG4A,RNDECAPLEG4B,0
;RNDECAPLEG5
;	.long	RNDECAPLEG5A,RNDECAPLEG5B,RNDECAPLEG5C,0
;RNDECAPLEG6
;	.long	RNDECAPLEG6A,RNDECAPLEG6B,RNDECAPLEG6C,0
;RNDECAPLEG7
;	.long	RNDECAPLEG7A,RNDECAPLEG7B,0



a_back_broke
	.long	RNBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>0a
	.long	RNBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>30
	.long	RNBACKBREAK1
	.long	RNBACKBREAK2
	.long	RNBACKBREAK3
	.long	0
	.long	RNBACKBREAK2
	.long	RNBACKBREAK1
	.long	0

RNBACKBREAK1
	.long	RNBACKBREAK1A,RNBACKBREAK1B,RNBACKBREAK1C,0
RNBACKBREAK2
	.long	RNBACKBREAK2A,RNBACKBREAK2B,RNBACKBREAK2C,RNBACKBREAK2D
	.long	RNBACKBREAK2E,0
RNBACKBREAK3
	.long	RNBACKBREAK3A,RNBACKBREAK3B,RNBACKBREAK3C,RNBACKBREAK3D
	.long	0

a_impaled
	.long	ani_adjustxy
	.word	->60,>00
	.long	RDIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	RDIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	RDIMPALED1

	.long	ani_adjustxy
	.word	>10,->15
	.long	RDIMPALED1

	.long	0
*
* suffering (that's Christmas)
*
	.long	RDIMPALED1
	.long	RDIMPALED2
	.long	RDIMPALED3

	.long	RDIMPALED2
	.long	RDIMPALED1
	.long	RDIMPALED2
	.long	RDIMPALED3
	.long	0


RDIMPALED1
	.long	RDIMPALED1A,0
RDIMPALED2
	.long	RDIMPALED2A,RDIMPALED2B,0
RDIMPALED3
	.long	RDIMPALED3A,RDIMPALED3B,RDIMPALED3C,0

;***********************************************************************

a_fb_goro
	.long	ani_adjustxy
	.word	->60,->20
	.long	RNFLIPPED1

	.long	ani_adjustxy
	.word	>10,->70
	.long	RNKNOCKDOWN7

	.long	ani_adjustxy
	.word	>20,>00
	.long	RNKNOCKDOWN7

	.long	ani_adjustxy
	.word	>2a,>10
	.long	RNKNOCKDOWN6

	.long	ani_adjustxy
	.word	>38,>10
	.long	RNKNOCKDOWN6

	.long	ani_adjustxy
	.word	>00,>68
	.long	RNKNOCKDOWN7

	.long	0

;********************************************************************

a_victory_bolts
	.long	RNVICBOLT1
	.long	RNVICBOLT2
	.long	RNVICBOLT3
	.long	RNVICBOLT4
	.long	RNVICBOLT5
	.long	RNVICBOLT6
	.long	RNVICBOLT7
	.long	RNVICBOLT8
	.long	0

KLUDGE_BOLT1A
	.word   19,27,115,91
	.long   05492ac6H
	.word   06080H
	.long   ELEC_P

RNVICBOLT1
	.long	KLUDGE_BOLT1A,RNVICBOLT1B,0
RNVICBOLT2
	.long	RNVICBOLT2A,RNVICBOLT2B,0
RNVICBOLT3
	.long	RNVICBOLT3A,RNVICBOLT3B,0
RNVICBOLT4
	.long	RNVICBOLT4A,RNVICBOLT4B,RNVICBOLT4C,0
RNVICBOLT5
	.long	RNVICBOLT5A,RNVICBOLT5B,RNVICBOLT5C,RNVICBOLT5D,0
RNVICBOLT6
	.long	RNVICBOLT6A,RNVICBOLT6B,RNVICBOLT6C,RNVICBOLT6D,0
RNVICBOLT7
	.long	RNVICBOLT7A,RNVICBOLT7B,RNVICBOLT7C,0
RNVICBOLT8
	.long	RNVICBOLT8A,RNVICBOLT8B,0

;********************************************************************

	.end



