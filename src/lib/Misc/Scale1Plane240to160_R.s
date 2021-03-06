| C prototype: void Scale1Plane240to160_R(const void *src asm("%a0"), void *dest asm("%a1"));
| Courtesy of Geoffrey Anneheim IIRC, modified to fit the needs.

.text
.globl Scale1Plane240to160_R
.even

Scale1Plane240to160_R:
    movem.l  %d3-%d5/%a4-%a5,-(%sp)

    lea      8f(%pc),%a4  | Array of 5-bit-wide elements
    lea      9f(%pc),%a5  | Array of 6-bit-wide elements

    moveq    #0,%d1
    move.w   #32768,%d5
0:
    moveq    #128-1,%d2
1:
    moveq    #(20/2)-1,%d0

    add.w    #7296,%d5  | 32768-(99/128*32768+128)
    bmi.s    2f | Optimization: if > 32768 (unsigned), then it is negative !
    sub.w    #32768,%d5
    lea      30(%a0),%a0
    dbf      %d2,2f
3:
    movem.l  (%sp)+,%d3-%d5/%a4-%a5
    rts

2:
    moveq    #0,%d4

    | Byte 1 (5)
    move.b   (%a0)+,%d1
    move.b   0(%a4,%d1.w),%d3
    lsl.w    #3,%d3
    move.b   %d3,(%a1)+
    
    | Byte 2 (6)
    move.b   (%a0)+,%d1
    move.b   0(%a5,%d1.w),%d4
    
    | Byte 3 (5)
    move.b   (%a0)+,%d1
    move.b   0(%a4,%d1.w),%d3
    move.b   %d3,(%a1)+

    lsl.w    #3,%d4
    or.w     %d4,-2(%a1)

    | We're done with those 24 (-> 16) pixels.
    dbf      %d0,2b

    | Skip unused part of the screen and loop over...
    lea.l    10(%a1),%a1
    dbf      %d2,1b
    bra.s    3b


