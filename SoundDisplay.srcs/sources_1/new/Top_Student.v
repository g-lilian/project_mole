`timescale 1ns / 1ps


module Top_Student (
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v
    output [6:0] JC,
    
    input CLK100MHZ,
    input btnL, btnR, btnC, // push buttons
    input sw0, sw1, sw2, sw3, sw15, // VB_on, border, freeze_disp, freeze_led, start_game

    output [14:0] led, // 5 LEDs for HP [0,4], 3 LEDs for difficulty [6,8], all LEDs for volume indicator
    output [7:0] seg, // score
    output [3:0] an
    );

    // SET-UP: OLED, audio declarations
    wire [4:0] teststate;
    localparam Width = 96;localparam Height = 64;localparam PixelCount = Width * Height;localparam PixelCountWidth = $clog2(PixelCount);
    wire frame_begin, sending_pixels, sample_pixel;
    wire [PixelCountWidth-1:0] pixel_index;
    wire [15:0] pixel_colour;
    wire [11:0] mic_out;
    wire [14:0] led_out;
    
/************************************************************************************************************************/
    // INTEGRATION (VOLUME BAR and WHACK-A-MOLE)
    wire [15:0] pixel_colour_VB; wire [15:0] pixel_colour_mole;
    assign pixel_colour = sw15 ? pixel_colour_mole : pixel_colour_VB;
    wire [14:0] led_VB; wire [14:0] led_mole;
    assign led[4:0] = sw15 ? led_mole[4:0] : led_VB[4:0];
    assign led[8:6] = sw15 ? led_mole[8:6] : led_VB[8:6];
    assign led[5] = sw15 ? 0 : led_VB[5];
    assign led[14:9] = sw15 ? 0 : led_VB[14:9];
    wire [7:0] seg_VB; wire [7:0] seg_mole;
    assign seg [6:0] = sw15 ? seg_mole[6:0] : seg_VB[6:0];
    assign seg[7] = 1;
    wire [3:0] an_VB; wire [3:0] an_mole;
    assign an = sw15 ? an_mole : an_VB;

/************************************************************************************************************************/
    // SET-UP: ALL CLOCKS
    wire CLK6p25m; // for oled
    master_clock get_6p25m (CLK100MHZ, 7, CLK6p25m);
    wire SLOW_CLOCK; // for mic
    master_clock get_slowclock (CLK100MHZ, 2499, SLOW_CLOCK);
    wire CLK0, CLK1, CLK2, CLK_OUT; // clocks for 3 difficulty levels and the currently selected one
    master_clock get_CLK5HZ (CLK100MHZ, 9_999_999, CLK0);
    master_clock get_CLK7HZ (CLK100MHZ, 7142856, CLK1);
    master_clock get_CLK12HZ (CLK100MHZ, 3_999_999, CLK2);
    wire CLK1HZ; // for 1sec sp (mole_killed)
    master_clock get_1HZ (CLK100MHZ, 49_999_999, CLK1HZ);
    wire CLK10HZ; // for whack_sp
    master_clock get_10HZ (CLK100MHZ, 4_999_999, CLK10HZ);
    wire CLK20HZ;
    master_clock get_20HZ (CLK100MHZ, 2499999, CLK20HZ);
    wire sp_clock; // a good speed for push button sp
    master_clock get_50HZ (CLK100MHZ, 999_999, sp_clock);
    wire CLK500HZ;
    master_clock get_500HZ (CLK100MHZ, 99999, CLK500HZ);
    wire clock10_out,clock240_out; // old clocks for audio
    clock240(CLK100MHZ, clock240_out);
    clock10(CLK100MHZ,clock10_out);
    
    // SP SET-UP
    wire btnC_sp, btnL_sp, btnR_sp;
    sp C (sp_clock, btnC, btnC_sp);
    sp L (sp_clock, btnL, btnL_sp);
    sp R (sp_clock, btnR, btnR_sp);

/************************************************************************************************************************/
    // BASIC VOLUME BAR
    volume_bar_control display_volume_bar (sp_clock, sw0, sw1, sw2, btnL, btnR, CLK100MHZ, pixel_index, mic_out, led_out, pixel_colour_VB);
    wire [3:0] an_out; wire [6:0] seg_out;
    led_volume_disp(SLOW_CLOCK,clock10_out,mic_out,led_out);
    seg_volume_disp(SLOW_CLOCK, clock240_out, mic_out, an_out, seg_out);
    MUX(sw3,mic_out, an_out, seg_out, led_out,an_VB, seg_VB, led_VB);

/************************************************************************************************************************/
    // WHACK-A-MOLE
    difficulty_selector (sp_clock, btnL_sp, btnR_sp, CLK0, CLK1, CLK2, led_mole [8:6], CLK_OUT);
    wire [12:0] rand;
    wire mole_status, bombed, bomb_status, mole_trauma;
    rng (SLOW_CLOCK, btnC_sp, bomb_status, mole_status, rand); // clk, reset, mole_status, rand
    mole (CLK_OUT, rand, mole_trauma, mole_status); // when hit, mole dies & enter trauma for 1sec (cannot spawn or hit mole again)
    bomb (CLK_OUT, rand, bombed, bomb_status);
    wire reset, WHACK;
    whack_sp get_WHACK (SLOW_CLOCK, CLK20HZ, mic_out, WHACK);
    //sp debug_whack (sp_clock, btnU, WHACK);
    wire WIN, LOSE;
    scoreboard (SLOW_CLOCK, WHACK, mole_status, btnC, seg_mole, an_mole, WIN, mole_trauma); // IMPT: second para must be SAME clock as whack_sp clock
    lives (SLOW_CLOCK, WHACK, bomb_status, btnC, led_mole [4:0], LOSE, bombed);
    animation (CLK6p25m, pixel_index, mole_status, bomb_status, mole_trauma, bombed, WIN, LOSE, pixel_colour_mole);

/************************************************************************************************************************/
    // SET-UP: OLED
    Oled_Display display (.clk(CLK6p25m), .reset(reset), .pixel_data(pixel_colour),
                          .frame_begin(frame_begin), .sending_pixels(sending_pixels), .sample_pixel(sample_pixel), .pixel_index(pixel_index),
                          .cs(JC[0]), .sdin(JC[1]), .sclk(JC[2]), .d_cn(JC[3]), .resn(JC[4]), .vccen(JC[5]), .pmoden(JC[6]),
                          .teststate(teststate)
                          );
    
    // SET-UP: MIC
    Audio_Capture(CLK100MHZ, SLOW_CLOCK, J_MIC3_Pin3, J_MIC3_Pin1, J_MIC3_Pin4, mic_out);
    
endmodule