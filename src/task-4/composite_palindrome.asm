section .data
; will contain all combinations of words one by one
practice_string times 150 db 0

section .text
; max length of palindromic string
%define STR_LEN 150
; the array will contain always 15 words
%define WORDS 15
global check_palindrome
global composite_palindrome
global concatenate
global compare
global new_string
extern calloc
extern malloc
extern strcat
extern strlen
extern strcmp
extern strcpy
extern printf

; const int check_palindrome(const char * const str, const int len)
check_palindrome:
; create a new stack frame
enter 0, 0
push esi
push edi
push edx
push ecx
push ebx

; *str
mov esi, [ebp + 8]
; len
mov edi, [ebp + 12]

; calculate len / 2
mov ecx, edi
; ecx = ecx / 2
shr ecx, 1

xor ebx, ebx
loop:
; left position
mov al, byte [esi + ebx]

; right position
mov edx, edi
sub edx, ebx
dec edx
mov dl, byte [esi + edx]

; left should be equal to the right
cmp al, dl
jne not_equal

inc ebx
cmp ebx, ecx
jl loop

jmp equal

not_equal:
; means that the word is not a palindrome
mov eax, 0
jmp out
equal:
; word is palindrome
mov eax, 1
jmp out
out:
pop ebx
pop ecx
pop edx
pop edi
pop esi
leave
ret

; just like strcat function from C, but between one word from strs array and dest string
; char* concatenate(char *dest, const char* const* const  strs, int pos)
concatenate:
push ebp
mov ebp, esp
push esi
push edi
push edx
push ecx
push ebx

; dest
mov esi, [ebp + 8]
; strs
mov edi, [ebp + 12]
; pos
mov ecx, [ebp + 16]

; the word
mov eax, [edi + ecx*4]

; save before strcat
push edx
push ecx

; concatenate
push eax
push esi
call strcat
; remove the registers
add esp, 8

; Restore
pop ecx
pop edx

; by default the new string will be returned in eax

pop ebx
pop ecx
pop edx
pop edi
pop esi
leave
ret

; int compare(char *str1, char *str2)
compare:
push ebp
mov ebp, esp
push esi
push edi
push edx
push ecx
push ebx

; str1
mov esi, [ebp + 8]
; str2
mov edi, [ebp + 12]

; save before strlen
push ecx
push edx

; length of str1
push esi
call strlen
; remove the register pushed
add esp, 4

; restore
pop edx
pop ecx

; copy length
mov ecx, eax

; save
push edx
push ecx

; len of str2
push edi
call strlen
; remove the register pushed
add esp, 4

; restore
pop ecx
pop edx

; compare the lengths
cmp ecx, eax
jg better_str1
jl better_str2

; save
push ecx
push edx

; compare laxicrographical
push edi
push esi
call strcmp
; remove the registers pushed
add esp, 8

; restore
pop edx
pop ecx

; choose minim lexicographical
cmp eax, 0
jg better_str2
jl better_str1

jmp out1

better_str1:
; str1 is better than str2
mov eax, 1
jmp out1
better_str2:
; str2 is better than str1
mov eax, 2
out1:
pop ebx
pop ecx
pop edx
pop edi
pop esi
leave
ret

; compute the new combination of words
; char* new_string(char *dest, char **strs, int combination)
new_string:
push ebp
mov ebp, esp
push esi
push edi
push edx
push ecx
push ebx

; dest
mov esi, [ebp + 8]
; strs
mov edi, [ebp + 12]
; sombination
mov ebx, [ebp + 16]

xor ecx, ecx
loop3:
; copy combination
mov edx, ebx

; find bit
shr edx, cl
; 1 means - add the word
and edx, 1

; 0 means don't add
cmp edx, 0
je skip_conc

; save
push ecx
push edx

; will be every address of the words
push dword [edi + 4*ecx]

push esi
call strcat
; remove pushed registers
add esp, 8

; restore
pop edx
pop ecx

mov esi, eax
skip_conc:
; next bit
inc ecx
cmp ecx, WORDS
jl loop3

; copy address of the new string
mov eax, esi

pop ebx
pop ecx
pop edx
pop edi
pop esi

leave
ret


; char * const composite_palindrome(const char * const * const strs, const int len);
composite_palindrome:
; create a new stack frame
enter 0, 0
push esi
push edi
push edx
push ecx
push ebx
xor eax, eax

; strs
mov esi, [ebp + 8]
; len
mov ecx, [ebp + 12]

; alloc memory for the best palindromic string
push STR_LEN
; calloc(1, STR_LEN)
push dword 1
call calloc

; set local variable at [ebp - 4]
add esp, 4
; memorise the address in a local variable
mov [ebp - 4], eax

mov edi, practice_string

; calculate all combinations
mov edx, 1
shl edx, WORDS

; each bit represents a word from strs
xor ebx, ebx
inc ebx
loop1:
mov edi, practice_string
; reset the string
mov byte [edi], 0

; calculate new string
push ebx
push esi
push edi
call new_string
; remove the registers
add esp, 12

; save before strlen
push ecx
push edx

; find length
push edi
call strlen
; remove register
add esp, 4

; restore
pop edx
pop ecx

; eax contains the length

; verify if it's palindrome
push eax
push edi
call check_palindrome
; remove registers from stack
add esp, 8

; 0 means - the string is not a palindrome
cmp eax, 0
je is_not_palindrome

; compare with the best palindrome until now
push edi
; local variable
push dword [ebp - 4]
call compare
; remove registers from stack
add esp, 8

; the return of the compare function
cmp eax, 1
je dont_swap

; save before strcpy
push ecx
push edx

push edi
; address of the best palindrome
push dword [ebp - 4]
call strcpy
; remove registers
add esp, 8

; restore
pop edx
pop ecx

dont_swap:
is_not_palindrome:
; next combination
inc ebx

cmp ebx, edx
jle loop1

; return the palindromic string
mov eax, [ebp - 4]
; refresh stack
add esp, 4

pop ebx
pop ecx
pop edx
pop edi
pop esi
leave
ret

