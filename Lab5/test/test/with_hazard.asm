.text 
		addi t6, x0, 0						#  initialize  counter (t6)
test1:										# [Fibonacci]  Distance = 1
		addi x7, x0, 8						# x7 stores the correct result
		addi x1, x0, 1						# x1 = 1
		add x2, x1, x0						# x2 = 1
		add x3, x2, x1						# x3 = 2
		add x4, x3, x2						# x4 = 3
		add x5, x4, x3						# x5 = 5
		add x6, x5, x4						# x6 = 8
		beq x6, x7, pass1					# beq can be used to test control hazard
		jal fail	
pass1:
		addi t6, t6, 1
		
test2:										#  [Fibonacci]  Distance = 2
		addi x7, x0, 8						# x7 stores the correct result
		addi x1, x0, 1						# x1 = 1
		nop
		add x2, x1, x0						# x2 = 1
		nop
		add x3, x2, x1						# x3 = 2
		nop
		add x4, x3, x2						# x4 = 3
		nop
		add x5, x4, x3						# x5 = 5
		nop
		add x6, x5, x4						# x6 = 8
		beq x6, x7, pass2
		jal fail

pass2:
		addi t6, t6, 1

test3:										# [Fibonacci] Distance = 3, which is used to test control hazard
		addi x7, x0, 8						#  x7 stores the correct result 
		addi x1, x0, 1						# x1 = 1
		nop
		nop
		add x2, x1, x0						# x2 = 1
		nop
		nop
		add x3, x2, x1						# x3 = 2
		nop
		nop
		add x4, x3, x2						# x4 = 3
		nop
		nop
		add x5, x4, x3						# x5 = 5
		nop
		nop
		add x6, x5, x4						# x6 = 8
		beq x6, x7, pass3
		jal fail

pass3:
		addi t6, t6, 1
		

test4:										# load hazard
		addi x7, x0, 8						# x7 stores the correct answer
		addi x2, x0, 4
		lw x1, 4	
		add x3, x2, x1	
		beq x3, x7, pass4
		
pass4:
		addi t6, t6, 1

pass_all:
		add t0, x0, t6						# if no errors detected, t6 = 4 (3'b100)
		sw t0, -256(x0)
		jal pass_all
						
fail:
		addi t0, x0, -1						# errors detected
		sw t0, -256(x0)
		jal fail
		
		
			
