// File: /common/fifo_rintf.sv
// Description: Defines the Asynchronous FIFO interface for connecting the DUT to the UVM testbench.
//              Includes signal declarations and clocking blocks for driver, monitor.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//==================================================================================================================================================
//===================================================================================================================================================
//=========================|| Interface for async_fifo module ||=========================
	interface fifo_rintf(input logic rclk_i,rst_i);
		logic rd_en_i;
		logic [`WIDTH-1:0] rdata_o;
		logic empty_o;
		logic error_o;	
	endinterface

//===============================|| Clocking Blocks ||===================================
//
//===============|> Monitor Clocking Block <|===================
	clocking rd_mon_cb @(posedge rclk_i);
		default input #0;
		input rst_i,rd_en_i,rdata_i,empty_o,error_o;
	endclocking

//===============|> Driver Clocking block <|===================
	clocking rd_drv_cb @(posedge wclk_i);
		default input #0 output #0;
		input rst_i,empty_o,error_o;
		output rd_en_i,rdata_i;
	endclocking
//===================================================================================================================================================
