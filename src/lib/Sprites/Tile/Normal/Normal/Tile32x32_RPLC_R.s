| C prototype: void Tile32x32_RPLC_R(unsigned short col asm("%d0"), unsigned short y asm("%d1"), const unsigned long *sprite asm("%a1"), void *plane asm("%a0"));

.text
.globl Tile32x32_RPLC_R
.even

Tile32x32_RPLC_R:
    move.w   %d1,%d2
    lsl.w    #4,%d1
    sub.w    %d2,%d1
 
    add.w    %d0,%d1
    add.w    %d1,%d1

    adda.w   %d1,%a0
 
    moveq.l  #(32/8)-1,%d2
 
0:
    move.l   (%a1)+,(%a0)

    move.l   (%a1)+,30(%a0)

    move.l   (%a1)+,60(%a0)

    move.l   (%a1)+,90(%a0)

    move.l   (%a1)+,120(%a0)

    move.l   (%a1)+,150(%a0)

    move.l   (%a1)+,180(%a0)

    move.l   (%a1)+,210(%a0)

    lea.l    240(%a0),%a0
 
    dbf      %d2,0b
 
    rts
