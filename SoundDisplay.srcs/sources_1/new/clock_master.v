`timescale 1ns / 1ps

module master_clock(
    input CLOCK, [32:0] m_value, // variable m so you can use this for any clock
    output reg clock_divider = 0
    );
    reg [32:0] count = 0; // get a frequency between 50MHz (max) and 100MHz/(2((2^N - 1) + 1)) (min)
    always @ (posedge CLOCK) begin
        count <= (count == m_value) ? 0 : count + 1; // gets clock with frequency 100MHz/(2(m + 1)) eg. for count==0, freq=50MHz
        clock_divider <= (count == 0) ? ~clock_divider : clock_divider;
    end
    
endmodule