// mux_df.v
// 2:1 multiplexer - DATAFLOW style (continuous assignment)

`timescale 1ns / 1ps

module mux_df (
  input  I0,
  input  I1,
  input  S,
  output Y
);

  // Y = I0 when S = 0, Y = I1 when S = 1
  assign Y = (~S & I0) | (S & I1);

endmodule