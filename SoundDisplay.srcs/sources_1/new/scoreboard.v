`timescale 1ns / 1ps

module scoreboard(
    input CLK_UPDATE, // for updating counts and scoreboard refreshing
    input WHACK,
    input MOLE, // 0 for absent, 1 for present
    input RESET,
    
    output reg [7:0] seg,
    output reg [3:0] an,
    output reg WIN = 0,
    output reg mole_trauma = 0 // is it in trauma period?
    );
    
    // GENERATE SCORE
    reg [15:0] timer = 0;
    reg [4:0] score = 0; // initialize to 0

    
    always @ (posedge CLK_UPDATE)
    begin
        if(RESET)
        begin
            score <= 0;
            WIN <= 0;
        end
        if(score == 20)
            WIN <= 1;
        if(mole_trauma || timer != 0)
            timer = (timer == 7999) ? 0 :timer + 1;
        if(timer == 0 && WHACK && MOLE && !WIN)
            begin
            score <= score + 1;
            mole_trauma <= 1;   
            end
         else if( timer ==7999)
            mole_trauma <= 0;
     end
    
    
    // RESET SCOREBOARD
//    always @ (posedge RESET) begin
//        score = 0;
//    end
    
    // DISPLAY SCORE ON 7-SEG (based on score only)
    reg count;
    always @ (posedge CLK_UPDATE) begin
            if (score < 10) begin
                an = 4'b1110;
                case (score) // display based on score: 0-9
                    0: seg = 8'b1100_0000;
                    1: seg = 8'b1111_1001;
                    2: seg = 8'b1010_0100;
                    3: seg = 8'b1011_0000;
                    4: seg = 8'b1001_1001;
                    5: seg = 8'b1001_0010;
                    6: seg = 8'b1000_0010;
                    7: seg = 8'b1111_1000;
                    8: seg = 8'b1000_0000;
                    9: seg = 8'b1001_0000;
                    default: seg = 8'b0000_0000; // debug
                endcase
            end
            else begin // score >= 10
                if (count) an = 4'b1110;
                else an = 4'b1101;
                if (score >= 20) begin
                    case (count)
                        0: seg = 8'b1010_0100; // 2
                        1: seg = 8'b1100_0000; // 0
                    endcase
                end
                else begin
                    case (count)
                        0: seg = 8'b1111_1001; // 1
                        1: begin
                            case (score) // 2nd digit
                                10: seg = 8'b1100_0000;
                                11: seg = 8'b1111_1001;
                                12: seg = 8'b1010_0100;
                                13: seg = 8'b1011_0000;
                                14: seg = 8'b1001_1001;
                                15: seg = 8'b1001_0010;
                                16: seg = 8'b1000_0010;
                                17: seg = 8'b1111_1000;
                                18: seg = 8'b1000_0000;
                                19: seg = 8'b1001_0000;
                                default: seg = 8'b0000_0000; // debug
                            endcase
                        end
                    endcase
                end
            end
    end
    
    // for displaying double digit numbers
    always @ (posedge CLK_UPDATE) begin
        count = ~count;
    end
    
endmodule
