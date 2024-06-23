@echo off
ml /c /coff "7-06-IM-21-Dvoretska.asm"
ml /c /coff "7-06-IM-21-Dvoretska-PROC.asm"
link /subsystem:WINDOWS "7-06-IM-21-Dvoretska.obj" "7-06-IM-21-Dvoretska-PROC.obj"
7-06-IM-21-Dvoretska.exe 