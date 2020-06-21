`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2019 01:10:23 AM
// Design Name: 
// Module Name: clock240
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock240(
input CLOCK,
output reg SLOW_CLOCK=0
);

reg[20:0] count = 0;
always @ (posedge CLOCK) 
    begin
        count <= (count == 208332) ? 0 : count+1;
        SLOW_CLOCK <= (count == 0) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end 
endmodule

