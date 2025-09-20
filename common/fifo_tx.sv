// File Name: common/fifo_tx.sv
// Description: Defines the UVM transaction class for asynchronous fifo operations.
//              Includes fields for address, data, burst parameters, and responses.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//===================================================================================================================================================

class fifo_tx extends uvm_sequence_item;
	
	//==========================|| Declaring & Randomizing Signals ||================================
		rand bit 				rst_i;		// Randomizing reset signal	
		rand bit 				wr_en_i;	// Randomizing write enable signal
		rand bit 			  	rd_en_i;	// Randomizing read enable signal
		rand bit [`WIDTH-1:0] 	wdata_i;	// Randomizing wdata signal
			 bit [`WIDTH-1:0] 	rdata_i;	// Declaring rdata signal
			 bit 				empty_o;	// Declaring empty signal
			 bit 				full_o;		// Declaring full signal
			 bit 				error_o;	// Declaring empty signal
	
	//==========================|| Signals Factory Registration||================================
		`uvm_object_utils_begin(fifo_tx)
			`uvm_field_int(rst_i,UVM_ALL_ON)
			`uvm_field_int(wr_en_i,UVM_ALL_ON)
			`uvm_field_int(rd_en_i,UVM_ALL_ON)
			`uvm_field_int(wdata_i,UVM_ALL_ON)
			`uvm_field_int(rdata_i,UVM_ALL_ON)
			`uvm_field_int(empty_o,UVM_ALL_ON)
			`uvm_field_int(full_o,UVM_ALL_ON)
			`uvm_field_int(error_o,UVM_ALL_ON)
		`uvm_object_utils_end	

	//==================================|| NEW Constructor ||===================================
		function new(string name = "fifo_tx");
				super.new(name);
		endfunction

	//====================================|| Constraints ||=====================================
		//---> burst size constraint

endclass


//===================================================================================================================================================
