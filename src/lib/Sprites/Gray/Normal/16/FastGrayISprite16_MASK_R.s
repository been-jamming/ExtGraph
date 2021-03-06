| C prototype: void FastGrayISprite16_MASK_R(short x,short y,short h,short* sprite,void* dest);
| Environ 57% plus rapide que GraySprite16_MASK d'extgraph 1.02

.text
.globl FastGrayISprite16_MASK_R
.even
FastGrayISprite16_MASK_R:
    dbf      %d2,__suite__
    rts

__suite__:
    move.w   %d3,-(%a7)

    move.w   %d1,%d3
    lsl.w    #4,%d1
    sub.w    %d3,%d1

    move.w   %d0,%d3
    lsr.w    #4,%d3

    add.w    %d3,%d1
    add.w    %d1,%d1
    adda.w   %d1,%a0

    move.w   (%a7)+,%d3

    and.w    #0xF,%d0
    cmpi.w   #7,%d0
    bls.s    Pre_Boucle16_LSR

    moveq    #16,%d1
    sub.w    %d0,%d1

    lsr.w    #1,%d2
    bcs.s    _loop_Sprite16_MASK

    lea.l    -30(%a0),%a0
    bra.s    Milieu_Boucle16

_loop_Sprite16_MASK:
| light mask line 1
    moveq.l  #-1,%d0
    move.w   (%a1)+,%d0
    rol.l    %d1,%d0
    and.l    %d0,(%a0)
| dark mask line 1
    and.l    %d0,6000(%a0)
| light sprite line 1
    moveq    #0,%d0
    move.w   (%a1)+,%d0
    lsl.l    %d1,%d0
    or.l     %d0,(%a0)
|dark sprite line 1
    moveq    #0,%d0
    move.w   (%a1)+,%d0
    lsl.l    %d1,%d0
    or.l     %d0,6000(%a0)

Milieu_Boucle16:
| light mask line 2
    moveq.l  #-1,%d0
    move.w   (%a1)+,%d0
    rol.l    %d1,%d0
    and.l    %d0,30(%a0)
| dark mask line 2
    and.l    %d0,6000+30(%a0)
| light sprite line 2
    moveq    #0,%d0
    move.w   (%a1)+,%d0
    lsl.l    %d1,%d0
    or.l     %d0,30(%a0)
| dark sprite line 2
    moveq    #0,%d0
    move.w   (%a1)+,%d0
    lsl.l    %d1,%d0
    or.l     %d0,6000+30(%a0)

    lea.l    60(%a0),%a0

    dbf      %d2,_loop_Sprite16_MASK

    rts

Pre_Boucle16_LSR:
    lsr.w    #1,%d2
    bcs.s    Boucle16_LSR

    lea.l    -30(%a0),%a0
    bra.s    Milieu_Boucle16_LSR

Boucle16_LSR:
| light mask, line 1
    moveq.l  #-1,%d1
    move.w   (%a1)+,%d1
    swap     %d1
    ror.l    %d0,%d1
    and.l    %d1,(%a0)
| dark mask, line 1
    and.l    %d1,6000(%a0)
| light sprite, line 1
    moveq.l  #0,%d1
    move.w   (%a1)+,%d1
    swap.w   %d1
    lsr.l    %d0,%d1
    or.l     %d1,(%a0)
| dark sprite, line 1
    moveq    #0,%d1
    move.w   (%a1)+,%d1
    swap.w   %d1
    lsr.l    %d0,%d1
    or.l     %d1,6000(%a0)

Milieu_Boucle16_LSR:
| light mask, line 2
    moveq.l  #-1,%d1
    move.w   (%a1)+,%d1
    swap     %d1
    ror.l    %d0,%d1
    and.l    %d1,30(%a0)
| dark mask, line 2
    and.l    %d1,6000+30(%a0)
| light sprite, line 2
    moveq    #0,%d1
    move.w   (%a1)+,%d1
    swap.w   %d1
    lsr.l    %d0,%d1
    or.l     %d1,30(%a0)
| dark sprite, line 2
    moveq    #0,%d1
    move.w   (%a1)+,%d1
    swap.w   %d1
    lsr.l    %d0,%d1
    or.l     %d1,6000+30(%a0)

    lea.l    60(%a0),%a0

    dbf      %d2,Boucle16_LSR

    rts
