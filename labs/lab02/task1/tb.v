// tb.v
// Self-checking testbench for the 2:1 MUX.
// Works unchanged for both the dataflow and behavioral versions,
// since it only ever talks to the DUT wrapper.

`timescale 1ns / 1ps

module tb;

  // Stimulus
  reg  I0, I1, S;
  wire Y;

  integer i;
  integer errors;
  reg     expected;

  // Device under test
  DUT uut (
    .I0 (I0),
    .I1 (I1),
    .S  (S),
    .Y  (Y)
  );

  // Waveform dump (open mux.vcd in GTKWave)
  initial begin
    $dumpfile("mux.vcd");
    $dumpvars(0, tb);
  end

  initial begin
    errors = 0;
    I0 = 1'b0;
    I1 = 1'b0;
    S  = 1'b0;

    $display("--------------------------------------------");
    $display(" Time   S  I1  I0  |  Y  | Expected | Result");
    $display("--------------------------------------------");

    // Exhaustively apply all 8 input combinations
    for (i = 0; i < 8; i = i + 1) begin
      {S, I1, I0} = i[2:0];
      #10;

      expected = S ? I1 : I0;

      $display("%5t   %b   %b   %b  |  %b  |    %b     |  %s",
               $time, S, I1, I0, Y, expected,
               (Y === expected) ? "PASS" : "FAIL");

      if (Y !== expected)
        errors = errors + 1;
    end

    $display("--------------------------------------------");
    if (errors == 0)
      $display("All 8 test cases PASSED.");
    else
      $display("%0d test case(s) FAILED.", errors);
    $display("--------------------------------------------");

    #10 $finish;
  end

endmodule