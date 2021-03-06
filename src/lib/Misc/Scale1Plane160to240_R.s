| C prototype: void Scale1Plane160to240_R(const void *src asm("%a0"), void *dest asm("%a1"));
|
| Routine courtesy of GoldenCrystal. It gives better-looking results than
| my attempt to "reverse" geogeo's routine, commented below, does.
| Modified by Lionel Debroux:
| * optimized for size (it's already large enough, there's no need to unroll
|   the loops, which does not help much speed-wise anyway !), replace
|   copy&paste with macros. It is much more readable now.
| * changed calling convention (the macros made it easier).

.text
.globl Scale1Plane160to240_R
.even

.macro STRETCH_LINE
	| Proc�dure pour �crire trois octets de destination en partant de deux octets source
	| Sera r�p�t�e 10 fois pour �crire une ligne
	move.w (%a0)+,%d2 | Charge le premier mot dans d2
	move.w %d2,%d3 | Copie vers d3
	andi.w #0x3F,%d3 | Conserve uniquement les 6 derniers bits de d3
	move.b (0,%d3.w,%a4),(%a1) | Ecrit le troisi�me octet
	lsr.w #5,%d2 | D�cale d2 de 5 bits vers la droite
	move.w %d2,%d3 | Copie d2 vers d3
	andi.w #0x3F,%d3
	move.b (0,%d3.w,%a3),-(%a1) | Ecrit le deuxi�me octet
	lsr.w #6,%d2 | D�cale d2 de 6 bits vers la droite
	move.b (0,%d2.w,%a2),-(%a1) | Ecrit le premier octet
	addq.w #5,%a1 | Incr�mente le pointeur de 5 pour le bloc suivant
.endm

.macro NEXT_LINE
	subq.w #2,%a1 | D�cr�mente le pointeur destination de 2, passage � la ligne suivante
	lea (10, %a0),%a0 | Incr�mente le pointeur source de 10, passage � la ligne suivante
.endm

.macro COPY_LINE
	| On copie la ligne pr�cedente ici
	movem.l (-30,%a1),%d2-%d7/%a5
	movem.l %d2-%d7/%a5,(%a1)
	move.w -(%a1),%d2
	lea (28+2,%a1),%a1
	move.w %d2,(%a1)+
.endm


.macro MAKE_LINE
	addq.w #2,%a1

	moveq #10-1,%d4
0:
	STRETCH_LINE
	
	dbf %d4,0b
	
	NEXT_LINE
.endm


Scale1Plane160to240_R:
	movem.l %d3-%d7/%a2-%a5,-(%a7)
	lea 7f(%pc),%a2
	lea 8f(%pc),%a3
	lea 9f(%pc),%a4
	| On va �crire des blocs de 32 lignes (3 blocs de 9 lignes et un bloc de 5), il faudra r�p�ter l'op�ration 4 fois
	| Le redimensionnement 100 -> 128 est moins r�p�titif que le redimensionnement 160 -> 240
	| Il se d�compose de fa�on primaire en 4 r�p�titions identiques
	| Dans chacune de ces r�p�titions il y a 2 types de sous-r�p�titions
	| Une ligne double suivie de deux lignes simples
	| Une ligne double suivie de trois lignes simples
	| On encha�ne 3 r�p�titions 211-2111 puis une r�p�tition 2111
	moveq #4-1,%d0
2:
	moveq #3-1,%d1
1:
	MAKE_LINE
	COPY_LINE

	MAKE_LINE

	MAKE_LINE
	

	MAKE_LINE
	COPY_LINE
	
	MAKE_LINE

	MAKE_LINE

	MAKE_LINE

	dbf %d1,1b


	MAKE_LINE
	COPY_LINE
	
	MAKE_LINE
	
	MAKE_LINE

	MAKE_LINE

	dbf %d0,2b
	
	movem.l (%a7)+,%d3-%d7/%a2-%a5
	rts

7:
.byte 0x00, 0x03, 0x04, 0x07, 0x18, 0x1B, 0x1C, 0x1F, 0x20, 0x23, 0x24, 0x27, 0x38, 0x3B, 0x3C, 0x3F, 0xC0, 0xC3, 0xC4, 0xC7, 0xD8, 0xDB, 0xDC, 0xDF, 0xE0, 0xE3, 0xE4, 0xE7, 0xF8, 0xFB, 0xFC, 0xFF

