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

module dac_generator#(parameter width = 16, depth = 8)
(input clk, rst, wave_select, input [7:0] amplitude, input [15:0] frequency);

reg [$clog2(width)-1:0] wave_iter;
reg [15:0] frequency_iter;

wire [depth-1:0] data_out;

always @(posedge clk, posedge rst)
    if (rst)
        frequency_iter <= 0;
    else if (frequency_iter == frequency)
        frequency_iter <= 0;
    else
        frequency_iter <= frequency_iter + 1;



always @(posedge clk, posedge rst)
    if (rst)
        wave_iter <= 0;
    else if (frequency_iter == frequency) begin
        if (wave_iter == width)
            wave_iter <= 0;
        else
            wave_iter <= wave_iter + 1;
    end

wave_samples_memory #(width, depth) mem_inst(clk, wave_select, wave_iter, data_out);

spidac #(depth) spidac_inst(clk, rst, en, data_out_tansposed);

endmodule;