**************************************************************************
*											     *
*  video game project:	Mortal Kombat 2							*
* 											     *
*  game software:    	Ed Boon								     *
* 											     *
*  module: Female Ninjas										*
*											     *
**************************************************************************
	.FILE	'MK56.ASM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
*
* GET THE SYSTEM STUFF
*
	.INCLUDE	MAINEQU.ASM
	.INCLUDE	MKFN.TBL
	.INCLUDE	IMGTBL.GLO
	.text

fn1_anitab1
fn2_anitab1
fn3_anitab1
	.long	a_fn1stance	;
	.long	a_fn1walkf	;  1 - walk forward
	.long	a_fn1skipf	;  2 - skip forward
	.long	a_fn1walkb	;  3 - walk backward
	.long	a_fn1skipb	;  4 - walk backward
	.long	a_fnduck  	;  5 - duck animation
	.long	a_fnjumpup	;  6 - jump straight up
	.long	a_fnfflip	;  7 - forward flip
	.long	a_fnbflip	;  8 - backward flip
	.long	a_fn1turn	;  9 - turn around
	.long	a_fnduckturn	;  A - turn around while ducking
	.long	a_fnblockhi	;  B - standing block
	.long	a_fnduckblock	;  C - ducking block
	.long	a_fnhikick	;  D - hi kick
	.long	a_fnlokick	;  E - lo kick
	.long	a_fnkdown	;  F - knocked down
	.long	a_fnhithi	; 10 - hit high
	.long	a_fnhitlo	; 11 - hit low
	.long	a_fngetup	; 12 - normal getup
	.long	a_fnhipunch	; 13 - hi punch
	.long	a_fnlopunch	; 14 - lo punch
	.long	a_fnsweep	; 15 - sweep kick
	.long	a_fnsweepfall	; 16 - sweep fall
	.long	a_fnsweepup	; 17 - getup from sweep kick
	.long	a_fnduckpunch	; 18 - duck punch
	.long	a_fnduckkickh	; 19 - duck kick high
	.long	a_fnduckkickl	; 1a - duck kick low
	.long	a_fnduckhit	; 1b - hit while ducking
	.long	a_fnuppercut	; 1c - uppercut
	.long	a_fnjumpupkick	; 1d - jump straight up kick
	.long	a_fnflipkick	; 1e - flip kick
	.long	a_fnflippunch	; 1f - flip punch
	.long	a_fnroundh	; 20 - roundhouse kick
	.long	a_fnknee	; 21 - knee
	.long	a_fnelbow	; 22 - elbow
	.long	a_fnstumble	; 23 - stumble back
	.long	a_fnbodyslam	; 24 - body slam
	.long	a_shredded	; 25 -
	.long	a_fnprojectile	; 26 - throwing his hat
	.long	a_fnfanfly	; 27 - fan flying
	.long	a_fnstunned	; 28 - stunned
	.long	a_fn1victory	; 29 - victory

	.long	a_fn_fb_hh	; 2a - female ninja flipped by hh
	.long	a_fn_fb_lk	; 2b - female ninja flipped by liu kang
	.long	a_fn_fb_jc	; 2c - female ninja flipped by cage
	.long	a_fn_fb_sa	; 2d - female ninja flipped by sword arms
	.long	a_fn_fb_fn	; 2e - female ninja flipped by female ninjas
	.long	a_fn_fb_fn	; 2f - female ninja flipped by female ninjas
	.long	a_fn_fb_st	; 30 - female ninja flipped by shang tsung
	.long	a_fn_fb_rd	; 31 - female ninja flipped by raiden
	.long	a_fn_fb_nj	; 32 - female ninja flipped by ninja
	.long	a_fn_fb_nj	; 33 - female ninja flipped by ninja
	.long	a_fn_fb_nj	; 34 - female ninja flipped by ninja
	.long	a_fn_fb_jx	; 35 - female ninja flipped by jax

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





fn1_anitab2
	.long	a_fnairfan 	; 0 - throw fans while I am in the air
	.long	a_spinfan 	; 1 - lean back to spin the fans
	.long	a_spinwave	; 2 - waves which come out of the fans
	.long	a_fan_swipe	; 3 - fan swipe
	.long	a_death_kiss1	; 4 - death kiss
	.long	a_square_punch	; 5 - sonya square wave punch
	.long	dummy		;
	.long	dummy		;
	.long	dummy		;

fn2_anitab2
fn3_anitab2
	.long	a_fn2_stab		; 0 - stabbing death blow
	.long	a_fn2walkf		; 1 - walk forward
	.long	a_fn2skipf		; 2 - skip forward
	.long	a_fn2walkb		; 3 - walk backward
	.long	a_death_kiss2		; 4 - death kiss
	.long	a_fnthrow_sai		; 5 - throw sai's
	.long	a_fnsaifly		; 6 - sai's flying
	.long	a_fnthrow_sai_air 	; 7
	.long	a_spit_bones		; 8
	.long	dummy			; 9

;***********************************************************************

pointless_code
	move	a0,a0
	move	a1,a1
	move	a2,a2
	move	a3,a3
	move	a4,a4
	move	a5,a5



dummy
a_fn1stance
	.long	ani_ochar_jump
	.word	ft_fn2			; am I the female ninja #2 ??
	.long	a_fn2stance		; yes = do her stance then !

j_fn1st 
	.long	KT1STANCE1
	.long	KT1STANCE2
	.long	KT1STANCE3
	.long	KT1STANCE4
	.long	KT1STANCE5
	.long	KT1STANCE6
	.long	ani_jump,j_fn1st

KT1STANCE1
	.long	KT1STANCE1A,KT1STANCE1B,0
KT1STANCE2
	.long	KT1STANCE2A,KT1STANCE2B,0
KT1STANCE3
	.long	KT1STANCE3A,KT1STANCE3B,0
KT1STANCE4
	.long	KT1STANCE4A,KT1STANCE4B,0
KT1STANCE5
	.long	KT1STANCE5A,KT1STANCE5B,0
KT1STANCE6
	.long	KT1STANCE6A,KT1STANCE6B,0

;***********************************************************************

a_fn2stance
	.long	KT2STANCE1
	.long	KT2STANCE2
	.long	KT2STANCE3
	.long	KT2STANCE4
	.long	KT2STANCE5
	.long	KT2STANCE6
	.long	KT2STANCE7
	.long	KT2STANCE6
	.long	KT2STANCE5
	.long	KT2STANCE4
	.long	KT2STANCE3
	.long	KT2STANCE2
	.long	ani_jump,a_fn2stance

KT2STANCE1
	.long	KT2STANCE1A,KT2STANCE1B,0
KT2STANCE2
	.long	KT2STANCE2A,KT2STANCE2B,0
KT2STANCE3
	.long	KT2STANCE3A,KT2STANCE3B,0
KT2STANCE4
	.long	KT2STANCE4A,KT2STANCE4B,0
KT2STANCE5
	.long	KT2STANCE5A,KT2STANCE5B,0
KT2STANCE6
	.long	KT2STANCE6A,KT2STANCE6B,0
KT2STANCE7
	.long	KT2STANCE7A,KT2STANCE7B,0

;***********************************************************************

a_fn1walkf
	.long	ani_ochar_jump
	.word	ft_fn2			; am I fn2
	.long	a_fn2walkf		; yes = new stance then !

	.long	KT1WALK1
	.long	KT1WALK2
	.long	KT1WALK3
	.long	KT1WALK4
	.long	KT1WALK5
	.long	KT1WALK6
	.long	KT1WALK7
	.long	KT1WALK8
	.long	KT1WALK9
	.long	ani_jump,a_fn1walkf

a_fn1skipf
	.long	ani_ochar_jump
	.word	ft_fn2			; am I fn2
	.long	a_fn2skipf		; yes = new stance then !

	.long	KT1WALK1
	.long	KT1WALK2
	.long	KT1WALK8
	.long	KT1WALK9
	.long	0

a_fn1walkb
	.long	ani_ochar_jump
	.word	ft_fn2			; am I fn2
	.long	a_fn2walkb		; yes = new stance then !

	.long	KT1WALK9
	.long	KT1WALK8
	.long	KT1WALK7
	.long	KT1WALK6
	.long	KT1WALK5
	.long	KT1WALK4
	.long	KT1WALK3
	.long	KT1WALK2
	.long	KT1WALK1
	.long	ani_jump,a_fn1walkb

a_fn1skipb
	.long	ani_ochar_jump
	.word	ft_fn2			; am I fn2
	.long	a_fn2skipb		; yes = new stance then !

	.long	KT1WALK9
	.long	KT1WALK8
	.long	KT1WALK2
	.long	KT1WALK1
	.long	0

