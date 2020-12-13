`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2020 09:13:29 AM
// Design Name: 
// Module Name: mockup_driver
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


module mockup_driver(input clk, rst, output reg wave_select, start, stop, output reg [7:0] amplitude, output reg [15:0] frequency);

// localparam freq = 100000000 * 1;
localparam freq = 1000000;
reg [61:0] cnt;

assign wave_select = 1;

reg start_stop;
assign start = start_stop;
assign stop = ~start_stop;

assign amplitude = 8'hff;
assign frequency = 10000;

always @(posedge clk, posedge rst)
    if (rst)
        cnt <= 0;
    else if (cnt == freq)
        cnt <= 0;
    else
        cnt <= cnt + 1;
        
always @(posedge clk, posedge rst)
    if (rst)
        start_stop <= 0;
    else if (cnt == 0)
        start_stop <= 0;
    else if (cnt == freq/2)
        start_stop <= 1;

endmodule
