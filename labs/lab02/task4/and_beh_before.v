// and_beh_before.v
// Behavioral AND gate -- delay placed BEFORE the assignment
// (inter-assignment / regular delay).

`timescale 1ns / 1ps

module and_beh_before (
  input      a,
  input      b,
  output reg y
);

  always @(a or b) begin
    // Wait 5 units FIRST, then read a and b and assign.
    // The inputs are sampled late, so their values may already
    // have changed by the time the RHS is evaluated.
    #5 y = a & b;
  end

endmodule