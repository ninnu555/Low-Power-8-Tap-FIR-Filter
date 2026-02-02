`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Matteo Matta & Fabio Piras
// 
// Create Date: 28.09.2022
// Design Name: folded
// Module Name: dp
//
//////////////////////////////////////////////////////////////////////////////////

module dp(
input clk, x_clr,
input shift, valid,
input [1:0] ctrl_1, 
input signed [7:0] x,
input y_en, y_clr,
output reg signed [7:0] y
);
    
reg [7:0] x_shift [7:0];
parameter [7:0] b0 = 2;
parameter [7:0] b1 = 8;
parameter [7:0] b2 = 21;
parameter [7:0] b3 = 31;
parameter [7:0] b4 = 31;
parameter [7:0] b5 = 21;
parameter [7:0] b6 = 8;
parameter [7:0] b7 = 2;

// shifter
integer i;
always @(posedge clk)
    if(x_clr)
        for(i=0;i<8;i=i+1)    
            x_shift[i] <= 0;
    else if(shift) 
          begin
            x_shift[0] <= x;
            for(i=1;i<8;i=i+1)
                x_shift[i] <= x_shift[i-1];
          end

// MUX x_1        
reg signed [7:0] mux_x_1_out; 
always @(*)
   case(ctrl_1) 
        0: mux_x_1_out = x_shift[1]; 
        1: mux_x_1_out = x_shift[3];
        2: mux_x_1_out = x_shift[5];
        3: mux_x_1_out = x_shift[7]; 
        default: mux_x_1_out = x_shift[1];
   endcase

// MUX b_1        
reg signed [7:0] mux_b_1_out; 
always @(*)
   case(ctrl_1) 
        0: mux_b_1_out = b1;
        1: mux_b_1_out = b3;
        2: mux_b_1_out = b5;
        3: mux_b_1_out = b7;
        default: mux_b_1_out = b1;
   endcase

// MUX x_2        
reg signed [7:0] mux_x_2_out; 
always @(*)
   case(ctrl_1) 
        0: mux_x_2_out = x_shift[0];
        1: mux_x_2_out = x_shift[2];
        2: mux_x_2_out = x_shift[4];
        3: mux_x_2_out = x_shift[6];
        default: mux_x_2_out = x_shift[0];
   endcase

// MUX b_2        
reg signed [7:0] mux_b_2_out; 
always @(*)
   case(ctrl_1)             // to be handled with the FSM
        0: mux_b_2_out = b0; 
        1: mux_b_2_out = b2;
        2: mux_b_2_out = b4;
        3: mux_b_2_out = b6; 
        default: mux_b_2_out = b0;
   endcase

// multiplier 1
wire signed [15:0] mul_1_out;
assign mul_1_out = mux_x_1_out*mux_b_1_out;
wire signed [7:0] mul_1_out_floor;
assign mul_1_out_floor = mul_1_out[14:7];

// multiplier 2
wire signed [15:0] mul_2_out;
assign mul_2_out = mux_x_2_out*mux_b_2_out;
wire signed [7:0] mul_2_out_floor;
assign mul_2_out_floor = mul_2_out[14:7];

reg signed [7:0] z;     

always @(posedge clk) begin
    if (y_clr)
        // iniziation
        z <= mul_1_out_floor + mul_2_out_floor;
    else if (y_en)
        // MAC ops
        z <= z + mul_1_out_floor + mul_2_out_floor;
end

always @(*) begin
    // updating y 
    if (valid)
    // y takes z == MAC3 and adds it to mul1+mul2 == MAC4 
        y = z + mul_1_out_floor + mul_2_out_floor;
    else
        y = 0;
end

endmodule
