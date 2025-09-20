// File: /top/fifo_sbd.sv
// Description: Defines the UVM scoreboard class for asynchronous fifo verification.
//              Tracks matches and mismatches for transaction-level comparisons.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//===================================================================================================================================================
class fifo_sbd extends uvm_scoreboard;
	`uvm_component_utils(fifo_sbd)							// Factory Registration
	`NEW_COMP 												// NEW Constructor
	uvm_analysis_imp #(fifo_tx,fifo_sbd) analysis_imp;		// Declare and create analysis imp

	fifo_tx wr_queue[$];
	int match_count;
	int mismatch_count;

	//---> Build Phase : Allocate memoryfor analysis implement ------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		analysis_imp = new ("analysis_imp", this);			// allocate memory to analysis imp
	endfunction

    function void write(fifo_tx tr);
		fifo_tx sbd_tx;
		$cast(sbd_tx,tr.clone()); //clone the transaction
		
		// If transaction is a write, push to queue
		if(sbd_tx.wr_en_i == 1) begin
			`uvm_info("SBD", "Write transaction received, pushing to queue.", UVM_HIGH)
			wr_queue.push_back(sbd_tx);
		end
	
		// If transaction is a read, pop from queue and compare
		if(sbd_tx.rd_en_i == 1) begin
			fifo_tx expected_tx;
			if(wr_queue.size() > 0) begin
				expected_tx = wr_queue.pop_front();
				`uvm_info("SBD", "Read transaction received, comparing with expected.", UVM_HIGH)
				if(sbd_tx.rdata_i == expected_tx.wdata_i) begin
					match_count++;
					`uvm_info("SBD", $sformatf("MATCH: Read data matches written data. Read: %0h, Expected: %0h", sbd_tx.rdata_i, expected_tx.wdata_i), UVM_HIGH)
				end 
				else begin
					mismatch_count++;
					`uvm_info("SBD", $sformatf("MISMATCH: Read data does not match written data. Read: %0h, Expected: %0h", sbd_tx.rdata_i, expected_tx.wdata_i), UVM_HIGH)
				end
			end 
			else begin
				`uvm_info("SBD", "====> Read transaction received but write queue is empty. Possible underflow.", UVM_NONE)
			end
		end
	endfunction

	//---> Report Phase : Display test result ------------------------------------------
	function void report_phase(uvm_phase phase);
		`uvm_info("SBD","//===============================================//", UVM_NONE)
		`uvm_info("SBD", $sformatf("====| Test Results: %0d matches, %0d mismatches.|====", match_count, mismatch_count), UVM_NONE)
		`uvm_info("SBD","//===============================================//", UVM_NONE)
		if(mismatch_count > 0) begin
			`uvm_fatal("TEST FAILED", "Mismatches detected in scoreboard.")
		end
	endfunction
endclass
//===================================================================================================================================================