| Array of 5-bit-wide elements
8:
  .byte  0b00000000
  .byte  0b00000000
  .byte  0b00000001
  .byte  0b00000001
  .byte  0b00000000
  .byte  0b00000000
  .byte  0b00000001
  .byte  0b00000001
  .byte  0b00000010
  .byte  0b00000010
  .byte  0b00000011
  .byte  0b00000011
  .byte  0b00000010
  .byte  0b00000010
  .byte  0b00000011
  .byte  0b00000011
  .byte  0b00000100
  .byte  0b00000100
  .byte  0b00000101
  .byte  0b00000101
  .byte  0b00000100
  .byte  0b00000100
  .byte  0b00000101
  .byte  0b00000101
  .byte  0b00000110
  .byte  0b00000110
  .byte  0b00000111
  .byte  0b00000111
  .byte  0b00000110
  .byte  0b00000110
  .byte  0b00000111
  .byte  0b00000111
  .byte  0b00001000
  .byte  0b00001000
  .byte  0b00001001
  .byte  0b00001001
  .byte  0b00001000
  .byte  0b00001000
  .byte  0b00001001
  .byte  0b00001001
  .byte  0b00001010
  .byte  0b00001010
  .byte  0b00001011
  .byte  0b00001011
  .byte  0b00001010
  .byte  0b00001010
  .byte  0b00001011
  .byte  0b00001011
  .byte  0b00001100
  .byte  0b00001100
  .byte  0b00001101
  .byte  0b00001101
  .byte  0b00001100
  .byte  0b00001100
  .byte  0b00001101
  .byte  0b00001101
  .byte  0b00001110
  .byte  0b00001110
  .byte  0b00001111
  .byte  0b00001111
  .byte  0b00001110
  .byte  0b00001110
  .byte  0b00001111
  .byte  0b00001111
  .byte  0b00000000
  .byte  0b00000000
  .byte  0b00000001
  .byte  0b00000001
  .byte  0b00000000
  .byte  0b00000000
  .byte  0b00000001
  .byte  0b00000001
  .byte  0b00000010
  .byte  0b00000010
  .byte  0b00000011
  .byte  0b00000011
  .byte  0b00000010
  .byte  0b00000010
  .byte  0b00000011
  .byte  0b00000011
  .byte  0b00000100
  .byte  0b00000100
  .byte  0b00000101
  .byte  0b00000101
  .byte  0b00000100
  .byte  0b00000100
  .byte  0b00000101
  .byte  0b00000101
  .byte  0b00000110
  .byte  0b00000110
  .byte  0b00000111
  .byte  0b00000111
  .byte  0b00000110
  .byte  0b00000110
  .byte  0b00000111
  .byte  0b00000111
  .byte  0b00001000
  .byte  0b00001000
  .byte  0b00001001
  .byte  0b00001001
  .byte  0b00001000
  .byte  0b00001000
  .byte  0b00001001
  .byte  0b00001001
  .byte  0b00001010
  .byte  0b00001010
  .byte  0b00001011
  .byte  0b00001011
  .byte  0b00001010
  .byte  0b00001010
  .byte  0b00001011
  .byte  0b00001011
  .byte  0b00001100
  .byte  0b00001100
  .byte  0b00001101
  .byte  0b00001101
  .byte  0b00001100
  .byte  0b00001100
  .byte  0b00001101
  .byte  0b00001101
  .byte  0b00001110
  .byte  0b00001110
  .byte  0b00001111
  .byte  0b00001111
  .byte  0b00001110
  .byte  0b00001110
  .byte  0b00001111
  .byte  0b00001111
  .byte  0b00010000
  .byte  0b00010000
  .byte  0b00010001
  .byte  0b00010001
  .byte  0b00010000
  .byte  0b00010000
  .byte  0b00010001
  .byte  0b00010001
  .byte  0b00010010
  .byte  0b00010010
  .byte  0b00010011
  .byte  0b00010011
  .byte  0b00010010
  .byte  0b00010010
  .byte  0b00010011
  .byte  0b00010011
  .byte  0b00010100
  .byte  0b00010100
  .byte  0b00010101
  .byte  0b00010101
  .byte  0b00010100
  .byte  0b00010100
  .byte  0b00010101
  .byte  0b00010101
  .byte  0b00010110
  .byte  0b00010110
  .byte  0b00010111
  .byte  0b00010111
  .byte  0b00010110
  .byte  0b00010110
  .byte  0b00010111
  .byte  0b00010111
  .byte  0b00011000
  .byte  0b00011000
  .byte  0b00011001
  .byte  0b00011001
  .byte  0b00011000
  .byte  0b00011000
  .byte  0b00011001
  .byte  0b00011001
  .byte  0b00011010
  .byte  0b00011010
  .byte  0b00011011
  .byte  0b00011011
  .byte  0b00011010
  .byte  0b00011010
  .byte  0b00011011
  .byte  0b00011011
  .byte  0b00011100
  .byte  0b00011100
  .byte  0b00011101
  .byte  0b00011101
  .byte  0b00011100
  .byte  0b00011100
  .byte  0b00011101
  .byte  0b00011101
  .byte  0b00011110
  .byte  0b00011110
  .byte  0b00011111
  .byte  0b00011111
  .byte  0b00011110
  .byte  0b00011110
  .byte  0b00011111
  .byte  0b00011111
  .byte  0b00010000
  .byte  0b00010000
  .byte  0b00010001
  .byte  0b00010001
  .byte  0b00010000
  .byte  0b00010000
  .byte  0b00010001
  .byte  0b00010001
  .byte  0b00010010
  .byte  0b00010010
  .byte  0b00010011
  .byte  0b00010011
  .byte  0b00010010
  .byte  0b00010010
  .byte  0b00010011
  .byte  0b00010011
  .byte  0b00010100
  .byte  0b00010100
  .byte  0b00010101
  .byte  0b00010101
  .byte  0b00010100
  .byte  0b00010100
  .byte  0b00010101
  .byte  0b00010101
  .byte  0b00010110
  .byte  0b00010110
  .byte  0b00010111
  .byte  0b00010111
  .byte  0b00010110
  .byte  0b00010110
  .byte  0b00010111
  .byte  0b00010111
  .byte  0b00011000
  .byte  0b00011000
  .byte  0b00011001
  .byte  0b00011001
  .byte  0b00011000
  .byte  0b00011000
  .byte  0b00011001
  .byte  0b00011001
  .byte  0b00011010
  .byte  0b00011010
  .byte  0b00011011
  .byte  0b00011011
  .byte  0b00011010
  .byte  0b00011010
  .byte  0b00011011
  .byte  0b00011011
  .byte  0b00011100
  .byte  0b00011100
  .byte  0b00011101
  .byte  0b00011101
  .byte  0b00011100
  .byte  0b00011100
  .byte  0b00011101
  .byte  0b00011101
  .byte  0b00011110
  .byte  0b00011110
  .byte  0b00011111
  .byte  0b00011111
  .byte  0b00011110
  .byte  0b00011110
  .byte  0b00011111
  .byte  0b00011111