KT1WALK1	.long	KT1WALKTORSO1A,KT1WALKTORSO1B,KTLEGWALK1A,KTLEGWALK1B,0
KT1WALK2	.long	KT1WALKTORSO2A,KT1WALKTORSO2B,KTLEGWALK2A,KTLEGWALK2B,0
KT1WALK3	.long	KT1WALKTORSO3A,KT1WALKTORSO3B,KTLEGWALK3A,KTLEGWALK3B,0
KT1WALK4	.long	KT1WALKTORSO4A,KT1WALKTORSO4B,KTLEGWALK4A,KTLEGWALK4B,0
KT1WALK5	.long	KT1WALKTORSO5A,KT1WALKTORSO5B,KTLEGWALK5A,KTLEGWALK5B,0
KT1WALK6	.long	KT1WALKTORSO6A,KT1WALKTORSO6B,KTLEGWALK6A,KTLEGWALK6B,0
KT1WALK7	.long	KT1WALKTORSO7A,KT1WALKTORSO7B,KTLEGWALK7A,0
KT1WALK8	.long	KT1WALKTORSO8A,KT1WALKTORSO8B,KTLEGWALK8A,KTLEGWALK8B,0
KT1WALK9	.long	KT1WALKTORSO9A,KT1WALKTORSO9B,KTLEGWALK9A,KTLEGWALK9B,0

;***********************************************************************

a_fn2walkf
	.long	KT2WALK1
	.long	KT2WALK2
	.long	KT2WALK3
	.long	KT2WALK4
	.long	KT2WALK5
	.long	KT2WALK6
	.long	KT2WALK7
	.long	KT2WALK8
	.long	KT2WALK9
	.long	ani_jump,a_fn2walkf

a_fn2skipf
	.long	KT2WALK1
	.long	KT2WALK2
	.long	KT2WALK8
	.long	KT2WALK9
	.long	0

a_fn2walkb
	.long	KT2WALK9
	.long	KT2WALK8
	.long	KT2WALK7
	.long	KT2WALK6
	.long	KT2WALK5
	.long	KT2WALK4
	.long	KT2WALK3
	.long	KT2WALK2
	.long	KT2WALK1
	.long	ani_jump,a_fn2walkb

a_fn2skipb
	.long	KT2WALK9
	.long	KT2WALK8
	.long	KT2WALK2
	.long	KT2WALK1
	.long	0

KT2WALK1	.long	KT2WALKTORSO1A,KT2WALKTORSO1B,KTLEGWALK1A,KTLEGWALK1B,0
KT2WALK2	.long	KT2WALKTORSO2A,KT2WALKTORSO2B,KTLEGWALK2A,KTLEGWALK2B,0
KT2WALK3	.long	KT2WALKTORSO3A,KT2WALKTORSO3B,KTLEGWALK3A,KTLEGWALK3B,0
KT2WALK4	.long	KT2WALKTORSO4A,KT2WALKTORSO4B,KTLEGWALK4A,KTLEGWALK4B,0
KT2WALK5	.long	KT2WALKTORSO5A,KT2WALKTORSO5B,KTLEGWALK5A,KTLEGWALK5B,0
KT2WALK6	.long	KT2WALKTORSO6A,KT2WALKTORSO6B,KTLEGWALK6A,KTLEGWALK6B,0
KT2WALK7	.long	KT2WALKTORSO7A,KT2WALKTORSO7B,KTLEGWALK7A,0
KT2WALK8	.long	KT2WALKTORSO8A,KT2WALKTORSO8B,KTLEGWALK8A,KTLEGWALK8B,0
KT2WALK9	.long	KT2WALKTORSO9A,KT2WALKTORSO9B,KTLEGWALK9A,KTLEGWALK9B,0

;***********************************************************************

a_fnduck
	.long	KTDUCK1
	.long	KTDUCK2
	.long	KTDUCK3
	.long	0

KTDUCK1	.long	KTDUCK1A,KTDUCK1B,KTDUCK1C,0
KTDUCK2	.long	KTDUCK2A,KTDUCK2B,KTDUCK2C,0
KTDUCK3	.long	KTDUCK3A,KTDUCK3B,KTDUCK3C,0

;***********************************************************************

a_fnfflip
	.long	KTJUMPFLIP1
	.long	KTJUMPFLIP2
	.long	KTJUMPFLIP3
	.long	KTJUMPFLIP4
	.long	KTJUMPFLIP5
	.long	KTJUMPFLIP6
	.long	KTJUMPFLIP7
	.long	KTJUMPFLIP8
	.long	ani_jump,a_fnfflip+32

a_fnbflip
	.long	KTJUMPFLIP1
	.long	KTJUMPFLIP8
	.long	KTJUMPFLIP7
	.long	KTJUMPFLIP6
	.long	KTJUMPFLIP5
	.long	KTJUMPFLIP4
	.long	KTJUMPFLIP3
	.long	KTJUMPFLIP2
	.long	ani_jump,a_fnbflip+32

KTJUMPFLIP1
	.long	KTJUMPFLIP1A,KTJUMPFLIP1B,0
KTJUMPFLIP2
	.long	KTJUMPFLIP2A,0
KTJUMPFLIP3
	.long	KTJUMPFLIP3A,0
KTJUMPFLIP4
	.long	KTJUMPFLIP4A,0
KTJUMPFLIP5
	.long	KTJUMPFLIP5A,KTJUMPFLIP5B,0
KTJUMPFLIP6
	.long	KTJUMPFLIP6A,0
KTJUMPFLIP7
	.long	KTJUMPFLIP7A,0
KTJUMPFLIP8
	.long	KTJUMPFLIP8A,0


;***********************************************************************

a_fnjumpup
	.long	KTJUMP2
	.long	KTJUMP3
	.long	0
	.long	KTJUMP2
	.long	KTJUMP1
	.long	0

KTJUMP1	.long	KTJUMP1A,KTJUMP1B,0
KTJUMP2	.long	KTJUMP2A,KTJUMP2B,0
KTJUMP3	.long	KTJUMP3A,KTJUMP3B,0

;***********************************************************************

a_fn1turn
	.long	ani_ochar_jump
	.word	ft_fn2			; am I the female ninja #2 ??
	.long	a_fn2turn		; yes = do her turn then !

	.long	KT1TURN1
	.long	KT1TURN2
	.long	ani_flip  
	.long	ani_adjustx
	.word	-4
	.long	KT1TURN1
	.long	0

KT1TURN1	.long	KT1TURN1A,KT1TURN1B,0
KT1TURN2	.long	KT1TURN2A,KT1TURN2B,0

a_fn2turn
	.long	KT2TURN1
	.long	KT2TURN2
	.long	ani_flip  
	.long	ani_adjustx
	.word	-7
	.long	KT2TURN1
	.long	0

KT2TURN1	.long	KT2TURN1A,KT2TURN1B,0
KT2TURN2	.long	KT2TURN2A,KT2TURN2B,0

;***********************************************************************

a_fnduckturn
	.long	KTDUCKTURN1
	.long	KTDUCKTURN2
	.long	ani_flip  
	.long	ani_adjustx
	.word	-5
	.long	KTDUCKTURN1
	.long	KTDUCK3
	.long	0

KTDUCKTURN2
	.long	KTDUCKTURN2A,KTDUCKTURN2B,0
KTDUCKTURN1
	.long	KTDUCKTURN1A,KTDUCKTURN1B,0

;***********************************************************************

a_fnblockhi
	.long	KTHIBLOCK1
	.long	KTHIBLOCK2
	.long	KTHIBLOCK3
	.long	0
	.long	KTHIBLOCK2
	.long	KTHIBLOCK1
	.long	0

KTHIBLOCK1
	.long	KTHIBLOCK1A,KTHIBLOCK1B,0
KTHIBLOCK2
	.long	KTHIBLOCK2A,KTHIBLOCK2B,KTHIBLOCK2C,0
KTHIBLOCK3
	.long	KTHIBLOCK3A,KTHIBLOCK3B,0

;***********************************************************************

a_fnduckblock
	.long	KTDUCKBLOCK1
	.long	KTDUCKBLOCK2
	.long	KTDUCKBLOCK3
	.long	0
	.long	KTDUCKBLOCK2
	.long	KTDUCKBLOCK1
	.long	KTDUCK3
	.long	0

KTDUCKBLOCK1
	.long	KTDUCKBLOCK1A,KTDUCKBLOCK1B,0
KTDUCKBLOCK2
	.long	KTDUCKBLOCK2A,KTDUCKBLOCK2B,0
KTDUCKBLOCK3
	.long	KTDUCKBLOCK3A,KTDUCKBLOCK3B,0

;***********************************************************************

a_fnhikick
	.long	KTHIKICK1
	.long	KTHIKICK3
	.long	KTHIKICK4
	.long	KTHIKICK5
	.long	KTHIKICK6
	.long	KTHIKICK7
	.long	0
	.long	KTHIKICK6
	.long	KTHIKICK5
	.long	KTHIKICK4
	.long	KTHIKICK3
	.long	KTHIKICK2
	.long	KTHIKICK1
	.long	0

a_fnlokick
	.long	KTHIKICK1
	.long	KTHIKICK3
	.long	KTHIKICK4
	.long	KTHIKICK5
	.long	KTHIKICK6
	.long	KTLOKICK1
	.long	0
	.long	KTHIKICK6
	.long	KTHIKICK5
	.long	KTHIKICK4
	.long	KTHIKICK3
	.long	KTHIKICK2
	.long	KTHIKICK1
	.long	0

KTHIKICK1
	.long	KTHIKICK1A,KTHIKICK1B,0
KTHIKICK2
	.long	KTHIKICK2A,KTHIKICK2B,0
KTHIKICK3
	.long	KTHIKICK3A,0
KTHIKICK4
	.long	KTHIKICK4A,KTHIKICK4B,0
