OPTION DOTNAME
option casemap:none

include \masm64\include\temphls.inc
include \masm64\include\win64.inc
include \masm64\include\kernel32.inc
include \masm64\include\user32.inc
include \masm64\include\temphls.inc
includelib \masm64\lib\kernel32.lib
includelib \masm64\lib\user32.lib

.data
    title_of_messagebox db "Lab1(64)", 0
    data_of_messagebox  db "My full name: Anastasia Dvoretska", 10
                        db "My birthday: 16.05.2005", 10
                        db "My student card's 4 last numbers: 8760", 0

.code
WinMain proc
    sub rsp, 28h                 
    invoke MessageBox, 0, offset data_of_messagebox, offset title_of_messagebox, MB_ICONINFORMATION
    invoke ExitProcess, 0

   WinMain endp

end