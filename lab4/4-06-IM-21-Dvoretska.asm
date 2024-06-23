.386
.model flat, stdcall
option casemap:none
includelib kernel32.lib
includelib user32.lib
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

IB_XPOS         equ 100
IB_YPOS         equ 100
buffersize      equ 32

.DATA
StrLen                  dd 0
buffer                  db buffersize DUP(?)
buffer_encrypted        db buffersize DUP(?)
message                 db "Enter your password",0

title_of_inputbox       db "lab4",0
full_name_title         db "My name",0
birthday_title          db "My birthday",0
student_card_title      db "My student card",0
error_title             db "Error",0

msg_if_field_empty      db "You need to enter a password",0
msg_if_pass_incorrect   db "The password is incorrect! Try again",0
my_full_name            db "My full name: Anastasia Dvoretska", 0
my_birthday_info        db "My birthday: 16.05.2005", 0
my_student_card_4num    db "My student card's 4 last numbers: 8760", 0

my_pass                 db  "IIJKM@",0
xor_key                 db  "xastia",0

.CODE

_main:
    invoke MessageBox, 0, ADDR message, ADDR title_of_inputbox, MB_OK
    invoke InputBox, ADDR buffer, ADDR title_of_inputbox, ADDR message, buffersize, IB_XPOS, IB_YPOS, ADDR StrLen
    test eax, eax
    jz finish
    mov eax, StrLen
    test eax, eax
    jnz go_check
    invoke MessageBox, 0, ADDR msg_if_field_empty, ADDR error_title, MB_OK
    jmp _main

go_check:
    invoke encrypt_string, ADDR buffer, ADDR buffer_encrypted, ADDR xor_key
    invoke compare_strings, ADDR buffer_encrypted, ADDR my_pass
    jz password_correct
    invoke MessageBox, 0, ADDR msg_if_pass_incorrect, ADDR error_title, MB_OK
    jmp _main

password_correct:
    invoke MessageBox, 0, ADDR my_full_name, ADDR full_name_title, MB_OK
    invoke MessageBox, 0, ADDR my_birthday_info, ADDR birthday_title, MB_OK
    invoke MessageBox, 0, ADDR my_student_card_4num, ADDR student_card_title, MB_OK
    jmp _main

finish:
    invoke ExitProcess, 0

; Процедура обработки сообщений диалогового окна
DlgProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .IF uMsg == WM_INITDIALOG
        invoke SetDlgItemTextA, hWnd, IDC_STATIC, lParam
        invoke SetWindowTextA, hWnd, lParam + 4
        invoke SendDlgItemMessageA, hWnd, IDC_EDIT, EM_LIMITTEXT, buffersize, 0
    .ELSEIF uMsg == WM_COMMAND
        movzx eax, wParam
        shr eax, 16
        .IF ax == BN_CLICKED
            .IF wParam == IDB_CANCEL
                invoke EndDialog, hWnd, 0
            .ELSEIF wParam == IDB_OK || wParam == IDOK
                invoke GetDlgItemTextA, hWnd, IDC_EDIT, ADDR buffer, buffersize
                invoke EndDialog, hWnd, 1
            .ENDIF
        .ENDIF
    .ELSEIF uMsg == WM_CLOSE
        invoke EndDialog, hWnd, 0
    .ENDIF
    xor eax, eax
    ret
DlgProc ENDP

END _main

