// File Name: /common/fifo_config.sv
// Description: Asynchronous FIFO design with separate read and write clocks, supporting configurable width and depth.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//===================================================================================================================================================

//======================================|| Defination for FIFO configuration ||==================================================

`define WIDTH   8                              		// Data width of the FIFO
`define DEPTH   16                              	// Depth of the FIFO
`define PTR_WIDTH   $clog2(`DEPTH)              	// Width of the pointers (log2(DEPTH))

//=========================================|| Defination for NEW constructor ||==================================================
//******** NEW Component
`define NEW_COMP	\
	function new(string name = "", uvm_component parent);	\
		super.new(name,parent);	\
	endfunction

//******** NEW Object
`define NEW_OBJ	\
	function new(string name = "");	\
		super.new(name);	\
	endfunction

//================================|| Defination for Multiple Multiple Read Write Tet ||===========================================
`define NUM_OF_TX 4 
//===================================================================================================================================================
