`timescale 1ns / 1ps

module rptr #(parameter ADDRSIZE = 4)
(input rinc,
 input rclk,
 input rrst_n,
 input [ADDRSIZE:0] wptr_sync,
 output reg empty,
 output reg [ADDRSIZE:0] rptr,
 output [ADDRSIZE-1:0] raddr
);

reg [ADDRSIZE:0] rbin;
wire [ADDRSIZE:0] rptrnext;
wire [ADDRSIZE:0] rbinnext;
wire empty_val;

assign raddr = rbin[ADDRSIZE-1:0];
assign rbinnext = rbin+(rinc&!empty);
assign rptrnext = (rbinnext>>1)^rbinnext;
assign empty_val = (rptr==wptr_sync);

always@(posedge rclk or negedge rrst_n) begin
    if(!rrst_n) begin
        rptr <=0;
        rbin <=0;
        empty <= 1'b1;
    end
    else begin
        rptr <=rptrnext;
        rbin <=rbinnext;
        empty <= empty_val;
    end
end

endmodule