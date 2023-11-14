vlib work
vlog -f Compile.txt 
vsim -voptargs=+acc work.ALSU_Top  -classdebug -uvmcontrol=all 
add wave /ALSU_Top/interface_insta/*
add wave /ALSU_Top/DUT_insta/asertions_insta/red_or_B_ap /ALSU_Top/DUT_insta/asertions_insta/op_rotate_right_ap /ALSU_Top/DUT_insta/asertions_insta/check_reset_property /ALSU_Top/DUT_insta/asertions_insta/invalid_reduction_ap /ALSU_Top/DUT_insta/asertions_insta/invalid_opcode_ap /ALSU_Top/DUT_insta/asertions_insta/passA_ap /ALSU_Top/DUT_insta/asertions_insta/op_shift_left_ap /ALSU_Top/DUT_insta/asertions_insta/red_or_A_ap /ALSU_Top/DUT_insta/asertions_insta/op_rotate_left_ap /ALSU_Top/DUT_insta/asertions_insta/red_Xor_A_ap /ALSU_Top/DUT_insta/asertions_insta/op_shift_right_ap /ALSU_Top/DUT_insta/asertions_insta/op_or_ap /ALSU_Top/DUT_insta/asertions_insta/op_xor_ap /ALSU_Top/DUT_insta/asertions_insta/op_add_ap /ALSU_Top/DUT_insta/asertions_insta/op_mult_ap /ALSU_Top/DUT_insta/asertions_insta/red_xor_B_ap /ALSU_Top/DUT_insta/asertions_insta/passB_ap
coverage save ALSU.ucdb -du ALSU -onexit
run 0
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/ALSU_test_env/ALSU_env_agent/ALSU_agent_driver/stim_seq_item
run -all
coverage report -detail -cvg -directive -comments -output fcover_ALSU.txt {}