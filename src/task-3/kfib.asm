section .text
global kfib

; const int fib(int n, int K);
kfib:
    ; create a new stack frame
    enter 0, 0

    push esi
    push edi
    push ebx
    push ecx
    push edx

    ; n
    mov esi, [ebp + 8]
    ; k
    mov edi, [ebp + 12]

    cmp esi, edi
    je equal
    jl lower

    ; index
    xor ebx, ebx
    inc ebx
    ; memorise sum
    xor edx, edx
loop:
    ; n - k
    mov ecx, esi
    sub ecx, ebx

    ; call recursive
    push edi
    push ecx
    call kfib
    ; refresh stack
    add esp, 8

    add edx, eax

    inc ebx
    cmp ebx, edi
    jle loop

    jmp out

equal:
    ; n == k => KFib = 1
    mov edx, 1
    jmp out
lower:
    ; n < k => KFib = 0
    mov edx, 0
    jmp out
out:
    mov eax, edx
    pop edx
    pop ecx
    pop ebx
    pop edi
    pop esi
    leave
    ret

