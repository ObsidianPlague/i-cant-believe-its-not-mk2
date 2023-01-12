**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: Ninjas										*
*											     *
**************************************************************************
	.FILE	'MKNJ.ASM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
*
* GET THE SYSTEM STUFF
*
	.INCLUDE	MAINEQU.ASM
	.INCLUDE	MKNJ.TBL
	.INCLUDE	IMGTBL.GLO
	.text

sz_anitab1
rp_anitab1
sc_anitab1
sm_anitab1
	.long	a_njstance	;  0 - stance
	.long	a_njwalkf	;  1 - walk forward
	.long	a_njskipf	;  2 - skip forward
	.long	a_njwalkb	;  3 - walk backward
	.long	a_njskipb	;  4 - walk backward
	.long	a_njduck  	;  5 - duck animation
	.long	a_njjumpup	;  6 - jump straight up
	.long	a_njfflip	;  7 - forward flip
	.long	a_njbflip	;  8 - backward flip
	.long	a_njturn	;  9 - turn around
	.long	a_njduckturn	;  a - turn around while ducking
	.long	a_njblockhi	;  b - standing block
	.long	a_njduckblock	;  c - ducking block
	.long	a_njhikick	;  d - hi kick
	.long	a_njlokick	;  e - lo kick
	.long	a_njkdown	;  f - knocked down
	.long	a_njhithi	; 10 - hit high
	.long	a_njhitlo	; 11 - hit low
	.long	a_njgetup	; 12 - normal getup
	.long	a_njhipunch	; 13 - hi punch
	.long	a_njlopunch	; 14 - lo punch
	.long	a_njsweep	; 15 - sweep kick
	.long	a_njsweepfall	; 16 - sweep fall
	.long	a_njsweepup	; 17 - getup from sweep kick
	.long	a_njduckpunch	; 18 - duck punch
	.long	a_njduckkickh	; 19 - duck kick high
	.long	a_njduckkickl	; 1a - duck kick low
	.long	a_njduckhit	; 1b - hit while ducking
	.long	a_njuppercut	; 1c - uppercut
	.long	a_njjumpupkick	; 1d - jump straight up kick
	.long	a_njflipkick	; 1e - flip kick
	.long	a_njflippunch	; 1f - flip punch
	.long	a_njroundh	; 20 - roundhouse kick
	.long	a_njknee	; 21 - knee
	.long	a_njelbow	; 22 - elbow
	.long	a_njstumble	; 23 - stumble back
	.long	a_njbodyslam	; 24 - body slam
	.long	a_shredded	; 25 -
	.long	a_njzap		; 26 - throwing fireball
	.long	a_njprojani	; 27 - fireball ani
	.long	a_njstunned	; 28 - stunned
	.long	a_njvictory	; 29 - victory
	.long	a_nj_fb_hh	; 2a - ninjas flipped by hatheat
	.long	a_nj_fb_lk	; 2b - ninjas flipped by liu kang
	.long	a_nj_fb_jc	; 2c - ninjas flipped by cage
	.long	a_nj_fb_sa	; 2d - ninjas flipped by sa
	.long	a_nj_fb_fn	; 2e - ninjas flipped by female ninja
	.long	a_nj_fb_fn	; 2f - ninjas flipped by female ninja
	.long	a_nj_fb_st	; 30 - ninjas flipped by shang tsung
	.long	a_nj_fb_rd	; 31 - ninjas flipped by raiden
	.long	a_nj_fb_nj	; 32 - ninjas flipped by ninja
	.long	a_nj_fb_nj	; 33 - ninjas flipped by ninja
	.long	a_nj_fb_nj	; 34 - ninjas flipped by ninja
	.long	a_nj_fb_jx	; 35 - ninjas flipped by jax

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
	.long	0
	.long	a_swipe_torso	; 41 - scorpion swiped me torso



sz_anitab2
	.long	a_slide		; 0 - Subzero slide move
	.long	a_ice_ball	; 1 - iceball
	.long	a_floor_ice	; 2 - floor ice
	.long	a_ice_down	; 3 - subzero throwing ice on ground
	.long	a_pitch		; 4 - pitch a snowball

rp_anitab2
	.long	a_slide		; 0 - Subzero slide move
	.long	a_slow_proj	; 1 - launch slow projectile
	.long	a_ring_bang	; 2 - reptile ring BANG!
	.long	a_acid_fly	; 3 - reptile acid fly
	.long	a_spit		; 4 - reptile spitting !!
	.long	a_eat_head	; 5 - reptile fatality
	.long	a_tongue	; 6 - tongue ani
	.long	a_inviso	; 7 - inviso

sm_anitab2
sc_anitab2
	.long	a_throw_spear	 ; 0 - throw scorpion spear
	.long	a_rope_ani	 ; 1 - rope animations
	.long	a_scissor_kick	 ; 2 - scissor kick
	.long	a_scortch	 ; 3 - scortch lean over
	.long	a_scorpion_skull ; 4 - scorpion skull head
	.long	a_sc_swipe	 ; 5 - death blow swipe
	.long	a_death_spear	 ; 6 -

a_njstance
	.long	ani_ochar_jump
	.word	ft_reptile		; am I reptile
	.long	j_rpst			; yes = new stance then !

	.long	ani_ochar_jump
	.word	ft_scorpion		; am I scorpion
	.long	j_scst			; yes = new stance then !

	.long	ani_ochar_jump
	.word	ft_smoke		; am I smoke
	.long	j_rpst			; yes = new stance then !

j_szst	.long	NJ1STANCE1
	.long	NJ1STANCE2
	.long	NJ1STANCE3
	.long	NJ1STANCE4
	.long	NJ1STANCE5
	.long	NJ1STANCE6
	.long	NJ1STANCE7
	.long	NJ1STANCE6
	.long	NJ1STANCE5
	.long	NJ1STANCE4
	.long	NJ1STANCE3
	.long	NJ1STANCE2
	.long	ani_jump,j_szst

j_rpst	.long	NJ2STANCE1
	.long	NJ2STANCE2
	.long	NJ2STANCE3
	.long	NJ2STANCE4
	.long	NJ2STANCE5
	.long	NJ2STANCE6
	.long	NJ2STANCE7
	.long	ani_jump,j_rpst

j_scst	.long	NJ3STANCE1
	.long	NJ3STANCE2
	.long	NJ3STANCE3
	.long	NJ3STANCE4
	.long	NJ3STANCE5
	.long	NJ3STANCE6
	.long	NJ3STANCE7
	.long	ani_jump,j_scst

NJ1STANCE1
	.long	NJ1STANCE1A,NJ1STANCE1B,0
NJ1STANCE2
	.long	NJ1STANCE2A,NJ1STANCE2B,0
NJ1STANCE3
	.long	NJ1STANCE3A,NJ1STANCE3B,0
NJ1STANCE4
	.long	NJ1STANCE4A,NJ1STANCE4B,0
NJ1STANCE5
	.long	NJ1STANCE5A,NJ1STANCE5B,0
NJ1STANCE6
	.long	NJ1STANCE6A,NJ1STANCE6B,0
NJ1STANCE7
	.long	NJ1STANCE7A,NJ1STANCE7B,0

;*********************************************************************

NJ2STANCE1
	.long	NJ2STANCE1A,NJ2STANCE1B,0
NJ2STANCE2
	.long	NJ2STANCE2A,NJ2STANCE2B,0
NJ2STANCE3
	.long	NJ2STANCE3A,NJ2STANCE3B,0
NJ2STANCE4
	.long	NJ2STANCE4A,NJ2STANCE4B,0
NJ2STANCE5
	.long	NJ2STANCE5A,NJ2STANCE5B,0
NJ2STANCE6
	.long	NJ2STANCE6A,NJ2STANCE6B,0
NJ2STANCE7
	.long	NJ2STANCE7A,NJ2STANCE7B,0

;*********************************************************************

NJ3STANCE1
	.long	NJ3STANCE1A,NJ3STANCE1B,0
NJ3STANCE2
	.long	NJ3STANCE2A,NJ3STANCE2B,NJ3STANCE2C,0
NJ3STANCE3
	.long	NJ3STANCE3A,NJ3STANCE3B,NJ3STANCE3C,0
NJ3STANCE4
	.long	NJ3STANCE4A,NJ3STANCE4B,NJ3STANCE4C,0
NJ3STANCE5
	.long	NJ3STANCE5A,NJ3STANCE5B,NJ3STANCE5C,0
NJ3STANCE6
	.long	NJ3STANCE6A,NJ3STANCE6B,NJ3STANCE6C,0
NJ3STANCE7
	.long	NJ3STANCE7A,NJ3STANCE7B,NJ3STANCE7C,0

;*********************************************************************

a_njwalkf
	.long	ani_ochar_jump
	.word	ft_reptile		; am I reptile
	.long	a_rpwalkf		; yes = new walk

	.long	ani_ochar_jump
	.word	ft_scorpion		; am I scorpion
	.long	a_scwalkf		; yes = new walk

	.long	ani_ochar_jump
	.word	ft_smoke		; am I smoke
	.long	a_rpwalkf		; yes = new walk


a_szwalkf
	.long	SZWALK1
	.long	SZWALK2
	.long	SZWALK3
	.long	SZWALK4
	.long	SZWALK5
	.long	SZWALK6
	.long	SZWALK7
	.long	SZWALK8
	.long	SZWALK9
	.long	ani_jump,a_szwalkf

a_rpwalkf
	.long	REPWALK1
	.long	REPWALK2
	.long	REPWALK3
	.long	REPWALK4
	.long	REPWALK5
	.long	REPWALK6
	.long	REPWALK7
	.long	REPWALK8
	.long	REPWALK9
	.long	ani_jump,a_rpwalkf

a_scwalkf
	.long	SCWALK1
	.long	SCWALK2
	.long	SCWALK3
	.long	SCWALK4
	.long	SCWALK5
	.long	SCWALK6
	.long	SCWALK7
	.long	SCWALK8
	.long	SCWALK9
	.long	ani_jump,a_scwalkf

a_njskipf
	.long	ani_ochar_jump
	.word	ft_reptile		; am I reptile
	.long	a_rpskipf		; yes = new skip

	.long	ani_ochar_jump
	.word	ft_scorpion		; am I scorpion
	.long	a_scskipf		; yes = new skip

	.long	SZWALK1
	.long	SZWALK2
	.long	SZWALK8
	.long	SZWALK9
	.long	0

