`timescale 1ns / 1ps


module led_volume_disp(
    input clock20k,
    input clock10,
    input [11:0] mic_in,
    output reg [14:0] led_out

    );
    reg [9:0] count = 0;
    reg [14:0] max;
    always @ (posedge clock20k)
    begin
        count <= (count == 999) ? 0 : count + 1;
        if(count == 1)
            max = mic_in;
        else
            max = (mic_in > max) ? mic_in : max;
    end
        
    
    always @ (posedge clock10)
    begin
            if(max>3956)
                led_out <= 15'b111111111111111;
            else if (max>3816)
                led_out <= 15'b011111111111111;
            else if (max>3676)
                led_out <= 15'b001111111111111;
            else if (max>3536)
                led_out <= 15'b000111111111111;
            else if (max>3396)
                led_out <= 15'b000011111111111;
            else if (max> 3256)
                led_out <= 15'b000001111111111;
            else if (max > 3116)
                led_out <= 15'b000000111111111;
            else if (max > 2976)
                led_out <= 15'b000000011111111;
            else if (max > 2836)
                led_out <= 15'b000000001111111;
            else if (max > 2696)
                led_out <= 15'b000000000111111;
            else if (max > 2556)
                led_out <= 15'b000000000011111;
            else if (max > 2416)
                led_out <= 15'b000000000001111;
            else if (max > 2276)
                led_out <= 15'b000000000000111;
            else if (max > 2136)
                led_out <= 15'b000000000000011; 
            else if (max > 1996)
                led_out <= 15'b000000000000001;             
            else 
                led_out <= 0;
       end
endmodule
