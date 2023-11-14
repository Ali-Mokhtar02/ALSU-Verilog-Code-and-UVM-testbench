package ALSU_seq_item_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	typedef enum {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7 } Opcode_e;
	localparam MAXPOS=3, MAXNEG=-4, ZERO=0;
	class ALSU_seq_item extends uvm_sequence_item;
		`uvm_object_utils(ALSU_seq_item);

		rand logic signed [2:0] A, B;
		rand Opcode_e opcode;
		rand logic rst;
		rand logic cin,red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
		logic signed [5:0] out;
		logic signed [5:0] out_golden;
		logic [15:0] leds;
		logic [15:0] leds_golden;
		function  new(string name="ALSU_seq_item");
			super.new(name);
		endfunction : new

		virtual function string convert2string();
			return $sformatf(" %s  reset=%0b , A=%0b , B=%0b, opcode=%0b , cin=%0h red_op_A=%0b red_op_A=%0b bypass_A=%0b bypass_B=0%b direction=%0b serial_in=%0b",super.convert2string(),rst, A, B, opcode, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in);
		endfunction: convert2string

		virtual function string convert2string_stimulus();
			return $sformatf("reset=%0b , A=%0b , B=%0b, opcode=%0b , cin=%0h red_op_A=%0b red_op_A=%0b, bypass_A=%0b bypass_B=0%b direction=%0b serial_in=%0b",rst, A,B, opcode, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in);
		endfunction: convert2string_stimulus		

		//ALSU_4
		constraint reset {
			rst dist {0:=99 , 1:=1};
		}
		constraint ADD_MULT {
			if( opcode==MULT || opcode==ADD )
			{
				A dist { MAXPOS:=30 , ZERO:=30 , MAXNEG:=30 , [-MAXPOS:-1]:=10, [1:2]:=10 };
				B dist { MAXPOS:=30 , ZERO:=30 , MAXNEG:=30 , [-MAXPOS:-1]:=10, [1:2]:=10 };
			}
		}
		constraint OR_XOR {
			if( ( opcode==OR || opcode==XOR) && red_op_A )
			{
				A dist { 2:=90, -4:=90, [-3:0]:=10, 3:=30 };
				B==ZERO;
			}
				if( ( opcode==OR || opcode==XOR) && red_op_B )
				{
					B dist{ 2:=90, -4:=90 , [-3:0]:=10, 3:=30     };
					A==ZERO;
				}
		}
		//ALSU_3
		constraint Opcode_Invalid_Cases{
			opcode dist { [0:5]:=90 , [6:7]:=10 };
		}
		//ALSU_4
		constraint Bypass_A_B{
				bypass_B dist {ZERO:=80, 1:=20};
				bypass_A dist {ZERO:=80, 1:=20};
		}
		
	endclass : ALSU_seq_item

endpackage : ALSU_seq_item_pkg