a_rpskipf
	.long	REPWALK1
	.long	REPWALK2
	.long	REPWALK8
	.long	REPWALK9
	.long	0

a_scskipf
	.long	SCWALK1
	.long	SCWALK2
	.long	SCWALK8
	.long	SCWALK9
	.long	0

a_njwalkb
	.long	ani_ochar_jump
	.word	ft_reptile		; am I reptile
	.long	a_rpwalkb		; yes = new walk

	.long	ani_ochar_jump
	.word	ft_scorpion		; am I scorpion
	.long	a_scwalkb		; yes = new walk

a_szwalkb
	.long	SZWALK9
	.long	SZWALK8
	.long	SZWALK7
	.long	SZWALK6
	.long	SZWALK5
	.long	SZWALK4
	.long	SZWALK3
	.long	SZWALK2
	.long	SZWALK1
	.long	ani_jump,a_szwalkb

a_rpwalkb
	.long	REPWALK9
	.long	REPWALK8
	.long	REPWALK7
	.long	REPWALK6
	.long	REPWALK5
	.long	REPWALK4
	.long	REPWALK3
	.long	REPWALK2
	.long	REPWALK1
	.long	ani_jump,a_rpwalkb

a_scwalkb
	.long	SCWALK9
	.long	SCWALK8
	.long	SCWALK7
	.long	SCWALK6
	.long	SCWALK5
	.long	SCWALK4
	.long	SCWALK3
	.long	SCWALK2
	.long	SCWALK1
	.long	ani_jump,a_scwalkb

a_njskipb
	.long	ani_ochar_jump
	.word	ft_reptile		; am I reptile
	.long	a_rpskipb		; yes = new skip

	.long	ani_ochar_jump
	.word	ft_scorpion		; am I scorpion
	.long	a_scskipb		; yes = new skip

	.long	SZWALK9
	.long	SZWALK8
	.long	SZWALK2
	.long	SZWALK1
	.long	0

a_rpskipb
	.long	REPWALK9
	.long	REPWALK8
	.long	REPWALK2
	.long	REPWALK1
	.long	0

a_scskipb
	.long	SCWALK9
	.long	SCWALK8
	.long	SCWALK2
	.long	SCWALK1
	.long	0

SZWALK1	.long	NJWALKLEG1B,NJSUBTORSO1A,NJWALKLEG1A,0
SZWALK2	.long	NJWALKLEG2B,NJSUBTORSO2A,NJWALKLEG2A,0
SZWALK3	.long	NJWALKLEG3A,NJSUBTORSO3A,0
SZWALK4	.long	NJWALKLEG4B,NJSUBTORSO4A,NJWALKLEG4A,0
SZWALK5	.long	NJWALKLEG5B,NJSUBTORSO5A,NJWALKLEG5A,0
SZWALK6	.long	NJWALKLEG6B,NJSUBTORSO6A,NJWALKLEG6A,0
SZWALK7	.long	NJWALKLEG7B,NJSUBTORSO7A,NJWALKLEG7A,0
SZWALK8	.long	NJWALKLEG8B,NJSUBTORSO8A,NJWALKLEG8A,0
SZWALK9	.long	NJWALKLEG9B,NJSUBTORSO9A,NJWALKLEG9A,0

SCWALK1	.long	NJWALKLEG1B,NJSCORPTORSO1A,NJWALKLEG1A,0
SCWALK2	.long	NJWALKLEG2B,NJSCORPTORSO2A,NJWALKLEG2A,0
SCWALK3	.long	NJWALKLEG3A,NJSCORPTORSO3A,0
SCWALK4	.long	NJWALKLEG4B,NJSCORPTORSO4A,NJWALKLEG4A,0
SCWALK5	.long	NJWALKLEG5B,NJSCORPTORSO5A,NJWALKLEG5A,0
SCWALK6	.long	NJWALKLEG6B,NJSCORPTORSO6A,NJWALKLEG6A,0
SCWALK7	.long	NJWALKLEG7B,NJSCORPTORSO7A,NJWALKLEG7A,0
SCWALK8	.long	NJWALKLEG8B,NJSCORPTORSO8A,NJWALKLEG8A,0
SCWALK9	.long	NJWALKLEG9B,NJSCORPTORSO9A,NJWALKLEG9A,0

REPWALK1	.long	NJWALKLEG1A,NJWALKLEG1B,NJREPTORSO1A,NJREPTORSO1B,0
REPWALK2	.long	NJWALKLEG2A,NJWALKLEG2B,NJREPTORSO2A,NJREPTORSO2B,0
REPWALK3	.long	NJWALKLEG3A,NJREPTORSO3A,NJREPTORSO3B,0
REPWALK4	.long	NJWALKLEG4A,NJWALKLEG4B,NJREPTORSO4A,NJREPTORSO4B,0
REPWALK5	.long	NJWALKLEG5A,NJWALKLEG5B,NJREPTORSO5A,NJREPTORSO5B,0
REPWALK6	.long	NJWALKLEG6A,NJWALKLEG6B,NJREPTORSO6A,NJREPTORSO6B,0
REPWALK7	.long	NJWALKLEG7A,NJWALKLEG7B,NJREPTORSO7A,NJREPTORSO7B,0
REPWALK8	.long	NJWALKLEG8A,NJWALKLEG8B,NJREPTORSO8A,NJREPTORSO8B,0
REPWALK9	.long	NJWALKLEG9A,NJWALKLEG9B,NJREPTORSO9A,NJREPTORSO9B,0

;*********************************************************************

NJWALKLEG1
	.long	NJWALKLEG1A,NJWALKLEG1B,0
NJWALKLEG2
	.long	NJWALKLEG2A,NJWALKLEG2B,0
NJWALKLEG3
	.long	NJWALKLEG3A,0
NJWALKLEG4
	.long	NJWALKLEG4A,NJWALKLEG4B,0
NJWALKLEG5
	.long	NJWALKLEG5A,NJWALKLEG5B,0
NJWALKLEG6
	.long	NJWALKLEG6A,NJWALKLEG6B,0
NJWALKLEG7
	.long	NJWALKLEG7A,NJWALKLEG7B,0
NJWALKLEG8
	.long	NJWALKLEG8A,NJWALKLEG8B,0
NJWALKLEG9
	.long	NJWALKLEG9A,NJWALKLEG9B,0

;************************
dummy
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	0
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	0
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	NJ1STANCE3
	.long	0
;************************

a_njduck
	.long	NJDUCK1
	.long	NJDUCK2
	.long	NJDUCK3
	.long	0

NJDUCK1	.long	NJDUCK1A,NJDUCK1B,NJDUCK1C,0
NJDUCK2	.long	NJDUCK2A,NJDUCK2B,0
NJDUCK3	.long	NJDUCK3A,NJDUCK3B,0

;**********************************************************************

a_njjumpup
	.long	NJJUMP2
	.long	NJJUMP3
	.long	0
	.long	NJJUMP2
	.long	NJJUMP1
	.long	0

NJJUMP1	.long	NJJUMP1A,NJJUMP1B,NJJUMP1C,NJJUMP1D,0
NJJUMP2	.long	NJJUMP2A,NJJUMP2B,0
NJJUMP3	.long	NJJUMP3A,NJJUMP3B,NJJUMP3C,0

;**********************************************************************

a_njfflip
	.long	NJJUMPFLIP1
	.long	NJJUMPFLIP2
	.long	NJJUMPFLIP3
	.long	NJJUMPFLIP4
	.long	NJJUMPFLIP5
	.long	NJJUMPFLIP6
	.long	NJJUMPFLIP7
	.long	NJJUMPFLIP8
	.long	ani_jump,a_njfflip+32

a_njbflip
	.long	NJJUMPFLIP1
	.long	NJJUMPFLIP8
	.long	NJJUMPFLIP7
	.long	NJJUMPFLIP6
	.long	NJJUMPFLIP5
	.long	NJJUMPFLIP4
	.long	NJJUMPFLIP3
	.long	NJJUMPFLIP2
	.long	ani_jump,a_njbflip+32

NJJUMPFLIP1
	.long	NJJUMPFLIP1A,NJJUMPFLIP1B,NJJUMPFLIP1C,0
NJJUMPFLIP2
	.long	NJJUMPFLIP2A,0
NJJUMPFLIP3
	.long	NJJUMPFLIP3A,0
NJJUMPFLIP4
	.long	NJJUMPFLIP4A,NJJUMPFLIP4B,0
NJJUMPFLIP5
	.long	NJJUMPFLIP5A,NJJUMPFLIP5B,0
NJJUMPFLIP6
	.long	NJJUMPFLIP6A,NJJUMPFLIP6B,NJJUMPFLIP6C,0
NJJUMPFLIP7
	.long	NJJUMPFLIP7A,NJJUMPFLIP7B,NJJUMPFLIP7C,0
NJJUMPFLIP8
	.long	NJJUMPFLIP8A,0

;**********************************************************************

a_njturn
	.long	NJTURN1
	.long	NJTURN2
	.long	ani_flip

	.long	ani_adjustx
	.word	-6
	.long	NJTURN1
	.long	0

NJTURN1	.long	NJTURN1A,NJTURN1B,NJTURN1C,0
NJTURN2	.long	NJTURN2A,NJTURN2B,0

;**********************************************************************

a_njduckturn
	.long	NJDUCKTURN1
	.long	NJDUCKTURN2
	.long	ani_flip
	.long	NJDUCKTURN1
	.long	NJDUCK3
	.long	0

NJDUCKTURN1
	.long	NJDUCKTURN1A,NJDUCKTURN1B,NJDUCKTURN1C,0
NJDUCKTURN2
	.long	NJDUCKTURN2A,NJDUCKTURN2B,NJDUCKTURN2C,0

;**********************************************************************

a_njblockhi
       	.long	NJBLOCK1
       	.long	NJBLOCK2
       	.long	NJBLOCK3
	.long	0
       	.long	NJBLOCK2
       	.long	NJBLOCK1
	.long	0

NJBLOCK1	.long	NJBLOCK1A,NJBLOCK1B,NJBLOCK1C,0
NJBLOCK2	.long	NJBLOCK2A,NJBLOCK2B,NJBLOCK2C,0
NJBLOCK3	.long	NJBLOCK3A,NJBLOCK3B,0

;**********************************************************************

a_njduckblock
	.long	NJDUCKBLOCK1
	.long	NJDUCKBLOCK2
	.long	NJDUCKBLOCK3
	.long	0
	.long	NJDUCKBLOCK2
	.long	NJDUCKBLOCK1
	.long	NJDUCK3
	.long	0

