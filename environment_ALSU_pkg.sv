package ALUS_env_pkg;
	import uvm_pkg::*;
	import ALSU_agent_pkg::*;
	import ALSU_scoreboard_pkg::*;
	import ALSU_coverage_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_env extends uvm_env;
		`uvm_component_utils(ALSU_env);
		ALSU_agent ALSU_env_agent;
		ALSU_scoreboard ALSU_env_sb;
		ALSU_coverage ALSU_env_coverage;
		function new(string name="ALSU_env", uvm_component parent = null );
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			ALSU_env_agent=ALSU_agent::type_id::create("ALSU_env_agent",this);
			ALSU_env_sb= ALSU_scoreboard::type_id::create("ALSU_env_sb",this);
			ALSU_env_coverage=ALSU_coverage::type_id::create("ALSU_env_coverage",this);
		endfunction : build_phase 

		function void connect_phase(uvm_phase phase);
			ALSU_env_agent.agent_ap.connect(ALSU_env_sb.sb_exp);
			ALSU_env_agent.agent_ap.connect(ALSU_env_coverage.coverage_exp);
		endfunction : connect_phase 

	endclass : ALSU_env
endpackage : ALUS_env_pkg