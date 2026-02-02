`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Unica
// Engineer: Gianluca Leone
// 
// Create Date: 28.09.2022
// Design Name: folded
// Module Name: top
//
//////////////////////////////////////////////////////////////////////////////////

module top(
    input clk, rst,
    input en,
    input signed [7:0] x,    
    input signed [7:0] b0, b1, b2, b3, b4, b5, b6, b7,

	output ready,
	output valid,
    output signed [7:0] y
);
 
wire x_clr, y_clr, y_mult;

fsm control_unit(clk, rst, en, x_clr, y_clr, y_mult, valid, ready);
dp datapath(clk, x_clr, en, x, y_clr, y_mult, b0, b1, b2, b3, b4, b5, b6, b7, y);

endmodule

