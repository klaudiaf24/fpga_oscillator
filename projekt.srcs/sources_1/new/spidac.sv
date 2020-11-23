`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2020 10:29:08 AM
// Design Name: 
// Module Name: spidac
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

module spidac #(parameter nb=8)
        (input clk, rst, en, input [nb-1:0] data2trans,
        output cs, mosi, fin, slck);
        
typedef enum { idle, send, hold1, done } states;
states st, nst;
localparam bdcnt= $clog2(nb);
reg [2:0] cnt;
reg [nb-1:0] shreg;
reg t;
reg [bdcnt:0] dcnt;
//reg tmp;

 

always @(posedge clk, posedge rst)
    if(rst)
        st <= idle;
    else 
        st <= nst;

 

always @* begin
    nst = idle;
    case(st)
        idle: nst = en ? send : idle;
        send: nst = last_bit ? hold1 : send;
        hold1: nst = done;
        done: nst = en ? done : idle;
    endcase
end

 

always @(posedge clk, posedge rst)
    if(rst)
        cnt <= 2'b0;
    else if (st == send)
        cnt = cnt + 1;
assign slck = cnt[1];

 

always@(posedge clk, posedge rst)
    if(rst)
        t <= 1'b0;
    else 
        t <= slck;

 

assign sh = t & !slck;

 

always @(posedge clk, posedge rst)
    if(rst)
        dcnt <= 2'b0;
    else if (st == send && sh)
        dcnt <= dcnt + 1;
    else if (st == idle)
        dcnt <= {bdcnt{1'b0}};
        
assign last_bit = (dcnt == nb);

 

always@(posedge clk, posedge rst)
    if(rst)
        shreg <= {bdcnt{1'b0}};
    else if(st == idle && en)
        shreg <= data2trans;
        else if(st == send && sh)
            shreg <= {shreg[nb-2:0], 1'b0};
assign mosi = shreg[nb-1];
assign fin = (st == done);

 

assign cs = (st == idle && ~en);
endmodule
