module ALSU_assertions (
A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, clk, rst, direction, leds, out);
input clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input logic [2:0] opcode;
input logic signed [2:0] A, B;
input logic [15:0] leds;
input  logic signed [5:0] out;
logic invalid;
assign invalid= opcode == 7 || opcode== 6 || ( ( opcode!=1 && opcode!=0) && (red_op_B || red_op_A) ) ;

always_comb begin
	if(rst)
		check_reset_property: assert final(out==0 && leds==0);
end

property invalid_reduction;
	@(posedge clk)  disable iff(rst) ( (red_op_A || red_op_B) && (opcode!=0 && opcode!=1) ) |-> ##2 out==0 && leds==~$past(leds);
endproperty
property invalid_opcode;
	@(posedge clk) disable iff(rst) ( opcode==6 || opcode==7) |-> ##2 out==0 && leds==~$past(leds);
endproperty
//assuming A always has higher prio
property passA;
	logic signed [2:0] A_prev;
	@(posedge clk) disable iff(rst) (!invalid && bypass_A , A_prev=A ) |-> ##2 out==A_prev && leds==0;
endproperty

property passB;
	logic signed [2:0] B_prev;
	@(posedge clk) disable iff(rst) (!invalid && bypass_B && ~bypass_A, B_prev=B ) |-> ##2 out==B_prev && leds==0;
endproperty

property red_or_A;
	logic signed [2:0] A_prev;
	@(posedge clk) disable iff(rst) (!invalid && !bypass_A && !bypass_B && red_op_A && opcode==0, A_prev=A ) |-> ##2 out==|A_prev && leds==0;
endproperty

property red_or_B;
	logic signed [2:0] B_prev;
	@(posedge clk) disable iff(rst) (!invalid && !bypass_A && !bypass_B && red_op_B && opcode==0, B_prev=B ) |-> ##2 out==|B_prev && leds==0;
endproperty
property red_Xor_A;
	logic signed [2:0] A_prev;
	@(posedge clk) disable iff(rst) (!invalid && !bypass_A && !bypass_B && red_op_A && opcode==1, A_prev=A ) |-> ##2 out==^A_prev && leds==0;
endproperty

property red_xor_B;
	logic signed [2:0] B_prev;
	@(posedge clk) disable iff(rst) (!invalid && !bypass_A && !bypass_B && red_op_B && opcode==1, B_prev=B ) |-> ##2 out==^B_prev && leds==0;
endproperty

property op_or;
	logic signed [2:0] A_prev;
	logic signed [2:0] B_prev;
	@(posedge clk) disable iff(rst) (!bypass_A && !bypass_B && !red_op_B && !red_op_A && opcode==0, A_prev=A, B_prev=B ) |-> ##2 out==A_prev|B_prev && leds==0;
endproperty

property op_xor;
	logic signed [2:0] A_prev;
	logic signed [2:0] B_prev;
	@(posedge clk) disable iff(rst) (!bypass_A && !bypass_B && !red_op_B && !red_op_A && opcode==1, A_prev=A, B_prev=B ) |-> ##2 out==A_prev^B_prev && leds==0;
endproperty
// assuming always full adder
property op_add;
	@(posedge clk) disable iff(rst) (!bypass_A && !bypass_B && !red_op_B && !red_op_A && opcode==2) |-> ##2 ( out[2:0]== ($past(A,2)+ $past(B,2)+ $past(cin,2)) ) && leds==0;
endproperty

property op_mult;
	logic signed [2:0] A_prev;
	logic signed [2:0] B_prev;
	@(posedge clk) disable iff(rst) (!bypass_A && !bypass_B && !red_op_B && !red_op_A && opcode==3, A_prev=A, B_prev=B ) |-> ##2 out==A_prev*B_prev && leds==0;
endproperty

property op_shift_right;
	logic serial_in_prev;
	logic direction_prev;
	@(posedge clk) disable iff(rst) (!bypass_A && !bypass_B && !red_op_B && !red_op_A && opcode==4,serial_in_prev=serial_in, 
	direction_prev=direction) |-> ##2 direction_prev |-> out=={$past(out[4:0]), serial_in_prev} && leds==0;
endproperty

property op_shift_left;
	logic serial_in_prev;
	logic direction_prev;
	@(posedge clk) disable iff(rst) (!bypass_A && !bypass_B && !red_op_B && !red_op_A && opcode==4,serial_in_prev=serial_in,
	direction_prev=direction ) |-> ##2 !direction_prev |-> out=={serial_in_prev,$past(out[5:1])} && leds==0;
endproperty

property op_rotate_right;
	logic direction_prev;
	@(posedge clk) disable iff(rst) (!bypass_A && !bypass_B && !red_op_B && !red_op_A && opcode==5,
	direction_prev=direction ) |-> ##2 direction_prev |-> out=={$past( (out[4:0]) ),$past((out[5])) } && leds==0;
endproperty

property op_rotate_left;
	logic direction_prev;
	@(posedge clk) disable iff(rst) (!bypass_A && !bypass_B && !red_op_B && !red_op_A && opcode==5,
	direction_prev=direction ) |-> ##2 !direction_prev |-> out=={$past(out[0]),$past(out[5:1]) } && leds==0;
endproperty


invalid_reduction_ap: assert property(invalid_reduction);
invalid_reduction_cp: cover property(invalid_reduction);


invalid_opcode_ap: assert property(invalid_opcode);
invalid_opcode_cp: cover property(invalid_opcode);

passA_ap: assert property(passA);
passA_cp: cover property(passA);

passB_ap: assert property(passB);
passB_cp: cover property(passB);

red_or_A_ap: assert property(red_or_A);
red_or_A_cp: cover property(red_or_A);

red_or_B_ap: assert property(red_or_B);
red_or_B_cp: cover property(red_or_B);

red_Xor_A_ap: assert property(red_Xor_A);
red_Xor_A_cp: cover property(red_Xor_A);

red_xor_B_ap: assert property(red_xor_B);
red_xor_B_cp: cover property(red_xor_B);

op_or_ap: assert property(op_or);
op_or_cp: cover property(op_or);

op_xor_ap: assert property(op_xor);
op_xor_cp: cover property(op_xor);

op_add_ap: assert property(op_add);
op_add_cp: cover property(op_add);

op_mult_ap: assert property(op_mult);
op_mult_cp: cover property(op_mult);

op_shift_right_ap: assert property(op_shift_right);
op_shift_right_cp: cover property(op_shift_right);

op_shift_left_ap: assert property(op_shift_left);
op_shift_left_cp: cover property(op_shift_left);

op_rotate_right_ap: assert property(op_rotate_right);
op_rotate_right_cp: cover property(op_rotate_right);

op_rotate_left_ap: assert property(op_rotate_left);
op_rotate_left_cp: cover property(op_rotate_left);




endmodule : ALSU_assertions