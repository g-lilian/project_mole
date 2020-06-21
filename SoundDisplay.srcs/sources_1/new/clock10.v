`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2019 03:48:16 PM
// Design Name: 
// Module Name: clock10
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


module clock10(
    input CLOCK,
output reg SLOW_CLOCK=0
);

reg[24:0] count = 0;
always @ (posedge CLOCK) 
    begin
        count <= (count == 49999999) ? 0 : count+1;
        SLOW_CLOCK <= (count == 0) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end 
endmodule
