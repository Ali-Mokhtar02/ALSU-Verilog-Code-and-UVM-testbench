package ALSU_scoreboard_pkg;
	import uvm_pkg::*;
	import ALSU_seq_item_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_scoreboard extends  uvm_scoreboard;
		`uvm_component_utils(ALSU_scoreboard);
		uvm_analysis_export #(ALSU_seq_item) sb_exp;
		uvm_tlm_analysis_fifo #(ALSU_seq_item) sb_fifo;
		ALSU_seq_item ALSU_sb_seq_item;

		int error_count=0;
		int correct_count=0;

		function  new(string name="ALSU_scoreboard", uvm_component parent=null );
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_exp= new("sb_exp",this);
			sb_fifo= new("sb_fifo",this);
		endfunction: build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_exp.connect(sb_fifo.analysis_export);

		endfunction: connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sb_fifo.get(ALSU_sb_seq_item);
				if(ALSU_sb_seq_item.out_golden !== ALSU_sb_seq_item.out || ALSU_sb_seq_item.leds_golden !== ALSU_sb_seq_item.leds) begin
					error_count++;
					if(ALSU_sb_seq_item.out_golden !== ALSU_sb_seq_item.out)
						`uvm_error("sb_run_phase", $sformatf("error happened with out signals dut values are %s and the golden model out is %0h", ALSU_sb_seq_item.convert2string(), ALSU_sb_seq_item.out_golden ) );


					if(ALSU_sb_seq_item.leds_golden !== ALSU_sb_seq_item.leds)
						`uvm_error("sb_run_phase", $sformatf("error happened with leds signals dut values are %s and the golden model leds is %0h", ALSU_sb_seq_item.convert2string(), ALSU_sb_seq_item.leds) );
				end
				else
					correct_count++;
			end
		endtask : run_phase

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase",$sformatf("total success are %0d",correct_count),UVM_MEDIUM);
			`uvm_info("report_phase",$sformatf("total erorrs are %0d",error_count),UVM_MEDIUM);
		endfunction: report_phase

	endclass : ALSU_scoreboard
endpackage : ALSU_scoreboard_pkg