// File: /common/fifo_wintf.sv
// Description: Defines the Asynchronous FIFO interface for connecting the DUT to the UVM testbench.
//              Includes signal declarations and clocking blocks for driver, monitor.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//==================================================================================================================================================
//===================================================================================================================================================
//=========================|| Interface for async_fifo module ||=========================
	interface fifo_wintf(input logic wclk_i,rst_i);
		logic wr_en_i;
		logic [`WIDTH-1:0] wdata_i;
		logic full_o;
		logic error_o;	
	endinterface

//===============================|| Clocking Blocks ||===================================
//
//===============|> Monitor Clocking Block <|===================
	clocking wr_mon_cb @(posedge wclk_i);
		default input #0;
		input rst_i,wr_en_i,wdata_i,full_o,error_o;
	endclocking
	
//===============|> Driver Clocking block <|===================
	clocking wr_drv_cb @(posedge wclk_i);
		default input #0 output #0;
		input rst_i,full_o,error_o;
		output wr_en_i,wdata_i;
	endclocking

//===================================================================================================================================================
