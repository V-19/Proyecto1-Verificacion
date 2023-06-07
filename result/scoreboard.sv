class scoreboard;
  
//  int dfifo[$]; // data fifo
  int afifo[$]; // address  fifo
  int bfifo[$]; // Burst Length fifo
  
  int s_data[int];
  
  function new();
  endfunction
  
  function void write();
    input [31:0] data;
    input [31:0] address;
    begin
      s_data[address] = data; //guardar datos segun la dirección
      
    end
  endfunction
  
  function [31:0] read;
    input [31:0] address;
    reg [31:0] r_data;
    begin
      r_data = s_data[address];
      read = r_data;
    end
  endfunction
  
endclass