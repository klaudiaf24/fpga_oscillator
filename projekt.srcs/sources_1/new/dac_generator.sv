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
    (input clk, rst, wave_select, start, stop, input unsigned [7:0] amplitude, input [15:0] frequency,
     output sync, d0, sclk // dac output 
);

reg [$clog2(width)-1:0] wave_iter;
reg [15:0] frequency_iter;


wire [depth-1:0] mem_data_in;
// amplitude = max => spidac_data_out = mem_data_in
// amplitude = 0 => spidac_data_out = 0 signed
reg [depth-1:0] spidac_data_out;
reg en;

localparam ctr_word = 8'b0;

typedef enum {Idle, LoadFromMem, PrepareDataOut, SendToDac, WaitSent, Sent, WaitPlay, Played} states_en; // WaitPlay plays 1 sample
states_en st, nst;

// counts to frequency and increments wave iter
always @(posedge clk, posedge rst)
    if (rst)
        frequency_iter <= 0;
    else if (st == WaitSent)
        frequency_iter <= 0;
    else if (st == WaitPlay)
        frequency_iter <= frequency_iter + 1;

// this one goes through the wave in memory (16 samples repeated)
always @(posedge clk, posedge rst)
    if (rst)
        wave_iter <= 0;
    else if (st == Idle)
        wave_iter <= 0;
    else if (st == Played) begin
        if (wave_iter < width - 1)
            wave_iter <= wave_iter + 1;
        else
            wave_iter <= 0;
    end

typedef reg signed [15:0] int16_t;
typedef reg unsigned [15:0] uint16_t; 
typedef reg signed [8:0] int8_t;

always @(posedge clk, posedge rst)
    if (rst)
        spidac_data_out <= 0;
    else if (st == LoadFromMem)
        spidac_data_out <= 0;
    else if (st == PrepareDataOut)
        spidac_data_out <= mem_data_in + 8'b10000000; // int8_t'(int16_t'(mem_data_in) * int16_t'(amplitude) / int16_t'{8{1'b1}});
        
always @(posedge clk, posedge rst)
    if (rst)
        en <= 0;
    else if (st == Idle)
        en <= 0;
    else if (st == SendToDac)
        en <= 1;
    else if (st == Sent)
        en <= 0;

always @* begin
    nst = Idle;
    case (st)
    Idle: nst = start ? LoadFromMem : Idle;
    LoadFromMem: nst = PrepareDataOut;
    PrepareDataOut: nst = SendToDac;
    SendToDac: nst = WaitSent;
    WaitSent: nst = fin ? Sent : WaitSent;
    Sent: nst = WaitPlay;
    WaitPlay: nst = frequency_iter == frequency ? Played : WaitPlay;
    Played: nst = stop ? Idle : LoadFromMem;
    endcase
end

always @(posedge clk, posedge rst)
    if (rst)
        st <= Idle;
    else
        st <= nst;

wave_samples_memory #(width, depth) mem_inst(clk, wave_select, wave_iter, mem_data_in);

spidac #(depth + 8) spidac_inst(clk, rst, en, {ctr_word,spidac_data_out}, sync, d0, fin, sclk);

endmodule