	.text
	xdef DrawGrayBufferWithShifts89_TRANB

| Affiche le buffer de 5440 octets sur un buffer de 3840 octets, la couleur blanche est transparente

| Input :
| a0.l : adresse du buffer source
| a1.l : adresse du buffer destination
| a2.l : adresse de la table de d�calage horizontal
| a3.l : adresse de la table de d�calage vertical
| d0.w : d�calage sur x (0 <= d0 < 16)
| d1.w : d�calage sur y (0 <= d1 < 16)

| D�truit : d0-d2/a0-a1

DrawGrayBufferWithShifts89_TRANB:
    movem.l  %d3-%d7/%a2-%a6,-(%a7)

    add.w    %d1,%d1
    move.w   %d1,%d2
    lsl.w    #4,%d1
    add.w    %d2,%d1	| d1 = y*34
    adda.w   %d1,%a0	| scrolling vertical

    lea.l    5440(%a0),%a4
    lea.l    3840(%a1),%a5

    move.w   %d0,%a6

    moveq.l  #99,%d2

LineStart_DrawGrayBufferWithShifts89_TRANB:
    swap.w   %d2

    moveq.l  #16,%d1
    move.w   %a6,%d0
    add.b    (%a2),%d0
    cmp.w    %d1,%d0	| d0 < 16 ?
    blt.s    OK_DrawGrayBufferWithShifts89_TRANB
    addq.l   #2,%a0
    addq.l   #2,%a4
    sub.w    %d1,%d0
OK_DrawGrayBufferWithShifts89_TRANB:

    moveq.l  #-1,%d1
    lsl.w    %d0,%d1	| d1 = mask1
    move.w   %d1,%d2
    not.w    %d2	| d2 = mask2

    move.l   (%a0)+,%d3
    lsl.l    %d0,%d3

    move.l   (%a4)+,%d5
    lsl.l    %d0,%d5

    move.l   (%a0)+,%d4
    rol.l    %d0,%d4
    move.w   %d4,%d7
    and.w    %d2,%d7
    or.w     %d7,%d3

    move.l   (%a4)+,%d6
    rol.l    %d0,%d6
    move.w   %d6,%d7
    and.w    %d2,%d7
    or.w     %d7,%d5

    move.l   %d5,%d7
    not.l    %d7
    or.l     (%a1),%d7	| 1
    and.l    %d3,%d7
    move.l   %d7,(%a1)+

    not.l    %d3
    or.l     (%a5),%d3
    and.l    %d5,%d3
    move.l   %d3,(%a5)+

    and.w    %d1,%d4
    move.l   (%a0)+,%d3
    rol.l    %d0,%d3
    move.w   %d3,%d7
    and.w    %d2,%d7
    or.w     %d7,%d4

    and.w    %d1,%d6
    move.l   (%a4)+,%d5
    rol.l    %d0,%d5
    move.w   %d5,%d7
    and.w    %d2,%d7
    or.w     %d7,%d6

    move.l   %d6,%d7
    not.l    %d7
    or.l     (%a1),%d7	| 2
    and.l    %d4,%d7
    move.l   %d7,(%a1)+

    not.l    %d4
    or.l     (%a5),%d4
    and.l    %d6,%d4
    move.l   %d4,(%a5)+

    and.w    %d1,%d3
    move.l   (%a0)+,%d4
    rol.l    %d0,%d4
    move.w   %d4,%d7
    and.w    %d2,%d7
    or.w     %d7,%d3

    and.w    %d1,%d5
    move.l   (%a4)+,%d6
    rol.l    %d0,%d6
    move.w   %d6,%d7
    and.w    %d2,%d7
    or.w     %d7,%d5

    move.l   %d5,%d7
    not.l    %d7
    or.l     (%a1),%d7	| 3
    and.l    %d3,%d7
    move.l   %d7,(%a1)+

    not.l    %d3
    or.l     (%a5),%d3
    and.l    %d5,%d3
    move.l   %d3,(%a5)+

    and.w    %d1,%d4
    move.l   (%a0)+,%d3
    rol.l    %d0,%d3
    move.w   %d3,%d7
    and.w    %d2,%d7
    or.w     %d7,%d4

    and.w    %d1,%d6
    move.l   (%a4)+,%d5
    rol.l    %d0,%d5
    move.w   %d5,%d7
    and.w    %d2,%d7
    or.w     %d7,%d6

    move.l   %d6,%d7
    not.l    %d7
    or.l     (%a1),%d7	| 4
    and.l    %d4,%d7
    move.l   %d7,(%a1)+

    not.l    %d4
    or.l     (%a5),%d4
    and.l    %d6,%d4
    move.l   %d4,(%a5)+

    and.w    %d1,%d3
    move.w   (%a0)+,%d4
    rol.w    %d0,%d4
    and.w    %d2,%d4
    or.w     %d4,%d3

    and.w    %d1,%d5
    move.w   (%a4)+,%d6
    rol.w    %d0,%d6
    and.w    %d2,%d6
    or.w     %d6,%d5

    move.l   %d5,%d7
    not.l    %d7
    or.l     (%a1),%d7	| 5
    and.l    %d3,%d7
    move.l   %d7,(%a1)+

    not.l    %d3
    or.l     (%a5),%d3
    and.l    %d5,%d3
    move.l   %d3,(%a5)+

    moveq.l  #10,%d1

    move.w   %a6,%d0	| D�calage initial
    add.b    (%a2)+,%d0	| D�calage horizontal
    cmpi.w   #16,%d0	| d0 < 16 ?
    bge.s    OK2_DrawGrayBufferWithShifts89_TRANB
    addq.w   #2,%d1
OK2_DrawGrayBufferWithShifts89_TRANB:

    add.w    (%a3)+,%d1	| d�calage vertical

    adda.w   %d1,%a0
    adda.w   %d1,%a4
    lea.l    10(%a1),%a1
    lea.l    10(%a5),%a5

    swap.w   %d2
    dbf      %d2,LineStart_DrawGrayBufferWithShifts89_TRANB

    movem.l  (%a7)+,%d3-%d7/%a2-%a6
    rts