NJDUCKBLOCK1
	.long	NJDUCKBLOCK1A,NJDUCKBLOCK1B,NJDUCKBLOCK1C,0
NJDUCKBLOCK2
	.long	NJDUCKBLOCK2A,NJDUCKBLOCK2B,NJDUCKBLOCK2C,NJDUCKBLOCK2D,0
NJDUCKBLOCK3
	.long	NJDUCKBLOCK3A,NJDUCKBLOCK3B,NJDUCKBLOCK3C,0

;**********************************************************************

a_njhikick
	.long	NJHIKICK1
	.long	NJHIKICK2
	.long	NJHIKICK3
	.long	NJHIKICK4
	.long	NJHIKICK5
	.long	NJHIKICK6
	.long	0
	.long	NJHIKICK5
	.long	NJHIKICK4
	.long	NJHIKICK3
	.long	NJHIKICK2
	.long	NJHIKICK1
	.long	0

NJHIKICK1
	.long	NJHIKICK1A,NJHIKICK1B,0
NJHIKICK2
	.long	NJHIKICK2A,NJHIKICK2B,0
NJHIKICK3
	.long	NJHIKICK3A,NJHIKICK3B,0
NJHIKICK4
	.long	NJHIKICK4A,NJHIKICK4B,0
NJHIKICK5
	.long	NJHIKICK5A,NJHIKICK5B,NJHIKICK5C,0
NJHIKICK6
	.long	NJHIKICK6A,NJHIKICK6B,NJHIKICK6C,0
NJLOKICK1
	.long	NJLOKICK1A,NJLOKICK1B,NJLOKICK1C,0

a_njlokick
	.long	NJHIKICK1
	.long	NJHIKICK2
	.long	NJHIKICK3
	.long	NJHIKICK4
	.long	NJHIKICK5
	.long	NJLOKICK1
	.long	0
	.long	NJHIKICK5
	.long	NJHIKICK4
	.long	NJHIKICK3
	.long	NJHIKICK2
	.long	NJHIKICK1
	.long	0

;**********************************************************************

a_njkdown
	.long	NJKNOCKDOWN1
	.long	NJKNOCKDOWN2
	.long	NJKNOCKDOWN3
	.long	NJKNOCKDOWN4
	.long	0
*
* part 2 = landing
*
	.long	NJKNOCKDOWN5
	.long	NJKNOCKDOWN6
	.long	NJKNOCKDOWN7
	.long	0
*
* part 3 = shake on ground
*
	.long	NJKNOCKDOWN6
	.long	NJKNOCKDOWN7
	.long	NJKNOCKDOWN6
	.long	NJKNOCKDOWN7
	.long	0

NJKNOCKDOWN1
	.long	NJKNOCKDOWN1A,NJKNOCKDOWN1B,NJKNOCKDOWN1C,0
NJKNOCKDOWN2
	.long	NJKNOCKDOWN2A,NJKNOCKDOWN2B,NJKNOCKDOWN2C,0
NJKNOCKDOWN3
	.long	NJKNOCKDOWN3A,NJKNOCKDOWN3B,0
NJKNOCKDOWN4
	.long	NJKNOCKDOWN4A,NJKNOCKDOWN4B,0
NJKNOCKDOWN5
	.long	NJKNOCKDOWN5A,NJKNOCKDOWN5B,0
NJKNOCKDOWN6
	.long	NJKNOCKDOWN6A,NJKNOCKDOWN6B,0
NJKNOCKDOWN7
	.long	NJKNOCKDOWN7A,NJKNOCKDOWN7B,0

;**********************************************************************

a_njhithi
	.long	NJHIHIT2
	.long	NJHIHIT3
	.long	NJHIHIT2
	.long	NJHIHIT1
	.long	0

NJHIHIT1	.long	NJHIHIT1A,NJHIHIT1B,NJHIHIT1C,0
NJHIHIT2	.long	NJHIHIT2A,NJHIHIT2B,0
NJHIHIT3	.long	NJHIHIT3A,NJHIHIT3B,NJHIHIT3C,0

;**********************************************************************

a_njhitlo
	.long	NJLOHIT2
	.long	NJLOHIT3
	.long	NJLOHIT2
	.long	NJLOHIT1
	.long	0

NJLOHIT1	.long	NJLOHIT1A,NJLOHIT1B,0
NJLOHIT2	.long	NJLOHIT2A,NJLOHIT2B,0
NJLOHIT3	.long	NJLOHIT3A,NJLOHIT3B,0

;**********************************************************************

a_njgetup
	.long	NJGETUP1
	.long	NJGETUP2
	.long	NJGETUP3
	.long	NJGETUP4
	.long	NJGETUP5
	.long	NJGETUP6
	.long	0

NJGETUP1	.long	NJGETUP1A,NJGETUP1B,0
NJGETUP2	.long	NJGETUP2A,0
NJGETUP3	.long	NJGETUP3A,NJGETUP3B,0
NJGETUP4	.long	NJGETUP4A,NJGETUP4B,0
NJGETUP5	.long	NJGETUP5A,NJGETUP5B,0
NJGETUP6	.long	NJGETUP6A,NJGETUP6B,0

;**********************************************************************

a_njhipunch
	.long	NJHIPUNCH1
nhp2	.long	NJHIPUNCH2
nhp3	.long	NJHIPUNCH3
	.long	0
	.long	NJHIPUNCH4
nhp5	.long	NJHIPUNCH5
	.long	NJHIPUNCH6
	.long	0
	.long	NJHIPUNCH5
	.long	NJHIPUNCH4
	.long	ani_jump,nhp3
	.long	0
*
* Unhipunch #1
*
	.long	NJHIPUNCH2
	.long	NJHIPUNCH1
	.long	0
*
* Unhipunch #2
*
	.long	NJHIPUNCH7
	.long	0
*
* Hi to Med #1
*
	.long	NJHIPUNCH4
	.long	NJLOPUNCH3
	.long	ani_jump,nlp4
	.long	0
*
* Hi to Med #2
*
	.long	NJHIPUNCH5
	.long	NJLOPUNCH1
	.long	ani_jump,nlp2
	.long	0

;***********************************************************************

a_njlopunch
	.long	NJHIPUNCH1
	.long	NJLOPUNCH1
nlp2	.long	NJLOPUNCH2
	.long	0

;**************
	.long	NJLOPUNCH1
;	.long	NJHIPUNCH4
;**************

	.long	NJLOPUNCH3
nlp4 	.long	NJLOPUNCH4
	.long	0

	.long	NJLOPUNCH3
	.long	NJLOPUNCH1
	.long	ani_jump,nlp2
	.long	0
*
* Unlopunch #1
*
	.long	NJLOPUNCH1
	.long	NJHIPUNCH1
	.long	0
*
* Unlopunch #2
*
	.long	NJLOPUNCH3
	.long	0
*
* Med to High #1
*
	.long	NJLOPUNCH1
	.long	ani_jump,nhp5		; lo1 - hi5 - hi6
	.long	0
*
* Med to High #2
*
	.long	NJLOPUNCH3
	.long	ani_jump,nhp2		; lo3 - hi2 - hi3
	.long	0

NJHIPUNCH1
	.long	NJHIPUNCH1A,NJHIPUNCH1B,0
NJHIPUNCH2
	.long	NJHIPUNCH2A,NJHIPUNCH2B,NJHIPUNCH2C,0
NJHIPUNCH3
	.long	NJHIPUNCH3A,NJHIPUNCH3B,NJHIPUNCH3C,0
NJHIPUNCH4
	.long	NJHIPUNCH4A,NJHIPUNCH4B,0
NJHIPUNCH5
	.long	NJHIPUNCH5A,NJHIPUNCH5B,NJHIPUNCH5C,0
NJHIPUNCH6
	.long	NJHIPUNCH6A,NJHIPUNCH6B,NJHIPUNCH6C,0
NJHIPUNCH7
	.long	NJHIPUNCH7A,NJHIPUNCH7B,NJHIPUNCH7C,0

NJLOPUNCH1
	.long	NJLOPUNCH1A,NJLOPUNCH1B,NJLOPUNCH1C,0
NJLOPUNCH2
	.long	NJLOPUNCH2A,NJLOPUNCH2B,0
NJLOPUNCH3
	.long	NJLOPUNCH3A,NJLOPUNCH3B,NJLOPUNCH3C,0
NJLOPUNCH4
	.long	NJLOPUNCH4A,NJLOPUNCH4B,0

;**********************************************************************

a_njsweep
	.long	NJSWEEPKICK1
	.long	NJSWEEPKICK2
	.long	NJSWEEPKICK3
	.long	ani_calla,sweep_sounds
	.long	NJSWEEPKICK4
	.long	NJSWEEPKICK5
	.long	0
	.long	NJSWEEPKICK6
	.long	NJSWEEPKICK7
	.long	0

NJSWEEPKICK1
	.long	NJSWEEPKICK1A,NJSWEEPKICK1B,NJSWEEPKICK1C,NJSWEEPKICK1D,0
NJSWEEPKICK2
	.long	NJSWEEPKICK2A,NJSWEEPKICK2B,0
NJSWEEPKICK3
	.long	NJSWEEPKICK3A,NJSWEEPKICK3B,0
NJSWEEPKICK4
	.long	NJSWEEPKICK4A,NJSWEEPKICK4B,NJSWEEPKICK4C,0
NJSWEEPKICK5
	.long	NJSWEEPKICK5A,NJSWEEPKICK5B,NJSWEEPKICK5C,0
NJSWEEPKICK6
	.long	NJSWEEPKICK6A,NJSWEEPKICK6B,0
NJSWEEPKICK7
	.long	NJSWEEPKICK7A,NJSWEEPKICK7B,NJSWEEPKICK7C,0

;**********************************************************************

a_njsweepfall
	.long	NJSWEEPFALL1
	.long	NJSWEEPFALL2
	.long	NJSWEEPFALL3
	.long	NJSWEEPFALL4
	.long	NJSWEEPFALL5
	.long	NJSWEEPFALL6
	.long	0
	.long	NJSWEEPFALL5
	.long	NJSWEEPFALL6
	.long	0

NJSWEEPFALL1
	.long	NJSWEEPFALL1A,NJSWEEPFALL1B,NJSWEEPFALL1C,NJSWEEPFALL1D,0
