/*---------------------------------------------------------------------------
  --      AES.sv                                                           --
  --      Joe Meng                                                         --
  --      Fall 2013                                                        --
  --                                                                       --
  --      For use with ECE 298 Experiment 9                                --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/

// AES module interface with all ports, commented for Week 1
 module  AES ( input  [127:0]  In,
                               Cipherkey,
               input           Clk, 
                               Reset,
               output [127:0]  Ciphertext,
               output          Ready,
					input logic[3:0] counter,
					output logic [127:0] lastrkey);

// Partial interface for Week 1
// Splitting the signals into 32-bit ones for compatibility with ModelSim
	logic [127:0] aesstate;	
		logic [127:0] next_aesstate;	

	logic [0:1407] keyschedule;	 
	logic [0:10][127:0] keyArray;
	assign keyArray[10] = keyschedule[0:127];
	assign keyArray[9] = keyschedule[128:255];
	assign keyArray[8] = keyschedule[256:383];
	assign keyArray[7] = keyschedule[384:511];
	assign keyArray[6] = keyschedule[512:639];
	assign keyArray[5] = keyschedule[640:767];
	assign keyArray[4] = keyschedule[768:895];
	assign keyArray[3] = keyschedule[896:1023];
	assign keyArray[2] = keyschedule[1024:1151];
	assign keyArray[1] = keyschedule[1152:1279];
	assign keyArray[0] = keyschedule[1280:1407];
	
	assign lastrkey = isb0_out ^ keyArray[1];
	KeyExpansion keyexpansion_0(
	.clk(Clk),
	.Cipherkey(Cipherkey),
	.KeySchedule(keyschedule)
	);
	
	logic [127:0] isr0_out,isb0_out,imc0_out;
	InvShiftRowsBig isr0(
	.in(aesstate),
	.out(isr0_out)
	);
	 InvSubBytesBig isb0( .clk(Clk),
							.in(isr0_out),
                    .out(isb0_out) 
		);
		InvMixColumnsBig imc0(
							.in(isb0_out ^ keyArray[counter]) ,
                     .out(imc0_out) );
assign Ciphertext = aesstate;
						
always_ff @ (posedge Clk) begin
		if(counter == 0)  //0
		begin
			Ready = 1'b0;
			aesstate = keyArray[0] ^ In;
		end
//		else if(counter == 10)  //10
//		begin
//			Ready = 1'b0;
//			next_aesstate = isb0_out ^ keyArray[counter];
//		end
		else if(counter > 1)
			begin
			Ready = 1'b1;
			end
		else
		begin
			Ready = 1'b0;
		end
end
endmodule

