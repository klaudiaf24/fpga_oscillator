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


module wave_samples_memory#(parameter width = 16, depth = 8)
    (input clk, wave_select, input [$clog2(width)-1:0] addr, output reg signed [depth-1:0] data_out);

(*ram_style = "block"*) reg [depth-1:0] sin_wave [width:0];
(*ram_style = "block"*) reg [depth-1:0] triangle_wave [width:0];

initial $readmemh("init_val_sin.mem", sin_wave);
initial $readmemh("init_val_triangle.mem", triangle_wave);

always @(posedge clk)
    if (wave_select)
        data_out <= sin_wave[addr];
    else
        data_out <= triangle_wave[addr];

endmodule
