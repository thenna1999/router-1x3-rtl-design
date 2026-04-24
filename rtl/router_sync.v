`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 23:32:44
// Design Name: 
// Module Name: router_sync
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



module router_sync(detect_add,data_in,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,write_enb,fifo_full,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,full_0,full_1,full_2,vld_out_0,vld_out_1,vld_out_2);
input detect_add,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
input [1:0] data_in;
output reg [2:0] write_enb;
output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
output vld_out_0,vld_out_1,vld_out_2;
reg [1:0]temp;
reg [5:0]count_0,count_1,count_2;

//internal variable
always@(posedge clock)
begin
	if (!resetn)
		temp<=2'b0;
	else if (detect_add==1'b1)
		temp<=data_in;
end

//write_enb
always@(*)
begin
	if(write_enb_reg)
	begin
		case(temp)
			2'b00:write_enb=3'b001;
			2'b01:write_enb=3'b010;
			2'b10:write_enb=3'b100;
			default:write_enb=3'b000;
		endcase
	end
	else
		write_enb=3'b000;
end

//fifo_fsm
always@(*)
begin
	case(temp)
		2'b00:fifo_full=full_0;
		2'b01:fifo_full=full_1;
		2'b10:fifo_full=full_2;
		default:fifo_full=1'b0;
	endcase
end

//valid_out

assign vld_out_0=~empty_0;
assign vld_out_1=~empty_1;
assign vld_out_2=~empty_2;

//soft_reset_0
always@(posedge clock)
begin
	if(!resetn)
	begin
		count_0<=6'd1;
		soft_reset_0<=1'b0;
	end
	else if (vld_out_0)
	begin
		if(!read_enb_0)
		begin
			if(count_0==6'd29)
				begin
					soft_reset_0<=1'b1;
					count_0<=1'b0;
				end
			else
				begin
					soft_reset_0<=1'b0;
					count_0<=count_0 + 1'd1;
				end
		end
	end
end

//soft_reset_1
always@(posedge clock)
begin
	if(!resetn)
	begin
		count_1<=6'd1;
		soft_reset_1<=1'b0;
	end
	else if (vld_out_1)
	begin
		if(!read_enb_1)
		begin
			if(count_1==6'd29)
				begin
					soft_reset_1<=1'b1;
					count_1<=1'b0;
				end
			else
				begin
					soft_reset_1<=1'b0;
					count_1<=count_1 + 1'd1;
				end
		end
	end
end

//soft_reset_2
always@(posedge clock)
begin
	if(!resetn)
	begin
		count_2<=6'd1;
		soft_reset_2<=1'b0;
	end
	else if (vld_out_2)
	begin
		if(!read_enb_2)
		begin
			if(count_2==6'd29)
				begin
					soft_reset_2<=1'b1;
					count_2<=1'b0;
				end
			else
				begin
					soft_reset_2<=1'b0;
					count_2<=count_2 + 1'd1;
				end
		end
	end
end

endmodule




		 
		    






