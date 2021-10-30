`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     www.circuitden.com
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
//
// Create Date: 10/30/2021 08:27:05 AM
// Design Name: 
// Module Name: complex_multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// piplined 2 input 1 output complex digital multiplier
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module complex_multiplier#(parameter INPUT_DATA_WIDTH = 16)
    (
        input  wire                                    i_clk,
        input  wire                                    i_rst,
        input  wire signed [INPUT_DATA_WIDTH-1:0]      i_real_h,
        input  wire signed [INPUT_DATA_WIDTH-1:0]      i_imag_h,
        input  wire signed [INPUT_DATA_WIDTH-1:0]      i_real_y,
        input  wire signed [INPUT_DATA_WIDTH-1:0]      i_imag_y,
        output reg  signed [INPUT_DATA_WIDTH*2:0]      o_real = 0,
        output reg  signed [INPUT_DATA_WIDTH*2:0]      o_imag = 0
    );
    
    
    /*
      h     y
    (a+bj)(c+dj) = ac + adj + cbj - bd
    */
    reg signed [INPUT_DATA_WIDTH*2-1:0] ac = 0;
    reg signed [INPUT_DATA_WIDTH*2-1:0] ad = 0;
    reg signed [INPUT_DATA_WIDTH*2-1:0] cb = 0;
    reg signed [INPUT_DATA_WIDTH*2-1:0] bd = 0;


    always@(posedge i_clk) begin
        if(i_rst)begin
            o_real <= 0;
            o_imag <= 0;
            ac     <= 0;
            ad     <= 0;
            cb     <= 0;
            bd     <= 0;
        end         
        else begin
            ac <= i_real_h * i_real_y;
            ad <= i_real_h * i_imag_y;
            cb <= i_real_y * i_imag_h;
            bd <= i_imag_h * i_imag_y;
            o_real <= ac - bd;
            o_imag <= ad + cb;
        end
    end

endmodule
