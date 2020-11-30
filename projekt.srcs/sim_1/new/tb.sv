`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2020 10:14:47 AM
// Design Name: 
// Module Name: tb
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


module tb;

reg clk;
reg rst;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 0;
    #100 rst = 1;
    #100 rst = 0;
end

top top_inst(clk, rst, rx, tx, d0, sync, sclk);

endmodule
