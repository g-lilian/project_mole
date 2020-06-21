`timescale 1ns / 1ps

module one_dff(
    input dff_clock,input D, output reg Q
    );
    
    always @(posedge dff_clock) begin
        Q <= D;
    end
endmodule