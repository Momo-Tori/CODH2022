#测试时单步运行
#假定MMIO的起始地址为0xff00

#test no hazards
addi x30, x0, -1    #x30=0xffffffff
addi x31, x0, -256    #MMIO base address
addi x1, x0, 1    #x1=1
addi x2, x0, 2    #x2=2
addi x3, x0, 3    #x3=3
addi x4, x0, 4    #x4=4
sw x1, 0x00(x31)    #led_data=1
sw x2, 0x00(x31)    #led_data=2
sw x3, 0x00(x31)    #led_data=3
sw x4, 0x00(x31)    #led_data=4
sw x30, 0x00(x31)    #led_data=0xffff
sw x31, 0x00(x31)    #led_data=oxff00

#test data hazards
add x5, x4, x1    #x5=5
add x6, x5, x1    #x6=6
add x7, x5, x2    #x7=7
add x8, x1, x7    #x8=8
add x9, x2, x7    #x9=9
sw x9, 0x00(x31)    #led_data=9
sw x8, 0x00(x31)    #led_data=8
sw x7, 0x00(x31)    #led_data=7
sw x6, 0x00(x31)    #led_data=6
sw x5, 0x00(x31)    #led_data=5

add x10, x5, x6    #x6=11
add x10, x10, x7    #x6=18
add x10, x10, x8    #x6=26
add x10, x10, x9    #x6=35
sw x10, 0x00(x31)    #led_data=35


#test load-use hazard
add x10, x0, x0      #fig
loop:
lw x11, 0x04(x31)    #x11=swt_data
addi x12, x11, 1    #x12=swt_data+1
addi x13, x12, -1    #x13=swt_data
sw x13, 0x00(x31)    #led_data=swt_data


#test control hazard
beq x13, x0, stop    #if (swt_data==0) stop
add x10, x10, x13
sw x10, 0x00(x31)    #led_data=accum of swt_data
jal x0, loop

stop:
sw x30, 0x00(x31)    #led_data=0xffff
jal x0, stop

#do not execute
err:
sw x0, 0x00(x31)    #led_data=0x0000
sw x30, 0x00(x31)    #led_data=0xffff
jal x0, err

