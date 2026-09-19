// tb.v
// Testbench for the parameterized LUT (ROM).

`timescale 1ns / 1ps

module tb;

  localparam WIDTH = 8;
  localparam DEPTH = 4;

  reg  [$clog2(DEPTH)-1:0] t_sel;
  wire [WIDTH-1:0]         t_dout;

  integer i;

  lut #(
    .WIDTH (WIDTH),
    .DEPTH (DEPTH)
  ) DUT (
    .sel  (t_sel),
    .dout (t_dout)
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
    t_sel = 0;

    $display("------------------------------");
    $display(" Time   sel | dout | Expected");
    $display("------------------------------");

    for (i = 0; i < DEPTH; i = i + 1) begin
      t_sel = i;
      #10;
      $display("%5t    %0d  |  %0d   |    %0d   %s",
               $time, t_sel, t_dout, i*i,
               (t_dout === i*i) ? "PASS" : "FAIL");
    end

    $display("------------------------------");
    #10 $finish;
  end

endmodule