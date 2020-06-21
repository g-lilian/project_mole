`timescale 1ns / 1ps


module rng(
    input clock, //use a 100Hz clock
    input reset, // set a random button to this or set as 0
    input pause_mole, // connect mole to this
    input pause_bomb,
    output reg [12:0] rnd // connect this to "number in mole"
    );

wire feedback = random[12] ^ random[3] ^ random[2] ^ random[0]; 
 
reg [12:0] random = 13'hF, random_next, random_done;
reg [3:0] count, count_next; //to keep track of the shifts
 
always @ (posedge clock or posedge reset)
begin
 if (reset)
 begin
  random <= 13'hF; //An LFSR cannot have an all 0 state, thus reset to FF
  count <= 0;
 end
  
 else
 begin
  random <= random_next;
  count <= count_next;
  random_next = random; //default state stays the same
  count_next = count;
    
  random_next = {random[11:0], feedback}; //shift left the xor'd every posedge clock
  count_next = count + 1;
  
  if (count == 13)
  begin
  count = 0;
  random_done = random; //assign the random number to output after 13 shifts
  end
 end
end
 
//assign rnd = random_done;
always @ (posedge clock)
begin
if(pause_mole == 0 && pause_bomb == 0)
rnd <= random_done;
else if(pause_mole == 1 || pause_bomb == 1)
rnd <= 5000;
end
endmodule