section .data
; number of delimiters
%define num_del 4
; all delimiters specified
delimiters db ' ', '.', ',', 10, 0

section .text
global sort
global get_words
global is_delimiter
extern qsort
extern strlen
extern strcmp
global compare

; int is_delimiter(char *chr, char *delimiters, int num_del)
is_delimiter:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ecx
    push edx
    push ebx

    ; pointer to character
    mov edi, [ebp + 8]
    ; pointer to delimiters array
    mov esi, [ebp + 12]
    ; number of delimiters
    mov ecx, [ebp + 16]

    xor edx, edx
    xor ebx, ebx
loop:

    mov edx, esi
    add edx, ebx
    mov al, byte [edx]
    mov cl, byte [edi]

    cmp al, cl
    je delimiter

    inc ebx
    cmp ebx, ecx
    jl loop

no_delimiter:
    ; return 0 if it s not delimiter
    mov eax, 0

    jmp out

delimiter:
    ; return 1, so it s delimiter
    mov eax, 1
out:
    pop ebx
    pop edx
    pop ecx
    pop esi
    pop edi
    leave
    ret

; int compare(const void* a, const void *b)
compare:
    push ebp
    mov ebp, esp
    push ecx
    push ebx
    push edx
    push edi
    push esi

    ; pointer to word1(which it's also a pointer)
    mov esi, [ebp + 8]
    ; pointer to word2
    mov edi, [ebp + 12]

    ; address of word1
    mov esi, [esi]
    ; address of word2
    mov edi, [edi]

    ; length of word1
    push esi
    call strlen
    ; refresh stack
    add esp, 4
    mov ebx, eax

    ; length of word2
    push edi
    call strlen
    ; refresh stack
    add esp, 4
    ; eax contains length

    ; compare length
    cmp ebx, eax
    jg greater
    jl lower

    ; lexicographical comparison
    push edi
    push esi
    call strcmp
    ; refresh stack
    add esp, 8

    ; strcmp returns -1,0 or 1
    cmp eax, 0
    jg greater
    jl lower
    je out1

greater:
    ; swap
    mov eax, 1
    jmp out1
lower:
    ; don't swap
    mov eax, -1
    jmp out1

out1:
    pop esi
    pop edi
    pop edx
    pop ebx
    pop ecx
    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax

    ; **words
    mov esi, [ebp + 8]
    ; number of words
    mov ecx, [ebp + 12]
    ; size
    mov edx, [ebp + 16]

    push compare
    push edx
    push ecx
    push esi
    call qsort
    ; refresh stack
    add esp, 16

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax

    ; *s
    mov esi, [ebp + 8]
    ; **words
    mov edi, [ebp + 12]
    ; number of words
    mov ecx, [ebp + 16]

    xor ebx, ebx
    xor edx, edx

    mov [edi], esi
    inc edx
    inc ebx
loop1:
    push ecx

    ; address of character
    mov ecx, esi
    add ecx, ebx

    ; check if it is delimiter
    push num_del
    push delimiters
    push ecx
    call is_delimiter
    ; refresh stack
    add esp, 12

    ; if it's not delim, go to next character
    cmp eax, 0
    je next_chr

loop2:
    ; set final of the word
    mov byte [ecx], 0

    ; address of next character
    inc ebx
    mov ecx, esi
    add ecx, ebx

    ; check if it is delimiter
    push num_del
    push delimiters
    push ecx
    call is_delimiter
    ; refresh stack
    add esp, 12

    ; continue loop if it's delimiter
    cmp eax, 1
    je loop2

    ; set start of word
    mov [edi + edx*4], ecx
    inc edx

next_chr:
    inc ebx

    pop ecx
    mov al, byte [esi + ebx]
    ; stop at the end of the string
    cmp al, 0
    jne loop1

    leave
    ret

