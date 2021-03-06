| C prototype: void GrayClipISprite32_XOR_R(short x asm("%d0"), short y asm("%d1"), unsigned short height asm("%d2"), const unsigned long *sprite, void *dest0 asm("%a0"), void *dest1 asm("%a1")) __attribute__((__stkparm__));

.text
.globl GrayClipISprite32_XOR_R
.even

GrayClipISprite32_XOR_R:
    move.l   %d3,-(%sp)
    move.l   %a2,-(%sp)

    move.l   4+8(%sp),%a2

    subq.w   #1,%d2		| %d2 = h - 1
    move.w   %d1,%d3		| %d3 = y
    bpl.s    9f	| h > 0 ?

    add.w    %d1,%d2		| %d2 = y + h
    bmi.s    0f		| y + h < 0 ?

    lsl.w    #3,%d1		| %d1 = 8y
    suba.w   %d1,%a2		| sprite -= 8y
    moveq.l  #0,%d1		| offsety = 0
    bra.s    10f

9:
    add.w    %d2,%d3		| %d3 = h + y
    subi.w   #127,%d3		| %d3 = h + y - 127
    ble.s    6f			| h + y - 127 <= 0 ?
    sub.w    %d3,%d2		| h -= h + y - 127 (h = 127-y)
    bmi.s    0f

6:
    move.w   %d1,%d3
    lsl.w    #4,%d1
    sub.w    %d3,%d1		| %d1 = y*15

10:
    move.w   %d0,%d3		| %d3 = x
    ble.s    8f	| x < 0 ?
    cmpi.w   #239-32,%d0
    bhi.s    7f	| x > 239-32

    lsr.w    #4,%d3		| %d3 = x/16
    add.w    %d3,%d1		| %d3 = x/16 + y*15
    add.w    %d1,%d1		| %d3 = x/8 + y*30
    adda.w   %d1,%a0		| dest += offset
    adda.w   %d1,%a1
    moveq.l  #16,%d1
    andi.w   #15,%d0		| %d0 = righshift
    sub.w    %d0,%d1		| %d1 = 16 - (x & 15)
    move.w   %d4,-(%sp)
    move.w   %d5,-(%sp)

    moveq.l  #-1,%d3
    lsl.l    %d1,%d3
    move.w   %d3,%d4
    not.w    %d4
1:
    move.l   (%a2)+,%d0
    rol.l    %d1,%d0
    move.w   %d0,%d5
    and.w    %d4,%d5
    eor.w    %d5,(%a0)+
    and.l    %d3,%d0
    eor.l    %d0,(%a0)

    move.l   (%a2)+,%d0
    rol.l    %d1,%d0
    move.w   %d0,%d5
    and.w    %d4,%d5
    eor.w    %d5,(%a1)+
    and.l    %d3,%d0
    eor.l    %d0,(%a1)

    lea.l    28(%a0),%a0
    lea.l    28(%a1),%a1
    dbf      %d2,1b
    move.w   (%sp)+,%d5
    move.w   (%sp)+,%d4

0:
    move.l   (%sp)+,%a2
    move.l   (%sp)+,%d3
    rts

8:
    cmpi.w   #-32,%d0
    ble.s    0b		| x <= -32 ?
    neg.w    %d0		| shift = -x
    add.w    %d1,%d1		| %d1 = y*30
    adda.w   %d1,%a0		| dest += offset
    adda.w   %d1,%a1
4:
    move.l   (%a2)+,%d1
    lsl.l    %d0,%d1		| shifting
    eor.l    %d1,(%a0)

    move.l   (%a2)+,%d1
    lsl.l    %d0,%d1		| shifting
    eor.l    %d1,(%a1)

    lea.l    30(%a0),%a0
    lea.l    30(%a1),%a1
    dbf      %d2,4b

    move.l   (%sp)+,%a2
    move.l   (%sp)+,%d3
    rts

7:
    cmpi.w   #239,%d0
    bhi.s    0b		| x > 239

    add.w    %d1,%d1		| %d1 = y*30
    addi.w   #26,%d1
    adda.w   %d1,%a0
    adda.w   %d1,%a1

    subi.w   #208,%d0		| shiftx

5:
    move.l   (%a2)+,%d1
    lsr.l    %d0,%d1
    eor.l    %d1,(%a0)

    move.l   (%a2)+,%d1
    lsr.l    %d0,%d1
    eor.l    %d1,(%a1)

    lea.l    30(%a0),%a0
    lea.l    30(%a1),%a1
    dbf      %d2,5b

    move.l   (%sp)+,%a2
    move.l   (%sp)+,%d3
    rts
