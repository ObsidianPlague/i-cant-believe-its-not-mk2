**************************************************************************
*                                                                        *
*		equates for string routines						*					 *
*                                                                        *
**************************************************************************
*
*	text routines
*
	.global	printf, lm_printf
	.global	stringf
	.global	strlnrm, strcnrm, strrnrm, strcnrmo, strlnrmo
;	.global	strlnc, strcnc, strrnc, strcnco
	.global	strcnrmos,strlnrms,strcnrms,strrnrms
	.global	l_mess, lm_setup, lm_finis, clrtext, hextoasc
	.global	rd5font
	.global	rd7font
	.global	rd15font
	.global	rd20font
	.global	string1, string2, string3
	.global	strnglen
	.global	strngram
	.global	stringf_ram
	.global	htohxasc
	.global	string_shadow

	.global	strlnrmos_scr,strcnrmos_scr,strrnrmos_scr
	.global	strcnrmo_scr


*
*ascii font miscellaneous equates
f15sp		equ	7eh			;font 15 sp character, for hs entry
f15rub	equ	f15sp+1		;font 15 rub character,for hs entry
f15end	equ	f15rub+1		;font 15 end character,for hs entry
f15rquot equ	f15end+1		;font 15 right quote
*
*stringer control characters
new_sleep	equ	1	;change current sleep time
new_pcolor	equ	2	;change the current print color
new_control	equ	3	;change current dma control word
new_font		equ	4	;change current font
new_xy		equ	5	;change current print position
new_spacing	equ	6	;change current spacing
add_dydx		equ	7	;add this [y,x] to the current position
new_palette equ	8	;use new palette, specified by i.d.
ascii_tab	equ	9
underline_on	equ	0ah	; turn on underlining
underline_off	equ	0bh	; turn off underlining
ascii_cr		equ	0dh
**************************************************************************
*                                                                        *
* pcolor - change to a new print color					 							 *
*                                                                        *
**************************************************************************
pcolor	$macro	color
	.byte	new_pcolor
	.word	:color:
	$end

**************************************************************************
*                                                                        *
*          mess_mac                                                      *
*                                                                        *
*          this macro is used to setup an "l_mess" message.              *
*          the message follows the macro.                                *
*          zero terminates the message.                                  *
*          another zero terminates l_mess.                               *
*                                                                        *
*          a "1" after the terminating "0" will cause                    *
*          l_mess to print out another message.                          *
*                                                                        *
**************************************************************************

mess_mac $macro  font,spacing,x,y,color,routine,sleep
         .long	:font:
         .long	:spacing:
			.word	:x:	
			.word	:y:
         .long	:color:
         .long	:routine:
         .long	:sleep:
         $end

spacing20        equ     2
spacing07        equ     1
