`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH
// Engineer: Patryk Chodur, Klaudia Fil
// 
// Create Date: 22.11.2020 20:45:50
// Design Name: 
// Module Name: wave_samples_memory
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

module uart_decoder(input clk, rst,
    output tx, input rx,
    output reg wave_select, start, stop, 
    output reg [7:0] amplitude, output reg [15:0] frequency);


wire rstn = ~rst;
wire [31:0] s_axi_wdata, s_axi_rdata;
wire [3:0] s_axi_awaddr, s_axi_araddr;
wire [1:0] s_axi_bresp, s_axi_rresp; //, s_axi_rresp;
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
  .s_axi_rresp(s_axi_rresp),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid(s_axi_rvalid),    // output wire s_axi_rvalid
  .s_axi_rready(s_axi_rready),    // input wire s_axi_rready
  .rx(rx),                        // input wire rx
  .tx(tx)                        // output wire tx
);

reg [7:0] read_data;

master_axi_r master_r (.clk(clk), .rst(rstn),
    .wadr(s_axi_awaddr), .wadr_valid(s_axi_awvalid), .wadr_rdy(s_axi_awready),
    .wdata(s_axi_wdata), .wdata_valid(s_axi_wvalid), .wdata_rdy(s_axi_wready),
    .bresp(s_axi_bresp), .bvalid(s_axi_bvalid), .brdy(s_axi_bready),    //not needed
    .radr(s_axi_araddr), .radr_valid(s_axi_arvalid), .radr_rdy(s_axi_arready),
    .rdata(s_axi_rdata), .rdata_valid(s_axi_rvalid), .rdata_rdy(s_axi_rready), .rresp(s_axi_rresp),
    .received_data(read_data), .stb(read_ready));



typedef enum {WaitWave, ReadWave, WaitAmplitude, ReadAmplitude, WaitFreq1, ReadFreq1, WaitFreq2, ReadFreq2, Command} states_en;
states_en st, nst;

always @* begin
    nst = WaitAmplitude;
    case(st)
    WaitWave:      nst = read_ready ? ReadWave : WaitWave;
    ReadWave:      nst = WaitAmplitude;
    WaitAmplitude: nst = read_ready ? ReadAmplitude : WaitAmplitude;
    ReadAmplitude: nst = WaitFreq1;
    WaitFreq1:     nst = read_ready ? ReadFreq1 : WaitFreq1;
    ReadFreq1:     nst = WaitFreq2;
    WaitFreq2:     nst = read_ready ? ReadFreq2 : WaitFreq2;
    ReadFreq2:     nst = Command;
    Command:       nst = WaitWave;
    
    endcase
end

always @(posedge clk, posedge rst)
    if (rst)
        st <= WaitWave;
    else
        st <= nst;
        
        
always @(posedge clk, posedge rst) begin
    if (rst) begin
        start <= 0;
        stop <= 1;
        amplitude <= 0;
        frequency <= 0;
    end else if (st == ReadWave)
        wave_select <= read_data[0];
    else if (st == ReadAmplitude)
        amplitude <= read_data; 
    else if (st == ReadFreq1)
        frequency[7:0] <= read_data;
    else if (st == ReadFreq2)
        frequency[15:8] <= read_data;
    else if (st == Command) begin
        if (amplitude == 0 & frequency == 0) begin
            start <= 0;
            stop <= 1;
        end else begin
            start <= 1;
            stop <= 0;
        end
    end   
end

//uart_rx #((10000000)/(9600)) receiver (.i_Clock(clk), .i_Rx_Serial(rx), .o_Rx_DV(read_ready), .o_Rx_Byte(read_data));



endmodule
