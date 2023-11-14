package ALSU_driver_pkg;
	import uvm_pkg::*;
	import ALSU_seq_item_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_driver extends uvm_driver #(ALSU_seq_item);
		`uvm_component_utils(ALSU_driver);
		virtual ALSU_if ALSU_driver_vif;
		ALSU_seq_item stim_seq_item;
		function new(string name="ALSU_driver", uvm_component parent=null);
			super.new(name,parent);
		endfunction : new
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				stim_seq_item=ALSU_seq_item::type_id::create("stim_seq_item");
				seq_item_port.get_next_item(stim_seq_item);
				ALSU_driver_vif.rst = stim_seq_item.rst;
				ALSU_driver_vif.A = stim_seq_item.A;
				ALSU_driver_vif.B = stim_seq_item.B;
				ALSU_driver_vif.opcode = stim_seq_item.opcode;
				ALSU_driver_vif.cin=stim_seq_item.cin;
				ALSU_driver_vif.red_op_A = stim_seq_item.red_op_A;
				ALSU_driver_vif.red_op_B = stim_seq_item.red_op_B;
				ALSU_driver_vif.bypass_A = stim_seq_item.bypass_A;
				ALSU_driver_vif.bypass_B = stim_seq_item.bypass_B;
				ALSU_driver_vif.serial_in = stim_seq_item.serial_in;
				ALSU_driver_vif.direction = stim_seq_item.direction;
				@(negedge ALSU_driver_vif.clk);
				seq_item_port.item_done();
				`uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH);
			end

		endtask : run_phase

	endclass : ALSU_driver
endpackage : ALSU_driver_pkg