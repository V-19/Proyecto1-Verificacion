//////////////////////////////////////////////////////////////////////
////                                                              ////
////                                                              ////
////  This file is part of the SDRAM Controller project           ////
////  http://www.opencores.org/cores/sdr_ctrl/                    ////
////                                                              ////
////  Description                                                 ////
////  SDRAM CTRL definitions.                                     ////
////                                                              ////
////  To Do:                                                      ////
////    nothing                                                   ////
////                                                              ////
//   Version  :0.1 - Test Bench automation is improvised with     ////
//             seperate data,address,burst length fifo.           ////
//             Now user can create different write and            ////
//             read sequence                                      ////
//                                                                ////
////  Author(s):                                                  ////
////      - Dinesh Annayya, dinesha@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
`include "interfase_wishbone.sv"
`include "interfase_SRAM.sv"
`include "stimulus.sv"
`include "scoreboard.sv"
`include "driver.sv"
`include "monitor_write.sv"
`include "monitor_read.sv"
`include "environment.sv"
`include "test1.sv"



`timescale 1ns/1ps

// This testbench verify with SDRAM TOP

module tb_top;

parameter P_SYS  = 10;     //    200MHz
parameter P_SDR  = 20;     //    100MHz

//-------------------------------------------
// SRAM Interface
//-------------------------------------------  

intf_SRAM_G2 intf_SRAM(); 

//-------------------------------------------
// WISH BONE Interface
//-------------------------------------------  
intf_WB_G2 intf_WB();  
  

// General
//reg            RESETN;
//reg            sdram_clk;
//reg            sys_clk;

initial intf_WB.sys_clk = 0;
initial intf_WB.sdram_clk = 0;

always #(P_SYS/2) intf_WB.sys_clk = !intf_WB.sys_clk;
always #(P_SDR/2) intf_WB.sdram_clk = ! intf_WB.sdram_clk;

parameter      dw              = 32;  // data width
parameter      tw              = 8;   // tag id width
parameter      bl              = 5;   // burst_lenght_width 

  

// to fix the sdram interface timing issue
wire #(2.0)  sdram_clk_d   =  intf_WB.sdram_clk;

//`ifdef SDR_32BIT

   sdrc_top #(.SDR_DW(32),.SDR_BW(4)) u_dut(
/*`elsif SDR_16BIT 
   sdrc_top #(.SDR_DW(16),.SDR_BW(2)) u_dut(
`else  // 8 BIT SDRAM
   sdrc_top #(.SDR_DW(8),.SDR_BW(1)) u_dut(
`endif*/
      // System 
