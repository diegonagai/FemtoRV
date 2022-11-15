
// Testbench simples, apenas para execução do código no simulador

`timescale 1ns/1ps

module soc_tb;

  reg       clock;
  reg       reset;
  reg [9:0] switch;
  reg       key;
  reg       rx;
	
  wire [9:0] led;
  wire [7:0] display0;
  wire [7:0] display1;
  wire [7:0] display2;
  wire [7:0] display3;
  wire [7:0] display4;
  wire [7:0] display5;
  wire       tx;

  soc dut(.clk      (clock),
          .resetn   (reset),
          .led      (led),
          .display0 (display0),
          .display1 (display1),
          .display2 (display2),
          .display3 (display3),
          .display4 (display4),
          .display5 (display5),
          .switch   (switch),
          .key      (key),
          .rx       (rx),
          .tx       (tx));

  initial begin
    clock = 0;
	reset = 1;
    switch = 0;
	rx = 0;
    key = 1;
  end

  always #10 clock = !clock;

endmodule
