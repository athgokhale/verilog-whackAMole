module LFSR(out, resetn, clock, play);

input resetn, clock, play;
output [3:0] out;

wire [3:0] num; 

LFSR_m(
.clock(clock),
.reset(resetn),
.play(play)
.rnd(num)
);

assign out = num; 
endmodule

module LFSR_m (
    input clock,
    input reset,
    input play,
    output [3:0] rnd 
    );
 

reg [12:0] random, random_next, random_done;
reg [3:0] count, count_next; //to keep track of the shifts

wire feedback = random[12] ^ random[3] ^ random[2] ^ random[0]; 
 
always @ (posedge clock or negedge reset)
	begin
		if (play)
			if (~reset)
				begin
				random <= 13'hF; //An LFSR cannot have an all 0 state, thus reset to FF
				count <= 4'b0;
				end
			else
				begin
				random <= random_next;
				count <= count_next;
				end
		end
	end
 
always @ (*)
	begin
		if (play)
			random_next <= random; //default state stays the same
			count_next <= count_next + 1;
   
			random_next <= {random[11:0], feedback}; //shift left the xor'd every posedge clock
			//count_next = count + 1;
 
			if (count == 4'd13)
				begin
				count <= 4'b0;
				random_done = random; //assign the random number to output after 13 shifts
				end
			end
		end
assign rnd = random_done[3:0];
 
endmodule