//`ifdef SDR_32BIT
          .cfg_sdr_width      (2'b00              ), // 32 BIT SDRAM
/*`elsif SDR_16BIT
          .cfg_sdr_width      (2'b01              ), // 16 BIT SDRAM
`else 
          .cfg_sdr_width      (2'b10              ), // 8 BIT SDRAM
`endif*/
          .cfg_colbits        (2'b00              ), // 8 Bit Column Address

/* WISH BONE */
          .wb_rst_i           (!intf_WB.RESETN            ),
          .wb_clk_i           (intf_WB.sys_clk            ),

     	  .wb_stb_i           (intf_WB.wb_stb_i           ),
     	  .wb_ack_o           (intf_WB.wb_ack_o           ),
          .wb_addr_i          (intf_WB.wb_addr_i          ),
          .wb_we_i            (intf_WB.wb_we_i            ),
          .wb_dat_i           (intf_WB.wb_dat_i           ),
          .wb_sel_i           (intf_WB.wb_sel_i           ),
          .wb_dat_o           (intf_WB.wb_dat_o           ),
          .wb_cyc_i           (intf_WB.wb_cyc_i           ),
          .wb_cti_i           (intf_WB.wb_cti_i           ), 

/* Interface to SDRAMs */
          .sdram_clk          (intf_WB.sdram_clk          ),
          .sdram_resetn       (intf_WB.RESETN             ),
          .sdr_cs_n           (intf_SRAM.sdr_cs_n           ),
          .sdr_cke            (intf_SRAM.sdr_cke            ),
          .sdr_ras_n          (intf_SRAM.sdr_ras_n          ),
          .sdr_cas_n          (intf_SRAM.sdr_cas_n          ),
          .sdr_we_n           (intf_SRAM.sdr_we_n           ),
          .sdr_dqm            (intf_SRAM.sdr_dqm            ),
          .sdr_ba             (intf_SRAM.sdr_ba             ),
          .sdr_addr           (intf_SRAM.sdr_addr           ), 
     	  .sdr_dq             (intf_SRAM.Dq            ),

    /* Parameters */
     	  .sdr_init_done      (intf_WB.sdr_init_done      ),
          .cfg_req_depth      (2'h3               ),            //how many req. buffer should hold
          .cfg_sdr_en         (1'b1               ),
          .cfg_sdr_mode_reg   (13'h033            ),
          .cfg_sdr_tras_d     (4'h4               ),
          .cfg_sdr_trp_d      (4'h2               ),
          .cfg_sdr_trcd_d     (4'h2               ),
          .cfg_sdr_cas        (3'h3               ),
          .cfg_sdr_trcar_d    (4'h7               ),
          .cfg_sdr_twr_d      (4'h1               ),
          .cfg_sdr_rfsh       (12'h100            ), // reduced from 12'hC35
          .cfg_sdr_rfmax      (3'h6               )

);


     
//`ifdef SDR_32BIT
mt48lc2m32b2 #(.data_bits(32)) u_sdram32 (
 		  .Dq                 (intf_SRAM.Dq      ) , 
          .Addr               (intf_SRAM.sdr_addr[10:0]     ), 
          .Ba                 (intf_SRAM.sdr_ba             ), 
          .Clk                (sdram_clk_d        ), 
          .Cke                (intf_SRAM.sdr_cke            ), 
          .Cs_n               (intf_SRAM.sdr_cs_n           ), 
          .Ras_n              (intf_SRAM.sdr_ras_n          ), 
          .Cas_n              (intf_SRAM.sdr_cas_n          ), 
          .We_n               (intf_SRAM.sdr_we_n           ), 
          .Dqm                (intf_SRAM.sdr_dqm    )
     );

/*`elsif SDR_16BIT

   IS42VM16400K u_sdram16 (
     	  .dq                 (intf_SRAM.Dq            ), 
          .addr               (intf_SRAM.sdr_addr[11:0]     ), 
          .ba                 (intf_SRAM.sdr_ba             ), 
          .clk                (sdram_clk_d        ), 
          .cke                (intf_SRAM.sdr_cke            ), 
          .csb                (intf_SRAM.sdr_cs_n           ), 
          .rasb               (intf_SRAM.sdr_ras_n          ), 
          .casb               (intf_SRAM.sdr_cas_n          ), 
          .web                (intf_SRAM.sdr_we_n           ), 
          .dqm                (intf_SRAM.sdr_dqm           )
    );
`else 


mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
  		  .Dq                 (intf_SRAM.Dq                ) , 
          .Addr               (intf_SRAM.sdr_addr[11:0]     ), 
          .Ba                 (intf_SRAM.sdr_ba             ), 
          .Clk                (sdram_clk_d        ), 
          .Cke                (intf_SRAM.sdr_cke            ), 
          .Cs_n               (intf_SRAM.sdr_cs_n           ), 
          .Ras_n              (intf_SRAM.sdr_ras_n          ), 
          .Cas_n              (intf_SRAM.sdr_cas_n          ), 
          .We_n               (intf_SRAM.sdr_we_n           ), 
          .Dqm                (intf_SRAM.sdr_dqm            )
     );
`endif*/


/////////////////////////////////////////////////////////////////////////
// Test Case
/////////////////////////////////////////////////////////////////////////


   
testcase test1(intf_WB,intf_SRAM);
     





endmodule