KTHIKICK5
	.long	KTHIKICK5A,KTHIKICK5B,0
KTHIKICK6
	.long	KTHIKICK6A,0
KTHIKICK7
	.long	KTHIKICK7A,KTHIKICK7B,0
KTLOKICK1
	.long	KTLOKICK1A,0

;***********************************************************************


a_fnhipunch
	.long	KTHIPUNCH1
	.long	KTHIPUNCH2
	.long	KTHIPUNCH3
	.long	0

	.long	KTHIPUNCH4
	.long	KTHIPUNCH5
	.long	KTHIPUNCH6
	.long	0

	.long	KTHIPUNCH5
	.long	KTHIPUNCH4
	.long	ani_jump,a_fnhipunch+(32*2)
	.long	0					; we NEED this "0"
*
* Unhipunch #1
*
	.long	KTHIPUNCH2
	.long	KTHIPUNCH1
	.long	0
*
* Unhipunch #2
*
	.long	KTHIPUNCH5
	.long	0
*
* Hi to Med #1
*
	.long	KTHIPUNCH4
	.long	KTHIPUNCH5
	.long	ani_jump,a_fnlopunch+(32*6)
	.long	0
*
* Hi to Med #2
*
	.long	KTHIPUNCH5
	.long	KTHIPUNCH4
	.long	ani_jump,a_fnlopunch+(32*2)
	.long	0



a_fnlopunch
	.long	KTHIPUNCH1
	.long	KTHIPUNCH2
	.long	KTLOPUNCH1
	.long	0

	.long	KTHIPUNCH4
	.long	KTHIPUNCH5
	.long	KTLOPUNCH2
	.long	0

	.long	KTHIPUNCH5
	.long	KTHIPUNCH4
	.long	ani_jump,a_fnlopunch+(32*2)
	.long	0
*
* Unlopunch #1
*
	.long	KTHIPUNCH2
	.long	KTHIPUNCH1
	.long	0
*
* Unlopunch #2
*
	.long	KTHIPUNCH5
	.long	0
*
* Med to High #1
*
	.long	KTHIPUNCH4
	.long	KTHIPUNCH5
	.long	ani_jump,a_fnhipunch+(32*6)
	.long	0
*
* Med to High #2
*
	.long	KTHIPUNCH5
	.long	KTHIPUNCH4
	.long	ani_jump,a_fnhipunch+(32*2)

KTHIPUNCH1
	.long	KTHIPUNCH1A,KTHIPUNCH1B,0
KTHIPUNCH2
	.long	KTHIPUNCH2A,KTHIPUNCH2B,KTHIPUNCH2C,KTHIPUNCH2D,0
KTHIPUNCH3
	.long	KTHIPUNCH3A,KTHIPUNCH3B,KTHIPUNCH3C,KTHIPUNCH3D,0
KTHIPUNCH4
	.long	KTHIPUNCH4A,KTHIPUNCH4B,0
KTHIPUNCH5
	.long	KTHIPUNCH5A,KTHIPUNCH5B,KTHIPUNCH5C,0
KTHIPUNCH6
	.long	KTHIPUNCH6A,KTHIPUNCH6B,KTHIPUNCH6C,KTHIPUNCH6D,0
KTHIPUNCH7
	.long	KTHIPUNCH7A,KTHIPUNCH7B,KTHIPUNCH7C,0
KTLOPUNCH1
	.long	KTLOPUNCH1A,KTLOPUNCH1B,0
KTLOPUNCH2
	.long	KTLOPUNCH2A,KTLOPUNCH2B,0

;***********************************************************************

a_fnroundh
	.long	KTROUNDKIK1
	.long	KTROUNDKIK2
	.long	KTROUNDKIK3
	.long	KTROUNDKIK4
	.long	0
	.long	KTROUNDKIK5
	.long	KTROUNDKIK6
	.long	KTROUNDKIK7
	.long	KTROUNDKIK8
	.long	0

KTROUNDKIK1
	.long	KTROUNDKIK1A,KTROUNDKIK1B,0
KTROUNDKIK2
	.long	KTROUNDKIK2A,KTROUNDKIK2B,0
KTROUNDKIK3
	.long	KTROUNDKIK3A,KTROUNDKIK3B,0
KTROUNDKIK4
	.long	KTROUNDKIK4A,KTROUNDKIK4B,0
KTROUNDKIK5
	.long	KTROUNDKIK5A,KTROUNDKIK5B,0
KTROUNDKIK6
	.long	KTROUNDKIK6A,0
KTROUNDKIK7
	.long	KTROUNDKIK7A,KTROUNDKIK7B,0
KTROUNDKIK8
	.long	KTROUNDKIK8A,KTROUNDKIK8B,0

;***********************************************************************

a_fnuppercut
	.long	KTUPPERCUT1
	.long	KTUPPERCUT2
	.long	KTUPPERCUT3
	.long	KTUPPERCUT4
	.long	ani_nosleep	; dont sleep after next frame
	.long	KTUPPERCUT5
	.long	0
	.long	KTUPPERCUT6
	.long	KTHIPUNCH1
	.long	0

KTUPPERCUT1
	.long	KTUPPERCUT1A,KTUPPERCUT1B,0
KTUPPERCUT2
	.long	KTUPPERCUT2A,KTUPPERCUT2B,0
KTUPPERCUT3
	.long	KTUPPERCUT3A,KTUPPERCUT3B,0
KTUPPERCUT4
	.long	KTUPPERCUT4A,KTUPPERCUT4B,KTUPPERCUT4C,0
KTUPPERCUT5
	.long	KTUPPERCUT5A,KTUPPERCUT5B,0
KTUPPERCUT6
	.long	KTUPPERCUT6A,KTUPPERCUT6B,0

;***********************************************************************

a_fnknee
	.long	KTKNEE1
	.long	KTKNEE2
	.long	KTKNEE3
	.long	0
	.long	KTKNEE2
	.long	KTKNEE1
	.long	0

KTKNEE1	.long	KTKNEE1A,KTKNEE1B,KTKNEE1C,0
KTKNEE2	.long	KTKNEE2A,0
KTKNEE3	.long	KTKNEE3A,KTKNEE3B,0

;***********************************************************************

a_fnelbow
	.long	KTELBO1
	.long	KTELBO2
	.long	KTELBO3
	.long	0
	.long	KTELBO2
	.long	KTELBO1
	.long	0

KTELBO1	.long	KTELBO1A,KTELBO1B,0
KTELBO2	.long	KTELBO2A,KTELBO2B,0
KTELBO3	.long	KTELBO3A,KTELBO3B,KTELBO3C,0

;***********************************************************************

a_fnstumble
	.long	KTSTUMBLE1
	.long	KTSTUMBLE2
	.long	KTSTUMBLE3
	.long	KTSTUMBLE4
	.long	KTSTUMBLE5
	.long	0

KTSTUMBLE1
	.long	KTSTUMBLE1A,KTSTUMBLE1B,KTSTUMBLE1C,0
KTSTUMBLE2
	.long	KTSTUMBLE2A,KTSTUMBLE2B,KTSTUMBLE2C,0
KTSTUMBLE3
	.long	KTSTUMBLE3A,KTSTUMBLE3B,KTSTUMBLE3C,0
KTSTUMBLE4
	.long	KTSTUMBLE4A,KTSTUMBLE4B,0
KTSTUMBLE5
	.long	KTSTUMBLE5A,KTSTUMBLE5B,0

;***********************************************************************

a_fnkdown
	.long	KTKNOCKDOWN1
	.long	KTKNOCKDOWN2
	.long	KTKNOCKDOWN3
	.long	KTKNOCKDOWN4
	.long	0
*
* part 2 = landing on back
*
	.long	KTKNOCKDOWN5
	.long	KTKNOCKDOWN6
	.long	0
*
* part 3 = shake on the ground
*
	.long	KTKNOCKDOWN5
	.long	KTKNOCKDOWN6
	.long	KTKNOCKDOWN5
	.long	KTKNOCKDOWN6
	.long	0

KTKNOCKDOWN1
	.long	KTKNOCKDOWN1A,0
KTKNOCKDOWN2
	.long	KTKNOCKDOWN2A,0
KTKNOCKDOWN3
	.long	KTKNOCKDOWN3A,KTKNOCKDOWN3B,0
KTKNOCKDOWN4
	.long	KTKNOCKDOWN4A,KTKNOCKDOWN4B,0
KTKNOCKDOWN5
	.long	KTKNOCKDOWN5A,KTKNOCKDOWN5B,0
KTKNOCKDOWN6
	.long	KTKNOCKDOWN6A,KTKNOCKDOWN6B,0

;***********************************************************************

a_fnduckkickl
	.long	KTDUCKICKLO1
	.long	ani_calla,kick_sounds
	.long	KTDUCKICKLO2
	.long	KTDUCKICKLO3
	.long	KTDUCKICKLO4
	.long	0
	.long	KTDUCKICKLO3
	.long	KTDUCKICKLO2
	.long	KTDUCKICKLO1
	.long	KTDUCK3
 	.long	0

a_fnduckkickh
	.long	KTDUCKICKLO1
	.long	ani_calla,kick_sounds
	.long	KTDUCKICKLO2
	.long	KTDUCKICKHI1
	.long	KTDUCKICKHI2
	.long	0
	.long	KTDUCKICKHI1
	.long	KTDUCKICKLO2
	.long	KTDUCKICKLO1
	.long	KTDUCK3
	.long	0

