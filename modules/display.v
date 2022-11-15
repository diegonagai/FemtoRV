
// Decodificador decimal para display de 7-segmentos

module display (input [31:0] i_data,      // Dados do registrador (binário)
                output [7:0] o_display0,  // Dado decodificado    (unidade)
                output [7:0] o_display1,  // Dado decodificado    (dezena)
                output [7:0] o_display2,  // Dado decodificado    (centena)
                output [7:0] o_display3,  // Dado decodificado    (milhar)
                output [7:0] o_display4,  // Dado decodificado    (dezena de milhar)
                output [7:0] o_display5); // Dado decodificado    (centena de milhar)

wire  [3:0] w_d5 = i_data / 100000;       // Centena de milhar
wire [16:0] w_r5 = i_data % 100000;       // Resto da divisão

wire  [3:0] w_d4 = w_r5 / 10000;          // Dezena de milhar
wire [16:0] w_r4 = w_r5 % 10000;          // Resto da divisão

wire  [3:0] w_d3 = w_r4 / 1000;           // Milhar
wire [16:0] w_r3 = w_r4 % 1000;           // Resto da divisão

wire  [3:0] w_d2 = w_r3 / 100;            // Centena
wire [16:0] w_r2 = w_r3 % 100;            // Resto da divisão

wire  [3:0] w_d1 = w_r2 / 10;             // Dezena
wire  [3:0] w_d0 = w_r2 % 10;             // Unidade

decoder d5 (.i_bin(w_d5),                 // Dígito mais significativo
            .o_dec(o_display5));

decoder d4 (.i_bin(w_d4),                 // ...
            .o_dec(o_display4));

decoder d3 (.i_bin(w_d3),                 // ...
            .o_dec(o_display3));

decoder d2 (.i_bin(w_d2),                 // ...
            .o_dec(o_display2));

decoder d1 (.i_bin(w_d1),                 // ...
            .o_dec(o_display1));

decoder d0 (.i_bin(w_d0),                 // Dígito menos significativo
            .o_dec(o_display0));

endmodule

module decoder (input  [3:0] i_bin,
                output [7:0] o_dec);

reg[7:0] r_dec;

	always @(i_bin) begin
		case(i_bin)
					0: r_dec = 8'b1100_0000; // 0
					1: r_dec = 8'b1111_1001; // 1
					2: r_dec = 8'b1010_0100; // 2 
					3: r_dec = 8'b1011_0000; // 3
					4: r_dec = 8'b1001_1001; // 4
					5: r_dec = 8'b1001_0010; // 5
					6: r_dec = 8'b1000_0010; // 6
					7: r_dec = 8'b1111_1000; // 7
					8: r_dec = 8'b1000_0000; // 8
					9: r_dec = 8'b1001_0000; // 9
		default: r_dec = 8'b1111_1111; // Apagado
		endcase
	end

assign o_dec = r_dec;

endmodule
