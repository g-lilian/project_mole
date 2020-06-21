`timescale 1ns / 1ps

module whack_sp(
    input clock20k, // pls connect 20kHZ clock
input clock10, //10Hz clock
input [11:0] mic_in,
output reg sp_whack = 0
);

wire dff_one_out, dff_two_out;
sound_dff(clock20k,clock10, mic_in, dff_one_out);
one_dff(clock10, dff_one_out, dff_two_out);
    reg [10:0] count = 0;
always @ (posedge clock20k)
    begin
    if(sp_whack || count != 0)
    count <= (count == 1000) ? 0 : count + 1;
    end
    
always @ (posedge clock20k)
    begin
    if(dff_one_out & !dff_two_out && count < 199)
        sp_whack = 1;
    else
        sp_whack = 0;
    end
endmodule

