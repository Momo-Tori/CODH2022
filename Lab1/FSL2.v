module  fls2 (
input CLK100MHZ,
input [15:0] SW,
input CPU_RESETN,
input BTNC,
output [15:0]LED
);
wire en;
IP IP(CLK100MHZ,BTNC,en);
fls fls(CLK100MHZ,CPU_RESETN,en,SW,LED);
endmodule