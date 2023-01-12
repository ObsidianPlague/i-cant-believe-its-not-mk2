	.file	'diagword.asm'
	.title	" <<< word substitution strings >>>"
	.width	132
	.option	b,d,l,t
	.mnolist

**************************************************************************
*									    *
*	copyright (c) 1990 williams electronics games, inc.		 *
*	all rights reserved.						 *
*									    *
**************************************************************************
	.include	macros.hdr
	.include	"dispequ.asm"		;display processor equates
	.include	"sysequ.asm"		;system equates
	.include	"mainequ.asm"
	.include	"imgtbl.glo"
	.include	"stringh.asm"

	.include	"diagdict.asm"		; dictionary of words
	.include	"diagsequ.asm"

**************************************************************************
*									    *
*	defs and refs							 *
*									    *
**************************************************************************

	.def	dict_lookup
	.def	lm_xfinis, l_xmess
	
**************************************************************************
*									    *
*	code start							 *
*									    *
**************************************************************************

	.text
	.even

**************************************************************************
*									    *
*	lm_xfinis							 *
*									 *
*	entry								 *
*		everything lm_finis needs				 *
*									 *
*	exit								 *
*		whatever lm_finis gives back				 *
*									 *
*	call								 *
*		jsrp							 *
*									    *
**************************************************************************

lm_xfinis
	calla	stringf
	mmtm	a12,a1,a3	;save routine and next string ptr
	jsrpr	a1
	mmfm	a12,a1,a8	;restore routine and next string (a8)
	retp


**************************************************************************
*												*
*	  l_mess										*
*												*
*	  a8 points at mess_mac followed by message text.			*
*	     pop all reggies leaving a8 pointing at text.			*
*	     and jump to the text processor!						*
*												*
*	  the mmfm pops the routine to call into a1.				*
*												*
*	  you ***must*** use jsrp to get here. 					*
*												*
**************************************************************************
l_xmess_loop
	addi	8,a8			;push beyond this byte
l_xmess
	addi	0fh,a8			;if it ends in other than zero..
*					;kick to next word (i.e. .even)
	srl	4,a8
	sll	4,a8			;mask fractional word

	mmfm	a8,a1,a5,a9,a10,a11	;load up reggies from a8.
	mmfm	a8,a0			;you may sleep
	calla	stringf
	pushp	a3			; save new text location
	jsrpr	a1			;jsrp to the routine
	pullp	a8
	movb	*a8,a0			;check next byte 0=done...1=more.
	jrnz	l_xmess_loop
	retp


**************************************************************************
*									    *
*	dict_lookup							 *
*									 *
*	entry								 *
*		a0	word number					 *
*									 *
*	exit								 *
*		a8	pointer to word string				 *
*									 *
*	call								 *
*		call							 *
*									    *
**************************************************************************

dict_lookup:
	mmtm	sp,a0
	clr	a8			; "assume zero"
	sll	25,a0
	srl	25,a0			; mask all but low 7
	cmpi	w_lastword,a0
	jrhi	dict_ret		; br = not a real word
	sll	5,a0
	addi	lookup_tab,a0
	move	*a0,a8,l
dict_ret
	move	a8,a8
	mmfm	sp,a0
	rets

**************************************************************************
*									    *
*	word table							 *
*									    *
**************************************************************************

lookup_tab:
	.long	w_000,w_001,w_002,w_003,w_004,w_005,w_006,w_007
	.long	w_008,w_009,w_010,w_011,w_012,w_013,w_014,w_015
	.long	w_016,w_017,w_018,w_019,w_blah,w_020,w_021,w_022,w_023
	.long	w_024,w_025,w_026,w_027,w_028,w_029,w_030,w_031
	.long	w_032,w_033,w_034,w_035,w_036,w_037,w_038,w_039
	.long	w_040,w_041,w_042,w_043,w_044,w_045,w_046,w_047
	.long	w_048,w_049,w_050,w_051,w_052,w_053,w_054,w_055
	.long	w_056,w_057,w_058,w_059,w_060,w_061,w_062,w_063

w_000	.STRING	"FRANCE",0
w_001	.STRING	"GERMAN",0
w_002	.STRING	82H,0
w_003	.STRING	"CREDIT",0
w_004	.STRING	"GAME",0
w_005	.STRING	"ADJUSTMENT",0
w_006	.STRING	"CREDITS",0
w_007	.STRING	"PRICING",0
w_008	.STRING	"CUSTOM",0
w_009	.STRING	"FREE",0
w_010	.STRING	"PLAY",0
w_011	.STRING	"COIN",0
w_012	.STRING	"COINS",0
w_013	.STRING	"STANDARD",0
w_014	.STRING	"UNITS",0
w_015	.STRING	"CHUTE",0
w_016	.STRING "FACTORY SETTING",0
w_017	.STRING	"TIME",0
w_018	.STRING	"AUDITS",0
w_019	.STRING	"CLOSED",0
w_blah	.STRING	"CLEAR",0
w_020	.STRING	"TEST",0
w_021	.STRING	"AVERAGE",0
w_022	.STRING	"FOURTH",0
w_023	.STRING	"SWITCH",0
w_024	.STRING	"BOARD",0
w_025	.STRING	"SLOT",0
w_026	.STRING	"TONE",0
w_027	.STRING	"GAMES",0
w_028	.STRING	"RETURN",0
w_029	.STRING	"RIGHT",0
w_030	.STRING	"PLAYS",0
w_031	.STRING	"FINISH",0
w_033	.STRING	"CONTINUES",0
w_034	.STRING	"COLLECTION",0
w_036	.STRING	"AUDIT",0
w_037	.STRING	"PRESS",0
w_038	.STRING	"BONE",0
w_039	.STRING	"SETTINGS",0
w_040	.STRING	"DIPSWITCH",0
w_041	.STRING	"BOOK",0
w_043	.STRING	"CENTER",0
w_044	.STRING	"SELECT",0
w_045	.STRING	"LEFT",0
w_046	.STRING	"START",0
w_047	.STRING	"PLAYER",0
w_048	.STRING	"SIMULTANEOUS",0
w_049	.STRING	"SCREEN",0
w_050	.STRING	"TOTAL",0
w_051	.STRING	"STARTS",0
w_052	.STRING	"SOUND",0
w_054	.STRING	"ADJUSTMENTS",0
w_055	.STRING	"ROM ERROR  U",0
w_057	.STRING	"ERROR",0
w_058	.STRING	"TOTALS",0
w_059	.STRING	"COIN COUNTERS",0
w_060	.STRING	"MESSAGE",0
w_061	.STRING	"BUTTON",0
w_062	.STRING	"CONTINUE",0
w_063	.STRING	"U.S.A.",0

w_056
w_032
w_035
w_042
w_053
w_xxx	.string	"XXX"

	.even
