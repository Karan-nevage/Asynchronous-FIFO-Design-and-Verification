// File: /top/fifo_mon.sv
// Description: Defines the UVM Monitor class for asynchronous fifo verification.
//              Captures Write and Readd transaction and sends them to scoreboard
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//===================================================================================================================================================
class fifo_mon extends uvm_monitor;
	fifo_tx tx;												// Instantiate fifo transaction
	uvm_analysis_port #(fifo_tx) ap_port;					// Analysis port for sending tx to scoreboard
	virtual fifo_wintf wvif;								// Refrence to FIFO write interface
	virtual fifo_rintf rvif;								// Refrence to FIFO read interface
	`uvm_component_utils(fifo_mon)							// Registering to factory
	`NEW_COMP												// NEW Constructor

	//---> Build Function : Initialize analysis port and retrives the virtual interface -------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ap_port = new("ap_port",this);																	// Create analysis port
		if(!uvm_resource_db#(virtual fifo_wintf)::read_by_name("W-GLOBAL","WPIF",wvif,this)) begin		// Get virtual interface
			`uvm_fatal("MONITOR","Unable to get write virtual interface")								// for debug
		end
		else begin
			`uvm_info("MONITOR","Get write virtual interface",UVM_HIGH)									// for debug
		end
	
		if(!uvm_resource_db#(virtual fifo_rintf)::read_by_name("R-GLOBAL","RPIF",rvif,this)) begin		// Get Virtual interface
			`uvm_fatal("MONITOR","Unable to get read virtual interface")								// for debug
		end
		else begin
			`uvm_info("MONITOR","Get read virtual interface",UVM_HIGH)									// for debug
		end
	endfunction

	//---> Run Phase : Monitor fifo transactions -----------------------------------------------task run_phase(uvm_phase phase);
	task run();
		// Fork two separate processes to monitor both clock domains concurrently
		fork
			// Process to monitor write transactions
			forever begin
				@(posedge wvif.wclk_i);
				if (wvif.wr_en_i) begin
					fifo_tx write_tx;
					write_tx = fifo_tx::type_id::create("write_tx");
					write_tx.wdata_i = wvif.wdata_i;
					write_tx.wr_en_i = wvif.wr_en_i;
					write_tx.full_o = wvif.full_o;
					write_tx.error_o = wvif.error_o;
					ap_port.write(write_tx);
					`uvm_info("MONITOR", $sformatf("Monitored Write Transaction: %s", write_tx.sprint()), UVM_HIGH)
				end
			end
			
			// Process to monitor read transactions
			forever begin
				@(posedge rvif.rclk_i);
				if (rvif.rd_en_i) begin
					fifo_tx read_tx;
					read_tx = fifo_tx::type_id::create("read_tx");
					read_tx.rdata_i = rvif.rdata_o;
					read_tx.rd_en_i = rvif.rd_en_i;
					read_tx.empty_o = rvif.empty_o;
					read_tx.error_o = rvif.error_o;
					ap_port.write(read_tx);
					`uvm_info("MONITOR", $sformatf("Monitored Read Transaction: %s", read_tx.sprint()), UVM_HIGH)
				end
			end
		join_none
	endtask
endclass

//===================================================================================================================================================
