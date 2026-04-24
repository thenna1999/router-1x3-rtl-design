`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 23:31:39
// Design Name: 
// Module Name: router_fifo
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


module router_fifo(clock,resetn,write_enb,soft_reset,read_enb,d_in,lfd_state,empty,full,data_out);
input clock,resetn,write_enb,soft_reset,read_enb,lfd_state;
input [7:0]d_in;
output empty,full;
output reg [7:0]data_out;
reg [8:0]mem[15:0];
reg [4:0]wptr,rptr;
reg [5:0]count;
integer i,j,k;
reg lfd_st;

always@(posedge clock)
begin
if(!resetn)
	lfd_st <= 1'b0;
	else
	lfd_st<=lfd_state;
end
	
//write;
always@(posedge clock)
begin
	if(!resetn) 
		begin
		    for(i=0;i<16;i=i+1)
			 begin
				mem[i]<=8'b0;
				wptr <= 5'b0;
			 end
		end
	else if(soft_reset)
		begin
		    for(j=0;j<16;j=j+1)
			 begin
				mem[j]<=8'b0;
				wptr <= 4'b0;
    		 end	
		end
	else if(write_enb && !full)
	   begin
		 mem[wptr[3:0]] <= {lfd_st,d_in};
	 	 wptr<=wptr+'b1;
	   end
end
//read;
always@(posedge clock)
begin
	if(!resetn)
	  begin
		data_out<=8'b0;
		rptr <= 5'b0;
	  end
	else if(soft_reset)
		data_out<=8'bz;
	else if(count==5'b0 && data_out!=8'b0)
		data_out<=8'bz;
	else if(read_enb && !empty)
	begin
		data_out<=mem[rptr[3:0]];
		rptr<=rptr+1'b1;
end
end

//internal counter
always@(posedge clock)
begin
	if(!resetn)
		count<=6'b0;
	else if(soft_reset)
	   begin
		count<=6'b0;
		/*for(k=0;k<16;k=k+1)
			 begin
				mem[k]<=8'b0;
				wptr <= 4'b0;
    		 end*/
		end
	else if(read_enb && !empty)
	begin
		if(mem[rptr[3:0]][8]== 1'b1)
			count<=mem[rptr[3:0]][7:2]+1'b1;
		else if(count!= 6'b0)
			count<=count-1'b1;
  end
end
assign full = ((wptr == 'd16) && (rptr=='b0))?1'b1:1'b0;
assign empty = (rptr==wptr)?1'b1:1'b0;
endmodule


