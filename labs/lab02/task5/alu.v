// alu.v
// 1-bit-opcode ALU: op=0 -> add, op=1 -> sub. 4-bit operands.
// Subtraction is implemented the way real hardware does it: negate b (one's
// complement, then +1 for two's complement) and add.

`timescale 1ns / 1ps

module alu (
  input      [3:0] a,
  input      [3:0] b,
  input            op,      // 0 = add, 1 = sub
  output reg [3:0] result
);

  reg [3:0] b_inv;
  reg [3:0] b_twos;

  // BUG 1 FIX: op was missing from the sensitivity list, so the block
  // never re-evaluated when only op changed. @(*) covers every input read
  // inside the block automatically.
  always @(*) begin
    case (op)
      1'b0: begin
        result = a + b;                 // add
      end
      1'b1: begin
        // BUG 2 FIX: these were non-blocking (<=). Non-blocking assignments
        // schedule their updates for the end of the time step, so b_inv and
        // b_twos still held their OLD values when the next line read them.
        // Blocking (=) makes each line take effect immediately, which is
        // what a chained combinational calculation needs.
        b_inv  = ~b;                    // sub, via two's complement
        b_twos = b_inv + 1;
        result = a + b_twos;
      end
    endcase
  end

endmodule