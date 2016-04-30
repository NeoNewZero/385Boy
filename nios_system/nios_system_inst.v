	nios_system u0 (
		.buttons_export       (<connected-to-buttons_export>),       //        buttons.export
		.clk_clk              (<connected-to-clk_clk>),              //            clk.clk
		.gameboy_clk_clk      (<connected-to-gameboy_clk_clk>),      //    gameboy_clk.clk
		.leds_export          (<connected-to-leds_export>),          //           leds.export
		.reset_reset_n        (<connected-to-reset_reset_n>),        //          reset.reset_n
		.sdram_clk_clk        (<connected-to-sdram_clk_clk>),        //      sdram_clk.clk
		.sdram_wire_addr      (<connected-to-sdram_wire_addr>),      //     sdram_wire.addr
		.sdram_wire_ba        (<connected-to-sdram_wire_ba>),        //               .ba
		.sdram_wire_cas_n     (<connected-to-sdram_wire_cas_n>),     //               .cas_n
		.sdram_wire_cke       (<connected-to-sdram_wire_cke>),       //               .cke
		.sdram_wire_cs_n      (<connected-to-sdram_wire_cs_n>),      //               .cs_n
		.sdram_wire_dq        (<connected-to-sdram_wire_dq>),        //               .dq
		.sdram_wire_dqm       (<connected-to-sdram_wire_dqm>),       //               .dqm
		.sdram_wire_ras_n     (<connected-to-sdram_wire_ras_n>),     //               .ras_n
		.sdram_wire_we_n      (<connected-to-sdram_wire_we_n>),      //               .we_n
		.sram_DQ              (<connected-to-sram_DQ>),              //           sram.DQ
		.sram_ADDR            (<connected-to-sram_ADDR>),            //               .ADDR
		.sram_LB_N            (<connected-to-sram_LB_N>),            //               .LB_N
		.sram_UB_N            (<connected-to-sram_UB_N>),            //               .UB_N
		.sram_CE_N            (<connected-to-sram_CE_N>),            //               .CE_N
		.sram_OE_N            (<connected-to-sram_OE_N>),            //               .OE_N
		.sram_WE_N            (<connected-to-sram_WE_N>),            //               .WE_N
		.switches_export      (<connected-to-switches_export>),      //       switches.export
		.vga_controller_CLK   (<connected-to-vga_controller_CLK>),   // vga_controller.CLK
		.vga_controller_HS    (<connected-to-vga_controller_HS>),    //               .HS
		.vga_controller_VS    (<connected-to-vga_controller_VS>),    //               .VS
		.vga_controller_BLANK (<connected-to-vga_controller_BLANK>), //               .BLANK
		.vga_controller_SYNC  (<connected-to-vga_controller_SYNC>),  //               .SYNC
		.vga_controller_R     (<connected-to-vga_controller_R>),     //               .R
		.vga_controller_G     (<connected-to-vga_controller_G>),     //               .G
		.vga_controller_B     (<connected-to-vga_controller_B>),     //               .B
		.din_export           (<connected-to-din_export>),           //            din.export
		.address_export       (<connected-to-address_export>)        //        address.export
	);

