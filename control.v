module control(
    input clk,
    input resetn,
	 input go_x,
    input go_y,
    input [3:0] counter_out,

    output reg  ld_y, ld_colour, plot, ld_x
    );

    reg [3:0] current_state, next_state; 
    
    localparam  S_LOAD_X_WAIT   = 4'd0,
					 S_LOAD_X		  = 4'd1,
					 S_LOAD_Y_WAIT   = 4'd2,
                S_LOAD_Y_COLOUR = 4'd3,	 
					 S_PLOT = 4'd4;

    // Next state logic aka our state table
    always@(*)
    begin: state_table
            case (current_state)
					 S_LOAD_X_WAIT: next_state = go_x ? S_LOAD_X_WAIT : S_LOAD_X;
					 S_LOAD_X: next_state = S_LOAD_Y_WAIT;
                S_LOAD_Y_WAIT: next_state = go_y ? S_LOAD_Y_WAIT : S_LOAD_Y_COLOUR; // Loop in current state until go signal goes low
                S_LOAD_Y_COLOUR: next_state = S_PLOT; // Loop in current state until value is input
					 S_PLOT: next_state = (counter_out == 4'd15) ? S_LOAD_X_WAIT : S_PLOT;
		
		
		// we will be done our two operations, start over after
            default:     next_state = S_LOAD_X_WAIT;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_y = 1'b0;
		  ld_x = 1'b0;
		  ld_colour = 1'b0;
		  plot = 1'b0; 

        case (current_state)
				S_LOAD_X: begin
					 ld_x = 1'b1;
					 end
            S_LOAD_Y_COLOUR: begin
                ld_y = 1'b1;
					 ld_colour = 1'b1; 
                end
            S_PLOT: begin
                plot = 1'b1;
                end    
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_X_WAIT;
        else
            current_state <= next_state;
    end // state_FFS
endmodule