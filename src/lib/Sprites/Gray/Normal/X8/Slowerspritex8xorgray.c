extern void SpriteX8_XOR_R(register short x asm("%d0"), register short y asm("%d1"),register short h asm("%d2"),register unsigned char *sprt asm("%a1"),register short w asm("%d3"),register void *dest asm("%a0")) __attribute__((__regparm__));

void __attribute__((__stkparm__)) SlowerGraySpriteX8_XOR(short x,short y,short h,
                      unsigned char* sprite1,
                      unsigned char* sprite2,
                      short bytewidth,
                      void* dest1,
                      void* dest2)
{
    SpriteX8_XOR_R(x,y,h,sprite1,bytewidth,dest1);
    SpriteX8_XOR_R(x,y,h,sprite2,bytewidth,dest2);
}
