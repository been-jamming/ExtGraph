@REM @echo off
@echo ======= building extgraph library =======

cd Misc
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c versiondef.c
tigcc -O3 -fno-omit-frame-pointer -Wall -W -Wwrite-strings -ftracer -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c FloodFill.c
tigcc -O3 -fno-omit-frame-pointer -Wall -W -Wwrite-strings -ftracer -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c FloodFillMF.c
tigcc -O3 -fno-omit-frame-pointer -Wall -W -Wwrite-strings -ftracer -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c FloodFill_R.c
tigcc -O3 -fno-omit-frame-pointer -Wall -W -Wwrite-strings -ftracer -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c FloodFillMF_R.c
tigcc -O3 -fno-omit-frame-pointer -Wall -W -Wwrite-strings -ftracer -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c FloodFill_noshade_R.c
tigcc -O3 -fno-omit-frame-pointer -Wall -W -Wwrite-strings -ftracer -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c FloodFillMF_noshade_R.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c FilledTriangle_R.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c ClipFilledTriangle_R.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c GrayFilledTriangle_R.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c GrayClipFilledTriangle_R.c
cd ..\Grayutil
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c GrayDrawRect2B.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c GrayInvertRect2B.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c GrayDrawLine2B.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c GrayDrawClipLine2B.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c GrayFastDrawLine2B.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c GrayFastDrawHLine2B.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c GrayDrawStr2B.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c GrayDrawStrExt2B.c
cd ..\Rect
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c FastOutlineRect.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c FastOutlineRect_R.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c GrayFastOutlineRect_R.c
tigcc -Os -Wall -W -Wwrite-strings -ffunction-sections -fdata-sections -Wa,--all-relocs -D_GENERIC_ARCHIVE -c GrayFastFillRect_R.c
cd ..


tprbuilder extgraph.tpr

copy extgraph.a ..\..\lib
REM del extgraph.a
@echo on

@REM ..\..\bin\m68k-coff-ar -rv extgraph.a Misc\versiondef.o Misc\FloodFill.o Misc\FloodFillMF.o Misc\FloodFill_R.o Misc\FloodFillMF_R.o Misc\FloodFill_noshade_R.o Misc\FloodFillMF_noshade_R.o Misc\FilledTriangle_R.o Misc\ClipFilledTriangle_R.o Misc\GrayFilledTriangle_R.o Misc\GrayClipFilledTriangle_R.o
@REM ..\..\bin\m68k-coff-ar -rv extgraph.a Grayutil\GrayDrawRect2B.o Grayutil\GrayInvertRect2B.o Grayutil\GrayDrawLine2B.o Grayutil\GrayDrawClipLine2B.o Grayutil\GrayFastDrawLine2B.o Grayutil\GrayFastDrawHLine2B.o Grayutil\GrayDrawStr2B.o Grayutil\GrayDrawStrExt2B.o
@REM ..\..\bin\m68k-coff-ar -rv extgraph.a Rect\FastOutlineRect.o Rect\FastOutlineRect_R.o Rect\GrayFastOutlineRect_R.o Rect\GrayFastFillRect_R.o
