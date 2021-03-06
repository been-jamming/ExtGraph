| C prototype: void RotateSprite8_R(const unsigned char *src asm("%a0"), unsigned char *dest asm("%a1"), unsigned short height, short originX asm("%d1"), short originY asm("%d2"), long degreesClockwise asm("%d0")) __attribute__((__stkparm__));
|
| Courtesy of Joey Adams.
| Modified by Lionel Debroux:
| * renamed labels.
| * slightly optimized for size.

.text
.even
.globl RotateSprite8_R
RotateSprite8_R:
	movem.l %d3-%d7/%a2-%a6,-(%a7)
	move.w 10*4+4(%a7),%d5 |height
	jbsr RS_detrSC
	lea 10f(%pc),%a3 | Save sp.
	move.l %a7,(%a3)
	move.l %d3,%a7 |yv
	lsl.l #3,%d0
	add.l %a5,%d0
	move.l %d0,%a6 |yvr
	move.l %a5,%d0
	lsl.l #3,%d0
	sub.l %a4,%d0
	move.w %d5,rs8_heightdropoff+2-10f(%a3)
	move.l %d0,%a3 |xvr
	move.l %a1,%a2 |origDestSprite
	adda.w %d5,%a1
rs8_yloop:
	cmpa.l %a2,%a1
	bls.s rs8_endy
	moveq #0,%d6
	moveq #7,%d5
rs8_xloop:
	moveq #13,%d7
	move.l %a7,%d0
	asr.l %d7,%d0
	add.w %d2,%d0 |y2
	blt.s rs8_continue
    rs8_heightdropoff:
	cmp.w #0xDEED,%d0
	bge rs8_continue
	move.b (%a0,%d0.w),%d3 |current row data
	move.l %d4,%d0
	asr.l %d7,%d0
	add.w %d1,%d0 |x2
	blt.s rs8_continue
	cmp.w #8,%d0
	bge.s rs8_continue
	eor.w #7,%d0
	btst %d0,%d3
	beq.s rs8_continue
	bset %d5,%d6
rs8_continue:
	add.l %a4,%a7
	add.l %a5,%d4
	dbf %d5,rs8_xloop
	move.b %d6,-(%a1)
	sub.l %a6,%a7
	sub.l %a3,%d4
	bra.s rs8_yloop
rs8_endy:
	|%d0.l is general purpose
	|%d1.w is originX
	|%d2.w is originY
	|%d3.l is general purpose
	|%d4.l is xv
	|%d5.w is height, then tracer (%d5.l)
	|%d6.l is rowresult
	|%d7.l is general purpose
	|%a0.a is source address
	|%a1.a is destination address
	|%a2.a is original destination
	|%a3.a is xvr
	|%a4.a is sin -degrees *8192
	|%a5.a is cos -degrees *8192
	|%a6.a is yvr
	|%a7.a is yv
	move.l 10f(%pc),%a7
	movem.l (%a7)+,%d3-%d7/%a2-%a6
	rts

10:
	.long 0
