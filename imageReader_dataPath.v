module imageReader_dataPath(clock, resetn, mole_up, play, moleCounter);

input clock, resetn, mole_up;

output [24:0] moleCounter; 

wire [3:0] imageSelector; 
wire [3:0] randNum;

muxMoleDownOrUpSelector (
.mole_up(mole_up), 
.randumNum(randNum), 
.outSignal(imageSelector)
);  

wire [3:0] randNum;

LFSR randNumGen(
.out(randNum),
.play(play), 
.resetn(~play), 
.clock(CLOCK_50)
);

moleTimeCounter mole_time(
	.clock(CLOCK_50),
	.resetn(resetn),
	.out(moleCounter), 
	.play(play)
);     

assign moleCounter = wire_moleCounter; 

endmodule

module muxMoleDownOrUpSelector(mole_up, randumNum, outSignal);
input mole_up;
input [3:0]randumNum;
output [3:0]outSignal;

reg [3:0] out;

always@(posedge mole_up or negedge mole_up)
    begin
        case(mole_up)
            4'd0:  out <= 4'b0000; 
            4'd1:  out <= randumNum; 
        endcase
	end
assign outSignal = out; 

endmodule
