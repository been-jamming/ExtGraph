	.text
	xdef DrawGrayBuffer_OR

| Affiche le buffer de 5440 octets sur un buffer de 3840 octets en faisant un OR

| Input :
| a0.l : adresse du buffer source
| a1.l : adresse du buffer destination
| d0.w : d�calage sur x (0 <= d0 < 32)
| d1.w : d�calage sur y (0 <= d1 < 32)

| D�truit : d0-d2/a0-a1

DrawGrayBuffer_OR:
    movem.l  %d3-%d7/%a2-%a3,-(%a7)

    add.w    %d1,%d1
    move.w   %d1,%d2
    lsl.w    #4,%d1
    add.w    %d2,%d1	| d1 = y*34
    adda.w   %d1,%a0	| scrolling vertical

    moveq.l  #16,%d1
    cmp.w    %d1,%d0	| d0 < 16 ?
    blt.s    OK_DrawGrayBuffer_OR
    addq.l   #2,%a0
    sub.w    %d1,%d0
OK_DrawGrayBuffer_OR:

    lea.l    5440(%a0),%a2
    lea.l    3840(%a1),%a3

    moveq.l  #127,%d7

    moveq.l  #-1,%d1
    lsl.w    %d0,%d1	| d1 = mask1
    move.w   %d1,%d2
    not.w    %d2	| d2 = mask2

LineStart_DrawGrayBuffer_OR:
    move.l   (%a0)+,%d3
    lsl.l    %d0,%d3

    move.l   (%a0)+,%d4
    rol.l    %d0,%d4
    move.w   %d4,%d5
    and.w    %d2,%d5
    or.w     %d5,%d3
    or.l     %d3,(%a1)+	| 1

    move.l   (%a2)+,%d5
    lsl.l    %d0,%d5

    move.l   (%a2)+,%d6
    rol.l    %d0,%d6
    move.w   %d6,%d3
    and.w    %d2,%d3
    or.w     %d3,%d5
    or.l     %d5,(%a3)+

    and.w    %d1,%d4
    move.l   (%a0)+,%d3
    rol.l    %d0,%d3
    move.w   %d3,%d5
    and.w    %d2,%d5
    or.w     %d5,%d4
    or.l     %d4,(%a1)+	| 2

    and.w    %d1,%d6
    move.l   (%a2)+,%d5
    rol.l    %d0,%d5
    move.w   %d5,%d4
    and.w    %d2,%d4
    or.w     %d4,%d6
    or.l     %d6,(%a3)+

    and.w    %d1,%d3
    move.l   (%a0)+,%d4
    rol.l    %d0,%d4
    move.w   %d4,%d6
    and.w    %d2,%d6
    or.w     %d6,%d3
    or.l     %d3,(%a1)+	| 3

    and.w    %d1,%d5
    move.l   (%a2)+,%d6
    rol.l    %d0,%d6
    move.w   %d6,%d3
    and.w    %d2,%d3
    or.w     %d3,%d5
    or.l     %d5,(%a3)+

    and.w    %d1,%d4
    move.l   (%a0)+,%d3
    rol.l    %d0,%d3
    move.w   %d3,%d5
    and.w    %d2,%d5
    or.w     %d5,%d4
    or.l     %d4,(%a1)+	| 4

    and.w    %d1,%d6
    move.l   (%a2)+,%d5
    rol.l    %d0,%d5
    move.w   %d5,%d4
    and.w    %d2,%d4
    or.w     %d4,%d6
    or.l     %d6,(%a3)+

    and.w    %d1,%d3
    move.l   (%a0)+,%d4
    rol.l    %d0,%d4
    move.w   %d4,%d6
    and.w    %d2,%d6
    or.w     %d6,%d3
    or.l     %d3,(%a1)+	| 5

    and.w    %d1,%d5
    move.l   (%a2)+,%d6
    rol.l    %d0,%d6
    move.w   %d6,%d3
    and.w    %d2,%d3
    or.w     %d3,%d5
    or.l     %d5,(%a3)+

    and.w    %d1,%d4
    move.l   (%a0)+,%d3
    rol.l    %d0,%d3
    move.w   %d3,%d5
    and.w    %d2,%d5
    or.w     %d5,%d4
    or.l     %d4,(%a1)+	| 6

    and.w    %d1,%d6
    move.l   (%a2)+,%d5
    rol.l    %d0,%d5
    move.w   %d5,%d4
    and.w    %d2,%d4
    or.w     %d4,%d6
    or.l     %d6,(%a3)+

    and.w    %d1,%d3
    move.l   (%a0)+,%d4
    rol.l    %d0,%d4
    and.w    %d2,%d4
    or.w     %d4,%d3
    or.l     %d3,(%a1)+	| 7

    and.w    %d1,%d5
    move.l   (%a2)+,%d6
    rol.l    %d0,%d6
    and.w    %d2,%d6
    or.w     %d6,%d5
    or.l     %d5,(%a3)+

    swap.w   %d4
    swap.w   %d6

    or.w     %d4,(%a1)+
    or.w     %d6,(%a3)+

    addq.l   #2,%a0
    addq.l   #2,%a2

    dbf      %d7,LineStart_DrawGrayBuffer_OR

    movem.l  (%a7)+,%d3-%d7/%a2-%a3
    rts
