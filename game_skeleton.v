`include "game_controller.v"
`include "gameClock.v"

module game_skeleton(CLOCK_50, KEY, SW, HEX0, HEX1, HEX2); 

input [9:0] SW; 
input [3:0] KEY;
input CLOCK_50;

input [6:0] HEX0, HEX1, HEX2; 

wire display_score, ld_time, play;
wire [7:0] timer; 

game_controller g0(
    .clk(CLOCK_50),
    .resetn(KEY[3]),
    .go(~KEY[0]),
    .gameClock_out(timer),
    .ld_time(ld_time),
    .play(play),
    .display_score(display_score)
);

gameClock game_clock(
	.reset_n(KEY[3]),
	.CLOCK_50(CLOCK_50),
	.start_timer(play),
	.load_time(ld_time),
	.time_chooser(SW[6:5]),
	.parload(SW[3]),
	.HEX0(HEX0), 
	.HEX1(HEX1), 
	.HEX2(HEX2),
	.clock_out(timer)
);





endmodule
