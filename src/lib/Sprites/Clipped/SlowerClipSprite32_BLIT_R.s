| C prototype: void SlowerClipSprite32_BLIT_R(register short x asm("%d0"),register short y asm("%d1"),register short h asm("%d2"),register unsigned long *sprt asm("%a1"),unsigned long maskval,register void *dest asm("%a0")) __attribute__((__stkparm__));

.text
.globl SlowerClipSprite32_BLIT_R
.even

SlowerClipSprite32_BLIT_R:
    move.l   %d3,-(%sp)

    subq.w   #1,%d2		| %d2 = h - 1
    move.w   %d1,%d3		| %d3 = y
    bpl.s    __YPositive_ClipSprite32_BLIT_R	| h > 0 ?

    add.w    %d1,%d2		| %d2 = y + h
    bmi.s    __End_ClipSprite32_BLIT_R		| y + h < 0 ?

    add.w    %d1,%d1		| %d1 = 2y
    add.w    %d1,%d1		| %d1 = 4y
    suba.w   %d1,%a1		| sprt -= 4y

    moveq.l  #0,%d1		| offsety = 0
    bra.s    __ClipX_ClipSprite32_BLIT_R

__YPositive_ClipSprite32_BLIT_R:
    subi.w   #127,%d3		| %d3 = y - 128
    bhi.s    __End_ClipSprite32_BLIT_R		| y - 128 > 0 ?

    add.w    %d2,%d3		| %d3 = h + y - 128
    bmi.s    __CalcOffset_ClipSprite32_BLIT_R	| h + y - 128 < 0 ?
    sub.w    %d3,%d2		| h -= h + y - 128
__CalcOffset_ClipSprite32_BLIT_R:
    move.w   %d1,%d3
    lsl.w    #4,%d1
    sub.w    %d3,%d1		| %d1 = y*15

__ClipX_ClipSprite32_BLIT_R:
    move.w   %d0,%d3		| %d3 = x
    bmi.s    __ClipXLeft_ClipSprite32_BLIT_R	| x < 0 ?

    cmpi.w   #239-32,%d0
    bhi.s    __ClipXRight_ClipSprite32_BLIT_R	| x > 239-15

    lsr.w    #4,%d3		| %d3 = x/16
    add.w    %d3,%d1		| %d3 = x/16 + y*15
    add.w    %d1,%d1		| %d3 = x/8 + y*30
    adda.w   %d1,%a0		| dest += offset

    moveq.l  #16,%d1
    andi.w   #15,%d0		| %d0 = righshift
    sub.w    %d0,%d1		| %d1 = 16 - (x & 15)

    move.w   %d4,-(%sp)
    move.l   %d5,-(%sp)
    move.w   %d6,-(%sp)
    
    move.l   4+4+2+4+2(%sp),%d5
    not.l    %d5
    move.w   %d5,%d6
    lsr.l    %d0,%d5
    not.l    %d5
    lsl.w    %d1,%d6
    not.w    %d6

__Loop_ClipSprite32_BLIT_R:
    and.l    %d5,(%a0)
    and.w    %d6,4(%a0)

    move.l   (%a1)+,%d3
    move.w   %d3,%d4
    lsr.l    %d0,%d3
    lsl.w    %d1,%d4
    or.l     %d3,(%a0)+
    or.w     %d4,(%a0)

    lea.l    26(%a0),%a0
    dbf      %d2,__Loop_ClipSprite32_BLIT_R

    move.w   (%sp)+,%d6
    move.l   (%sp)+,%d5
    move.w   (%sp)+,%d4
__End_ClipSprite32_BLIT_R:
    move.l   (%sp)+,%d3
    rts
__ClipXLeft_ClipSprite32_BLIT_R:
    cmpi.w   #-32,%d0
    bls.s    __End_ClipSprite32_BLIT_R		| x <= -32 ?

    neg.w    %d0		| shift = -x
    add.w    %d1,%d1		| %d1 = y*30
    adda.w   %d1,%a0

    move.l   8+2(%sp),%d3
    not.l    %d3
    lsl.l    %d0,%d3
    not.l    %d3

__LoopClipL_ClipSprite32_BLIT_R:
    and.l    %d3,(%a0)

    move.l   (%a1)+,%d1
    lsl.l    %d0,%d1		| shifting
    or.l     %d1,(%a0)

    lea.l    30(%a0),%a0
    dbf      %d2,__LoopClipL_ClipSprite32_BLIT_R

    move.l   (%sp)+,%d3
    rts
__ClipXRight_ClipSprite32_BLIT_R:
    cmpi.w   #239,%d0
    bhi.s    __End_ClipSprite32_BLIT_R		| x > 239

    add.w    %d1,%d1		| %d1 = y*30
    lea.l    26(%a0,%d1.w),%a0

    move.w   %d0,%d3
    andi.w   #15,%d0		| shiftx
    cmpi.w   #224,%d3
    blt.s    __PreLoopClipR_ClipSprite32_BLIT_R
    addi.w   #16,%d0

__PreLoopClipR_ClipSprite32_BLIT_R:
    move.l   8+2(%sp),%d3
    not.l    %d3
    lsr.l    %d0,%d3
    not.l    %d3

__LoopClipR_ClipSprite32_BLIT_R:
    and.l    %d3,(%a0)

    move.l   (%a1)+,%d1
    lsr.l    %d0,%d1
    or.l     %d1,(%a0)

    lea.l    30(%a0),%a0
    dbf      %d2,__LoopClipR_ClipSprite32_BLIT_R

    move.l   (%sp)+,%d3
    rts
