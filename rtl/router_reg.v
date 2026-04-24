`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 23:32:23
// Design Name: 
// Module Name: router_reg
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


module router_reg(clock,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,err,dout);
input clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
input [7:0] data_in;
output reg parity_done,low_pkt_valid,err;
output reg [7:0]dout;
reg [7:0]header,full_state_byte,internal_parity,packet_parity;

//dout logic
always@(posedge clock)
begin
	if(!resetn)
		dout<=8'd0;
	else if(detect_add && pkt_valid && data_in[1:0]!=3)
		dout<=dout;
	else if(lfd_state)
		dout<=header;
	else if(ld_state && ~fifo_full)
		dout<=data_in;
	else if(ld_state && fifo_full)
		dout<=dout;
	else if(laf_state)
		dout<=full_state_byte;
end

//header logic
always@(posedge clock)
begin
	if(!resetn)
		header<=8'd0;
	else if(detect_add && pkt_valid && data_in[1:0]!=3)
		header<=data_in;
end

//internal parity
always@(posedge clock)
begin
	if(!resetn)
		internal_parity<=8'd0;
	else if(detect_add)
		internal_parity<=8'd0;
	else 
	begin
	if(lfd_state)
		   internal_parity<=internal_parity^header;
   else if(pkt_valid && ld_state && ~full_state)
		   internal_parity<=internal_parity^data_in;
	end
end

//packet parity
always@(posedge clock)
begin
	if(!resetn)
		packet_parity<=8'd0;
	else if(detect_add)
		packet_parity<=8'd0;
	else if(ld_state && ~pkt_valid)
		packet_parity<=data_in;
end

//parity done
always@(posedge clock)
begin
	if(!resetn)
		parity_done<=1'b0;
	else if((ld_state && !fifo_full && !pkt_valid) || (laf_state && low_pkt_valid && !parity_done))
		parity_done<=1'b1;
	else if (detect_add)
		parity_done<=1'b0;
end

//low pkt valid
always@(posedge clock)
begin
	if(!resetn)
		low_pkt_valid<=1'b0;
	else
	begin
	if (rst_int_reg)
		low_pkt_valid<=1'b0;
	else if(ld_state && ~pkt_valid)
		low_pkt_valid<=1'b1;
	end
end

//err
always@(posedge clock)
begin
	if(!resetn)
		err<=1'b0;
	else if(parity_done)
	    begin
	        if(internal_parity!=packet_parity)
		         err<=1'b1;
				else
					err<=1'b0;
		 end
end

//full_state_byte;
always@(posedge clock)
begin
	if(!resetn)
		full_state_byte <= 1'b0;
	else if(ld_state && fifo_full)
		full_state_byte <= data_in;
	else 
		full_state_byte <= full_state_byte;
end


endmodule 