KTDUCKICKLO1
	.long	KTDUCKICKLO1A,KTDUCKICKLO1B,0
KTDUCKICKLO2
	.long	KTDUCKICKLO2A,KTDUCKICKLO2B,0
KTDUCKICKLO3
	.long	KTDUCKICKLO3A,KTDUCKICKLO3B,0
KTDUCKICKLO4
	.long	KTDUCKICKLO4A,KTDUCKICKLO4B,KTDUCKICKLO4C,KTDUCKICKLO4D,0

KTDUCKICKHI1
	.long	KTDUCKICKHI1A,KTDUCKICKHI1B,KTDUCKICKHI1C,0
KTDUCKICKHI2
	.long	KTDUCKICKHI2A,KTDUCKICKHI2B,0

;***********************************************************************

a_fnsweepfall
	.long	KTSWEEPFALL1
	.long	KTSWEEPFALL2
	.long	KTSWEEPFALL3
	.long	KTSWEEPFALL4
	.long	0
	.long	KTSWEEPFALL5
	.long	KTSWEEPFALL6
	.long	0

KTSWEEPFALL1
	.long	KTSWEEPFALL1A,KTSWEEPFALL1B,KTSWEEPFALL1C,KTSWEEPFALL1D,0
KTSWEEPFALL2
	.long	KTSWEEPFALL2A,KTSWEEPFALL2B,KTSWEEPFALL2C,KTSWEEPFALL2D,0
KTSWEEPFALL3
	.long	KTSWEEPFALL3A,KTSWEEPFALL3B,KTSWEEPFALL3C,0
KTSWEEPFALL4
	.long	KTSWEEPFALL4A,KTSWEEPFALL4B,KTSWEEPFALL4C,0
KTSWEEPFALL5
	.long	KTSWEEPFALL5A,KTSWEEPFALL5B,KTSWEEPFALL5C,0
KTSWEEPFALL6
	.long	KTSWEEPFALL6A,KTSWEEPFALL6B,0

;***********************************************************************

a_fnsweep
	.long	KTSWEEPKICK1
	.long	KTSWEEPKICK2
	.long	KTSWEEPKICK3
	.long	ani_calla,sweep_sounds
	.long	KTSWEEPKICK4
	.long	0
	.long	KTSWEEPKICK5
	.long	KTSWEEPKICK6
	.long	KTSWEEPKICK7
	.long	0

KTSWEEPKICK1
	.long	KTSWEEPKICK1A,KTSWEEPKICK1B,0
KTSWEEPKICK2
	.long	KTSWEEPKICK2A,KTSWEEPKICK2B,0
KTSWEEPKICK3
	.long	KTSWEEPKICK3A,KTSWEEPKICK3B,0
KTSWEEPKICK4
	.long	KTSWEEPKICK4A,KTSWEEPKICK4B,KTSWEEPKICK4C,0
KTSWEEPKICK5
	.long	KTSWEEPKICK5A,KTSWEEPKICK5B,0
KTSWEEPKICK6
	.long	KTSWEEPKICK6A,KTSWEEPKICK6B,KTSWEEPKICK6C,0
KTSWEEPKICK7
	.long	KTSWEEPKICK7A,KTSWEEPKICK7B,KTSWEEPKICK7C,0

;***********************************************************************

a_fnsweepup
	.long	KTSWEEPUP1
	.long	KTSWEEPUP2
	.long	KTSWEEPUP3
	.long	KTSWEEPUP4
	.long	KTSWEEPUP5
	.long	0

KTSWEEPUP1
	.long	KTSWEEPUP1A,KTSWEEPUP1B,0
KTSWEEPUP2
	.long	KTSWEEPUP2A,KTSWEEPUP2B,0
KTSWEEPUP3
	.long	KTSWEEPUP3A,KTSWEEPUP3B,0
KTSWEEPUP4
	.long	KTSWEEPUP4A,KTSWEEPUP4B,0
KTSWEEPUP5
	.long	KTSWEEPUP5A,KTSWEEPUP5B,0

;***********************************************************************

a_fnduckpunch
	.long	KTDUCKPUNCH1
	.long	KTDUCKPUNCH2
	.long	KTDUCKPUNCH3
	.long	0
	.long	KTDUCKPUNCH2
	.long	KTDUCKPUNCH1
	.long	KTDUCK3
	.long	0

KTDUCKPUNCH1
	.long	KTDUCKPUNCH1A,KTDUCKPUNCH1B,0
KTDUCKPUNCH2
	.long	KTDUCKPUNCH2A,KTDUCKPUNCH2B,0
KTDUCKPUNCH3
	.long	KTDUCKPUNCH3A,KTDUCKPUNCH3B,0

;***********************************************************************

a_fnhithi
	.long	KTHITHI2
	.long	KTHITHI3
	.long	KTHITHI2
	.long	KTHITHI1
	.long	0

KTHITHI1	.long	KTHITHI1A,KTHITHI1B,KTHITHI1C,0
KTHITHI2	.long	KTHITHI2A,KTHITHI2B,0
KTHITHI3	.long	KTHITHI3A,KTHITHI3B,0

;***********************************************************************

a_fnhitlo
	.long	KTHITLO2
	.long	KTHITLO3
	.long	KTHITLO2
	.long	KTHITLO1
	.long	0

KTHITLO1	.long	KTHITLO1A,KTHITLO1B,0
KTHITLO2	.long	KTHITLO2A,KTHITLO2B,0
KTHITLO3	.long	KTHITLO3A,KTHITLO3B,0

;***********************************************************************

a_fngetup
	.long	KTGETTUP1
	.long	KTGETTUP2
	.long	KTGETTUP3
	.long	KTGETTUP4
	.long	KTGETTUP5
	.long	0

KTGETTUP1
	.long	KTGETTUP1A,KTGETTUP1B,0
KTGETTUP2
	.long	KTGETTUP2A,KTGETTUP2B,0
KTGETTUP3
	.long	KTGETTUP3A,KTGETTUP3B,0
KTGETTUP4
	.long	KTGETTUP4A,0
KTGETTUP5
	.long	KTGETTUP5A,KTGETTUP5B,0

;***********************************************************************

a_fnduckhit
	.long	KTDUCKHIT2
	.long	KTDUCKHIT3
	.long	KTDUCKHIT2
	.long	KTDUCKHIT1
	.long	KTDUCK3
	.long	0

KTDUCKHIT1
	.long	KTDUCKHIT1A,KTDUCKHIT1B,0
KTDUCKHIT2
	.long	KTDUCKHIT2A,KTDUCKHIT2B,0
KTDUCKHIT3
	.long	KTDUCKHIT3A,KTDUCKHIT3B,0

;***********************************************************************

a_fnjumpupkick
	.long	KTJUMPKICK1
	.long	KTJUMPKICK2
	.long	0
	.long	KTJUMPKICK1
	.long	0

KTJUMPKICK1
	.long	KTJUMPKICK1A,0
KTJUMPKICK2
	.long	KTJUMPKICK2A,KTJUMPKICK2B,0

;***********************************************************************

a_fnflipkick
	.long	KTFLIPKICK1
	.long	KTFLIPKICK2
	.long	KTFLIPKICK3
	.long	0
	.long	KTFLIPKICK2
	.long	KTFLIPKICK1
	.long	0

	.long	KTFLIPKICK2
	.long	KTFLIPKICK1
	.long	0

KTFLIPKICK1
	.long	KTFLIPKICK1A,KTFLIPKICK1B,0
KTFLIPKICK2
	.long	KTFLIPKICK2A,KTFLIPKICK2B,0
KTFLIPKICK3
	.long	KTFLIPKICK3A,KTFLIPKICK4B,0

;***********************************************************************

a_fnflippunch
	.long	KTFLIPUNCH1
	.long	KTFLIPUNCH2
	.long	KTFLIPUNCH3
	.long	0
	.long	KTFLIPUNCH2
	.long	KTFLIPUNCH1
	.long	0

a_square_punch
	.long	KTFLIPUNCH1
	.long	KTFLIPUNCH2
	.long	KTSONYAPUNCH
	.long	0

KTSONYAPUNCH
	.long	KTSONYAPUNCH1A,KTSONYAPUNCH1B,KTSONYAPUNCH1C
	.long	KTSONYAPUNCH1D,0

KTFLIPUNCH1
	.long	KTFLIPUNCH1A,KTFLIPUNCH1B,KTFLIPUNCH1C,KTFLIPUNCH1D,0
KTFLIPUNCH2
	.long	KTFLIPUNCH2A,KTFLIPUNCH2B,KTFLIPUNCH2C,0
KTFLIPUNCH3
	.long	KTFLIPUNCH3A,KTFLIPUNCH3B,KTFLIPUNCH3C,0

;***********************************************************************

a_fnbodyslam
	.long	KTTHROW1	; grab !
	.long	0

	.long	KTTHROW2
	.long	KTTHROW3
	.long	KTTHROW4
	.long	KTTHROW5
	.long	KTTHROW6
	.long	0

	.long	KTTHROW5
	.long	KTTHROW4
	.long	KTTHROW3
	.long	KTTHROW2
	.long	0

