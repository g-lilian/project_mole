`timescale 1ns / 1ps

module clock20k(
    input CLOCK,
    output reg SLOW_CLOCK=0
    );
    
    reg[11:0] count = 0;
    always @ (posedge CLOCK) 
        begin
            count <= (count == 2499) ? 0 : count+1;
            SLOW_CLOCK <= (count == 0) ? ~SLOW_CLOCK : SLOW_CLOCK;
        end 
endmodule
