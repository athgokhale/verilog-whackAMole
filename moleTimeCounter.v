module moleTimeCounter(clock, out, resetn, play, enable);

input resetn, enable;
output [24:0] out;
reg[24:0] counter;
reg[24:0] counter_next;

input clock;

always @(play && enable) begin
	if (counter == 25'd0) begin
		counter_next = 25'd24999999;
	end
	else begin
		counter_next = counter - 1;
	end
end

always @(posedge clock or negedge resetn) begin
	if (!resetn)
		counter <= 25'd24999999;
	else
		counter <= counter_next;
end

assign out = counter;

endmodule