8:
.byte 0x00, 0x01, 0x02, 0x03, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13, 0x1C, 0x1D, 0x1E, 0x1F, 0x60, 0x61, 0x62, 0x63, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x7C, 0x7D, 0x7E, 0x7F, 0x80, 0x81, 0x82, 0x83, 0x8C, 0x8D, 0x8E, 0x8F, 0x90, 0x91, 0x92, 0x93, 0x9C, 0x9D, 0x9E, 0x9F, 0xE0, 0xE1, 0xE2, 0xE3, 0xEC, 0xED, 0xEE, 0xEF, 0xF0, 0xF1, 0xF2, 0xF3, 0xFC, 0xFD, 0xFE, 0xFF

9:
.byte 0x00, 0x01, 0x06, 0x07, 0x08, 0x09, 0x0E, 0x0F, 0x30, 0x31, 0x36, 0x37, 0x38, 0x39, 0x3E, 0x3F, 0x40, 0x41, 0x46, 0x47, 0x48, 0x49, 0x4E, 0x4F, 0x70, 0x71, 0x76, 0x77, 0x78, 0x79, 0x7E, 0x7F, 0x80, 0x81, 0x86, 0x87, 0x88, 0x89, 0x8E, 0x8F, 0xB0, 0xB1, 0xB6, 0xB7, 0xB8, 0xB9, 0xBE, 0xBF, 0xC0, 0xC1, 0xC6, 0xC7, 0xC8, 0xC9, 0xCE, 0xCF, 0xF0, 0xF1, 0xF6, 0xF7, 0xF8, 0xF9, 0xFE, 0xFF


/*
| Made by Lionel Debroux, from Scale1Plane240to160_R.

.text
.globl Scale1Plane160to240_R
.even

Scale1Plane160to240_R:
    movem.l  %d3-%d5/%a4-%a5,-(%sp)

    lea      sc1p160x240_t(%pc),%a4  | Array of 5-bit-wide elements

    moveq    #0,%d1
    move.w   #0,%d5
0:
    moveq    #128-1,%d2
1:
    moveq    #(20/2)-1,%d0

    addi.w   #9276,%d5  | (128/100*32768+100)-32768
    bmi.s    2f | Optimization: if > 32768 (unsigned), then it is negative !
    subi.w   #32768,%d5
    lea      -30(%a1),%a5
    move.l   (%a5)+,(%a1)+
    move.l   (%a5)+,(%a1)+
    move.l   (%a5)+,(%a1)+
    move.l   (%a5)+,(%a1)+
    move.l   (%a5)+,(%a1)+
    move.l   (%a5)+,(%a1)+
    move.l   (%a5)+,(%a1)+
    move.w   (%a5)+,(%a1)+
    dbf      %d2,2f
3:
    movem.l  (%sp)+,%d3-%d5/%a4-%a5
    rts

2:
    clr.w    %d1
    move.b   (%a0)+,%d1
    add.w    %d1,%d1
    move.b   0(%a4,%d1.w),(%a1)+
    move.b   1(%a4,%d1.w),(%a1)
    
    clr.w    %d1
    move.b   (%a0)+,%d1
    add.w    %d1,%d1
    move.b   0(%a4,%d1.w),%d3
    lsr.b    #4,%d3
    or.b     %d3,(%a1)+
    move.w   0(%a4,%d1.w),%d3
    lsr.w    #4,%d3
    move.b   %d3,(%a1)+
    
    | We're done with those 16 (-> 24) pixels.
    dbf      %d0,2b

    | Skip unused part of the screen and loop over...
    lea      10(%a0),%a0
    dbf      %d2,1b
    bra.s    3b


| Array of 12-bit-wide elements
.globl sc1p160x240_t
sc1p160x240_t:
.skip 256*16/8


extern unsigned short sc1p160x240_t[256];

| Le r�sultat de 160->240->160 est meilleur, mais le r�sultat de 240->160->240 est moins bon.
| Fait grosses strings.
|unsigned char t[4] = {0b000,0b011,0b110,0b111};
| Le r�sultat de 160->240->160 est moins bon, mais le r�sultat de 240->160->240 est meilleur.
| Fait strings coup�es...
|//unsigned char t[4] = {0b000,0b001,0b100,0b111};

void gen_table(void) {
    unsigned short i = 0, res = 0;
    unsigned short *ptr = sc1p160x240_t;
    for (i = 0; i < 256; i++) {
        res = t[(i>>6)&3];
        res <<= 3;
        res |= t[(i>>4)&3];
        res <<= 3;
        res |= t[(i>>2)&3];
        res <<= 3;
        res |= t[(i>>0)&3];
        *ptr++ = res << 4;
    }
}
*/
