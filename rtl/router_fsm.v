`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 23:32:05
// Design Name: 
// Module Name: router_fsm
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



module router_fsm(input clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,
		  input [1:0]addr,
	  	  input low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,
	  	  output detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy);
parameter DECODE_ADDRESS = 3'B000,
	  LOAD_FIRST_DATA = 3'b001,
	  LOAD_DATA = 3'b010,
	  FIFO_FULL_STATE = 3'b011,
	  LOAD_AFTER_FULL = 3'b100,
	  LOAD_PARITY = 3'b101,
	  CHECK_PARITY_ERROR = 3'b110,
	  WAIT_TILL_EMPTY = 3'b111;
reg [2:0] state,next_state;
always@(posedge clock)
begin
	if(!resetn)
		state <= DECODE_ADDRESS;
	else
	begin
		if((soft_reset_0 && addr ==2'b00)||
		  (soft_reset_1 && addr ==2'b01) ||
		  (soft_reset_2 && addr ==2'b10))
		 	state <= DECODE_ADDRESS;
		else
			state <= next_state;
	end
end
// internal variable
/*always@(posedge clock)
begin
	if(!resetn)
		addr <= 2'b00;
	else 
		if((soft_reset_0 && data_in == 2'b00)||
		  (soft_reset_1 && data_in == 2'b01)||
		  (soft_reset_2 && data_in == 2'b10))
		 	 addr <= 2'b00;
		else
			addr <= data_in;
end*/

//next_logic
always@(*)
begin
	next_state = DECODE_ADDRESS;
	case(state)
		DECODE_ADDRESS : begin
		       	  if((pkt_valid && (addr[1:0] == 2'b00) && fifo_empty_0)||
			    (pkt_valid && (addr[1:0] == 2'b01) && fifo_empty_1)||
			    (pkt_valid && (addr[1:0] == 2'b10) && fifo_empty_2))

								next_state = LOAD_FIRST_DATA;

				     else if((pkt_valid && (addr[1:0] == 2'b00) && !fifo_empty_0)||
				             (pkt_valid && (addr[1:0] == 2'b01) && !fifo_empty_1)||
				             (pkt_valid && (addr[1:0] == 2'b10) && !fifo_empty_2))

				      		next_state = WAIT_TILL_EMPTY;
				     else 
						next_state = DECODE_ADDRESS;
			         end		
		LOAD_FIRST_DATA : next_state = LOAD_DATA;
		LOAD_DATA : begin
		       	       	 if(fifo_full)
					 next_state = FIFO_FULL_STATE;
				 else if(!fifo_full && !pkt_valid)
					 next_state = LOAD_PARITY;
				 else 
					 next_state = LOAD_DATA;
			    end
				
		FIFO_FULL_STATE : begin
				       if(!fifo_full)
					       next_state = LOAD_AFTER_FULL;
				       else if (fifo_full)
					       next_state = FIFO_FULL_STATE;
			       end
	        LOAD_AFTER_FULL : begin
				       if(!parity_done && low_pkt_valid)
					       next_state = LOAD_PARITY;
				       else if(!parity_done && !low_pkt_valid)
					       next_state = LOAD_DATA;
				       else if(parity_done)
					       next_state = DECODE_ADDRESS;
			       end
	        LOAD_PARITY : next_state = CHECK_PARITY_ERROR;
		CHECK_PARITY_ERROR : begin
			 		if(!fifo_full)
						next_state = DECODE_ADDRESS;
					else 
						next_state = FIFO_FULL_STATE;
				end
		WAIT_TILL_EMPTY : begin
					if((fifo_empty_0 && (addr == 0)) ||
					   (fifo_empty_1 && (addr == 1)) ||
					   (fifo_empty_2 && (addr == 2)))
					   	next_state = LOAD_FIRST_DATA;
					else
						next_state = WAIT_TILL_EMPTY;
				end
	endcase
end
assign detect_add = (state == DECODE_ADDRESS) ? 1'b1: 1'b0;
assign lfd_state = (state == LOAD_FIRST_DATA) ? 1'b1:1'b0;
assign ld_state = (state == LOAD_DATA) ? 1'b1: 1'b0;
assign full_state = (state == FIFO_FULL_STATE) ? 1'b1 : 1'b0;
assign laf_state = (state == LOAD_AFTER_FULL) ? 1'b1:1'b0;
assign rst_int_reg = (state == CHECK_PARITY_ERROR) ? 1'b1: 1'b0;
assign write_enb_reg = ((state == LOAD_DATA)||(state == LOAD_AFTER_FULL)||(state == LOAD_PARITY)) ? 1'b1: 1'b0;
assign busy = ((state == LOAD_FIRST_DATA)||(state == FIFO_FULL_STATE)||(state == LOAD_AFTER_FULL)||(state == LOAD_PARITY)||(state == CHECK_PARITY_ERROR) ? 1'b1 : 1'b0);
endmodule

