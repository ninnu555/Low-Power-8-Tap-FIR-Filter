`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Unica
// Engineer: MAtteo Matta & Fabio Piras
// 
// Create Date: 28.09.2022
// Design Name: folded
// Module Name: top
//
//////////////////////////////////////////////////////////////////////////////////

module top(
    input clk, rst,
    input en,
    input [7:0] x,    

    output [7:0] y,
    output valid,
	output ready
);
 
wire x_clr, shift;
wire [1:0] ctrl;
wire y_en, y_clr;
    
dp datapath(clk, x_clr, shift, valid, ctrl, x, y_en, y_clr, y);
fsm control_unit(clk, rst, en, x_clr, shift, ctrl, y_en, y_clr, valid, ready);    

endmodule


