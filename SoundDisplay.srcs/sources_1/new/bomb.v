`timescale 1ns / 1ps


module bomb(
    input clock, //use a 10hz clock
    input [12:0] number, // connect to RNG
    input bombed, // connect from scoreboard
    output reg bomb = 0 // connect to pause also
);

    reg [10:0] count = 0;
    always @ (posedge clock, posedge bombed)
    begin
    if(bomb || count != 0)
        count = (count == 4)? 0 : count+1;
    if(number < 250 && count == 0 && !bombed )
        bomb <= 1;
    else if (count == 4 || bombed == 1)
        bomb <= 0;
    end

    endmodule