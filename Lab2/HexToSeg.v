module HexToSeg(
    input[3:0] hex,
    output reg [7:0] seg
);
always @(*) begin
    case(hex)
    4'h0:seg=8'h3F;
    4'h1:seg=8'h06;
    4'h2:seg=8'h5B;
    4'h3:seg=8'h4F;
    4'h4:seg=8'h66;
    4'h5:seg=8'h6D;
    4'h6:seg=8'h7D;
    4'h7:seg=8'h07;
    4'h8:seg=8'h7F;
    4'h9:seg=8'h6F;
    4'ha:seg=8'h77;
    4'hb:seg=8'h7C;
    4'hc:seg=8'h39;
    4'hd:seg=8'h5E;
    4'he:seg=8'h79;
    4'hf:seg=8'h71;
    default seg=0;
    endcase
end

endmodule