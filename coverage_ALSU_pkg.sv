package ALSU_coverage_pkg;
	import uvm_pkg::*;
	import ALSU_seq_item_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_coverage extends  uvm_component;
		`uvm_component_utils(ALSU_coverage);
		
		uvm_analysis_export #(ALSU_seq_item) coverage_exp;
		uvm_tlm_analysis_fifo #(ALSU_seq_item) coverage_fifo;
		ALSU_seq_item ALSU_coverage_seq_item;

		covergroup cvr_gp();
				//ALSU_1
				A_cp: coverpoint ALSU_coverage_seq_item.A
				{
					bins data_0= {ZERO};
					bins data_max= {MAXPOS};
					bins data_min= {MAXNEG};
					bins data_default= default;
				}
				//ALSU_2
				A_walkingones_cp: coverpoint ALSU_coverage_seq_item.A
				{
					bins data_walkingones1={3'b001};
					bins data_walkingones2={3'b010};
					bins data_walkingones4={$signed(3'b100)};
				}
				//ALSU_1
				B_cp: coverpoint ALSU_coverage_seq_item.B
				{
					bins data_0= {ZERO};
					bins data_max= {MAXPOS};
					bins data_min= {MAXNEG};
					bins data_default= default;
				}
				//ALSU_2
				B_walkingones_cp: coverpoint ALSU_coverage_seq_item.B
				{
					bins data_walkingones1={3'b001};
					bins data_walkingones2={3'b010};
					bins data_walkingones4={$signed(3'b100)};
				}
				//ALSU_3
				ALU_cp: coverpoint ALSU_coverage_seq_item.opcode
				{
					bins Bins_shift[] = {SHIFT,ROTATE};
					bins Bins_arith[] = {ADD,MULT};
					bins Bins_bitwise[] = {OR,XOR};
					bins Bins_invalid = {INVALID_6, INVALID_7};
				}

				Serial_in_cp: coverpoint ALSU_coverage_seq_item.serial_in;
				Direction_cp: coverpoint ALSU_coverage_seq_item.direction;
				Cin_cp: coverpoint ALSU_coverage_seq_item.cin;
				Red_A: coverpoint ALSU_coverage_seq_item.red_op_A;
				Red_B: coverpoint ALSU_coverage_seq_item.red_op_B;
			
				//ALSU_1
				ADD_Mult: cross ALU_cp, A_cp, B_cp // all permuatuions of A and B with addition/multiplication
				{	
					bins Addition_Multiplication_MPMP = binsof(ALU_cp.Bins_arith) && binsof(A_cp) intersect
					{MAXPOS} && binsof(B_cp) intersect {MAXPOS};
					bins Addition_Multiplication_MP0 = binsof(ALU_cp.Bins_arith) && binsof(A_cp) intersect
					{MAXPOS} && binsof(B_cp) intersect {ZERO};
					bins Addition_Multiplication_MPMN = binsof(ALU_cp.Bins_arith) && binsof(A_cp) intersect
					{MAXPOS} && binsof(B_cp) intersect {MAXNEG};

					bins Addition_Multiplication_MNMP = binsof(ALU_cp.Bins_arith) && binsof(A_cp) intersect
					{MAXNEG} && binsof(B_cp) intersect {MAXPOS};
					bins Addition_Multiplication_MN0 = binsof(ALU_cp.Bins_arith) && binsof(A_cp) intersect
					{MAXNEG} && binsof(B_cp) intersect {ZERO};
					bins Addition_Multiplication_MNMN = binsof(ALU_cp.Bins_arith) && binsof(A_cp) intersect
					{MAXNEG} && binsof(B_cp) intersect {MAXNEG};

					bins Addition_Multiplication_0MP = binsof(ALU_cp.Bins_arith) && binsof(A_cp) intersect
					{ZERO} && binsof(B_cp) intersect {MAXPOS};
					bins Addition_Multiplication_00 = binsof(ALU_cp.Bins_arith) && binsof(A_cp) intersect
					{ZERO} && binsof(B_cp) intersect {ZERO};
					bins Addition_Multiplication_0MN = binsof(ALU_cp.Bins_arith) && binsof(A_cp) intersect
					{ZERO} && binsof(B_cp) intersect {MAXNEG};

					ignore_bins ADD_MULT_shift = binsof(ALU_cp.Bins_shift) ;
					ignore_bins ADD_MULT_bitwise=binsof(ALU_cp.Bins_bitwise);

				}
				//ALSU_8
				Shift_Serial_in: cross Serial_in_cp,ALU_cp
				{
					ignore_bins none_ADD_Mult1= binsof(ALU_cp.Bins_arith);
					ignore_bins none_ADD_Mult2= binsof(ALU_cp.Bins_bitwise);
					bins Shift_Serial_in1 = binsof(Serial_in_cp) intersect {1} && binsof(ALU_cp.Bins_shift) intersect {SHIFT};
					bins Shift_Serial_in0 = binsof(Serial_in_cp) intersect {0} && binsof(ALU_cp.Bins_shift) intersect {SHIFT};

				}	
				//ALSU_6				
				ALU_Cin: cross Cin_cp,ALU_cp
				{
					ignore_bins none_ADD_Mult1= binsof(ALU_cp.Bins_shift);
					ignore_bins none_ADD_Mult2= binsof(ALU_cp.Bins_bitwise);
					bins Add_Mult_Cin1 = binsof(Cin_cp) intersect {1} && binsof(ALU_cp.Bins_arith);
					bins Add_Mult_Cin0 = binsof(Cin_cp) intersect {0} && binsof(ALU_cp.Bins_arith);
				}				
				//ALSU_5
				Shift_rotate_direction: cross Direction_cp,ALU_cp
				{
					ignore_bins none_ADD_Mult1= binsof(ALU_cp.Bins_arith);
					ignore_bins none_ADD_Mult2= binsof(ALU_cp.Bins_bitwise);
					bins Shift_Rotate_Direction_1 = binsof(Direction_cp) intersect {1} && binsof(ALU_cp.Bins_shift);
					bins Shift_Rotate_Direction_0 = binsof(Direction_cp) intersect {0} && binsof(ALU_cp.Bins_shift);
				}	
				//ALSU_2
				OR_XOR_redA: cross A_walkingones_cp, Red_A, B_cp
				{
					ignore_bins B_MP = binsof(B_cp.data_max);
					ignore_bins B_NP = binsof(B_cp.data_min);
					bins redA_walkA1_ZeroB = binsof(A_walkingones_cp.data_walkingones1)  && binsof(B_cp.data_0) && binsof(Red_A) intersect{1};
					bins redA_walkA2_ZeroB = binsof(A_walkingones_cp.data_walkingones2)  && binsof(B_cp.data_0) && binsof(Red_A) intersect{1};
					bins redA_walkA4_ZeroB = binsof(A_walkingones_cp.data_walkingones4) && binsof(B_cp.data_0) && binsof(Red_A) intersect{1};
					ignore_bins red_A_0 = binsof(Red_A) intersect {0};

				}
				//ALSU_2
				OR_XOR_redb: cross A_cp, Red_B, B_walkingones_cp
				{
					ignore_bins A_MP = binsof(A_cp.data_max);
					ignore_bins A_NP = binsof(A_cp.data_min);
					bins redB_walkB1_ZeroA = binsof(B_walkingones_cp.data_walkingones1)  && binsof(A_cp.data_0) && binsof(Red_B) intersect{1};
					bins redB_walkB2_ZeroA = binsof(B_walkingones_cp.data_walkingones2)  && binsof(A_cp.data_0) && binsof(Red_B) intersect{1};
					bins redB_walkB4_ZeroA = binsof(B_walkingones_cp.data_walkingones4)  && binsof(A_cp.data_0) && binsof(Red_B) intersect{1};
					ignore_bins red_B_0 = binsof(Red_B) intersect {0};
				}
				//ALSU_7
				INVALID_CASE1: cross ALU_cp, Red_A
				{
					ignore_bins ADD_MULT_bitwise = binsof(ALU_cp.Bins_bitwise);
					ignore_bins red_A_0 = binsof(Red_A) intersect {0}; 
					bins INVALID_DUE_to_ReductionA = binsof(ALU_cp) intersect {SHIFT,ROTATE,ADD,MULT} && binsof(Red_A) intersect {1} ; //red_A has higher priority
				}
				//ALSU_7
				INVALID_CASE2: cross ALU_cp, Red_A, Red_B
				{
					ignore_bins ADD_MULT_bitwise = binsof(ALU_cp.Bins_bitwise);
					ignore_bins red_A_0 = binsof(Red_A) intersect {1}; 
					ignore_bins red_B_0 = binsof(Red_B) intersect {0};
					bins INVALID_DUE_to_ReductionB = binsof(ALU_cp) intersect {SHIFT,ROTATE,ADD,MULT} && binsof(Red_B) intersect {1} && binsof(Red_A) intersect {0}; //red_A has higher priority
				}

		endgroup

		function new(string name="ALSU_coverage", uvm_component parent=null );
			super.new(name,parent);
			cvr_gp=new();
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			coverage_exp= new("coverage_exp",this);
			coverage_fifo= new("coverage_fifo",this);
		endfunction: build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			coverage_exp.connect(coverage_fifo.analysis_export);

		endfunction: connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				coverage_fifo.get(ALSU_coverage_seq_item);
				cvr_gp.sample();
			end
		endtask : run_phase

	endclass : ALSU_coverage
endpackage : ALSU_coverage_pkg