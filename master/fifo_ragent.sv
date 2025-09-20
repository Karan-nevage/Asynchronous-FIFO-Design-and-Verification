// File: /master/fifo_ragent.sv
// Description: Defines the UVM read agent class for asynchronous fifo verification.
//              Integrates driver & sequencer components.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//==================================================================================================================================================

class fifo_ragent extends uvm_agent;
	fifo_rdrv rdrv;										// Instantiat read driver
	fifo_rsqr rsqr;										// Instantiate read sequencer 
	`uvm_component_utils(fifo_ragent)					// Register with UVM factory
	`NEW_COMP											// New Constructor

	//---> Build Phase : Create Components ----------------------------------------------------------
	function void build();
		`uvm_info("RAGENT","Build Phase Hitted", UVM_HIGH)		// For Debug
		rdrv = fifo_rdrv::type_id::create("rdrv", this);		// Create read driver
		rsqr = fifo_rsqr::type_id::create("rsqr", this);		// Create read sequencer
	endfunction
	
	//---> Connect Phase : Connect Components parts ------------------------------------------------------
	function void connect();
		`uvm_info("RAGENT","Connect Phase Hitted", UVM_HIGH)		// For Debug
		// Connect drivers sequence item port to sequencer export
		rdrv.seq_item_port.connect(rsqr.seq_item_export);
	endfunction	

endclass	
//==================================================================================================================================================
