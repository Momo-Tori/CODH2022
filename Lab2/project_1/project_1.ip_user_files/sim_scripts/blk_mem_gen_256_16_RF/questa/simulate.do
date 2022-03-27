onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib blk_mem_gen_256_16_RF_opt

do {wave.do}

view wave
view structure
view signals

do {blk_mem_gen_256_16_RF.udo}

run -all

quit -force
