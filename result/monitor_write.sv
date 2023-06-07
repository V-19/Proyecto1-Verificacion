class monitor_write;
  scoreboard sb;
  virtual intf_WB_G2 vir_intf_WB;
  virtual intf_SRAM_G2 vir_intf_SRAM;
          
  function new(virtual intf_WB_G2 vir_intf_WB,virtual intf_SRAM_G2 vir_intf_SRAM,scoreboard sb);
    this.vir_intf_WB = vir_intf_WB;
     this.vir_intf_SRAM=vir_intf_SRAM;
    this.sb = sb;
  endfunction
  
  
  int i,j;
  
  task check();

   forever
   begin
   
     
     @ (negedge vir_intf_WB.sys_clk);
	 
         
     if(vir_intf_WB.wb_stb_i== 1 && vir_intf_WB.wb_cyc_i ==1 && vir_intf_WB.wb_we_i== 1 && vir_intf_WB.wb_ack_o==1) 
      begin
        
        sb.write(vir_intf_WB.wb_dat_i, vir_intf_WB.wb_addr_i);
         	 ///sb.bfifo.push_back(vir_intf_WB.burst);//p
         	 ///sb.dfifo.push_back(vir_intf_WB.wb_dat_i);//p
       
          //$display("Guardado de datos fifo ");
          
          //end
      end
   end
     
  	endtask
endclass