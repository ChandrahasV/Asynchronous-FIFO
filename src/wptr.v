`timescale 1ns / 1ps

module wptr #(parameter ADDRSIZE = 4)
(input winc,
 input wclk,
 input wrst_n,
 input [ADDRSIZE:0] rptr_sync,
 output reg full,
 output reg [ADDRSIZE:0] wptr,
 output [ADDRSIZE-1:0] waddr
);

reg [ADDRSIZE:0] wbin;
wire [ADDRSIZE:0] wptrnext;
wire [ADDRSIZE:0] wbinnext;
wire full_val;

assign waddr = wbin[ADDRSIZE-1:0];
assign wbinnext = wbin+(winc&!full);
assign wptrnext = (wbinnext>>1)^wbinnext;
assign full_val = (rptr_sync == {~wptrnext[ADDRSIZE:ADDRSIZE-1],wptrnext[ADDRSIZE-2:0]});

always@(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) begin
        wptr <=0;
        wbin <=0;
        full <= 1'b0;
    end
    else begin
        wptr <=wptrnext;
        wbin <=wbinnext;
        full <= full_val;
    end
end

endmodule
