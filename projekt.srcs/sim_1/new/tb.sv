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

/*
initial begin
    rst = 0;
    #100 rst = 1;
    #100 rst = 0;
end
*/
reg [7:0] val;
reg str;

task play(input byte wave_select, input byte amplitude, input shortint frequency);
    str <= 0;
    
    val <= wave_select;
    str <= 1;
    wait(fin);
    str <= 0;
    
    #20 val <= amplitude;
    str <= 1;
    wait(fin);
    str <= 0;

    #20 val <= frequency[7:0];
    str <= 1;
    wait(fin);
    str <= 0;

    #20 val <= frequency[15:8];
    str <= 1;
    wait(fin);
    str <= 0;
endtask

task stop();
    play(0, 0, 0);
endtask

reg [3:0] cnt;

initial begin
    cnt = 15;
    rst = 0;
    #5 rst = 1;
    #100 rst = 0;
    #100
    play(0, 100, 1000);
    #10_000_000
    stop();
    #10_000_000
    play(0, 255, 1000);
    
end


top top_inst(clk, rst, rx, tx, d0, sync, sclk);
simple_transmitter #(.baudrate(9600)) trst(clk, ~rst, str, val, rx, fin);

    
reg [7:0] tmp_values;
reg [7:0] values;
always @(negedge sclk) begin
    if (cnt < 8)
        tmp_values[cnt] = d0;
    cnt = cnt - 1;    
end

always @(posedge sync)
    values = tmp_values;

endmodule