KTTHROW1
	.long	KTTHROW1A,KTTHROW1B,0
KTTHROW2
	.long	KTTHROW2A,KTTHROW2B,KTTHROW2C,KTTHROW2D,0
KTTHROW3
	.long	KTTHROW3A,KTTHROW3B,KTTHROW3C,0
KTTHROW4
	.long	KTTHROW4A,KTTHROW4B,KTTHROW4C,0
KTTHROW5
	.long	KTTHROW5A,KTTHROW5B,KTTHROW5C,KTTHROW5D,0
KTTHROW6
	.long	KTTHROW6A,KTTHROW6B,KTTHROW6C,KTTHROW6D,0

;***********************************************************************

a_shredded
	.long	ani_adjustxy
	.word	6,6
	.long	KTSTUMBLE1

	.long	ani_adjustxy
	.word	-6,-6
	.long	KTSTUMBLE2

	.long	ani_adjustxy
	.word	6,6
	.long	KTSTUMBLE3

	.long	ani_adjustxy
	.word	-6,-6
	.long	KTSTUMBLE2
	.long	ani_jump,a_shredded

;***********************************************************************

a_fnprojectile
	.long	KTFANTHROW1
	.long	KTFANTHROW2
	.long	KTFANTHROW3
	.long	0
	.long	KTFANTHROW4
	.long	KTFANTHROW5
	.long	0

KTFANTHROW1
	.long	KTFANTHROW1A,KTFANTHROW1B,KTFANTHROW1C,0
KTFANTHROW2
	.long	KTFANTHROW2A,KTFANTHROW2B,KTFANTHROW2C,0
KTFANTHROW3
	.long	KTFANTHROW3A,KTFANTHROW3B,0
KTFANTHROW4
	.long	KTFANTHROW4A,KTFANTHROW4B,KTFANTHROW4C,0
KTFANTHROW5
	.long	KTFANTHROW5A,0

;***********************************************************************

a_fnairfan
	.long	KTAIRFAN1
	.long	KTAIRFAN2
	.long	0
	.long	KTAIRFAN3
	.long	KTAIRFAN4
	.long	0

KTAIRFAN1
	.long	KTAIRFAN1A,KTAIRFAN1B,KTAIRFAN1C,0
KTAIRFAN2
	.long	KTAIRFAN2A,KTAIRFAN2B,KTAIRFAN2C,0
KTAIRFAN4
	.long	KTAIRFAN4A,KTAIRFAN4B,KTAIRFAN4C,KTAIRFAN4D,0
KTAIRFAN3
	.long	KTAIRFAN3A,KTAIRFAN3B,KTAIRFAN3C,0

;***********************************************************************

a_fnthrow_sai
	.long	KTSAITHROW1
	.long	KTSAITHROW2
	.long	KTSAITHROW3
	.long	0

	.long	KTSAITHROW4
	.long	0

KTSAITHROW1
	.long	KTSAITHROW1A,KTSAITHROW1B,0
KTSAITHROW2
	.long	KTSAITHROW2A,KTSAITHROW2B,0
KTSAITHROW3
	.long	KTSAITHROW3A,KTSAITHROW3B,KTSAITHROW3C,0
KTSAITHROW4
	.long	KTSAITHROW4A,KTSAITHROW4B,0

a_fnthrow_sai_air
	.long	KTAIRSAI1
	.long	KTAIRSAI2
	.long	KTAIRSAI3
	.long	0

KTAIRSAI1
	.long	KTAIRSAI1A,KTAIRSAI1B,0
KTAIRSAI2
	.long	KTAIRSAI2A,KTAIRSAI2B,KTAIRSAI2C,0
KTAIRSAI3
	.long	KTAIRSAI3A,KTAIRSAI3B,KTAIRSAI3C,0

;***********************************************************************

a_fnsaifly
	.long	flysai1
	.long	flysai2
	.long	flysai3
	.long	flysai4
	.long	flysai5
	.long	flysai6
	.long	flysai7
	.long	0

	.long	flysai8
	.long	flysai9
	.long	flysai10
	.long	flysai11
	.long	flysai12
	.long	flysai13
	.long	flysai14
	.long	flysai15
	.long	flysai16
	.long	0

flysai1	.long	FLYSAI1,0
flysai2	.long	FLYSAI2,0
flysai3	.long	FLYSAI3,0
flysai4	.long	FLYSAI4,0
flysai5	.long	FLYSAI5,0
flysai6	.long	FLYSAI6,0
flysai7	.long	FLYSAI7,0
flysai8	.long	FLYSAI8,0
flysai9	.long	FLYSAI9,0
flysai10	.long	FLYSAI10,0
flysai11	.long	FLYSAI11,0
flysai12	.long	FLYSAI12,0
flysai13	.long	FLYSAI13,0
flysai14	.long	FLYSAI14,0
flysai15	.long	FLYSAI15,0
flysai16	.long	FLYSAI16,0

;***********************************************************************

a_fnfanfly
	.long	fans13
	.long	fans12
	.long	fans11
	.long	fans10
	.long	fans9
	.long	fans8
	.long	fans7
	.long	fans6
	.long	fans5
	.long	fans4
	.long	ani_jump,a_fnfanfly
	.long	0			; we need this

j_fanfast
	.long	fans13
	.long	fans11
	.long	fans9
	.long	fans7
	.long	fans5
	.long	ani_jump,j_fanfast
	.long	0			; we need this

;	.long	fans2
;	.long	fans3
;	.long	fans4			; fans openning up (too slow)

j_gfan	.long	fans13
	.long	fans12
	.long	fans11
	.long	fans10
	.long	fans9
	.long	fans8
	.long	fans7
	.long	fans6
	.long	fans5
	.long	fans4
	.long	ani_jump,j_gfan
	.long	0			; we need this
*
* fan closing ani
*
	.long	fans4
	.long	fans3
	.long	fans2
	.long	0


fans2	.long	FANS2,0
fans3	.long	FANS3,0
fans4	.long	FANS4,0

fans5	.long	FANS5,0
fans6	.long	FANS6,0
fans7	.long	FANS7,0
fans8	.long	FANS8,0
fans9	.long	FANS9,0
fans10	.long	FANS10,0
fans11	.long	FANS11,0
fans12	.long	FANS12,0
fans13	.long	FANS13,0

;***********************************************************************

a_fnstunned
	.long	KTSTUNNED1
	.long	KTSTUNNED2
	.long	KTSTUNNED3
	.long	KTSTUNNED4
	.long	KTSTUNNED5
	.long	KTSTUNNED6
	.long	KTSTUNNED7
	.long	ani_jump,a_fnstunned

KTSTUNNED1
	.long	KTSTUNNED1A,KTSTUNNED1B,0
KTSTUNNED2
	.long	KTSTUNNED2A,KTSTUNNED2B,0
KTSTUNNED3
	.long	KTSTUNNED3A,KTSTUNNED3B,0
KTSTUNNED4
	.long	KTSTUNNED4A,KTSTUNNED4B,0
KTSTUNNED5
	.long	KTSTUNNED5A,KTSTUNNED5B,0
KTSTUNNED6
	.long	KTSTUNNED6A,KTSTUNNED6B,0
KTSTUNNED7
	.long	KTSTUNNED7A,KTSTUNNED7B,0

;***********************************************************************

a_fn1victory
	.long	ani_ochar_jump
	.word	ft_fn2			; am I the female ninja #2 ??
	.long	a_fn2victory		; yes = do her victory then !

	.long	KT1VIC1
	.long	KT1VIC2
	.long	KT1VIC3
	.long	KT1VIC4
	.long	KT1VIC5

	.long	KT1VIC61
	.long	KT1VIC61
	.long	KT1VIC61
	.long	KT1VIC61
	.long	KT1VIC61

	.long	KT1VIC62
	.long	KT1VIC63
	.long	KT1VIC64

	.long	KT1VIC7
	.long	KT1VIC8
	.long	KT1VIC9
	.long	KT1VIC10
	.long	0

KT1VIC1	.long	KT1VICTORY1A,KT1VICTORY1B,0
KT1VIC2	.long	KT1VICTORY2A,KT1VICTORY2B,KT1VICTORYLEG1A,0
KT1VIC3	.long	KT1VICTORY3A,KT1VICTORY3B,KT1VICTORY3C,KT1VICTORYLEG1A,0
KT1VIC4	.long	KT1VICTORY4A,KT1VICTORY4B,KT1VICTORY4C,KT1VICTORY4D
	.long	KT1VICTORY4E,KT1VICTORYLEG1A,0
KT1VIC5 	.long	KT1VICTORY5A,KT1VICTORY5B,KT1VICTORY5C,KT1VICTORYLEG1A,0

KT1VIC61 .long	KT1VICTORY6A,KT1VICTORY6B,KT1VICTORYLEG1A,KT1VICTORYARM1A,0
KT1VIC62 .long	KT1VICTORY6A,KT1VICTORY6B,KT1VICTORYLEG1A,KT1VICTORYARM2A,0
KT1VIC63 .long	KT1VICTORY6A,KT1VICTORY6B,KT1VICTORYLEG1A,KT1VICTORYARM3A,0
KT1VIC64 .long	KT1VICTORY6A,KT1VICTORY6B,KT1VICTORYLEG1A,KT1VICTORYARM4A,0

