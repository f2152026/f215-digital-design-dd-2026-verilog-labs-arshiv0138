// and_df.v
// Dataflow AND gate with a #5 delay on the continuous assignment.

`timescale 1ns / 1ps

module and_df (
  input  a,
  input  b,
  output y
);

  // Delay sits on the continuous assignment itself.
  assign #5 y = a & b;

endmodule