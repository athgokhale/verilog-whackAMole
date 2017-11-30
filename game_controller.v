module game_controller(
    input clk,
    input resetn,
    input go,
    input [3:0] gameClock_out,

    output reg  ld_time, play, display_score
    );

    reg [3:0] current_state, next_state; 
    
    localparam  WELCOME   		= 4'd0,
		S_LOAD_TIME_WAIT	= 4'd1,
		S_LOAD_TIME		= 4'd2,
		S_START_GAME_WAIT	= 4'd3, 
		S_PLAY_GAME   		= 4'd4,
                S_END_SCREEN_SCORE	= 4'd5;

    // Next state logic aka our state table
    always@(*)
    begin: state_table
            case (current_state)
		WELCOME: next_state = go ? S_LOAD_TIME_WAIT : WELCOME;
		S_LOAD_TIME_WAIT: next_state = go ? S_LOAD_TIME_WAIT: S_LOAD_TIME;
		S_LOAD_TIME: next_state = go ? S_START_GAME_WAIT: S_LOAD_TIME;
		S_START_GAME_WAIT: next_state = S_PLAY_GAME;
		S_PLAY_GAME: next_state = (gameClock_out == 4'b0) ? S_END_SCREEN_SCORE: S_PLAY_GAME;
		S_END_SCREEN_SCORE: next_state = go ? WELCOME: S_END_SCREEN_SCORE;

            default:     next_state = WELCOME;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_time = 1'b0;
	play = 1'b0; 
	display_score = 1'b0; 

        case (current_state)
		S_LOAD_TIME: begin
			ld_time = 1'b1;
		end
            	S_PLAY_GAME: begin
                	play = 1'b1;
                end
            	S_END_SCREEN_SCORE: begin
                	display_score = 1'b1;
                end    
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= WELCOME;
        else
            current_state <= next_state;
    end // state_FFS
endmodule