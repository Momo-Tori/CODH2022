module alu3(
input CLK100MHZ,
input [15:0] SW,
input CPU_RESETN,
input BTNC,
output [15:0]LED
);
wire en;
IP IP(CLK100MHZ,BTNC,en);

reg [31:0]a=0;
reg [31:0]b=0;
reg [2:0]f=0;
reg [2:0]status=0;
wire [31:0]out;
reg [15:0] LEDout;
assign LED=LEDout;
wire [2:0]fout;

always @(posedge CLK100MHZ or negedge CPU_RESETN) begin
    if(~CPU_RESETN)
        a<=0;
    else if(en)
        case(status)
        3'b000:a[15:0]<=SW;
        3'b001:a[31:16]<=SW;
        default:a<=a;
        endcase
    else a<=a;
end

always @(posedge CLK100MHZ or negedge CPU_RESETN) begin
    if(~CPU_RESETN)
        b<=0;
    else if(en)
        case(status)
        3'b010:b[15:0]<=SW;
        3'b011:b[31:16]<=SW;
        default:b<=b;
        endcase
    else b<=b;
end

always @(posedge CLK100MHZ or negedge CPU_RESETN) begin
    if(~CPU_RESETN)
        f<=0;
    else if(en)
        case(status)
        3'b100:f<=SW[2:0];
        default:f<=f;
        endcase
    else f<=f;
end

always @(posedge CLK100MHZ or negedge CPU_RESETN) begin
    if(~CPU_RESETN)
        status<=0;
    else if(en)
        if(status==3'b111)
            status<=3'b101;
        else
            status<=status+1;
    else status<=status;
end

always @(*) begin
    case(status)
        3'b001:LEDout=16'b1;
        3'b010:LEDout=16'b10;
        3'b011:LEDout=16'b100;
        3'b100:LEDout=16'b1000;
        3'b101:LEDout=out[15:0];
        3'b110:LEDout=out[31:16];
        3'b111:LEDout={13*{0},fout};
        default:LEDout=0;
    endcase
end

alu#(32) alu(.a(a),.b(b),.s(f),.y(out),.f(fout));

endmodule