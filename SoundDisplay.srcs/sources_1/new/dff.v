`timescale 1ns / 1ps

//dff to model a d flip_flop
module sound_dff(
    input clock20k,
    input clock10, //10hz
    input [11:0] d,
    output reg q = 0
    );
    
    reg [9:0] count = 0;
        reg [14:0] max;
        always @ (posedge clock20k)
        begin
            count <= (count == 499) ? 0 : count + 1;
            if(count == 1)
                max = d;
            else
                max = (d > max) ? d : max;
        end
    
    
    always @ (posedge clock10)
    begin 
        q <= (max > 2500) ? 1 : 0; //d considered 1 when d > 3000
    end
endmodule
