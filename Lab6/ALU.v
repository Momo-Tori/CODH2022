module alu #(
parameter WIDTH = 32     //数据宽度
)(
input [WIDTH-1:0] a, b,       //两操作数
input [2:0] s,                      //功能选择
output [WIDTH-1:0] y,     //运算结果
output [2:0] f                     //标志
);
reg [WIDTH-1:0]rtemp;
reg [2:0] rf;
assign y=rtemp;
assign f=rf;
always @(*) begin
    case(s) 
    3'b000:rtemp=a-b;
    3'b001:rtemp=a+b;
    3'b010:rtemp=a&b;
    3'b011:rtemp=a|b;
    3'b100:rtemp=a^b;
    3'b101:rtemp=a>>b;
    3'b110:rtemp=a<<b;
    3'b111:rtemp={{(WIDTH){a[WIDTH-1]}},a}>>(b[4:0]);
    default :rtemp<=0;
    endcase
end
wire OF;//判断是否溢出
assign OF=(a[WIDTH-1]^b[WIDTH-1])&(a[WIDTH-1]^rtemp[WIDTH-1]);
always @(*) begin
    if(s==0)
    begin
        if(rtemp==0)
            rf[0]=1;
        else 
            rf[0]=0;
        if(OF^rtemp[WIDTH-1])
            rf[1]=1;
        else 
            rf[1]=0;
        if(a<b)
            rf[2]=1;
        else 
            rf[2]=0;
    end
    else
        rf=0;
end
endmodule