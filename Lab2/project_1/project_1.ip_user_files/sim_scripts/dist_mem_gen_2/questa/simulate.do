onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib dist_mem_gen_2_opt

do {wave.do}

view wave
view structure
view signals

do {dist_mem_gen_2.udo}

run -all

quit -force
