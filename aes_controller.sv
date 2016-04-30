/*---------------------------------------------------------------------------
  --      aes_controller.sv                                                --
  --      Christine Chen                                                   --
  --      10/29/2013                                                       --
  --                                                                       --
  --      For use with ECE 298 Experiment 9                                --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/
// AES controller module

module aes_controller(
				input			 		clk,
				input logic step,
				input					reset_n,
				input	[127:0]			msg_en,
				input	[127:0]			key,
				output  [127:0]			msg_de,
				input					io_ready,
				output logic aes_ready
				,output logic [127:0] lastrkey
			    );

enum logic [5:0] {WAIT,ROUND1, COMPUTE, COMPUTE2,COMPUTE3,COMPUTE4,COMPUTE5, FINAL,READY} state, next_state;
logic [3:0] counter;
logic [3:0] roundcounter;

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
	
	
	logic [127:0] aesstate,next_aes;
	assign msg_de = aesstate;
	assign lastrkey = aesstate;
	logic [127:0] isr0_out,isb0_out,imc0_out;
	InvShiftRowsBig isr0(
	.in(aesstate),
	.out(isr0_out)
	);
	 InvSubBytesBig isb0( .clk(clk),
							.in(isr0_out),
                    .out(isb0_out) 
		);
		InvMixColumnsBig imc0(
							.in(isb0_out ^ keyArray[counter]) ,
                     .out(imc0_out) );
							
	KeyExpansion keyexpansion_0(
	.clk(clk),
	.Cipherkey(key),
	.KeySchedule(keyschedule)
	);
 logic aesthing;
//AES aes0( .In(msg_en),
//           .Cipherkey(key),
//            .Clk(clk), 
//            .Reset(reset_n),
//               .Ciphertext(msg_de),
//               .Ready(aesthing),
//					.counter,.lastrkey);
					
always_ff @ (posedge clk, negedge reset_n) begin
	if (reset_n == 1'b0) begin
		state <= WAIT;
		counter <= 4'd1;
		roundcounter <= 4'd0;
	end else begin
		state <= next_state;
		if(state == ROUND1)
			begin
					aesstate <= msg_en ^ keyArray[0];
			end
		else
		if (state == COMPUTE5)
			begin
			aesstate <= imc0_out;
			counter <= counter + 1'b1;
			
//
//			roundcounter <= roundcounter + 1'b1;
//			if(roundcounter == 7
//				begin
//					roundcounter <= 0;
//					counter <= counter +1'b1;
//				end
		end
		else if(state==FINAL)
			aesstate <= isb0_out ^ keyArray[counter];
		else
			aesstate <= aesstate;
	end
end
always_comb begin
	next_state = state;
	case (state)
		WAIT: begin
			if (io_ready)
				next_state = ROUND1;
		end
		ROUND1: begin
			   next_state = COMPUTE;
		end

		COMPUTE: begin
				if(counter == 4'b1010)
					next_state = FINAL;
				else
				next_state = COMPUTE2;
			
		end
		COMPUTE2: begin
				next_state = COMPUTE3;
		
		end
		COMPUTE3: begin
			next_state = COMPUTE4;
		end
		COMPUTE4: begin
			next_state = COMPUTE5;
		end
		COMPUTE5: begin
			next_state = COMPUTE;
		end
		FINAL: begin
			next_state = READY;
		end		
		READY: begin
		end
	endcase
end

always_comb begin
	aes_ready = 1'b0;
	case (state)
		WAIT: begin
			aes_ready = 1'b0;
		end
		ROUND1: begin
			aes_ready = 1'b0;
		end
		
		COMPUTE: begin
			aes_ready = 1'b0;
		end
		
		FINAL: begin
			aes_ready = 1'b0;
		end
		READY: begin
			aes_ready = 1'b1;
		end
	endcase
end
			  
endmodule