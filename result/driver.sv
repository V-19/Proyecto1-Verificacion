class driver;
  
  stimulus sti;
  scoreboard sb;
  
  virtual intf_WB_G2 vir_intf_WB;
  virtual intf_SRAM_G2 vir_intf_SRAM;
  
  function new(virtual intf_WB_G2 vir_intf_WB,virtual intf_SRAM_G2 vir_intf_SRAM ,scoreboard sb);
    this.vir_intf_WB = vir_intf_WB;
    this.vir_intf_SRAM=vir_intf_SRAM;
    this.sb = sb;
  endfunction
  
  
  
  task reset();  
    
    vir_intf_WB.ErrCnt          = 0;
    vir_intf_WB.wb_addr_i      = 0;
    vir_intf_WB.wb_dat_i      = 0;
    vir_intf_WB.wb_sel_i       = 4'h0;
    vir_intf_WB.wb_we_i        = 0;
    vir_intf_WB.wb_stb_i       = 0;
    vir_intf_WB.wb_cyc_i       = 0;

  	vir_intf_WB.RESETN    = 1'h1;

 	#100
  	// Applying reset
  	vir_intf_WB.RESETN    = 1'h0;
  	#10000;
  	// Releasing reset
  	vir_intf_WB.RESETN    = 1'h1;
  endtask
        
  
  task burst_write;
	//input [31:0] Address;
	input [7:0]  bl;
    reg [31:0] address;
	int i;
	begin
      
  	
      sti = new();
      	
      vir_intf_WB.burst=bl;
      
        sb.bfifo.push_back(bl); 

        if(sti.randomize()) 
        address = sti.value2; // Drive to DUT
            
		sb.afifo.push_back(address);
      
     	@ (negedge vir_intf_WB.sys_clk)
     
      //$display("Write Address: %x, Burst Size: %d",address,vir_intf_WB.burst);  
      
      for(i=0; i < bl; i++) begin
      vir_intf_WB.wb_stb_i        = 1;
      vir_intf_WB.wb_cyc_i        = 1;
      vir_intf_WB.wb_we_i         = 1;
      vir_intf_WB.wb_sel_i        = 4'b1111;
      vir_intf_WB.wb_addr_i       = {address[31:2]+i,2'b00};
      if(sti.randomize()) 
        vir_intf_WB.wb_dat_i = sti.value; // Drive to DUT
	
      do begin
          @ (posedge vir_intf_WB.sys_clk);
      end while(vir_intf_WB.wb_ack_o == 1'b0);
          @ (negedge vir_intf_WB.sys_clk);
   		$display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,vir_intf_WB.wb_addr_i,vir_intf_WB.wb_dat_i);
   end
      
   	 vir_intf_WB.wb_stb_i        = 0;
   	 vir_intf_WB.wb_cyc_i        = 0;
     vir_intf_WB.wb_we_i         = 'hx;
     vir_intf_WB.wb_sel_i        = 'hx;
     vir_intf_WB.wb_addr_i       = 'hx;
     vir_intf_WB.wb_dat_i        = 'hx;

end
   
endtask


  
  task burst_read;
    // reg [7:0]  bl;
    reg [31:0] address;
	int j;
	input [7:0]  bl;
    
    
	begin
      
        
      	//bl      = sb.bfifo.pop_front(); 
   		address = sb.afifo.pop_front(); 
        //vir_intf_WB.burst      =  sb.bfifo.pop_front(); //p
      
   		@ (negedge vir_intf_WB.sys_clk);
      
       for(j=0; j < bl; j++) begin
         vir_intf_WB.wb_stb_i        = 1;
         vir_intf_WB.wb_cyc_i        = 1;
         vir_intf_WB.wb_we_i         = 0;
         vir_intf_WB.wb_addr_i       = {address[31:2]+j,2'b00};
         
         do begin
             @ (posedge vir_intf_WB.sys_clk);
         end while(vir_intf_WB.wb_ack_o == 1'b0);
         
         //$display("Address: %d Addr:",vir_intf_WB.wb_addr_i);
         
         @ (negedge vir_intf_WB.sdram_clk);
          //vir_intf_WB.address =  sb.afifo.pop_front(); //p 
       end
          //vir_intf_WB.exp_data        = sb.dfifo.pop_front();//p // Exptected Read Data
      vir_intf_WB.wb_stb_i        = 0;
   	  vir_intf_WB.wb_cyc_i        = 0;
      vir_intf_WB.wb_we_i         = 'hx;
      vir_intf_WB.wb_addr_i       = 'hx;
    
 
      end
  
endtask
    
    
endclass