onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib InstMem_opt

do {wave.do}

view wave
view structure
view signals

do {InstMem.udo}

run -all

quit -force
