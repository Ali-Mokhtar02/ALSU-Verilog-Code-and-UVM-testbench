package ALSU_monitor_pkg;
	import uvm_pkg::*;
	import ALSU_seq_item_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_monitor extends  uvm_monitor;
		`uvm_component_utils(ALSU_monitor);
		virtual ALSU_if ALSU_monitor_vif;
		uvm_analysis_port #(ALSU_seq_item) monitor_ap;
		ALSU_seq_item ALSU_monitor_seq_item;

		function  new(string name="ALSU_monitor", uvm_component parent=null );
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			monitor_ap= new("monitor_ap",this);
		endfunction: build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				ALSU_monitor_seq_item = ALSU_seq_item::type_id::create("ALSU_monitor_seq_item");

				@(negedge ALSU_monitor_vif.clk);
				ALSU_monitor_seq_item.rst = ALSU_monitor_vif.rst;
				ALSU_monitor_seq_item.A = ALSU_monitor_vif.A;
				ALSU_monitor_seq_item.B = ALSU_monitor_vif.B;
				ALSU_monitor_seq_item.cin = ALSU_monitor_vif.cin;
				ALSU_monitor_seq_item.opcode = ALSU_monitor_vif.opcode;
				ALSU_monitor_seq_item.red_op_A = ALSU_monitor_vif.red_op_A;
				ALSU_monitor_seq_item.red_op_B = ALSU_monitor_vif.red_op_B;
				ALSU_monitor_seq_item.bypass_A = ALSU_monitor_vif.bypass_A;
				ALSU_monitor_seq_item.bypass_B = ALSU_monitor_vif.bypass_B;
				ALSU_monitor_seq_item.serial_in = ALSU_monitor_vif.serial_in;
				ALSU_monitor_seq_item.direction = ALSU_monitor_vif.direction;
				ALSU_monitor_seq_item.out = ALSU_monitor_vif.out;
				ALSU_monitor_seq_item.out_golden = ALSU_monitor_vif.out_golden;
				ALSU_monitor_seq_item.leds = ALSU_monitor_vif.leds;
				ALSU_monitor_seq_item.leds_golden = ALSU_monitor_vif.leds_golden;
				monitor_ap.write(ALSU_monitor_seq_item);
				`uvm_info("run_phase",ALSU_monitor_seq_item.convert2string(),UVM_HIGH);
			end
		endtask : run_phase
	endclass : ALSU_monitor
endpackage : ALSU_monitor_pkg