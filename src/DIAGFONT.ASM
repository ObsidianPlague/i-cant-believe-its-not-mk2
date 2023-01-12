
;****************************************************************************
;* sysfont: system font; module defines the font used with system	    *
;*	    diagnostics.						    *
;****************************************************************************

	  .title 'sysfont'
	.width	132
	.option	b,d,l,t
	.mnolist

	.def	sysfont

	  .even

; ===========================
; | dydx char dimensions    |
; | pointer to xy char data |
; ===========================

t2_sp:
   .word    04h,08h
   .long    i2_sp

t2_mn:
   .word    08h,08h
   .long    i2_mn

t2_per:
	.word	2,8
	.long	i2_per

t2_slash:
	.word	6,8
	.long	i2_slash

t2_colon:
	.word	2,8
	.long	i2_colon

t2_00:
   .word    06h,08h
   .long    i2_00

t2_11:
   .word    06h,08h
   .long    i2_11

t2_22:
   .word    06h,08h
   .long    i2_22

t2_33:
   .word    06h,08h
   .long    i2_33

t2_44:
   .word    06h,08h
   .long    i2_44

t2_55:
   .word    06h,08h
   .long    i2_55

t2_66:
   .word    06h,08h
   .long    i2_66

t2_77:
   .word    06h,08h
   .long    i2_77

t2_88:
   .word    06h,08h
   .long    i2_88

t2_99:
   .word    06h,08h
   .long    i2_99

t2_aa:
   .word    06h,08h
   .long    i2_aa

t2_bb:
   .word    06h,08h
   .long    i2_bb

t2_cc:
   .word    06h,08h
   .long    i2_cc

t2_dd:
   .word    06h,08h
   .long    i2_dd

t2_ee:
   .word    06h,08h
   .long    i2_ee

t2_ff:
   .word    06h,08h
   .long    i2_ff

t2_gg:
   .word    06h,08h
   .long    i2_gg

t2_hh:
   .word    06h,08h
   .long    i2_hh

t2_ii:
   .word    02h,08h
   .long    i2_ii

t2_jj:
   .word    06h,08h
   .long    i2_jj

t2_kk:
   .word    06h,08h
   .long    i2_kk

t2_ll:
   .word    05h,08h
   .long    i2_ll

t2_mm:
   .word    0ah,08h
   .long    i2_mm

t2_nn:
   .word    07h,08h
   .long    i2_nn

t2_oo:
   .word    07h,08h
   .long    i2_oo

t2_pp:
   .word    06h,08h
   .long    i2_pp

t2_qq:
   .word    07h,0ah
   .long    i2_qq

t2_rr:
   .word    06h,08h
   .long    i2_rr

t2_ss:
   .word    06h,08h
   .long    i2_ss

t2_tt:
   .word    06h,08h
   .long    i2_tt

t2_uu:
   .word    06h,08h
   .long    i2_uu

t2_vv:
   .word    07h,08h
   .long    i2_vv

t2_ww:
   .word    0bh,08h
   .long    i2_ww

t2_xx:
   .word    07h,08h
   .long    i2_xx

t2_yy:
   .word    06h,08h
   .long    i2_yy

t2_zz:
   .word    06h,08h
   .long    i2_zz

t2_arrowl
   .word    0eh,09h
   .long    i2_arrowl

t2_arrowr
   .word    >e,>9
   .long    i2_arrowr

t2_arrowu
   .word    >9,>d
   .long    i2_arrowu

t2_arrowd
   .word    >9,>d
   .long    i2_arrowd

; ===========================
; | character directory	   |
; ===========================

