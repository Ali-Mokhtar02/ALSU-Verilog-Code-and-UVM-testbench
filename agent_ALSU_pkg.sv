package ALSU_agent_pkg;
	import uvm_pkg::*;
	import ALSU_seq_item_pkg::*;
	import ALSU_config_pkg::*;
	import ALSU_driver_pkg::*;
	import ALSU_monitor_pkg::*;
	import ALSU_sequencer_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_agent extends  uvm_agent;
		`uvm_component_utils(ALSU_agent);

		ALSU_config_obj ALSU_agent_cfg;
		ALSU_driver ALSU_agent_driver;
		ALSU_monitor ALSU_agent_monitor;
		ALSU_sequencer ALSU_agent_sqr;
		uvm_analysis_port #(ALSU_seq_item) agent_ap;

		function  new(string name="ALSU_agent", uvm_component parent=null );
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			ALSU_agent_cfg=ALSU_config_obj::type_id::create("ALSU_agent_cfg",this);
			if(! uvm_config_db #(ALSU_config_obj)::get(this, "", "ALSU_CFG",ALSU_agent_cfg) )
				`uvm_fatal("build_phase", "get of ALSU cfg failed in agent");
			if(! uvm_config_db #(uvm_active_passive_enum)::get(this, "", "ALSU_agent_type",ALSU_agent_cfg.active) )
				`uvm_fatal("build_phase", "get of ALSU agent type failed in agent");
			if(ALSU_agent_cfg.active==UVM_ACTIVE) begin
				ALSU_agent_driver= ALSU_driver::type_id::create("ALSU_agent_driver",this);
				ALSU_agent_sqr= ALSU_sequencer::type_id::create("ALSU_agent_sqr",this);
			end
			ALSU_agent_monitor= ALSU_monitor::type_id::create("ALSU_agent_monitor",this);
			agent_ap=new("agent_ap",this);

		endfunction: build_phase

		function void connect_phase( uvm_phase phase);
			super.connect_phase(phase);
			if(ALSU_agent_cfg.active==UVM_ACTIVE) begin
				ALSU_agent_driver.ALSU_driver_vif=ALSU_agent_cfg.ALSU_config_vif;
				ALSU_agent_driver.seq_item_port.connect(ALSU_agent_sqr.seq_item_export);
			end
			ALSU_agent_monitor.ALSU_monitor_vif=ALSU_agent_cfg.ALSU_config_vif;
			ALSU_agent_monitor.monitor_ap.connect(agent_ap);
		endfunction : connect_phase

	endclass : ALSU_agent
endpackage : ALSU_agent_pkg