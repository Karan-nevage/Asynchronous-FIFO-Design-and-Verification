// File: /master/fifo_wagent.sv
// Description: Defines the UVM write agent class for asynchronous fifo verification.
//              Integrates driver & sequence components.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//==================================================================================================================================================

class fifo_wagent extends uvm_agent;
	fifo_wdrv wdrv;										// Instantiate Write driver
	fifo_wsqr wsqr;										// Instantiate Write sequencer 
	`uvm_component_utils(fifo_wagent)					// Register with UVM factory
	`NEW_COMP											// New Constructor

	//---> Build Phase : Create Components ----------------------------------------------------------
	function void build();
		`uvm_info("WAGENT","Build Phase Hitted", UVM_HIGH)		// For Debug
		wdrv = fifo_wdrv::type_id::create("wdrv", this);		// Create write driver
		wsqr = fifo_wsqr::type_id::create("wsqr", this);		// Create write sequencer
	endfunction
	
	//---> Connect Phase : Connect Components parts ------------------------------------------------------
	function void connect();
		`uvm_info("WAGENT","Connect Phase Hitted", UVM_HIGH)		// For Debug
		// Connect drivers sequence item port to sequencer export
		wdrv.seq_item_port.connect(wsqr.seq_item_export);
	endfunction	

endclass	
//==================================================================================================================================================
