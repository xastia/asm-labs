make_my_messagebox MACRO message:REQ, title_of_messagebox:REQ;викликаю меседжбокс
    invoke MessageBox, 0, offset message, offset title_of_messagebox, 0 
   
   ;;  Це мій перший прихований коментар
   
ENDM

encrypt_string MACRO input_string:REQ, output_buffer:REQ, xor_key:REQ
    LOCAL xor_loop
    mov esi, OFFSET input_string
    mov edi, OFFSET output_buffer
    mov ebx, OFFSET xor_key
    
    xor_loop:
        lodsb
        test al, al          ; Перевіряю, чи це кінець рядка
        jz end_loop         ; Якщо так, виходжу з циклу
        xor al, BYTE PTR [ebx]
        stosb
        jmp xor_loop
    
    end_loop:
    ; Додаю нульовий символ, щоб завершити рядок
    mov byte ptr [edi], 0
   
    ;;  Це мій другий прихований коментар
  

ENDM

compare_strings MACRO string1:REQ, string2:REQ
        LOCAL compare_loop, compare_done
    jmp compare_done         ; Перейти до порівняння рядків
    compare_loop:
        lodsb               ; Завантажити наступний символ першого рядка
        cmp al, [esi]       ; Порівняти його з відповідним символом другого рядка
        jne compare_done    ; Якщо символи відрізняються, вийти з циклу
        test al, al         ; Перевірити, чи це кінець першого рядка
        jz compare_done     ; Якщо так, обидва рядки однакові, вийти з циклу
        inc esi             ; Перейти до наступного символу першого рядка
        inc edi             ; Перейти до наступного символу другого рядка
        jmp compare_loop    ; Повторити цикл порівнянь
    compare_done:
        invoke lstrcmp, ADDR string1, ADDR string2 ; Виклик функції lstrcmp для порівняння рядків
       
         ;; Це мій третій і останній прихований коментар:)
    

ENDM
