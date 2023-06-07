class environment;
  driver drvr;
  scoreboard sb;
  monitor_write mntrw;
  monitor_read mntrr;
  
  virtual intf_WB_G2 vir_intf_WB;
  virtual intf_SRAM_G2 vir_intf_SRAM;
           
  function new(virtual intf_WB_G2 vir_intf_WB, virtual intf_SRAM_G2 vir_intf_SRAM);
    $display("Creating environment");
    this.vir_intf_WB = vir_intf_WB;
    this.vir_intf_SRAM=vir_intf_SRAM;
    sb = new();
    drvr = new(vir_intf_WB,vir_intf_SRAM,sb);
    mntrw = new(vir_intf_WB,vir_intf_SRAM,sb);
    mntrr = new(vir_intf_WB,vir_intf_SRAM,sb);
    fork 
      mntrr.check();
      mntrw.check();
    join_none
  endfunction
           
endclass