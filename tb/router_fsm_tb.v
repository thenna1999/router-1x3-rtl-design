`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 23:35:46
// Design Name: 
// Module Name: router_fsm_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module router_fsm_tb();
reg clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full;
reg [1:0]data_in;
reg low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
wire detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy;

router_fsm DUT(clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,data_in,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy);

always 
begin
	#5;
	clock=1'b1;
	#5;
	clock=1'b0;
end

task rst;
	begin
		@(negedge clock)
		resetn=1'b0;
		@(negedge clock)
		resetn=1'b1;
	end
endtask

task t1();
	begin
		@(negedge clock)
		pkt_valid=1'b1;
		data_in=2'b01;
		fifo_empty_1=1'b1;
		@(negedge clock)
	   @(negedge clock)
		fifo_full=1'b0;
		pkt_valid=1'b0;
		@(negedge clock)
		@(negedge clock)
		fifo_full=1'b0;
	end
endtask

task t2();
	begin
		@(negedge clock)
		pkt_valid=1'b1;
		data_in=2'b01;
		fifo_empty_1=1'b1;
		@(negedge clock)
	   @(negedge clock)
		fifo_full=1'b1;
		@(negedge clock)
		@(negedge clock)
		fifo_full=1'b0;
		@(negedge clock)
		parity_done=1'b0;
		low_pkt_valid=1'b1;
		@(negedge clock)
		@(negedge clock)
		fifo_full=1'b0;
	end
endtask

task t3();
	begin
		@(negedge clock)
		pkt_valid=1'b1;
		data_in=2'b01;
		fifo_empty_1=1'b1;
		@(negedge clock)
	   @(negedge clock)
		fifo_full=1'b1;
		@(negedge clock)
		@(negedge clock)
		fifo_full=1'b0;
		@(negedge clock)
		parity_done=1'b0;
		low_pkt_valid=1'b0;
		@(negedge clock)
		fifo_full=1'b0;
		pkt_valid=1'b0;
		@(negedge clock)
		@(negedge clock)
		fifo_full=1'b0;
	end
endtask

task t4();
	begin
		@(negedge clock)
		pkt_valid=1'b1;
		data_in=2'b01;
		fifo_empty_1=1'b1;
		@(negedge clock)
	   @(negedge clock)
		fifo_full=1'b0;
		pkt_valid=1'b0;
		@(negedge clock)
		@(negedge clock)
		fifo_full=1'b1;
		@(negedge clock)
		@(negedge clock)
		fifo_full=1'b0;
		@(negedge clock)
		parity_done=1'b1;
		end
	endtask

initial
begin
	rst;
	t2;
	#500;
	$finish;
end
endmodule





