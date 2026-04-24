`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 23:34:13
// Design Name: 
// Module Name: router_reg_tb
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


module router_reg_tb();
reg clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
reg [7:0] data_in;
wire parity_done,low_pkt_valid,err;
wire [7:0]dout;
integer i;

router_reg DUT(clock,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,err,dout);

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

task packet_generation;
	reg [7:0] payload_data,parity,header;
	reg [5:0] payload_len;
	reg [1:0] addr;
	begin
		@(negedge clock)
		payload_len=6'd5;
		addr=2'b10;
		pkt_valid=1'b1;
		detect_add=1'b1;
		parity=1'b0;
		header={payload_len,addr};
		parity=parity^header;
		data_in = header;
		@(negedge clock)
		detect_add=1'b0;
		lfd_state=1'b1;
		full_state=1'b0;
		fifo_full=1'b0;
		laf_state=1'b0;
		for(i=0;i<payload_len;i=i+1)
		begin
			@(negedge clock)
			lfd_state=1'b0;
			ld_state=1'b1;
			payload_data={$random}%256;
			data_in=payload_data;
			parity=parity^data_in;
		end
		@(negedge clock)
		pkt_valid=1'b0;
		data_in=parity;
		@(negedge clock)
		ld_state=1'b0;
	end
endtask

initial
begin
	rst;
	#5;
	packet_generation;
	#500 $finish;
end
endmodule



