`timescale 1ns / 1ps

module top #(parameter nd = 20) (input clk, rst, /* start ,*/ rx, 
    output tx,
    output d0, sync, sclk);

wire rstn = ~rst;

/*
wire [31:0] s_axi_wdata, s_axi_rdata;
wire [3:0] s_axi_awaddr, s_axi_araddr;
wire [1:0] s_axi_bresp; //, s_axi_rresp;
wire [3:0] s_axi_wstrb = 4'b1;
axi_uartlite_0 uart_ip (.s_axi_aclk(clk),        // input wire s_axi_aclk
  .s_axi_aresetn(rstn),  // input wire s_axi_aresetn
  .interrupt(interrupt),          // output wire interrupt
  .s_axi_awaddr(s_axi_awaddr),    // input wire [3 : 0] s_axi_awaddr
  .s_axi_awvalid(s_axi_awvalid),  // input wire s_axi_awvalid
  .s_axi_awready(s_axi_awready),  // output wire s_axi_awready
  .s_axi_wdata(s_axi_wdata),      // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb(s_axi_wstrb),      // input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid(s_axi_wvalid),    // input wire s_axi_wvalid
  .s_axi_wready(s_axi_wready),    // output wire s_axi_wready
  .s_axi_bresp(s_axi_bresp),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(s_axi_bvalid),    // output wire s_axi_bvalid
  .s_axi_bready(s_axi_bready),    // input wire s_axi_bready
  .s_axi_araddr(s_axi_araddr),    // input wire [3 : 0] s_axi_araddr
  .s_axi_arvalid(s_axi_arvalid),  // input wire s_axi_arvalid
  .s_axi_arready(s_axi_arready),  // output wire s_axi_arready
  .s_axi_rdata(s_axi_rdata),      // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp(),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid(s_axi_rvalid),    // output wire s_axi_rvalid
  .s_axi_rready(s_axi_rready),    // input wire s_axi_rready
  .rx(rx),                        // input wire rx
  .tx(tx)                        // output wire tx
);
*/
  
//wire [$clog2(nd)-1:0] addr;
//wire [7:0] received, transmit;
//master_axi_uart #(.nd(nd)) master (.clk(clk), .rst(rstp), .start(start), .rec_trn(led),
//    .awadr(s_axi_awaddr), .awvalid(s_axi_awvalid), .awrdy(s_axi_awready),
//    .wdata(s_axi_wdata), .wvalid(s_axi_wvalid), .wrdy(s_axi_wready),
//    .bdata(s_axi_bresp), .bvalid(s_axi_bvalid), .brdy(s_axi_bready),    //not needed
//    .aradr(s_axi_araddr), .arvalid(s_axi_arvalid), .arrdy(s_axi_arready),
//    .rdata(s_axi_rdata), .rvalid(s_axi_rvalid), .rrdy(s_axi_rready),
//    .received(received), .dcnt(addr), .wstb(wr),
//    .transmit(transmit), .rstb(rd));

//memory #(.deep(nd)) data_storage (.clk(clk), .wr(wr), .rd(rd), .adr(addr), .datin(received), .datout(transmit));

//assign leds = {led, {(7-$clog2(nd)){1'b0}}, addr};

wire [7:0] amplitude;
wire [15:0] frequency;

mockup_driver driver_inst(clk, rst, wave_select, start, stop, amplitude, frequency);
dac_generator #(16, 8) dac_generator_inst
    (clk, rst, wave_select, start, stop, amplitude, frequency,
     sync, d0, sclk // dac output 
);

endmodule
