module Cache (
  input [31:0] address,    //cpu给的地址
  input memRead,           //cpu是否需要读cache的信号
  output [31:0] data,      //从cache中取出的数据
  output hit,               //是否hit，若hit，数据从cache出否则从主存直接读出，由cpu控制
  input memReadable,         //主存输入是否可用（考虑主存取data有时间延迟
  input [31:0] memData      //从主存输入用来更新Cache的Data
);

endmodule //Cache