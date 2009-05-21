program     equ     32
data        equ     42
jj          jmp     program
            orig    program
start       nop     
step2       lda     42          ; A = 0x090a
            sta     43          ; [43] = 0x090a
            add     44          ; A = 0x1a1b
            lda     43          ; A = 0x090a
            sub     45          ; A = 0x0f0f and OF = 1
            hlt
            orig    data
            con     0000
            con     1111
