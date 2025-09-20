// File: /top/fifo_test_lib.sv
// Description: Defines UVM test classes for verifying the asyn_fifo module.
//              Includes base test and derived functional tests for various scenarios.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//===================================================================================================================================================

//******************************************************************************************************
//											FIFO Base Test
//******************************************************************************************************
class fifo_base_test extends uvm_test;
	uvm_factory factory;						// Get factory instance
	fifo_env env;								// Envoirment Instance
	`uvm_component_utils(fifo_base_test)		// Register to UVM factory
	`NEW_COMP									// NEW Constructor

	//---> Build Phase : Create envoirment ---------------------------------------------
	function void build();
		`uvm_info("TEST_LIB","Hitted build phase",UVM_HIGH)		// For debugging
		env = fifo_env::type_id::create("env",this);			// env factory Creation
	endfunction

	//---> End of Elaboration Phase : Print topology and factory -----------------------
	function void end_of_elaboration();
		`uvm_info("TEST_LIB", "Hitted EOElaboration phase",UVM_HIGH)
		factory=uvm_factory::get();							// Get factory instance
		factory.print();									// Print factory overrides
		uvm_top.print_topology();							// Print topology
	endfunction

	//---> Report Phase : Display test result ------------------------------------------
	//function void report();
	//		$display("*********** Test Passed Succesfully ************");
	//endfunction
	//
endclass
//======================================================================================================


//======================================================================================================
//******************************************************************************************************
//										Write Read Test (Single)
//******************************************************************************************************
class wr_rd_test extends fifo_base_test;
	wr_rd_seq seq;															// Sequence Instantiation
	`uvm_component_utils(wr_rd_test)										// Register to factory
	`NEW_COMP																// New Constructor

	//----> Build Phase : Allocate memory to the sequence ---------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = new("seq");			
	endfunction

	//----> Run Task : Execute write read sequence ----------------------------------
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);										// Raise Objection
		phase.phase_done.set_drain_time(this,40);							// Set 40ns Drain Time
		seq.start(env.wagent.wsqr);											// Start write sequencer
		seq.start(env.ragent.rsqr);											// Start Read Sequencer
		phase.drop_objection(this);											// Drop Objection
	endtask
endclass


//======================================================================================================


//======================================================================================================
//******************************************************************************************************
//									N Write Read Test (Multiple)
//******************************************************************************************************
class fifo_n_wr_rd_test extends fifo_base_test;
	fifo_n_wr_rd_seq seq;															// Sequence Instantiation
	`uvm_component_utils(fifo_n_wr_rd_test)											// Register to factory
	`NEW_COMP																		// New Constructor

	//----> Build Phase : Allocate memory to the sequence ---------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = new("seq");			
	endfunction

	//----> Run Task : Execute write read sequence ----------------------------------
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);										// Raise Objection
		phase.phase_done.set_drain_time(this,40);							// Set 40ns Drain Time
		seq.start(env.wagent.wsqr);											// Start write sequencer
		seq.start(env.ragent.rsqr);											// Start Read Sequencer
		phase.drop_objection(this);											// Drop Objection
	endtask
endclass


//======================================================================================================
//======================================================================================================
//******************************************************************************************************
//									FIFO FULL and EMPTY TEST
//******************************************************************************************************
class fifo_full_then_empty_test extends fifo_base_test;
	fifo_full_then_empty_seq seq;											// Sequence Instantiation
	`uvm_component_utils(fifo_full_then_empty_test)							// Register to factory
	`NEW_COMP																// New Constructor

	//----> Build Phase : Allocate memory to the sequence ---------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = new("seq");			
	endfunction

	//----> Run Task : Execute write read sequence ----------------------------------
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);										// Raise Objection
		phase.phase_done.set_drain_time(this,40);							// Set 40ns Drain Time
		seq.start(env.wagent.wsqr);											// Start write sequencer
		seq.start(env.ragent.rsqr);											// Start Read Sequencer
		phase.drop_objection(this);											// Drop Objection
	endtask
endclass


//======================================================================================================


//======================================================================================================
//******************************************************************************************************
//											FIFO OVERFLOW
//******************************************************************************************************
class fifo_overflow_test extends fifo_base_test;
	fifo_overflow_seq seq;															// Sequence Instantiation
	`uvm_component_utils(fifo_overflow_test)											// Register to factory
	`NEW_COMP																		// New Constructor

	//----> Build Phase : Allocate memory to the sequence ---------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = new("seq");			
	endfunction

	//----> Run Task : Execute write read sequence ----------------------------------
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);										// Raise Objection
		phase.phase_done.set_drain_time(this,40);							// Set 40ns Drain Time
		seq.start(env.wagent.wsqr);											// Start write sequencer
		seq.start(env.ragent.rsqr);											// Start Read Sequencer
		phase.drop_objection(this);											// Drop Objection
	endtask
endclass
//======================================================================================================


//======================================================================================================
//******************************************************************************************************
//											FIFO UNDERFLOW
//******************************************************************************************************
class fifo_underflow_test extends fifo_base_test;
	fifo_underflow_seq seq;															// Sequence Instantiation
	`uvm_component_utils(fifo_underflow_test)										// Register to factory
	`NEW_COMP																		// New Constructor

	//----> Build Phase : Allocate memory to the sequence ---------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = new("seq");			
	endfunction

	//----> Run Task : Execute write read sequence ----------------------------------
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);										// Raise Objection
		phase.phase_done.set_drain_time(this,40);							// Set 40ns Drain Time
		seq.start(env.wagent.wsqr);											// Start write sequencer
		seq.start(env.ragent.rsqr);											// Start Read Sequencer
		phase.drop_objection(this);											// Drop Objection
	endtask
endclass


//======================================================================================================
//===================================================================================================================================================
