module jitter_clr(
input clk,
input button,
output button_clean
);
reg [4:0] cnt;
always@(posedge clk)
begin
if(button==1'b0)
cnt <= 5'h0;
else if(cnt<5'h10)
cnt <= cnt + 1'b1;
end
assign button_clean = cnt[4];
endmodule

module signal_edge(
input clk,
input button,
output button_edge);
reg button_r1,button_r2;
always@(posedge clk)
button_r1 <= button;
always@(posedge clk)
button_r2 <= button_r1;
assign button_edge = button_r1 & (~button_r2);
endmodule

module IP(//Input Processing
input clk,
input button,
output button_edge);
wire temp;
jitter_clr jitter_clr(clk,button,temp);
signal_edge signal_edge(clk,temp,button_edge);
endmodule