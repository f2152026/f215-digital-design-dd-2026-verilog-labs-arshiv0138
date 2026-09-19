// mux_beh.v
// 2:1 multiplexer - BEHAVIORAL style (procedural always block)

`timescale 1ns / 1ps

module mux_beh (
  input      I0,
  input      I1,
  input      S,
  output reg Y
);

  always @(*) begin
    if (S)
      Y = I1;
    else
      Y = I0;
  end

endmodule