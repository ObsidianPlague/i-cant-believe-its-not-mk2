**************************************************************************
*												*
*	     copyright (c) 1990 williams electronics games			*
*			 all rights reserved.						*
*												*
**************************************************************************

	.global	get_adj, aud, aud1

**************************************************************************
*												*
*				 audits							*
*												*
*	 audits are handled by audits number off of the base			*
*	 of the audit region									*
*												*
*	 if "chutes" value is changed....extra values must			*
*	 be put in this table.	(and adjustment table of course)		*
*												*
**************************************************************************

audnull		equ	0

audlcoin		equ	1	; total coins in left chute
audccoin		equ	2	; total coins in center chute
audrcoin		equ	3	; total coins in right chute
aud4coin		equ	4	; total coins in fourth chute
audscoin		equ	5	; total service credits
audpaidc		equ	6	; total paid credits

frst_c		equ	audlcoin	;for clearing coins
last_c		equ	audpaidc

**************************************************************************
*											     *
* 	game audits									     *
*											     *
**************************************************************************
frstgaud 	equ	7

aud_choose_hh	equ	 7	; kung lao chosen
aud_choose_lk	equ	 8	; kang chosen
aud_choose_jc	equ	 9	; cage chosen
aud_choose_sa	equ	10	; baraka chosen
aud_choose_fn1	equ	11	; kitana chosen
aud_choose_fn2	equ	12	; mileena chosen
aud_choose_st	equ	13	; shang tsung chosen
aud_choose_rd	equ	14	; raiden chosen
aud_choose_sz	equ	15	; subzero chosen
aud_choose_rp	equ	16	; reptile chosen
aud_choose_sc	equ	17	; scorpion chosen
aud_choose_jx	equ	18	; jax chosen
aud_continue1	equ	19	; 1 player continues taken
aud_continue2	equ	20	; 2 player continues taken
aud_syslock	equ	21	; system "on purpose" lockups
aud_illop	equ	22 	; # of illegal opcodes
aud_1time	equ	23	; 1 player total time
aud_2time	equ	24	; 2 players total time
aud_game_starts	equ	25	; # of games started
aud_ptime	equ	26	; total play time
aud_finish	equ	27	; # of time game was finished
aud_traps 	equ	29	; # of boon traps
aud_hibattle	equ	30	; highest battle # reached
aud_ontime	equ	31	; game power on time
audauto		equ    	32	; auto cycle passes
aud_start 	equ    	33	; total starts !
aud_drone_fatal	equ	34	; drone fatality counter
aud_ws_reset	equ	35	; winning streak reset count
aud_slam		equ	36	; # of time slam switch was made
aud_bb		equ	38	; bb counter
aud_fs		equ	39	; fs counter
aud_watchdog	equ	40	; watch dog triggered !
aud_found_smoke	equ	41	; # of times smoke was found
aud_found_jade	equ	42	; # of times jade was found
aud_clue		equ	43	; clue counter
aud_found_noob	equ	44	; # of times nooby was found

last_audit	equ	45
lastgaud 	equ	last_audit

**************************************************************************
*											     *
* 	adjustments are all long words referenced by adjustment	     *
* 	number.										     *
*											     *
**************************************************************************
adjnull	       equ     0
adjprice        equ     1	; master pricing
adjlmult        equ     2
adjc1	       equ     adjlmult	; first coin table adjustment
adjcmult        equ     3
adjrmult        equ     4
adj4mult	       equ     5
adjcunit        equ     6
adjbunit        equ     7
adjmunit        equ     8
adjcdiv	       equ     9
adjfrac	       equ     10	; non zero says show half credits
adjcx	       equ     adjfrac	; last coin table adjustment
adjcstrt        equ     11	; credits required to start
adjccont        equ     12	; credits required to continue
adj_hsreset     equ     13	; longest winning streak reset adj
adj_ddiff       equ     14	; drone difficulty adjustment
adj_volume      equ     15	; volume adjustment
;	       equ     16	;
adjmaxc	       equ     17	; maximum credits
adjfrepl        equ     18	; non-zero means free play
adjvirgin       equ     19	; non-zero means 1st 8 of coin adjust block untouchted
adj_hsoff       equ     20	; non-zero means highscore table off
adj1st6	       equ     21	; non-zero means 1st 6 untouched.
;	       equ     22
;	       equ     23	;
last_adjust     equ     23



