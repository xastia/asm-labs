.386
.model flat, stdcall
option casemap :none


public my_div2_result, my_dec2_result
extern Array_Of_My_A:qword, Array_Of_My_B:qword

.code
my_third_part PROC
    mov ebx, 4
    mov my_help, ebx
    fld qword ptr [my_current_a]
    fild dword ptr[my_help]
    fdiv
    fstp tbyte ptr[my_div2_result]

    fld tbyte ptr[my_div2_result]
    fld qword ptr [my_current_b]
    fsub
    fstp tbyte ptr[my_dec2_result]
    ret

my_third_part ENDP
end

