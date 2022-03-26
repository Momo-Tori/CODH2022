.data
number: .word 16
array: .word 7,17,5,2,11,15,3,12,4,1,20,6,9,8,0,19

.text
main:
    lw t0,number
    LOOP1:
        addi t0,t0,-1
        beqz t0,FIN
        la t1,array
        addi t2,t0,-1
        slli t2,t2,2 #t2=(t0-1)*4
        add t2,t2,t1 #t2 is the finish address
        LOOP2:
            lw t3,0(t1)
            blt t2,t1,LOOP2FIN
            lw t4,4(t1)
            blt t3,t4,SKIP
            sw t3,4(t1)
            sw t4,0(t1)
            SKIP:
            addi t1,t1,4
            j LOOP2
        LOOP2FIN:
        j LOOP1
    FIN:
    li a7, 10 # Exit program
    ecall
        