sysfont:
	.long	t2_sp		;space
	.long	t2_sp		;no "!"
	.long	t2_sp		;no """
	.long	t2_sp		;no "#"
	.long	t2_sp		;no "$"
	.long	t2_sp		;no "%"
	.long	t2_sp		;no "&"
	.long	t2_sp		;no "'"
	.long	t2_sp		;no "("
	.long	t2_sp		;no ")"
	.long	t2_sp		;no "*"
	.long	t2_sp		;no "+"
	.long	t2_sp		;no ","
	.long	t2_mn		;"-"
	.long	t2_per		;"."
	.long	t2_slash	;"/"
	.long	t2_00		;0
	.long	t2_11		;1
	.long	t2_22		;2
	.long	t2_33		;3
	.long	t2_44		;4
	.long	t2_55		;5
	.long	t2_66		;6
	.long	t2_77		;7
	.long	t2_88		;8
	.long	t2_99		;9
	.long	t2_colon	;:
	.long	t2_00		; no ;
	.long	t2_arrowl	;left arrow (not a "less than" sign)
	.long	t2_00		; no =
	.long	t2_arrowr	;right arrow (not a "greater than" sign)
	.long	t2_00		; no ?
	.long	t2_00		; no @
	.long	t2_aa		;a
	.long	t2_bb		;b
	.long	t2_cc		;c
	.long	t2_dd		;d
	.long	t2_ee		;e
	.long	t2_ff		;f
	.long	t2_gg		;g
	.long	t2_hh		;h
	.long	t2_ii		;i
	.long	t2_jj		;j
	.long	t2_kk		;k
	.long	t2_ll		;l
	.long	t2_mm		;m
	.long	t2_nn		;n
	.long	t2_oo		;o
	.long	t2_pp		;p
	.long	t2_qq		;q
	.long	t2_rr		;r
	.long	t2_ss		;s
	.long	t2_tt		;t
	.long	t2_uu		;u
	.long	t2_vv		;v
	.long	t2_ww		;w
	.long	t2_xx		;x
	.long	t2_yy		;y
	.long	t2_zz		;z
	.long	t2_sp		;no "["
	.long	t2_sp		;no "\"
	.long	t2_sp		;no "]"
	.long	t2_arrowu	;up arrow (not an "exponent" sign)
	.long	t2_arrowd	;down arrow (not an under_score)


; ===========================
; | character definitions   |
; ===========================

i2_sp:
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h

i2_mn:
   .byte    000h
   .byte    000h
   .byte    000h
   .byte    0ffh
   .byte    0ffh
   .byte    000h
   .byte    000h
   .byte    000h

i2_per:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0ffh
	.byte	0ffh

i2_slash:
	.byte	30h
	.byte	30h
	.byte	18h
	.byte	18h
	.byte	06h
	.byte	06h
	.byte	03h
	.byte	03h

i2_colon:
	.byte	0
	.byte	0ffh
	.byte	0ffh
	.byte	0
	.byte	0
	.byte	0ffh
	.byte	0ffh
	.byte	0

i2_00:
   .byte    01eh
   .byte    03fh
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    03fh
   .byte    01eh

i2_11:
   .byte    0eh
   .byte    0fh
   .byte    0fh
   .byte    0ch
   .byte    0ch
   .byte    0ch
   .byte    0ch
   .byte    0ch

i2_22:
   .byte    01fh
   .byte    03fh
   .byte    038h
   .byte    01ch
   .byte    0eh
   .byte    07h
   .byte    03fh
   .byte    03fh

i2_33:
   .byte    01fh
   .byte    03fh
   .byte    030h
   .byte    01eh
   .byte    01eh
   .byte    030h
   .byte    03fh
   .byte    01fh

i2_44:
   .byte    038h
   .byte    03ch
   .byte    036h
   .byte    033h
   .byte    03fh
   .byte    03fh
   .byte    030h
   .byte    030h

i2_55:
   .byte    03fh
   .byte    03fh
   .byte    03h
   .byte    01fh
   .byte    03fh
   .byte    030h
   .byte    03fh
   .byte    01fh

i2_66:
   .byte    03eh
   .byte    03fh
   .byte    03h
   .byte    01fh
   .byte    03fh
   .byte    033h
   .byte    03fh
   .byte    01eh

i2_77:
   .byte    03fh
   .byte    03fh
   .byte    030h
   .byte    018h
   .byte    018h
   .byte    0ch
   .byte    0ch
   .byte    0ch

i2_88:
   .byte    01eh
   .byte    03fh
   .byte    033h
   .byte    01eh
   .byte    01eh
   .byte    033h
   .byte    03fh
   .byte    01eh

i2_99:
   .byte    01eh
   .byte    03fh
   .byte    033h
   .byte    03fh
   .byte    03eh
   .byte    030h
   .byte    03fh
   .byte    01fh

i2_aa:
   .byte    01eh
   .byte    03fh
   .byte    033h
   .byte    033h
   .byte    03fh
   .byte    03fh
   .byte    033h
   .byte    033h

i2_bb:
   .byte    01fh
   .byte    03fh
   .byte    033h
   .byte    03fh
   .byte    01fh
   .byte    033h
   .byte    03fh
   .byte    01fh

i2_cc:
   .byte    03eh
   .byte    03fh
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03fh
   .byte    03eh

i2_dd:
   .byte    01fh
   .byte    03fh
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    03fh
   .byte    01fh

i2_ee:
   .byte    03fh
   .byte    03fh
   .byte    03h
   .byte    03fh
   .byte    03fh
   .byte    03h
   .byte    03fh
   .byte    03fh

i2_ff:
   .byte    03fh
   .byte    03fh
   .byte    03h
   .byte    03fh
   .byte    03fh
   .byte    03h
   .byte    03h
   .byte    03h

i2_gg:
   .byte    03eh
   .byte    03fh
   .byte    03h
   .byte    03h
   .byte    033h
   .byte    033h
   .byte    03fh
   .byte    01eh

i2_hh:
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    03fh
   .byte    03fh
   .byte    033h
   .byte    033h
   .byte    033h

i2_ii:
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h

i2_jj:
   .byte    030h
   .byte    030h
   .byte    030h
   .byte    030h
   .byte    030h
   .byte    033h
   .byte    03fh
   .byte    01eh

i2_kk:
   .byte    033h
   .byte    033h
   .byte    01bh
   .byte    0fh
   .byte    01fh
   .byte    033h
   .byte    033h
   .byte    033h

i2_ll:
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    01fh
   .byte    01fh

i2_mm:
   .byte    087h,03h
   .byte    0cfh,03h
   .byte    0cfh,03h
   .byte    07bh,03h
   .byte    07bh,03h
   .byte    033h,03h
   .byte    033h,03h
   .byte    033h,03h

i2_nn:
   .byte    063h
   .byte    067h
   .byte    06fh
   .byte    06fh
   .byte    07bh
   .byte    07bh
   .byte    073h
   .byte    063h

i2_oo:
   .byte    03eh
   .byte    07fh
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    07fh
   .byte    03eh

i2_pp:
   .byte    01fh
   .byte    03fh
   .byte    033h
   .byte    03fh
   .byte    01fh
   .byte    03h
   .byte    03h
   .byte    03h

i2_qq:
   .byte    03eh
   .byte    07fh
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    07fh
   .byte    03eh
   .byte    060h
   .byte    060h

i2_rr:
   .byte    01fh
   .byte    03fh
   .byte    033h
   .byte    03fh
   .byte    01fh
   .byte    033h
   .byte    033h
   .byte    033h

i2_ss:
   .byte    03eh
   .byte    03fh
   .byte    03h
   .byte    01fh
   .byte    03eh
   .byte    030h
   .byte    03fh
   .byte    01fh

i2_tt:
   .byte    03fh
   .byte    03fh
   .byte    0ch
   .byte    0ch
   .byte    0ch
   .byte    0ch
   .byte    0ch
   .byte    0ch

i2_uu:
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    03fh
   .byte    01eh

i2_vv:
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    036h
   .byte    036h
   .byte    03eh
   .byte    01ch
   .byte    01ch

i2_ww:
   .byte    023h,06h
   .byte    023h,06h
   .byte    073h,06h
   .byte    076h,03h
   .byte    076h,03h
   .byte    0deh,03h
   .byte    08ch,01h
   .byte    08ch,01h

i2_xx:
   .byte    063h
   .byte    063h
   .byte    036h
   .byte    01ch
   .byte    01ch
   .byte    036h
   .byte    063h
   .byte    063h

i2_yy:
   .byte    033h
   .byte    033h
   .byte    01eh
   .byte    01eh
   .byte    0ch
   .byte    0ch
   .byte    0ch
   .byte    0ch

i2_zz:
   .byte    03fh
   .byte    03fh
   .byte    038h
   .byte    01ch
   .byte    0eh
   .byte    07h
   .byte    03fh
   .byte    03fh

i2_arrowl
   .byte    70h,0
   .byte    38h,0
   .byte    1ch,0
   .byte    0feh,3fh
   .byte    0ffh,3fh
   .byte    0feh,3fh
   .byte    1ch,0
   .byte    38h,0
   .byte    70h,0

i2_arrowr
   .byte    80h,03h
   .byte    00h,07h
   .byte    00h,0eh
   .byte    0ffh,1fh
   .byte    0ffh,3fh
   .byte    0ffh,1fh
   .byte    00h,0eh
   .byte    00h,07h
   .byte    80h,03h

i2_arrowu
   .byte    10h,0
   .byte    38h,0
   .byte    7ch,0
   .byte    0feh,0
   .byte    0bbh,01h
   .byte    039h,01h
   .byte    038h,0
   .byte    038h,0
   .byte    038h,0
   .byte    038h,0
   .byte    038h,0
   .byte    038h,0
   .byte    038h,0

i2_arrowd
   .byte    038h,0
   .byte    038h,0
   .byte    038h,0
   .byte    038h,0
   .byte    038h,0
   .byte    038h,0
   .byte    038h,0
   .byte    039h,01h
   .byte    0bbh,01h
   .byte    0feh,0
   .byte    7ch,0
   .byte    38h,0
   .byte    10h,0

  .end
