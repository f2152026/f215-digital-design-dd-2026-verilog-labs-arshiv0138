// and_beh_intra.v
// Behavioral AND gate -- delay placed INSIDE the assignment
// (intra-assignment delay).

`timescale 1ns / 1ps

module and_beh_intra (
  input      a,
  input      b,
  output reg y
);

  always @(a or b) begin
    // Evaluate a & b IMMEDIATELY, hold that value, wait 5 units,
    // then drive it onto y. The sampled value is the one that
    // existed at the moment the inputs changed.
    y = #5 a & b;
  end

endmodule