module FA_Gate(
  input  a,
  input  b,
  input  cin,
  output sum,
  output cout
);
  wire ps, pc1, pc2;

  xor #(2,3)(ps,  a,   b);
  and #(3,4)(pc1, a,   b);
  xor #(1,2)(sum, cin, ps);
  and #(2,4)(pc2, cin, ps);
  or  #(2,3)(cout, pc1, pc2);

endmodule


