`timescale 1ns / 1ps

module FIFO_Top #(parameter ADDRSIZE = 4,
                 parameter DATASIZE = 8)
(input wclk,
 input rclk,
 input wrst_n,
 input rrst_n,
 input winc,
 input rinc,
 input [DATASIZE-1:0] wdata,
 output [DATASIZE-1:0] rdata,
 output full,
 output empty);

wire wen;
wire [ADDRSIZE-1:0] raddr;
wire [ADDRSIZE-1:0] waddr;
wire [ADDRSIZE:0] rptr;
wire [ADDRSIZE:0] wptr;
wire [ADDRSIZE:0] rptr_sync;
wire [ADDRSIZE:0] wptr_sync;


assign wen = winc&!full;

Dual_Port_RAM #(ADDRSIZE,
DATASIZE) DUAL_PORT_RAM
(wen,
 waddr,
 wdata,
 wclk,
 raddr,
 rdata 
);

rptr #(ADDRSIZE) RPTR_EMPTY
(rinc,
 rclk,
 rrst_n,
 wptr_sync,
 empty,
 rptr,
 raddr
);

wptr #(ADDRSIZE) WPTR_FULL
(winc,
 wclk,
 wrst_n,
 rptr_sync,
 full,
 wptr,
 waddr
);

DFF_Synchronizer #(ADDRSIZE) rptr_synchronizer
(rptr,
 wclk,
 wrst_n,
 rptr_sync
 );
 
DFF_Synchronizer #(ADDRSIZE) wptr_synchronizer
(wptr,
 rclk,
 rrst_n,
 wptr_sync
 );

endmodule
