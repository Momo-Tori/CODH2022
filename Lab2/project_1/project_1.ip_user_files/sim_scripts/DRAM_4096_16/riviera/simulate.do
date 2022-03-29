onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+DRAM_4096_16 -L dist_mem_gen_v8_0_13 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.DRAM_4096_16 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {DRAM_4096_16.udo}

run -all

endsim

quit -force
