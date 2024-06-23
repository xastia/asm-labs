.386
.model flat, stdcall
option casemap:none
includelib kernel32.lib
includelib user32.lib
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include 4-06-IM-21-Dvoretska.inc

IB_XPOS         equ 100
IB_YPOS         equ 100
buffersize      equ 32




DlgProc PROTO hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD   ; Forward declaration

IDC_STATIC  equ 4001
IDC_EDIT    equ 4002
IDB_OK      equ 4003
IDB_CANCEL  equ 4004

.DATA
	
;DlgTemplateEx
ALIGN 4
DlgTemplateEx   dw 1, 0FFFFh    ; dlgVer, Signature
                dd 0, 0         ; helpID, exStyle
                dd 90C800CCh    ; style
                dw 4            ; cDlgItems
DlgBoxCoord     dw 300          ; x
                dw 250          ; y
                dw 120          ; cx
                dw 80           ; cy
                dw 0            ; menu
                dw 0            ; windowClass
                dw 0            ; title
                dw 12           ; pointsize
                dw 0            ; weight
                db 0            ; italic
                db 1            ; charset
                dw 'O','l','d',' ','E','n','g','l','i','s','h',' ','T','e','x','t',' ','M','T',0

ALIGN 4
        dd 0,0          ; helpID, exStyle
        dd 50020000h    ; style
        dw 10           ; x
        dw 5            ; y
        dw 150          ; cx
        dw 20           ; cy
        dd IDC_STATIC   ; id
        dw 0FFFFh, 82h  ; windowClass, Static
        dw 0            ; title
        dw 0            ; extraCount

ALIGN 4
        dd 0,0          ; helpID, exStyle
        dd 50810080h    ; style
        dw 10           ; x
        dw 25           ; y
        dw 100          ; cx
        dw 12           ; cy
        dd IDC_EDIT     ; id
        dw 0FFFFh, 81h  ; windowClass, Edit
        dw 0            ; title
        dw 0            ; extraCount

ALIGN 4
        dd 0,0          ; helpID, exStyle
        dd 50010000h    ; style
        dw 10           ; x
        dw 50           ; y
        dw 45           ; cx
        dw 15           ; cy
        dd IDB_OK       ; id
        dw 0FFFFh, 80h  ; windowClass, Button
        dw  'O','K',0   ; title: OK
        dw 0            ; extraCount

ALIGN 4
        dd 0,0          ; helpID, exStyle
        dd 50010000h    ; style
        dw 65           ; x
        dw 50           ; y
        dw 45           ; cx
        dw 15           ; cy
        dd IDB_CANCEL   ; id
        dw 0FFFFh, 80h  ; windowClass, Button
        dw 'C','a','n','c','e','l',0    ; title: Cancel
        dw 0            ; extraCount

;End of DlgTemplateEx
;End of .DATA

.data?

	IBparams    dd ?
	hEditBoxIB  dd ?
	StringLenIB dd ?

.code

InputBox PROC pText:DWORD,\     ; address of text to displayed in the static control
            pCaption:DWORD,\    ; address of title of input box
            pBuffer:DWORD,\     ; address of buffer receiving the input text
            pbuffersize:DWORD,\
            xpos:DWORD,\        ; x-coordinate of input box
            ypos:DWORD,\        ; y-coordinate of input box
            pStringLen:DWORD    ; pointer to number of characters received to the input box


    mov   eax, ypos
    shl   eax, 16
    or    eax, xpos
    mov   DWORD PTR [DlgBoxCoord], eax ; set the coordinates of the input box

    invoke  GetModuleHandleA, 0
    lea   edx,[pText]                       ; get the stack address pointing the parameters of InputBox

   	invoke  DialogBoxIndirectParamA,\       
                eax,\                       
                ADDR DlgTemplateEx,\        
                0,\                         
                ADDR DlgProc,\              
                edx                         
    ret

InputBox ENDP

