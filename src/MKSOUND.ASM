**************************************************************************
*												*
*  video game project:	  mortal kombat 2							*
*												*
*  programmer:		  ed boon								*
*												*
*  module: sound processor									*
*												*
*  copyright (c) 1993 midway manufacturing							*
*												*
**************************************************************************
	.width	132
	.option	b,d,l,t
	.mnolist

	.include	mainequ.asm
	.include	sysequ.asm 	; sys.inc and gsp.inc
	.include	macros.hdr
	.include	dispequ.asm

	.text

send	.set	>0001			; script command --> send sound code
setpri	.set	>0002			; script command --> set priority
endtune	.set	>0003			; script command --> end of tune script
sleep	.set	>0004			; script command --> sleep next byte
send2	.set	>0005

sndpri	.set	0			; priority offset
snddur	.set	10h			; duration offset
sndscp	.set	20h			; script pointer offset

ex	.set	>8000			; flag: extended sound call !!

	.bss	chan1ram,0,1
	.bss	chan1pri,16,1		; sound channel #1 priority
	.bss	chan1dur,16,1		; sound channel #1 duration (timer)
	.bss	chan1scp,32,1		; sound channel #1 script pointer

	.bss	chan2pri,16,1		; sound channel #2 priority
	.bss	chan2dur,16,1		; sound channel #2 duration (timer)
	.bss	chan2scp,32,1		; sound channel #2 script pointer

	.bss	chan3pri,16,1		; sound channel #3 priority
	.bss	chan3dur,16,1		; sound channel #3 duration (timer)
	.bss	chan3scp,32,1		; sound channel #3 script pointer

	.bss	chan4pri,16,1		; sound channel #4 priority
	.bss	chan4dur,16,1		; sound channel #4 duration (timer)
	.bss	chan4scp,32,1		; sound channel #4 script pointer

**************************************************************************
*												*
*	these strobe equates are for the pinball sound card			*
*												*
**************************************************************************
resetbit		equ	0fe00h	;this is the reset bit
musicbit		equ	0fd00h	;this is the yamaha side strobe

sp_minor1	.set	>05*>100		; minor sound #1

sp_cursor	.set	>06*>100		; cursor move
sp_select	.set	>07*>100		; player chosen sound
sp_joinin	.set	>08*>100		; player joined in

sp_woosh1	.set	>10*>100		; attack whoosh 1
sp_woosh2	.set	>12*>100		; attack whoosh 2
sp_woosh3	.set	>14*>100		; attack whoosh 3

sp_splish	.set	>16*>100		; blood splish

sp_attkv1	.set	>20*>100		; attack voice
sp_attkv2	.set	>22*>100		; attack voice
sp_attkv3	.set	>24*>100		; attack voice

sp_smlfx		.set	>2a*>100		; small special effect
sp_reacv1	.set	>30*>100		; react voice
sp_reacv2	.set	>32*>100		; react voice
sp_reacv3	.set	>34*>100		; react voice

sp_smack1	.set	>40*>100		; smack !!
sp_smack2	.set	>42*>100		; smack !!
sp_ground	.set	>43*>100		; land on ground
sp_smack3	.set	>44*>100		; BIG smack !!

sp_effect	.set	>50*>100		; special effect sound !
sp_bikeyl	.set	>52*>100		; bike kick yell
sp_crowd1	.set	>53*>100		; crowd
sp_scorpv	.set	>54*>100		; scorpion: get over here / come here
sp_gorov1	.set	>55*>100		; kintaro voice
sp_pitdie	.set	>58*>100		; falling down the pit voice

sp_death1	.set	>60*>100		; death voice
sp_victsp	.set	>61*>100		; victory speech
sp_double	.set	>68*>100		; double voice sound
sp_bossv1	.set	>70*>100		; boss dudes voice #1
sp_bossv2	.set	>71*>100		; boss dudes voice #2

sp_bighit	.set	>75*>100		; big hit sound
sp_splash	.set	>76*>100		; green splash


***************** KEEP ALL OF THESE INDIVIDUALIZED **********************
***************** KEEP ALL OF THESE INDIVIDUALIZED **********************
***************** KEEP ALL OF THESE INDIVIDUALIZED **********************

sp_reporb	.set	>61*>100		; reptile orb

