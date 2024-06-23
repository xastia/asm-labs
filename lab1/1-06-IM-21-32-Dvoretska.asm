.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib


.data

title_of_messagebox db "Lab1(32)", 0
data_of_messagebox db "My full name: Anastasiia Dvoretska", 10
                   db "My birthday: 16.05.2005", 10
                   db "My student card's 4 last numbers: 8760", 0

.code

start:
     
     invoke MessageBox, 0, offset data_of_messagebox, offset title_of_messagebox, MB_ICONINFORMATION
     invoke ExitProcess, 0
      
     invoke ExitProcess, 0 

end start