// File: /top/fifo_cov.sv
// Description: Defines the UVM coverage subscriber for collecting fifo functional coverage.
//              Samples different signals from transactions.
//              Access coverage in Verdi using: verdi -cov -covdir simv.vdb & (use CTRL + Z if it stuck in terminal)
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//---------------------------------------------------------------------------------------------------------------------------------------------------
class fifo_cov extends uvm_subscriber#(fifo_tx);
	fifo_tx tx;												// Instantiat fifo transactions
	`uvm_component_utils(fifo_cov)							// Factory Regestring
	uvm_analysis_imp #(fifo_tx, fifo_cov) any_imp;	
	
	//---> New Constructor -------------------------------------------------------------------------------	
	function new(string name="", uvm_component parent);
        super.new(name, parent);
        any_imp = new("any_imp", this);
        fifo_cg = new();
    endfunction	

	//---> Covergroup for asynchronous fifo functional verification --------------------------------------
	covergroup fifo_cg;
		// Coverpoint for write enable and read enable
		WR_EN_CP : coverpoint tx.wr_en_i;
		RD_EN_CP : coverpoint tx.rd_en_i;

		// Cross coverage for write and read enables to ensure all combinations are hit
		WR_RD_CROSS : cross tx.wr_en_i, tx.rd_en_i;

		// Coverpoint for the data being written with targeted bins
		WDATA_CP : coverpoint tx.wdata_i {
			bins part_1 = {[0:63]};
			bins part_2 = {[64:127]};
			bins part_3 = {[128:191]};
			bins part_4 = {[192:255]};
		}
		
		// Coverpoint for the data being read with targeted bins
		RDATA_CP : coverpoint tx.rdata_i {
			bins part_1 = {[0:63]};
			bins part_2 = {[64:127]};
			bins part_3 = {[128:191]};
			bins part_4 = {[192:255]};
		}

		// Coverpoints for empty and full status signals
		EMPTY_CP : coverpoint tx.empty_o;
		FULL_CP : coverpoint tx.full_o;

		// Cross coverage for empty and full signals to ensure all combinations are hit
		EMPTY_FULL_CROSS : cross tx.empty_o, tx.full_o;
		
		// Cross coverage for error signal
		ERROR_CP : coverpoint tx.error_o;
		
	endgroup

	function void write(fifo_tx t);
		$cast(tx,t);				// cast input tx to local tx
		fifo_cg.sample();			// sample covergroup
	endfunction
endclass
//===================================================================================================================================================
