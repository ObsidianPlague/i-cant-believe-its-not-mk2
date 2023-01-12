.286

%	.MODEL	model,lang

	include mixed.inc

.DATA

d	dw	?
red	db	?
grn	db	?
blu	db	?
mindx	dw	?
pxlcnt	db	?

.CODE


color_average	PROC USES si di,xdelt:WORD,c1:PTR BYTE,ColorPal:PTR WORD,num_cols:WORD
	cld
	pLes	di,ColorPal
	mov	bx,xdelt
	xor	dx,dx		; redsum in dx = 0
	xor	cx,cx		; grnsum in cx = 0, num non-trans in lower cl
	push	ds
	pLds	si,c1
	push	bp
	xor	bp,bp		; blusum in bp = 0.
	
	mov	al,[si]
	call	add2sum
	mov	al,[si+2]
	call	add2sum
	mov	al,[bx][si]
	call	add2sum
	mov	al,[bx][si+2]
	call	add2sum

	mov	bx,bp
	pop	bp
	pop	ds
	mov	al,cl
	shr	dx,2		; align redsum
	shr	cx,5		; align grnsum
	and	al,1fh
	cmp	al,2	 	; if < 2 are non-trans pixels, keep it trans
	je	pix2		; if = 2, do shift
	jg	nottrans
	xor	ax,ax
	RET
nottrans:
	cmp	al,4	    	; if all 4 are non-trans, treat normally
	je	normal
	jmp	div3	    	; other numbers, must divide
pix2:
	shl	dx,1		; mult sums by 2. when they are div by 4 later
	shl	cx,1	 	; the net result is a division by 2 
	shl	bx,1
normal:
	shr	dx,2		; if all 4 pixels, div by 4
	shr	cx,2
	shr	bx,2
norm3:
	and	cx,1fh		; grn to match in cx
	and	dx,1fh		; red to match in dx
	and	bx,1fh		; blu to match in bx

	call	find_closest	; leaves closest in ax
	RET


div3: 
	xchg	ax,bx
	div	bl
	mov	bh,al		; blusum quotient in bh temp.
	mov	ax,cx
	div	bl
	mov	cl,al		; grn quotient back in cl
	mov	ax,dx
	div	bl
	mov	dl,al		; red quotient back in dl
	mov	bl,bh		; blue fix
	jmp	norm3

color_average	ENDP



add2sum:
	push	bx
	mov	bl,al		; color index in bh
	xor	bh,bh
	shl	bx,1
	jz	trans
	inc	cl		; counter of non-trans pixels
	mov	ax,FP[bx][di]	
	mov	bx,ax
	and	bx,7c1fh	; isolate red and blue in bx
	and	ax,3e0h		; isolate green
	add	cx,ax		; add grn to sum in cx
	xor	ax,ax
	xchg 	al,bh		; red in ax, blue in bx
	add	dx,ax		; add red to sum in dx
	add	bp,bx		; add blu to sum in bp
trans:
	pop	bx
	ret




find_closest:
	xor	si,si			; indx
	mov	blu,bl
	mov	red,dl
	mov	grn,cl
	mov	word ptr d,5000		; minsum
	mov	cx,num_cols
	dec	cx
	add	di,2
minloop:
	mov	ax,FP[di]	; next color from palette in ax
	add	di,2
	inc	si	      
	mov	bx,ax		
	shr	bh,2
	and	bx,1f1fh 	; blu in bl, red in bh
	sub	bl,blu
	sub	bh,red
	shr	ax,5
	and	al,1fh		; grn in al
	sub	al,grn
	imul	al	       
	mov	dx,ax		; new sum started in dx
	mov	al,bl
	imul	bl
	add	dx,ax
	mov	al,bh
	imul	bh
	add	dx,ax		; new sum complete in dx
	jz	exact
	cmp	dx,d
	jg	toloop
	mov	mindx,si
	mov	d,dx
toloop:
	loop	minloop
	mov	ax,mindx
	RET	     

exact:	mov	ax,si
	RET
	


	END

