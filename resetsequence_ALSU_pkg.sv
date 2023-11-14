package ALSU_reset_sequence_pkg;
	import uvm_pkg::*;
	import ALSU_seq_item_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_reset_sequence extends uvm_sequence #(ALSU_seq_item);
		`uvm_object_utils(ALSU_reset_sequence);
		ALSU_seq_item seq_item;

		function  new(string name="ALSU_reset_sequence");
			super.new(name);
		endfunction : new

		task body;
			seq_item= ALSU_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.rst=1;
			seq_item.A=$random;
			seq_item.B=$random;
			seq_item.cin=$random;
			seq_item.red_op_A=$random;
			seq_item.red_op_B=$random;
			seq_item.bypass_A=$random;
			seq_item.bypass_B=$random;
			seq_item.direction=$random;
			seq_item.serial_in=$random;
			finish_item(seq_item);
		endtask : body

	endclass : ALSU_reset_sequence

endpackage : ALSU_reset_sequence_pkg