package ALSU_sequencer_pkg;
	import uvm_pkg::*;
	import ALSU_seq_item_pkg::*;
	`include "uvm_macros.svh"
	
	class ALSU_sequencer extends uvm_sequencer #(ALSU_seq_item) ;
		
		`uvm_component_utils(ALSU_sequencer);

		function new (string name="ALSU_sequencer", uvm_component parent=null);
			super.new(name,parent);
		endfunction : new

	endclass : ALSU_sequencer
endpackage : ALSU_sequencer_pkg