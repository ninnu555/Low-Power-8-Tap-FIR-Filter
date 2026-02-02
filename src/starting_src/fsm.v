`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Unica
// Engineer: Matteo Matta & Fabio Piras
// 
// Create Date: <date>
// Design Name: folded
// Module Name: fsm
//
//////////////////////////////////////////////////////////////////////////////////


module fsm(
input clk, rst, en,
output reg x_clr,
output reg shift,
output reg [1:0] ctrl,
output reg y_en, y_clr,
output reg valid,
output reg ready
);
    
reg [1:0] state;
reg [1:0] counter;
parameter [1:0] IDLE = 0, READY = 1, MAC = 2, MAC1 = 3;

always @(posedge clk, posedge rst) 
    begin
        if (rst) 
            begin
                state <= IDLE;
            end
        else
            case(state)
                IDLE: 
                    begin
                        state <= READY;
                    end
                READY:
                    begin 
                        if(en)
                            begin
                                state <= MAC;
                                counter <= 1;
                            end
                        else    
                            begin
                                counter <= 0;
                                state <= READY; //to reduce the number of latchs and so of hardware (to be checked)
                            end
                    end
                MAC:
                    begin
                        counter <= counter + 1;
                        if (counter < 3) begin
                            state   <= MAC;
                        end
                        else begin
                            // if counter == 3
                            if(en) 
                                state <= MAC1;
                            else   
                                state <= READY;
                        end
                    end
                MAC1:
                    begin
                        state   <= MAC;
                        counter <= counter + 1;
                    end
                default: ;
            endcase
    end

always @(*)
    begin
        x_clr   = 0;
        shift   = 0;
        ctrl    = 0;
        y_en    = 0;
        y_clr   = 0;
        valid   = 0;
        ready   = 0;
        case(state)
            IDLE: begin
                x_clr = 1;
            end
            READY: 
                begin
                    y_clr = en;
                    ready = 1;
                    shift = en;     // given the behaviour, we can discard this and charge the ready to do the shift, 
									// used for solving race condition in MAC state
                    ctrl  = 0;
                end
            MAC:
                begin
                    y_en    = 1;
                    ctrl  = counter[1:0];
                    if(counter == 3) begin
                        valid = 1; // valid when doing the last addition
                        ready = 1; // ready when finishing the MAC operation
                        shift = en; // shift only if en is high
                    end 
                        
                end
            MAC1:
                begin
                    ctrl = 0;
                    y_clr = 1; // clear y only if en is high
                    // valid  = 1; // valid when doing the last addition
                end
            default: ;
        endcase
    end

endmodule
