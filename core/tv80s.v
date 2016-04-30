//
// TV80 8-Bit Microprocessor Core
// Based on the VHDL T80 core by Daniel Wallner (jesus@opencores.org)
//
// Copyright (c) 2004 Guy Hutchison (ghutchis@opencores.org)
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the 
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module tv80s (/*AUTOARG*/
  // Outputs
  m1_n, mreq_n, iorq_n, rd_n, wr_n, rfsh_n, halt_n, busak_n, A, dout, PC,HL,ACC,F,DE,
  // Inputs
  reset_n, clk, wait_n, int_n, nmi_n, busrq_n, di
  );

  parameter Mode = 3;    // 0 => Z80, 1 => Fast Z80, 2 => 8080, 3 => GB
  parameter T2Write = 1; // 0 => wr_n active in T3, /=0 => wr_n active in T2
  parameter IOWait  = 1; // 0 => Single cycle I/O, 1 => Std I/O cycle


  input         reset_n;  //reset active low
  input         clk;   //clk
  input         wait_n;  
  input         int_n;  //interrupt active low
  input         nmi_n;  //nmi active low
  input         busrq_n;  //request cpu to disable bus
  output        m1_n; //mi & mreq means cpu is in decode phase. m1 & iorq is interrupt acknowledge
  output        mreq_n; //address bus has valid address   
  output        iorq_n;  //request io using address
  output        rd_n;   //read active low
  output        wr_n;   //write active low
  output        rfsh_n; //lets ignore this for now no idea
  output        halt_n; //halted active low
  output        busak_n; //bus disabled active low
  output [15:0] A;   //address
  input [7:0]   di;   //data in 
  output [7:0]  dout; //data out
output [15:0] PC;
output [15:0] HL;
output [15:0] DE;
output [7:0] ACC;
output [7:0] F;
  reg           mreq_n; 
  reg           iorq_n; 
  reg           rd_n; 
  reg           wr_n; 
  
  wire          cen;
  wire          intcycle_n;
  wire          no_read;
  wire          write;
  wire          iorq;
  reg [7:0]     di_reg;
  wire [6:0]    mcycle;
  wire [6:0]    tstate;

  assign    cen = 1;

  tv80_core #(Mode, IOWait) i_tv80_core
    (
     .cen (cen),
     .m1_n (m1_n),
     .iorq (iorq),
     .no_read (no_read),
     .write (write),
     .rfsh_n (rfsh_n),
     .halt_n (halt_n),
     .wait_n (wait_n),
     .int_n (int_n),
     .nmi_n (nmi_n),
     .reset_n (reset_n),
     .busrq_n (busrq_n),
     .busak_n (busak_n),
     .clk (clk),
     .IntE (),
     .stop (),
     .A (A),
     .dinst (di),
     .di (di_reg),
     .do (dout),
     .mc (mcycle),
     .ts (tstate),
     .intcycle_n (intcycle_n),
	  .PC(PC),
	  .ACC(ACC),
	  .HL(HL),
	  .F(F),
	  .DE(DE)
     );  

  always @(posedge clk or negedge reset_n)
    begin
      if (!reset_n)
        begin
          rd_n   <= #1 1'b1;
          wr_n   <= #1 1'b1;
          iorq_n <= #1 1'b1;
          mreq_n <= #1 1'b1;
          di_reg <= #1 0;
        end
      else
        begin
          rd_n <= #1 1'b1;
          wr_n <= #1 1'b1;
          iorq_n <= #1 1'b1;
          mreq_n <= #1 1'b1;
          if (mcycle[0])
            begin
              if (tstate[1] || (tstate[2] && wait_n == 1'b0))
                begin
                  rd_n <= #1 ~ intcycle_n;
                  mreq_n <= #1 ~ intcycle_n;
                  iorq_n <= #1 intcycle_n;
                end
            `ifdef TV80_REFRESH
              if (tstate[3])
            mreq_n <= #1 1'b0;
            `endif
            end // if (mcycle[0])          
          else
            begin
              if ((tstate[1] || (tstate[2] && wait_n == 1'b0)) && no_read == 1'b0 && write == 1'b0)
                begin
                  rd_n <= #1 1'b0;
                  iorq_n <= #1 ~ iorq;
                  mreq_n <= #1 iorq;
                end
              if (T2Write == 0)
                begin                          
                  if (tstate[2] && write == 1'b1)
                    begin
                      wr_n <= #1 1'b0;
                      iorq_n <= #1 ~ iorq;
                      mreq_n <= #1 iorq;
                    end
                end
              else
                begin
                  if ((tstate[1] || (tstate[2] && wait_n == 1'b0)) && write == 1'b1)
                    begin
                      wr_n <= #1 1'b0;
                      iorq_n <= #1 ~ iorq;
                      mreq_n <= #1 iorq;
                  end
                end // else: !if(T2write == 0)
              
            end // else: !if(mcycle[0])
          
          if (tstate[2] && wait_n == 1'b1)
            di_reg <= #1 di;
        end // else: !if(!reset_n)
    end // always @ (posedge clk or negedge reset_n)
  
endmodule // t80s