NJSWEEPFALL2
	.long	NJSWEEPFALL2A,NJSWEEPFALL2B,NJSWEEPFALL2C,0
NJSWEEPFALL3
	.long	NJSWEEPFALL3A,NJSWEEPFALL3B,NJSWEEPFALL3C,NJSWEEPFALL3D,0
NJSWEEPFALL4
	.long	NJSWEEPFALL4A,NJSWEEPFALL4B,NJSWEEPFALL4C,NJSWEEPFALL4D,0
NJSWEEPFALL5
	.long	NJSWEEPFALL5A,NJSWEEPFALL5B,NJSWEEPFALL5C,0
NJSWEEPFALL6
	.long	NJSWEEPFALL6A,NJSWEEPFALL6B,0

;**********************************************************************

a_njsweepup
	.long	NJSWEEPUP1
	.long	NJSWEEPUP2
	.long	NJSWEEPUP3
	.long	NJSWEEPUP4
	.long	NJSWEEPUP5
	.long	0

NJSWEEPUP1
	.long	NJSWEEPUP1A,NJSWEEPUP1B,0
NJSWEEPUP2
	.long	NJSWEEPUP2A,NJSWEEPUP2B,0
NJSWEEPUP3
	.long	NJSWEEPUP3A,NJSWEEPUP3B,0
NJSWEEPUP4
	.long	NJSWEEPUP4A,NJSWEEPUP4B,NJSWEEPUP4C,NJSWEEPUP4D,0
NJSWEEPUP5
	.long	NJSWEEPUP5A,NJSWEEPUP5B,0

;**********************************************************************

a_njduckpunch
	.long	NJDUCKPUNCH1
	.long	NJDUCKPUNCH2
	.long	NJDUCKPUNCH3
	.long	0
	.long	NJDUCKPUNCH2
	.long	NJDUCKPUNCH1
	.long	NJDUCK3
	.long	0

NJDUCKPUNCH1
	.long	NJDUCKPUNCH1A,NJDUCKPUNCH1B,0
NJDUCKPUNCH2
	.long	NJDUCKPUNCH2A,NJDUCKPUNCH2B,NJDUCKPUNCH2C,NJDUCKPUNCH2D,0
NJDUCKPUNCH3
	.long	NJDUCKPUNCH3A,NJDUCKPUNCH3B,NJDUCKPUNCH3C,NJDUCKPUNCH3D,0

;**********************************************************************

a_njduckkickh
	.long	NJDUCKICKLO1
	.long	ani_calla,kick_sounds
	.long	NJDUCKICKLO2
	.long	NJDUCKICKHI1
	.long	NJDUCKICKHI2
	.long	0
	.long	NJDUCKICKHI1
	.long	NJDUCKICKLO2
	.long	NJDUCKICKLO1
	.long	NJDUCK3
	.long	0

a_njduckkickl
	.long	NJDUCKICKLO1
	.long	ani_calla,kick_sounds
	.long	NJDUCKICKLO2
	.long	NJDUCKICKLO3
	.long	NJDUCKICKLO4
	.long	NJDUCKICKLO5
	.long	0
	.long	NJDUCKICKLO4
	.long	NJDUCKICKLO3
	.long	NJDUCKICKLO2
	.long	NJDUCKICKLO1
	.long	NJDUCK3
	.long	0

NJDUCKICKLO1
	.long	NJDUCKICKLO1A,NJDUCKICKLO1B,0
NJDUCKICKLO2
	.long	NJDUCKICKLO2A,NJDUCKICKLO2B,0
NJDUCKICKLO3
	.long	NJDUCKICKLO3A,NJDUCKICKLO3B,NJDUCKICKLO3C,NJDUCKICKLO3D,0
NJDUCKICKLO4
	.long	NJDUCKICKLO4A,NJDUCKICKLO4B,NJDUCKICKLO4C,NJDUCKICKLO4D,0
NJDUCKICKLO5
	.long	NJDUCKICKLO5A,NJDUCKICKLO5B,NJDUCKICKLO5C,NJDUCKICKLO5D,0

NJDUCKICKHI1
	.long	NJDUCKICKHI1A,NJDUCKICKHI1B,NJDUCKICKHI1C,0
NJDUCKICKHI2
	.long	NJDUCKICKHI2A,NJDUCKICKHI2B,0

;**********************************************************************

a_njduckhit
	.long	NJDUCKHIT2
	.long	NJDUCKHIT3
	.long	NJDUCKHIT2
	.long	NJDUCKHIT1
	.long	NJDUCK3
	.long	0

NJDUCKHIT1
	.long	NJDUCKHIT1A,NJDUCKHIT1B,NJDUCKHIT1C,0
NJDUCKHIT2
	.long	NJDUCKHIT2A,NJDUCKHIT2B,NJDUCKHIT2C,0
NJDUCKHIT3
	.long	NJDUCKHIT3A,NJDUCKHIT3B,NJDUCKHIT3C,0

;**********************************************************************

a_njuppercut
	.long	NJUPPERCUT2
	.long	NJUPPERCUT3
	.long	NJUPPERCUT4
	.long	NJUPPERCUT5
	.long	ani_nosleep	; dont sleep after next frame
	.long	NJUPPERCUT6
	.long	0
	.long	NJHIPUNCH2
	.long	NJHIPUNCH1
	.long	0

NJUPPERCUT2
	.long	NJUPPERCUT2A,NJUPPERCUT2B,NJUPPERCUT2C,0
NJUPPERCUT3
	.long	NJUPPERCUT3A,NJUPPERCUT3B,0
NJUPPERCUT4
	.long	NJUPPERCUT4A,NJUPPERCUT4B,NJUPPERCUT4C,0
NJUPPERCUT5
	.long	NJUPPERCUT5A,NJUPPERCUT5B,NJUPPERCUT5C,NJUPPERCUT5D,0
NJUPPERCUT6
	.long	NJUPPERCUT6A,NJUPPERCUT6B,NJUPPERCUT6C,0

;**********************************************************************

a_njjumpupkick
	.long	NJJUMPKICK1
	.long	NJJUMPKICK2
	.long	0
	.long	NJJUMPKICK1
	.long	0

NJJUMPKICK1
	.long	NJJUMPKICK1A,NJJUMPKICK1B,0
NJJUMPKICK2
	.long	NJJUMPKICK2A,NJJUMPKICK2B,NJJUMPKICK2C,0

;**********************************************************************

a_njflipkick
	.long	NJFLIPKICK1
	.long	NJFLIPKICK2
	.long	NJFLIPKICK3
	.long	0
	.long	NJFLIPKICK2
	.long	NJFLIPKICK1
	.long	0

NJFLIPKICK1
	.long	NJFLIPKICK1A,NJFLIPKICK1B,0
NJFLIPKICK2
	.long	NJFLIPKICK2A,NJFLIPKICK2B,0
NJFLIPKICK3
	.long	NJFLIPKICK3A,NJFLIPKICK3B,NJFLIPKICK3C,0

;**********************************************************************

a_njflippunch
	.long	NJFLIPUNCH1
	.long	NJFLIPUNCH2
	.long	NJFLIPUNCH3
	.long	0
	.long	NJFLIPUNCH2
	.long	NJFLIPUNCH1
	.long	0

NJFLIPUNCH1
	.long	NJFLIPUNCH1A,NJFLIPUNCH1B,0
NJFLIPUNCH2
	.long	NJFLIPUNCH2A,NJFLIPUNCH2B,0
NJFLIPUNCH3
	.long	NJFLIPUNCH3A,NJFLIPUNCH3B,NJFLIPUNCH3C,0

;**********************************************************************

a_njroundh
	.long	NJROUNDKIK1
	.long	NJROUNDKIK2
	.long	NJROUNDKIK3
	.long	NJROUNDKIK4
	.long	ani_nosleep
	.long	NJROUNDKIK5
	.long	0
	.long	NJROUNDKIK6
	.long	NJROUNDKIK7
	.long	NJROUNDKIK8
	.long	0

NJROUNDKIK1
	.long	NJROUNDKIK1A,NJROUNDKIK1B,NJROUNDKIK1C,0
NJROUNDKIK2
	.long	NJROUNDKIK2A,NJROUNDKIK2B,0
NJROUNDKIK3
	.long	NJROUNDKIK3A,NJROUNDKIK3B,0
NJROUNDKIK4
	.long	NJROUNDKIK4A,NJROUNDKIK4B,NJROUNDKIK4C,0
NJROUNDKIK5
	.long	NJROUNDKIK5A,NJROUNDKIK5B,NJROUNDKIK5C,0
NJROUNDKIK6
	.long	NJROUNDKIK6A,NJROUNDKIK6B,0
NJROUNDKIK7
	.long	NJROUNDKIK7A,0
NJROUNDKIK8
	.long	NJROUNDKIK8A,NJROUNDKIK8B,0

;**********************************************************************

a_njknee
	.long	NJKNEE1
	.long	NJKNEE2
	.long	NJKNEE3
	.long	0
	.long	NJKNEE2
	.long	NJKNEE1
	.long	0

; left over unused frames

NJKNEE1	.long	NJKNEE1A,NJKNEE1B,0
NJKNEE2	.long	NJKNEE2A,NJKNEE2B,0
NJKNEE3	.long	NJKNEE3A,NJKNEE3B,0
NJKNEE4	.long	NJKNEE4A,NJKNEE4B,NJKNEE4C,0
NJKNEE5	.long	NJKNEE5A,0
NJKNEE6	.long	NJKNEE6A,NJKNEE6B,NJKNEE6C,0

;**********************************************************************

a_njelbow
	.long	NJELBO1
	.long	NJELBO2
	.long	NJELBO3
	.long	0
	.long	NJELBO4
	.long	0

NJELBO1	.long	NJELBO1A,NJELBO1B,0
NJELBO2	.long	NJELBO2A,NJELBO2B,0
NJELBO3	.long	NJELBO3A,NJELBO3B,NJELBO3C,0
NJELBO4	.long	NJELBO4A,NJELBO4B,0

;**********************************************************************

a_njstumble
	.long	NJSTUMBLE1
	.long	NJSTUMBLE2
	.long	NJSTUMBLE3
	.long	NJSTUMBLE4
	.long	NJSTUMBLE5
	.long	NJSTUMBLE6
	.long	0

NJSTUMBLE1
	.long	NJSTUMBLE1A,NJSTUMBLE1B,0
NJSTUMBLE2
	.long	NJSTUMBLE2A,NJSTUMBLE2B,NJSTUMBLE2C,0
