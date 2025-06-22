; arbitrary value that represents infinity
%define INFINITY 100
; represents the size of structure node
%define SIZE_OF_NODE 8
section .data
    ; will memorise address of the first element
    head dd 0
    ; address of current element
    crt dd 0
    ; the minimum value
    minim dd 0

struc node
    .val: resd 1
    .next: resd 1
endstruc


section .text
global sort

;   struct node {
;    int val;
;    struct node* next;
;   };


;   The function will link the nodes in the array
;   in ascending order and will return the address
;   of the new found head of the list
; @params:
;   n -> the number of nodes in the array
;   node -> a pointer to the beginning in the array
;   @returns:
;   the address of the head of the sorted list

;; struct node* sort(int n, struct node* node);
sort:
    ; create a new stack frame
    enter 0, 0

    ; will be n
    mov ecx, [ebp + 8]
    ; will be first node
    mov esi, [ebp + 12]

    xor eax, eax
    xor ebx, ebx
    mov dword [minim], INFINITY
    ; will cross all list
for_loop:
    xor eax, eax

    ; extract n'th structure
    mov eax, SIZE_OF_NODE
    mul ebx
    add eax, esi

    ; compare with minimum
    mov edx, [eax + node.val]
    cmp edx, [minim]
    jg skip

    ; memorise the address of the first element from the array
    mov [head], eax
    push ebx
    mov ebx, [eax + node.val]
    mov [minim], ebx
    pop ebx

skip:

    inc ebx
    cmp ebx, ecx
    jl for_loop

    mov ebx, [head]
    mov [crt], ebx
    xor ebx, ebx
for_loop1:
    ; save index
    push ebx

    ; calculate next number
    mov ebx, [minim]
    inc ebx
    mov [minim], ebx    

    xor ebx, ebx
for_loop2:
    ; extract n'th structure
    mov edi, ebx
    imul edi, SIZE_OF_NODE
    add edi, esi

    ; check if it's the correct number
    mov eax, [minim]
    mov edx, [edi + node.val]
    cmp edx, eax
    jne is_not_minimum

    ; update the current element from the array
    mov edx, [crt]
    mov [edx + node.next], edi
    mov [crt], edi
    jmp number_found
is_not_minimum:
    inc ebx
    cmp ebx, ecx
    jl for_loop2

number_found:

    ; extract index
    pop ebx
    inc ebx
    cmp ebx, ecx
    jl for_loop1

    mov eax, [head]

    leave
    ret