**************************************************************************
*											     *
*    TRIPLE SOUND TABLE format:								     *
* 											     *
*              .word   >aaaa,>bbbb							     *
* 											     *
*       where:  aaaa = priority / duration						     *
*               bbbb = channel 1 sound call					     *
*											     *
**************************************************************************
triple_sndtab
	.word	sp_woosh1|18,>85	;  0 = small whoosh #1
	.word	sp_woosh1|16,>88	;  1 = small whoosh #2
	.word	sp_woosh1|23,>8b	;  2 = small whoosh #3
	.word	sp_woosh1|20,>8e	;  3 = small whoosh #4
	.word	sp_woosh1|20,>82	;  4 = DEEP whoosh

	.word	sp_attkv1|43,>300	;  5 = kang throw speech #1
	.word	sp_attkv1|31,>315	;  6 = kang throw speech #1

	.word	sp_attkv1|16,>28a	;  7 = jon hey fast attack #1
	.word	sp_attkv1|16,>28d	;  8 = jon hey fast attack #2
	.word	sp_attkv1|16,>28a	;  9 = jon hey fast attack #1
	.word	sp_attkv1|16,>28d	;  a = jon hey fast attack #2
	.word	sp_attkv1|16,>2ee	;  b	= kang fast attack #1
	.word	sp_attkv1|16,>2f1	;  c	= kang fast attack #2
	.word	sp_attkv1|16,>2bc	;  d = female fast attack #1 
	.word	sp_attkv1|16,>2bf	;  e = female fast attack #2
	.word	sp_bikeyl|87,>2fa	;  f = kang super kick yell !!
	.word	sp_bikeyl|128,>2f4	; 10 = kang bike kick yell !!
	.word	sp_bikeyl|75,>2f7	; 11 = kang super kick yell #2

	.word	sp_smack1|25,>79	; 12 = face hit #1
	.word	sp_smack1|18,>7c	; 13 = face hit #2
	.word	sp_smack1|16,>73	; 14 = body hit #1
	.word	sp_smack1|18,>76	; 15 = body hit #2
	.word	sp_smack1|15,>6d	; 16 = block #1
	.word	sp_smack1|14,>70	; 17 = block #2
	.word	sp_smack1|16,>6a	; 18 = BIG block sound
	.word	sp_bighit|16,>64	; 19 = BIG smack #1
	.word	sp_smack3|16,>67	; 1a = BIG smack #2
	.word	sp_bighit|45,>c1	; 1b = MK 1 uppercut smack #1
	.word	sp_bighit|43,>c4	; 1c = MK 1 uppercut smack #2
	.word	sp_smack3|43,>1ce	; 1d = getting nut crunched by cage

	.word	sp_minor1|10,>c7	; 1e = feet landing on ground

	.word	sp_ground|>10,>94	; 1f = land on ground #1
	.word	sp_ground|>10,>97	; 20 = land on ground #2
	.word	sp_ground|>10,>ac	; 21 = land on ground #3
	.word	sp_ground|>10,>af	; 22 = land on ground #4

	.word	sp_reacv1|20,>26a	; 23 = forden hit voice #1
	.word	sp_reacv1|20,>26d	; 24 = forden hit voice #2
	.word	sp_reacv1|20,>270	; 25 = forden hit voice #3
	.word	sp_reacv1|20,>29c	; 26 = jon hey hit voice #1
	.word	sp_reacv1|20,>29f	; 27 = jon hey hit voice #2
	.word	sp_reacv1|20,>2a2	; 28 = jon hey hit voice #3
	.word	sp_reacv1|20,>303	; 29 = liu kang hit voice #1
	.word	sp_reacv1|20,>306	; 2a = liu kang hit voice #2
	.word	sp_reacv1|20,>303	; 2b = liu kang hit voice #3 (same as 1)
	.word	sp_reacv1|20,>2ce	; 2c = female hit voice #1
	.word	sp_reacv1|20,>2d1	; 2d = female hit voice #2
	.word	sp_reacv1|20,>2d4	; 2e = female hit voice #3 (same as 1)

	.word	sp_attkv3|100,>eb	; 2f	= lk death blow yell
	.word	sp_attkv1|31,>ee	; 30 = db kick voice #1
	.word	sp_attkv1|55,>f1	; 31	= db kick voice #2

	.word	sp_reacv3|89,>273	; 32 = forden wasted voice #1
	.word	sp_reacv3|47,>276	; 33 = forden wasted voice #2
	.word	sp_reacv3|94,>2a5	; 34 = jon hey wasted voice #1
	.word	sp_reacv3|93,>2a8	; 35 = jon hey wasted voice #2
	.word	sp_reacv3|84,>309	; 36 = kang wasted voice #1
	.word	sp_reacv3|91,>30c	; 37 = kang wasted voice #2
	.word	sp_reacv3|37,>2d7	; 38 = female wasted voice #1
	.word	sp_reacv3|92,>2da	; 39 = female wasted voice #2
	.word	sp_victsp|87,>e8	; 3a = kang victory "ooooo" speech
	.word	sp_attkv1|76,>f4	; 3b	= lk db upcut
	.word	sp_reacv1|20,>261	; 3c = tripped voice player 1
	.word	sp_reacv1|20,>293	; 3d = tripped voice player 2

	.word	sp_attkv2|16,>264	; 3e = grab
	.word	sp_attkv2|16,>296	; 3f = grab
	.word	sp_attkv2|16,>267	; 40 = throw
	.word	sp_attkv2|16,>299	; 41 = throw

	.word	sp_effect|39,>12f	; 42 = swords ejecting
	.word	sp_effect|67,>12c	; 43 = shadow kick sound
	.word	sp_effect|39,>132	; 44 = sword plunge

	.word	sp_death1|56,>279	; 45 = forden death voice
	.word	sp_death1|150,>2ab	; 46 = jon hey death voice
	.word	sp_death1|71,>30c	; 47 = kang death voice
	.word	sp_death1|124,>2dd	; 48 = female death voice

	.word	sp_effect|63,>135	; 49 = throw fans
	.word	sp_effect|26,>138	; 4a = fans hit
	.word	sp_effect|20,>13b	; 4b = fans blocked
	.word	sp_effect|87,>13e	; 4c = throw snot 
	.word	sp_effect|33,>141	; 4d = snot hit
	.word	sp_effect|29,>144	; 4e = snot blocked
	.word	sp_effect|63,>147	; 4f = throw tsai
	.word	sp_effect|31,>14a	; 50 = tsai hit
	.word	sp_effect|29,>14d	; 51 = tsai blocked
	.word	sp_effect|38,>162	; 52 = throw hat
	.word	sp_effect|31,>165	; 53 = hat hit 
	.word	sp_effect|29,>168	; 54 = hat blocked
	.word	sp_bighit|66,>a6	; 55 = speared by scorpion
	.word	sp_bighit|35,>9d	; 56 = some sorta crunch

	.word	sp_effect|90,>17a	; 57 = raiden throw lightning
	.word	sp_effect|53,>17d	; 58 = lightning hit
	.word	sp_effect|24,>180	; 59 = lightning blocked
	.word	sp_effect|88,>183	; 5a = raiden fry other guy
	.word	sp_effect|40,>19e	; 5b = raiden teleport
	.word	sp_effect|55,>1a1	; 5c = raiden getup
	.word	sp_effect|33,>1ad	; 5d = subzero slide sound
	.word	sp_effect|71,>186	; 5e = fan sonic trap spell sound
	.word	sp_effect|81,>1d1	; 5f = raiden dive hit
	.word	sp_effect|24,>18f	; 60 = kiss smooch

	.word	sp_effect|63,>192	; 61 = lk fireball fire
	.word	sp_effect|52,>195	; 62 = lk fireball hit
	.word	sp_effect|25,>198	; 63 = lk fireball block

	.word	sp_effect|70,>159	; 64 = throw scorpion spear
	.word	sp_bighit|66,>15c	; 65 = scorpion spear hit
	.word	sp_effect|20,>15f	; 66 = scorpion spear blocked

	.word	sp_reporb|24,>1b3	; 67 = slow proj fire
	.word	sp_effect|62,>1cb	; 68 = slow proj hit
	.word	sp_effect|25,>198	; 69 = slow proj block
	.word	sp_effect|76,>1c5	; 6a = subzero throw ice
	.word	sp_effect|29,>1b0	; 6b = shadow elbow

	.word	sp_reacv1|20,>2c5	; 6c = tripped voice player 1
	.word	sp_attkv2|18,>2c8	; 6d = grab (girl)
	.word	sp_attkv2|33,>2cb	; 6e = throw (girl)

	.word	sp_attkv2|82,>150	; 6f = reptile spit
	.word	sp_effect|20,>153	; 70 = spit hit
	.word	sp_effect|20,>156	; 71 = spit block
	.word	sp_effect|11,>218	; 72 = time's running out tick

	.word	sp_splish|17,>203	; 73 = splish
	.word	sp_splish|14,>206	; 74 = splish
	.word	sp_splish|20,>209	; 75 = splish

	.word	sp_effect|81,>1a4	; 76 = skull scream
	.word	sp_effect|58,>1a7	; 77 = skull hit
	.word	sp_effect|25,>1aa	; 78 = skull block

	.word	sp_attkv3|72,>2ae	; 79 = raiden ---> bbb
	.word	sp_attkv3|78,>2b1	; 7a = raiden ---> sss
	.word	sp_attkv3|64,>2b4	; 7b = raiden ---> ttt
	.word	sp_attkv3|64,>2b7	; 7c = raiden ---> ngbas

	.word	sp_scorpv|72,>338	; 7d = scorpion ---> come here
	.word	sp_scorpv|72,>33b	; 7e = scorpion ---> get over here

	.word	sp_reacv3|100,>3d4	; 7f = sliding on ice
	.word	sp_reacv3|100,>3d7	; 80 = sliding on ice
	.word	sp_reacv3|100,>3da	; 81 = sliding on ice
	.word	sp_effect|25,>1c2	; 82 = pee
	.word	sp_smlfx|40,>19b	; 83 = lk superkick whoosh
	.word	sp_attkv3|72,>40e	; 84 = reptile: "Yum"
	.word	sp_death1|128,>27c	; 85 = disturbing death

	.word	sp_smlfx|35,>1d4	; 86 = teleport scorpion style
	.word	sp_smlfx|49,>1d7	; 87 = teleport kung lao style
	.word	sp_smlfx|53,>1da	; 88 = teleport malena style
	.word	sp_attkv2|36,>32f	; 89 = jax: gotcha !

	.word	sp_effect|53,>1e0	; 8a = baraka throw sparks
	.word	sp_effect|66,>1e3	; 8b = baraka spark hit
	.word	sp_effect|12,>1e6	; 8c = baraka spark blocked

	.word	sp_effect|43,>1dd	; 8d = shang morph

	.word	sp_attkv2|183,>33e	; 8e = kang dragon roar
	.word	sp_double|62,>3e8	; 8f = throw fans (DOUBLE)
	.word	sp_effect|62,>40b	; 90 = exploding dude

	.word	sp_effect|120,>10f	; 91 = scorpion take off mask
	.word	sp_effect|45,>112	; 92 = scorpion spit flame
	.word	sp_effect|160,>115	; 93 = scorpion flame scortch (big)

	.word	sp_effect|144,>f7	; 94 = lk morph into dragon
	.word	sp_effect|157,>fd	; 95 = dragon morph into lk

	.word	sp_effect|64,>11b	; 96 = guy getting split in half
	.word	sp_effect|46,>16b	; 97 = split guy in 2 hat swipe

	.word	sp_effect|35,>414	; 98 = reptile tongue whip
	.word	sp_effect|35,>411	; 99 = reptile tongue stick
	.word	sp_effect|35,>ca	; 9a = reptile rip head off
	.word	sp_effect|35,>d3	; 9b = reptile bite

	.word	sp_attkv2|20,>189	; 9c = reptile "hock a loogy"

	.word	sp_effect|70,>426	; 9d = jax proj
	.word	sp_effect|66,>195	; 9e = jax proj hit
	.word	sp_effect|20,>198	; 9f = jax proj blocked

	.word	sp_woosh1|18,>1b6	; a0 = baraka quick sword stab #1
	.word	sp_woosh1|18,>1b9	; a1 = baraka quick sword stab #2
	.word	sp_woosh1|18,>1bc	; a2 = baraka quick sword stab #3

	.word	sp_effect|134,>405	; a3 = rumble
	.word	sp_effect|139,>40b	; a4 = BOOM !!
	.word	sp_reacv1|69,>408	; a5 = male voice about to explode
	.word	sp_reacv1|126,>2e9	; a6 = female voice about to explode

	.word	sp_minor1|22,>508	; a7 = bone landing #1
	.word	sp_minor1|28,>50b	; a8 = bone landing #2
	.word	sp_minor1|25,>50e	; a9 = bone landing #3
	.word	sp_minor1|23,>511	; aa = bone landing #4

	.word	sp_gorov1|23,>4b0	; ab = Goro purr
	.word	sp_gorov1|23,>4b3	; ac = Goro growl
	.word	sp_gorov1|23,>4b6	; ad = Goro ROAR !!
	.word	sp_gorov1|23,>4b9	; ae = Goro stomp roar
	.word	sp_gorov1|23,>4bc	; af = Goro hit
	.word	sp_gorov1|23,>4bf	; b0 = Goro hit #2
	.word	sp_gorov1|23,>4c2	; b1 = Goro long roar
	.word	sp_effect|66,>251	; b2 = Goro quake sound
	.word	sp_crowd1|166,>121	; b3 = kick ass crowd cheer

	.word	sp_minor1|30,>e2	; b4 = vortex spark	1
	.word	sp_minor1|24,>e5	; b5 = vortex spark 2
	.word	sp_effect|141,>33e	; b6 = tree roar

	.word	sp_death1|161,>2e0	; b7 = girl disturbing death
	.word	sp_death1|122,>30f	; b8 = kang disturbing death

	.word	sp_bighit|29,>100	; b9 = getting arms ripped off
	.word	sp_bighit|26,>d0	; ba = loud rip sound
	.word	sp_bighit|35,>9d	; bb = back broke
	.word	sp_effect|50,>df	; bc = danger danger

	.word	sp_effect|44,>42c	; bd = reptile fly kick move
	.word	sp_effect|54,>1ef	; be = kung lao spin sound
	.word	sp_attkv2|86,>34a	; bf = kung lao flip dude voice

	.word	sp_effect|66,>429	; c0 = mileena spinning ball
	.word	sp_effect|85,>379	; c1 = green shit sound
	.word	sp_effect|56,>37c	; c2 = green shit into st hand
	.word	sp_effect|82,>376	; c3 = st dive into other dudes mouth
	.word	sp_effect|51,>d6	; c4 = blood spooge
	.word	sp_effect|34,>1e9	; c5 = subzero ice hit
	.word	sp_effect|12,>1ec	; c6 = subzero ice blocked
	.word	sp_bighit|59,>11e	; c7 = raiden death zap sound
	.word	sp_woosh3|20,>be	; c8 = new big whoosh (baraka/kitana swipes)

	.word	sp_effect|85,>124	; c9 = suck in sound (mileena)
	.word	sp_effect|32,>b5	; ca = bones a falling

	.word	sp_pitdie|210,>344	; cb = EB falling down pit
	.word	sp_pitdie|37,>347	; cc = EB hitting bottom of pit
	.word	sp_pitdie|209,>2e3	; cd = girl falling down pit
	.word	sp_pitdie|41,>2e6	; ce = girl hitting bottom of pit
	.word	sp_effect|57,>254	; cf = impact at bottom of pit

	.word	sp_effect|62,>1cb	; d0 = reptile poof / goro fireball
	.word	sp_bighit|81,>24e	; d1 = goro fireball hit
	.word	sp_bighit|16,>6a	; d2 = goro fireball blocked

	.word	sp_effect|1,>1c5	; d3 = kahn spear appear
	.word	sp_effect|63,>147	; d4 = kahn spear throw
	.word	sp_effect|93,>329  	; d5 = kt
	.word	sp_bighit|50,>417	; d6 = hat splitting dude in 2
	.word	sp_bighit|84,>b8	; d7 = subzero arctic blast sound
	.word	sp_bighit|98,>103	; d8 = subzero shatter sound

	.word	sp_reacv3|23,>514	; d9 = Ed: Slippery #1
	.word	sp_reacv3|23,>517	; da = Ed: Slippery #2
	.word	sp_reacv3|28,>51a	; db = Ed: Slippery #3
	.word	sp_reacv3|34,>51d	; dc = Ed: Slippery #4
	.word	sp_reacv3|40,>520	; dd = Ed: Slippery #5
	.word	sp_reacv3|29,>523	; de = Ed: Slippery #6
	.word	sp_reacv3|98,>526	; df = Ed: Big Slippery Whoa
	.word	sp_reacv3|19,>529	; e0 = Dan: Slippery #1
	.word	sp_reacv3|20,>52c	; e1 = Dan: Slippery #2
	.word	sp_reacv3|20,>52f	; e2 = Dan: Slippery #3
	.word	sp_reacv3|20,>532	; e3 = Dan: Slippery #4
	.word	sp_reacv3|29,>535	; e4 = Dan: Slippery #5
	.word	sp_reacv3|43,>538	; e5 = Dan: Slippery #6
	.word	sp_reacv3|33,>546	; e6 = Girl: Slippery #1
	.word	sp_reacv3|18,>549	; e7 = Girl: Slippery #2
	.word	sp_reacv3|37,>54c	; e8 = Girl: Slippery #3
	.word	sp_reacv3|18,>54f	; e9 = Girl: Slippery #4
	.word	sp_reacv3|30,>552	; ea = Girl: Slippery #5
	.word	sp_reacv3|55,>555	; eb = Girl: Big slip
	.word	sp_smlfx|16,>41a	; ec = Slipping on ice #1
	.word	sp_smlfx|16,>41d	; ed = Slipping on ice #2
	.word	sp_smlfx|19,>420	; ee = Slipping on ice #3
	.word	sp_smlfx|24,>423	; ef = Slipping on ice #4
	.word	sp_bighit|104,>127	; f0 = raiden wins effect

	.word	sp_bighit|31,>14a	; f1 = sk spear hit
	.word	sp_bighit|29,>14d	; f2 = sk spear blocked

	.word	sp_bighit|61,>1fa	; f3 = message hit
	.word	sp_bighit|32,>dc	; f4 = raiden dive smack u against wall
	.word	sp_splash|32,>109	; f5 = splash
	.word	sp_splash|32,>106	; f6 = bubble
	.word	sp_splash|32,>335	; f7 = oh maw
	.word	sp_splash|61,>1fa	; f8 = auto select music hit
	.word	sp_splash|42,>bb	; f9 = coin sound

	.word	sp_attkv1|19,>25e	; fa = forden jump voice
	.word	sp_attkv1|21,>290	; fb = jon hey jump voice
	.word	sp_attkv1|20,>312	; fc = kang jump voice
	.word	sp_attkv1|20,>2c2	; fd = girl jump voice
