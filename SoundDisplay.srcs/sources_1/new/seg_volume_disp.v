`timescale 1ns / 1ps


module seg_volume_disp(
    input clock20k,
    input clock240,
    input [11:0] mic_in,
    output reg [3:0] an,
    output reg [7:0] seg
    );
    
    //to find max
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
    
    //anode control
    reg [2:0] an_counter=0;
    always @(posedge clock240)
    begin
    begin
    an_counter <= (an_counter == 3) ? 0 : an_counter + 1;
    end
    begin
        case (an_counter)
            0 : an <= 4'b0111;
            1 : an <= 4'b1011;
            2 : an <= 4'b1101;
            3 : an <= 4'b1110;
        endcase
    end
    end
    
    //cathode control
    always @ (posedge clock240)
    begin
    if(max>3956)
        case(an_counter) //15
            0 : seg = 8'b11000000;
            1 : seg = 8'b11000000;
            2 : seg = 8'b11111001;
            3 : seg = 8'b10010010;
        endcase
    else if (max>3816)
        case(an_counter)//14
            0 : seg = 8'b11000000;
            1 : seg = 8'b11000000;
            2 : seg = 8'b11111001;
            3 : seg = 8'b10010110;
        endcase
    else if (max>3676)
        case(an_counter)//13
                0 : seg = 8'b11000000;
                1 : seg = 8'b11000000;
                2 : seg = 8'b11111001;
                3 : seg = 8'b10110000;
        endcase
    else if (max>3536)
        case(an_counter)//12
                0 : seg = 8'b11000000;
                1 : seg = 8'b11000000;
                2 : seg = 8'b11111001;
                3 : seg = 8'b10100100;
        endcase
    else if (max>3396)
        case(an_counter)//11
                    0 : seg = 8'b11000000;
                    1 : seg = 8'b11000000;
                    2 : seg = 8'b11111001;
                    3 : seg = 8'b11111001;
            endcase
    else if (max> 3256)
        case(an_counter)//10
                    0 : seg = 8'b11000000;
                    1 : seg = 8'b11000000;
                    2 : seg = 8'b11111001;
                    3 : seg = 8'b11000000;
            endcase
    else if (max > 3116)
        case(an_counter)//9
                    0 : seg = 8'b11000000;
                    1 : seg = 8'b11000000;
                    2 : seg = 8'b11000000;
                    3 : seg = 8'b10010000;
            endcase
    else if (max > 2976)
        case(an_counter)//8
                        0 : seg = 8'b11000000;
                        1 : seg = 8'b11000000;
                        2 : seg = 8'b11000000;
                        3 : seg = 8'b10000000;
                endcase
    else if (max > 2836)
        case(an_counter)//7
                        0 : seg = 8'b11000000;
                        1 : seg = 8'b11000000;
                        2 : seg = 8'b11000000;
                        3 : seg = 8'b11111000;
                endcase
    else if (max > 2696)
        case(an_counter)//6
                    0 : seg = 8'b11000000;
                    1 : seg = 8'b11000000;
                    2 : seg = 8'b11000000;
                    3 : seg = 8'b10000010;
            endcase    
    else if (max > 2556)
            case(an_counter)//5
                0 : seg = 8'b11000000;
                1 : seg = 8'b11000000;
                2 : seg = 8'b11000000;
                3 : seg = 8'b10010010;
        endcase
    else if (max > 2416)
                case(an_counter)//4
                0 : seg = 8'b11000000;
                1 : seg = 8'b11000000;
                2 : seg = 8'b11000000;
                3 : seg = 8'b10011001;
        endcase
    else if (max > 2276)
                case(an_counter)//3
                0 : seg = 8'b11000000;
                1 : seg = 8'b11000000;
                2 : seg = 8'b11000000;
                3 : seg = 8'b10110000;
        endcase
    else if (max > 2136)
                case(an_counter)//2
                0 : seg = 8'b11000000;
                1 : seg = 8'b11000000;
                2 : seg = 8'b11000000;
                3 : seg = 8'b10100100;
        endcase
    else if (max > 1996)
                          case(an_counter)//1
    0 : seg = 8'b11000000;
    1 : seg = 8'b11000000;
    2 : seg = 8'b11000000;
    3 : seg = 8'b11111001;
endcase         
    else 
        seg = 8'b11000000;
        end
    
endmodule