KT1VIC7	.long	KT1VICTORY7A,0
KT1VIC8	.long	KT1VICTORY8A,0
KT1VIC9	.long	KT1VICTORY9A,0
KT1VIC10	.long	KT1VICTORY10A,0


a_fn2victory
	.long	KT1VIC1
	.long	KT1VIC2

	.long	ani_sound,0
	.long	KT2VIC11
	.long	KT2VIC12
	.long	ani_sound,1
	.long	KT2VIC13
	.long	KT2VIC14
	.long	ani_sound,2
	.long	KT2VIC15
	.long	KT2VIC16
	.long	ani_sound,3
	.long	KT2VIC17
	.long	KT2VIC18
	.long	ani_sound,1

	.long	KT2VIC2
	.long	KT2VIC3
	.long	KT2VIC4
	.long	0

KT2VIC11	.long	KT2VICTORY1A,KT2VARMRIGHT1A,KT2VARMLEFT1A,0
KT2VIC12	.long	KT2VICTORY1A,KT2VARMRIGHT2A,KT2VARMLEFT2A,0
KT2VIC13	.long	KT2VICTORY1A,KT2VARMRIGHT3A,KT2VARMLEFT3A,0
KT2VIC14	.long	KT2VICTORY1A,KT2VARMRIGHT4A,KT2VARMLEFT4A,0
KT2VIC15	.long	KT2VICTORY1A,KT2VARMRIGHT5A,KT2VARMLEFT5A,0
KT2VIC16	.long	KT2VICTORY1A,KT2VARMRIGHT6A,KT2VARMLEFT6A,0
KT2VIC17	.long	KT2VICTORY1A,KT2VARMRIGHT7A,KT2VARMLEFT7A,0
KT2VIC18	.long	KT2VICTORY1A,KT2VARMRIGHT8A,KT2VARMLEFT8A,0

KT2VIC2	.long	KT2VICTORY2A,KT2VICTORY2B,KT2VICTORY2C,0
KT2VIC3	.long	KT2VICTORY3A,KT2VICTORY3B,0
KT2VIC4	.long	KT2VICTORY4A,KT2VICTORY4B,0

;***********************************************************************

a_fn_fb_hh
	.long	ani_adjustxy
	.word	->38,8		; we need even # of words here !
	.long	KTSTUMBLE1
	.long	0

	.long	ani_flip
	.long	ani_adjustxy
	.word	>18,>00		; we need even # of words here !
	.long	KTSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>60,->30
	.long	KTGETFLIPPED2
	.long	KTGETFLIPPED3
	.long	KTGETFLIPPED4
	.long	0

a_fn_fb_lk
	.long	ani_adjustxy
	.word	->40,>00
	.long	KTSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>10,>00
	.long	KTGETFLIPPED1

	.long	ani_adjustxy
	.word	>18,>06
	.long	KTGETFLIPPED1

	.long	ani_adjustxy
	.word	>28,>00
	.long	KTGETFLIPPED2

	.long	ani_adjustxy
	.word	>40,->10
	.long	KTGETFLIPPED3

	.long	ani_adjustxy
	.word	>40,->10
	.long	KTGETFLIPPED4
	.long	0
*
* land on the ground
*
	.long	KTKNOCKDOWN5
	.long	KTKNOCKDOWN6
	.long	KTKNOCKDOWN5
	.long	KTKNOCKDOWN6
	.long	0



a_fn_fb_nj
	.long	ani_adjustxy
	.word	->40,>00
	.long	KTSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>04,>00
	.long	KTSTUMBLE1

	.long	ani_adjustxy
	.word	>18,>0a
	.long	KTGETFLIPPED2

	.long	ani_adjustxy
	.word	>20,>00
	.long	KTGETFLIPPED2

	.long	ani_adjustxy
	.word	>40,->10
	.long	KTGETFLIPPED3

	.long	ani_adjustxy
	.word	>40,->10
	.long	KTGETFLIPPED4
	.long	0
*
* land on the ground
*
	.long	KTKNOCKDOWN5
	.long	KTKNOCKDOWN6
	.long	KTKNOCKDOWN5
	.long	KTKNOCKDOWN6
	.long	0


a_fn_fb_jx
	.long	ani_adjustxy
	.word	->4b,>00
	.long	KTSTUMBLE1
	.long	KTSTUMBLE1
	.long	0

	.long	ani_adjustxy
	.word	>08,->40
	.long	KTGETFLIPPED1	; jax 3

	.long	ani_adjustxy
	.word	>2a,->08
	.long	KTGETFLIPPED2	; jax 4

	.long	ani_adjustxy
	.word	>3d,>0a
	.long	KTGETFLIPPED3	; jax 5

	.long	ani_adjustxy
	.word	>20,>38
	.long	KTGETFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	>00,>10
	.long	KTKNOCKDOWN6	; jax 7
	.long	0
*
* slammed again !
*
	.long	ani_adjustxy
	.word	>00,->10
	.long	KTGETFLIPPED4	; jax 6

	.long	ani_adjustxy
	.word	->10,->46
	.long	KTGETFLIPPED4	; jax 6

	.long	ani_flip
	.long	ani_adjustxy
	.word	>40,->10
	.long	KTGETFLIPPED3	; jax 4

	.long	ani_adjustxy
	.word	>34,>0d
	.long	KTGETFLIPPED4	; jax 3

	.long	ani_adjustxy
	.word	>10,>46
	.long	KTGETFLIPPED4

	.long	ani_adjustxy
	.word	->10,>10
	.long	KTKNOCKDOWN6	; jax 7
	.long	0


a_fn_fb_jc
	.long	ani_adjustxy
	.word	->30,>08
	.long	KTSTUMBLE3
	.long	KTSTUMBLE3
	.long	0

	.long	ani_adjustxy
	.word	>12,->38
	.long	KTGETFLIPPED2

	.long	ani_adjustxy
	.word	>58,>18
	.long	KTGETFLIPPED3

	.long	ani_adjustxy
	.word	>28,>48
	.long	KTGETFLIPPED4
	.long	0


a_fn_fb_sa
	.long	ani_adjustxy
	.word	->44,>00
	.long	KTSTUMBLE3
	.long	0

	.long	ani_adjustxy
	.word	>0a,->2a
	.long	KTGETFLIPPED1

	.long	ani_adjustxy
	.word	>2a,->10
	.long	KTGETFLIPPED2

	.long	ani_adjustxy
	.word	>3f,->10
	.long	KTGETFLIPPED3
	.long	0

;	.long	KTGETFLIPPED1
;	.long	KTGETFLIPPED2
;	.long	KTGETFLIPPED3
;	.long	KTGETFLIPPED4
;	.long	0


a_fn_fb_fn
	.long	ani_adjustxy
	.word	->42,->10
	.long	ani_flip
	.long	KTKNOCKDOWN1
	.long	0

	.long	ani_adjustxy
	.word	->20,->20
	.long	KTKNOCKDOWN2

	.long	ani_adjustxy
	.word	->38,->18
	.long	KTKNOCKDOWN3

	.long	ani_adjustxy
	.word	->38,>38
	.long	KTGETFLIPPED3

	.long	ani_adjustxy
	.word	->10,>20
	.long	KTGETFLIPPED3

	.long	ani_adjustxy
	.word	->10,>20
	.long	KTGETFLIPPED3
	.long	0
*
* bounce on ground
*
	.long	KTGETFLIPPED3
	.long	0


a_fn_fb_st
	.long	ani_adjustxy
	.word	->30,>00
	.long	KTSTUMBLE5
	.long	KTSTUMBLE5
	.long	0

	.long	ani_adjustxy
	.word	->08,->30
	.long	KTGETFLIPPED1
	.long	ani_adjustxy
	.word	>40,>00
	.long	KTGETFLIPPED2
	.long	ani_adjustxy
	.word	>30,>20
	.long	KTGETFLIPPED3
	.long	ani_adjustxy
	.word	>20,>28
	.long	KTGETFLIPPED4
	.long	0

	.long	ani_adjustxy
	.word	>20,>00
	.long	KTKNOCKDOWN6
	.long	0


;*********************************************************************

a_fn_fb_rd
	.long	ani_adjustxy
	.word	->42,>00
	.long	KTSTUMBLE5
	.long	0

	.long	ani_adjustxy
	.word	>00,->2f
	.long	KTGETFLIPPED1

	.long	ani_flip_v
	.long	ani_adjustxy
	.word	>34,>50
	.long	KTGETFLIPPED2
	.long	KTGETFLIPPED2

	.long	ani_adjustxy
	.word	>0a,>40
	.long	KTGETFLIPPED2

	.long	ani_adjustxy
	.word	>38,>40
	.long	KTGETFLIPPED2
	.long	0

	.long	ani_adjustxy
	.word	>18,>10
	.long	ani_flip
	.long	KTKNOCKDOWN6
	.long	0


;*********************************************************************

a_banged
	.long	KTGETFLIPPED1
	.long	KTGETFLIPPED2
	.long	KTGETFLIPPED3
	.long	KTGETFLIPPED4
	.long	0

KTGETFLIPPED1
	.long	KTGETFLIPPED1A,KTGETFLIPPED1B,KTGETFLIPPED1C,0
