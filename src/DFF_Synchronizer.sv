`timescale 1ns / 1ps

module DFF_Synchronizer #(parameter ADDR_SIZE = 4)
(input [ADDR_SIZE:0] ptr,
 input clk,
 input rst_n,
 output reg [ADDR_SIZE:0] ptr_out  
 );
 
 reg [ADDR_SIZE:0] ptr_ff1;
 
 always@(posedge clk or negedge rst_n) begin
    if(!rst_n) ptr_ff1<= 0;
    else ptr_ff1<= ptr;
 end
 
 always@(posedge clk or negedge rst_n) begin
    if(!rst_n) ptr_out<= 0;
    else ptr_out<= ptr_ff1;
 end
    
    
endmodule
