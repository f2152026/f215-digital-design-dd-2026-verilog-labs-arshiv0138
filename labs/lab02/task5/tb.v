// tb.v
// Self-checking testbench for the 1-bit-opcode ALU.

`timescale 1ns / 1ps

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  integer i, j, k;
  integer errors;
  reg [3:0] expected;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, tb);
    end
  end

  initial begin
    errors = 0;
    t_a  = 4'd0;
    t_b  = 4'd0;
    t_op = 1'b0;
    #10;

    $display("-----------------------------------------------------");
    $display(" Time    op   a   b  | result | Expected | Result");
    $display("-----------------------------------------------------");

    // Exhaustive sweep: both opcodes, all 16 x 16 operand pairs.
    // Sweeping op in the OUTER loop and again per-operand means op
    // changes while a and b are held steady -- that is what exposes
    // a missing entry in the sensitivity list.
    for (k = 0; k < 2; k = k + 1) begin
      for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
          t_a  = i[3:0];
          t_b  = j[3:0];
          t_op = k[0];
          #10;

          expected = (k == 0) ? (i + j) : (i - j);

          if (t_result !== expected) begin
            $display("%5t    %b   %2d  %2d  |   %2d   |    %2d    |  FAIL",
                     $time, t_op, t_a, t_b, t_result, expected);
            errors = errors + 1;
          end
        end
      end
    end

    // Targeted check: hold a and b fixed, toggle op only.
    // A correct ALU must change its output here.
    $display("--- op-toggle test (a and b held constant) ---");
    t_a = 4'd9; t_b = 4'd4;
    t_op = 1'b0; #10;
    $display("%5t    op=0  a=%0d b=%0d | result=%0d | expected=%0d  %s",
             $time, t_a, t_b, t_result, 9 + 4,
             (t_result === 4'd13) ? "PASS" : "FAIL");
    if (t_result !== 4'd13) errors = errors + 1;

    t_op = 1'b1; #10;
    $display("%5t    op=1  a=%0d b=%0d | result=%0d | expected=%0d  %s",
             $time, t_a, t_b, t_result, 9 - 4,
             (t_result === 4'd5) ? "PASS" : "FAIL");
    if (t_result !== 4'd5) errors = errors + 1;

    $display("-----------------------------------------------------");
    if (errors == 0)
      $display("All test cases PASSED.");
    else
      $display("%0d failure(s) detected.", errors);
    $display("-----------------------------------------------------");

    #10 $finish;
  end

endmodule