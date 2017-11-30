module gameClock(reset_n, CLOCK_50, HEX0, HEX1, HEX2, start_timer, load_time, clock_out, time_chooser, parload);

	input [1:0] time_chooser;
	input reset_n;
	input CLOCK_50;
	input start_timer;
	input load_time;
	input parload;
	output [6:0] HEX0, HEX1, HEX2;
	output [7:0] clock_out; 
	
	wire enable;
	wire [27:0]temp;
	wire [27:0] connection0;
	wire [7:0] connection1, temp_time;

	reg [7:0] time_count; 
	
	assign connection0 = 28'd10;

	mux3to1 m0(
	.select(time_chooser), 
	.q(temp_time)
	);

	always @(posedge CLOCK_50) begin
		if (!reset_n) begin
			time_count <= 8'd0;
			end else begin
			if (load_time)
				time_count <= temp_time;
		end
	end

	
	RateDivider r1(
	.enable(start_timer),
	.clock(CLOCK_50),
	.resetn(reset_n),
	.d(connection0),
	.count(temp)
	);
	
	assign enable = (temp == 28'b0) ? 1 : 0;
	
	displayCounter d1(
	.clock(CLOCK_50),
	.resetn(reset_n),
	.parload(parload),
	.enable(enable),
	.d(time_count),
	.q(connection1)
	);
	
	assign clock_out = connection1; 

	wire [3:0] add1, add2, add3, add4, add5, add6, add7;
	wire [1:0] hunds;
	wire [3:0] tens, ones; 

	add3 a1(
	.in({1'b0, connection1[7:5]}),
	.out(add1)
	);

	add3 a2(
	.in({add1[2:0], connection1[4]}),
	.out(add2)
	);
	
	add3 a3(
	.in({add2[2:0], connection1[3]}),
	.out(add3)
	);
	
	add3 a4(
	.in({add3[2:0], connection1[2]}),
	.out(add4)
	);

	add3 a5(
	.in({add4[2:0], connection1[1]}),
	.out(add5)
	);
	
	add3 a6(
	.in({1'b0, add1[3], add2[3], add3[3]}),
	.out(add6)
	);

	add3 a7(
	.in({add6[2:0], add4[3]}),
	.out(add7)
	);

	assign hunds = {add6[3], add7[3]};
	assign tens = {add7[2:0], add5[3]};
	assign ones = {add5[2:0], connection1[0]};

	hex_decoder h0(
	.hex_digit({2'b0, ones}),
	.segments(HEX0)
	);

	hex_decoder h1(
	.hex_digit(tens),
	.segments(HEX1)
	);

	hex_decoder h2(
	.hex_digit(hunds),
	.segments(HEX2)
	);
	
endmodule

module RateDivider(clock, resetn, d, count, enable);
    
input clock, resetn, enable;
input [27:0] d;
output [27:0] count;
 
reg [27:0] count; //counts down
 
    always @ (posedge clock)
    begin  
       	if (resetn) begin
	    if(enable == 1'b1) begin 
           	if(count== 0) begin
              	    count <= d;
           	end 
		else begin
              		count <= count - 1;
            	end
	     end
       	end else begin
           count <= d;
	end
    end
endmodule

module displayCounter(clock, resetn, parload, enable, q, d);
input clock;// declare clock
input resetn; // declare resetn
input [7:0] d; 
input parload, enable;// declare parload and enable
output [7:0] q; 

reg [7:0] q; // declare q

always @(posedge clock)// triggered every time clock rises
begin
	if(resetn == 1'b0) // when resetn is 0
		q <= d; // q is set to d
	else// increment q only when enable is 1
	begin
	if(q == 8'b0) // when q is the minimum value for the counter
		q <= d; // q reset to d
	else // when q is not the maximum value
		if (enable) begin
			q <= q - 1'b1; // decrement q
		end
		// q <= q - 1'b1; // decrement q
	end
end

endmodule

module mux3to1(select, q);

input [1:0] select; 
output [7:0] q;

reg [27:0] Q;

always 
@(*)
begin
	case(select [1:0])	
		2'b00: Q = 8'd120;
		2'b01: Q = 8'd60;
		2'b10: Q = 8'd30;
		2'b11: Q = 8'd120;
	endcase
end

assign q = Q;

endmodule


module add3(in,out);
input [3:0] in;
output [3:0] out;
reg [3:0] out;

always @ (in)
    case (in)
    4'b0000: out <= 4'b0000;  // 0 -> 0
    4'b0001: out <= 4'b0001;
    4'b0010: out <= 4'b0010;
    4'b0011: out <= 4'b0011; 
    4'b0100: out <= 4'b0100;  // 4 -> 4
    4'b0101: out <= 4'b1000;  // 5 -> 8
    4'b0110: out <= 4'b1001;  
    4'b0111: out <= 4'b1010;
    4'b1000: out <= 4'b1011;
    4'b1001: out <= 4'b1100;  // 9 -> 12
    default: out <= 4'b0000;
    endcase
endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule