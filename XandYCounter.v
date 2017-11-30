module xAndYCounter(clock, resetn, x, y);
input clock, resetn;
output [7:0] x;
output [6:0] y;

wire [7:0] xTemp;
wire [6:0] yTemp;
 
xCounter countX(
.clock(clock),
.resetn(resetn),
.x(xTemp)
);

yCounter countY(
.clock(clock),
.resetn(resetn),
.x(xTemp),
.y(yTemp)
);

assign x = xTemp;
assign y = yTemp;
endmodule


module xCounter(clock, resetn, x);

input resetn;
output[7:0] x;
reg[7:0] counter;
reg[7:0] counter_next;

input clock;

always @(*) begin
	if (counter == 8'd160) begin
		counter_next = 8'b0;
	end
	else begin
	counter_next = counter + 1;
	end
end

always @(posedge clock or negedge resetn) begin
	if (!resetn)
		counter <= 8'b0;
	else
		counter <= counter_next;
end

assign x = counter;


endmodule

module yCounter(clock, resetn, x, y);

input resetn;
input [7:0] x;
output[6:0] y;
reg[6:0] counter;
reg[6:0] counter_next;

input clock;

always @(*) begin
	if (x == 8'd160) begin
		counter_next = counter + 1;
	end
end

always @(posedge clock or negedge resetn) begin
	if (!resetn)
		counter <= 7'b0;
	else
		counter <= counter_next;
end

assign out = counter;
endmodule
