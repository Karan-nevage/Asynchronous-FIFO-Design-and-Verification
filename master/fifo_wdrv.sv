// File Name: /master/fifo_wdrv.sv
// Description: Defines the UVM driver class for asynchronous fifo operations.
//              Drives transaction from sequencer to the DUT via Write Interface.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//===================================================================================================================================================
class fifo_wdrv extends uvm_driver#(fifo_tx);
	virtual fifo_wintf wvif;								// Virtual Interface to connect DUT
	`uvm_component_utils(fifo_wdrv)							// Factory registration	
	`NEW_COMP												// NEW Constructor

	//---> Run Phase : Main driver loop to process transactions -------------------------------
	task run();
		uvm_resource_db#(virtual fifo_wintf)::read_by_name("W-GLOBAL","WPIF",wvif,this);		// Getting Handdle read by name
		wait(wvif.rst_i == 0);																// Wait for reset equals to zero
		forever begin
			seq_item_port.get_next_item(req);				// Request next transactions
			req.print();									// Print requested transactions
			drive_tx(req);									// Drive transactions
			seq_item_port.item_done();						// Signal Completion of transaction
		end
	endtask

	//---> Drive Task : Drive Write or Read Transactions Signal to the DUT ----------------------------------
	task drive_tx(fifo_tx tx);
		`uvm_info("WDRV", $sformatf("Driving write transaction with data: %0h", tx.wdata_i), UVM_HIGH)
		@(posedge wvif.wclk_i)
		wvif.wr_en_i = tx.wr_en_i;
		wvif.wdata_i = tx.wdata_i;
		`uvm_info("WDRV", "Write transaction driven.", UVM_HIGH)
	endtask


endclass

//==================================================================================================================================================
