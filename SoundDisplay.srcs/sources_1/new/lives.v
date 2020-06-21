`timescale 1ns / 1ps

module lives(
    input CLK_UPDATE,
    input WHACK,
    input BOMB,
    input RESET,
    
    output reg [4:0] led = 5'b11111, // start with 5 lives
    output reg LOSE = 0,
    output reg bombed = 0
    );
    
    // TAKE LIVES
    reg [2:0] lives = 5;
    reg [15:0] timer = 0;
    always @ (posedge CLK_UPDATE)
    begin
        if(RESET)
        begin
            lives <= 5;
            LOSE <= 0;
        end
        if(lives == 0)
            LOSE <= 1; 
        if(bombed || timer != 0)
            timer = (timer == 7999) ? 0 :timer + 1;
        if(timer == 0 && WHACK && BOMB && !LOSE)
            begin
            lives <= lives - 1;
            bombed <= 1;   
            end
         else if( timer ==7999)
            bombed <= 0;
     end
    
    // RESET LIVES
//    always @ (posedge RESET) begin
//        lives = 5;
//    end
    
    // DISPLAY LIVES AS LED
    always @ (posedge CLK_UPDATE) begin
        case (lives)
            5: led = 5'b11111;
            4: led = 5'b01111;
            3: led = 5'b00111;
            2: led = 5'b00011;
            1: led = 5'b00001;
            0: led = 5'b00000;
        endcase
    end
    
endmodule