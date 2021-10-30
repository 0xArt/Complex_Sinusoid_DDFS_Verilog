`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     www.circuitden.com
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
//
// Create Date: 10/29/2021 08:02:00 PM
// Design Name: 
// Module Name: complex_sinusoid_ddfs
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   e^(jwt) = cos(wt) + jsin(wt)
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//          
//
//////////////////////////////////////////////////////////////////////////////////


module complex_sinusoid_ddfs#(parameter ROM_DEPTH = 32768, ROM_WIDTH = 16)
(
        input wire                           i_clk,
        input wire                           i_rst,
        input wire        [31:0]             i_freq_control, //freq will  increase as i_freq_control increases
        output reg signed [ROM_WIDTH-1:0]    o_real = 0,
        output reg signed [ROM_WIDTH-1:0]    o_imag = 0
);


    reg signed [ROM_WIDTH-1:0] rom_memory [ROM_DEPTH-1:0];
    initial begin
        $readmemh("16x32768_sine_lut_quarter.mem", rom_memory);
    end
    
    reg  [31:0] accumulator = 0;
    
    //rom depth is 32768 so our lut_index must be 15 bits wide (2^15 = 32768)
    wire [14:0] lut_index_sin;
    wire [14:0] lut_index_cos;
    //we reserve 2 more bits with index to represent each quadrant of sine wave
    wire [16:0] index;
    wire [ROM_WIDTH-1:0] sin_out;
    wire [ROM_WIDTH-1:0] cos_out;
    wire [1:0] sin_quadrant;
    wire [1:0] cos_quadrant;
    wire [1:0] invert;
    wire [1:0] reverse;
    
    assign sin_quadrant = index[16:15];
    assign cos_quadrant = sin_quadrant + 1'b1;
    //upper 17 bits of accumulator are used indexing
    assign index = accumulator[31:15];
    //if index[15] is set we want to read backwards
    assign lut_index_sin = (sin_quadrant[0]) ? ((ROM_DEPTH-1) - index[14:0]) : index[14:0];
    assign lut_index_cos = (cos_quadrant[0]) ? ((ROM_DEPTH-1) - index[14:0]) : index[14:0];
    //if index[16] is set we want to negate the result
    assign sin_out  =  (sin_quadrant[1]) ? -rom_memory[lut_index_sin] : rom_memory[lut_index_sin];
    assign cos_out  =  (cos_quadrant[1]) ? -rom_memory[lut_index_cos] : rom_memory[lut_index_cos];
    
    //phase accumulator
    always@(posedge i_clk) begin
        if(i_rst)begin
            o_real <= 0;
            o_imag <= 0;
            accumulator <= 0;
        end         
        else begin
            //accumulate
            accumulator <= accumulator + i_freq_control;
            //reg output in order to decrease prop delay if more modules are used downstream
            o_real <= cos_out;
            o_imag <= sin_out;
        end
    end



endmodule

