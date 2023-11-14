package ALSU_test_pkg;
	import uvm_pkg::*;
	import ALUS_env_pkg::*;
	import ALSU_config_pkg::*;
	import ALSU_reset_sequence_pkg::*;
	import ALSU_main_sequence_pkg::*;
	import ALSU_seq_item_pkg::*;
	
	`include "uvm_macros.svh"
	class ALSU_test extends uvm_test;
		`uvm_component_utils(ALSU_test);
		ALSU_env ALSU_test_env;
		ALSU_config_obj ALSU_test_cfg;
		ALSU_reset_sequence ALSU_test_rst_seq;
		ALSU_main_sequence ALSU_test_main_seq;

		function  new(string name="ALSU_test", uvm_component parent=null );
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			ALSU_test_cfg= ALSU_config_obj::type_id::create("ALSU_test_cfg",this);
			ALSU_test_env= ALSU_env::type_id::create("ALSU_test_env",this);
			ALSU_test_main_seq= ALSU_main_sequence::type_id::create("ALSU_test_main_seq",this);
			ALSU_test_rst_seq= ALSU_reset_sequence::type_id::create("ALSU_test_rst_seq",this);
			if(! uvm_config_db#(virtual ALSU_if)::get(this, "", "ALSU_IF",ALSU_test_cfg.ALSU_config_vif) )
				`uvm_fatal("build_phase", "get of ALSU interface failed in test");

			uvm_config_db#( uvm_active_passive_enum)::set(this, "*", "ALSU_agent_type",UVM_ACTIVE);
			uvm_config_db#( ALSU_config_obj)::set(this, "*", "ALSU_CFG",ALSU_test_cfg);
		endfunction : build_phase 

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);
			`uvm_info("run_phase","Reset asserted", UVM_MEDIUM);
			ALSU_test_rst_seq.start(ALSU_test_env.ALSU_env_agent.ALSU_agent_sqr);
			`uvm_info("run_phase", "Reset deasserted", UVM_MEDIUM);
			`uvm_info("run_phase", "Stimulus generation starts", UVM_MEDIUM);
			ALSU_test_main_seq.start(ALSU_test_env.ALSU_env_agent.ALSU_agent_sqr);
			`uvm_info("run_phase", "Stimulus generation ends", UVM_MEDIUM);
			phase.drop_objection(this);
		endtask : run_phase
	endclass : ALSU_test
endpackage : ALSU_test_pkg