module ImmGen (
    input [31:0]Ins,
    output reg [31:0]Imm
);
always @(*) begin
    if(Ins[6:2]==5'b01000)
        Imm={{20{Ins[31]}},Ins[31:25],Ins[11:7]};//SW
    else if(~Ins[14]&Ins[12])
        Imm={{20'b0},Ins[31:20]};//UI
    else if(Ins[13:12]==2'b01) Imm={{27'b0},Ins[24:20]};//左右移
    else Imm={{20{Ins[31]}},Ins[31:20]};//I
end
endmodule //ImmGen