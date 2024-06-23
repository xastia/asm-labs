.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib
includelib user32.lib
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\InputBox.inc

IB_XPOS         equ 100
IB_YPOS         equ 100
buffersize      equ 32

.DATA

StrLen		    dd	0
buffer		    db	buffersize DUP(?)
buffer_encrypted      db      buffersize DUP(?) 
message		    dd	0

title_of_inputbox       db "lab3",0
info_title              db "Information",0
error_title             db "Error",0
msg_to_enter_pass       db "Enter your password",0
msg_if_field_empty      db "You need to enter password",0
my_data_from_lab1       db "My full name: Anastasia Dvoretska", 10
                        db "My birthday: 16.05.2005", 10
                        db "My student card's 4 last numbers: 8760", 0

msg_if_pass_incorrect   db "The password is incorrect! Try again",0
my_pass                 db  "IIJKM@",0
xor_key                 db  "xastia",0

.CODE

_main:

	mov message, OFFSET msg_to_enter_pass
    go_start:
    invoke InputBox, message, ADDR title_of_inputbox , ADDR buffer, buffersize, IB_XPOS, IB_YPOS, ADDR StrLen
    test   eax, eax                 
    jz     finish                   
    mov    eax, StrLen
    test   eax, eax                
    jnz    go_check                
    mov    message, OFFSET msg_if_field_empty     
    jmp    go_start                 
        go_check:
    mov esi, OFFSET buffer
    mov edi, OFFSET buffer_encrypted
    mov ebx, OFFSET xor_key
    mov ecx, StrLen
    xor_loop:
        lodsb                        
        xor al, BYTE PTR [ebx]      
        stosb                        
        loop xor_loop               
    invoke lstrcmp, ADDR buffer_encrypted, ADDR my_pass
    cmp    eax, 0                   
    jz     password_correct         
    invoke MessageBoxA, 0,OFFSET msg_if_pass_incorrect, ADDR error_title, MB_ICONERROR  
    jmp    go_start
    password_correct:
    invoke MessageBoxA, 0, ADDR my_data_from_lab1, ADDR info_title, MB_ICONINFORMATION    
    jmp    go_start

	finish:
    invoke ExitProcess, 0
	
END _main






