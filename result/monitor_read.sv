class monitor_read;
  scoreboard sb;
  virtual intf_WB_G2 vir_intf_WB;
  virtual intf_SRAM_G2 vir_intf_SRAM;
          
  function new(virtual intf_WB_G2 vir_intf_WB,virtual intf_SRAM_G2 vir_intf_SRAM ,scoreboard sb);
    this.vir_intf_WB = vir_intf_WB;
    this.vir_intf_SRAM=vir_intf_SRAM;
    this.sb = sb;
  endfunction
  
  
  int i;
  
  task check();
    
    
    reg [31:0]exp_data;
    reg [7:0] bl;
    reg [12:0]address;
      
  
    
    forever
        
      begin
         
        @ (posedge vir_intf_WB.sdram_clk);

        if(vir_intf_SRAM.sdr_ras_n== 1 && vir_intf_SRAM.sdr_cas_n ==0 && vir_intf_SRAM.sdr_we_n== 1) begin
         
        
      	  address={5'h0,vir_intf_WB.wb_addr_i[7:0]};
          exp_data = sb.read(vir_intf_WB.wb_addr_i);
 
           do begin
             @ (posedge vir_intf_WB.sys_clk);
          end while(vir_intf_SRAM.sdr_cas_n == 1'b1);
              
              if(vir_intf_SRAM.sdr_addr !== address) begin
                $display("Address Error: Addr: %x RAddr: %x",vir_intf_SRAM.sdr_addr,address);
             	vir_intf_WB.ErrCnt = vir_intf_WB.ErrCnt+1;
          	end else begin
              $display("Address: Addr: %x ",vir_intf_SRAM.sdr_addr);
            end
          
          repeat (3) begin
  			@(posedge vir_intf_WB.sdram_clk);
		  end
          
          if(vir_intf_SRAM.Dq !== exp_data) begin
           			$display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",vir_intf_WB.burst,address,vir_intf_SRAM.Dq, exp_data);
             	vir_intf_WB.ErrCnt = vir_intf_WB.ErrCnt+1;
          	end else begin
           			$display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",vir_intf_WB.burst,address,vir_intf_SRAM.Dq);
            end
         
          

          /*    
          do begin
             @ (posedge vir_intf_WB.sys_clk);
          end while(vir_intf_WB.wb_ack_o == 1'b0);
          
            if(vir_intf_WB.wb_dat_o !== exp_data) begin
           			$display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",vir_intf_WB.burst,address,vir_intf_WB.wb_dat_o, exp_data);
             	vir_intf_WB.ErrCnt = vir_intf_WB.ErrCnt+1;
          	end else begin
           			$display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",vir_intf_WB.burst,address,vir_intf_WB.wb_dat_o);
              
            end*/
           //$display("Expect data %x",exp_data);
           
          end //if
        //end//for
      end//forever
      
      
   
  
  	endtask
endclass
