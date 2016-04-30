module timer(
	input logic clk,
	input Reset,
	input logic int_a,
	output logic irq,
	input logic [15:0] address,
	input logic [7:0] din,
	input logic we_n,
	input logic [7:0] TAC,
	input logic [7:0] TMA,
	output logic [7:0] DIV,
	output logic [7:0] TIMA
	
);

enum logic [1:0] {IDLE,INT} state, next_state;

logic main_clk;
logic [7:0] count,next_count;
logic [7:0] divider,next_div;
assign DIV = divider;
assign TIMA = count;
logic [31:0] clk_counter;
logic [31:0] div_counter;
logic [31:0] reset_point;
always_comb
begin
if(TAC[1:0]==2'b00)
	reset_point = 20;
else if(TAC[1:0]==2'b01)
	reset_point = 200000;
else if(TAC[1:0]==2'b10)
	reset_point = 200000;
else  //11
	reset_point =200000 ;
end

always_comb  //state actions
begin
	irq = 1'b0;
	if(state == INT)
		begin
			irq = 1'b1;
		end
end

always_comb //next state
begin
next_state = state;
next_count = count;
next_div = divider + 1;

if(state == INT)
	begin
		if(int_a == 1'b1)
			next_state = IDLE;
	end

if(TAC[2] == 1'b1)
	begin
		if(count==8'hFF) //overflow
			begin
				next_state = INT;
				next_count = TMA;
			end
		else
			begin
				next_count = count + 1;
			end
	end
	
if(~we_n && (address == 16'hFF04))
	next_div = 0;
	
if(~we_n && (address == 16'hFF05))
	next_count = din;
	
end
always_ff @ (posedge clk or posedge Reset)
    begin 
	 if(Reset)
		begin
			state <= IDLE;
			clk_counter <=0;
			div_counter <=0;
			divider <=0;
			count <=0;
		end
	else
		begin
			state <= next_state;
			if(~we_n && (address == 16'hFF05))
				count <= next_count;
			else
			begin
		if(clk_counter >= reset_point)
			begin
				count<=next_count;
				clk_counter <= 0;
			end
		else
			clk_counter <= clk_counter+1;
			end
		if(~we_n && (address == 16'hFF04))
				divider <= next_div;
		else
			begin
		if(div_counter >= 10)
			begin
				divider <= next_div;
				div_counter<=0;
			end
		else
			div_counter<=div_counter+1;
		end
	
    end
	 end

endmodule
