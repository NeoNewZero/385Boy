module divider #(parameter regwidth = 8,parameter resetPoint=12)
(
	input logic clk_in,
	input logic Reset,
	output logic clk_out

);
logic [regwidth-1:0] counter= 0;
logic curclk = 0;
assign clk_out = curclk;
always_ff @ (posedge clk_in or posedge Reset )
    begin 
        if (Reset) 
			begin
            counter <= 0;
				curclk <= 0;
				end
        else
		  begin
				counter <= counter + 1;
				if(counter==resetPoint)
					begin
					counter <= 0;
					curclk <= ~ (curclk);
					end
		  end
		
    end
   

endmodule
