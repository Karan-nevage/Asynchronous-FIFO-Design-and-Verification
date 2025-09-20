// File Name: /top/top.sv
// Description: Top-level module for UVM verification of the fifo module.
//              Instantiates the DUT, interface, and sets up clock, reset, and simulation.
// Author: Karankumar Nevage | Email: karanpr9423@gmail.com
// Version: 0.1
//===================================================================================================================================================
module top;
    // ----> Signal declarations
	reg wclk;                              	// Clock signal
	reg rclk;                              	// Clock signal
    reg rst;                              	// Reset signal

    //-----> Instantiate Asynchrounous FIFO interface
	fifo_wintf wpif(wclk, rst);				// Write Interface Instantiation
	fifo_rintf rpif(rclk, rst);				// Read  Interface Instantiation

  	//=============================|| Instantiate DUT (FIFO RTL) ||=====================================
    async_fifo dut (
        .wclk_i(wpif.wclk_i),                // Connect w-clock
        .rclk_i(rpif.rclk_i),                // Connect r-clock
        .rst_i(rst),               			 // Connect reset
        .wr_en_i(wpif.wr_en_i),              // Connect write enable
        .rd_en_i(rpif.rd_en_i),              // Connect read enable
        .wdata_i(wpif.wdata_i),              // Connect wdata
        .rdata_o(rpif.rdata_o),              // Connect rdata
        .empty_o(rpif.empty_o),              // Connect empty
        .full_o(wpif.full_o),                // Connect full
        .error_o(wpif.error_o)               // Connect error
		);

	//=============================|| Clock Generation (wclk_i,rclk_i) ||=====================================
    //-----> Write Clock generation: 10ns period (5ns high, 5ns low) 100 Mhz
    initial begin
        wclk = 0;                          // Initialize clock
        forever #5 wclk = ~wclk;           // Toggle clock every 5 time units
    end

    //-----> Read Clock generation: 20ns period (10ns high, 10ns low) 50 MHz
    initial begin
        rclk = 0;                          // Initialize clock
        forever #10 rclk = ~rclk;          // Toggle clock every 5 time units
    end

	//=====================================|| Interface Registration ||=============================================
    //----> Write Interface Refistration
	initial begin
		uvm_resource_db#(virtual fifo_wintf)::set("W-GLOBAL","WPIF",wpif,null);
	end

    //----> read Interface Refistration
	initial begin
		uvm_resource_db#(virtual fifo_rintf)::set("R-GLOBAL","RPIF",rpif,null);
	end

	//============================|| Reset generation: Assert for 4 clock cycles ||==========================
    initial begin
        rst = 1'b1;                          	// Assert reset
		fork 
        	repeat(4) @(posedge wclk);      	// Hold for 4 clock cycles
			repeat(2) @(posedge rclk);			// Hold for 2 clock cycles
		join_any
        rst = 1'b0;                          	// Deassert reset
    end

    //=====================================|| UVM test execution ||==========================================
    initial begin
        run_test("");   // Run the specified UVM test
    end

    //=============================|| Waveform dump for debugging (Synopsys VCS) ||==========================
	initial begin
		$fsdbDumpfile("fifo_waveform.fsdb");	// Specify fsdb file for waveform
		$fsdbDumpvars;							// Dump all variables
	end

    //----> Waveform dump for debugging if QuestaSim being used <-----
    //	initial begin
    //    	$dumpfile("fifo_waveform.vcd");   // Specify VCD file for waveform
    //  	$dumpvars(0);                     // Dump all variables
    //	end
endmodule
//===================================================================================================================================================
