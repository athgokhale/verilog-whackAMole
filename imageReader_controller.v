module mole_controller(
    input clk,
    input resetn,
    input play,
    input [24:0] moleTimeCounter,
    input hit,
 	
 	output reg moleCounter_en, hit_signal, miss_signal, mole_up
    );

    reg [3:0] current_state, next_state; 
    
    localparam  S_WAIT   		= 4'd0,
				S_MOLE_DOWN	    = 4'd1,
				S_MOLE_UP		= 4'd2,
				S_HIT	     	= 4'd3, 
	   			S_MISS   		= 4'd4;
   

    // Next state logic aka our state table
    always@(*)
    begin: state_table
            case (current_state)
		S_WAIT: next_state = play ? S_MOLE_DOWN : S_WAIT; 
		S_MOLE_DOWN: 
			begin
				if (play) begin
					next_state = (moleTimeCounter == 25'd0) ? S_MOLE_UP: S_MOLE_DOWN;
				end
				else begin
					next_state = S_WAIT;
				end
			end
		S_MOLE_UP:
			begin
				if (play) begin
					if (hit) begin
						next_state = S_HIT;
					end
					else if (moleTimeCounter == 25'd0) begin
						next_state = S_MISS;
					end
					else begin
						next_state = S_MOLE_UP;
					end
				end
				else begin
					next_state = S_WAIT; 
				end	
			end
		S_HIT: next_state = play ? S_MOLE_DOWN: S_WAIT;
		S_MISS: next_state = play ? S_MOLE_DOWN: S_WAIT;
            default:     next_state = S_WAIT;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0 
        hit_signal = 1'b0;
        miss_signal = 1'b0;
        mole_up = 1'b0;
        moleCounter_en = 1'b0
        
        case (current_state)
        	S_MOLE_DOWN: begin
                	mole_up = 1'b0;
                	moleCounter_en = 1'b1;
                	end
            S_MOLE_UP: begin 
                	mole_up = 1'b1; 
                	moleCounter_en = 1'b1;
                	end
            S_HIT: begin
            		hit_signal = 1'b1;
            		end
            S_MISS: begin
            		miss_signal = 1'b1;
            		end    
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_WAIT;
        else
            current_state <= next_state;
    end // state_FFS
endmodule