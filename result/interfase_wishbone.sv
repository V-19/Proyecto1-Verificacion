

interface intf_WB_G2();
  
  
  
parameter      APP_AW   = 26;  // Application Address Width
//parameter      APP_DW   = 32;  // Application Data Width 
//parameter      APP_BW   = 4;   // Application Byte Width
//parameter      APP_RW   = 9;   // Application Request Width
 
//parameter      SDR_DW   = 16;  // SDR Data Width 
//parameter      SDR_BW   = 2;   // SDR Byte Width
 
parameter      dw       = 32;  // data width
//parameter      tw       = 8;   // tag id width
parameter      bl       = 9;   // burst_lenght_width 
  
//--------------------------------------
// Wish Bone Interface
// -------------------------------------      
  
logic                   wb_rst_i           ;
logic                   wb_clk_i           ;
logic                   wb_stb_i           ;
logic                  wb_ack_o           ;
logic [APP_AW-1:0]            wb_addr_i          ;
logic                   wb_we_i            ; // 1 - Write, 0 - Read
logic [dw-1:0]          wb_dat_i           ;
logic [dw/8-1:0]        wb_sel_i           ; // Byte enable
logic [dw-1:0]         wb_dat_o           ;
logic                   wb_cyc_i           ;
logic  [2:0]            wb_cti_i           ;
  
//------------------------------------------------
// Configuration Parameter
//------------------------------------------------
logic                  sdr_init_done       ; // Indicate SDRAM Initialisation Done
logic [3:0] 		cfg_sdr_tras_d      ; // Active to precharge delay
logic [3:0]             cfg_sdr_trp_d       ; // Precharge to active delay
logic [3:0]             cfg_sdr_trcd_d      ; // Active to R/W delay
logic 			cfg_sdr_en          ; // Enable SDRAM controller
logic [1:0] 		cfg_req_depth       ; // Maximum Request accepted by SDRAM controller
logic [12:0] 		cfg_sdr_mode_reg    ;
logic [2:0] 		cfg_sdr_cas         ; // SDRAM CAS Latency
logic [3:0] 		cfg_sdr_trcar_d     ; // Auto-refresh period
logic [3:0]             cfg_sdr_twr_d       ; // Write recovery delay
logic [`SDR_RFSH_TIMER_W-1 : 0] cfg_sdr_rfsh;
logic [`SDR_RFSH_ROW_CNT_W -1 : 0] cfg_sdr_rfmax;  

//--------------------------------------------
// Important signals
//--------------------------------------------  
//logic [31:0] read_data;
logic [31:0] ErrCnt;
logic            RESETN;
logic           sys_clk;
logic           sdram_clk;
logic [7:0]  burst;
 
  
endinterface