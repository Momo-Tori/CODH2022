onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib InstMemoryTest_opt

do {wave.do}

view wave
view structure
view signals

do {InstMemoryTest.udo}

run -all

quit -force
