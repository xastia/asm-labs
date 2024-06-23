.386
option casemap :none
include \masm32\include\masm32rt.inc 

.data
buff db 256 dup(?) 
buffD db 32 dup(?) 
buffE db 32 dup(?) 
buffF db 32 dup(?)
buffMinusD db 32 dup(?) 
buffMinusE db 32 dup(?) 
buffMinusF db 32 dup(?)

              

title_of_messagebox db "Lab2", 0
data_of_messagebox db "My birthday: 16.05.2005", 10
                   db "My student card's 4 last numbers(N): 8760", 10
                   db "My numbers:",10
                   db "A=%d, -A=%d", 10
                   db "B=%d, -B=%d", 10
                   db "C=%d, -C=%d", 10
                   db "D=%s, -D=%s", 10
                   db "E=%s, -E=%s", 10
                   db "F=%s, -F=%s", 0



A db 16
PlusA1 dw 16
PlusA2 dd 16
PlusA3 dq 16
MinusA db -16
MinusA1 dw -16
MinusA2 dd -16
MinusA3 dq -16

B dw 1605
PlusB1 dd 1605
PlusB2 dq 1605
MinusB dw -1605
MinusB1 dd -1605
MinusB2 dq -1605

PlusC dd 16052005
PlusC1 dq 16052005
MinusC dd -16052005
MinusC1 dq -16052005

D dq 0.002
PlusD1 dd 0.002
MinusD dq -0.002
MinusD1 dd -0.002

E dq 0.183
MinusE dq -0.183

F dq 1832.421
MinusF dq -1832.421
PlusF1 dt 1832.421
MinusF1 dt -1832.421

.code
Main:
invoke FloatToStr2, D, addr buffD 
invoke FloatToStr2, MinusD, addr buffMinusD 
invoke FloatToStr2, E, addr buffE
invoke FloatToStr2, F, addr buffF
invoke FloatToStr2, MinusE, addr buffMinusE
invoke FloatToStr2, MinusF, addr buffMinusF
invoke wsprintf, addr buff, addr data_of_messagebox, PlusA2, MinusA2, PlusB1, MinusB1, PlusC, MinusC, addr buffD, addr buffMinusD, addr buffE, addr buffMinusE, addr buffF, addr buffMinusF
invoke MessageBox, 0, addr buff, addr title_of_messagebox, 0
invoke ExitProcess, 0
end Main