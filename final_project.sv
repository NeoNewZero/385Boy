/*---------------------------------------------------------------------------
  --      lab9.sv                                                          --
  --      Christine Chen                                                   --
  --      10/23/2013                                                       --
  --                                                                       --
  --      For use with ECE 298 Experiment 9                                --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/
// Top-level module that integrates the Nios II system with the rest of the hardware

module final_project(
				input logic CLOCK_50,
				input logic [17:0] SW,
				output logic [6:0] HEX0,
				output logic [6:0] HEX1,
				output logic [6:0] HEX2,
				output logic [6:0] HEX3,
				output logic [6:0] HEX4,
				output logic [6:0] HEX5,
				output logic [6:0] HEX6,
				output logic [6:0] HEX7,
				
				output logic [7:0] LEDG,
				output logic [17:0] LEDR,
				//vga
				output logic [7:0] VGA_R,
				output logic [7:0] VGA_G,
				output logic [7:0] VGA_B,
				output logic VGA_CLK,
				output logic VGA_BLANK_N,
				output logic VGA_SYNC_N,
				output logic VGA_HS,
				output logic VGA_VS,
				//dram
				output logic [12:0] DRAM_ADDR,
				output logic [1:0] DRAM_BA,
				output logic DRAM_CAS_N,
				output logic DRAM_CKE,
				output logic DRAM_CS_N,
				inout wire [31:0] DRAM_DQ,
				output wire [3:0] DRAM_DQM,
				output logic DRAM_RAS_N,
				output logic DRAM_WE_N,
				output logic DRAM_CLK,
				//sram
				inout logic [15:0] SRAM_DQ,
				output logic [19:0] SRAM_ADDR,
				output logic SRAM_LB_N,
				output logic SRAM_UB_N,
				output logic SRAM_CE_N,
				output logic SRAM_OE_N,
				output logic SRAM_WE_N,
				input logic [3:0] KEY,
				input logic TD_CLK27,
				input logic TD_RESET_N
				  
				  );
				  logic [15:0] BC, DE, PC, SP;
		logic gameboy_clk;
		logic ready;
		logic m1_n;
		logic mreq_n;
		logic iorq_n;
		logic rd_n;
		logic wr_n;
		logic rfsh_n;
		logic halt_n;
		logic busak_n;
		logic [15:0] A;
		logic [7:0] dout;
		logic wait_n;
		logic int_n;
		logic nmi_n;
		logic busrq_n;

		logic [7:0] di;
		logic aclk;
	logic [7:0] buttons;
	logic [7:0] DIV;
	logic [7:0] TIMA;
	logic [7:0] TMA;
	logic [7:0] TAC;
	logic [7:0] IF;
	logic [7:0] IE;
	logic [7:0] vdata;
	logic [15:0] vid_address;
	logic [7:0] ledtemp;
	logic [3:0] debug;
	logic [7:0] ACC;
	logic [7:0] F;
	logic [7:0] vpos;
	logic [15:0] HL;
	assign int_n = 1'b1;
	assign nmi_n = 1'b1;
	assign busrq_n = 1'b1;
	assign LEDR[3:0] = debug;
	assign LEDR[4] = ~rd_n;
	assign LEDR[5] = ~wr_n;
	assign LEDR[6] = ~mreq_n;
	assign LEDR[7] = ~wait_n;
		nios_system cpu (
		.clk_clk(CLOCK_50),              //            clk.clk
		.reset_reset_n(KEY[0]),        //          reset.reset_n
		.switches_export(SW),      //       switches.export
		.leds_export(ledtemp),          //           leds.export
		.sdram_wire_addr(DRAM_ADDR),      //     sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),        //               .ba
		.sdram_wire_cas_n(DRAM_CAS_N),     //               .cas_n
		.sdram_wire_cke(DRAM_CKE),       //               .cke
		.sdram_wire_cs_n(DRAM_CS_N),      //               .cs_n
		.sdram_wire_dq(DRAM_DQ),        //               .dq
		.sdram_wire_dqm(DRAM_DQM),       //               .dqm
		.sdram_wire_ras_n(DRAM_RAS_N),     //               .ras_n
		.sdram_wire_we_n(DRAM_WE_N),      //               .we_n
		.sdram_clk_clk(DRAM_CLK),        //      sdram_clk.clk
		.sram_DQ(SRAM_DQ),              //           sram.DQ
		.sram_ADDR(SRAM_ADDR),            //               .ADDR
		.sram_LB_N(SRAM_LB_N),            //               .LB_N
		.sram_UB_N(SRAM_UB_N),            //               .UB_N
		.sram_CE_N(SRAM_CE_N),            //               .CE_N
		.sram_OE_N(SRAM_OE_N),            //               .OE_N
		.sram_WE_N(SRAM_WE_N),            //               .WE_N
		.vga_controller_CLK(VGA_CLK),   // vga_controller.CLK
		.vga_controller_HS(VGA_HS),    //               .HS
		.vga_controller_VS(VGA_VS),    //               .VS
		.vga_controller_BLANK(VGA_BLANK_N), //               .BLANK
		.vga_controller_SYNC(VGA_SYNC_N),  //               .SYNC
		.vga_controller_R(VGA_R),     //               .R
		.vga_controller_G(VGA_G),     //               .G
		.vga_controller_B(VGA_B),     //               .B
		.buttons_export(KEY),
		.address_export(vid_address),		//           addr.export
		.din_export(vdata),
		.gameboy_clk_clk(gameboy_clk)      //    gameboy_clk.cl
		);
//assign gameboy_clk = KEY[1];
	mem_unit mu(
	.clk(gameboy_clk),
	.z80_mreq_n(mreq_n),
	.z80_read_n(rd_n),
	.z80_write_n(wr_n),
	.z80_address(A),
	.z80_dout(dout),
	.z80_din(di),
	.z80_wait_n(wait_n),
	.vid_address,
	.vdata,
	.Reset(~KEY[0]),
	.buttons,
	.DIV,
	.TIMA,
	.TMA,
	.TAC,
	.IF,
	.IE

);
divider gameBoyClkDiv
(
	.clk_in(CLOCK_50),
	.Reset(~KEY[0]),
	.clk_out(gameboy_clk)

);

assign LEDG[2] = ~mreq_n;

 HexDriver hex_inst_0 (di[3:0], HEX0);
	 HexDriver hex_inst_1 (di[7:4], HEX1);
	  HexDriver hex_inst_2 (PC[3:0], HEX2);
	  HexDriver hex_inst_3 (PC[7:4], HEX3);
	HexDriver hex_inst_4 (PC[11:8], HEX4);
	  HexDriver hex_inst_5 (PC[15:12], HEX5);
  HexDriver hex_inst_6 (ACC[3:0], HEX6);
	  HexDriver hex_inst_7 (ACC[7:4], HEX7);


	
	tv80s z80 (
  .m1_n, .mreq_n, .iorq_n, .rd_n, .wr_n, .rfsh_n, .halt_n, .busak_n, .A, .dout(dout),.ACC,.F,.HL,.PC,.DE,
  .reset_n(KEY[2]), .clk(gameboy_clk & ((PC<SW[15:0])|~(KEY[1]))), .wait_n, .int_n, .nmi_n, .busrq_n, .di
  );
													  
endmodule

