tigcc -O3 -Wall -W -fomit-frame-pointer -Wwrite-strings -mpcrel -mregparm=5 -ffunction-sections -fdata-sections --optimize-code --cut-ranges --reorder-sections -mno-bss -Wa,-l -Wa,--all-relocs -DUSE_TI89 %1.c ..\..\lib\extgraph.a ..\..\lib\tilemap.a %2
move %1.89z ..\..\bin89
tigcc -O3 -Wall -W -fomit-frame-pointer -Wwrite-strings -mpcrel -mregparm=5 -ffunction-sections -fdata-sections --optimize-code --cut-ranges --reorder-sections -mno-bss -Wa,-l -Wa,--all-relocs -DUSE_TI92P -DUSE_V200 %1.c ..\..\lib\extgraph.a ..\..\lib\tilemap.a %2
move %1.9xz ..\..\bin92pv200
move %1.v2z ..\..\bin92pv200
