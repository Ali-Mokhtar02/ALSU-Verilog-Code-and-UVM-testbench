module ALSU_Top ();
	import uvm_pkg::*;
	import ALSU_test_pkg::*;
	`include "uvm_macros.svh"

	logic clk;

	initial begin
		clk=0;
		forever
			#1 clk=~clk;
	end

	ALSU_if interface_insta(clk);

	
	ALSU DUT_insta(interface_insta.A, interface_insta.B, interface_insta.cin, interface_insta.serial_in, interface_insta.red_op_A,
		interface_insta.red_op_B, interface_insta.opcode, interface_insta.bypass_A, interface_insta.bypass_B, interface_insta.clk,
		interface_insta.rst, interface_insta.direction, interface_insta.leds, interface_insta.out);

	ALSU_Golden_Model ALSU_Goldent_inta(interface_insta.A, interface_insta.B, interface_insta.cin, interface_insta.serial_in,
	 interface_insta.red_op_A,interface_insta.red_op_B, interface_insta.opcode, interface_insta.bypass_A, interface_insta.bypass_B,
	 interface_insta.clk,interface_insta.rst, interface_insta.direction, interface_insta.leds_golden, interface_insta.out_golden);


	bind DUT_insta ALSU_assertions asertions_insta(interface_insta.A, interface_insta.B, interface_insta.cin, interface_insta.serial_in, 
		interface_insta.red_op_A,interface_insta.red_op_B, interface_insta.opcode, interface_insta.bypass_A, interface_insta.bypass_B,
		interface_insta.clk,interface_insta.rst, interface_insta.direction, interface_insta.leds, interface_insta.out);

	initial begin
		uvm_config_db#(virtual ALSU_if)::set(null, "uvm_test_top", "ALSU_IF",interface_insta);
		run_test("ALSU_test");
	end

endmodule : ALSU_Top