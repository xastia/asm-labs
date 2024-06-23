.386
option casemap :none
include \masm32\include\masm32rt.inc 



CheckAndProcessParity MACRO
    mov edi, eax
    mov ebx,2
    cdq
    idiv ebx
    test edx,edx
    jz is_even          
    imul eax, edi, 5    
    jmp end_check      

is_even:

end_check:
 ENDM


.data
buff db 512 dup(?) 

    Array_Of_My_A dd 8, -4, 12, -20, 4
    Array_Of_My_C dd 4, -5, -4, 5, 6
    Array_Of_My_D dd 2, -3, -2, 4, 5

title_of_my_messagebox db "Lab5-Dvoretska",0
data_of_my_messagebox db "My variant is 6",10
                      db "My formula is: (-2*ñ + d*82)/(a/4 - 1)",10
                      db "Numbers, which I used:",10
                      db "a=%d, c=%d, d=%d",10
                      db "My result is: %d",10
                      db "My result after changing: %d",0
data_of_my_error_messagebox db "My variant is 6",10
                            db "My formula is: (-2*ñ + d*82)/(a/4 - 1)",10
                            db "Error! It's impossible",0



.code
mainLab5:
    xor esi,esi
    xor edi,edi
    xor ebp,ebp
    xor ecx,ecx

   

    mov esi, OFFSET Array_Of_My_A    
    mov edi, OFFSET Array_Of_My_C     
    mov ebp, OFFSET Array_Of_My_D     
              

    mov ecx, 5
loop_for_my_lab:
    xor edx,edx
    push ecx
    push esi
    push edi
    push ebp
    

    xor ecx,ecx
    mov ecx, [ebp] 
    mov eax, [esi]  
    
    push eax
    
    xor edx,edx
    mov ebx, 4
    cdq
    idiv ebx
    
    dec eax
    test eax, eax
    jz error_of_0
    
    mov esi, eax
    mov ebx, [edi]
    push ebx
    xor edx,edx
    imul edx, ebx, -2
    
    mov ebx, ecx
    imul ebx, 82
    
    add edx, ebx
    
    mov eax, edx
    xor edx,edx
    cdq             
    idiv esi
    
    mov ebp, eax
    CheckAndProcessParity
    mov edx, ebp
    mov esi,eax
    pop ebx
    pop eax
    
    
    invoke wsprintf, ADDR buff, ADDR data_of_my_messagebox, eax, ebx, ecx, edx, esi
    invoke MessageBox, 0, ADDR buff, ADDR title_of_my_messagebox, MB_OK
    
    pop ebp
    pop edi
    pop esi
    
    add esi, 4
    add edi, 4
    add ebp, 4
    
    pop ecx
    dec ecx
    jnz loop_for_my_lab
     
    

       error_of_0:
         invoke MessageBox, 0,ADDR data_of_my_error_messagebox, ADDR title_of_my_messagebox, MB_ICONERROR  
    
invoke ExitProcess, 0
end mainLab5
    
