`timescale 1ns / 1ps

module difficulty_selector(
    input sp_clock,
    input left,
    input right,
    input clock0,
    input clock1,
    input clock2,
    output reg [2:0] led = 3'b010,
    output reg clock_out
    );
    always @ (posedge sp_clock)
    begin
        case (led)
            3'b010: clock_out = clock1;
            3'b100: clock_out = clock2;
            3'b001: clock_out = clock0;
        endcase
    end
    always @ (posedge sp_clock)
    begin
        if(left && led != 3'b100)    
            begin        
            led <= led << 1; 
            end          
        else if (right && led != 3'b001)       
            begin     
            led <= led >> 1;
            end
    end
    
    
endmodule
