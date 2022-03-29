onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib BRAM_4096_16_opt

do {wave.do}

view wave
view structure
view signals

do {BRAM_4096_16.udo}

run -all

quit -force
