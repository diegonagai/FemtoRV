// Copyright (c) 2020-2021, Bruno Levy All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification, are 
// permitted provided that the following conditions are met:
// 
//   * Redistributions of source code must retain the above copyright notice, this list 
//     of conditions and the following disclaimer.
//
//   * Redistributions in binary form must reproduce the above copyright notice, this 
//     list of conditions and the following disclaimer in the documentation and/or 
//     other materials provided with the distribution.
//
//   * Neither the name of the nor the names of its contributors may be used to endorse
//     or promote products derived from this software without
//     specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
// SHALL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
// OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
// AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

`define BENCH

module soc (input 	         clk,      // system clock 
            input 	         resetn,   // reset button
            output reg [9:0] led,      // system LEDs
            output     [7:0] display0, // 7-segment display
            output     [7:0] display1, // 7-segment display
            output     [7:0] display2, // 7-segment display
            output     [7:0] display3, // 7-segment display
            output     [7:0] display4, // 7-segment display
            output     [7:0] display5, // 7-segment display
            input      [9:0] switch,   // switches
            input            key,      // push-button
            input 	         rx,       // UART receive
            output 	         tx);      // UART transmit

    wire [31:0] mem_addr;
    wire [31:0] mem_rdata;
    wire        mem_rstrb;
    wire [31:0] mem_wdata;
    wire  [3:0] mem_wmask;

    processor CPU(.clk       (clk),
                  .resetn    (resetn),		 
                  .mem_addr  (mem_addr),
                  .mem_rdata (mem_rdata),
                  .mem_rstrb (mem_rstrb),
                  .mem_wdata (mem_wdata),
                  .mem_wmask (mem_wmask));

    wire [31:0] RAM_rdata;
    wire [29:0] mem_wordaddr = mem_addr[31:2];
    wire isIO  = mem_addr[22];
    wire isRAM = !isIO;
    wire mem_wstrb = |mem_wmask;

    memory RAM(.address (mem_wordaddr[10:0]),
	             .byteena ({4{isRAM}}&mem_wmask),
	             .clock   (clk),
	             .data    (mem_wdata),
	             .rden    (isRAM & mem_rstrb),
	             .wren    (!(isRAM & mem_rstrb)),
	             .q       (RAM_rdata));

    // Memory-mapped IO in IO page, 1-hot addressing in word address.   
    localparam IO_LEDS_bit      = 0;  // W five leds (GP+4)
    localparam IO_UART_DAT_bit  = 1;  // W data to send (8 bits) (GP+8)
    localparam IO_UART_CNTL_bit = 2;  // R status. bit 9: busy sending (GP+16)
    localparam IO_DISPLAYS_bit  = 3;  // Displays de 7-segmentos com decodificador decimal (GP+32)
    localparam IO_SWITCHES_bit  = 4;  // Chaves (GP+64)
    localparam IO_KEY_bit       = 5;  // Botão (GP+128)
   
    always @(posedge clk) begin
       if(isIO & mem_wstrb & mem_wordaddr[IO_LEDS_bit]) begin
	  led <= mem_wdata;
       end
    end

    wire uart_valid = isIO & mem_wstrb & mem_wordaddr[IO_UART_DAT_bit];
    wire uart_ready;
   
    emitter_uart #(
      .clk_freq_hz  (50*1000000),
      .baud_rate    (9600)) 
    UART(.i_clk     (clk),
         .i_rst     (!resetn),
         .i_data    (mem_wdata[7:0]),
         .i_valid   (uart_valid),
         .o_ready   (uart_ready),
         .o_uart_tx (tx));

    wire [31:0] IO_rdata = mem_wordaddr[IO_UART_CNTL_bit] ? {22'b0, !uart_ready, 9'b0} : 
                           mem_wordaddr[IO_SWITCHES_bit]  ? {22'b0, switch}            : 
                           mem_wordaddr[IO_KEY_bit]       ? {31'b0, key}               :
                           32'b0;
   
    assign mem_rdata = isRAM ? RAM_rdata : IO_rdata ;
  

	  reg [31:0] display_data;

	  display DISPLAY(.i_data(display_data),
                    .o_display0(display0),
                    .o_display1(display1),
                    .o_display2(display2),
                    .o_display3(display3),
                    .o_display4(display4),
                    .o_display5(display5));

    always @(posedge clk) begin
       if(isIO & mem_wstrb & mem_wordaddr[IO_DISPLAYS_bit]) begin
	  display_data <= mem_wdata;
       end
    end

    `ifdef BENCH
       always @(posedge clk) begin
          if(uart_valid) begin
    	       $write("%c", mem_wdata[7:0]);
    	       //$fflush(32'h8000_0001);
          end
       end
    `endif  

endmodule
