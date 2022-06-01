module  register_file  #(
    parameter AW = 5,		
    parameter DW = 32		
)(
    input  clk,			
    input [AW-1:0]  ra0, ra1,	
    output [DW-1:0]  rd0, rd1,	
    input [AW-1:0]  wa,		
    input [DW-1:0]  wd,		
    input we,			
    input [AW-1:0]  raout,
    output [DW-1:0]  rdout
);
reg [DW-1:0]  rf [(1<<AW)-1:0];
assign rd0=((ra0==wa)&&we&&(ra0!=0))?wd:rf[ra0];
assign rd1=((ra1==wa)&&we&&(ra1!=0))?wd:rf[ra1];
assign rdout=((raout==wa)&&we&&(raout!=0))?wd:rf[raout];


initial rf[0]=0;
always  @(posedge  clk)begin
    if (we)  rf[wa]  =  wd;
    rf[0]=0;
end
endmodule
