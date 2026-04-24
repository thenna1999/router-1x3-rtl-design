`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 23:34:37
// Design Name: 
// Module Name: router_sync_tb
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



module router_sync_tb();
reg  detect_add,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
reg [1:0] data_in;
wire [2:0] write_enb;
wire vld_out_0,vld_out_1,vld_out_2;
wire fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;

router_sync DUT(detect_add,data_in,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,write_enb,fifo_full,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,full_0,full_1,full_2,vld_out_0,vld_out_1,vld_out_2);

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

initial 
begin
	rst;
	@(negedge clock)
	detect_add=1'b1;
	data_in=2'b10;
	@(negedge clock)
	detect_add=1'b0;
	write_enb_reg=1'b1;
	@(negedge clock)
	{full_0,full_1,full_2}=3'b001;
	@(negedge clock)
	{empty_0,empty_1,empty_2}=3'b110;
	@(negedge clock)
	{read_enb_0,read_enb_1,read_enb_2}=3'b000;
	#1000 $finish;
end
endmodule