KTGETFLIPPED2
	.long	KTGETFLIPPED2A,KTGETFLIPPED2B,KTGETFLIPPED2C,KTGETFLIPPED2D,0
KTGETFLIPPED3
	.long	KTGETFLIPPED3A,KTGETFLIPPED3B,0
KTGETFLIPPED4
	.long	KTGETFLIPPED4A,KTGETFLIPPED4B,0

;***********************************************************************

a_nutcrunched

;***********************************************************************

a_bike_kicked
	.long	KTSTUMBLE1
	.long	KTSTUMBLE2
	.long	KTSTUMBLE3
	.long	KTSTUMBLE4
	.long	KTSTUMBLE5
	.long	ani_jump,a_bike_kicked

;***********************************************************************

a_spinfan
	.long	KTFANSPIN1
	.long	KTFANSPIN2
	.long	KTFANSPIN3
	.long	0

KTFANSPIN1
	.long	KTFANSPIN1A,KTFANSPIN1B,0
KTFANSPIN2
	.long	KTFANSPIN2A,KTFANSPIN2B,0
KTFANSPIN3
	.long	KTFANSPIN3A,KTFANSPIN3B,KTFANSPIN3C,0

;*************************************************************************

a_spinwave
	.long	WAVE1
	.long	WAVE2
	.long	WAVE3
	.long	WAVE4
	.long	WAVE5
	.long	WAVE6
	.long	WAVE7
	.long	WAVE8
	.long	WAVE9
	.long	WAVE10
	.long	0

;*************************************************************************

a_fn2_stab
	.long	KTSAISTAB2

	.long	KTSAISTAB1
	.long	KTSAISTAB2
	.long	KTSAISTAB3
	.long	KTSAISTAB4
	.long	KTSAISTAB5
	.long	KTSAISTAB6
	.long	KTSAISTAB7
	.long	KTSAISTAB6
	.long	KTSAISTAB5
	.long	KTSAISTAB4
	.long	KTSAISTAB3
	.long	KTSAISTAB2
	.long	ani_jump,a_fn2_stab+32

KTSAISTAB1
	.long	KTSAISTAB1A,KTSAISTAB1B,KTSAISTAB1C,0
KTSAISTAB2
	.long	KTSAISTAB2A,KTSAISTAB2B,KTSAISTAB2C,0
KTSAISTAB3
	.long	KTSAISTAB3A,KTSAISTAB3B,KTSAISTAB3C,0
KTSAISTAB4
	.long	KTSAISTAB4A,KTSAISTAB4B,KTSAISTAB4C,0
KTSAISTAB5
	.long	KTSAISTAB5A,KTSAISTAB5B,KTSAISTAB5C,0
KTSAISTAB6
	.long	KTSAISTAB6A,KTSAISTAB6B,KTSAISTAB6C,0
KTSAISTAB7
	.long	KTSAISTAB7A,KTSAISTAB7B,KTSAISTAB7C,0

;*************************************************************************

a_fan_swipe
	.long	KTFANSWIPE1
	.long	KTFANSWIPE1
	.long	KTFANSWIPE2
	.long	KTFANSWIPE3
	.long	KTFANSWIPE4
	.long	ani_nosleep	; dont sleep after next frame
	.long	KTFANSWIPE5
	.long	0

	.long	KTFANSWIPE6
	.long	KTFANSWIPE6
	.long	0

KTFANSWIPE1
	.long	KTFANSWIPE1A,KTFANSWIPE1B,0
KTFANSWIPE2
	.long	KTFANSWIPE2A,KTFANSWIPE2B,0
KTFANSWIPE3
	.long	KTFANSWIPE3A,KTFANSWIPE3B,0
KTFANSWIPE4
	.long	KTFANSWIPE4A,KTFANSWIPE4B,KTFANSWIPE4C,0
KTFANSWIPE5
	.long	KTFANSWIPE5A,KTFANSWIPE5B,KTFANSWIPE5C,0
KTFANSWIPE6
	.long	KTFANSWIPE6A,KTFANSWIPE6B,0

;*************************************************************************

a_death_kiss1
	.long	KTDETHKISS1
	.long	KTDETHKISS2
	.long	KTDETHKISS3
	.long	0

	.long	KTDETHKISS4
	.long	KTDETHKISS5
	.long	KTDETHKISS6
	.long	0

	.long	KTDETHKISS7
	.long	KTDETHKISS8
	.long	KTDETHKISS9
	.long	KTDETHKISS10
	.long	KTDETHKISS11
	.long	KTDETHKISS12
	.long	KTDETHKISS13
	.long	0
*
* put yer leg back down
*
	.long	KTDETHKISS13
	.long	KTDETHKISS12
	.long	KTDETHKISS11
	.long	KTDETHKISS10
	.long	KTDETHKISS9
	.long	KTDETHKISS8
	.long	KTDETHKISS7
	.long	KTDETHKISS6
	.long	KTDETHKISS5
	.long	KTDETHKISS4
	.long	0

KTDETHKISS1
	.long	KTDETHKISS1A,KTDETHKISSLEG1A,KTDETHKISSLEG1B,0
KTDETHKISS2
	.long	KTDETHKISS2A,KTDETHKISSLEG1A,KTDETHKISSLEG1B,0
KTDETHKISS3
	.long	KTDETHKISS3A,KTDETHKISSLEG1A,KTDETHKISSLEG1B,0
KTDETHKISS4
	.long	KTDETHKISS4A,KTDETHKISS4B,0
KTDETHKISS5
	.long	KTDETHKISS5A,KTDETHKISS5B,KTDETHKISS5C,0
KTDETHKISS6
	.long	KTDETHKISS6A,KTDETHKISS6B,KTDETHKISS6C,0
KTDETHKISS7
	.long	KTDETHKISS7A,KTDETHKISS7B,KTDETHKISS7C,0
KTDETHKISS8
	.long	KTDETHKISS8A,KTDETHKISS8B,KTDETHKISS8C,0
KTDETHKISS9
	.long	KTDETHKISS9A,KTDETHKISS9B,KTDETHKISS9LEG1,0
KTDETHKISS10
	.long	KTDETHKISS9A,KTDETHKISS9B,KTDETHKISS9LEG2,0
KTDETHKISS11
	.long	KTDETHKISS9A,KTDETHKISS9B,KTDETHKISS9LEG3,0
KTDETHKISS12
	.long	KTDETHKISS9A,KTDETHKISS9B,KTDETHKISS9LEG4,0
KTDETHKISS13
	.long	KTDETHKISS9A,KTDETHKISS9B,KTDETHKISS9LEG5,0


a_death_kiss2
	.long	UGLYKISS1
	.long	UGLYKISS2
	.long	UGLYKISS3
	.long	0

	.long	UGLYKISS4
	.long	UGLYKISS5
	.long	UGLYKISS6
	.long	0

	.long	UGLYKISS7
	.long	UGLYKISS8
	.long	UGLYKISS9
	.long	UGLYKISS10
	.long	UGLYKISS11
	.long	UGLYKISS12
	.long	UGLYKISS13
	.long	0
*
* put yer leg back down
*
	.long	UGLYKISS13
	.long	UGLYKISS12
	.long	UGLYKISS11
	.long	UGLYKISS10
	.long	UGLYKISS9
	.long	UGLYKISS8
	.long	UGLYKISS7
	.long	0

	.long	UGLYKISS3
	.long	UGLYKISS2
	.long	UGLYKISS1
	.long	0

UGLYKISS1
	.long	KTDETHKISS1A,KTDETHKISSLEG1A,KTDETHKISSLEG1B,0
UGLYKISS2
	.long	KTDETHKISS2A,KTDETHKISSLEG1A,KTDETHKISSLEG1B,0
UGLYKISS3
	.long	KTDETHKISS3A,KTDETHKISSLEG1A,KTDETHKISSLEG1B
	.long	KTUGHEAD1,0
UGLYKISS4
	.long	KTDETHKISS4A,KTDETHKISS4B
	.long	KTUGHEAD2,0
UGLYKISS5
	.long	KTDETHKISS5A,KTDETHKISS5B,KTDETHKISS5C
	.long	KTUGHEAD3,0
UGLYKISS6
	.long	KTDETHKISS6A,KTDETHKISS6B,KTDETHKISS6C
	.long	KTUGHEAD4,0
UGLYKISS7
	.long	KTDETHKISS7A,KTDETHKISS7B,KTDETHKISS7C
	.long	KTUGHEAD5,0
UGLYKISS8
	.long	KTDETHKISS8A,KTDETHKISS8B,KTDETHKISS8C
	.long	KTUGHEAD6,0
UGLYKISS9
	.long	KTDETHKISS9A,KTDETHKISS9B,KTDETHKISS9LEG1
	.long	KTUGHEAD7,0
UGLYKISS10
	.long	KTDETHKISS9A,KTDETHKISS9B,KTDETHKISS9LEG2
	.long	KTUGHEAD7,0
UGLYKISS11
	.long	KTDETHKISS9A,KTDETHKISS9B,KTDETHKISS9LEG3
	.long	KTUGHEAD7,0
UGLYKISS12
	.long	KTDETHKISS9A,KTDETHKISS9B,KTDETHKISS9LEG4
	.long	KTUGHEAD7,0
