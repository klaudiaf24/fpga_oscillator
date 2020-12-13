`timescale 1ns / 1ps
////////////////////////////////////////////////////////

module master_axi_r (input clk, rst, // start, 
    output reg [3:0] wadr, output reg wadr_valid, input wadr_rdy, 
    output reg [31:0] wdata, output reg wdata_valid, input wdata_rdy,
    input [1:0] bresp, input bvalid, output reg brdy,
    output reg [3:0] radr, output reg radr_valid, input radr_rdy, 
    input [31:0] rdata, input rdata_valid, output reg rdata_rdy, input [1:0] rresp,
    output reg [7:0] received_data, output stb);

typedef enum {Read, WaitAD, ReadStatus, WaitStatus, Next} stateEnum; 
    
stateEnum st, nst;
//localparam cb = $clog2(nd);
//reg [cb-1:0] cnt;

//data valid in Rx FIFO
wire rx_fifo_vdat = ((st == WaitStatus) & rdata_valid)?rdata[0]:1'b0;  
        
//state register
always @(posedge clk, negedge rst)
    if(~rst)
        st <= ReadStatus;
    else
        st <= nst;
//next state logic
always @* begin
    nst = ReadStatus;
    case(st)
       ReadStatus: nst = WaitStatus;
       WaitStatus: nst = rdata_valid?(rx_fifo_vdat?Read:ReadStatus):WaitStatus;
       Read: nst = WaitAD;
       WaitAD: nst = rdata_valid?Next:WaitAD;
       Next: nst = ReadStatus;
    endcase
end
        
//output register with strobe
assign stb = (st == WaitAD & rdata_valid);
always @(posedge clk, negedge rst)
    if(~rst) 
        received_data <= 8'b0;
    else if(stb)
        received_data <= rdata;
        
//read from Rx FIFO or STATUS
always @(posedge clk, negedge rst)
    if(~rst) 
        radr <= 4'b0;       
    else if (st == Read) 
        radr <= 4'h0;   //take from Rx FIFO
    else if (st == ReadStatus) 
        radr <= 4'h8;   //take status register

//addres is stable
always @(posedge clk, negedge rst)
    if(~rst) 
        radr_valid <= 1'b0;
    else if (st == Read | st == ReadStatus) 
        radr_valid <= 1'b1;
    else if (radr_rdy) 
        radr_valid <= 1'b0;

//data received       
always @(posedge clk, negedge rst)
    if(~rst) 
        rdata_rdy <= 1'b0;
    else if ((st == WaitStatus | st == WaitAD) & rdata_valid) 
        rdata_rdy <= 1'b1;
    else 
        rdata_rdy <= 1'b0;

//reamaining outputs force to zero
always @(posedge clk) begin
    wadr <= 4'b0;
    wadr_valid <= 1'b0; 
    wdata <= 4'b0; 
    wdata_valid <= 1'b0;
    brdy <= 1'b0;
end                                     

endmodule

