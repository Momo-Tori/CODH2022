module alu2(
input CLK100MHZ,
input [15:0] SW,
input CPU_RESETN,
input BTNC,
output [15:0]LED
);
reg [5:0]a=0;
reg [5:0]b=0;
reg [2:0]s=0;
reg [2:0]f=0;
reg [5:0]y=0;
wire [2:0]fo;
wire [5:0]yo;
assign LED[15:13]=f;
assign LED[5:0]=y;


always @(posedge CLK100MHZ or negedge CPU_RESETN) begin
    if(~CPU_RESETN)
        s<=0;
    else if(BTNC)
        s<=SW[15:13];
    else s<=s;
end

always @(posedge CLK100MHZ or negedge CPU_RESETN) begin
    if(~CPU_RESETN)
        a<=0;
    else if(BTNC)
        a<=SW[11:6];
    else a<=a;
end

always @(posedge CLK100MHZ or negedge CPU_RESETN) begin
    if(~CPU_RESETN)
        b<=0;
    else if(BTNC)
        b<=SW[5:0];
    else b<=b;
end

always @(posedge CLK100MHZ or negedge CPU_RESETN) begin
    if(~CPU_RESETN)
        f<=0;
    else 
        f<=fo;
end

always @(posedge CLK100MHZ or negedge CPU_RESETN) begin
    if(~CPU_RESETN)
        y<=0;
    else 
        y<=yo;
end

alu#(6) alu(a,b,s,yo,fo);

endmodule
