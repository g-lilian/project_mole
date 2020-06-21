`timescale 1ns / 1ps

module animation(
    input clock,
    input [12:0] pixel_index,
    input mole_status, bomb_status,
    input mole_trauma, bombed,
    input WIN, LOSE,
    output reg [15:0] pixel_colour
    );
    
    // DISPLAYS
    wire [12:0] x,y; wire [20:0] distance;
    assign x = pixel_index % 96;
    assign y = pixel_index/96;
    reg [12:0] x0,y0,r; // for checking distance between center (x0,y0) and any point (x,y)
    assign distance = (x0-x)*(x0-x) + (y0-y)*(y0-y); // for drawing circles (working code)
    always @ (posedge clock) begin
        if (WIN) begin
            x0=48; y0=40;
            pixel_colour = 16'h18C3; // INITIALIZE
            if (y>=40 && distance<100) pixel_colour = 16'hFBB6; // smile :D
            else if ((x>=34 && x<=38 && y>=20 && y<25) || (x>=58 && x<=62 && y>=20 && y<25)) pixel_colour = 16'hFBB6; // eyes
        end
        else if (LOSE) begin
            x0=48; y0=50;
            pixel_colour = 16'h18C3; // INITIALIZE
            if (y<=50 && distance<100) pixel_colour = 16'h073F; // sad D:
            else if ((x>=34 && x<=38 && y>=20 && y<25) || (x>=58 && x<=62 && y>=20 && y<25)) pixel_colour = 16'h073F; // eyes
        end
        else if (mole_trauma) begin
        // HIT MOLE animation (trauma period), same as mole present but with bg colour change
            if (x<=15 || x>=80) begin
            pixel_colour = 16'hF800; // colour change
            end
            else begin
                pixel_colour = 16'hF800; // INITIALIZATION
                // check row by row (max is 16+16 comparisons)
                if (y<=3) // 1
                begin
                    if (x>=40 && x<56) pixel_colour = 16'h0000;
                end
                else if (y>3 && y<=7) // 2
                begin
                    if ((x>=16 && x<28) || (x>=32 && x<40) || (x>=56 && x<64) || (x>=68 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=40 && x<56)) pixel_colour = 16'hF5EC;
                end
                else if (y>7 && y<=11) // 3
                begin
                    if ((x>=16 && x<20) || (x>=28 && x<32) || (x>=40 && x<44) || (x>=52 && x<56) || (x>=64 && x<68) || (x>=76 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=36 && x<40) || (x>=44 && x<52) || (x>=56 && x<60)) pixel_colour = 16'hF5EC;
                    else if ((x>=20 && x<28) || (x>=32 && x<36) || (x>=60 && x<64) || (x>=68 && x<76)) pixel_colour = 16'h8940;
                end
                else if (y>11 && y<=15) // 4
                begin
                    if ((x>=16 && x<20) || (x>=28 && x<32) || (x>=64 && x<68) || (x>=76 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=24 && x<28) || (x>=32 && x<64) || (x>=68 && x<72)) pixel_colour = 16'hF5EC;
                    else if ((x>=20 && x<24) || (x>=72 && x<76)) pixel_colour = 16'h8940;
                end
                else if (y>15 && y<=19) // 5
                begin
                    if ((x>=16 && x<20) || (x>=44 && x<52) || (x>=76 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=20 && x<40) || (x>=56 && x<76)) pixel_colour = 16'hF5EC;
                    else if ((x>=40 && x<44) || (x>=52 && x<56)) pixel_colour = 16'hFFFF;
                end
                else if (y>19 && y<=23) // 6
                begin
                    if ((x>=16 && x<20) || (x>=32 && x<36) || (x>=60 && x<64) || (x>=76 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=24 && x<28) || (x>=68 && x<72)) pixel_colour = 16'hF5EC;
                    else if ((x>=20 && x<24) || (x>=28 && x<32) || (x>=64 && x<68) || (x>=72 && x<76)) pixel_colour = 16'h8940;
                    else if ((x>=36 && x<60)) pixel_colour = 16'hFFFF;
                end
                else if (y>23 && y<=27) // 7
                begin
                    if ((x>=20 && x<24) || (x>=32 && x<36) || (x>=44 && x<52) || (x>=60 && x<64) || (x>=72 && x<76)) pixel_colour = 16'h0000;
                    else if ((x>=24 && x<32) || (x>=64 && x<72)) pixel_colour = 16'hF5EC;
                    else if ((x>=36 && x<44) || (x>=52 && x<60)) pixel_colour = 16'hFFFF;
                end
                else if (y>27 && y<=31) // 8
                begin
                    if ((x>=20 && x<24) || (x>=36 && x<44) || (x>=52 && x<60) || (x>=72 && x<76)) pixel_colour = 16'h0000;
                    else if ((x>=24 && x<36) || (x>=60 && x<72)) pixel_colour = 16'hF5EC;
                    else if ((x>=44 && x<52)) pixel_colour = 16'hFFFF;
                end
                else if (y>31 && y<=35) // 9
                begin
                    if ((x>=24 && x<28) || (x>=68 && x<72)) pixel_colour = 16'h0000;
                    else if ((x>=28 && x<32) || (x>=64 && x<68)) pixel_colour = 16'hF5EC;
                    else if ((x>=32 && x<64)) pixel_colour = 16'hFFFF;
                end
                else if (y>35 && y<=39) // 10
                begin
                    if ((x>=24 && x<28) || (x>=68 && x<72)) pixel_colour = 16'h0000;
                    else if ((x>=28 && x<32) || (x>=64 && x<68)) pixel_colour = 16'hF5EC;
                    else if ((x>=32 && x<64)) pixel_colour = 16'hFFFF;
                end
                else if (y>39 && y<=43) // 11
                begin
                    if ((x>=16 && x<28) || (x>=68 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=28 && x<32) || (x>=64 && x<68)) pixel_colour = 16'hF5EC;
                    else if ((x>=32 && x<64)) pixel_colour = 16'hFFFF;
                end
                else if (y>43 && y<=47) // 12
                begin
                    if ((x>=16 && x<24) || (x>=72 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=28 && x<36) || (x>=60 && x<68)) pixel_colour = 16'hF5EC;
                    else if ((x>=24 && x<28) || (x>=68 && x<72)) pixel_colour = 16'h8940;
                    else if ((x>=36 && x<60)) pixel_colour = 16'hFFFF;
                end
                else if (y>47 && y<=51) // 13
                begin
                    if ((x>=16 && x<28) || (x>=68 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=28 && x<40) || (x>=56 && x<68)) pixel_colour = 16'hF5EC;
                    else if ((x>=40 && x<56)) pixel_colour = 16'hFFFF;
                end
                else if (y>51 && y<=55) // 14
                begin
                    if ((x>=20 && x<32) || (x>=36 && x<40) || (x>=56 && x<60) || (x>=64 && x<76)) pixel_colour = 16'h0000;
                    else if ((x>=32 && x<36) || (x>=60 && x<64)) pixel_colour = 16'hF5EC;
                    else if ((x>=40 && x<56)) pixel_colour = 16'h8940;
                end
                else if (y>55 && y<=59) // 15
                begin
                    if ((x>=24 && x<36) || (x>=40 && x<44) || (x>=52 && x<56) || (x>=60 && x<72)) pixel_colour = 16'h0000;
                    else if ((x>=44 && x<52)) pixel_colour = 16'h8940;
                end
                else if (y>59 && y<=63) // 16
                begin
                    if ((x>=28 && x<36) || (x>=44 && x<52) || (x>=60 && x<68)) pixel_colour = 16'h0000;
                end
            end
        end
        
        else if (bombed) begin
        // HIT BOMB animation
            x0=48; y0=32; // middle of screen
            pixel_colour = 16'hFFC0; // INITIALIZE
            if (distance<400) pixel_colour = 16'h0000; // nested circles :O
            else if (distance>=400 && distance<550) pixel_colour = 16'hFCE0;
        end

        else if (mole_status == 1) begin
        // MOLE ALIVE animation
            if (x<=15 || x>=80) begin // the sides
                pixel_colour = 16'h07E6; // green
            end
            else begin
                pixel_colour = 16'h07E6; // INITIALIZATION
                // check row by row (max is 16+16 comparisons)
                if (y<=3) // 1
                begin
                    if (x>=40 && x<56) pixel_colour = 16'h0000;
                end
                else if (y>3 && y<=7) // 2
                begin
                    if ((x>=16 && x<28) || (x>=32 && x<40) || (x>=56 && x<64) || (x>=68 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=40 && x<56)) pixel_colour = 16'hF5EC;
                end
                else if (y>7 && y<=11) // 3
                begin
                    if ((x>=16 && x<20) || (x>=28 && x<32) || (x>=40 && x<44) || (x>=52 && x<56) || (x>=64 && x<68) || (x>=76 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=36 && x<40) || (x>=44 && x<52) || (x>=56 && x<60)) pixel_colour = 16'hF5EC;
                    else if ((x>=20 && x<28) || (x>=32 && x<36) || (x>=60 && x<64) || (x>=68 && x<76)) pixel_colour = 16'h8940;
                end
                else if (y>11 && y<=15) // 4
                begin
                    if ((x>=16 && x<20) || (x>=28 && x<32) || (x>=64 && x<68) || (x>=76 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=24 && x<28) || (x>=32 && x<64) || (x>=68 && x<72)) pixel_colour = 16'hF5EC;
                    else if ((x>=20 && x<24) || (x>=72 && x<76)) pixel_colour = 16'h8940;
                end
                else if (y>15 && y<=19) // 5
                begin
                    if ((x>=16 && x<20) || (x>=44 && x<52) || (x>=76 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=20 && x<40) || (x>=56 && x<76)) pixel_colour = 16'hF5EC;
                    else if ((x>=40 && x<44) || (x>=52 && x<56)) pixel_colour = 16'hFFFF;
                end
                else if (y>19 && y<=23) // 6
                begin
                    if ((x>=16 && x<20) || (x>=32 && x<36) || (x>=60 && x<64) || (x>=76 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=24 && x<28) || (x>=68 && x<72)) pixel_colour = 16'hF5EC;
                    else if ((x>=20 && x<24) || (x>=28 && x<32) || (x>=64 && x<68) || (x>=72 && x<76)) pixel_colour = 16'h8940;
                    else if ((x>=36 && x<60)) pixel_colour = 16'hFFFF;
                end
                else if (y>23 && y<=27) // 7
                begin
                    if ((x>=20 && x<24) || (x>=32 && x<36) || (x>=44 && x<52) || (x>=60 && x<64) || (x>=72 && x<76)) pixel_colour = 16'h0000;
                    else if ((x>=24 && x<32) || (x>=64 && x<72)) pixel_colour = 16'hF5EC;
                    else if ((x>=36 && x<44) || (x>=52 && x<60)) pixel_colour = 16'hFFFF;
                end
                else if (y>27 && y<=31) // 8
                begin
                    if ((x>=20 && x<24) || (x>=36 && x<44) || (x>=52 && x<60) || (x>=72 && x<76)) pixel_colour = 16'h0000;
                    else if ((x>=24 && x<36) || (x>=60 && x<72)) pixel_colour = 16'hF5EC;
                    else if ((x>=44 && x<52)) pixel_colour = 16'hFFFF;
                end
                else if (y>31 && y<=35) // 9
                begin
                    if ((x>=24 && x<28) || (x>=68 && x<72)) pixel_colour = 16'h0000;
                    else if ((x>=28 && x<32) || (x>=64 && x<68)) pixel_colour = 16'hF5EC;
                    else if ((x>=32 && x<64)) pixel_colour = 16'hFFFF;
                end
                else if (y>35 && y<=39) // 10
                begin
                    if ((x>=24 && x<28) || (x>=68 && x<72)) pixel_colour = 16'h0000;
                    else if ((x>=28 && x<32) || (x>=64 && x<68)) pixel_colour = 16'hF5EC;
                    else if ((x>=32 && x<64)) pixel_colour = 16'hFFFF;
                end
                else if (y>39 && y<=43) // 11
                begin
                    if ((x>=16 && x<28) || (x>=68 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=28 && x<32) || (x>=64 && x<68)) pixel_colour = 16'hF5EC;
                    else if ((x>=32 && x<64)) pixel_colour = 16'hFFFF;
                end
                else if (y>43 && y<=47) // 12
                begin
                    if ((x>=16 && x<24) || (x>=72 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=28 && x<36) || (x>=60 && x<68)) pixel_colour = 16'hF5EC;
                    else if ((x>=24 && x<28) || (x>=68 && x<72)) pixel_colour = 16'h8940;
                    else if ((x>=36 && x<60)) pixel_colour = 16'hFFFF;
                end
                else if (y>47 && y<=51) // 13
                begin
                    if ((x>=16 && x<28) || (x>=68 && x<80)) pixel_colour = 16'h0000;
                    else if ((x>=28 && x<40) || (x>=56 && x<68)) pixel_colour = 16'hF5EC;
                    else if ((x>=40 && x<56)) pixel_colour = 16'hFFFF;
                end
                else if (y>51 && y<=55) // 14
                begin
                    if ((x>=20 && x<32) || (x>=36 && x<40) || (x>=56 && x<60) || (x>=64 && x<76)) pixel_colour = 16'h0000;
                    else if ((x>=32 && x<36) || (x>=60 && x<64)) pixel_colour = 16'hF5EC;
                    else if ((x>=40 && x<56)) pixel_colour = 16'h8940;
                end
                else if (y>55 && y<=59) // 15
                begin
                    if ((x>=24 && x<36) || (x>=40 && x<44) || (x>=52 && x<56) || (x>=60 && x<72)) pixel_colour = 16'h0000;
                    else if ((x>=44 && x<52)) pixel_colour = 16'h8940;
                end
                else if (y>59 && y<=63) // 16
                begin
                    if ((x>=28 && x<36) || (x>=44 && x<52) || (x>=60 && x<68)) pixel_colour = 16'h0000;
                end
            end
        end
        
        else if (bomb_status == 1) begin
        // BOMB ALIVE animation
            x0=48; y0=32; // middle of screen
            pixel_colour = 16'hF800; // INITIALIZE
            if (distance<400) pixel_colour = 16'h0000; // circle :O
        end
        
        else begin
        // background
            pixel_colour = 16'h94B2;
        end
    end
    
endmodule
