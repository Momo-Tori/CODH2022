module CPUDownload (
    input [15:0] SW,
    input CLK100MHZ,
    output [15:0]LED,
    output LED16_R,
    output LED17_B,
    output LED17_G,
    output LED17_R,
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG,
    output [7:0] AN,
    input CPU_RESETN,
    input BTNC,
    input BTNU,
    input BTNL,
    input BTNR,
    input BTND
);
wire [2:0]seg_sel;
wire [6:0]seg;
wire clk_cpu,rst_cpu,io_we,io_rd;
wire [7:0]io_addr;
wire [31:0] io_dout,io_din,pc,chk_data;
wire [15:0]chk_addr;

assign {LED17_R,LED17_G,LED17_B}=seg_sel;
assign {CA,CB,CC,CD,CE,CF,CG}=seg;
pdu pdu(CLK100MHZ,CPU_RESETN,BTNU,BTND,BTNR,BTNC,BTNL,SW,LED16_R,LED,AN,seg,seg_sel,clk_cpu,rst_cpu,io_addr,io_dout,io_we,io_rd,io_din,pc,chk_addr,chk_data);
cpu cpu(clk_cpu,~rst_cpu,io_addr,io_dout,io_we,io_rd,io_din,pc,chk_addr,chk_data);

endmodule