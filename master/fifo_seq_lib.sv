// File Name: master/fifo_seq.sv
// Description: Defines sequence classes for asynchronous fifo.
//              Includes base sequence and specific sequences for various test scenarios.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//==================================================================================================================================================

//******************************************************************************************************
//             							FIFO BASE SEQUENCE
//******************************************************************************************************
class fifo_base_seq extends uvm_sequence#(fifo_tx);
	fifo_tx tx;									// Transaction instance
	uvm_phase phase;							// Phase refrence
	`uvm_object_utils(fifo_base_seq)			// Register with UVM Factory
	`NEW_OBJ									// NEW Constructor

	//---> Pre Body Task : Raising Objections --------------------------------------------------------------------------
	task pre_body();
		phase = get_starting_phase();								// Get run phase of sequencer
		if (phase != null) begin									// Check the availability of phase
			phase.raise_objection(this);							// Rise the objection
			phase.phase_done.set_drain_time(this,150);				// Set drain time
		end
		else begin													 // for phase not availaible
			`uvm_info("BASE_SEQ","Phase Is not available", UVM_NONE) // For Debugging
		end
	endtask
	
	//---> Pre Body Task : Raising Objections --------------------------------------------------------------------------
	task post_body();
		if (phase != null) begin										// Check the availaiblity of phase
			phase.drop_objection(this);									// Drop objection
		end
	endtask
endclass
//======================================================================================================


//======================================================================================================
//******************************************************************************************************
//             							FIFO Write Read SEQUENCE
//******************************************************************************************************
class wr_rd_seq extends fifo_base_seq;
	`uvm_object_utils(wr_rd_seq)										// Factory Registration
	`NEW_OBJ															// New Constructor

	//----> Task Body : Task for Generating write read sequence ----------------------
	task body();
    
   		`uvm_do_with(tx, {
      		tx.wr_en_i == 1'b1; 							// Assert the write enable signal
   			 })
    
    	`uvm_do_with(tx, {
      		tx.rd_en_i == 1'b1; 							// Assert the read enable signal
    		})		
	endtask
endclass
//======================================================================================================


//======================================================================================================
//******************************************************************************************************
//             							FIFO N Write Read SEQUENCE
//******************************************************************************************************
class fifo_n_wr_rd_seq extends fifo_base_seq;
	`uvm_object_utils(fifo_n_wr_rd_seq)
	`NEW_OBJ

	task body();
		`uvm_info("N_WR_RD_SEQ", $sformatf("Starting %0d write/read transactions...", `NUM_OF_TX), UVM_LOW);


		// Fork the write and read tasks to run concurrently
		fork
			// Write task
			begin
				fifo_tx write_tx; // Local transaction object for the write task
				for (int i = 0; i < `NUM_OF_TX; i++) begin
					`uvm_do_with(write_tx, {
						write_tx.wr_en_i == 1'b1;
						write_tx.rd_en_i == 1'b0;
					})
				end
			end

			// Read task
			begin
				fifo_tx read_tx; // Local transaction object for the read task
				for (int i = 0; i < `NUM_OF_TX; i++) begin
					`uvm_do_with(read_tx, {
						read_tx.wr_en_i == 1'b0;
						read_tx.rd_en_i == 1'b1;
					})
				end
			end
		join

		`uvm_info(get_type_name(), "All transactions completed.", UVM_LOW);
	endtask
endclass


//================================================================================================
//             				FIFO FULL & EMPTY SEQUENCES
//================================================================================================
class fifo_full_then_empty_seq extends fifo_base_seq;
    `uvm_object_utils(fifo_full_then_empty_seq)
    `NEW_OBJ

    parameter NUM_WR_TX = `DEPTH;
    parameter NUM_RD_TX = `DEPTH;

    task body();
        `uvm_info(get_type_name(), $sformatf("Filling the FIFO with %0d transactions.", NUM_WR_TX), UVM_LOW);

        // Fill the FIFO
        for (int i = 0; i < NUM_WR_TX; i++) begin
            `uvm_do_with(tx, {tx.wr_en_i == 1'b1; tx.rd_en_i == 1'b0;})
        end
		#20;
        // Drain the FIFO
        for (int i = 0; i < NUM_RD_TX; i++) begin
            `uvm_do_with(tx, {tx.wr_en_i == 1'b0; tx.rd_en_i == 1'b1;})
        end

    endtask
endclass

//================================================================================================
//             				FIFO OVERFLOW & UNDERFLOW SEQUENCES
//================================================================================================
class fifo_overflow_seq extends fifo_base_seq;
    `uvm_object_utils(fifo_overflow_seq)
    `NEW_OBJ

    parameter NUM_TX = `DEPTH + 2;

    task body();

        // Attempt to write more data than the FIFO can hold
        for (int i = 0; i < NUM_TX; i++) begin
            `uvm_do_with(tx, {tx.wr_en_i == 1'b1; tx.rd_en_i == 1'b0;})
        end
    endtask
endclass
//***********************************************************************************
class fifo_underflow_seq extends fifo_base_seq;
    `uvm_object_utils(fifo_underflow_seq)
    `NEW_OBJ

    parameter NUM_TX = `DEPTH + 2;

    task body();
        `uvm_info(get_type_name(), $sformatf("Attempting to underflow FIFO with %0d read transactions.", NUM_TX), UVM_LOW);

        // Fill the FIFO first
        for (int i = 0; i < `DEPTH; i++) begin
             `uvm_do_with(tx, {tx.wr_en_i == 1'b1; tx.rd_en_i == 1'b0;})
        end
        
        // Now, read more data than the FIFO holds
        for (int i = 0; i < NUM_TX; i++) begin
            `uvm_do_with(tx, {tx.wr_en_i == 1'b0; tx.rd_en_i == 1'b1;})
        end
    endtask
endclass



//==================================================================================================================================================

