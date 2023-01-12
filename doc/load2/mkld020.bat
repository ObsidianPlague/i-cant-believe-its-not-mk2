del cc.err
if .%1==.   goto instr
if .%1==./D goto dbg
if .%1==./L goto linkonly
cl /AL /G2  /c /DW020 %1.c %2.c >> cc.err
if ERRORLEVEL 1 goto showerr
link load2 ldbgnd2 emmprim load2asm,load20,,lg020com /CO /ST:8000;
rem copy loadimg.exe e:\bin
goto end
:dbg
cl /Od /Zi /G2 /AL /c /DW020 %2.c %3.c   >> cc.err
if ERRORLEVEL 1 goto showerr
:linkonly
link load2 ldbgnd2 emmprim load2asm,load20,,lg020com /CO  /ST:8000;
goto end
:showerr
type cc.err
goto end
:instr
echo  Usage:   mkld020 [opts]  file1  file2   where file1 and file2 are
echo+                                       load2 and or ldbgnd2
echo+         options:  /D = debug,  /L = link only
:end
