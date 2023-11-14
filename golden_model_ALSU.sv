import ALSU_seq_item_pkg::*; //import enum typedef

module ALSU_Golden_Model(A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B,
clk, rst, direction, leds_golden, out_golden);
input logic signed [2:0] A, B;
input logic [2:0] opcode;
input clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
output logic signed [5:0] out_golden; 
output logic [15:0] leds_golden;

logic signed [2:0] A_Reg,B_Reg;
logic [2:0] opcode_Reg;
logic cin_Reg;
logic red_op_A_Reg, red_op_B_Reg, bypass_A_Reg, bypass_B_Reg;
logic direction_Reg, serial_in_Reg;

logic invalid;

always @(*) begin
	if(opcode_Reg == INVALID_7 || opcode_Reg== INVALID_6)
		invalid=1;
	else if(opcode_Reg!=XOR && opcode_Reg!=OR && (red_op_B_Reg || red_op_A_Reg  ) )
		invalid=1;
	else
		invalid=0;
end



always @(posedge clk or posedge rst) begin 
	if(rst) begin
		out_golden<=0;
		leds_golden<=0;
	end 
	else begin
		if(invalid) begin
			out_golden<=0;
			leds_golden<=~leds_golden;
		end
		else begin
			leds_golden<=0;
			if(bypass_A_Reg)
				out_golden<=A_Reg;
			else if(bypass_B_Reg)
				out_golden<=B_Reg;
			else if(red_op_A_Reg) begin
				if(opcode_Reg==OR)
					out_golden<=|A_Reg;
				else
					out_golden<=^A_Reg;
			end
			else if(red_op_B_Reg) begin
				if(opcode_Reg==OR)
					out_golden<=|B_Reg;
				else
					out_golden<=^B_Reg;
			end
			else begin
				case(opcode_Reg)
					OR: begin
						out_golden<= A_Reg | B_Reg;
					end
					XOR: begin
						out_golden<= A_Reg ^ B_Reg;
					end
					ADD: begin
						if(cin_Reg)
							out_golden= A_Reg + B_Reg + 1;
						else
							out_golden= A_Reg + B_Reg;
					end
					MULT: begin
						out_golden<= A_Reg * B_Reg;
					end
					SHIFT: begin
						if(direction_Reg)
							out_golden<= {out_golden[4:0] , serial_in_Reg};
						else
							out_golden<= {serial_in_Reg, out_golden[5:1]};
					end
					ROTATE: begin
						if(direction_Reg)
							out_golden<={out_golden[4:0], out_golden[5] };
						else
							out_golden<={out_golden[0], out_golden[5:1] };
					end
				endcase
			end
		end
	end
end

always @(posedge clk or posedge rst) begin
	if(rst) begin
	    A_Reg <= 0;
	    B_Reg <= 0;
	    opcode_Reg <= MULT; //doesn't matter
		cin_Reg <= 0;
	    red_op_A_Reg <= 0;
	    red_op_B_Reg <= 0;
	    bypass_A_Reg <= 0;
	    bypass_B_Reg <= 0;
	    direction_Reg <= 0;
	    serial_in_Reg <= 0;
	end
	else begin
		A_Reg <= A;
	    B_Reg <= B;
	    opcode_Reg <= opcode;
		cin_Reg <= cin;
	    red_op_A_Reg <= red_op_A;
	    red_op_B_Reg <= red_op_B;
	    bypass_A_Reg <= bypass_A;
	    bypass_B_Reg <= bypass_B;
	    direction_Reg <= direction;
	    serial_in_Reg <= serial_in;
	end
end
endmodule