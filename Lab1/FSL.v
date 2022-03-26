module  fls (
    input  clk, 
    input  rstn, 
    input  en,
    input  [15:0]  d,
    output [15:0]  f
);
reg [15:0]a=0;
reg [15:0]b=0;
reg [1:0]status=0;
wire [15:0]out;

always @(posedge clk or negedge rstn) begin
    if(~rstn)
        a<=0;
    else if(en)
        a<=b;
    else a<=a;
end

always @(posedge clk or negedge rstn) begin
    if(~rstn)
        b<=0;
    else if(en)
        case(status)
        2'b00:b<=d;
        2'b01:b<=d;
        2'b10:b<=out;
        default:b<=b;
        endcase
    else b<=b;
end

always @(posedge clk or negedge rstn) begin
    if(~rstn)
        status<=0;
    else if(en)
        if(status==2'b10)
            status<=status;
        else
            status<=status+1;
    else status<=status;
end

assign f=b;

alu#(16) alu(.a(a),.b(b),.s(3'b001),.y(out));
endmodule