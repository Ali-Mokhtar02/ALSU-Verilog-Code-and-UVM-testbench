package ALSU_config_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_config_obj extends  uvm_object;

		`uvm_object_utils(ALSU_config_obj);

		virtual ALSU_if ALSU_config_vif;
		uvm_active_passive_enum active;

		function new(string name="ALSU_config_obj");
			super.new(name);
		endfunction : new
		
	endclass : ALSU_config_obj
endpackage : ALSU_config_pkg