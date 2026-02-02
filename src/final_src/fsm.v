`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Unica
// Engineers: Fabio Piras & Matteo Matta
// 
// Create Date: <date>
// Design Name: folded
// Module Name: fsm
//
//////////////////////////////////////////////////////////////////////////////////


module fsm(
input clk, rst, en,
output reg y_mult,
output reg valid,
output reg ready
);

always @(posedge clk) begin
    ready <= ~rst;
    y_mult <= en;
    valid  <= y_mult;
end

endmodule










