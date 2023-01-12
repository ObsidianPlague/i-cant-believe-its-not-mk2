**************************************************************************
*									    			*
*	coinage stuff							 			*
*									    			*
**************************************************************************

chutes	equ	4   		;maximum coin chutes in game.

l_coin_bit	equ	1h
c_coin_bit	equ	4h
r_coin_bit	equ	2h
x_coin_bit	equ	80h
slam_bit 	equ	8h

menu_pid 	equ	 0ac1h	 ;get_menu slave
mdun_pid 	equ	 0ac2h	 ;menu slave changes to this when done

long_size	equ	32
word_size	equ	16
byte_size	equ	8

c_long_size	equ	64
c_word_size	equ	32
c_byte_size	equ	16
cmos_1k		equ	c_byte_size*1024

byte_mask	equ	0ffh
word_mask	equ	0ffffh

sx_mask		 equ	 0ffffh
sy_mask		 equ	 0ffff0000h

**************************************************************************
*												*
*	  ascii stuff										*
*												*
**************************************************************************
space		equ	20h
ex_pt		equ	21h
let_0		equ	30h
let_a		equ	41h
let_z		equ	5ah
underscore 	equ	5fh
font_space  	equ	7eh
font_rub 	equ	font_space+1
font_end 	equ	font_rub+1
font_rquote 	equ	font_end+1
font_epound 	equ	font_rquote+1
font_cr	   	equ	font_epound+1
ascii_comma 	equ	2ch
right_paren 	equ	29h
ascii_dq 	equ	22h

**************************************************************************
*												*
*	  audit structure									*
*												*
**************************************************************************
aud_data 		equ	0		  ;the counter is 4 bytes starting at zero
aud_cksum		equ	aud_data+(4*c_byte_size)  ;checksum = 2 bytes
aud_size 		equ	aud_cksum+c_word_size
aud_bytes_to_check	equ	(aud_size/c_byte_size)-2  ;# to add for checksum

n_audits 	equ	45			;use 45 audits!

**************************************************************************
*												*
*	  adjustments										*
*												*
**************************************************************************
adj_size 	equ	c_long_size
n_adjusts	equ	28		;28 normal adjustments


**************************************************************************
*												*
*  cmos stuff for hstd..........move this to special equate file 		*
*  some day											*
*												*
**************************************************************************
*
*	high score table (cmos) entry data structure
*
num_inits	equ	3	   ;initials in each entry..this must be odd
hs_score 	equ	0				  ;long word.....8 digit score
hs_col		equ	hs_score+c_long_size	; palette to plot in
hs_inits 	equ	hs_col+c_word_size	;byte for first initial
hs_ckbyte	equ	hs_inits+(num_inits*c_byte_size)  ;byte for checksum
hs_size		equ	hs_ckbyte+c_byte_size	  ;size of structure
hs_bytes_to_check equ	(hs_size/c_byte_size)-1  ;# to add for checksum
hs_size_in_words  equ	hs_size/c_word_size	  ;size of entry in words
hs_size_in_bytes  equ	hs_size/c_byte_size	  ;size of entry in bytes
hs_rom_size	 equ	hs_size/2			  ;address size of rom entry

rhs_valid	equ	0
rhs_score	equ	rhs_valid+word_size
rhs_col		equ	rhs_score+long_size
rhs_inits	equ	rhs_col+word_size
rhs_ckbyte	equ	rhs_inits+(num_inits*byte_size)
rhs_size	equ	rhs_ckbyte+byte_size

**************************************************************************
*												*
*	 a high score table is defined in rom by the following		*
*	 structure (there are at least 2 tables....all time			*
*	 and "todays")										*
*												*
**************************************************************************
tb_pointer	equ	0				;long-pointer to beginning of table
tb_count 	equ	tb_pointer+long_size	;word....# in the table.
tb_visible	equ	tb_count+word_size 	;word....number displayed
tb_page_bits	equ	tb_visible+word_size	;word....status word for cmos page
tb_factory	equ	tb_page_bits+word_size ;long....rom startup table
tb_error_count	equ	tb_factory+long_size	;word....num errors to re-init
*
cmos			equ	1400000h	;base of cmos
wpcmos			equ	1404000h	;write protected cmos
wp_read			equ	1c00010h	;place to read write protect status
snd_talk			equ	1c00020h	;sound board talk back.
wp_bit			equ	800h		;bit where write enable lives  0=no writes
cmos_page_select_bits 	equ 	0c0h		;bits 6 and 7 of sysctrl select cmos page
cmos_page_select_unit 	equ 	040h		;4 pages use multiples of this

