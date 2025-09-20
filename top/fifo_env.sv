// File: /top/fifo_env.sv
// Description: Defines UVM envoirment class for asyn_fifo.
//              Integrates write/read agent, scoreboard, coverage components .
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//===================================================================================================================================================
class fifo_env extends uvm_env;

	fifo_wagent wagent;							// Write Agent Instance
	fifo_ragent ragent;							// Read Agent Instance
	fifo_mon mon;								// Monitor Instance
	fifo_sbd sbd;								// scoreboard Instance for TX Comparison
	fifo_cov cov; 								// Coverage Instance for Reporting
	`uvm_component_utils(fifo_env)				// Register with UVM factory 
	`NEW_COMP									// NEW Constructor

	//---> Build Phase ----------------------------------------------------
	// Creates wagent, ragent, scorboard and coverage instance
	function void build();
		`uvm_info("ENV","Bulid Phase Hitted", UVM_HIGH)			// for debugging
		wagent = fifo_wagent::type_id::create("wagent",this);	// Instantiate write agent
		ragent = fifo_ragent::type_id::create("ragent",this);	// Instantiate read agent
		mon    = fifo_mon::type_id::create("mon",this);			// Instantiate monitor
		sbd    = fifo_sbd::type_id::create("sbd",this);			// Instantiate Scoreboard
		cov	   = fifo_cov::type_id::create("cov",this);			// Instantiate Coverage
	endfunction

	//---> Connect Phase ----------------------------------------------------
	// Connects monitor analysis port to scoreboard & coverage analysis implementation
	function void connect();
		`uvm_info("ENV","Connect Phase Hitted", UVM_HIGH)			// for debugging
        //--->> Connect monitor analysis port to the scoreboard analysis imp
  		mon.ap_port.connect(sbd.analysis_imp);

        //--->> Connect monitor analysis port to the coverage analysis imp
        mon.ap_port.connect(cov.any_imp);
	endfunction

endclass
//===================================================================================================================================================
