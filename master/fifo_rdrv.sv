// File Name: /master/fifo_rdrv.sv
// Description: Defines the UVM driver class for asynchronous fifo operations.
//              Drives transaction from sequencer to the DUT via Read Interface.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//===================================================================================================================================================
class fifo_rdrv extends uvm_driver#(fifo_tx);
	virtual fifo_rintf rvif;								// Virtual Interface to connect DUT
	`uvm_component_utils(fifo_rdrv)							// Factory registration	
	`NEW_COMP												// NEW Constructor

	//---> Build Phase : Get virtual interface handle ----------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// Get virtual interface handle from the resource database
		if (!uvm_resource_db#(virtual fifo_rintf)::read_by_name("R-GLOBAL","RPIF",rvif,this)) begin
			`uvm_fatal("RDRV", "Could not get virtual interface handle for rvif")
		end
	endfunction

	//---> Run Phase : Main driver loop to process transactions -------------------------------
	task run();
		wait(rvif.rst_i == 0 );																	// Wait for reset equals to zero
		forever begin
			seq_item_port.get_next_item(req);				// Request next transactions
			req.print();									// Print requested transactions
			drive_tx(req);									// Drive transactions
			seq_item_port.item_done();						// Signal Completion of transaction
		end
	endtask

	//---> Drive Task : Drive Write or Read Transactions Signal to the DUT ----------------------------------
	task drive_tx(fifo_tx tx);
		`uvm_info("RDRV", "Driving read transaction", UVM_HIGH)
		@(posedge rvif.rclk_i)
		rvif.rd_en_i = tx.rd_en_i;												// Drive Read Enable Signal
		`uvm_info("RDRV", $sformatf("Read enable: %0h", tx.rd_en_i), UVM_HIGH) 	// For Debug	
	endtask

endclass



//===================================================================================================================================================