NJSTUMBLE3
	.long	NJSTUMBLE3A,NJSTUMBLE3B,0
NJSTUMBLE4
	.long	NJSTUMBLE4A,NJSTUMBLE4B,NJSTUMBLE4C,0
NJSTUMBLE5
	.long	NJSTUMBLE5A,NJSTUMBLE5B,0
NJSTUMBLE6
	.long	NJSTUMBLE6A,NJSTUMBLE6B,NJSTUMBLE6C,0

;**********************************************************************

a_njbodyslam
	.long	NJFLIP1
	.long	0
	.long	NJFLIP2
	.long	NJFLIP3
	.long	NJFLIP4
	.long	NJFLIP5
	.long	NJFLIP6
	.long	0
	.long	ani_jump,a_njgetup

NJFLIP1	.long	NJFLIP1A,NJFLIP1B,0
NJFLIP2	.long	NJFLIP2A,0
NJFLIP3	.long	NJFLIP3A,NJFLIP3B,NJFLIP3C,NJFLIP3D,0
NJFLIP4	.long	NJFLIP4A,NJFLIP4B,NJFLIP4C,0
NJFLIP5	.long	NJFLIP5A,NJFLIP5B,NJFLIP5C,0
NJFLIP6	.long	NJFLIP6A,NJFLIP6B,0

;**********************************************************************

a_shredded
	.long	ani_adjustxy
	.word	6,6
	.long	NJSTUMBLE1

	.long	ani_adjustxy
	.word	-6,-6
	.long	NJSTUMBLE2

	.long	ani_adjustxy
	.word	6,6
	.long	NJSTUMBLE3

	.long	ani_adjustxy
	.word	-6,-6
	.long	NJSTUMBLE2
	.long	ani_jump,a_shredded

;**********************************************************************

a_throw_spear
	.long	NJSCORPTHRO1
	.long	NJSCORPTHRO2
	.long	NJSCORPTHRO3
	.long	NJSCORPTHRO4
	.long	0
	.long	NJSCORPTHRO5
	.long	NJSCORPTHRO6
	.long	NJSCORPTHRO7
	.long	0

a_rope_ani
	.long	ROPE1
	.long	ROPE2
	.long	ani_jump,a_rope_ani
	.long	0
*
* rope part 2 = tight part
*
	.long	ROPEHIT
	.long	0

	.long	WIGGLE1
	.long	WIGGLE2
	.long	WIGGLE3
	.long	0

ROPE1	.long	BIGRP1,0
ROPE2	.long	BIGRP2,0

WIGGLE1	.long	ROPEPULL1,0
WIGGLE2	.long	ROPEPULL2,0
WIGGLE3	.long	ROPEPULL3,0
ROPEHIT	.long	SPEARHIT,a0

NJSCORPTHRO1
	.long	NJSCORPTHRO1A,NJSCORPTHRO1B,NJSCORPTHRO1C,NJSCORPTHRO1D,0
NJSCORPTHRO2
	.long	NJSCORPTHRO2A,NJSCORPTHRO2B,NJSCORPTHRO2C,0
NJSCORPTHRO3
	.long	NJSCORPTHRO3A,NJSCORPTHRO3B,NJSCORPTHRO3C,0
NJSCORPTHRO4
	.long	NJSCORPTHRO4A,NJSCORPTHRO4B,0
NJSCORPTHRO5
	.long	NJSCORPTHRO5A,NJSCORPTHRO5B,0
NJSCORPTHRO6
	.long	NJSCORPTHRO6A,NJSCORPTHRO6B,NJSCORPTHRO6C,0
NJSCORPTHRO7
	.long	NJSCORPTHRO7A,NJSCORPTHRO7B,0

;**********************************************************************

a_njzap
	.long	NJTHROWICE1
	.long	NJTHROWICE2
	.long	NJTHROWICE3
	.long	NJTHROWICE4
	.long	0

NJTHROWICE1
	.long	NJTHROWICE1A,NJTHROWICE1B,0
NJTHROWICE2
	.long	NJTHROWICE2A,NJTHROWICE2B,NJTHROWICE2C,0
NJTHROWICE3
	.long	NJTHROWICE3A,NJTHROWICE3B,NJTHROWICE3C,0
NJTHROWICE4
	.long	NJTHROWICE4A,NJTHROWICE4B,NJTHROWICE4C,NJTHROWICE4D,0

a_ice_ball
	.long	ICE1
	.long	ICE2
	.long	ICE3
	.long	0

	.long	ICE4
	.long	ICE5		; last stationary frame
	.long	ICE6
	.long	ICE7
	.long	0

	.long	ICE9		; first hit frame
	.long	ICE10
	.long	ICE11
	.long	ICE12
	.long	ICE13
	.long	0

ICE1	.long	NJICEBALLS1,0
ICE2	.long	NJICEBALLS2,0
ICE3	.long	NJICEBALLS3,0
ICE4	.long	NJICEBALLS4,0
ICE5	.long	NJICEBALLS5,0
ICE6	.long	NJICEBALLS6,0
ICE7	.long	NJICEBALLS7,0
ICE9	.long	NJICEBALLS9,0
ICE10	.long	NJICEBALLS10,0
ICE11	.long	NJICEBALLS11,0
ICE12	.long	NJICEBALLS12,0
ICE13	.long	NJICEBALLS13,0


a_floor_ice
	.long	FLRICE1
	.long	FLRICE2
	.long	FLRICE3
	.long	FLRICE4
	.long	FLRICE5
	.long	FLRICE6
	.long	0

	.long	FLRICE7
	.long	0

	.long	FLRICE8
	.long	FLRICE9
	.long	FLRICE10
	.long	FLRICE11
	.long	FLRICE12
	.long	FLRICE13
	.long	0

FLRICE1	.long	NJFLOORICE1,0
FLRICE2	.long	NJFLOORICE2,0
FLRICE3	.long	NJFLOORICE3,0
FLRICE4	.long	NJFLOORICE4,0
FLRICE5	.long	NJFLOORICE5,0
FLRICE6	.long	NJFLOORICE6,0
FLRICE7	.long	NJFLOORICE7,0

FLRICE8	.long	NJFLOORICE8,0
FLRICE9	.long	NJFLOORICE9,0
FLRICE10 .long	NJFLOORICE10,0
FLRICE11	.long	NJFLOORICE11,0
FLRICE12	.long	NJFLOORICE12,0
FLRICE13	.long	NJFLOORICE13,0


;**********************************************************************

a_ice_down
	.long	NJTHROWLOW1
	.long	NJTHROWLOW2
	.long	NJTHROWLOW3
	.long	0

NJTHROWLOW1
	.long	NJTHROWLOW1A,NJTHROWLOW1B,NJTHROWLOW1C,0
NJTHROWLOW2
	.long	NJTHROWLOW2A,NJTHROWLOW2B,NJTHROWLOW2C,0
NJTHROWLOW3
	.long	NJTHROWLOW3A,NJTHROWLOW3B,0

;**********************************************************************

a_njprojani

;**********************************************************************

a_njstunned
	.long	NJSTUNNED1
	.long	NJSTUNNED2
	.long	NJSTUNNED3
	.long	NJSTUNNED4
	.long	NJSTUNNED5
	.long	NJSTUNNED6
	.long	NJSTUNNED7
	.long	ani_jump,a_njstunned

NJSTUNNED1
	.long	NJSTUNNED1A,NJSTUNNED1B,0
NJSTUNNED2
	.long	NJSTUNNED2A,NJSTUNNED2B,0
NJSTUNNED3
	.long	NJSTUNNED3A,NJSTUNNED3B,NJSTUNNED3C,0
NJSTUNNED4
	.long	NJSTUNNED4A,NJSTUNNED4B,0
NJSTUNNED5
	.long	NJSTUNNED5A,NJSTUNNED5B,0
NJSTUNNED6
	.long	NJSTUNNED6A,NJSTUNNED6B,0
NJSTUNNED7
	.long	NJSTUNNED7A,NJSTUNNED7B,0

;**********************************************************************

a_njvictory
	.long	ani_ochar_jump
	.word	ft_scorpion		; am I scorpion
	.long	a_scorpion_vic

	.long	ani_ochar_jump
	.word	ft_reptile
	.long	a_retile_vic

	.long	NJSUBVIC1
	.long	NJSUBVIC2
	.long	NJSUBVIC3
	.long	0

a_scorpion_vic
	.long	NJSCORPVIC1
	.long	NJSCORPVIC2
	.long	NJSCORPVIC3
	.long	0

a_retile_vic
	.long	NJREPVIC1
	.long	NJREPVIC2
	.long	NJREPVIC3
	.long	NJREPVIC4
	.long	0

NJSUBVIC1
	.long	NJSUBVIC1A,NJSUBVIC1B,NJSUBVIC1C,0
NJSUBVIC2
	.long	NJSUBVIC2A,NJSUBVIC2B,NJSUBVIC2C,NJSUBVIC2D
	.long	NJSUBVIC2E,0
NJSUBVIC3
	.long	NJSUBVIC3A,NJSUBVIC3B,NJSUBVIC3C,0

NJREPVIC1
	.long	NJREPVIC1A,NJREPVIC1B,0
NJREPVIC2
	.long	NJREPVIC2A,NJREPVIC2B,0
NJREPVIC3
	.long	NJREPVIC3A,NJREPVIC3B,NJREPVIC3C,NJREPVIC3D,NJREPVIC3E,NJREPVIC3F,0
NJREPVIC4
	.long	NJREPVIC4A,NJREPVIC4B,0

NJSCORPVIC1
	.long	NJSCORPVIC1A,NJSCORPVIC1B,NJSCORPVIC1C,NJSCORPVIC1D,0
NJSCORPVIC2
	.long	NJSCORPVIC2A,NJSCORPVIC2B,NJSCORPVIC2C,NJSCORPVIC2D,0
NJSCORPVIC3
	.long	NJSCORPVIC3A,NJSCORPVIC3B,0

;**********************************************************************

a_nj_fb_sa
	.long	ani_adjustxy
	.word	->40,>00
	.long	NJSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>12,->28
	.long	NJFLIPPED1

	.long	ani_adjustxy
	.word	>23,->10
	.long	NJFLIPPED2

	.long	ani_adjustxy
	.word	>3f,->20
	.long	NJFLIPPED3
	.long	0



