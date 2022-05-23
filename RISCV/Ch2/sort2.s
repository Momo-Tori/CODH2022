.data
number: .word 16
array: .word 7,17,5,2,11,15,3,12,4,1,20,6,9,8,0,19

.text
main:
    lw t0,0(zero)                   #.data´Ó0x0000¿ªÊ¼
    LOOP1:
        addi t0,t0,-1
        beqz t0,FIN
        addi t1,zero,4              # array address
        addi t2,t0,-1
        slli t2,t2,2 #t2=(t0-1)*4
        add t2,t2,t1 #t2 is the finish address
        lw t3,0(t1)
        LOOP2:
            blt t2,t1,LOOP2FIN
            lw t4,4(t1)
            bge t3,t4,skip
            mv t5,t3
            mv t3,t4
            mv t4,t5
            skip:
            sw t4,0(t1)
            addi t1,t1,4
            j LOOP2
        LOOP2FIN:
        sw t3,0(t1)
        j LOOP1
    FIN:
	nop
	nop	
	nop
	nop
	nop
