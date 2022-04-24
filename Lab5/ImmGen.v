module ImmGen (
    input [31:0]Ins,
    output reg [31:0]Imm
);
always @(*) begin
    if(Ins[6:2]==5'b01000)Imm={{20{Ins[31]}},Ins[31:25],Ins[11:7]};//SW
    else Imm={{20{Ins[31]}},Ins[31:20]};
end
endmodule //ImmGen