a_nj_fb_fn
	.long	ani_adjustxy
	.word	->40,->10
	.long	ani_flip
	.long	NJKNOCKDOWN1
	.long	0

	.long	ani_adjustxy
	.word	->20,->20
	.long	NJKNOCKDOWN1

	.long	ani_adjustxy
	.word	->40,->1a
	.long	NJKNOCKDOWN3

	.long	ani_adjustxy
	.word	->20,>20
	.long	NJKNOCKDOWN3

	.long	ani_adjustxy
	.word	->08,>30
	.long	NJFLIPPED4

	.long	ani_adjustxy
	.word	>00,>20
	.long	NJFLIPPED4
	.long	0
*
* bounce on ground
*
	.long	NJFLIPPED4
	.long	0


a_nj_fb_hh
	.long	ani_adjustxy
	.word	->3a,>00		; we need even # of words here !
	.long	NJSTUMBLE3
	.long	0

	.long	ani_flip
	.long	ani_adjustxy
	.word	>25,->05
	.long	NJSTUMBLE3
	.long	0

	.long	ani_adjustxy
	.word	>70,->40

	.long	NJFLIPPED3
	.long	NJFLIPPED3
	.long	NJFLIPPED4
	.long	0

a_nj_fb_lk
	.long	ani_adjustxy
	.word	->40,>00
	.long	NJFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>20,>10
	.long	NJFLIPPED1

	.long	ani_adjustxy
	.word	>20,>00
	.long	NJFLIPPED2

	.long	ani_adjustxy
	.word	>28,->08
	.long	NJFLIPPED3

	.long	ani_adjustxy
	.word	>40,->28
	.long	NJFLIPPED4

	.long	ani_adjustxy
	.word	>10,->08
	.long	NJFLIPPED4
	.long	0
*
* land on the ground
*
	.long	NJKNOCKDOWN6
	.long	NJKNOCKDOWN7
	.long	NJKNOCKDOWN6
	.long	NJKNOCKDOWN7
     	.long	0

;********************************************************************

a_nj_fb_nj
	.long	ani_adjustxy
	.word	->40,>00
	.long	NJFLIPPED1
	.long	0

	.long	ani_adjustxy
	.word	>04,>00
	.long	NJFLIPPED1

	.long	ani_adjustxy
	.word	>20,>10
	.long	NJFLIPPED2

	.long	ani_adjustxy
	.word	>38,->20
	.long	NJFLIPPED3

	.long	ani_adjustxy
	.word	>40,->28
	.long	NJFLIPPED4

	.long	ani_adjustxy
	.word	>10,->08
	.long	NJFLIPPED4
	.long	0
*
* land on the ground
*
	.long	NJKNOCKDOWN6
	.long	NJKNOCKDOWN7
	.long	NJKNOCKDOWN6
	.long	NJKNOCKDOWN7
     	.long	0

;***********************************************************************

a_nj_fb_jx
	.long	ani_adjustxy
	.word	->50,>00
	.long	NJSTUMBLE1
	.long	NJSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>10,->38
	.long	NJFLIPPED1	; jax 3

	.long	ani_adjustxy
	.word	>2a,->08
	.long	NJFLIPPED2	; jax 4

	.long	ani_adjustxy
	.word	>38,>00
	.long	NJFLIPPED3	; jax 5

	.long	ani_adjustxy
	.word	>30,>30
	.long	NJFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	->05,>1d
	.long	NJKNOCKDOWN7	; jax 7
	.long	0
*
* slammed again !
*
	.long	ani_adjustxy
	.word	>00,->20
	.long	NJFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	->1a,->46
	.long	NJFLIPPED4	; jax 6

	.long	ani_flip
	.long	ani_adjustxy
	.word	>42,->10
	.long	NJFLIPPED3	; jax 4

	.long	ani_adjustxy
	.word	>3c,>10
	.long	NJFLIPPED4	; jax 3

	.long	ani_adjustxy
	.word	>00,>46
	.long	NJFLIPPED4

	.long	ani_adjustxy
	.word	->10,>20
	.long	NJKNOCKDOWN7	; jax 7
	.long	0

;***********************************************************************

a_nj_fb_jc
	.long	ani_adjustxy
	.word	->38,>08
	.long	NJSTUMBLE1
	.long	NJSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>10,->30
	.long	NJFLIPPED2

	.long	ani_adjustxy
	.word	>68,>10
	.long	NJFLIPPED4

	.long	ani_adjustxy
	.word	>18,>40
	.long	NJFLIPPED4
	.long	0


a_nj_fb_st
	.long	ani_adjustxy
	.word	->30,>00
	.long	NJSTUMBLE5
	.long	NJSTUMBLE5
	.long	0

	.long	ani_adjustxy
	.word	>00,->20
	.long	NJFLIPPED1
	.long	ani_adjustxy
	.word	>30,->10
	.long	NJFLIPPED2
	.long	ani_adjustxy
	.word	>40,>10
	.long	NJFLIPPED4
	.long	ani_adjustxy
	.word	>10,>28
	.long	NJFLIPPED4
	.long	0

	.long	ani_adjustxy
	.word	>20,>00
	.long	NJKNOCKDOWN6
	.long	0


a_nj_fb_rd
	.long	ani_adjustxy
	.word	->4a,>00
	.long	NJSTUMBLE5
	.long	0

	.long	ani_adjustxy
	.word	>0a,->25
	.long	NJFLIPPED1

	.long	ani_adjustxy
	.word	>34,->20
	.long	NJFLIPPED2
	.long	NJFLIPPED2

	.long	ani_adjustxy
	.word	>0a,>A0
	.long	ani_flip_v
	.long	NJFLIPPED2

	.long	ani_adjustxy
	.word	>38,>40
	.long	NJFLIPPED2
	.long	0

	.long	ani_adjustxy
	.word	>18,>10
	.long	ani_flip
	.long	NJKNOCKDOWN7
	.long	0

a_banged
	.long	NJFLIPPED1
	.long	NJFLIPPED2
	.long	NJFLIPPED3
	.long	NJFLIPPED4
	.long	0

NJFLIPPED1
	.long	NJFLIPPED1A,0
NJFLIPPED2
	.long	NJFLIPPED2A,NJFLIPPED2B,0
NJFLIPPED3
	.long	NJFLIPPED3A,NJFLIPPED3B,0
NJFLIPPED4
	.long	NJFLIPPED4A,NJFLIPPED4B,NJFLIPPED4C,0

;**********************************************************************

a_nutcrunched
	.long	NJNUTCRUNCH1
	.long	NJNUTCRUNCH2
	.long	0
	.long	NJNUTCRUNCH1
	.long	0

NJNUTCRUNCH1
	.long	NJNUTCRUNCH1A,NJNUTCRUNCH1B,0
NJNUTCRUNCH2
	.long	NJNUTCRUNCH2A,NJNUTCRUNCH2B,0

;**********************************************************************

a_bike_kicked
	.long	NJSTUMBLE1
	.long	NJSTUMBLE2
	.long	NJSTUMBLE3
	.long	NJSTUMBLE4
	.long	NJSTUMBLE5
	.long	NJSTUMBLE6
	.long	ani_jump,a_bike_kicked

;**********************************************************************

a_drained
	.long	ani_adjustxy
	.word	->48,->13
	.long	NJSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	->0a,>1a
	.long	NJDRAIN0
	.long	ani_adjustxy
	.word	>13,->08
	.long	NJDRAIN0
	.long	ani_adjustxy
	.word	>08,->14
	.long	NJDRAIN0
	.long	ani_adjustxy
	.word	0,0
	.long	NJDRAIN0
	.long	0

;***********************************************************************

a_slide
	.long	NJSLIDE1
	.long	NJSLIDE2
	.long	NJSLIDE3
	.long	0

NJSLIDE1	.long	NJSLIDE1A,NJSLIDE1B,0
NJSLIDE2	.long	NJSLIDE2A,NJSLIDE2B,NJSLIDE2C,0
NJSLIDE3	.long	NJSLIDE3A,NJSLIDE3B,NJSLIDE3C,0

;***********************************************************************

a_slow_proj
	.long	NJREPTHROW1
	.long	NJREPTHROW2
	.long	0

	.long	NJREPTHROW2
	.long	NJREPTHROW3
	.long	NJREPTHROW4
	.long	NJREPTHROW5
	.long	NJREPTHROW5
	.long	NJREPTHROW5
	.long	NJREPTHROW5
	.long	NJREPTHROW5
	.long	0

	.long	BLOB1
	.long	BLOB2
	.long	BLOB3
	.long	BLOB4
	.long	BLOB5
	.long	BLOB6
	.long	BLOB7
	.long	ani_adjustxy
	.word	>43,>2d

	.long	BLOB8
	.long	0			; needed


j_blob	.long	BLOB8
	.long	BLOB9
	.long	ani_jump,j_blob


BLOB1	.long	NJGLOBALL1,0
BLOB2	.long	NJGLOBALL2,0
BLOB3	.long	NJGLOBALL3,0
BLOB4	.long	NJGLOBALL4,0
BLOB5	.long	NJGLOBALL5,0
BLOB6	.long	NJGLOBALL6,0
BLOB7	.long	NJGLOBALL7,0
BLOB8	.long	NJGLOBALL8,0
BLOB9	.long	NJGLOBALL9,0


NJREPTHROW1
	.long	NJREPTHROW1A,NJREPTHROW1B,NJREPTHROW1C,NJREPTHROW1D,0
NJREPTHROW2
	.long	NJREPTHROW2A,NJREPTHROW2B,NJREPTHROW2C,0
NJREPTHROW3
	.long	NJREPTHROW3A,NJREPTHROW3B,NJREPTHROW3C,NJREPTHROW3D,0
NJREPTHROW4
	.long	NJREPTHROW4A,NJREPTHROW4B,NJREPTHROW4C,0
NJREPTHROW5
	.long	NJREPTHROW5A,NJREPTHROW5B,0

;***********************************************************************

a_inviso
	.long	NJINVISO1
	.long	NJINVISO2
	.long	0

NJINVISO1
	.long	NJINVISO1A,NJINVISO1B,NJINVISO1C,0
NJINVISO2
	.long	NJINVISO2A,NJINVISO2B,NJINVISO2C,0

;***********************************************************************

NJAIRICE1
	.long	NJAIRICE1A,NJAIRICE1B,NJAIRICE1C,0
NJAIRICE2
	.long	NJAIRICE2A,NJAIRICE2B,NJAIRICE2C,0

;***********************************************************************

