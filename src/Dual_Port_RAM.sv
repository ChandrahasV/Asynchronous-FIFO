`timescale 1ns / 1ps

module Dual_Port_RAM #(parameter ADDRSIZE = 4,
                       parameter DATASIZE = 8)
(input wen,
 input [ADDRSIZE-1:0] waddr,
 input [DATASIZE-1:0] wdata,
 input wclk,
 input [ADDRSIZE-1:0] raddr,
 output [DATASIZE-1:0] rdata 
);

localparam DEPTH = 1<<ADDRSIZE;

reg [DATASIZE-1:0] MEM [DEPTH-1:0];

assign rdata = MEM[raddr];

always@(posedge wclk) begin
    if (wen) MEM[waddr] <= wdata;
end

endmodule
