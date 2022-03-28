`timescale 1ns / 1ps
module sortSim( );
    reg [15:0] SW;reg CLK100MHZ;wire [15:0]LED;wire LED16_R;wire[23:0] SegData;reg CPU_RESETN;reg BTNC;reg BTNU;reg BTNL;reg BTNR;reg BTND;
    sort sort(CLK100MHZ,rstn,SW,BTNL,BTNU,BTNC,BTNR,BTND,SegData,LED16_R,LED);

    initial begin
        SW=0;CPU_RESETN=1;BTNC=0;BTNU=0;BTNL=0;BTNR=0;BTND=0;SW=0;
    #0.5  CPU_RESETN=0;
    #1  CPU_RESETN=1;
    #1  BTNR=1;
    #1 BTNR=0;
    #1  SW[2]=1;
    #1  SW[2]=0;
    #1 BTNL=1;
    #1 BTNL=0;
    #1  SW[10]=1;
    #1  SW[10]=0;
    #1  SW[10]=1;
    #1  SW[10]=0;
    #1 BTNC=1;
    #1 BTNC=0;
    #1  BTNR=1;
    #1 BTNR=0;
    #1  SW[1]=1;
    #1  SW[1]=0;
    #1  SW[5]=1;
    #1  SW[5]=0;
    #1 BTNL=1;
    #1 BTNL=0;
    #1  BTNU=1;
    #1 BTNU=0;
    #1  BTNR=1;
    #1 BTNR=0;
    end


    initial begin
        CLK100MHZ=0;
        forever begin
            #1 CLK100MHZ=~CLK100MHZ;
        end
    end
endmodule