| Array of 6-bit-wide elements (pre-shifted left by 2 at assemble-time, to be faster at run-time).
9:
  .byte  0b00000000
  .byte  0b00000100
  .byte  0b00001000
  .byte  0b00001100
  .byte  0b00000000
  .byte  0b00000100
  .byte  0b00001000
  .byte  0b00001100
  .byte  0b00010000
  .byte  0b00010100
  .byte  0b00011000
  .byte  0b00011100
  .byte  0b00010000
  .byte  0b00010100
  .byte  0b00011000
  .byte  0b00011100
  .byte  0b00100000
  .byte  0b00100100
  .byte  0b00101000
  .byte  0b00101100
  .byte  0b00100000
  .byte  0b00100100
  .byte  0b00101000
  .byte  0b00101100
  .byte  0b00110000
  .byte  0b00110100
  .byte  0b00111000
  .byte  0b00111100
  .byte  0b00110000
  .byte  0b00110100
  .byte  0b00111000
  .byte  0b00111100
  .byte  0b01000000
  .byte  0b01000100
  .byte  0b01001000
  .byte  0b01001100
  .byte  0b01000000
  .byte  0b01000100
  .byte  0b01001000
  .byte  0b01001100
  .byte  0b01010000
  .byte  0b01010100
  .byte  0b01011000
  .byte  0b01011100
  .byte  0b01010000
  .byte  0b01010100
  .byte  0b01011000
  .byte  0b01011100
  .byte  0b01100000
  .byte  0b01100100
  .byte  0b01101000
  .byte  0b01101100
  .byte  0b01100000
  .byte  0b01100100
  .byte  0b01101000
  .byte  0b01101100
  .byte  0b01110000
  .byte  0b01110100
  .byte  0b01111000
  .byte  0b01111100
  .byte  0b01110000
  .byte  0b01110100
  .byte  0b01111000
  .byte  0b01111100
  .byte  0b00000000
  .byte  0b00000100
  .byte  0b00001000
  .byte  0b00001100
  .byte  0b00000000
  .byte  0b00000100
  .byte  0b00001000
  .byte  0b00001100
  .byte  0b00010000
  .byte  0b00010100
  .byte  0b00011000
  .byte  0b00011100
  .byte  0b00010000
  .byte  0b00010100
  .byte  0b00011000
  .byte  0b00011100
  .byte  0b00100000
  .byte  0b00100100
  .byte  0b00101000
  .byte  0b00101100
  .byte  0b00100000
  .byte  0b00100100
  .byte  0b00101000
  .byte  0b00101100
  .byte  0b00110000
  .byte  0b00110100
  .byte  0b00111000
  .byte  0b00111100
  .byte  0b00110000
  .byte  0b00110100
  .byte  0b00111000
  .byte  0b00111100
  .byte  0b01000000
  .byte  0b01000100
  .byte  0b01001000
  .byte  0b01001100
  .byte  0b01000000
  .byte  0b01000100
  .byte  0b01001000
  .byte  0b01001100
  .byte  0b01010000
  .byte  0b01010100
  .byte  0b01011000
  .byte  0b01011100
  .byte  0b01010000
  .byte  0b01010100
  .byte  0b01011000
  .byte  0b01011100
  .byte  0b01100000
  .byte  0b01100100
  .byte  0b01101000
  .byte  0b01101100
  .byte  0b01100000
  .byte  0b01100100
  .byte  0b01101000
  .byte  0b01101100
  .byte  0b01110000
  .byte  0b01110100
  .byte  0b01111000
  .byte  0b01111100
  .byte  0b01110000
  .byte  0b01110100
  .byte  0b01111000
  .byte  0b01111100
  .byte  0b10000000
  .byte  0b10000100
  .byte  0b10001000
  .byte  0b10001100
  .byte  0b10000000
  .byte  0b10000100
  .byte  0b10001000
  .byte  0b10001100
  .byte  0b10010000
  .byte  0b10010100
  .byte  0b10011000
  .byte  0b10011100
  .byte  0b10010000
  .byte  0b10010100
  .byte  0b10011000
  .byte  0b10011100
  .byte  0b10100000
  .byte  0b10100100
  .byte  0b10101000
  .byte  0b10101100
  .byte  0b10100000
  .byte  0b10100100
  .byte  0b10101000
  .byte  0b10101100
  .byte  0b10110000
  .byte  0b10110100
  .byte  0b10111000
  .byte  0b10111100
  .byte  0b10110000
  .byte  0b10110100
  .byte  0b10111000
  .byte  0b10111100
  .byte  0b11000000
  .byte  0b11000100
  .byte  0b11001000
  .byte  0b11001100
  .byte  0b11000000
  .byte  0b11000100
  .byte  0b11001000
  .byte  0b11001100
  .byte  0b11010000
  .byte  0b11010100
  .byte  0b11011000
  .byte  0b11011100
  .byte  0b11010000
  .byte  0b11010100
  .byte  0b11011000
  .byte  0b11011100
  .byte  0b11100000
  .byte  0b11100100
  .byte  0b11101000
  .byte  0b11101100
  .byte  0b11100000
  .byte  0b11100100
  .byte  0b11101000
  .byte  0b11101100
  .byte  0b11110000
  .byte  0b11110100
  .byte  0b11111000
  .byte  0b11111100
  .byte  0b11110000
  .byte  0b11110100
  .byte  0b11111000
  .byte  0b11111100
  .byte  0b10000000
  .byte  0b10000100
  .byte  0b10001000
  .byte  0b10001100
  .byte  0b10000000
  .byte  0b10000100
  .byte  0b10001000
  .byte  0b10001100
  .byte  0b10010000
  .byte  0b10010100
  .byte  0b10011000
  .byte  0b10011100
  .byte  0b10010000
  .byte  0b10010100
  .byte  0b10011000
  .byte  0b10011100
  .byte  0b10100000
  .byte  0b10100100
  .byte  0b10101000
  .byte  0b10101100
  .byte  0b10100000
  .byte  0b10100100
  .byte  0b10101000
  .byte  0b10101100
  .byte  0b10110000
  .byte  0b10110100
  .byte  0b10111000
  .byte  0b10111100
  .byte  0b10110000
  .byte  0b10110100
  .byte  0b10111000
  .byte  0b10111100
  .byte  0b11000000
  .byte  0b11000100
  .byte  0b11001000
  .byte  0b11001100
  .byte  0b11000000
  .byte  0b11000100
  .byte  0b11001000
  .byte  0b11001100
  .byte  0b11010000
  .byte  0b11010100
  .byte  0b11011000
  .byte  0b11011100
  .byte  0b11010000
  .byte  0b11010100
  .byte  0b11011000
  .byte  0b11011100
  .byte  0b11100000
  .byte  0b11100100
  .byte  0b11101000
  .byte  0b11101100
  .byte  0b11100000
  .byte  0b11100100
  .byte  0b11101000
  .byte  0b11101100
  .byte  0b11110000
  .byte  0b11110100
  .byte  0b11111000
  .byte  0b11111100
  .byte  0b11110000
  .byte  0b11110100
  .byte  0b11111000
  .byte  0b11111100