DlgProc PROC USES esi hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

    .IF uMsg==WM_INITDIALOG

        mov     esi, lParam
        mov     IBparams, esi
        invoke  GetDlgItem, hWnd, IDC_STATIC
        invoke  SendMessageA, eax, WM_SETTEXT, 0, DWORD PTR [esi]       ; pText
        invoke  SendMessageA, hWnd, WM_SETTEXT, 0, DWORD PTR [esi+4]    ; pCaption
        invoke  GetDlgItem, hWnd, IDC_EDIT
        mov     hEditBoxIB, eax
        mov     edx, [esi+12]               ; buffersize
        dec edx
        invoke  SendMessageA, eax, EM_LIMITTEXT, edx, 0

        mov     StringLenIB, 0

    .ELSEIF uMsg==WM_CLOSE

        invoke  EndDialog, hWnd, 0

    .ELSEIF uMsg==WM_COMMAND

        mov  eax, wParam
        mov  edx, eax
        shr  edx, 16

        .IF dx==BN_CLICKED

            .IF ax==IDB_CANCEL

                invoke  EndDialog, hWnd, 0

            .ELSEIF ax==IDB_OK || ax==IDOK                         ; check also if RETURN \ ENTER is pressed

                mov esi, hEditBoxIB
                invoke  SendMessageA, esi, WM_GETTEXTLENGTH, 0, 0
                mov StringLenIB, eax
                test eax, eax                                  ; check the length of the input text
                jz @F                                      ; if no text is entered then quit application
                inc eax
                mov edx, IBparams
                invoke SendMessageA, esi, WM_GETTEXT, eax, DWORD PTR [edx+8]    ; DWORD PTR [edx] -> pointer to the buffer receiving keyboard input
                @@:
                mov ecx, IBparams
                mov edx, DWORD PTR [ecx+24]
                mov DWORD PTR [edx], eax
                invoke EndDialog, hWnd, 1

            .ENDIF

        .ENDIF

    .ELSE

        xor eax, eax
        ret

    .ENDIF

    mov  eax, TRUE
    ret

DlgProc ENDP


.DATA

StrLen                  dd 0
buffer                  db buffersize DUP(?)
buffer_encrypted        db buffersize DUP(?)
message                 dd 0

title_of_inputbox       db "lab4",0
full_name_title         db "My name",0
birthday_title          db "My birthday",0
student_card_title      db "My student card",0
error_title             db "Error",0
msg_to_enter_pass       db "Enter your password",0
msg_if_field_empty      db "You need to enter password",0
my_full_name            db "My full name: Anastasia Dvoretska", 0
my_birthday_info        db "My birthday: 16.05.2005", 0
my_student_card_4num    db "My student card's 4 last numbers: 8760", 0

msg_if_pass_incorrect   db "The password is incorrect! Try again",0
my_pass                 db  "IIJKM@",0
xor_key                 db  "xastia",0

.CODE

_main:
    mov message, OFFSET msg_to_enter_pass
    jmp go_start

go_start:
    invoke InputBox, message, ADDR title_of_inputbox, ADDR buffer, buffersize, IB_XPOS, IB_YPOS, ADDR StrLen
    test eax, eax
    jz finish
    mov eax, StrLen
    test eax, eax
    jnz go_check
    mov message, OFFSET msg_if_field_empty
    jmp go_start

go_check:
    encrypt_string buffer, buffer_encrypted, xor_key ; Зашифрувати введений користувачем пароль
    compare_strings buffer_encrypted, my_pass
    cmp eax, 0
    jz password_correct
    make_my_messagebox OFFSET msg_if_pass_incorrect, OFFSET error_title
    jmp go_start

password_correct:
    make_my_messagebox OFFSET my_full_name, OFFSET full_name_title
    make_my_messagebox OFFSET my_birthday_info, OFFSET birthday_title
    make_my_messagebox OFFSET my_student_card_4num, OFFSET student_card_title
    jmp go_start

finish:
    invoke ExitProcess, 0

END _main
