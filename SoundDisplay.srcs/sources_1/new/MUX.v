`timescale 1ns / 1ps

module MUX(
    input sw,
    input [11:0] mic_in,
    input [3:0] an_in,
    input [7:0] seg_in,
    input [14:0] led_in,
    output [3:0] an_out,
    output [7:0] seg_out,
    output [14:0] led_out
    );
    assign an_out = (sw == 0) ? an_in : 3'b111;
    assign seg_out = (sw == 0) ? seg_in : 8'b11111111;
    assign led_out = (sw == 0) ? led_in : mic_in;
endmodule
