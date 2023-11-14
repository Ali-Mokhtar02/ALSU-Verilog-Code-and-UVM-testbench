package ALSU_main_sequence_pkg;
	import uvm_pkg::*;
	import ALSU_seq_item_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_main_sequence extends uvm_sequence #(ALSU_seq_item);
		`uvm_object_utils(ALSU_main_sequence);
		ALSU_seq_item seq_item;
		function  new(string name="ALSU_main_sequence");
			super.new(name);
		endfunction : new

		task body;
			repeat(5000) begin
				seq_item= ALSU_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
			
		endtask : body
	endclass : ALSU_main_sequence
endpackage : ALSU_main_sequence_pkg