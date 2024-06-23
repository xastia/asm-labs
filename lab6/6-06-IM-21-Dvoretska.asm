.386
option casemap :none
include \masm32\include\masm32rt.inc 





.data
buff db 512 dup(?) 
buff_of_null db 512 dup(?) 
buff_of_error db 512 dup(?)
buff_of_a db 256 dup(?)
buff_of_b db 256 dup(?)
buff_of_c db 256 dup(?)
buff_of_d db 256 dup(?)
buff_of_res db 512 dup(?)

    Array_Of_My_A dq 1.3, -2.6, 4.1, -5.3, 4.4
    Array_Of_My_B dq -3.2, 10.2, 4.3, -7.8, 1.1
    Array_Of_My_C dq -2.5, 27.4, -5.9, 30.1, -2.8
    Array_Of_My_D dq 2.6, -3.3, 7.3, 7.7, 5.6

title_of_my_messagebox db "Lab6-Dvoretska",0
data_of_my_messagebox db "My variant is 6",10
                      db "My formula is: (-2*ñ - sin(a/d) + 53)/(a/4 - b)",10
                      db "Numbers, which I used:",10
                      db "a=%s, b=%s, c=%s, d=%s",10
                      db "My result is: %s",0
                      
data_of_my_error_messagebox db "My variant is 6",10
                            db "My formula is: (-2*ñ - sin(a/d) + 53)/(a/4 - b)",10
                            db "Numbers, which I used:",10
                            db "a=%s, b=%s, c=%s, d=%s",10
                            db "Error! It's impossible",0
;my_current_a db 256 dup(?)
;my_current_b db 256 dup(?)
;my_current_c db 256 dup(?)
;my_current_d db 256 dup(?)
my_current_a dq ?
my_current_b dq ?
my_current_c dq ?
my_current_d dq ?

my_mul_result dt ?
my_div1_result dt ?
my_dec1_result dt ?
my_sin_result dt ?
my_add_result dt ?
my_div2_result dt ?
my_dec2_result dt ?
my_end_result dq ?
my_help dd ?

my_test dq ?


.code
mainLab6:
    xor esi,esi
    xor edi,edi
    xor ebp,ebp
    xor ecx,ecx
    xor eax,eax 

    finit
    ffree st(0)
    
    mov esi, OFFSET Array_Of_My_A    
    mov eax, OFFSET Array_Of_My_B
    mov edi, OFFSET Array_Of_My_C     
    mov ebp, OFFSET Array_Of_My_D     
              

    mov ecx, 5
loop_for_my_lab:
    push ecx
    push esi
    push eax
    push edi
    push ebp

    ffree st(0)
    fld qword ptr[ebp]
    fstp qword ptr [my_current_d] 
    fld qword ptr [edi]
    fstp qword ptr [my_current_c]
    fld qword ptr [eax]
    fstp qword ptr [my_current_b]
    fld qword ptr [esi]
   ; fstp qword ptr [my_test]
    fstp qword ptr [my_current_a]
 
   
    mov ebx, -2
    mov my_help, ebx
    ffree st(0)
    fild dword ptr[my_help]
    fld qword ptr [my_current_c]
    fmul st, st(1)
    fstp tbyte ptr[my_mul_result]
    ;fstp qword ptr [my_test]

    ffree st(0)
    fld qword ptr [my_current_a]
    fld qword ptr [my_current_d]
    fdiv
    fstp tbyte ptr[my_div1_result]
    ;fstp qword ptr [my_test]

    ffree st(0)
    fld tbyte ptr [my_div1_result]
    fsin
    fstp tbyte ptr[my_sin_result]
    ;fstp qword ptr [my_test]

    ffree st(0)
    fld tbyte ptr[my_mul_result]
    fld tbyte ptr[my_sin_result]
    fsub
    fstp tbyte ptr[my_dec1_result]

    mov ebx, 53
    mov my_help, ebx
    ffree st(0)
    fld tbyte ptr[my_dec1_result]
    fild dword ptr[my_help]
    fadd
    fstp tbyte ptr[my_add_result]
    ;fstp qword ptr[my_test]

    mov ebx, 4
    mov my_help, ebx
    ffree st(0)
    fld qword ptr [my_current_a]
    fild dword ptr[my_help]
    fdiv
    fstp tbyte ptr[my_div2_result]

    ffree st(0)
    fld tbyte ptr[my_div2_result]
    fld qword ptr [my_current_b]
    fsub
    fstp tbyte ptr[my_dec2_result]

    ;fld qword ptr [my_current_a]
   ; fstp qword ptr[my_test]
    ffree st(0)
    fld tbyte ptr[my_dec2_result]
    fldz
    fcomp st(1)
    fstsw ax
    sahf
    jz is_null          
    
    jmp end_check      

    is_null:
     
        ;invoke FloatToStr2, my_end_result, addr buff_of_error
        invoke FloatToStr, my_current_a, addr buff_of_a
        invoke FloatToStr2, my_current_b, addr buff_of_b
        invoke FloatToStr2, my_current_c, addr buff_of_c
        invoke FloatToStr2, my_current_d, addr buff_of_d
        invoke wsprintf, addr buff_of_null, addr data_of_my_error_messagebox, addr buff_of_a, addr buff_of_b, addr buff_of_c, addr buff_of_d
        invoke MessageBox, 0, addr buff_of_null, addr title_of_my_messagebox,  MB_ICONERROR  
        jz end_of
    

    end_check:
        ffree st(0)
        fld tbyte ptr[my_add_result]
        fld tbyte ptr[my_dec2_result]
        fdiv
        fstp qword ptr[my_end_result]

       ; invoke FloatToStr, [my_end_result], addr buff_of_error
        invoke FloatToStr, [my_current_a], addr buff_of_a
        invoke FloatToStr2, [my_current_b], addr buff_of_b
        invoke FloatToStr2, [my_current_c], addr buff_of_c
        invoke FloatToStr, [my_end_result], addr buff_of_res
        invoke FloatToStr2, [my_current_d], addr buff_of_d
        
        invoke wsprintf, addr buff, addr data_of_my_messagebox, addr buff_of_a, addr buff_of_b, addr buff_of_c, addr buff_of_d, addr buff_of_res
        invoke MessageBox, 0, addr buff, addr title_of_my_messagebox, 0
    
    
    end_of:
        ffree st(0)
        pop ebp
        pop edi
        pop eax
        pop esi
    
        add esi, 8
        add eax, 8
        add edi, 8
        add ebp, 8
    
 
        pop ecx
        dec ecx
    jnz loop_for_my_lab

 
             
invoke ExitProcess, 0
end mainLab6
    

