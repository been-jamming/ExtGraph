| C prototype: void Tile8x8_RPLC_R(unsigned short col asm("%d0"), unsigned short y asm("%d1"), const unsigned char *sprite asm("%a1"), void *plane asm("%a0"));

.text
.globl Tile8x8_RPLC_R
.even

Tile8x8_RPLC_R:
    move.w   %d1,%d2
    lsl.w    #4,%d1
    sub.w    %d2,%d1
 
    add.w    %d1,%d1
    add.w    %d0,%d1
 
    adda.w   %d1,%a0
 

    move.b   (%a1)+,(%a0)
 
    move.b   (%a1)+,30(%a0)

    move.b   (%a1)+,60(%a0)

    move.b   (%a1)+,90(%a0)

    move.b   (%a1)+,120(%a0)

    move.b   (%a1)+,150(%a0)

    move.b   (%a1)+,180(%a0)

    move.b   (%a1)+,210(%a0)
  
    rts
