module encoder_16bits(
    input[15:0] in,
    output reg [3:0] out
);
always @(*) begin
    casex(in)
    16'b1xxxxxxxxxxxxxxx:out=4'hF;
    16'b01xxxxxxxxxxxxxx:out=4'hE;
    16'b001xxxxxxxxxxxxx:out=4'hD;
    16'b0001xxxxxxxxxxxx:out=4'hC;
    16'b00001xxxxxxxxxxx:out=4'hB;
    16'b000001xxxxxxxxxx:out=4'hA;
    16'b0000001xxxxxxxxx:out=4'h9;
    16'b00000001xxxxxxxx:out=4'h8;
    16'b000000001xxxxxxx:out=4'h7;
    16'b0000000001xxxxxx:out=4'h6;
    16'b00000000001xxxxx:out=4'h5;
    16'b000000000001xxxx:out=4'h4;
    16'b0000000000001xxx:out=4'h3;
    16'b00000000000001xx:out=4'h2;
    16'b000000000000001x:out=4'h1;
    16'b0000000000000001:out=4'h0;
    default:out=4'bxxxx;
    endcase
end
endmodule