.text 
		addi t6, x0, 0						#  initialize  counter (t6)


# test slt,sltu,slti,sltiu
test1:										# [Fibonacci]  Distance = 1
	addi x7, x0, 1						# x7 stores the correct result
	addi x1, x0, -1
        addi x2, x0, 1
        slt x3, x1, x2
        sltu x4, x1, x2
        slti x5, x3, 0
        sltiu x6, x1, 1
        bne x3, x7, fail
	bne x4, x0, fail
        bne x5, x0, fail
        bne x6, x0, fail
pass1:
	addi t6, t6, 1
		

# test xor,xori
test2:										#  [Fibonacci]  Distance = 2
		addi x7, x0, 7						# x7 stores the correct result
		addi x1,x0,-8
        addi x2,x0,-1
        xor x2,x2,x1
        xori x1,x1,-1
		bne x1, x7, fail
        bne x2, x7, fail

pass2:
		addi t6, t6, 1


# test or,ori
test3:										# [Fibonacci] Distance = 3, which is used to test control hazard
		addi x7, x0, 8						#  x7 stores the correct result 
		addi x1, x0, 8
        or  x1,x0,x1
        ori  x2,x0,8
        bne x1, x7, fail
        bne x2, x7, fail

pass3:
		addi t6, t6, 1
		
# test and,andi
test4:
		addi x7, x0, 8						# x7 stores the correct answer
		addi x1,x0,-1
        addi x2,x0,8
        and x2,x1,x2
        andi x1,x1,8
        bne x1, x7, fail
        bne x2, x7, fail
		
pass4:
		addi t6, t6, 1

# test  sll,slli,srl,srli,sra,srai
test5:
		addi x7, x0, 8						# x7 stores the correct answer
        addi x1,x0,3
        addi x2,x0,1
        sll x2,x2,x1
        addi x1,x0,2
        slli x1,x1,2
        bne x1, x7, fail
        bne x2, x7, fail
        addi x3,x0,1
        srl x1,x1,x3
        srli x2,x2,1
        add x1,x1,x1
        add x2,x2,x2
        bne x1, x7, fail
        bne x2, x7, fail
        addi x7,x0,-8
        addi x1,x0,-16
        addi x2,x0,1
        sra x1,x1,x2
        addi x2,x0,-16
        srai x2,x2,1
        bne x1, x7, fail
        bne x2, x7, fail
		
pass5:
		addi t6, t6, 1

# test LUI
test6:
		auipc x1,0
		auipc x2,16
		sub x1,x2,x1
		addi x1,x1,-4
		lui x2,16
		bne x1,x2,fail		
pass6:
		addi t6, t6, 1
		
# test bge,bltu,bgeu
test7:
		addi x1,x0,-1
		addi x2,x0,1
		bge x2,x1,skip1
		j fail	
		skip1:
		bltu x2,x1,skip2
		j fail	
		skip2:
		bgeu x1,x2,skip3
		j fail	
		skip3:
		bge x1,x1,pass7
		j fail	
pass7:
		addi t6, t6, 1

pass_all:
		add t0, x0, t6						# if no errors detected, t6 = 4 (3'b100)
		sw t0, -256(x0)
		jal pass_all
						
fail:
		addi t0, x0, -1						# errors detected
		sw t0, -256(x0)
		jal fail
		
		
			
