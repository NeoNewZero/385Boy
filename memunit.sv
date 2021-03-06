module mem_unit(
	input logic clk,
	input logic z80_mreq_n,
	input logic z80_read_n,
	input logic z80_write_n,
	input logic [15:0] z80_address,
	input logic [7:0] z80_dout,
	output logic [7:0] z80_din,
	output logic z80_wait_n,
	input logic [15:0] vid_address,
	output logic [7:0] vdata,
	input logic Reset,
	input logic [7:0] buttons,
	input logic [7:0] DIV,
	input logic [7:0] TIMA,
	output logic [7:0] TMA,
	output logic [7:0] TAC,
	input logic [7:0] IF,
	output logic [7:0] IE
	
);

logic [7:0] bootrom [256];
logic [7:0] mainram [65536];
logic [7:0] outval;
logic bootrom_enabled = 1'b1;
assign z80_wait_n = 1'b1;
//assign IE = mainram[16'hFFFF];
//assign TMA = mainram[16'hFF06];
//assign TAC = mainram[16'hFF07];



initial begin
    $readmemh("boot.rom.txt", bootrom, 0, 255);
	 $readmemh("tetris.txt", mainram, 0, 26210);
  end
  
always_comb
begin
			vdata = mainram[vid_address];
end

always_ff @ (posedge clk)
    begin 
		if(~z80_write_n)
			begin
				mainram[z80_address] = z80_dout;
			if((z80_address == 16'hFF50)&&(z80_dout==8'h01))
			begin
				bootrom_enabled <= 0;
				end
			end
				if((bootrom_enabled)&&(z80_address<256))
				begin
			
						z80_din = bootrom[z80_address];
				end
			else
				begin
				case(z80_address)
			16'hFF00:
				begin
					z80_din = buttons;
				end
			16'hFF04:
				begin
					z80_din = DIV;
				end
			16'hFF05:
				begin
					z80_din = TIMA;
				end
			16'hFF0F: //IF
				begin
					z80_din = IF;
				end
			default:
				begin
					z80_din = mainram[z80_address];
				end
		endcase
				end
				
		
    end
endmodule
