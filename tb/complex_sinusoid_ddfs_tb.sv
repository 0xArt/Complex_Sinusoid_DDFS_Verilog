`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     www.circuitden.com
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
//
// Create Date: 10/30/2021 08:05:13 AM
// Design Name: 
// Module Name: complex_sinusoid_ddfs_tb
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


module complex_sinusoid_ddfs_tb(

    );
    
    reg clk = 0;
    reg rst = 0;    
    reg [31:0] freq_control_a = 32'h000FFFFF;
    reg [31:0] freq_control_b = 32'h0000FFFF;

    wire signed [15:0] real_signal_a;
    wire signed [15:0] imag_signal_a;


    wire signed [15:0] real_signal_b;
    wire signed [15:0] imag_signal_b;

    //clock gen
    always begin
        #10
        clk = ~clk;
    end
    
    integer i;

    
    initial begin
    
        rst = 1;
        @(posedge clk);
        @(posedge clk);
        rst = 0;
        @(posedge clk);
        
        //sweep up in frequency
        for(i=32'h000FFFFF; i<32'hFFFFFFFF; i=i+32'h00100000)begin
            //phase_step = i;
            repeat (500)begin
                @(posedge clk);
            end 
        end
        $stop;

    end
    
    

    complex_sinusoid_ddfs complex_sinusoid_ddfs_a_inst(
         .i_clk(clk)
        ,.i_rst(rst)
        ,.i_freq_control(freq_control_a)
        ,.o_real(real_signal_a)
        ,.o_imag(imag_signal_a)
    );
    
    
    complex_sinusoid_ddfs complex_sinusoid_ddfs_b_inst(
         .i_clk(clk)
        ,.i_rst(rst)
        ,.i_freq_control(freq_control_b)
        ,.o_real(real_signal_b)
        ,.o_imag(imag_signal_b)
    );
    
    

    
    
    /*
     Amplitude Modulation
    */
    wire signed [31:0] am_signal;
    complex_multiplier complex_multiplier_am_mod_inst(
         .i_clk(clk)
        ,.i_rst(rst)
        ,.i_real_h(real_signal_a)
        ,.i_imag_h(0)
        ,.i_real_y(imag_signal_b)
        ,.i_imag_y(0)
        ,.o_real(am_signal)
        ,.o_imag()
    );
    
    /*
        heterodyne Signal
    */
    wire signed [31:0] heterodyne_real;
    wire signed [31:0] heterodyne_imag;
    complex_multiplier complex_multiplier_hetrodyne_inst(
         .i_clk(clk)
        ,.i_rst(rst)
        ,.i_real_h(real_signal_a)
        ,.i_imag_h(imag_signal_a)
        ,.i_real_y(real_signal_b)
        ,.i_imag_y(imag_signal_b)
        ,.o_real(heterodyne_real)
        ,.o_imag(heterodyne_imag)
    );
    
    


    
endmodule
