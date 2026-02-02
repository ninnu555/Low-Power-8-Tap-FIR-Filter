`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Unica
// Engineer: Fabio Piras & Matteo Matta
// 
// Create Date: 28.09.2022
// Design Name: folded
// Module Name: dp
//
//////////////////////////////////////////////////////////////////////////////////

module dp(
input clk, x_clr,
input en,
input signed [7:0] x,
input y_clr, y_mult,
input signed [7:0] b0, b1, b2, b3, b4, b5, b6, b7,

output reg signed [7:0] y
);
    
reg signed [7:0] x_shift [7:0];

// shifter
integer i;
always @(posedge clk)
    //if(x_clr) begin
    //    for(i=0;i<8;i=i+1)    
    //        x_shift[i] <= 0;
	//	end
    // else 
if(en) 
          begin
            x_shift[0] <= x;
            for(i=1;i<8;i=i+1) begin
                x_shift[i] <= x_shift[i-1];
			end
          end


reg signed [15:0] mul_0_out;
reg signed [15:0] mul_1_out;
reg signed [15:0] mul_2_out;
reg signed [15:0] mul_3_out;
reg signed [15:0] mul_4_out;
reg signed [15:0] mul_5_out;
reg signed [15:0] mul_6_out;
reg signed [15:0] mul_7_out;

always @(posedge clk) 
    if (y_mult) begin
        mul_0_out <= x_shift[0]*b0;
        mul_1_out <= x_shift[1]*b1;
        mul_2_out <= x_shift[2]*b2;
        mul_3_out <= x_shift[3]*b3;
        mul_4_out <= x_shift[4]*b4;
        mul_5_out <= x_shift[5]*b5;
        mul_6_out <= x_shift[6]*b6;
        mul_7_out <= x_shift[7]*b7;
    end
    // else begin
    //     mul_0_out <= mul_0_out;
    //     mul_1_out <= mul_1_out;
    //     mul_2_out <= mul_2_out;
    //     mul_3_out <= mul_3_out;
    //     mul_4_out <= mul_4_out;
    //     mul_5_out <= mul_5_out;
    //     mul_6_out <= mul_6_out;
    //     mul_7_out <= mul_7_out;
    // end

wire signed [7:0] mul_0_out_floor;
wire signed [7:0] mul_1_out_floor;
wire signed [7:0] mul_2_out_floor;
wire signed [7:0] mul_3_out_floor;
wire signed [7:0] mul_4_out_floor;
wire signed [7:0] mul_5_out_floor;
wire signed [7:0] mul_6_out_floor;
wire signed [7:0] mul_7_out_floor;

assign mul_0_out_floor = mul_0_out[14:7];
assign mul_1_out_floor = mul_1_out[14:7];
assign mul_2_out_floor = mul_2_out[14:7];
assign mul_3_out_floor = mul_3_out[14:7];
assign mul_4_out_floor = mul_4_out[14:7];
assign mul_5_out_floor = mul_5_out[14:7];
assign mul_6_out_floor = mul_6_out[14:7];
assign mul_7_out_floor = mul_7_out[14:7];

// accumulator
always @(*)
    // if(y_clr) 
    //     begin
    //         y <= 0;
    //     end
    // else 
        // begin
            //if(y_mult) 
                begin 
                    y <= mul_0_out_floor + mul_1_out_floor + mul_2_out_floor + mul_3_out_floor + mul_4_out_floor + mul_5_out_floor + mul_6_out_floor + mul_7_out_floor;
                end
            // else y = 0;
       // end
        
endmodule
