`timescale 1ns / 1ps

module sp(
    input sp_clock, push_button, output single_pulse
    );
    
    wire dff1_out, dff2_out;
    one_dff dff_unit1 (.D(push_button), .dff_clock(sp_clock), .Q(dff1_out));
    one_dff dff_unit2 (.D(dff1_out), .dff_clock(sp_clock), .Q(dff2_out));
    
    assign single_pulse = dff1_out & ~dff2_out;
    
endmodule
