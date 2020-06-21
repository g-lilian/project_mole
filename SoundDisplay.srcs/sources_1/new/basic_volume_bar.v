`timescale 1ns / 1ps

// for volume bar theme selection
module volume_bar_control(
    input sp_clock,
    input sw0, sw1, sw2, // on/off, border size, freeze
    input pb_L, pb_R, // left and right push buttons
    input clk_6p25m,
    input [12:0] pixel_index,
    input [11:0] mic_out,
    input [14:0] led_out,
    output [15:0] pixel_colour
    );
    
    reg [2:0] select_theme = 3'b001; // start with default
    wire sp_L, sp_R;
    sp get_spL (sp_clock, pb_L, sp_L);
    sp get_spR (sp_clock, pb_R, sp_R);
    // use push buttons to select theme
    always @ (posedge sp_clock) begin
        if (sp_L && !pb_R) begin
            if (select_theme != 3'b100) select_theme = select_theme << 1;
            else select_theme = 3'b001;
        end
        else if (sp_R && !pb_L) begin
            if (select_theme != 3'b001) select_theme = select_theme >> 1;
            else select_theme = 3'b100;
        end
    end
    
    // generate display
    volume_bar(sw0, sw1, sw2, select_theme, clk_6p25m, pixel_index, mic_out, led_out, pixel_colour);

endmodule

// for volume bar display
module volume_bar(
    input sw0, // toggle on/off display
    input sw1, // toggle border size = 1 or = 3
    input sw2, // toggle freeze display
    input [2:0] select_theme, // choose between 3 colour schemes
    input clk_6p25m,
    input [12:0] pixel_index,
    input [11:0] mic_out, // for volume indication
    input [14:0] led_out,
    output reg [15:0] pixel_colour
    );
    
    // colour themes
    reg [15:0] bg_colour, border_colour, low_colour, med_colour, high_colour;
    always @ (clk_6p25m) begin
        case (select_theme)
            3'b001: // default
            begin
                border_colour = 16'hFFFF; // white
                bg_colour = 16'h0000; // black
                low_colour = 16'h16A0; // G
                med_colour = 16'hFFE0; // Y
                high_colour = 16'hF800; // R
            end
            3'b010: // pastel
            begin
                border_colour = 16'hA69B; // grey-blue
                bg_colour = 16'h2965; // dark grey
                low_colour = 16'hFFCD; // creamy yellow
                med_colour = 16'hFC79; // baby pink
                high_colour = 16'hD37F; // lavender
            end
            3'b100: // futuristic
            begin
                border_colour = 16'h2551; // dark turquoise
                bg_colour = 16'h07FE; // cyan
                low_colour = 16'hD6BA; // silver grey
                med_colour = 16'hE0F2; // magenta
                high_colour = 16'h888B; // burgundy
            end
            default: bg_colour = 16'hF800; // detect errors
        endcase
    end
    
    // get x,y coordinates
    wire [12:0] x, y;
    assign x = pixel_index % 96;
    assign y = pixel_index/96;
    
    // main loop
    reg [14:0] volume;
    always @ (clk_6p25m) begin
        if (sw0) begin // if turned on
            if (!sw2) volume = led_out; // freeze when sw2 is on
            
            // border
            // default to 1 pixel border
            if (!sw1 && (x == 0 || x == 95 || y == 0 || y == 63)) begin // if col==0/95 or row==0/63
                pixel_colour = border_colour;
            end
            else if (sw1  && (x < 3 || x > 92 || y < 3 || y > 60)) begin // when sw1 is on, switch to 3 pixel border
                pixel_colour = border_colour;
            end
            
            // 15-level volume bar: 3px/bar with 1px spacing, topmost bar only 2px, 3px buffer above and below
            else if ((x >= 45 && x <= 51) && (y >= 3) && (y <= 60)) begin // 150 per bar
                pixel_colour = bg_colour; // default colour if none of the below statements are true

                if (volume >= 15'b000000000000001) begin 
                    if (y >= 59 && y <= 60) pixel_colour = low_colour; // only 2px
                        if (volume >= 15'b000000000000011) begin if (y >= 55 && y <= 57) pixel_colour = low_colour;
                        if (volume >= 15'b000000000000111) begin if (y >= 51 && y <= 53) pixel_colour = low_colour;
                        if (volume >= 15'b000000000001111) begin if (y >= 47 && y <= 49) pixel_colour = low_colour;
                        if (volume >= 15'b000000000011111) begin if (y >= 43 && y <= 45) pixel_colour = low_colour;
                        
                        if (volume >= 15'b000000000111111) begin if (y >= 39 && y <= 41) pixel_colour = med_colour;
                        if (volume >= 15'b000000001111111) begin if (y >= 35 && y <= 37) pixel_colour = med_colour;
                        if (volume >= 15'b000000011111111) begin if (y >= 31 && y <= 33) pixel_colour = med_colour;
                        if (volume >= 15'b000000111111111) begin if (y >= 27 && y <= 29) pixel_colour = med_colour;
                        if (volume >= 15'b000001111111111) begin if (y >= 23 && y <= 25) pixel_colour = med_colour;
                        
                        if (volume >= 15'b000011111111111) begin if (y >= 19 && y <= 21) pixel_colour = high_colour;
                        if (volume >= 15'b000111111111111) begin if (y >= 15 && y <= 17) pixel_colour = high_colour;
                        if (volume >= 15'b001111111111111) begin if (y >= 11 && y <= 13) pixel_colour = high_colour;
                        if (volume >= 15'b011111111111111) begin if (y >= 7 && y <= 9) pixel_colour = high_colour;
                        if (volume >= 15'b111111111111111) begin if (y >= 3 && y <= 5) pixel_colour = high_colour;
                end end end end end end end end end end end end end end end
                
                if (y==6 || y==10 || y==14 || y==18 || y==22) pixel_colour = bg_colour; // spaces
                if (y==26 || y==30 || y==34 || y==38 || y==42) pixel_colour = bg_colour; // spaces
                if (y==46 || y==50 || y==54 || y==58) pixel_colour = bg_colour; // spaces
            end
            
            // background
            else
                pixel_colour = bg_colour;
        end
        else pixel_colour = 16'h0000; // if display is not frozen, turn it off by resetting to black
    end
    
endmodule