**************************************************************************
*                                                                        *
*          cmos allocation for tunit                                     *
*                                                                        *
**************************************************************************

	.if tunit

wp_unlock	equ	1480000h		;write here to unlock

*
*	32k x 8
*
*	all is protected, you may unprotect for one write only
*		hstd today	- 1k
*		hstd all time	- 1k
*		audits		- 2k
*		adjustments	- 1k
*		error dump data	- 2k
*

**************************************************************************
*											     *
*  custom message definitions								     *
*											     *
**************************************************************************
cmess_chars	equ	18				;25 chars/line of custom message
cmess_lines	equ	3				;3 lines
cmess_line_size	equ	cmess_chars*c_byte_size
cmess_size	equ	cmess_lines*cmess_line_size

name_rev_size	equ	30			;name and rev data
;name_rev_size	equ	30			;name and rev data


;todays_origin	equ	cmos
;todays_visible	equ	10
;todays_cmosmem	equ	cmos_1k			;total cmos for today's hstd
;
;all_time_origin	equ	todays_origin+todays_cmosmem
;all_time_select	equ	cmos_page_select_unit*2
;all_time_visible equ	10
;all_time_cmosmem equ	cmos_1k			;total cmos for all time hstd

**************************************************************************
*											     *
*  cmos group #1 = audit data and credits						     *
*											     *
**************************************************************************
auditorg		equ	cmos						;audits live here
credits		equ	auditorg+(n_audits*aud_size)	;byte for credits
cunits		equ	credits+c_byte_size			;word
bunits		equ	cunits+c_word_size			;word
minunits		equ	bunits+c_word_size			;word
coin_cksum	equ	minunits+c_word_size			;byte
hsr_c		equ	coin_cksum+c_byte_size			;long = high score reset counter
audit_cmosmem	equ	2*cmos_1k					;total cmos for audits

**************************************************************************
*											     *
*  cmos group #2 = adjustments									*
*											     *
**************************************************************************
adjustorg		equ	auditorg+audit_cmosmem		;first adjustment here
custom_message		equ	adjustorg+(n_adjusts*adj_size)
valid_custom		equ	custom_message+cmess_size	;word = eabc if ok.
end_ck_region		equ	valid_custom+c_word_size
adj_area_size		equ	end_ck_region-adjustorg		;adjusts+custom message
adj_cksum		equ	end_ck_region				;word check for adjusts
adj_bytes_to_check 	equ	adj_area_size/c_byte_size	;number of bytes in checksum.
name_rev			equ	adj_cksum+c_word_size
end_adj			equ	name_rev+(name_rev_size*c_byte_size)
adjust_cmosmem		equ	cmos_1k					;total cmos for adjustments

**************************************************************************
*											     *
*  cmos group #3 = longest winning streak data					     *
*											     *
**************************************************************************
rankorg 			equ	adjustorg+adjust_cmosmem


coin_cksum_start equ	credits
coin_cksum_size  equ	coin_cksum-coin_cksum_start	;size of region to check
coin_cksum_bytes equ	coin_cksum_size/c_byte_size	;number of bytes to add

**************************************************************************
*											     *
*  not used anymore									     *
*											     *
**************************************************************************
audit_select	equ	cmos_page_select_unit*1
hsr_select	equ	audit_select				; high score reset counter
coin_select	equ	audit_select				; coins and credits
adjust_select	equ	cmos_page_select_unit*1
rank_select	equ	cmos_page_select_unit*3 	; lifetime rankings
todays_select	equ	cmos_page_select_unit*0



valid_value	equ	0eabch			;stored at "valid_custom" if ok!


;dump_org	equ	adjustorg+adjust_cmosmem
;dump_select	equ	cmos_page_select_unit*3
;dump_ptr	equ	dump_org		;word....number of entries!
;dump_data	equ	dump_ptr+c_word_size	;dumps go here!
;dump_cmosmem	equ	2*cmos_1k		;total cmos for dumps
;dump_end	equ	dump_org+dump_cmosmem

	.else

