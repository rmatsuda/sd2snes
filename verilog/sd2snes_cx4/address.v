`timescale 1 ns / 1 ns
//////////////////////////////////////////////////////////////////////////////////
// Company: Rehkopf
// Engineer: Rehkopf
// 
// Create Date:    01:13:46 05/09/2009 
// Design Name: 
// Module Name:    address 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Address logic w/ SaveRAM masking
//
// Dependencies: 
//
// Revision: 
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module address(
  input CLK,
  input [2:0] MAPPER,       // MCU detected mapper
  input [23:0] SNES_ADDR,   // requested address from SNES
  input [7:0] SNES_PA,      // peripheral address from SNES
  input SNES_CS,            // SNES ROMSEL signal
  output [23:0] ROM_ADDR,   // Address to request from SRAM0
  output ROM_SEL,           // enable SRAM0 (active low)
  output IS_SAVERAM,        // address/CS mapped as SRAM?
  output IS_ROM,            // address mapped as ROM?
  output IS_WRITABLE,       // address somehow mapped as writable area?
  input [23:0] SAVERAM_MASK,
  input [23:0] ROM_MASK,
  input use_msu1,
  output msu_enable,
  output cx4_enable,
  output cx4_vect_enable,
  output r213f_enable,
  output snescmd_rd_enable,
  output snescmd_wr_enable
);

wire [23:0] SRAM_SNES_ADDR;

/* Cx4 mapper:
   - LoROM (extended to 00-7d, 80-ff)
   - MMIO @ 6000-7fff
 */

assign IS_ROM = ~SNES_CS;

assign SRAM_SNES_ADDR = ({2'b00, SNES_ADDR[22:16], SNES_ADDR[14:0]}
                               & ROM_MASK);

assign ROM_ADDR = SRAM_SNES_ADDR;

assign ROM_SEL = 1'b0;

wire msu_enable_w = use_msu1 & (!SNES_ADDR[22] && ((SNES_ADDR[15:0] & 16'hfff8) == 16'h2000));
assign msu_enable = msu_enable_w;

wire cx4_enable_w = (!SNES_ADDR[22] && (SNES_ADDR[15:13] == 3'b011));
assign cx4_enable = cx4_enable_w;

assign cx4_vect_enable = &SNES_ADDR[15:5];

wire r213f_enable_w = (SNES_PA == 8'h3f);
assign r213f_enable = r213f_enable_w;

wire snescmd_rd_enable_w = (SNES_PA[7:4] == 4'b1111);
assign snescmd_rd_enable = snescmd_rd_enable_w;

wire snescmd_wr_enable_w = (SNES_ADDR[23:4] == 20'hccccc);
assign snescmd_wr_enable = snescmd_wr_enable_w;

endmodule
