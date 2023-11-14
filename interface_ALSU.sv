interface ALSU_if (clk);
	import ALSU_seq_item_pkg::*;
		input logic clk;
		logic signed [2:0] A, B;
		Opcode_e opcode;
		logic rst;
		logic cin,red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
		logic signed [5:0] out;
		logic signed [5:0] out_golden;
		logic [15:0] leds;
		logic [15:0] leds_golden;
endinterface : ALSU_if