**************************************************************************
*											     *
* 			  cmos allocation						     *
* 											     *
* 	4 pages of 2k									     *
* 											     *
* 	each page    low 1k = read/write						     *
* 		     high 1k = write protected					     *
* 											     *
* 	page 0	     low half  = hstd today					     *
*                     high halk = hstd all time						*
* 											     *
* 	page 1	     low half  = audits						     *
* 		     high half = adjustments					     *
* 											     *
* 	page 2	     low half  = hstd all time (gonna be rankings also) *
* 											     *
* 	page 3       both halves = player rankings				     *
*											     *
**************************************************************************
*todays_origin	equ	all_time_origin+(hs_size*37)
;all_time_select	equ	cmos_page_select_unit*2 (old way - ejb)

todays_origin	equ	 cmos
all_time_origin	equ	 todays_origin+(hs_size*15)

todays_select	equ	cmos_page_select_unit*0
all_time_select	equ	cmos_page_select_unit*0
adjust_select	equ	cmos_page_select_unit*1
audit_select	equ	cmos_page_select_unit*1

hsr_select	equ	audit_select  			; high score reset counter
coin_select	equ	audit_select  			; coins and credits
wrec_select	equ	audit_select  			; world records
rank_select	equ	cmos_page_select_unit*3 	; lifetime rankings

todays_visible	 equ	 10
all_time_visible  equ	 10

**************************************************************************
*											     *
* 	audit page audit data and credits						     *
*											     *
**************************************************************************
auditorg 	equ	cmos			; audits live here
rankorg 		equ	cmos			; player rankings live here
rankend		equ	cmos+(16*2048)	; and end here

credits		equ	auditorg+(n_audits*aud_size)	;byte for credits
cunits		equ	credits+c_byte_size			;word
bunits		equ	cunits+c_word_size			;word
minunits 	equ	bunits+c_word_size			;word
coin_cksum	equ	minunits+c_word_size			;byte
hsr_c		equ	coin_cksum+c_byte_size 		;long = high score reset counter
*
*	next two are assumed to be back to back
*
hreset_counter	equ	hsr_c+c_long_size 			;long = high score reset counter
hreset_verify	equ	hreset_counter+c_long_size		;long = 2nd copy inverted.

coin_cksum_start equ	credits
coin_cksum_size	equ	coin_cksum-coin_cksum_start 	;size of region to check
coin_cksum_bytes equ	coin_cksum_size/c_byte_size 	;number of bytes to add

cmess_chars	equ	18				;25 chars/line of custom message
cmess_lines	equ	3				;3 lines
cmess_line_size	equ	cmess_chars*c_byte_size
cmess_size	equ	cmess_lines*cmess_line_size

valid_value	equ	0eabch				;stored at "valid_custom" if ok!

	.endif

**************************************************************************
*												*
*	  color stuff -- palette 0								*
*												*
**************************************************************************
trog_red		equ	0101h	
trog_white	equ	0202h
trog_blue	equ	0303h
trog_grey	equ	0404h
trog_yellow	equ	0505h
trog_purple	equ	0606h
trog_green	equ	0707h
trog_black	equ	0808h
trog_decay	equ	0c0ch
trog_bpr		equ	0b0bh
trog_lf		equ	0d0dh
trog_rgb		equ	0e0eh
dino_intense	equ	0e0eh

trog_pred	equ	01010000h
trog_pwhite	equ	02020000h
trog_pblue	equ	03030000h
trog_pgrey	equ	04040000h
trog_pyellow	equ	05050000h
trog_ppurple	equ	06060000h
trog_pgreen	equ	07070000h
trog_pblack	equ	08080000h
trog_pbpr	equ	0b0b0000h
trog_pdecay	equ	0c0c0000h
trog_plf		equ	0d0d0000h
trog_prgb	equ	0e0e0000h

dino_pintense	equ	0e0e0000h
dino_white	equ	0f0fh
dino_grey	equ	0101h

dino_pwhite	equ	0f0f0101h
dino_pgrey	equ	01010101h

**************************************************************************
*									    			*
*			diagnostic macros				 			*
*									    			*
**************************************************************************
*
*fcall - function call without using the system stack
*	fcall	routine, breg
*
fcall	$macro	name,breg
	movi	:name:,:breg:
	exgpc	:breg:
        $end
*
*fret - function return without using the system stack
*	fcall	routine, breg
*
fret	$macro	breg
	exgpc	:breg:
	$end
*
*	timed pause
*
pause	$macro	time,reg
	movi	:time:,:reg:
label?:	nop
	dsjs	:reg:,label?
        $end


