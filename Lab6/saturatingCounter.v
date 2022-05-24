module saturatingCounter (
    input clk,
    input rstn,
    input we,
    input inIfBranch,
    output outIfBranch
);
reg [1:0] counter;
always @(posedge clk or negedge rstn) begin
    if(~rstn) counter<=1;//弱不跳转
    else 
    if(we)
        if(inIfBranch)
        begin
            if(counter==2'b11) counter<=counter;
            else counter<=counter+1;
        end
        else
        begin
            if(counter==2'b00) counter<=counter;
            else counter<=counter-1;
        end
end
assign outIfBranch = counter [1];
endmodule //saturatingCounter