triple_end


triple_sndtab2
	.word	>0f60,>1f4		; 0 = buyin doors closing
	.word	>0f60,>1f7		; 1 = buyin doors slam shut

	.word	>0f60,>233		; 2 = distance thunder #1
	.word	>0f60,>236		; 3 = distance thunder #2
	.word	sp_effect|115,>239  	; 4 = lightning strike

	.word	sp_effect|90,>242	;  5 = flawless victory tone
	.word	sp_bossv1|121,>387	;  6 = "Kung Lao wins"
	.word	sp_bossv1|121,>384	;  7 = "Liu Kang wins"
	.word	sp_bossv1|121,>38a	;  8 = "J. Cage wins"
	.word	sp_bossv1|121,>39f	;  9 = "baraka wins"
	.word	sp_bossv1|121,>396	;  a = "Kitana wins"
	.word	sp_bossv1|121,>39c	;  b = "other chickwins"
	.word	sp_bossv1|121,>393	;  c = "shang tsung wins"
	.word	sp_bossv1|121,>3a5	;  d = "raiden wins"
	.word	sp_bossv1|121,>390	;  e = "sub-zero wins"
	.word	sp_bossv1|121,>38d	;  f = "reptile wins"
	.word	sp_bossv1|121,>3a2	; 10 = "scorpion wins"
	.word	sp_bossv1|121,>399	; 11 = "jax wins"
	.word	sp_bossv1|121,>3a8	; 12 = "smoke wins"
	.word	sp_bossv1|121,>3ab	; 13 = "jade wins"

	.word	sp_bossv1|121,>3ae	; 14 = "finish him"
	.word	sp_bossv1|121,>3b1	; 15 = "finish her"
	.word	sp_bossv1|121,>3b4	; 16 = "fatality"
	.word	sp_bossv1|64,>3cc	; 17 = "fight"

	.word	sp_bossv1|64,>44f	; 18 = "round 1"
	.word	sp_bossv1|64,>452	; 19 = "round 2"
	.word	sp_bossv1|64,>455	; 1a = "round 3"
	.word	sp_bossv1|64,>458	; 1b = "round 4"

	.word	sp_bossv1|64,>45e	; 1c = "kung lao"
	.word	sp_bossv1|64,>45b	; 1d = "liu kang"
	.word	sp_bossv1|64,>461	; 1e = "johnny cage"
	.word	sp_bossv1|64,>476	; 1f = "baraka"
	.word	sp_bossv1|64,>46d	; 20 = "kitana"
	.word	sp_bossv1|64,>473	; 21 = "mileena"
	.word	sp_bossv1|64,>46a	; 22 = "shang tsung"
	.word	sp_bossv1|64,>47c	; 23 = "raiden"
	.word	sp_bossv1|64,>467	; 24 = "subzero"
	.word	sp_bossv1|64,>464	; 25 = "reptile"
	.word	sp_bossv1|64,>479	; 26 = "scorpion"
	.word	sp_bossv1|64,>470	; 27 = "jax"
	.word	sp_bossv1|98,>3b7	; 28 = "flawless victory"
	.word	sp_effect|169,>245	; 29 = fatality dripping in sound

	.word	sp_cursor|15,>20c	; 2a - move cursor
	.word	sp_cursor|15,>20f	; 2b - move cursor
	.word	sp_select|39,>212	; 2c - flash cursor
	.word	sp_select|52,>215	; 2d - flash cursor
	.word	sp_joinin|46,>248	; 2e - player joins in

	.word	sp_bossv2|37,>285	; 2f = "toasty"
	.word	sp_bossv1|49,>3ba	; 30 = "excellent"
	.word	sp_bossv1|72,>3c0	; 31 = "outstanding"
	.word	sp_bossv1|64,>3c3	; 32 = "well done"
	.word	sp_bossv1|64,>3c6	; 33 = "superb"
	.word	sp_bossv1|64,>24b	; 34 = "crowd ooo"

	.word	sp_bossv1|116,>3bd	; 35 = "kintaro wins"
	.word	sp_bossv1|54,>4a0	; 36 = short laugh
	.word	sp_bossv1|71,>3c9	; 37 =

	.word	sp_bikeyl|59,>1fd	; 38 = kang 1
	.word	sp_bikeyl|118,>200	; 39 = kang 2

	.word	sp_effect|244,>561	; 3a = kahn death rumble
	.word	sp_effect|40,>567	; 3b = no
	.word	sp_effect|42,>56a	; 3c = NO
	.word	sp_effect|239,>56d	; 3d = NO !!!
	.word	sp_bossv1|54,>4f4	; 3e = shao kahn wasted voice #1
	.word	sp_bossv1|61,>4f7	; 3f = shao kahn wasted voice #2
	.word	sp_effect|32,>570	; 40 = turn to stone
	.word	sp_effect|81,>24e	; 41 = bang

	.word	sp_bossv2|187,>47f	; 42 = Shao Kahn: I'm SK, bow to me
	.word	sp_bossv2|145,>482	; 43 = Shao Kahn: Feel the wrath ...
	.word	sp_bossv2|137,>485	; 44 = Shao Kahn: Feel the power ...
	.word	sp_bossv2|119,>488	; 45 = Shao Kahn: I rule ...
	.word	sp_bossv2|105,>48e	; 46 = Shao Kahn: Prepare to die
	.word	sp_bossv2|128,>494	; 47 = Shao Kahn: You will die
	.word	sp_bossv2|95,>497	; 48 = Shao Kahn: You are nothing
	.word	sp_bossv2|110,>49a	; 49 = Shao Kahn: laugh #1
	.word	sp_bossv2|119,>49d	; 4a = Shao Kahn: laugh #2
	.word	sp_bossv2|54,>4a0	; 4b = Shao Kahn: laugh #3
	.word	sp_bossv2|164,>4a3	; 4c = Shao Kahn: <laugh> ... yer best?
	.word	sp_bossv2|94,>4a6	; 4d = Shao Kahn: Is that yer best?
	.word	sp_bossv2|97,>4a9	; 4e = Shao Kahn: All too easy
	.word	sp_bossv2|158,>4ac	; 4f = Shao Kahn: You weak pathetic
	.word	sp_bossv2|34,>4e2	; 50 = Shao Kahn: attack #1
	.word	sp_bossv2|37,>4e5	; 51 = Shao Kahn: attack #2

	.word	sp_bossv2|26,>4e8	; 52 = Shao Kahn: react #1
	.word	sp_bossv2|31,>4eb	; 53 = Shao Kahn: react #2
	.word	sp_bossv2|38,>4ee	; 54 = Shao Kahn: react #3
	.word	sp_bossv2|49,>4f1	; 55 = Shao Kahn: react #4
	.word	sp_bossv2|54,>4f4	; 56 = Shao Kahn: wast #1
	.word	sp_bossv2|61,>4f7	; 57 = Shao Kahn: wast #2

	.word	sp_bossv1|69,>3cf	; 58 = Shao Kahn: f
	.word	sp_bossv1|69,>44c	; 59 = Shao Kahn: f ?
	.word	sp_bossv1|112,>578	; 5a = feel the power of toasty

