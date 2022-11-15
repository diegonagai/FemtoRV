
// Top-Level

module DE10_Lite(input         CLOCK_50,
                 input   [1:0] KEY,
                 inout  [35:0] GPIO,
                 output  [9:0] LEDR,
                 output  [7:0] HEX0,
                 output  [7:0] HEX1,
                 output  [7:0] HEX2,
                 output  [7:0] HEX3,
                 output  [7:0] HEX4,
                 output  [7:0] HEX5,
                 input   [9:0] SW);

	soc SOC(.clk      (CLOCK_50),
          .resetn   (KEY[0]),
          .led      (LEDR),
          .display0 (HEX0),
          .display1 (HEX1),
          .display2 (HEX2),
          .display3 (HEX3),
          .display4 (HEX4),
          .display5 (HEX5),
          .switch   (SW),
          .key      (KEY[1]),
          .rx       (GPIO[0]),
          .tx       (GPIO[1]));

endmodule
