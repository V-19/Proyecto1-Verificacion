program testcase(intf_WB_G2 vir_intf_WB, intf_SRAM_G2 vir_intf_SRAM);
  environment env = new(vir_intf_WB,vir_intf_SRAM);
  
  int k;
  initial
    begin
  env.drvr.reset();
  #1000;
  wait(u_dut.sdr_init_done == 1);
  #1000;
  $display("-------------------------------------- ");
  $display(" Case-1: Single Write/Read Case        ");
  $display("-------------------------------------- ");

  env.drvr.burst_write(8'h4);
 
 #1000;
  env.drvr.burst_read(8'h4);
  
  
   #100;
  // Repeat one more time to analysis the 
  // SDRAM state change for same col/row address
  $display("-------------------------------------- ");
  $display(" Case-2: Repeat same transfer once again ");
  $display("----------------------------------------");
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4); 
  
   /* 
      #100;
  $display("----------------------------------------");
  $display(" Case-3 Create a Page Cross Over        ");
  $display("----------------------------------------");
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4); 
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4); 
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);  
  env.drvr.burst_write(8'h4);
  env.drvr.burst_write(8'h4); 
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  env.drvr.burst_read(8'h4);  
  #100;
      /*
  $display("----------------------------------------");
  $display(" Case:4 4 Write & 4 Read                ");
  $display("----------------------------------------");
  env.drvr.burst_write();  
  env.drvr.burst_write();  
  env.drvr.burst_write();  
  env.drvr.burst_write();  
  env.drvr.burst_read();  
  env.drvr.burst_read();  
  env.drvr.burst_read();  
  env.drvr.burst_read();  

  $display("---------------------------------------");
  $display(" Case:5 24 Write & 24 Read With Different Bank and Row ");
  $display("---------------------------------------");
  //----------------------------------------
  // Address Decodeing:
  //  with cfg_col bit configured as: 00
  //    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
  //
  drvr.burst_write({12'h000,2'b00,8'h00,2'b00},8'h4);   // Row: 0 Bank : 0
  drvr.burst_write({12'h000,2'b01,8'h00,2'b00},8'h5);   // Row: 0 Bank : 1
  drvr.burst_write({12'h000,2'b10,8'h00,2'b00},8'h6);   // Row: 0 Bank : 2
  drvr.burst_write({12'h000,2'b11,8'h00,2'b00},8'h7);   // Row: 0 Bank : 3
  drvr.burst_write({12'h001,2'b00,8'h00,2'b00},8'h4);   // Row: 1 Bank : 0
  drvr.burst_write({12'h001,2'b01,8'h00,2'b00},8'h5);   // Row: 1 Bank : 1
  drvr.burst_write({12'h001,2'b10,8'h00,2'b00},8'h6);   // Row: 1 Bank : 2
  drvr.burst_write({12'h001,2'b11,8'h00,2'b00},8'h7);   // Row: 1 Bank : 3
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  

  drvr.burst_write({12'h002,2'b00,8'h00,2'b00},8'h4);   // Row: 2 Bank : 0
  drvr.burst_write({12'h002,2'b01,8'h00,2'b00},8'h5);   // Row: 2 Bank : 1
  drvr.burst_write({12'h002,2'b10,8'h00,2'b00},8'h6);   // Row: 2 Bank : 2
  drvr.burst_write({12'h002,2'b11,8'h00,2'b00},8'h7);   // Row: 2 Bank : 3
  drvr.burst_write({12'h003,2'b00,8'h00,2'b00},8'h4);   // Row: 3 Bank : 0
  drvr.burst_write({12'h003,2'b01,8'h00,2'b00},8'h5);   // Row: 3 Bank : 1
  drvr.burst_write({12'h003,2'b10,8'h00,2'b00},8'h6);   // Row: 3 Bank : 2
  drvr.burst_write({12'h003,2'b11,8'h00,2'b00},8'h7);   // Row: 3 Bank : 3

  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  

  drvr.burst_write({12'h002,2'b00,8'h00,2'b00},8'h4);   // Row: 2 Bank : 0
  drvr.burst_write({12'h002,2'b01,8'h01,2'b00},8'h5);   // Row: 2 Bank : 1
  drvr.burst_write({12'h002,2'b10,8'h02,2'b00},8'h6);   // Row: 2 Bank : 2
  drvr.burst_write({12'h002,2'b11,8'h03,2'b00},8'h7);   // Row: 2 Bank : 3
  drvr.burst_write({12'h003,2'b00,8'h04,2'b00},8'h4);   // Row: 3 Bank : 0
  drvr.burst_write({12'h003,2'b01,8'h05,2'b00},8'h5);   // Row: 3 Bank : 1
  drvr.burst_write({12'h003,2'b10,8'h06,2'b00},8'h6);   // Row: 3 Bank : 2
  drvr.burst_write({12'h003,2'b11,8'h07,2'b00},8'h7);   // Row: 3 Bank : 3

  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  drvr.burst_read();  
  
  #100;
  $display("---------------------------------------------------");
  $display(" Case: 6 Random 2 write and 2 read random");
  $display("---------------------------------------------------");
  for(k=0; k < 20; k++) begin
     //intf_WB.StartAddr = 32'h0017_0FAC;
     env.drvr.burst_write();  
 #100;

     //intf_WB.StartAddr = 32'h0017_0FAC;
     env.drvr.burst_write();  
 #100;
     env.drvr.burst_read();  
 #100;
     env.drvr.burst_read();  
 #100;
  end

  
  */
  
  #10000;
 

        $display("###############################");
    if(intf_WB.ErrCnt == 0)
        $display("STATUS: SDRAM Write/Read TEST PASSED");
    else
        $display("ERROR:  SDRAM Write/Read TEST FAILED");
        $display("###############################");
  $display("Errorcnt %d Error:",intf_WB.ErrCnt);
    $finish;
    
    end
endprogram