triple_end2

*
* a0 = sound call table offset
* a5 = sound priority we WANT to interupt
*
interupt_sound
	srl	8,a5
	move	a0,a3
	sll	5,a3				; 32 bits per table entry
	addi	triple_sndtab,a3 		; a0 --> our entry
	move	*a3+,a1,w
	move	*a3,a3,w
	move	a1,a4
	sll	32-8,a4
	srl	32-8,a4				; a4 = duration
	srl	8,a1				; a1 = priority

	mmtm	sp,a0,a1,a2,a3

	move	@chan1pri,a2,w
	cmp	a2,a5
	jreq	tsnd1

	move	@chan2pri,a2,w
	cmp	a2,a5
	jreq	tsnd2

	move	@chan3pri,a2,w
	cmp	a2,a5
	jreq	tsnd3
*
* old sound is not running --> normal sound call
*
	mmfm	sp,a0,a1,a2,a3
	jruc	triple_sound


punch_sounds
	callr	rsnd_whoosh	; woosh
	jruc	rsnd_attack	; and "hiya"

kick_sounds
	callr	rsnd_whoosh
	jruc	rsnd_attack

sweep_sounds
	callr	rsnd_attack
	movk	4,a0	
	jruc	triple_sound	; whoosh

rsnd_whoosh
	movi	>00040000,a0	; [total # of entries, 1st entry]
	jruc	random_triple	; random whoosh

rsnd_block
	movi	>00020016,a0	; [total # of entries, 1st entry]
	jruc	random_triple

rsnd_attack
	movk	2,a0		; a0 = # of entries
	movi	>07090b0d,a1	; a1 = left / right / kang / female
	jruc	rsnd_ochar

rsnd_face_hit
	callr	rsnd_react_voice
rsnd_smack
	movi	>00020012,a0	; [total # of entries, 1st entry]
	jruc	random_triple


rsnd_ground
	movi	>0004001f,a0	; [total # of entries, 1st entry]
	jruc	random_triple

rsnd_body_hit
;	callr	rsnd_react_voice
	movi	>00020014,a0	; [total # of entries, 1st entry]
	jruc	random_triple

rsnd_react_voice
	movk	3,a0
	movi	>2326292c,a1	; a1 = left / right / kang / female
	jruc	rsnd_ochar

rsnd_grab_voice
	movk	1,a0
	movi	>3e3f3e6d,a1	; a1 = left / right / kang / female
	jruc	rsnd_ochar

rsnd_throw_voice
	movk	1,a0
	movi	>4041406e,a1	; a1 = left / right / kang / female
	jruc	rsnd_ochar



rsnd_wasted_voice
	movk	2,a0
	movi	>32343638,a1	; a1 = left / right / kang / female
	jruc	rsnd_ochar

rsnd_tripped_voice
	movk	1,a0
	movi	>3c3d3c6c,a1	; a1 = left / right / kang / female
	jruc	rsnd_ochar


rsnd_death_voice
	movi	>45464748,a1	; a1 = left / right / kang / female
	jruc	ochar_sound

**********************************************

disturbing_scream
	movi	>8585b8b7,a1
	jruc	ochar_sound

rsnd_big_smack
	rets
	movk    3,a0 		; total # of entries
	movk	>12,a1 		; 1st entry offset
	jruc	random_triple


orb_hit_sound
	movi	>68,a0		; hit sound
	movi	sp_reporb,a5
	jruc	interupt_sound


random_triple
	move	a0,a1
	srl	16,a0		; a0 = # of calls
	zext	a1,w		; a1 = 1st one
	calla	randu		; a0 = random from 1 to ??
	dec	a0
	add	a1,a0
	jruc	triple_sound

********************************************************************

*
* a1 = [left,right,kang,female]
*
ochar_sound
	movk	1,a0
; <<<<<<<<<<<<<< fall through >>>>>>>>>>>>>


*
* a0 = # of entries
* a1 = [left,right,kang,female]
*
rsnd_ochar
	move	*a8(ochar),a2,w
	cmpi	ft_fn1,a2
	jreq	rsnd_female
	cmpi	ft_fn2,a2
	jreq	rsnd_female		; female call !!
	cmpi	ft_jade,a2
	jreq	rsnd_female

	cmpi	ft_kang,a2
	jreq	rsnd_kang		; liu kang !
	move	*a13(procid),a2,w
	cmpi	pid_p1,a2
	jreq	rsnd_p1

	sll	8,a1
rsnd_p1	srl	32-8,a1			; a1 = player 2 1st entry
	jruc	rsf4

rsnd_kang
	sll	32-16,a1
	srl	32-8,a1			; a1 = kang 1st entry
	jruc	rsf4

rsnd_female
	sll	32-8,a1
	srl	32-8,a1			; a1 = female 1st entry
rsf4	calla	randu
	dec	a0
	add	a1,a0
	jruc	triple_sound


**************************************************************************
*											     *
*  triple_sound - Make a sound call from the triple_sndtab sound table   *
* 											     *
*  input: a0 = sound call offset into table					     *
*											     *
**************************************************************************
triple_sound2
	move	@f_nosound,b3,w			; are we allowed ??
	jrne	send_rets			; no

	mmtm	sp,a0,a1,a2,a3
	sll	5,a0				; 32 bits per table entry
	addi	triple_sndtab2,a0 		; a0 --> our entry
	cmpi	triple_end2,a0			; past the end of the table ?
	jrhs	tsnd9				; yes, sans
	jruc	tsnd0


triple_sound
	move	@f_nosound,b3,w			; are we allowed ??
	jrne	send_rets			; no

	mmtm	sp,a0,a1,a2,a3
	sll	5,a0				; 32 bits per table entry
	addi	triple_sndtab,a0 		; a0 --> our entry
	cmpi	triple_end,a0			; past the end of the table ?
	jrhs	tsnd9				; yes, sans

tsnd0	move	*a0+,a1,w		; a1 = [priority , duration]
	jreq	tsnd9			; zero entry = skip
	jrn	triple_tune		; ffff = tune script

	move	a1,a4
	srl	8,a1			; a1 = priority only
	sll	32-8,a4
	srl	32-8,a4			; a4 = duration only
	move	*a0+,a3,w		; a3 = channel 1 sound call

;****************
	cmpi	sp_bossv2/>100,a1	; boss speech ?
	jrne	noboss			; no
	move	@chan1pri,a0,w
	cmpi	sp_bossv2/>100,a0
	jrne	boss3
	jreq	tsnd1			; channel 1 = has boss speech, use it
boss3	move	@chan2pri,a0,w
	cmpi	sp_bossv2/>100,a0
	jrne	boss4
	jreq	tsnd2			; channel 2 = has boss speech, use it
boss4	move	@chan3pri,a0,w
	cmpi	sp_bossv2/>100,a0
	jrne	noboss
	jreq	tsnd3			; channel 3 = has boss speech, use it
noboss
;****************

*
* a1 = priority
* a3 = channel 1 sound call
* a4 = duration
*
	move	@chan1pri,a0,w
	jreq	tsnd1			; channel 1
	move	@chan2pri,a0,w
	jreq	tsnd2			; channel 2
	move	@chan3pri,a0,w
	jreq	tsnd3			; channel 3
*
* all channels used up ---> see if I am more important
*
	move	@chan1pri,a0,w
	cmp	a0,a1			; who is more important ?
	jrhs	tsnd1			; me ---> do it
	move	@chan2pri,a0,w
	cmp	a0,a1			; who is more important ?
	jrhs	tsnd2			; me ---> do it
	move	@chan3pri,a0,w
	cmp	a0,a1			; who is more important ?
	jrhs	tsnd3			; me ---> do it
	
	mmfm	sp,a0,a1,a2,a3
	clrc
	rets

tsnd1	move	a1,@chan1pri,w		; new priority for channel 1
	move	a4,@chan1dur,w		; new duration
	jruc	tsnd7
tsnd2	move	a1,@chan2pri,w		; new priority for channel 2
	move	a4,@chan2dur,w		; new duration
	inc	a3			; switch to channel 2 sound call
	jruc	tsnd7
tsnd3	move	a1,@chan3pri,w		; new priority for channel 3
	move	a4,@chan3dur,w		; new duration
	addk	2,a3			; switch to channel 3 sound call

tsnd7	callr	send_code_a3

tsnd9	mmfm	sp,a0,a1,a2,a3
	setc	 			; carry set = success
	rets

**************************************************************************
*											     *
*   tune script decoding									     *
*											     *
**************************************************************************
triple_tune
	addk	16,a0
	move	*a0,a1,l		; a1 = tune table
	move	*a1+,a2,w 		; a2 = priority

	movb	*a1(8),a0 		; grab player 1 channel
	move	*a13(procid),a3,w
	cmpi	pid_p1,a3		; player 1 ?
	jreq	tune4			; yes
	movb	*a1,a0			; grab player 1 channel
tune4	addk	16,a1			; a1 ---> next command

	dec	a0	     		; a0 = channel = (0-2)
	sll	6,a0	     		; 64 bits / channel ram storage area
	addi	chan1ram,a0  		; a0 = our channel's ram         
	move	*a0(sndpri),a3,w 	; a3 = current priority		
	cmp	a3,a2		 	; who is more important ?
	jrlo	tune9		 	; not me...

	move	a2,*a0(sndpri),w 	; i am the new priority !!
	callr	do_tune_commands

tune9	mmfm	sp,a0,a1,a2,a3
	rets

**************************************************************************
*											     *
*  psound_for_him - lets a player make a sound call for another player   *
*                   by pretending he is him for an instant		     *
* 											     *
*  input: a0 = sound call 2 make								     *
*											     *
**************************************************************************
psound_for_him
	mmtm	sp,a8,a13
	move	*a13(p_otherguy),a8,l
	move	*a13(p_otherproc),a13,l
	calla	triple_sound
	mmfm	sp,a8,a13
	rets


**************************************************************************
*											     *
*    Sound Tune scripts									     *
*											     *
**************************************************************************
	.word	endtune		; We need this here !

tn_flip_whooshes
	.word	>05,>0103	; priority  [p1 channel , p2 channel]
	.byte	sleep,>0a
	.byte	send2,>3d,>4d
	.byte	sleep,>0e
	.byte	send2,>3d,>4d
	.word	endtune

**************************************************************************
*												*
*  sound table entries										*
*												*
*  in the format:										*
*		  .word   >aabb,>ccdd							*
*												*
*	  where:   aa = duration (00-ff)							*
*		   bb = code (00-ff) 							*
*		   cc = channel (1-3)							*
*		   dd = priority (00-ff)							*
*												*
*			    -- or -- 							*
*												*
*		  .long   >eeeeeeee								*
*												*
*	  where:  eeeeeeee is a pointer to a sound script of commands	*
*		  used to make more complicated or longer lasting		*
*		  sound calls.									*
*												*
**************************************************************************


; priorities:
; 4 - raiden lightning zap
; 5 - whoosh
; 6 - smack / body hits / blocks
; 7 - big hit sound
; 9 - hit ground sound
; a - crowd
; c - emperor speech
; 6 - attack voice
; 8 - react voice
;12 - long wasted voice 


**************************************************************************
*											     *
*  player 1 sounds:									     *
* 											     *
*  voice 1 - hits / sound fx								     *
*  voice 2 - speech									     *
*											     *
*  player 2 sounds:									     *
* 											     *
*  voice 3 - hits / sound fx								     *
*  voice 4 - speech									     *
*											     *
**************************************************************************



**************************************************************************
*											     *
*  yamaha sounds										     *
*											     *
**************************************************************************
sndtab
	.word	>0000,>0000
sndend




fast_fade_music
	.word	>03ff
	.byte	send,>61		; drop music volume
	.byte	send,>21		; drop drum volume
	.byte	sleep,>08
	.byte	send,>63		; drop music volume
	.byte	send,>23		; drop drum volume
	.byte	sleep,>08
	.byte	send,>65		; drop music volume
	.byte	send,>25		; drop drum volume
	.byte	sleep,>08
	.byte	send,>67		; drop music volume
	.byte	send,>27		; drop drum volume
	.byte	sleep,>08
	.byte	send,>69		; drop music volume
	.byte	send,>29		; drop drum volume
	.byte	sleep,>08
	.byte	send,>00		; off u go
	.word	endtune

**************************************************************************
*											     *
*    sound call routines									     *
*											     *
**************************************************************************


**************************************************************************
*												*
*  nosounds											*
*												*
*  cancells all sound calls. zeros all priorities and stops all		*
*  currently running tunes.									*
*												*
**************************************************************************
nosounds
	mmtm	sp,a0,a1
	clr	a3
	callr	send_code_a3		; silence the music board
	callr	clear_sound_ram
	mmfm	sp,a0,a1
	rets

clear_sound_ram
	clr	a0
	movi	chan1ram,a1
nos2	move	a0,*a1+,w		; zero u out !!!
	cmpi	chan4scp+32,a1		; everyone cleared ??
	jrne	nos2			; nope, do more
	rets

**************************************************************************
*												*
*  do_tune_commands										*
*												*
*  run and execute a list of tune commands until a "sleep" or "endtune"	*
*  is reached											*
*												*
*  input:											*
*	a0 = top of current channel's ram storage                       *
*	a1 = current script position 							*
*												*
**************************************************************************
do_tune_commands
	move	*a1+,a3,w			; get [parameter,command]
	sll	16,a3
	srl	16,a3				; mask out the "ffff" scum

	move	a3,a2				; save [command,parameter]
	sll	24,a2
	srl	24,a2
	dec	a2   				; a2 = command offset
	sll	5,a2

	addi	tune_commands,a2
	move	*a2,a2,l			; grab address
	jump	a2				; execute

tune_commands		
	.long	tc_send		; 1
	.long	tc_setpri	; 2
	.long	tc_endtune	; 3
	.long	tc_sleep	; 4
	.long	tc_send2	; 5


tc_send
	srl	8,a3		    	; yes --> a3 = code to send
	calla	send_code_a3	    	; send it and return
	jruc	do_tune_commands

tc_setpri
	srl	8,a3		    	; yes --> a3 = priority to set to
	move	a3,*a1(sndpri),w    	; set it
	jruc	do_tune_commands

tc_endtune
	clr	a1
	move	a1,*a0(sndpri),w
	move	a1,*a0(snddur),w
	move	a1,*a0(sndscp),l  	; clear this channel		
	rets

tc_sleep
	srl	8,a3		  	; yes --> a3 = sleep time
	move	a3,*a0(snddur),w  	; store into duration area
	move	a1,*a0(sndscp),l  	; save current script pointer
	clr	a1		  	; signal --> we are done
	rets

tc_send2
	push	a1			; save script position
tcs1	subk	8,a1
	movb	*a1,a2
	cmpi	endtune,a2		; search backwards for "endtune"
	jrne	tcs1
	addk	24,a1			; a1 ---> channel
	movb	*a1,a2			; a2 = current channel
	pull	a1			; restore script position

	cmpi	1,a2
	jreq	tcs2
	cmpi	2,a2
	jreq	tcs2		  	; channel 1 or 2 = player 1

	movb	*a1,a3		  	; grab it player 2 sound call
	sll	8,a3			; adjust for next line of code

tcs2	addk	8,a1		  	; a1 ---> next command
	srl	8,a3		  	; yes --> a3 = code to send
	calla	send_code_a3	  	; send it and return
	jruc	do_tune_commands


tc_setpri2
	srl	8,a3		    	; yes --> a3 = priority to set to
	move	a3,*a1(sndpri),w    	; set it
	jruc	do_tune_commands

**************************************************************************
*												*
*  sound updater 										*
*												*
*  routine to hanle all the timing of sound calls and sound tune		*
*  scripts. this routine must be called every tick (16 milliseconds)	*
*												*
**************************************************************************
soundup
	move	@chan1dur,a0,w			; channel #1 timing down ?
	jreq	sup2				; nope....
	dec	a0				; yes, count this tick !!
	move	a0,@chan1dur,w			; update duration ram
	jrne	sup2

	move	@chan1scp,a1,l			; we doing a tune script ?
	jreq	sup1				; no
	movi	chan1pri,a0			; a0 = input = chan 1 ram pointer
	callr	do_tune_commands
	jruc	sup2
sup1	move	a1,@chan1pri,w			; no script --> priority = 0

sup2	move	@chan2dur,a0,w			; channel #2 timing down ?
	jreq	sup3				; nope....
	dec	a0				; yes, count this tick !!
	move	a0,@chan2dur,w			; update duration ram
	jrne	sup3
	move	@chan2scp,a1,l			; a1 = input = chan 2 script point
	jreq	sup25				; we are not processing a tune !!
	movi	chan2pri,a0			; a0 = input = chan 2 ram pointer
	callr	do_tune_commands
	jruc	sup3
sup25	move	a1,@chan2pri,w			; no script --> priority = 0

sup3	move	@chan3dur,a0,w			; channel #3 timing down ?
	jreq	sup4				; nope....
	dec	a0				; yes, count this tick !!
	move	a0,@chan3dur,w			; update duration ram
	jrne	sup4
	move	@chan3scp,a1,l			; a1 = input = chan 3 script point
	jreq	sup35				; we are not processing a tune !!
	movi	chan3pri,a0			; a0 = input = chan 3 ram pointer
	callr	do_tune_commands
	jruc	sup4
sup35	move	a1,@chan3pri,w			; no script --> priority = 0

sup4	move	@chan4dur,a0,w			; channel #4 timing down ?
	jreq	supexit				; nope....
	dec	a0				; yes, count this tick !!
	move	a0,@chan4dur,w			; update duration ram
	jrne	supexit
	move	@chan4scp,a1,l			; a1 = input = chan 4 script point
	jreq	sup45				; we are not processing a tune !!
	movi	chan4pri,a0			; a0 = input = chan 4 ram pointer
	callr	do_tune_commands
	rets
sup45	move	a1,@chan4pri,w			; no script --> priority = 0

supexit	rets

**************************************************************************
*												*
*  send code a3											*
*												*
*  this does the actual sending of the sound code (in a3) to the port	*
*  at location @sound.										*
*												*
**************************************************************************
send_code_a3
	mmtm	sp,a0,a1,a2,a3,a4
	move	@f_nosound,a0,w		; are we allowed ??
	jrne	sendx			; no

	move	a3,a0
	sll	32-16,a3
	srl	32-8,a3			; a3 = high byte
*
* send high byte
*
	addi	0ff00h|soundbit,a3	; send high byte.
	move	a3,@sound		; hit sound (low)

	movk	2,a2
	dsj	a2,$			; time for signal to get through
 	callr	poll_sirq
*
* send low byte
*
	sll	32-8,a0
	srl	32-8,a0			; a3 = low byte
	addi	0ff00h|soundbit,a0	; send low
	move	a0,@sound		; hit sound (low)

	movk	2,a2
	dsj	a2,$			; time for signal to get through
	callr	poll_sirq

sendx	mmfm	sp,a0,a1,a2,a3,a4
	rets

send_rets
	rets	


poll_sirq
	movi	390/3,a4		; 180 micros max firq delay on snd board
poll3	movb	@soundirq+b_sirq-7,a1
	jrn	poll9			; done?
	dsj	a4,poll3
poll9	rets

**************************************************************************
*												*
*  reset sound board										*
*												*
*  this is a full reset, checksum dings and all. this is the same routin *
*  that was in the old (gspsnd) processor. (ed boon) 				*
*												*
**************************************************************************
sndres:
	mmtm	sp,a0
	movi	resetbit,a0	;hit reset bit
	move	a0,@sound

	movi	6000,a0		;wait for it to catch
sndrl:	dsjs	a0,sndrl	
	movi	0ffffh,a0	;let it go
	move	a0,@sound
	mmfm	sp,a0
	rets


**************************************************************************
*												*
*  partial sound board reset									*
*												*
*  same as above but with no checksum dings.						*
*			 --									*
**************************************************************************
sndresp:
	mmtm	sp,a0
	movi	resetbit,a0	;hit reset bit
	move	a0,@sound,w
	movi	6000,a0		;wait for it to catch
	dsjs	a0,$	
	movi	0ffffh,a0	;let it go
	move	a0,@sound,w
	movi	soundbit,a0
	move	a0,@sound,w	;supress sound side checksummer
	movk	8,a0
	dsjs	a0,$
	movi	0ff00h,a0
	move	a0,@sound,w
	movk	8,a0
	dsjs	a0,$
	movi	musicbit,a0
	move	a0,@sound,w	;supress music side checksummer
	movk	8,a0
	dsjs	a0,$
	movi	0ff00h,a0
	move	a0,@sound,w
	mmfm	sp,a0
	rets	

*
* input: A0 = [p1,p2] sound call
*
p1p2_sound
	move	*a13(procid),a1,w
	cmpi	pid_p1,a1
	jrne	p12
	srl	16,a0
p12	zext	a0,w
	jruc	triple_sound


**************************************************************************
*												*
*  randsnd											*
*												*
*  will randomly make one of the sound calls (a or b) in a1 where:		*
*												*
*  input: a1 = [a,b] (32 bits)									*
*												*
**************************************************************************
randsnd
	move	@rand,a0,w
	jrn	rands2			; one or the other
	sll	16,a1			; use the one on the right
rands2	srl	16,a1			
	move	a1,a0
	jruc	triple_sound

randsnd2
	move	@rand,a0,w
	jrn	rand2			; one or the other
	sll	16,a1			; use the one on the right
rand2	srl	16,a1			
	move	a1,a0
	jruc	triple_sound2



full_volume
	movi	>55aa,a3
	callr	send_code_a3
	movi	>ff00,a3
	jruc	send_code_a3


	.end
