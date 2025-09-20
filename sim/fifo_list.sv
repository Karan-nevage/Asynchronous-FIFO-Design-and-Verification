// File: list.sv
// Description: Includes the UVM package and imports all its components.
//              Lists all project files for inclusion using a bottom-up approach.
//===================================================================================================================================================

//======================|} Import UVM Package {|======================
`include "uvm_pkg.sv"						// include uvm package
import uvm_pkg::*;							// import all things from package

//====================|} Include Project Files {|=====================
//      Lists all necessary UVM component files in bottom-up order
`include "fifo_config.sv"                  	// Common configuration definitions
`include "fifo_tx.sv"                      	// Transaction class for FIFO transactions
`include "fifo_wintf.sv"                   	// FIFO write interface definition
`include "fifo_rintf.sv"                   	// FIFO read interface definition
`include "fifo_wdrv.sv"                    	// Write driver component for fifo
`include "fifo_rdrv.sv"                    	// Read driver component for fifo
`include "asyn_fifo.v"                     	// FIFO Rtls Design
`include "fifo_wsqr.sv"                    	// Write Sequencer typedef for FIFO
`include "fifo_rsqr.sv"                    	// Read Sequencer typedef for FIFO
`include "fifo_mon.sv"                     	// Monitor component for FIFO
`include "fifo_cov.sv"                     	// Coverage component for FIFO
`include "fifo_sbd.sv"                     	// Scoreboard for transaction-level comparison
`include "fifo_wagent.sv"                  	// Write agent component
`include "fifo_ragent.sv"                  	// Read agent component
`include "fifo_env.sv"                     	// Environment component for AXI verification
`include "fifo_seq_lib.sv"                 	// Sequence library for FIFO tests
`include "fifo_test_lib.sv"                	// Test library for FIFO test cases
`include "fifo_top.sv"                     	// Top-level testbench module
//============================================================================================= 

//===================================================================================================================================================
