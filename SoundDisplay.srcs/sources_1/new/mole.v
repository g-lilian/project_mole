`timescale 1ns / 1ps

module mole(
    input clock, //use a 10hz clock
    input [12:0] number, // connect to RNG
    input dead_mole, // connect from scoreboard
    output reg mole = 0 // connect to pause also
    );
    
    reg [10:0] count = 0;
    always @ (posedge clock, posedge dead_mole)
    begin
        if(mole || count != 0)
            count <= (count == 6)? 0 : count+1;   
        if(number > 7500 && count == 0 && dead_mole == 0)
            mole <= 1;
         else if (count == 6 || dead_mole == 1)
            mole <= 0; 
                   
    end
    
endmodule