UGLYKISS13
	.long	KTDETHKISS9A,KTDETHKISS9B,KTDETHKISS9LEG5
	.long	KTUGHEAD7,0

;*************************************************************************

a_drained
	.long	ani_adjustxy
	.word	->3c,->13
	.long	KTHITHI3
	.long	0

	.long	ani_adjustxy
	.word	->20,>15
	.long	FNDRAIN0
	.long	ani_adjustxy
	.word	>13,->08
	.long	FNDRAIN0
	.long	ani_adjustxy
	.word	>08,->14
	.long	FNDRAIN0
	.long	ani_adjustxy
	.word	>08,>08
	.long	FNDRAIN0

	.long	0

;******************************************************************

a_impaled
	.long	ani_adjustxy
	.word	->60,>00
	.long	KTIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	KTIMPALED1

	.long	ani_adjustxy
	.word	>00,->18
	.long	KTIMPALED1

	.long	ani_adjustxy
	.word	>10,->18
	.long	KTIMPALED1

	.long	0
*
* suffering (that's Christmas)
*
	.long	KTIMPALED1
	.long	KTIMPALED2
	.long	KTIMPALED3

	.long	KTIMPALED2
	.long	KTIMPALED1
	.long	KTIMPALED2
	.long	KTIMPALED3
	.long	0


KTIMPALED1
	.long	KTIMPALED1A,KTIMPALED1B,0
KTIMPALED2
	.long	KTIMPALED2A,KTIMPALED2B,0
KTIMPALED3
	.long	KTIMPALED3A,KTIMPALED3B,KTIMPALED3C,0

;******************************************************************

a_torso_ripped
	.long	ani_adjustxy
	.word	->43,>00
	.long	KTSTUMBLE3
	.long	0

	.long	ani_calla,change_to_bloody_pal	; switch to bloody pal
	.long	KTRIPTORSO1

	.long	ani_adjustxy
	.word	>18,->20
	.long	KTRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>00,>08
	.long	KTRIPTORSO2
	.long	0

	.long	ani_adjustxy
	.word	>30,>20
	.long	KTRIPTORSO2

	.long	ani_adjustxy
	.word	>30,>40
	.long	KTRIPTORSO2
	.long	0

	.long	KTRIPTORSO6
	.long	KTRIPTORSO6
	.long	0
*
* standing legz
*
	.long	KTDECAPLEG1		; legz
	.long	0

KTRIPTORSO1
	.long	KTRIPTORSO1A,KTRIPTORSO1B,0
KTRIPTORSO2
	.long	KTRIPTORSO2A,KTRIPTORSO2B,0
KTRIPTORSO3
	.long	KTRIPTORSO3A,KTRIPTORSO3B,0
KTRIPTORSO4
	.long	KTRIPTORSO4A,KTRIPTORSO4B,KTRIPTORSO4C,0
KTRIPTORSO5
	.long	KTRIPTORSO5A,KTRIPTORSO5B,KTRIPTORSO5C,0
KTRIPTORSO6
	.long	KTRIPTORSO6A,KTRIPTORSO6B,0


a_swipe_torso
	.long	KTRIPTORSO1
	.long	KTRIPTORSO2
	.long	KTRIPTORSO3
	.long	KTRIPTORSO4
	.long	KTRIPTORSO5
	.long	KTRIPTORSO6
	.long	0

;******************************************************************

a_head
	.long	KTDECAPHEAD1
	.long	KTDECAPHEAD2
	.long	KTDECAPHEAD3
	.long	KTDECAPHEAD4
	.long	KTDECAPHEAD5
	.long	KTDECAPHEAD7
	.long	KTDECAPHEAD8
	.long	KTDECAPHEAD9
	.long	KTDECAPHEAD10
	.long	ani_jump,a_head


a_decapfall
	.long	KTDECAP1
	.long	KTDECAP2
	.long	KTDECAP3	; on knees
	.long	0
*
* wobble on yer knees
*
	.long	KTDECAP4
	.long	KTDECAP3
	.long	KTDECAP4
	.long	KTDECAP3
	.long	KTDECAP4
	.long	KTDECAP3
	.long	0
*
* fall to ground
*
	.long	KTDECAP4
	.long	KTDECAP5
	.long	KTDECAP6
	.long	KTDECAP7
	.long	0



KTDECAP1
	.long	KTDECAPLEG1A
	.long	KTDECAPTORSO1A,0
KTDECAP2
	.long	KTDECAPLEG2A
	.long	KTDECAPTORSO2A,0
KTDECAP3
	.long	KTDECAPLEG3A,KTDECAPLEG3B
	.long	KTDECAPTORSO3A,0
KTDECAP4
	.long	KTDECAPLEG4A,KTDECAPLEG4B
	.long	KTDECAPTORSO4A,0
KTDECAP5
	.long	KTDECAPLEG5A,KTDECAPLEG5B
	.long	KTDECAPTORSO5A,0
KTDECAP6
	.long	KTDECAPLEG6A,KTDECAPLEG6B
	.long	KTDECAPTORSO6A,KTDECAPTORSO6B,0
KTDECAP7
	.long	KTDECAPLEG7A,KTDECAPLEG7B
	.long	KTDECAPTORSO7A,0

KTDECAPLEG1
	.long	KTDECAPLEG1A,0
;KTDECAPLEG2
;	.long	KTDECAPLEG2A,0
;KTDECAPLEG3
;	.long	KTDECAPLEG3A,KTDECAPLEG3B,0
;KTDECAPLEG4
;	.long	KTDECAPLEG4A,KTDECAPLEG4B,0
;KTDECAPLEG5
;	.long	KTDECAPLEG5A,KTDECAPLEG5B,0
;KTDECAPLEG6
;	.long	KTDECAPLEG6A,KTDECAPLEG6B,0
;KTDECAPLEG7
;	.long	KTDECAPLEG7A,KTDECAPLEG7B,0
;KTDECAPTORSO1
;	.long	KTDECAPTORSO1A,0
;KTDECAPTORSO2
;	.long	KTDECAPTORSO2A,0
;KTDECAPTORSO3
;	.long	KTDECAPTORSO3A,0
;KTDECAPTORSO4
;	.long	KTDECAPTORSO4A,0
;KTDECAPTORSO5
;	.long	KTDECAPTORSO5A,0
;KTDECAPTORSO6
;	.long	KTDECAPTORSO6A,KTDECAPTORSO6B,0
;KTDECAPTORSO7
;	.long	KTDECAPTORSO7A,0


a_back_broke
	.long	KTBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>0a
	.long	KTBACKBREAK1
	.long	ani_adjustxy
	.word	>00,>30
	.long	KTBACKBREAK1
	.long	KTBACKBREAK2
	.long	KTBACKBREAK3
	.long	0
	.long	KTBACKBREAK2
	.long	KTBACKBREAK1
	.long	0

KTBACKBREAK1
	.long	KTBACKBREAK1A,KTBACKBREAK1B,KTBACKBREAK1C,KTBACKBREAK1D
	.long	0
KTBACKBREAK2
	.long	KTBACKBREAK2A,KTBACKBREAK2B,KTBACKBREAK2C,KTBACKBREAK2D
	.long	KTBACKBREAK2E,0
KTBACKBREAK3
	.long	KTBACKBREAK3A,KTBACKBREAK3B,KTBACKBREAK3C,KTBACKBREAK3D
	.long	KTBACKBREAK3E,0

;***********************************************************************

a_fb_goro
	.long	ani_adjustxy
	.word	->60,->20
	.long	KTSTUMBLE3

	.long	ani_adjustxy
	.word	>10,->70
	.long	KTKNOCKDOWN6

	.long	ani_adjustxy
	.word	>20,>00
	.long	KTKNOCKDOWN6

	.long	ani_adjustxy
	.word	>3a,>20
	.long	KTKNOCKDOWN5

	.long	ani_adjustxy
	.word	>38,>10
	.long	KTKNOCKDOWN5

	.long	ani_adjustxy
	.word	>00,>68
	.long	KTKNOCKDOWN6

	.long	0

;***********************************************************************

a_spit_bones
	.long	KTSPITBONES1
	.long	KTSPITBONES2
	.long	KTSPITBONES3
	.long	KTSPITBONES4
	.long	KTSPITBONES5
	.long	KTSPITBONES6
	.long	KTSPITBONES7
	.long	0

	.long	KTSPITBONES6
	.long	KTSPITBONES5
	.long	KTSPITBONES4
	.long	UGLYKISS3
	.long	UGLYKISS2
	.long	UGLYKISS1
	.long	0

KTSPITBONES1
	.long	KTSPITBONES1A,KTSPITBONES1B,KTSPITBONES1C,0
KTSPITBONES2
	.long	KTSPITBONES2A,KTSPITBONES2B,0
KTSPITBONES3
	.long	KTSPITBONES3A,KTSPITBONES3B,0
KTSPITBONES5
	.long	KTSPITBONES5A,KTSPITBONES5B,0
KTSPITBONES6
	.long	KTSPITBONES6A,KTSPITBONES6B,0
KTSPITBONES7
	.long	KTSPITBONES7A,KTSPITBONES7B,0
KTSPITBONES4
	.long	KTSPITBONES4A,KTSPITBONES4B,0



	.end
