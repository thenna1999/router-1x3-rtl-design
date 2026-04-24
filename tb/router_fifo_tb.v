`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 23:33:46
// Design Name: 
// Module Name: router_fifo_tb
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


module router_fifo_tb();
reg  clock,resetn,write_enb,soft_reset,read_enb,lfd_state;
reg [7:0]data_in;
wire empty,full;
wire [7:0]data_out;
integer i;
router_fifo DUT(clock,resetn,write_enb,soft_reset,read_enb,data_in,lfd_state,empty,full,data_out);

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

task soft_rst;
	begin
	@(negedge clock)
	soft_reset=1'b1;
	@(negedge clock)
	soft_reset=1'b0;
end
endtask

task write;
	reg [7:0] payload_data,parity,header;
	reg [5:0] payload_len;
	reg [1:0] addr;
	begin   
	        //header;
		@(negedge clock)
		payload_len=6'd16;
		addr=2'b01;
		header={payload_len,addr};
		data_in=header;
		lfd_state=1'b1;
		write_enb=1'b1;

		//payload_data;
		for(i=0;i<payload_len;i=i+1)
		begin
			@(negedge clock)
			lfd_state=1'b0;
			payload_data={$random}%256;
			data_in=payload_data;
		end

		//parity;
		@(negedge clock)
		parity={$random}%256;
		data_in=parity;
	end
endtask

task read;
	begin
		@(negedge clock)
		write_enb=1'b0;
		read_enb=1'b1;
	end
endtask

initial
begin
	#5;
	rst;
	soft_rst;
	write;
	read;
	#1000 $finish;
end
endmodule





