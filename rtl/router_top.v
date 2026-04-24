`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 23:31:08
// Design Name: 
// Module Name: router_top
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



`define size 4 
module router_top(clock,resetn,read_enb_0,read_enb_1,read_enb_2,data_in,pkt_valid,
data_out_0,data_out_1,data_out_2,vld_out_0,vld_out_1,vld_out_2,error,busy);
input clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
input [7:0] data_in;
output [7:0] data_out_0,data_out_1,data_out_2;
output vld_out_0,vld_out_1,vld_out_2,error,busy;
genvar i;
wire [2:0]w_enb,sft_rst,emp,fu;
wire [2:0] r_enb = {read_enb_2,read_enb_1,read_enb_0};
wire [7:0] data_out [2:0];
wire [7:0] d_out;

assign soft_reset_0 = sft_rst[0];
assign soft_reset_1 = sft_rst[1];
assign soft_reset_2 = sft_rst[2];

assign data_out_0 = data_out[0];
assign data_out_1 = data_out[1];
assign data_out_2 = data_out[2];


router_fsm f1(.clock(clock),.resetn(resetn),.pkt_valid(pkt_valid),.parity_done(parity_done),
.soft_reset_0(sft_rst[0]),.soft_reset_1(sft_rst[1]),.soft_reset_2(sft_rst[2]),
.fifo_full(fifo_full),.addr(data_in[1:0]),.low_pkt_valid(low_pkt_valid),.fifo_empty_0(emp[0]),
.fifo_empty_1(emp[1]),.fifo_empty_2(emp[2]),.detect_add(detect_add),.ld_state(ld_state),
.laf_state(laf_state),.full_state(full_state),.write_enb_reg(write_enb_reg),.rst_int_reg(rst_int_reg),
.lfd_state(lfd_state),.busy(busy));


router_sync s1(.detect_add(detect_add),.data_in(data_in[1:0]),.write_enb_reg(write_enb_reg),
.clock(clock),.resetn(resetn),.read_enb_0(r_enb[0]),.read_enb_1(r_enb[1]),
.read_enb_2(r_enb[2]),.write_enb(w_enb[2:0]),.fifo_full(fifo_full),.empty_0(emp[0]),
.empty_1(emp[1]),.empty_2(emp[2]),.soft_reset_0(sft_rst[0]),.soft_reset_1(sft_rst[1]),
.soft_reset_2(sft_rst[2]),.full_0(fu[0]),.full_1(fu[1]),.full_2(fu[2]),.vld_out_0(vld_out_0),
.vld_out_1(vld_out_1),.vld_out_2(vld_out_2));
	

router_reg r1(.clock(clock),.resetn(resetn),.pkt_valid(pkt_valid),.
data_in(data_in),.fifo_full(fifo_full),.rst_int_reg(rst_int_reg),.detect_add(detect_add),
.ld_state(ld_state),.laf_state(laf_state),.full_state(full_state),.lfd_state(lfd_state),.parity_done(parity_done),
.low_pkt_valid(low_pkt_valid),.err(error),.dout(d_out));

generate for(i=0;i<(`size-1);i=i+1)
begin : fifo
router_fifo a1(.clock(clock),.resetn(resetn),.write_enb(w_enb[i]),
.soft_reset(sft_rst[i]),.read_enb(r_enb[i]),
.d_in(d_out),.lfd_state(lfd_state),.empty(emp[i]),.full(fu[i]),.data_out(data_out[i]));
end
endgenerate

endmodule