a_ring_bang
	.long	BANG1
	.long	BANG2
	.long	BANG3
	.long	BANG4
	.long	BANG5
	.long	BANG6
	.long	BANG7 
	.long	BANG8
	.long	BANG9
	.long	BANG10
	.long	BANG11
	.long	BANG12
	.long	BANG13
	.long	0

BANG1
	.long	NJGLORING1A,NJGLORING1B
	.long	NJGLORING2A,NJGLORING2B
	.long	0

BANG2
	.long	NJGLORING2A,NJGLORING2B
	.long	NJGLORING3A,NJGLORING3B
	.long	0

BANG8
	.long	NJGLORING8A,NJGLORING8B

BANG3
	.long	NJGLORING3A,NJGLORING3B
	.long	NJGLORING4A,NJGLORING4B
	.long	0

BANG9
BANG4
	.long	NJGLORING4A,NJGLORING4B
	.long	NJGLORING5A,NJGLORING5B
	.long	0

BANG10
BANG5
	.long	NJGLORING5A,NJGLORING5B
	.long	NJGLORING6A,NJGLORING6B
	.long	0

BANG6
	.long	NJGLORING1A,NJGLORING1B
	.long	NJGLORING2A,NJGLORING2B

BANG11
	.long	NJGLORING6A,NJGLORING6B
	.long	NJGLORING7A,NJGLORING7B

	.long	0

BANG7
	.long	NJGLORING2A,NJGLORING2B
	.long	NJGLORING3A,NJGLORING3B

BANG12
	.long	NJGLORING7A,NJGLORING7B

BANG13
	.long	NJGLORING8A,NJGLORING8B
	.long	0


	.long	NJGLORING2A,NJGLORING2B
	.long	NJGLORING3A,NJGLORING3B
	.long	NJGLORING4A,NJGLORING4B
	.long	NJGLORING5A,NJGLORING5B
	.long	NJGLORING6A,NJGLORING6B
	.long	NJGLORING7A,NJGLORING7B
	.long	NJGLORING8A,NJGLORING8B

NJGLORING1
	.long	NJGLORING1A,NJGLORING1B,0
NJGLORING2
	.long	NJGLORING2A,NJGLORING2B,0
NJGLORING3
	.long	NJGLORING3A,NJGLORING3B,0
NJGLORING4
	.long	NJGLORING4A,NJGLORING4B,0
NJGLORING5
	.long	NJGLORING5A,NJGLORING5B,0
NJGLORING6
	.long	NJGLORING6A,NJGLORING6B,0
NJGLORING7
	.long	NJGLORING7A,NJGLORING7B,0
NJGLORING8
	.long	NJGLORING8A,NJGLORING8B,0

;***********************************************************************

a_sc_swipe
	.long	NJSCORPSWIPE1	;1
	.long	NJSCORPSWIPE2
	.long	NJSCORPSWIPE3
	.long	NJSCORPSWIPE4
	.long	0

	.long	NJSCORPSWIPE5	;2
	.long	0

	.long	NJSCORPSWIPE7	;3
	.long	NJSCORPSWIPE8
	.long	0

	.long	NJSCORPSWIPE9	;4
	.long	0

	.long	NJSCORPSWIPE6	;5
	.long	0


a_death_spear
	.long	DSPEAR1
	.long	DSPEAR2
	.long	DSPEAR3
	.long	DSPEAR4
	.long	0

	.long	DSPEAR5
	.long	0

	.long	DSPEAR6
	.long	DSPEAR7
	.long	0

	.long	DSPEAR8
	.long	0




NJSCORPSWIPE1
	.long	NJSCORPSWIPE1A,NJSCORPSWIPE1B,0
NJSCORPSWIPE2
	.long	NJSCORPSWIPE2A,NJSCORPSWIPE2B,0
NJSCORPSWIPE3
	.long	NJSCORPSWIPE3A,NJSCORPSWIPE3B,NJSCORPSWIPE3C,0
NJSCORPSWIPE4
	.long	NJSCORPSWIPE4A,NJSCORPSWIPE4B,NJSCORPSWIPE4C,0
NJSCORPSWIPE5
	.long	NJSCORPSWIPE5A,NJSCORPSWIPE5B,0
NJSCORPSWIPE6
	.long	NJSCORPSWIPE6A,NJSCORPSWIPE6B,0
NJSCORPSWIPE7
	.long	NJSCORPSWIPE7A,NJSCORPSWIPE7B,0
NJSCORPSWIPE8
	.long	NJSCORPSWIPE8A,NJSCORPSWIPE8B,NJSCORPSWIPE8C,0
NJSCORPSWIPE9
	.long	NJSCORPSWIPE9A,NJSCORPSWIPE9B,NJSCORPSWIPE9C,0

DSPEAR1	.long	NJDETHSPEAR1,0
DSPEAR2	.long	NJDETHSPEAR2,0
DSPEAR3	.long	NJDETHSPEAR3,0
DSPEAR4	.long	NJDETHSPEAR4,0
DSPEAR5	.long	NJDETHSPEAR5,0
DSPEAR6	.long	NJDETHSPEAR6,0
DSPEAR7	.long	NJDETHSPEAR7,0
DSPEAR8	.long	NJDETHSPEAR8,0

**********************************************************************

a_scortch
a_eat_head
	.long	NJMASKOFF1
	.long	NJMASKOFF2
	.long	0

	.long	NJMASKOFF3
	.long	NJMASKOFF4
	.long	NJMASKOFF5
	.long	NJMASKOFF6	; off goes the mask
	.long	0
*
* sizzle - lean
*
	.long	NJLEANOVER1
	.long	NJLEANOVER2
	.long	NJLEANOVER2
	.long	NJLEANOVER2
	.long	NJLEANOVER2
	.long	0
*
* chomp !!
*
	.long	NJLEANOVER2
	.long	NJLEANOVER2
	.long	NJLEANOVER2
	.long	0

	.long	NJREPYUM1
	.long	NJREPYUM2
	.long	NJREPYUM3
	.long	NJREPYUM4
	.long	NJREPYUM5
	.long	0
*
* back up (for scorpion scortch)
*
	.long	NJLEANOVER1
	.long	NJMASKOFF6
	.long	0


a_tongue
	.long	RTONGUE1
	.long	RTONGUE2
	.long	RTONGUE3
	.long	RTONGUE4
	.long	RTONGUE5
	.long	RTONGUE6
	.long	RTONGUE7
	.long	RTONGUE8
	.long	RTONGUE9
	.long	RTONGUE10
	.long	RTONGUE11		; splat !!
	.long	0
*
* part 2 = toungue retracting !!
* 
	.long	RTONGUE10
	.long	RTONGUE8
	.long	RTONGUE7
	.long	RTONGUE6
	.long	RTONGUE5
	.long	RTONGUE4
	.long	RTONGUE3
	.long	RTONGUE2
	.long	RTONGUE1
	.long	0
*
* part 3 = head
* 
	.long	NJRHD1
	.long	NJRHD2
	.long	NJRHD3
	.long	NJRHD4
	.long	0

	.long	NJRHD5
	.long	NJRHD6
	.long	NJRHD7
	.long	NJRHD8
	.long	NJRHD9
	.long	0
*
* chomp !!
*
	.long	NJRHD10
	.long	NJRHD11
	.long	NJRHD12
	.long	0

	.long	RPYUMHEAD1
	.long	RPYUMHEAD2
	.long	RPYUMHEAD3
	.long	RPYUMHEAD4
	.long	RPYUMHEAD5
	.long	0


NJREPYUM1
	.long	NJREPYUMLEG1A,NJREPYUMLEG1B
	.long	NJREPYUM1A,NJREPYUM1B,0
NJREPYUM2
	.long	NJREPYUMLEG1A,NJREPYUMLEG1B
	.long	NJREPYUM2A,NJREPYUM2B,0
NJREPYUM3
	.long	NJREPYUMLEG1A,NJREPYUMLEG1B
	.long	NJREPYUM3A,NJREPYUM3B,0
NJREPYUM4
	.long	NJREPYUMLEG1A,NJREPYUMLEG1B
	.long	NJREPYUM4A,NJREPYUM4B,0
NJREPYUM5
	.long	NJREPYUMLEG1A,NJREPYUMLEG1B
	.long	NJREPYUM5A,NJREPYUM5B,0


RPYUMHEAD1
	.long	NJYUMHEAD1,0
RPYUMHEAD2
	.long	NJYUMHEAD2,0
RPYUMHEAD3
	.long	NJYUMHEAD3,0
RPYUMHEAD4
	.long	NJYUMHEAD4,0
RPYUMHEAD5
	.long	NJYUMHEAD5,0



RTONGUE1
	.long	NJTONGUE1,0
RTONGUE2
	.long	NJTONGUE2,0
RTONGUE3
	.long	NJTONGUE3,0
RTONGUE4
	.long	NJTONGUE4,0
RTONGUE5
	.long	NJTONGUE5,0
RTONGUE6
	.long	NJTONGUE6,0
RTONGUE7
	.long	NJTONGUE7,0
RTONGUE8
	.long	NJTONGUE8,0
RTONGUE9
	.long	NJTONGUE9,0
RTONGUE10
	.long	NJTONGUE10,0
RTONGUE11
	.long	NJTONGUE11,0



NJRHD1	.long	NJREPHEAD1,0
NJRHD2	.long	NJREPHEAD2,0
NJRHD3	.long	NJREPHEAD3,0
NJRHD4	.long	NJREPHEAD4,0
NJRHD5	.long	NJREPHEAD5,0
NJRHD6	.long	NJREPHEAD6,0
NJRHD7	.long	NJREPHEAD7,0
NJRHD8	.long	NJREPHEAD8,0
NJRHD9	.long	NJREPHEAD9,0
NJRHD10	.long	NJREPHEAD10,0
NJRHD11	.long	NJREPHEAD11,0
NJRHD12	.long	NJREPHEAD12,0


NJMASKOFF1
	.long	NJMASKOFF1A,NJMASKOFF1B,0
NJMASKOFF2
	.long	NJMASKOFF2A,NJMASKOFF2B,0
NJMASKOFF3
	.long	NJMASKOFF3A,NJMASKOFF3B,0
NJMASKOFF4
	.long	NJMASKOFF4A,NJMASKOFF4B,0
NJMASKOFF5
	.long	NJMASKOFF5A,NJMASKOFF5B,NJMASKOFF5C,0
NJMASKOFF6
	.long	NJMASKOFF6A,NJMASKOFF6B,NJMASKOFF6C,0

