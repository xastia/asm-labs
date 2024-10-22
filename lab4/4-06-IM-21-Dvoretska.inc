make_my_messagebox MACRO message:REQ, title_of_messagebox:REQ;�������� ����������
    invoke MessageBox, 0, offset message, offset title_of_messagebox, 0 
   
   ;;  �� �� ������ ���������� ��������
   
ENDM

encrypt_string MACRO input_string:REQ, output_buffer:REQ, xor_key:REQ
    LOCAL xor_loop
    mov esi, OFFSET input_string
    mov edi, OFFSET output_buffer
    mov ebx, OFFSET xor_key
    
    xor_loop:
        lodsb
        test al, al          ; ��������, �� �� ����� �����
        jz end_loop         ; ���� ���, ������� � �����
        xor al, BYTE PTR [ebx]
        stosb
        jmp xor_loop
    
    end_loop:
    ; ����� �������� ������, ��� ��������� �����
    mov byte ptr [edi], 0
   
    ;;  �� �� ������ ���������� ��������
  

ENDM

compare_strings MACRO string1:REQ, string2:REQ
        LOCAL compare_loop, compare_done
    jmp compare_done         ; ������� �� ��������� �����
    compare_loop:
        lodsb               ; ����������� ��������� ������ ������� �����
        cmp al, [esi]       ; �������� ���� � ��������� �������� ������� �����
        jne compare_done    ; ���� ������� �����������, ����� � �����
        test al, al         ; ���������, �� �� ����� ������� �����
        jz compare_done     ; ���� ���, ������ ����� �������, ����� � �����
        inc esi             ; ������� �� ���������� ������� ������� �����
        inc edi             ; ������� �� ���������� ������� ������� �����
        jmp compare_loop    ; ��������� ���� ��������
    compare_done:
        invoke lstrcmp, ADDR string1, ADDR string2 ; ������ ������� lstrcmp ��� ��������� �����
       
         ;; �� �� ����� � �������� ���������� ��������:)
    

ENDM
