// tb.v
// Self-checking testbench for the 2-bit magnitude comparator.

`timescale 1ns / 1ps

module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  integer i, j;
  integer errors;

  reg exp_gt, exp_lt, exp_eq;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    t_a = 2'b00;
    t_b = 2'b00;

    $display("---------------------------------------------------------");
    $display(" Time    A   B  | GT LT EQ | Expected | Result");
    $display("---------------------------------------------------------");

    // Exhaustive: all 16 combinations of A and B
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i[1:0];
        t_b = j[1:0];
        #10;

        exp_gt = (i >  j);
        exp_lt = (i <  j);
        exp_eq = (i == j);

        $display("%5t    %0d   %0d  |  %b  %b  %b |  %b  %b  %b  |  %s",
                 $time, t_a, t_b, t_gt, t_lt, t_eq,
                 exp_gt, exp_lt, exp_eq,
                 ({t_gt, t_lt, t_eq} === {exp_gt, exp_lt, exp_eq})
                   ? "PASS" : "FAIL");

        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq})
          errors = errors + 1;

        // One-hot check: exactly one output must be high
        if ((t_gt + t_lt + t_eq) !== 1) begin
          $display("         ^^ ERROR: outputs not one-hot (A=%0d B=%0d)",
                   t_a, t_b);
          errors = errors + 1;
        end
      end
    end

    $display("---------------------------------------------------------");
    if (errors == 0)
      $display("All 16 test cases PASSED.");
    else
      $display("%0d failure(s) detected.", errors);
    $display("---------------------------------------------------------");

    #10 $finish;
  end

endmodule