NJLEANOVER1
	.long	NJLEANOVER1A,NJLEANOVER1B,0
NJLEANOVER2
	.long	NJLEANOVER2A,NJLEANOVER2B,0


;************************************************************************

a_spit
	.long	NJREPSPIT1
	.long	NJREPSPIT3
	.long	NJREPSPIT4
	.long	0

	.long	NJREPSPIT3
	.long	NJREPSPIT1
	.long	0

	.long	SPITH1
	.long	SPITH3
	.long	SPITH4
	.long	0

	.long	SPITH3
	.long	SPITH1
	.long	0



a_acid_fly
	.long	NJSPIT1
	.long	NJSPIT2
	.long	NJSPIT3
	.long	NJSPIT4
	.long	NJSPIT5
	.long	NJSPIT6
	.long	NJSPIT7
	.long	NJSPIT8
	.long	0

	.long	NJSPIT9
	.long	NJSPIT10
	.long	NJSPIT11
	.long	NJSPIT12
	.long	NJSPIT13
	.long	0

NJREPSPIT1
	.long	NJREPSPIT1A,NJREPSPIT1B,0
NJREPSPIT3
	.long	NJREPSPIT3A,NJREPSPIT3B,NJREPSPIT3C,0
NJREPSPIT4
	.long	NJREPSPIT4A,NJREPSPIT4B,NJREPSPIT4C,0


NJSPIT1	.long	NJACID1,0
NJSPIT2	.long	NJACID2,0
NJSPIT3	.long	NJACID3,0
NJSPIT4	.long	NJACID4,0
NJSPIT5	.long	NJACID5,0
NJSPIT6	.long	NJACID6,0
NJSPIT7	.long	NJACID7,0
NJSPIT8	.long	NJACID8,0
NJSPIT9	.long	NJACID9,0
NJSPIT10	.long	NJACID10,0
NJSPIT11	.long	NJACID11,0
NJSPIT12	.long	NJACID12,0
NJSPIT13	.long	NJACID13,0


SPITH1	.long	NJSPITHED1,0
SPITH3	.long	NJSPITHED3,0
SPITH4	.long	NJSPITHED4,0

;***********************************************************************



a_impaled
	.long	ani_adjustxy
	.word	->70,>16
	.long	NJIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	NJIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	NJIMPALED1

	.long	ani_adjustxy
	.word	>10,->0d
	.long	NJIMPALED1

	.long	0
*
* suffering (that's Christmas)
*
	.long	NJIMPALED1
	.long	NJIMPALED2
	.long	NJIMPALED1
	.long	NJIMPALED2
	.long	NJIMPALED1
	.long	NJIMPALED2
	.long	NJIMPALED3
	.long	0


NJIMPALED1
	.long	NJIMPALED1A,NJIMPALED1B,0
NJIMPALED2
	.long	NJIMPALED2A,0
NJIMPALED3
	.long	NJIMPALED3A,NJIMPALED3B,0



a_back_broke
	.long	NJBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>0a
	.long	NJBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>30
	.long	NJBACKBREAK1
	.long	NJBACKBREAK2
	.long	NJBACKBREAK3
	.long	0
	.long	NJBACKBREAK2
	.long	NJBACKBREAK1
	.long	0

NJBACKBREAK1
	.long	NJBACKBREAK1A,NJBACKBREAK1B,NJBACKBREAK1C,NJBACKBREAK1D
	.long	NJBACKBREAK1E,0
NJBACKBREAK2
	.long	NJBACKBREAK2A,NJBACKBREAK2B,NJBACKBREAK2C,0
NJBACKBREAK3
	.long	NJBACKBREAK3A,NJBACKBREAK3B,NJBACKBREAK3C,0

;************************************************************************

a_torso_ripped
	.long	ani_adjustxy
	.word	->43,>0a
	.long	NJSTUMBLE3
	.long	0

	.long	ani_calla,change_to_bloody_pal	; switch to bloody pal
	.long	NJRIPTORSO1

	.long	ani_adjustxy
	.word	>18,->2a
	.long	NJRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>00,>08
	.long	NJRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>30,>20
	.long	NJRIPTORSO3

	.long	ani_adjustxy
	.word	>30,>40
	.long	NJRIPTORSO4
	.long	0

	.long	NJRIPTORSO5
	.long	NJRIPTORSO6
	.long	0
*
* standing legz
*
	.long	NJDECAPLEG1		; legz
	.long	0

NJRIPTORSO1
	.long	NJRIPTORSO1A,NJRIPTORSO1B,0
NJRIPTORSO2
	.long	NJRIPTORSO2A,NJRIPTORSO2B,0
NJRIPTORSO3
	.long	NJRIPTORSO3A,NJRIPTORSO3B,0
NJRIPTORSO4
	.long	NJRIPTORSO4A,NJRIPTORSO4B,0
NJRIPTORSO5
	.long	NJRIPTORSO5A,0
NJRIPTORSO6
	.long	NJRIPTORSO6A,NJRIPTORSO6B,0


a_swipe_torso
	.long	NJRIPTORSO1
	.long	NJRIPTORSO2
	.long	NJRIPTORSO3
	.long	NJRIPTORSO4
	.long	NJRIPTORSO5
	.long	NJRIPTORSO6
	.long	0

;**************************************************************


a_head
	.long	NJHEAD1
	.long	NJHEAD2
	.long	NJHEAD3
	.long	NJHEAD4
	.long	NJHEAD5
	.long	NJHEAD6
	.long	NJHEAD7
	.long	NJHEAD8
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


NJDECAPLEG1
	.long	NJDECAPLEG1A,0

NJDECAP1
	.long	NJDECAPLEG1A,NJDECAPTORSO1,0
NJDECAP2
	.long	NJDECAPLEG2A,NJDECAPTORSO2,0
NJDECAP3
	.long	NJDECAPLEG3A,NJDECAPLEG3B,NJDECAPTORSO3,0
NJDECAP4
	.long	NJDECAPLEG4A,NJDECAPLEG4B,NJDECAPTORSO4,0
NJDECAP5
	.long	NJDECAPLEG5A,NJDECAPLEG5B,NJDECAPTORSO5,0
NJDECAP6
	.long	NJDECAPLEG6A,NJDECAPLEG6B,NJDECAPTORSO5,0
NJDECAP7
	.long	NJDECAPLEG7A,NJDECAPLEG7B,NJDECAPTORSO7,0

;**************************************************************

a_scissor_kick
	.long	ani_adjustx
	.word	12
	.long	NJDUCK1

	.long	ani_adjustx
	.word	12
	.long	NJSIZZERKIK1

	.long	ani_adjustx
	.word	12
	.long	NJSIZZERKIK2

	.long	ani_adjustx
	.word	12
	.long	NJSIZZERKIK3
	.long	0

	.long	NJSIZZERKIK4
	.long	NJSIZZERKIK5
	.long	NJSIZZERKIK6
	.long	0

NJSIZZERKIK1
	.long	NJSIZZERKIK1A,NJSIZZERKIK1B,NJSIZZERKIK1C,0
NJSIZZERKIK2
	.long	NJSIZZERKIK2A,NJSIZZERKIK2B,NJSIZZERKIK2C,0
NJSIZZERKIK3
	.long	NJSIZZERKIK3A,NJSIZZERKIK3B,NJSIZZERKIK3C,0
NJSIZZERKIK4
	.long	NJSIZZERKIK4A,NJSIZZERKIK4B,NJSIZZERKIK4C,NJSIZZERKIK4D,0
NJSIZZERKIK5
	.long	NJSIZZERKIK5A,NJSIZZERKIK5B,NJSIZZERKIK5C,0
NJSIZZERKIK6
	.long	NJSIZZERKIK6A,NJSIZZERKIK6B,NJSIZZERKIK6C,NJSIZZERKIK6D,0

;**************************************************************

a_fb_goro
	.long	ani_adjustxy
	.word	->60,->20
	.long	NJSTUMBLE1

	.long	ani_adjustxy
	.word	>10,->70
	.long	NJKNOCKDOWN6

	.long	ani_adjustxy
	.word	>20,>00
	.long	NJKNOCKDOWN6

	.long	ani_adjustxy
	.word	>3a,>20
	.long	NJKNOCKDOWN5

	.long	ani_adjustxy
	.word	>38,>10
	.long	NJKNOCKDOWN5

	.long	ani_adjustxy
	.word	>00,>68
	.long	NJKNOCKDOWN6
	.long	0

;***********************************************************************

a_scorpion_skull
	.long	SCSKULL1
	.long	SCSKULL2
	.long	SCSKULL3
	.long	SCSKULL4
	.long	0

	.long	SCSKULL5
	.long	SCSKULL6
	.long	0

	.long	SCSKULL5
	.long	SCSKULL4
	.long	0

SCSKULL1	.long	NJSKULLHED1,0
SCSKULL2	.long	NJSKULLHED2,0
SCSKULL3	.long	NJSKULLHED3,0
SCSKULL4	.long	NJSKULLHED4,0
SCSKULL5	.long	NJSKULLHED5,0
SCSKULL6	.long	NJSKULLHED6,0

;***********************************************************************

a_pitch
	.long	NJSUBDETHBLO1
	.long	NJSUBDETHBLO1
	.long	NJSUBDETHBLO1
	.long	NJSUBDETHBLO1
	.long	NJSUBDETHBLO1
	.long	NJSUBDETHBLO1
	.long	0

	.long	NJSUBDETHBLO2
	.long	NJSUBDETHBLO3
	.long	NJSUBDETHBLO4
	.long	NJSUBDETHBLO5
	.long	0

NJSUBDETHBLO1
	.long	NJSUBDETHBLO1A,NJSUBDETHBLO1B,NJSUBDETHBLO1C,NJSUBDETHBLO1D,0
NJSUBDETHBLO2
	.long	NJSUBDETHBLO2A,NJSUBDETHBLO2B,NJSUBDETHBLO2C,0
NJSUBDETHBLO3
	.long	NJSUBDETHBLO3A,NJSUBDETHBLO3B,0
NJSUBDETHBLO4
	.long	NJSUBDETHBLO4A,NJSUBDETHBLO4B,NJSUBDETHBLO4C,0
NJSUBDETHBLO5
	.long	NJSUBDETHBLO5A,NJSUBDETHBLO5B,NJSUBDETHBLO5C,NJSUBDETHBLO5D,0

;************************************************************************

	.end


